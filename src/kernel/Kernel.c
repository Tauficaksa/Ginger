#include "core/Logger.h"
#include "io/keyboard.h"

void kernel_main()
{
    const char* startMessage = "HI, I'm Ginger! \nI'm A Cat";

    ClearScreen();

    // SetLogColor(PRINT_COLOR_WHITE, PRINT_COLOR_BLACK);
    // Log(startMessage);
    keyboard_input();

    while(1) {}
}
