#include <gb/gb.h>
#include <stdio.h>
#include <gbdk/font.h>

#include "bg.c"
#include "bgtiles.c"
#include "winmap.c"
#include "tiles.c"

int8_t speed[2];
BYTE jumping;

uint8_t player_pos[2];

const uint8_t GRAVITY = 1;
uint8_t ground_y = 108;

void set_jumping(BYTE on){
    jumping = on;
    
    
    if (on){        
        draw_win_line(8, 0, "1");
    } else {
        draw_win_line(8, 0, "0");
    }    
    
    move_win(7, 120);
}

void jump()
{    
    if (jumping==0){        
        set_jumping(1);
        speed[1] = -5;
    }
             
}

UBYTE checkcollision(uint8_t x, uint8_t y){
    uint8_t tile_i = x / 8;
    uint8_t tile_j = y / 8;
    uint8_t tile_id = bgWidth*tile_i + tile_j;
    return bg[tile_id] == 0x00;
}

void move(uint8_t dt){    

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

        
    // Other controls    
    if (joypad() & J_A){
        set_sprite_tile(0,1);               
    }
    if (joypad() & J_B){
        set_sprite_tile(0,0);               
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
    

    
    move_sprite(0, player_pos[0], player_pos[1]);
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
    uint8_t dt = 5;
    
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