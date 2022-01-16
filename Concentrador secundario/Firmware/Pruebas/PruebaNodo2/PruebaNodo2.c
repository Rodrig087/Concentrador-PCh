/*-------------------------------------------------------------------------------------------------------------------------
Autor: Milton Munoz
Fecha de creacion: 21/02/2017
Ultima modificacion: 21/02/2017
Configuracion: PIC18F25k22 XT=20MHz
Descripcion:

---------------------------------------------------------------------------------------------------------------------------*/

////////////////////////////////////////////////////         Librerias         /////////////////////////////////////////////////////////////
#include <RS485.c>
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////// Declaracion de variables y constantes ///////////////////////////////////////////////////////
#define IDNODO 5

//Definicion de pines:
sbit TEST at LATC4_bit;                                                         //Definicion del pin de indicador auxiliar para hacer pruebas
sbit TEST_Direction at TRISC4_bit;
sbit MS1RS485 at LATC5_bit;                                                     //Definicion del pin MS1 RS485
sbit MS1RS485_Direction at TRISC5_bit;


//Variables para la peticion y respuesta de datos

const short Psize = 6;                                  //Constante de longitud de trama de Peticion
//const short Rsize = 6;                                  //Constante de longitud de trama de Respuesta
const short Hdr = 0x3A;                                 //Constante de delimitador de inicio de trama
//const short End = 0x0D;                                 //Constante de delimitador de final de trama
unsigned char Ptcn[Psize];                              //Vector de trama de peticion
//unsigned char Rspt[Rsize];                              //Vector de trama de respuesta
short ip;                                 //Subindices para las tramas de peticion y respuesta
unsigned short BanLP;                            //Banderas de lectura de tramas de peticion y respuesta
unsigned short BanAP;                            //Banderas de almacenamiento de tramas de peticion y respuesta
unsigned short ByPtcn;                          //Bytes de peticion y respuesta




/////////////////////////////////////////////////////////  Declaracion de funciones  /////////////////////////////////////////////////////////
void ConfiguracionPrincipal();
void interrupt(void);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////      Main      ////////////////////////////////////////////////////////////////
void main() {

    ConfiguracionPrincipal();

    //Puertos:
    TEST = 1;

    //Entra al bucle princial del programa:
    while(1){
             TEST = ~TEST;
             Delay_ms(250);
    }

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Configuracion //
void ConfiguracionPrincipal(){

     //Configuracion oscilador
     OSCCON.IDLEN=1;                                    //Entra en modo IDLE durante la instruccion SLEEP
     OSCCON.IRCF2=1;                                    //HFINTOSC=16MHz  IRFC=111
     OSCCON.IRCF1=1;
     OSCCON.IRCF0=1;
     OSCCON.SCS1=1;                                     //System Clock Select bit:  1x=Internal oscillator block
     OSCCON.SCS0=1;

     //Configuracion de puertos:
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

////////////////////////////////////////////////////////////// Interrupciones //////////////////////////////////////////////////////////////
void interrupt(void){
//Interrupcion UART1
     if(PIR1.F5==1){
        /*
        RC4_bit = 1;
        ByPtcn = UART1_Read();                     //Lee el byte de peticion
        if ((ByPtcn==Hdr)&&(ip==0)){               //Verifica que el primer dato en llegar sea el identificador de inicio de trama
           BanAP = 1;                              //Activa la bandera de almacenamiento de trama de peticion
           Ptcn[ip] = ByPtcn;                      //Almacena el Dato en la trama de peticion
        }
        if ((ByPtcn!=Hdr)&&(ip==0)){               //Verifica si el primer dato en llegar es diferente del identificador del inicio de trama
           ip=-1;                                  //Si es asi, reduce el subindice en una unidad
        }
        if ((BanAP==1)&&(ip!=0)){
           Ptcn[ip] = ByPtcn;                      //Almacena el resto de datos en la trama de peticion si la bandera de almacenamiento de trama esta activada
        }
        ip++;                                      //Aumenta el subindice una unidad
        if (ip==Psize){                            //Verifica que se haya terminado de llenar la trama de peticion
           BanLP = 1;                              //Habilita la bandera de lectura de peticion
           BanAP = 0;                              //Limpia la bandera de almacenamiento de trama de peticion
           ip=0;                                   //Limpia el subindice de la trama de peticion para permitir una nueva secuencia de recepcion de datos
        }
        RC4_bit = 0;
        */
        PIR1.F5 = 0;                               //Limpia la bandera de interrupcion de UART1

     }

}