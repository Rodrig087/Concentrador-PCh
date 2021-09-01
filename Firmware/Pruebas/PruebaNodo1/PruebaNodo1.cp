#line 1 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaNodo1/PruebaNodo1.c"
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
#line 19 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaNodo1/PruebaNodo1.c"
sbit TEST at LATC4_bit;
sbit TEST_Direction at TRISC4_bit;
sbit MS2RS485 at LATC5_bit;
sbit MS2RS485_Direction at TRISC5_bit;
sbit MS1RS485 at LATC5_bit;
sbit MS1RS485_Direction at TRISC5_bit;

unsigned int i, j, x, y;

unsigned short banRSI, banRSC;
unsigned char byteRS485;
unsigned int i_rs485;
unsigned char tramaCabeceraRS485[5];
unsigned char inputPyloadRS485[15];
unsigned char outputPyloadRS485[15];
unsigned short direccionRS485, funcionRS485, subFuncionRS485, numDatosRS485;
unsigned char tramaPruebaRS485[10]= {10, 11, 12, 13, 14, 15, 16, 17, 18, 19};




void ConfiguracionPrincipal();
void interrupt(void);




void main() {

 ConfiguracionPrincipal();



 i = 0;
 j = 0;
 x = 0;
 y = 0;


 banRSI = 0;
 banRSC = 0;
 byteRS485 = 0;
 i_rs485 = 0;
 funcionRS485 = 0;
 subFuncionRS485 = 0;
 numDatosRS485 = 0;
 MS1RS485 = 0;



 TEST = 1;
#line 78 "C:/Users/milto/Milton/RSA/Git/Proyecto Chanlud/Concentrador PCh/Concentrador-PCh/Firmware/Pruebas/PruebaNodo1/PruebaNodo1.c"
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
 MS1RS485_Direction = 0;

 INTCON.GIE = 1;
 INTCON.PEIE = 1;


 PIE1.RC1IE = 1;
 PIR1.RC1IF = 0;
 UART1_Init(19200);

 Delay_ms(100);

}






void interrupt(void){



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

 if (tramaCabeceraRS485[0]== 5 ){

 funcionRS485 = tramaCabeceraRS485[1];
 subFuncionRS485 = tramaCabeceraRS485[2];
 numDatosRS485 = tramaCabeceraRS485[3];
 banRSI = 2;
 i_rs485 = 0;

 } else {
 banRSI = 0;
 banRSC = 0;
 i_rs485 = 0;
 }
 }


 if (banRSC==1){

 TEST = ~TEST;
 Delay_ms(250);

 tramaCabeceraRS485[3] = 10;
 EnviarTramaRS485(1, tramaCabeceraRS485, tramaPruebaRS485);

 banRSC = 0;

 }



 }


}
