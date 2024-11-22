#include "../core/Logger.h"
extern unsigned char input_byte(unsigned short port);

void keyboard_input()
{
    //keyboard sends a code (called a scancode)
    //keyboard sends data to a specific port (usually 0x60)
    unsigned char scancode = inb(0X60); 

    SetLogColor(PRINT_COLOR_WHITE, PRINT_COLOR_BLACK);
    Log(scancode);
}

