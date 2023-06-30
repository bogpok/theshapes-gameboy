#include <gb/gb.h>
#include <stdio.h>
#include <gbdk/font.h>

#include "bg.c"
#include "bgtiles.c"
#include "winmap.c"
#include "tiles.c"


const UBYTE DEBUG = 1;
const uint8_t GRAVITY = 1;
uint8_t ground_y = 108;


// === Player properties ===
int8_t speed[2];
BYTE jumping;
uint8_t player_pos[2];

uint8_t state = 0;
uint8_t n_states = 2;
UBYTE canChangeState = 1;

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

/**
 * Verify collision with map tileset
 * When coverting from pixel x, y the offset (X: 1 tiles, Y: 2 tiles) is considered
 * x, y: uint8_t coords [pixels]
 * Return:
 * UBYTE 0 - when there is a tile, which considered a blank, e.g. 0x00
 * UBYTE 1 - otherwise
*/
UBYTE checkcollision(uint8_t x, uint8_t y){
    char charstub[10];
    uint8_t tile_i = (x - 8) / 8;
    uint8_t tile_j = (y - 16) / 8;

    uint16_t tile_id = tile_i + bgWidth*tile_j;
    UBYTE result = (bg[tile_id] == 0x00) || (bg[tile_id] == 0x25);
    
    // DEBUG WINDOW
    sprintf(charstub, "X%d", tile_i);   
    draw_win_line(11, 0, "   ");  
    draw_win_line(10, 0, charstub);
    sprintf(charstub, "Y%d", tile_j); 
    draw_win_line(16, 0, "   "); 
    draw_win_line(15, 0, charstub);    
    
    sprintf(charstub, "%d", tile_id); 
    draw_win_line(6, 2, "   ");     
    draw_win_line(6, 2, charstub);

    sprintf(charstub, "%d", bg[tile_id]); 
    draw_win_line(10, 2, "   ");     
    draw_win_line(10, 2, charstub);
    
    if (result) {
        draw_win_line(6, 1, "NO ");
    } else {
        draw_win_line(6, 1, "YES");
    }   
    
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
        if (player_pos[0] < 16){
            player_pos[0] = 16;
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
        //set_sprite_tile(0,1);               
    }
    if (joypad() & J_B){
        next_state();
        
        set_sprite_tile(0,state);               
    } else {
        canChangeState = 1;
    }

    /*  switch(joypad()){            
        case J_A:
            
            break;
        case J_B:
            set_sprite_tile(0,0);
            break;            
    } */    

    int8_t dx = speed[0]*dt;
    if (!checkcollision(player_pos[0]+=dx, player_pos[1]+=speed[1]*dt)){
        player_pos[0]+=dx;
        player_pos[1]+=speed[1]*dt;
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
    set_bkg_tiles(0, 0, 32, 18,bg);
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
    
    player_pos[0] = 16;
    player_pos[1] = ground_y;    
    
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