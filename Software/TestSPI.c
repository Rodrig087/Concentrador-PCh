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
#define P0 0																	//Pin 11 GPIO
#define MCLR 28																	//Pin 38 GPIO
#define LEDTEST 29 																//Pin 40 GPIO																						
#define TIEMPO_SPI 10
#define FreqSPI 400000

#define RED   "\x1B[31m"
#define RESET "\x1B[0m"

//Declaracion de variables
unsigned short i;
unsigned int x;

unsigned short idPet;
unsigned short funcionPet;
unsigned short subFuncionPet;
unsigned short numDatosPet;

unsigned char payloadPet[255];
unsigned char payloadResp[255];

unsigned int sumEnviado;
unsigned int sumRecibido;

//Declaracion de funciones
int ConfiguracionPrincipal();
void RecibirRespuesta();														//C:0xA0    F:0xF0
void EnviarSolicitud(unsigned short id, unsigned short funcion, unsigned short subFuncion, unsigned short numDatos, unsigned char* payload); //C:0xA1    F:0xF1														//C:0xA4	F:0xF4

void Salir();						


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
	numDatosPet = 5;
	payloadPet[0] = 0xE1;
	payloadPet[1] = 0XE2;
	payloadPet[2] = 0XE3;
	payloadPet[3] = 0XE4;
	payloadPet[4] = 0XE5;
	
	sumEnviado = 0;
	sumRecibido = 0;
	
	EnviarSolicitud(idPet, funcionPet, subFuncionPet, numDatosPet, payloadPet);
	
	while(1){}
	//Salir();	

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
	bcm2835_spi_setClockDivider(BCM2835_SPI_CLOCK_DIVIDER_256);					//Clock divider RPi 3		
    bcm2835_spi_set_speed_hz(FreqSPI);
    bcm2835_spi_chipSelect(BCM2835_SPI_CS0);
    bcm2835_spi_setChipSelectPolarity(BCM2835_SPI_CS0, LOW);
		
	//Configuracion libreria WiringPi:
    wiringPiSetup();
    pinMode(P0, INPUT);
	pinMode(MCLR, OUTPUT);
	pinMode(LEDTEST, OUTPUT);
	wiringPiISR (P0, INT_EDGE_RISING, RecibirRespuesta);
	
	//Enciende el pin LEDTEST:
	digitalWrite (LEDTEST, HIGH);
	
	//Genera un pulso para resetear el PIC:
    digitalWrite(MCLR, HIGH);
    delay(100);
    digitalWrite(MCLR, LOW);
    delay(100);
    digitalWrite(MCLR, HIGH); 
		
	//printf("Configuracion completa\n");
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
	//bcm2835_delayMicroseconds(TIEMPO_SPI);
	
	delay(25); //**Este retardo es muy importante**
	
	//sumatoria de control:
	for (i=0;i<numDatosResp;i++){
        sumRecibido = sumRecibido + payloadResp[i];
    }
	
	//Imprime la respuesta:
	printf("\nTrama recibida");
	printf("\nCabecera: %d %d %d %d", idResp, funcionResp, subFuncionResp, numDatosResp);
	printf("\nPayload: ");
	for (i=0;i<numDatosResp;i++){
        printf("%#02X ", payloadResp[i]);
    }
	//printf("\n");
	
	
	if (sumEnviado==sumRecibido){
		printf("\nSumatoria control = %d", sumRecibido);
	}else{
		printf("\nSumatoria control = " RED "%d" RESET, sumRecibido);
	}
	
	
	//Apaga el LEDTEST:
	digitalWrite (LEDTEST, LOW);
	
	Salir();

	
}

//C:0xA1	F:0xF1
void EnviarSolicitud(unsigned short id, unsigned short funcion, unsigned short subFuncion, unsigned short numDatos, unsigned char* payload){
	
	//sumatoria de control:
	for (i=0;i<numDatosPet;i++){
        sumEnviado = sumEnviado + payload[i];
    }
	
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
	
	//Imprime la solicitud:
	printf("\nSolicitud enviada");
	printf("\nCabecera: %d %d %d %d", id, funcion, subFuncion, numDatos);
	printf("\nPayload: ");
	for (i=0;i<numDatosPet;i++){
        printf("%#02X ", payload[i]);
    }
	printf("\nSumatoria control = %d", sumEnviado);
	
	digitalWrite (LEDTEST, HIGH);
	
}

//**************************************************************************************************************************************

//**************************************************************************************************************************************
//Procesos locales:

void Salir(){
	
	bcm2835_spi_end();
	bcm2835_close();
	printf("\nAdios...\n");
	exit (-1);
}


//**************************************************************************************************************************************





