#include "Logger.h"

// VGA Text Mode starting address
#define VGA_TEXT (char*)0xB8000

void Log(const char* message)
{
    char* videoMemory = VGA_TEXT;
    int i = 0;

    // Write each character to video memory
    while (message[i] != '\0')
    {
        videoMemory[i * 2] = message[i];    // Character byte
        videoMemory[i * 2 + 1] = 0x07;      // Attribute byte (light grey on black)
        i++;
    }
}