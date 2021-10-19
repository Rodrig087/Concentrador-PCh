
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
	GOTO        L__EnviarTramaRS48543
	MOVF        EnviarTramaRS485_numDatos_L0+0, 0 
	SUBWF       EnviarTramaRS485_iDatos_L0+0, 0 
L__EnviarTramaRS48543:
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
	GOTO        L__EnviarTramaRS48544
	MOVF        EnviarTramaRS485_numDatos_L0+0, 0 
	SUBWF       EnviarTramaRS485_iDatos_L0+0, 0 
L__EnviarTramaRS48544:
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

;PruebaNodo1.c,49 :: 		void main() {
;PruebaNodo1.c,51 :: 		ConfiguracionPrincipal();
	CALL        _ConfiguracionPrincipal+0, 0
;PruebaNodo1.c,55 :: 		i = 0;
	CLRF        _i+0 
	CLRF        _i+1 
;PruebaNodo1.c,56 :: 		j = 0;
	CLRF        _j+0 
	CLRF        _j+1 
;PruebaNodo1.c,57 :: 		x = 0;
	CLRF        _x+0 
	CLRF        _x+1 
;PruebaNodo1.c,58 :: 		y = 0;
	CLRF        _y+0 
	CLRF        _y+1 
;PruebaNodo1.c,61 :: 		banRSI = 0;
	CLRF        _banRSI+0 
;PruebaNodo1.c,62 :: 		banRSC = 0;
	CLRF        _banRSC+0 
;PruebaNodo1.c,63 :: 		byteRS485 = 0;
	CLRF        _byteRS485+0 
;PruebaNodo1.c,64 :: 		i_rs485 = 0;
	CLRF        _i_rs485+0 
	CLRF        _i_rs485+1 
;PruebaNodo1.c,65 :: 		funcionRS485 = 0;
	CLRF        _funcionRS485+0 
;PruebaNodo1.c,66 :: 		subFuncionRS485 = 0;
	CLRF        _subFuncionRS485+0 
;PruebaNodo1.c,67 :: 		numDatosRS485 = 0;
	CLRF        _numDatosRS485+0 
	CLRF        _numDatosRS485+1 
;PruebaNodo1.c,68 :: 		ptrNumDatosRS485 = (unsigned char *) & numDatosRS485;
	MOVLW       _numDatosRS485+0
	MOVWF       _ptrNumDatosRS485+0 
	MOVLW       hi_addr(_numDatosRS485+0)
	MOVWF       _ptrNumDatosRS485+1 
;PruebaNodo1.c,69 :: 		MS1RS485 = 0;
	BCF         LATC5_bit+0, BitPos(LATC5_bit+0) 
;PruebaNodo1.c,73 :: 		TEST = 1;
	BSF         LATC4_bit+0, BitPos(LATC4_bit+0) 
;PruebaNodo1.c,82 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_ConfiguracionPrincipal:

;PruebaNodo1.c,90 :: 		void ConfiguracionPrincipal(){
;PruebaNodo1.c,93 :: 		OSCCON.IDLEN=1;                                    //Entra en modo IDLE durante la instruccion SLEEP
	BSF         OSCCON+0, 7 
;PruebaNodo1.c,94 :: 		OSCCON.IRCF2=1;                                    //HFINTOSC=16MHz  IRFC=111
	BSF         OSCCON+0, 6 
;PruebaNodo1.c,95 :: 		OSCCON.IRCF1=1;
	BSF         OSCCON+0, 5 
;PruebaNodo1.c,96 :: 		OSCCON.IRCF0=1;
	BSF         OSCCON+0, 4 
;PruebaNodo1.c,97 :: 		OSCCON.SCS1=1;                                     //System Clock Select bit:  1x=Internal oscillator block
	BSF         OSCCON+0, 1 
;PruebaNodo1.c,98 :: 		OSCCON.SCS0=1;
	BSF         OSCCON+0, 0 
;PruebaNodo1.c,101 :: 		ANSELA = 0;                                        //Configura PORTA como digital
	CLRF        ANSELA+0 
;PruebaNodo1.c,102 :: 		ANSELB = 0;                                        //Configura PORTB como digital
	CLRF        ANSELB+0 
;PruebaNodo1.c,103 :: 		ANSELC = 0;                                        //Configura PORTC como digital
	CLRF        ANSELC+0 
;PruebaNodo1.c,105 :: 		TEST_Direction = 0;                                //Configura el pin TEST como salida
	BCF         TRISC4_bit+0, BitPos(TRISC4_bit+0) 
;PruebaNodo1.c,106 :: 		MS1RS485_Direction = 0;                            //Configura el pin MS1RS485 como salida
	BCF         TRISC5_bit+0, BitPos(TRISC5_bit+0) 
;PruebaNodo1.c,108 :: 		INTCON.GIE = 1;                                    //Habilita las interrupciones globales
	BSF         INTCON+0, 7 
;PruebaNodo1.c,109 :: 		INTCON.PEIE = 1;                                   //Habilita las interrupciones perifericas
	BSF         INTCON+0, 6 
;PruebaNodo1.c,112 :: 		PIE1.RC1IE = 1;                                   //Habilita la interrupcion en UART1 receive
	BSF         PIE1+0, 5 
;PruebaNodo1.c,113 :: 		PIR1.RC1IF = 0;                                   //Limpia la bandera de interrupcion UART1
	BCF         PIR1+0, 5 
;PruebaNodo1.c,114 :: 		UART1_Init(19200);                                //Inicializa el UART1 a 19200 bps
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       207
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;PruebaNodo1.c,116 :: 		Delay_ms(100);                                     //Espera hasta que se estabilicen los cambios
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
;PruebaNodo1.c,118 :: 		}
L_end_ConfiguracionPrincipal:
	RETURN      0
; end of _ConfiguracionPrincipal

_GenerarTramaPrueba:

;PruebaNodo1.c,122 :: 		void GenerarTramaPrueba(unsigned int numDatosResp, unsigned char *cabeceraRespuesta){
;PruebaNodo1.c,124 :: 		unsigned int contadorMuestras = 0;
	CLRF        GenerarTramaPrueba_contadorMuestras_L0+0 
	CLRF        GenerarTramaPrueba_contadorMuestras_L0+1 
;PruebaNodo1.c,127 :: 		for (j=0;j<numDatosResp;j++){
	CLRF        _j+0 
	CLRF        _j+1 
L_GenerarTramaPrueba13:
	MOVF        FARG_GenerarTramaPrueba_numDatosResp+1, 0 
	SUBWF       _j+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GenerarTramaPrueba48
	MOVF        FARG_GenerarTramaPrueba_numDatosResp+0, 0 
	SUBWF       _j+0, 0 
L__GenerarTramaPrueba48:
	BTFSC       STATUS+0, 0 
	GOTO        L_GenerarTramaPrueba14
;PruebaNodo1.c,128 :: 		outputPyloadRS485[j] = contadorMuestras;
	MOVLW       _outputPyloadRS485+0
	ADDWF       _j+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_outputPyloadRS485+0)
	ADDWFC      _j+1, 0 
	MOVWF       FSR1H 
	MOVF        GenerarTramaPrueba_contadorMuestras_L0+0, 0 
	MOVWF       POSTINC1+0 
;PruebaNodo1.c,129 :: 		contadorMuestras++;
	INFSNZ      GenerarTramaPrueba_contadorMuestras_L0+0, 1 
	INCF        GenerarTramaPrueba_contadorMuestras_L0+1, 1 
;PruebaNodo1.c,130 :: 		if (contadorMuestras>255) {
	MOVLW       0
	MOVWF       R0 
	MOVF        GenerarTramaPrueba_contadorMuestras_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__GenerarTramaPrueba49
	MOVF        GenerarTramaPrueba_contadorMuestras_L0+0, 0 
	SUBLW       255
L__GenerarTramaPrueba49:
	BTFSC       STATUS+0, 0 
	GOTO        L_GenerarTramaPrueba16
;PruebaNodo1.c,131 :: 		contadorMuestras = 0;
	CLRF        GenerarTramaPrueba_contadorMuestras_L0+0 
	CLRF        GenerarTramaPrueba_contadorMuestras_L0+1 
;PruebaNodo1.c,132 :: 		}
L_GenerarTramaPrueba16:
;PruebaNodo1.c,127 :: 		for (j=0;j<numDatosResp;j++){
	INFSNZ      _j+0, 1 
	INCF        _j+1, 1 
;PruebaNodo1.c,133 :: 		}
	GOTO        L_GenerarTramaPrueba13
L_GenerarTramaPrueba14:
;PruebaNodo1.c,135 :: 		EnviarTramaRS485(1, cabeceraRespuesta, outputPyloadRS485);
	MOVLW       1
	MOVWF       FARG_EnviarTramaRS485_puertoUART+0 
	MOVF        FARG_GenerarTramaPrueba_cabeceraRespuesta+0, 0 
	MOVWF       FARG_EnviarTramaRS485_cabecera+0 
	MOVF        FARG_GenerarTramaPrueba_cabeceraRespuesta+1, 0 
	MOVWF       FARG_EnviarTramaRS485_cabecera+1 
	MOVLW       _outputPyloadRS485+0
	MOVWF       FARG_EnviarTramaRS485_payload+0 
	MOVLW       hi_addr(_outputPyloadRS485+0)
	MOVWF       FARG_EnviarTramaRS485_payload+1 
	CALL        _EnviarTramaRS485+0, 0
;PruebaNodo1.c,138 :: 		}
L_end_GenerarTramaPrueba:
	RETURN      0
; end of _GenerarTramaPrueba

_interrupt:

;PruebaNodo1.c,146 :: 		void interrupt(void){
;PruebaNodo1.c,150 :: 		if (RC1IF_bit==1){
	BTFSS       RC1IF_bit+0, BitPos(RC1IF_bit+0) 
	GOTO        L_interrupt17
;PruebaNodo1.c,152 :: 		RC1IF_bit = 0;                                                           //Limpia la bandera de interrupcion
	BCF         RC1IF_bit+0, BitPos(RC1IF_bit+0) 
;PruebaNodo1.c,153 :: 		byteRS485 = UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _byteRS485+0 
;PruebaNodo1.c,156 :: 		if (banRSI==2){
	MOVF        _banRSI+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt18
;PruebaNodo1.c,158 :: 		if (i_rs485<(numDatosRS485)){
	MOVF        _numDatosRS485+1, 0 
	SUBWF       _i_rs485+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt52
	MOVF        _numDatosRS485+0, 0 
	SUBWF       _i_rs485+0, 0 
L__interrupt52:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt19
;PruebaNodo1.c,159 :: 		inputPyloadRS485[i_rs485] = byteRS485;
	MOVLW       _inputPyloadRS485+0
	ADDWF       _i_rs485+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_inputPyloadRS485+0)
	ADDWFC      _i_rs485+1, 0 
	MOVWF       FSR1H 
	MOVF        _byteRS485+0, 0 
	MOVWF       POSTINC1+0 
;PruebaNodo1.c,160 :: 		i_rs485++;
	INFSNZ      _i_rs485+0, 1 
	INCF        _i_rs485+1, 1 
;PruebaNodo1.c,161 :: 		} else {
	GOTO        L_interrupt20
L_interrupt19:
;PruebaNodo1.c,162 :: 		banRSI = 0;                                                        //Limpia la bandera de inicio de trama
	CLRF        _banRSI+0 
;PruebaNodo1.c,163 :: 		banRSC = 1;                                                        //Activa la bandera de trama completa
	MOVLW       1
	MOVWF       _banRSC+0 
;PruebaNodo1.c,164 :: 		}
L_interrupt20:
;PruebaNodo1.c,165 :: 		}
L_interrupt18:
;PruebaNodo1.c,168 :: 		if ((banRSI==0)&&(banRSC==0)){
	MOVF        _banRSI+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt23
	MOVF        _banRSC+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt23
L__interrupt41:
;PruebaNodo1.c,169 :: 		if (byteRS485==0x3A){                                                 //Verifica si el primer byte recibido sea el byte de inicio de trama
	MOVF        _byteRS485+0, 0 
	XORLW       58
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt24
;PruebaNodo1.c,170 :: 		banRSI = 1;
	MOVLW       1
	MOVWF       _banRSI+0 
;PruebaNodo1.c,171 :: 		i_rs485 = 0;
	CLRF        _i_rs485+0 
	CLRF        _i_rs485+1 
;PruebaNodo1.c,172 :: 		}
L_interrupt24:
;PruebaNodo1.c,173 :: 		}
L_interrupt23:
;PruebaNodo1.c,174 :: 		if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<5)){
	MOVF        _banRSI+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt27
	MOVF        _byteRS485+0, 0 
	XORLW       58
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt27
	MOVLW       0
	SUBWF       _i_rs485+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt53
	MOVLW       5
	SUBWF       _i_rs485+0, 0 
L__interrupt53:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt27
L__interrupt40:
;PruebaNodo1.c,175 :: 		tramaCabeceraRS485[i_rs485] = byteRS485;                              //Recupera los datos de cabecera de la trama UART: [Direccion, Funcion, Subfuncion, NumeroDatos]
	MOVLW       _tramaCabeceraRS485+0
	ADDWF       _i_rs485+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_tramaCabeceraRS485+0)
	ADDWFC      _i_rs485+1, 0 
	MOVWF       FSR1H 
	MOVF        _byteRS485+0, 0 
	MOVWF       POSTINC1+0 
;PruebaNodo1.c,176 :: 		i_rs485++;
	INFSNZ      _i_rs485+0, 1 
	INCF        _i_rs485+1, 1 
;PruebaNodo1.c,177 :: 		}
L_interrupt27:
;PruebaNodo1.c,178 :: 		if ((banRSI==1)&&(i_rs485==5)){
	MOVF        _banRSI+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt30
	MOVLW       0
	XORWF       _i_rs485+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt54
	MOVLW       5
	XORWF       _i_rs485+0, 0 
L__interrupt54:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt30
L__interrupt39:
;PruebaNodo1.c,180 :: 		if (tramaCabeceraRS485[0]==IDNODO){
	MOVF        _tramaCabeceraRS485+0, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt31
;PruebaNodo1.c,182 :: 		funcionRS485 = tramaCabeceraRS485[1];
	MOVF        _tramaCabeceraRS485+1, 0 
	MOVWF       _funcionRS485+0 
;PruebaNodo1.c,183 :: 		subFuncionRS485 = tramaCabeceraRS485[2];
	MOVF        _tramaCabeceraRS485+2, 0 
	MOVWF       _subFuncionRS485+0 
;PruebaNodo1.c,184 :: 		*(ptrNumDatosRS485) = tramaCabeceraRS485[3];
	MOVFF       _ptrNumDatosRS485+0, FSR1
	MOVFF       _ptrNumDatosRS485+1, FSR1H
	MOVF        _tramaCabeceraRS485+3, 0 
	MOVWF       POSTINC1+0 
;PruebaNodo1.c,185 :: 		*(ptrNumDatosRS485+1) = tramaCabeceraRS485[4];
	MOVLW       1
	ADDWF       _ptrNumDatosRS485+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      _ptrNumDatosRS485+1, 0 
	MOVWF       FSR1H 
	MOVF        _tramaCabeceraRS485+4, 0 
	MOVWF       POSTINC1+0 
;PruebaNodo1.c,186 :: 		banRSI = 2;
	MOVLW       2
	MOVWF       _banRSI+0 
;PruebaNodo1.c,187 :: 		i_rs485 = 0;
	CLRF        _i_rs485+0 
	CLRF        _i_rs485+1 
;PruebaNodo1.c,188 :: 		} else {
	GOTO        L_interrupt32
L_interrupt31:
;PruebaNodo1.c,189 :: 		banRSI = 0;
	CLRF        _banRSI+0 
;PruebaNodo1.c,190 :: 		banRSC = 0;
	CLRF        _banRSC+0 
;PruebaNodo1.c,191 :: 		i_rs485 = 0;
	CLRF        _i_rs485+0 
	CLRF        _i_rs485+1 
;PruebaNodo1.c,192 :: 		}
L_interrupt32:
;PruebaNodo1.c,193 :: 		}
L_interrupt30:
;PruebaNodo1.c,196 :: 		if (banRSC==1){
	MOVF        _banRSC+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt33
;PruebaNodo1.c,198 :: 		TEST = ~TEST;
	BTG         LATC4_bit+0, BitPos(LATC4_bit+0) 
;PruebaNodo1.c,199 :: 		Delay_ms(250);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_interrupt34:
	DECFSZ      R13, 1, 1
	BRA         L_interrupt34
	DECFSZ      R12, 1, 1
	BRA         L_interrupt34
	DECFSZ      R11, 1, 1
	BRA         L_interrupt34
	NOP
	NOP
;PruebaNodo1.c,202 :: 		if (funcionRS485==2){
	MOVF        _funcionRS485+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt35
;PruebaNodo1.c,205 :: 		numDatosRS485 = 5;
	MOVLW       5
	MOVWF       _numDatosRS485+0 
	MOVLW       0
	MOVWF       _numDatosRS485+1 
;PruebaNodo1.c,206 :: 		tramaCabeceraRS485[3] = *(ptrNumDatosRS485);
	MOVFF       _ptrNumDatosRS485+0, FSR0
	MOVFF       _ptrNumDatosRS485+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       _tramaCabeceraRS485+3 
;PruebaNodo1.c,207 :: 		tramaCabeceraRS485[4] = *(ptrNumDatosRS485+1);
	MOVLW       1
	ADDWF       _ptrNumDatosRS485+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      _ptrNumDatosRS485+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       _tramaCabeceraRS485+4 
;PruebaNodo1.c,209 :: 		EnviarTramaRS485(1, tramaCabeceraRS485, inputPyloadRS485);
	MOVLW       1
	MOVWF       FARG_EnviarTramaRS485_puertoUART+0 
	MOVLW       _tramaCabeceraRS485+0
	MOVWF       FARG_EnviarTramaRS485_cabecera+0 
	MOVLW       hi_addr(_tramaCabeceraRS485+0)
	MOVWF       FARG_EnviarTramaRS485_cabecera+1 
	MOVLW       _inputPyloadRS485+0
	MOVWF       FARG_EnviarTramaRS485_payload+0 
	MOVLW       hi_addr(_inputPyloadRS485+0)
	MOVWF       FARG_EnviarTramaRS485_payload+1 
	CALL        _EnviarTramaRS485+0, 0
;PruebaNodo1.c,210 :: 		}
L_interrupt35:
;PruebaNodo1.c,211 :: 		if (funcionRS485==4){
	MOVF        _funcionRS485+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt36
;PruebaNodo1.c,212 :: 		if (subFuncionRS485==2){
	MOVF        _subFuncionRS485+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt37
;PruebaNodo1.c,214 :: 		numDatosRS485 = 10;
	MOVLW       10
	MOVWF       _numDatosRS485+0 
	MOVLW       0
	MOVWF       _numDatosRS485+1 
;PruebaNodo1.c,215 :: 		tramaCabeceraRS485[3] = *(ptrNumDatosRS485);
	MOVFF       _ptrNumDatosRS485+0, FSR0
	MOVFF       _ptrNumDatosRS485+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       _tramaCabeceraRS485+3 
;PruebaNodo1.c,216 :: 		tramaCabeceraRS485[4] = *(ptrNumDatosRS485+1);
	MOVLW       1
	ADDWF       _ptrNumDatosRS485+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      _ptrNumDatosRS485+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       _tramaCabeceraRS485+4 
;PruebaNodo1.c,217 :: 		EnviarTramaRS485(1, tramaCabeceraRS485, tramaPruebaRS485);
	MOVLW       1
	MOVWF       FARG_EnviarTramaRS485_puertoUART+0 
	MOVLW       _tramaCabeceraRS485+0
	MOVWF       FARG_EnviarTramaRS485_cabecera+0 
	MOVLW       hi_addr(_tramaCabeceraRS485+0)
	MOVWF       FARG_EnviarTramaRS485_cabecera+1 
	MOVLW       _tramaPruebaRS485+0
	MOVWF       FARG_EnviarTramaRS485_payload+0 
	MOVLW       hi_addr(_tramaPruebaRS485+0)
	MOVWF       FARG_EnviarTramaRS485_payload+1 
	CALL        _EnviarTramaRS485+0, 0
;PruebaNodo1.c,218 :: 		}
L_interrupt37:
;PruebaNodo1.c,219 :: 		if (subFuncionRS485==3){
	MOVF        _subFuncionRS485+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt38
;PruebaNodo1.c,221 :: 		numDatosRS485 = 700;
	MOVLW       188
	MOVWF       _numDatosRS485+0 
	MOVLW       2
	MOVWF       _numDatosRS485+1 
;PruebaNodo1.c,222 :: 		tramaCabeceraRS485[3] = *(ptrNumDatosRS485);
	MOVFF       _ptrNumDatosRS485+0, FSR0
	MOVFF       _ptrNumDatosRS485+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       _tramaCabeceraRS485+3 
;PruebaNodo1.c,223 :: 		tramaCabeceraRS485[4] = *(ptrNumDatosRS485+1);
	MOVLW       1
	ADDWF       _ptrNumDatosRS485+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      _ptrNumDatosRS485+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       _tramaCabeceraRS485+4 
;PruebaNodo1.c,224 :: 		GenerarTramaPrueba(numDatosRS485, tramaCabeceraRS485);
	MOVLW       188
	MOVWF       FARG_GenerarTramaPrueba_numDatosResp+0 
	MOVLW       2
	MOVWF       FARG_GenerarTramaPrueba_numDatosResp+1 
	MOVLW       _tramaCabeceraRS485+0
	MOVWF       FARG_GenerarTramaPrueba_cabeceraRespuesta+0 
	MOVLW       hi_addr(_tramaCabeceraRS485+0)
	MOVWF       FARG_GenerarTramaPrueba_cabeceraRespuesta+1 
	CALL        _GenerarTramaPrueba+0, 0
;PruebaNodo1.c,225 :: 		}
L_interrupt38:
;PruebaNodo1.c,226 :: 		}
L_interrupt36:
;PruebaNodo1.c,228 :: 		banRSC = 0;
	CLRF        _banRSC+0 
;PruebaNodo1.c,230 :: 		}
L_interrupt33:
;PruebaNodo1.c,234 :: 		}
L_interrupt17:
;PruebaNodo1.c,237 :: 		}
L_end_interrupt:
L__interrupt51:
	RETFIE      1
; end of _interrupt
