#include "core/Logger.h"


void kernel_main()
{
    const char* startMessage = "HI, I'm Ginger! \nI'm A Cat";

    ClearScreen();

    SetLogColor(PRINT_COLOR_WHITE, PRINT_COLOR_BLACK);
    Log(startMessage);

    while(1) {}
}
