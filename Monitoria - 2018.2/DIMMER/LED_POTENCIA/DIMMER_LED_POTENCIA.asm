;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES
		VALOR_PWM
		
		;NOVAS VARI�VEIS

	ENDC			;FIM DO BLOCO DE MEM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER� ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00010000'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	MOVLW	B'00011000'
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000111'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	CALL	0X3FF		;CALIBRA��O
	MOVWF	OSCCAL	
	BCF	 PIE1,TMR1IE
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00001100'
	MOVWF	ADCON0
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO
	BSF	T1CON,TMR1ON	;HABILITA O TIMER1
	BCF	T1CON,TMR1CS	;DEFINE O CLOCK DE OPERA��O INTERNO
	BCF	T1CON,T1CKPS1	
	BCF	T1CON,T1CKPS0	;PS PARA 1:1
	CLRF	VALOR_PWM
	BSF	ADCON0,ADON

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	clrf GPIO
MAIN	;Nops necess�rios entre uma convers�o e outra, para evitar valores convertidos errados.
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	
	LOOP		
	BSF ADCON0,GO_DONE			;HABILITA CONVERS�O
WAIT_ADC
	BTFSC ADCON0,GO_DONE		;ESPERA AT� A CONVERS�O FINALIZAR
	GOTO  WAIT_ADC
		
	MOVLW	.250			
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_100			;PWM 100%
	
	MOVLW	.242			
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_95			;PWM 95%
	
	MOVLW	.230			
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_90			;PWM 90%
	
	MOVLW	.217			
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_85			;PWM 85%
	
	MOVLW	.204			
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_80			;PWM 80%
	
	MOVLW	.192			
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_75			;PWM 75%
	
	MOVLW	.179			
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_70			;PWM 70%
	
	MOVLW	.166			
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_65			;PWM 65%
	
	MOVLW	.153			
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_60			;PWM 60%
	
	MOVLW	.140			
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_55			;PWM 55%
	
	MOVLW	.128
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_50			;PWM 50%
	
	MOVLW	.115
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_45			;PWM 45%
	
	MOVLW	.102
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_40			;PWM 40%
	
	MOVLW	.89
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_35			;PWM 35%
	
	MOVLW	.77
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_30			;PWM 30%
	
	MOVLW	.64
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_25			;PWM 25%
	
	MOVLW	.51
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_20			;PWM 20%
	
	MOVLW	.38
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_15			;PWM 15%
	
	MOVLW	.26
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_10			;PWM 10%
	
	MOVLW	.13
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C
	GOTO	PWM_5			;PWM 5%
	
	MOVLW	.5
	MOVWF   VALOR_PWM	
	MOVFW	ADRESH
	SUBWF	VALOR_PWM,W
	BTFSS	STATUS,C	
	BCF	GPIO,GP0			;PWM 0%
		
	GOTO MAIN
	
PWM_100
	BSF	GPIO,GP0
GOTO	MAIN

PWM_95
	BSF	GPIO,GP0
	CALL	delay_95P_high
	BCF	GPIO,GP0
	CALL	delay_95P_low
GOTO	MAIN	
;os 2 primeiros coment�rios dos delays servem como base de funcionamento, os pr�ximos funcionam semelhantemente.
	
delay_95P_high
	    BCF	T1CON,T1CKPS1	;DEFINE PRESCALER PARA 1:2
	    BSF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .252	;INICIA O TIMER1 .252
	    MOVWF   TMR1H	;FORMULA TIMER1 = ((256 - TMR1H)*256)*PRESCALER
	    MOVLW   .84		;COM ESSE VALOR, CONSEGUE 1.9ms NO mpLAB
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECIS�O 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_95P_low
	    BCF	T1CON,T1CKPS1	;DEFINE PRESCALER PARA 1:1
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .255	;INICIA O TIMER1 .255
	    MOVWF   TMR1H	;FORMULA TIMER1 = ((256 - TMR1H)*256)*PRESCALER
	    MOVLW   .179	;COM ESSE VALOR, CONSEGUE 0.1ms NO mpLAB
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECIS�O 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	

	
PWM_90	
	BSF	GPIO,GP0
	CALL	delay_90P_high
	BCF	GPIO,GP0
	CALL	delay_90P_low
GOTO	MAIN
	
delay_90P_high
	    BCF	T1CON,T1CKPS1	
	    BSF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .252	
	    MOVWF   TMR1H	
	    MOVLW   .135	
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_90P_low
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .255	
	    MOVWF   TMR1H	
	    MOVLW   .78		
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN
	    
PWM_85
	BSF	GPIO,GP0
	CALL	delay_85P_high
	BCF	GPIO,GP0
	CALL	delay_85P_low
GOTO	MAIN	
	
delay_85P_high
	    BCF	T1CON,T1CKPS1	
	    BSF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .252	
	    MOVWF   TMR1H	
	    MOVLW   .183	
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_85P_low
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .254	
	    MOVWF   TMR1H	
	    MOVLW   .232		
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
	    
PWM_80
	BSF	GPIO,GP0
	CALL	delay_80P_high
	BCF	GPIO,GP0
	CALL	delay_80P_low
GOTO	MAIN	
	
delay_80P_high
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .249	
	    MOVWF   TMR1H	
	    MOVLW   .213		
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_80P_low
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .254	
	    MOVWF   TMR1H	
	    MOVLW   .125	
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
	    
PWM_75
	BSF	GPIO,GP0
	CALL	delay_75P_high
	BCF	GPIO,GP0
	CALL	delay_75P_low
GOTO	MAIN	
	
delay_75P_high
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .250	
	    MOVWF   TMR1H	
	    MOVLW   .55		
	    MOVWF   TMR1L	
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_75P_low
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .254	
	    MOVWF   TMR1H	
	    MOVLW   .33		
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN

PWM_70
	BSF	GPIO,GP0
	CALL	delay_70P_high
	BCF	GPIO,GP0
	CALL	delay_70P_low
GOTO	MAIN	
	
delay_70P_high
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .250	
	    MOVWF   TMR1H	
	    MOVLW   .150	
	    MOVWF   TMR1L	
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_70P_low
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .253	
	    MOVWF   TMR1H	
	    MOVLW   .189	
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	    
	    
PWM_65
	BSF	GPIO,GP0
	CALL	delay_65P_high
	BCF	GPIO,GP0
	CALL	delay_65P_low
GOTO	MAIN	
	
delay_65P_high
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .251	
	    MOVWF   TMR1H	
	    MOVLW   .0		
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_65P_low
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .253	
	    MOVWF   TMR1H	
	    MOVLW   .88		
	    MOVWF   TMR1L	
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
	    
PWM_60
	BSF	GPIO,GP0
	CALL	delay_60P_high
	BCF	GPIO,GP0
	CALL	delay_60P_low
GOTO	MAIN	
	
delay_60P_high
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .251	
	    MOVWF   TMR1H	
	    MOVLW   .100	
	    MOVWF   TMR1L	
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_60P_low
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .252	
	    MOVWF   TMR1H	
	    MOVLW   .246	
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
	    
PWM_55
	BSF	GPIO,GP0
	CALL	delay_55P_high
	BCF	GPIO,GP0
	CALL	delay_55P_low
GOTO	MAIN	
	
delay_55P_high
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .251	
	    MOVWF   TMR1H	
	    MOVLW   .202	
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_55P_low
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .252	
	    MOVWF   TMR1H	
	    MOVLW   .146	
	    MOVWF   TMR1L	
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	    
	
PWM_50
	BSF	GPIO,GP0
	CALL	delay_50P
	BCF	GPIO,GP0
	CALL	delay_50P
GOTO	MAIN	
	
delay_50P
	    BCF	T1CON,T1CKPS1	
	    BSF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .254	
	    MOVWF   TMR1H	
	    MOVLW   .19		
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
    return

PWM_45
	BSF	GPIO,GP0
	CALL	delay_45P_high
	BCF	GPIO,GP0
	CALL	delay_45P_low
GOTO	MAIN	
	
delay_45P_low
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .251	
	    MOVWF   TMR1H	
	    MOVLW   .202	
	    MOVWF   TMR1L	
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_45P_high
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .252	
	    MOVWF   TMR1H	
	    MOVLW   .146	
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
	    
PWM_40
	BSF	GPIO,GP0
	CALL	delay_40P_high
	BCF	GPIO,GP0
	CALL	delay_40P_low
GOTO	MAIN	
	
delay_40P_low
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .251	
	    MOVWF   TMR1H	
	    MOVLW   .100	
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_40P_high
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .252	
	    MOVWF   TMR1H	
	    MOVLW   .246	
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
	    
PWM_35
	BSF	GPIO,GP0
	CALL	delay_35P_high
	BCF	GPIO,GP0
	CALL	delay_35P_low
GOTO	MAIN	
	
delay_35P_low
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .251	
	    MOVWF   TMR1H	
	    MOVLW   .0		
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_35P_high
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .253	
	    MOVWF   TMR1H	
	    MOVLW   .88		
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
	    
PWM_30
	BSF	GPIO,GP0
	CALL	delay_30P_high
	BCF	GPIO,GP0
	CALL	delay_30P_low
GOTO	MAIN	
	
delay_30P_low
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .250	
	    MOVWF   TMR1H	
	    MOVLW   .150	
	    MOVWF   TMR1L	
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_30P_high
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .253	
	    MOVWF   TMR1H	
	    MOVLW   .189	
	    MOVWF   TMR1L	
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	    
	    
PWM_25
	BSF	GPIO,GP0
	CALL	delay_25P_high
	BCF	GPIO,GP0
	CALL	delay_25P_low
GOTO	MAIN	
	
delay_25P_low
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .250	
	    MOVWF   TMR1H	
	    MOVLW   .55		
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_25P_high
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .254	
	    MOVWF   TMR1H	
	    MOVLW   .33		
	    MOVWF   TMR1L	
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN
	    
PWM_20
	BSF	GPIO,GP0
	CALL	delay_20P_high
	BCF	GPIO,GP0
	CALL	delay_20P_low
GOTO	MAIN	
	
delay_20P_low
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .249	
	    MOVWF   TMR1H	
	    MOVLW   .213	
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_20P_high
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .254	
	    MOVWF   TMR1H	
	    MOVLW   .125	
	    MOVWF   TMR1L	
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
	    
PWM_15
	BSF	GPIO,GP0
	CALL	delay_15P_high
	BCF	GPIO,GP0
	CALL	delay_15P_low
GOTO	MAIN	
	
delay_15P_low
	    BCF	T1CON,T1CKPS1	
	    BSF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .252	
	    MOVWF   TMR1H	
	    MOVLW   .183	
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_15P_high
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .254	
	    MOVWF   TMR1H	
	    MOVLW   .232		
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
	    
PWM_10	
	BSF	GPIO,GP0
	CALL	delay_10P_high
	BCF	GPIO,GP0
	CALL	delay_10P_low
GOTO	MAIN
	
delay_10P_low
	    BCF	T1CON,T1CKPS1	
	    BSF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .252	
	    MOVWF   TMR1H	
	    MOVLW   .135		
	    MOVWF   TMR1L	
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_10P_high
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .255	
	    MOVWF   TMR1H	
	    MOVLW   .78		
	    MOVWF   TMR1L	
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN
	    
PWM_5
	BSF	GPIO,GP0
	CALL	delay_5P_high
	BCF	GPIO,GP0
	CALL	delay_5P_low
GOTO	MAIN	
	
delay_5P_low
	    BCF	T1CON,T1CKPS1	
	    BSF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .252	
	    MOVWF   TMR1H	
	    MOVLW   .84		
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
    
delay_5P_high
	    BCF	T1CON,T1CKPS1	
	    BCF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .255	
	    MOVWF   TMR1H	
	    MOVLW   .179	
	    MOVWF   TMR1L	 
	    BTFSS    PIR1,TMR1IF
	    GOTO    $-1
RETURN	
	    
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END