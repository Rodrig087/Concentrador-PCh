//Compilar:
//gcc TestSPI.c -o testspi -lbcm2835 -lwiringPi 

#include <stdio.h>
#include <stdlib.h>
#include <wiringPi.h>
#include <bcm2835.h>
#include <time.h>
#include <string.h>
#include <unistd.h>


//Declaracion de constantes
#define P1 0																	//Pin 11 GPIO
#define MCLR 28																	//Pin 38 GPIO
#define LEDTEST 29 																//Pin 40 GPIO																						
#define TIEMPO_SPI 10
#define FreqSPI 2000000


//Declaracion de variables
unsigned short i;
unsigned int x;

unsigned short idPet;
unsigned short funcionPet;
unsigned short subFuncionPet;
unsigned short numDatosPet;

unsigned char payloadPet[255];
unsigned char payloadResp[255];

//Declaracion de funciones
int ConfiguracionPrincipal();
void RecibirRespuesta();														//C:0xA0    F:0xF0
void EnviarSolicitud(unsigned short id, unsigned short funcion, unsigned short subFuncion, unsigned short numDatos, unsigned char* payload); //C:0xA1    F:0xF1														//C:0xA4	F:0xF4

void Salir();						
void SetRelojLocal(unsigned char* tramaTiempo);


int main() {

	//printf("Iniciando...\n");
  
	//Inicializa las variables:
	i = 0;
	x = 0;
		
	//Configuracion principal:
	ConfiguracionPrincipal();
	
	//Datos de prueba:
	idPet = 5;
	funcionPet = 4;
	subFuncionPet = 3;
	numDatosPet = 2;
	payloadPet[0] = 0xFF;
	payloadPet[1] = 0XEE;
	
	EnviarSolicitud(idPet, funcionPet, subFuncionPet, numDatosPet, payloadPet);
	
	//while(1){}
	Salir();	

}

//**************************************************************************************************************************************
//Configuracion:

int ConfiguracionPrincipal(){
	
	//Reinicia el modulo SPI
	system("sudo rmmod  spi_bcm2835");
	bcm2835_delayMicroseconds(500);
	system("sudo modprobe spi_bcm2835");

    //Configuracion libreria bcm2835:
	if (!bcm2835_init()){
		printf("bcm2835_init fallo. Ejecuto el programa como root?\n");
		return 1;
    }
    if (!bcm2835_spi_begin()){
		printf("bcm2835_spi_begin fallo. Ejecuto el programa como root?\n");
		return 1;
    }

    bcm2835_spi_setBitOrder(BCM2835_SPI_BIT_ORDER_MSBFIRST);
    bcm2835_spi_setDataMode(BCM2835_SPI_MODE3);
	//bcm2835_spi_setClockDivider(BCM2835_SPI_CLOCK_DIVIDER_32);				/Clock divider RPi 2
	bcm2835_spi_setClockDivider(BCM2835_SPI_CLOCK_DIVIDER_64);					//Clock divider RPi 3		
    bcm2835_spi_set_speed_hz(FreqSPI);
    bcm2835_spi_chipSelect(BCM2835_SPI_CS0);
    bcm2835_spi_setChipSelectPolarity(BCM2835_SPI_CS0, LOW);
		
	//Configuracion libreria WiringPi:
    wiringPiSetup();
    pinMode(P1, INPUT);
	pinMode(MCLR, OUTPUT);
	pinMode(LEDTEST, OUTPUT);
	wiringPiISR (P1, INT_EDGE_RISING, RecibirRespuesta);
	
	//Enciende el pin LEDTEST:
	digitalWrite (LEDTEST, HIGH);
	
	//Genera un pulso para resetear el PIC:
    digitalWrite(MCLR, HIGH);
    delay(100);
    digitalWrite(MCLR, LOW);
    delay(100);
    digitalWrite(MCLR, HIGH); 
		
	printf("Configuracion completa\n");
	//sleep(1);
	
}
//**************************************************************************************************************************************

//**************************************************************************************************************************************
//Comunicacion RPi-dsPIC:

//C:0xA0    F:0xF0
void RecibirRespuesta(){
	
	bcm2835_delayMicroseconds(200);
	
	unsigned short idResp;
	unsigned short funcionResp;
	unsigned short subFuncionResp;
	unsigned short numDatosResp;
	
	//Recupera la cabecera: [id, funcion, subfuncion, #Datos]:
	bcm2835_spi_transfer(0xA0);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	idResp = bcm2835_spi_transfer(0x00);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	funcionResp = bcm2835_spi_transfer(0x00);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	subFuncionResp = bcm2835_spi_transfer(0x00);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	numDatosResp = bcm2835_spi_transfer(0x00);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	
	//Recupera el payload:
	for (i=0;i<numDatosResp;i++){
        payloadResp[i] = bcm2835_spi_transfer(0x00);
        bcm2835_delayMicroseconds(TIEMPO_SPI);
    }
	
	//Envia el delimitador de fin de trama:
	bcm2835_spi_transfer(0xF0);	
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	
	//Salir();

	
}

//C:0xA1	F:0xF1
void EnviarSolicitud(unsigned short id, unsigned short funcion, unsigned short subFuncion, unsigned short numDatos, unsigned char* payload){
	
	bcm2835_delayMicroseconds(200);
	
	//Envia la cabecera: [id, funcion, subfuncion, #Datos]:
	bcm2835_spi_transfer(0xA1);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(id);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(funcion);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(subFuncion);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(numDatos);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	
	//Envia el payload:
	for (i=0;i<numDatosPet;i++){
        bcm2835_spi_transfer(payload[i]);
        bcm2835_delayMicroseconds(TIEMPO_SPI);
    }
	
	//Envia el delimitador de fin de trama:
	bcm2835_spi_transfer(0xF1);	
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	
	printf("Solicitud Enviada\n");
	printf("Cabecera: %d %d %d %d\n", id, funcion, subFuncion, numDatos);
	
}

//**************************************************************************************************************************************

//**************************************************************************************************************************************
//Procesos locales:

void Salir(){
	
	bcm2835_spi_end();
	bcm2835_close();
	printf("Adios...\n");
	exit (-1);
}

void SetRelojLocal(unsigned char* tramaTiempo){
	
	printf("Sincronizando hora local...\n");
	char datePIC[22];
	char comando[40];	
	//Configura el reloj interno de la RPi con la hora recuperada del PIC:
	strcpy(comando, "sudo date --set ");	//strcpy( <variable_destino>, <cadena_fuente> )
	//Ejemplo: '2019-09-13 17:45:00':
	datePIC[0] = 0x27;						//'
	datePIC[1] = '2';
	datePIC[2] = '0';
	datePIC[3] = (tramaTiempo[0]/10)+48;		//aa: (19/10)+48 = 49 = '1'
	datePIC[4] = (tramaTiempo[0]%10)+48;		//    (19%10)+48 = 57 = '9'
	datePIC[5] = '-';	
	datePIC[6] = (tramaTiempo[1]/10)+48;		//MM
	datePIC[7] = (tramaTiempo[1]%10)+48;
	datePIC[8] = '-';
	datePIC[9] = (tramaTiempo[2]/10)+48;		//dd
	datePIC[10] = (tramaTiempo[2]%10)+48;
	datePIC[11] = ' ';
	datePIC[12] = (tramaTiempo[3]/10)+48;		//hh
	datePIC[13] = (tramaTiempo[3]%10)+48;
	datePIC[14] = ':';
	datePIC[15] = (tramaTiempo[4]/10)+48;		//mm
	datePIC[16] = (tramaTiempo[4]%10)+48;
	datePIC[17] = ':';
	datePIC[18] = (tramaTiempo[5]/10)+48;		//ss
	datePIC[19] = (tramaTiempo[5]%10)+48;
	datePIC[20] = 0x27;
	datePIC[21] = '\0';
	
	strcat(comando, datePIC);
	
	system(comando);
	system("date");
	
}

//**************************************************************************************************************************************





