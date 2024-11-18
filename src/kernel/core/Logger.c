#include "Logger.h"

// VGA Text Mode starting address
#define VGA_TEXT (char*)0xB8000

void Log(const char* message)
{
    char* videoMemory = VGA_TEXT;

    // videoMemory[0] = 'H';
    // videoMemory[1] = 0x07;

    const char* msg = "ISAE";

    int i = 0;
    int j = 0;
    while(msg[j] != '\0')
    {
        videoMemory[i] = msg[j];
        i++;
        j++;
        videoMemory[i] = 0x07;
        i++;
    }
}