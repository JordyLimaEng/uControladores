; Placa de aprendizagem: uStart for PIC   
; ProgramaÁ„o em Assembly do PIC18F4550 
; Autor: Jordy Allyson
    
  list p=18f4550, r=hex
  #include <p18f4550.inc>  
  
  org 0x0000 ;Inicia o programa no endereÁo de memÛria 0x00
  goto INICIO 
  
  org 0x0008 ;interrupÁ„o de alta prioridade, desvia para endereÁo 0x08
  goto HI_INT
  
  org 0x0018 ;interrupÁ„o de baixa prioridade, desvia para endereÁo 0x18
  goto LOW_INT
  
  #DEFINE   LCD_EN  LATD,7
  #DEFINE   RS	    LATD,6
  #DEFINE   RW	    LATD,5
  
;####### INTERRUP«√O DE ALTA PRIORIDADE ########
  HI_INT:
;EspaÁoßo para execuÁ„o em alta prioridade
;----------------------------------------
    
  btfss INTCON,TMR0IF
  goto end_int

  movlw b'00000110' ; RA1 e RA2
  xorwf LATA,F
  clrf counter
 
end_int:
    bcf INTCON,TMR0IF 
;----------------------------------------  
  retfie ;Volta ao curso do programa  
;################################################ 
  
;####### INTERRUP«√O DE BAIXA PRIORIDADE ########
  LOW_INT:
;EspaÁo para execuÁ„o em baixa prioridade
;----------------------------------------
    
  nop
  
;----------------------------------------
  retfie ;Volta ao curso do programa  
;################################################
  
  
;##### INCIALIZA«√O DE VARI¡VEIS #####
  CBLOCK	0x10	;ENDERE«O INICIAL DA MEM”RIA DE USU¡RIO
			
		counter
		;NOVAS VARI√ÅVEIS
  ENDC		;FIM DO BLOCO DE MEM”RIA

;######### ROTINA PRINCIPAL DO PROGRAMA #########
INICIO:
  ;limpa vari·veis
  clrf counter 
  ;--------------------------------------
  MOVLW	b'00000000'
  MOVWF	TRISB
  MOVLW	b'00000000'
  MOVWF	TRISD  
  clrf	INTCON	    ; Desabilita todas as interrupÁıes  
  BCF	PIE1,TMR1IE ;Desabilita interrupÁ„o do timer1
  BSF	T1CON,TMR1ON	;HABILITA O TIMER1
  BCF	T1CON,TMR1CS	;DEFINE O CLOCK DE OPERA«√O INTERNO
  BCF	T1CON,T1CKPS1	
  BCF	T1CON,T1CKPS0	;PRESCALER 1:1		
    
  CALL	Inicia_LCD
MAIN  
	
		   
   
   GOTO MAIN
  
   Inicia_LCD
   ;COMO EST¡ ORGANIZADA AS PORTAS DE ACORDO COM A PINAGEM:
   ; RS   RW   DB7  DB6  DB5  DB4  DB3  DB2  DB1  DB0
   ; RD6  RD5  RB7  RB6  RB5  RB4  RB3  RB2  RB1  RB0
	CALL	delay_15ms
	;#1
	;00 0011****
	BSF	LCD_EN
	BCF	RS
	BCF	RW
	MOVLW	b'00110000'
	MOVWF	LATB
	BCF	LCD_EN	
	CALL	delay_4ms
	
	;#2
	;00 0011****
	BSF	LCD_EN
	BCF	RS
	BCF	RW
	MOVLW	b'00110000'
	MOVWF	LATB
	BCF	LCD_EN	
	CALL	delay_100us
	
	;#3
	;00 0011****
	BSF	LCD_EN
	BCF	RS
	BCF	RW
	MOVLW	b'00110000'
	MOVWF	LATB
	BCF	LCD_EN
	CALL	delay_100us
	
	;#4
	;00 00111000
	BSF	LCD_EN
	BCF	RS
	BCF	RW
	MOVLW	b'00111000'
	MOVWF	LATB
	BCF	LCD_EN
	CALL	delay_100us
	
	;#5
	;00 00001000
	BSF	LCD_EN
	BCF	RS
	BCF	RW
	MOVLW	b'00001000'
	MOVWF	LATB
	BCF	LCD_EN
	CALL	delay_100us
	
	;#6
	;00 00000001
	BSF	LCD_EN
	BCF	RS
	BCF	RW
	MOVLW	b'00000001'
	MOVWF	LATB
	BCF	LCD_EN
	CALL	delay_4ms
	
	;#7
	;00 00000110
	BSF	LCD_EN
	BCF	RS
	BCF	RW
	MOVLW	b'00000110'
	MOVWF	LATB
	BCF	LCD_EN
	CALL	delay_100us
   return
   
   
   
   delay_15ms;16ms
   	    BCF	  PIR1,TMR1IF
	    MOVLW   .193		;INICIA O TIMER1 COM B'0000 0000'
	    MOVWF   TMR1H	;FORMULA TIMER1 = ((255 - TMR1H)*255)*PS
	    MOVLW   .0
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECIS√O
	aux_15
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_15
   return
   
   delay_4ms;5ms
   	    BCF	  PIR1,TMR1IF
	    MOVLW   .235		;INICIA O TIMER1 COM B'0000 0000'
	    MOVWF   TMR1H	;FORMULA TIMER1 = ((255 - TMR1H)*255)*PS
	    MOVLW   .0
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECIS√O
	aux_4
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_4
   return
   
   delay_100us;300us
	    BCF	  PIR1,TMR1IF
	    MOVLW   .254		;INICIA O TIMER1 COM B'0000 0000'
	    MOVWF   TMR1H	;FORMULA TIMER1 = ((255 - TMR1H)*255)*PS
	    MOVLW   .127
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECIS√O
	    aux_100
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_100
    return
   
  end