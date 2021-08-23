
_main:

;PruebaConfiguracion.c,37 :: 		void main() {
;PruebaConfiguracion.c,39 :: 		ConfiguracionPrincipal();
	CALL        _ConfiguracionPrincipal+0, 0
;PruebaConfiguracion.c,43 :: 		i = 0;
	CLRF        _i+0 
	CLRF        _i+1 
;PruebaConfiguracion.c,44 :: 		j = 0;
	CLRF        _j+0 
	CLRF        _j+1 
;PruebaConfiguracion.c,45 :: 		x = 0;
	CLRF        _x+0 
	CLRF        _x+1 
;PruebaConfiguracion.c,46 :: 		y = 0;
	CLRF        _y+0 
	CLRF        _y+1 
;PruebaConfiguracion.c,48 :: 		banSPI0 = 0;
	CLRF        _banSPI0+0 
;PruebaConfiguracion.c,49 :: 		banSPI1 = 0;
	CLRF        _banSPI1+0 
;PruebaConfiguracion.c,51 :: 		direccionRS485 = 0;
	CLRF        _direccionRS485+0 
;PruebaConfiguracion.c,52 :: 		funcionRS485 = 0;
	CLRF        _funcionRS485+0 
;PruebaConfiguracion.c,53 :: 		subFuncionRS485 = 0;
	CLRF        _subFuncionRS485+0 
;PruebaConfiguracion.c,54 :: 		numDatosRS485 = 0;
	CLRF        _numDatosRS485+0 
;PruebaConfiguracion.c,56 :: 		TEST = 1;
	BSF         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,67 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_ConfiguracionPrincipal:

;PruebaConfiguracion.c,74 :: 		void ConfiguracionPrincipal(){
;PruebaConfiguracion.c,77 :: 		OSCCON.IDLEN=1;                                    //Entra en modo IDLE durante la instruccion SLEEP
	BSF         OSCCON+0, 7 
;PruebaConfiguracion.c,78 :: 		OSCCON.IRCF2=1;                                    //HFINTOSC=16MHz  IRFC=111
	BSF         OSCCON+0, 6 
;PruebaConfiguracion.c,79 :: 		OSCCON.IRCF1=1;
	BSF         OSCCON+0, 5 
;PruebaConfiguracion.c,80 :: 		OSCCON.IRCF0=1;
	BSF         OSCCON+0, 4 
;PruebaConfiguracion.c,81 :: 		OSCCON.SCS1=1;                                     //System Clock Select bit:  1x=Internal oscillator block
	BSF         OSCCON+0, 1 
;PruebaConfiguracion.c,82 :: 		OSCCON.SCS0=1;
	BSF         OSCCON+0, 0 
;PruebaConfiguracion.c,85 :: 		ANSELA = 0;                                        //Configura PORTA como digital
	CLRF        ANSELA+0 
;PruebaConfiguracion.c,86 :: 		ANSELB = 0;                                        //Configura PORTB como digital
	CLRF        ANSELB+0 
;PruebaConfiguracion.c,87 :: 		ANSELC = 0;                                        //Configura PORTC como digital
	CLRF        ANSELC+0 
;PruebaConfiguracion.c,89 :: 		TEST_Direction = 0;                                //Configura el pin TEST como salida
	BCF         TRISB2_bit+0, BitPos(TRISB2_bit+0) 
;PruebaConfiguracion.c,90 :: 		TRISA5_bit = 1;                                    //SS1 In
	BSF         TRISA5_bit+0, BitPos(TRISA5_bit+0) 
;PruebaConfiguracion.c,91 :: 		TRISC3_bit = 1;                                    //SCK1 In
	BSF         TRISC3_bit+0, BitPos(TRISC3_bit+0) 
;PruebaConfiguracion.c,92 :: 		TRISC4_bit = 1;                                    //SDI1 In
	BSF         TRISC4_bit+0, BitPos(TRISC4_bit+0) 
;PruebaConfiguracion.c,93 :: 		TRISC5_bit = 0;                                    //SDO1 Out
	BCF         TRISC5_bit+0, BitPos(TRISC5_bit+0) 
;PruebaConfiguracion.c,95 :: 		INTCON.GIE = 1;                                    //Habilita las interrupciones globales
	BSF         INTCON+0, 7 
;PruebaConfiguracion.c,96 :: 		INTCON.PEIE = 1;                                   //Habilita las interrupciones perifericas
	BSF         INTCON+0, 6 
;PruebaConfiguracion.c,99 :: 		SSP1IE_bit = 1;
	BSF         SSP1IE_bit+0, BitPos(SSP1IE_bit+0) 
;PruebaConfiguracion.c,100 :: 		SPI1_Init_Advanced(_SPI_SLAVE_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_HIGH_2_LOW);
	MOVLW       4
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	MOVLW       128
	MOVWF       FARG_SPI1_Init_Advanced_data_sample+0 
	MOVLW       16
	MOVWF       FARG_SPI1_Init_Advanced_clock_idle+0 
	CLRF        FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;PruebaConfiguracion.c,101 :: 		SSP1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI *
	BCF         SSP1IF_bit+0, BitPos(SSP1IF_bit+0) 
;PruebaConfiguracion.c,111 :: 		Delay_ms(100);                                     //Espera hasta que se estabilicen los cambios
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
;PruebaConfiguracion.c,112 :: 		}
L_end_ConfiguracionPrincipal:
	RETURN      0
; end of _ConfiguracionPrincipal

_CambiarEstadoBandera:

;PruebaConfiguracion.c,115 :: 		void CambiarEstadoBandera(unsigned short bandera, unsigned short estado){
;PruebaConfiguracion.c,117 :: 		if (estado==1){
	MOVF        FARG_CambiarEstadoBandera_estado+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera1
;PruebaConfiguracion.c,119 :: 		banSPI0 = 3;
	MOVLW       3
	MOVWF       _banSPI0+0 
;PruebaConfiguracion.c,120 :: 		banSPI1 = 3;
	MOVLW       3
	MOVWF       _banSPI1+0 
;PruebaConfiguracion.c,122 :: 		switch (bandera){
	GOTO        L_CambiarEstadoBandera2
;PruebaConfiguracion.c,123 :: 		case 0:
L_CambiarEstadoBandera4:
;PruebaConfiguracion.c,124 :: 		banSPI0 = 1;
	MOVLW       1
	MOVWF       _banSPI0+0 
;PruebaConfiguracion.c,125 :: 		break;
	GOTO        L_CambiarEstadoBandera3
;PruebaConfiguracion.c,126 :: 		case 1:
L_CambiarEstadoBandera5:
;PruebaConfiguracion.c,127 :: 		banSPI1 = 1;
	MOVLW       1
	MOVWF       _banSPI1+0 
;PruebaConfiguracion.c,128 :: 		break;
	GOTO        L_CambiarEstadoBandera3
;PruebaConfiguracion.c,129 :: 		}
L_CambiarEstadoBandera2:
	MOVF        FARG_CambiarEstadoBandera_bandera+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera4
	MOVF        FARG_CambiarEstadoBandera_bandera+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera5
L_CambiarEstadoBandera3:
;PruebaConfiguracion.c,130 :: 		}
L_CambiarEstadoBandera1:
;PruebaConfiguracion.c,132 :: 		if (estado==0){
	MOVF        FARG_CambiarEstadoBandera_estado+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera6
;PruebaConfiguracion.c,133 :: 		banSPI0 = 0;
	CLRF        _banSPI0+0 
;PruebaConfiguracion.c,134 :: 		banSPI1 = 0;
	CLRF        _banSPI1+0 
;PruebaConfiguracion.c,135 :: 		}
L_CambiarEstadoBandera6:
;PruebaConfiguracion.c,136 :: 		}
L_end_CambiarEstadoBandera:
	RETURN      0
; end of _CambiarEstadoBandera

_interrupt:

;PruebaConfiguracion.c,142 :: 		void interrupt(void){
;PruebaConfiguracion.c,158 :: 		if (SSP1IF_bit==1){
	BTFSS       SSP1IF_bit+0, BitPos(SSP1IF_bit+0) 
	GOTO        L_interrupt7
;PruebaConfiguracion.c,160 :: 		SSP1IF_bit = 0;                                                          //Limpia la bandera de interrupcion por SPI
	BCF         SSP1IF_bit+0, BitPos(SSP1IF_bit+0) 
;PruebaConfiguracion.c,161 :: 		bufferSPI = SSP1BUF;                                                     //Guarda el contenido del bufeer (lectura)
	MOVF        SSP1BUF+0, 0 
	MOVWF       _bufferSPI+0 
;PruebaConfiguracion.c,164 :: 		if ((banSPI1==0)&&(bufferSPI==0xA1)){
	MOVF        _banSPI1+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt10
	MOVF        _bufferSPI+0, 0 
	XORLW       161
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt10
L__interrupt20:
;PruebaConfiguracion.c,165 :: 		CambiarEstadoBandera(1,1);
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_bandera+0 
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,166 :: 		i = 0;
	CLRF        _i+0 
	CLRF        _i+1 
;PruebaConfiguracion.c,167 :: 		}
L_interrupt10:
;PruebaConfiguracion.c,168 :: 		if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
	MOVF        _banSPI1+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt13
	MOVF        _bufferSPI+0, 0 
	XORLW       161
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt13
	MOVF        _bufferSPI+0, 0 
	XORLW       241
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt13
L__interrupt19:
;PruebaConfiguracion.c,169 :: 		tramaSolicitudSPI[i] = bufferSPI;                                     //Recupera la direccion del nodo y el indicador de sobrescritura de la SD
	MOVLW       _tramaSolicitudSPI+0
	ADDWF       _i+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_tramaSolicitudSPI+0)
	ADDWFC      _i+1, 0 
	MOVWF       FSR1H 
	MOVF        _bufferSPI+0, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,170 :: 		i++;
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;PruebaConfiguracion.c,171 :: 		}
L_interrupt13:
;PruebaConfiguracion.c,172 :: 		if ((banSPI1==1)&&(bufferSPI==0xF1)){
	MOVF        _banSPI1+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt16
	MOVF        _bufferSPI+0, 0 
	XORLW       241
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt16
L__interrupt18:
;PruebaConfiguracion.c,173 :: 		direccionRS485 = tramaSolicitudSPI[0];
	MOVF        _tramaSolicitudSPI+0, 0 
	MOVWF       _direccionRS485+0 
;PruebaConfiguracion.c,174 :: 		funcionRS485 = tramaSolicitudSPI[1];
	MOVF        _tramaSolicitudSPI+1, 0 
	MOVWF       _funcionRS485+0 
;PruebaConfiguracion.c,175 :: 		subFuncionRS485 = tramaSolicitudSPI[2];
	MOVF        _tramaSolicitudSPI+2, 0 
	MOVWF       _subFuncionRS485+0 
;PruebaConfiguracion.c,176 :: 		numDatosRS485 = tramaSolicitudSPI[3];
	MOVF        _tramaSolicitudSPI+3, 0 
	MOVWF       _numDatosRS485+0 
;PruebaConfiguracion.c,180 :: 		if (numDatosRS485==2){
	MOVF        _tramaSolicitudSPI+3, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt17
;PruebaConfiguracion.c,181 :: 		direccionRS485 = 0;
	CLRF        _direccionRS485+0 
;PruebaConfiguracion.c,182 :: 		funcionRS485 = 0;
	CLRF        _funcionRS485+0 
;PruebaConfiguracion.c,183 :: 		subFuncionRS485 = 0;
	CLRF        _subFuncionRS485+0 
;PruebaConfiguracion.c,184 :: 		numDatosRS485 = 0;
	CLRF        _numDatosRS485+0 
;PruebaConfiguracion.c,185 :: 		TEST = ~TEST;
	BTG         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,186 :: 		}
L_interrupt17:
;PruebaConfiguracion.c,188 :: 		CambiarEstadoBandera(1,0);                                            //Limpia la bandera
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_bandera+0 
	CLRF        FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,189 :: 		}
L_interrupt16:
;PruebaConfiguracion.c,194 :: 		}
L_interrupt7:
;PruebaConfiguracion.c,196 :: 		}
L_end_interrupt:
L__interrupt25:
	RETFIE      1
; end of _interrupt
