LIST P = 16F887
#include "p16f887.inc"

; CONFIG1
; __config 0xE0F2
 __CONFIG _CONFIG1, _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFEFF
 __CONFIG _CONFIG2, _BOR4V_BOR21V & _WRT_OFF
 
CBLOCK 0X20
SET_OK
SET_NOK
adclecturaH
adclecturaL
LOW_ADC_OK
HIGH_ADC_OK
AND_RESULT

ENDC
 
 

ORG 0X0000
    GOTO INICIO
    
ORG 0X0005
INICIO

BANKSEL ANSEL
MOVLW	0X01
MOVWF	ANSEL
BANKSEL ANSELH
MOVLW	0X00
MOVWF	ANSELH
    
BANKSEL	TRISB
MOVLW	0X00
MOVWF	TRISB
BANKSEL PORTB
MOVLW	0X00
MOVWF   PORTB;;;;; CLEAR PORTB
BANKSEL TRISC
MOVLW	0X00
MOVWF	TRISC   ;;;PORTC AS AN OUTPUT
BANKSEL PORTC
MOVLW	0X00
MOVWF	PORTC;;;;
    
BANKSEL TRISD
MOVLW	0X00
MOVWF	TRISD
BANKSEL PORTD
MOVLW	0X00
MOVWF   PORTD
    
;MOVLW	0X00
;BANKSEL SET_OK
;MOVWF   SET_OK
    
;MOVLW	0X00
;BANKSEL SET_NOK
;MOVWF	SET_NOK
    

;;
    
    
;CONFIGURACION ADC


BANKSEL ADCON1
MOVLW	0X80    ;RIGHT JSUT
MOVWF	ADCON1  ;RIGHT JUSTIFIED / VSS VDD REFERENCE
BANKSEL ADCON0
MOVLW	0X00
MOVWF	ADCON0 ;FOSC/2  /CH0=AN0 / DISABLED
BSF     ADCON0, ADON  ;ENABLED 
;;;;;;;;;;;;;;;;;;;;;;
    
CALL    LCD_Init
CALL    LCD_Clear
MOVLW   0X00
CALL    LCD_GoTo


    
BUCLE:
    
    BANKSEL ADCON0
    ;CALL    Delay1ms
    BSF	    ADCON0, GO_DONE ;INICIA LA CONVERSION (GO DONE SE MANDA A CERO CUANDO LA CONVERSION SE COMPLETA)
    BTFSC   ADCON0, GO_DONE ;ESTA COMPLETA LA CONVERSION?
    GOTO    BUCLE
    
    BANKSEL ADRESL
    MOVF    ADRESL,W ;MOVEMOS EL RESULTADO L AL REGISTRO DE TRABAJO
    BANKSEL adclecturaL
    MOVWF   adclecturaL
    
    BANKSEL ADRESH
    MOVF    ADRESH,W ;MOVEMOS EL RESULTADO H AL REGISTRO DE TRABAJO
    MOVWF   adclecturaH
    
    BANKSEL adclecturaL
    MOVF    adclecturaL,W  
    
    BANKSEL PORTB
    MOVWF   PORTB
    
    BANKSEL adclecturaH
    MOVF    adclecturaH,W
    
    
    BANKSEL PORTC
   
     MOVWF   PORTC
    
    
    ;si la conversion es arriba de  128 mandar mensaje en LCD
   
    
    
    CLRF    W
    CLRF    LOW_ADC_OK
    CLRF    HIGH_ADC_OK
    
    
    BANKSEL STATUS
    
    BCF     STATUS,C
    
    BANKSEL adclecturaL
    
    MOVF    adclecturaL,W
    SUBLW   D'128'
    
    BANKSEL STATUS
    
    BTFSC   STATUS,C
    BSF     LOW_ADC_OK,0  ;SE SETEA CUANDO LA LECTURA ANALOGICA ES MENOR A 128
    
    
   
    BCF	    STATUS,C
    
    
     
    
     BANKSEL adclecturaH
     MOVF    adclecturaH,W
     SUBLW   D'0'
    
    
     BANKSEL STATUS
     BTFSC   STATUS,C
     BSF     HIGH_ADC_OK,0  ;SE SETEA CUANDO LA LECTURA ANALOGICA ES MENOR A 128
     
    
     BANKSEL LOW_ADC_OK
     MOVF    LOW_ADC_OK,W
    
   
     BANKSEL HIGH_ADC_OK
     ANDWF   HIGH_ADC_OK,0
    
     
     BANKSEL  AND_RESULT
     MOVWF    AND_RESULT
     
     

     ;MOVFW   AND_RESULT
     ;BANKSEL PORTC
     ;MOVWF   PORTC
    
     BANKSEL AND_RESULT
    

     
      BTFSS   AND_RESULT,0
      CALL    TEMP_NOK
    
     
      
      BANKSEL AND_RESULT
     
      
      BTFSC   AND_RESULT,0
      CALL    TEMP_OK     ;TEMP_OK
      
      
    
   
  
      CALL    Delay1s
    
    
GOTO    BUCLE
    
    
    TEMP_OK:
    
    ;BANKSEL SET_OK
    
    BTFSC SET_OK,0
    RETURN
   

    CALL LCD_Clear;
    
    
    MOVLW   'T'
    CALL    LCD_Char
    MOVLW   'E'
    CALL    LCD_Char
    MOVLW   'M'
    CALL    LCD_Char
    MOVLW   'P'
    CALL    LCD_Char
    MOVLW   'E'
    CALL    LCD_Char
    MOVLW   'R'
    CALL    LCD_Char
    MOVLW   'A'
    CALL    LCD_Char
    MOVLW   'T'
    CALL    LCD_Char
    MOVLW   'U'
    CALL    LCD_Char
    MOVLW   'R'
    CALL    LCD_Char
    MOVLW   'A'
    CALL    LCD_Char
    MOVLW   ' '
    CALL    LCD_Char
    MOVLW   'O'
    CALL    LCD_Char
    MOVLW   'K'
    CALL    LCD_Char
    
    ;BANKSEL SET_OK
    BSF     SET_OK,0
    
    ;BANKSEL SET_NOK
    BCF	    SET_NOK,0
    
    
    RETURN

    
    TEMP_NOK:
    
    ;BANKSEL SET_NOK
    
    BTFSC   SET_NOK,0
    RETURN
    
    CALL LCD_Clear
    
   
    MOVLW   'T'
    CALL    LCD_Char
    MOVLW   'E'
    CALL    LCD_Char
    MOVLW   'M'
    CALL    LCD_Char
    MOVLW   'P'
    CALL    LCD_Char
    
    MOVLW   'E'
    CALL    LCD_Char
    MOVLW   'R'
    CALL    LCD_Char
    MOVLW   'A'
    CALL    LCD_Char
    MOVLW   'T'
    CALL    LCD_Char
    MOVLW   'U'
    CALL    LCD_Char
    MOVLW   'R'
    CALL    LCD_Char
    MOVLW   'A'
    CALL    LCD_Char
    MOVLW   'N'
    CALL    LCD_Char
    MOVLW   'O'
    CALL    LCD_Char
    MOVLW   'K'
    CALL    LCD_Char
    
    ;BANKSEL SET_OK
    BCF     SET_OK,0
    
    ;BANKSEL SET_NOK
    BSF	    SET_NOK,0
    RETURN
    
    
    
   
  
    
   
    
    
    

	
INCLUDE <LCD_lib.inc>

;;;;;;;;;;;;;;;;;;;;;;;    
   
	
END




