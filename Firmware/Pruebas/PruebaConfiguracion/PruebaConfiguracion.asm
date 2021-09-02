
_EnviarTramaRS485:

;rs485.c,20 :: 		void EnviarTramaRS485(unsigned short puertoUART, unsigned char *cabecera, unsigned char *payload){
;rs485.c,28 :: 		direccion = cabecera[0];
	MOVFF       FARG_EnviarTramaRS485_cabecera+0, FSR0
	MOVFF       FARG_EnviarTramaRS485_cabecera+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       EnviarTramaRS485_direccion_L0+0 
;rs485.c,29 :: 		funcion = cabecera[1];
	MOVLW       1
	ADDWF       FARG_EnviarTramaRS485_cabecera+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_EnviarTramaRS485_cabecera+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       EnviarTramaRS485_funcion_L0+0 
;rs485.c,30 :: 		subfuncion = cabecera[2];
	MOVLW       2
	ADDWF       FARG_EnviarTramaRS485_cabecera+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_EnviarTramaRS485_cabecera+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       EnviarTramaRS485_subfuncion_L0+0 
;rs485.c,31 :: 		numDatos = cabecera[3];
	MOVLW       3
	ADDWF       FARG_EnviarTramaRS485_cabecera+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_EnviarTramaRS485_cabecera+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       EnviarTramaRS485_numDatos_L0+0 
;rs485.c,33 :: 		if (puertoUART == 1){
	MOVF        FARG_EnviarTramaRS485_puertoUART+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_EnviarTramaRS4850
;rs485.c,34 :: 		MS1RS485 = 1;                                                            //Establece el Max485 en modo escritura
	BSF         MS1RS485+0, BitPos(MS1RS485+0) 
;rs485.c,35 :: 		UART1_Write(0x3A);                                                      //Envia la cabecera de la trama
	MOVLW       58
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,36 :: 		UART1_Write(direccion);                                                 //Envia la direccion del destinatario
	MOVF        EnviarTramaRS485_direccion_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,37 :: 		UART1_Write(funcion);                                                   //Envia el codigo de la funcion
	MOVF        EnviarTramaRS485_funcion_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,38 :: 		UART1_Write(subfuncion);                                                //Envia el codigo de la subfuncion
	MOVF        EnviarTramaRS485_subfuncion_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,39 :: 		UART1_Write(numDatos);                                                  //Envia el numero de datos
	MOVF        EnviarTramaRS485_numDatos_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,40 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	CLRF        EnviarTramaRS485_iDatos_L0+0 
L_EnviarTramaRS4851:
	MOVF        EnviarTramaRS485_numDatos_L0+0, 0 
	SUBWF       EnviarTramaRS485_iDatos_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_EnviarTramaRS4852
;rs485.c,41 :: 		UART1_Write(payload[iDatos]);
	MOVF        EnviarTramaRS485_iDatos_L0+0, 0 
	ADDWF       FARG_EnviarTramaRS485_payload+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_EnviarTramaRS485_payload+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,40 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INCF        EnviarTramaRS485_iDatos_L0+0, 1 
;rs485.c,42 :: 		}
	GOTO        L_EnviarTramaRS4851
L_EnviarTramaRS4852:
;rs485.c,43 :: 		UART1_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,44 :: 		UART1_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,45 :: 		UART1_Write(0x00);                                                      //Envia un byte adicional
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,46 :: 		while(UART1_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarTramaRS4854:
	CALL        _UART1_Tx_Idle+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_EnviarTramaRS4855
	GOTO        L_EnviarTramaRS4854
L_EnviarTramaRS4855:
;rs485.c,47 :: 		MS1RS485 = 0;                                                            //Establece el Max485 en modo lectura
	BCF         MS1RS485+0, BitPos(MS1RS485+0) 
;rs485.c,48 :: 		}
L_EnviarTramaRS4850:
;rs485.c,50 :: 		if (puertoUART == 2){
	MOVF        FARG_EnviarTramaRS485_puertoUART+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_EnviarTramaRS4856
;rs485.c,51 :: 		MS2RS485 = 1;                                                            //Establece el Max485 en modo escritura
	BSF         MS2RS485+0, BitPos(MS2RS485+0) 
;rs485.c,52 :: 		UART2_Write(0x3A);                                                      //Envia la cabecera de la trama
	MOVLW       58
	MOVWF       FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;rs485.c,53 :: 		UART2_Write(direccion);                                                 //Envia la direccion del destinatario
	MOVF        EnviarTramaRS485_direccion_L0+0, 0 
	MOVWF       FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;rs485.c,54 :: 		UART2_Write(funcion);                                                   //Envia el codigo de la funcion
	MOVF        EnviarTramaRS485_funcion_L0+0, 0 
	MOVWF       FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;rs485.c,55 :: 		UART1_Write(subfuncion);                                                //Envia el codigo de la subfuncion
	MOVF        EnviarTramaRS485_subfuncion_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,56 :: 		UART1_Write(numDatos);                                                  //Envia el numero de datos
	MOVF        EnviarTramaRS485_numDatos_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,57 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	CLRF        EnviarTramaRS485_iDatos_L0+0 
L_EnviarTramaRS4857:
	MOVF        EnviarTramaRS485_numDatos_L0+0, 0 
	SUBWF       EnviarTramaRS485_iDatos_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_EnviarTramaRS4858
;rs485.c,58 :: 		UART2_Write(payload[iDatos]);
	MOVF        EnviarTramaRS485_iDatos_L0+0, 0 
	ADDWF       FARG_EnviarTramaRS485_payload+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_EnviarTramaRS485_payload+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;rs485.c,57 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INCF        EnviarTramaRS485_iDatos_L0+0, 1 
;rs485.c,59 :: 		}
	GOTO        L_EnviarTramaRS4857
L_EnviarTramaRS4858:
;rs485.c,60 :: 		UART2_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	MOVLW       13
	MOVWF       FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;rs485.c,61 :: 		UART2_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOVLW       10
	MOVWF       FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;rs485.c,62 :: 		UART2_Write(0x00);                                                      //Envia un byte adicional
	CLRF        FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;rs485.c,63 :: 		while(UART2_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarTramaRS48510:
	CALL        _UART2_Tx_Idle+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_EnviarTramaRS48511
	GOTO        L_EnviarTramaRS48510
L_EnviarTramaRS48511:
;rs485.c,64 :: 		MS2RS485 = 0;                                                            //Establece el Max485 en modo lectura
	BCF         MS2RS485+0, BitPos(MS2RS485+0) 
;rs485.c,65 :: 		}
L_EnviarTramaRS4856:
;rs485.c,67 :: 		}
L_end_EnviarTramaRS485:
	RETURN      0
; end of _EnviarTramaRS485

_main:

;PruebaConfiguracion.c,63 :: 		void main() {
;PruebaConfiguracion.c,66 :: 		ConfiguracionPrincipal();
	CALL        _ConfiguracionPrincipal+0, 0
;PruebaConfiguracion.c,70 :: 		i = 0;
	CLRF        _i+0 
	CLRF        _i+1 
;PruebaConfiguracion.c,71 :: 		j = 0;
	CLRF        _j+0 
	CLRF        _j+1 
;PruebaConfiguracion.c,72 :: 		x = 0;
	CLRF        _x+0 
	CLRF        _x+1 
;PruebaConfiguracion.c,73 :: 		y = 0;
	CLRF        _y+0 
	CLRF        _y+1 
;PruebaConfiguracion.c,75 :: 		banSPI0 = 0;
	CLRF        _banSPI0+0 
;PruebaConfiguracion.c,76 :: 		banSPI1 = 0;
	CLRF        _banSPI1+0 
;PruebaConfiguracion.c,77 :: 		bufferSPI = 0;
	CLRF        _bufferSPI+0 
;PruebaConfiguracion.c,78 :: 		idSolicitud = 0;
	CLRF        _idSolicitud+0 
;PruebaConfiguracion.c,79 :: 		funcionSolicitud = 0;
	CLRF        _funcionSolicitud+0 
;PruebaConfiguracion.c,80 :: 		subFuncionSolicitud = 0;
	CLRF        _subFuncionSolicitud+0 
;PruebaConfiguracion.c,82 :: 		banRSI = 0;
	CLRF        _banRSI+0 
;PruebaConfiguracion.c,83 :: 		banRSC = 0;
	CLRF        _banRSC+0 
;PruebaConfiguracion.c,84 :: 		byteRS485 = 0;
	CLRF        _byteRS485+0 
;PruebaConfiguracion.c,85 :: 		i_rs485 = 0;
	CLRF        _i_rs485+0 
	CLRF        _i_rs485+1 
;PruebaConfiguracion.c,86 :: 		funcionRS485 = 0;
	CLRF        _funcionRS485+0 
;PruebaConfiguracion.c,87 :: 		subFuncionRS485 = 0;
	CLRF        _subFuncionRS485+0 
;PruebaConfiguracion.c,88 :: 		numDatosRS485 = 0;
	CLRF        _numDatosRS485+0 
;PruebaConfiguracion.c,89 :: 		MS1RS485 = 0;
	BCF         LATB3_bit+0, BitPos(LATB3_bit+0) 
;PruebaConfiguracion.c,90 :: 		MS2RS485 = 0;
	BCF         LATB5_bit+0, BitPos(LATB5_bit+0) 
;PruebaConfiguracion.c,91 :: 		sumValidacion = 0;
	CLRF        _sumValidacion+0 
;PruebaConfiguracion.c,93 :: 		RP0 = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;PruebaConfiguracion.c,94 :: 		TEST = 1;
	BSF         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,95 :: 		MS1RS485 = 0;
	BCF         LATB3_bit+0, BitPos(LATB3_bit+0) 
;PruebaConfiguracion.c,96 :: 		MS2RS485 = 0;
	BCF         LATB5_bit+0, BitPos(LATB5_bit+0) 
;PruebaConfiguracion.c,98 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_ConfiguracionPrincipal:

;PruebaConfiguracion.c,105 :: 		void ConfiguracionPrincipal(){
;PruebaConfiguracion.c,108 :: 		OSCCON.IDLEN=1;                                    //Entra en modo IDLE durante la instruccion SLEEP
	BSF         OSCCON+0, 7 
;PruebaConfiguracion.c,109 :: 		OSCCON.IRCF2=1;                                    //HFINTOSC=16MHz  IRFC=111
	BSF         OSCCON+0, 6 
;PruebaConfiguracion.c,110 :: 		OSCCON.IRCF1=1;
	BSF         OSCCON+0, 5 
;PruebaConfiguracion.c,111 :: 		OSCCON.IRCF0=1;
	BSF         OSCCON+0, 4 
;PruebaConfiguracion.c,112 :: 		OSCCON.SCS1=1;                                     //System Clock Select bit:  1x=Internal oscillator block
	BSF         OSCCON+0, 1 
;PruebaConfiguracion.c,113 :: 		OSCCON.SCS0=1;
	BSF         OSCCON+0, 0 
;PruebaConfiguracion.c,116 :: 		ANSELA = 0;                                        //Configura PORTA como digital
	CLRF        ANSELA+0 
;PruebaConfiguracion.c,117 :: 		ANSELB = 0;                                        //Configura PORTB como digital
	CLRF        ANSELB+0 
;PruebaConfiguracion.c,118 :: 		ANSELC = 0;                                        //Configura PORTC como digital
	CLRF        ANSELC+0 
;PruebaConfiguracion.c,120 :: 		TEST_Direction = 0;                                //Configura el pin TEST como salida
	BCF         TRISB2_bit+0, BitPos(TRISB2_bit+0) 
;PruebaConfiguracion.c,121 :: 		RP0_Direction = 0;                                 //Configura el pin RP0 como salida
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;PruebaConfiguracion.c,122 :: 		MS1RS485_Direction = 0;                            //Configura el pin MS1RS485 como salida
	BCF         TRISB3_bit+0, BitPos(TRISB3_bit+0) 
;PruebaConfiguracion.c,123 :: 		MS2RS485_Direction = 0;                            //Configura el pin MS2RS485 como salida
	BCF         TRISB5_bit+0, BitPos(TRISB5_bit+0) 
;PruebaConfiguracion.c,124 :: 		TRISA5_bit = 1;                                    //SS1 In
	BSF         TRISA5_bit+0, BitPos(TRISA5_bit+0) 
;PruebaConfiguracion.c,125 :: 		TRISC3_bit = 1;                                    //SCK1 In
	BSF         TRISC3_bit+0, BitPos(TRISC3_bit+0) 
;PruebaConfiguracion.c,126 :: 		TRISC4_bit = 1;                                    //SDI1 In
	BSF         TRISC4_bit+0, BitPos(TRISC4_bit+0) 
;PruebaConfiguracion.c,127 :: 		TRISC5_bit = 0;                                    //SDO1 Out
	BCF         TRISC5_bit+0, BitPos(TRISC5_bit+0) 
;PruebaConfiguracion.c,129 :: 		INTCON.GIE = 1;                                    //Habilita las interrupciones globales
	BSF         INTCON+0, 7 
;PruebaConfiguracion.c,130 :: 		INTCON.PEIE = 1;                                   //Habilita las interrupciones perifericas
	BSF         INTCON+0, 6 
;PruebaConfiguracion.c,133 :: 		PIE1.SSP1IE = 1;                                   //Activa la interrupcion por SPI
	BSF         PIE1+0, 3 
;PruebaConfiguracion.c,134 :: 		PIR1.SSP1IF = 0;                                   //Limpia la bandera de interrupcion por SPI *
	BCF         PIR1+0, 3 
;PruebaConfiguracion.c,135 :: 		SPI1_Init_Advanced(_SPI_SLAVE_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_HIGH_2_LOW);
	MOVLW       4
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	MOVLW       128
	MOVWF       FARG_SPI1_Init_Advanced_data_sample+0 
	MOVLW       16
	MOVWF       FARG_SPI1_Init_Advanced_clock_idle+0 
	CLRF        FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;PruebaConfiguracion.c,138 :: 		PIE1.RC1IE = 1;                                   //Habilita la interrupcion en UART1 receive
	BSF         PIE1+0, 5 
;PruebaConfiguracion.c,139 :: 		PIR1.RC1IF = 0;                                   //Limpia la bandera de interrupcion UART1
	BCF         PIR1+0, 5 
;PruebaConfiguracion.c,140 :: 		PIE3.RC2IE = 1;                                   //Habilita la interrupcion en UART2 receive
	BSF         PIE3+0, 5 
;PruebaConfiguracion.c,141 :: 		PIR3.RC2IF = 0;                                   //Limpia la bandera de interrupcion
	BCF         PIR3+0, 5 
;PruebaConfiguracion.c,142 :: 		UART1_Init(19200);                                //Inicializa el UART1 a 19200 bps
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       207
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;PruebaConfiguracion.c,143 :: 		UART2_Init(19200);                                //Inicializa el UART2 a 19200 bps
	BSF         BAUDCON2+0, 3, 0
	CLRF        SPBRGH2+0 
	MOVLW       207
	MOVWF       SPBRG2+0 
	BSF         TXSTA2+0, 2, 0
	CALL        _UART2_Init+0, 0
;PruebaConfiguracion.c,152 :: 		Delay_ms(100);                                     //Espera hasta que se estabilicen los cambios
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_ConfiguracionPrincipal12:
	DECFSZ      R13, 1, 1
	BRA         L_ConfiguracionPrincipal12
	DECFSZ      R12, 1, 1
	BRA         L_ConfiguracionPrincipal12
	DECFSZ      R11, 1, 1
	BRA         L_ConfiguracionPrincipal12
;PruebaConfiguracion.c,153 :: 		}
L_end_ConfiguracionPrincipal:
	RETURN      0
; end of _ConfiguracionPrincipal

_CambiarEstadoBandera:

;PruebaConfiguracion.c,156 :: 		void CambiarEstadoBandera(unsigned short bandera, unsigned short estado){
;PruebaConfiguracion.c,158 :: 		if (estado==1){
	MOVF        FARG_CambiarEstadoBandera_estado+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera13
;PruebaConfiguracion.c,160 :: 		banSPI0 = 3;
	MOVLW       3
	MOVWF       _banSPI0+0 
;PruebaConfiguracion.c,161 :: 		banSPI1 = 3;
	MOVLW       3
	MOVWF       _banSPI1+0 
;PruebaConfiguracion.c,163 :: 		switch (bandera){
	GOTO        L_CambiarEstadoBandera14
;PruebaConfiguracion.c,164 :: 		case 0:
L_CambiarEstadoBandera16:
;PruebaConfiguracion.c,165 :: 		banSPI0 = 1;
	MOVLW       1
	MOVWF       _banSPI0+0 
;PruebaConfiguracion.c,166 :: 		break;
	GOTO        L_CambiarEstadoBandera15
;PruebaConfiguracion.c,167 :: 		case 1:
L_CambiarEstadoBandera17:
;PruebaConfiguracion.c,168 :: 		banSPI1 = 1;
	MOVLW       1
	MOVWF       _banSPI1+0 
;PruebaConfiguracion.c,169 :: 		break;
	GOTO        L_CambiarEstadoBandera15
;PruebaConfiguracion.c,170 :: 		}
L_CambiarEstadoBandera14:
	MOVF        FARG_CambiarEstadoBandera_bandera+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera16
	MOVF        FARG_CambiarEstadoBandera_bandera+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera17
L_CambiarEstadoBandera15:
;PruebaConfiguracion.c,171 :: 		}
L_CambiarEstadoBandera13:
;PruebaConfiguracion.c,173 :: 		if (estado==0){
	MOVF        FARG_CambiarEstadoBandera_estado+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera18
;PruebaConfiguracion.c,174 :: 		banSPI0 = 0;
	CLRF        _banSPI0+0 
;PruebaConfiguracion.c,175 :: 		banSPI1 = 0;
	CLRF        _banSPI1+0 
;PruebaConfiguracion.c,176 :: 		}
L_CambiarEstadoBandera18:
;PruebaConfiguracion.c,177 :: 		}
L_end_CambiarEstadoBandera:
	RETURN      0
; end of _CambiarEstadoBandera

_ResponderSPI:

;PruebaConfiguracion.c,180 :: 		void ResponderSPI(unsigned char *cabeceraRespuesta, unsigned char *payloadRespuesta){
;PruebaConfiguracion.c,183 :: 		tramaRespuestaSPI[0] = cabeceraRespuesta[0];
	MOVFF       FARG_ResponderSPI_cabeceraRespuesta+0, FSR0
	MOVFF       FARG_ResponderSPI_cabeceraRespuesta+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       _tramaRespuestaSPI+0 
;PruebaConfiguracion.c,184 :: 		tramaRespuestaSPI[1] = cabeceraRespuesta[1];
	MOVLW       1
	ADDWF       FARG_ResponderSPI_cabeceraRespuesta+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_ResponderSPI_cabeceraRespuesta+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       _tramaRespuestaSPI+1 
;PruebaConfiguracion.c,185 :: 		tramaRespuestaSPI[2] = cabeceraRespuesta[2];
	MOVLW       2
	ADDWF       FARG_ResponderSPI_cabeceraRespuesta+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_ResponderSPI_cabeceraRespuesta+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       _tramaRespuestaSPI+2 
;PruebaConfiguracion.c,186 :: 		tramaRespuestaSPI[3] = cabeceraRespuesta[3];
	MOVLW       3
	ADDWF       FARG_ResponderSPI_cabeceraRespuesta+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_ResponderSPI_cabeceraRespuesta+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       _tramaRespuestaSPI+3 
;PruebaConfiguracion.c,189 :: 		for (j=0;j<(cabeceraRespuesta[3]);j++){
	CLRF        _j+0 
	CLRF        _j+1 
L_ResponderSPI19:
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
	GOTO        L__ResponderSPI84
	MOVF        R1, 0 
	SUBWF       _j+0, 0 
L__ResponderSPI84:
	BTFSC       STATUS+0, 0 
	GOTO        L_ResponderSPI20
;PruebaConfiguracion.c,190 :: 		tramaRespuestaSPI[j+4] = payloadRespuesta[j];
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
;PruebaConfiguracion.c,189 :: 		for (j=0;j<(cabeceraRespuesta[3]);j++){
	INFSNZ      _j+0, 1 
	INCF        _j+1, 1 
;PruebaConfiguracion.c,191 :: 		}
	GOTO        L_ResponderSPI19
L_ResponderSPI20:
;PruebaConfiguracion.c,194 :: 		RP0 = 1;
	BSF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;PruebaConfiguracion.c,195 :: 		Delay_us(100);
	MOVLW       133
	MOVWF       R13, 0
L_ResponderSPI22:
	DECFSZ      R13, 1, 1
	BRA         L_ResponderSPI22
;PruebaConfiguracion.c,196 :: 		RP0 = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;PruebaConfiguracion.c,198 :: 		}
L_end_ResponderSPI:
	RETURN      0
; end of _ResponderSPI

_interrupt:

;PruebaConfiguracion.c,204 :: 		void interrupt(void){
;PruebaConfiguracion.c,220 :: 		if (SSP1IF_bit==1){
	BTFSS       SSP1IF_bit+0, BitPos(SSP1IF_bit+0) 
	GOTO        L_interrupt23
;PruebaConfiguracion.c,222 :: 		SSP1IF_bit = 0;                                                          //Limpia la bandera de interrupcion por SPI
	BCF         SSP1IF_bit+0, BitPos(SSP1IF_bit+0) 
;PruebaConfiguracion.c,223 :: 		bufferSPI = SSP1BUF;                                                     //Guarda el contenido del bufeer (lectura)
	MOVF        SSP1BUF+0, 0 
	MOVWF       _bufferSPI+0 
;PruebaConfiguracion.c,224 :: 		TEST = ~TEST;
	BTG         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,228 :: 		if ((banSPI0==0)&&(bufferSPI==0xA0)) {
	MOVF        _banSPI0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt26
	MOVF        _bufferSPI+0, 0 
	XORLW       160
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt26
L__interrupt78:
;PruebaConfiguracion.c,229 :: 		SSP1BUF = tramaRespuestaSPI[0];                                       //Carga en el buffer el primer elemento de la cabecera (id)
	MOVF        _tramaRespuestaSPI+0, 0 
	MOVWF       SSP1BUF+0 
;PruebaConfiguracion.c,230 :: 		i = 1;
	MOVLW       1
	MOVWF       _i+0 
	MOVLW       0
	MOVWF       _i+1 
;PruebaConfiguracion.c,231 :: 		CambiarEstadoBandera(0,1);                                            //Activa la bandera
	CLRF        FARG_CambiarEstadoBandera_bandera+0 
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,232 :: 		}
L_interrupt26:
;PruebaConfiguracion.c,233 :: 		if ((banSPI0==1)&&(bufferSPI!=0xA0)&&(bufferSPI!=0xF0)){
	MOVF        _banSPI0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt29
	MOVF        _bufferSPI+0, 0 
	XORLW       160
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt29
	MOVF        _bufferSPI+0, 0 
	XORLW       240
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt29
L__interrupt77:
;PruebaConfiguracion.c,234 :: 		SSP1BUF = tramaRespuestaSPI[i];                                       //Se envia la trama de respuesta
	MOVLW       _tramaRespuestaSPI+0
	ADDWF       _i+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_tramaRespuestaSPI+0)
	ADDWFC      _i+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       SSP1BUF+0 
;PruebaConfiguracion.c,235 :: 		i++;
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;PruebaConfiguracion.c,237 :: 		}
L_interrupt29:
;PruebaConfiguracion.c,238 :: 		if ((banSPI0==1)&&(bufferSPI==0xF0)){
	MOVF        _banSPI0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt32
	MOVF        _bufferSPI+0, 0 
	XORLW       240
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt32
L__interrupt76:
;PruebaConfiguracion.c,239 :: 		CambiarEstadoBandera(0,0);                                            //Limpia las banderas
	CLRF        FARG_CambiarEstadoBandera_bandera+0 
	CLRF        FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,240 :: 		}
L_interrupt32:
;PruebaConfiguracion.c,243 :: 		if ((banSPI1==0)&&(bufferSPI==0xA1)){
	MOVF        _banSPI1+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt35
	MOVF        _bufferSPI+0, 0 
	XORLW       161
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt35
L__interrupt75:
;PruebaConfiguracion.c,244 :: 		i = 0;                                                                //Limpia el subindice para guardar la trama SPI
	CLRF        _i+0 
	CLRF        _i+1 
;PruebaConfiguracion.c,245 :: 		CambiarEstadoBandera(1,1);                                            //Activa la bandera banSPI1
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_bandera+0 
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,246 :: 		}
L_interrupt35:
;PruebaConfiguracion.c,247 :: 		if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
	MOVF        _banSPI1+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt38
	MOVF        _bufferSPI+0, 0 
	XORLW       161
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt38
	MOVF        _bufferSPI+0, 0 
	XORLW       241
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt38
L__interrupt74:
;PruebaConfiguracion.c,248 :: 		tramaSolicitudSPI[i] = bufferSPI;                                     //Recupera la trama de solicitud SPI
	MOVLW       _tramaSolicitudSPI+0
	ADDWF       _i+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_tramaSolicitudSPI+0)
	ADDWFC      _i+1, 0 
	MOVWF       FSR1H 
	MOVF        _bufferSPI+0, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,249 :: 		i++;
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;PruebaConfiguracion.c,250 :: 		}
L_interrupt38:
;PruebaConfiguracion.c,251 :: 		if ((banSPI1==1)&&(bufferSPI==0xF1)){
	MOVF        _banSPI1+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt41
	MOVF        _bufferSPI+0, 0 
	XORLW       241
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt41
L__interrupt73:
;PruebaConfiguracion.c,253 :: 		for (j=0;j<4;j++){
	CLRF        _j+0 
	CLRF        _j+1 
L_interrupt42:
	MOVLW       0
	SUBWF       _j+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt87
	MOVLW       4
	SUBWF       _j+0, 0 
L__interrupt87:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt43
;PruebaConfiguracion.c,254 :: 		cabeceraSolicitud[j] = tramaSolicitudSPI[j];
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
;PruebaConfiguracion.c,253 :: 		for (j=0;j<4;j++){
	INFSNZ      _j+0, 1 
	INCF        _j+1, 1 
;PruebaConfiguracion.c,255 :: 		}
	GOTO        L_interrupt42
L_interrupt43:
;PruebaConfiguracion.c,257 :: 		for (j=0;j<(cabeceraSolicitud[3]);j++){
	CLRF        _j+0 
	CLRF        _j+1 
L_interrupt45:
	MOVLW       0
	SUBWF       _j+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt88
	MOVF        _cabeceraSolicitud+3, 0 
	SUBWF       _j+0, 0 
L__interrupt88:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt46
;PruebaConfiguracion.c,258 :: 		payloadSolicitud[j] = tramaSolicitudSPI[4+j];
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
;PruebaConfiguracion.c,257 :: 		for (j=0;j<(cabeceraSolicitud[3]);j++){
	INFSNZ      _j+0, 1 
	INCF        _j+1, 1 
;PruebaConfiguracion.c,259 :: 		}
	GOTO        L_interrupt45
L_interrupt46:
;PruebaConfiguracion.c,262 :: 		idSolicitud = cabeceraSolicitud[0];
	MOVF        _cabeceraSolicitud+0, 0 
	MOVWF       _idSolicitud+0 
;PruebaConfiguracion.c,263 :: 		funcionSolicitud = cabeceraSolicitud[1];
	MOVF        _cabeceraSolicitud+1, 0 
	MOVWF       _funcionSolicitud+0 
;PruebaConfiguracion.c,264 :: 		subFuncionSolicitud = cabeceraSolicitud[2];
	MOVF        _cabeceraSolicitud+2, 0 
	MOVWF       _subFuncionSolicitud+0 
;PruebaConfiguracion.c,267 :: 		if (funcionSolicitud!=4){
	MOVF        _cabeceraSolicitud+1, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt48
;PruebaConfiguracion.c,269 :: 		EnviarTramaRS485(1, cabeceraSolicitud, payloadSolicitud);
	MOVLW       1
	MOVWF       FARG_EnviarTramaRS485_puertoUART+0 
	MOVLW       _cabeceraSolicitud+0
	MOVWF       FARG_EnviarTramaRS485_cabecera+0 
	MOVLW       hi_addr(_cabeceraSolicitud+0)
	MOVWF       FARG_EnviarTramaRS485_cabecera+1 
	MOVLW       _payloadSolicitud+0
	MOVWF       FARG_EnviarTramaRS485_payload+0 
	MOVLW       hi_addr(_payloadSolicitud+0)
	MOVWF       FARG_EnviarTramaRS485_payload+1 
	CALL        _EnviarTramaRS485+0, 0
;PruebaConfiguracion.c,270 :: 		EnviarTramaRS485(2, cabeceraSolicitud, payloadSolicitud);
	MOVLW       2
	MOVWF       FARG_EnviarTramaRS485_puertoUART+0 
	MOVLW       _cabeceraSolicitud+0
	MOVWF       FARG_EnviarTramaRS485_cabecera+0 
	MOVLW       hi_addr(_cabeceraSolicitud+0)
	MOVWF       FARG_EnviarTramaRS485_cabecera+1 
	MOVLW       _payloadSolicitud+0
	MOVWF       FARG_EnviarTramaRS485_payload+0 
	MOVLW       hi_addr(_payloadSolicitud+0)
	MOVWF       FARG_EnviarTramaRS485_payload+1 
	CALL        _EnviarTramaRS485+0, 0
;PruebaConfiguracion.c,271 :: 		} else {
	GOTO        L_interrupt49
L_interrupt48:
;PruebaConfiguracion.c,272 :: 		if (subfuncionSolicitud==1){
	MOVF        _subFuncionSolicitud+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt50
;PruebaConfiguracion.c,274 :: 		TEST = ~TEST;
	BTG         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,275 :: 		cabeceraSolicitud[3] = 10;                                      //Actualiza el numero de datos para hacer el test
	MOVLW       10
	MOVWF       _cabeceraSolicitud+3 
;PruebaConfiguracion.c,276 :: 		ResponderSPI(cabeceraSolicitud, tramaPruebaSPI);
	MOVLW       _cabeceraSolicitud+0
	MOVWF       FARG_ResponderSPI_cabeceraRespuesta+0 
	MOVLW       hi_addr(_cabeceraSolicitud+0)
	MOVWF       FARG_ResponderSPI_cabeceraRespuesta+1 
	MOVLW       _tramaPruebaSPI+0
	MOVWF       FARG_ResponderSPI_payloadRespuesta+0 
	MOVLW       hi_addr(_tramaPruebaSPI+0)
	MOVWF       FARG_ResponderSPI_payloadRespuesta+1 
	CALL        _ResponderSPI+0, 0
;PruebaConfiguracion.c,277 :: 		} else {
	GOTO        L_interrupt51
L_interrupt50:
;PruebaConfiguracion.c,279 :: 		EnviarTramaRS485(1, cabeceraSolicitud, payloadSolicitud);
	MOVLW       1
	MOVWF       FARG_EnviarTramaRS485_puertoUART+0 
	MOVLW       _cabeceraSolicitud+0
	MOVWF       FARG_EnviarTramaRS485_cabecera+0 
	MOVLW       hi_addr(_cabeceraSolicitud+0)
	MOVWF       FARG_EnviarTramaRS485_cabecera+1 
	MOVLW       _payloadSolicitud+0
	MOVWF       FARG_EnviarTramaRS485_payload+0 
	MOVLW       hi_addr(_payloadSolicitud+0)
	MOVWF       FARG_EnviarTramaRS485_payload+1 
	CALL        _EnviarTramaRS485+0, 0
;PruebaConfiguracion.c,280 :: 		EnviarTramaRS485(2, cabeceraSolicitud, payloadSolicitud);
	MOVLW       2
	MOVWF       FARG_EnviarTramaRS485_puertoUART+0 
	MOVLW       _cabeceraSolicitud+0
	MOVWF       FARG_EnviarTramaRS485_cabecera+0 
	MOVLW       hi_addr(_cabeceraSolicitud+0)
	MOVWF       FARG_EnviarTramaRS485_cabecera+1 
	MOVLW       _payloadSolicitud+0
	MOVWF       FARG_EnviarTramaRS485_payload+0 
	MOVLW       hi_addr(_payloadSolicitud+0)
	MOVWF       FARG_EnviarTramaRS485_payload+1 
	CALL        _EnviarTramaRS485+0, 0
;PruebaConfiguracion.c,281 :: 		}
L_interrupt51:
;PruebaConfiguracion.c,282 :: 		}
L_interrupt49:
;PruebaConfiguracion.c,284 :: 		CambiarEstadoBandera(1,0);                                            //Limpia la bandera
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_bandera+0 
	CLRF        FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,286 :: 		}
L_interrupt41:
;PruebaConfiguracion.c,288 :: 		}
L_interrupt23:
;PruebaConfiguracion.c,293 :: 		if (RC1IF_bit==1){
	BTFSS       RC1IF_bit+0, BitPos(RC1IF_bit+0) 
	GOTO        L_interrupt52
;PruebaConfiguracion.c,295 :: 		RC1IF_bit = 0;                                                           //Limpia la bandera de interrupcion
	BCF         RC1IF_bit+0, BitPos(RC1IF_bit+0) 
;PruebaConfiguracion.c,296 :: 		byteRS485 = UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _byteRS485+0 
;PruebaConfiguracion.c,299 :: 		if (banRSI==2){
	MOVF        _banRSI+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt53
;PruebaConfiguracion.c,301 :: 		if (i_rs485<(numDatosRS485)){
	MOVLW       0
	SUBWF       _i_rs485+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt89
	MOVF        _numDatosRS485+0, 0 
	SUBWF       _i_rs485+0, 0 
L__interrupt89:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt54
;PruebaConfiguracion.c,302 :: 		inputPyloadRS485[i_rs485] = byteRS485;
	MOVLW       _inputPyloadRS485+0
	ADDWF       _i_rs485+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_inputPyloadRS485+0)
	ADDWFC      _i_rs485+1, 0 
	MOVWF       FSR1H 
	MOVF        _byteRS485+0, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,303 :: 		i_rs485++;
	INFSNZ      _i_rs485+0, 1 
	INCF        _i_rs485+1, 1 
;PruebaConfiguracion.c,304 :: 		} else {
	GOTO        L_interrupt55
L_interrupt54:
;PruebaConfiguracion.c,305 :: 		banRSI = 0;                                                        //Limpia la bandera de inicio de trama
	CLRF        _banRSI+0 
;PruebaConfiguracion.c,306 :: 		banRSC = 1;                                                        //Activa la bandera de trama completa
	MOVLW       1
	MOVWF       _banRSC+0 
;PruebaConfiguracion.c,307 :: 		}
L_interrupt55:
;PruebaConfiguracion.c,308 :: 		}
L_interrupt53:
;PruebaConfiguracion.c,311 :: 		if ((banRSI==0)&&(banRSC==0)){
	MOVF        _banRSI+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt58
	MOVF        _banRSC+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt58
L__interrupt72:
;PruebaConfiguracion.c,312 :: 		if (byteRS485==0x3A){                                                 //Verifica si el primer byte recibido sea el byte de inicio de trama
	MOVF        _byteRS485+0, 0 
	XORLW       58
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt59
;PruebaConfiguracion.c,313 :: 		banRSI = 1;
	MOVLW       1
	MOVWF       _banRSI+0 
;PruebaConfiguracion.c,314 :: 		i_rs485 = 0;
	CLRF        _i_rs485+0 
	CLRF        _i_rs485+1 
;PruebaConfiguracion.c,315 :: 		}
L_interrupt59:
;PruebaConfiguracion.c,316 :: 		}
L_interrupt58:
;PruebaConfiguracion.c,317 :: 		if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<4)){
	MOVF        _banRSI+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt62
	MOVF        _byteRS485+0, 0 
	XORLW       58
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt62
	MOVLW       0
	SUBWF       _i_rs485+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt90
	MOVLW       4
	SUBWF       _i_rs485+0, 0 
L__interrupt90:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt62
L__interrupt71:
;PruebaConfiguracion.c,318 :: 		tramaCabeceraRS485[i_rs485] = byteRS485;                              //Recupera los datos de cabecera de la trama UART: [Direccion, Funcion, Subfuncion, NumeroDatos]
	MOVLW       _tramaCabeceraRS485+0
	ADDWF       _i_rs485+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_tramaCabeceraRS485+0)
	ADDWFC      _i_rs485+1, 0 
	MOVWF       FSR1H 
	MOVF        _byteRS485+0, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,319 :: 		i_rs485++;
	INFSNZ      _i_rs485+0, 1 
	INCF        _i_rs485+1, 1 
;PruebaConfiguracion.c,320 :: 		}
L_interrupt62:
;PruebaConfiguracion.c,321 :: 		if ((banRSI==1)&&(i_rs485==4)){
	MOVF        _banRSI+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt65
	MOVLW       0
	XORWF       _i_rs485+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt91
	MOVLW       4
	XORWF       _i_rs485+0, 0 
L__interrupt91:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt65
L__interrupt70:
;PruebaConfiguracion.c,323 :: 		if (tramaCabeceraRS485[0]==idSolicitud){
	MOVF        _tramaCabeceraRS485+0, 0 
	XORWF       _idSolicitud+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt66
;PruebaConfiguracion.c,325 :: 		funcionRS485 = tramaCabeceraRS485[1];
	MOVF        _tramaCabeceraRS485+1, 0 
	MOVWF       _funcionRS485+0 
;PruebaConfiguracion.c,326 :: 		subFuncionRS485 = tramaCabeceraRS485[2];
	MOVF        _tramaCabeceraRS485+2, 0 
	MOVWF       _subFuncionRS485+0 
;PruebaConfiguracion.c,327 :: 		numDatosRS485 = tramaCabeceraRS485[3];
	MOVF        _tramaCabeceraRS485+3, 0 
	MOVWF       _numDatosRS485+0 
;PruebaConfiguracion.c,328 :: 		idSolicitud = 0;                                                   //Encera el idSolicitud
	CLRF        _idSolicitud+0 
;PruebaConfiguracion.c,329 :: 		i_rs485 = 0;                                                       //Encera el subindice para almacenar el payload
	CLRF        _i_rs485+0 
	CLRF        _i_rs485+1 
;PruebaConfiguracion.c,330 :: 		banRSI = 2;                                                        //Cambia el valor de la bandera para salir del bucle
	MOVLW       2
	MOVWF       _banRSI+0 
;PruebaConfiguracion.c,332 :: 		} else {
	GOTO        L_interrupt67
L_interrupt66:
;PruebaConfiguracion.c,333 :: 		banRSI = 0;
	CLRF        _banRSI+0 
;PruebaConfiguracion.c,334 :: 		banRSC = 0;
	CLRF        _banRSC+0 
;PruebaConfiguracion.c,335 :: 		i_rs485 = 0;
	CLRF        _i_rs485+0 
	CLRF        _i_rs485+1 
;PruebaConfiguracion.c,336 :: 		}
L_interrupt67:
;PruebaConfiguracion.c,337 :: 		}
L_interrupt65:
;PruebaConfiguracion.c,340 :: 		if (banRSC==1){
	MOVF        _banRSC+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt68
;PruebaConfiguracion.c,341 :: 		TEST = ~TEST;
	BTG         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,342 :: 		ResponderSPI(tramaCabeceraRS485, inputPyloadRS485);
	MOVLW       _tramaCabeceraRS485+0
	MOVWF       FARG_ResponderSPI_cabeceraRespuesta+0 
	MOVLW       hi_addr(_tramaCabeceraRS485+0)
	MOVWF       FARG_ResponderSPI_cabeceraRespuesta+1 
	MOVLW       _inputPyloadRS485+0
	MOVWF       FARG_ResponderSPI_payloadRespuesta+0 
	MOVLW       hi_addr(_inputPyloadRS485+0)
	MOVWF       FARG_ResponderSPI_payloadRespuesta+1 
	CALL        _ResponderSPI+0, 0
;PruebaConfiguracion.c,344 :: 		banRSC = 0;
	CLRF        _banRSC+0 
;PruebaConfiguracion.c,345 :: 		}
L_interrupt68:
;PruebaConfiguracion.c,347 :: 		}
L_interrupt52:
;PruebaConfiguracion.c,352 :: 		if (RC2IF_bit==1){
	BTFSS       RC2IF_bit+0, BitPos(RC2IF_bit+0) 
	GOTO        L_interrupt69
;PruebaConfiguracion.c,354 :: 		RC2IF_bit = 0;                                                           //Limpia la bandera de interrupcion
	BCF         RC2IF_bit+0, BitPos(RC2IF_bit+0) 
;PruebaConfiguracion.c,407 :: 		}
L_interrupt69:
;PruebaConfiguracion.c,410 :: 		}
L_end_interrupt:
L__interrupt86:
	RETFIE      1
; end of _interrupt
