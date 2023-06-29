#include <string.h>

// What appears on window

char hello[] = "HELLO228";

static inline char chartoRAMInt(char c) {
  // first tile in RAM is blank
  // "0" is 0x01
  // when font is loaded pattern is 0-1-...-9-A-B-...-Z
  // where Z is 0x24 (36)
  int c_int = c + 1; 
  if (c >= '0' && c <= '9') {
		return c_int - '0';
  } else if (c >= 'A' && c <= 'Z') {
    // Ascii A is 41
    // But A starts in RAM at 0x0B
    return c_int - 'A' + 0x0A;
  } else {
    return 0;
  }  
}


/** Params
 * xt: tile position from left
 * yt: line number in tiles
 * text: string of text
*/
void draw_win_line(int8_t xt, int8_t yt, char text[]) {
  uint8_t n = strlen(text); // <string.h>
  for (uint8_t i = 0; i < n; i++)
  {
    //set_win_tiles(xt, yt, 1, 1, chartoRAMIntPoint(text[i]));
    set_win_tile_xy(xt+i, yt, chartoRAMInt(text[i]));
  } 

}

void draw_win(){
  draw_win_line(0, 0, "JUMPING");
  draw_win_line(0, 1, "KY KY");
}

/* End of winmap.C */


