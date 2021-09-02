#line 1 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaConfiguracion/PruebaConfiguracion.c"
#line 1 "c:/users/milto/milton/rsa/git/proyecto chanlud/concentrador pch/concentrador-pch/firmware/librerias/rs485.c"
#line 13 "c:/users/milto/milton/rsa/git/proyecto chanlud/concentrador pch/concentrador-pch/firmware/librerias/rs485.c"
extern sfr sbit MS1RS485;
extern sfr sbit MS1RS485_Direction;
extern sfr sbit MS2RS485;
extern sfr sbit MS2RS485_Direction;



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
 MS1RS485 = 1;
 UART1_Write(0x3A);
 UART1_Write(direccion);
 UART1_Write(funcion);
 UART1_Write(subfuncion);
 UART1_Write(numDatos);
 for (iDatos=0;iDatos<numDatos;iDatos++){
 UART1_Write(payload[iDatos]);
 }
 UART1_Write(0x0D);
 UART1_Write(0x0A);
 UART1_Write(0x00);
 while(UART1_Tx_Idle()==0);
 MS1RS485 = 0;
 }

 if (puertoUART == 2){
 MS2RS485 = 1;
 UART2_Write(0x3A);
 UART2_Write(direccion);
 UART2_Write(funcion);
 UART1_Write(subfuncion);
 UART1_Write(numDatos);
 for (iDatos=0;iDatos<numDatos;iDatos++){
 UART2_Write(payload[iDatos]);
 }
 UART2_Write(0x0D);
 UART2_Write(0x0A);
 UART2_Write(0x00);
 while(UART2_Tx_Idle()==0);
 MS2RS485 = 0;
 }

}
#line 24 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaConfiguracion/PruebaConfiguracion.c"
sbit RP0 at LATC0_bit;
sbit RP0_Direction at TRISC0_bit;
sbit TEST at RB2_bit;
sbit TEST_Direction at TRISB2_bit;
sbit MS1RS485 at LATB3_bit;
sbit MS1RS485_Direction at TRISB3_bit;
sbit MS2RS485 at LATB5_bit;
sbit MS2RS485_Direction at TRISB5_bit;

unsigned int i, j, x, y;

unsigned short bufferSPI;
unsigned short banSPI0, banSPI1;
unsigned char tramaSolicitudSPI[20];
unsigned char tramaRespuestaSPI[20];
unsigned short idSolicitud;
unsigned short funcionSolicitud;
unsigned short subFuncionSolicitud;
unsigned char cabeceraSolicitud[5];
unsigned char payloadSolicitud[5];
unsigned char tramaPruebaSPI[10]= {0xA0, 0xA1, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6, 0xA7, 0xA8, 0xA9};

unsigned short banRSI, banRSC;
unsigned char byteRS485;
unsigned int i_rs485;
unsigned char tramaCabeceraRS485[5];
unsigned char inputPyloadRS485[15];
unsigned char outputPyloadRS485[15];
unsigned short direccionRS485, funcionRS485, subFuncionRS485, numDatosRS485;
unsigned short sumValidacion;



void ConfiguracionPrincipal();
void CambiarEstadoBandera(unsigned short bandera, unsigned short estado);
void ResponderSPI(unsigned char *cabeceraRespuesta, unsigned char *payloadRespuesta);



void main() {


 ConfiguracionPrincipal();



 i = 0;
 j = 0;
 x = 0;
 y = 0;

 banSPI0 = 0;
 banSPI1 = 0;
 bufferSPI = 0;
 idSolicitud = 0;
 funcionSolicitud = 0;
 subFuncionSolicitud = 0;

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

 RP0 = 0;
 TEST = 1;
 MS1RS485 = 0;
 MS2RS485 = 0;

}






void ConfiguracionPrincipal(){


 OSCCON.IDLEN=1;
 OSCCON.IRCF2=1;
 OSCCON.IRCF1=1;
 OSCCON.IRCF0=1;
 OSCCON.SCS1=1;
 OSCCON.SCS0=1;


 ANSELA = 0;
 ANSELB = 0;
 ANSELC = 0;

 TEST_Direction = 0;
 RP0_Direction = 0;
 MS1RS485_Direction = 0;
 MS2RS485_Direction = 0;
 TRISA5_bit = 1;
 TRISC3_bit = 1;
 TRISC4_bit = 1;
 TRISC5_bit = 0;

 INTCON.GIE = 1;
 INTCON.PEIE = 1;


 PIE1.SSP1IE = 1;
 PIR1.SSP1IF = 0;
 SPI1_Init_Advanced(_SPI_SLAVE_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_HIGH_2_LOW);


 PIE1.RC1IE = 1;
 PIR1.RC1IF = 0;
 PIE3.RC2IE = 1;
 PIR3.RC2IF = 0;
 UART1_Init(19200);
 UART2_Init(19200);








 Delay_ms(100);
}


void CambiarEstadoBandera(unsigned short bandera, unsigned short estado){

 if (estado==1){

 banSPI0 = 3;
 banSPI1 = 3;

 switch (bandera){
 case 0:
 banSPI0 = 1;
 break;
 case 1:
 banSPI1 = 1;
 break;
 }
 }

 if (estado==0){
 banSPI0 = 0;
 banSPI1 = 0;
 }
}


void ResponderSPI(unsigned char *cabeceraRespuesta, unsigned char *payloadRespuesta){


 tramaRespuestaSPI[0] = cabeceraRespuesta[0];
 tramaRespuestaSPI[1] = cabeceraRespuesta[1];
 tramaRespuestaSPI[2] = cabeceraRespuesta[2];
 tramaRespuestaSPI[3] = cabeceraRespuesta[3];


 for (j=0;j<(cabeceraRespuesta[3]);j++){
 tramaRespuestaSPI[j+4] = payloadRespuesta[j];
 }


 RP0 = 1;
 Delay_us(100);
 RP0 = 0;

}





void interrupt(void){
#line 220 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaConfiguracion/PruebaConfiguracion.c"
 if (SSP1IF_bit==1){

 SSP1IF_bit = 0;
 bufferSPI = SSP1BUF;
 TEST = ~TEST;



 if ((banSPI0==0)&&(bufferSPI==0xA0)) {
 SSP1BUF = tramaRespuestaSPI[0];
 i = 1;
 CambiarEstadoBandera(0,1);
 }
 if ((banSPI0==1)&&(bufferSPI!=0xA0)&&(bufferSPI!=0xF0)){
 SSP1BUF = tramaRespuestaSPI[i];
 i++;

 }
 if ((banSPI0==1)&&(bufferSPI==0xF0)){
 CambiarEstadoBandera(0,0);
 }


 if ((banSPI1==0)&&(bufferSPI==0xA1)){
 i = 0;
 CambiarEstadoBandera(1,1);
 }
 if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
 tramaSolicitudSPI[i] = bufferSPI;
 i++;
 }
 if ((banSPI1==1)&&(bufferSPI==0xF1)){

 for (j=0;j<4;j++){
 cabeceraSolicitud[j] = tramaSolicitudSPI[j];
 }

 for (j=0;j<(cabeceraSolicitud[3]);j++){
 payloadSolicitud[j] = tramaSolicitudSPI[4+j];
 }


 idSolicitud = cabeceraSolicitud[0];
 funcionSolicitud = cabeceraSolicitud[1];
 subFuncionSolicitud = cabeceraSolicitud[2];


 if (funcionSolicitud!=4){

 EnviarTramaRS485(1, cabeceraSolicitud, payloadSolicitud);
 EnviarTramaRS485(2, cabeceraSolicitud, payloadSolicitud);
 } else {
 if (subfuncionSolicitud==1){

 TEST = ~TEST;
 cabeceraSolicitud[3] = 10;
 ResponderSPI(cabeceraSolicitud, tramaPruebaSPI);
 } else {

 EnviarTramaRS485(1, cabeceraSolicitud, payloadSolicitud);
 EnviarTramaRS485(2, cabeceraSolicitud, payloadSolicitud);
 }
 }

 CambiarEstadoBandera(1,0);

 }

 }




 if (RC1IF_bit==1){

 RC1IF_bit = 0;
 byteRS485 = UART1_Read();


 if (banRSI==2){

 if (i_rs485<(numDatosRS485)){
 inputPyloadRS485[i_rs485] = byteRS485;
 i_rs485++;
 } else {
 banRSI = 0;
 banRSC = 1;
 }
 }


 if ((banRSI==0)&&(banRSC==0)){
 if (byteRS485==0x3A){
 banRSI = 1;
 i_rs485 = 0;
 }
 }
 if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<4)){
 tramaCabeceraRS485[i_rs485] = byteRS485;
 i_rs485++;
 }
 if ((banRSI==1)&&(i_rs485==4)){

 if (tramaCabeceraRS485[0]==idSolicitud){

 funcionRS485 = tramaCabeceraRS485[1];
 subFuncionRS485 = tramaCabeceraRS485[2];
 numDatosRS485 = tramaCabeceraRS485[3];
 idSolicitud = 0;
 i_rs485 = 0;
 banRSI = 2;

 } else {
 banRSI = 0;
 banRSC = 0;
 i_rs485 = 0;
 }
 }


 if (banRSC==1){
 TEST = ~TEST;
 ResponderSPI(tramaCabeceraRS485, inputPyloadRS485);

 banRSC = 0;
 }

 }




 if (RC2IF_bit==1){

 RC2IF_bit = 0;
#line 407 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaConfiguracion/PruebaConfiguracion.c"
 }


}
