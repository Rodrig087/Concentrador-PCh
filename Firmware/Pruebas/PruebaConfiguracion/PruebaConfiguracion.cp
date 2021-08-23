#line 1 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaConfiguracion/PruebaConfiguracion.c"
#line 15 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaConfiguracion/PruebaConfiguracion.c"
sbit RP0 at LATC0_bit;
sbit RP0_Direction at TRISC0_bit;
sbit TEST at RB2_bit;
sbit TEST_Direction at TRISB2_bit;

unsigned int i, j, x, y;

unsigned short bufferSPI;
unsigned short banSPI0, banSPI1;
unsigned char tramaSolicitudSPI[10];

unsigned short direccionSol, funcionSol, subFuncionSol, numDatosSol;
unsigned char cabeceraSolicitud[4];
unsigned char payloadSolicitud[15];



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

 direccionSol = 0;
 funcionSol = 0;
 subFuncionSol = 0;
 numDatosSol = 0;

 RP0 = 0;
 TEST = 1;










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
 TRISA5_bit = 1;
 TRISC3_bit = 1;
 TRISC4_bit = 1;
 TRISC5_bit = 0;

 INTCON.GIE = 1;
 INTCON.PEIE = 1;


 SSP1IE_bit = 1;
 SPI1_Init_Advanced(_SPI_SLAVE_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_HIGH_2_LOW);
 SSP1IF_bit = 0;









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


 RP0 = 1;
 Delay_us(100);
 RP0 = 0;

}





void interrupt(void){
#line 171 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaConfiguracion/PruebaConfiguracion.c"
 if (SSP1IF_bit==1){

 SSP1IF_bit = 0;
 bufferSPI = SSP1BUF;


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


 if ((payloadSolicitud[1])==0xEE){
 TEST = ~TEST;
 ResponderSPI(cabeceraSolicitud, payloadSolicitud);
 }


 CambiarEstadoBandera(1,0);
 }





 }

}
