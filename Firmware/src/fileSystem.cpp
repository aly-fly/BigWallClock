#include <arduino.h>
#include "LittleFS.h"
#include "fsTools.h"
#include "__CONFIG.h"
#include "Logger.h"

bool FSready = false;

bool fileSystem_init(void)
{
  bool result = false;
  // Initialize LittleFS
  Serial.println("Mounting LittleFS..");
  if (LittleFS.begin(true)) // format on fail
  {
    Serial.println("Filesystem ready.");
    Serial.printf("FS size: %d Bytes\n", LittleFS.totalBytes());
    Serial.printf("FS used: %d Bytes\n", LittleFS.usedBytes());
    Serial.printf("FS available: %d Bytes\n", LittleFS.totalBytes() - LittleFS.usedBytes());
    FSready = true;
    result = true;
  }
  else
  {
    Serial.println("An Error has occurred while mounting LittleFS.");
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
    LogNS("File too big. (%u B)  Can't save data.\n", (uint32_t)(fileSize));
    return true; // clear buffer of collected data
  }

  //Serial.printf("File name: %s\n", LOG_FILE_wPATH);
  int64_t Time1 = esp_timer_get_time();
  File file = LittleFS.open(LOG_FILE_wPATH, FILE_APPEND);

  // Insert the data in the photo file
  if (!file)
  {
    LogNS("Failed to open file in append mode!\n");
  }
  else
  {
    LogNS("File open.\n");
    yield();
    file.print(*TextToWrite);
    LogNS("Data has been saved.\n");
    result = true;
  }
  // Close the file (reading file size des not work before this!)
  file.close();
  int64_t Time2 = esp_timer_get_time();

  // check if file has been correctly saved in LittleFS
  fileSize = getFileSize(LOG_FILE_wPATH);

  bool ok = fileSize > 10;
  LogNS("File save ok: %d\n", ok);

  LogNS("Save: %u B, %u ms\n", (uint32_t)(fileSize), (uint32_t)((Time2 - Time1) / 1000));
  return result;
}


void ReadAndPrintContentsOfTheLog(void)
{
  loggerPurgeToFile(true); // first save data from the RAM 

  size_t fileSize = getFileSize(LOG_FILE_wPATH);
  LogNS("File size: %u B\n", (uint32_t)(fileSize));

  File file = LittleFS.open(LOG_FILE_wPATH, FILE_READ);
  if (!file)
  {
    LogNS("Failed to open file in read mode!\n");
  }
  else
  {
    LogNS("File open.\n");

    while (file.available()) 
    {
      char c = file.read();
      LogNSc(c);
    }

    LogNS("======================== EOF ============================= \n");
  }
  file.close();
}


void DeleteLogFile(void)
{
  LogNS("Deleting log file...");
  if (LittleFS.remove(LOG_FILE_wPATH))
  {
    LogNS("ok.\n");
  }
  else
  {
    LogNS("FAIL!\n");
  }
}


