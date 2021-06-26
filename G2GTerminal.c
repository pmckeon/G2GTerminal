#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "SMSlib.h"

#define BLINKSPEED 10 // Text cursor blink speed.
#define SEND_BUFFER_SIZE 61 // Size including null terminating character.

#define G2G_BYTE_SENT 0x01
#define G2G_BYTE_RECV 0x02
#define G2G_ERROR 0x04
#define G2G_ENABLE_NMI_ON_RECV 0x08
#define G2G_ENABLE_SEND 0x10
#define G2G_ENABLE_RECV 0x20

#define STRING_OFFSET (-32)

// define GG Link stuff.
__sfr __at 0x01 G2G_IOPinPort;
__sfr __at 0x02 G2G_NMIPort;
__sfr __at 0x03 G2G_TxPort;
__sfr __at 0x04 G2G_RxPort;
__sfr __at 0x05 G2G_StatusPort;

static char text[11][21];
static int writeIndex = 0;

static uint8_t recv_x = 6;
static uint8_t recv_y = 3;

static const unsigned char cursor_sprite[32] = {
    0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00,
    0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00};

volatile char receiveBuffer[SEND_BUFFER_SIZE];
volatile uint8_t receiveCount = 0;
volatile bool endMessage = false;

void SMS_nmi_isr (void) __critical __interrupt;
void putstring(uint8_t x, uint8_t y, const char *string);
void UpdateMessage();

void main(void)
{
    uint8_t keyPress, char_x, char_y, send_x, send_y;
    int index;
    uint8_t timer = BLINKSPEED;
    char sendBuffer[SEND_BUFFER_SIZE];
    bool blink = false;
    
    SMS_VRAMmemsetW(XYtoADDR(0, 0), 0, 32 * 28 * 2); // Initialise VRAM.

    SMS_useFirstHalfTilesforSprites(true);
    SMS_autoSetUpTextRenderer();
    SMS_loadTiles(cursor_sprite, 96, 32);
    GG_setSpritePaletteColor(1, 0xFEDF);

    G2G_IOPinPort = 0x00;
    G2G_NMIPort = 0xFF;
    G2G_StatusPort = 0x38; // 4800 baud, NMI enabled.

    char_x = 6;
    char_y = 19;
    index = 0;
    send_x = 6;
    send_y = 15;

    putstring(6, 14, "--------------------");

    putstring(6, 18, "--------------------");

    putstring(6, 19, "ABCDEFGHIJKLMNOPQRST");
    putstring(6, 20, "UVWXYZ .<");

    for (;;)
    {
        SMS_initSprites();

        SMS_waitForVBlank();

        if(endMessage)
        {
            const char *src;
            char *dst;
            src = receiveBuffer;
            dst = text[writeIndex];
            int n = 0;
            while(*src)
            {
                *dst = *src;
                src++;
                dst++;
                n++;
                if(n >= 20 && *src)
                {
                    *dst = '\0';
                    n=0;
                    writeIndex++;
                    if(writeIndex >= 11)
                    {
                        writeIndex = 0;
                    }
                    dst = text[writeIndex];
                }
            }
            *dst = '\0';
            writeIndex++;
            if(writeIndex >= 11)
            {
                writeIndex = 0;
            }
            receiveCount = 0;
            endMessage = false;
            UpdateMessage();
            // Insert blank line to improve readability.
            dst = text[writeIndex];
            *dst = '\0';
            writeIndex++;
            if(writeIndex >= 11)
            {
                writeIndex = 0;
            }
        }

        keyPress = SMS_getKeysPressed();
        if (keyPress & PORT_A_KEY_UP)
        {
            char_y--;
            if (char_y < 19)
                char_y = 19;
        }
        else if (keyPress & PORT_A_KEY_DOWN)
        {
            char_y++;
            if (char_y > 20)
                char_y = 20;
            if (char_x > 14 && char_y == 20)
            {
                char_x = 14;
                char_y = 20;
            }
        }
        else if (keyPress & PORT_A_KEY_LEFT)
        {
            char_x--;
            if (char_x < 6)
                char_x = 6;
        }
        else if (keyPress & PORT_A_KEY_RIGHT)
        {
            char_x++;
            if (char_x > 14 && char_y == 20)
            {
                char_x = 14;
                char_y = 20;
            }
            if (char_x > 25)
                char_x = 25;
        }
        else if (keyPress & PORT_A_KEY_1)
        {
            // Maybe there's a better way to handle this... but it works!
            if (char_x == 12 && char_y == 20) // Handle space.
            {
                if (send_x < 26)
                {
                    sendBuffer[index] = ' ';
                    sendBuffer[index + 1] = '\0';
                    SMS_setNextTileatXY(send_x, send_y);
                    SMS_setTile(sendBuffer[index] + STRING_OFFSET);

                    index++;
                    send_x++;
                }
            }
            else if (char_x == 13 && char_y == 20) // Handle full stop.
            {
                if (send_x < 26)
                {
                    sendBuffer[index] = '.';
                    sendBuffer[index + 1] = '\0';
                    SMS_setNextTileatXY(send_x, send_y);
                    SMS_setTile(sendBuffer[index] + STRING_OFFSET);

                    index++;
                    send_x++;
                }
            }
            else if (char_x == 14 && char_y == 20) // Handle backspace.
            {
                if (send_x > 6 || send_y > 15)
                {
                    index--;
                    sendBuffer[index] = '\0';
                    send_x--;
                    if (send_x < 6 && send_y > 15)
                    {
                        send_x = 25;
                        send_y--;
                    }
                    SMS_setNextTileatXY(send_x, send_y);
                    SMS_setTile(0);
                }
            }
            else // Handle standard characters.
            {
                if (send_x < 26)
                {
                    sendBuffer[index] = char_x + 59;
                    if (char_y == 20)
                        sendBuffer[index] += 20;
                    sendBuffer[index + 1] = '\0';
                    SMS_setNextTileatXY(send_x, send_y);
                    SMS_setTile(sendBuffer[index] + STRING_OFFSET);

                    index++;
                    send_x++;
                }
            }
            if (index < 0)
                index = 0;
            if (index > SEND_BUFFER_SIZE)
                index = SEND_BUFFER_SIZE;
            if (send_x > 25)
            {
                if (send_y < 17)
                {
                    send_y++;
                    send_x = 6;
                }
                else
                    send_x = 26;
            }
        }
        else if (keyPress & PORT_A_KEY_2 && index > 0) // Send whatever is in our buffer over the link.
        {
            for (int i = 0; i < (index+1); i++)
            {
                while ((G2G_StatusPort & G2G_BYTE_SENT) != 0);
                G2G_TxPort = sendBuffer[i];
            }

            index = 0;
            sendBuffer[index] = '\0';
            send_x = 6;
            send_y = 15;
            // Clear send window.
            SMS_VRAMmemsetW(XYtoADDR(6, 15), 0, 20 * 2);
            SMS_VRAMmemsetW(XYtoADDR(6, 16), 0, 20 * 2);
            SMS_VRAMmemsetW(XYtoADDR(6, 17), 0, 20 * 2);
        }

        if (--timer == 0)
        {
            blink = !blink;
            timer = BLINKSPEED;
        }

        if (blink)
        {
            SMS_addSprite(char_x * 8, char_y * 8, 96);
        }

        SMS_copySpritestoSAT();
    }
}

void SMS_nmi_isr (void) __critical __interrupt
{
    if(receiveCount >= SEND_BUFFER_SIZE)
        return;

    receiveBuffer[receiveCount]=G2G_RxPort;
    if(receiveBuffer[receiveCount] == '\0')
        endMessage = true;
    receiveCount++;
}

void putstring(uint8_t x, uint8_t y, const char *string)
{
    SMS_setNextTileatXY(x, y);
    while (*string)
    {
        SMS_setTile(*string++ + STRING_OFFSET);
    }
}

void UpdateMessage()
{
    int startIndex = writeIndex;
    recv_y=3;
    for(int i=0; i < 11; i++)
    {
        if(startIndex >= 11)
            startIndex = 0;
        SMS_VRAMmemsetW(XYtoADDR(recv_x, recv_y), 0, 20 * 2);
        putstring(recv_x, recv_y, text[startIndex]);
        recv_y++;
        startIndex++;
    }
}

SMS_EMBED_SEGA_ROM_HEADER(1, 0);
SMS_EMBED_SDSC_HEADER_AUTO_DATE(1, 0, "thatawesomeguy", "G2GTerminal", "2021");