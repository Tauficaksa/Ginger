#include "Logger.h"

// VGA Text Mode starting address
#define VGA_TEXT (char*)0xB8000

void Log(const char* message)
{
    char* videoMemory = VGA_TEXT;


    // videoMemory[0] = 'H';
    // videoMemory[1] = 0x07;

    int i = -1;
    int j = 0;
    while(message[j] != '\0')
    {
        videoMemory[++i] = message[j++];
        videoMemory[++i] = 0x07;
    }
}