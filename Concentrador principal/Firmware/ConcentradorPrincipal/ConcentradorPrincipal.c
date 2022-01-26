/*-------------------------------------------------------------------------------------------------------------------------
Autor: Milton Munoz, email: miltonrodrigomunoz@gmail.com, github: https://github.com/Rodrig087/SaludEstructuralCS.git
Fecha de creacion: 12/01/2022
Configuracion: dsPIC33EP256MC202, XT=80MHz
---------------------------------------------------------------------------------------------------------------------------*/


////////////////////////////////////////////////////         Librerias         /////////////////////////////////////////////////////////////

#include <TIEMPO_RTC.c>
#include <TIEMPO_GPS.c>
#include <TIEMPO_RPI.c>
#include <RS485.c>

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////// Declaracion de variables y costantes ///////////////////////////////////////////////////////

//Subindices:
unsigned int i, j, x, y;

//Definicion de pines:
sbit RP1 at LATA4_bit;                                                          //Definicion del pin P1
sbit RP1_Direction at TRISA4_bit;
sbit RP2 at LATA0_bit;                                                          //Definicion del pin P2
sbit RP2_Direction at TRISA0_bit;
sbit MS1RS485 at LATB11_bit;                                                    //Definicion del pin MS RS485
sbit MS1RS485_Direction at TRISB11_bit;
sbit LED1 at LATA1_bit;                                                         //Led TEST
sbit LED1_Direction at TRISA1_bit;

//Variables para manejo del GPS:
unsigned int i_gps;
unsigned char byteGPS, banGPSI, banGPSC;
unsigned char banSetGPS;
unsigned char tramaGPS[70];
unsigned char datosGPS[13];
unsigned char contTimeout1;

//Variables para manejo del tiempo:
unsigned char tiempo[6];                                                        //Vector de datos de tiempo del sistema
unsigned char banSetReloj, banSyncReloj, banRespuestaPi;
unsigned char fuenteReloj;                                                      //Indica la fuente de reloj: 1=GPS, 2=RTC, 3=RPi
unsigned long horaSistema, fechaSistema;
unsigned char referenciaTiempo;                                                 //Variable para la referencia de tiempo solicitada: 1=GPS, 2=RTC
unsigned long horaRPiRTC;
unsigned char tiempoRPiRTC[6];                                                  //Vector para enviar el tiempo local al RTC y a la RPi

//Variables para la comunicacion SPI:
unsigned char bufferSPI;
unsigned char banSPI0, banSPI1, banSPI2, banSPI3, banP1;
unsigned char tramaSolicitudSPI[20];                                            //Vector para almacenar los datos de solicitud que envia la RPi a traves del SPI
unsigned char cabeceraRespuestaSPI[10];
unsigned char payloadConcentrador[10];
unsigned char idSolicitud;                                                     //Variable para almacenar el id del nodo al que se hizo la solicitud
unsigned char funcionSolicitud;                                                //Variable para almacenar la funcion solicitada
unsigned char subFuncionSolicitud;                                             //Variable para almacenar la subfuncion solicitada
unsigned char cabeceraSolicitud[10];                                             //Vector para almacenar la cabecera de la trama RS485 a enviar
unsigned char payloadSolicitud[10];                                              //Vector para almacenar el pyload de la trama RS485 a enviar
unsigned char tramaPruebaSPI[10]= {0xA0, 0xA1, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6, 0xA7, 0xA8, 0xA9};

//Variables para manejo del RS485:
unsigned char banRSI, banRSC, banRSI2, banRSC2;                                //Banderas de control de inicio de trama y trama completa
unsigned char byteRS485, byteRS4852;
unsigned int i_rs485, i_rs4852;                                                 //Subindice
unsigned char tramaCabeceraRS485[10];                                            //Vector para almacenar los datos de cabecera de la trama RS485: [0x3A, Direccion, Funcion, NumeroDatos]
unsigned char pyloadRS485[770];                                                 //Vector para almacenar el pyload de la trama RS485 recibida. **Este PIC soporta una trama maxima de 1300 bytes
unsigned char direccionRS485, funcionRS485, subFuncionRS485;
unsigned int numDatosPayload;
unsigned char *ptrNumDatosPayload;

//Variables para el control del muestreo:
unsigned char banInicioMuestreo;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////  Declaracion de funciones  /////////////////////////////////////////////////////////
void ConfiguracionPrincipal();
void Muestrear();
//void InterrupcionP1(unsigned short funcionSPI, unsigned short subFuncionSPI, unsigned int numBytesSPI);
void EnviarCabeceraRespuesta(unsigned char);
void ProcesarSolicitudConcentrador(unsigned char, unsigned char);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////      Main      ////////////////////////////////////////////////////////////////
void main() {

     ConfiguracionPrincipal();
     GPS_init(1,1);
     DS3234_init();

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
     banP1 = 0;
     bufferSPI = 0;
     idSolicitud = 0;
     funcionSolicitud = 0;
     subFuncionSolicitud = 0;
     
     //RS485:
     banRSI = 0;
     banRSI2 = 0;
     banRSC = 0;
     banRSC2 = 0;
     byteRS485 = 0;
     byteRS4852 = 0;
     i_rs485 = 0;
     funcionRS485 = 0;
     subFuncionRS485 = 0;
     numDatosPayload = 0;
     ptrNumDatosPayload = (unsigned char *) & numDatosPayload;
     MS1RS485 = 0;

     //GPS:
     i_gps = 0;
     byteGPS = 0;
     banGPSI = 0;
     banGPSC = 0;
     banSetGPS = 0;
     contTimeout1 = 0;

     //Tiempo:
     banSetReloj = 0;
     banSyncReloj = 0;
     banRespuestaPi = 0;
     horaSistema = 0;
     fechaSistema = 0;
     fuenteReloj = 0;
     referenciaTiempo = 0;
     horaRPiRTC = 0;

     //Muestreo:
     banInicioMuestreo = 0;

     //Puertos:
     RP1 = 0;                                                                   //Encera el pin de interrupcion de la RPi
     RP2 = 0;                                                                   //Encera el pin de interrupcion de la RPi
     LED1 = 0;                                                                  //Enciende el pin TEST
     MS1RS485 = 0;                                                              //Establece el Max485 en modo de lectura;
     
     //Recupera la hora del RTC:
     fechaSistema = RecuperarFechaRTC();                                        //Recupera la fecha del RTC
     horaSistema = RecuperarHoraRTC();                                          //Recupera la hora del RTC
     AjustarTiempoSistema(horaRPiRTC, fechaSistema, tiempo);                    //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas
     fuenteReloj = 3;                                                           //Fuente de reloj: RTC
     banSetReloj = 1;                                                           //Activa esta bandera para usar la hora/fecha recuperada

     while(1){
              asm CLRWDT;         //Clear the watchdog timer
              Delay_ms(100);
     }

}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////// Funciones ////////////////////////////////////////////////////////////////

//*****************************************************************************************************************************************
// Funcion para realizar la configuracion principal
void ConfiguracionPrincipal(){

     //configuracion del oscilador                                              //FPLLO = FIN*(M/(N1+N2)) = 80.017MHz
     CLKDIVbits.FRCDIV = 0;                                                     //FIN=FRC/1
     CLKDIVbits.PLLPOST = 0;                                                    //N2=2
     CLKDIVbits.PLLPRE = 5;                                                     //N1=7
     PLLFBDbits.PLLDIV = 150;                                                   //M=152

     //Configuracion de puertos
     ANSELA = 0;                                                                //Configura PORTA como digital     *
     ANSELB = 0;                                                                //Configura PORTB como digital     *

     TRISA2_bit = 0;                                                            //RTC_CS
     LED1_Direction = 0;                                                        //INT_SINC
     RP1_Direction = 0;                                                         //RP1
     RP2_Direction = 0;                                                         //RP2
     MS1RS485_Direction = 0;                                                    //MSRS485
     TRISB13_bit = 1;                                                           //SQW
     TRISB14_bit = 1;                                                           //PPS

     INTCON2.GIE = 1;                                                           //Habilita las interrupciones globales *

    //Configuracion del puerto UART1
     RPINR18bits.U1RXR = 0x22;                                                  //Configura el pin RB2/RPI34 como Rx1
     RPOR0bits.RP35R = 0x01;                                                    //Configura el Tx1 en el pin RB3/RP35
     U1RXIE_bit = 1;                                                            //Habilita la interrupcion UART1 RX
     IPC2bits.U1RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
     U1STAbits.URXISEL = 0x00;                                                  //Interrupt is set when any character is received and transferred from the UxRSR to the receive buffer; receive buffer has one or more characters
     UART1_Init(9600);                                                          //Inicializa el UART1 con una velocidad de 9600 baudios

     //Configuracion del puerto UART2
     RPINR19bits.U2RXR = 0x2F;                                                  //Configura el pin RB15/RPI47 como Rx2
     RPOR1bits.RP36R = 0x03;                                                    //Configura el Tx2 en el pin RB4/RP36
     U2RXIE_bit = 1;                                                            //Habilita la interrupcion UART2 RX
     IPC7bits.U2RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
     U2STAbits.URXISEL = 0x00;
     UART2_Init(19200);                                                         //Inicializa el UART2 a 19200 bps

     //Configuracion del puerto SPI1 en modo Esclavo
     SPI1STAT.SPIEN = 1;                                                        //Habilita el SPI1 *
     SPI1_Init_Advanced(_SPI_SLAVE, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_1, _SPI_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
     SPI1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI *
     IPC2bits.SPI1IP = 0x03;                                                    //Prioridad de la interrupcion SPI1

     //Configuracion del puerto SPI2 en modo Master
     RPINR22bits.SDI2R = 0x21;                                                  //Configura el pin RB1/RPI33 como SDI2 *
     RPOR2bits.RP38R = 0x08;                                                    //Configura el SDO2 en el pin RB6/RP38 *
     RPOR1bits.RP37R = 0x09;                                                    //Configura el SCK2 en el pin RB5/RP37 *
     SPI2STAT.SPIEN = 1;                                                        //Habilita el SPI2 *
     SPI2_Init();                                                               //Inicializa el modulo SPI2
     CS_DS3234 = 1;                                                             //Pone en alto el CS del RTC

     //Configuracion de las interrupciones externas INT1 e INT2
     RPINR0 = 0x2D00;                                                           //Asigna INT1 al RB13/RPI45 (SQW)
     RPINR1 = 0x002E;                                                           //Asigna INT2 al RB14/RPI46 (PPS)
     INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
     INT2IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT2
     IPC5bits.INT1IP = 0x02;                                                    //Prioridad en la interrupocion externa INT1
     IPC7bits.INT2IP = 0x01;                                                    //Prioridad en la interrupocion externa INT2

     //Configuracion del TMR1 con un tiempo de 300ms
     T1CON = 0x30;                                                              //Prescalador
     T1CON.TON = 0;                                                             //Apaga el Timer1
     T1IE_bit = 1;                                                              //Habilita la interrupción de desbordamiento TMR1
     T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion del TMR1
     PR1 = 46875;                                                               //Carga el preload para un tiempo de 300ms
     IPC0bits.T1IP = 0x02;                                                      //Prioridad de la interrupcion por desbordamiento del TMR1

     //Configuracion del TMR2 con un tiempo de 300ms
     T2CON = 0x30;                                                              //Prescalador
     T2CON.TON = 0;                                                             //Apaga el Timer2
     T2IE_bit = 1;                                                              //Habilita la interrupción de desbordamiento TMR2
     T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion del TMR2
     PR2 = 46875;                                                               //Carga el preload para un tiempo de 300ms
     IPC1bits.T2IP = 0x02;                                                      //Prioridad de la interrupcion por desbordamiento del TMR2

     //Habilitacion de interrupciones
     SPI1IE_bit = 1;                                                            //SPI1
     INT1IE_bit = 1;                                                            //INT1
     INT2IE_bit = 1;                                                            //INT2

     Delay_ms(200);                                                             //Espera hasta que se estabilicen los cambios

}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Funcion para enviar la respuesta a la RPi por SPI
void EnviarCabeceraRespuesta(unsigned char *cabeceraRespuesta){

     //Llena la trama de respuesta con los datos de cabecera:
     cabeceraRespuestaSPI[0] = cabeceraRespuesta[0];
     cabeceraRespuestaSPI[1] = cabeceraRespuesta[1];
     cabeceraRespuestaSPI[2] = cabeceraRespuesta[2];
     cabeceraRespuestaSPI[3] = cabeceraRespuesta[3];
     cabeceraRespuestaSPI[4] = cabeceraRespuesta[4];

     //Genera el pulso RP1 para producir la interrupcion externa en la RPi:
     RP1 = 1;
     Delay_us(100);
     RP1 = 0;

}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
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

//*****************************************************************************************************************************************
//Funcion para procesar la solitud realizada al concentrador (Test de comunicacion SPI, sincronizacion de tiempo)
void ProcesarSolicitudConcentrador(unsigned char* cabeceraSolicitudCon, unsigned char* payloadSolicitudCon){

     //Funcion 2: Lectura de datos (Hora actual)
     //Funcion 3: Escritura de datos (Hora RPi, Hora GPS, Hora RTC)
     //Funcion 4: Test comunicacion
     
     switch (cabeceraSolicitudCon[1]){
            case 2:
                 switch (cabeceraSolicitudCon[2]){
                        case 1:
                             //Activa la bandera para enviar la hora actual a la RPi en el siguiente pulso SQW:
                             banRespuestaPi = 1;
                             break;
                        case 2:
                             //Subfuncion=3: Hora RTC
                             fechaSistema = RecuperarFechaRTC();                        //Recupera la fecha del RTC
                             horaRPiRTC = RecuperarHoraRTC();                           //Recupera la hora del RTC
                             horaRPiRTC = horaRPiRTC + 1;                               //Incrementa un segundo para enviar la hora exacta en el siguiente pulso SQW.
                             AjustarTiempoSistema(horaRPiRTC, fechaSistema, tiempo);    //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas
                             //fuenteReloj = 3;                                           //Fuente de reloj = RTC
                             banRespuestaPi = 1;
                             break;
                 }
                 break;
            case 3:
                 switch (cabeceraSolicitudCon[2]){
                        case 1:
                             //Subfuncion=1: Hora RPi
                             horaSistema = RecuperarHoraRPI(payloadSolicitudCon);        //Recupera la hora de la RPi
                             fechaSistema = RecuperarFechaRPI(payloadSolicitudCon);      //Recupera la fecha de la RPi
                             DS3234_setDate(horaSistema, fechaSistema);                  //Configura la hora en el RTC
                             AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);    //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas
                             fuenteReloj = 1;                                            //Fuente de reloj = RED
                             banSetReloj = 1;                                            //Activa esta bandera para usar la hora/fecha recuperada
                             banRespuestaPi = 1;                                         //Activa esta bandera para enviar la trama de tiempo a la RPi
                             break;
                        case 2:
                             //Subfuncion=2: Hora GPS
                             banRespuestaPi = 0;
                             banGPSI = 1;                                                //Activa la bandera de inicio de trama  del GPS
                             banGPSC = 0;                                                //Limpia la bandera de trama completa
                             U1MODE.UARTEN = 1;                                          //Inicializa el UART1
                             //Inicia el Timeout 1:
                             TMR1 = 0;
                             T1CON.TON = 1;
                             //Desactiva la interrupcion INT1/SQW:
                             INT1IE_bit = 0;
                             break;
                 }
                 break;
            case 4:
                 //Actualiza el numero de datos para hacer el testnumDatosPayload = 10;
                 numDatosPayload = 10;
                 cabeceraSolicitud[3] = *(ptrNumDatosPayload);
                 cabeceraSolicitud[4] = *(ptrNumDatosPayload+1);
                 //Llena el payload con los datos de prueba:
                 for (x=0;x<numDatosPayload;x++){
                     payloadConcentrador[x] = tramaPruebaSPI[x];
                 }
                 //Envia la cabecera de respuesta:
                 EnviarCabeceraRespuesta(cabeceraSolicitud);
                 break;
     }
}
//*****************************************************************************************************************************************

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////// Interrupciones /////////////////////////////////////////////////////////////

//*****************************************************************************************************************************************
//Interrupcion SPI1
void spi_1() org  IVT_ADDR_SPI1INTERRUPT {

     SPI1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI
     bufferSPI = SPI1BUF;                                                       //Guarda el contenido del bufeer (lectura)
     
     //************************************************************************************************************************************
     //Rutina de Solcitud:
       //Rutina para recibir la trama de solicitud (C:0xA0   F:0xF0):
       if ((banSPI0==0)&&(bufferSPI==0xA0)){
          i = 0;                                                                //Limpia el subindice para guardar la trama SPI
          CambiarEstadoBandera(0,1);                                            //Activa la bandera 0
          LED1 = 1;
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
          *(ptrNumDatosPayload) = cabeceraSolicitud[3];
          *(ptrNumDatosPayload+1) = cabeceraSolicitud[4];
          //Recupera los datos de payload de la solicitud:
          for (j=0;j<numDatosPayload;j++){
              payloadSolicitud[j] = tramaSolicitudSPI[5+j];
          }
          //Comprueba si se solicito una tarea al concentrador (Id=0):
          if (idSolicitud==0){
               //Procesa la solicitud realizada al concentrador
               ProcesarSolicitudConcentrador(cabeceraSolicitud, payloadSolicitud);
          } else {
               //Renvia la trama de solicitud a los nodos a traves de RS485:
               EnviarTramaRS485(1, cabeceraSolicitud, payloadSolicitud);
               EnviarTramaRS485(2, cabeceraSolicitud, payloadSolicitud);
          }
          CambiarEstadoBandera(0,0);                                            //Limpia la bandera 0
          LED1 = 0;
       }
     //************************************************************************************************************************************
     //Rutinas de Respuesta:
       //Envia la cabecera de respuesta a la RPi (C:0xA1 F:0xF1)
       if ((banSPI1==0)&&(bufferSPI==0xA1)) {
          SPI1BUF = cabeceraRespuestaSPI[0];                                    //Carga en el buffer el primer elemento de la cabecera (id)
          i = 1;
          CambiarEstadoBandera(1,1);                                            //Activa la bandera 1
       }
       if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
          SPI1BUF = cabeceraRespuestaSPI[i];                                    //Se envia la trama de respuesta
          i++;
       }
       if ((banSPI1==1)&&(bufferSPI==0xF1)){
          CambiarEstadoBandera(1,0);                                            //Limpia la bandera 1
       }
       //Envia el contenido del pyload de la trama RS485 a la RPi (Payload nodos: C:0xA2 F:0xF2):
       if ((banSPI2==0)&&(bufferSPI==0xA2)){
          CambiarEstadoBandera(2,1);                                            //Activa la bandera 2
          SPI1BUF = pyloadRS485[0];
          i = 1;
       }
       if ((banSPI2==1)&&(bufferSPI!=0xA2)&&(bufferSPI!=0xF2)){
          SPI1BUF = pyloadRS485[i];
          i++;
       }
       if ((banSPI2==1)&&(bufferSPI==0xF2)){
          CambiarEstadoBandera(2,0);                                            //Limpia la bandera 2
       }
       //Envia el contenido del payload del concentrador (C:0xA3   F:0xF3):
       if ((banSPI3==0)&&(bufferSPI==0xA3)){
          CambiarEstadoBandera(3,1);                                            //Activa la bandera 3
          SPI1BUF = payloadConcentrador[0];
          i = 1;
       }
       if ((banSPI3==1)&&(bufferSPI!=0xA3)&&(bufferSPI!=0xF3)){
          SPI1BUF = payloadConcentrador[i];
          i++;
       }
       if ((banSPI3==1)&&(bufferSPI==0xF3)){
          CambiarEstadoBandera(3,0);                                            //Limpia la bandera 3
          banP1 = 0;
       }
       //************************************************************************************************************************************
}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Interrupcion INT1: SQW
void int_1() org IVT_ADDR_INT1INTERRUPT {

     INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
     
     //Genera el pulso RP2 para producir la interrupcion externa en la RPi:
     if ((banRespuestaPi==2)&&(banP1==0)){
         RP2 = 1;
         Delay_us(100);
         RP2 = 0;
         banRespuestaPi = 0;
     }

     //Incrementa el reloj del sistema:
     if (banSetReloj==1){
         horaSistema++;
         AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);
         LED1 = ~LED1;
     }

     //Envia el tiempo solicitado a la RPi.
     if (banRespuestaPi==1){
         //******************************************************
         //Envia la actualizacion de tiempo a la RPi
         //Actualiza el numero de datos del payload:
         numDatosPayload = 7;
         cabeceraSolicitud[3] = *(ptrNumDatosPayload);
         cabeceraSolicitud[4] = *(ptrNumDatosPayload+1);
         //Llena el payload con los datos de tiempo actual:
         for (x=0;x<6;x++){
             payloadConcentrador[x] = tiempo[x];
         }
         //Lena el ultimo byte del payload con el codigo
         payloadConcentrador[6] = fuenteReloj;
         //Envia la cabecera de respuesta:
         EnviarCabeceraRespuesta(cabeceraSolicitud);
         //******************************************************
         banRespuestaPi = 0;
     }
     
     //Sincroniza el reloj local con el GPS cada hora:
     if ((horaSistema!=0)&&(horaSistema%3600==0)){
        banRespuestaPi = 0;                                                     //No envia respuesta a la RPi
        //Recupera el tiempo del GPS:
        banGPSI = 1;                                                            //Activa la bandera de inicio de trama  del GPS
        banGPSC = 0;                                                            //Limpia la bandera de trama completa
        U1MODE.UARTEN = 1;                                                      //Inicializa el UART1
        //Inicia el Timeout 1:
        T1CON.TON = 1;
        TMR1 = 0;
     }

}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Interrupcion INT2: PPS
void int_2() org IVT_ADDR_INT2INTERRUPT {

     INT2IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT2

     if (banSyncReloj==1){
         
         LED1 = ~LED1;                                                          //TEST
         
         //Incrementa el tiempo 2seg para setear el RTC
         horaSistema = horaSistema + 2;

         //Realiza el retraso necesario para sincronizar el RTC con el PPS (Consultar Datasheet del DS3234)
         Delay_ms(499);
         DS3234_setDate(horaSistema, fechaSistema);                             //Configura la hora en el RTC con la hora recuperada de la RPi

         //
         horaSistema = horaSistema - 1;
         AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);

         banSyncReloj = 0;
         banSetReloj = 1;                                                       //Activa esta bandera para continuar trabajando con el pulso SQW

     }

}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Timeout de 4*300ms para el UART1: Espera la señal del GPS durante 0.9 segundos.
void Timer1Int() org IVT_ADDR_T1INTERRUPT{

     T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del Timer1
     contTimeout1++;                                                            //Incrementa el contador de Timeout

     //Despues de 4 desbordamientos apaga el Timer2 y recupera la hora del RTC:
     if (contTimeout1==4){
        T1CON.TON = 0;                                                          //Apaga el Timer1
        TMR1 = 0;
        contTimeout1 = 0;
        //Recupera la hora del RTC:
        horaSistema = RecuperarHoraRTC();                                       //Recupera la hora del RTC
        fechaSistema = RecuperarFechaRTC();                                     //Recupera la fecha del RTC
        horaRPiRTC = horaSistema + 2;
        AjustarTiempoSistema(horaRPiRTC, fechaSistema, tiempo);                 //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas del RTC
        fuenteReloj = 7;                                                        //Fuente de reloj = RTC|E7: El GPS tarda en responder
        //******************************************************
        //Envia la actualizacion de tiempo a la RPi
        numDatosPayload = 7;
        cabeceraSolicitud[3] = *(ptrNumDatosPayload);
        cabeceraSolicitud[4] = *(ptrNumDatosPayload+1);
        for (x=0;x<6;x++){
            payloadConcentrador[x] = tiempo[x];
        }
        payloadConcentrador[6] = fuenteReloj;
        EnviarCabeceraRespuesta(cabeceraSolicitud);
        banP1 = 1;                                                              //Activa esta bandera para evitar que se genere el pulso P2 hasta que se haya terminado de enviar el payload.
        banRespuestaPi = 2;
        //******************************************************
        INT1IE_bit = 1;                                                         //Activa la interrupcion INT1
     }

}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Timeout de 300ms para el UART2:
void Timer2Int() org IVT_ADDR_T2INTERRUPT{

     T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del Timer2
     T2CON.TON = 0;                                                             //Apaga el Timer
     TMR2 = 0;

     LED1 = ~LED1;//TEST

     //Limpia estas banderas para restablecer la comunicacion por RS485:
     banRSI = 0;
     banRSC = 0;
     i_rs485 = 0;

     //Envia el codigo de error de TimeOut a la RPi:
     numDatosPayload = 3;
     /*inputPyloadRS485[0] = 0xD3;
     inputPyloadRS485[1] = 0xEE;
     inputPyloadRS485[2] = 0xE4;
     InterrupcionP1(0xB3,0xD3,3);*/

}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Interrupcion UART1
void urx_1() org  IVT_ADDR_U1RXINTERRUPT {

     //Recupera el byte recibido en cada interrupcion:
     U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART
     byteGPS = U1RXREG;                                                         //Lee el byte de la trama enviada por el GPS
     U1STA.OERR = 0;                                                            //Limpia este bit para limpiar el FIFO UART1

     //Recupera el pyload de la trama GPS:                                      //Aqui deberia entrar despues de recuperar la cabecera de trama
     if (banGPSI==3){
        if (byteGPS!=0x2A){
           tramaGPS[i_gps] = byteGPS;                                           //LLena la tramaGPS hasta recibir el ultimo simbolo ("*") de la trama GPS
           i_gps++;
        } else {
           banGPSI = 0;                                                         //Limpia la bandera de inicio de trama
           banGPSC = 1;                                                         //Activa la bandera de trama completa
        }
     }

     //Recupera la cabecera de la trama GPS:                                    //Aqui deberia entrar primero cada vez que se recibe una trama nueva
     if ((banGPSI==1)){
        if (byteGPS==0x24){                                                     //Verifica si el primer byte recibido sea la cabecera de trama "$"
           banGPSI = 2;
           i_gps = 0;
        }
     }
     if ((banGPSI==2)&&(i_gps<6)){
        tramaGPS[i_gps] = byteGPS;                                              //Recupera los datos de cabecera de la trama GPS: ["$", "G", "P", "R", "M", "C"]
        i_gps++;
     }
     if ((banGPSI==2)&&(i_gps==6)){
        //Detiene el Timeout 1:
        T1CON.TON = 0;
        TMR1 = 0;
        //Comprueba la cabecera GPRMC:
        if (tramaGPS[1]=='G'&&tramaGPS[2]=='P'&&tramaGPS[3]=='R'&&tramaGPS[4]=='M'&&tramaGPS[5]=='C'){
           banGPSI = 3;
           i_gps = 0;
        } else {
           banGPSI = 0;
           banGPSC = 0;
           i_gps = 0;
           //Recupera la hora del RTC:
           horaSistema = RecuperarHoraRTC();                                    //Recupera la hora del RTC
           fechaSistema = RecuperarFechaRTC();                                  //Recupera la fecha del RTC
           horaRPiRTC = horaSistema + 2;
           AjustarTiempoSistema(horaRPiRTC, fechaSistema, tiempo);              //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas del RTC
           fuenteReloj = 5;                                                     //Fuente de reloj = RTC|E5: Problemas al recuperar la trama GPRMC del GPS
           banGPSI = 0;
           banGPSC = 0;
           i_gps = 0;
           //******************************************************
           //Envia la actualizacion de tiempo a la RPi
           numDatosPayload = 7;
           cabeceraSolicitud[3] = *(ptrNumDatosPayload);
           cabeceraSolicitud[4] = *(ptrNumDatosPayload+1);
           for (x=0;x<6;x++){
               payloadConcentrador[x] = tiempo[x];
           }
           payloadConcentrador[6] = fuenteReloj;
           EnviarCabeceraRespuesta(cabeceraSolicitud);
           banP1 = 1;
           banRespuestaPi = 2;
           //******************************************************
           U1MODE.UARTEN = 0;                                                   //Desactiva el UART1
           INT1IE_bit = 1;                                                      //Activa la interrupcion INT1
        }
     }

     //Realiza el procesamiento de la informacion del  pyload:                  //Aqui se realiza cualquier accion con el pyload recuperado
     if (banGPSC==1){
        //Verifica que el caracter 12 sea igual a "A" lo cual comprueba que los datos son validos:
        if (tramaGPS[12]==0x41) {
           for (x=0;x<6;x++){
               datosGPS[x] = tramaGPS[x+1];                                     //Guarda los datos de hhmmss
           }
           //Busca el simbolo "," a partir de la posicion 44
           for (x=44;x<54;x++){
               if (tramaGPS[x]==0x2C){
                   for (y=0;y<6;y++){
                       datosGPS[6+y] = tramaGPS[x+y+1];                         //Guarda los datos de DDMMAA en la trama datosGPS
                   }
               }
           }
           horaSistema = RecuperarHoraGPS(datosGPS);                            //Recupera la hora del GPS
           fechaSistema = RecuperarFechaGPS(datosGPS);                          //Recupera la fecha del GPS
           horaSistema = horaSistema + 1;                                       //Incrementa un segundo debido a que la trama NMEA corresponde al segundo anterior
           horaRPiRTC = horaSistema + 1;                                        //**REVISAR** Funciona a la fuerza
           AjustarTiempoSistema(horaRPiRTC, fechaSistema, tiempo);              //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas del gps
           fuenteReloj = 2;                                                     //Fuente de reloj = GPS
           //******************************************************
           //Envia la actualizacion de tiempo a la RPi
           numDatosPayload = 7;
           cabeceraSolicitud[3] = *(ptrNumDatosPayload);
           cabeceraSolicitud[4] = *(ptrNumDatosPayload+1);
           for (x=0;x<6;x++){
                payloadConcentrador[x] = tiempo[x];
           }
           payloadConcentrador[6] = fuenteReloj;
           EnviarCabeceraRespuesta(cabeceraSolicitud);
           banP1 = 1;
           banRespuestaPi = 2;
          //******************************************************
           banSyncReloj = 1;
           banSetReloj = 0;
        } else {
           //Recupera la hora del RTC:
           horaSistema = RecuperarHoraRTC();                                    //Recupera la hora del RTC
           fechaSistema = RecuperarFechaRTC();                                  //Recupera la fecha del RTC
           horaRPiRTC = horaSistema + 2;
           AjustarTiempoSistema(horaRPiRTC, fechaSistema, tiempo);              //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas del RTC
           fuenteReloj = 6;                                                     //Fuente de reloj = RTC|E6: La hora del GPS es invalida
           //******************************************************
           //Envia la actualizacion de tiempo a la RPi
           numDatosPayload = 7;
           cabeceraSolicitud[3] = *(ptrNumDatosPayload);
           cabeceraSolicitud[4] = *(ptrNumDatosPayload+1);
           for (x=0;x<6;x++){
               payloadConcentrador[x] = tiempo[x];
           }
           payloadConcentrador[6] = fuenteReloj;
           EnviarCabeceraRespuesta(cabeceraSolicitud);
           banP1 = 1;
           banRespuestaPi = 2;
           //******************************************************
        }

        banGPSI = 0;
        banGPSC = 0;
        i_gps = 0;
        U1MODE.UARTEN = 0;                                                      //Desactiva el UART1
        INT1IE_bit = 1;                                                         //Activa la interrupcion INT1
        
     }

}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
/*//Interrupcion UART2
void urx_2() org  IVT_ADDR_U2RXINTERRUPT {

     //Recupera el byte recibido en cada interrupcion:
     U2RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART2
     byteRS485 = U2RXREG;                                                       //Lee el byte de la trama enviada por el nodo
     U2STA.OERR = 0;                                                            //Limpia este bit para limpiar el FIFO UART2

     //Recupera el pyload de la trama RS485:                                  //Aqui deberia entrar despues de recuperar la cabecera de trama
       if (banRSI2==2){
          //Recupera el pyload de final de trama:
          if (i_rs4852<(numDatosPayload)){
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
             //LED2 = 1;
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
             *(ptrNumDatosPayload) = tramaCabeceraRS485[3];
             *(ptrNumDatosPayload+1) = tramaCabeceraRS485[4];
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
          //LED2 = 0;
          EnviarCabeceraRespuesta(tramaCabeceraRS485);
          //Limpia la bandera de trama completa:
          banRSC2 = 0;
       }
}
*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////