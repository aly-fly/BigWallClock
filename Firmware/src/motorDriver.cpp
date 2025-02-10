#include <Arduino.h>
#include <Ponoor_PowerSTEP01Library.h>
#include <SPI.h>
#include "__CONFIG.h"
#include "motorDriver.h"


SPIClass myVSPI (VSPI);

// powerSTEP library instance, parameters are distance from the end of a daisy-chain
// of drivers, !CS pin, !STBY/!Reset pin, !Busy pin (optional)
powerSTEP driver(0, VSPI_nCS, nSTBY_nRESET_PIN);  // Busy not configured -> reads from the register over SPI
//powerSTEP driver(0, VSPI_nCS, nSTBY_nRESET_PIN, nBUSY_PIN);

bool HiPowerMode;

bool MotorInit() 
{
  bool result = false;
  Serial.println("powerSTEP01 control initialising...");

  // Library does not initialize pins - let's do it here.
  pinMode(nSTBY_nRESET_PIN, OUTPUT);
  //pinMode(nBUSY_PIN, INPUT);  
  pinMode(VSPI_nCS, OUTPUT);


  // Reset powerSTEP and set CS
  digitalWrite(VSPI_nCS, HIGH);
  digitalWrite(nSTBY_nRESET_PIN, HIGH);
  delay(50);
  digitalWrite(nSTBY_nRESET_PIN, LOW);
  delay(50);
  digitalWrite(nSTBY_nRESET_PIN, HIGH);

  // Start SPI
  myVSPI.begin(VSPI_SCK, VSPI_MISO, VSPI_MOSI, VSPI_nCS);
  myVSPI.setFrequency(100000); // 100 kHz
  myVSPI.setDataMode(SPI_MODE3); // configure CPOL and CPHA

  // Configure powerSTEP
  driver.SPIPortConnect(&myVSPI); // give library the SPI port

  Serial.println("Testing comm...");
  Serial.printf("Status = 0x%4X\n", driver.getStatus());

  byte bOCT = driver.getOCThreshold();
  Serial.printf("OC Threshold = %d (must be 8 after reset)\n", bOCT);
  if (bOCT == 8)  // must be 8 after reset
  {
    Serial.println("Communication is ok.");
    result = true;
  }
  else
  {
    Serial.println("Communication is NOT GOOD!!");
    result = false;
  }

  // Programmable UVLO thresholds
  unsigned long configVal = driver.getParam(CONFIG);
  // This bit is CONFIG 8, mask is 0x0100
  configVal &= ~(0x0100); // reset the bit for low voltage operation
  driver.setParam(CONFIG, configVal);


  driver.configSyncPin(BUSY_PIN, 0); // use SYNC/nBUSY pin as nBUSY, 
                                     // thus syncSteps (2nd paramater) does nothing
                                     
  driver.setFullSpeed(1500); // full steps/s threshold for disabling microstepping
  
  driver.setSlewRate(SR_220V_us); // faster may give more torque (but also EM noise),
                                  // options are: 114, 220, 400, 520, 790, 980(V/us)
                                  
  driver.setOCThreshold(OVERCURRENT_LVL);// over-current threshold. Value 0 to 31. Low = sensitive; High = Powerful.
                            // If your motor stops working for no apparent reason, it's probably this. 
                            // Can prevent catastrophic failures caused by shorts.

  driver.setOCShutdown(OC_SD_ENABLE); // shutdown motor bridge on over-current event
                                      // to protect against permanant damage
  
  driver.setVoltageStallThreshold(STALL_LVL); // detecting that motor is skipping steps (in voltage mode)

//  driver.setPWMFreq(PWM_DIV_1, PWM_MUL_0_75); // 16MHz*0.75/(512*1) = 23.4375kHz 
                            // power is supplied to stepper phases as a sin wave,  
                            // frequency is set by two PWM modulators,
                            // Fpwm = Fosc*m/(512*N), N and m are set by DIV and MUL,
                            // options: DIV: 1, 2, 3, 4, 5, 6, 7, 
                            // MUL: 0.625, 0.75, 0.875, 1, 1.25, 1.5, 1.75, 2
                            
  driver.setVoltageComp(VS_COMP_DISABLE); // no compensation for variation in Vs as
                                          // ADC voltage divider is not populated
                                          
  driver.setSwitchMode(SW_USER); // switch doesn't trigger stop, status can be read.
                                 // SW_HARD_STOP: TP1 causes hard stop on connection 
                                 // to GND, you get stuck on switch after homing
                                      
  driver.setOscMode(INT_16MHZ); // 16MHz internal oscillator as clock source


/*

function TStSpin.Set_HoldCurrent(StNaprave: Cardinal; Value: Double): Double;  // Peak tok. Tok je v mA, vrne nastavljen tok
var
  R: Double;
  Kv: Integer;
begin
  if VoltMode(StNaprave) then
  begin
    R := MotorData[StNaprave].Resistance+ Rs;
    Kv := Round(Value*256*R/1000/Vbus);
    if Kv < 0 then Kv := 0;
    if Kv > 255 then Kv := 255;
    Kv := SetParam(StNaprave, $09, Kv);
    Result := Kv*1000/256/R*Vbus;
  end else
  begin
    R := Rs;
    Kv := Round(Value*128*R/1000- 1);
    if Kv < 0 then Kv := 0;
    if Kv > 127 then Kv := 127;
    Kv := SetParam(StNaprave, $09, Kv);
    Result := (Kv+ 1)*1000/128/R;
  end;
end;

*/

  driver.setParam(ALARM_EN, ALARM_EN_CMD_ERROR |
                            ALARM_EN_OVERCURRENT |
                            ALARM_EN_STALL_DETECT |
                            ALARM_EN_THERMAL_SHUTDOWN |
                            ALARM_EN_THERMAL_WARNING |
                            ALARM_EN_UNDER_VOLTAGE
                        //  ALARM_EN_ADC_UVLO |
                        //  ALARM_EN_SW_TURN_ON 
                            ); 

  MotorGetStatusOk(true);
  driver.getStatus(); // clears error flags

  driver.setAcc(150); // full steps/s^2 acceleration
  driver.setDec(150); // full steps/s^2 deceleration

  Serial.println("Voltage mode");
  driver.hardHiZ();
  driver.setVoltageMode();
  driver.configStepMode(STEP_FS_128); // options: 1, 1/2, 1/4, 1/8, 1/16, 1/32, 1/64, 1/128; full steps = STEP_FS,
                                      // in the current mode, microstepping is limited to 1/16
  driver.setMaxSpeed(500.); // Voltage mode is quieter and has smoother microstepping.

  // KVAL registers set the power to the motor by adjusting the PWM duty cycle,
  // use a value between 0-255 where 0 = no power, 255 = full power.
  // Start low and monitor the motor temperature until you find a safe balance
  // between power and temperature. 

  driver.setRunKVAL(LOW_POWER);
  driver.setAccKVAL(LOW_POWER);
  driver.setDecKVAL(LOW_POWER);
  driver.setHoldKVAL(LOW_POWER);
  HiPowerMode = false;
  
  EnableMotor(true);

  Serial.println("Motor driver initialisation complete.");
  return result;
}

bool MotorGetStatusOk(bool PrintAlways)
{
  bool MotorOk;
  String ActiveErrors;
  int iStatus = driver.getStatus();
  // if returned value is 0, reading is probably incorrect. Read again.
  if (iStatus == 0) iStatus = driver.getStatus();

  ActiveErrors = "Status = 0x" + String(iStatus, HEX);  
  if (!(iStatus & STATUS_nSTALL_A))  ActiveErrors.concat("  STALL_A"); // STALL_A and STALL_B flags are forced low when a stall condition is detected on bridge A or bridge B 
  if (!(iStatus & STATUS_nSTALL_B))  ActiveErrors.concat("  STALL_B"); // respectively. The stall detection is operative only when the voltage mode control is selected. 
  if (!(iStatus & STATUS_nOCD))      ActiveErrors.concat("  OCD overcurrent");  
  if ( (iStatus & 0x1000))           ActiveErrors.concat("  TH 12");  
  if ( (iStatus & 0x0800))           ActiveErrors.concat("  TH 11");  
  if (!(iStatus & STATUS_nUVLO_ADC)) ActiveErrors.concat("  UVLO_ADC"); // The UVLO_ADC flag is active low and indicates an ADC undervoltage event. 
  if (!(iStatus & STATUS_nUVLO))     ActiveErrors.concat("  UVLO");     // The UVLO flag is active low and is set by an undervoltage lockout or reset events (power-up included).
  if ( (iStatus & STATUS_STCK_MOD))  ActiveErrors.concat("  STCK_MOD");  
  if ( (iStatus & STATUS_CMD_ERROR)) ActiveErrors.concat("  CMD_ERROR"); // active high and indicates that the command received by SPI cannot be performed or does not exist at all.  
  //if ( (iStatus & 0x0040))         ActiveErrors.concat("  MOT_STATUS 6");  
  //if ( (iStatus & 0x0020))         ActiveErrors.concat("  MOT_STATUS 5");  
  //if ( (iStatus & STATUS_DIR_FWD)) ActiveErrors.concat("  FWD DIR");  
  if ( (iStatus & STATUS_SW_EVNT))   ActiveErrors.concat("  SWITCH WAS ACTIVATED");  
  if ( (iStatus & STATUS_SW_CLOS))   ActiveErrors.concat("  SWITCH IS CLOSED");  
  if (!(iStatus & STATUS_nBUSY))     ActiveErrors.concat("  BUSY");  
  if ( (iStatus & STATUS_HIZ))       ActiveErrors.concat("  HiZ");  

  if (PrintAlways)
  {
    Serial.println(ActiveErrors);
  }
  // active high flags
  MotorOk = (iStatus & 0b0001100010000000) == 0; //thermal, cmd_err
  // active low flags
  MotorOk = MotorOk & ((iStatus & 0b1110001000000000) == 0b1110001000000000); // stall, OCD, UVLO
  if (!MotorOk)
  {
    Serial.println("Motor Error(s): " + ActiveErrors);
  }
  return MotorOk;
}

void MoveConstSpeed (float speed, bool IgnoreLimit)
{
  byte dir;
  float speedAbs = abs(speed);
  dir = speed > 0 ? FWD : REV;

  // enable higher power if high speed is requested
  if ((speedAbs > 0.5) && (!HiPowerMode))
  {
    driver.setRunKVAL(HIGH_POWER);
    driver.setAccKVAL(HIGH_POWER);
    driver.setDecKVAL(HIGH_POWER);
    driver.setHoldKVAL(HIGH_POWER-15);
    HiPowerMode = true;
  }
  if ((speedAbs < 0.3) && (HiPowerMode))
  {
    driver.setRunKVAL(LOW_POWER);
    driver.setAccKVAL(LOW_POWER);
    driver.setDecKVAL(LOW_POWER);
    driver.setHoldKVAL(LOW_POWER);
    HiPowerMode = false;
  }
  if (!IgnoreLimit)
    if (speedAbs > SPEED_LIMIT) speedAbs = SPEED_LIMIT; // limit max
  if (speedAbs > 0.05) // hysteresis - do not move if too little; wait for the next command
  {
    driver.run(dir, speedAbs);
  }
  else
  {
    driver.softStop();
  }
}


void oneMotion(int dist) {
  driver.move(FWD, dist); // move forward 12800 microsteps
  while(driver.busyCheck()); // wait fo the move to finish
  driver.softStop(); // soft stops prevent errors in the next operation
  while(driver.busyCheck());
  
  MotorGetStatusOk(true);

  driver.move(REV, dist/2); // reverse back
  while(driver.busyCheck());
  driver.softStop();
  while(driver.busyCheck());

  MotorGetStatusOk(true);
}



void EnableMotor (bool Enable)
{
  if (!Enable) driver.hardHiZ();
  Serial.printf ("Motor enabled: %d\n", Enable);
}

//================================================================================================================
//================================================================================================================

void MotorTest() 
{ 
  driver.setAcc(50); // full steps/s^2 acceleration
  driver.setDec(50); // full steps/s^2 deceleration


  Serial.println("Voltage mode");
  driver.hardHiZ();
  driver.setVoltageMode();
  driver.configStepMode(STEP_FS_128);
  driver.setMaxSpeed(20.); // Voltage mode is quieter and has smoother microstepping.

  // KVAL registers set the power to the motor by adjusting the PWM duty cycle,
  // use a value between 0-255 where 0 = no power, 255 = full power.
  // Start low and monitor the motor temperature until you find a safe balance
  // between power and temperature. 

  driver.setRunKVAL(30);
  driver.setAccKVAL(30);
  driver.setDecKVAL(30);
  driver.setHoldKVAL(20);
  oneMotion(300*128);
  delay(1500);
  driver.softHiZ();
  delay(500);

/*
  Serial.println("Current mode");
  driver.hardHiZ();
  driver.setCurrentMode();
  driver.configStepMode(STEP_FS_16);  // max allowed for current mode
  driver.setMaxSpeed(20.); // Current mode spins much faster, but is noticeably louder.
  driver.setRunTVAL(9);
  driver.setAccTVAL(6);
  driver.setDecTVAL(6);
  driver.setHoldTVAL(4);
  oneMotion(300*16);
  delay(1500);
  driver.softHiZ();
  delay(500);
*/
}
