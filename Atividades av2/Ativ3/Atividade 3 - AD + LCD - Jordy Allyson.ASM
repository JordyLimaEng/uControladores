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
#DEFINE	  LCD_EN   GPIO,GP5
#DEFINE	  SR_DAT   GPIO,GP4
#DEFINE	  SR_CLOCK GPIO,GP0	
#DEFINE	  LED1	   GPIO,GP1
#DEFINE	  LED2	   GPIO,GP0
#DEFINE	  LED3	   GPIO,GP4
#DEFINE	  LED4	   GPIO,GP5
#define bf_carry 3, 0
#define bf_zero 3, 2
#define stc bsf bf_carry
#define clc bcf bf_carry
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
		
		;VARIÁVEIS PARA O LCD		
		LETRA	
		DADOS_LCD
		
		;VARIÁVEIS PARA A PARTE DE CONVERSÃO
		Valor_ad	;VARIÁVEL QUE RECEBE O VALOR CONVERTIDO
		CONTADOR	;CONTA AS VEZES QUE CONVERTEU
		CONTADOR_AUX
		Valor_Lido	;RECEBE O VALOR CONVERTIDO
		CARRY_BIT	;AUXILIAR PARA ACUMULAÇÃO
		MEDIA		;RECEBE A MÉDIAS DAS AQUISIÇÕES
		PORCENT		;VARIÁVEIS PARA CALCULO DA PORCENTAGEM
		resulthi	;RESULTADO PARTE ALTA DA MULT
		resultlo	;RESULTADO PARTE BAIXA DA MULT
		f_divhi		;RESULTADO PARTE ALTA DA DIV
		f_divlo		;RESULTADO PARTE BAIXA DA DIV
		dezena		;PARTE DAS DEZENAS NA PORCENTAGEM
		unidade		;PARTE DAS UNIDADES NA PORCENTAGEM
		valor_10	;VALOR QUE SE QUER DIVIDIR POR 10
		

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
	
	LE_EEPROM
;LER DADO DA EEPROM, CUJO ENDEREÇO É INDICADO EM W
;DADO LIDO RETORNA EM W
	ANDLW	.127		;LIMITA ENDEREÇO MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR		;INDICA O END. DE LEITURA
	BSF		EECON1,RD	;INICIA O PROCESSO DE LEITURA
	MOVF	EEDATA,W	;COLOCA DADO LIDO EM W
	BANK0				;POSICIONA PARA BANK 0
	RETURN

GRAVA_EEPROM
;ESCREVE DADO (DADO) NA EEPROM, CUJO ENDEREÇO É INDICADO EM W
	ANDLW	.127		;LIMITA ENDEREÇO MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR
	MOVF	Valor_ad,W
	MOVWF	EEDATA
	BSF		EECON1,WREN ;HABILITA ESCRITA
	BCF		INTCON,GIE	;DESLIGA INTERRUPÇÕES
	MOVLW	B'01010101'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	MOVLW	B'10101010'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	BSF		EECON1,WR ;INICIA A ESCRITA
AGUARDA
	BTFSC	EECON1,WR ;TERMINOU?
	GOTO	AGUARDA
	BSF		INTCON,GIE ;HABILITA INTERRUPÇÕES
	BANK0				;POSICIONA PARA BANK 0
	RETURN

;Referência das rotinas:http://www.piclist.com/techref/microchip/math/	
;######### ROTINAS DE DIVISÃO E MULTIPlICAÇÃO BASEADAS NO AN544 ########
;######### MULTIPLICAÇÃO
;***************************************************************************
;**		    8 bit x 8 bit = 16 bit (sem sinal)
;**
;**  multiplicador:   no work
;**  multiplicando:   no resultlo
;**  resultado: parte alta  em => resulthi 
;		parte baixa em => resultlo
;***************************************************************************
;Através de sucessivas somas e rrf, consegue multiplicar dois números de 8bit
Mul8x8                          ;* 2 ciclos 
mult    MACRO					;Para n ter que ficar fazendo CALL
        btfsc   STATUS,C
        addwf   resulthi,F
        rrf     resulthi,F
        rrf     resultlo,F
        ENDM

        clrf    resulthi                ;* 1 ciclos
        rrf     resultlo,F              ;* 1 ciclos
	;chama a label mult 8x afim de fazer a multiplicação
        mult                            ;* 4 ciclos
        mult                            ;* 4 ciclos
        mult                            ;* 4 ciclos
        mult                            ;* 4 ciclos
        mult                            ;* 4 ciclos
        mult                            ;* 4 ciclos
        mult                            ;* 4 ciclos
        mult                            ;* 4 ciclos

        retlw 0                 ;* 2 ciclos
return
	
;######## DIVISÃO
Dividir
; Recebe: Parte alta e baixa em f_divhi:f_divlo, divisor em W.
; Retorna: Quociente em f_divlo, resto em f_divhi. W não altera.
;          Carry recebe 1 se der erro. Z seta se divisão pro zero, 
;	   NZ seta se registrador estourar.

Div;
    addlw 0          ; w+=0 (testa se é divisão por zero)
    stc              ; set em carry se erro
    btfsc bf_zero    ; se zero
     return          ; retorna (erro C,Z)

    call DivPulaShiftD
Repete = 8		;8 pelo número de bits
while Repete	;Através de rlf faz as divisões no valor recebido
    call DivCode
Repete--
endw

    rlf f_divlo, 1 ; C << lo << C

    bcf bf_zero  ; NZ (seta se houver overflow)
    return       ; Fim da operação

DivCode
    rlf f_divlo, 1    ; C << lo << C
    rlf f_divhi, 1    ; C << hi << C
    btfss bf_carry       ; 
     goto DivPulaShiftD ;
    subwf f_divhi, 1  ;   hi-=w
    stc                  ;   ignora carry
    return               
                         
DivPulaShiftD
    subwf f_divhi, 1  ; hi-=w
    btfsc bf_carry       ; ignora carry
     return              ;   fim
    addwf f_divhi, 1  ; hi+=w
    clc                  ; limpa carry	
return
    
;######## DIVISÃO POR 10  
Divisao_por_10   
	clrf dezena	;Limpa o valor anterior
	MOVWF	valor_10
dezena_t  
	bcf STATUS,Z	
	bcf STATUS,C	
	movlw .10		;Valor do denominador, no caso da funçâo, 10.  
	subwf valor_10,0 ;Faz subtração de valor_10 - W, guarda resultado em W  
	btfss STATUS,Z	;Primeiro teste verifica se valor_10 = W.  
	goto dezena_p	;A divisão é possível.  
	incf dezena,1	;valor_10=10, logo incrementa o regist dezena  
	movwf unidade	;Completa o outro digito unidade com o valor 0  
	goto out    	;Divisão não é possível.  
dezena_p
	btfss STATUS,C	;segundo teste verifica se a divisão é possível  
	goto out_temp	;valor_10 menor que 10,divisão não é possível.  
	movwf valor_10	;resultado da subtração passa para o regist valor_10.  
	incf dezena,1	;soma 1 ao regist  
	goto dezena_t   ;volta ao inicio, para mais divisões... 
out_temp 
	movf valor_10,0	;resto da divisão fica no regist unidades  
	movwf unidade	;  
out 
	return

	
;***************************************************************************

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000100'	;GP0 COMO ENTRADA
	MOVWF	TRISIO		;COMO SAÍDAS
	MOVLW	B'00100100'	;AN0 COMO ENTRADA ANALOGICA
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'11000000'
	MOVWF	INTCON		;DEFINE OPÃ?Ã?ES DE INTERRUPÃ?Ã?ES
	CALL	0X3FF
	MOVWF	OSCCAL
	
	BCF	 PIE1,TMR1IE	;DESABILITA A INTERRUPÇÃO PELO TIMER1
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00001001'	;SELECIONA A ENTRADA AN0
	MOVWF	ADCON0
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	BSF	T1CON,TMR1ON	;HABILITA O TIMER1
	BCF	T1CON,TMR1CS	;DEFINE O CLOCK DE OPERAÇÃO INTERNO
	BCF	T1CON,T1CKPS1	
	BCF	T1CON,T1CKPS0	;PRESCALER 1:1	
	CLRF	DADOS_LCD
	CLRF	GPIO
	CLRF CONTADOR
	CLRF	Valor_ad
	BSF	ADCON0,ADON
	
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;Os 200ms de atualização do display, são conseguidos através da chamada não muito usual
;da rotina de gravação da EEPROM 32x, o que resulta em um delay de ~190ms.
	CALL INIT_LCD	
LOOP		
	BSF ADCON0,GO_DONE		;HABILITA CONVERSÃO
WAIT_ADC
	BTFSC ADCON0,GO_DONE		;ESPERA ATÉ A CONVERSÃO FINALIZAR
	GOTO  WAIT_ADC
	
	MOVF	ADRESH,W		;COPIA O VALOR CONVERTIDO PARA UMA VARIÁVEL
	MOVWF   Valor_ad		;PARA POSTERIOR ACUMULAÇÃO.
	MOVFW	CONTADOR		;CONTADOR QUE SERVE PARA INDICAR AS POSIÇÕES
	CALL	GRAVA_EEPROM	;DA EEPROM QUE RECEBERÃO OS VALORES VINDO DO A/D.
	CLRF	Valor_ad		;LIMPA O VALOR ATUAL PARA RECEBER OS PRÓXIMOS.
	
	MOVFW	CONTADOR		;COPIA A QUANTIDADE DE CONVERSÕES FEITAS PARA UM AUXILIAR
	MOVWF	CONTADOR_AUX		;PARA PRESERVAR O VALOR ATUAL
	CALL	ACUMULA_VALORES		;CHAMA A ROTINA PARA SOMAR AS AQUISIÇÕES ATÉ AQUI FEITAS
	
	MOVLW	.31			;VERIFICA SE JÁ FORAM FEITAS 32 AQUISIÇÕES
	SUBWF	CONTADOR_AUX,F
	BTFSC	STATUS,C		;SE NÃO, CONTINUA
	GOTO	PARA			;SE SIM, DESCONTINUA
	
	INCF	CONTADOR
	CLRF	CONTADOR_AUX
	
	CALL delay_100us		;ESPERA UM TEMPO PARA A PRÓXIMA AQUISIÇÃO
	CALL delay_100us
	CALL delay_100us
	CALL delay_100us
	CALL delay_100us
	
goto LOOP
	
PARA					
	CLRF CONTADOR			;LIMPA AS VARIÁVEIS USADAS PARA PRÓXIMA CONVERSÃO.
	CALL FAZ_MEDIA			;CHAMA A ROTINA PARA MÉDIA DAS AQUISIÇÕES.
	CLRF CARRY_BIT			;LIMPA AS VARIÁVEIS USADAS PARA PRÓXIMA CONVERSÃO.
	CLRF Valor_Lido			;LIMPA AS VARIÁVEIS USADAS PARA PRÓXIMA CONVERSÃO.
GOTO	LOOP
	

ACUMULA_VALORES	
	BCF	STATUS,C
	MOVFW	CONTADOR_AUX
	CALL	LE_EEPROM
	ADDWF	Valor_Lido,F
	BTFSC	STATUS,C	;VALOR LIDO FUNCIONANDO
	INCF	CARRY_BIT	;CARRY_BIT FUNCIONANDO
return
	
FAZ_MEDIA		    ;FAZ A MÉDIA DAS 32 AQUISIÇÕES, USANDO RRF 5 VEZES	
	rrf	CARRY_BIT   ;FAZ A MÉDIA DIVIDINDO POR 32, ATRAVÉS DE 5 RRF EM
	rrf	Valor_Lido  ;CARRY_BIT E Valor_Lido
	rrf	CARRY_BIT
	rrf	Valor_Lido
	rrf	CARRY_BIT
	rrf	Valor_Lido
	rrf	CARRY_BIT
	rrf	Valor_Lido
	rrf	CARRY_BIT
	rrf	Valor_Lido

PORCENTAGEM		    ;FAZ A PORCENTAGEM DE ACORDO COM A MÉDIA OBTIDA
	;USANDO REGRA DE 3, ONDE PORCENTAGEM = (100*MEDIA)/255
	;DEPOIS, DIVIDE POR 10 PARA IDENTIFICAR DEZENA E UNIDADE DA PORCENTAGEM
	;PARA ASSIM PODER FAZER O FILTRO E PRINTAR NO LCD.
	MOVFW	Valor_Lido
	MOVWF	MEDIA	    ;PEGA O VALOR MÉDIO DA MEDIDA E JOGA PARA ROTINA DE MULTI
	MOVWF	resultlo
	MOVLW	.100	    ;ESPECIFICA O VALOR Q IRÁ MULTIPLICAR
	CALL	Mul8x8	    ;FAZ A MULTIPLICAÇÃO
	
	movfw	resulthi    ;COPIA O RESULTADO DA MULTIPLICAÇÃO
	movwf	f_divhi	    ;E MANDA PARA A DIVISÃO COMO ARGUMENTO	
	movfw	resultlo
	movwf	f_divlo
	
	MOVLW	.254	    ;DIVIDE POR 255 (COLOCOU-SE 254 POR MOTIVOS DE PRECISÃO)
	CALL	Dividir
	MOVFW	f_divlo	    ;MOVE O QUOCIENTE DA DIVISÃO PARA WORK
	MOVWF	PORCENTAGEM ;MOVE DO WORK O VALOR DA PORCENTAGEM
	
	
	MOVFW	PORCENTAGEM ;MOVE PARA WORK O VALOR DA PORCENTAGEM
	CALL	Divisao_por_10 ;E MANDA COMO ARGUMENTO PARA DIVIR POR 10
	MOVFW	dezena	    ;APÓS, PODE-SE IDENTIFICAR A DEZENA e UNIDADE
	CALL    Printa_Dezena
	CALL	Cursor_prox
    Printou_dezena
	MOVFW	unidade	    ;SUBTRAI UM DA UNIDADE POIS LÊ COMO SE O MÁXIMO FOSSE 101%
	MOVLW	.1
	SUBWF	PORCENTAGEM,f
	MOVFW	unidade
	CALL    Printa_Unidade
	CALL	Cursor_prox2
	MOVLW   0x25
	CALL	ESCREVE
    Limpa
	CALL  Clear_cursor 	;Posiciona o cursor na primeira posição da DDRAM
return

;ANALISA QUAL O VALOR DA DEZENA E MANDA PRINTAR	
Printa_Dezena
	BCF	STATUS,Z		;LIMPA REGISTRADOR Z
	MOVLW	.10			;SE A SUBTRAÇÃO DER RESULTADO 0
	SUBWF	dezena,w	;VALOR ANALISADO É O ENCONTRADO,
	BTFSC	STATUS,Z	;SE NÃO, TESTA OS OUTROS.	
	GOTO	Escreve_10	
	
	BCF	STATUS,Z
	MOVLW	.9
	SUBWF	dezena,w
	BTFSC	STATUS,Z
	GOTO	Escreve_9
	
	BCF	STATUS,Z
	MOVLW	.8
	SUBWF	dezena,w
	BTFSC	STATUS,Z
	GOTO	Escreve_8
	
	BCF	STATUS,Z
	MOVLW	.7
	SUBWF	dezena,w
	BTFSC	STATUS,Z
	GOTO	Escreve_7
	
	BCF	STATUS,Z
	MOVLW	.6
	SUBWF	dezena,w
	BTFSC	STATUS,Z
	GOTO	Escreve_6
	
	BCF	STATUS,Z
	MOVLW	.5
	SUBWF	dezena,w
	BTFSC	STATUS,Z
	GOTO	Escreve_5
	
	BCF	STATUS,Z
	MOVLW	.4
	SUBWF	dezena,w
	BTFSC	STATUS,Z
	GOTO	Escreve_4
	
	BCF	STATUS,Z
	MOVLW	.3
	SUBWF	dezena,w
	BTFSC	STATUS,Z
	GOTO	Escreve_3
	
	BCF	STATUS,Z
	MOVLW	.2
	SUBWF	dezena,w
	BTFSC	STATUS,Z
	GOTO	Escreve_2
	
	BCF	STATUS,Z
	MOVLW	.1
	SUBWF	dezena,w
	BTFSC	STATUS,Z
	GOTO	Escreve_1
	
	BCF	STATUS,Z
	MOVLW	.0
	SUBWF	dezena,w
	BTFSC	STATUS,Z
	GOTO	Escreve_0
return
	
PT1
	CALL delay_100us    ;MOVE CURSOR PARA POSIÇÃO 3 DA DDRAM
	BSF  LCD_EN
	MOVLW	B'00100001' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	BSF  LCD_EN
	MOVLW	B'00100100' ;NIBBLE2
	CALL SHIFT_REGISTER
	BCF  LCD_EN	
	CALL delay_100us 
return

PT2
	CALL delay_100us    ;MOVE CURSOR PARA POSIÇÃO 1 DA DDRAM
	BSF  LCD_EN
	MOVLW	B'00100001' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	BSF  LCD_EN
	MOVLW	B'00100000' ;NIBBLE2
	CALL SHIFT_REGISTER
	BCF  LCD_EN	
	CALL delay_100us  
return

;PRINTA A PARTE DAS UNIDADES NO LCD
Escreve_10
	MOVLW   0x31	;d'1
	CALL	ESCREVE
	MOVLW   0x30	;d'0
	CALL	ESCREVE
	MOVLW   0x30	;d'0
	CALL	ESCREVE
	BSF	STATUS,DC
	GOTO	Limpa	
Escreve_9
	CALL PT1			;MOVE CURSOR PARA POSIÇÃO 3 DA DDRAM
	BTFSC	STATUS,DC	;Verifica se printou 100% alguma vez
	CALL	LIMPA_ZERO	;Se sim, limpa o segundo zero de 100%
	CALL PT2			;Se não, vai para posição 1 da DDRAM e printa a unidade correspondente
	MOVLW   0x39	;d'9
	CALL	ESCREVE
	BCF	STATUS,DC
	GOTO	Printou_dezena ;Ao printar a dezena, vai label afim de printar a unidade.
Escreve_8
	CALL PT1			;MOVE CURSOR PARA POSIÇÃO 3 DA DDRAM
	BTFSC	STATUS,DC	;Verifica se printou 100% alguma vez
	CALL	LIMPA_ZERO	;Se sim, limpa o segundo zero de 100%
	CALL PT2			;Se não, vai para posição 1 da DDRAM e printa a unidade correspondente
	MOVLW   0x38	;d'8
	CALL	ESCREVE
	GOTO	Printou_dezena
Escreve_7
	CALL PT1			;MOVE CURSOR PARA POSIÇÃO 3 DA DDRAM
	BTFSC	STATUS,DC	;Verifica se printou 100% alguma vez
	CALL	LIMPA_ZERO	;Se sim, limpa o segundo zero de 100%
	CALL PT2			;Se não, vai para posição 1 da DDRAM e printa a unidade correspondente
	MOVLW   0x37	;d'7
	CALL	ESCREVE
	GOTO	Printou_dezena
Escreve_6
	CALL PT1			;MOVE CURSOR PARA POSIÇÃO 3 DA DDRAM
	BTFSC	STATUS,DC	;Verifica se printou 100% alguma vez
	CALL	LIMPA_ZERO	;Se sim, limpa o segundo zero de 100%
	CALL PT2			;Se não, vai para posição 1 da DDRAM e printa a unidade correspondente
	MOVLW   0x36	;d'6
	CALL	ESCREVE
	GOTO	Printou_dezena
Escreve_5
	CALL PT1			;MOVE CURSOR PARA POSIÇÃO 3 DA DDRAM
	BTFSC	STATUS,DC	;Verifica se printou 100% alguma vez
	CALL	LIMPA_ZERO	;Se sim, limpa o segundo zero de 100%
	CALL PT2			;Se não, vai para posição 1 da DDRAM e printa a unidade correspondente
	MOVLW   0x35	;d'5
	CALL	ESCREVE
	GOTO	Printou_dezena
Escreve_4
	CALL PT1			;MOVE CURSOR PARA POSIÇÃO 3 DA DDRAM
	BTFSC	STATUS,DC	;Verifica se printou 100% alguma vez
	CALL	LIMPA_ZERO	;Se sim, limpa o segundo zero de 100%
	CALL PT2			;Se não, vai para posição 1 da DDRAM e printa a unidade correspondente
	MOVLW   0x34	;d'4
	CALL	ESCREVE
	GOTO	Printou_dezena
Escreve_3
	CALL PT1			;MOVE CURSOR PARA POSIÇÃO 3 DA DDRAM
	BTFSC	STATUS,DC	;Verifica se printou 100% alguma vez
	CALL	LIMPA_ZERO	;Se sim, limpa o segundo zero de 100%
	CALL PT2			;Se não, vai para posição 1 da DDRAM e printa a unidade correspondente
	MOVLW   0x33	;d'3
	CALL	ESCREVE
	GOTO	Printou_dezena
Escreve_2
	CALL PT1			;MOVE CURSOR PARA POSIÇÃO 3 DA DDRAM
	BTFSC	STATUS,DC	;Verifica se printou 100% alguma vez
	CALL	LIMPA_ZERO	;Se sim, limpa o segundo zero de 100%
	CALL PT2			;Se não, vai para posição 1 da DDRAM e printa a unidade correspondente
	MOVLW   0x32	;d'2
	CALL	ESCREVE
	GOTO	Printou_dezena
Escreve_1
	CALL PT1			;MOVE CURSOR PARA POSIÇÃO 3 DA DDRAM
	BTFSC	STATUS,DC	;Verifica se printou 100% alguma vez
	CALL	LIMPA_ZERO	;Se sim, limpa o segundo zero de 100%
	CALL PT2			;Se não, vai para posição 1 da DDRAM e printa a unidade correspondente
	MOVLW   0x31	;d'1
	CALL	ESCREVE
	GOTO	Printou_dezena
Escreve_0
	CALL PT1			;MOVE CURSOR PARA POSIÇÃO 3 DA DDRAM
	BTFSC	STATUS,DC	;Verifica se printou 100% alguma vez
	CALL	LIMPA_ZERO	;Se sim, limpa o segundo zero de 100%
	CALL PT2			;Se não, vai para posição 1 da DDRAM e printa a unidade correspondente
	MOVLW   0x30	;d'0
	CALL	ESCREVE
	GOTO	Printou_dezena
;FIM

;ANALISA QUAL O VALOR DA UNIDADE E MANDA PRINTAR	
Printa_Unidade
	BCF	STATUS,Z
	MOVLW	.9
	SUBWF	unidade,w
	BTFSC	STATUS,Z
	GOTO	Escreve_9u
	
	BCF	STATUS,Z
	MOVLW	.8
	SUBWF	unidade,w
	BTFSC	STATUS,Z
	GOTO	Escreve_8u
	
	BCF	STATUS,Z
	MOVLW	.7
	SUBWF	unidade,w
	BTFSC	STATUS,Z
	GOTO	Escreve_7u
	
	BCF	STATUS,Z
	MOVLW	.6
	SUBWF	unidade,w
	BTFSC	STATUS,Z
	GOTO	Escreve_6u
	
	BCF	STATUS,Z
	MOVLW	.5
	SUBWF	unidade,w
	BTFSC	STATUS,Z
	GOTO	Escreve_5u
	
	BCF	STATUS,Z
	MOVLW	.4
	SUBWF	unidade,w
	BTFSC	STATUS,Z
	GOTO	Escreve_4u
	
	BCF	STATUS,Z
	MOVLW	.3
	SUBWF	unidade,w
	BTFSC	STATUS,Z
	GOTO	Escreve_3u
	
	BCF	STATUS,Z
	MOVLW	.2
	SUBWF	unidade,w
	BTFSC	STATUS,Z
	GOTO	Escreve_2u
	
	BCF	STATUS,Z
	MOVLW	.1
	SUBWF	unidade,w
	BTFSC	STATUS,Z
	GOTO	Escreve_1u
	
	BCF	STATUS,Z
	MOVLW	.0
	SUBWF	unidade,w
	BTFSC	STATUS,Z
	GOTO	Escreve_0u
return

;PRINTA A PARTE DAS UNIDADES NO LCD
Escreve_9u
	MOVLW   0x39
	CALL	ESCREVE
	GOTO	Limpa
Escreve_8u
	MOVLW   0x38
	CALL	ESCREVE
	GOTO	Limpa
Escreve_7u
	MOVLW   0x37
	CALL	ESCREVE
	GOTO	Limpa
Escreve_6u
	MOVLW   0x36
	CALL	ESCREVE
	GOTO	Limpa
Escreve_5u
	MOVLW   0x35
	CALL	ESCREVE
	GOTO	Limpa
Escreve_4u
	MOVLW   0x34
	CALL	ESCREVE
	GOTO	Limpa
Escreve_3u
	MOVLW   0x33
	CALL	ESCREVE
	GOTO	Limpa
Escreve_2u
	MOVLW   0x32
	CALL	ESCREVE
	GOTO	Limpa
Escreve_1u
	MOVLW   0x31
	CALL	ESCREVE
	GOTO	Limpa
Escreve_0u
	MOVLW   0x30
	CALL	ESCREVE
	GOTO	Limpa
;FIM	

Clear_cursor   ;MOVE O CURSOR PARA O INICIO DA LINHA 1
		
	CALL delay_100us    ;CLEAR DISPLAY E CURSOR NA LINHA 1, NA ESQUERDA
	BSF  LCD_EN
	MOVLW	B'00100000' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	BSF  LCD_EN
	MOVLW	B'00100100' ;NIBBLE2
	CALL SHIFT_REGISTER
	BCF  LCD_EN	
	CALL delay_1.8ms
return
	
Cursor_prox   ;move cursor para a posição 2 da DDRam
		
	CALL delay_100us    ;MOVE O CURSOR PARA POSIÇÃO 3 DA DDRAM
	BSF  LCD_EN
	MOVLW	B'00100001' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	BSF  LCD_EN
	MOVLW	B'00101000' ;NIBBLE2
	CALL SHIFT_REGISTER
	BCF  LCD_EN	
	CALL delay_100us  
return	
	
Cursor_prox2	
	CALL delay_100us    ;MOVE O CURSOR PARA POSIÇÃO 4 DA DDRAM
	BSF  LCD_EN
	MOVLW	B'00100001' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	BSF  LCD_EN
	MOVLW	B'00101100' ;NIBBLE2
	CALL SHIFT_REGISTER
	BCF  LCD_EN	
	CALL delay_100us  
return	
	
LIMPA_ZERO		    ;LIMPA O ZERO DO 100%
	MOVLW   0x10
	CALL	ESCREVE
return

ESCREVE
    BSF  LCD_EN
	MOVWF	LETRA		   ;RECEBE 8 BITS DE DADOS
	RLF	LETRA		   ;FAZ RLF E ANALISA O CARRY
	BCF	SR_DAT		   ;DEPENDENDO DO VALOR EM CARRY, ENVIA 0 OU 1
	BTFSC	STATUS,C	   ;PARA O SHIFT REGISTER 
	BSF	SR_DAT		
	BSF	SR_CLOCK	   ;NESTE PONTO, ENVIA D7
	BCF	SR_CLOCK	   ;DÁ PULSO DE CLOCK PARA MOVIMENTAÇÃO DOS BITS 
	
	RLF	LETRA		;ENVIA D6
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	    
	RLF 	LETRA		;ENVIA D5
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	RLF	LETRA		;ENVIA D4
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
				;RS - 0 COMANDO
				;RS - 1 CARACTER	
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BSF	SR_DAT		;ATIVA BACKLIGHT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BCF	SR_DAT		;O RESTO, MANDA COMO ZERO
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BCF	SR_DAT		;O RESTO, MANDA COMO ZERO
	BSF	SR_CLOCK
	BCF	SR_CLOCK
    BCF  LCD_EN
    	
    BSF  LCD_EN
	
	RLF	LETRA		   ;FAZ RLF E ANALISA O CARRY
	BCF	SR_DAT		   ;DEPENDENDO DO VALOR EM CARRY, ENVIA 0 OU 1
	BTFSC	STATUS,C	   ;PARA O SHIFT REGISTER 
	BSF	SR_DAT		
	BSF	SR_CLOCK	   ;NESTE PONTO, ENVIA D7
	BCF	SR_CLOCK	   ;DÁ PULSO DE CLOCK PARA MOVIMENTAÇÃO DOS BITS 
	
	RLF	LETRA		;ENVIA D6
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	    
	RLF 	LETRA		;ENVIA D5
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	RLF	LETRA		;ENVIA D4
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
				;RS - 0 COMANDO
				;RS - 1 CARACTER	
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BSF	SR_DAT		;ATIVA BACKLIGHT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BCF	SR_DAT		;O RESTO, MANDA COMO ZERO
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BCF	SR_DAT		;O RESTO, MANDA COMO ZERO
	BSF	SR_CLOCK
	BCF	SR_CLOCK
    BCF  LCD_EN
RETURN
    
	
    
INIT_LCD ;DADOS => 0 0 BL RS D4 D5 D6 D7 PARA NIBBLE1
	 ;DADOS => 0 0 BL RS D0 D1 D2 D3 PARA NIBBLE2
	 ;       MSB                  LSB
    
	CALL delay_15ms	    ;ENVIA COMANDO 0X30 PARA O LCD
	BSF  LCD_EN
	MOVLW	B'00101100' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN	
		
	CALL delay_4ms	    ;ENVIA COMANDO 0X30 PARA O LCD
	BSF  LCD_EN
	MOVLW	B'00101100' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN	
	
	CALL delay_100us    ;ENVIA COMANDO 0X30 PARA O LCD
	BSF  LCD_EN
	MOVLW	B'00101100' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
		
	CALL delay_100us    ;ESPERA DE SEGURANÇA
	
	BSF  LCD_EN	    ;ESTABELECE A COMUNICAÇÃO POR 4VIAS
	MOVLW	B'00100100' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	
	CALL delay_100us    ;CONDIÇÕES DE UTILIZAÇÃO
	BSF  LCD_EN
	MOVLW	B'00100100' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	BSF  LCD_EN
	MOVLW	B'00100001' ;NIBBLE2  -   4VIAS e 2 LINHAS, MATRIZ 7X5
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	
	CALL delay_100us    ;CLEAR DISPLAY E CURSOR NA LINHA 1, NA ESQUERDA
	BSF  LCD_EN
	MOVLW	B'00100000' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	BSF  LCD_EN
	MOVLW	B'00101000' ;NIBBLE2
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	
	CALL delay_1.8ms
	
	BSF  LCD_EN	    ;LIGA O DISPLAY SEM CURSOR
	MOVLW	B'00100000' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	BSF  LCD_EN
	MOVLW	B'00100011' ;NIBBLE2  
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	
	CALL delay_100us
	
	BSF  LCD_EN	    ;DESLOCAMENTO AUTOMÁTICO PARA DIREITA
	MOVLW	B'00100000' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	BSF  LCD_EN
	MOVLW	B'00100110' ;NIBBLE2  
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	
	CALL delay_40us
	CALL delay_100us
	
	MOVLW 'I'
	CALL ESCREVE
	CALL delay_65ms
	CALL delay_65ms
	
	MOVLW 'N'
	CALL ESCREVE
	CALL delay_65ms
	CALL delay_65ms
	
	MOVLW 'I'
	CALL ESCREVE
	CALL delay_65ms
	CALL delay_65ms
	
	MOVLW 'C'
	CALL ESCREVE
	CALL delay_65ms
	CALL delay_65ms
	
	MOVLW 'I'
	CALL ESCREVE
	CALL delay_65ms
	CALL delay_65ms
	
	MOVLW 'A'
	CALL ESCREVE
	CALL delay_65ms
	CALL delay_65ms
	
	MOVLW 'N'
	CALL ESCREVE
	CALL delay_65ms
	CALL delay_65ms
	
	MOVLW 'D'
	CALL ESCREVE
	CALL delay_65ms
	CALL delay_65ms
	
	MOVLW 'O'
	CALL ESCREVE
	CALL delay_65ms
	CALL delay_65ms
	
	MOVLW '.'
	CALL ESCREVE
	CALL delay_65ms
	CALL delay_65ms
	
	MOVLW '.'
	CALL ESCREVE
	CALL delay_65ms
	CALL delay_65ms
	
	MOVLW '.'
	CALL ESCREVE
	CALL delay_65ms
	CALL delay_65ms
	
	CALL delay_100us    ;CLEAR DISPLAY E CURSOR NA LINHA 1, NA ESQUERDA
	BSF  LCD_EN
	MOVLW	B'00100000' ;NIBBLE1
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	BSF  LCD_EN
	MOVLW	B'00101000' ;NIBBLE2
	CALL SHIFT_REGISTER
	BCF  LCD_EN
	
	CALL delay_1.8ms
return
	
	
;FUNÇÃO QUE RECEBE O QUE É ENVIADO PARA O WORK
;ONDE FAZ ROTATE PARA DIREITA, PEGA O QUE ESTÁ NO CARRY
;E ENVIA PARA O SHIFT REGISTER
SHIFT_REGISTER     
    
	MOVWF	DADOS_LCD	   ;RECEBE 8 BITS DE DADOS
	RRF	DADOS_LCD	   ;FAZ RRF E ANALISA O CARRY
	BCF	SR_DAT		   ;DEPENDENDO DO VALOR EM CARRY, ENVIA 0 OU 1
	BTFSC	STATUS,C	   ;PARA O SHIFT REGISTER 
	BSF	SR_DAT		
	BSF	SR_CLOCK	   ;NESTE PONTO, ENVIA D7
	BCF	SR_CLOCK	   ;DÁ PULSO DE CLOCK PARA MOVIMENTAÇÃO DOS BITS 
	
	RRF	DADOS_LCD	;ENVIA D6
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	    
	RRF 	DADOS_LCD	;ENVIA D5
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	RRF	DADOS_LCD	;ENVIA D4
	BCF	SR_DAT
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	RRF	DADOS_LCD	;RS - 0 COMANDO
	BCF	SR_DAT		;RS - 1 CARACTER
	BTFSC	STATUS,C
	BSF	SR_DAT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BSF	SR_DAT		;ATIVA BACKLIGHT
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BCF	SR_DAT		;O RESTO, MANDA COMO ZERO
	BSF	SR_CLOCK
	BCF	SR_CLOCK
	
	BCF	SR_DAT		;O RESTO, MANDA COMO ZERO
	BSF	SR_CLOCK
	BCF	SR_CLOCK
RETURN	
	
	
	

	
;#########################	    DELAYS	    ###########################
    delay_2s
	call  delay_0.5s
	call  delay_0.5s
	call  delay_0.5s
	call  delay_0.5s
    return
	
    delay_0.5s
	    BSF	T1CON,T1CKPS1	;DEFINE PRESCALER PARA 1:8
	    BSF	T1CON,T1CKPS0
	    BCF	  PIR1,TMR1IF
	    MOVLW   .0		;INICIA O TIMER1 COM B'0000 0000'
	    MOVWF   TMR1H	;FORMULA TIMER1 = (255 - TMR1H)*255
	    MOVLW   .0
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECISÃO
	    aux_0.5s
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_0.5s
	   BCF	T1CON,T1CKPS1	
	   BCF	T1CON,T1CKPS0
    return
    
    delay_65ms
	    BCF	  PIR1,TMR1IF
	    MOVLW   .0		;INICIA O TIMER1 COM B'0000 0000'
	    MOVWF   TMR1H	;FORMULA TIMER1 = (255 - TMR1H)*255
	    MOVLW   .0
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECISÃO
	    aux_65ms
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_65ms
    return
    
    delay_15ms
	    BCF	  PIR1,TMR1IF
	    MOVLW   .193	;INICIA O TIMER1 COM B'1100 0001'
	    MOVWF   TMR1H	;FORMULA TIMER1 = (255 - TMR1H)*255
	    MOVLW   .0
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECISÃO
	    aux_15ms
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_15ms
    return
    
    delay_8ms
	    BCF	    PIR1,TMR1IF
	    MOVLW   .222	;INICIA O TIMER1 COM B'1101 1110'
	    MOVWF   TMR1H	;FORMULA TIMER1 = (255 - TMR1H)*255
	    MOVLW   .199
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECISÃO
	    aux_8ms
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_8ms
    return
	   
    delay_4ms
	    BCF	  PIR1,TMR1IF
	    MOVLW   .236	;INICIA O TIMER1 COM B'1110 1100'
	    MOVWF   TMR1H	;FORMULA TIMER1 = (255 - TMR1H)*255
	    MOVLW   .115
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECISÃO
	    aux_4ms
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_4ms
    return
	   

    delay_1.8ms
	    BCF	  PIR1,TMR1IF
	    MOVLW   .248	;INICIA O TIMER1 COM B'1111 1000'
	    MOVWF   TMR1H	;FORMULA TIMER1 = (255 - TMR1H)*255
	    MOVLW   .0
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECISÃO
	    aux_1.8ms
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_1.8ms
    return
    
    delay_100us
	    BCF	  PIR1,TMR1IF
	    MOVLW   .255	;INICIA O TIMER1 COM B'1111 1111'
	    MOVWF   TMR1H	;FORMULA TIMER1 = (255 - TMR1H)*255
	    MOVLW   .120
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECISÃO
	    aux_100us
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_100us
    return
	   
    delay_40us
	    BCF	  PIR1,TMR1IF
	    MOVLW   .255	;INICIA O TIMER1 COM B'1111 1111'
	    MOVWF   TMR1H	;FORMULA TIMER1 = (255 - TMR1H)*255
	    MOVLW   .185
	    MOVWF   TMR1L	;TMR1L SERVE COMO PRECISÃO
	    aux_40us
	   BTFSS    PIR1,TMR1IF
	   GOTO	    aux_40us
    return						;Sim, retorna 							
 	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END