
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
;PruebaConfiguracion.c,51 :: 		OSCCON.SCS1=1;                                     //System Clock Select bit:  1x=Internal oscillator block
	BSF         OSCCON+0, 1 
;PruebaConfiguracion.c,52 :: 		OSCCON.SCS0=1;
	BSF         OSCCON+0, 0 
;PruebaConfiguracion.c,59 :: 		ANSELA = 0;                                        //Configura PORTA como digital
	CLRF        ANSELA+0 
;PruebaConfiguracion.c,60 :: 		ANSELB = 0;                                        //Configura PORTB como digital
	CLRF        ANSELB+0 
;PruebaConfiguracion.c,61 :: 		ANSELC = 0;                                        //Configura PORTC como digital
	CLRF        ANSELC+0 
;PruebaConfiguracion.c,63 :: 		TEST_Direction = 0;                                //Configura el pin TEST como salida
	BCF         TRISB2_bit+0, BitPos(TRISB2_bit+0) 
;PruebaConfiguracion.c,64 :: 		TRISA5_bit = 1;                                    //SS1 In
	BSF         TRISA5_bit+0, BitPos(TRISA5_bit+0) 
;PruebaConfiguracion.c,65 :: 		TRISC3_bit = 1;                                    //SCK1 In
	BSF         TRISC3_bit+0, BitPos(TRISC3_bit+0) 
;PruebaConfiguracion.c,66 :: 		TRISC4_bit = 1;                                    //SDI1 In
	BSF         TRISC4_bit+0, BitPos(TRISC4_bit+0) 
;PruebaConfiguracion.c,67 :: 		TRISC5_bit = 0;                                    //SDO1 Out
	BCF         TRISC5_bit+0, BitPos(TRISC5_bit+0) 
;PruebaConfiguracion.c,69 :: 		INTCON.GIE = 1;                                    //Habilita las interrupciones globales
	BSF         INTCON+0, 7 
;PruebaConfiguracion.c,70 :: 		INTCON.PEIE = 1;                                   //Habilita las interrupciones perifericas
	BSF         INTCON+0, 6 
;PruebaConfiguracion.c,73 :: 		SSP1IE_bit = 1;
	BSF         SSP1IE_bit+0, BitPos(SSP1IE_bit+0) 
;PruebaConfiguracion.c,74 :: 		SPI1_Init_Advanced(_SPI_SLAVE_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_HIGH_2_LOW);
	MOVLW       4
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	MOVLW       128
	MOVWF       FARG_SPI1_Init_Advanced_data_sample+0 
	MOVLW       16
	MOVWF       FARG_SPI1_Init_Advanced_clock_idle+0 
	CLRF        FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;PruebaConfiguracion.c,75 :: 		SSP1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI *
	BCF         SSP1IF_bit+0, BitPos(SSP1IF_bit+0) 
;PruebaConfiguracion.c,85 :: 		Delay_ms(100);                                     //Espera hasta que se estabilicen los cambios
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
;PruebaConfiguracion.c,86 :: 		}
L_end_ConfiguracionPrincipal:
	RETURN      0
; end of _ConfiguracionPrincipal

_interrupt:

;PruebaConfiguracion.c,91 :: 		void interrupt(void){
;PruebaConfiguracion.c,107 :: 		if (SSP1IF_bit==1){
	BTFSS       SSP1IF_bit+0, BitPos(SSP1IF_bit+0) 
	GOTO        L_interrupt1
;PruebaConfiguracion.c,109 :: 		SSP1IF_bit = 0;
	BCF         SSP1IF_bit+0, BitPos(SSP1IF_bit+0) 
;PruebaConfiguracion.c,110 :: 		TEST = ~TEST;
	BTG         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,112 :: 		}
L_interrupt1:
;PruebaConfiguracion.c,114 :: 		}
L_end_interrupt:
L__interrupt5:
	RETFIE      1
; end of _interrupt
