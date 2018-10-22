;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 16f628a                  *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 16f628a                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p16f628a.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT & _LVP_OFF

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA
#DEFINE SCL	PORTB,RB0
#DEFINE SDA	PORTB,RB1
#DEFINE LED	PORTB,RB2

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES	
		CONT
		ENDERECO
		RW
		ACK

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÁ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

delay_200ms
	MOVLW	.2
	MOVWF	CONT
inicio
	BCF	  PIR1,TMR1IF
	MOVLW   .158		;INICIA O TIMER1 COM B'1001 1110'
	MOVWF   TMR1H		;FORMULA TIMER1 = (255 - TMR1H)*255
	MOVLW   .0
	MOVWF   TMR1L		;TMR1L SERVE COMO PRECISÃO
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
	MOVWF	TRISA		;COMO SAÍDAS	
	MOVLW	B'00000001'	;RB0 ENTRADA - RB1 SAÍDA
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
	MOVWF	TRISA		;COMO SAÍDAS	
	MOVLW	B'00000011'	;RB0 e RB1 como entradas, resto Saída
	MOVWF	TRISB		
	MOVLW	B'00000111'
	MOVWF	OPTION_REG 	;DEFINE OPÇÕES DE OPERAÇÃO	
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES	
	BANK0			;RETORNA PARA O BANCO		
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	BSF	T1CON,TMR1ON	;HABILITA O TIMER1
	BCF	T1CON,TMR1CS	;DEFINE O CLOCK DE OPERAÇÃO INTERNO
	BSF	T1CON,T1CKPS1	
	BCF	T1CON,T1CKPS0	;PRESCALER 1:4
	MOVLW	.0
	MOVWF	ENDERECO


;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
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
	MOVWF	TRISA		;COMO SAÍDAS	
	MOVLW	B'00000011'	;RB0 e RB1 como entradas, resto Saída
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
	

	
	
GOTO MAIN		    ;VOLTA PARA ESPERAR OUTRO ENDEREÇO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	END