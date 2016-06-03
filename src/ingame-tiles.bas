' CONVIMGCPC for converting the picture to TILES.SCR
'
' INPUT  : TILES.SCR (17 Ko screenshot with the tiles)
' OUTPUT : INGAME.SPR
'
1 spr=&4000
10 OPENOUT"d":MEMORY &3FFF
20 MODE 1:LOAD "tiles.scr",&C000
21 REM
22 REM empty, 4 targets, 4 sliders
23 REM
30 FOR i=0 TO 8:'elements
40 FOR j=0 TO 15:'hauteur
50 FOR k=0 TO 3:'largeur 16px=4 en mode1
60 adr=&C000+i*4+k+(INT(j/8)*&50)+(j MOD 8)*&800
70 a=PEEK(adr):POKE adr,&FF:POKE spr,a
80 spr=spr+1
90 NEXT:NEXT:NEXT
100 REM
110 REM 16 walls
120 REM
1000 FOR i=0 TO 15:'elements
1010 FOR j=0 TO 15:'hauteur
1020 FOR k=0 TO 3:'largeur
1030 adr=&C0A0+i*4+k+(INT(j/8)*&50)+(j MOD 8)*&800
1040 a=PEEK(adr):POKE adr,&FF:POKE spr,a
1050 spr=spr+1
1060 NEXT:NEXT:NEXT
2000 SAVE "ingame.spr",b,&4000,spr-&4000
