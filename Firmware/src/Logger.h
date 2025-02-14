
void int_log (void);
void int_logNS (void);
void loggerPurgeToFile(bool immediatelly = false);

void LogNSc(char cc);

extern char int_logbuffer[150];

//#define Log(format, ...)  sprintf(int_logbuffer, format, ##__VA_ARGS__); int_log();
// Send to Serial, TCP and info file.
#define Log(...)  sprintf(int_logbuffer, ##__VA_ARGS__); int_log();

// Send to Serial, TCP. Don't save.
#define LogNS(...)  sprintf(int_logbuffer, ##__VA_ARGS__); int_logNS();

