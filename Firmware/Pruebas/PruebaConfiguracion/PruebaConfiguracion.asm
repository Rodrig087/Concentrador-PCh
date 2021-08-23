
_main:

;PruebaConfiguracion.c,38 :: 		void main() {
;PruebaConfiguracion.c,40 :: 		ConfiguracionPrincipal();
	CALL        _ConfiguracionPrincipal+0, 0
;PruebaConfiguracion.c,44 :: 		i = 0;
	CLRF        _i+0 
	CLRF        _i+1 
;PruebaConfiguracion.c,45 :: 		j = 0;
	CLRF        _j+0 
	CLRF        _j+1 
;PruebaConfiguracion.c,46 :: 		x = 0;
	CLRF        _x+0 
	CLRF        _x+1 
;PruebaConfiguracion.c,47 :: 		y = 0;
	CLRF        _y+0 
	CLRF        _y+1 
;PruebaConfiguracion.c,49 :: 		banSPI0 = 0;
	CLRF        _banSPI0+0 
;PruebaConfiguracion.c,50 :: 		banSPI1 = 0;
	CLRF        _banSPI1+0 
;PruebaConfiguracion.c,52 :: 		direccionSol = 0;
	CLRF        _direccionSol+0 
;PruebaConfiguracion.c,53 :: 		funcionSol = 0;
	CLRF        _funcionSol+0 
;PruebaConfiguracion.c,54 :: 		subFuncionSol = 0;
	CLRF        _subFuncionSol+0 
;PruebaConfiguracion.c,55 :: 		numDatosSol = 0;
	CLRF        _numDatosSol+0 
;PruebaConfiguracion.c,57 :: 		RP0 = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;PruebaConfiguracion.c,58 :: 		TEST = 1;
	BSF         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,69 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_ConfiguracionPrincipal:

;PruebaConfiguracion.c,76 :: 		void ConfiguracionPrincipal(){
;PruebaConfiguracion.c,79 :: 		OSCCON.IDLEN=1;                                    //Entra en modo IDLE durante la instruccion SLEEP
	BSF         OSCCON+0, 7 
;PruebaConfiguracion.c,80 :: 		OSCCON.IRCF2=1;                                    //HFINTOSC=16MHz  IRFC=111
	BSF         OSCCON+0, 6 
;PruebaConfiguracion.c,81 :: 		OSCCON.IRCF1=1;
	BSF         OSCCON+0, 5 
;PruebaConfiguracion.c,82 :: 		OSCCON.IRCF0=1;
	BSF         OSCCON+0, 4 
;PruebaConfiguracion.c,83 :: 		OSCCON.SCS1=1;                                     //System Clock Select bit:  1x=Internal oscillator block
	BSF         OSCCON+0, 1 
;PruebaConfiguracion.c,84 :: 		OSCCON.SCS0=1;
	BSF         OSCCON+0, 0 
;PruebaConfiguracion.c,87 :: 		ANSELA = 0;                                        //Configura PORTA como digital
	CLRF        ANSELA+0 
;PruebaConfiguracion.c,88 :: 		ANSELB = 0;                                        //Configura PORTB como digital
	CLRF        ANSELB+0 
;PruebaConfiguracion.c,89 :: 		ANSELC = 0;                                        //Configura PORTC como digital
	CLRF        ANSELC+0 
;PruebaConfiguracion.c,91 :: 		TEST_Direction = 0;                                //Configura el pin TEST como salida
	BCF         TRISB2_bit+0, BitPos(TRISB2_bit+0) 
;PruebaConfiguracion.c,92 :: 		RP0_Direction = 0;                                 //Configura el pin RP0 como salida
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;PruebaConfiguracion.c,93 :: 		TRISA5_bit = 1;                                    //SS1 In
	BSF         TRISA5_bit+0, BitPos(TRISA5_bit+0) 
;PruebaConfiguracion.c,94 :: 		TRISC3_bit = 1;                                    //SCK1 In
	BSF         TRISC3_bit+0, BitPos(TRISC3_bit+0) 
;PruebaConfiguracion.c,95 :: 		TRISC4_bit = 1;                                    //SDI1 In
	BSF         TRISC4_bit+0, BitPos(TRISC4_bit+0) 
;PruebaConfiguracion.c,96 :: 		TRISC5_bit = 0;                                    //SDO1 Out
	BCF         TRISC5_bit+0, BitPos(TRISC5_bit+0) 
;PruebaConfiguracion.c,98 :: 		INTCON.GIE = 1;                                    //Habilita las interrupciones globales
	BSF         INTCON+0, 7 
;PruebaConfiguracion.c,99 :: 		INTCON.PEIE = 1;                                   //Habilita las interrupciones perifericas
	BSF         INTCON+0, 6 
;PruebaConfiguracion.c,102 :: 		SSP1IE_bit = 1;
	BSF         SSP1IE_bit+0, BitPos(SSP1IE_bit+0) 
;PruebaConfiguracion.c,103 :: 		SPI1_Init_Advanced(_SPI_SLAVE_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_HIGH_2_LOW);
	MOVLW       4
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	MOVLW       128
	MOVWF       FARG_SPI1_Init_Advanced_data_sample+0 
	MOVLW       16
	MOVWF       FARG_SPI1_Init_Advanced_clock_idle+0 
	CLRF        FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;PruebaConfiguracion.c,104 :: 		SSP1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI *
	BCF         SSP1IF_bit+0, BitPos(SSP1IF_bit+0) 
;PruebaConfiguracion.c,114 :: 		Delay_ms(100);                                     //Espera hasta que se estabilicen los cambios
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
;PruebaConfiguracion.c,115 :: 		}
L_end_ConfiguracionPrincipal:
	RETURN      0
; end of _ConfiguracionPrincipal

_CambiarEstadoBandera:

;PruebaConfiguracion.c,118 :: 		void CambiarEstadoBandera(unsigned short bandera, unsigned short estado){
;PruebaConfiguracion.c,120 :: 		if (estado==1){
	MOVF        FARG_CambiarEstadoBandera_estado+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera1
;PruebaConfiguracion.c,122 :: 		banSPI0 = 3;
	MOVLW       3
	MOVWF       _banSPI0+0 
;PruebaConfiguracion.c,123 :: 		banSPI1 = 3;
	MOVLW       3
	MOVWF       _banSPI1+0 
;PruebaConfiguracion.c,125 :: 		switch (bandera){
	GOTO        L_CambiarEstadoBandera2
;PruebaConfiguracion.c,126 :: 		case 0:
L_CambiarEstadoBandera4:
;PruebaConfiguracion.c,127 :: 		banSPI0 = 1;
	MOVLW       1
	MOVWF       _banSPI0+0 
;PruebaConfiguracion.c,128 :: 		break;
	GOTO        L_CambiarEstadoBandera3
;PruebaConfiguracion.c,129 :: 		case 1:
L_CambiarEstadoBandera5:
;PruebaConfiguracion.c,130 :: 		banSPI1 = 1;
	MOVLW       1
	MOVWF       _banSPI1+0 
;PruebaConfiguracion.c,131 :: 		break;
	GOTO        L_CambiarEstadoBandera3
;PruebaConfiguracion.c,132 :: 		}
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
;PruebaConfiguracion.c,133 :: 		}
L_CambiarEstadoBandera1:
;PruebaConfiguracion.c,135 :: 		if (estado==0){
	MOVF        FARG_CambiarEstadoBandera_estado+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera6
;PruebaConfiguracion.c,136 :: 		banSPI0 = 0;
	CLRF        _banSPI0+0 
;PruebaConfiguracion.c,137 :: 		banSPI1 = 0;
	CLRF        _banSPI1+0 
;PruebaConfiguracion.c,138 :: 		}
L_CambiarEstadoBandera6:
;PruebaConfiguracion.c,139 :: 		}
L_end_CambiarEstadoBandera:
	RETURN      0
; end of _CambiarEstadoBandera

_ResponderSPI:

;PruebaConfiguracion.c,142 :: 		void ResponderSPI(unsigned char *cabeceraRespuesta, unsigned char *payloadRespuesta){
;PruebaConfiguracion.c,145 :: 		RP0 = 1;
	BSF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;PruebaConfiguracion.c,146 :: 		Delay_us(100);
	MOVLW       133
	MOVWF       R13, 0
L_ResponderSPI7:
	DECFSZ      R13, 1, 1
	BRA         L_ResponderSPI7
;PruebaConfiguracion.c,147 :: 		RP0 = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;PruebaConfiguracion.c,149 :: 		}
L_end_ResponderSPI:
	RETURN      0
; end of _ResponderSPI

_interrupt:

;PruebaConfiguracion.c,155 :: 		void interrupt(void){
;PruebaConfiguracion.c,171 :: 		if (SSP1IF_bit==1){
	BTFSS       SSP1IF_bit+0, BitPos(SSP1IF_bit+0) 
	GOTO        L_interrupt8
;PruebaConfiguracion.c,173 :: 		SSP1IF_bit = 0;                                                          //Limpia la bandera de interrupcion por SPI
	BCF         SSP1IF_bit+0, BitPos(SSP1IF_bit+0) 
;PruebaConfiguracion.c,174 :: 		bufferSPI = SSP1BUF;                                                     //Guarda el contenido del bufeer (lectura)
	MOVF        SSP1BUF+0, 0 
	MOVWF       _bufferSPI+0 
;PruebaConfiguracion.c,177 :: 		if ((banSPI1==0)&&(bufferSPI==0xA1)){
	MOVF        _banSPI1+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt11
	MOVF        _bufferSPI+0, 0 
	XORLW       161
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt11
L__interrupt27:
;PruebaConfiguracion.c,178 :: 		i = 0;                                                                //Limpia el subindice para guardar la trama SPI
	CLRF        _i+0 
	CLRF        _i+1 
;PruebaConfiguracion.c,179 :: 		CambiarEstadoBandera(1,1);                                            //Activa la bandera banSPI1
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_bandera+0 
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,180 :: 		}
L_interrupt11:
;PruebaConfiguracion.c,181 :: 		if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
	MOVF        _banSPI1+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt14
	MOVF        _bufferSPI+0, 0 
	XORLW       161
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt14
	MOVF        _bufferSPI+0, 0 
	XORLW       241
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt14
L__interrupt26:
;PruebaConfiguracion.c,182 :: 		tramaSolicitudSPI[i] = bufferSPI;                                     //Recupera la trama de solicitud SPI
	MOVLW       _tramaSolicitudSPI+0
	ADDWF       _i+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_tramaSolicitudSPI+0)
	ADDWFC      _i+1, 0 
	MOVWF       FSR1H 
	MOVF        _bufferSPI+0, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,183 :: 		i++;
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;PruebaConfiguracion.c,184 :: 		}
L_interrupt14:
;PruebaConfiguracion.c,185 :: 		if ((banSPI1==1)&&(bufferSPI==0xF1)){
	MOVF        _banSPI1+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt17
	MOVF        _bufferSPI+0, 0 
	XORLW       241
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt17
L__interrupt25:
;PruebaConfiguracion.c,187 :: 		for (j=0;j<4;j++){
	CLRF        _j+0 
	CLRF        _j+1 
L_interrupt18:
	MOVLW       0
	SUBWF       _j+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt34
	MOVLW       4
	SUBWF       _j+0, 0 
L__interrupt34:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt19
;PruebaConfiguracion.c,188 :: 		cabeceraSolicitud[j] = tramaSolicitudSPI[j];
	MOVLW       _cabeceraSolicitud+0
	ADDWF       _j+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_cabeceraSolicitud+0)
	ADDWFC      _j+1, 0 
	MOVWF       FSR1H 
	MOVLW       _tramaSolicitudSPI+0
	ADDWF       _j+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_tramaSolicitudSPI+0)
	ADDWFC      _j+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,187 :: 		for (j=0;j<4;j++){
	INFSNZ      _j+0, 1 
	INCF        _j+1, 1 
;PruebaConfiguracion.c,189 :: 		}
	GOTO        L_interrupt18
L_interrupt19:
;PruebaConfiguracion.c,191 :: 		for (j=0;j<(cabeceraSolicitud[3]);j++){
	CLRF        _j+0 
	CLRF        _j+1 
L_interrupt21:
	MOVLW       0
	SUBWF       _j+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt35
	MOVF        _cabeceraSolicitud+3, 0 
	SUBWF       _j+0, 0 
L__interrupt35:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt22
;PruebaConfiguracion.c,192 :: 		payloadSolicitud[j] = tramaSolicitudSPI[4+j];
	MOVLW       _payloadSolicitud+0
	ADDWF       _j+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_payloadSolicitud+0)
	ADDWFC      _j+1, 0 
	MOVWF       FSR1H 
	MOVLW       4
	ADDWF       _j+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _j+1, 0 
	MOVWF       R1 
	MOVLW       _tramaSolicitudSPI+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_tramaSolicitudSPI+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,191 :: 		for (j=0;j<(cabeceraSolicitud[3]);j++){
	INFSNZ      _j+0, 1 
	INCF        _j+1, 1 
;PruebaConfiguracion.c,193 :: 		}
	GOTO        L_interrupt21
L_interrupt22:
;PruebaConfiguracion.c,196 :: 		if ((payloadSolicitud[1])==0xEE){
	MOVF        _payloadSolicitud+1, 0 
	XORLW       238
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt24
;PruebaConfiguracion.c,197 :: 		TEST = ~TEST;
	BTG         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,198 :: 		ResponderSPI(cabeceraSolicitud, payloadSolicitud);
	MOVLW       _cabeceraSolicitud+0
	MOVWF       FARG_ResponderSPI_cabeceraRespuesta+0 
	MOVLW       hi_addr(_cabeceraSolicitud+0)
	MOVWF       FARG_ResponderSPI_cabeceraRespuesta+1 
	MOVLW       _payloadSolicitud+0
	MOVWF       FARG_ResponderSPI_payloadRespuesta+0 
	MOVLW       hi_addr(_payloadSolicitud+0)
	MOVWF       FARG_ResponderSPI_payloadRespuesta+1 
	CALL        _ResponderSPI+0, 0
;PruebaConfiguracion.c,199 :: 		}
L_interrupt24:
;PruebaConfiguracion.c,202 :: 		CambiarEstadoBandera(1,0);                                            //Limpia la bandera
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_bandera+0 
	CLRF        FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,203 :: 		}
L_interrupt17:
;PruebaConfiguracion.c,209 :: 		}
L_interrupt8:
;PruebaConfiguracion.c,211 :: 		}
L_end_interrupt:
L__interrupt33:
	RETFIE      1
; end of _interrupt
