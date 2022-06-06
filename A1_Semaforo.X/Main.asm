LIST P = 16F887
#include "p16f887.inc"

; CONFIG1
; __config 0xE0F2
 __CONFIG _CONFIG1, _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFEFF
 __CONFIG _CONFIG2, _BOR4V_BOR21V & _WRT_OFF
 
 
 CBLOCK 0x020
        Count100us
	Count500us
	Count1ms
	Count100ms
	Count500ms
	Count700ms
	Count1s
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
      

    
BUCLE:
      BANKSEL PORTB
      MOVLW   0X00
      MOVWF   PORTB
      
      BSF     PORTB,5 ;SE PRENDE ROJO    R2
      BSF     PORTB,0 ;SE PRENDE VERDE POR DOS SEGUNDOS V1
      CALL    Delay1s
      CALL    Delay1s
      BCF     PORTB,0 ;SE APAGA VERDE  V1
      
      BSF     PORTB,1  ;SE PRENDE AMARILLO  A1
      CALL    Delay700ms
      BCF     PORTB,1  ;SE APAGA AMARILLO   A1
      CALL    Delay500ms
      BSF     PORTB,1 ;SE PRENDE DE NUEVO AMARILLO  A1
      CALL    Delay700ms
   
      BCF     PORTB,1  ;SE APAGA AMARILLO   A1
      CALL    Delay500ms
      BSF     PORTB,1 ;SE PRENDE DE NUEVO AMARILLO  A1
      CALL    Delay700ms
      
      BCF     PORTB,1  ;SE APAGA AMARILLO   A1
      BSF     PORTB,2 ;SE PRENDE ROJO    R1
      BCF     PORTB,5 ;SE PRENDE ROJO    R2
      BSF     PORTB,3 ;SE PRENDE VERDE   V2 
      CALL    Delay1s
      CALL    Delay1s
      
      BCF     PORTB,3 ;SE APAGA VERDE   V2
      BSF     PORTB,4  ;SE PRENDE AMARILLO  A2
      CALL    Delay700ms
      BCF     PORTB,4  ;SE APAGA AMARILLO   A2
      CALL    Delay500ms
      BSF     PORTB,4 ;SE PRENDE DE NUEVO AMARILLO  A2
      CALL    Delay700ms
   
      BCF     PORTB,4  ;SE APAGA AMARILLO   A2
      CALL    Delay500ms
      BSF     PORTB,4 ;SE PRENDE DE NUEVO AMARILLO  A2
      CALL    Delay700ms
      
     
     
    
    GOTO    BUCLE
    

Delay100us:
    BANKSEL Count100us
    MOVLW   D'100'
    MOVWF   Count100us
D100us:
    DECFSZ  Count100us
    GOTO    D100us
    RETURN

    
Delay500us:
    BANKSEL Count500us
    MOVLW   D'5'
    MOVWF   Count500us
D500us:
    CALL    Delay100us
    DECFSZ  Count500us
    GOTO    D500us
    RETURN
    
Delay1ms:
    BANKSEL Count1ms
    MOVLW   D'2'
    MOVWF   Count1ms
D1ms:
    CALL    Delay500us    
    DECFSZ  Count1ms
    GOTO    D1ms
    RETURN
    
Delay100ms:
    BANKSEL Count100ms
    MOVLW   D'100'
    MOVWF   Count100ms
D100ms:
    CALL    Delay1ms    
    DECFSZ  Count100ms
    GOTO    D100ms
    RETURN
    
Delay500ms:
    BANKSEL Count500ms
    MOVLW   D'5'
    MOVWF   Count500ms
D500ms:
    CALL    Delay100ms    
    DECFSZ  Count500ms
    GOTO    D500ms
    RETURN
    
Delay700ms:
    BANKSEL Count700ms
    MOVLW   D'7'
    MOVWF   Count700ms
D700ms:
    CALL    Delay100ms    
    DECFSZ  Count700ms
    GOTO    D700ms
    RETURN
    
Delay1s:
    BANKSEL Count1s
    MOVLW   D'2'
    MOVWF   Count1s
D1s:
    CALL    Delay500ms    
    DECFSZ  Count1s
    GOTO    D1s
    RETURN

	
	

;;;;;;;;;;;;;;;;;;;;;;;    
   
	
END




