
void int_log (void);
void loggerPurgeToFile(void);


extern char int_logbuffer[100];

//#define Log(format, ...)  sprintf(int_logbuffer, format, ##__VA_ARGS__); int_log();
#define Log(...)  sprintf(int_logbuffer, ##__VA_ARGS__); int_log();

