;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÃ?Ã?ES PARA USO COM 12F675                 *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃ?O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÃ?Ã?O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÃ?Ã?ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃ?O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÃ?Ã?O DE MEMÃ?RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÃ?Ã?O DE COMANDOS DE USUÃRIO PARA ALTERAÃ?Ã?O DA PÃGINA DE MEMÃ?RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÃ?RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÃ?RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÃVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÃ?Ã?O DOS NOMES E ENDEREÃ?OS DE TODAS AS VARIÃVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÃ?O INICIAL DA MEMÃ?RIA DE
					;USUÃRIO
		W_TEMP		;REGISTRADORES TEMPORÃRIOS PARA USO
		STATUS_TEMP	;JUNTO Ã?S INTERRUPÃ?Ã?ES

		;NOVAS VARIÃVEIS

	ENDC			;FIM DO BLOCO DE MEMÃ?RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÃ?Ã?O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÃ?Ã?O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÃ?Ã?O DE TODOS OS PINOS QUE SERÃ?O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÃ?M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÃDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÃ?Ã?O DE TODOS OS PINOS QUE SERÃ?O UTILIZADOS COMO SAÃDA
; RECOMENDAMOS TAMBÃ?M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÃ?O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÃCIO DA INTERRUPÃ?Ã?O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÃ?O DE DESVIO DAS INTERRUPÃ?Ã?ES. A PRIMEIRA TAREFA Ã? SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÃ?Ã?O FUTURA

	ORG	0x04			;ENDEREÃ?O INICIAL DA INTERRUPÃ?Ã?O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÃ?Ã?O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÃ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÃ?Ã?ES
	
	BTFSS	PIR1,TMR1IF	;TESTA SE OCORREU OVERFLOW NO TMR1
	GOTO	SAI_INT		;SE NÃO, DESVIA PARA SAIDA DE INTERRUPÇÃO
	BCF	PIR1,TMR1IF	;SE SIM, LIMPA O TMR1IF
	MOVLW	.255
	MOVWF	TMR1H		;FORMULA TIMER1 = (255 - TMR1H)*255
	MOVLW	.0
	MOVWF	TMR1L		;TMR1L SERVE COMO PRECISÃO
	COMF	GPIO		;E COMPLEMENTA TODAS AS PORTAS DO PIC
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÃDA DA INTERRUPÃ?Ã?O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÃ?Ã?O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÃ?Ã?O DE FUNCIONAMENTO
; E UM NOME COERENTE Ã?S SUAS FUNÃ?Ã?ES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÃDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000000'
	MOVWF	OPTION_REG	;DEFINE OPÃ?Ã?ES DE OPERAÃ?Ã?O
	MOVLW	B'11000000'
	MOVWF	INTCON		;DEFINE OPÃ?Ã?ES DE INTERRUPÃ?Ã?ES
	CALL	0X3FF
	MOVWF	OSCCAL
	
	BSF	 PIE1,TMR1IE	;HABILITA A INTERRUPÇÃO PELO TIMER1
	
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÃ?Ã?O DO COMPARADOR ANALÃ?GICO
	
	BSF	T1CON,TMR1ON	;HABILITA O TIMER1
	BCF	T1CON,TMR1CS	;DEFINE O CLOCK DE OPERAÇÃO INTERNO
	BSF	T1CON,T1CKPS1	
	BSF	T1CON,T1CKPS0	;PRESCALER 1:8
	
	MOVLW	.0		;INICIA O TIMER1 COM B'0000 0000'
	MOVWF	TMR1H
	MOVLW	.0
	MOVWF	TMR1L

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÃ?Ã?O DAS VARIÃVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN

	
	GOTO MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
