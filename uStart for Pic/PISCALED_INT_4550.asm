; Placa de aprendizagem: uStart for PIC   
; Programação em Assembly do PIC18F4550 
; Autor: Jordy Allyson
    
  list p=18f4550, r=hex
  #include <p18f4550.inc>  
  
  org 0x0000 ;Inicia o programa no endereço de memória 0x00
  goto INICIO 
  
  org 0x0008 ;Interrupção de alta prioridade, desvia para endereço 0x08
  goto HI_INT
  
  org 0x0018 ;interrupção de baixa prioridade, desvia para endereço 0x18
  goto LOW_INT
  
;####### INTERRUPÇÃO DE ALTA PRIORIDADE ########
  HI_INT:
;Espaço para execução em alta prioridade
;----------------------------------------
    
  btfss INTCON,TMR0IF
  goto end_int

  ;incf counter,f 
     
  ;movf  counter,0
  ;sublw d'127'

  ;btfss STATUS,Z
  ;goto  end_int

  movlw b'00000010' ; RA1 
  xorwf LATA,F
  clrf counter
 
end_int:
  bcf INTCON,TMR0IF  
;----------------------------------------  
  retfie ;Volta ao curso do programa  
;################################################ 
  
;####### INTERRUPÇÃO DE BAIXA PRIORIDADE ########
  LOW_INT:
;Espaço para execução em baixa prioridade
;----------------------------------------
    
  nop
  
;----------------------------------------
  retfie ;Volta ao curso do programa  
;################################################
  
  
;##### INCIALIZAÇÃO DE VARIÁVEIS #####
  CBLOCK	0x10	;ENDEREÇO INICIAL DA MEMÓRIA DE USUÁRIO
			
		counter
		;NOVAS VARIÁVEIS
	ENDC		;FIM DO BLOCO DE MEMÓRIA

;######### ROTINA PRINCIPAL DO PROGRAMA #########
INICIO:
  clrf counter 
  ;--------------------------------------

  ;LATA é usado em sáidas Digitais
  ;PORTA é usado em entradas TTL
  movlw b'00000000' ;Define todas as portas de TRISA como saídas
  movwf TRISA
  bcf   LATA,2	    ;Outra forma de definir RA1 como saída
  
  ;INTCON (1,2 e 3) funcionam de acordo com os valores encontrados em RCON,IPEN
  ;Neste caso, RCON,IPEN = 0 (incialização padrão)
  bcf INTCON,GIE    ; Desabilita interrupções globais
  bcf T0CON,TMR0ON  ; Desliga Timer 0
  bsf INTCON,TMR0IE ; Habilita interrupção Timer 0
  bcf T0CON,T08BIT  ; Utiliza modo de 16 bits
  bcf T0CON,T0CS    
  bcf T0CON,T0PS2   ;0
  bcf T0CON,T0PS1   ;0		DEFINE PRESCALER PARA 1:4
  bsf T0CON,T0PS0   ;1
  
  ;Inicializa timer
  movlw 0x00
  movwf TMR0H
  movlw 0x00
  movwf TMR0L
 
  ;INTCON2,TMR0IP define se o estouro do timer desvia para hi_int ou low_int
  bsf INTCON2,TMR0IP ; Timer 0 - INTCON2,TMR0IP = 1 - Alta prioridade
  bsf T0CON,TMR0ON   ; Timer 0 - Habilita Timer0
  bsf INTCON,GIE     ; Habilita interrupções globais
     
  loop
  nop   
  goto loop
  
  end