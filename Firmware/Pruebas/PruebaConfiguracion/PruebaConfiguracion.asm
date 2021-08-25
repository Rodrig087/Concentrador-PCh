
_main:

;PruebaConfiguracion.c,39 :: 		void main() {
;PruebaConfiguracion.c,41 :: 		ConfiguracionPrincipal();
	CALL        _ConfiguracionPrincipal+0, 0
;PruebaConfiguracion.c,45 :: 		i = 0;
	CLRF        _i+0 
	CLRF        _i+1 
;PruebaConfiguracion.c,46 :: 		j = 0;
	CLRF        _j+0 
	CLRF        _j+1 
;PruebaConfiguracion.c,47 :: 		x = 0;
	CLRF        _x+0 
	CLRF        _x+1 
;PruebaConfiguracion.c,48 :: 		y = 0;
	CLRF        _y+0 
	CLRF        _y+1 
;PruebaConfiguracion.c,50 :: 		banSPI0 = 0;
	CLRF        _banSPI0+0 
;PruebaConfiguracion.c,51 :: 		banSPI1 = 0;
	CLRF        _banSPI1+0 
;PruebaConfiguracion.c,53 :: 		direccionSol = 0;
	CLRF        _direccionSol+0 
;PruebaConfiguracion.c,54 :: 		funcionSol = 0;
	CLRF        _funcionSol+0 
;PruebaConfiguracion.c,55 :: 		subFuncionSol = 0;
	CLRF        _subFuncionSol+0 
;PruebaConfiguracion.c,56 :: 		numDatosSol = 0;
	CLRF        _numDatosSol+0 
;PruebaConfiguracion.c,58 :: 		RP0 = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;PruebaConfiguracion.c,59 :: 		TEST = 1;
	BSF         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,70 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_ConfiguracionPrincipal:

;PruebaConfiguracion.c,77 :: 		void ConfiguracionPrincipal(){
;PruebaConfiguracion.c,80 :: 		OSCCON.IDLEN=1;                                    //Entra en modo IDLE durante la instruccion SLEEP
	BSF         OSCCON+0, 7 
;PruebaConfiguracion.c,81 :: 		OSCCON.IRCF2=1;                                    //HFINTOSC=16MHz  IRFC=111
	BSF         OSCCON+0, 6 
;PruebaConfiguracion.c,82 :: 		OSCCON.IRCF1=1;
	BSF         OSCCON+0, 5 
;PruebaConfiguracion.c,83 :: 		OSCCON.IRCF0=1;
	BSF         OSCCON+0, 4 
;PruebaConfiguracion.c,84 :: 		OSCCON.SCS1=1;                                     //System Clock Select bit:  1x=Internal oscillator block
	BSF         OSCCON+0, 1 
;PruebaConfiguracion.c,85 :: 		OSCCON.SCS0=1;
	BSF         OSCCON+0, 0 
;PruebaConfiguracion.c,88 :: 		ANSELA = 0;                                        //Configura PORTA como digital
	CLRF        ANSELA+0 
;PruebaConfiguracion.c,89 :: 		ANSELB = 0;                                        //Configura PORTB como digital
	CLRF        ANSELB+0 
;PruebaConfiguracion.c,90 :: 		ANSELC = 0;                                        //Configura PORTC como digital
	CLRF        ANSELC+0 
;PruebaConfiguracion.c,92 :: 		TEST_Direction = 0;                                //Configura el pin TEST como salida
	BCF         TRISB2_bit+0, BitPos(TRISB2_bit+0) 
;PruebaConfiguracion.c,93 :: 		RP0_Direction = 0;                                 //Configura el pin RP0 como salida
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;PruebaConfiguracion.c,94 :: 		TRISA5_bit = 1;                                    //SS1 In
	BSF         TRISA5_bit+0, BitPos(TRISA5_bit+0) 
;PruebaConfiguracion.c,95 :: 		TRISC3_bit = 1;                                    //SCK1 In
	BSF         TRISC3_bit+0, BitPos(TRISC3_bit+0) 
;PruebaConfiguracion.c,96 :: 		TRISC4_bit = 1;                                    //SDI1 In
	BSF         TRISC4_bit+0, BitPos(TRISC4_bit+0) 
;PruebaConfiguracion.c,97 :: 		TRISC5_bit = 0;                                    //SDO1 Out
	BCF         TRISC5_bit+0, BitPos(TRISC5_bit+0) 
;PruebaConfiguracion.c,99 :: 		INTCON.GIE = 1;                                    //Habilita las interrupciones globales
	BSF         INTCON+0, 7 
;PruebaConfiguracion.c,100 :: 		INTCON.PEIE = 1;                                   //Habilita las interrupciones perifericas
	BSF         INTCON+0, 6 
;PruebaConfiguracion.c,103 :: 		SSP1IE_bit = 1;
	BSF         SSP1IE_bit+0, BitPos(SSP1IE_bit+0) 
;PruebaConfiguracion.c,104 :: 		SPI1_Init_Advanced(_SPI_SLAVE_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_HIGH_2_LOW);
	MOVLW       4
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	MOVLW       128
	MOVWF       FARG_SPI1_Init_Advanced_data_sample+0 
	MOVLW       16
	MOVWF       FARG_SPI1_Init_Advanced_clock_idle+0 
	CLRF        FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;PruebaConfiguracion.c,105 :: 		SSP1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI *
	BCF         SSP1IF_bit+0, BitPos(SSP1IF_bit+0) 
;PruebaConfiguracion.c,115 :: 		Delay_ms(100);                                     //Espera hasta que se estabilicen los cambios
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
;PruebaConfiguracion.c,116 :: 		}
L_end_ConfiguracionPrincipal:
	RETURN      0
; end of _ConfiguracionPrincipal

_CambiarEstadoBandera:

;PruebaConfiguracion.c,119 :: 		void CambiarEstadoBandera(unsigned short bandera, unsigned short estado){
;PruebaConfiguracion.c,121 :: 		if (estado==1){
	MOVF        FARG_CambiarEstadoBandera_estado+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera1
;PruebaConfiguracion.c,123 :: 		banSPI0 = 3;
	MOVLW       3
	MOVWF       _banSPI0+0 
;PruebaConfiguracion.c,124 :: 		banSPI1 = 3;
	MOVLW       3
	MOVWF       _banSPI1+0 
;PruebaConfiguracion.c,126 :: 		switch (bandera){
	GOTO        L_CambiarEstadoBandera2
;PruebaConfiguracion.c,127 :: 		case 0:
L_CambiarEstadoBandera4:
;PruebaConfiguracion.c,128 :: 		banSPI0 = 1;
	MOVLW       1
	MOVWF       _banSPI0+0 
;PruebaConfiguracion.c,129 :: 		break;
	GOTO        L_CambiarEstadoBandera3
;PruebaConfiguracion.c,130 :: 		case 1:
L_CambiarEstadoBandera5:
;PruebaConfiguracion.c,131 :: 		banSPI1 = 1;
	MOVLW       1
	MOVWF       _banSPI1+0 
;PruebaConfiguracion.c,132 :: 		break;
	GOTO        L_CambiarEstadoBandera3
;PruebaConfiguracion.c,133 :: 		}
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
;PruebaConfiguracion.c,134 :: 		}
L_CambiarEstadoBandera1:
;PruebaConfiguracion.c,136 :: 		if (estado==0){
	MOVF        FARG_CambiarEstadoBandera_estado+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera6
;PruebaConfiguracion.c,137 :: 		banSPI0 = 0;
	CLRF        _banSPI0+0 
;PruebaConfiguracion.c,138 :: 		banSPI1 = 0;
	CLRF        _banSPI1+0 
;PruebaConfiguracion.c,139 :: 		}
L_CambiarEstadoBandera6:
;PruebaConfiguracion.c,140 :: 		}
L_end_CambiarEstadoBandera:
	RETURN      0
; end of _CambiarEstadoBandera

_ResponderSPI:

;PruebaConfiguracion.c,143 :: 		void ResponderSPI(unsigned char *cabeceraRespuesta, unsigned char *payloadRespuesta){
;PruebaConfiguracion.c,146 :: 		tramaRespuestaSPI[0] = cabeceraRespuesta[0];
	MOVFF       FARG_ResponderSPI_cabeceraRespuesta+0, FSR0
	MOVFF       FARG_ResponderSPI_cabeceraRespuesta+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       _tramaRespuestaSPI+0 
;PruebaConfiguracion.c,147 :: 		tramaRespuestaSPI[1] = cabeceraRespuesta[1];
	MOVLW       1
	ADDWF       FARG_ResponderSPI_cabeceraRespuesta+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_ResponderSPI_cabeceraRespuesta+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       _tramaRespuestaSPI+1 
;PruebaConfiguracion.c,148 :: 		tramaRespuestaSPI[2] = cabeceraRespuesta[2];
	MOVLW       2
	ADDWF       FARG_ResponderSPI_cabeceraRespuesta+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_ResponderSPI_cabeceraRespuesta+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       _tramaRespuestaSPI+2 
;PruebaConfiguracion.c,149 :: 		tramaRespuestaSPI[3] = cabeceraRespuesta[3];
	MOVLW       3
	ADDWF       FARG_ResponderSPI_cabeceraRespuesta+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_ResponderSPI_cabeceraRespuesta+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       _tramaRespuestaSPI+3 
;PruebaConfiguracion.c,152 :: 		for (j=0;j<(cabeceraRespuesta[3]);j++){
	CLRF        _j+0 
	CLRF        _j+1 
L_ResponderSPI7:
	MOVLW       3
	ADDWF       FARG_ResponderSPI_cabeceraRespuesta+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_ResponderSPI_cabeceraRespuesta+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	MOVWF       R1 
	MOVLW       0
	SUBWF       _j+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ResponderSPI47
	MOVF        R1, 0 
	SUBWF       _j+0, 0 
L__ResponderSPI47:
	BTFSC       STATUS+0, 0 
	GOTO        L_ResponderSPI8
;PruebaConfiguracion.c,153 :: 		tramaRespuestaSPI[j+4] = payloadRespuesta[j];
	MOVLW       4
	ADDWF       _j+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _j+1, 0 
	MOVWF       R1 
	MOVLW       _tramaRespuestaSPI+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_tramaRespuestaSPI+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        _j+0, 0 
	ADDWF       FARG_ResponderSPI_payloadRespuesta+0, 0 
	MOVWF       FSR0 
	MOVF        _j+1, 0 
	ADDWFC      FARG_ResponderSPI_payloadRespuesta+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,152 :: 		for (j=0;j<(cabeceraRespuesta[3]);j++){
	INFSNZ      _j+0, 1 
	INCF        _j+1, 1 
;PruebaConfiguracion.c,154 :: 		}
	GOTO        L_ResponderSPI7
L_ResponderSPI8:
;PruebaConfiguracion.c,165 :: 		RP0 = 1;
	BSF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;PruebaConfiguracion.c,166 :: 		Delay_us(100);
	MOVLW       133
	MOVWF       R13, 0
L_ResponderSPI10:
	DECFSZ      R13, 1, 1
	BRA         L_ResponderSPI10
;PruebaConfiguracion.c,167 :: 		RP0 = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;PruebaConfiguracion.c,169 :: 		}
L_end_ResponderSPI:
	RETURN      0
; end of _ResponderSPI

_interrupt:

;PruebaConfiguracion.c,175 :: 		void interrupt(void){
;PruebaConfiguracion.c,191 :: 		if (SSP1IF_bit==1){
	BTFSS       SSP1IF_bit+0, BitPos(SSP1IF_bit+0) 
	GOTO        L_interrupt11
;PruebaConfiguracion.c,193 :: 		SSP1IF_bit = 0;                                                          //Limpia la bandera de interrupcion por SPI
	BCF         SSP1IF_bit+0, BitPos(SSP1IF_bit+0) 
;PruebaConfiguracion.c,194 :: 		bufferSPI = SSP1BUF;                                                     //Guarda el contenido del bufeer (lectura)
	MOVF        SSP1BUF+0, 0 
	MOVWF       _bufferSPI+0 
;PruebaConfiguracion.c,197 :: 		if ((banSPI0==0)&&(bufferSPI==0xA0)) {
	MOVF        _banSPI0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt14
	MOVF        _bufferSPI+0, 0 
	XORLW       160
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt14
L__interrupt42:
;PruebaConfiguracion.c,198 :: 		CambiarEstadoBandera(0,1);                                            //Activa la bandera
	CLRF        FARG_CambiarEstadoBandera_bandera+0 
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,199 :: 		i = 1;
	MOVLW       1
	MOVWF       _i+0 
	MOVLW       0
	MOVWF       _i+1 
;PruebaConfiguracion.c,200 :: 		SSP1BUF = tramaRespuestaSPI[0];                                       //Carga en el buffer el primer elemento de la cabecera (id)
	MOVF        _tramaRespuestaSPI+0, 0 
	MOVWF       SSP1BUF+0 
;PruebaConfiguracion.c,201 :: 		}
L_interrupt14:
;PruebaConfiguracion.c,202 :: 		if ((banSPI0==1)&&(bufferSPI!=0xA0)&&(bufferSPI!=0xF0)){
	MOVF        _banSPI0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt17
	MOVF        _bufferSPI+0, 0 
	XORLW       160
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt17
	MOVF        _bufferSPI+0, 0 
	XORLW       240
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt17
L__interrupt41:
;PruebaConfiguracion.c,203 :: 		SSP1BUF = tramaRespuestaSPI[i];                                       //Se envia la subfuncion, y el LSB y MSB de la variable numBytesSPI
	MOVLW       _tramaRespuestaSPI+0
	ADDWF       _i+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_tramaRespuestaSPI+0)
	ADDWFC      _i+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       SSP1BUF+0 
;PruebaConfiguracion.c,204 :: 		i++;
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;PruebaConfiguracion.c,205 :: 		}
L_interrupt17:
;PruebaConfiguracion.c,206 :: 		if ((banSPI0==1)&&(bufferSPI==0xF0)){
	MOVF        _banSPI0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt20
	MOVF        _bufferSPI+0, 0 
	XORLW       240
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt20
L__interrupt40:
;PruebaConfiguracion.c,207 :: 		CambiarEstadoBandera(0,0);                                            //Limpia las banderas
	CLRF        FARG_CambiarEstadoBandera_bandera+0 
	CLRF        FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,208 :: 		}
L_interrupt20:
;PruebaConfiguracion.c,211 :: 		if ((banSPI1==0)&&(bufferSPI==0xA1)){
	MOVF        _banSPI1+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt23
	MOVF        _bufferSPI+0, 0 
	XORLW       161
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt23
L__interrupt39:
;PruebaConfiguracion.c,212 :: 		i = 0;                                                                //Limpia el subindice para guardar la trama SPI
	CLRF        _i+0 
	CLRF        _i+1 
;PruebaConfiguracion.c,213 :: 		CambiarEstadoBandera(1,1);                                            //Activa la bandera banSPI1
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_bandera+0 
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,214 :: 		}
L_interrupt23:
;PruebaConfiguracion.c,215 :: 		if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
	MOVF        _banSPI1+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt26
	MOVF        _bufferSPI+0, 0 
	XORLW       161
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt26
	MOVF        _bufferSPI+0, 0 
	XORLW       241
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt26
L__interrupt38:
;PruebaConfiguracion.c,216 :: 		tramaSolicitudSPI[i] = bufferSPI;                                     //Recupera la trama de solicitud SPI
	MOVLW       _tramaSolicitudSPI+0
	ADDWF       _i+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_tramaSolicitudSPI+0)
	ADDWFC      _i+1, 0 
	MOVWF       FSR1H 
	MOVF        _bufferSPI+0, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,217 :: 		i++;
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;PruebaConfiguracion.c,218 :: 		}
L_interrupt26:
;PruebaConfiguracion.c,219 :: 		if ((banSPI1==1)&&(bufferSPI==0xF1)){
	MOVF        _banSPI1+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt29
	MOVF        _bufferSPI+0, 0 
	XORLW       241
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt29
L__interrupt37:
;PruebaConfiguracion.c,221 :: 		for (j=0;j<4;j++){
	CLRF        _j+0 
	CLRF        _j+1 
L_interrupt30:
	MOVLW       0
	SUBWF       _j+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt50
	MOVLW       4
	SUBWF       _j+0, 0 
L__interrupt50:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt31
;PruebaConfiguracion.c,222 :: 		cabeceraSolicitud[j] = tramaSolicitudSPI[j];
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
;PruebaConfiguracion.c,221 :: 		for (j=0;j<4;j++){
	INFSNZ      _j+0, 1 
	INCF        _j+1, 1 
;PruebaConfiguracion.c,223 :: 		}
	GOTO        L_interrupt30
L_interrupt31:
;PruebaConfiguracion.c,225 :: 		for (j=0;j<(cabeceraSolicitud[3]);j++){
	CLRF        _j+0 
	CLRF        _j+1 
L_interrupt33:
	MOVLW       0
	SUBWF       _j+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt51
	MOVF        _cabeceraSolicitud+3, 0 
	SUBWF       _j+0, 0 
L__interrupt51:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt34
;PruebaConfiguracion.c,226 :: 		payloadSolicitud[j] = tramaSolicitudSPI[4+j];
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
;PruebaConfiguracion.c,225 :: 		for (j=0;j<(cabeceraSolicitud[3]);j++){
	INFSNZ      _j+0, 1 
	INCF        _j+1, 1 
;PruebaConfiguracion.c,227 :: 		}
	GOTO        L_interrupt33
L_interrupt34:
;PruebaConfiguracion.c,230 :: 		if ((payloadSolicitud[4])==0xE5){
	MOVF        _payloadSolicitud+4, 0 
	XORLW       229
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt36
;PruebaConfiguracion.c,231 :: 		TEST = ~TEST;
	BTG         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,232 :: 		ResponderSPI(cabeceraSolicitud, payloadSolicitud); //Esta parte deberia ir en la interrupcion uart
	MOVLW       _cabeceraSolicitud+0
	MOVWF       FARG_ResponderSPI_cabeceraRespuesta+0 
	MOVLW       hi_addr(_cabeceraSolicitud+0)
	MOVWF       FARG_ResponderSPI_cabeceraRespuesta+1 
	MOVLW       _payloadSolicitud+0
	MOVWF       FARG_ResponderSPI_payloadRespuesta+0 
	MOVLW       hi_addr(_payloadSolicitud+0)
	MOVWF       FARG_ResponderSPI_payloadRespuesta+1 
	CALL        _ResponderSPI+0, 0
;PruebaConfiguracion.c,233 :: 		}
L_interrupt36:
;PruebaConfiguracion.c,236 :: 		CambiarEstadoBandera(1,0);                                            //Limpia la bandera
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_bandera+0 
	CLRF        FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,237 :: 		}
L_interrupt29:
;PruebaConfiguracion.c,243 :: 		}
L_interrupt11:
;PruebaConfiguracion.c,245 :: 		}
L_end_interrupt:
L__interrupt49:
	RETFIE      1
; end of _interrupt
