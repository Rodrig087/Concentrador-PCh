#line 1 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaNodo2/PruebaNodo2.c"
#line 1 "c:/users/milto/milton/rsa/git/proyecto chanlud/concentrador pch/concentrador-pch/firmware/librerias/rs485.c"
#line 12 "c:/users/milto/milton/rsa/git/proyecto chanlud/concentrador pch/concentrador-pch/firmware/librerias/rs485.c"
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
#line 18 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaNodo2/PruebaNodo2.c"
sbit TEST at LATC4_bit;
sbit TEST_Direction at TRISC4_bit;
sbit MS1RS485 at LATC5_bit;
sbit MS1RS485_Direction at TRISC5_bit;




const short Psize = 6;

const short Hdr = 0x3A;

unsigned char Ptcn[Psize];

short ip;
unsigned short BanLP;
unsigned short BanAP;
unsigned short ByPtcn;





void ConfiguracionPrincipal();
void interrupt(void);




void main() {

 ConfiguracionPrincipal();


 TEST = 1;


 while(1){
 TEST = ~TEST;
 Delay_ms(250);
 }

}



void ConfiguracionPrincipal(){


 OSCCON.IDLEN=1;
 OSCCON.IRCF2=1;
 OSCCON.IRCF1=1;
 OSCCON.IRCF0=1;
 OSCCON.SCS1=1;
 OSCCON.SCS0=1;


 ANSELB = 0;
 ANSELC = 0;

 TEST_Direction = 0;
 MS1RS485_Direction = 0;

 INTCON.GIE = 1;
 INTCON.PEIE = 1;


 PIE1.RC1IE = 1;
 PIR1.RC1IF = 0;
 UART1_Init(19200);

 Delay_ms(100);

}


void interrupt(void){

 if(PIR1.F5==1){
#line 118 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaNodo2/PruebaNodo2.c"
 PIR1.F5 = 0;

 }

}
