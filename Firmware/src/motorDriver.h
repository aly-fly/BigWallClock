

bool MotorInit();
//void MotorTest();
void MoveConstSpeed (float speed, bool IgnoreLimit = false);
bool MotorGetStatusOk(bool PrintAlways = false);
void EnableMotor (bool Enable);
