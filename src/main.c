#include <gb/gb.h>
#include <stdio.h>
#include <gbdk/font.h>

#include "bg.c"
#include "bgtiles.c"
#include "winmap.c"
#include "tiles.c"


const UBYTE DEBUG = 1;
uint8_t screen_offset[2] = {8, 16};

const unsigned char emptyTilesId[2] = {0x00, 0x25};

const uint8_t GRAVITY = 1;
uint8_t ground_y = 108;


// === Player properties ===
int8_t speed[2];
BYTE jumping;
uint8_t player_pos[2];

uint8_t state = 0;
uint8_t n_states = 2;
UBYTE canChangeState = 1;

void resetPlayerPos(){
    player_pos[0] = 24;
    player_pos[1] = 50;
}

void next_state(){
    if (canChangeState){
        state++;
        if (state+1>n_states){
            state = 0;
        }
        canChangeState = 0;
    }  
}

void set_jumping(UBYTE on){
    jumping = on;
    if (on){        
        draw_win_line(6, 0, "YES");
    } else {
        draw_win_line(6, 0, "NO ");
    }        
    move_win(7, 120);
}

void jump()
{    
    if (jumping==0){        
        set_jumping(1);
        speed[1] = -4;
    }
             
}

void debugColl(uint8_t tile_i, uint8_t tile_j, uint16_t tile_id, char bgc, UBYTE result){
    // DEBUG WINDOW
    char charstub[10];
    // XY
    sprintf(charstub, "X%d", tile_i);   
    draw_win_line(11, 0, "   ");  
    draw_win_line(10, 0, charstub);
    sprintf(charstub, "Y%d", tile_j); 
    draw_win_line(16, 0, "   "); 
    draw_win_line(15, 0, charstub);    
    // TILE ID
    sprintf(charstub, "%d", tile_id); 
    draw_win_line(6, 2, "    ");     
    draw_win_line(6, 2, charstub);
    // BG TILE CHAR
    sprintf(charstub, "%d", bgc); 
    draw_win_line(10, 2, "   ");     
    draw_win_line(10, 2, charstub);
    // IF THERE IS COLLISION
    if (result) {
        // 'empty' tile
        draw_win_line(6, 1, "NO ");
    } else {
        // non-'empty' tile
        draw_win_line(6, 1, "YES");
    }   
}

/**
 * Verify collision with map tileset
 * When coverting from pixel x, y the offset (X: 1 tiles, Y: 2 tiles) is considered
 * x, y: uint8_t coords [pixels]
 * speed: current speed
 * Return:
 * UBYTE 0 - when there is a tile, which considered a blank, e.g. 0x00
 * UBYTE 1 - otherwise
*/
UBYTE checkcollision(uint8_t x, uint8_t y, int8_t speed[2]){    
    
    uint16_t tile_id;
    UBYTE result;
    UBYTE resultx;
    UBYTE resulty;
    uint8_t player_width = 8;
    // offset difference by the player sprite
    // 6 = player_width/2 + step??
    uint8_t od = 6;
    uint8_t t_left = (x + 0 - screen_offset[0]) / 8;
    uint8_t t_right = (x + od - screen_offset[0]) / 8;
    uint8_t t_top = (y + 0 - screen_offset[1]) / 8;
    uint8_t t_bottom = (y + od - screen_offset[1]) / 8;

    uint16_t tid_topleft = t_left + bgWidth*t_top;   
    uint16_t tid_bottomleft = t_left + bgWidth*t_bottom; 
    uint16_t tid_topright = t_right + bgWidth*t_top; 
    uint16_t tid_bottomright = t_right + bgWidth*t_bottom; 

    // OX
    // this does not count right and bottom
    //result = (bg[tid_topleft] == emptyTilesId[0]) || (bg[tid_topleft] == [1]);
    tile_id = t_left;
    resultx = 1;
    if (speed[0] > 0){
        // check right
        tile_id = t_right;
        if (tid_topright != tid_bottomright) {
            // if top and bottom are not in the same tile
            // so check lower tile first IF ITS EMPTY
            resultx = (bg[tid_bottomright] == emptyTilesId[0]) 
            || (bg[tid_bottomright] == emptyTilesId[1]);            
        } 
    } else if (speed[0] < 0) {
        if (tid_topleft != tid_bottomleft) {
            // if top and bottom are not in the same tile
            // so check lower tile first IF ITS EMPTY
            resultx = (bg[tid_bottomleft] == emptyTilesId[0]) 
            || (bg[tid_bottomleft] == emptyTilesId[1]);            
        } 
    }

    // OY
    resulty = 1;
    if (speed[1] > 0){
        // check bottom
        tile_id += bgWidth*t_bottom;
        if (tid_bottomleft != tid_bottomright) {
            // if left and right are not in the same tile
            // so check lower tile first IF ITS EMPTY
            resulty = ((bg[tid_bottomright] == emptyTilesId[0]) 
            || (bg[tid_bottomright] == emptyTilesId[1]))
            && ((bg[tid_bottomleft] == emptyTilesId[0]) 
            || (bg[tid_bottomleft] == emptyTilesId[1]));      
            
        } 
    } else {
        tile_id += bgWidth*t_top;
        if (tid_topleft != tid_topright) {
            // if left and right are not in the same tile
            // so check lower tile first IF ITS EMPTY
            resulty = ((bg[tid_topright] == emptyTilesId[0]) 
            || (bg[tid_topright] == emptyTilesId[1]))
            && ((bg[tid_topleft] == emptyTilesId[0]) 
            || (bg[tid_topleft] == emptyTilesId[1]));     
            
        } 
    }
    result = resultx && resulty
    && ((bg[tile_id] == 0x00) || (bg[tile_id] == 0x25));


    debugColl(t_left, t_top, tile_id, bg[tile_id], result); 
    return !result;
}

void move(uint8_t dt){    

    if (DEBUG){
        // TESTING controls
        if (joypad() & J_LEFT){
            speed[0] = -1;
        } else if (joypad() & J_RIGHT){
            speed[0] = 1;
        } else {
            speed[0] = 0;
        }

        if (joypad() & J_UP){
            speed[1] = -1;
        } else if (joypad() & J_DOWN){
            speed[1] = 1;
        } else {
            speed[1] = 0;
        }
    } else {
        // Moving controls
        if (joypad() & J_LEFT){
            speed[0] = -1;
        } else if (joypad() & J_RIGHT){
            speed[0] = 1;
        } else {
            speed[0] = 0;
        }

        
        if (joypad() & J_UP){
            jump();                
        }
        // fall
        speed[1] += GRAVITY;

        // == Boundaries ==

        // Screen borders
        // Left offset is 8 pixels
        if (player_pos[0] < screen_offset[0]){
            player_pos[0] = screen_offset[0];
            speed[0] = 0;        
        }

        // Ground  
        if (player_pos[1] >= ground_y){
            player_pos[1] = ground_y;
            speed[1] = 0;
            set_jumping(0);
        } else if (player_pos[1]<=ground_y-50){
            // ceil
            player_pos[1] = ground_y-50;
            set_jumping(1);        
        }
    }
    
    // Other controls    
    if (joypad() & J_A){
        resetPlayerPos();             
    }
    if (joypad() & J_B){
        next_state();        
        set_sprite_tile(0,state);               
    } else {
        canChangeState = 1;
    }        

    int8_t dx = speed[0]*dt;
    int8_t dy = speed[1]*dt;    

    if (!checkcollision(player_pos[0]+dx, player_pos[1]+dy, speed)){
        player_pos[0]+=dx;
        player_pos[1]+=dy;
    }
    
    move_sprite(0, player_pos[0], player_pos[1]);

    // === HANDLE BACKGROUND ===
    // dx, dy
    //scroll_bkg(dx, 0);
    //move_bkg(player_pos[0], player_pos[1]);
    
}


void main()
{       
    font_init();
    font_t min_font = font_load(font_min); // 36 tiles!
    font_set(min_font);
    // WINDOW MAP is not transparent
       

    // window and background occupy same tiles in VRAM, thus start with 37
    set_bkg_data(37, 7, groundTiles);
    // x, y, w, h
    // w - width of area to set in tiles (1-32)
    set_bkg_tiles(0, 0, 32, 18, bg);
    SHOW_BKG;
    
    draw_win(); 
    move_win(7, 120);
    SHOW_WIN;
   

    // first_tile, ntiles, src
    set_sprite_data(0, 2, RectTile);
    // Sprite number (nb), tile
    set_sprite_tile(0, 0);
    SHOW_SPRITES;
    
    // INITIAL DATA
    uint8_t dt = 2;
    
    player_pos[0] = 24;
    player_pos[1] = ground_y-24;    
    
    speed[0]=0;
    speed[1]=0;

    set_jumping(0);

    move_sprite(0, player_pos[0], player_pos[1]);

    while(1){
        //printf("%d; ", sys_time);

        // Instead of using a blocking delay() for things such as sprite 
        // animations/etc (which can prevent the rest of the game from 
        // continuing) many times 
        // it's better to use a counter which performs an action 
        // once every N frames. 
        // sys_time may be useful in these cases.
        
        // every secs        
        if (sys_time % 3 == 0){
            //printf("%d-", sys_time & 0x1A);
            move(dt);
        }
        
        // HALTs the CPU and waits for the vertical blank interrupt (VBL) to finish.
        wait_vbl_done();
    }
}