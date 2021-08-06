/*-------------------------------------------------------------------------------------------------------------------------
Autor: Milton Munoz
Fecha de creacion: 21/08/03
Configuracion: PIC18F25k22 XT=20MHz
Observaciones:

---------------------------------------------------------------------------------------------------------------------------*/

////////////////////////////////////////////// Declaracion de variables y costantes ///////////////////////////////////////////////////////
//Variables y contantes para la peticion y respuesta de datos
sbit TEST at RB2_bit;                                  //Definicion del pin de indicador auxiliar para hacer pruebas
sbit TEST_Direction at TRISB2_bit;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////  Declaracion de funciones  /////////////////////////////////////////////////////////
void ConfiguracionPrincipal();
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////      Main      ////////////////////////////////////////////////////////////////
void main() {

    ConfiguracionPrincipal();
    TEST = 1;
    
    //Entra al bucle princial del programa:
    //while(1){
             //TEST = ~TEST;
             //Delay_ms(80);
    //}
     



}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////// Funciones ////////////////////////////////////////////////////////////////

//*****************************************************************************************************************************************
// Funcion para realizar la configuracion principal
void ConfiguracionPrincipal(){
     //

     //Configuracion oscilador
     OSCCON.IDLEN=1;                                    //Entra en modo IDLE durante la instruccion SLEEP
     OSCCON.IRCF2=1;                                    //HFINTOSC=16MHz  IRFC=111
     OSCCON.IRCF1=1;
     OSCCON.IRCF0=1;
     OSCCON.OSTS=0;                                     //*El dispositivo está funcionando desde el reloj definido por FOSC <3:0> del registro CONFIG1H
     OSCCON.HFIOFS=1;                                   //HFINTOSC frequency is stable
     OSCCON.SCS1=1;                                     //System Clock Select bit:  1x=Internal oscillator block
     OSCCON.SCS0=1;
     //OSCCON2 = 0b10000000;                              //Select PLL as osc source
     //OSCTUNE = 0b00000000 ;                               //Frequency Tuning bits: Fecuencia de calibracion de fabrica

     //Configuracion de puertos:
     ANSELB = 0;                                        //Configura PORTB como digital
     TEST_Direction = 0;                                //Configura el pin TEST como salida

     INTCON.GIE = 1;                                    //Habilita las interrupciones globales
     INTCON.PEIE = 1;                                   //Habilita las interrupciones perifericas
    
     //Configuracion del TMR1 con un tiempo de 1ms
     T1CON = 0x01;                                      //Timer1 Input Clock Prescale Select bits
     TMR1H = 0xF0;
     TMR1L = 0x60;
     PIR1.TMR1IF = 0;                                   //Limpia la bandera de interrupcion del TMR1
     PIE1.TMR1IE = 1;                                   //Habilita la interrupción de desbordamiento TMR1
    
    Delay_ms(100);                                     //Espera hasta que se estabilicen los cambios
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////// Interrupciones ///////////////////////////////////////////////////////////////
void interrupt(void){

//********************************************************************************************************************************************
//Interrupcion por desbordamiento del Timer1
    if (TMR1IF_bit==1){
        
        TEST = ~TEST;
        TMR1IF_bit = 0;                                       //Limpia la bandera de interrupcion por desbordamiento del TMR1
        //T1CON.TMR1ON = 0;                                     //Apaga el Timer1
        //Reinicia el Timer1:
        TMR1H = 0xF0;
        TMR1L = 0x60;

    }
//********************************************************************************************************************************************

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////