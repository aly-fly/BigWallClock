
enum motorStatus_t { MSOK, MSSTALL, MSFAULT };

bool MotorInit();
//void MotorTest();
void MoveConstSpeed (float speed, bool IgnoreLimit = false);
motorStatus_t MotorGetStatus(bool PrintAlways = false);
void EnableMotor (bool Enable);
