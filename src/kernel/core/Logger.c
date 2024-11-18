#include "Logger.h"

// some consts that we cant control
const static size_t NUM_COLS = 80;
const static size_t NUM_ROWS = 25;

struct VGAChar
{
    uint8_t character;
    uint8_t color;
};

// starting from the point 0xb8000 we are creating a buffer of
// memory of chars
struct VGAChar* buffer = (struct VGAChar*) 0xb8000;

size_t row = 0;
size_t col = 0;
// the color we will be using. white for fg, black for bg
uint8_t currentColor = PRINT_COLOR_WHITE | PRINT_COLOR_BLACK << 4;


// private functions //
void clearRow(size_t pRow)
{
    struct VGAChar empty = (struct VGAChar) {
        character: ' ',
        color: currentColor
    };
    
    for(size_t c = 0; c < NUM_COLS; c++)
        buffer[c + NUM_COLS * pRow] = empty;
}

void logNewLine()
{
    col = 0;

    if(row < NUM_ROWS - 1)
    {
        row++;
        return;
    }

    // we move all the rows up by 1 if the whole screen is filled
    for(size_t r = 1; r < NUM_ROWS; r++)
    {
        for(size_t c = 0; c < NUM_COLS; c++)
        {
            struct VGAChar character = buffer[c + NUM_COLS * r];
            buffer[c + NUM_COLS * (r - 1)] = character;
        }
    }

    clearRow(NUM_ROWS - 1);
}


// public functions //
void ClearScreen()
{
    for(size_t i = 0; i < NUM_ROWS; i++)
        clearRow(i);
}

void LogChar(char c)
{
    if(c == '\n')
    {
        logNewLine();
        return;
    }

    if(col > NUM_COLS)
    {
        logNewLine();
    }

    buffer[col + NUM_COLS * row] = (struct VGAChar) {
        character: (uint8_t) c,
        color: currentColor
    };

    col++;
}

void Log(const char* message)
{
    for(int i = 0; 1; i++)
    {
        char c = (uint8_t)message[i];

        if(c == '\0')
            return;
        
        LogChar(c);
    }
}

void SetLogColor(uint8_t fgColor, uint8_t bgColor)
{ currentColor = fgColor + (bgColor << 4); }