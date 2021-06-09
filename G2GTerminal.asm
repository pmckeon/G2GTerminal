;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (MINGW64)
;--------------------------------------------------------
	.module G2GTerminal
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl ___SMS__SDSC_signature
	.globl ___SMS__SDSC_descr
	.globl ___SMS__SDSC_name
	.globl ___SMS__SDSC_author
	.globl ___SMS__SEGA_signature
	.globl _main
	.globl _putstring
	.globl _SMS_VRAMmemsetW
	.globl _SMS_getKeysPressed
	.globl _SMS_autoSetUpTextRenderer
	.globl _GG_setSpritePaletteColor
	.globl _SMS_copySpritestoSAT
	.globl _SMS_addSprite
	.globl _SMS_initSprites
	.globl _SMS_loadTiles
	.globl _SMS_crt0_RST18
	.globl _SMS_crt0_RST08
	.globl _SMS_waitForVBlank
	.globl _SMS_useFirstHalfTilesforSprites
	.globl _SMS_SRAM
	.globl _SRAM_bank_to_be_mapped_on_slot2
	.globl _ROM_bank_to_be_mapped_on_slot2
	.globl _cursor_sprite
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_G2G_IOPinPort	=	0x0001
_G2G_NMIPort	=	0x0002
_G2G_TxPort	=	0x0003
_G2G_RxPort	=	0x0004
_G2G_StatusPort	=	0x0005
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_ROM_bank_to_be_mapped_on_slot2	=	0xffff
_SRAM_bank_to_be_mapped_on_slot2	=	0xfffc
_SMS_SRAM	=	0x8000
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;G2GTerminal.c:29: void putstring(uint8_t x, uint8_t y, const char *string)
;	---------------------------------
; Function putstring
; ---------------------------------
_putstring::
	push	ix
	ld	ix,#0
	add	ix,sp
;G2GTerminal.c:31: SMS_setNextTileatXY(x, y);
	ld	l, 5 (ix)
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, 4 (ix)
	ld	b, #0x00
	add	hl, bc
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
	call	_SMS_crt0_RST08
;G2GTerminal.c:32: while (*string)
	ld	c, 6 (ix)
	ld	b, 7 (ix)
00101$:
	ld	a, (bc)
	or	a, a
	jr	Z,00104$
;G2GTerminal.c:34: SMS_setTile(*string++ + STRING_OFFSET);
	inc	bc
	ld	e, a
	ld	d, #0x00
	ld	hl, #0xffe0
	add	hl, de
	call	_SMS_crt0_RST18
	jr	00101$
00104$:
;G2GTerminal.c:36: }
	pop	ix
	ret
_cursor_sprite:
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
;G2GTerminal.c:43: void main(void)
;	---------------------------------
; Function main
; ---------------------------------
_main::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl, #-140
	add	hl, sp
	ld	sp, hl
;G2GTerminal.c:47: uint8_t timer = BLINKSPEED;
	ld	-18 (ix), #0x0a
;G2GTerminal.c:51: bool blink = false;
	xor	a, a
	ld	-7 (ix), a
;G2GTerminal.c:53: SMS_VRAMmemsetW(XYtoADDR(0, 0), 0, 32 * 28 * 2); // Initialise VRAM
	ld	hl, #0x0700
	push	hl
	ld	h, #0x00
	push	hl
	ld	h, #0x78
	push	hl
	call	_SMS_VRAMmemsetW
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
;G2GTerminal.c:55: SMS_useFirstHalfTilesforSprites(true);
	ld	l, #0x01
	call	_SMS_useFirstHalfTilesforSprites
;G2GTerminal.c:56: SMS_autoSetUpTextRenderer();
	call	_SMS_autoSetUpTextRenderer
;G2GTerminal.c:57: SMS_loadTiles(cursor_sprite, 96, 32);
	ld	hl, #0x0020
	push	hl
	ld	l, #0x60
	push	hl
	ld	hl, #_cursor_sprite
	push	hl
	call	_SMS_loadTiles
	ld	hl, #6
	add	hl, sp
	ld	sp, hl
;G2GTerminal.c:58: GG_setSpritePaletteColor(1, 0xFEDF);
	ld	hl, #0xfedf
	push	hl
	ld	a, #0x01
	push	af
	inc	sp
	call	_GG_setSpritePaletteColor
	pop	af
	inc	sp
;G2GTerminal.c:60: G2G_IOPinPort = 0x00;
	ld	a, #0x00
	out	(_G2G_IOPinPort), a
;G2GTerminal.c:61: G2G_NMIPort = 0xFF;
	ld	a, #0xff
	out	(_G2G_NMIPort), a
;G2GTerminal.c:62: G2G_StatusPort = 0x30; // 4800 baud
	ld	a, #0x30
	out	(_G2G_StatusPort), a
;G2GTerminal.c:67: char_x = 6;
	ld	-6 (ix), #0x06
;G2GTerminal.c:68: char_y = 19;
	ld	-5 (ix), #0x13
;G2GTerminal.c:69: index = 0;
	xor	a, a
	ld	-4 (ix), a
;G2GTerminal.c:70: send_x = 6;
	ld	-3 (ix), #0x06
;G2GTerminal.c:71: send_y = 15;
	ld	-2 (ix), #0x0f
;G2GTerminal.c:75: putstring(6, 14, "--------------------");
	ld	hl, #___str_0
	push	hl
	ld	de, #0x0e06
	push	de
	call	_putstring
	pop	af
;G2GTerminal.c:77: putstring(6, 18, "--------------------");
	ld	hl, #___str_0
	ex	(sp),hl
	ld	de, #0x1206
	push	de
	call	_putstring
	pop	af
;G2GTerminal.c:79: putstring(6, 19, "ABCDEFGHIJKLMNOPQRST");
	ld	hl, #___str_1
	ex	(sp),hl
	ld	de, #0x1306
	push	de
	call	_putstring
	pop	af
;G2GTerminal.c:80: putstring(6, 20, "UVWXYZ .<");
	ld	hl, #___str_2
	ex	(sp),hl
	ld	de, #0x1406
	push	de
	call	_putstring
	pop	af
	pop	af
	ld	-1 (ix), #0x06
00181$:
;G2GTerminal.c:84: SMS_initSprites();
	call	_SMS_initSprites
;G2GTerminal.c:86: SMS_waitForVBlank();
	call	_SMS_waitForVBlank
;G2GTerminal.c:89: if ((G2G_StatusPort & G2G_BYTE_RECV) != 0)
	in	a, (_G2G_StatusPort)
	bit	1, a
	jr	Z,00102$
;G2GTerminal.c:91: SMS_setNextTileatXY(recv_x, recv_y);
	ld	a, -1 (ix)
	ld	-9 (ix), a
	xor	a, a
	ld	-8 (ix), a
	ld	a, -9 (ix)
	add	a, #0x60
	ld	l, a
	ld	a, -8 (ix)
	adc	a, #0x00
	ld	h, a
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
	call	_SMS_crt0_RST08
;G2GTerminal.c:92: recByte = G2G_RxPort;
	in	a, (_G2G_RxPort)
;G2GTerminal.c:93: SMS_setTile(recByte + STRING_OFFSET);
	ld	c, a
	ld	b, #0x00
	ld	hl, #0xffe0
	add	hl, bc
	call	_SMS_crt0_RST18
;G2GTerminal.c:94: recv_x++;
	inc	-1 (ix)
00102$:
;G2GTerminal.c:97: keyPress = SMS_getKeysPressed();
	call	_SMS_getKeysPressed
	ld	-8 (ix), l
;G2GTerminal.c:98: if (keyPress & PORT_A_KEY_UP)
	bit	0, -8 (ix)
	jr	Z,00171$
;G2GTerminal.c:100: char_y--;
	dec	-5 (ix)
;G2GTerminal.c:101: if (char_y < 19)
	ld	a, -5 (ix)
	sub	a, #0x13
	jp	NC, 00172$
;G2GTerminal.c:102: char_y = 19;
	ld	-5 (ix), #0x13
	jp	00172$
00171$:
;G2GTerminal.c:104: else if (keyPress & PORT_A_KEY_DOWN)
	bit	1, -8 (ix)
	jr	Z,00168$
;G2GTerminal.c:106: char_y++;
	inc	-5 (ix)
;G2GTerminal.c:107: if (char_y > 20)
	ld	a, #0x14
	sub	a, -5 (ix)
	jr	NC,00106$
;G2GTerminal.c:108: char_y = 20;
	ld	-5 (ix), #0x14
00106$:
;G2GTerminal.c:109: if (char_x > 14 && char_y == 20)
	ld	a, #0x0e
	sub	a, -6 (ix)
	jp	NC, 00172$
	ld	a, -5 (ix)
	sub	a, #0x14
	jp	NZ,00172$
;G2GTerminal.c:111: char_x = 14;
	ld	-6 (ix), #0x0e
;G2GTerminal.c:112: char_y = 20;
	ld	-5 (ix), #0x14
	jp	00172$
00168$:
;G2GTerminal.c:115: else if (keyPress & PORT_A_KEY_LEFT)
	bit	2, -8 (ix)
	jr	Z,00165$
;G2GTerminal.c:117: char_x--;
	dec	-6 (ix)
;G2GTerminal.c:118: if (char_x < 6)
	ld	a, -6 (ix)
	sub	a, #0x06
	jp	NC, 00172$
;G2GTerminal.c:119: char_x = 6;
	ld	-6 (ix), #0x06
	jp	00172$
00165$:
;G2GTerminal.c:109: if (char_x > 14 && char_y == 20)
	ld	a, -5 (ix)
	sub	a, #0x14
	ld	a, #0x01
	jr	Z,00383$
	xor	a, a
00383$:
	ld	-17 (ix), a
;G2GTerminal.c:121: else if (keyPress & PORT_A_KEY_RIGHT)
	bit	3, -8 (ix)
	jr	Z,00162$
;G2GTerminal.c:123: char_x++;
	inc	-6 (ix)
;G2GTerminal.c:124: if (char_x > 14 && char_y == 20)
	ld	a, #0x0e
	sub	a, -6 (ix)
	jr	NC,00113$
	ld	a, -17 (ix)
	or	a, a
	jr	Z,00113$
;G2GTerminal.c:126: char_x = 14;
	ld	-6 (ix), #0x0e
;G2GTerminal.c:127: char_y = 20;
	ld	-5 (ix), #0x14
00113$:
;G2GTerminal.c:129: if (char_x > 25)
	ld	a, #0x19
	sub	a, -6 (ix)
	jp	NC, 00172$
;G2GTerminal.c:130: char_x = 25;
	ld	-6 (ix), #0x19
	jp	00172$
00162$:
;G2GTerminal.c:132: else if (keyPress & PORT_A_KEY_1)
	bit	4, -8 (ix)
	jp	Z,00159$
;G2GTerminal.c:137: if (send_x < 26)
	ld	a, -3 (ix)
	sub	a, #0x1a
	ld	a, #0x00
	rla
	ld	-16 (ix), a
;G2GTerminal.c:139: sendBuffer[index] = ' ';
	ld	a, -4 (ix)
	ld	-15 (ix), a
	rla
	sbc	a, a
	ld	-14 (ix), a
;G2GTerminal.c:140: sendBuffer[index + 1] = '\0';
	ld	a, -4 (ix)
	inc	a
	ld	-13 (ix), a
;G2GTerminal.c:141: SMS_setNextTileatXY(send_x, send_y);
	ld	e, -2 (ix)
	ld	d, #0x00
	ld	c, -3 (ix)
	ld	b, #0x00
;G2GTerminal.c:145: send_x++;
	ld	a, -3 (ix)
	inc	a
	ld	-12 (ix), a
;G2GTerminal.c:140: sendBuffer[index + 1] = '\0';
	ld	a, -13 (ix)
	ld	-11 (ix), a
	rla
	sbc	a, a
	ld	-10 (ix), a
;G2GTerminal.c:141: SMS_setNextTileatXY(send_x, send_y);
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	-9 (ix), l
	ld	a, h
	or	a, #0x78
	ld	-8 (ix), a
;G2GTerminal.c:135: if (char_x == 12 && char_y == 20) // Handle space
	ld	a, -6 (ix)
	sub	a, #0x0c
	jp	NZ,00140$
	ld	a, -17 (ix)
	or	a, a
	jp	Z, 00140$
;G2GTerminal.c:137: if (send_x < 26)
	ld	a, -16 (ix)
	or	a, a
	jp	Z, 00141$
;G2GTerminal.c:139: sendBuffer[index] = ' ';
	ld	hl, #0
	add	hl, sp
	ld	-17 (ix), l
	ld	-16 (ix), h
	ld	a, -17 (ix)
	add	a, -15 (ix)
	ld	-4 (ix), a
	ld	a, -16 (ix)
	adc	a, -14 (ix)
	ld	-3 (ix), a
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	(hl), #0x20
;G2GTerminal.c:140: sendBuffer[index + 1] = '\0';
	ld	a, -17 (ix)
	add	a, -11 (ix)
	ld	-15 (ix), a
	ld	a, -16 (ix)
	adc	a, -10 (ix)
	ld	-14 (ix), a
	ld	l, -15 (ix)
	ld	h, -14 (ix)
	ld	(hl), #0x00
;G2GTerminal.c:141: SMS_setNextTileatXY(send_x, send_y);
	ld	l, -9 (ix)
	ld	h, -8 (ix)
	call	_SMS_crt0_RST08
;G2GTerminal.c:142: SMS_setTile(sendBuffer[index] + STRING_OFFSET);
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	a, (hl)
	ld	-3 (ix), a
	ld	-4 (ix), a
	xor	a, a
	ld	-3 (ix), a
	ld	a, -4 (ix)
	add	a, #0xe0
	ld	-9 (ix), a
	ld	a, -3 (ix)
	adc	a, #0xff
	ld	-8 (ix), a
	ld	l, -9 (ix)
	ld	h, -8 (ix)
	call	_SMS_crt0_RST18
;G2GTerminal.c:144: index++;
	ld	a, -13 (ix)
	ld	-4 (ix), a
;G2GTerminal.c:145: send_x++;
	ld	a, -12 (ix)
	ld	-3 (ix), a
	jp	00141$
00140$:
;G2GTerminal.c:148: else if (char_x == 13 && char_y == 20) // Handle full stop
	ld	a, -6 (ix)
	sub	a, #0x0d
	jp	NZ,00136$
	ld	a, -17 (ix)
	or	a, a
	jp	Z, 00136$
;G2GTerminal.c:150: if (send_x < 26)
	ld	a, -16 (ix)
	or	a, a
	jp	Z, 00141$
;G2GTerminal.c:152: sendBuffer[index] = '.';
	ld	hl, #0
	add	hl, sp
	ld	-17 (ix), l
	ld	-16 (ix), h
	ld	a, -17 (ix)
	add	a, -15 (ix)
	ld	-4 (ix), a
	ld	a, -16 (ix)
	adc	a, -14 (ix)
	ld	-3 (ix), a
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	(hl), #0x2e
;G2GTerminal.c:153: sendBuffer[index + 1] = '\0';
	ld	a, -17 (ix)
	add	a, -11 (ix)
	ld	-15 (ix), a
	ld	a, -16 (ix)
	adc	a, -10 (ix)
	ld	-14 (ix), a
	ld	l, -15 (ix)
	ld	h, -14 (ix)
	ld	(hl), #0x00
;G2GTerminal.c:154: SMS_setNextTileatXY(send_x, send_y);
	ld	l, -9 (ix)
	ld	h, -8 (ix)
	call	_SMS_crt0_RST08
;G2GTerminal.c:155: SMS_setTile(sendBuffer[index] + STRING_OFFSET);
	ld	l, -4 (ix)
	ld	h, -3 (ix)
	ld	a, (hl)
	ld	-3 (ix), a
	ld	-4 (ix), a
	xor	a, a
	ld	-3 (ix), a
	ld	a, -4 (ix)
	add	a, #0xe0
	ld	-9 (ix), a
	ld	a, -3 (ix)
	adc	a, #0xff
	ld	-8 (ix), a
	ld	l, -9 (ix)
	ld	h, -8 (ix)
	call	_SMS_crt0_RST18
;G2GTerminal.c:157: index++;
	ld	a, -13 (ix)
	ld	-4 (ix), a
;G2GTerminal.c:158: send_x++;
	ld	a, -12 (ix)
	ld	-3 (ix), a
	jp	00141$
00136$:
;G2GTerminal.c:161: else if (char_x == 14 && char_y == 20) // Handle backspace
	ld	a, -6 (ix)
	sub	a, #0x0e
	jp	NZ,00132$
	ld	a, -17 (ix)
	or	a, a
	jp	Z, 00132$
;G2GTerminal.c:163: if (send_x > 6 || send_y > 15)
	ld	a, #0x0f
	sub	a, -2 (ix)
	ld	a, #0x00
	rla
	ld	-14 (ix), a
	ld	a, #0x06
	sub	a, -3 (ix)
	jr	C,00124$
	ld	a, -14 (ix)
	or	a, a
	jp	Z, 00141$
00124$:
;G2GTerminal.c:165: index--;
	dec	-4 (ix)
;G2GTerminal.c:166: sendBuffer[index] = '\0';
	ld	hl, #0
	add	hl, sp
	ld	-13 (ix), l
	ld	-12 (ix), h
	ld	a, -4 (ix)
	ld	-11 (ix), a
	rla
	sbc	a, a
	ld	-10 (ix), a
	ld	a, -13 (ix)
	add	a, -11 (ix)
	ld	-9 (ix), a
	ld	a, -12 (ix)
	adc	a, -10 (ix)
	ld	-8 (ix), a
	ld	l, -9 (ix)
	ld	h, -8 (ix)
	ld	(hl), #0x00
;G2GTerminal.c:167: send_x--;
	dec	-3 (ix)
;G2GTerminal.c:168: if (send_x < 6 && send_y > 15)
	ld	a, -3 (ix)
	sub	a, #0x06
	jr	NC,00122$
	ld	a, -14 (ix)
	or	a, a
	jr	Z,00122$
;G2GTerminal.c:170: send_x = 25;
	ld	-3 (ix), #0x19
;G2GTerminal.c:171: send_y--;
	dec	-2 (ix)
00122$:
;G2GTerminal.c:173: SMS_setNextTileatXY(send_x, send_y);
	ld	l, -2 (ix)
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, -3 (ix)
	ld	b, #0x00
	add	hl, bc
	add	hl, hl
	ld	a, h
	or	a, #0x78
	ld	h, a
	call	_SMS_crt0_RST08
;G2GTerminal.c:174: SMS_setTile(0);
	ld	hl, #0x0000
	call	_SMS_crt0_RST18
	jr	00141$
00132$:
;G2GTerminal.c:179: if (send_x < 26)
	ld	a, -16 (ix)
	or	a, a
	jr	Z,00141$
;G2GTerminal.c:181: sendBuffer[index] = char_x + 59;
	ld	hl, #0
	add	hl, sp
	ex	de, hl
	ld	a, e
	add	a, -15 (ix)
	ld	c, a
	ld	a, d
	adc	a, -14 (ix)
	ld	b, a
	ld	a, -6 (ix)
	add	a, #0x3b
	ld	(bc), a
;G2GTerminal.c:182: if (char_y == 20)
	ld	a, -17 (ix)
	or	a, a
	jr	Z,00128$
;G2GTerminal.c:183: sendBuffer[index] += 20;
	ld	a, (bc)
	add	a, #0x14
	ld	(bc), a
00128$:
;G2GTerminal.c:184: sendBuffer[index + 1] = '\0';
	ld	a, e
	add	a, -11 (ix)
	ld	e, a
	ld	a, d
	adc	a, -10 (ix)
	ld	d, a
	xor	a, a
	ld	(de), a
;G2GTerminal.c:185: SMS_setNextTileatXY(send_x, send_y);
	push	bc
	ld	l, -9 (ix)
	ld	h, -8 (ix)
	call	_SMS_crt0_RST08
	pop	bc
;G2GTerminal.c:186: SMS_setTile(sendBuffer[index] + STRING_OFFSET);
	ld	a, (bc)
	ld	c, a
	ld	b, #0x00
	ld	hl, #0xffe0
	add	hl, bc
	call	_SMS_crt0_RST18
;G2GTerminal.c:188: index++;
	ld	a, -13 (ix)
	ld	-4 (ix), a
;G2GTerminal.c:189: send_x++;
	ld	a, -12 (ix)
	ld	-3 (ix), a
00141$:
;G2GTerminal.c:192: if (index < 0)
	bit	7, -4 (ix)
	jr	Z,00144$
;G2GTerminal.c:193: index = 0;
	xor	a, a
	ld	-4 (ix), a
00144$:
;G2GTerminal.c:194: if (index > SEND_BUFFER_SIZE)
	ld	a, #0x3d
	sub	a, -4 (ix)
	jp	PO, 00392$
	xor	a, #0x80
00392$:
	jp	P, 00146$
;G2GTerminal.c:195: index = SEND_BUFFER_SIZE;
	ld	-4 (ix), #0x3d
00146$:
;G2GTerminal.c:196: if (send_x > 25)
	ld	a, #0x19
	sub	a, -3 (ix)
	jr	NC,00172$
;G2GTerminal.c:198: if (send_y < 17)
	ld	a, -2 (ix)
	sub	a, #0x11
	jr	NC,00148$
;G2GTerminal.c:200: send_y++;
	inc	-2 (ix)
;G2GTerminal.c:201: send_x = 6;
	ld	-3 (ix), #0x06
	jr	00172$
00148$:
;G2GTerminal.c:204: send_x = 26;
	ld	-3 (ix), #0x1a
	jr	00172$
00159$:
;G2GTerminal.c:207: else if (keyPress & PORT_A_KEY_2) // Send whatever is in our buffer over the link
	bit	5, -8 (ix)
	jr	Z,00172$
;G2GTerminal.c:209: for (int i = 0; i < index; i++)
	ld	hl, #0
	add	hl, sp
	ld	c, l
	ld	b, h
	ld	de, #0x0000
00179$:
	ld	a, -4 (ix)
	ld	l, a
	rla
	sbc	a, a
	ld	h, a
	ld	a, e
	sub	a, l
	ld	a, d
	sbc	a, h
	jp	PO, 00394$
	xor	a, #0x80
00394$:
	jp	P, 00155$
;G2GTerminal.c:211: while ((G2G_StatusPort & G2G_BYTE_SENT) != 0);
00152$:
	in	a, (_G2G_StatusPort)
	rrca
	jr	C,00152$
;G2GTerminal.c:212: G2G_TxPort = sendBuffer[i];
	ld	l, c
	ld	h, b
	add	hl, de
	ld	a, (hl)
	out	(_G2G_TxPort), a
;G2GTerminal.c:209: for (int i = 0; i < index; i++)
	inc	de
	jr	00179$
00155$:
;G2GTerminal.c:215: index = 0;
	xor	a, a
	ld	-4 (ix), a
;G2GTerminal.c:216: sendBuffer[index] = '\0';
	xor	a, a
	ld	(bc), a
;G2GTerminal.c:217: send_x = 6;
	ld	-3 (ix), #0x06
;G2GTerminal.c:218: send_y = 15;
	ld	-2 (ix), #0x0f
;G2GTerminal.c:219: putstring(6, 15, "                    ");
	ld	hl, #___str_3
	push	hl
	ld	de, #0x0f06
	push	de
	call	_putstring
	pop	af
;G2GTerminal.c:220: putstring(6, 16, "                    ");
	ld	hl, #___str_3
	ex	(sp),hl
	ld	de, #0x1006
	push	de
	call	_putstring
	pop	af
;G2GTerminal.c:221: putstring(6, 17, "                    ");
	ld	hl, #___str_3
	ex	(sp),hl
	ld	de, #0x1106
	push	de
	call	_putstring
	pop	af
	pop	af
00172$:
;G2GTerminal.c:224: if (--timer == 0)
	dec	-18 (ix)
	ld	a, -18 (ix)
	or	a, a
	jr	NZ,00174$
;G2GTerminal.c:226: blink = !blink;
	ld	a, -7 (ix)
	xor	a, #0x01
	ld	-7 (ix), a
;G2GTerminal.c:227: timer = BLINKSPEED;
	ld	-18 (ix), #0x0a
00174$:
;G2GTerminal.c:230: if (blink)
	bit	0, -7 (ix)
	jr	Z,00176$
;G2GTerminal.c:232: SMS_addSprite(char_x * 8, char_y * 8, 96);
	ld	a, -5 (ix)
	add	a, a
	add	a, a
	add	a, a
	ld	d, a
	ld	a, -6 (ix)
	add	a, a
	add	a, a
	add	a, a
	ld	b, a
	ld	a, #0x60
	push	af
	inc	sp
	ld	e, b
	push	de
	call	_SMS_addSprite
	pop	af
	inc	sp
00176$:
;G2GTerminal.c:235: SMS_copySpritestoSAT();
	call	_SMS_copySpritestoSAT
;G2GTerminal.c:237: }
	jp	00181$
___str_0:
	.ascii "--------------------"
	.db 0x00
___str_1:
	.ascii "ABCDEFGHIJKLMNOPQRST"
	.db 0x00
___str_2:
	.ascii "UVWXYZ .<"
	.db 0x00
___str_3:
	.ascii "                    "
	.db 0x00
	.area _CODE
__str_4:
	.ascii "thatawesomeguy"
	.db 0x00
__str_5:
	.ascii "G2GTerminal"
	.db 0x00
__str_6:
	.ascii "2021"
	.db 0x00
	.area _INITIALIZER
	.area _CABS (ABS)
	.org 0x7FF0
___SMS__SEGA_signature:
	.db #0x54	; 84	'T'
	.db #0x4d	; 77	'M'
	.db #0x52	; 82	'R'
	.db #0x20	; 32
	.db #0x53	; 83	'S'
	.db #0x45	; 69	'E'
	.db #0x47	; 71	'G'
	.db #0x41	; 65	'A'
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7c	; 124
	.org 0x7FD1
___SMS__SDSC_author:
	.ascii "thatawesomeguy"
	.db 0x00
	.org 0x7FC5
___SMS__SDSC_name:
	.ascii "G2GTerminal"
	.db 0x00
	.org 0x7FC0
___SMS__SDSC_descr:
	.ascii "2021"
	.db 0x00
	.org 0x7FE0
___SMS__SDSC_signature:
	.db #0x53	; 83	'S'
	.db #0x44	; 68	'D'
	.db #0x53	; 83	'S'
	.db #0x43	; 67	'C'
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xd1	; 209
	.db #0x7f	; 127
	.db #0xc5	; 197
	.db #0x7f	; 127
	.db #0xc0	; 192
	.db #0x7f	; 127
