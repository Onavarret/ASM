CBLOCK 0x0A0
        Count100us
	Count500us
	Count1ms
	Count100ms
	Count300ms
	Count500ms
	Count700ms
	Count1s
ENDC
	
	
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
    
Delay300ms:
    BANKSEL Count300ms
    MOVLW   D'3'
    MOVWF   Count300ms
D300ms:
    CALL    Delay100ms    
    DECFSZ  Count300ms
    GOTO    D300ms
    RETURN
	

	
	
END


