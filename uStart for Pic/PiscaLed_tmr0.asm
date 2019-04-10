; Placa de aprendizagem: uStart for PIC   
; ProgramaÃ§Ã£o em Assembly do PIC18F4550 
; Autor: Jordy Allyson
    
  list p=18f4550, r=hex
  #include <p18f4550.inc>  
  
  org 0x0000 ;Inicia o programa no endereço de memória 0x00
  goto INICIO 
  
  org 0x0008 ;interrupção de alta prioridade, desvia para endereço 0x08
  goto HI_INT
  
  org 0x0018 ;interrupção de baixa prioridade, desvia para endereço 0x18
  goto LOW_INT
  
;####### INTERRUPÇÃO DE ALTA PRIORIDADE ########
  HI_INT:
;Espaço§o para execução em alta prioridade
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
		;NOVAS VARIÃVEIS
  ENDC		;FIM DO BLOCO DE MEMÓRIA

;######### ROTINA PRINCIPAL DO PROGRAMA #########
INICIO:
  clrf counter 
  ;--------------------------------------
  ;LATA é usado em saidas Digitais
  ;PORTA é usado em entradas TTL
  movlw b'00000000' ;Define todas as portas de TRISA como saÃ­das
  movwf TRISA
  bcf   LATA,1	    ;seta RA1 em LOW
  bsf	LATA,2	    ;seta RA2 en HIGH
  
  ;INTCON (1,2 e 3) funcionam de acordo com os valores encontrados em RCON,IPEN
  ;Neste caso, RCON,IPEN = 0 (incialização padrão)
  bcf INTCON,GIE    ; Desabilita interrupções globais
  bsf INTCON,TMR0IE ; Habilita interrupção Timer 0
  
  movlw b'00010110' ;Tmr0 parado, 16bit, PSA de 1:2
  movwf	T0CON
  
  ;INTCON2,TMR0IP define se o estouro do timer desvia para hi_int ou low_int
  bsf INTCON2,TMR0IP ; Timer 0 - INTCON2,TMR0IP = 1 - Alta prioridade
  bsf T0CON,TMR0ON   ; Timer 0 - Habilita Timer0
  bsf INTCON,GIE     ; Habilita interrupções globais
  
  teste
  bcf INTCON,TMR0IF  
  ;Inicializa timer 
  ;Máx PS  1:2 000  =  10.9ms
  ;Máx PS  1:4 001  =  21.8ms
  ;Máx PS  1:8 010  =  43.7ms
  ;Máx PS 1:16 011  =  87.4ms 
  ;Máx PS 1:32 100  = 174.7ms
  ;Máx PS 1:64 101  = 349.5ms
  ;Máx PS 1:128 110 = 699.0ms
  ;Máx PS 1:256 111 = 1.398s
  
  movlw .0
  movwf TMR0H
  movlw .0
  movwf TMR0L
     
  loop
  btfsc INTCON,TMR0IF
  goto teste
  goto loop
  
  end
