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

////////////////////////////////////////////// Declaracion de variables y costantes ///////////////////////////////////////////////////////
//Definicion de pines:
sbit RP0 at LATC0_bit;                                                          //Definicion del pin P1
sbit RP0_Direction at TRISC0_bit;
sbit LED1 at RB2_bit;                                                           //Definicion del pin LED1
sbit LED1_Direction at TRISB2_bit;
sbit LED2 at RB4_bit;                                                           //Definicion del pin LED1
sbit LED2_Direction at TRISB4_bit;
sbit MS1RS485 at LATB3_bit;                                                     //Definicion del pin MS1 RS485
sbit MS1RS485_Direction at TRISB3_bit;
sbit MS2RS485 at LATB5_bit;                                                     //Definicion del pin MS1 RS485
sbit MS2RS485_Direction at TRISB5_bit;
//Subindices:
unsigned int i, j, x, y;
//Variables para la comunicacion SPI:
unsigned char bufferSPI;
unsigned char banSPI0, banSPI1, banSPI2, banSPI3;
unsigned char tramaSolicitudSPI[20];                                            //Vector para almacenar los datos de solicitud que envia la RPi a traves del SPI
unsigned char cabeceraRespuestaSPI[10];
unsigned char idSolicitud;                                                     //Variable para almacenar el id del nodo al que se hizo la solicitud
unsigned char funcionSolicitud;                                                //Variable para almacenar la funcion solicitada
unsigned char subFuncionSolicitud;                                             //Variable para almacenar la subfuncion solicitada
unsigned char cabeceraSolicitud[10];                                             //Vector para almacenar la cabecera de la trama RS485 a enviar
unsigned char payloadSolicitud[10];                                              //Vector para almacenar el pyload de la trama RS485 a enviar
unsigned char tramaPruebaSPI[10]= {0xA0, 0xA1, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6, 0xA7, 0xA8, 0xA9};
//Variables para la comunicacion RS485:
unsigned char banRSI, banRSC, banRSI2, banRSC2;                                //Banderas de control de inicio de trama y trama completa
unsigned char byteRS485, byteRS4852;
unsigned int i_rs485, i_rs4852;                                                 //Subindice
unsigned char tramaCabeceraRS485[10];                                            //Vector para almacenar los datos de cabecera de la trama RS485: [0x3A, Direccion, Funcion, NumeroDatos]
unsigned char pyloadRS485[770];                                                 //Vector para almacenar el pyload de la trama RS485 recibida. **Este PIC soporta una trama maxima de 1300 bytes
unsigned char direccionRS485, funcionRS485, subFuncionRS485;
unsigned int numDatosRS485;
unsigned char *ptrNumDatosRS485;
//Variable para una suma de verificacion:
unsigned char sumValidacion;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////  Declaracion de funciones  /////////////////////////////////////////////////////////
void ConfiguracionPrincipal();
void CambiarEstadoBandera(unsigned char, unsigned char);
void ResponderSPI(unsigned char);
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
    banSPI2 = 0;
    banSPI3 = 0;
    bufferSPI = 0;
    idSolicitud = 0;
    funcionSolicitud = 0;
    subFuncionSolicitud = 0;
    //Comunicacion RS485:
    banRSI = 0;
    banRSI2 = 0;
    banRSC = 0;
    banRSC2 = 0;
    byteRS485 = 0;
    byteRS4852 = 0;
    i_rs485 = 0;
    i_rs4852 = 0;
    funcionRS485 = 0;
    subFuncionRS485 = 0;
    numDatosRS485 = 0;
    ptrNumDatosRS485 = (unsigned char *) & numDatosRS485;
    MS1RS485 = 0;
    MS2RS485 = 0;
    sumValidacion = 0;
    //Puertos:
    RP0 = 0;
    LED1 = 0;
    LED2 = 0;
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

     LED1_Direction = 0;                                //Configura el pin LED1 como salida
     LED2_Direction = 0;                                //Configura el pin LED1 como salida
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
void CambiarEstadoBandera(unsigned char bandera, unsigned char estado){

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
                case 2:
                     banSPI2 = 1;
                     break;
                case 3:
                     banSPI3 = 1;
                     break;
         }
     }
     //Limpia todas las banderas de comunicacion SPI:
     if (estado==0){
         banSPI0 = 0;
         banSPI1 = 0;
         banSPI2 = 0;
         banSPI3 = 0;
     }
}
//*****************************************************************************************************************************************
//Funcion para enviar la respuesta a la RPi por SPI
void ResponderSPI(unsigned char *cabeceraRespuesta){

     //Llena la trama de respuesta con los datos de cabecera:
     cabeceraRespuestaSPI[0] = cabeceraRespuesta[0];
     cabeceraRespuestaSPI[1] = cabeceraRespuesta[1];
     cabeceraRespuestaSPI[2] = cabeceraRespuesta[2];
     cabeceraRespuestaSPI[3] = cabeceraRespuesta[3];
     cabeceraRespuestaSPI[4] = cabeceraRespuesta[4];

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
        LED1 = ~LED1;
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

       //************************************************************************************************************************************
       //Rutina de Solcitud:
       //Rutina para recibir la trama de solicitud (C:0xA0   F:0xF0):
       if ((banSPI0==0)&&(bufferSPI==0xA0)){
          i = 0;                                                                //Limpia el subindice para guardar la trama SPI
          CambiarEstadoBandera(0,1);                                            //Activa la bandera 0
          LED1 = 1;
          LED2 = 1;
       }
       if ((banSPI0==1)&&(bufferSPI!=0xA0)&&(bufferSPI!=0xF0)){
          tramaSolicitudSPI[i] = bufferSPI;                                     //Recupera la trama de solicitud SPI
          i++;
       }
       if ((banSPI0==1)&&(bufferSPI==0xF0)){
          //Recupera la cabecera de la solicitud:
          for (j=0;j<5;j++){
              cabeceraSolicitud[j] = tramaSolicitudSPI[j];
          }
          //Recupera los datos de la cabecera:
          idSolicitud = cabeceraSolicitud[0];
          funcionSolicitud = cabeceraSolicitud[1];
          subFuncionSolicitud = cabeceraSolicitud[2];
          *(ptrNumDatosRS485) = cabeceraSolicitud[3];
          *(ptrNumDatosRS485+1) = cabeceraSolicitud[4];
          //Recupera los datos de payload de la solicitud:
          for (j=0;j<numDatosRS485;j++){
              payloadSolicitud[j] = tramaSolicitudSPI[5+j];
          }
          //Comprueba si se solicito una tarea al concentrador (Id=0):
          if (idSolicitud==0){
               if (funcionSolicitud==4){
                    numDatosRS485 = 10;                                         //Actualiza el numero de datos para hacer el test
                    cabeceraSolicitud[3] = *(ptrNumDatosRS485);
                    cabeceraSolicitud[4] = *(ptrNumDatosRS485+1);
                    ResponderSPI(cabeceraSolicitud);
               }
          } else {
               //Renvia la trama de solicitud a traves de RS485:
               EnviarTramaRS485(1, cabeceraSolicitud, payloadSolicitud);
               EnviarTramaRS485(2, cabeceraSolicitud, payloadSolicitud);

          }
          CambiarEstadoBandera(0,0);                                            //Limpia la bandera 0
          LED1 = 0;
          LED2 = 0;

       }
       //************************************************************************************************************************************

       //************************************************************************************************************************************
       //Rutinas de Respuesta:
       //Envia la cabecera de respuesta a la RPi  (C:0xA1   F:0xF1)
       if ((banSPI1==0)&&(bufferSPI==0xA1)) {
          SSP1BUF = cabeceraRespuestaSPI[0];                                       //Carga en el buffer el primer elemento de la cabecera (id)
          i = 1;
          CambiarEstadoBandera(1,1);                                            //Activa la bandera 1
       }
       if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
          SSP1BUF = cabeceraRespuestaSPI[i];                                       //Se envia la trama de respuesta
          i++;
       }
       if ((banSPI1==1)&&(bufferSPI==0xF1)){
          CambiarEstadoBandera(1,0);                                            //Limpia la bandera 1
       }
       //Envia el contenido del pyload de la trama RS485 a la RPi (C:0xA2   F:0xF2):
       if ((banSPI2==0)&&(bufferSPI==0xA2)){
          CambiarEstadoBandera(2,1);                                            //Activa la bandera 2
          SSP1BUF = pyloadRS485[0];
          i = 1;
       }
       if ((banSPI2==1)&&(bufferSPI!=0xA2)&&(bufferSPI!=0xF2)){
          SSP1BUF = pyloadRS485[i];
          i++;
       }
       if ((banSPI2==1)&&(bufferSPI==0xF2)){
          CambiarEstadoBandera(2,0);                                            //Limpia la bandera 2
       }
       //Envia la trama de prueba SPI (C:0xA3   F:0xF3):
       if ((banSPI3==0)&&(bufferSPI==0xA3)){
          CambiarEstadoBandera(3,1);                                            //Activa la bandera 3
          SSP1BUF = tramaPruebaSPI[0];
          i = 1;
       }
       if ((banSPI3==1)&&(bufferSPI!=0xA3)&&(bufferSPI!=0xF3)){
          SSP1BUF = tramaPruebaSPI[i];
          i++;
       }
       if ((banSPI3==1)&&(bufferSPI==0xF3)){
          CambiarEstadoBandera(3,0);                                            //Limpia la bandera 3
       }
       //************************************************************************************************************************************
       
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
             pyloadRS485[i_rs485] = byteRS485;
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
             LED1 = 1;
          }
       }
       if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<5)){
          tramaCabeceraRS485[i_rs485] = byteRS485;                              //Recupera los datos de cabecera de la trama UART: [Direccion, Funcion, Subfuncion, NumeroDatos]
          i_rs485++;
       }
       if ((banRSI==1)&&(i_rs485==5)){
          //Comprueba la direccion del nodo solicitado:
          if (tramaCabeceraRS485[0]==idSolicitud){
             //Recupera la funcion, la subfuncion y el numero de datos:
             funcionRS485 = tramaCabeceraRS485[1];
             subFuncionRS485 = tramaCabeceraRS485[2];
             *(ptrNumDatosRS485) = tramaCabeceraRS485[3];
             *(ptrNumDatosRS485+1) = tramaCabeceraRS485[4];
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
          LED1 = 0;
          ResponderSPI(tramaCabeceraRS485);
          //Limpia la bandera de trama completa:
          banRSC = 0;
       }
    
    }
//********************************************************************************************************************************************

//********************************************************************************************************************************************
// Interrupcion por UART2 //
    if (RC2IF_bit==1){
    
       RC2IF_bit = 0;                                                           //Limpia la bandera de interrupcion
       byteRS4852 = UART2_Read();

       //Recupera el pyload de la trama RS485:                                  //Aqui deberia entrar despues de recuperar la cabecera de trama
       if (banRSI2==2){
          //Recupera el pyload de final de trama:
          if (i_rs4852<(numDatosRS485)){
             pyloadRS485[i_rs4852] = byteRS4852;
             i_rs4852++;
          } else {
             banRSI2 = 0;                                                       //Limpia la bandera de inicio de trama
             banRSC2 = 1;                                                       //Activa la bandera de trama completa
          }
       }

       //Recupera la cabecera de la trama RS485:                                //Aqui deberia entrar primero cada vez que se recibe una trama nueva
       if ((banRSI2==0)&&(banRSC2==0)){
          if (byteRS4852==0x3A){                                                //Verifica si el primer byte recibido sea el byte de inicio de trama
             banRSI2 = 1;
             i_rs4852 = 0;
             LED2 = 1;
          }
       }
       if ((banRSI2==1)&&(byteRS4852!=0x3A)&&(i_rs4852<5)){
          tramaCabeceraRS485[i_rs4852] = byteRS4852;                            //Recupera los datos de cabecera de la trama UART: [Direccion, Funcion, Subfuncion, NumeroDatos]
          i_rs4852++;
       }
       if ((banRSI2==1)&&(i_rs4852==5)){
          //Comprueba la direccion del nodo solicitado:
          if (tramaCabeceraRS485[0]==idSolicitud){
             //Recupera la funcion, la subfuncion y el numero de datos:
             funcionRS485 = tramaCabeceraRS485[1];
             subFuncionRS485 = tramaCabeceraRS485[2];
             *(ptrNumDatosRS485) = tramaCabeceraRS485[3];
             *(ptrNumDatosRS485+1) = tramaCabeceraRS485[4];
             idSolicitud = 0;                                                   //Encera el idSolicitud
             i_rs4852 = 0;                                                      //Encera el subindice para almacenar el payload
             banRSI2 = 2;                                                       //Cambia el valor de la bandera para salir del bucle

          } else {
             banRSI2 = 0;
             banRSC2 = 0;
             i_rs4852 = 0;
          }
       }

       //Realiza el procesamiento de la informacion del  pyload:                //Aqui se realiza cualquier accion con el pyload recuperado
       if (banRSC2==1){
          LED2 = 0;
          ResponderSPI(tramaCabeceraRS485);
          //Limpia la bandera de trama completa:
          banRSC2 = 0;
       }

    }
//********************************************************************************************************************************************

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////