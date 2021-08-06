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
 OSCCON.OSTS=0;
 OSCCON.HFIOFS=1;
 OSCCON.SCS1=1;
 OSCCON.SCS0=1;




 ANSELB = 0;
 TEST_Direction = 0;

 INTCON.GIE = 1;
 INTCON.PEIE = 1;


 T1CON = 0x01;
 TMR1H = 0xF0;
 TMR1L = 0x60;
 PIR1.TMR1IF = 0;
 PIE1.TMR1IE = 1;

 Delay_ms(100);
}




void interrupt(void){



 if (TMR1IF_bit==1){

 TEST = ~TEST;
 TMR1IF_bit = 0;


 TMR1H = 0xF0;
 TMR1L = 0x60;

 }


}
