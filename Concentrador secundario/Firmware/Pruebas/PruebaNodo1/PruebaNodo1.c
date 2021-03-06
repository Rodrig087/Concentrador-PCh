/*-------------------------------------------------------------------------------------------------------------------------
Autor: Milton Munoz
Fecha de creacion: 21/08/25
Configuracion: PIC18F25k22 XT=16MHz
Observaciones:

---------------------------------------------------------------------------------------------------------------------------*/

////////////////////////////////////////////////////         Librerias         /////////////////////////////////////////////////////////////
#include <RS485.c>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Credenciales (Esto iria en los nodos):
#define IDNODO 5                                                                //Direccion del nodo

////////////////////////////////////////////// Declaracion de variables y costantes ///////////////////////////////////////////////////////
//Definicion de pines:
sbit TEST at LATC4_bit;                                                         //Definicion del pin de indicador auxiliar para hacer pruebas
sbit TEST_Direction at TRISC4_bit;
sbit MS2RS485 at LATC5_bit;                                                     //**Es importante definir los dos pines MS del RS485
sbit MS2RS485_Direction at TRISC5_bit;                                          //**Si solo se utiliza uno, se debe sobrescribir al momento de definir el pin
sbit MS1RS485 at LATC5_bit;                                                     //Definicion del pin MS1 RS485
sbit MS1RS485_Direction at TRISC5_bit;
//Subindices:
unsigned int i, j, x, y;
//Variables para manejo del RS485:
unsigned char banRSI, banRSC;                                                  //Banderas de control de inicio de trama y trama completa
unsigned char byteRS485;
unsigned int i_rs485;                                                           //Indice
unsigned char tramaCabeceraRS485[5];                                            //Vector para almacenar los datos de cabecera de la trama RS485: [0x3A, Direccion, Funcion, NumeroDatos]
unsigned char inputPyloadRS485[15];                                             //Vector para almacenar el pyload de la trama RS485 recibida
unsigned char outputPyloadRS485[710];                                           //Vector para almacenar el pyload de la trama RS485 a enviar
unsigned char direccionRS485, funcionRS485, subFuncionRS485;
unsigned int numDatosRS485;
unsigned char *ptrNumDatosRS485;
unsigned char tramaPruebaRS485[10]= {0xB, 0xB, 0xB, 0xB, 0xB, 0xB, 0xB, 0xB, 0xB, IDNODO};   //Trama de 10 elementos para probar la comunicacion RS485
//unsigned char tramaPruebaRS485[10];
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////  Declaracion de funciones  /////////////////////////////////////////////////////////
void ConfiguracionPrincipal();
void interrupt(void);
void GenerarTramaPrueba(unsigned int, unsigned char);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////      Main      ////////////////////////////////////////////////////////////////
void main() {

     ConfiguracionPrincipal();

     //Inicializacion de variables:
     //Subindices:
     i = 0;
     j = 0;
     x = 0;
     y = 0;

     //Comunicacion RS485:
     banRSI = 0;
     banRSC = 0;
     byteRS485 = 0;
     i_rs485 = 0;
     funcionRS485 = 0;
     subFuncionRS485 = 0;
     numDatosRS485 = 0;
     ptrNumDatosRS485 = (unsigned char *) & numDatosRS485;
     MS1RS485 = 0;
     //MS2RS485 = 0;

     //Puertos:
     TEST = 1;

     //Entra al bucle princial del programa:
     /*
     while(1){
              TEST = ~TEST;
              Delay_ms(250);
     }
     */
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
     MS1RS485_Direction = 0;                            //Configura el pin MS1RS485 como salida

     INTCON.GIE = 1;                                    //Habilita las interrupciones globales
     INTCON.PEIE = 1;                                   //Habilita las interrupciones perifericas

     //Configuracion del USART:
     PIE1.RC1IE = 1;                                   //Habilita la interrupcion en UART1 receive
     PIR1.RC1IF = 0;                                   //Limpia la bandera de interrupcion UART1
     UART1_Init(19200);                                //Inicializa el UART1 a 19200 bps

     Delay_ms(100);                                     //Espera hasta que se estabilicen los cambios

}

//*****************************************************************************************************************************************
// Funcion para realizar la configuracion principal
void GenerarTramaPrueba(unsigned int numDatosResp, unsigned char *cabeceraRespuesta){

     unsigned int contadorMuestras = 0;

     //Llena la trama de respuesta con los datos del payload:
     for (j=0;j<numDatosResp;j++){
         outputPyloadRS485[j] = contadorMuestras;
         contadorMuestras++;
         if (contadorMuestras>255) {
           contadorMuestras = 0;
         }
     }

     EnviarTramaRS485(1, cabeceraRespuesta, outputPyloadRS485);


}

//************************************************************************************************************************************

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////// Interrupciones ///////////////////////////////////////////////////////////////
void interrupt(void){

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
       if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<5)){
          tramaCabeceraRS485[i_rs485] = byteRS485;                              //Recupera los datos de cabecera de la trama UART: [Direccion, Funcion, Subfuncion, NumeroDatos]
          i_rs485++;
       }
       if ((banRSI==1)&&(i_rs485==5)){
          //Comprueba la direccion del solicitado:
          if (tramaCabeceraRS485[0]==IDNODO){
             //Recupera la funcion, la subfuncion y el numero de datos:
             funcionRS485 = tramaCabeceraRS485[1];
             subFuncionRS485 = tramaCabeceraRS485[2];
             *(ptrNumDatosRS485) = tramaCabeceraRS485[3];
             *(ptrNumDatosRS485+1) = tramaCabeceraRS485[4];
             banRSI = 2;
             i_rs485 = 0;
          } else {
             banRSI = 0;
             banRSC = 0;
             i_rs485 = 0;
          }
       }

       //Realiza el procesamiento de la informacion del  pyload:                  //Aqui se realiza cualquier accion con el pyload recuperado
       if (banRSC==1){
          
          TEST = ~TEST;
          Delay_ms(250);
          
          //Comprueba si se solicito una funcion de testeo:
          if (funcionRS485==2){
             //Renvia la trama de solicitud a traves de RS485:
             //Prueba
             numDatosRS485 = 5;
             tramaCabeceraRS485[3] = *(ptrNumDatosRS485);
             tramaCabeceraRS485[4] = *(ptrNumDatosRS485+1);
             //Fin prueba
             EnviarTramaRS485(1, tramaCabeceraRS485, inputPyloadRS485);
          } 
          if (funcionRS485==4){
             if (subFuncionRS485==2){
                //Realiza el testeo de la comunicacion RS485:
                numDatosRS485 = 10;
                tramaCabeceraRS485[3] = *(ptrNumDatosRS485);
                tramaCabeceraRS485[4] = *(ptrNumDatosRS485+1);
                EnviarTramaRS485(1, tramaCabeceraRS485, tramaPruebaRS485);
             }
             if (subFuncionRS485==3){
                //Envia una trama de respuesta con N numeros des muestras:
                numDatosRS485 = 700;
                tramaCabeceraRS485[3] = *(ptrNumDatosRS485);
                tramaCabeceraRS485[4] = *(ptrNumDatosRS485+1);
                GenerarTramaPrueba(numDatosRS485, tramaCabeceraRS485);
             }
          }

          banRSC = 0;

       }



    }
//********************************************************************************************************************************************

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////