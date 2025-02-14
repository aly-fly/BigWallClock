#include <arduino.h>
#include "LittleFS.h"
#include "fsTools.h"
#include "__CONFIG.h"
#include "Logger.h"

bool FSready = false;

void fileSystem_init()
{
  // Initialize LittleFS
  Serial.println("Mounting LittleFS..");
  if (!LittleFS.begin(true)) // format on fail
  {
    Serial.println("An Error has occurred while mounting LittleFS.");
    while (1)
    {
      delay(10);
      yield();
    } // Stay here twiddling thumbs waiting
  }
  Serial.println("Filesystem ready.");
  FSready = true;
}

//==================================================================================================================

bool saveToFile(String *TextToWrite)
{
  size_t fileSize = 0;
  bool result = false;

  fileSize = getFileSize(LOG_FILE_wPATH);
  if (fileSize > 2500000)
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


