
;Ubicación de los pines de EN y RS en Miuva
#define LCD_EN   PORTD,4
#define LCD_RS   PORTD,5

;CBLOCK  0x020
	
;ENDC
 
    
;*****************************************************************************;
;Ejemplo de envío de instrucción					      ;
;									      ;
;   RS	    _________________________	1: DATOS | 0: INSTRUCCIONES	      ;
;									      ;   
;   RW	    _________________________	1: LECTURA  |	0: ESCRITURA          ;
;		  ___      ___                                                ;
;   EN	    _____/   \____/   \______	LEE EN FLANCOS DE BAJADA              ;
;									      ;
;	    _________________________					      ;
;   D7:D4   ___/_4 MSB_\/_4_LSB_\____	PARA ENVIAR LOS 8 BITS DE INSTRUCCION ;
;					PRIMERO SE ENVIAN LOS 4 MÁS           ;
;					SIGNIFICATIVOS Y POSTERIORMENTE LOS   ;
;					4 MENOS SIGNIFICATIVOS                ;
;									      ;
;*****************************************************************************;
;Se carga D7:D4 de la LCD en los bits D3:D0 de Miuva    

;*****************************************************************************;
;				    LCD_Init				      ;
;   Inicializa la LCD, esta función se debe ejecutar antes de cualquier otra  ;
;   que involucre el uso de la LCD.					      ;
;									      ;
;   Ejemplo de uso:							      ;
;	call    LCD_Init						      ;
;								              ;
;*****************************************************************************;

LCD_Init    
    BANKSEL PORTD
    BCF     LCD_EN		;Enable = LOW
    CALL    Delay15ms		
    BANKSEL PORTD
    BCF     LCD_RS		;RS = LOW
    
    ;Inicia secuencia de inicialización
    ;Function set
    BANKSEL PORTD
    MOVLW   b'00000011'	;Carga el valor del puerto D
    MOVWF   PORTD	;Manda el valor al puerto
    BSF	    LCD_EN	;Activa el bit de ENABLE
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay4_1ms
	
    ;Function set
    BANKSEL PORTD
    MOVLW   b'00000011'
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN	;Lee Function set
    CALL    Delay100us
	
    ;Function set
    BANKSEL PORTD
    MOVLW   b'00000011'
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN	;Lee Function set
    CALL    Delay4_1ms
    
    ;Function set
    BANKSEL PORTD
    MOVLW   b'00000010'
    MOVWF PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN	;Lee Function set
    CALL    Delay4_1ms
	
    ;Function set
    BANKSEL PORTD
    movlw   b'00000010' ;MSB Función set
    movwf   PORTD
    bsf	    LCD_EN
    CALL    Delay100us
    bcf	    LCD_EN	
    CALL    Delay4_1ms
    movlw   b'00001110' ;LSB Función set
    movwf   PORTD
    bsf	    LCD_EN
    CALL    Delay100us
    bcf	    LCD_EN	
    CALL    Delay4_1ms
	
    ;Display off
    BANKSEL PORTD
    movlw   b'00000000'	;MSB Funcion display
    movwf   PORTD
    bsf	    LCD_EN
    CALL    Delay100us
    bcf	    LCD_EN	
    CALL    Delay4_1ms
    movlw   b'00001000'	;LSB Funcion display
    movwf   PORTD
    bsf	    LCD_EN
    CALL    Delay100us
    bcf	    LCD_EN	
    CALL    Delay4_1ms
	
    ;Display clear
    BANKSEL PORTD
    movlw   b'00000000'	;MSB Funcion clear
    movwf   PORTD
    bsf	    LCD_EN
    CALL    Delay100us
    bcf	    LCD_EN	
    call    Delay4_1ms
    movlw   b'00000001'	;LSB Funcion clear
    movwf   PORTD
    bsf	    LCD_EN
    CALL    Delay100us
    bcf	    LCD_EN	
    call    Delay4_1ms

    ;Entry mode set
    BANKSEL PORTD
    movlw   b'00000000'	;MSB Funcion mode set
    movwf   PORTD
    bsf	    LCD_EN
    call    Delay100us
    bcf	    LCD_EN	
    call    Delay4_1ms
    movlw   b'00000110'	;LSB Funcion mode set
    movwf   PORTD
    bsf	    LCD_EN
    call    Delay100us
    bcf	    LCD_EN	
    call    Delay4_1ms
	
    ;DDRAM ACCES
    BANKSEL PORTD
    movlw   b'00001000'	;MSB DDRAM Access
    movwf   PORTD
    bsf	    LCD_EN
    call    Delay100us
    bcf	    LCD_EN	
    call    Delay4_1ms
    movlw   b'00000000'	;LSB DDRAM Access
    movwf   PORTD
    bsf	    LCD_EN
    call    Delay100us
    bcf	    LCD_EN	
    call    Delay4_1ms
	
    ;Display on
    BANKSEL PORTD
    movlw   b'00000000'	;MSB Display ON
    movwf   PORTD
    bsf	    LCD_EN
    call    Delay100us
    bcf	    LCD_EN	
    call    Delay4_1ms
    movlw   b'00001100'	;LSB Display ON
    movwf   PORTD
    bsf	    LCD_EN
    call    Delay100us
    bcf	    LCD_EN	
    call    Delay4_1ms
	
    return
    
;*****************************************************************************;
;   Ejemplo de envío del caracter H
;   Ubicación del caracter H: 0100 1000
;   Se tiene que enviar primero 0100 y posteriormente 1000
;   1. NIBBLE almacena el valor 0100 1000
;   2. Intercambia los nibbles y los almacena en W -> W = 0100 
;   3. Realiza una AND con 0x0F para tener solamente 4 bits
;	W = 0000 0100
;   4. Le suma 00100000 para habilitar RS como datos -> W = 0010 0100
;   5. Se envía a la LCD (PUERTO D)
;   6. Mueve al registro de trabajo la variable NIBBLE -> W = 0100 1000
;   7. Realiza una AND con 0x0F para tener solamente 4 bits
;	W = 0000 1000
;   8. Le suma 00100000 para habilitar RS como datos -> W = 0010 1000
;   9. Se envía a la LCD (PUERTO D)
;******************************************************************************;
    
;*****************************************************************************;
;				    LCD_Char				      ;
;   Imprime cualquier caracter en la posición actual de la LCD.		      ;
;									      ;
;   Ejemplo de uso:							      ;
;	movlw	'H'		;Caracter a escribir			      ;
;	call    LCD_Char						      ;
;								              ;
;*****************************************************************************;
LCD_Char
    BANKSEL PORTD
    bsf	    LCD_RS	;Se enviará un dato
    movwf   NIBBLE	;Almacenamos el valor en la variable NIBBLE
    swapf   NIBBLE,w	;Intercambia los NIBBLE
    andlw   0x0F	;AND con 0x0F
    addlw   b'00100000'	;Suma 00100000
    movwf   PORTD	;Se envía al puerto D
    bsf	    LCD_EN	;ENABLE = HIGH
    call    Delay100us
    bcf	    LCD_EN	;ENABLE = LOW
    call    Delay4_1ms
    movf    NIBBLE,w	;Mueve la variable NIBBLE a W
    andlw   0x0F	;AND con 0x0F
    addlw   b'00100000'	;Suma 00100000
    movwf   PORTD	;Se envía al puerto D
    bsf	    LCD_EN	;ENABLE = HIGH
    call    Delay100us
    bcf	    LCD_EN	;ENABLE = LOW
    call    Delay4_1ms
    return	
    
;*****************************************************************************;
;				    LCD_Clear				      ;
;   Limpia todo lo que está escrito en la LCD y posteriormente regresa el     ;
;   cursor a Home.
;									      ;
;   Ejemplo de uso:							      ;
;	call    LCD_Clear						      ;
;								              ;
;*****************************************************************************;
LCD_Clear
    BANKSEL PORTD
    bcf	    LCD_RS
    movlw	b'00000000'
    movwf	PORTD
    bsf	LCD_EN
    call	Delay100us
    bcf	LCD_EN	
    call	Delay4_1ms
    movlw	b'00000001'
    movwf	PORTD
    bsf	LCD_EN
    call	Delay100us
    bcf	LCD_EN	
    call	Delay4_1ms
    return
    
;*****************************************************************************;
;				    LCD_Home				      ;
;   Envia el cursor a la posición inicial de la LCD			      ;
;									      ;
;   Ejemplo de uso:							      ;
;	call    LCD_Home						      ;
;								              ;
;*****************************************************************************;
LCD_Home
    BANKSEL PORTD
    bcf	    LCD_RS
    movlw	b'00000000'
    movwf	PORTD
    bsf	LCD_EN
    call	Delay100us
    bcf	LCD_EN	;Lee Function set
    call	Delay4_1ms
    movlw	b'00000010'
    movwf	PORTD
    bsf	LCD_EN
    call	Delay100us
    bcf	LCD_EN	;Lee Function set
    call	Delay4_1ms
    return
   
;*****************************************************************************;
;				    LCD_GoTo				      ;
;   Inicializa la LCD, esta función se debe ejecutar antes de cualquier otra  ;
;   que involucre el uso de la LCD.					      ;
;									      ;
;   Ejemplo de uso:							      ;
;	movlw	0x03	    ;Posición de la LCD		        	      ;
;       call    LCD_GoTo						      ;
;								              ;
;*****************************************************************************;
;			POSICIONES DE LA LCD 2X16			      ;
;									      ;
;          00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F                    ;
;	   40 41 42 43 44 45 46 47 48 49 4A 4B 4C 4D 4E 4F                    ;
;									      ;
;*****************************************************************************;
LCD_GoTo
    BANKSEL PORTD
    bcf	    LCD_RS
    movwf   NIBBLE
    swapf   NIBBLE,w
    andlw   0x0F
    addlw   b'00001000'  ;FUNCION DDRAM
    movwf   PORTD
    bsf	    LCD_EN
    call    Delay100us
    bcf	    LCD_EN	;Lee Function set
    call    Delay4_1ms
    movf    NIBBLE,w
    andlw   0x0F
    movwf   PORTD
    bsf	    LCD_EN
    call    Delay100us
    bcf	    LCD_EN	;Lee Function set
    call    Delay4_1ms
    return

;*****************************************************************************;
;			Funciones de retardos				      ;
;*****************************************************************************;
Delay167us:
	banksel	Count167us
	movlw	D'167'
	movwf	Count167us
D167us:
	decfsz	Count167us
	goto	D167us
	return
	
Delay334us:
	banksel	Count334us
	movlw	D'2'
	movwf	Count334us
D334us:
	call	Delay167us
	decfsz	Count334us
	goto	D334us
	return

Delay4_1ms:
	banksel	Count4_1ms
	movlw	D'13'
	movwf	Count4_1ms
D4_1ms:
	call	Delay334us
	decfsz	Count4_1ms
	goto	D4_1ms
	return

Delay100us:
	banksel	Count100us
	movlw	D'100'
	movwf	Count100us
D100us:
	decfsz	Count100us
	goto	D100us
	return

Delay1ms:
	banksel	Count1ms
	movlw	D'3'
	movwf	Count1ms
D1ms:
	call	Delay334us
	decfsz	Count1ms
	goto	D1ms
	return

Delay15ms:
	banksel	Count15ms
	movlw	D'15'
	movwf	Count15ms
D15ms:
	call	Delay1ms
	decfsz	Count15ms
	goto	D15ms
	return
	
Delay668us:
	banksel	Count668us
	movlw	D'2'
	movwf	Count668us
D668us:
	decfsz	Count668us
	goto	D334us
	return
	
		
Delay1_s:
	banksel	Count1s
	movlw	D'1000'
	movwf	Count1s
D1s:
	CALL	Delay1ms
	decfsz	Count1s
	goto	D1s
	return
    
    
    END


