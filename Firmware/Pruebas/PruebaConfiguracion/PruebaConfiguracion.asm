
_EnviarTramaRS485:

;rs485.c,20 :: 		void EnviarTramaRS485(unsigned char puertoUART, unsigned char *cabecera, unsigned char *payload){
;rs485.c,32 :: 		ptrnumDatos = (unsigned char *) & numDatos;
	MOVLW       EnviarTramaRS485_numDatos_L0+0
	MOVWF       EnviarTramaRS485_ptrnumDatos_L0+0 
	MOVLW       hi_addr(EnviarTramaRS485_numDatos_L0+0)
	MOVWF       EnviarTramaRS485_ptrnumDatos_L0+1 
;rs485.c,35 :: 		direccion = cabecera[0];
	MOVFF       FARG_EnviarTramaRS485_cabecera+0, FSR0
	MOVFF       FARG_EnviarTramaRS485_cabecera+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       EnviarTramaRS485_direccion_L0+0 
;rs485.c,36 :: 		funcion = cabecera[1];
	MOVLW       1
	ADDWF       FARG_EnviarTramaRS485_cabecera+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_EnviarTramaRS485_cabecera+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       EnviarTramaRS485_funcion_L0+0 
;rs485.c,37 :: 		subfuncion = cabecera[2];
	MOVLW       2
	ADDWF       FARG_EnviarTramaRS485_cabecera+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_EnviarTramaRS485_cabecera+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       EnviarTramaRS485_subfuncion_L0+0 
;rs485.c,38 :: 		lsbNumDatos = cabecera[3];
	MOVLW       3
	ADDWF       FARG_EnviarTramaRS485_cabecera+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_EnviarTramaRS485_cabecera+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       EnviarTramaRS485_lsbNumDatos_L0+0 
;rs485.c,39 :: 		msbNumDatos = cabecera[4];
	MOVLW       4
	ADDWF       FARG_EnviarTramaRS485_cabecera+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_EnviarTramaRS485_cabecera+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       EnviarTramaRS485_msbNumDatos_L0+0 
;rs485.c,42 :: 		*(ptrnumDatos) = lsbNumDatos;
	MOVFF       EnviarTramaRS485_ptrnumDatos_L0+0, FSR1
	MOVFF       EnviarTramaRS485_ptrnumDatos_L0+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;rs485.c,43 :: 		*(ptrnumDatos+1) = msbNumDatos;
	MOVLW       1
	ADDWF       EnviarTramaRS485_ptrnumDatos_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      EnviarTramaRS485_ptrnumDatos_L0+1, 0 
	MOVWF       FSR1H 
	MOVF        EnviarTramaRS485_msbNumDatos_L0+0, 0 
	MOVWF       POSTINC1+0 
;rs485.c,45 :: 		if (puertoUART == 1){
	MOVF        FARG_EnviarTramaRS485_puertoUART+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_EnviarTramaRS4850
;rs485.c,46 :: 		MS1RS485 = 1;                                                            //Establece el Max485 en modo escritura
	BSF         MS1RS485+0, BitPos(MS1RS485+0) 
;rs485.c,47 :: 		UART1_Write(0x3A);                                                      //Envia la cabecera de la trama
	MOVLW       58
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,48 :: 		UART1_Write(direccion);                                                 //Envia la direccion del destinatario
	MOVF        EnviarTramaRS485_direccion_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,49 :: 		UART1_Write(funcion);                                                   //Envia el codigo de la funcion
	MOVF        EnviarTramaRS485_funcion_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,50 :: 		UART1_Write(subfuncion);                                                //Envia el codigo de la subfuncion
	MOVF        EnviarTramaRS485_subfuncion_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,51 :: 		UART1_Write(lsbNumDatos);                                               //Envia el LSB del numero de datos
	MOVF        EnviarTramaRS485_lsbNumDatos_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,52 :: 		UART1_Write(msbNumDatos);                                               //Envia el MSB del numero de datos
	MOVF        EnviarTramaRS485_msbNumDatos_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,53 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	CLRF        EnviarTramaRS485_iDatos_L0+0 
	CLRF        EnviarTramaRS485_iDatos_L0+1 
L_EnviarTramaRS4851:
	MOVF        EnviarTramaRS485_numDatos_L0+1, 0 
	SUBWF       EnviarTramaRS485_iDatos_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__EnviarTramaRS485121
	MOVF        EnviarTramaRS485_numDatos_L0+0, 0 
	SUBWF       EnviarTramaRS485_iDatos_L0+0, 0 
L__EnviarTramaRS485121:
	BTFSC       STATUS+0, 0 
	GOTO        L_EnviarTramaRS4852
;rs485.c,54 :: 		UART1_Write(payload[iDatos]);
	MOVF        EnviarTramaRS485_iDatos_L0+0, 0 
	ADDWF       FARG_EnviarTramaRS485_payload+0, 0 
	MOVWF       FSR0 
	MOVF        EnviarTramaRS485_iDatos_L0+1, 0 
	ADDWFC      FARG_EnviarTramaRS485_payload+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,53 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INFSNZ      EnviarTramaRS485_iDatos_L0+0, 1 
	INCF        EnviarTramaRS485_iDatos_L0+1, 1 
;rs485.c,55 :: 		}
	GOTO        L_EnviarTramaRS4851
L_EnviarTramaRS4852:
;rs485.c,56 :: 		UART1_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,57 :: 		UART1_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,58 :: 		UART1_Write(0x00);                                                      //Envia un byte adicional
	CLRF        FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs485.c,59 :: 		while(UART1_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarTramaRS4854:
	CALL        _UART1_Tx_Idle+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_EnviarTramaRS4855
	GOTO        L_EnviarTramaRS4854
L_EnviarTramaRS4855:
;rs485.c,60 :: 		MS1RS485 = 0;                                                           //Establece el Max485 en modo lectura
	BCF         MS1RS485+0, BitPos(MS1RS485+0) 
;rs485.c,61 :: 		}
L_EnviarTramaRS4850:
;rs485.c,63 :: 		if (puertoUART == 2){
	MOVF        FARG_EnviarTramaRS485_puertoUART+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_EnviarTramaRS4856
;rs485.c,64 :: 		MS2RS485 = 1;                                                            //Establece el Max485 en modo escritura
	BSF         MS2RS485+0, BitPos(MS2RS485+0) 
;rs485.c,65 :: 		UART2_Write(0x3A);                                                      //Envia la cabecera de la trama
	MOVLW       58
	MOVWF       FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;rs485.c,66 :: 		UART2_Write(direccion);                                                 //Envia la direccion del destinatario
	MOVF        EnviarTramaRS485_direccion_L0+0, 0 
	MOVWF       FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;rs485.c,67 :: 		UART2_Write(funcion);                                                   //Envia el codigo de la funcion
	MOVF        EnviarTramaRS485_funcion_L0+0, 0 
	MOVWF       FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;rs485.c,68 :: 		UART2_Write(subfuncion);                                                //Envia el codigo de la subfuncion
	MOVF        EnviarTramaRS485_subfuncion_L0+0, 0 
	MOVWF       FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;rs485.c,69 :: 		UART2_Write(lsbNumDatos);                                               //Envia el LSB del numero de datos
	MOVF        EnviarTramaRS485_lsbNumDatos_L0+0, 0 
	MOVWF       FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;rs485.c,70 :: 		UART2_Write(msbNumDatos);                                               //Envia el MSB del numero de datos
	MOVF        EnviarTramaRS485_msbNumDatos_L0+0, 0 
	MOVWF       FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;rs485.c,71 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	CLRF        EnviarTramaRS485_iDatos_L0+0 
	CLRF        EnviarTramaRS485_iDatos_L0+1 
L_EnviarTramaRS4857:
	MOVF        EnviarTramaRS485_numDatos_L0+1, 0 
	SUBWF       EnviarTramaRS485_iDatos_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__EnviarTramaRS485122
	MOVF        EnviarTramaRS485_numDatos_L0+0, 0 
	SUBWF       EnviarTramaRS485_iDatos_L0+0, 0 
L__EnviarTramaRS485122:
	BTFSC       STATUS+0, 0 
	GOTO        L_EnviarTramaRS4858
;rs485.c,72 :: 		UART2_Write(payload[iDatos]);
	MOVF        EnviarTramaRS485_iDatos_L0+0, 0 
	ADDWF       FARG_EnviarTramaRS485_payload+0, 0 
	MOVWF       FSR0 
	MOVF        EnviarTramaRS485_iDatos_L0+1, 0 
	ADDWFC      FARG_EnviarTramaRS485_payload+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;rs485.c,71 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INFSNZ      EnviarTramaRS485_iDatos_L0+0, 1 
	INCF        EnviarTramaRS485_iDatos_L0+1, 1 
;rs485.c,73 :: 		}
	GOTO        L_EnviarTramaRS4857
L_EnviarTramaRS4858:
;rs485.c,74 :: 		UART2_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	MOVLW       13
	MOVWF       FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;rs485.c,75 :: 		UART2_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOVLW       10
	MOVWF       FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;rs485.c,76 :: 		UART2_Write(0x00);                                                      //Envia un byte adicional
	CLRF        FARG_UART2_Write_data_+0 
	CALL        _UART2_Write+0, 0
;rs485.c,77 :: 		while(UART2_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarTramaRS48510:
	CALL        _UART2_Tx_Idle+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_EnviarTramaRS48511
	GOTO        L_EnviarTramaRS48510
L_EnviarTramaRS48511:
;rs485.c,78 :: 		MS2RS485 = 0;                                                            //Establece el Max485 en modo lectura
	BCF         MS2RS485+0, BitPos(MS2RS485+0) 
;rs485.c,79 :: 		}
L_EnviarTramaRS4856:
;rs485.c,81 :: 		}
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
;PruebaConfiguracion.c,77 :: 		banSPI2 = 0;
	CLRF        _banSPI2+0 
;PruebaConfiguracion.c,78 :: 		banSPI3 = 0;
	CLRF        _banSPI3+0 
;PruebaConfiguracion.c,79 :: 		bufferSPI = 0;
	CLRF        _bufferSPI+0 
;PruebaConfiguracion.c,80 :: 		idSolicitud = 0;
	CLRF        _idSolicitud+0 
;PruebaConfiguracion.c,81 :: 		funcionSolicitud = 0;
	CLRF        _funcionSolicitud+0 
;PruebaConfiguracion.c,82 :: 		subFuncionSolicitud = 0;
	CLRF        _subFuncionSolicitud+0 
;PruebaConfiguracion.c,84 :: 		banRSI = 0;
	CLRF        _banRSI+0 
;PruebaConfiguracion.c,85 :: 		banRSI2 = 0;
	CLRF        _banRSI2+0 
;PruebaConfiguracion.c,86 :: 		banRSC = 0;
	CLRF        _banRSC+0 
;PruebaConfiguracion.c,87 :: 		banRSC2 = 0;
	CLRF        _banRSC2+0 
;PruebaConfiguracion.c,88 :: 		byteRS485 = 0;
	CLRF        _byteRS485+0 
;PruebaConfiguracion.c,89 :: 		byteRS4852 = 0;
	CLRF        _byteRS4852+0 
;PruebaConfiguracion.c,90 :: 		i_rs485 = 0;
	CLRF        _i_rs485+0 
	CLRF        _i_rs485+1 
;PruebaConfiguracion.c,91 :: 		i_rs4852 = 0;
	CLRF        _i_rs4852+0 
	CLRF        _i_rs4852+1 
;PruebaConfiguracion.c,92 :: 		funcionRS485 = 0;
	CLRF        _funcionRS485+0 
;PruebaConfiguracion.c,93 :: 		subFuncionRS485 = 0;
	CLRF        _subFuncionRS485+0 
;PruebaConfiguracion.c,94 :: 		numDatosRS485 = 0;
	CLRF        _numDatosRS485+0 
	CLRF        _numDatosRS485+1 
;PruebaConfiguracion.c,95 :: 		ptrNumDatosRS485 = (unsigned char *) & numDatosRS485;
	MOVLW       _numDatosRS485+0
	MOVWF       _ptrNumDatosRS485+0 
	MOVLW       hi_addr(_numDatosRS485+0)
	MOVWF       _ptrNumDatosRS485+1 
;PruebaConfiguracion.c,96 :: 		MS1RS485 = 0;
	BCF         LATB3_bit+0, BitPos(LATB3_bit+0) 
;PruebaConfiguracion.c,97 :: 		MS2RS485 = 0;
	BCF         LATB5_bit+0, BitPos(LATB5_bit+0) 
;PruebaConfiguracion.c,98 :: 		sumValidacion = 0;
	CLRF        _sumValidacion+0 
;PruebaConfiguracion.c,100 :: 		RP0 = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;PruebaConfiguracion.c,101 :: 		LED1 = 0;
	BCF         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,102 :: 		LED2 = 0;
	BCF         RB4_bit+0, BitPos(RB4_bit+0) 
;PruebaConfiguracion.c,103 :: 		MS1RS485 = 0;
	BCF         LATB3_bit+0, BitPos(LATB3_bit+0) 
;PruebaConfiguracion.c,104 :: 		MS2RS485 = 0;
	BCF         LATB5_bit+0, BitPos(LATB5_bit+0) 
;PruebaConfiguracion.c,106 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_ConfiguracionPrincipal:

;PruebaConfiguracion.c,113 :: 		void ConfiguracionPrincipal(){
;PruebaConfiguracion.c,116 :: 		OSCCON.IDLEN=1;                                    //Entra en modo IDLE durante la instruccion SLEEP
	BSF         OSCCON+0, 7 
;PruebaConfiguracion.c,117 :: 		OSCCON.IRCF2=1;                                    //HFINTOSC=16MHz  IRFC=111
	BSF         OSCCON+0, 6 
;PruebaConfiguracion.c,118 :: 		OSCCON.IRCF1=1;
	BSF         OSCCON+0, 5 
;PruebaConfiguracion.c,119 :: 		OSCCON.IRCF0=1;
	BSF         OSCCON+0, 4 
;PruebaConfiguracion.c,120 :: 		OSCCON.SCS1=1;                                     //System Clock Select bit:  1x=Internal oscillator block
	BSF         OSCCON+0, 1 
;PruebaConfiguracion.c,121 :: 		OSCCON.SCS0=1;
	BSF         OSCCON+0, 0 
;PruebaConfiguracion.c,124 :: 		ANSELA = 0;                                        //Configura PORTA como digital
	CLRF        ANSELA+0 
;PruebaConfiguracion.c,125 :: 		ANSELB = 0;                                        //Configura PORTB como digital
	CLRF        ANSELB+0 
;PruebaConfiguracion.c,126 :: 		ANSELC = 0;                                        //Configura PORTC como digital
	CLRF        ANSELC+0 
;PruebaConfiguracion.c,128 :: 		LED1_Direction = 0;                                //Configura el pin LED1 como salida
	BCF         TRISB2_bit+0, BitPos(TRISB2_bit+0) 
;PruebaConfiguracion.c,129 :: 		LED2_Direction = 0;                                //Configura el pin LED1 como salida
	BCF         TRISB4_bit+0, BitPos(TRISB4_bit+0) 
;PruebaConfiguracion.c,130 :: 		RP0_Direction = 0;                                 //Configura el pin RP0 como salida
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;PruebaConfiguracion.c,131 :: 		MS1RS485_Direction = 0;                            //Configura el pin MS1RS485 como salida
	BCF         TRISB3_bit+0, BitPos(TRISB3_bit+0) 
;PruebaConfiguracion.c,132 :: 		MS2RS485_Direction = 0;                            //Configura el pin MS2RS485 como salida
	BCF         TRISB5_bit+0, BitPos(TRISB5_bit+0) 
;PruebaConfiguracion.c,133 :: 		TRISA5_bit = 1;                                    //SS1 In
	BSF         TRISA5_bit+0, BitPos(TRISA5_bit+0) 
;PruebaConfiguracion.c,134 :: 		TRISC3_bit = 1;                                    //SCK1 In
	BSF         TRISC3_bit+0, BitPos(TRISC3_bit+0) 
;PruebaConfiguracion.c,135 :: 		TRISC4_bit = 1;                                    //SDI1 In
	BSF         TRISC4_bit+0, BitPos(TRISC4_bit+0) 
;PruebaConfiguracion.c,136 :: 		TRISC5_bit = 0;                                    //SDO1 Out
	BCF         TRISC5_bit+0, BitPos(TRISC5_bit+0) 
;PruebaConfiguracion.c,138 :: 		INTCON.GIE = 1;                                    //Habilita las interrupciones globales
	BSF         INTCON+0, 7 
;PruebaConfiguracion.c,139 :: 		INTCON.PEIE = 1;                                   //Habilita las interrupciones perifericas
	BSF         INTCON+0, 6 
;PruebaConfiguracion.c,142 :: 		PIE1.SSP1IE = 1;                                   //Activa la interrupcion por SPI
	BSF         PIE1+0, 3 
;PruebaConfiguracion.c,143 :: 		PIR1.SSP1IF = 0;                                   //Limpia la bandera de interrupcion por SPI *
	BCF         PIR1+0, 3 
;PruebaConfiguracion.c,144 :: 		SPI1_Init_Advanced(_SPI_SLAVE_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_HIGH_2_LOW);
	MOVLW       4
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	MOVLW       128
	MOVWF       FARG_SPI1_Init_Advanced_data_sample+0 
	MOVLW       16
	MOVWF       FARG_SPI1_Init_Advanced_clock_idle+0 
	CLRF        FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;PruebaConfiguracion.c,147 :: 		PIE1.RC1IE = 1;                                   //Habilita la interrupcion en UART1 receive
	BSF         PIE1+0, 5 
;PruebaConfiguracion.c,148 :: 		PIR1.RC1IF = 0;                                   //Limpia la bandera de interrupcion UART1
	BCF         PIR1+0, 5 
;PruebaConfiguracion.c,149 :: 		PIE3.RC2IE = 1;                                   //Habilita la interrupcion en UART2 receive
	BSF         PIE3+0, 5 
;PruebaConfiguracion.c,150 :: 		PIR3.RC2IF = 0;                                   //Limpia la bandera de interrupcion
	BCF         PIR3+0, 5 
;PruebaConfiguracion.c,151 :: 		UART1_Init(19200);                                //Inicializa el UART1 a 19200 bps
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       207
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;PruebaConfiguracion.c,152 :: 		UART2_Init(19200);                                //Inicializa el UART2 a 19200 bps
	BSF         BAUDCON2+0, 3, 0
	CLRF        SPBRGH2+0 
	MOVLW       207
	MOVWF       SPBRG2+0 
	BSF         TXSTA2+0, 2, 0
	CALL        _UART2_Init+0, 0
;PruebaConfiguracion.c,161 :: 		Delay_ms(100);                                     //Espera hasta que se estabilicen los cambios
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
;PruebaConfiguracion.c,162 :: 		}
L_end_ConfiguracionPrincipal:
	RETURN      0
; end of _ConfiguracionPrincipal

_CambiarEstadoBandera:

;PruebaConfiguracion.c,165 :: 		void CambiarEstadoBandera(unsigned char bandera, unsigned char estado){
;PruebaConfiguracion.c,167 :: 		if (estado==1){
	MOVF        FARG_CambiarEstadoBandera_estado+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera13
;PruebaConfiguracion.c,169 :: 		banSPI0 = 3;
	MOVLW       3
	MOVWF       _banSPI0+0 
;PruebaConfiguracion.c,170 :: 		banSPI1 = 3;
	MOVLW       3
	MOVWF       _banSPI1+0 
;PruebaConfiguracion.c,172 :: 		switch (bandera){
	GOTO        L_CambiarEstadoBandera14
;PruebaConfiguracion.c,173 :: 		case 0:
L_CambiarEstadoBandera16:
;PruebaConfiguracion.c,174 :: 		banSPI0 = 1;
	MOVLW       1
	MOVWF       _banSPI0+0 
;PruebaConfiguracion.c,175 :: 		break;
	GOTO        L_CambiarEstadoBandera15
;PruebaConfiguracion.c,176 :: 		case 1:
L_CambiarEstadoBandera17:
;PruebaConfiguracion.c,177 :: 		banSPI1 = 1;
	MOVLW       1
	MOVWF       _banSPI1+0 
;PruebaConfiguracion.c,178 :: 		break;
	GOTO        L_CambiarEstadoBandera15
;PruebaConfiguracion.c,179 :: 		case 2:
L_CambiarEstadoBandera18:
;PruebaConfiguracion.c,180 :: 		banSPI2 = 1;
	MOVLW       1
	MOVWF       _banSPI2+0 
;PruebaConfiguracion.c,181 :: 		break;
	GOTO        L_CambiarEstadoBandera15
;PruebaConfiguracion.c,182 :: 		case 3:
L_CambiarEstadoBandera19:
;PruebaConfiguracion.c,183 :: 		banSPI3 = 1;
	MOVLW       1
	MOVWF       _banSPI3+0 
;PruebaConfiguracion.c,184 :: 		break;
	GOTO        L_CambiarEstadoBandera15
;PruebaConfiguracion.c,185 :: 		}
L_CambiarEstadoBandera14:
	MOVF        FARG_CambiarEstadoBandera_bandera+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera16
	MOVF        FARG_CambiarEstadoBandera_bandera+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera17
	MOVF        FARG_CambiarEstadoBandera_bandera+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera18
	MOVF        FARG_CambiarEstadoBandera_bandera+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera19
L_CambiarEstadoBandera15:
;PruebaConfiguracion.c,186 :: 		}
L_CambiarEstadoBandera13:
;PruebaConfiguracion.c,188 :: 		if (estado==0){
	MOVF        FARG_CambiarEstadoBandera_estado+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_CambiarEstadoBandera20
;PruebaConfiguracion.c,189 :: 		banSPI0 = 0;
	CLRF        _banSPI0+0 
;PruebaConfiguracion.c,190 :: 		banSPI1 = 0;
	CLRF        _banSPI1+0 
;PruebaConfiguracion.c,191 :: 		banSPI2 = 0;
	CLRF        _banSPI2+0 
;PruebaConfiguracion.c,192 :: 		banSPI3 = 0;
	CLRF        _banSPI3+0 
;PruebaConfiguracion.c,193 :: 		}
L_CambiarEstadoBandera20:
;PruebaConfiguracion.c,194 :: 		}
L_end_CambiarEstadoBandera:
	RETURN      0
; end of _CambiarEstadoBandera

_ResponderSPI:

;PruebaConfiguracion.c,197 :: 		void ResponderSPI(unsigned char *cabeceraRespuesta){
;PruebaConfiguracion.c,200 :: 		cabeceraRespuestaSPI[0] = cabeceraRespuesta[0];
	MOVFF       FARG_ResponderSPI_cabeceraRespuesta+0, FSR0
	MOVFF       FARG_ResponderSPI_cabeceraRespuesta+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       _cabeceraRespuestaSPI+0 
;PruebaConfiguracion.c,201 :: 		cabeceraRespuestaSPI[1] = cabeceraRespuesta[1];
	MOVLW       1
	ADDWF       FARG_ResponderSPI_cabeceraRespuesta+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_ResponderSPI_cabeceraRespuesta+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       _cabeceraRespuestaSPI+1 
;PruebaConfiguracion.c,202 :: 		cabeceraRespuestaSPI[2] = cabeceraRespuesta[2];
	MOVLW       2
	ADDWF       FARG_ResponderSPI_cabeceraRespuesta+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_ResponderSPI_cabeceraRespuesta+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       _cabeceraRespuestaSPI+2 
;PruebaConfiguracion.c,203 :: 		cabeceraRespuestaSPI[3] = cabeceraRespuesta[3];
	MOVLW       3
	ADDWF       FARG_ResponderSPI_cabeceraRespuesta+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_ResponderSPI_cabeceraRespuesta+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       _cabeceraRespuestaSPI+3 
;PruebaConfiguracion.c,204 :: 		cabeceraRespuestaSPI[4] = cabeceraRespuesta[4];
	MOVLW       4
	ADDWF       FARG_ResponderSPI_cabeceraRespuesta+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_ResponderSPI_cabeceraRespuesta+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       _cabeceraRespuestaSPI+4 
;PruebaConfiguracion.c,207 :: 		RP0 = 1;
	BSF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;PruebaConfiguracion.c,208 :: 		Delay_us(100);
	MOVLW       133
	MOVWF       R13, 0
L_ResponderSPI21:
	DECFSZ      R13, 1, 1
	BRA         L_ResponderSPI21
;PruebaConfiguracion.c,209 :: 		RP0 = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;PruebaConfiguracion.c,211 :: 		}
L_end_ResponderSPI:
	RETURN      0
; end of _ResponderSPI

_interrupt:

;PruebaConfiguracion.c,217 :: 		void interrupt(void){
;PruebaConfiguracion.c,233 :: 		if (SSP1IF_bit==1){
	BTFSS       SSP1IF_bit+0, BitPos(SSP1IF_bit+0) 
	GOTO        L_interrupt22
;PruebaConfiguracion.c,235 :: 		SSP1IF_bit = 0;                                                          //Limpia la bandera de interrupcion por SPI
	BCF         SSP1IF_bit+0, BitPos(SSP1IF_bit+0) 
;PruebaConfiguracion.c,236 :: 		bufferSPI = SSP1BUF;                                                     //Guarda el contenido del bufeer (lectura)
	MOVF        SSP1BUF+0, 0 
	MOVWF       _bufferSPI+0 
;PruebaConfiguracion.c,241 :: 		if ((banSPI0==0)&&(bufferSPI==0xA0)){
	MOVF        _banSPI0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt25
	MOVF        _bufferSPI+0, 0 
	XORLW       160
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt25
L__interrupt119:
;PruebaConfiguracion.c,242 :: 		i = 0;                                                                //Limpia el subindice para guardar la trama SPI
	CLRF        _i+0 
	CLRF        _i+1 
;PruebaConfiguracion.c,243 :: 		CambiarEstadoBandera(0,1);                                            //Activa la bandera 0
	CLRF        FARG_CambiarEstadoBandera_bandera+0 
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,244 :: 		LED1 = 1;
	BSF         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,245 :: 		LED2 = 1;
	BSF         RB4_bit+0, BitPos(RB4_bit+0) 
;PruebaConfiguracion.c,246 :: 		}
L_interrupt25:
;PruebaConfiguracion.c,247 :: 		if ((banSPI0==1)&&(bufferSPI!=0xA0)&&(bufferSPI!=0xF0)){
	MOVF        _banSPI0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt28
	MOVF        _bufferSPI+0, 0 
	XORLW       160
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt28
	MOVF        _bufferSPI+0, 0 
	XORLW       240
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt28
L__interrupt118:
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
L_interrupt28:
;PruebaConfiguracion.c,251 :: 		if ((banSPI0==1)&&(bufferSPI==0xF0)){
	MOVF        _banSPI0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt31
	MOVF        _bufferSPI+0, 0 
	XORLW       240
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt31
L__interrupt117:
;PruebaConfiguracion.c,253 :: 		for (j=0;j<5;j++){
	CLRF        _j+0 
	CLRF        _j+1 
L_interrupt32:
	MOVLW       0
	SUBWF       _j+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt129
	MOVLW       5
	SUBWF       _j+0, 0 
L__interrupt129:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt33
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
;PruebaConfiguracion.c,253 :: 		for (j=0;j<5;j++){
	INFSNZ      _j+0, 1 
	INCF        _j+1, 1 
;PruebaConfiguracion.c,255 :: 		}
	GOTO        L_interrupt32
L_interrupt33:
;PruebaConfiguracion.c,257 :: 		idSolicitud = cabeceraSolicitud[0];
	MOVF        _cabeceraSolicitud+0, 0 
	MOVWF       _idSolicitud+0 
;PruebaConfiguracion.c,258 :: 		funcionSolicitud = cabeceraSolicitud[1];
	MOVF        _cabeceraSolicitud+1, 0 
	MOVWF       _funcionSolicitud+0 
;PruebaConfiguracion.c,259 :: 		subFuncionSolicitud = cabeceraSolicitud[2];
	MOVF        _cabeceraSolicitud+2, 0 
	MOVWF       _subFuncionSolicitud+0 
;PruebaConfiguracion.c,260 :: 		*(ptrNumDatosRS485) = cabeceraSolicitud[3];
	MOVFF       _ptrNumDatosRS485+0, FSR1
	MOVFF       _ptrNumDatosRS485+1, FSR1H
	MOVF        _cabeceraSolicitud+3, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,261 :: 		*(ptrNumDatosRS485+1) = cabeceraSolicitud[4];
	MOVLW       1
	ADDWF       _ptrNumDatosRS485+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      _ptrNumDatosRS485+1, 0 
	MOVWF       FSR1H 
	MOVF        _cabeceraSolicitud+4, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,263 :: 		for (j=0;j<numDatosRS485;j++){
	CLRF        _j+0 
	CLRF        _j+1 
L_interrupt35:
	MOVF        _numDatosRS485+1, 0 
	SUBWF       _j+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt130
	MOVF        _numDatosRS485+0, 0 
	SUBWF       _j+0, 0 
L__interrupt130:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt36
;PruebaConfiguracion.c,264 :: 		payloadSolicitud[j] = tramaSolicitudSPI[5+j];
	MOVLW       _payloadSolicitud+0
	ADDWF       _j+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_payloadSolicitud+0)
	ADDWFC      _j+1, 0 
	MOVWF       FSR1H 
	MOVLW       5
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
;PruebaConfiguracion.c,263 :: 		for (j=0;j<numDatosRS485;j++){
	INFSNZ      _j+0, 1 
	INCF        _j+1, 1 
;PruebaConfiguracion.c,265 :: 		}
	GOTO        L_interrupt35
L_interrupt36:
;PruebaConfiguracion.c,267 :: 		if (idSolicitud==0){
	MOVF        _idSolicitud+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt38
;PruebaConfiguracion.c,268 :: 		if (funcionSolicitud==4){
	MOVF        _funcionSolicitud+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt39
;PruebaConfiguracion.c,269 :: 		numDatosRS485 = 10;                                         //Actualiza el numero de datos para hacer el test
	MOVLW       10
	MOVWF       _numDatosRS485+0 
	MOVLW       0
	MOVWF       _numDatosRS485+1 
;PruebaConfiguracion.c,270 :: 		cabeceraSolicitud[3] = *(ptrNumDatosRS485);
	MOVFF       _ptrNumDatosRS485+0, FSR0
	MOVFF       _ptrNumDatosRS485+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       _cabeceraSolicitud+3 
;PruebaConfiguracion.c,271 :: 		cabeceraSolicitud[4] = *(ptrNumDatosRS485+1);
	MOVLW       1
	ADDWF       _ptrNumDatosRS485+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      _ptrNumDatosRS485+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       _cabeceraSolicitud+4 
;PruebaConfiguracion.c,272 :: 		ResponderSPI(cabeceraSolicitud);
	MOVLW       _cabeceraSolicitud+0
	MOVWF       FARG_ResponderSPI_cabeceraRespuesta+0 
	MOVLW       hi_addr(_cabeceraSolicitud+0)
	MOVWF       FARG_ResponderSPI_cabeceraRespuesta+1 
	CALL        _ResponderSPI+0, 0
;PruebaConfiguracion.c,273 :: 		}
L_interrupt39:
;PruebaConfiguracion.c,274 :: 		} else {
	GOTO        L_interrupt40
L_interrupt38:
;PruebaConfiguracion.c,276 :: 		EnviarTramaRS485(1, cabeceraSolicitud, payloadSolicitud);
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
;PruebaConfiguracion.c,277 :: 		EnviarTramaRS485(2, cabeceraSolicitud, payloadSolicitud);
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
;PruebaConfiguracion.c,279 :: 		}
L_interrupt40:
;PruebaConfiguracion.c,280 :: 		CambiarEstadoBandera(0,0);                                            //Limpia la bandera 0
	CLRF        FARG_CambiarEstadoBandera_bandera+0 
	CLRF        FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,281 :: 		LED1 = 0;
	BCF         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,282 :: 		LED2 = 0;
	BCF         RB4_bit+0, BitPos(RB4_bit+0) 
;PruebaConfiguracion.c,284 :: 		}
L_interrupt31:
;PruebaConfiguracion.c,290 :: 		if ((banSPI1==0)&&(bufferSPI==0xA1)) {
	MOVF        _banSPI1+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt43
	MOVF        _bufferSPI+0, 0 
	XORLW       161
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt43
L__interrupt116:
;PruebaConfiguracion.c,291 :: 		SSP1BUF = cabeceraRespuestaSPI[0];                                       //Carga en el buffer el primer elemento de la cabecera (id)
	MOVF        _cabeceraRespuestaSPI+0, 0 
	MOVWF       SSP1BUF+0 
;PruebaConfiguracion.c,292 :: 		i = 1;
	MOVLW       1
	MOVWF       _i+0 
	MOVLW       0
	MOVWF       _i+1 
;PruebaConfiguracion.c,293 :: 		CambiarEstadoBandera(1,1);                                            //Activa la bandera 1
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_bandera+0 
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,294 :: 		}
L_interrupt43:
;PruebaConfiguracion.c,295 :: 		if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
	MOVF        _banSPI1+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt46
	MOVF        _bufferSPI+0, 0 
	XORLW       161
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt46
	MOVF        _bufferSPI+0, 0 
	XORLW       241
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt46
L__interrupt115:
;PruebaConfiguracion.c,296 :: 		SSP1BUF = cabeceraRespuestaSPI[i];                                       //Se envia la trama de respuesta
	MOVLW       _cabeceraRespuestaSPI+0
	ADDWF       _i+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_cabeceraRespuestaSPI+0)
	ADDWFC      _i+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       SSP1BUF+0 
;PruebaConfiguracion.c,297 :: 		i++;
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;PruebaConfiguracion.c,298 :: 		}
L_interrupt46:
;PruebaConfiguracion.c,299 :: 		if ((banSPI1==1)&&(bufferSPI==0xF1)){
	MOVF        _banSPI1+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt49
	MOVF        _bufferSPI+0, 0 
	XORLW       241
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt49
L__interrupt114:
;PruebaConfiguracion.c,300 :: 		CambiarEstadoBandera(1,0);                                            //Limpia la bandera 1
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_bandera+0 
	CLRF        FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,301 :: 		}
L_interrupt49:
;PruebaConfiguracion.c,303 :: 		if ((banSPI2==0)&&(bufferSPI==0xA2)){
	MOVF        _banSPI2+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt52
	MOVF        _bufferSPI+0, 0 
	XORLW       162
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt52
L__interrupt113:
;PruebaConfiguracion.c,304 :: 		CambiarEstadoBandera(2,1);                                            //Activa la bandera 2
	MOVLW       2
	MOVWF       FARG_CambiarEstadoBandera_bandera+0 
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,305 :: 		SSP1BUF = pyloadRS485[0];
	MOVF        _pyloadRS485+0, 0 
	MOVWF       SSP1BUF+0 
;PruebaConfiguracion.c,306 :: 		i = 1;
	MOVLW       1
	MOVWF       _i+0 
	MOVLW       0
	MOVWF       _i+1 
;PruebaConfiguracion.c,307 :: 		}
L_interrupt52:
;PruebaConfiguracion.c,308 :: 		if ((banSPI2==1)&&(bufferSPI!=0xA2)&&(bufferSPI!=0xF2)){
	MOVF        _banSPI2+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt55
	MOVF        _bufferSPI+0, 0 
	XORLW       162
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt55
	MOVF        _bufferSPI+0, 0 
	XORLW       242
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt55
L__interrupt112:
;PruebaConfiguracion.c,309 :: 		SSP1BUF = pyloadRS485[i];
	MOVLW       _pyloadRS485+0
	ADDWF       _i+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_pyloadRS485+0)
	ADDWFC      _i+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       SSP1BUF+0 
;PruebaConfiguracion.c,310 :: 		i++;
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;PruebaConfiguracion.c,311 :: 		}
L_interrupt55:
;PruebaConfiguracion.c,312 :: 		if ((banSPI2==1)&&(bufferSPI==0xF2)){
	MOVF        _banSPI2+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt58
	MOVF        _bufferSPI+0, 0 
	XORLW       242
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt58
L__interrupt111:
;PruebaConfiguracion.c,313 :: 		CambiarEstadoBandera(2,0);                                            //Limpia la bandera 2
	MOVLW       2
	MOVWF       FARG_CambiarEstadoBandera_bandera+0 
	CLRF        FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,314 :: 		}
L_interrupt58:
;PruebaConfiguracion.c,316 :: 		if ((banSPI3==0)&&(bufferSPI==0xA3)){
	MOVF        _banSPI3+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt61
	MOVF        _bufferSPI+0, 0 
	XORLW       163
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt61
L__interrupt110:
;PruebaConfiguracion.c,317 :: 		CambiarEstadoBandera(3,1);                                            //Activa la bandera 3
	MOVLW       3
	MOVWF       FARG_CambiarEstadoBandera_bandera+0 
	MOVLW       1
	MOVWF       FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,318 :: 		SSP1BUF = tramaPruebaSPI[0];
	MOVF        _tramaPruebaSPI+0, 0 
	MOVWF       SSP1BUF+0 
;PruebaConfiguracion.c,319 :: 		i = 1;
	MOVLW       1
	MOVWF       _i+0 
	MOVLW       0
	MOVWF       _i+1 
;PruebaConfiguracion.c,320 :: 		}
L_interrupt61:
;PruebaConfiguracion.c,321 :: 		if ((banSPI3==1)&&(bufferSPI!=0xA3)&&(bufferSPI!=0xF3)){
	MOVF        _banSPI3+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt64
	MOVF        _bufferSPI+0, 0 
	XORLW       163
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt64
	MOVF        _bufferSPI+0, 0 
	XORLW       243
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt64
L__interrupt109:
;PruebaConfiguracion.c,322 :: 		SSP1BUF = tramaPruebaSPI[i];
	MOVLW       _tramaPruebaSPI+0
	ADDWF       _i+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_tramaPruebaSPI+0)
	ADDWFC      _i+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       SSP1BUF+0 
;PruebaConfiguracion.c,323 :: 		i++;
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;PruebaConfiguracion.c,324 :: 		}
L_interrupt64:
;PruebaConfiguracion.c,325 :: 		if ((banSPI3==1)&&(bufferSPI==0xF3)){
	MOVF        _banSPI3+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt67
	MOVF        _bufferSPI+0, 0 
	XORLW       243
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt67
L__interrupt108:
;PruebaConfiguracion.c,326 :: 		CambiarEstadoBandera(3,0);                                            //Limpia la bandera 3
	MOVLW       3
	MOVWF       FARG_CambiarEstadoBandera_bandera+0 
	CLRF        FARG_CambiarEstadoBandera_estado+0 
	CALL        _CambiarEstadoBandera+0, 0
;PruebaConfiguracion.c,327 :: 		}
L_interrupt67:
;PruebaConfiguracion.c,330 :: 		}
L_interrupt22:
;PruebaConfiguracion.c,335 :: 		if (RC1IF_bit==1){
	BTFSS       RC1IF_bit+0, BitPos(RC1IF_bit+0) 
	GOTO        L_interrupt68
;PruebaConfiguracion.c,337 :: 		RC1IF_bit = 0;                                                           //Limpia la bandera de interrupcion
	BCF         RC1IF_bit+0, BitPos(RC1IF_bit+0) 
;PruebaConfiguracion.c,338 :: 		byteRS485 = UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _byteRS485+0 
;PruebaConfiguracion.c,341 :: 		if (banRSI==2){
	MOVF        _banRSI+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt69
;PruebaConfiguracion.c,343 :: 		if (i_rs485<(numDatosRS485)){
	MOVF        _numDatosRS485+1, 0 
	SUBWF       _i_rs485+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt131
	MOVF        _numDatosRS485+0, 0 
	SUBWF       _i_rs485+0, 0 
L__interrupt131:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt70
;PruebaConfiguracion.c,344 :: 		pyloadRS485[i_rs485] = byteRS485;
	MOVLW       _pyloadRS485+0
	ADDWF       _i_rs485+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_pyloadRS485+0)
	ADDWFC      _i_rs485+1, 0 
	MOVWF       FSR1H 
	MOVF        _byteRS485+0, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,345 :: 		i_rs485++;
	INFSNZ      _i_rs485+0, 1 
	INCF        _i_rs485+1, 1 
;PruebaConfiguracion.c,346 :: 		} else {
	GOTO        L_interrupt71
L_interrupt70:
;PruebaConfiguracion.c,347 :: 		banRSI = 0;                                                        //Limpia la bandera de inicio de trama
	CLRF        _banRSI+0 
;PruebaConfiguracion.c,348 :: 		banRSC = 1;                                                        //Activa la bandera de trama completa
	MOVLW       1
	MOVWF       _banRSC+0 
;PruebaConfiguracion.c,349 :: 		}
L_interrupt71:
;PruebaConfiguracion.c,350 :: 		}
L_interrupt69:
;PruebaConfiguracion.c,353 :: 		if ((banRSI==0)&&(banRSC==0)){
	MOVF        _banRSI+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt74
	MOVF        _banRSC+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt74
L__interrupt107:
;PruebaConfiguracion.c,354 :: 		if (byteRS485==0x3A){                                                 //Verifica si el primer byte recibido sea el byte de inicio de trama
	MOVF        _byteRS485+0, 0 
	XORLW       58
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt75
;PruebaConfiguracion.c,355 :: 		banRSI = 1;
	MOVLW       1
	MOVWF       _banRSI+0 
;PruebaConfiguracion.c,356 :: 		i_rs485 = 0;
	CLRF        _i_rs485+0 
	CLRF        _i_rs485+1 
;PruebaConfiguracion.c,357 :: 		LED1 = 1;
	BSF         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,358 :: 		}
L_interrupt75:
;PruebaConfiguracion.c,359 :: 		}
L_interrupt74:
;PruebaConfiguracion.c,360 :: 		if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<5)){
	MOVF        _banRSI+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt78
	MOVF        _byteRS485+0, 0 
	XORLW       58
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt78
	MOVLW       0
	SUBWF       _i_rs485+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt132
	MOVLW       5
	SUBWF       _i_rs485+0, 0 
L__interrupt132:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt78
L__interrupt106:
;PruebaConfiguracion.c,361 :: 		tramaCabeceraRS485[i_rs485] = byteRS485;                              //Recupera los datos de cabecera de la trama UART: [Direccion, Funcion, Subfuncion, NumeroDatos]
	MOVLW       _tramaCabeceraRS485+0
	ADDWF       _i_rs485+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_tramaCabeceraRS485+0)
	ADDWFC      _i_rs485+1, 0 
	MOVWF       FSR1H 
	MOVF        _byteRS485+0, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,362 :: 		i_rs485++;
	INFSNZ      _i_rs485+0, 1 
	INCF        _i_rs485+1, 1 
;PruebaConfiguracion.c,363 :: 		}
L_interrupt78:
;PruebaConfiguracion.c,364 :: 		if ((banRSI==1)&&(i_rs485==5)){
	MOVF        _banRSI+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt81
	MOVLW       0
	XORWF       _i_rs485+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt133
	MOVLW       5
	XORWF       _i_rs485+0, 0 
L__interrupt133:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt81
L__interrupt105:
;PruebaConfiguracion.c,366 :: 		if (tramaCabeceraRS485[0]==idSolicitud){
	MOVF        _tramaCabeceraRS485+0, 0 
	XORWF       _idSolicitud+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt82
;PruebaConfiguracion.c,368 :: 		funcionRS485 = tramaCabeceraRS485[1];
	MOVF        _tramaCabeceraRS485+1, 0 
	MOVWF       _funcionRS485+0 
;PruebaConfiguracion.c,369 :: 		subFuncionRS485 = tramaCabeceraRS485[2];
	MOVF        _tramaCabeceraRS485+2, 0 
	MOVWF       _subFuncionRS485+0 
;PruebaConfiguracion.c,370 :: 		*(ptrNumDatosRS485) = tramaCabeceraRS485[3];
	MOVFF       _ptrNumDatosRS485+0, FSR1
	MOVFF       _ptrNumDatosRS485+1, FSR1H
	MOVF        _tramaCabeceraRS485+3, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,371 :: 		*(ptrNumDatosRS485+1) = tramaCabeceraRS485[4];
	MOVLW       1
	ADDWF       _ptrNumDatosRS485+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      _ptrNumDatosRS485+1, 0 
	MOVWF       FSR1H 
	MOVF        _tramaCabeceraRS485+4, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,372 :: 		idSolicitud = 0;                                                   //Encera el idSolicitud
	CLRF        _idSolicitud+0 
;PruebaConfiguracion.c,373 :: 		i_rs485 = 0;                                                       //Encera el subindice para almacenar el payload
	CLRF        _i_rs485+0 
	CLRF        _i_rs485+1 
;PruebaConfiguracion.c,374 :: 		banRSI = 2;                                                        //Cambia el valor de la bandera para salir del bucle
	MOVLW       2
	MOVWF       _banRSI+0 
;PruebaConfiguracion.c,376 :: 		} else {
	GOTO        L_interrupt83
L_interrupt82:
;PruebaConfiguracion.c,377 :: 		banRSI = 0;
	CLRF        _banRSI+0 
;PruebaConfiguracion.c,378 :: 		banRSC = 0;
	CLRF        _banRSC+0 
;PruebaConfiguracion.c,379 :: 		i_rs485 = 0;
	CLRF        _i_rs485+0 
	CLRF        _i_rs485+1 
;PruebaConfiguracion.c,380 :: 		}
L_interrupt83:
;PruebaConfiguracion.c,381 :: 		}
L_interrupt81:
;PruebaConfiguracion.c,384 :: 		if (banRSC==1){
	MOVF        _banRSC+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt84
;PruebaConfiguracion.c,385 :: 		LED1 = 0;
	BCF         RB2_bit+0, BitPos(RB2_bit+0) 
;PruebaConfiguracion.c,386 :: 		ResponderSPI(tramaCabeceraRS485);
	MOVLW       _tramaCabeceraRS485+0
	MOVWF       FARG_ResponderSPI_cabeceraRespuesta+0 
	MOVLW       hi_addr(_tramaCabeceraRS485+0)
	MOVWF       FARG_ResponderSPI_cabeceraRespuesta+1 
	CALL        _ResponderSPI+0, 0
;PruebaConfiguracion.c,388 :: 		banRSC = 0;
	CLRF        _banRSC+0 
;PruebaConfiguracion.c,389 :: 		}
L_interrupt84:
;PruebaConfiguracion.c,391 :: 		}
L_interrupt68:
;PruebaConfiguracion.c,396 :: 		if (RC2IF_bit==1){
	BTFSS       RC2IF_bit+0, BitPos(RC2IF_bit+0) 
	GOTO        L_interrupt85
;PruebaConfiguracion.c,398 :: 		RC2IF_bit = 0;                                                           //Limpia la bandera de interrupcion
	BCF         RC2IF_bit+0, BitPos(RC2IF_bit+0) 
;PruebaConfiguracion.c,399 :: 		byteRS4852 = UART2_Read();
	CALL        _UART2_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _byteRS4852+0 
;PruebaConfiguracion.c,402 :: 		if (banRSI2==2){
	MOVF        _banRSI2+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt86
;PruebaConfiguracion.c,404 :: 		if (i_rs4852<(numDatosRS485)){
	MOVF        _numDatosRS485+1, 0 
	SUBWF       _i_rs4852+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt134
	MOVF        _numDatosRS485+0, 0 
	SUBWF       _i_rs4852+0, 0 
L__interrupt134:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt87
;PruebaConfiguracion.c,405 :: 		pyloadRS485[i_rs4852] = byteRS4852;
	MOVLW       _pyloadRS485+0
	ADDWF       _i_rs4852+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_pyloadRS485+0)
	ADDWFC      _i_rs4852+1, 0 
	MOVWF       FSR1H 
	MOVF        _byteRS4852+0, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,406 :: 		i_rs4852++;
	INFSNZ      _i_rs4852+0, 1 
	INCF        _i_rs4852+1, 1 
;PruebaConfiguracion.c,407 :: 		} else {
	GOTO        L_interrupt88
L_interrupt87:
;PruebaConfiguracion.c,408 :: 		banRSI2 = 0;                                                       //Limpia la bandera de inicio de trama
	CLRF        _banRSI2+0 
;PruebaConfiguracion.c,409 :: 		banRSC2 = 1;                                                       //Activa la bandera de trama completa
	MOVLW       1
	MOVWF       _banRSC2+0 
;PruebaConfiguracion.c,410 :: 		}
L_interrupt88:
;PruebaConfiguracion.c,411 :: 		}
L_interrupt86:
;PruebaConfiguracion.c,414 :: 		if ((banRSI2==0)&&(banRSC2==0)){
	MOVF        _banRSI2+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt91
	MOVF        _banRSC2+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt91
L__interrupt104:
;PruebaConfiguracion.c,415 :: 		if (byteRS4852==0x3A){                                                //Verifica si el primer byte recibido sea el byte de inicio de trama
	MOVF        _byteRS4852+0, 0 
	XORLW       58
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt92
;PruebaConfiguracion.c,416 :: 		banRSI2 = 1;
	MOVLW       1
	MOVWF       _banRSI2+0 
;PruebaConfiguracion.c,417 :: 		i_rs4852 = 0;
	CLRF        _i_rs4852+0 
	CLRF        _i_rs4852+1 
;PruebaConfiguracion.c,418 :: 		LED2 = 1;
	BSF         RB4_bit+0, BitPos(RB4_bit+0) 
;PruebaConfiguracion.c,419 :: 		}
L_interrupt92:
;PruebaConfiguracion.c,420 :: 		}
L_interrupt91:
;PruebaConfiguracion.c,421 :: 		if ((banRSI2==1)&&(byteRS4852!=0x3A)&&(i_rs4852<5)){
	MOVF        _banRSI2+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt95
	MOVF        _byteRS4852+0, 0 
	XORLW       58
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt95
	MOVLW       0
	SUBWF       _i_rs4852+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt135
	MOVLW       5
	SUBWF       _i_rs4852+0, 0 
L__interrupt135:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt95
L__interrupt103:
;PruebaConfiguracion.c,422 :: 		tramaCabeceraRS485[i_rs4852] = byteRS4852;                            //Recupera los datos de cabecera de la trama UART: [Direccion, Funcion, Subfuncion, NumeroDatos]
	MOVLW       _tramaCabeceraRS485+0
	ADDWF       _i_rs4852+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_tramaCabeceraRS485+0)
	ADDWFC      _i_rs4852+1, 0 
	MOVWF       FSR1H 
	MOVF        _byteRS4852+0, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,423 :: 		i_rs4852++;
	INFSNZ      _i_rs4852+0, 1 
	INCF        _i_rs4852+1, 1 
;PruebaConfiguracion.c,424 :: 		}
L_interrupt95:
;PruebaConfiguracion.c,425 :: 		if ((banRSI2==1)&&(i_rs4852==5)){
	MOVF        _banRSI2+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt98
	MOVLW       0
	XORWF       _i_rs4852+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt136
	MOVLW       5
	XORWF       _i_rs4852+0, 0 
L__interrupt136:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt98
L__interrupt102:
;PruebaConfiguracion.c,427 :: 		if (tramaCabeceraRS485[0]==idSolicitud){
	MOVF        _tramaCabeceraRS485+0, 0 
	XORWF       _idSolicitud+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt99
;PruebaConfiguracion.c,429 :: 		funcionRS485 = tramaCabeceraRS485[1];
	MOVF        _tramaCabeceraRS485+1, 0 
	MOVWF       _funcionRS485+0 
;PruebaConfiguracion.c,430 :: 		subFuncionRS485 = tramaCabeceraRS485[2];
	MOVF        _tramaCabeceraRS485+2, 0 
	MOVWF       _subFuncionRS485+0 
;PruebaConfiguracion.c,431 :: 		*(ptrNumDatosRS485) = tramaCabeceraRS485[3];
	MOVFF       _ptrNumDatosRS485+0, FSR1
	MOVFF       _ptrNumDatosRS485+1, FSR1H
	MOVF        _tramaCabeceraRS485+3, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,432 :: 		*(ptrNumDatosRS485+1) = tramaCabeceraRS485[4];
	MOVLW       1
	ADDWF       _ptrNumDatosRS485+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      _ptrNumDatosRS485+1, 0 
	MOVWF       FSR1H 
	MOVF        _tramaCabeceraRS485+4, 0 
	MOVWF       POSTINC1+0 
;PruebaConfiguracion.c,433 :: 		idSolicitud = 0;                                                   //Encera el idSolicitud
	CLRF        _idSolicitud+0 
;PruebaConfiguracion.c,434 :: 		i_rs4852 = 0;                                                      //Encera el subindice para almacenar el payload
	CLRF        _i_rs4852+0 
	CLRF        _i_rs4852+1 
;PruebaConfiguracion.c,435 :: 		banRSI2 = 2;                                                       //Cambia el valor de la bandera para salir del bucle
	MOVLW       2
	MOVWF       _banRSI2+0 
;PruebaConfiguracion.c,437 :: 		} else {
	GOTO        L_interrupt100
L_interrupt99:
;PruebaConfiguracion.c,438 :: 		banRSI2 = 0;
	CLRF        _banRSI2+0 
;PruebaConfiguracion.c,439 :: 		banRSC2 = 0;
	CLRF        _banRSC2+0 
;PruebaConfiguracion.c,440 :: 		i_rs4852 = 0;
	CLRF        _i_rs4852+0 
	CLRF        _i_rs4852+1 
;PruebaConfiguracion.c,441 :: 		}
L_interrupt100:
;PruebaConfiguracion.c,442 :: 		}
L_interrupt98:
;PruebaConfiguracion.c,445 :: 		if (banRSC2==1){
	MOVF        _banRSC2+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt101
;PruebaConfiguracion.c,446 :: 		LED2 = 0;
	BCF         RB4_bit+0, BitPos(RB4_bit+0) 
;PruebaConfiguracion.c,447 :: 		ResponderSPI(tramaCabeceraRS485);
	MOVLW       _tramaCabeceraRS485+0
	MOVWF       FARG_ResponderSPI_cabeceraRespuesta+0 
	MOVLW       hi_addr(_tramaCabeceraRS485+0)
	MOVWF       FARG_ResponderSPI_cabeceraRespuesta+1 
	CALL        _ResponderSPI+0, 0
;PruebaConfiguracion.c,449 :: 		banRSC2 = 0;
	CLRF        _banRSC2+0 
;PruebaConfiguracion.c,450 :: 		}
L_interrupt101:
;PruebaConfiguracion.c,452 :: 		}
L_interrupt85:
;PruebaConfiguracion.c,455 :: 		}
L_end_interrupt:
L__interrupt128:
	RETFIE      1
; end of _interrupt
