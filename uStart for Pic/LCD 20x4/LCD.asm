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
 
end_int: 
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
  MOVWF	TRISB	    ;SAÕDA PARA O LCD
  MOVLW	b'00000000'
  MOVWF	TRISD	    ;BITS DE CONTROLE DO LCD
  clrf	INTCON	    ; Desabilita todas as interrupÁıes  
  BCF	PIE1,TMR1IE ;Desabilita interrupÁ„o do timer1
  BSF	T1CON,TMR1ON	;HABILITA O TIMER1
  BCF	T1CON,TMR1CS	;DEFINE O CLOCK DE OPERA«√O INTERNO
  BCF	T1CON,T1CKPS1	
  BCF	T1CON,T1CKPS0	;PRESCALER 1:1		
    
  CALL	Inicia_LCD
  MOVLW 0x0F	;cmd para deixar cursor on e piscante
  CALL  COMANDO
MAIN  
	call  delay_0.5s
	MOVLW A'J'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'o'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'r'
	CALL  ESCREVE
	call  delay_0.5s	
	MOVLW A'd'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'y'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW 0x20
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'L'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'i'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'm'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'a'
	CALL  ESCREVE
	
	CALL  delay_0.5s
	CALL  delay_0.5s
	CALL  delay_0.5s
	CALL  delay_0.5s
	
	MOVLW 0xC0
	CALL COMANDO
	CALL delay_100us
	
	call  delay_0.5s
	MOVLW A'u'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'C'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'-'
	CALL  ESCREVE
	call  delay_0.5s	
	MOVLW A'u'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'S'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A't'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'a'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'r'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A't'
	CALL  ESCREVE
	
	CALL  delay_0.5s
	CALL  delay_0.5s
	CALL  delay_0.5s
	CALL  delay_0.5s
	
	MOVLW 0x94
	CALL COMANDO
	CALL delay_100us
	
	MOVLW A'.'
	CALL  ESCREVE
	call  delay_0.5s
	call  delay_0.5s
	
	MOVLW 0xD4
	CALL COMANDO
	CALL delay_100us
	
	MOVLW A'.'
	CALL  ESCREVE
	call  delay_0.5s
	call  delay_0.5s
	
	CALL  CLEAR
	CALL  delay_4ms
	
	
		      
   GOTO MAIN
   
   COMANDO
	BSF	LCD_EN
	BCF	RS
	BCF	RW
	MOVWF	LATB
	BCF	LCD_EN
    return
    
   ESCREVE
   	BSF	LCD_EN
	BSF	RS
	BCF	RW
	MOVWF	LATB
	BCF	LCD_EN
	CALL	delay_100us
    return
    
    CLEAR;Limpa display e posiciona cursor na 1a posiÁ„o
	BSF	LCD_EN
	BCF	RS
	BCF	RW
	MOVLW	0x01
	MOVWF	LATB
	BCF	LCD_EN
    return
    
  
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
	MOVLW	0x30
	MOVWF	LATB
	BCF	LCD_EN	
	CALL	delay_4ms
	
	;#2
	;00 0011****
	BSF	LCD_EN
	BCF	RS
	BCF	RW
	MOVLW	0x30
	MOVWF	LATB
	BCF	LCD_EN	
	CALL	delay_100us
	
	;#3
	;00 0011****
	BSF	LCD_EN
	BCF	RS
	BCF	RW
	MOVLW	0x30
	MOVWF	LATB
	BCF	LCD_EN
	CALL	delay_100us
	
	;#4
	;00 00111000
	BSF	LCD_EN
	BCF	RS
	BCF	RW
	MOVLW	0x38
	MOVWF	LATB
	BCF	LCD_EN
	CALL	delay_100us
	
	;#5
	;00 0000001
	BSF	LCD_EN
	BCF	RS
	BCF	RW
	MOVLW	0x01
	MOVWF	LATB
	BCF	LCD_EN
	CALL	delay_4ms
	
	;#6
	;00 00001100
	BSF	LCD_EN
	BCF	RS
	BCF	RW
	MOVLW	0x0C
	MOVWF	LATB
	BCF	LCD_EN
	CALL	delay_100us
	
	;#7
	;00 00000110
	BSF	LCD_EN
	BCF	RS
	BCF	RW
	MOVLW	0x06
	MOVWF	LATB
	BCF	LCD_EN
	CALL	delay_100us
   return
   
   
   delay_0.5s
	    BSF	T1CON,T1CKPS1	;DEFINE PRESCALER PARA 1:8
	    BSF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .0		;INICIA O TIMER1 COM B'0000 0000'
	    MOVWF   TMR1H	;FORMULA TIMER1 = (255 - TMR1H)*255
	    MOVLW   .0
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECIS√O
	    aux_0.5s
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_0.5s
	   BCF	T1CON,T1CKPS1	
	   BCF	T1CON,T1CKPS0
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