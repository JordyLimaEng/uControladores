; Placa de aprendizagem: uStart for PIC   
; Programação em Assembly do PIC18F4550 
; Autor: Jordy Allyson
    
  list p=18f4550, r=hex
  #include <p18f4550.inc>  
  
  org 0x0000 ;Inicia o programa no endere�o de mem�ria 0x00
  goto INICIO 
  
  org 0x0008 ;interrup��o de alta prioridade, desvia para endere�o 0x08
  goto HI_INT
  
  org 0x0018 ;interrup��o de baixa prioridade, desvia para endere�o 0x18
  goto LOW_INT
  
;####### INTERRUP��O DE ALTA PRIORIDADE ########
  HI_INT:
;Espa�o�o para execu��o em alta prioridade
;----------------------------------------
    
  btfss INTCON,TMR0IF
  goto end_int

  movlw b'00000110' ; RA1 e RA2
  xorwf LATA,F
  clrf counter
 
end_int:
  bcf INTCON,TMR0IF  
;----------------------------------------  
  retfie ;Volta ao curso do programa  
;################################################ 
  
;####### INTERRUP��O DE BAIXA PRIORIDADE ########
  LOW_INT:
;Espa�o para execu��o em baixa prioridade
;----------------------------------------
    
  nop
  
;----------------------------------------
  retfie ;Volta ao curso do programa  
;################################################
  
  
;##### INCIALIZA��O DE VARI�VEIS #####
  CBLOCK	0x10	;ENDERE�O INICIAL DA MEM�RIA DE USU�RIO
			
		counter
		;NOVAS VARIÁVEIS
  ENDC		;FIM DO BLOCO DE MEM�RIA

;######### ROTINA PRINCIPAL DO PROGRAMA #########
INICIO:
  clrf counter 
  ;--------------------------------------
  ;LATA � usado em saidas Digitais
  ;PORTA � usado em entradas TTL
  movlw b'00000000' ;Define todas as portas de TRISA como saídas
  movwf TRISA
  bcf   LATA,1	    ;seta RA1 em LOW
  bsf	LATA,2	    ;seta RA2 en HIGH
  
  ;INTCON (1,2 e 3) funcionam de acordo com os valores encontrados em RCON,IPEN
  ;Neste caso, RCON,IPEN = 0 (incializa��o padr�o)
  bcf INTCON,GIE    ; Desabilita interrup��es globais
  bsf INTCON,TMR0IE ; Habilita interrup��o Timer 0
  
  movlw b'00010100' ;Tmr0 parado, 16bit, PSA de 1:2
  movwf	T0CON
  
  ;Inicializa timer
  movlw 0x00
  movwf TMR0H
  movlw 0x00
  movwf TMR0L
 
  ;INTCON2,TMR0IP define se o estouro do timer desvia para hi_int ou low_int
  bsf INTCON2,TMR0IP ; Timer 0 - INTCON2,TMR0IP = 1 - Alta prioridade
  bsf T0CON,TMR0ON   ; Timer 0 - Habilita Timer0
  bsf INTCON,GIE     ; Habilita interrup��es globais
     
  loop
  nop   
  goto loop
  
  end