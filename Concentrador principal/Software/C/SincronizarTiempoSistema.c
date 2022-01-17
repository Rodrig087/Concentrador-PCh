//Compilar:
//gcc SincronizarTiempoSistema.c -o /home/pi/Ejecutables/sincronizartiemposistema -lbcm2835 -lwiringPi 
//gcc SincronizarTiempoSistema.c -o sincronizartiemposistema -lbcm2835 -lwiringPi 

/*-------------------------------------------------------------------------------------------------------------------------
Autor: Milton Munoz
Fecha de creacion: 22/01/13
Observaciones:
Direccion concentrador: 0
Funcion 1: Inicio de medicion.
Funcion 2: Lectura de datos.
Funcion 3: Escritura de datos.
Funcion 4: Test comunicacion
        Subfuncion 1: Test SPI (sumRecibido=1645)
        Subfuncion 2: Test RS485 (sumRecibido=1805)

uso: ./sincronizartiemposistema [opcion] [0: (L)Consultar hora actural dsPIC, 1: (E)Enviar hora RPi, 2: (E)Recibir hora GPS, 3: (E)Recibir hora RTC,  9: Test comunicacion SPI]
-------------------------------------------------------------------------------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <wiringPi.h>
#include <bcm2835.h>
#include <time.h>
#include <string.h>
#include <unistd.h>
#include <sys/time.h>

//Declaracion de constantes
#define P1 0																	//Pin 11 GPIO
#define MCLR 28																	//Pin 38 GPIO
#define LEDTEST 29 																//Pin 40 GPIO																						
#define TIEMPO_SPI 100
#define FreqSPI 200000


//Declaracion de variables
unsigned int i, x;
unsigned char bufferSPI;

unsigned char idPet;
unsigned char funcionPet;
unsigned char subFuncionPet;
unsigned int numDatosPet;

unsigned char idResp;
unsigned char funcionResp;
unsigned char subFuncionResp;
unsigned int numDatosResp;
unsigned char *ptrNumDatosResp;

unsigned char payloadPet[20];
unsigned char payloadResp[2600];

unsigned char tiempoPIC[8];
char fuenteRelojPIC;
int fuenteTiempo;
unsigned char errorSinc;

struct timeval  tv1, tv2;
double tiempoEjecucion;

//Declaracion de funciones
int ConfiguracionPrincipal();
void EnviarSolicitud(unsigned char id, unsigned char funcion, unsigned char subFuncion, unsigned char numDatos, unsigned char* payload);
void RecibirRespuesta();
void RecibirPayloadConcentrador(unsigned int numBytesPyload, unsigned char* pyloadConcentrador);
void EnviarTiempoRPi();														
void SincronizarTiempo(short fuenteTiempoPIC);
void ObtenerTiempoPIC();
void SetRelojLocal(unsigned char* tramaTiempo);
void Salir();

//**************************************************************************************************************************************
//************************************************************** Principal *************************************************************
//**************************************************************************************************************************************
int main(int argc, char *argv[]){

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
	ptrNumDatosResp = (unsigned char *) & numDatosResp;
	
	fuenteTiempo = atoi(argv[1]); 
	
	errorSinc = 0;
	
	//Configuracion principal:
	ConfiguracionPrincipal();
		
	//Obtencion de fuente de reloj:
	SincronizarTiempo(fuenteTiempo);	
			 
	while(1){}

}
//**************************************************************************************************************************************


//**************************************************************************************************************************************
//************************************************************** Funciones *************************************************************
//**************************************************************************************************************************************

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
    pinMode(P1, INPUT);
	pinMode(MCLR, OUTPUT);
	pinMode(LEDTEST, OUTPUT);
	wiringPiISR (P1, INT_EDGE_RISING, RecibirRespuesta);
		
	//printf("Configuracion completa\n");
	
}
//**************************************************************************************************************************************

//**************************************************************************************************************************************
//Funcion para enviar la solicitud al dsPIC (C:0xA0 F:0xF0):
void EnviarSolicitud(unsigned char id, unsigned char funcion, unsigned char subFuncion, unsigned char numDatos, unsigned char* payload){
		
	bcm2835_delayMicroseconds(200);
	
	//Envia la cabecera: [id, funcion, subfuncion, #Datos]:
	bcm2835_spi_transfer(0xA0);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(id);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(funcion);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(subFuncion);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(numDatos);
	bcm2835_spi_transfer(0x00);     //Envia este byte para simular el MSB de la variable numDatos. Es poco probable que una solicitud tenga un pyload de mas de 255 bytes.
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	
	//Envia el payload:
	for (i=0;i<numDatos;i++){
        bcm2835_spi_transfer(payload[i]);
        bcm2835_delayMicroseconds(TIEMPO_SPI);
    }
		
	//Envia el delimitador de fin de trama:
	bcm2835_spi_transfer(0xF0);	
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	
	//Imprime la solicitud:
	printf("\n>Solicitud enviada");
	
	//Enciende el LEDTEST:
	digitalWrite (LEDTEST, HIGH);
	
}
//**************************************************************************************************************************************

//**************************************************************************************************************************************
//Funcion para recibir la cabecera de respuesta (C:0xA1 F:0xF1):
void RecibirRespuesta(){
		
	bcm2835_delayMicroseconds(200);
		
	//Recupera la cabecera de la respuesta: [id, funcion, subfuncion, lsbNumDatos, msbNumDatos]:
	bcm2835_spi_transfer(0xA1);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	idResp = bcm2835_spi_transfer(0x00);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	funcionResp = bcm2835_spi_transfer(0x00);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	subFuncionResp = bcm2835_spi_transfer(0x00);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	*(ptrNumDatosResp) = bcm2835_spi_transfer(0x00);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	*(ptrNumDatosResp+1) = bcm2835_spi_transfer(0x00);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(0xF1);	

	delay(25); //**Este retardo es muy importante**
	
	//Recupera el payload enviado por el concentrador:
	RecibirPayloadConcentrador(numDatosResp, payloadResp);	
		
	//Imprime mensaje de respuesta:
	printf("\n>Respuesta recibida\n");
			
	//Apaga el LEDTEST:
	digitalWrite (LEDTEST, LOW);
		
	//Imprime fecha/hora del dsPIC:
	ObtenerTiempoPIC();
	
	Salir();
		
}
//**************************************************************************************************************************************

//**************************************************************************************************************************************
//Funcion para testear la comunicacion SPI con el concentrador (C:0xA3 F:0xF3):
void RecibirPayloadConcentrador(unsigned int numBytesPyload, unsigned char* pyloadConcentrador){
		
	bcm2835_spi_transfer(0xA3);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	for (i=0;i<numBytesPyload;i++){
        bufferSPI = bcm2835_spi_transfer(0x00);
        pyloadConcentrador[i] = bufferSPI;
        bcm2835_delayMicroseconds(TIEMPO_SPI);
    }
	bcm2835_spi_transfer(0xF3);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
		
}
//**************************************************************************************************************************************

//**************************************************************************************************************************************
//Funcion para procesar sincronizar el tiempo de la RPi y el del dsPIC
void SincronizarTiempo(short fuenteTiempoPIC){
		
	if (fuenteTiempoPIC==1){
		printf("\nEnviando referencia de tiempo de la RPi...");
	} else {
		printf("\nObteniendo referencia de tiempo del dsPIC...");
	}
	
	switch (fuenteTiempoPIC){
			case 0: 
					//Realiza una lectura del tiempo actual del dsPIC
					idPet = 0;
					funcionPet = 2;
					subFuncionPet = 0;
					numDatosPet = 0;
					EnviarSolicitud(idPet, funcionPet, subFuncionPet, numDatosPet, payloadPet);
					break;
			case 1:
					//Envia el tiempo locar de la RPi al dsPIC:
					EnviarTiempoRPi();
					break;
			case 2:
					//Obtiene la hora del GPS
					idPet = 0;
					funcionPet = 3;
					subFuncionPet = 2;
					numDatosPet = 0;
					EnviarSolicitud(idPet, funcionPet, subFuncionPet, numDatosPet, payloadPet);
					break;			
			case 3:
					//Obtiene la hora del RTC
					idPet = 0;
					funcionPet = 3;
					subFuncionPet = 3;
					numDatosPet = 0;
					EnviarSolicitud(idPet, funcionPet, subFuncionPet, numDatosPet, payloadPet);
					break;
			default:
					//Prueba la comunicacion SPI
					idPet = 0;
					funcionPet = 4;
					subFuncionPet = 1;
					numDatosPet = 5;
					payloadPet[0] = 1;
					payloadPet[1] = 2;
					payloadPet[2] = 3;
					payloadPet[3] = 4;
					payloadPet[4] = 5;
					EnviarSolicitud(idPet, funcionPet, subFuncionPet, numDatosPet, payloadPet);
					break;
					
	}
		
}
//**************************************************************************************************************************************

//**************************************************************************************************************************************
//Funcion para obtener la hora/fecha de la RPi y enviarla al dsPIC:
void EnviarTiempoRPi(){
	
	//Obtiene la hora y la fecha del sistema:
	//printf("Tiempo RPi: ");
	time_t t;
	struct tm *tm;
	t=time(NULL);
	tm=localtime(&t);
	
	payloadPet[0] = tm->tm_year-100;		//Anio (contado desde 1900)
	payloadPet[1] = tm->tm_mon+1;			//Mes desde Enero (0-11)
	payloadPet[2] = tm->tm_mday;			//Dia del mes (0-31)
	payloadPet[3] = tm->tm_hour;			//Hora
	payloadPet[4] = tm->tm_min;				//Minuto
	payloadPet[5] = tm->tm_sec;				//Segundo 
				
	idPet = 0;
	funcionPet = 3;
	subFuncionPet = 1;
	numDatosPet = 6;
	EnviarSolicitud(idPet, funcionPet, subFuncionPet, numDatosPet, payloadPet);
	
}
//**************************************************************************************************************************************

//**************************************************************************************************************************************
//Funcion para visualizar y procesar el tiempo recuperado del dsPIC
void ObtenerTiempoPIC(){
	
	//Imprime la trama de solicitud:
	printf("\nTrama enviada:");
	printf("\n Cabecera: %d %d %d %d", idPet, funcionPet, subFuncionPet, numDatosPet);
	printf("\n Payload: ");
	for (i=0;i<numDatosPet;i++){
        printf("%#02X ", payloadPet[i]);
    }
	//Imprime la trama de respuesta:
	printf("\nTrama recibida:");
	printf("\n Cabecera: %d %d %d %d", idResp, funcionResp, subFuncionResp, numDatosResp);
	printf("\n Payload: ");
	for (i=0;i<numDatosResp;i++){
		printf("%#02X ", payloadResp[i]);
	}
	
	if (funcionPet==3&&subFuncionPet==1){
		
		//Imprime la hora enviada por la RPi:
		printf("\n\nTiempo RPi: ");
		printf("%0.2d/",payloadPet[0]);			//aa
		printf("%0.2d/",payloadPet[1]);			//MM
		printf("%0.2d ",payloadPet[2]);			//dd
		printf("%0.2d:",payloadPet[3]);			//hh
		printf("%0.2d:",payloadPet[4]);			//mm
		printf("%0.2d\n",payloadPet[5]);		//ss
		
		//Imprime la hora recibida del dsPIC:
		printf("Tiempo dsPIC: ");
		printf("%0.2d/",payloadResp[0]);			//aa
		printf("%0.2d/",payloadResp[1]);			//MM
		printf("%0.2d ",payloadResp[2]);			//dd
		printf("%0.2d:",payloadResp[3]);			//hh
		printf("%0.2d:",payloadResp[4]);			//mm
		printf("%0.2d\n",payloadResp[5]);			//ss
				
	
	}else{
		
		//Imprime la hora recuperada del dsPIC:
		printf("\n");
		printf("\nTiempo dsPIC: ");
		
		fuenteRelojPIC = payloadResp[numDatosResp-1];
		switch (fuenteRelojPIC){
				case 1: 
						printf("RPi ");
						break;
				case 2:
						printf("GPS ");
						break;
				case 3:
						printf("RTC ");
						break;			
				default:
						errorSinc = fuenteRelojPIC;
						printf("E%d ", errorSinc);
						break;
		}
		
		printf("%0.2d/",payloadResp[0]);		//aa
		printf("%0.2d/",payloadResp[1]);		//MM
		printf("%0.2d ",payloadResp[2]);		//dd
		printf("%0.2d:",payloadResp[3]);		//hh
		printf("%0.2d:",payloadResp[4]);		//mm
		printf("%0.2d\n",payloadResp[5]);		//ss
		
		if (errorSinc!=0){
			switch (errorSinc){
					case 5: 
							printf("**Error 5: Problemas al recuperar la trama GPRMC del GPS\n");
							break;
					case 6:
							printf("**Error 6: La hora del GPS no esta comprobada\n");   //Corregir en el concentrador//
							break;
					case 7:
							printf("**Error 7: El GPS tarda en responder\n");
							break;			
			}
		}
	
	}	
	
	
	//tiempoEjecucion = ((double)(tv2.tv_usec - tv1.tv_usec));
	//printf ("\nTiempo de descarga = %0.3f us", tiempoEjecucion);
		
	Salir();
	
}
//**************************************************************************************************************************************

//**************************************************************************************************************************************
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

//**************************************************************************************************************************************
void Salir(){
	
	bcm2835_spi_end();
	bcm2835_close();
	//printf("\nAdios...\n");
	printf("\n");
	exit (-1);
}
//**************************************************************************************************************************************

//Fuentes de reloj: 
//1->RPi, 2->GPS, 3->RTC
//Errores:
//Error E5: Problemas al recuperar la trama GPRMC del GPS
//Error E6: La hora del GPS es invalida
//Error E7: El GPS tarda en responder
//Configurar reloj RPi: 
//sudo date --set '2020-09-08 16:10:00'

//Medir tiempo de ejecucion:
//#include <sys/time.h>
//struct tv1, tv2;
//double tiempoEjecucion;
//gettimeofday(&tv1, NULL);
//gettimeofday(&tv2, NULL);
//tiempoEjecucion = (double)(tv2.tv_sec - tv1.tv_sec)+((double)(tv2.tv_usec - tv1.tv_usec)/1000000);



