;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
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
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA
#DEFINE SCL	GPIO,GP0
#DEFINE SDA	GPIO,GP1
#DEFINE LED	GPIO,GP5

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
		ENDERECO	;VARIÁVEL QUE RECEBE O ENDEREÇO ENVIADO DO MASTER
		

		;NOVAS VARIÁVEIS

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

SUBROTINA1
	
delay_200ms
	MOVLW	.2
	MOVWF	CONT
inicio
	BCF	  PIR1,TMR1IF
	MOVLW   .158		;INICIA O TIMER1 COM TMR1H = 158
	MOVWF   TMR1H		;FORMULA TIMER1 = (255 - TMR1H)*255
	MOVLW   .0
	MOVWF   TMR1L		;TMR1L SERVE COMO PRECISÃO
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
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES	
	BANK0				;RETORNA PARA O BANCO
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

VERIFICA_SDA		    ;TESTA SDA ENQUANTO ESTIVER EM 1
	BTFSS	SDA	    ;QUANDO FOR PRA ZERO, ANALISA SE O CLOCK ESTÁ EM 1
	GOTO	VERIFICA_SCL
	GOTO	VERIFICA_SDA
	
VERIFICA_SCL
	BTFSC	SCL	    ;SE O CLOCK ESTIVER EM 1, IDENTIFICA-SE START_BIT
	GOTO	START_BIT
	GOTO	VERIFICA_SDA;SE NÃO, VOLTA A VERIFICAR SDA ATÉ QUE SEJA 0 NOVAMENTE
	
START_BIT		    ;AQUI JÁ É IDENTIFICADO O ST_BIT, AGORA SÓ ESPERA
	BTFSS	SCL	    ;VOLTAR PARA 0 PARA COMEÇAR IDENTIFICAR OS CLK DOS DADOS
	GOTO	CLK_1
	GOTO	START_BIT
	
;OS DADOS SÃO INTERPRETADOS DA SEGUINTE FORMA (MODO SLAVE):
;SDA ->  D7  D6  D5  D4  D3  D2  D1  D0 R/W ACK
;SCL -> CK1 CK2 CK3 CK4 CK5 CK6 CK7 CK8 CK9 CK10

CLK_1			    ;IDENTIFICAÇÃO DO PRIMEIRO CLOCK DE DADO (CLK_1 E DADO_7)
	BTFSC	SCL 
	GOTO	DADO_7
	GOTO	CLK_1

DADO_7
	INCF	ENDERECO    ;SE JÁ É UM, INCREMENTA ENDEREÇO E FAZ RLF
	BTFSS	SDA	    ;SE SDA FOR ZERO, ENDEREÇO RECEBE ZERO
	DECF	ENDERECO
	RLF	ENDERECO
A1	
	BTFSS	SCL
	GOTO	CLK_2
GOTO A1
	
CLK_2			    ;IDENTIFICAÇÃO (CLK_2 E DADO_6)
	BTFSC	SCL
	GOTO	DADO_6
	GOTO	CLK_2

DADO_6
	INCF	ENDERECO    ;SE JÁ É UM, INCREMENTA ENDEREÇO E FAZ RLF
	BTFSS	SDA	    ;SE SDA FOR ZERO, ENDEREÇO RECEBE ZERO
	DECF	ENDERECO
	RLF	ENDERECO
A2	
	BTFSS	SCL
	GOTO	CLK_3
GOTO A2
	
CLK_3			    ;IDENTIFICAÇÃO (CLK_3 E DADO_5)
	BTFSC	SCL
	GOTO	DADO_5
	GOTO	CLK_3

DADO_5
	INCF	ENDERECO    ;SE JÁ É UM, INCREMENTA ENDEREÇO E FAZ RLF
	BTFSS	SDA	    ;SE SDA FOR ZERO, ENDEREÇO RECEBE ZERO
	DECF	ENDERECO
	RLF	ENDERECO
A3	
	BTFSS	SCL
	GOTO	CLK_4
GOTO A3

CLK_4			    ;IDENTIFICAÇÃO (CLK_4 E DADO_4)
	BTFSC	SCL
	GOTO	DADO_4
	GOTO	CLK_4

DADO_4
	INCF	ENDERECO    ;SE JÁ É UM, INCREMENTA ENDEREÇO E FAZ RLF
	BTFSS	SDA	    ;SE SDA FOR ZERO, ENDEREÇO RECEBE ZERO
	DECF	ENDERECO
	RLF	ENDERECO
A4	
	BTFSS	SCL
	GOTO	CLK_5
GOTO A4
	
CLK_5			    ;IDENTIFICAÇÃO (CLK_5 E DADO_3)
	BTFSC	SCL
	GOTO	DADO_3
	GOTO	CLK_5

DADO_3
	INCF	ENDERECO    ;SE JÁ É UM, INCREMENTA ENDEREÇO E FAZ RLF
	BTFSS	SDA	    ;SE SDA FOR ZERO, ENDEREÇO RECEBE ZERO
	DECF	ENDERECO
	RLF	ENDERECO
A5
	BTFSS	SCL
	GOTO	CLK_6
GOTO A5
	
CLK_6			    ;IDENTIFICAÇÃO (CLK_6 E DADO_2)
	BTFSC	SCL
	GOTO	DADO_2
	GOTO	CLK_6

DADO_2
	INCF	ENDERECO    ;SE JÁ É UM, INCREMENTA ENDEREÇO E FAZ RLF
	BTFSS	SDA	    ;SE SDA FOR ZERO, ENDEREÇO RECEBE ZERO
	DECF	ENDERECO
	RLF	ENDERECO
A6
	BTFSS	SCL
	GOTO	CLK_7
GOTO A6
	
CLK_7			    ;IDENTIFICAÇÃO (CLK_7 E DADO_1)
	BTFSC	SCL
	GOTO	DADO_1
	GOTO	CLK_7

DADO_1
	INCF	ENDERECO    ;SE JÁ É UM, INCREMENTA ENDEREÇO E FAZ RLF
	BTFSS	SDA	    ;SE SDA FOR ZERO, ENDEREÇO RECEBE ZERO
	DECF	ENDERECO
	RLF	ENDERECO
A7
	BTFSS	SCL
	GOTO	CLK_8
GOTO A7

	
CLK_8			    ;IDENTIFICAÇÃO (CLK_8 E DADO_0)
	BTFSC	SCL
	GOTO	DADO_0
	GOTO	CLK_8

DADO_0
	INCF	ENDERECO    ;SE JÁ É UM, INCREMENTA ENDEREÇO 
	BTFSS	SDA	    ;SE SDA FOR ZERO, ENDEREÇO RECEBE ZERO
	DECF	ENDERECO	

RW
	BTFSC	SCL
	GOTO	IGNORA_RW   ;IGNORA O RW
GOTO	RW
	
IGNORA_RW
	BTFSS	SCL	    ;IGNORA O RW
	GOTO	$+2
GOTO	IGNORA_RW
	
VERIFICA_ENDERECO
	BCF	STATUS,Z
	MOVLW	.51	    ;MEU ENDEREÇO FICOU DEFINIDO COMO 51
	SUBWF	ENDERECO,W  ;0011 0011
	BTFSS	STATUS,Z
	GOTO	ACK_NOP
ACK_YEP			    ;SE O ENDEREÇO FOI IDENTIFICADO CORRETAMENTE
	CLRF	ENDERECO    ;LIMPA ENDEREÇO PARA PROXIMA AQUISIÇÃO
	BCF	STATUS,C    ;LIMPA CARRY PARA OS PROXIMOS RLF
	BANK1				
	MOVLW	B'00000000'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	BANK0
	BCF	SDA	    ;MANDA ACKNOWLEDGE
	BCF	SCL	    ;FORÇA SCL PARA LOW
	BSF	LED	    ;ACENDE O LED PARA IDENTIFICAÇÃO CORRETA
	CALL	delay_200ms ;ESPERA 200ms
	BCF	LED
	BANK1				
	MOVLW	B'00000011'	;GP0 E GP1 DE VOLTA PARA ENTRADA
	MOVWF	TRISIO		
	BANK0
GOTO	STOP_BIT_SCL
	
ACK_NOP	
	CLRF	ENDERECO    ;LIMPA ENDEREÇO PARA PROXIMA AQUISIÇÃO
	BCF	STATUS,C    ;LIMPA CARRY PARA OS PROXIMOS RLF
;	BANK1				
;	MOVLW	B'00000000'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
;	MOVWF	TRISIO		;COMO SAÍDAS
;	BANK0
;	BSF	SDA	    ;MANDA NOT ACKNOWLEDGE
;	;BCF	SCL	    ;FORÇA SCL PARA LOW
;	;CALL	delay_200ms ;ESPERA 200ms
;	BANK1				
;	MOVLW	B'00000011'	;GP0 E GP1 DE VOLTA PARA ENTRADA
;	MOVWF	TRISIO		
;	BANK0
				
			    ;IDENTIFICA SE É STOP_BIT
STOP_BIT_SCL		    ;CASO SCL ESTEJA EM ALTO E SDA EM ALTO, EH STOP_BIT
	BTFSC	SCL	    ;E PRIMEIRO SCL SUBA E DEPOIS SDA
	GOTO	STOP_BIT_SDA
	GOTO	STOP_BIT_SCL

STOP_BIT_SDA
	BTFSC	SDA
	GOTO	$+2
GOTO	STOP_BIT_SDA	



GOTO MAIN		    ;VOLTA PARA ESPERAR OUTRO ENDEREÇO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
