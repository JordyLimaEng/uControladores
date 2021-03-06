;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
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
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA
#DEFINE SCL	GPIO,GP0
#DEFINE SDA	GPIO,GP1
#DEFINE LED	GPIO,GP5

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
		ENDERECO	;VARI�VEL QUE RECEBE O ENDERE�O ENVIADO DO MASTER
		

		;NOVAS VARI�VEIS

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

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000011'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES	
	BANK0				;RETORNA PARA O BANCO
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

;OS DADOS S�O INTERPRETADOS DA SEGUINTE FORMA (MODO SLAVE):
;SDA -> STbit   D6  D5  D4  D3  D2  D1  D0 R/W ACK 
;SCL -> CKST   CK1 CK2 CK3 CK4 CK5 CK6 CK7 CK8 CK9 

VERIFICA_SDA		    ;TESTA SDA ENQUANTO ESTIVER EM 1
	BTFSS	SDA	    ;QUANDO FOR PRA ZERO, ANALISA SE O CLOCK EST� EM 1
	GOTO	VERIFICA_SCL
	GOTO	VERIFICA_SDA
	
VERIFICA_SCL
	BTFSC	SCL	    ;SE O CLOCK ESTIVER EM 1, IDENTIFICA-SE START_BIT
	GOTO	START_BIT
	GOTO	VERIFICA_SDA;SE N�O, VOLTA A VERIFICAR SDA AT� QUE SEJA 0 NOVAMENTE
	
START_BIT		    ;AQUI J� � IDENTIFICADO O ST_BIT, AGORA S� ESPERA
	BTFSS	SCL	    ;VOLTAR PARA 0 PARA COME�AR IDENTIFICAR OS CLK DOS DADOS
	GOTO	CLK_1
	GOTO	START_BIT
	
	
CLK_1			    ;IDENTIFICA��O (CLK_2 E DADO_6)
	BTFSC	SCL
	GOTO	DADO_6
	GOTO	CLK_1

DADO_6
	INCF	ENDERECO    ;SE J� � UM, INCREMENTA ENDERE�O E FAZ RLF
	BTFSS	SDA	    ;SE SDA FOR ZERO, ENDERE�O RECEBE ZERO
	DECF	ENDERECO
	RLF	ENDERECO
A2	
	BTFSS	SCL
	GOTO	CLK_2
GOTO A2
	
CLK_2			    ;IDENTIFICA��O (CLK_3 E DADO_5)
	BTFSC	SCL
	GOTO	DADO_5
	GOTO	CLK_2

DADO_5
	INCF	ENDERECO    ;SE J� � UM, INCREMENTA ENDERE�O E FAZ RLF
	BTFSS	SDA	    ;SE SDA FOR ZERO, ENDERE�O RECEBE ZERO
	DECF	ENDERECO
	RLF	ENDERECO
A3	
	BTFSS	SCL
	GOTO	CLK_3
GOTO A3

CLK_3			    ;IDENTIFICA��O (CLK_4 E DADO_4)
	BTFSC	SCL
	GOTO	DADO_4
	GOTO	CLK_3

DADO_4
	INCF	ENDERECO    ;SE J� � UM, INCREMENTA ENDERE�O E FAZ RLF
	BTFSS	SDA	    ;SE SDA FOR ZERO, ENDERE�O RECEBE ZERO
	DECF	ENDERECO
	RLF	ENDERECO
A4	
	BTFSS	SCL
	GOTO	CLK_4
GOTO A4
	
CLK_4			    ;IDENTIFICA��O (CLK_5 E DADO_3)
	BTFSC	SCL
	GOTO	DADO_3
	GOTO	CLK_4

DADO_3
	INCF	ENDERECO    ;SE J� � UM, INCREMENTA ENDERE�O E FAZ RLF
	BTFSS	SDA	    ;SE SDA FOR ZERO, ENDERE�O RECEBE ZERO
	DECF	ENDERECO
	RLF	ENDERECO
A5
	BTFSS	SCL
	GOTO	CLK_5
GOTO A5
	
CLK_5			    ;IDENTIFICA��O (CLK_6 E DADO_2)
	BTFSC	SCL
	GOTO	DADO_2
	GOTO	CLK_5

DADO_2
	INCF	ENDERECO    ;SE J� � UM, INCREMENTA ENDERE�O E FAZ RLF
	BTFSS	SDA	    ;SE SDA FOR ZERO, ENDERE�O RECEBE ZERO
	DECF	ENDERECO
	RLF	ENDERECO
A6
	BTFSS	SCL
	GOTO	CLK_6
GOTO A6
	
CLK_6			    ;IDENTIFICA��O (CLK_7 E DADO_1)
	BTFSC	SCL
	GOTO	DADO_1
	GOTO	CLK_6

DADO_1
	INCF	ENDERECO    ;SE J� � UM, INCREMENTA ENDERE�O E FAZ RLF
	BTFSS	SDA	    ;SE SDA FOR ZERO, ENDERE�O RECEBE ZERO
	DECF	ENDERECO
	RLF	ENDERECO
	
A7
	BTFSS	SCL
	GOTO	CLK_7
GOTO A7

	
CLK_7			    ;IDENTIFICA��O (CLK_8 E DADO_0)
	BTFSC	SCL
	GOTO	DADO_0
	GOTO	CLK_7

DADO_0
	INCF	ENDERECO    ;SE J� � UM, INCREMENTA ENDERE�O 
	BTFSS	SDA	    ;SE SDA FOR ZERO, ENDERE�O RECEBE ZERO
	DECF	ENDERECO

RW			    ;IGNORA O RW J� QUE N�O SE USA NESSA ATIVIDADE
	BTFSS	SCL	    ;CLK_8
	GOTO	IGNORA_RW
GOTO	RW
	
IGNORA_RW
	BTFSC	SCL
	GOTO	$+2
GOTO	IGNORA_RW
	
VERIFICA_ENDERECO
	BCF	STATUS,Z
	MOVLW	.51	    ;MEU ENDERE�O FICOU DEFINIDO COMO 51
	SUBWF	ENDERECO,W  ;X011 0011
	BTFSS	STATUS,Z
	GOTO	ACK_NOP
ACK_YEP			    ;SE O ENDERE�O FOI IDENTIFICADO CORRETAMENTE
	CLRF	ENDERECO    ;LIMPA ENDERE�O PARA PROXIMA AQUISI��O
	BCF	STATUS,C    ;LIMPA CARRY PARA OS PROXIMOS RLF
	BANK1				
	MOVLW	B'00000001'	;SCL - entrada SDA - sa�da
	MOVWF	TRISIO		
	BANK0
	BCF	SDA	    ;FOR�A SDA PARA LOW PARA MANDAR ACKNOWLEDGE
			    
			    ;CLK_9
aux	
	BTFSC	SCL	    ;ESPERA O CLOCK SUBIR
	GOTO	aux	    
aux2	
	BTFSS	SCL	    ;ESPERA O CLOCK DESCER
	GOTO	aux2
	
aux3	
	BTFSC	SCL	    ;EM AUX3 e AUX4 ESPERA O CLOCK SUBIR E DESCER PARA 
	GOTO	aux3	    ;ACENDER O LED E DAR O DELAY DE 200ms
aux4	
	BTFSS	SCL
	GOTO	aux4
	
	BANK1				
	MOVLW	B'00000010'	;SCL - sa�da SDA - entrada
	MOVWF	TRISIO		
	BANK0	
	BCF	SCL	    ;FOR�A SCL PARA LOW
	BSF	LED	    ;ACENDE O LED PARA IDENTIFICA��O CORRETA
	CALL	delay_200ms ;ESPERA 200ms
	BCF	LED
	BANK1				
	MOVLW	B'00000011'	;GP0 E GP1 DE VOLTA PARA ENTRADA
	MOVWF	TRISIO		
	BANK0
GOTO	STOP_BIT_SCL
	
ACK_NOP	
	CLRF	ENDERECO    ;LIMPA ENDERE�O PARA PROXIMA AQUISI��O
	BCF	STATUS,C    ;LIMPA CARRY PARA OS PROXIMOS RLF
				
			    ;IDENTIFICA SE � STOP_BIT
STOP_BIT_SCL		    ;CASO SCL ESTEJA EM ALTO E SDA EM ALTO, EH STOP_BIT
	BTFSC	SCL
	GOTO	STOP_BIT_SDA
	GOTO	STOP_BIT_SCL

STOP_BIT_SDA
	BTFSC	SDA
	GOTO	$+2
GOTO	STOP_BIT_SDA	
	
GOTO MAIN		    ;VOLTA PARA ESPERAR OUTRO ENDERE�O

	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
