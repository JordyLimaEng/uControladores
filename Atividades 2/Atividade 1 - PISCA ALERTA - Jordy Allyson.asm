;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA√?√?ES PARA USO COM 12F675                   *
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

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT

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
		
		CONTA		;VARI¡VEIS PARA CONTAGEM E GERA«√O DOS TIMERS
		CONTA2
		CONTA3

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
;*                    IN√çCIO DA INTERRUP«√O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE√?O DE DESVIO DAS INTERRUP√?√?ES. A PRIMEIRA TAREFA √? SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA√?√?O FUTURA

	ORG	0x04		;ENDERE«O INICIAL DA INTERRUP«√O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP√?√?O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER√Å ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP√?√?ES
	
	CLRF	GPIO		;LIMPA OS VALORES EM GPIO, PARA EVITAR LIXO
	
	BTFSS	GPIO,GP0	;SE GP0 ESTIVER EM HIGH, ATIVA PISCA_ALERTA
	GOTO	TESTA_ESQUERDA	;SE N√O, TESTA SE … PARA ESQUERDA
	BCF	INTCON,GPIF	;LIMPA O GPIF PARA N√O GERAR OUTRAS INTERRUP«’ES
	CALL	PISCA_ALERTA	;PISCA O ALERTA
	GOTO	SAI_INT		;SAI DO TRATAMENTO DE INTERRUP«√O
	
TESTA_ESQUERDA
	BTFSS	GPIO,GP1	;SE GP1 ESTIVER EM HIGH, PISCA ESQUERDA
	GOTO	TESTA_DIREITA	;SE N√O, TESTA SE … PARA DIREITA
	CALL	PISCA_ESQUERDA	;PISCA ESQUERDA
	GOTO	SAI_INT		;SAI DO TRATAMENTO DE INTERRUP«√O

TESTA_DIREITA
	BTFSC	GPIO,GP2	;SE GP2 ESTIVER EM LOW, SAI DA INTERRUP«√O
	CALL	PISCA_DIREITA	;SE N√O, PISCA PARA DIREITA
	GOTO	SAI_INT		;SAI DO TRATAMENTO DE INTERRUP«√O
	
PISCA_DIREITA			;ROTINA PARA PISCAR ¿ DIREITA
	
	BSF	GPIO,GP5	;ACENDE POR 500ms
	
	MOVLW	    .16		
	MOVWF	    CONTA	 
	    AUX			
	CALL	    DELAY_500ms	
	DECFSZ	    CONTA	
	GOTO	    AUX		
	
	BCF	GPIO,GP5	;DESLIGA POR 500ms
	
	MOVLW	    .16
	MOVWF	    CONTA
	    AUX.
	CALL	    DELAY_500ms
	DECFSZ	    CONTA
	GOTO	    AUX.
	
	BTFSC	GPIO,GP0	;CASO PISCA ALERTA N√O ESTIVER ACIONADO, CONTINUA PISCANDO PARA DIREITA
	RETURN			
	BTFSC	GPIO,GP2	;SE GP2 CONTINUAR EM HIGH, VOLTA PARA PISCAR NOVAMENTE
	GOTO	PISCA_DIREITA
return

PISCA_ESQUERDA			;ROTINA PARA PISCAR ¿ ESQUERDA
	
	BSF	GPIO,GP4	;ACENDE POR 500ms
	
	MOVLW	    .16
	MOVWF	    CONTA2
	    AUX2
	CALL	    DELAY_500ms
	DECFSZ	    CONTA2
	GOTO	    AUX2
	
	BCF	GPIO,GP4	;DESLIGA POR 500ms
	
	MOVLW	    .16
	MOVWF	    CONTA2
	    AUX2.
	CALL	    DELAY_500ms
	DECFSZ	    CONTA2
	GOTO	    AUX2.
	
	BTFSC	GPIO,GP0	;CASO PISCA ALERTA N√O ESTIVER ACIONADO, CONTINUA PISCANDO PARA ESQUERDA
	RETURN			
	BTFSC	GPIO,GP1	;SE GP1 CONTINUAR EM HIGH, VOLTA PARA PISCAR NOVAMENTE
	GOTO	PISCA_ESQUERDA
return
	
PISCA_ALERTA			;ROTINA PARA PISCA ALERTA
	
	BSF	GPIO,GP4	;ACENDE POR 500ms
	BSF	GPIO,GP5
	
	MOVLW	    .16
	MOVWF	    CONTA3
	    AUX3
	CALL	    DELAY_500ms
	DECFSZ	    CONTA3
	GOTO	    AUX3
	
	BCF	GPIO,GP4	;DESLIGA POR 500ms
	BCF	GPIO,GP5
	
	MOVLW	    .16
	MOVWF	    CONTA3
	    AUX3.
	CALL	    DELAY_500ms
	DECFSZ	    CONTA3
	GOTO	    AUX3.
	
	BTFSC	GPIO,GP0	;SE GP0 CONTINUAR EM HIGH, VOLTA PARA PISCAR NOVAMENTE
	GOTO	PISCA_ALERTA
return
	
	
	
DELAY_500ms			;ROTINA PARA CRIA«√O DO TIMER DE 500ms (GERANDO 1HZ NO PISCA)
    MOVLW   .127
    MOVWF   TMR0
    BCF	    INTCON,T0IF
    CONTAUX
    BTFSS   INTCON,T0IF
    GOTO    CONTAUX 
return
	

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
	MOVLW	B'00000111'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÕDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'11000111'
	MOVWF	OPTION_REG	;DEFINE OP«’ES DE OPERA«AO
	MOVLW	B'11001000'
	MOVWF	INTCON		;DEFINE OP«’ES DE INTERRUP«√O
	CALL	0X3FF		;CALIBRA«√O DO TIMER
	MOVWF	OSCCAL
	MOVLW	B'00000111'	;DEFINE QUE HAVER¡ INTERRUP«√O QUANDO
	MOVWF	IOC		;AS PORTAS GP2, GP1 e GP0 MUDAREM DE ESTADO
	
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA«√O PARA COMPARADOR ANAL”GICO
	
	BCF	INTCON,INTF	;LIMPA OS REGISTRADORES DE INTERRUP«√O ANTECIPADAMENTE
	BCF	INTCON,T0IF	;PARA N√O GERAR INTERRUP«√O DESNECESS¡RIA
	BCF	INTCON,GPIF

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
