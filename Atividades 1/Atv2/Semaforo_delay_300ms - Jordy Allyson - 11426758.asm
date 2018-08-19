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

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MEMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
		CONT_1
		CONT_2
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
;Aluno: Jordy Allyson de Sousa Lima - 11426758
;Atividade 2 - Simulação de Semáforo Simples com Delay de 300ms	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	MOVWF	CONT_1
	MOVWF	CONT_2
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	BSF	   GPIO,GP5	;LED1 = HIGH        LED2 = LOW
	CALL	   CONTAGEM	;DELAY CONTAGEM DE 9 a 0 - duração 3s
	BCF	   GPIO,GP5	;LED1 = LOW         LED2 = HIGH
	CALL	   CONTAGEM	;DELAY CONTAGEM DE 9 a 0 - duração 3s
	GOTO	   MAIN	
	
CONTAGEM	    ;GP0 - MSB e GP4 - LSB
Seg_9
	    BSF	    GPIO,GP0	;1 
	    BCF	    GPIO,GP1	;0
	    BCF	    GPIO,GP2	;0
	    BSF	    GPIO,GP4	;1
	    CALL delay300ms
Seg_8
	    BSF	    GPIO,GP0	;1
	    BCF	    GPIO,GP1	;0
	    BCF	    GPIO,GP2	;0
	    BCF	    GPIO,GP4	;0
	    CALL delay300ms
Seg_7
	    BCF	    GPIO,GP0	;0
	    BSF	    GPIO,GP1	;1
	    BSF	    GPIO,GP2	;1
	    BSF	    GPIO,GP4	;1
	    CALL delay300ms
Seg_6
	    BCF	    GPIO,GP0	;0
	    BSF	    GPIO,GP1	;1
	    BSF	    GPIO,GP2	;1
	    BCF	    GPIO,GP4	;0
	    CALL delay300ms
Seg_5
	    BCF	    GPIO,GP0	;0
	    BSF	    GPIO,GP1	;1
	    BCF	    GPIO,GP2	;0
	    BSF	    GPIO,GP4	;1
	    CALL delay300ms
Seg_4
	    BCF	    GPIO,GP0	;0
	    BSF	    GPIO,GP1	;1
	    BCF	    GPIO,GP2	;0
	    BCF	    GPIO,GP4	;0
	    CALL delay300ms
Seg_3
	    BCF	    GPIO,GP0	;0
	    BCF	    GPIO,GP1	;0
	    BSF	    GPIO,GP2	;1
	    BSF	    GPIO,GP4	;1
	    CALL delay300ms
Seg_2
	    BCF	    GPIO,GP0	;0
	    BCF	    GPIO,GP1	;0
	    BSF	    GPIO,GP2	;1
	    BCF	    GPIO,GP4	;0
	    CALL delay300ms
	    
Seg_1
	    BCF	    GPIO,GP0	;0
	    BCF	    GPIO,GP1	;0
	    BCF	    GPIO,GP2	;0
	    BSF	    GPIO,GP4	;1
	    CALL delay300ms
	    
Seg_0
	    BCF	    GPIO,GP0	;0
	    BCF	    GPIO,GP1	;0
	    BCF	    GPIO,GP2	;0
	    BCF	    GPIO,GP4	;0
	    CALL delay300ms
return

delay300ms
	    MOVLW   D'200'  ;ATRAVÉS DO CALCULO DO TEMPO APROXIMADO (Explicado
			    ;no comentário sobre o delay)
	    MOVWF   CONT_1  ;TEM-SE O VALOR DE 200 PARA O CONT_1

aux1
	    MOVLW   D'187'  ;IDEM AO COMENTARIO ANTERIOR
	    MOVWF   CONT_2  ;TEM-SE O VALOR DE 187 PARA O CONT_2

aux2			    ;####DELAY####
	    nop		    ;USA-SE A SEGUINTE EQUAÇÃO COMO LÓGICA:
	    nop		    ;CONT_2 * (QT_DE_OP_nop + DECFSZ + GOTO) = QT_DE_CICLOS
	    nop		    ;QT_DE_CICLOS * CONT_1 = TEMPO_DE_DELAY
	    nop		    ;EX.: 8us -> 5us(nop's) + 1us (DECFSZ) + 2us (GOTO)
	    nop		   ;187 * 8 = 1496 ciclos de máquina (1496us ou 1,496ms)
			    ;1496 * 200 = 299,200 ms ~ 300ms
	    
	    DECFSZ CONT_2
	    goto aux2
	    
	    DECFSZ CONT_1
	    goto aux1
return	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END

