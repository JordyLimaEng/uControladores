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
		
		DADOS_LCD	;OS BITS QUE QUERO MANDAR PARA O LCD
		LETRA

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
#DEFINE	  LCD_EN   GPIO,GP5
#DEFINE	  SR_DAT   GPIO,GP4
#DEFINE	  SR_CLOCK GPIO,GP0 	

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
	
	BCF	 PIE1,TMR1IE	;DESABILITA A INTERRUPÇÃO PELO TIMER1
	
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÃ?Ã?O DO COMPARADOR ANALÃ?GICO	
	BSF	T1CON,TMR1ON	;HABILITA O TIMER1
	BCF	T1CON,TMR1CS	;DEFINE O CLOCK DE OPERAÇÃO INTERNO
	BCF	T1CON,T1CKPS1	
	BCF	T1CON,T1CKPS0	;PRESCALER 1:1	
	CLRF	DADOS_LCD
	CLRF	GPIO
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÃ?Ã?O DAS VARIÃVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN

	CALL INIT_LCD	    ;CHAMA A ROTINHA DE INICIALIZAÇÃO DO LCD
	call  delay_0.5s
		
	
	
	MOVLW A'J'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'o'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'r'
	CALL  ESCREVE
	call  delay_0.5s	
	MOVLW A'd'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'y'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW 0x20
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'L'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'i'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'm'
	CALL  ESCREVE
	call  delay_0.5s
	MOVLW A'a'
	CALL  ESCREVE
	
	call  delay_0.5s
       	
    GOTO MAIN	;REPETE A ESCRITA DO NOME
    
    
ESCREVE
    BSF  LCD_EN
	MOVWF	LETRA		   ;RECEBE 8 BITS DE DADOS
	RLF	LETRA		   ;FAZ RRF E ANALISA O CARRY
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
	
	RLF	LETRA		   ;FAZ RRF E ANALISA O CARRY
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
	
	
;##############################delays################################    
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
    return

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
