#include "Logger.h"

// VGA Text Mode starting address
#define VGA_TEXT (char*)0xB8000

void Log(const char* message)
{
    char* videoMemory = VGA_TEXT;

    int i = 0;
    // while(message[i] != '\0')
    // {
    //     videoMemory[i * 2] = message[i];
    //     videoMemory[i * 2 + 1] = 0x07;
    //     i++;
    // }

    videoMemory[0] = 'H';
    videoMemory[1] = 0x07;
    videoMemory[2] = 'I';
    videoMemory[3] = 0x07;
    videoMemory[4] = '!';
    videoMemory[5] = 0x07;
}