;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA√?√?ES PARA USO COM 12F675                 *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS√?O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI√?√?O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI√?√?ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR√?O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA√?√?O DE MEM√?RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI√?√?O DE COMANDOS DE USU√ÅRIO PARA ALTERA√?√?O DA P√ÅGINA DE MEM√?RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM√?RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM√?RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI√ÅVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI√?√?O DOS NOMES E ENDERE√?OS DE TODAS AS VARI√ÅVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE√?O INICIAL DA MEM√?RIA DE
					;USU√ÅRIO
		W_TEMP		;REGISTRADORES TEMPOR√ÅRIOS PARA USO
		STATUS_TEMP	;JUNTO √?S INTERRUP√?√?ES

		;NOVAS VARI√ÅVEIS

	ENDC			;FIM DO BLOCO DE MEM√?RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI√?√?O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI√?√?O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI√?√?O DE TODOS OS PINOS QUE SER√?O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB√?M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA√çDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI√?√?O DE TODOS OS PINOS QUE SER√?O UTILIZADOS COMO SA√çDA
; RECOMENDAMOS TAMB√?M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE√?O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN√çCIO DA INTERRUP√?√?O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE√?O DE DESVIO DAS INTERRUP√?√?ES. A PRIMEIRA TAREFA √? SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA√?√?O FUTURA

	ORG	0x04			;ENDERE√?O INICIAL DA INTERRUP√?√?O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP√?√?O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER√Å ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP√?√?ES
	
	BTFSS	PIR1,TMR1IF	;TESTA SE OCORREU OVERFLOW NO TMR1
	GOTO	SAI_INT		;SE N√O, DESVIA PARA SAIDA DE INTERRUP«√O
	BCF	PIR1,TMR1IF	;SE SIM, LIMPA O TMR1IF
	MOVLW	.255
	MOVWF	TMR1H
	MOVLW	.0
	MOVWF	TMR1L
	COMF	GPIO		;E COMPLEMENTA TODAS AS PORTAS DO PIC
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA√çDA DA INTERRUP√?√?O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP√?√?O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI√?√?O DE FUNCIONAMENTO
; E UM NOME COERENTE √?S SUAS FUN√?√?ES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA√çDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000000'
	MOVWF	OPTION_REG	;DEFINE OP√?√?ES DE OPERA√?√?O
	MOVLW	B'11000000'
	MOVWF	INTCON		;DEFINE OP√?√?ES DE INTERRUP√?√?ES
	CALL	0X3FF
	MOVWF	OSCCAL
	
	BSF	 PIE1,TMR1IE	;HABILITA A INTERRUP«√O PELO TIMER1
	
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA√?√?O DO COMPARADOR ANAL√?GICO
	
	BSF	T1CON,TMR1ON	;HABILITA O TIMER1
	BCF	T1CON,TMR1CS	;DEFINE O CLOCK DE OPERA«√O INTERNO
	BSF	T1CON,T1CKPS1	
	BSF	T1CON,T1CKPS0	;PRESCALER 1:8
	
	MOVLW	.0		;INICIA O TIMER1 COM B'0000 0000'
	MOVWF	TMR1H
	MOVLW	.0
	MOVWF	TMR1L

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA√?√?O DAS VARI√ÅVEIS                 *
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
