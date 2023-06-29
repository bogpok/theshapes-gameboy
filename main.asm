;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler 
; Version 4.2.2 #13350 (MINGW64)
;--------------------------------------------------------
	.module main
	.optsdcc -msm83
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _move
	.globl _checkcollision
	.globl _jump
	.globl _set_jumping
	.globl _draw_win
	.globl _draw_win_line
	.globl _strlen
	.globl _font_set
	.globl _font_load
	.globl _font_init
	.globl _set_sprite_data
	.globl _set_win_tile_xy
	.globl _set_bkg_tiles
	.globl _set_bkg_data
	.globl _wait_vbl_done
	.globl _joypad
	.globl _ground_y
	.globl _TriaTile
	.globl _RectTile
	.globl _hello
	.globl _groundTiles
	.globl _bg
	.globl _player_pos
	.globl _jumping
	.globl _speed
	.globl _GRAVITY
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_speed::
	.ds 2
_jumping::
	.ds 1
_player_pos::
	.ds 2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_bg::
	.ds 575
_groundTiles::
	.ds 112
_hello::
	.ds 9
_RectTile::
	.ds 32
_TriaTile::
	.ds 16
_ground_y::
	.ds 1
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
;winmap.c:7: static inline char chartoRAMInt(char c) {
;	---------------------------------
; Function chartoRAMInt
; ---------------------------------
_chartoRAMInt:
;winmap.c:12: int c_int = c + 1; 
	ld	c, a
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	rlca
	sbc	a, a
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
;winmap.c:14: return c_int - '0';
;winmap.c:13: if (c >= '0' && c <= '9') {
	ld	a, c
	xor	a, #0x80
	sub	a, #0xb0
	jr	C, 00106$
	ld	e, c
	ld	a,#0x39
	ld	d,a
	sub	a, c
	bit	7, e
	jr	Z, 00131$
	bit	7, d
	jr	NZ, 00132$
	cp	a, a
	jr	00132$
00131$:
	bit	7, d
	jr	Z, 00132$
	scf
00132$:
	jr	C, 00106$
;winmap.c:14: return c_int - '0';
	ld	a, l
	add	a, #0xd0
	ret
00106$:
;winmap.c:15: } else if (c >= 'A' && c <= 'Z') {
	ld	a, c
	xor	a, #0x80
	sub	a, #0xc1
	jr	C, 00102$
	ld	e, c
	ld	a,#0x5a
	ld	d,a
	sub	a, c
	bit	7, e
	jr	Z, 00133$
	bit	7, d
	jr	NZ, 00134$
	cp	a, a
	jr	00134$
00133$:
	bit	7, d
	jr	Z, 00134$
	scf
00134$:
	jr	C, 00102$
;winmap.c:18: return c_int - 'A' + 0x0A;
	ld	a, l
	add	a, #0xc9
	ret
00102$:
;winmap.c:20: return 0;
	xor	a, a
;winmap.c:22: }
	ret
;winmap.c:30: void draw_win_line(int8_t xt, int8_t yt, char text[]) {
;	---------------------------------
; Function draw_win_line
; ---------------------------------
_draw_win_line::
	add	sp, #-7
	ldhl	sp,	#5
	ld	(hl-), a
	ld	(hl), e
;winmap.c:31: uint8_t n = strlen(text); // <string.h>
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	call	_strlen
	pop	hl
	ldhl	sp,	#0
	ld	(hl), e
;winmap.c:32: for (uint8_t i = 0; i < n; i++)
	ldhl	sp,	#6
	ld	(hl), #0x00
00112$:
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#0
	sub	a, (hl)
	jp	NC, 00114$
;winmap.c:35: set_win_tile_xy(xt+i, yt, chartoRAMInt(text[i]));
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#6
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#1
	ld	(hl), a
	ld	a, (hl+)
;winmap.c:12: int c_int = c + 1; 
	ld	(hl-), a
;winmap.c:14: return c_int - '0';
	ld	a, (hl+)
	inc	hl
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
	inc	bc
;winmap.c:13: if (c >= '0' && c <= '9') {
	ld	a, c
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	xor	a, #0x80
	sub	a, #0xb0
	jr	C, 00108$
	ld	e, (hl)
	ld	a,#0x39
	ld	d,a
	sub	a, (hl)
	bit	7, e
	jr	Z, 00147$
	bit	7, d
	jr	NZ, 00148$
	cp	a, a
	jr	00148$
00147$:
	bit	7, d
	jr	Z, 00148$
	scf
00148$:
	jr	C, 00108$
;winmap.c:14: return c_int - '0';
	ldhl	sp,	#3
	ld	a, (hl)
	add	a, #0xd0
	ld	(hl), a
	jr	00110$
00108$:
;winmap.c:15: } else if (c >= 'A' && c <= 'Z') {
	ldhl	sp,	#2
	ld	a, (hl)
	xor	a, #0x80
	sub	a, #0xc1
	jr	C, 00106$
	ld	e, (hl)
	ld	a,#0x5a
	ld	d,a
	sub	a, (hl)
	bit	7, e
	jr	Z, 00149$
	bit	7, d
	jr	NZ, 00150$
	cp	a, a
	jr	00150$
00149$:
	bit	7, d
	jr	Z, 00150$
	scf
00150$:
	jr	C, 00106$
;winmap.c:18: return c_int - 'A' + 0x0A;
	ldhl	sp,	#3
	ld	a, (hl)
	add	a, #0xc9
	ld	(hl), a
	jr	00110$
00106$:
;winmap.c:20: return 0;
	ldhl	sp,	#3
	ld	(hl), #0x00
;winmap.c:35: set_win_tile_xy(xt+i, yt, chartoRAMInt(text[i]));
00110$:
	ldhl	sp,	#6
	ld	a, (hl-)
	add	a, (hl)
	ldhl	sp,	#2
	ld	(hl+), a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl-)
	dec	hl
	ld	e, a
	push	de
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_win_tile_xy
	add	sp, #3
;winmap.c:32: for (uint8_t i = 0; i < n; i++)
	ldhl	sp,	#6
	inc	(hl)
	jp	00112$
00114$:
;winmap.c:38: }
	add	sp, #7
	pop	hl
	pop	af
	jp	(hl)
;winmap.c:40: void draw_win(){
;	---------------------------------
; Function draw_win
; ---------------------------------
_draw_win::
;winmap.c:41: draw_win_line(0, 0, "JUMPING");
	ld	de, #___str_0
	push	de
	xor	a, a
	ld	e, a
	call	_draw_win_line
;winmap.c:42: draw_win_line(0, 1, "KY KY");
	ld	de, #___str_1
	push	de
	ld	e, #0x01
	xor	a, a
	call	_draw_win_line
;winmap.c:43: }
	ret
___str_0:
	.ascii "JUMPING"
	.db 0x00
___str_1:
	.ascii "KY KY"
	.db 0x00
;main.c:18: void set_jumping(BYTE on){
;	---------------------------------
; Function set_jumping
; ---------------------------------
_set_jumping::
	ld	c, a
;main.c:19: jumping = on;
	ld	hl, #_jumping
	ld	(hl), c
;main.c:22: if (on){        
	ld	a, c
	or	a, a
	jr	Z, 00102$
;main.c:23: draw_win_line(8, 0, "1");
	ld	de, #___str_2
	push	de
	ld	e, #0x00
	ld	a, #0x08
	call	_draw_win_line
	jr	00103$
00102$:
;main.c:25: draw_win_line(8, 0, "0");
	ld	de, #___str_3
	push	de
	ld	e, #0x00
	ld	a, #0x08
	call	_draw_win_line
00103$:
;c:/gbdk/include/gb/gb.h:1468: WX_REG=x, WY_REG=y;
	ld	a, #0x07
	ldh	(_WX_REG + 0), a
	ld	a, #0x78
	ldh	(_WY_REG + 0), a
;main.c:28: move_win(7, 120);
;main.c:29: }
	ret
_GRAVITY:
	.db #0x01	; 1
___str_2:
	.ascii "1"
	.db 0x00
___str_3:
	.ascii "0"
	.db 0x00
;main.c:31: void jump()
;	---------------------------------
; Function jump
; ---------------------------------
_jump::
;main.c:33: if (jumping==0){        
	ld	a, (#_jumping)
	or	a, a
	ret	NZ
;main.c:34: set_jumping(1);
	ld	a, #0x01
	call	_set_jumping
;main.c:35: speed[1] = -5;
	ld	hl, #(_speed + 1)
	ld	(hl), #0xfb
;main.c:38: }
	ret
;main.c:40: UBYTE checkcollision(uint8_t x, uint8_t y){
;	---------------------------------
; Function checkcollision
; ---------------------------------
_checkcollision::
	dec	sp
	dec	sp
	ld	c, a
	ldhl	sp,	#1
	ld	(hl), e
;main.c:41: uint8_t tile_i = x / 8;
	ld	b, #0x00
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	bit	7, b
	jr	Z, 00103$
	ld	hl, #0x0007
	add	hl, bc
00103$:
	ld	c, l
	ld	b, h
	sra	b
	rr	c
	sra	b
	rr	c
	sra	b
	rr	c
	ldhl	sp,	#0
;main.c:42: uint8_t tile_j = y / 8;
	ld	a, c
	ld	(hl+), a
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
;	spillPairReg hl
;	spillPairReg hl
	ld	h, b
;	spillPairReg hl
;	spillPairReg hl
	bit	7, b
	jr	Z, 00104$
	ld	hl, #0x0007
	add	hl, bc
00104$:
	ld	c, l
	sra	h
	rr	c
	sra	h
	rr	c
	sra	h
	rr	c
;main.c:43: uint8_t tile_id = bgWidth*tile_i + tile_j;
	ldhl	sp,	#0
	ld	a, (hl)
	swap	a
	rlca
	and	a, #0xe0
	add	a, c
	ld	c, a
;main.c:44: return bg[tile_id] == 0x00;
	ld	hl, #_bg
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	or	a, a
	ld	a, #0x01
	jr	Z, 00116$
	xor	a, a
00116$:
;main.c:45: }
	inc	sp
	inc	sp
	ret
;main.c:47: void move(uint8_t dt){    
;	---------------------------------
; Function move
; ---------------------------------
_move::
	dec	sp
	dec	sp
	ldhl	sp,	#1
	ld	(hl), a
;main.c:50: if (joypad() & J_LEFT){
	call	_joypad
	bit	1, a
	jr	Z, 00105$
;main.c:51: speed[0] = -1;
	ld	hl, #_speed
	ld	(hl), #0xff
	jr	00106$
00105$:
;main.c:52: } else if (joypad() & J_RIGHT){
	call	_joypad
	rrca
	jr	NC, 00102$
;main.c:53: speed[0] = 1;
	ld	hl, #_speed
	ld	(hl), #0x01
	jr	00106$
00102$:
;main.c:55: speed[0] = 0;
	ld	hl, #_speed
	ld	(hl), #0x00
00106$:
;main.c:59: if (joypad() & J_UP){
	call	_joypad
	bit	2, a
	jr	Z, 00108$
;main.c:60: jump();                
	call	_jump
00108$:
;main.c:63: speed[1] += GRAVITY;
	ld	a, (#(_speed + 1) + 0)
	ld	hl, #_GRAVITY
	ld	c, (hl)
	add	a, c
	ld	(#(_speed + 1)),a
;main.c:67: if (joypad() & J_A){
	call	_joypad
	bit	4, a
	jr	Z, 00110$
;c:/gbdk/include/gb/gb.h:1602: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 2)
	ld	(hl), #0x01
;main.c:68: set_sprite_tile(0,1);               
00110$:
;main.c:70: if (joypad() & J_B){
	call	_joypad
	bit	5, a
	jr	Z, 00112$
;c:/gbdk/include/gb/gb.h:1602: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 2)
	ld	(hl), #0x00
;main.c:71: set_sprite_tile(0,0);               
00112$:
;main.c:82: int8_t dx = speed[0]*dt;
	ld	hl, #_speed
	ld	c, (hl)
	ldhl	sp,	#1
	ld	e, (hl)
	ld	a, c
	call	__muluschar
;main.c:83: if (!checkcollision(player_pos[0]+=dx, player_pos[1]+=speed[1]*dt)){
	ld	hl, #(_player_pos + 1)
	ld	b, (hl)
	ld	hl, #(_speed + 1)
	ld	l, (hl)
;	spillPairReg hl
	push	bc
	push	hl
	ldhl	sp,	#5
	ld	e, (hl)
	pop	hl
	ld	a, l
	call	__muluschar
	ld	a, c
	pop	bc
	add	a, b
	ld	b, a
	ld	hl, #(_player_pos + 1)
	ld	(hl), b
	ld	a, (#_player_pos + 0)
	add	a, c
	ldhl	sp,	#0
	ld	(hl), a
	ld	de, #_player_pos
	ld	a, (hl)
	ld	(de), a
	push	bc
	ld	e, b
	ld	a, (hl)
	call	_checkcollision
	pop	bc
	or	a, a
	jr	NZ, 00114$
;main.c:84: player_pos[0]+=dx;
	ld	a, (#_player_pos + 0)
	add	a, c
	ld	(#_player_pos),a
;main.c:85: player_pos[1]+=speed[1]*dt;
	ld	hl, #(_player_pos + 1)
	ld	c, (hl)
	ld	hl, #(_speed + 1)
	ld	b, (hl)
	push	bc
	ldhl	sp,	#3
	ld	e, (hl)
	ld	a, b
	call	__muluschar
	ld	a, c
	pop	bc
	add	a, c
	ld	(#(_player_pos + 1)),a
00114$:
;main.c:94: if (player_pos[0] < 16){
	ld	a, (#_player_pos + 0)
	sub	a, #0x10
	jr	NC, 00116$
;main.c:95: player_pos[0] = 16;
	ld	hl, #_player_pos
	ld	(hl), #0x10
;main.c:96: speed[0] = 0;        
	ld	hl, #_speed
	ld	(hl), #0x00
00116$:
;main.c:83: if (!checkcollision(player_pos[0]+=dx, player_pos[1]+=speed[1]*dt)){
	ld	hl, #(_player_pos + 1)
	ld	c, (hl)
;main.c:100: if (player_pos[1] >= ground_y){
	ld	a, c
	ld	hl, #_ground_y
	sub	a, (hl)
	jr	C, 00120$
;main.c:101: player_pos[1] = ground_y;
	ld	de, #(_player_pos + 1)
	ld	a, (hl)
	ld	(de), a
;main.c:102: speed[1] = 0;
	ld	hl, #(_speed + 1)
	ld	(hl), #0x00
;main.c:103: set_jumping(0);
	xor	a, a
	call	_set_jumping
	jr	00121$
00120$:
;main.c:104: } else if (player_pos[1]<=ground_y-50){
	ld	a, (#_ground_y)
	ld	b, #0x00
	add	a, #0xce
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	ld	a, b
	adc	a, #0xff
	ld	b, a
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	ld	e, h
	ld	d, b
	ld	a, l
	sub	a, c
	ld	a, b
	sbc	a, h
	bit	7, e
	jr	Z, 00177$
	bit	7, d
	jr	NZ, 00178$
	cp	a, a
	jr	00178$
00177$:
	bit	7, d
	jr	Z, 00178$
	scf
00178$:
	jr	C, 00121$
;main.c:106: player_pos[1] = ground_y-50;
	ld	a, (#_ground_y)
	add	a, #0xce
	ld	(#(_player_pos + 1)),a
;main.c:107: set_jumping(1);        
	ld	a, #0x01
	call	_set_jumping
00121$:
;main.c:112: move_sprite(0, player_pos[0], player_pos[1]);
	ld	hl, #(_player_pos + 1)
	ld	c, (hl)
	ld	hl, #_player_pos
	ld	b, (hl)
;c:/gbdk/include/gb/gb.h:1675: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
;c:/gbdk/include/gb/gb.h:1676: itm->y=y, itm->x=x;
	ld	(hl), c
	inc	hl
	ld	(hl), b
;main.c:112: move_sprite(0, player_pos[0], player_pos[1]);
;main.c:117: }
	inc	sp
	inc	sp
	ret
;main.c:120: void main()
;	---------------------------------
; Function main
; ---------------------------------
_main::
;main.c:122: font_init();
	call	_font_init
;main.c:123: font_t min_font = font_load(font_min); // 36 tiles!
	ld	de, #_font_min
	push	de
	call	_font_load
	pop	hl
;main.c:124: font_set(min_font);
	push	de
	call	_font_set
	pop	hl
;main.c:129: set_bkg_data(37, 7, groundTiles);
	ld	de, #_groundTiles
	push	de
	ld	hl, #0x725
	push	hl
	call	_set_bkg_data
	add	sp, #4
;main.c:132: set_bkg_tiles(0, 0, 32, 18,bg);
	ld	de, #_bg
	push	de
	ld	hl, #0x1220
	push	hl
	xor	a, a
	rrca
	push	af
	call	_set_bkg_tiles
	add	sp, #6
;main.c:133: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;main.c:135: draw_win(); 
	call	_draw_win
;c:/gbdk/include/gb/gb.h:1468: WX_REG=x, WY_REG=y;
	ld	a, #0x07
	ldh	(_WX_REG + 0), a
	ld	a, #0x78
	ldh	(_WY_REG + 0), a
;main.c:137: SHOW_WIN;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x20
	ldh	(_LCDC_REG + 0), a
;main.c:141: set_sprite_data(0, 2, RectTile);
	ld	de, #_RectTile
	push	de
	ld	hl, #0x200
	push	hl
	call	_set_sprite_data
	add	sp, #4
;c:/gbdk/include/gb/gb.h:1602: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 2)
	ld	(hl), #0x00
;main.c:144: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;main.c:149: player_pos[0] = 16;
	ld	hl, #_player_pos
	ld	(hl), #0x10
;main.c:150: player_pos[1] = ground_y;    
	ld	bc, #_player_pos + 1
	ld	a, (#_ground_y)
	ld	(bc), a
;main.c:152: speed[0]=0;
	ld	de, #_speed+0
	xor	a, a
	ld	(de), a
;main.c:153: speed[1]=0;
	inc	de
	xor	a, a
	ld	(de), a
;main.c:155: set_jumping(0);
	push	bc
	xor	a, a
	call	_set_jumping
	pop	bc
;main.c:157: move_sprite(0, player_pos[0], player_pos[1]);
	ld	a, (bc)
	ld	b, a
	ld	hl, #_player_pos
	ld	c, (hl)
;c:/gbdk/include/gb/gb.h:1675: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
;c:/gbdk/include/gb/gb.h:1676: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:159: while(1){
00104$:
;main.c:171: if (sys_time % 3 == 0){
	ld	hl, #_sys_time
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	bc, #0x0003
	call	__moduint
	ld	a, b
	or	a, c
	jr	NZ, 00102$
;main.c:173: move(dt);
	ld	a, #0x05
	call	_move
00102$:
;main.c:178: wait_vbl_done();
	call	_wait_vbl_done
;main.c:181: }
	jr	00104$
	.area _CODE
	.area _INITIALIZER
__xinit__bg:
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x28	; 40
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x2b	; 43
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x26	; 38
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
	.db #0x25	; 37
__xinit__groundTiles:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0xf8	; 248
	.db #0x8e	; 142
	.db #0x8e	; 142
	.db #0x82	; 130
	.db #0x82	; 130
	.db #0x82	; 130
	.db #0x82	; 130
	.db #0x3e	; 62
	.db #0x3e	; 62
	.db #0xe6	; 230
	.db #0xe6	; 230
	.db #0xcd	; 205
	.db #0xcd	; 205
	.db #0x09	; 9
	.db #0x09	; 9
	.db #0xe0	; 224
	.db #0xe0	; 224
	.db #0xa2	; 162
	.db #0xa2	; 162
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x09	; 9
	.db #0x09	; 9
	.db #0x1b	; 27
	.db #0x1b	; 27
	.db #0x12	; 18
	.db #0x12	; 18
	.db #0xb6	; 182
	.db #0xb6	; 182
	.db #0xa0	; 160
	.db #0xa0	; 160
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x9b	; 155
	.db #0x9b	; 155
	.db #0x8e	; 142
	.db #0x8e	; 142
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xc1	; 193
	.db #0xc1	; 193
	.db #0x70	; 112	'p'
	.db #0x70	; 112	'p'
	.db #0x90	; 144
	.db #0x90	; 144
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x89	; 137
	.db #0x89	; 137
	.db #0x8b	; 139
	.db #0x8b	; 139
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7b	; 123
	.db #0x7b	; 123
	.db #0xfe	; 254
	.db #0xfe	; 254
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x40	; 64
	.db #0xff	; 255
	.db #0xfe	; 254
	.db #0x01	; 1
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
__xinit__hello:
	.ascii "HELLO228"
	.db 0x00
__xinit__RectTile:
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0xc3	; 195
	.db #0xff	; 255
	.db #0xbd	; 189
	.db #0xff	; 255
	.db #0xa5	; 165
	.db #0xff	; 255
	.db #0xa5	; 165
	.db #0xff	; 255
	.db #0xbd	; 189
	.db #0xff	; 255
	.db #0xc3	; 195
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0x7e	; 126
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x7e	; 126
	.db #0x66	; 102	'f'
	.db #0x7e	; 126
	.db #0x42	; 66	'B'
	.db #0x99	; 153
	.db #0xff	; 255
	.db #0x99	; 153
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0x7e	; 126
__xinit__TriaTile:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x7e	; 126
	.db #0x66	; 102	'f'
	.db #0x7e	; 126
	.db #0x42	; 66	'B'
	.db #0x99	; 153
	.db #0xff	; 255
	.db #0x99	; 153
	.db #0xff	; 255
	.db #0x7e	; 126
	.db #0x7e	; 126
__xinit__ground_y:
	.db #0x6c	; 108	'l'
	.area _CABS (ABS)
