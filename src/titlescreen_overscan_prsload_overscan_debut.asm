ORG #A300

DI

;MODE 1
LD A,1
CALL &BC0E

;largeur a zero (masque l'écran)
LD BC,&BC01
OUT (C),C
LD BC,&BD00
OUT (C),C

;BORDER 11 (Bleu)
LD BC,&0B0B
CALL &BC38

;INK 0,0 (Noir)
XOR A
LD BC,&0000
CALL &BC32

;INK 1,11 (Bleu)
LD A,1
LD BC,&0B0B
CALL &BC32

;INK 2,15 (Orange)
LD A,2
LD BC,&0F0F
CALL &BC32

;INK 3,26 (Blanc)
LD A,3
LD BC,&1A1A
CALL &BC32

;chargement du fichier
LD B,&0C
LD HL,fichier_overscan
LD DE,&C000
CALL &BC77
;LD HL,&01FE ;normal
LD HL,&01F0 ;version compressée
CALL &BC83

CALL &55C6 ;décompression

;correction du soucis de compression avec Zenith 2 (1er octet de mangé)
LD a,&F0
LD (&01FE),a

;correction du problème avec convimgcpc (overscan FIN)
LD A,&F1
LD (&07FE),a
LD (&07FF),a
LD A,&F4
LD (&0FFE),a
LD (&0FFF),a
LD A,&F1
LD (&17FE),a
LD (&17FF),a
LD A,&F4
LD (&1FFE),a
LD (&1FFF),a
LD A,&F1
LD (&27FE),a
LD (&27FF),a
LD A,&F4
LD (&2FFE),a
LD (&2FFF),a
LD A,&F1
LD (&37FE),a
LD (&37FF),a
LD A,&F4
LD (&3FFE),a
LD (&3FFF),a

;OUT overscan
;largeur
LD BC,&BC01
OUT (C),C
LD BC,&BD30
OUT (C),C

;hauteur
LD BC,&BC06
OUT (C),C
;LD BC,&BD22
LD BC,&BD00
OUT (C),C

;decalage horizontal
LD BC,&BC02
OUT (C),C
LD BC,&BD32
OUT (C),C

;decalage vertical
LD BC,&BC07
OUT (C),C
LD BC,&BD23
OUT (C),C

;ecran 32 ko (&000 a &7FFF)
LD BC,&BC0C
OUT (C),C
LD BC,&BD0C
OUT (C),C

;debut offset (en &01FE)
LD BC,&BC0D
OUT (C),C
LD BC,&BDFF
OUT (C),C


;animation sur la hauteur R6 = 0 a 34
LD BC,&BC06
OUT (C),C
LD B,&BD

LD A,34
LD C,0
OUT (C),C

.anim2
INC C
OUT (C),C

;ralentissement
CALL &BD19
CALL &BD19
CALL &BD19
CALL &BD19
CALL &BD19
CALL &BD19
CALL &BD19
CALL &BD19

DEC A
CP 0
JP NZ,anim2


;attente de l'appuie d'une touche
CALL &BB06


;animation sur la largeur R1 = 48 a 0
LD BC,&BC01
OUT (C),C
LD B,&BD

LD A,47
LD C,47
OUT (C),C

.anim1
DEC C
OUT (C),C

;ralentissement
CALL &BD19
CALL &BD19
CALL &BD19
CALL &BD19

DEC A
CP 0
JP NZ,anim1



;OUT normal
;largeur
LD BC,&BC01
OUT (C),C
LD BC,&BD28
OUT (C),C

;hauteur
LD BC,&BC06
OUT (C),C
LD BC,&BD19
OUT (C),C

;decalage horizontal
LD BC,&BC02
OUT (C),C
LD BC,&BD2E
OUT (C),C

;decalage vertical
LD BC,&BC07
OUT (C),C
LD BC,&BD1E
OUT (C),C

;ecran 17 ko (&C00 a &FFFF)
LD BC,&BC0C
OUT (C),C
LD BC,&BD3C
OUT (C),C

;debut offset (en &C000)
LD BC,&BC0D
OUT (C),C
LD BC,&BD00
OUT (C),C

;vider la mémoire
LD HL,&01FE
LD DE,&01FF
LD BC,&8000
LD (HL),0
LDIR

EI

RET


fichier_overscan :
;DEFM "OVER1   .SCR" ;normal 32 ko
DEFM "OVER1   .SCA" ;compressée 22 ko
