#line 1 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Concentrador principal/Firmware/ConcentradorPrincipal/ConcentradorPrincipal.c"
#line 1 "c:/users/milto/milton/rsa/git/proyecto chanlud/concentrador pch/concentrador-pch/concentrador principal/firmware/librerias/tiempo_rtc.c"
#line 37 "c:/users/milto/milton/rsa/git/proyecto chanlud/concentrador pch/concentrador-pch/concentrador principal/firmware/librerias/tiempo_rtc.c"
sbit CS_DS3234 at LATA2_bit;




void DS3234_init();
void DS3234_write_byte(unsigned char address, unsigned char value);
void DS3234_read_byte(unsigned char address, unsigned char value);
void DS3234_setDate(unsigned long longHora, unsigned long longFecha);
unsigned long RecuperarFechaRTC();
unsigned long RecuperarHoraRTC();
unsigned long IncrementarFecha(unsigned long longFecha);
void AjustarTiempoSistema(unsigned long longHora, unsigned long longFecha, unsigned char *tramaTiempoSistema);





void DS3234_init(){

 SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_ACTIVE_2_IDLE);
 DS3234_write_byte( 0x8E ,0x20);
 DS3234_write_byte( 0x8F ,0x08);
 SPI2_Init();

}


void DS3234_write_byte(unsigned char address, unsigned char value){

 CS_DS3234 = 0;
 SPI2_Write(address);
 SPI2_Write(value);
 CS_DS3234 = 1;

}


unsigned char DS3234_read_byte(unsigned char address){

 unsigned char value = 0x00;
 CS_DS3234 = 0;
 SPI2_Write(address);
 value = SPI2_Read(0);
 CS_DS3234 = 1;
 return value;

}


void DS3234_setDate(unsigned long longHora, unsigned long longFecha){

 unsigned short valueSet;
 unsigned short hora;
 unsigned short minuto;
 unsigned short segundo;
 unsigned short dia;
 unsigned short mes;
 unsigned short anio;

 SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_ACTIVE_2_IDLE);

 anio = (short)(longFecha / 10000);
 mes = (short)((longFecha%10000) / 100);
 dia = (short)((longFecha%10000) % 100);

 hora = (short)(longHora / 3600);
 minuto = (short)((longHora%3600) / 60);
 segundo = (short)((longHora%3600) % 60);

 anio = Dec2Bcd(anio);
 dia = Dec2Bcd(dia);
 mes = Dec2Bcd(mes);
 segundo = Dec2Bcd(segundo);
 minuto = Dec2Bcd(minuto);
 hora = Dec2Bcd(hora);

 DS3234_write_byte( 0x80 , segundo);
 DS3234_write_byte( 0x81 , minuto);
 DS3234_write_byte( 0x82 , hora);
 DS3234_write_byte( 0x84 , dia);
 DS3234_write_byte( 0x85 , mes);
 DS3234_write_byte( 0x86 , anio);

 SPI2_Init();

 return;

}


unsigned long RecuperarHoraRTC(){

 unsigned short valueRead;
 unsigned long hora;
 unsigned long minuto;
 unsigned long segundo;
 unsigned long horaRTC;

 SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_ACTIVE_2_IDLE);

 valueRead = DS3234_read_byte( 0x00 );
 valueRead = Bcd2Dec(valueRead);
 segundo = (long)valueRead;
 valueRead = DS3234_read_byte( 0x01 );
 valueRead = Bcd2Dec(valueRead);
 minuto = (long)valueRead;

 valueRead = DS3234_read_byte( 0x02 );
 valueRead = Bcd2Dec(valueRead);
 hora = (long)valueRead;

 horaRTC = (hora*3600)+(minuto*60)+(segundo);

 SPI2_Init();

 return horaRTC;

}


unsigned long RecuperarFechaRTC(){

 unsigned short valueRead;
 unsigned long dia;
 unsigned long mes;
 unsigned long anio;
 unsigned long fechaRTC;

 SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_ACTIVE_2_IDLE);

 valueRead = DS3234_read_byte( 0x04 );
 valueRead = Bcd2Dec(valueRead);
 dia = (long)valueRead;
 valueRead = 0x1F & DS3234_read_byte( 0x05 );
 valueRead = Bcd2Dec(valueRead);
 mes = (long)valueRead;
 valueRead = DS3234_read_byte( 0x06 );
 valueRead = Bcd2Dec(valueRead);
 anio = (long)valueRead;

 fechaRTC = (anio*10000)+(mes*100)+(dia);

 SPI2_Init();

 return fechaRTC;

}


unsigned long IncrementarFecha(unsigned long longFecha){

 unsigned long dia;
 unsigned long mes;
 unsigned long anio;
 unsigned long fechaInc;

 anio = longFecha / 10000;
 mes = (longFecha%10000) / 100;
 dia = (longFecha%10000) % 100;

 if (dia<28){
 dia++;
 } else {
 if (mes==2){

 if (((anio-16)%4)==0){
 if (dia==29){
 dia = 1;
 mes++;
 } else {
 dia++;
 }
 } else {
 dia = 1;
 mes++;
 }
 } else {
 if (dia<30){
 dia++;
 } else {
 if (mes==4||mes==6||mes==9||mes==11){
 if (dia==30){
 dia = 1;
 mes++;
 } else {
 dia++;
 }
 }
 if ((dia!=1)&&(mes==1||mes==3||mes==5||mes==7||mes==8||mes==10)){
 if (dia==31){
 dia = 1;
 mes++;
 } else {
 dia++;
 }
 }
 if ((dia!=1)&&(mes==12)){
 if (dia==31){
 dia = 1;
 mes = 1;
 anio++;
 } else {
 dia++;
 }
 }
 }
 }

 }

 fechaInc = (anio*10000)+(mes*100)+(dia);
 return fechaInc;

}


void AjustarTiempoSistema(unsigned long longHora, unsigned long longFecha, unsigned short *tramaTiempoSistema){

 unsigned short hora;
 unsigned short minuto;
 unsigned short segundo;
 unsigned short dia;
 unsigned short mes;
 unsigned short anio;

 anio = (short)(longFecha / 10000);
 mes = (short)((longFecha%10000) / 100);
 dia = (short)((longFecha%10000) % 100);

 hora = (short)(longHora / 3600);
 minuto = (short)((longHora%3600) / 60);
 segundo = (short)((longHora%3600) % 60);

 tramaTiempoSistema[0] = anio;
 tramaTiempoSistema[1] = mes;
 tramaTiempoSistema[2] = dia;
 tramaTiempoSistema[3] = hora;
 tramaTiempoSistema[4] = minuto;
 tramaTiempoSistema[5] = segundo;

}
#line 1 "c:/users/milto/milton/rsa/git/proyecto chanlud/concentrador pch/concentrador-pch/concentrador principal/firmware/librerias/tiempo_gps.c"




void GPS_init(short conf,short NMA);
unsigned long RecuperarFechaGPS(unsigned char *tramaDatosGPS);
unsigned long RecuperarHoraGPS(unsigned char *tramaDatosGPS);





void GPS_init(short conf,short NMA){
#line 45 "c:/users/milto/milton/rsa/git/proyecto chanlud/concentrador pch/concentrador-pch/concentrador principal/firmware/librerias/tiempo_gps.c"
 UART1_Write_Text("$PMTK605*31\r\n");
 UART1_Write_Text("$PMTK220,1000*1F\r\n");
 UART1_Write_Text("$PMTK251,115200*1F\r\n");
 Delay_ms(1000);
 UART1_Init(115200);
 UART1_Write_Text("$PMTK313,1*2E\r\n");
 UART1_Write_Text("$PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0*29\r\n");
 UART1_Write_Text("$PMTK319,1*24\r\n");
 UART1_Write_Text("$PMTK413*34\r\n");
 UART1_Write_Text("$PMTK513,1*28\r\n");
 Delay_ms(1000);
 U1MODE.UARTEN = 0;
}




unsigned long RecuperarFechaGPS(unsigned char *tramaDatosGPS){

 unsigned long tramaFecha[4];
 unsigned long fechaGPS;
 char datoStringF[3];
 char *ptrDatoStringF = &datoStringF;
 datoStringF[2] = '\0';
 tramaFecha[3] = '\0';


 datoStringF[0] = tramaDatosGPS[10];
 datoStringF[1] = tramaDatosGPS[11];
 tramaFecha[0] = atoi(ptrDatoStringF);


 datoStringF[0] = tramaDatosGPS[8];
 datoStringF[1] = tramaDatosGPS[9];
 tramaFecha[1] = atoi(ptrDatoStringF);


 datoStringF[0] = tramaDatosGPS[6];
 datoStringF[1] = tramaDatosGPS[7];
 tramaFecha[2] = atoi(ptrDatoStringF);

 fechaGPS = (tramaFecha[0]*10000)+(tramaFecha[1]*100)+(tramaFecha[2]);

 return fechaGPS;

}


unsigned long RecuperarHoraGPS(unsigned char *tramaDatosGPS){

 unsigned long tramaTiempo[4];
 unsigned long horaGPS;
 char datoString[3];
 char *ptrDatoString = &datoString;
 datoString[2] = '\0';
 tramaTiempo[3] = '\0';


 datoString[0] = tramaDatosGPS[0];
 datoString[1] = tramaDatosGPS[1];
 tramaTiempo[0] = atoi(ptrDatoString);


 datoString[0] = tramaDatosGPS[2];
 datoString[1] = tramaDatosGPS[3];
 tramaTiempo[1] = atoi(ptrDatoString);


 datoString[0] = tramaDatosGPS[4];
 datoString[1] = tramaDatosGPS[5];
 tramaTiempo[2] = atoi(ptrDatoString);

 horaGPS = (tramaTiempo[0]*3600)+(tramaTiempo[1]*60)+(tramaTiempo[2]);
 return horaGPS;

}
#line 1 "c:/users/milto/milton/rsa/git/proyecto chanlud/concentrador pch/concentrador-pch/concentrador principal/firmware/librerias/tiempo_rpi.c"



unsigned long RecuperarFechaRPI(unsigned short *tramaTiempoRpi);
unsigned long RecuperarHoraRPI(unsigned short *tramaTiempoRpi);




unsigned long RecuperarFechaRPI(unsigned short *tramaTiempoRpi){

 unsigned long fechaRPi;

 fechaRPi = ((long)tramaTiempoRpi[0]*10000)+((long)tramaTiempoRpi[1]*100)+((long)tramaTiempoRpi[2]);

 return fechaRPi;

}


unsigned long RecuperarHoraRPI(unsigned short *tramaTiempoRpi){

 unsigned long horaRPi;

 horaRPi = ((long)tramaTiempoRpi[3]*3600)+((long)tramaTiempoRpi[4]*60)+((long)tramaTiempoRpi[5]);

 return horaRPi;

}
#line 1 "c:/users/milto/milton/rsa/git/proyecto chanlud/concentrador pch/concentrador-pch/concentrador principal/firmware/librerias/rs485.c"
#line 13 "c:/users/milto/milton/rsa/git/proyecto chanlud/concentrador pch/concentrador-pch/concentrador principal/firmware/librerias/rs485.c"
extern sfr sbit MS1RS485;
extern sfr sbit MS1RS485_Direction;



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

}
#line 21 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Concentrador principal/Firmware/ConcentradorPrincipal/ConcentradorPrincipal.c"
unsigned int i, j, x, y;


sbit RP1 at LATA4_bit;
sbit RP1_Direction at TRISA4_bit;
sbit RP2 at LATA0_bit;
sbit RP2_Direction at TRISA0_bit;
sbit MS1RS485 at LATB11_bit;
sbit MS1RS485_Direction at TRISB11_bit;
sbit LED1 at LATA1_bit;
sbit LED1_Direction at TRISA1_bit;


unsigned int i_gps;
unsigned char byteGPS, banGPSI, banGPSC;
unsigned char banSetGPS;
unsigned char tramaGPS[70];
unsigned char datosGPS[13];
unsigned char contTimeout1;


unsigned char tiempo[6];
unsigned char banSetReloj, banSyncReloj, banRespuestaPi;
unsigned char fuenteReloj;
unsigned long horaSistema, fechaSistema;
unsigned char referenciaTiempo;
unsigned long horaRPiRTC;
unsigned char tiempoRPiRTC[6];


unsigned char bufferSPI;
unsigned char banSPI0, banSPI1, banSPI2, banSPI3, banP1;
unsigned char tramaSolicitudSPI[20];
unsigned char cabeceraRespuestaSPI[10];
unsigned char payloadConcentrador[10];
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
unsigned int numDatosPayload;
unsigned char *ptrNumDatosPayload;


unsigned char banInicioMuestreo;







void ConfiguracionPrincipal();
void Muestrear();

void EnviarCabeceraRespuesta(unsigned char);
void ProcesarSolicitudConcentrador(unsigned char, unsigned char);





void main() {

 ConfiguracionPrincipal();
 GPS_init(1,1);
 DS3234_init();




 i = 0;
 j = 0;
 x = 0;
 y = 0;


 banSPI0 = 0;
 banSPI1 = 0;
 banSPI2 = 0;
 banSPI3 = 0;
 banP1 = 0;
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
 funcionRS485 = 0;
 subFuncionRS485 = 0;
 numDatosPayload = 0;
 ptrNumDatosPayload = (unsigned char *) & numDatosPayload;
 MS1RS485 = 0;


 i_gps = 0;
 byteGPS = 0;
 banGPSI = 0;
 banGPSC = 0;
 banSetGPS = 0;
 contTimeout1 = 0;


 banSetReloj = 0;
 banSyncReloj = 0;
 banRespuestaPi = 0;
 horaSistema = 0;
 fechaSistema = 0;
 fuenteReloj = 0;
 referenciaTiempo = 0;
 horaRPiRTC = 0;


 banInicioMuestreo = 0;


 RP1 = 0;
 RP2 = 0;
 LED1 = 0;
 MS1RS485 = 0;


 fechaSistema = RecuperarFechaRTC();
 horaSistema = RecuperarHoraRTC();
 AjustarTiempoSistema(horaRPiRTC, fechaSistema, tiempo);
 fuenteReloj = 3;
 banSetReloj = 1;

 while(1){
 asm CLRWDT;
 Delay_ms(100);
 }

}








void ConfiguracionPrincipal(){


 CLKDIVbits.FRCDIV = 0;
 CLKDIVbits.PLLPOST = 0;
 CLKDIVbits.PLLPRE = 5;
 PLLFBDbits.PLLDIV = 150;


 ANSELA = 0;
 ANSELB = 0;

 TRISA2_bit = 0;
 LED1_Direction = 0;
 RP1_Direction = 0;
 RP2_Direction = 0;
 MS1RS485_Direction = 0;
 TRISB13_bit = 1;
 TRISB14_bit = 1;

 INTCON2.GIE = 1;


 RPINR18bits.U1RXR = 0x22;
 RPOR0bits.RP35R = 0x01;
 U1RXIE_bit = 1;
 IPC2bits.U1RXIP = 0x04;
 U1STAbits.URXISEL = 0x00;
 UART1_Init(9600);


 RPINR19bits.U2RXR = 0x2F;
 RPOR1bits.RP36R = 0x03;
 U2RXIE_bit = 1;
 IPC7bits.U2RXIP = 0x04;
 U2STAbits.URXISEL = 0x00;
 UART2_Init(19200);


 SPI1STAT.SPIEN = 1;
 SPI1_Init_Advanced(_SPI_SLAVE, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_1, _SPI_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
 SPI1IF_bit = 0;
 IPC2bits.SPI1IP = 0x03;


 RPINR22bits.SDI2R = 0x21;
 RPOR2bits.RP38R = 0x08;
 RPOR1bits.RP37R = 0x09;
 SPI2STAT.SPIEN = 1;
 SPI2_Init();
 CS_DS3234 = 1;


 RPINR0 = 0x2D00;
 RPINR1 = 0x002E;
 INT1IF_bit = 0;
 INT2IF_bit = 0;
 IPC5bits.INT1IP = 0x02;
 IPC7bits.INT2IP = 0x01;


 T1CON = 0x30;
 T1CON.TON = 0;
 T1IE_bit = 1;
 T1IF_bit = 0;
 PR1 = 46875;
 IPC0bits.T1IP = 0x02;


 T2CON = 0x30;
 T2CON.TON = 0;
 T2IE_bit = 1;
 T2IF_bit = 0;
 PR2 = 46875;
 IPC1bits.T2IP = 0x02;


 SPI1IE_bit = 1;
 INT1IE_bit = 1;
 INT2IE_bit = 1;

 Delay_ms(200);

}




void EnviarCabeceraRespuesta(unsigned char *cabeceraRespuesta){


 cabeceraRespuestaSPI[0] = cabeceraRespuesta[0];
 cabeceraRespuestaSPI[1] = cabeceraRespuesta[1];
 cabeceraRespuestaSPI[2] = cabeceraRespuesta[2];
 cabeceraRespuestaSPI[3] = cabeceraRespuesta[3];
 cabeceraRespuestaSPI[4] = cabeceraRespuesta[4];


 RP1 = 1;
 Delay_us(100);
 RP1 = 0;

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




void ProcesarSolicitudConcentrador(unsigned char* cabeceraSolicitudCon, unsigned char* payloadSolicitudCon){





 switch (cabeceraSolicitudCon[1]){
 case 2:
 switch (cabeceraSolicitudCon[2]){
 case 1:

 banRespuestaPi = 1;
 break;
 case 2:

 fechaSistema = RecuperarFechaRTC();
 horaRPiRTC = RecuperarHoraRTC();
 horaRPiRTC = horaRPiRTC + 1;
 AjustarTiempoSistema(horaRPiRTC, fechaSistema, tiempo);

 banRespuestaPi = 1;
 break;
 }
 break;
 case 3:
 switch (cabeceraSolicitudCon[2]){
 case 1:

 horaSistema = RecuperarHoraRPI(payloadSolicitudCon);
 fechaSistema = RecuperarFechaRPI(payloadSolicitudCon);
 DS3234_setDate(horaSistema, fechaSistema);
 AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);
 fuenteReloj = 1;
 banSetReloj = 1;
 banRespuestaPi = 1;
 break;
 case 2:

 banRespuestaPi = 0;
 banGPSI = 1;
 banGPSC = 0;
 U1MODE.UARTEN = 1;

 TMR1 = 0;
 T1CON.TON = 1;

 INT1IE_bit = 0;
 break;
 }
 break;
 case 4:

 numDatosPayload = 10;
 cabeceraSolicitud[3] = *(ptrNumDatosPayload);
 cabeceraSolicitud[4] = *(ptrNumDatosPayload+1);

 for (x=0;x<numDatosPayload;x++){
 payloadConcentrador[x] = tramaPruebaSPI[x];
 }

 EnviarCabeceraRespuesta(cabeceraSolicitud);
 break;
 }
}









void spi_1() org IVT_ADDR_SPI1INTERRUPT {

 SPI1IF_bit = 0;
 bufferSPI = SPI1BUF;




 if ((banSPI0==0)&&(bufferSPI==0xA0)){
 i = 0;
 CambiarEstadoBandera(0,1);
 LED1 = 1;
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
 *(ptrNumDatosPayload) = cabeceraSolicitud[3];
 *(ptrNumDatosPayload+1) = cabeceraSolicitud[4];

 for (j=0;j<numDatosPayload;j++){
 payloadSolicitud[j] = tramaSolicitudSPI[5+j];
 }

 if (idSolicitud==0){

 ProcesarSolicitudConcentrador(cabeceraSolicitud, payloadSolicitud);
 } else {

 EnviarTramaRS485(1, cabeceraSolicitud, payloadSolicitud);
 EnviarTramaRS485(2, cabeceraSolicitud, payloadSolicitud);
 }
 CambiarEstadoBandera(0,0);
 LED1 = 0;
 }



 if ((banSPI1==0)&&(bufferSPI==0xA1)) {
 SPI1BUF = cabeceraRespuestaSPI[0];
 i = 1;
 CambiarEstadoBandera(1,1);
 }
 if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
 SPI1BUF = cabeceraRespuestaSPI[i];
 i++;
 }
 if ((banSPI1==1)&&(bufferSPI==0xF1)){
 CambiarEstadoBandera(1,0);
 }

 if ((banSPI2==0)&&(bufferSPI==0xA2)){
 CambiarEstadoBandera(2,1);
 SPI1BUF = pyloadRS485[0];
 i = 1;
 }
 if ((banSPI2==1)&&(bufferSPI!=0xA2)&&(bufferSPI!=0xF2)){
 SPI1BUF = pyloadRS485[i];
 i++;
 }
 if ((banSPI2==1)&&(bufferSPI==0xF2)){
 CambiarEstadoBandera(2,0);
 }

 if ((banSPI3==0)&&(bufferSPI==0xA3)){
 CambiarEstadoBandera(3,1);
 SPI1BUF = payloadConcentrador[0];
 i = 1;
 }
 if ((banSPI3==1)&&(bufferSPI!=0xA3)&&(bufferSPI!=0xF3)){
 SPI1BUF = payloadConcentrador[i];
 i++;
 }
 if ((banSPI3==1)&&(bufferSPI==0xF3)){
 CambiarEstadoBandera(3,0);
 banP1 = 0;
 }

}




void int_1() org IVT_ADDR_INT1INTERRUPT {

 INT1IF_bit = 0;


 if ((banRespuestaPi==2)&&(banP1==0)){
 RP2 = 1;
 Delay_us(100);
 RP2 = 0;
 banRespuestaPi = 0;
 }


 if (banSetReloj==1){
 horaSistema++;
 AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);
 LED1 = ~LED1;
 }


 if (banRespuestaPi==1){



 numDatosPayload = 7;
 cabeceraSolicitud[3] = *(ptrNumDatosPayload);
 cabeceraSolicitud[4] = *(ptrNumDatosPayload+1);

 for (x=0;x<6;x++){
 payloadConcentrador[x] = tiempo[x];
 }

 payloadConcentrador[6] = fuenteReloj;

 EnviarCabeceraRespuesta(cabeceraSolicitud);

 banRespuestaPi = 0;
 }


 if ((horaSistema!=0)&&(horaSistema%3600==0)){
 banRespuestaPi = 0;

 banGPSI = 1;
 banGPSC = 0;
 U1MODE.UARTEN = 1;

 T1CON.TON = 1;
 TMR1 = 0;
 }

}




void int_2() org IVT_ADDR_INT2INTERRUPT {

 INT2IF_bit = 0;

 if (banSyncReloj==1){

 LED1 = ~LED1;


 horaSistema = horaSistema + 2;


 Delay_ms(499);
 DS3234_setDate(horaSistema, fechaSistema);


 horaSistema = horaSistema - 1;
 AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);

 banSyncReloj = 0;
 banSetReloj = 1;

 }

}




void Timer1Int() org IVT_ADDR_T1INTERRUPT{

 T1IF_bit = 0;
 contTimeout1++;


 if (contTimeout1==4){
 T1CON.TON = 0;
 TMR1 = 0;
 contTimeout1 = 0;

 horaSistema = RecuperarHoraRTC();
 fechaSistema = RecuperarFechaRTC();
 horaRPiRTC = horaSistema + 2;
 AjustarTiempoSistema(horaRPiRTC, fechaSistema, tiempo);
 fuenteReloj = 7;


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

 INT1IE_bit = 1;
 }

}




void Timer2Int() org IVT_ADDR_T2INTERRUPT{

 T2IF_bit = 0;
 T2CON.TON = 0;
 TMR2 = 0;

 LED1 = ~LED1;


 banRSI = 0;
 banRSC = 0;
 i_rs485 = 0;


 numDatosPayload = 3;
#line 626 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Concentrador principal/Firmware/ConcentradorPrincipal/ConcentradorPrincipal.c"
}




void urx_1() org IVT_ADDR_U1RXINTERRUPT {


 U1RXIF_bit = 0;
 byteGPS = U1RXREG;
 U1STA.OERR = 0;


 if (banGPSI==3){
 if (byteGPS!=0x2A){
 tramaGPS[i_gps] = byteGPS;
 i_gps++;
 } else {
 banGPSI = 0;
 banGPSC = 1;
 }
 }


 if ((banGPSI==1)){
 if (byteGPS==0x24){
 banGPSI = 2;
 i_gps = 0;
 }
 }
 if ((banGPSI==2)&&(i_gps<6)){
 tramaGPS[i_gps] = byteGPS;
 i_gps++;
 }
 if ((banGPSI==2)&&(i_gps==6)){

 T1CON.TON = 0;
 TMR1 = 0;

 if (tramaGPS[1]=='G'&&tramaGPS[2]=='P'&&tramaGPS[3]=='R'&&tramaGPS[4]=='M'&&tramaGPS[5]=='C'){
 banGPSI = 3;
 i_gps = 0;
 } else {
 banGPSI = 0;
 banGPSC = 0;
 i_gps = 0;

 horaSistema = RecuperarHoraRTC();
 fechaSistema = RecuperarFechaRTC();
 horaRPiRTC = horaSistema + 2;
 AjustarTiempoSistema(horaRPiRTC, fechaSistema, tiempo);
 fuenteReloj = 5;
 banGPSI = 0;
 banGPSC = 0;
 i_gps = 0;


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

 U1MODE.UARTEN = 0;
 INT1IE_bit = 1;
 }
 }


 if (banGPSC==1){

 if (tramaGPS[12]==0x41) {
 for (x=0;x<6;x++){
 datosGPS[x] = tramaGPS[x+1];
 }

 for (x=44;x<54;x++){
 if (tramaGPS[x]==0x2C){
 for (y=0;y<6;y++){
 datosGPS[6+y] = tramaGPS[x+y+1];
 }
 }
 }
 horaSistema = RecuperarHoraGPS(datosGPS);
 fechaSistema = RecuperarFechaGPS(datosGPS);
 horaSistema = horaSistema + 1;
 horaRPiRTC = horaSistema + 1;
 AjustarTiempoSistema(horaRPiRTC, fechaSistema, tiempo);
 fuenteReloj = 2;


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

 banSyncReloj = 1;
 banSetReloj = 0;
 } else {

 horaSistema = RecuperarHoraRTC();
 fechaSistema = RecuperarFechaRTC();
 horaRPiRTC = horaSistema + 2;
 AjustarTiempoSistema(horaRPiRTC, fechaSistema, tiempo);
 fuenteReloj = 6;


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

 }

 banGPSI = 0;
 banGPSC = 0;
 i_gps = 0;
 U1MODE.UARTEN = 0;
 INT1IE_bit = 1;

 }

}
