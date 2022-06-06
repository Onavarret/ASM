LIST P = 16F887
#include "p16f887.inc"

; CONFIG1
; __config 0xE0F2
 __CONFIG _CONFIG1, _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFEFF
 __CONFIG _CONFIG2, _BOR4V_BOR21V & _WRT_OFF

 
CBLOCK 0X020
	    recibido
 ENDC
	
ORG 0X0000
    GOTO INICIO
    
ORG 0X0005
INICIO
    BANKSEL ANSEL   ;AMBOS DIGITALES
    MOVLW   0X00
    MOVWF   ANSEL
    MOVLW   0X00
    MOVWF   ANSELH  ;AMBOS CANALES DIGITALESZ
    BANKSEL TRISD
    MOVLW   0X00   ;OUTPUT
    MOVWF   TRISD
    MOVLW   0XFF   ;INPUT
    MOVWF   TRISC
    BANKSEL TRISB
    MOVLW   0XFF   ;INPUT
    MOVWF   TRISB
    CALL    LCD_Init
    MOVLW   0X00
    CALL    LCD_GoTo
    MOVLW   'R'
    CALL    LCD_Char
    MOVLW   'S'
    CALL    LCD_Char
    MOVLW   '2'
    CALL    LCD_Char
    MOVLW   '3'
    CALL    LCD_Char
    MOVLW   '2'
    CALL    LCD_Char
    MOVLW   0X40
    CALL   LCD_GoTo
    
    ;CONDIGURACION PARA RECEPCION DE DATOS
    
    BANKSEL SPBRG   ;VALOR CALCULADO DEPENDIENDO DE LA VELOCIDAD QUE QUIERO
    MOVLW   D'19'
    MOVWF   SPBRG
    
    BANKSEL TXSTA
    BCF	    TXSTA,BRGH ; LOW SPEED 
    
    BANKSEL BAUDCTL
    BCF	    BAUDCTL, BRG16 ;SELECCION DE VELOCIDAD ADECUADA (8 BITS)
    
    BANKSEL TXSTA
    BCF	    TXSTA, SYNC ;PUERTO SERIAL ASINCRONO

    BANKSEL RCSTA
    BSF	    RCSTA,SPEN  ;HABILITA PUERTO SERIAL
    BSF	    RCSTA,CREN  ;HABILITA LA RECEPCION
    
    ;;CONFIGURACION PARA LA TRANSMISION DE DATOS
    
    BANKSEL TXSTA
    BSF	    TXSTA, TXEN ;HABILITO EL ENVIO
    
    
BUCLE:
    BANKSEL PIR1   ;REGISTRO CON BITS DE RECEPCION Y TRANSMISION
    BTFSS   PIR1, RCIF ;ESPERAMOS A QUE ESTE LISTA LA CONVERSION
    GOTO    BUCLE
    BANKSEL RCREG
    MOVF    RCREG, W  ;ALMACENAMOS EL DATO RECIBIDO
    MOVWF   recibido  ;ALMACENAMOS EL DATO EN "recibido"
    MOVF    recibido, W ;muevo de recibido a W
    
    BANKSEL TXREG
    MOVWF   TXREG
    
    BANKSEL RCSTA
    BSF	    RCSTA, CREN
    MOVF    recibido, W ;muevo de recibido a W
    CALL    LCD_Char  ;llamo a escribir un dato
    
    ;BTFSC   PORTB,0
    ;CALL    LCD_Clear
    
    GOTO    BUCLE
    
    
    INCLUDE <LCD.inc>
	
	

;;;;;;;;;;;;;;;;;;;;;;;    
   
	
END




