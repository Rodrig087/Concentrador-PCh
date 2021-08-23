/*-------------------------------------------------------------------------------------------------------------------------
Autor: Milton Munoz
Fecha de creacion: 21/08/03
Configuracion: PIC18F25k22 XT=20MHz
Observaciones:

---------------------------------------------------------------------------------------------------------------------------*/

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Credenciales (Esto iria en los nodos):
#define IDNODO 3                                                                //Direccion del nodo

////////////////////////////////////////////// Declaracion de variables y costantes ///////////////////////////////////////////////////////
//Definicion de pines:
sbit RP0 at LATC0_bit;                                                          //Definicion del pin P1
sbit RP0_Direction at TRISC0_bit;
sbit TEST at RB2_bit;                                                           //Definicion del pin de indicador auxiliar para hacer pruebas
sbit TEST_Direction at TRISB2_bit;
//Subindices:
unsigned int i, j, x, y;
//Variables para la comunicacion SPI:
unsigned short bufferSPI;
unsigned short banSPI0, banSPI1;
unsigned char tramaSolicitudSPI[10];                                            //Vector para almacenar los datos de solicitud que envia la RPi a traves del SPI
//Variables para manejo del RS485:
unsigned short direccionSol, funcionSol, subFuncionSol, numDatosSol;
unsigned char cabeceraSolicitud[4];                                                   //Vector para almacenar la cabecera de la trama RS485 a enviar
unsigned char payloadSolicitud[15];                                                   //Vector para almacenar el pyload de la trama RS485 a enviar
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////  Declaracion de funciones  /////////////////////////////////////////////////////////
void ConfiguracionPrincipal();
void CambiarEstadoBandera(unsigned short bandera, unsigned short estado);
void ResponderSPI(unsigned char *cabeceraRespuesta, unsigned char *payloadRespuesta);
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
    //Comunicacion SPI:
    banSPI0 = 0;
    banSPI1 = 0;
    //Comunicacion RS485:
    direccionSol = 0;
    funcionSol = 0;
    subFuncionSol = 0;
    numDatosSol = 0;
    //Puertos:
    RP0 = 0;
    TEST = 1;
    
    //Entra al bucle princial del programa:
    //while(1){
             //TEST = ~TEST;
             //Delay_ms(80);
    //}
     



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
     TRISA5_bit = 1;                                    //SS1 In
     TRISC3_bit = 1;                                    //SCK1 In
     TRISC4_bit = 1;                                    //SDI1 In
     TRISC5_bit = 0;                                    //SDO1 Out

     INTCON.GIE = 1;                                    //Habilita las interrupciones globales
     INTCON.PEIE = 1;                                   //Habilita las interrupciones perifericas
    
     //Configuracion de SPI en modo esclavo:
     SSP1IE_bit = 1;
     SPI1_Init_Advanced(_SPI_SLAVE_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_HIGH_2_LOW);
     SSP1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI *


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
//Interrupcion por SPi:
    if (SSP1IF_bit==1){
    
       SSP1IF_bit = 0;                                                          //Limpia la bandera de interrupcion por SPI
       bufferSPI = SSP1BUF;                                                     //Guarda el contenido del bufeer (lectura)
       
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
          
          //Prueba: Cambia el estado del led si coincide el Id de la peticion
           if ((payloadSolicitud[1])==0xEE){
              TEST = ~TEST;
              ResponderSPI(cabeceraSolicitud, payloadSolicitud);
           }
          //Fin Prueba
          
          CambiarEstadoBandera(1,0);                                            //Limpia la bandera
       }
       
       //Rutina para enviar la trama de respuesta (C:0xA0   F:0xF0):


    
    }

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////