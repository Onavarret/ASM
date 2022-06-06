LIST P = 16F887
#include "p16f887.inc"

; CONFIG1
; __config 0xE0F2
 __CONFIG _CONFIG1, _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFEFF
 __CONFIG _CONFIG2, _BOR4V_BOR21V & _WRT_OFF
 
 
CBLOCK 0XA0
TIME
CONTADOR 
DECONTADOR
ENDC
 
 
 
ORG 0X0000;RESET VECTOR 
    GOTO INICIO
    
ORG 0X0004 ;INTERRUPTION VECTOR
    GOTO INTERRUP_B
    
ORG 0X0005  ;PAGE 0 ON CHIP PROGRAM MEMORY
INICIO
    
    
    BANKSEL ANSELH
    MOVLW   0X00
    MOVWF   ANSELH
    BANKSEL ANSEL
    MOVLW   0X00
    MOVWF   ANSEL
    
    BANKSEL TRISB
    MOVLW   0XFF ;ENTRADA
    MOVWF   TRISB
    
    BANKSEL TRISC
    MOVLW   0X00; SALIDA
    MOVWF   TRISC
    
    BANKSEL PORTC
    CLRF    PORTC
    
    
    BANKSEL TRISD
    MOVLW   0X00 ;SALIDAS
    MOVWF   TRISD
    
    BANKSEL PORTB
    MOVLW   0X00   ;CLEAR PORTB
    MOVWF   PORTB
    
    BANKSEL PORTD
    MOVLW   0X00   ;CLEAR PORTC
    MOVWF   PORTD
    
    
    CLRWDT  
    
   
    
    BANKSEL CONTADOR
    MOVLW   0X00
    MOVWF   CONTADOR

    BANKSEL TMR0
    CLRF    TMR0
    
    BANKSEL INTCON
    BSF	    INTCON,PEIE
    BSF	    INTCON,GIE
    BSF	    INTCON,T0IE
   ;BSF	    INTCON,RBIE
   ;BCF	    INTCON,RBIF
    BCF	    INTCON,T0IF
    ;MOVLW   b'11001000'
    ;MOVWF   INTCON
    
    BANKSEL OPTION_REG
    BCF	    OPTION_REG,T0SE
    BCF	    OPTION_REG,PSA
    BSF	    OPTION_REG,PS2   ;;8 bit prescaler means overflow at 21.7 ms
    BSF	    OPTION_REG,PS1
    BSF	    OPTION_REG,PS0
    BCF     OPTION_REG,T0CS ;SELECCION DE FUENTE DE RELOJ INTERNO 
    
    BANKSEL IOCB
    BSF	    IOCB,1
    
   BANKSEL TIME
   MOVLW   D'46'
   MOVWF   TIME
   
   BANKSEL  DECONTADOR
   MOVLW    D'255'
   MOVWF    DECONTADOR
    
    
   
    
BUCLE:
   
    BANKSEL DECONTADOR
    MOVFW   DECONTADOR
    
    BANKSEL PORTD
    MOVWF   PORTD
    
    CALL    Delay1s
    
    BANKSEL DECONTADOR
    DECF    DECONTADOR
    
    
GOTO    BUCLE
    
INTERRUP_B:
    
BANKSEL INTCON
BCF	INTCON, T0IF ;LIMPIA BANDERA DE INTERRUPCION POR DESBORDE 0
    
BANKSEL	PORTB
BTFSC	PORTB,1
GOTO	CLEAR_COUNTER


BANKSEL	TIME
DECFSZ	TIME ;DECREMENTAMOS LA VARIABLE TIEMPO, SALTA SI ES CERO
GOTO	SALIR_INT
MOVLW	D'46'
MOVWF	TIME;AJUSTO EL VALOR DE TIEMPO EN 50
BANKSEL	CONTADOR
INCF	CONTADOR;INCREMENTO EL VALOR DE CONTADOR EN UNO
MOVF	CONTADOR,W 
BANKSEL	PORTC
MOVWF	PORTC
    
;BANKSEL	CONTADOR
;MOVLW	0X00
;MOVWF   CONTADOR
    
;BANKSEL	PORTD
;MOVLW	0X00
;MOVWF	PORTD

    
SALIR_INT:
BANKSEL	INTCON
BSF	INTCON,T0IE
BCF	INTCON,RBIF
BSF	INTCON,RBIE
BSF	INTCON,PEIE
BSF	INTCON,GIE
BCF	INTCON,T0IF    
RETFIE
    
CLEAR_COUNTER:
BANKSEL	CONTADOR
MOVLW	0X00
MOVWF	CONTADOR
BANKSEL DECONTADOR
MOVLW	0X00
MOVWF	DECONTADOR
    
GOTO	SALIR_INT

  
    
 
    
    
INCLUDE <Delays.inc>
    

 
    
    
    
    
    

	
	

;;;;;;;;;;;;;;;;;;;;;;;    
   
	
END




