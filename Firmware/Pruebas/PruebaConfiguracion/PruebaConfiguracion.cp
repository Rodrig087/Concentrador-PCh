#line 1 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaConfiguracion/PruebaConfiguracion.c"
#line 1 "c:/users/milto/milton/rsa/git/proyecto chanlud/concentrador pch/concentrador-pch/firmware/librerias/rs485.c"
#line 13 "c:/users/milto/milton/rsa/git/proyecto chanlud/concentrador pch/concentrador-pch/firmware/librerias/rs485.c"
extern sfr sbit MS1RS485;
extern sfr sbit MS1RS485_Direction;
extern sfr sbit MS2RS485;
extern sfr sbit MS2RS485_Direction;



void EnviarTramaRS485(unsigned char puertoUART, unsigned char *cabecera, unsigned char *payload){

 unsigned char direccion;
 unsigned char funcion;
 unsigned char subfuncion;
 unsigned char lsbNumDatos;
 unsigned char msbNumDatos;
 unsigned int iDatos;


 unsigned int numDatos;
 unsigned char *ptrnumDatos;
 ptrnumDatos = (unsigned char *) & numDatos;


 direccion = cabecera[0];
 funcion = cabecera[1];
 subfuncion = cabecera[2];
 lsbNumDatos = cabecera[3];
 msbNumDatos = cabecera[4];


 *(ptrnumDatos) = lsbNumDatos;
 *(ptrnumDatos+1) = msbNumDatos;

 if (puertoUART == 1){
 MS1RS485 = 1;
 UART1_Write(0x3A);
 UART1_Write(direccion);
 UART1_Write(funcion);
 UART1_Write(subfuncion);
 UART1_Write(lsbNumDatos);
 UART1_Write(msbNumDatos);
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
 UART2_Write(subfuncion);
 UART2_Write(lsbNumDatos);
 UART2_Write(msbNumDatos);
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
#line 20 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaConfiguracion/PruebaConfiguracion.c"
sbit RP0 at LATC0_bit;
sbit RP0_Direction at TRISC0_bit;
sbit LED1 at RB2_bit;
sbit LED1_Direction at TRISB2_bit;
sbit LED2 at RB4_bit;
sbit LED2_Direction at TRISB4_bit;
sbit MS1RS485 at LATB3_bit;
sbit MS1RS485_Direction at TRISB3_bit;
sbit MS2RS485 at LATB5_bit;
sbit MS2RS485_Direction at TRISB5_bit;

unsigned int i, j, x, y;

unsigned char bufferSPI;
unsigned char banSPI0, banSPI1, banSPI2, banSPI3;
unsigned char tramaSolicitudSPI[20];
unsigned char cabeceraRespuestaSPI[10];
unsigned char idSolicitud;
unsigned char funcionSolicitud;
unsigned char subFuncionSolicitud;
unsigned char cabeceraSolicitud[10];
unsigned char payloadSolicitud[10];
unsigned char tramaPruebaSPI[10]= {0xA0, 0xA1, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6, 0xA7, 0xA8, 0xA9};

unsigned char banRSI, banRSC, banRSI2, banRSC2;
unsigned char byteRS485, byteRS4852;
unsigned int i_rs485, i_rs4852;
unsigned char tramaCabeceraRS485[10];
unsigned char pyloadRS485[770];
unsigned char direccionRS485, funcionRS485, subFuncionRS485;
unsigned int numDatosRS485;
unsigned char *ptrNumDatosRS485;

unsigned char sumValidacion;



void ConfiguracionPrincipal();
void CambiarEstadoBandera(unsigned char, unsigned char);
void ResponderSPI(unsigned char);



void main() {


 ConfiguracionPrincipal();



 i = 0;
 j = 0;
 x = 0;
 y = 0;

 banSPI0 = 0;
 banSPI1 = 0;
 banSPI2 = 0;
 banSPI3 = 0;
 bufferSPI = 0;
 idSolicitud = 0;
 funcionSolicitud = 0;
 subFuncionSolicitud = 0;

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

 RP0 = 0;
 LED1 = 0;
 LED2 = 0;
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

 LED1_Direction = 0;
 LED2_Direction = 0;
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


void CambiarEstadoBandera(unsigned char bandera, unsigned char estado){

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
 case 2:
 banSPI2 = 1;
 break;
 case 3:
 banSPI3 = 1;
 break;
 }
 }

 if (estado==0){
 banSPI0 = 0;
 banSPI1 = 0;
 banSPI2 = 0;
 banSPI3 = 0;
 }
}


void ResponderSPI(unsigned char *cabeceraRespuesta){


 cabeceraRespuestaSPI[0] = cabeceraRespuesta[0];
 cabeceraRespuestaSPI[1] = cabeceraRespuesta[1];
 cabeceraRespuestaSPI[2] = cabeceraRespuesta[2];
 cabeceraRespuestaSPI[3] = cabeceraRespuesta[3];
 cabeceraRespuestaSPI[4] = cabeceraRespuesta[4];


 RP0 = 1;
 Delay_us(100);
 RP0 = 0;

}





void interrupt(void){
#line 233 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaConfiguracion/PruebaConfiguracion.c"
 if (SSP1IF_bit==1){

 SSP1IF_bit = 0;
 bufferSPI = SSP1BUF;




 if ((banSPI0==0)&&(bufferSPI==0xA0)){
 i = 0;
 CambiarEstadoBandera(0,1);
 LED1 = 1;
 LED2 = 1;
 }
 if ((banSPI0==1)&&(bufferSPI!=0xA0)&&(bufferSPI!=0xF0)){
 tramaSolicitudSPI[i] = bufferSPI;
 i++;
 }
 if ((banSPI0==1)&&(bufferSPI==0xF0)){

 for (j=0;j<5;j++){
 cabeceraSolicitud[j] = tramaSolicitudSPI[j];
 }

 idSolicitud = cabeceraSolicitud[0];
 funcionSolicitud = cabeceraSolicitud[1];
 subFuncionSolicitud = cabeceraSolicitud[2];
 *(ptrNumDatosRS485) = cabeceraSolicitud[3];
 *(ptrNumDatosRS485+1) = cabeceraSolicitud[4];

 for (j=0;j<numDatosRS485;j++){
 payloadSolicitud[j] = tramaSolicitudSPI[5+j];
 }

 if (idSolicitud==0){
 if (funcionSolicitud==4){
 numDatosRS485 = 10;
 cabeceraSolicitud[3] = *(ptrNumDatosRS485);
 cabeceraSolicitud[4] = *(ptrNumDatosRS485+1);
 ResponderSPI(cabeceraSolicitud);
 }
 } else {

 EnviarTramaRS485(1, cabeceraSolicitud, payloadSolicitud);
 EnviarTramaRS485(2, cabeceraSolicitud, payloadSolicitud);

 }
 CambiarEstadoBandera(0,0);
 LED1 = 0;
 LED2 = 0;

 }





 if ((banSPI1==0)&&(bufferSPI==0xA1)) {
 SSP1BUF = cabeceraRespuestaSPI[0];
 i = 1;
 CambiarEstadoBandera(1,1);
 }
 if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
 SSP1BUF = cabeceraRespuestaSPI[i];
 i++;
 }
 if ((banSPI1==1)&&(bufferSPI==0xF1)){
 CambiarEstadoBandera(1,0);
 }

 if ((banSPI2==0)&&(bufferSPI==0xA2)){
 CambiarEstadoBandera(2,1);
 SSP1BUF = pyloadRS485[0];
 i = 1;
 }
 if ((banSPI2==1)&&(bufferSPI!=0xA2)&&(bufferSPI!=0xF2)){
 SSP1BUF = pyloadRS485[i];
 i++;
 }
 if ((banSPI2==1)&&(bufferSPI==0xF2)){
 CambiarEstadoBandera(2,0);
 }

 if ((banSPI3==0)&&(bufferSPI==0xA3)){
 CambiarEstadoBandera(3,1);
 SSP1BUF = tramaPruebaSPI[0];
 i = 1;
 }
 if ((banSPI3==1)&&(bufferSPI!=0xA3)&&(bufferSPI!=0xF3)){
 SSP1BUF = tramaPruebaSPI[i];
 i++;
 }
 if ((banSPI3==1)&&(bufferSPI==0xF3)){
 CambiarEstadoBandera(3,0);
 }


 }




 if (RC1IF_bit==1){

 RC1IF_bit = 0;
 byteRS485 = UART1_Read();


 if (banRSI==2){

 if (i_rs485<(numDatosRS485)){
 pyloadRS485[i_rs485] = byteRS485;
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
 LED1 = 1;
 }
 }
 if ((banRSI==1)&&(byteRS485!=0x3A)&&(i_rs485<5)){
 tramaCabeceraRS485[i_rs485] = byteRS485;
 i_rs485++;
 }
 if ((banRSI==1)&&(i_rs485==5)){

 if (tramaCabeceraRS485[0]==idSolicitud){

 funcionRS485 = tramaCabeceraRS485[1];
 subFuncionRS485 = tramaCabeceraRS485[2];
 *(ptrNumDatosRS485) = tramaCabeceraRS485[3];
 *(ptrNumDatosRS485+1) = tramaCabeceraRS485[4];
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
 LED1 = 0;
 ResponderSPI(tramaCabeceraRS485);

 banRSC = 0;
 }

 }




 if (RC2IF_bit==1){

 RC2IF_bit = 0;
 byteRS4852 = UART2_Read();


 if (banRSI2==2){

 if (i_rs4852<(numDatosRS485)){
 pyloadRS485[i_rs4852] = byteRS4852;
 i_rs4852++;
 } else {
 banRSI2 = 0;
 banRSC2 = 1;
 }
 }


 if ((banRSI2==0)&&(banRSC2==0)){
 if (byteRS4852==0x3A){
 banRSI2 = 1;
 i_rs4852 = 0;
 LED2 = 1;
 }
 }
 if ((banRSI2==1)&&(byteRS4852!=0x3A)&&(i_rs4852<5)){
 tramaCabeceraRS485[i_rs4852] = byteRS4852;
 i_rs4852++;
 }
 if ((banRSI2==1)&&(i_rs4852==5)){

 if (tramaCabeceraRS485[0]==idSolicitud){

 funcionRS485 = tramaCabeceraRS485[1];
 subFuncionRS485 = tramaCabeceraRS485[2];
 *(ptrNumDatosRS485) = tramaCabeceraRS485[3];
 *(ptrNumDatosRS485+1) = tramaCabeceraRS485[4];
 idSolicitud = 0;
 i_rs4852 = 0;
 banRSI2 = 2;

 } else {
 banRSI2 = 0;
 banRSC2 = 0;
 i_rs4852 = 0;
 }
 }


 if (banRSC2==1){
 LED2 = 0;
 ResponderSPI(tramaCabeceraRS485);

 banRSC2 = 0;
 }

 }


}
