;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 16f628a                  *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS�O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI��O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 16f628a                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p16f628a.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA
#DEFINE SCL	PORTB,RB0
#DEFINE SDA	PORTB,RB1
#DEFINE LED	PORTB,RB2

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES	
		CONT
		ENDERECO
		RW
		ACK

	ENDC			;FIM DO BLOCO DE MEM�RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

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

delay_200ms
	MOVLW	.2
	MOVWF	CONT
inicio
	BCF	  PIR1,TMR1IF
	MOVLW   .158		;INICIA O TIMER1 COM B'1001 1110'
	MOVWF   TMR1H		;FORMULA TIMER1 = (255 - TMR1H)*255
	MOVLW   .0
	MOVWF   TMR1L		;TMR1L SERVE COMO PRECIS�O
aux_200ms
	BTFSS    PIR1,TMR1IF
	GOTO	    aux_200ms
	DECFSZ	 CONT,F
	GOTO	 inicio
return
	
ENDERECO_CORRETO
	;BSF	LED
	;CALL	delay_200ms
;	BSF	PORTB,RB1
;	nop
;	nop
;	BCF	PORTB,RB1
	;BCF	LED
	DECF	ACK
RETURN
	
MANDA_ACK
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00000000'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISA		;COMO SA�DAS	
	MOVLW	B'00000001'	;RB0 ENTRADA - RB1 SA�DA
	MOVWF	TRISB
	BANK0	
	MOVLW	.1
	SUBWF	ACK
	BTFSS	STATUS,Z
	GOTO	$+2
	BSF	SDA
	BCF	SDA	
	;BSF	PORTB, RB4
	;NOP
	;BCF	PORTB, RB4
RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00000000'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISA		;COMO SA�DAS	
	MOVLW	B'00000011'	;RB0 e RB1 como entradas, resto Sa�da
	MOVWF	TRISB		
	MOVLW	B'00000111'
	MOVWF	OPTION_REG 	;DEFINE OP��ES DE OPERA��O	
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES	
	BANK0			;RETORNA PARA O BANCO		
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO
	BSF	T1CON,TMR1ON	;HABILITA O TIMER1
	BCF	T1CON,TMR1CS	;DEFINE O CLOCK DE OPERA��O INTERNO
	BSF	T1CON,T1CKPS1	
	BCF	T1CON,T1CKPS0	;PRESCALER 1:4
	MOVLW	.0
	MOVWF	ENDERECO


;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN	
	;STBIT
	BTFSC	SDA
	GOTO	$-1
	BTFSC	SCL
        GOTO	$-1
	
	;CLK1
	BTFSS	SCL
	GOTO	$-1
	INCF	ENDERECO
	BTFSS	SDA
	DECF	ENDERECO	
	RLF	ENDERECO
	
	;CLK2
	BTFSC	SCL
	GOTO	$-1
	BTFSS	SCL
	GOTO	$-1
	INCF	ENDERECO
	BTFSS	SDA
	DECF	ENDERECO	
	RLF	ENDERECO
	
	;CLK3
	BTFSC	SCL
	GOTO	$-1
	BTFSS	SCL
	GOTO	$-1
	INCF	ENDERECO
	BTFSS	SDA
	DECF	ENDERECO	
	RLF	ENDERECO
	
	;CLK4
	BTFSC	SCL
	GOTO	$-1
	BTFSS	SCL
	GOTO	$-1
	INCF	ENDERECO
	BTFSS	SDA
	DECF	ENDERECO	
	RLF	ENDERECO
	
	;CLK5
	BTFSC	SCL
	GOTO	$-1
	BTFSS	SCL
	GOTO	$-1
	INCF	ENDERECO
	BTFSS	SDA
	DECF	ENDERECO	
	RLF	ENDERECO
	
	;CLK6
	BTFSC	SCL
	GOTO	$-1
	BTFSS	SCL
	GOTO	$-1
	INCF	ENDERECO
	BTFSS	SDA
	DECF	ENDERECO
	RLF	ENDERECO
	
	;CLK7
	BTFSC	SCL
	GOTO	$-1
	BTFSS	SCL
	GOTO	$-1
	INCF	ENDERECO
	BTFSS	SDA
	DECF	ENDERECO
	RLF	ENDERECO
	
	;CLK8
	BTFSC	SCL
	GOTO	$-1
	BTFSS	SCL
	GOTO	$-1
	INCF	ENDERECO
	BTFSS	SDA
	DECF	ENDERECO
	
	INCF	ACK
	MOVLW	.51
	SUBWF	ENDERECO,W
	BTFSC	STATUS,Z
	CALL	ENDERECO_CORRETO	
	
	;RW
	BTFSC	SCL
	GOTO	$-1
	BTFSS	SCL
	GOTO	$-1
	INCF	RW
	BTFSS	SDA
	DECF	RW
	
	;ACK
	BTFSC	SCL
	GOTO	$-1
	BTFSS	SCL
	GOTO	$-1
	
	CALL	MANDA_ACK
	
	BTFSC	SCL
	GOTO	$-1
	
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00000000'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISA		;COMO SA�DAS	
	MOVLW	B'00000011'	;RB0 e RB1 como entradas, resto Sa�da
	MOVWF	TRISB
	BANK0
	
	;STOP_BIT
	BTFSS	SCL
	GOTO	$-1
	BTFSS	SDA
	GOTO	$-1
	
	
	MOVLW	.0
	MOVWF	ENDERECO
	MOVLW	.0
	MOVWF	ACK
	MOVLW	.0
	MOVWF	RW
	

	
	
GOTO MAIN		    ;VOLTA PARA ESPERAR OUTRO ENDERE�O

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	END