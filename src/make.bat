c:\gbdk\bin\lcc -Wa-l -Wl-m -Wl-j -DUSE_SFR_FOR_REG -c -o main.o main.c
c:\gbdk\bin\lcc -Wa-l -Wl-m -Wl-j -DUSE_SFR_FOR_REG -o main.gb main.o
ren main.gb theshapes.gb
move ./theshapes.gb ../theshapes.gb
del *.asm *.ihx *.lst *.map *.noi *.p *.o *.sym