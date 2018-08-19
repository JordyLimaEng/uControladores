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

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
		
		CONT_5		;Variáveis CONT_x são usadas na manipulação
		CONT_6		;e criação dos diferentes delays necessários
		CONT_7
		CONT_8
		CONT_9
		CONT_10
		CONT_BIT	;Faz a contagem de quanto tempo passa em LOW
		DECODE		;Recebe o sinal enviado pelo controle na forma MSB-LSB
		AUX_SINAL	;Variável que é decrementada sempre que um novo sinal é identificado
		AUX_TRATA   	;Variável que é uma cópia do que se recebe em DECODE, afim de fazer
				;Verificação de qual número será mostrado no display de 7seg
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

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;uC 2018.1
;Atividade 3 - Decodificador de Protocolo Infravermelho Controle Sony	
;Aluno: Jordy Allyson de Sousa Lima - 11426758

INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	CALL	0X3FF
	MOVWF	OSCCAL
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	CLRF	GPIO
	CLRF	CONT_5
	CLRF	CONT_6
	CLRF	CONT_7
	CLRF	CONT_8
	CLRF	CONT_9
	CLRF	CONT_10
	CLRF	DECODE
	CLRF	CONT_BIT
	CLRF	AUX_TRATA
	MOVLW	.9	    ;VALOR QUE SERÁ DECREMENTADO, ATÉ CHEGAR NO FINAL
	MOVWF	AUX_SINAL   ;DO SINAL DE CONTROLE
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	BTFSS	   GPIO,GP3	    ;A CADA CHEGADA DE SINAL DO SENSOR IR, VERIFICA
	CALL	   VERIFICA	    ;SE O SINAL CONTINUA EM HIGH, SE NÃO VAI 
	GOTO MAIN		    ;SER VERIFICADO QUE TIPO DE SINAL ESTÁ RECEBENDO.
	
VERIFICA
	CLRF	CONT_BIT	    ;TODA VEZ QUE FOR FAZER UMA NOVA VERIFICAÇÃO, ZERA A CONTAGEM.
	
	CALL	delay_25us	    ;ATRASO QUE SERVE COMO FORMA DE VERIFICAR QUANTO TEMPO PRECISA
	VER_AUX			    ;PASSAR PARA QUE SEJA ST_BIT, ZERO OU UM.
	
	CALL	   delay_25us	    ;ESTA ROTINA (VER_AUX) POSSUI UM TEMPO DE EXECUÇÃO DE ~37us
	BTFSC	   GPIO,GP3	    ;SENDO ASSIM, TEREMOS OS VALORES APROXIMADOS DE QUANTAS CONTAGENS
	GOTO	   CONTADOR	    ;PRECISAM SER FEITAS EM LOW PARA QUE SE IDENTIFIQUE CADA BIT
	INCF	   CONT_BIT	    ;CORRETAMENTE.
GOTO	   VER_AUX		    

CONTADOR
	DECFSZ	AUX_SINAL	    ;SEMPRE QUE É FEITA UMA VERIFICAÇÃO, DECREMENTA-SE AUX_SINAL
	GOTO	debg		    ;CASO SEJA IGUAL A ZERO (RECEBEU TODOS OS SINAIS DE CONTROLE)
	GOTO	IGNORA_RESTO	    ;O RESTO DOS SINAIS (DEVICE) SÃO IGNORADOS.
    debg
    ;IDENTIFICA START_BIT
	MOVLW	.55			;COMO A ROTINA RESPONSÁVEL PELA CONTAGEM LEVA 37us PARA SER EXECUTADA
	SUBWF	CONT_BIT,0		;TEMOS QUE PARA IDENTIFICAR QUE O BIT É START_BIT FAZEMOS 2.400/37 = 64
	BTFSS	STATUS,C		;O QUE SERIA O PONTO DE LIMIAR DO SINAL, COMO ESTE NÚMERO PODE VARIAR 
	GOTO	CONTADOR_EH1		;BASTANTE, ESCOLHEU-SE 55 POR SER UMA APROXIMAÇÃO BOA, DE ACORDO COM 
	GOTO	DECODE_RECEBE_START_BIT ;TESTES EM BANCADA.
	
    ;IDENTIFICA UM
	CONTADOR_EH1		    ;USANDO O CONCEITO ADOTADO EM START_BIT, TEMOS QUE PARA QUE SEJA UM
	MOVLW	.24		    ;1.200/37 = 32 QUE É O LIMIAR PARA DETERMINAR SE É UM. SENDO ASSIM, 
	SUBWF	CONT_BIT,0	    ;UMA BOA APROXIMAÇÃO FOI DE 24, DE ACORDO COM OS TESTES EM BANCADA.
	BTFSS	STATUS,C
	GOTO	CONTADOR_EH0
	GOTO	DECODE_RECEBE_1
	
    ;IDENTIFICA ZERO
	CONTADOR_EH0		    ;USANDO O CONCEITO ADOTADO EM START_BIT, TEMOS QUE PARA QUE SEJA UM
	MOVLW	.12		    ;600/37 = 16 QUE É O LIMIAR PARA DETERMINAR SE É ZERO. SENDO ASSIM,
	SUBWF	CONT_BIT,0	    ;UMA BOA APROXIMAÇÃO FOI DE 12, DE ACORDO COM OS TESTES EM BANCADA.
	BTFSS	STATUS,C
	GOTO	VERIFICA_AINDA
	GOTO	DECODE_RECEBE_0
	
	VERIFICA_AINDA		    ;CASO NÃO SEJA NENHUM DOS 3, VOLTA A ESPERAR
	    BTFSC   GPIO,GP3	    ;NIVEL ALTO, ATÉ UMA NOVA DESCIDA ONDE REFAZ	
	    GOTO    MAIN	    ;A CONTAGEM E VERIFICAÇÃO DOS NÚMEROS
	GOTO	VERIFICA_AINDA
	
	;============================
	
	IGNORA_RESTO		    ;DÁ UM DELAY DE 2.5ms PARA IGNORAR O SINAL DE DEVICE.
	    MOVLW   .9		    ;REINICIA A NOVA CONTAGEM QUE SERÁ FEITA.
	    MOVWF   AUX_SINAL	    
	    CALL   delay_2.2ms	    ;CHAMA A ROTINA PARA DELAY.
	GOTO	   TRATA_SINAL	    ;PARTE PARA O TRATAMENTO DO SINAL QUE FOI RECEBIDO EM DECODE
	
	;===============================
	;A CADA IDENTIFICAÇÃO DE BIT, COLOCA-SE NA VARIÁVEL DECODE
	;O BIT CORRESPONDENTE À IDENTIFICAÇÃO.
	DECODE_RECEBE_START_BIT	    
	    BCF	   STATUS,C	    
	    RRF	   DECODE,F	    
	GOTO	MAIN	    
	
	DECODE_RECEBE_1
	    BSF	   STATUS,C
	    RRF	   DECODE,F
	GOTO	MAIN
	
	DECODE_RECEBE_0
	    BCF	   STATUS,C
	    RRF	   DECODE,F
	GOTO	MAIN	
	
	;==========INICIO TRATA SINAL============
	TRATA_SINAL	      ;NESTE PONTO DO PROGRAMA, DECODE JÁ ESTÁ COM TODOS
	    BCF	    STATUS,C  ;SINAIS, INCLUINDO ST_BIT. COM ISSO, É FEITO RRF
	    RRF	    DECODE,F  ;PARA IGNORAR ST_BIT E A PARTIR DISTO, EXIBIR NO DISPLAY.
	    MOVF    DECODE,W	
	    MOVWF   AUX_TRATA
			    
	BOTAO_0			;EM CADA LABEL RESPONSAVEL PELO BOTÃO, É FEITA
	    MOVLW   .9		;UMA SUBTRAÇÃO DO VALOR IDENTIFICADO EM DECODE
	    SUBWF   AUX_TRATA,0	;ONDE QUANDO O RESULTADO DA SUBTRAÇÃO FOR ZERO
	    BTFSC   STATUS,Z	;TEM-SE QUE O BOTÃO PRESSIONADO CORRESPONDE
	    GOTO    DISPLAY_0	;AO BOTÃO QUE A LABEL INDICA, CASO NÃO,
				;UM LED PISCA COM UM INTERVALO DE 100ms
	BOTAO_1			;INDICANDO QUE AQUELE BOTÃO NÃO É TRATADO.
	    MOVLW   .0
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_1
	    
	BOTAO_2
	    MOVLW   .1
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_2
	    
	BOTAO_3
	    MOVLW   .2
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_3
	    
	BOTAO_4
	    MOVLW   .3
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_4
	    
	BOTAO_5
	    MOVLW   .4
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_5
	    
	BOTAO_6
	    MOVLW   .5
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_6
	    
	BOTAO_7
	    MOVLW   .6
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_7
	    
	BOTAO_8
	    MOVLW   .7
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_8
	    
	BOTAO_9
	    MOVLW   .8
	    SUBWF   AUX_TRATA,0
	    BTFSC   STATUS,Z
	    GOTO    DISPLAY_9
	
	BOTAO_QUALQUER
	    BSF	    GPIO,GP5
	    CALL    delay_100ms
	    BCF	    GPIO,GP5
	    
	    BSF	    GPIO,GP0	;1
	    BSF	    GPIO,GP1	;1
	    BSF	    GPIO,GP2	;1
	    BSF	    GPIO,GP4	;1
	    CALL   delay_2.2ms
	GOTO	MAIN
	;==========FIM TRATA SINAL=============
	
	;==========CONFIGURAÇÃO DISPLAYS=============
	;GP0 - MSB
	;GP1
	;GP2
	;GP4 - LSB
	DISPLAY_0
	    BCF	    GPIO,GP0	;0
	    BCF	    GPIO,GP1	;0
	    BCF	    GPIO,GP2	;0
	    BCF	    GPIO,GP4	;0
	    CALL   delay_2.2ms	   ;ESTE DELAY FOI NECESSÁRIO POIS AO SE FAZER
				   ;TESTES NA BANCADA, O DISPLAY ENCONTRAVA ALGUM
				   ;LIXO COMO SINAL E FICAVA INSTÁVEL.
	GOTO	MAIN
	
	DISPLAY_1
	    BCF	    GPIO,GP0	;0
	    BCF	    GPIO,GP1	;0
	    BCF	    GPIO,GP2	;0
	    BSF	    GPIO,GP4	;1
	    CALL   delay_2.2ms
	GOTO	MAIN
	
	DISPLAY_2
	    BCF	    GPIO,GP0	;0
	    BCF	    GPIO,GP1	;0
	    BSF	    GPIO,GP2	;1
	    BCF	    GPIO,GP4	;0
	    CALL   delay_2.2ms
	GOTO	MAIN
	
	DISPLAY_3
	    BCF	    GPIO,GP0	;0
	    BCF	    GPIO,GP1	;0
	    BSF	    GPIO,GP2	;1
	    BSF	    GPIO,GP4	;1
	    CALL   delay_2.2ms
	GOTO	MAIN
	
	DISPLAY_4
	    BCF	    GPIO,GP0	;0
	    BSF	    GPIO,GP1	;1
	    BCF	    GPIO,GP2	;0
	    BCF	    GPIO,GP4	;0
	    CALL   delay_2.2ms
	GOTO	MAIN
	
	DISPLAY_5
	    BCF	    GPIO,GP0	;0
	    BSF	    GPIO,GP1	;1
	    BCF	    GPIO,GP2	;0
	    BSF	    GPIO,GP4	;1
	    CALL   delay_2.2ms
	GOTO	MAIN
	
	DISPLAY_6
	    BCF	    GPIO,GP0	;0
	    BSF	    GPIO,GP1	;1
	    BSF	    GPIO,GP2	;1
	    BCF	    GPIO,GP4	;0
	    CALL   delay_2.2ms
	GOTO	MAIN
	
	DISPLAY_7
	    BCF	    GPIO,GP0	;0
	    BSF	    GPIO,GP1	;1
	    BSF	    GPIO,GP2	;1
	    BSF	    GPIO,GP4	;1
	    CALL   delay_2.2ms
	GOTO	MAIN
	
	DISPLAY_8
	    BSF	    GPIO,GP0	;1
	    BCF	    GPIO,GP1	;0
	    BCF	    GPIO,GP2	;0
	    BCF	    GPIO,GP4	;0
	    CALL   delay_2.2ms
	GOTO	MAIN
	
	DISPLAY_9
	    BSF	    GPIO,GP0	;1
	    BCF	    GPIO,GP1	;0
	    BCF	    GPIO,GP2	;0
	    BSF	    GPIO,GP4	;1
	    CALL   delay_2.2ms
	GOTO	MAIN
	;==========FIM CONFIGURAÇÃO DISPLAYS=============

;=================== DELAYS =====================	
;NA BASE DE TESTES, TANTO NA BANCADA QUANDO NO SIMULADOR, TEMOS OS SEGUINTES 
;DELAYS. ONDE CADA UM RECEBE UM VALOR ESPECÍFICO DE NOP'S E NOS CONTADORES
;AFIM DE QUE ALCANCE O TEMPO DESEJADO.
delay_25us
	    MOVLW   D'2'   
	    MOVWF   CONT_7  

aux7
	    MOVLW   D'2'  
	    MOVWF   CONT_8  

aux8			    
	    DECFSZ CONT_8
	    goto aux8
	    
	    DECFSZ CONT_7
	    goto aux7
return
	    
delay_2.2ms
	    MOVLW   D'30'  			    
	    MOVWF   CONT_5  

aux5
	    MOVLW   D'8'  
	    MOVWF   CONT_6  

aux6			    
	    nop		    
	    nop		    
	    nop		    
	    nop		    
	    nop		    
	    NOP
	    NOP
	    NOP
	    
	    DECFSZ CONT_6
	    goto aux6
	    
	    DECFSZ CONT_5
	    goto aux5
return

delay_100ms
	    MOVLW   D'400'  			    
	    MOVWF   CONT_9  

aux9
	    MOVLW   D'125'  
	    MOVWF   CONT_10  

aux10	
	    NOP
	    NOP
	    NOP
	    
	    DECFSZ CONT_10
	    goto aux10
	    
	    DECFSZ CONT_9
	    goto aux9
return	    

;=================== FIM DELAYS =====================	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
