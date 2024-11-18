#include "core/Logger.h"


void kernel_main()
{
    // char* video_memory = (char*)0xB8000;
    // video_memory[0] = 'H';  // Character
    // video_memory[1] = 0x07; // Attribute (light grey on black)
    // video_memory[2] = 'i';  // Character
    // video_memory[3] = 0x07; // Attribute (light grey on black)
    
    const char* msg = "HI";
    Log(msg);

    while(1) {}
}
