
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

;PruebaNodo1.c,46 :: 		void main() {
;PruebaNodo1.c,48 :: 		ConfiguracionPrincipal();
	CALL        _ConfiguracionPrincipal+0, 0
;PruebaNodo1.c,52 :: 		i = 0;
	CLRF        _i+0 
	CLRF        _i+1 
;PruebaNodo1.c,53 :: 		j = 0;
	CLRF        _j+0 
	CLRF        _j+1 
;PruebaNodo1.c,54 :: 		x = 0;
	CLRF        _x+0 
	CLRF        _x+1 
;PruebaNodo1.c,55 :: 		y = 0;
	CLRF        _y+0 
	CLRF        _y+1 
;PruebaNodo1.c,58 :: 		banRSI = 0;
	CLRF        _banRSI+0 
;PruebaNodo1.c,59 :: 		banRSC = 0;
	CLRF        _banRSC+0 
;PruebaNodo1.c,60 :: 		byteRS485 = 0;
	CLRF        _byteRS485+0 
;PruebaNodo1.c,61 :: 		i_rs485 = 0;
	CLRF        _i_rs485+0 
	CLRF        _i_rs485+1 
;PruebaNodo1.c,62 :: 		funcionRS485 = 0;
	CLRF        _funcionRS485+0 
;PruebaNodo1.c,63 :: 		subFuncionRS485 = 0;
	CLRF        _subFuncionRS485+0 
;PruebaNodo1.c,64 :: 		numDatosRS485 = 0;
	CLRF        _numDatosRS485+0 
;PruebaNodo1.c,65 :: 		MS1RS485 = 0;
	BCF         LATC5_bit+0, BitPos(LATC5_bit+0) 
;PruebaNodo1.c,66 :: 		MS2RS485 = 0;
	BCF         LATB5_bit+0, BitPos(LATB5_bit+0) 
;PruebaNodo1.c,69 :: 		TEST = 1;
	BSF         LATC4_bit+0, BitPos(LATC4_bit+0) 
;PruebaNodo1.c,78 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_ConfiguracionPrincipal:

;PruebaNodo1.c,86 :: 		void ConfiguracionPrincipal(){
;PruebaNodo1.c,89 :: 		OSCCON.IDLEN=1;                                    //Entra en modo IDLE durante la instruccion SLEEP
	BSF         OSCCON+0, 7 
;PruebaNodo1.c,90 :: 		OSCCON.IRCF2=1;                                    //HFINTOSC=16MHz  IRFC=111
	BSF         OSCCON+0, 6 
;PruebaNodo1.c,91 :: 		OSCCON.IRCF1=1;
	BSF         OSCCON+0, 5 
;PruebaNodo1.c,92 :: 		OSCCON.IRCF0=1;
	BSF         OSCCON+0, 4 
;PruebaNodo1.c,93 :: 		OSCCON.SCS1=1;                                     //System Clock Select bit:  1x=Internal oscillator block
	BSF         OSCCON+0, 1 
;PruebaNodo1.c,94 :: 		OSCCON.SCS0=1;
	BSF         OSCCON+0, 0 
;PruebaNodo1.c,97 :: 		ANSELA = 0;                                        //Configura PORTA como digital
	CLRF        ANSELA+0 
;PruebaNodo1.c,98 :: 		ANSELB = 0;                                        //Configura PORTB como digital
	CLRF        ANSELB+0 
;PruebaNodo1.c,99 :: 		ANSELC = 0;                                        //Configura PORTC como digital
	CLRF        ANSELC+0 
;PruebaNodo1.c,101 :: 		TEST_Direction = 0;                                //Configura el pin TEST como salida
	BCF         TRISC4_bit+0, BitPos(TRISC4_bit+0) 
;PruebaNodo1.c,102 :: 		MS1RS485_Direction = 0;                            //Configura el pin MS1RS485 como salida
	BCF         TRISC5_bit+0, BitPos(TRISC5_bit+0) 
;PruebaNodo1.c,104 :: 		INTCON.GIE = 1;                                    //Habilita las interrupciones globales
	BSF         INTCON+0, 7 
;PruebaNodo1.c,105 :: 		INTCON.PEIE = 1;                                   //Habilita las interrupciones perifericas
	BSF         INTCON+0, 6 
;PruebaNodo1.c,108 :: 		PIE1.RC1IE = 1;                                   //Habilita la interrupcion en UART1 receive
	BSF         PIE1+0, 5 
;PruebaNodo1.c,109 :: 		PIR1.RC1IF = 0;                                   //Limpia la bandera de interrupcion UART1
	BCF         PIR1+0, 5 
;PruebaNodo1.c,110 :: 		UART1_Init(19200);                                //Inicializa el UART1 a 19200 bps
	BSF         BAUDCON+0, 3, 0
	CLRF        SPBRGH+0 
	MOVLW       207
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;PruebaNodo1.c,112 :: 		Delay_ms(100);                                     //Espera hasta que se estabilicen los cambios
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
;PruebaNodo1.c,114 :: 		}
L_end_ConfiguracionPrincipal:
	RETURN      0
; end of _ConfiguracionPrincipal

_interrupt:

;PruebaNodo1.c,121 :: 		void interrupt(void){
;PruebaNodo1.c,125 :: 		if (RC1IF_bit==1){
	BTFSS       RC1IF_bit+0, BitPos(RC1IF_bit+0) 
	GOTO        L_interrupt13
;PruebaNodo1.c,127 :: 		RC1IF_bit = 0;                                                           //Limpia la bandera de interrupcion
	BCF         RC1IF_bit+0, BitPos(RC1IF_bit+0) 
;PruebaNodo1.c,128 :: 		byteRS485 = UART1_Read();
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _byteRS485+0 
;PruebaNodo1.c,131 :: 		if (banRSI==2){
	MOVF        _banRSI+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt14
;PruebaNodo1.c,133 :: 		if (i_rs485<(numDatosRS485)){
	MOVLW       0
	SUBWF       _i_rs485+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt39
	MOVF        _numDatosRS485+0, 0 
	SUBWF       _i_rs485+0, 0 
L__interrupt39:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt15
;PruebaNodo1.c,134 :: 		inputPyloadRS485[i_rs485] = byteRS485;
	MOVLW       _inputPyloadRS485+0
	ADDWF       _i_rs485+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_inputPyloadRS485+0)
	ADDWFC      _i_rs485+1, 0 
	MOVWF       FSR1H 
	MOVF        _byteRS485+0, 0 
	MOVWF       POSTINC1+0 
;PruebaNodo1.c,135 :: 		i_rs485++;
	INFSNZ      _i_rs485+0, 1 
	INCF        _i_rs485+1, 1 
;PruebaNodo1.c,136 :: 		} else {
	GOTO        L_interrupt16
L_interrupt15:
;PruebaNodo1.c,137 :: 		banRSI = 0;                                                        //Limpia la bandera de inicio de trama
	CLRF        _banRSI+0 
;PruebaNodo1.c,138 :: 		banRSC = 1;                                                        //Activa la bandera de trama completa
	MOVLW       1
	MOVWF       _banRSC+0 
;PruebaNodo1.c,139 :: 		}
L_interrupt16:
;PruebaNodo1.c,140 :: 		}
L_interrupt14:
;PruebaNodo1.c,143 :: 		if ((banRSI==0)&&(banRSC==0)){
	MOVF        _banRSI+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt19
	MOVF        _banRSC+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt19
L__interrupt33:
;PruebaNodo1.c,144 :: 		if (byteRS485==0x3A){                                                 //Verifica si el primer byte recibido sea el byte de inicio de trama
	MOVF        _byteRS485+0, 0 
	XORLW       58
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt20
;PruebaNodo1.c,145 :: 		banRSI = 1;
	MOVLW       1
	MOVWF       _banRSI+0 
;PruebaNodo1.c,146 :: 		i_rs485 = 0;
	CLRF        _i_rs485+0 
	CLRF        _i_rs485+1 
;PruebaNodo1.c,147 :: 		}
L_interrupt20:
;PruebaNodo1.c,148 :: 		}
L_interrupt19:
;PruebaNodo1.c,149 :: 		if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<4)){
	MOVF        _banRSI+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt23
	MOVF        _byteRS485+0, 0 
	XORLW       58
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt23
	MOVLW       0
	SUBWF       _i_rs485+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt40
	MOVLW       4
	SUBWF       _i_rs485+0, 0 
L__interrupt40:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt23
L__interrupt32:
;PruebaNodo1.c,150 :: 		tramaCabeceraRS485[i_rs485] = byteRS485;                              //Recupera los datos de cabecera de la trama UART: [Direccion, Funcion, Subfuncion, NumeroDatos]
	MOVLW       _tramaCabeceraRS485+0
	ADDWF       _i_rs485+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_tramaCabeceraRS485+0)
	ADDWFC      _i_rs485+1, 0 
	MOVWF       FSR1H 
	MOVF        _byteRS485+0, 0 
	MOVWF       POSTINC1+0 
;PruebaNodo1.c,151 :: 		i_rs485++;
	INFSNZ      _i_rs485+0, 1 
	INCF        _i_rs485+1, 1 
;PruebaNodo1.c,152 :: 		}
L_interrupt23:
;PruebaNodo1.c,153 :: 		if ((banRSI==1)&&(i_rs485==4)){
	MOVF        _banRSI+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt26
	MOVLW       0
	XORWF       _i_rs485+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt41
	MOVLW       4
	XORWF       _i_rs485+0, 0 
L__interrupt41:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt26
L__interrupt31:
;PruebaNodo1.c,155 :: 		if (tramaCabeceraRS485[0]==IDNODO){
	MOVF        _tramaCabeceraRS485+0, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt27
;PruebaNodo1.c,157 :: 		funcionRS485 = tramaCabeceraRS485[1];
	MOVF        _tramaCabeceraRS485+1, 0 
	MOVWF       _funcionRS485+0 
;PruebaNodo1.c,158 :: 		subFuncionRS485 = tramaCabeceraRS485[2];
	MOVF        _tramaCabeceraRS485+2, 0 
	MOVWF       _subFuncionRS485+0 
;PruebaNodo1.c,159 :: 		numDatosRS485 = tramaCabeceraRS485[3];
	MOVF        _tramaCabeceraRS485+3, 0 
	MOVWF       _numDatosRS485+0 
;PruebaNodo1.c,160 :: 		banRSI = 2;
	MOVLW       2
	MOVWF       _banRSI+0 
;PruebaNodo1.c,161 :: 		i_rs485 = 0;
	CLRF        _i_rs485+0 
	CLRF        _i_rs485+1 
;PruebaNodo1.c,163 :: 		} else {
	GOTO        L_interrupt28
L_interrupt27:
;PruebaNodo1.c,164 :: 		banRSI = 0;
	CLRF        _banRSI+0 
;PruebaNodo1.c,165 :: 		banRSC = 0;
	CLRF        _banRSC+0 
;PruebaNodo1.c,166 :: 		i_rs485 = 0;
	CLRF        _i_rs485+0 
	CLRF        _i_rs485+1 
;PruebaNodo1.c,167 :: 		}
L_interrupt28:
;PruebaNodo1.c,168 :: 		}
L_interrupt26:
;PruebaNodo1.c,171 :: 		if (banRSC==1){
	MOVF        _banRSC+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt29
;PruebaNodo1.c,173 :: 		TEST = ~TEST;
	BTG         LATC4_bit+0, BitPos(LATC4_bit+0) 
;PruebaNodo1.c,174 :: 		Delay_ms(250);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_interrupt30:
	DECFSZ      R13, 1, 1
	BRA         L_interrupt30
	DECFSZ      R12, 1, 1
	BRA         L_interrupt30
	DECFSZ      R11, 1, 1
	BRA         L_interrupt30
	NOP
	NOP
;PruebaNodo1.c,176 :: 		tramaCabeceraRS485[3] = 10; //Cambia el numero de datos. El resto de la trama permanece igual
	MOVLW       10
	MOVWF       _tramaCabeceraRS485+3 
;PruebaNodo1.c,177 :: 		EnviarTramaRS485(1, tramaCabeceraRS485, tramaPruebaRS485);
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
;PruebaNodo1.c,179 :: 		banRSC = 0;
	CLRF        _banRSC+0 
;PruebaNodo1.c,181 :: 		}
L_interrupt29:
;PruebaNodo1.c,185 :: 		}
L_interrupt13:
;PruebaNodo1.c,188 :: 		}
L_end_interrupt:
L__interrupt38:
	RETFIE      1
; end of _interrupt
