

extern uint32_t EncoderPosST;
extern int16_t EncoderPosMT;
extern bool EncoderWarning, EncoderError;

bool encoderInit(void);
bool encoderRead(bool PrintData = false);
bool EncoderSetMT(uint16_t NewMTvalue);
bool EncoderSetZeroHere(void);


