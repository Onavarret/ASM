LIST P = 16F887
#include "p16f887.inc"

; CONFIG1
; __config 0xE0F2
 __CONFIG _CONFIG1, _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFEFF
 __CONFIG _CONFIG2, _BOR4V_BOR21V & _WRT_OFF
 
 CBLOCK 0x20
 VAR
 DECREASE
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
    
    BANKSEL TRISB
    MOVLW   0X00
    MOVWF   TRISB
    
    BANKSEL PORTB
    MOVLW   0X00
    MOVWF   PORTB
    
    MOVLW   D'6'
    BANKSEL VAR
    MOVWF   VAR
    
    

    
BUCLE:
    
    BANKSEL PORTB
    CLRF    PORTB
    
    BANKSEL VAR
    DECFSZ  VAR,1
    GOTO    SHOW_NUMBER
    CALL    END_CYCLE
    

   
GOTO    BUCLE
    
    
     
    SHOW_NUMBER:
   
    MOVFW   VAR
    
    BANKSEL PORTB
    MOVWF   PORTB
    
    CALL    Delay1s
    
    GOTO    BUCLE
    
    
    END_CYCLE:
    
    BANKSEL PORTB
    MOVLW   0XFF
    MOVWF   PORTB
    
    CALL    Delay1s
    CALL    Delay1s
    CALL    Delay1s
   
    
    MOVLW   D'6'
    BANKSEL VAR
    MOVWF   VAR
    
    
    
    RETURN
    
    
    
    

    
    
    include <Timing.inc>
	
	

;;;;;;;;;;;;;;;;;;;;;;;    
   
	
END




