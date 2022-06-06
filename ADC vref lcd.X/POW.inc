;PARAMETERS (BASE, EXPONENT)
;RETURN POW_RES
    

	
	
P0W:
    
    CBLOCK	0X020
	BASE ;VALOR INICIAL BASE 2 
	EXPONENT;POTEANCIA A ELEVAR
	EXPONENTFIX ;POTENCIA A ELEVAR -1
	POW_RES
    ENDC
	
    BANKSEL	BASE	
    MOVLW	D'2'
    MOVWF	BASE

    BANKSEL POW_RES
    MOVLW	D'0'
    MOVWF	POW_RES
    ;;;;;;;;;;;;;
	
    CLRF    POW_RES
    BANKSEL EXPONENT
    MOVWF   EXPONENT
    MOVF    EXPONENT,0 ;MOVE EXPONENT VALUE TO WORKING REGISTER
    BANKSEL EXPONENTFIX
    MOVWF   EXPONENTFIX ;MOVE WORKING REGISTER TO EXPONENT FIX
    DECF    EXPONENTFIX,1 ;DECREMENT THE VALUE OF EXPONENTFIX BY ONE 
    MOVF    EXPONENTFIX,0
    BANKSEL MULTIPLIER    ;DANDO VALOR AL MULTIPLICADOR
    MOVLW   D'2'    ; DEPENDIENDO DEL EXPONENTFIX 
    MOVWF   MULTIPLIER
    BANKSEL N1     ;ARGUMENTO MULTIPLICANDO PARA LA FUNCION MUL
    MOVF    BASE,0
    MOVWF   N1      ;AL MULTIPLICANDO LE DAMOS EL VALOR DE LA BASE '2'
    
BUCLE_POW:    
    CALL    MULTIPLICATION
    BANKSEL MULTI
    MOVF    MULTI,0
    BANKSEL N1
    MOVWF   N1
    DECFSZ  EXPONENTFIX,1
    GOTO    BUCLE_POW
    
    BANKSEL MULTI
    MOVF    MULTI,0
    BANKSEL POW_RES
    MOVWF   POW_RES
    
    RETURN
    

    
    
    
    
;END

	
	
	

