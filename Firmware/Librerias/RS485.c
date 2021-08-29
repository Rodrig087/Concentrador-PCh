//Libreria para la comunicacion a travez de RS485
//Version 2: Esta version recibe como parametros el puerto, la trama de cabecera y la trama pdu

/////////////////////// /// Formato de la trama de datos //////////////////////////
//|                     Cabecera                 |       PDU       |      Fin     |
//|   1 byte   |   1 byte  |  1 byte   |    1 byte    |  1 byte  |     n bytes     |    2 bytes   |
//|    0x3A    | Direccion |  Funcion  |  Subfuncion  |  #Datos  |     Payload     |  0Dh  |  0Ah |


// Definicion de pines del chip select, en el programa que se va a utilizar la
// libreria hay que declarar este pin del CS
//sbit MS1RS485 at LATC5_bit; 
extern sfr sbit MS1RS485;
extern sfr sbit MS1RS485_Direction;
extern sfr sbit MS2RS485;
extern sfr sbit MS2RS485_Direction;
//*****************************************************************************************************************************************

//Funcion para enviar una trama de n datos a travez del MAX485
void EnviarTramaRS485(unsigned short puertoUART, unsigned char *cabecera, unsigned char *payload){

     unsigned short direccion; 
	 unsigned short funcion; 
	 unsigned short subfuncion; 
	 unsigned short numDatos;
	 unsigned short iDatos;
	 
	 direccion = cabecera[0];
	 funcion = cabecera[1];
	 subfuncion = cabecera[2];
	 numDatos = cabecera[3];
                     
     if (puertoUART == 1){
        MS1RS485 = 1;                                                            //Establece el Max485 en modo escritura
        UART1_Write(0x3A);                                                      //Envia la cabecera de la trama
        UART1_Write(direccion);                                                 //Envia la direccion del destinatario
        UART1_Write(funcion);                                                   //Envia el codigo de la funcion
        UART1_Write(subfuncion);                                                //Envia el codigo de la subfuncion
        UART1_Write(numDatos);                                                  //Envia el numero de datos
        for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
            UART1_Write(payload[iDatos]);
        }
        UART1_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
        UART1_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
        UART1_Write(0x00);                                                      //Envia un byte adicional
        while(UART1_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
        MS1RS485 = 0;                                                            //Establece el Max485 en modo lectura
     }

     if (puertoUART == 2){
		MS2RS485 = 1;                                                            //Establece el Max485 en modo escritura
        UART2_Write(0x3A);                                                      //Envia la cabecera de la trama
        UART2_Write(direccion);                                                 //Envia la direccion del destinatario
        UART2_Write(funcion);                                                   //Envia el codigo de la funcion
        UART1_Write(subfuncion);                                                //Envia el codigo de la subfuncion
        UART1_Write(numDatos);                                                  //Envia el numero de datos
        for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
            UART2_Write(payload[iDatos]);
        }
        UART2_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
        UART2_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
        UART2_Write(0x00);                                                      //Envia un byte adicional
        while(UART2_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
        MS2RS485 = 0;                                                            //Establece el Max485 en modo lectura
     }

}

//*****************************************************************************************************************************************