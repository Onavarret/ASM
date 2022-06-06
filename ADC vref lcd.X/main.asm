LIST P = 16F887
#include "p16f887.inc"



; CONFIG1
; __config 0xE0F2
 __CONFIG _CONFIG1, _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFEFF
 __CONFIG _CONFIG2, _BOR4V_BOR21V & _WRT_OFF

    CBLOCK 0X020
       adclecturaH ;almacenar la parte alta del ADC
       adclecturaL ;almacenar la parte baja del ADC
       K  ;CONTADOR
       H ; K - 1 
       ACUM ; ACUMULADOR
       POW ;POTENCIA A ELEVAR
       TOTAL_POW_RES ;resultado total de la conversion binario a decimal
       TEST
    ENDC
    
 
 
ORG 0X0000
    GOTO INICIO
    
ORG 0X0005
INICIO
    BANKSEL ANSELH
    MOVLW   0X00 ; SE COLOCAN COMO DIGITAL TODOS LOS CANALES HIGH
    MOVWF   ANSELH
    BANKSEL TRISA
    MOVLW   0XFF
    MOVWF   TRISA
    MOVLW   0X00
    MOVWF   TRISB
    BANKSEL TRISD
    MOVLW   0X00
    MOVWF   TRISD
    BANKSEL TRISC
    MOVLW   0X00
    MOVWF   TRISC
    
    BANKSEL ANSEL
    MOVLW   0X01 ; SE COLOCA COMO ANALOGICO EL PRIMER CANAL DEL ADC
    MOVWF   ANSEL
    
    
    BANKSEL ADCON1
    MOVLW   b'00110000'
    MOVWF   ADCON1 ;JUSTIFICADO A LA IZQUIERDA // REFERENCIAS DE VREF - VREF +
    BANKSEL ADCON0
    MOVLW   0X00
    MOVWF   ADCON0 ; SELECCIONAR RELOJ FOSC/2 .... CH=AN0 ..... ADON DESACTIVADO
    
    BSF	    ADCON0, ADON ;ACTIVAMOS EL ADC
    
    ;;;;;;;;;;;;;;;;
    BANKSEL TEST
    MOVLW   D'123'
    MOVWF   TEST
    ;;;;;
    
    CALL    LCD_Init
    CALL    LCD_Clear
    MOVLW   0X03
    CALL    LCD_GoTo
    MOVF    TEST,0
    CALL    LCD_Char
    
    
BUCLE:	
    BANKSEL ADCON0
    BSF	    ADCON0, GO_DONE ;INICIA LA CONVERSION (GO DONE SE MANDA A CERO CUANDO LA CONVERSION SE COMPLETA)
    BTFSC   ADCON0, GO_DONE ;¿ESTA COMPLETA LA CONVERSIÓN?
    GOTO    BUCLE
    BANKSEL ADRESL
    MOVF    ADRESL,W ;MOVEMOS EL RESULTADO L AL RESGISTRO DE TRABAJO 
    BANKSEL adclecturaL
    MOVWF   adclecturaL
    
    BANKSEL ADRESH
    MOVF    ADRESH,W ;MOVEMOS EL RESULTADO H AL REGISTRO DE TRABAJO 
    BANKSEL adclecturaH
    MOVWF   adclecturaH
    
   
    
   
    BANKSEL K
    MOVLW   D'7'
    MOVWF   K
     

    
    Init_CONVERSION:
     
		CLRW
		;CLRF	K
    
     
     CONVERSION:
     
		MOVF    K,0 
		BTFSC   adclecturaH,K
		CALL    POW
		;BTFSC   adclecturaH,K
		 MOVF    POW_RES,0
		;BTFSC   adclecturaH,K
		ADDWF   TOTAL_POW_RES,1
		DECFSZ    K,1   ;1 to store the result in K register instead of the working register
		GOTO CONVERSION
		
		;CLRW
     ;MOVLW '1111'  
     ;ANDWF  K,0
     ;BTFSC  W,0    
     ;GOTO Init_CONVERSION
     ;BTFSC  W,1    
     ;GOTO Init_CONVERSION
     ;BTFSC  W2,2    
     ;GOTO Init_CONVERSION
     ;BTFSS  W2,3    
     ;GOTO Init_CONVERSION
     
     
      BANKSEL TOTAL_POW_RES
      MOVF    TOTAL_POW_RES,0
      BANKSEL PORTB
      MOVWF   PORTB
      
    

   
    
 
    GOTO    BUCLE ;REGRESA A LA ETIQUETA DE BUCLE
   
    
    INCLUDE <LCD.inc>
    INCLUDE <MUL.inc>
    INCLUDE <POW.inc> 
  


	
END
