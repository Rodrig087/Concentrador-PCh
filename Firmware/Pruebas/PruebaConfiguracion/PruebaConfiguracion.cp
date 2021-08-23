#line 1 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaConfiguracion/PruebaConfiguracion.c"
#line 11 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaConfiguracion/PruebaConfiguracion.c"
sbit TEST at RB2_bit;
sbit TEST_Direction at TRISB2_bit;



void ConfiguracionPrincipal();



void main() {

 ConfiguracionPrincipal();
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




void interrupt(void){
#line 107 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaConfiguracion/PruebaConfiguracion.c"
 if (SSP1IF_bit==1){

 SSP1IF_bit = 0;
 TEST = ~TEST;

 }

}
