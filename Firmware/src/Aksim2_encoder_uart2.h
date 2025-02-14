

extern uint32_t EncoderPosST;
extern int16_t EncoderPosMT;
extern bool EncoderWarning, EncoderError;

bool encoderInit(void);
bool encoderRead(bool PrintData = false);
bool encoderReadAirGap(void);
bool EncoderSetMT(uint16_t NewMTvalue);
bool EncoderSetZeroHere(void);


