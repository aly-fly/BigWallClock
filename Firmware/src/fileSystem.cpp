#include <arduino.h>
#include "LittleFS.h"
#include "fsTools.h"
#include "__CONFIG.h"
#include "Logger.h"

void MainLoopBackgroundTasks(void);

bool FSready = false;

bool fileSystem_init(void)
{
  bool result = false;
  // Initialize LittleFS
  Log("Mounting LittleFS..");
  if (LittleFS.begin(true)) // format on fail
  {
    Log("Filesystem ready.");
    Log("FS size: %d Bytes", LittleFS.totalBytes());
    Log("FS used: %d Bytes", LittleFS.usedBytes());
    Log("FS available: %d Bytes", LittleFS.totalBytes() - LittleFS.usedBytes());
    FSready = true;
    result = true;
  }
  else
  {
    Log("An Error has occurred while mounting LittleFS.");
  }
  return result;
}

void fileSystemPrintInfo(void)
{
  Log("FS size: %d Bytes", LittleFS.totalBytes());
  Log("FS used: %d Bytes", LittleFS.usedBytes());
  Log("FS available: %d Bytes", LittleFS.totalBytes() - LittleFS.usedBytes());
}

//==================================================================================================================

bool saveToFile(String *TextToWrite)
{
  size_t fileSize = 0;
  size_t AvailableSpace = 0;
  bool result = false;

  AvailableSpace = LittleFS.totalBytes() - LittleFS.usedBytes();

  fileSize = getFileSize(LOG_FILE_wPATH);
  if ((fileSize + TextToWrite->length()) > (AvailableSpace - 500))
  {
    LogNS("File too big. (%u B)  Can't save data.\r\n", (uint32_t)(fileSize));
    return true; // clear buffer of collected data
  }

  //LogNS("File name: %s\r\n", LOG_FILE_wPATH);
  int64_t Time1 = esp_timer_get_time();
  File file = LittleFS.open(LOG_FILE_wPATH, FILE_APPEND);

  // Insert the data in the photo file
  if (!file)
  {
    LogNS("Failed to open file in append mode!\r\n");
  }
  else
  {
    LogNS("File open.\r\n");
    yield();
    file.print(*TextToWrite);
    LogNS("Data has been saved.\r\n");
    result = true;
  }
  // Close the file (reading file size des not work before this!)
  file.close();
  int64_t Time2 = esp_timer_get_time();

  // check if file has been correctly saved in LittleFS
  fileSize = getFileSize(LOG_FILE_wPATH);

  bool ok = fileSize > 10;
  LogNS("File save ok: %d\r\n", ok);

  LogNS("Save: %u B, %u ms\r\n", (uint32_t)(fileSize), (uint32_t)((Time2 - Time1) / 1000));
  return result;
}


void ReadAndPrintContentsOfTheLog(void)
{
  loggerPurgeToFile(true); // first save data from the RAM 

  size_t fileSize = getFileSize(LOG_FILE_wPATH);
  LogNS("File size: %u B\r\n", (uint32_t)(fileSize));

  File file = LittleFS.open(LOG_FILE_wPATH, FILE_READ);
  if (!file)
  {
    LogNS("Failed to open file in read mode!\r\n");
  }
  else
  {
    LogNS("File open.\r\n");
    int i = 0;
    while (file.available()) 
    {
      char c = file.read();
      LogNSc(c);
      i++;
      if (i > 1000)
      {
        i = 0;
        MainLoopBackgroundTasks();
      }
    }

    LogNS("======================== EOF ============================= \r\n");
  }
  file.close();
}


void DeleteLogFile(void)
{
  LogNS("Deleting log file...");
  if (LittleFS.remove(LOG_FILE_wPATH))
  {
    LogNS("ok.\r\n");
  }
  else
  {
    LogNS("FAIL!\r\n");
  }
}


