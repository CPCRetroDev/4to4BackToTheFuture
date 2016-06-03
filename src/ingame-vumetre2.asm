ORG &5400

DI
;position courante x,y
CALL &BBC6
push de
push hl

CALL lirelescanaux
CALL afficheVUMETRE

;restaurer la position courante
;(évite le bug avec le rectangle qui entoure le slider)
pop hl
pop de
CALL &BBC0

EI
RET

.blockevenement
ds 10

;stocker les valeurs des 3 canaux (A, B, C)
.valuecanaux
ds 3

.lirelescanaux
            LD B,&03
            LD HL,valuecanaux
.LIRECANAUX 
            PUSH BC
            LD A,B
            ADD &07
            LD C,A
            LD B,&74
            OUT (C),C
            LD B,&76
            IN A,(C)
            OR &C0
            OUT (C),A
            AND &30
            OUT (C),A
            LD BC,&F792
            OUT (C),C
            LD C,A
            PUSH BC
            DEC B
            OR &40
            OUT (C),A
            IN A,(&F4)
            AND &0F
            LD (HL),A
            POP BC
            LD A,&82
            OUT (C),A
            DEC B
            OUT (C),C
            INC HL
            POP BC
            DJNZ LIRECANAUX 
RET


.afficheVUMETRE
;***********************
;*** affiche CANAL A ***
;***********************
;barre 1 - effacer
LD A,2
CALL &BBDE    ;pen 2

LD DE,476     ;x
LD HL,364     ;y
CALL &BBEA    ;plot x,y,2 

LD DE,0       ;x
LD HL,30      ;y
CALL &BBF9    ;drawr x,y,2

;barre 1 - afficher
LD A,1
CALL &BBDE    ;pen 1

LD DE,476     ;x
LD HL,364     ;y
CALL &BBEA    ;plot x,y,1

LD A,(valuecanaux) ;la valeur de notre canal (&00 a &0F)
ADD A,A       ;A*2
LD DE,0       ;x
LD HL,0       ;y
LD L,A        ;y=a
CALL &BBF9    ;drawr x,VOL*2,1


;***********************
;*** affiche CANAL B ***
;***********************
;barre 1 - effacer
LD A,2
CALL &BBDE    ;pen 2

LD DE,476+12     ;x
LD HL,364     ;y
CALL &BBEA    ;plot x,y,2 

LD DE,0       ;x
LD HL,30      ;y
CALL &BBF9    ;drawr x,y,2

;barre 1 - afficher
LD A,1
CALL &BBDE    ;pen 1

LD DE,476+12     ;x
LD HL,364     ;y
CALL &BBEA    ;plot x,y,1

LD A,(valuecanaux+1) ;la valeur de notre canal (&00 a &0F)
ADD A,A       ;A*2
LD DE,0       ;x
LD HL,0       ;y
LD L,A        ;y=a
CALL &BBF9    ;drawr x,VOL*2,1


;***********************
;*** affiche CANAL C ***
;***********************
;barre 1 - effacer
LD A,2
CALL &BBDE    ;pen 2

LD DE,476+24     ;x
LD HL,364     ;y
CALL &BBEA    ;plot x,y,2 

LD DE,0       ;x
LD HL,30      ;y
CALL &BBF9    ;drawr x,y,2

;barre 1 - afficher
LD A,1
CALL &BBDE    ;pen 1

LD DE,476+24     ;x
LD HL,364     ;y
CALL &BBEA    ;plot x,y,1

LD A,(valuecanaux+2) ;la valeur de notre canal (&00 a &0F)
ADD A,A       ;A*2
LD DE,0       ;x
LD HL,0       ;y
LD L,A        ;y=a
CALL &BBF9    ;drawr x,VOL*2,1



RET

