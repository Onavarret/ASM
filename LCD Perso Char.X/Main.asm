LIST P = 16F887
#include "p16f887.inc"

; CONFIG1
; __config 0xE0F2
 __CONFIG _CONFIG1, _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFEFF
 __CONFIG _CONFIG2, _BOR4V_BOR21V & _WRT_OFF

#define LCD_EN	PORTD, 4 ;UBICACION DEL PIN EN EN MIUVA 16
#define LCD_RS	PORTD, 5 ;UBICACION DEL PIN RS EN MIUVA 16
 
;definicion de variables para la asignacion de tiempos
CBLOCK 0X020 ;posicion de declaracion de registros de proposito general
    Count167us
    Count15ms
    Count1ms
    Count100us
    Count4_1ms
    Count334us
    Count668us
ENDC

	
ORG 0X0000
    GOTO INICIO
    
ORG 0X0005
INICIO
    BANKSEL ANSEL
    MOVLW   0X00
    MOVWF   ANSEL
    MOVLW   0X00
    MOVWF   ANSELH
    BANKSEL TRISD
    MOVLW   0X00
    MOVWF   TRISD ;PUERTO D COMO SALIDA
    
    ;SE CARGA D7:D4 DE LA LCD EN LOS BITS D3:D0 DE MIUVA 16
    
    ;INICIA SECUENCIA DE INICIALIZACION
    BANKSEL PORTD
    BCF	    LCD_EN
    CALL    Delay15ms
    BCF	    LCD_RS
    ;wait for more than 15 ms after VCC rises to 4.5v
    
    ;funcion set
    MOVLW   b'00000011'
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us 
    BCF	    LCD_EN
    CALL    Delay4_1ms
    ;send set function with 8 bit config
    
     ;funcion set
    MOVLW   b'00000011'
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay100us
    ;send set function with 8 bit config
    
     ;funcion set
    MOVLW   b'00000011'
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay4_1ms
    ;send set function with 8 bit config
    
    ;funcion set
    MOVLW   b'00000010'
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay4_1ms
    
    ;COMIENZO A ENVIAR LA INFORMACION EN MODO DE 4 BITS
    ;FUNCION SET 
    
    ;funcion set
    MOVLW   b'00000010' ;activacion de funcion set en modo de 4 bits 
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us     ;retardo de enbale de 100us
    BCF	    LCD_EN
    CALL    Delay668us   ;retardo entre envio de parte alta y parte baja de 668us
    MOVLW   b'00001000'  ;activacion de N (1) modeo de dos lineas y F (0) 5x8 puntos Font 
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    
    ;;FUNCION DISPLAY OFF
    
    MOVLW   b'00000000' 
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us ;retardo entre parte alta y parte baja
    MOVLW   b'00001000' ;display off, cursor off, parpadeo off  
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    
     ;;FUNCION CLEAR DISPLAY
    
    MOVLW   b'00000000' 
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    MOVLW   b'00000001'  ;display desaparece,cursor posicion arriba izquierda de display,LCD modo incremento,corrimientos no cambian
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    
         ;;FUNCION ENTRY MODE SET
    
    MOVLW   b'00000000' 
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    MOVLW   b'00000110'; incrementar cursor hacia derecha, corrimiento activo a la izquierda  
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    
    ;FUNCION DDRAM ADDRESS
    
    MOVLW   b'00001000' ;posicion inicial
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    MOVLW   b'00000110'; posicion inicial de LCD
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    
     ;DISPLAY ON
    
    MOVLW   b'00000000' ;
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    MOVLW   b'00001111'; DISPLAY ON, CURSOR ON, PARPADEO ON
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;,CREACION DE CARACTER PERSONALIZADO
    ;INSTRUCCION CGRAM ADDRES
    
    MOVLW   b'00000100'  ;SE INDICA LA PARTE DE LA MEMORIA DONDE
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    MOVLW   b'00000000'; SE VA A ALMACENAR EL CARACTER PERSONALIZADO
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    
    
    ;SE ENVIARAN CADA UNA DE LAS FILAS DEL CARACTER PERSONALIZADO
    
    ;ENVIO DE FILA 1: 0  1110
    MOVLW   b'00100000'
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    MOVLW   b'00101110'
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    
    ;ENVIO DE FILA 2: 0  1110
    MOVLW   b'00100000'
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    MOVLW   b'00101110'
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    
    ;ENVIO DE FILA 3: 0  1110
    MOVLW   b'00100000'
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    MOVLW   b'00101110'
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    
    ;ENVIO DE FILA 4: 0  0100
    MOVLW   b'00100000'
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    MOVLW   b'00100100'
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    
    ;ENVIO DE FILA 5: 1  1111
    MOVLW   b'00100001'
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    MOVLW   b'00101111'
    MOVWF   PORTD
    BSF	    LCD_EN
    CALL    Delay100us
    BCF	    LCD_EN
    CALL    Delay668us
    
    ;ENVIO DE FILA 6: 0 0100
   MOVLW    b'00100000'
   MOVWF    PORTD
   BSF	    LCD_EN
   CALL	    Delay100us
   BCF	    LCD_EN
   CALL	    Delay668us
   MOVLW    b'00100100'
   MOVWF    PORTD
   BSF	    LCD_EN
   CALL	    Delay100us
   BCF	    LCD_EN
   CALL	    Delay668us
   
    ;ENVIO DE FILA 7:   0 0100
   MOVLW    b'00100000'
   MOVWF    PORTD
   BSF	    LCD_EN
   CALL	    Delay100us
   BCF	    LCD_EN
   CALL	    Delay668us
   MOVLW    b'00100100'
   MOVWF    PORTD
   BSF	    LCD_EN
   CALL	    Delay100us
   BCF	    LCD_EN
   CALL	    Delay668us
   
    ;ENVIO DE FILA 8:   1 1011
   MOVLW    b'00100001'
   MOVWF    PORTD
   BSF	    LCD_EN
   CALL	    Delay100us
   BCF	    LCD_EN
   CALL	    Delay668us
   MOVLW    b'00101011'
   MOVWF    PORTD
   BSF	    LCD_EN
   CALL	    Delay100us
   BCF	    LCD_EN
   CALL	    Delay668us
    
   ;FUNCION DISPLAY CLEAR
   MOVLW    b'00000000'
   MOVWF    PORTD
   BSF	    LCD_EN
   CALL	    Delay100us
   BCF	    LCD_EN
   CALL	    Delay668us
   MOVLW    b'00000001'
   MOVWF    PORTD
   BSF	    LCD_EN
   CALL	    Delay100us
   BCF	    LCD_EN
   CALL	    Delay668us
   
   ;DDRAM ADDRESS
   MOVLW    b'00001000'
   MOVWF    PORTD
   BSF	    LCD_EN
   CALL	    Delay100us
   BCF	    LCD_EN
   CALL	    Delay668us
   MOVLW    b'00000000'
   MOVWF    PORTD
   BSF	    LCD_EN
   CALL	    Delay100us
   BCF	    LCD_EN
   CALL	    Delay668us
   
   ;ENVIO DE DATO A IMPRIMIR
   MOVLW    b'00100000'
   MOVWF    PORTD
   BSF	    LCD_EN
   CALL	    Delay100us
   BCF	    LCD_EN
   CALL	    Delay668us
   MOVLW    b'00100000'
   MOVWF    PORTD
   BSF	    LCD_EN
   CALL	    Delay100us
   BCF	    LCD_EN
   CALL	    Delay668us
   
    
    
    
    
    
    
    
    
    
BUCLE:
    
    GOTO    BUCLE
    
    
    
Delay167us: ;label function
    BANKSEL Count167us
    MOVLW   D'167'
    MOVWF   Count167us
D167us: ;label
    decfsz  Count167us
    goto    D167us
    return 
    
Delay334us: ;label function
    BANKSEL Count334us
    MOVLW   D'2'
    MOVWF   Count334us
D334us: ;label
    call Delay167us
    decfsz  Count334us
    goto    D334us
    return 
    
Delay4_1ms: ;label function
    BANKSEL Count4_1ms
    MOVLW   D'13'
    MOVWF   Count4_1ms
D4_1ms: ;label
    call Delay334us
    decfsz  Count4_1ms
    goto    D4_1ms
    return 
    
Delay100us: ;label function
    BANKSEL Count100us
    MOVLW   D'100'
    MOVWF   Count100us
D100us: ;label
    decfsz  Count100us
    goto    D100us
    return 
    
    
Delay1ms: ;label function
    BANKSEL Count1ms
    MOVLW   D'3'
    MOVWF   Count1ms
D1ms: ;label
    call Delay334us
    decfsz  Count1ms
    goto    D1ms
    return 
    
Delay15ms: ;label function
    BANKSEL Count15ms
    MOVLW   D'15'
    MOVWF   Count15ms
D15ms: ;label
    call Delay1ms
    decfsz  Count15ms
    goto    D15ms
    return 
    
Delay668us: ;label function
    BANKSEL Count668us
    MOVLW   D'2'
    MOVWF   Count668us
D668us: ;label
    ;call Delay1ms
    decfsz  Count668us
    goto    D334us
    return 
 
 
END
    




