ORG &9FC1
;WRITE "INGAME.RSX"

Hauteur_du_tile  EQU 16

longueur_tableau EQU 16
hauteur_tableau  EQU 11
ecran_tableau    EQU &F0A1
gfx_des_tiles    EQU &9861

niveau_courant   EQU &9EA2

;9FB8 = level le plus haut fini

resultat_target1 EQU &9FB9
resultat_target2 EQU &9FBA
resultat_target3 EQU &9FBB
resultat_target4 EQU &9FBC

resultat_slider1 EQU &9FBD
resultat_slider2 EQU &9FBE
resultat_slider3 EQU &9FBF
resultat_slider4 EQU &9FC0


; ****************************
; *** RSX - INITIALISATION ***
; ****************************
.RSX_Init :
	LD	HL,RSX_Init
	LD	(HL),&C9            ; Ecrire un RET pour empêcher une nouvelle initialisation
	LD	BC,RSX_Commandes    ; BC pointe sur la table des Commandes RSX
	LD	HL,RSX_Tampon       ; HL pointe sur 4 octets libres.
	JP	&BCD1

.RSX_Tampon :
	DEFS	4                   ; Tampon de quatre octets.

.RSX_Commandes :
	DEFW	RSX_Mots_Clefs      ; Adresse des mots clefs
	JP	TILES_AFF
	JP      LEVEL_AFF
	JP      START_AFF
	JP      RESET_SAV
	JP      DECOR_SAV
	JP      DECOR_AFF
	JP      SPRITE_AFF
	JP      LEVEL_CLEAR
	JP      CART_PRS
	JP      CART_INFO
	JP      RECT_INFO
	JP      BOUCHES
	JP      CLS3


.RSX_Mots_Clefs
	DEFB	   "TIL","E"+&80    ; Mot clef avec le bit 7 du dernier caractere a 1.
	DEFB       "LEVE","L"+&80
	DEFB       "STAR","T"+&80
	DEFB       "RESETDAT","A"+&80
	DEFB       "DECORSAV","E"+&80
	DEFB       "DECORAF","F"+&80
        DEFB       "SPRIT","E"+&80
        DEFB       "LEVELCLEA","R"+&80
        DEFB       "CAR","T"+&80
        DEFB       "INF","O"+&80
        DEFB       "REC","T"+&80
        DEFB       "BLABL","A"+&80
        DEFB       "CLS","3"+&80                	
	DEFB       0                ; Fin de la table.

; *********************
; *** LES FONCTIONS ***
; *********************
;syntax |TILE,adresse_ecran,adresse_tiles
.TILES_AFF
        ;lecture valeur adresse_tiles
	LD L,(IX+00)
	LD H,(IX+01)
	;lecture valeur adresse_ecran
	LD E,(IX+02)
	LD D,(IX+03)
.TILES_1
        LD A,Hauteur_du_tile
.TILES_2
        LDI         ;16 pixels = 4 octets en MODE 1
        LDI
        LDI
        LDI
        EX DE,HL
        LD BC,&07FC
        ADD HL,BC
        JR NC,TILES_3
        LD BC,&C050
        ADD HL,BC
.TILES_3
        EX DE,HL
        DEC A
        JR NZ,TILES_2
        RET	

;syntax |LEVEL
.LEVEL_AFF
        ;adresse_niveau
	LD IX,niveau_courant

	LD DE,ecran_tableau
	LD A,hauteur_tableau

.aff_tableau3
	PUSH AF
	PUSH DE 	    ; on sauvegarde l'adresse video de la premiere ligne de sprites a afficher
	LD A,longueur_tableau

.aff_tableau2
	PUSH AF

	LD A,(IX+&00)
	INC IX

	LD L,A
	LD H,0
	ADD HL,HL ; x2
	ADD HL,HL ; x4
	ADD HL,HL ; x8
	ADD HL,HL ; x16
	ADD HL,HL ; x32
	ADD HL,HL ; x64

	LD BC,gfx_des_tiles
	ADD HL,BC

	PUSH DE
	CALL TILES_1
	POP DE

.aff_tableau1
	INC DE      ;Case suivante (decalage de 4 octets sur la droite)
	INC DE
	INC DE
	INC DE

	POP AF
	DEC A
	JR NZ,aff_tableau2

	POP HL
	LD BC,&00A0
	ADD HL,BC
	EX DE,HL   ;Ligne suivante
	POP AF
	DEC A
	JR NZ,aff_tableau3

	RET

;syntax |START,adresse_niveau_dans_le_pack
.START_AFF
        ;lecture valeur adresse_niveau
	LD L,(IX+00)
	LD H,(IX+01)
	LD DE,niveau_courant
	LD BC,176   ;16x11
	LDIR        ;transfeert des données
	
	;affichage du niveau
	;CALL LEVEL_AFF
	
	;calcul positions target et slider
	;suppression des valeurs des sliders dans le tableau
	LD HL,niveau_courant
	LD C,176 ;16x11
.LOOPCHECK
	LD A,(HL)
	PUSH HL
	CP &01
	CALL Z,TARGET1
	CP &02
	CALL Z,TARGET2
	CP &03
	CALL Z,TARGET3
	CP &04
	CALL Z,TARGET4
	CP &05
	CALL Z,SLIDER1
	CP &06
	CALL Z,SLIDER2
	CP &07
	CALL Z,SLIDER3
	CP &08
	CALL Z,SLIDER4
	DEC C
	POP HL
	INC HL
	JR NZ,LOOPCHECK
	
	;affichage du niveau
	LD HL,niveau_courant
	LD DE,niveau_courant        	
	CALL LEVEL_AFF	
	
	RET	
.TARGET1
        ;position
        LD a,c
	LD (resultat_target1),a
	XOR A
	RET
.TARGET2
        ;position
        LD a,c
	LD (resultat_target2),a
	XOR A	
	RET
.TARGET3
        ;position
        LD a,c
	LD (resultat_target3),a
	XOR A	
	RET
.TARGET4
        ;position
        LD a,c
	LD (resultat_target4),a
	XOR A	
	RET
.SLIDER1
        ;position
        LD a,c
	LD (resultat_slider1),a
        ;mise a zéro
        XOR A
        LD (HL),a       	
	RET
.SLIDER2
        ;position
        LD a,c
	LD (resultat_slider2),a
        ;mise a zéro
        XOR A
        LD (HL),a
	RET
.SLIDER3
        ;position
        LD a,c
	LD (resultat_slider3),a
        ;mise a zéro
        XOR A
        LD (HL),a
	RET
.SLIDER4
        ;position
        LD a,c
	LD (resultat_slider4),a
        ;mise a zéro
        XOR A
        LD (HL),a
	RET        	

;syntax |RESETDATA
.RESET_SAV
       LD HL,&9F53
       LD DE,&9F54
       LD BC,100 ;101 valeurs
       LD (HL),0
       LDIR
       RET
       
;syntax |LEVELCLEAR
.LEVEL_CLEAR
       LD HL,niveau_courant
       LD DE,niveau_courant+1
       LD BC,(16*11)-1
       LD (HL),0
       LDIR
       RET       

;*****************************
;*** gestion des 4 sprites ***
;*****************************
.fond_Tampon1 :
	DEFS	64                   ; MODE 1 : 16px*16px = 4*16 = 64 octets 
.fond_Tampon2 :
	DEFS	64
.fond_Tampon3 :
	DEFS	64
.fond_Tampon4 :
	DEFS	64 

.DECOR_SAV
;syntax |DECORSAVE,slider,adresse_ecran
        ;lecture slider
	LD A,(IX+02)
        ;lecture adresse_ecran
	LD E,(IX+00)
	LD D,(IX+01)

        ;HL adresse pour sauver
	CP &05
	CALL Z,FOND_SLIDER1
	CP &06
	CALL Z,FOND_SLIDER2
	CP &07
	CALL Z,FOND_SLIDER3
	CP &08
	CALL Z,FOND_SLIDER4

	LD A,Hauteur_du_tile
	EX DE,HL	

.sauver_fond1
	LDI ; 16 pixels = 4 octets en MODE 1
	LDI
	LDI
	LDI
	LD BC,&7FC
	ADD HL,BC
	JR NC,sauver_fond2
	LD BC,&C050
	ADD HL,BC
	
.sauver_fond2
	DEC A
	JR NZ,sauver_fond1
	RET


.DECOR_AFF
;syntax |DECORAFF,slider,adresse_ecran
        ;lecture slider
	LD A,(IX+02)
        ;lecture adresse_ecran
	LD E,(IX+00)
	LD D,(IX+01)

        ;HL adresse pour sauver
	CP &05
	CALL Z,FOND_SLIDER1
	CP &06
	CALL Z,FOND_SLIDER2
	CP &07
	CALL Z,FOND_SLIDER3
	CP &08
	CALL Z,FOND_SLIDER4
	
	LD A,Hauteur_du_tile
	
.restore_fond1
	LDI ; 16 pixels = 4 octets en MODE 1
	LDI
	LDI
	LDI
	EX DE,HL
	LD BC,&7FC
	ADD HL,BC
	JR NC,restore_fond2
	LD BC,&C050
	ADD HL,BC
	
.restore_fond2
	EX DE,HL
	DEC A
	JR NZ,restore_fond1
	RET	

.FOND_SLIDER1
        LD HL,fond_Tampon1
        RET
.FOND_SLIDER2
        LD HL,fond_Tampon2
        RET
.FOND_SLIDER3
        LD HL,fond_Tampon3
        RET
.FOND_SLIDER4
        LD HL,fond_Tampon4
        RET         
        
        
        
;syntax |SPRITE,slider(adresse_memoire),adresse_ecran
.SPRITE_AFF        
	;lecture valeur adresse_ecran
	LD E,(IX+02)
	LD D,(IX+03)
        ;lecture valeur adresse_tiles/sprite
	LD L,(IX+00)
	LD H,(IX+01)

	;EX DE,HL ; en inversant HL et DE, on peut gagner sur le calcul final de ligne suivante.
	LD A,Hauteur_du_tile

.aff_sp0
        DI        ;desactiver les interruptions (a cause du EX AF,AF')
	EX AF,AF'

; traitement premier octet
	LD A,(DE)
	LD B,A
	AND &88 ; pixel 4
	JR NZ,aff_sp11
	LD A,(HL)
	AND &88
.aff_sp11
	LD C,A  ; on sauvegarde dans C le pixel traite
	
	LD A,B
	AND &44
	JR NZ,aff_sp12
	LD A,(HL)
	AND &44
.aff_sp12
	ADD A,C
	LD C,A

	LD A,B
	AND &22
	JR NZ,aff_sp13
	LD A,(HL)
	AND &22
.aff_sp13
	ADD A,C
	LD C,A

	LD A,B
	AND &11
	JR NZ,aff_sp14
	LD A,(HL)
	AND &11
.aff_sp14
	ADD A,C
	LD (HL),A ; on poke en memoire video le resultat final

	INC HL
	INC DE

; traitement deuxieme octet
	LD A,(DE)
	LD B,A
	AND &88 ; pixel 4
	JR NZ,aff_sp21
	LD A,(HL)
	AND &88
.aff_sp21
	LD C,A  ; on sauvegarde dans C le pixel traite
	
	LD A,B
	AND &44
	JR NZ,aff_sp22
	LD A,(HL)
	AND &44
.aff_sp22
	ADD A,C
	LD C,A

	LD A,B
	AND &22
	JR NZ,aff_sp23
	LD A,(HL)
	AND &22
.aff_sp23
	ADD A,C
	LD C,A

	LD A,B
	AND &11
	JR NZ,aff_sp24
	LD A,(HL)
	AND &11
.aff_sp24
	ADD A,C
	LD (HL),A ; on poke en memoire video le resultat final

	INC HL
	INC DE

; traitement troisieme octet
	LD A,(DE)
	LD B,A
	AND &88 ; pixel 4
	JR NZ,aff_sp31
	LD A,(HL)
	AND &88
.aff_sp31
	LD C,A  ; on sauvegarde dans C le pixel traite
	
	LD A,B
	AND &44
	JR NZ,aff_sp32
	LD A,(HL)
	AND &44
.aff_sp32
	ADD A,C
	LD C,A

	LD A,B
	AND &22
	JR NZ,aff_sp33
	LD A,(HL)
	AND &22
.aff_sp33
	ADD A,C
	LD C,A

	LD A,B
	AND &11
	JR NZ,aff_sp34
	LD A,(HL)
	AND &11
.aff_sp34
	ADD A,C
	LD (HL),A ; on poke en memoire video le resultat final

	INC HL
	INC DE

; traitement quatrieme octet
	LD A,(DE)
	LD B,A
	AND &88 ; pixel 4
	JR NZ,aff_sp41
	LD A,(HL)
	AND &88
.aff_sp41
	LD C,A  ; on sauvegarde dans C le pixel traite
	
	LD A,B
	AND &44
	JR NZ,aff_sp42
	LD A,(HL)
	AND &44
.aff_sp42
	ADD A,C
	LD C,A

	LD A,B
	AND &22
	JR NZ,aff_sp43
	LD A,(HL)
	AND &22
.aff_sp43
	ADD A,C
	LD C,A

	LD A,B
	AND &11
	JR NZ,aff_sp44
	LD A,(HL)
	AND &11
.aff_sp44
	ADD A,C
	LD (HL),A ; on poke en memoire video le resultat final

	INC DE

	LD BC,&7FD
	ADD HL,BC
	JR NC,aff_sp5
	LD BC,&C050
	ADD HL,BC

aff_sp5	EX AF,AF'
	DEC A
	JP NZ,aff_sp0
	EI           ;réactiver les interruptions
	RET

;syntax |CART
.CART_PRS
         LD DE,&F8AD
         LD HL,&9C21 
         CALL TILES_1 ;coin haut gauche

         LD DE,&F14D
         LD HL,&9DA1 
         CALL TILES_1 ;coin bas gauche
         
         LD DE,&F8CD
         LD HL,&9B61 
         CALL TILES_1 ;coin haut droit

         LD DE,&F16D
         LD HL,&9CE1 
         CALL TILES_1 ;coin bas droit

         ;Utilisation de la zone graphique comme d'un FILL
         ;bord gauche et droit 
         ld de,130 
         ld hl,368
         call #BBCF 
         ;bord haut et bas 
         ld de,351
         ld hl,294 
         call #BBD2 
         ;couleur du paper 
         ld a,2 
         call #BBE4 
         ;cls fenetre graphique 
         call #BBDB
         
         ;parametre par defaut pour la zone graphique
         ;bord gauche et droit
         ld de,0
         ld hl,640
         call #BBCF
         ;bord haut et bas
         ld de,0
         ld hl,400
         call #BBD2
         
         ;refaire le trait blanc
         ;PEN 1
         ld a,1
         call #BBDE
         ;plot
         ld de,128 ;x
         ld hl,344 ;y
         call #BBEA
         ;draw
         ld de,374
         ld hl,344
         call #BBF6

         ;plot
         ld de,128 ;x
         ld hl,346 ;y
         call #BBEA
         ;draw
         ld de,374
         ld hl,346
         call #BBF6                            

         ;plot
         ld de,128 ;x
         ld hl,348 ;y
         call #BBEA
         ;draw
         ld de,374
         ld hl,348
         call #BBF6
                                         
         RET

;syntax |INFO
.CART_INFO         
         LD DE,&F329
         LD HL,&9BA1
         CALL TILES_1 ;coin gauche

         LD DE,&F355
         LD HL,&9AE1 
         CALL TILES_1 ;coin droit
         
         ;Utilisation de la zone graphique comme d'un FILL
         ;bord gauche et droit 
         ;104;225
         ;423;198
         ld de,104 
         ld hl,423
         call #BBCF 
         ;bord haut et bas 
         ld de,225
         ld hl,198 
         call #BBD2 
         ;couleur du paper 
         ld a,2 
         call #BBE4 
         ;cls fenetre graphique 
         call #BBDB
         
         ;parametre par defaut pour la zone graphique
         ;bord gauche et droit
         ld de,0
         ld hl,640
         call #BBCF
         ;bord haut et bas
         ld de,0
         ld hl,400
         call #BBD2         
         
         RET
         
;syntax |RECT         
.RECT_INFO
         ;Utilisation de la zone graphique comme d'un FILL
         ;bord gauche et droit 
         ld de,148-16
         ld hl,366+16
         call #BBCF 
         ;bord haut et bas 
         ld de,160
         ld hl,238 
         call #BBD2 
         ;couleur du paper 
         ld a,0 ;NOIR 
         call #BBE4 
         ;cls fenetre graphique 
         call #BBDB
         
         ;Utilisation de la zone graphique comme d'un FILL
         ;bord gauche et droit 
         ld de,148-8
         ld hl,366+8
         call #BBCF 
         ;bord haut et bas 
         ld de,160+8
         ld hl,238-8 
         call #BBD2 
         ;couleur du paper 
         ld a,3 ;BLEU 
         call #BBE4 
         ;cls fenetre graphique 
         call #BBDB         

         ;Utilisation de la zone graphique comme d'un FILL
         ;bord gauche et droit 
         ld de,148
         ld hl,366
         call #BBCF 
         ;bord haut et bas 
         ld de,160+16
         ld hl,238-16 
         call #BBD2 
         ;couleur du paper 
         ld a,1 ;BLANC 
         call #BBE4 
         ;cls fenetre graphique 
         call #BBDB
         
         ;Utilisation de la zone graphique comme d'un FILL
         ;bord gauche et droit 
         ld de,148+8
         ld hl,366-8
         call #BBCF 
         ;bord haut et bas 
         ld de,160+24
         ld hl,238-24 
         call #BBD2 
         ;couleur du paper 
         ld a,3 ;BLEU 
         call #BBE4 
         ;cls fenetre graphique 
         call #BBDB
         
         ;parametre par defaut pour la zone graphique
         ;bord gauche et droit
         ld de,0
         ld hl,640
         call #BBCF
         ;bord haut et bas
         ld de,0
         ld hl,400
         call #BBD2 
         
         RET                                      

;syntax |BLABLA
.valbouche
DEFB       0
.BOUCHES
        LD A,(valbouche)
	CP &00
	CALL Z,BOUCHE1
	CP &01
	CALL Z,BOUCHE2
        RET
.BOUCHE1
        ;changer 8 valeurs
        LD A,&0F
        LD (&E3B8),A
        LD (&E3B9),A
        LD (&FBB8),A
        LD (&FBB9),A        
        LD A,&F0        
        LD (&EBB8),A
        LD (&F3B8),A
        LD A,&E1
        LD (&EBB9),A
        LD (&F3B9),A
        ;on change pour le prochain appel
        LD A,1
        LD (valbouche),A
        ;en sortant de cette sous-routine on évite d'aller dans la suivante
        LD A,7
        RET                        
.BOUCHE2
        ;changer 8 valeurs
        LD A,&F0
        LD (&E3B8),A
        LD (&FBB8),A
        LD A,&E1
        LD (&E3B9),A
        LD (&FBB9),A
        XOR A        
        LD (&EBB8),A
        LD (&F3B8),A
        LD A,&01
        LD (&EBB9),A
        LD (&F3B9),A
        ;on change pour le prochain appel
        XOR A
        LD (valbouche),A
        RET 

;syntax |CLS3
;petit effet pour vider l'écran du dernier niveau             
.CLS3
        LD HL,&C000
        LD BC,&4000
clsloop2:
         LD (HL),&FF;remplir avec l'encre 3 (bleu)
         LD DE,&0059
         ADD HL,DE
         JR NC,clsloop1
         LD DE,&C000
         ADD HL,DE
clsloop1:
         DEC BC
         LD A,B
         OR C
         JR NZ,clsloop2
         RET
        
