/*-------------------------------------------------------------------------------------------------------------------------
Autor: Milton Munoz
Fecha de creacion: 21/08/03
Configuracion: PIC18F25k22 XT=16MHz
Observaciones:
Funcion 1: Inicio de medicion.
Funcion 2: Lectura de datos.
Funcion 3: Escritura de datos.
Funcion 4: Test comunicacion
        Subfuncion 1: Test SPI
        Subfuncion 2: Test RS485
---------------------------------------------------------------------------------------------------------------------------*/

////////////////////////////////////////////////////         Librerias         /////////////////////////////////////////////////////////////
#include <RS485.c>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Credenciales (Esto iria en los nodos):
//#define IDNODO 3                                                                //Direccion del nodo

////////////////////////////////////////////// Declaracion de variables y costantes ///////////////////////////////////////////////////////
//Definicion de pines:
sbit RP0 at LATC0_bit;                                                          //Definicion del pin P1
sbit RP0_Direction at TRISC0_bit;
sbit TEST at RB2_bit;                                                           //Definicion del pin de indicador auxiliar para hacer pruebas
sbit TEST_Direction at TRISB2_bit;
sbit MS1RS485 at LATB3_bit;                                                     //Definicion del pin MS1 RS485
sbit MS1RS485_Direction at TRISB3_bit;
sbit MS2RS485 at LATB5_bit;                                                     //Definicion del pin MS1 RS485
sbit MS2RS485_Direction at TRISB5_bit;
//Subindices:
unsigned int i, j, x, y;
//Variables para la comunicacion SPI:
unsigned short bufferSPI;
unsigned short banSPI0, banSPI1;
unsigned char tramaSolicitudSPI[20];                                            //Vector para almacenar los datos de solicitud que envia la RPi a traves del SPI
unsigned char tramaRespuestaSPI[20];
unsigned short idSolicitud;                                                     //Variable para almacenar el id del nodo al que se hizo la solicitud
unsigned short funcionSolicitud;                                                //Variable para almacenar la funcion solicitada
unsigned short subFuncionSolicitud;                                             //Variable para almacenar la subfuncion solicitada
unsigned char cabeceraSolicitud[5];                                             //Vector para almacenar la cabecera de la trama RS485 a enviar
unsigned char payloadSolicitud[5];                                             //Vector para almacenar el pyload de la trama RS485 a enviar
unsigned char tramaPruebaSPI[10]= {0xA0, 0xA1, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6, 0xA7, 0xA8, 0xA9};
//Variables para la comunicacion RS485:
unsigned short banRSI, banRSC;                                                  //Banderas de control de inicio de trama y trama completa
unsigned char byteRS485;
unsigned int i_rs485;                                                           //Subindice
unsigned char tramaCabeceraRS485[5];                                            //Vector para almacenar los datos de cabecera de la trama RS485: [0x3A, Direccion, Funcion, NumeroDatos]
unsigned char inputPyloadRS485[15];                                             //Vector para almacenar el pyload de la trama RS485 recibida
unsigned char outputPyloadRS485[15];                                            //Vector para almacenar el pyload de la trama RS485 a enviar
unsigned short direccionRS485, funcionRS485, subFuncionRS485, numDatosRS485;
unsigned short sumValidacion;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////  Declaracion de funciones  /////////////////////////////////////////////////////////
void ConfiguracionPrincipal();
void CambiarEstadoBandera(unsigned short bandera, unsigned short estado);
void ResponderSPI(unsigned char *cabeceraRespuesta, unsigned char *payloadRespuesta);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////      Main      ////////////////////////////////////////////////////////////////
void main() {

    //Inicio de configuracion:
    ConfiguracionPrincipal();

    //Inicializacion de variables:
    //Subindices:
    i = 0;
    j = 0;
    x = 0;
    y = 0;
    //Comunicacion SPI:
    banSPI0 = 0;
    banSPI1 = 0;
    bufferSPI = 0;
    idSolicitud = 0;
    funcionSolicitud = 0;
    subFuncionSolicitud = 0;
    //Comunicacion RS485:
    banRSI = 0;
    banRSC = 0;
    byteRS485 = 0;
    i_rs485 = 0;
    funcionRS485 = 0;
    subFuncionRS485 = 0;
    numDatosRS485 = 0;
    MS1RS485 = 0;
    MS2RS485 = 0;
    sumValidacion = 0;
    //Puertos:
    RP0 = 0;
    TEST = 1;
    MS1RS485 = 0;
    MS2RS485 = 0;

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////// Funciones ////////////////////////////////////////////////////////////////

//*****************************************************************************************************************************************
// Funcion para realizar la configuracion principal
void ConfiguracionPrincipal(){

     //Configuracion oscilador
     OSCCON.IDLEN=1;                                    //Entra en modo IDLE durante la instruccion SLEEP
     OSCCON.IRCF2=1;                                    //HFINTOSC=16MHz  IRFC=111
     OSCCON.IRCF1=1;
     OSCCON.IRCF0=1;
     OSCCON.SCS1=1;                                     //System Clock Select bit:  1x=Internal oscillator block
     OSCCON.SCS0=1;

     //Configuracion de puertos:
     ANSELA = 0;                                        //Configura PORTA como digital
     ANSELB = 0;                                        //Configura PORTB como digital
     ANSELC = 0;                                        //Configura PORTC como digital
     
     TEST_Direction = 0;                                //Configura el pin TEST como salida
     RP0_Direction = 0;                                 //Configura el pin RP0 como salida
     MS1RS485_Direction = 0;                            //Configura el pin MS1RS485 como salida
     MS2RS485_Direction = 0;                            //Configura el pin MS2RS485 como salida
     TRISA5_bit = 1;                                    //SS1 In
     TRISC3_bit = 1;                                    //SCK1 In
     TRISC4_bit = 1;                                    //SDI1 In
     TRISC5_bit = 0;                                    //SDO1 Out

     INTCON.GIE = 1;                                    //Habilita las interrupciones globales
     INTCON.PEIE = 1;                                   //Habilita las interrupciones perifericas
    
     //Configuracion de SPI en modo esclavo:
     PIE1.SSP1IE = 1;                                   //Activa la interrupcion por SPI
     PIR1.SSP1IF = 0;                                   //Limpia la bandera de interrupcion por SPI *
     SPI1_Init_Advanced(_SPI_SLAVE_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_HIGH_2_LOW);

     //Configuracion del USART:
     PIE1.RC1IE = 1;                                   //Habilita la interrupcion en UART1 receive
     PIR1.RC1IF = 0;                                   //Limpia la bandera de interrupcion UART1
     PIE3.RC2IE = 1;                                   //Habilita la interrupcion en UART2 receive
     PIR3.RC2IF = 0;                                   //Limpia la bandera de interrupcion
     UART1_Init(19200);                                //Inicializa el UART1 a 19200 bps
     UART2_Init(19200);                                //Inicializa el UART2 a 19200 bps

     //Configuracion del TMR1 con un tiempo de 1ms
     //T1CON = 0x01;                                      //Timer1 Input Clock Prescale Select bits
     //TMR1H = 0xF0;
     //TMR1L = 0x60;
     //PIR1.TMR1IF = 0;                                   //Limpia la bandera de interrupcion del TMR1
     //PIE1.TMR1IE = 1;                                   //Habilita la interrupción de desbordamiento TMR1

     Delay_ms(100);                                     //Espera hasta que se estabilicen los cambios
}
//************************************************************************************************************************************
//Funcion para cambiar el estado de las banderas:
void CambiarEstadoBandera(unsigned short bandera, unsigned short estado){

     if (estado==1){
         //Cambia el estado de todas las baderas para evitar posibles interferencias
         banSPI0 = 3;
         banSPI1 = 3;
         //Activa la bandera requerida:
         switch (bandera){
                case 0:
                     banSPI0 = 1;
                     break;
                case 1:
                     banSPI1 = 1;
                     break;
         }
     }
     //Limpia todas las banderas de comunicacion SPI:
     if (estado==0){
         banSPI0 = 0;
         banSPI1 = 0;
     }
}
//*****************************************************************************************************************************************
//Funcion para enviar la respuesta a la RPi por SPI
void ResponderSPI(unsigned char *cabeceraRespuesta, unsigned char *payloadRespuesta){

     //Llena la trama de respuesta con los datos de cabecera:
     tramaRespuestaSPI[0] = cabeceraRespuesta[0];
     tramaRespuestaSPI[1] = cabeceraRespuesta[1];
     tramaRespuestaSPI[2] = cabeceraRespuesta[2];
     tramaRespuestaSPI[3] = cabeceraRespuesta[3];

     //Llena la trama de respuesta con los datos del payload:
     for (j=0;j<(cabeceraRespuesta[3]);j++){
         tramaRespuestaSPI[j+4] = payloadRespuesta[j];
     }

     //Genera el pulso RP0 para producir la interrupcion externa en la RPi:
     RP0 = 1;
     Delay_us(100);
     RP0 = 0;

}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////// Interrupciones ///////////////////////////////////////////////////////////////
void interrupt(void){

//********************************************************************************************************************************************
//Interrupcion por desbordamiento del Timer1
    /*if (TMR1IF_bit==1){
        TEST = ~TEST;
        TMR1IF_bit = 0;                                       //Limpia la bandera de interrupcion por desbordamiento del TMR1
        //T1CON.TMR1ON = 0;                                     //Apaga el Timer1
        //Reinicia el Timer1:
        TMR1H = 0xF0;
        TMR1L = 0x60;
    }*/
//********************************************************************************************************************************************

//********************************************************************************************************************************************
// Interrupcion por SPi //
    if (SSP1IF_bit==1){
    
       SSP1IF_bit = 0;                                                          //Limpia la bandera de interrupcion por SPI
       bufferSPI = SSP1BUF;                                                     //Guarda el contenido del bufeer (lectura)
       TEST = ~TEST;


       //Rutina para enviar la trama de respuesta a la RPi  (C:0xA0   F:0xF0)
       if ((banSPI0==0)&&(bufferSPI==0xA0)) {
          SSP1BUF = tramaRespuestaSPI[0];                                       //Carga en el buffer el primer elemento de la cabecera (id)
          i = 1;
          CambiarEstadoBandera(0,1);                                            //Activa la bandera
       }
       if ((banSPI0==1)&&(bufferSPI!=0xA0)&&(bufferSPI!=0xF0)){
          SSP1BUF = tramaRespuestaSPI[i];                                       //Se envia la trama de respuesta
          i++;
          
       }
       if ((banSPI0==1)&&(bufferSPI==0xF0)){
          CambiarEstadoBandera(0,0);                                            //Limpia las banderas
       }
       
       //Rutina para recibir la trama de solicitud (C:0xA1   F:0xF1):
       if ((banSPI1==0)&&(bufferSPI==0xA1)){
          i = 0;                                                                //Limpia el subindice para guardar la trama SPI
          CambiarEstadoBandera(1,1);                                            //Activa la bandera banSPI1
       }
       if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
          tramaSolicitudSPI[i] = bufferSPI;                                     //Recupera la trama de solicitud SPI
          i++;
       }
       if ((banSPI1==1)&&(bufferSPI==0xF1)){
          //Recupera los datos de cabecera de la solicitud:
          for (j=0;j<4;j++){
              cabeceraSolicitud[j] = tramaSolicitudSPI[j];
          }
          //Recupera los datos de payload de la solicitud:
          for (j=0;j<(cabeceraSolicitud[3]);j++){
              payloadSolicitud[j] = tramaSolicitudSPI[4+j];
          }
          
          //Recupera los datos de la cabecera:
          idSolicitud = cabeceraSolicitud[0];
          funcionSolicitud = cabeceraSolicitud[1];
          subFuncionSolicitud = cabeceraSolicitud[2];
          
          //Comprueba si se solicito una funcion de testeo:
          if (funcionSolicitud!=4){
             //Renvia la trama de solicitud a traves de RS485:
             EnviarTramaRS485(1, cabeceraSolicitud, payloadSolicitud);
             EnviarTramaRS485(2, cabeceraSolicitud, payloadSolicitud);
          } else {
             if (subfuncionSolicitud==1){
                //Realiza el testeo de la comunicacion SPI:
                TEST = ~TEST;
                cabeceraSolicitud[3] = 10;                                      //Actualiza el numero de datos para hacer el test
                ResponderSPI(cabeceraSolicitud, tramaPruebaSPI);
             } else {
                //Renvia la trama de solicitud a traves de RS485:
                EnviarTramaRS485(1, cabeceraSolicitud, payloadSolicitud);
                EnviarTramaRS485(2, cabeceraSolicitud, payloadSolicitud);
             }
          }

          CambiarEstadoBandera(1,0);                                            //Limpia la bandera
       
       }
       
    }
//********************************************************************************************************************************************

//********************************************************************************************************************************************
// Interrupcion por UART1 //
    if (RC1IF_bit==1){
    
       RC1IF_bit = 0;                                                           //Limpia la bandera de interrupcion
       byteRS485 = UART1_Read();

       //Recupera el pyload de la trama RS485:                                  //Aqui deberia entrar despues de recuperar la cabecera de trama
       if (banRSI==2){
          //Recupera el pyload de final de trama:
          if (i_rs485<(numDatosRS485)){
             inputPyloadRS485[i_rs485] = byteRS485;
             i_rs485++;
          } else {
             banRSI = 0;                                                        //Limpia la bandera de inicio de trama
             banRSC = 1;                                                        //Activa la bandera de trama completa
          }
       }

       //Recupera la cabecera de la trama RS485:                                //Aqui deberia entrar primero cada vez que se recibe una trama nueva
       if ((banRSI==0)&&(banRSC==0)){
          if (byteRS485==0x3A){                                                 //Verifica si el primer byte recibido sea el byte de inicio de trama
             banRSI = 1;
             i_rs485 = 0;
          }
       }
       if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<4)){
          tramaCabeceraRS485[i_rs485] = byteRS485;                              //Recupera los datos de cabecera de la trama UART: [Direccion, Funcion, Subfuncion, NumeroDatos]
          i_rs485++;
       }
       if ((banRSI==1)&&(i_rs485==4)){
          //Comprueba la direccion del nodo solicitado:
          if (tramaCabeceraRS485[0]==idSolicitud){
             //Recupera la funcion, la subfuncion y el numero de datos:
             funcionRS485 = tramaCabeceraRS485[1];
             subFuncionRS485 = tramaCabeceraRS485[2];
             numDatosRS485 = tramaCabeceraRS485[3];
             idSolicitud = 0;                                                   //Encera el idSolicitud
             i_rs485 = 0;                                                       //Encera el subindice para almacenar el payload
             banRSI = 2;                                                        //Cambia el valor de la bandera para salir del bucle

          } else {
             banRSI = 0;
             banRSC = 0;
             i_rs485 = 0;
          }
       }

       //Realiza el procesamiento de la informacion del  pyload:                  //Aqui se realiza cualquier accion con el pyload recuperado
       if (banRSC==1){
          TEST = ~TEST;
          ResponderSPI(tramaCabeceraRS485, inputPyloadRS485);
          //Limpia la bandera de trama completa:
          banRSC = 0;
       }
    
    }
//********************************************************************************************************************************************

//********************************************************************************************************************************************
// Interrupcion por UART2 //
    if (RC2IF_bit==1){
    
       RC2IF_bit = 0;                                                           //Limpia la bandera de interrupcion
       /*
       byteRS485 = UART2_Read();

       //Recupera el pyload de la trama RS485:                                  //Aqui deberia entrar despues de recuperar la cabecera de trama
       if (banRSI==2){
          //Recupera el pyload de final de trama:
          if (i_rs485<(numDatosRS485)){
             inputPyloadRS485[i_rs485] = byteRS485;
             i_rs485++;
          } else {
             banRSI = 0;                                                        //Limpia la bandera de inicio de trama
             banRSC = 1;                                                        //Activa la bandera de trama completa
          }
       }

       //Recupera la cabecera de la trama RS485:                                //Aqui deberia entrar primero cada vez que se recibe una trama nueva
       if ((banRSI==0)&&(banRSC==0)){
          if (byteRS485==0x3A){                                                 //Verifica si el primer byte recibido sea el byte de inicio de trama
             banRSI = 1;
             i_rs485 = 0;
          }
       }
       if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<4)){
          tramaCabeceraRS485[i_rs485] = byteRS485;                              //Recupera los datos de cabecera de la trama UART: [Direccion, Funcion, Subfuncion, NumeroDatos]
          i_rs485++;
       }
       if ((banRSI==1)&&(i_rs485==4)){
          //Comprueba la direccion del nodo solicitado:
          if (tramaCabeceraRS485[0]==idSolicitud){
             //Recupera la funcion, la subfuncion y el numero de datos:
             funcionRS485 = tramaCabeceraRS485[1];
             subFuncionRS485 = tramaCabeceraRS485[2];
             numDatosRS485 = tramaCabeceraRS485[3];
             idSolicitud = 0;                                                   //Encera el idSolicitud
             i_rs485 = 0;                                                       //Encera el subindice para almacenar el payload
             banRSI = 2;                                                        //Cambia el valor de la bandera para salir del bucle

          } else {
             banRSI = 0;
             banRSC = 0;
             i_rs485 = 0;
          }
       }

       //Realiza el procesamiento de la informacion del  pyload:                  //Aqui se realiza cualquier accion con el pyload recuperado
       if (banRSC==1){
          TEST = ~TEST;
          ResponderSPI(tramaCabeceraRS485, inputPyloadRS485);
          //Limpia la bandera de trama completa:
          banRSC = 0;
       }
       */
    }
//********************************************************************************************************************************************

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////