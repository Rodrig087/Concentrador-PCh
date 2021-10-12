//Compilar:
//gcc TestSPI.c -o testspi -lbcm2835 -lwiringPi 

/*-------------------------------------------------------------------------------------------------------------------------
Autor: Milton Munoz
Fecha de creacion: 21/08/03
Observaciones:
Funcion 1: Inicio de medicion.
Funcion 2: Lectura de datos.
Funcion 3: Escritura de datos.
Funcion 4: Test comunicacion
        Subfuncion 1: Test SPI (sumRecibido=1645)
        Subfuncion 2: Test RS485 (sumRecibido=1805)
-------------------------------------------------------------------------------------------------------------------------*/

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
#define TIEMPO_SPI 100
#define FreqSPI 200000

#define RED   "\x1B[31m"
#define RESET "\x1B[0m"

//Declaracion de variables
unsigned short i;
unsigned int x;

unsigned short idPet;
unsigned short funcionPet;
unsigned short subFuncionPet;
unsigned short numDatosPet;

unsigned short idResp;
unsigned short funcionResp;
unsigned short subFuncionResp;
unsigned short numDatosResp;

unsigned char payloadPet[255];
unsigned char payloadResp[255];

unsigned int sumEnviado;
unsigned int sumRecibido;



//Declaracion de funciones
int ConfiguracionPrincipal();
void RecibirRespuesta();														//C:0xA0    F:0xF0
void EnviarSolicitud(unsigned short id, unsigned short funcion, unsigned short subFuncion, unsigned short numDatos, unsigned char* payload); //C:0xA1    F:0xF1														//C:0xA4	F:0xF4

void ImprimirInformacion();
void Salir();						


int main() {

	//printf("Iniciando...\n");
  
	//Inicializa las variables:
	i = 0;
	x = 0;
	
	idPet = 0;
	funcionPet = 0;
	subFuncionPet = 0;
	numDatosPet = 0;
	idResp = 0;
	funcionPet = 0;
	subFuncionResp = 0;
	numDatosResp = 0;
		
	//Configuracion principal:
	ConfiguracionPrincipal();
	
	//Datos de prueba:
	idPet = 3;
	funcionPet = 4;
	subFuncionPet = 2;
	numDatosPet = 5;
	payloadPet[0] = 1;
	payloadPet[1] = 2;
	payloadPet[2] = 3;
	payloadPet[3] = 4;
	payloadPet[4] = 5;
	
	sumEnviado = 0;
	sumRecibido = 0;
	
	EnviarSolicitud(idPet, funcionPet, subFuncionPet, numDatosPet, payloadPet);
	
	while(1){}
	//Salir();	

}

//**************************************************************************************************************************************
//Configuracion:

int ConfiguracionPrincipal(){
	
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
		
}
//**************************************************************************************************************************************

//Imprimir en pantalla los datos relevantes
void ImprimirInformacion(){
	
	//Imprime la solicitud:
	printf("\nTrama enviada:");
	printf("\n Cabecera: %d %d %d %d", idPet, funcionPet, subFuncionPet, numDatosPet);
	printf("\n Payload: ");
	for (i=0;i<numDatosPet;i++){
        printf("%#02X ", payloadPet[i]);
    }
	printf("\n Sumatoria control = %d", sumEnviado);
	
	//Imprime la respuesta:
	printf("\nTrama recibida:");
	printf("\n Cabecera: %d %d %d %d", idResp, funcionResp, subFuncionResp, numDatosResp);
	printf("\n Payload: ");
	for (i=0;i<numDatosResp;i++){
        printf("%#02X ", payloadResp[i]);
    }
	
	//Comprueba la sumatoria de control en las solicitudes de testeo de comunicacion:
	if (funcionPet==4){
		//Test comunicacion SPI
		if (subFuncionPet==1){
			if (sumRecibido==1645){
			printf("\n Sumatoria control = %d", sumRecibido);
			}else{
				printf("\n Sumatoria control = " RED "%d" RESET, sumRecibido);
			}
		}
		//Test comunicacion RS485:
		if (subFuncionPet==2){
			//0XB*9=99dec
			if (sumRecibido==(99+idPet)){
			printf("\n Sumatoria control = %d", sumRecibido);
			}else{
				printf("\n Sumatoria control = " RED "%d" RESET, sumRecibido);
			}		
		}
	}
		
	Salir();
	
}

//**************************************************************************************************************************************
//Comunicacion RPi-dsPIC:

//C:0xA0    F:0xF0
void RecibirRespuesta(){
	
	bcm2835_delayMicroseconds(200);
	
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
        payloadResp[i] = bcm2835_spi_transfer(0x01);
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
	printf("\n>Respuesta recibida\n");
			
	//Apaga el LEDTEST:
	digitalWrite (LEDTEST, LOW);
	
	//Imprime la informacion de solicitud y respuesta:
	ImprimirInformacion();
	
	Salir();

	
}

//C:0xA1	F:0xF1
void EnviarSolicitud(unsigned short id, unsigned short funcion, unsigned short subFuncion, unsigned short numDatos, unsigned char* payload){
	
	//sumatoria de control:
	for (i=0;i<numDatos;i++){
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
	for (i=0;i<numDatos;i++){
        bcm2835_spi_transfer(payload[i]);
        bcm2835_delayMicroseconds(TIEMPO_SPI);
    }
		
	//Envia el delimitador de fin de trama:
	bcm2835_spi_transfer(0xF1);	
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	
	//Imprime la solicitud:
	printf("\n>Solicitud enviada");
	
	//Enciende el LEDTEST:
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





