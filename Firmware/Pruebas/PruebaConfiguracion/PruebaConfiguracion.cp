#line 1 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaConfiguracion/PruebaConfiguracion.c"
#line 15 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaConfiguracion/PruebaConfiguracion.c"
sbit TEST at RB2_bit;
sbit TEST_Direction at TRISB2_bit;


unsigned int i, j, x, y;


unsigned short bufferSPI;
unsigned short banSPI0, banSPI1;
unsigned char tramaSolicitudSPI[10];


unsigned short direccionRS485, funcionRS485, subFuncionRS485, numDatosRS485;
unsigned char cabeceraOutRS485[15];



void ConfiguracionPrincipal();
void CambiarEstadoBandera(unsigned short bandera, unsigned short estado);



void main() {

 ConfiguracionPrincipal();



 i = 0;
 j = 0;
 x = 0;
 y = 0;

 banSPI0 = 0;
 banSPI1 = 0;

 direccionRS485 = 0;
 funcionRS485 = 0;
 subFuncionRS485 = 0;
 numDatosRS485 = 0;

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





void interrupt(void){
#line 158 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaConfiguracion/PruebaConfiguracion.c"
 if (SSP1IF_bit==1){

 SSP1IF_bit = 0;
 bufferSPI = SSP1BUF;


 if ((banSPI1==0)&&(bufferSPI==0xA1)){
 CambiarEstadoBandera(1,1);
 i = 0;
 }
 if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
 tramaSolicitudSPI[i] = bufferSPI;
 i++;
 }
 if ((banSPI1==1)&&(bufferSPI==0xF1)){
 direccionRS485 = tramaSolicitudSPI[0];
 funcionRS485 = tramaSolicitudSPI[1];
 subFuncionRS485 = tramaSolicitudSPI[2];
 numDatosRS485 = tramaSolicitudSPI[3];



 if (numDatosRS485==2){
 direccionRS485 = 0;
 funcionRS485 = 0;
 subFuncionRS485 = 0;
 numDatosRS485 = 0;
 TEST = ~TEST;
 }

 CambiarEstadoBandera(1,0);
 }




 }

}
