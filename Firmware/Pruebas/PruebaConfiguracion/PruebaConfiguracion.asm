
_main:

;PruebaConfiguracion.c,20 :: 		void main() {
;PruebaConfiguracion.c,22 :: 		ConfiguracionPrincipal();
	CALL        _ConfiguracionPrincipal+0, 0
;PruebaConfiguracion.c,23 :: 		TEST = 1;
	BSF         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,34 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_ConfiguracionPrincipal:

;PruebaConfiguracion.c,41 :: 		void ConfiguracionPrincipal(){
;PruebaConfiguracion.c,45 :: 		OSCCON.IDLEN=1;                                    //Entra en modo IDLE durante la instruccion SLEEP
	BSF         OSCCON+0, 7 
;PruebaConfiguracion.c,46 :: 		OSCCON.IRCF2=1;                                    //HFINTOSC=16MHz  IRFC=111
	BSF         OSCCON+0, 6 
;PruebaConfiguracion.c,47 :: 		OSCCON.IRCF1=1;
	BSF         OSCCON+0, 5 
;PruebaConfiguracion.c,48 :: 		OSCCON.IRCF0=1;
	BSF         OSCCON+0, 4 
;PruebaConfiguracion.c,49 :: 		OSCCON.OSTS=0;                                     //*El dispositivo está funcionando desde el reloj definido por FOSC <3:0> del registro CONFIG1H
	BCF         OSCCON+0, 3 
;PruebaConfiguracion.c,50 :: 		OSCCON.HFIOFS=1;                                   //HFINTOSC frequency is stable
	BSF         OSCCON+0, 2 
;PruebaConfiguracion.c,51 :: 		OSCCON.SCS1=1;                                     //System Clock Select bit:  1x=Internal oscillator block
	BSF         OSCCON+0, 1 
;PruebaConfiguracion.c,52 :: 		OSCCON.SCS0=1;
	BSF         OSCCON+0, 0 
;PruebaConfiguracion.c,57 :: 		ANSELB = 0;                                        //Configura PORTB como digital
	CLRF        ANSELB+0 
;PruebaConfiguracion.c,58 :: 		TEST_Direction = 0;                                //Configura el pin TEST como salida
	BCF         TRISB2_bit+0, BitPos(TRISB2_bit+0) 
;PruebaConfiguracion.c,60 :: 		INTCON.GIE = 1;                                    //Habilita las interrupciones globales
	BSF         INTCON+0, 7 
;PruebaConfiguracion.c,61 :: 		INTCON.PEIE = 1;                                   //Habilita las interrupciones perifericas
	BSF         INTCON+0, 6 
;PruebaConfiguracion.c,64 :: 		T1CON = 0x01;                                      //Timer1 Input Clock Prescale Select bits
	MOVLW       1
	MOVWF       T1CON+0 
;PruebaConfiguracion.c,65 :: 		TMR1H = 0xF0;
	MOVLW       240
	MOVWF       TMR1H+0 
;PruebaConfiguracion.c,66 :: 		TMR1L = 0x60;
	MOVLW       96
	MOVWF       TMR1L+0 
;PruebaConfiguracion.c,67 :: 		PIR1.TMR1IF = 0;                                   //Limpia la bandera de interrupcion del TMR1
	BCF         PIR1+0, 0 
;PruebaConfiguracion.c,68 :: 		PIE1.TMR1IE = 1;                                   //Habilita la interrupción de desbordamiento TMR1
	BSF         PIE1+0, 0 
;PruebaConfiguracion.c,70 :: 		Delay_ms(100);                                     //Espera hasta que se estabilicen los cambios
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_ConfiguracionPrincipal0:
	DECFSZ      R13, 1, 1
	BRA         L_ConfiguracionPrincipal0
	DECFSZ      R12, 1, 1
	BRA         L_ConfiguracionPrincipal0
	DECFSZ      R11, 1, 1
	BRA         L_ConfiguracionPrincipal0
;PruebaConfiguracion.c,71 :: 		}
L_end_ConfiguracionPrincipal:
	RETURN      0
; end of _ConfiguracionPrincipal

_interrupt:

;PruebaConfiguracion.c,76 :: 		void interrupt(void){
;PruebaConfiguracion.c,80 :: 		if (TMR1IF_bit==1){
	BTFSS       TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
	GOTO        L_interrupt1
;PruebaConfiguracion.c,82 :: 		TEST = ~TEST;
	BTG         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,83 :: 		TMR1IF_bit = 0;                                       //Limpia la bandera de interrupcion por desbordamiento del TMR1
	BCF         TMR1IF_bit+0, BitPos(TMR1IF_bit+0) 
;PruebaConfiguracion.c,86 :: 		TMR1H = 0xF0;
	MOVLW       240
	MOVWF       TMR1H+0 
;PruebaConfiguracion.c,87 :: 		TMR1L = 0x60;
	MOVLW       96
	MOVWF       TMR1L+0 
;PruebaConfiguracion.c,89 :: 		}
L_interrupt1:
;PruebaConfiguracion.c,92 :: 		}
L_end_interrupt:
L__interrupt5:
	RETFIE      1
; end of _interrupt
