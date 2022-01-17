
_DS3234_init:

;tiempo_rtc.c,55 :: 		void DS3234_init(){
;tiempo_rtc.c,57 :: 		SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_ACTIVE_2_IDLE);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CLR	W13
	MOV	#28, W12
	CLR	W11
	MOV	#32, W10
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CALL	_SPI2_Init_Advanced
	SUB	#8, W15
;tiempo_rtc.c,58 :: 		DS3234_write_byte(Control,0x20);
	MOV.B	#32, W11
	MOV.B	#142, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,59 :: 		DS3234_write_byte(ControlStatus,0x08);
	MOV.B	#8, W11
	MOV.B	#143, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,60 :: 		SPI2_Init();
	CALL	_SPI2_Init
;tiempo_rtc.c,62 :: 		}
L_end_DS3234_init:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _DS3234_init

_DS3234_write_byte:

;tiempo_rtc.c,65 :: 		void DS3234_write_byte(unsigned char address, unsigned char value){
;tiempo_rtc.c,67 :: 		CS_DS3234 = 0;
	PUSH	W10
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;tiempo_rtc.c,68 :: 		SPI2_Write(address);
	ZE	W10, W10
	CALL	_SPI2_Write
;tiempo_rtc.c,69 :: 		SPI2_Write(value);
	ZE	W11, W10
	CALL	_SPI2_Write
;tiempo_rtc.c,70 :: 		CS_DS3234 = 1;
	BSET	LATA2_bit, BitPos(LATA2_bit+0)
;tiempo_rtc.c,72 :: 		}
L_end_DS3234_write_byte:
	POP	W10
	RETURN
; end of _DS3234_write_byte

_DS3234_read_byte:

;tiempo_rtc.c,75 :: 		unsigned char DS3234_read_byte(unsigned char address){
;tiempo_rtc.c,77 :: 		unsigned char value = 0x00;
	PUSH	W10
;tiempo_rtc.c,78 :: 		CS_DS3234 = 0;
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;tiempo_rtc.c,79 :: 		SPI2_Write(address);
	ZE	W10, W10
	CALL	_SPI2_Write
;tiempo_rtc.c,80 :: 		value = SPI2_Read(0);
	CLR	W10
	CALL	_SPI2_Read
;tiempo_rtc.c,81 :: 		CS_DS3234 = 1;
	BSET	LATA2_bit, BitPos(LATA2_bit+0)
;tiempo_rtc.c,82 :: 		return value;
;tiempo_rtc.c,84 :: 		}
;tiempo_rtc.c,82 :: 		return value;
;tiempo_rtc.c,84 :: 		}
L_end_DS3234_read_byte:
	POP	W10
	RETURN
; end of _DS3234_read_byte

_DS3234_setDate:
	LNK	#14

;tiempo_rtc.c,87 :: 		void DS3234_setDate(unsigned long longHora, unsigned long longFecha){
;tiempo_rtc.c,97 :: 		SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_ACTIVE_2_IDLE);
	PUSH	W10
	PUSH	W11
	PUSH.D	W12
	PUSH.D	W10
	CLR	W13
	MOV	#28, W12
	CLR	W11
	MOV	#32, W10
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CALL	_SPI2_Init_Advanced
	SUB	#8, W15
	POP.D	W10
	POP.D	W12
;tiempo_rtc.c,99 :: 		anio = (short)(longFecha / 10000);
	PUSH.D	W12
	PUSH.D	W10
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W12, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W10
	POP.D	W12
	MOV.B	W0, [W14+4]
;tiempo_rtc.c,100 :: 		mes = (short)((longFecha%10000) / 100);
	PUSH.D	W10
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W12, W0
	CLR	W4
	CALL	__Modulus_32x32
	MOV	W0, [W14+10]
	MOV	W1, [W14+12]
	MOV	#100, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Divide_32x32
	MOV.B	W0, [W14+3]
;tiempo_rtc.c,101 :: 		dia = (short)((longFecha%10000) % 100);
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#100, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
	POP.D	W10
	MOV.B	W0, [W14+2]
;tiempo_rtc.c,103 :: 		hora = (short)(longHora / 3600);
	PUSH.D	W10
	MOV	#3600, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W10
	MOV.B	W0, [W14+0]
;tiempo_rtc.c,104 :: 		minuto = (short)((longHora%3600) / 60);
	MOV	#3600, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Modulus_32x32
	MOV	W0, [W14+10]
	MOV	W1, [W14+12]
	MOV	#60, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Divide_32x32
	MOV.B	W0, [W14+1]
;tiempo_rtc.c,105 :: 		segundo = (short)((longHora%3600) % 60);
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#60, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
; segundo start address is: 8 (W4)
	MOV.B	W0, W4
;tiempo_rtc.c,107 :: 		anio = Dec2Bcd(anio);
	MOV.B	[W14+4], W10
	CALL	_Dec2Bcd
	MOV.B	W0, [W14+4]
;tiempo_rtc.c,108 :: 		dia = Dec2Bcd(dia);
	MOV.B	[W14+2], W10
	CALL	_Dec2Bcd
	MOV.B	W0, [W14+2]
;tiempo_rtc.c,109 :: 		mes = Dec2Bcd(mes);
	MOV.B	[W14+3], W10
	CALL	_Dec2Bcd
	MOV.B	W0, [W14+3]
;tiempo_rtc.c,110 :: 		segundo = Dec2Bcd(segundo);
	MOV.B	W4, W10
; segundo end address is: 8 (W4)
	CALL	_Dec2Bcd
; segundo start address is: 8 (W4)
	MOV.B	W0, W4
;tiempo_rtc.c,111 :: 		minuto = Dec2Bcd(minuto);
	MOV.B	[W14+1], W10
	CALL	_Dec2Bcd
	MOV.B	W0, [W14+1]
;tiempo_rtc.c,112 :: 		hora = Dec2Bcd(hora);
	MOV.B	[W14+0], W10
	CALL	_Dec2Bcd
	MOV.B	W0, [W14+0]
;tiempo_rtc.c,114 :: 		DS3234_write_byte(Segundos_Esc, segundo);
	MOV.B	W4, W11
; segundo end address is: 8 (W4)
	MOV.B	#128, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,115 :: 		DS3234_write_byte(Minutos_Esc, minuto);
	MOV.B	[W14+1], W11
	MOV.B	#129, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,116 :: 		DS3234_write_byte(Horas_Esc, hora);
	MOV.B	[W14+0], W11
	MOV.B	#130, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,117 :: 		DS3234_write_byte(DiaMes_Esc, dia);
	MOV.B	[W14+2], W11
	MOV.B	#132, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,118 :: 		DS3234_write_byte(Mes_Esc, mes);
	MOV.B	[W14+3], W11
	MOV.B	#133, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,119 :: 		DS3234_write_byte(Anio_Esc, anio);
	MOV.B	[W14+4], W11
	MOV.B	#134, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,121 :: 		SPI2_Init();
	CALL	_SPI2_Init
;tiempo_rtc.c,125 :: 		}
;tiempo_rtc.c,123 :: 		return;
;tiempo_rtc.c,125 :: 		}
L_end_DS3234_setDate:
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _DS3234_setDate

_RecuperarHoraRTC:
	LNK	#4

;tiempo_rtc.c,128 :: 		unsigned long RecuperarHoraRTC(){
;tiempo_rtc.c,136 :: 		SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_ACTIVE_2_IDLE);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CLR	W13
	MOV	#28, W12
	CLR	W11
	MOV	#32, W10
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CALL	_SPI2_Init_Advanced
	SUB	#8, W15
;tiempo_rtc.c,138 :: 		valueRead = DS3234_read_byte(Segundos_Lec);
	CLR	W10
	CALL	_DS3234_read_byte
;tiempo_rtc.c,139 :: 		valueRead = Bcd2Dec(valueRead);
	MOV.B	W0, W10
	CALL	_Bcd2Dec
;tiempo_rtc.c,140 :: 		segundo = (long)valueRead;
; segundo start address is: 12 (W6)
	ZE	W0, W6
	CLR	W7
;tiempo_rtc.c,141 :: 		valueRead = DS3234_read_byte(Minutos_Lec);
	MOV.B	#1, W10
	CALL	_DS3234_read_byte
;tiempo_rtc.c,142 :: 		valueRead = Bcd2Dec(valueRead);
	MOV.B	W0, W10
	CALL	_Bcd2Dec
;tiempo_rtc.c,143 :: 		minuto = (long)valueRead;
; minuto start address is: 16 (W8)
	ZE	W0, W8
	CLR	W9
;tiempo_rtc.c,145 :: 		valueRead = DS3234_read_byte(Horas_Lec);
	MOV.B	#2, W10
	CALL	_DS3234_read_byte
;tiempo_rtc.c,146 :: 		valueRead = Bcd2Dec(valueRead);
	MOV.B	W0, W10
	CALL	_Bcd2Dec
;tiempo_rtc.c,147 :: 		hora = (long)valueRead;
	ZE	W0, W0
	CLR	W1
;tiempo_rtc.c,149 :: 		horaRTC = (hora*3600)+(minuto*60)+(segundo);                               //Calcula el segundo actual = hh*3600 + mm*60 + ss
	MOV	#3600, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV.D	W8, W0
	MOV	#60, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
; minuto end address is: 16 (W8)
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	ADD	W2, W0, W0
	ADDC	W3, W1, W1
; horaRTC start address is: 4 (W2)
	ADD	W0, W6, W2
	ADDC	W1, W7, W3
; segundo end address is: 12 (W6)
;tiempo_rtc.c,151 :: 		SPI2_Init();
	CALL	_SPI2_Init
;tiempo_rtc.c,153 :: 		return horaRTC;
	MOV.D	W2, W0
; horaRTC end address is: 4 (W2)
;tiempo_rtc.c,155 :: 		}
;tiempo_rtc.c,153 :: 		return horaRTC;
;tiempo_rtc.c,155 :: 		}
L_end_RecuperarHoraRTC:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _RecuperarHoraRTC

_RecuperarFechaRTC:
	LNK	#4

;tiempo_rtc.c,158 :: 		unsigned long RecuperarFechaRTC(){
;tiempo_rtc.c,166 :: 		SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_ACTIVE_2_IDLE);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CLR	W13
	MOV	#28, W12
	CLR	W11
	MOV	#32, W10
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CALL	_SPI2_Init_Advanced
	SUB	#8, W15
;tiempo_rtc.c,168 :: 		valueRead = DS3234_read_byte(DiaMes_Lec);
	MOV.B	#4, W10
	CALL	_DS3234_read_byte
;tiempo_rtc.c,169 :: 		valueRead = Bcd2Dec(valueRead);
	MOV.B	W0, W10
	CALL	_Bcd2Dec
;tiempo_rtc.c,170 :: 		dia = (long)valueRead;
; dia start address is: 12 (W6)
	ZE	W0, W6
	CLR	W7
;tiempo_rtc.c,171 :: 		valueRead = 0x1F & DS3234_read_byte(Mes_Lec);
	MOV.B	#5, W10
	CALL	_DS3234_read_byte
	ZE	W0, W0
	AND	W0, #31, W0
;tiempo_rtc.c,172 :: 		valueRead = Bcd2Dec(valueRead);
	MOV.B	W0, W10
	CALL	_Bcd2Dec
;tiempo_rtc.c,173 :: 		mes = (long)valueRead;
; mes start address is: 16 (W8)
	ZE	W0, W8
	CLR	W9
;tiempo_rtc.c,174 :: 		valueRead = DS3234_read_byte(Anio_Lec);
	MOV.B	#6, W10
	CALL	_DS3234_read_byte
;tiempo_rtc.c,175 :: 		valueRead = Bcd2Dec(valueRead);
	MOV.B	W0, W10
	CALL	_Bcd2Dec
;tiempo_rtc.c,176 :: 		anio = (long)valueRead;
	ZE	W0, W0
	CLR	W1
;tiempo_rtc.c,178 :: 		fechaRTC = (anio*10000)+(mes*100)+(dia);                                   //10000*aa + 100*mm + dd
	MOV	#10000, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV.D	W8, W0
	MOV	#100, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
; mes end address is: 16 (W8)
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	ADD	W2, W0, W0
	ADDC	W3, W1, W1
; fechaRTC start address is: 4 (W2)
	ADD	W0, W6, W2
	ADDC	W1, W7, W3
; dia end address is: 12 (W6)
;tiempo_rtc.c,180 :: 		SPI2_Init();
	CALL	_SPI2_Init
;tiempo_rtc.c,182 :: 		return fechaRTC;
	MOV.D	W2, W0
; fechaRTC end address is: 4 (W2)
;tiempo_rtc.c,184 :: 		}
;tiempo_rtc.c,182 :: 		return fechaRTC;
;tiempo_rtc.c,184 :: 		}
L_end_RecuperarFechaRTC:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _RecuperarFechaRTC

_IncrementarFecha:
	LNK	#4

;tiempo_rtc.c,187 :: 		unsigned long IncrementarFecha(unsigned long longFecha){
;tiempo_rtc.c,194 :: 		anio = longFecha / 10000;
	PUSH.D	W10
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W10
; anio start address is: 4 (W2)
	MOV.D	W0, W2
;tiempo_rtc.c,195 :: 		mes = (longFecha%10000) / 100;
	PUSH.D	W2
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Modulus_32x32
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV	#100, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W2
; mes start address is: 8 (W4)
	MOV.D	W0, W4
;tiempo_rtc.c,196 :: 		dia = (longFecha%10000) % 100;
	MOV	[W14+0], W0
	MOV	[W14+2], W1
	PUSH.D	W4
	PUSH.D	W2
	MOV	#100, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
	POP.D	W2
	POP.D	W4
; dia start address is: 12 (W6)
	MOV.D	W0, W6
;tiempo_rtc.c,198 :: 		if (dia<28){
	CP	W0, #28
	CPB	W1, #0
	BRA LTU	L__IncrementarFecha281
	GOTO	L_IncrementarFecha0
L__IncrementarFecha281:
;tiempo_rtc.c,199 :: 		dia++;
; dia start address is: 16 (W8)
	ADD	W6, #1, W8
	ADDC	W7, #0, W9
; dia end address is: 12 (W6)
;tiempo_rtc.c,200 :: 		} else {
; dia end address is: 16 (W8)
	MOV.D	W4, W6
	GOTO	L_IncrementarFecha1
L_IncrementarFecha0:
;tiempo_rtc.c,201 :: 		if (mes==2){
; dia start address is: 12 (W6)
	CP	W4, #2
	CPB	W5, #0
	BRA Z	L__IncrementarFecha282
	GOTO	L_IncrementarFecha2
L__IncrementarFecha282:
;tiempo_rtc.c,203 :: 		if (((anio-16)%4)==0){
	SUB	W2, #16, W0
	SUBB	W3, #0, W1
	AND	W0, #3, W0
	AND	W1, #0, W1
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__IncrementarFecha283
	GOTO	L_IncrementarFecha3
L__IncrementarFecha283:
;tiempo_rtc.c,204 :: 		if (dia==29){
	CP	W6, #29
	CPB	W7, #0
	BRA Z	L__IncrementarFecha284
	GOTO	L_IncrementarFecha4
L__IncrementarFecha284:
; dia end address is: 12 (W6)
;tiempo_rtc.c,205 :: 		dia = 1;
; dia start address is: 0 (W0)
	MOV	#1, W0
	MOV	#0, W1
;tiempo_rtc.c,206 :: 		mes++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
;tiempo_rtc.c,207 :: 		} else {
; dia end address is: 0 (W0)
	GOTO	L_IncrementarFecha5
L_IncrementarFecha4:
;tiempo_rtc.c,208 :: 		dia++;
; dia start address is: 0 (W0)
; dia start address is: 12 (W6)
	ADD	W6, #1, W0
	ADDC	W7, #0, W1
; dia end address is: 12 (W6)
; mes end address is: 8 (W4)
; dia end address is: 0 (W0)
;tiempo_rtc.c,209 :: 		}
L_IncrementarFecha5:
;tiempo_rtc.c,210 :: 		} else {
; dia start address is: 0 (W0)
; mes start address is: 8 (W4)
	MOV.D	W0, W8
; dia end address is: 0 (W0)
	MOV.D	W4, W6
	GOTO	L_IncrementarFecha6
L_IncrementarFecha3:
;tiempo_rtc.c,211 :: 		dia = 1;
; dia start address is: 0 (W0)
	MOV	#1, W0
	MOV	#0, W1
;tiempo_rtc.c,212 :: 		mes++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
	MOV.D	W0, W8
; mes end address is: 8 (W4)
; dia end address is: 0 (W0)
	MOV.D	W4, W6
;tiempo_rtc.c,213 :: 		}
L_IncrementarFecha6:
;tiempo_rtc.c,214 :: 		} else {
; mes start address is: 12 (W6)
; dia start address is: 16 (W8)
; mes end address is: 12 (W6)
; dia end address is: 16 (W8)
	GOTO	L_IncrementarFecha7
L_IncrementarFecha2:
;tiempo_rtc.c,215 :: 		if (dia<30){
; mes start address is: 8 (W4)
; dia start address is: 12 (W6)
	CP	W6, #30
	CPB	W7, #0
	BRA LTU	L__IncrementarFecha285
	GOTO	L_IncrementarFecha8
L__IncrementarFecha285:
;tiempo_rtc.c,216 :: 		dia++;
; dia start address is: 0 (W0)
	ADD	W6, #1, W0
	ADDC	W7, #0, W1
; dia end address is: 12 (W6)
;tiempo_rtc.c,217 :: 		} else {
	PUSH.D	W4
; dia end address is: 0 (W0)
	MOV.D	W2, W4
	MOV.D	W0, W2
	POP.D	W0
	GOTO	L_IncrementarFecha9
L_IncrementarFecha8:
;tiempo_rtc.c,218 :: 		if (mes==4||mes==6||mes==9||mes==11){
; dia start address is: 12 (W6)
	CP	W4, #4
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha286
	GOTO	L__IncrementarFecha196
L__IncrementarFecha286:
	CP	W4, #6
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha287
	GOTO	L__IncrementarFecha195
L__IncrementarFecha287:
	CP	W4, #9
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha288
	GOTO	L__IncrementarFecha194
L__IncrementarFecha288:
	CP	W4, #11
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha289
	GOTO	L__IncrementarFecha193
L__IncrementarFecha289:
	MOV.D	W4, W0
	MOV.D	W6, W4
	GOTO	L_IncrementarFecha12
L__IncrementarFecha196:
L__IncrementarFecha195:
L__IncrementarFecha194:
L__IncrementarFecha193:
;tiempo_rtc.c,219 :: 		if (dia==30){
	CP	W6, #30
	CPB	W7, #0
	BRA Z	L__IncrementarFecha290
	GOTO	L_IncrementarFecha13
L__IncrementarFecha290:
; dia end address is: 12 (W6)
;tiempo_rtc.c,220 :: 		dia = 1;
; dia start address is: 0 (W0)
	MOV	#1, W0
	MOV	#0, W1
;tiempo_rtc.c,221 :: 		mes++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
;tiempo_rtc.c,222 :: 		} else {
	PUSH.D	W0
; dia end address is: 0 (W0)
	MOV.D	W4, W0
	POP.D	W4
	GOTO	L_IncrementarFecha14
L_IncrementarFecha13:
;tiempo_rtc.c,223 :: 		dia++;
; dia start address is: 0 (W0)
; dia start address is: 12 (W6)
	ADD	W6, #1, W0
	ADDC	W7, #0, W1
; dia end address is: 12 (W6)
	PUSH.D	W0
; mes end address is: 8 (W4)
; dia end address is: 0 (W0)
	MOV.D	W4, W0
	POP.D	W4
;tiempo_rtc.c,224 :: 		}
L_IncrementarFecha14:
;tiempo_rtc.c,225 :: 		}
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
L_IncrementarFecha12:
;tiempo_rtc.c,226 :: 		if ((dia!=1)&&(mes==1||mes==3||mes==5||mes==7||mes==8||mes==10)){
; mes start address is: 0 (W0)
; dia start address is: 8 (W4)
	CP	W4, #1
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha291
	GOTO	L__IncrementarFecha206
L__IncrementarFecha291:
	CP	W0, #1
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha292
	GOTO	L__IncrementarFecha202
L__IncrementarFecha292:
	CP	W0, #3
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha293
	GOTO	L__IncrementarFecha201
L__IncrementarFecha293:
	CP	W0, #5
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha294
	GOTO	L__IncrementarFecha200
L__IncrementarFecha294:
	CP	W0, #7
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha295
	GOTO	L__IncrementarFecha199
L__IncrementarFecha295:
	CP	W0, #8
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha296
	GOTO	L__IncrementarFecha198
L__IncrementarFecha296:
	CP	W0, #10
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha297
	GOTO	L__IncrementarFecha197
L__IncrementarFecha297:
	GOTO	L_IncrementarFecha19
L__IncrementarFecha202:
L__IncrementarFecha201:
L__IncrementarFecha200:
L__IncrementarFecha199:
L__IncrementarFecha198:
L__IncrementarFecha197:
L__IncrementarFecha190:
;tiempo_rtc.c,227 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha298
	GOTO	L_IncrementarFecha20
L__IncrementarFecha298:
;tiempo_rtc.c,228 :: 		dia = 1;
	MOV	#1, W4
	MOV	#0, W5
;tiempo_rtc.c,229 :: 		mes++;
	ADD	W0, #1, W0
	ADDC	W1, #0, W1
;tiempo_rtc.c,230 :: 		} else {
	GOTO	L_IncrementarFecha21
L_IncrementarFecha20:
;tiempo_rtc.c,231 :: 		dia++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
;tiempo_rtc.c,232 :: 		}
L_IncrementarFecha21:
;tiempo_rtc.c,233 :: 		}
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
L_IncrementarFecha19:
;tiempo_rtc.c,226 :: 		if ((dia!=1)&&(mes==1||mes==3||mes==5||mes==7||mes==8||mes==10)){
; mes start address is: 0 (W0)
; dia start address is: 8 (W4)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
	GOTO	L__IncrementarFecha203
L__IncrementarFecha206:
L__IncrementarFecha203:
;tiempo_rtc.c,234 :: 		if ((dia!=1)&&(mes==12)){
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
	CP	W4, #1
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha299
	GOTO	L__IncrementarFecha207
L__IncrementarFecha299:
	CP	W0, #12
	CPB	W1, #0
	BRA Z	L__IncrementarFecha300
	GOTO	L__IncrementarFecha208
L__IncrementarFecha300:
L__IncrementarFecha189:
;tiempo_rtc.c,235 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha301
	GOTO	L_IncrementarFecha25
L__IncrementarFecha301:
; mes end address is: 0 (W0)
;tiempo_rtc.c,236 :: 		dia = 1;
	MOV	#1, W4
	MOV	#0, W5
;tiempo_rtc.c,237 :: 		mes = 1;
; mes start address is: 0 (W0)
	MOV	#1, W0
	MOV	#0, W1
;tiempo_rtc.c,238 :: 		anio++;
	ADD	W2, #1, W2
	ADDC	W3, #0, W3
;tiempo_rtc.c,239 :: 		} else {
	GOTO	L_IncrementarFecha26
L_IncrementarFecha25:
;tiempo_rtc.c,240 :: 		dia++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
;tiempo_rtc.c,241 :: 		}
L_IncrementarFecha26:
;tiempo_rtc.c,234 :: 		if ((dia!=1)&&(mes==12)){
; dia start address is: 8 (W4)
; anio start address is: 4 (W2)
; mes start address is: 0 (W0)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
	GOTO	L__IncrementarFecha205
L__IncrementarFecha207:
L__IncrementarFecha205:
; mes start address is: 0 (W0)
; anio start address is: 4 (W2)
; dia start address is: 8 (W4)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
	GOTO	L__IncrementarFecha204
L__IncrementarFecha208:
L__IncrementarFecha204:
;tiempo_rtc.c,243 :: 		}
; dia start address is: 8 (W4)
; anio start address is: 4 (W2)
; mes start address is: 0 (W0)
	PUSH.D	W2
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
	MOV.D	W4, W2
	POP.D	W4
L_IncrementarFecha9:
;tiempo_rtc.c,244 :: 		}
; mes start address is: 0 (W0)
; anio start address is: 8 (W4)
; dia start address is: 4 (W2)
	MOV.D	W0, W6
; mes end address is: 0 (W0)
; anio end address is: 8 (W4)
; dia end address is: 4 (W2)
	MOV.D	W2, W8
	MOV.D	W4, W2
L_IncrementarFecha7:
;tiempo_rtc.c,246 :: 		}
; dia start address is: 16 (W8)
; anio start address is: 4 (W2)
; mes start address is: 12 (W6)
; mes end address is: 12 (W6)
; anio end address is: 4 (W2)
; dia end address is: 16 (W8)
L_IncrementarFecha1:
;tiempo_rtc.c,248 :: 		fechaInc = (anio*10000)+(mes*100)+(dia);                                   //10000*aa + 100*mm + dd
; mes start address is: 12 (W6)
; anio start address is: 4 (W2)
; dia start address is: 16 (W8)
	MOV	#10000, W0
	MOV	#0, W1
	CALL	__Multiply_32x32
; anio end address is: 4 (W2)
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV.D	W6, W0
	MOV	#100, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
; mes end address is: 12 (W6)
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	ADD	W2, W0, W0
	ADDC	W3, W1, W1
	ADD	W0, W8, W0
	ADDC	W1, W9, W1
; dia end address is: 16 (W8)
;tiempo_rtc.c,249 :: 		return fechaInc;
;tiempo_rtc.c,251 :: 		}
L_end_IncrementarFecha:
	ULNK
	RETURN
; end of _IncrementarFecha

_AjustarTiempoSistema:
	LNK	#14

;tiempo_rtc.c,254 :: 		void AjustarTiempoSistema(unsigned long longHora, unsigned long longFecha, unsigned short *tramaTiempoSistema){
	MOV	[W14-8], W0
	MOV	W0, [W14-8]
;tiempo_rtc.c,263 :: 		anio = (short)(longFecha / 10000);
	PUSH.D	W12
	PUSH.D	W10
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W12, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W10
	POP.D	W12
	MOV.B	W0, [W14+4]
;tiempo_rtc.c,264 :: 		mes = (short)((longFecha%10000) / 100);
	PUSH.D	W10
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W12, W0
	CLR	W4
	CALL	__Modulus_32x32
	MOV	W0, [W14+10]
	MOV	W1, [W14+12]
	MOV	#100, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Divide_32x32
	MOV.B	W0, [W14+3]
;tiempo_rtc.c,265 :: 		dia = (short)((longFecha%10000) % 100);
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#100, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
	POP.D	W10
	MOV.B	W0, [W14+2]
;tiempo_rtc.c,267 :: 		hora = (short)(longHora / 3600);
	PUSH.D	W10
	MOV	#3600, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W10
	MOV.B	W0, [W14+0]
;tiempo_rtc.c,268 :: 		minuto = (short)((longHora%3600) / 60);
	MOV	#3600, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Modulus_32x32
	MOV	W0, [W14+10]
	MOV	W1, [W14+12]
	MOV	#60, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Divide_32x32
	MOV.B	W0, [W14+1]
;tiempo_rtc.c,269 :: 		segundo = (short)((longHora%3600) % 60);
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#60, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
; segundo start address is: 4 (W2)
	MOV.B	W0, W2
;tiempo_rtc.c,271 :: 		tramaTiempoSistema[0] = anio;
	MOV	[W14-8], W1
	MOV.B	[W14+4], W0
	MOV.B	W0, [W1]
;tiempo_rtc.c,272 :: 		tramaTiempoSistema[1] = mes;
	MOV	[W14-8], W0
	ADD	W0, #1, W1
	MOV.B	[W14+3], W0
	MOV.B	W0, [W1]
;tiempo_rtc.c,273 :: 		tramaTiempoSistema[2] = dia;
	MOV	[W14-8], W0
	ADD	W0, #2, W1
	MOV.B	[W14+2], W0
	MOV.B	W0, [W1]
;tiempo_rtc.c,274 :: 		tramaTiempoSistema[3] = hora;
	MOV	[W14-8], W0
	ADD	W0, #3, W1
	MOV.B	[W14+0], W0
	MOV.B	W0, [W1]
;tiempo_rtc.c,275 :: 		tramaTiempoSistema[4] = minuto;
	MOV	[W14-8], W0
	ADD	W0, #4, W1
	MOV.B	[W14+1], W0
	MOV.B	W0, [W1]
;tiempo_rtc.c,276 :: 		tramaTiempoSistema[5] = segundo;
	MOV	[W14-8], W0
	ADD	W0, #5, W0
	MOV.B	W2, [W0]
; segundo end address is: 4 (W2)
;tiempo_rtc.c,278 :: 		}
L_end_AjustarTiempoSistema:
	ULNK
	RETURN
; end of _AjustarTiempoSistema

_GPS_init:

;tiempo_gps.c,13 :: 		void GPS_init(short conf,short NMA){
;tiempo_gps.c,45 :: 		UART1_Write_Text("$PMTK605*31\r\n");
	PUSH	W10
	PUSH	W11
	MOV	#lo_addr(?lstr1_ConcentradorPrincipal), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,46 :: 		UART1_Write_Text("$PMTK220,1000*1F\r\n");
	MOV	#lo_addr(?lstr2_ConcentradorPrincipal), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,47 :: 		UART1_Write_Text("$PMTK251,115200*1F\r\n");
	MOV	#lo_addr(?lstr3_ConcentradorPrincipal), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,48 :: 		Delay_ms(1000);                                                            //Tiempo necesario para que se de efecto el cambio de configuracion
	MOV	#123, W8
	MOV	#4681, W7
L_GPS_init27:
	DEC	W7
	BRA NZ	L_GPS_init27
	DEC	W8
	BRA NZ	L_GPS_init27
;tiempo_gps.c,49 :: 		UART1_Init(115200);
	MOV	#49664, W10
	MOV	#1, W11
	CALL	_UART1_Init
;tiempo_gps.c,50 :: 		UART1_Write_Text("$PMTK313,1*2E\r\n");
	MOV	#lo_addr(?lstr4_ConcentradorPrincipal), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,51 :: 		UART1_Write_Text("$PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0*29\r\n");
	MOV	#lo_addr(?lstr5_ConcentradorPrincipal), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,52 :: 		UART1_Write_Text("$PMTK319,1*24\r\n");
	MOV	#lo_addr(?lstr6_ConcentradorPrincipal), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,53 :: 		UART1_Write_Text("$PMTK413*34\r\n");
	MOV	#lo_addr(?lstr7_ConcentradorPrincipal), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,54 :: 		UART1_Write_Text("$PMTK513,1*28\r\n");
	MOV	#lo_addr(?lstr8_ConcentradorPrincipal), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,55 :: 		Delay_ms(1000);
	MOV	#123, W8
	MOV	#4681, W7
L_GPS_init29:
	DEC	W7
	BRA NZ	L_GPS_init29
	DEC	W8
	BRA NZ	L_GPS_init29
;tiempo_gps.c,56 :: 		U1MODE.UARTEN = 0;                                                         //Desactiva el UART1
	BCLR	U1MODE, #15
;tiempo_gps.c,57 :: 		}
L_end_GPS_init:
	POP	W11
	POP	W10
	RETURN
; end of _GPS_init

_RecuperarFechaGPS:
	LNK	#28

;tiempo_gps.c,62 :: 		unsigned long RecuperarFechaGPS(unsigned char *tramaDatosGPS){
;tiempo_gps.c,67 :: 		char *ptrDatoStringF = &datoStringF;
	PUSH	W10
	ADD	W14, #16, W4
	MOV	W4, [W14+26]
; ptrDatoStringF start address is: 12 (W6)
	MOV	W4, W6
;tiempo_gps.c,68 :: 		datoStringF[2] = '\0';
	ADD	W4, #2, W1
	CLR	W0
	MOV.B	W0, [W1]
;tiempo_gps.c,69 :: 		tramaFecha[3] = '\0';
	ADD	W14, #0, W3
	MOV	W3, [W14+24]
	ADD	W3, #12, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;tiempo_gps.c,72 :: 		datoStringF[0] = tramaDatosGPS[10];
	ADD	W10, #10, W0
	MOV.B	[W0], [W4]
;tiempo_gps.c,73 :: 		datoStringF[1] = tramaDatosGPS[11];
	ADD	W4, #1, W1
	ADD	W10, #11, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,74 :: 		tramaFecha[0] = atoi(ptrDatoStringF);
	MOV	W3, W0
	MOV	W0, [W14+20]
	PUSH	W10
	MOV	W6, W10
	CALL	_atoi
	POP	W10
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;tiempo_gps.c,77 :: 		datoStringF[0] = tramaDatosGPS[8];
	ADD	W10, #8, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;tiempo_gps.c,78 :: 		datoStringF[1] = tramaDatosGPS[9];
	ADD	W0, #1, W1
	ADD	W10, #9, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,79 :: 		tramaFecha[1] = atoi(ptrDatoStringF);
	MOV	[W14+24], W0
	ADD	W0, #4, W0
	MOV	W0, [W14+20]
	PUSH	W10
	MOV	W6, W10
	CALL	_atoi
	POP	W10
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;tiempo_gps.c,82 :: 		datoStringF[0] = tramaDatosGPS[6];
	ADD	W10, #6, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;tiempo_gps.c,83 :: 		datoStringF[1] = tramaDatosGPS[7];
	ADD	W0, #1, W1
	ADD	W10, #7, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,84 :: 		tramaFecha[2] =  atoi(ptrDatoStringF);
	MOV	[W14+24], W0
	ADD	W0, #8, W0
	MOV	W0, [W14+20]
	MOV	W6, W10
; ptrDatoStringF end address is: 12 (W6)
	CALL	_atoi
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;tiempo_gps.c,86 :: 		fechaGPS = (tramaFecha[0]*10000)+(tramaFecha[1]*100)+(tramaFecha[2]);      //10000*aa + 100*mm + dd
	MOV	[W14+24], W2
	MOV.D	[W2], W0
	MOV	#10000, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+24], W2
	MOV	W0, [W14+20]
	MOV	W1, [W14+22]
	ADD	W2, #4, W2
	MOV.D	[W2], W0
	MOV	#100, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+20], W2
	MOV	[W14+22], W3
	ADD	W2, W0, W4
	ADDC	W3, W1, W5
	MOV	[W14+24], W0
	ADD	W0, #8, W2
	ADD	W4, [W2++], W0
	ADDC	W5, [W2--], W1
;tiempo_gps.c,88 :: 		return fechaGPS;
;tiempo_gps.c,90 :: 		}
;tiempo_gps.c,88 :: 		return fechaGPS;
;tiempo_gps.c,90 :: 		}
L_end_RecuperarFechaGPS:
	POP	W10
	ULNK
	RETURN
; end of _RecuperarFechaGPS

_RecuperarHoraGPS:
	LNK	#28

;tiempo_gps.c,93 :: 		unsigned long RecuperarHoraGPS(unsigned char *tramaDatosGPS){
;tiempo_gps.c,98 :: 		char *ptrDatoString = &datoString;
	PUSH	W10
	ADD	W14, #16, W4
	MOV	W4, [W14+26]
; ptrDatoString start address is: 12 (W6)
	MOV	W4, W6
;tiempo_gps.c,99 :: 		datoString[2] = '\0';
	ADD	W4, #2, W1
	CLR	W0
	MOV.B	W0, [W1]
;tiempo_gps.c,100 :: 		tramaTiempo[3] = '\0';
	ADD	W14, #0, W3
	MOV	W3, [W14+24]
	ADD	W3, #12, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;tiempo_gps.c,103 :: 		datoString[0] = tramaDatosGPS[0];
	MOV.B	[W10], [W4]
;tiempo_gps.c,104 :: 		datoString[1] = tramaDatosGPS[1];
	ADD	W4, #1, W1
	ADD	W10, #1, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,105 :: 		tramaTiempo[0] = atoi(ptrDatoString);
	MOV	W3, W0
	MOV	W0, [W14+20]
	PUSH	W10
	MOV	W6, W10
	CALL	_atoi
	POP	W10
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;tiempo_gps.c,108 :: 		datoString[0] = tramaDatosGPS[2];
	ADD	W10, #2, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;tiempo_gps.c,109 :: 		datoString[1] = tramaDatosGPS[3];
	ADD	W0, #1, W1
	ADD	W10, #3, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,110 :: 		tramaTiempo[1] = atoi(ptrDatoString);
	MOV	[W14+24], W0
	ADD	W0, #4, W0
	MOV	W0, [W14+20]
	PUSH	W10
	MOV	W6, W10
	CALL	_atoi
	POP	W10
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;tiempo_gps.c,113 :: 		datoString[0] = tramaDatosGPS[4];
	ADD	W10, #4, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;tiempo_gps.c,114 :: 		datoString[1] = tramaDatosGPS[5];
	ADD	W0, #1, W1
	ADD	W10, #5, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,115 :: 		tramaTiempo[2] = atoi(ptrDatoString);
	MOV	[W14+24], W0
	ADD	W0, #8, W0
	MOV	W0, [W14+20]
	MOV	W6, W10
; ptrDatoString end address is: 12 (W6)
	CALL	_atoi
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;tiempo_gps.c,117 :: 		horaGPS = (tramaTiempo[0]*3600)+(tramaTiempo[1]*60)+(tramaTiempo[2]);      //Calcula el segundo actual = hh*3600 + mm*60 + ss
	MOV	[W14+24], W2
	MOV.D	[W2], W0
	MOV	#3600, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+24], W2
	MOV	W0, [W14+20]
	MOV	W1, [W14+22]
	ADD	W2, #4, W2
	MOV.D	[W2], W0
	MOV	#60, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+20], W2
	MOV	[W14+22], W3
	ADD	W2, W0, W4
	ADDC	W3, W1, W5
	MOV	[W14+24], W0
	ADD	W0, #8, W2
	ADD	W4, [W2++], W0
	ADDC	W5, [W2--], W1
;tiempo_gps.c,118 :: 		return horaGPS;
;tiempo_gps.c,120 :: 		}
;tiempo_gps.c,118 :: 		return horaGPS;
;tiempo_gps.c,120 :: 		}
L_end_RecuperarHoraGPS:
	POP	W10
	ULNK
	RETURN
; end of _RecuperarHoraGPS

_RecuperarFechaRPI:
	LNK	#4

;tiempo_rpi.c,10 :: 		unsigned long RecuperarFechaRPI(unsigned short *tramaTiempoRpi){
;tiempo_rpi.c,14 :: 		fechaRPi = ((long)tramaTiempoRpi[0]*10000)+((long)tramaTiempoRpi[1]*100)+((long)tramaTiempoRpi[2]);      //10000*aa + 100*mm + dd
	ZE	[W10], W0
	CLR	W1
	MOV	#10000, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	ADD	W10, #1, W0
	ZE	[W0], W0
	CLR	W1
	MOV	#100, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	ADD	W2, W0, W2
	ADDC	W3, W1, W3
	ADD	W10, #2, W0
	ZE	[W0], W0
	CLR	W1
	ADD	W2, W0, W0
	ADDC	W3, W1, W1
;tiempo_rpi.c,16 :: 		return fechaRPi;
;tiempo_rpi.c,18 :: 		}
L_end_RecuperarFechaRPI:
	ULNK
	RETURN
; end of _RecuperarFechaRPI

_RecuperarHoraRPI:
	LNK	#4

;tiempo_rpi.c,21 :: 		unsigned long RecuperarHoraRPI(unsigned short *tramaTiempoRpi){
;tiempo_rpi.c,25 :: 		horaRPi = ((long)tramaTiempoRpi[3]*3600)+((long)tramaTiempoRpi[4]*60)+((long)tramaTiempoRpi[5]);      //Calcula el segundo actual = hh*3600 + mm*60 + ss
	ADD	W10, #3, W0
	ZE	[W0], W0
	CLR	W1
	MOV	#3600, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	ADD	W10, #4, W0
	ZE	[W0], W0
	CLR	W1
	MOV	#60, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	ADD	W2, W0, W2
	ADDC	W3, W1, W3
	ADD	W10, #5, W0
	ZE	[W0], W0
	CLR	W1
	ADD	W2, W0, W0
	ADDC	W3, W1, W1
;tiempo_rpi.c,27 :: 		return horaRPi;
;tiempo_rpi.c,29 :: 		}
L_end_RecuperarHoraRPI:
	ULNK
	RETURN
; end of _RecuperarHoraRPI

_EnviarTramaRS485:
	LNK	#2

;rs485.c,18 :: 		void EnviarTramaRS485(unsigned char puertoUART, unsigned char *cabecera, unsigned char *payload){
;rs485.c,30 :: 		ptrnumDatos = (unsigned char *) & numDatos;
	PUSH	W10
	ADD	W14, #0, W2
; ptrnumDatos start address is: 6 (W3)
	MOV	W2, W3
;rs485.c,33 :: 		direccion = cabecera[0];
; direccion start address is: 8 (W4)
	MOV.B	[W11], W4
;rs485.c,34 :: 		funcion = cabecera[1];
	ADD	W11, #1, W0
; funcion start address is: 10 (W5)
	MOV.B	[W0], W5
;rs485.c,35 :: 		subfuncion = cabecera[2];
	ADD	W11, #2, W0
; subfuncion start address is: 12 (W6)
	MOV.B	[W0], W6
;rs485.c,36 :: 		lsbNumDatos = cabecera[3];
	ADD	W11, #3, W1
; lsbNumDatos start address is: 14 (W7)
	MOV.B	[W1], W7
;rs485.c,37 :: 		msbNumDatos = cabecera[4];
	ADD	W11, #4, W0
; msbNumDatos start address is: 16 (W8)
	MOV.B	[W0], W8
;rs485.c,40 :: 		*(ptrnumDatos) = lsbNumDatos;
	MOV.B	[W1], [W2]
;rs485.c,41 :: 		*(ptrnumDatos+1) = msbNumDatos;
	ADD	W3, #1, W0
; ptrnumDatos end address is: 6 (W3)
	MOV.B	W8, [W0]
;rs485.c,43 :: 		if (puertoUART == 1){
	CP.B	W10, #1
	BRA Z	L__EnviarTramaRS485309
	GOTO	L_EnviarTramaRS48531
L__EnviarTramaRS485309:
;rs485.c,44 :: 		MS1RS485 = 1;                                                            //Establece el Max485 en modo escritura
	BSET	MS1RS485, BitPos(MS1RS485+0)
;rs485.c,45 :: 		UART1_Write(0x3A);                                                      //Envia la cabecera de la trama
	MOV	#58, W10
	CALL	_UART1_Write
;rs485.c,46 :: 		UART1_Write(direccion);                                                 //Envia la direccion del destinatario
	ZE	W4, W10
; direccion end address is: 8 (W4)
	CALL	_UART1_Write
;rs485.c,47 :: 		UART1_Write(funcion);                                                   //Envia el codigo de la funcion
	ZE	W5, W10
; funcion end address is: 10 (W5)
	CALL	_UART1_Write
;rs485.c,48 :: 		UART1_Write(subfuncion);                                                //Envia el codigo de la subfuncion
	ZE	W6, W10
; subfuncion end address is: 12 (W6)
	CALL	_UART1_Write
;rs485.c,49 :: 		UART1_Write(lsbNumDatos);                                               //Envia el LSB del numero de datos
	ZE	W7, W10
; lsbNumDatos end address is: 14 (W7)
	CALL	_UART1_Write
;rs485.c,50 :: 		UART1_Write(msbNumDatos);                                               //Envia el MSB del numero de datos
	ZE	W8, W10
; msbNumDatos end address is: 16 (W8)
	CALL	_UART1_Write
;rs485.c,51 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
; iDatos start address is: 2 (W1)
	CLR	W1
; iDatos end address is: 2 (W1)
L_EnviarTramaRS48532:
; iDatos start address is: 2 (W1)
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA LTU	L__EnviarTramaRS485310
	GOTO	L_EnviarTramaRS48533
L__EnviarTramaRS485310:
;rs485.c,52 :: 		UART1_Write(payload[iDatos]);
	ADD	W12, W1, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART1_Write
	POP	W10
;rs485.c,51 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INC	W1
;rs485.c,53 :: 		}
; iDatos end address is: 2 (W1)
	GOTO	L_EnviarTramaRS48532
L_EnviarTramaRS48533:
;rs485.c,54 :: 		UART1_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	PUSH	W10
	MOV	#13, W10
	CALL	_UART1_Write
;rs485.c,55 :: 		UART1_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOV	#10, W10
	CALL	_UART1_Write
;rs485.c,56 :: 		UART1_Write(0x00);                                                      //Envia un byte adicional
	CLR	W10
	CALL	_UART1_Write
	POP	W10
;rs485.c,57 :: 		while(UART1_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarTramaRS48535:
	CALL	_UART1_Tx_Idle
	CP	W0, #0
	BRA Z	L__EnviarTramaRS485311
	GOTO	L_EnviarTramaRS48536
L__EnviarTramaRS485311:
	GOTO	L_EnviarTramaRS48535
L_EnviarTramaRS48536:
;rs485.c,58 :: 		MS1RS485 = 0;                                                           //Establece el Max485 en modo lectura
	BCLR	MS1RS485, BitPos(MS1RS485+0)
;rs485.c,59 :: 		}
L_EnviarTramaRS48531:
;rs485.c,61 :: 		}
L_end_EnviarTramaRS485:
	POP	W10
	ULNK
	RETURN
; end of _EnviarTramaRS485

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 50
	MOV	#4, W0
	IOR	68

;ConcentradorPrincipal.c,89 :: 		void main() {
;ConcentradorPrincipal.c,91 :: 		ConfiguracionPrincipal();
	PUSH	W10
	PUSH	W11
	CALL	_ConfiguracionPrincipal
;ConcentradorPrincipal.c,92 :: 		GPS_init(1,1);
	MOV.B	#1, W11
	MOV.B	#1, W10
	CALL	_GPS_init
;ConcentradorPrincipal.c,93 :: 		DS3234_init();
	CALL	_DS3234_init
;ConcentradorPrincipal.c,98 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;ConcentradorPrincipal.c,99 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;ConcentradorPrincipal.c,100 :: 		x = 0;
	CLR	W0
	MOV	W0, _x
;ConcentradorPrincipal.c,101 :: 		y = 0;
	CLR	W0
	MOV	W0, _y
;ConcentradorPrincipal.c,104 :: 		banSPI0 = 0;
	MOV	#lo_addr(_banSPI0), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,105 :: 		banSPI1 = 0;
	MOV	#lo_addr(_banSPI1), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,106 :: 		banSPI2 = 0;
	MOV	#lo_addr(_banSPI2), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,107 :: 		banSPI3 = 0;
	MOV	#lo_addr(_banSPI3), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,108 :: 		bufferSPI = 0;
	MOV	#lo_addr(_bufferSPI), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,109 :: 		idSolicitud = 0;
	MOV	#lo_addr(_idSolicitud), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,110 :: 		funcionSolicitud = 0;
	MOV	#lo_addr(_funcionSolicitud), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,111 :: 		subFuncionSolicitud = 0;
	MOV	#lo_addr(_subFuncionSolicitud), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,114 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,115 :: 		banRSI2 = 0;
	MOV	#lo_addr(_banRSI2), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,116 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,117 :: 		banRSC2 = 0;
	MOV	#lo_addr(_banRSC2), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,118 :: 		byteRS485 = 0;
	MOV	#lo_addr(_byteRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,119 :: 		byteRS4852 = 0;
	MOV	#lo_addr(_byteRS4852), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,120 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;ConcentradorPrincipal.c,121 :: 		funcionRS485 = 0;
	MOV	#lo_addr(_funcionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,122 :: 		subFuncionRS485 = 0;
	MOV	#lo_addr(_subFuncionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,123 :: 		numDatosPayload = 0;
	CLR	W0
	MOV	W0, _numDatosPayload
;ConcentradorPrincipal.c,124 :: 		ptrNumDatosPayload = (unsigned char *) & numDatosPayload;
	MOV	#lo_addr(_numDatosPayload), W0
	MOV	W0, _ptrNumDatosPayload
;ConcentradorPrincipal.c,125 :: 		MS1RS485 = 0;
	BCLR	LATB11_bit, BitPos(LATB11_bit+0)
;ConcentradorPrincipal.c,128 :: 		i_gps = 0;
	CLR	W0
	MOV	W0, _i_gps
;ConcentradorPrincipal.c,129 :: 		byteGPS = 0;
	MOV	#lo_addr(_byteGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,130 :: 		banGPSI = 0;
	MOV	#lo_addr(_banGPSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,131 :: 		banGPSC = 0;
	MOV	#lo_addr(_banGPSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,132 :: 		banSetGPS = 0;
	MOV	#lo_addr(_banSetGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,133 :: 		contTimeout1 = 0;
	MOV	#lo_addr(_contTimeout1), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,136 :: 		banSetReloj = 0;
	MOV	#lo_addr(_banSetReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,137 :: 		banSyncReloj = 0;
	MOV	#lo_addr(_banSyncReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,138 :: 		banRespuestaPi = 0;
	MOV	#lo_addr(_banRespuestaPi), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,139 :: 		horaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;ConcentradorPrincipal.c,140 :: 		fechaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;ConcentradorPrincipal.c,141 :: 		fuenteReloj = 0;
	MOV	#lo_addr(_fuenteReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,142 :: 		referenciaTiempo = 0;
	MOV	#lo_addr(_referenciaTiempo), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,145 :: 		banInicioMuestreo = 0;
	MOV	#lo_addr(_banInicioMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,148 :: 		RP1 = 0;                                                                   //Encera el pin de interrupcion de la RPi
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;ConcentradorPrincipal.c,149 :: 		LED1 = 0;                                                                  //Enciende el pin TEST
	BCLR	LATA1_bit, BitPos(LATA1_bit+0)
;ConcentradorPrincipal.c,150 :: 		MS1RS485 = 0;                                                              //Establece el Max485 en modo de lectura;
	BCLR	LATB11_bit, BitPos(LATB11_bit+0)
;ConcentradorPrincipal.c,153 :: 		banGPSI = 1;                                                               //Activa la bandera de inicio de trama  del GPS
	MOV	#lo_addr(_banGPSI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,154 :: 		banGPSC = 0;                                                               //Limpia la bandera de trama completa
	MOV	#lo_addr(_banGPSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,155 :: 		U1MODE.UARTEN = 1;                                                         //Inicializa el UART1
	BSET	U1MODE, #15
;ConcentradorPrincipal.c,157 :: 		T1CON.TON = 1;
	BSET	T1CON, #15
;ConcentradorPrincipal.c,158 :: 		TMR1 = 0;
	CLR	TMR1
;ConcentradorPrincipal.c,160 :: 		while(1){
L_main37:
;ConcentradorPrincipal.c,161 :: 		asm CLRWDT;         //Clear the watchdog timer
	CLRWDT
;ConcentradorPrincipal.c,162 :: 		Delay_ms(100);
	MOV	#13, W8
	MOV	#13575, W7
L_main39:
	DEC	W7
	BRA NZ	L_main39
	DEC	W8
	BRA NZ	L_main39
;ConcentradorPrincipal.c,163 :: 		}
	GOTO	L_main37
;ConcentradorPrincipal.c,165 :: 		}
L_end_main:
	POP	W11
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_ConfiguracionPrincipal:

;ConcentradorPrincipal.c,174 :: 		void ConfiguracionPrincipal(){
;ConcentradorPrincipal.c,177 :: 		CLKDIVbits.FRCDIV = 0;                                                     //FIN=FRC/1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	CLKDIVbits, W1
	MOV	#63743, W0
	AND	W1, W0, W0
	MOV	WREG, CLKDIVbits
;ConcentradorPrincipal.c,178 :: 		CLKDIVbits.PLLPOST = 0;                                                    //N2=2
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,179 :: 		CLKDIVbits.PLLPRE = 5;                                                     //N1=7
	MOV.B	#5, W0
	MOV.B	W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,180 :: 		PLLFBDbits.PLLDIV = 150;                                                   //M=152
	MOV	#150, W0
	MOV	W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	#511, W0
	AND	W1, W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	W1, PLLFBDbits
;ConcentradorPrincipal.c,183 :: 		ANSELA = 0;                                                                //Configura PORTA como digital     *
	CLR	ANSELA
;ConcentradorPrincipal.c,184 :: 		ANSELB = 0;                                                                //Configura PORTB como digital     *
	CLR	ANSELB
;ConcentradorPrincipal.c,186 :: 		TRISA2_bit = 0;                                                            //RTC_CS
	BCLR	TRISA2_bit, BitPos(TRISA2_bit+0)
;ConcentradorPrincipal.c,187 :: 		LED1_Direction = 0;                                                        //INT_SINC
	BCLR	TRISA1_bit, BitPos(TRISA1_bit+0)
;ConcentradorPrincipal.c,188 :: 		RP1_Direction = 0;                                                         //RP1
	BCLR	TRISA4_bit, BitPos(TRISA4_bit+0)
;ConcentradorPrincipal.c,189 :: 		MS1RS485_Direction = 0;                                                    //MSRS485
	BCLR	TRISB11_bit, BitPos(TRISB11_bit+0)
;ConcentradorPrincipal.c,190 :: 		TRISB13_bit = 1;                                                           //SQW
	BSET	TRISB13_bit, BitPos(TRISB13_bit+0)
;ConcentradorPrincipal.c,191 :: 		TRISB14_bit = 1;                                                           //PPS
	BSET	TRISB14_bit, BitPos(TRISB14_bit+0)
;ConcentradorPrincipal.c,193 :: 		INTCON2.GIE = 1;                                                           //Habilita las interrupciones globales *
	BSET	INTCON2, #15
;ConcentradorPrincipal.c,196 :: 		RPINR18bits.U1RXR = 0x22;                                                  //Configura el pin RB2/RPI34 como Rx1
	MOV.B	#34, W0
	MOV.B	W0, W1
	MOV	#lo_addr(RPINR18bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#127, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(RPINR18bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(RPINR18bits), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,197 :: 		RPOR0bits.RP35R = 0x01;                                                    //Configura el Tx1 en el pin RB3/RP35
	MOV	#256, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR0bits), W0
	XOR	W1, [W0], W1
	MOV	#16128, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR0bits
;ConcentradorPrincipal.c,198 :: 		U1RXIE_bit = 1;                                                            //Habilita la interrupcion UART1 RX
	BSET	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;ConcentradorPrincipal.c,199 :: 		IPC2bits.U1RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
	MOV	#16384, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;ConcentradorPrincipal.c,200 :: 		U1STAbits.URXISEL = 0x00;                                                  //Interrupt is set when any character is received and transferred from the UxRSR to the receive buffer; receive buffer has one or more characters
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,201 :: 		UART1_Init(9600);                                                          //Inicializa el UART1 con una velocidad de 9600 baudios
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART1_Init
;ConcentradorPrincipal.c,204 :: 		RPINR19bits.U2RXR = 0x2F;                                                  //Configura el pin RB15/RPI47 como Rx2
	MOV.B	#47, W0
	MOV.B	W0, W1
	MOV	#lo_addr(RPINR19bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#127, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(RPINR19bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(RPINR19bits), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,205 :: 		RPOR1bits.RP36R = 0x03;                                                    //Configura el Tx2 en el pin RB4/RP36
	MOV.B	#3, W0
	MOV.B	W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(RPOR1bits), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,206 :: 		U2RXIE_bit = 1;                                                            //Habilita la interrupcion UART2 RX
	BSET	U2RXIE_bit, BitPos(U2RXIE_bit+0)
;ConcentradorPrincipal.c,207 :: 		IPC7bits.U2RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
	MOV	#1024, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC7bits), W0
	XOR	W1, [W0], W1
	MOV	#1792, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC7bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC7bits
;ConcentradorPrincipal.c,208 :: 		U2STAbits.URXISEL = 0x00;
	MOV	#lo_addr(U2STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U2STAbits), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,209 :: 		UART2_Init(19200);                                                         //Inicializa el UART2 a 19200 bps
	MOV	#19200, W10
	MOV	#0, W11
	CALL	_UART2_Init
;ConcentradorPrincipal.c,212 :: 		SPI1STAT.SPIEN = 1;                                                        //Habilita el SPI1 *
	BSET	SPI1STAT, #15
;ConcentradorPrincipal.c,213 :: 		SPI1_Init_Advanced(_SPI_SLAVE, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_1, _SPI_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
	MOV	#3, W13
	MOV	#28, W12
	CLR	W11
	CLR	W10
	CLR	W0
	PUSH	W0
	MOV	#64, W0
	PUSH	W0
	MOV	#512, W0
	PUSH	W0
	MOV	#128, W0
	PUSH	W0
	CALL	_SPI1_Init_Advanced
	SUB	#8, W15
;ConcentradorPrincipal.c,214 :: 		SPI1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI *
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;ConcentradorPrincipal.c,215 :: 		IPC2bits.SPI1IP = 0x03;                                                    //Prioridad de la interrupcion SPI1
	MOV	#768, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#1792, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;ConcentradorPrincipal.c,218 :: 		RPINR22bits.SDI2R = 0x21;                                                  //Configura el pin RB1/RPI33 como SDI2 *
	MOV.B	#33, W0
	MOV.B	W0, W1
	MOV	#lo_addr(RPINR22bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#127, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(RPINR22bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(RPINR22bits), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,219 :: 		RPOR2bits.RP38R = 0x08;                                                    //Configura el SDO2 en el pin RB6/RP38 *
	MOV.B	#8, W0
	MOV.B	W0, W1
	MOV	#lo_addr(RPOR2bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(RPOR2bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(RPOR2bits), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,220 :: 		RPOR1bits.RP37R = 0x09;                                                    //Configura el SCK2 en el pin RB5/RP37 *
	MOV	#2304, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	#16128, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR1bits
;ConcentradorPrincipal.c,221 :: 		SPI2STAT.SPIEN = 1;                                                        //Habilita el SPI2 *
	BSET	SPI2STAT, #15
;ConcentradorPrincipal.c,222 :: 		SPI2_Init();                                                               //Inicializa el modulo SPI2
	CALL	_SPI2_Init
;ConcentradorPrincipal.c,223 :: 		CS_DS3234 = 1;                                                             //Pone en alto el CS del RTC
	BSET	LATA2_bit, BitPos(LATA2_bit+0)
;ConcentradorPrincipal.c,226 :: 		RPINR0 = 0x2D00;                                                           //Asigna INT1 al RB13/RPI45 (SQW)
	MOV	#11520, W0
	MOV	WREG, RPINR0
;ConcentradorPrincipal.c,227 :: 		RPINR1 = 0x002E;                                                           //Asigna INT2 al RB14/RPI46 (PPS)
	MOV	#46, W0
	MOV	WREG, RPINR1
;ConcentradorPrincipal.c,228 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;ConcentradorPrincipal.c,229 :: 		INT2IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT2
	BCLR	INT2IF_bit, BitPos(INT2IF_bit+0)
;ConcentradorPrincipal.c,230 :: 		IPC5bits.INT1IP = 0x02;                                                    //Prioridad en la interrupocion externa INT1
	MOV.B	#2, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC5bits), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,231 :: 		IPC7bits.INT2IP = 0x01;                                                    //Prioridad en la interrupocion externa INT2
	MOV.B	#16, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC7bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#112, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IPC7bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC7bits), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,234 :: 		T1CON = 0x30;                                                              //Prescalador
	MOV	#48, W0
	MOV	WREG, T1CON
;ConcentradorPrincipal.c,235 :: 		T1CON.TON = 0;                                                             //Apaga el Timer1
	BCLR	T1CON, #15
;ConcentradorPrincipal.c,236 :: 		T1IE_bit = 1;                                                              //Habilita la interrupción de desbordamiento TMR1
	BSET	T1IE_bit, BitPos(T1IE_bit+0)
;ConcentradorPrincipal.c,237 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion del TMR1
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;ConcentradorPrincipal.c,238 :: 		PR1 = 46875;                                                               //Carga el preload para un tiempo de 300ms
	MOV	#46875, W0
	MOV	WREG, PR1
;ConcentradorPrincipal.c,239 :: 		IPC0bits.T1IP = 0x02;                                                      //Prioridad de la interrupcion por desbordamiento del TMR1
	MOV	#8192, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC0bits
;ConcentradorPrincipal.c,242 :: 		T2CON = 0x30;                                                              //Prescalador
	MOV	#48, W0
	MOV	WREG, T2CON
;ConcentradorPrincipal.c,243 :: 		T2CON.TON = 0;                                                             //Apaga el Timer2
	BCLR	T2CON, #15
;ConcentradorPrincipal.c,244 :: 		T2IE_bit = 1;                                                              //Habilita la interrupción de desbordamiento TMR2
	BSET	T2IE_bit, BitPos(T2IE_bit+0)
;ConcentradorPrincipal.c,245 :: 		T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion del TMR2
	BCLR	T2IF_bit, BitPos(T2IF_bit+0)
;ConcentradorPrincipal.c,246 :: 		PR2 = 46875;                                                               //Carga el preload para un tiempo de 300ms
	MOV	#46875, W0
	MOV	WREG, PR2
;ConcentradorPrincipal.c,247 :: 		IPC1bits.T2IP = 0x02;                                                      //Prioridad de la interrupcion por desbordamiento del TMR2
	MOV	#8192, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC1bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC1bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC1bits
;ConcentradorPrincipal.c,250 :: 		SPI1IE_bit = 1;                                                            //SPI1
	BSET	SPI1IE_bit, BitPos(SPI1IE_bit+0)
;ConcentradorPrincipal.c,251 :: 		INT1IE_bit = 1;                                                            //INT1
	BSET	INT1IE_bit, BitPos(INT1IE_bit+0)
;ConcentradorPrincipal.c,252 :: 		INT2IE_bit = 1;                                                            //INT2
	BSET	INT2IE_bit, BitPos(INT2IE_bit+0)
;ConcentradorPrincipal.c,254 :: 		Delay_ms(200);                                                             //Espera hasta que se estabilicen los cambios
	MOV	#25, W8
	MOV	#27150, W7
L_ConfiguracionPrincipal41:
	DEC	W7
	BRA NZ	L_ConfiguracionPrincipal41
	DEC	W8
	BRA NZ	L_ConfiguracionPrincipal41
	NOP
;ConcentradorPrincipal.c,256 :: 		}
L_end_ConfiguracionPrincipal:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _ConfiguracionPrincipal

_EnviarCabeceraRespuesta:

;ConcentradorPrincipal.c,261 :: 		void EnviarCabeceraRespuesta(unsigned char *cabeceraRespuesta){
;ConcentradorPrincipal.c,264 :: 		cabeceraRespuestaSPI[0] = cabeceraRespuesta[0];
	MOV.B	[W10], W1
	MOV	#lo_addr(_cabeceraRespuestaSPI), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,265 :: 		cabeceraRespuestaSPI[1] = cabeceraRespuesta[1];
	ADD	W10, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraRespuestaSPI+1), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,266 :: 		cabeceraRespuestaSPI[2] = cabeceraRespuesta[2];
	ADD	W10, #2, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraRespuestaSPI+2), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,267 :: 		cabeceraRespuestaSPI[3] = cabeceraRespuesta[3];
	ADD	W10, #3, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraRespuestaSPI+3), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,268 :: 		cabeceraRespuestaSPI[4] = cabeceraRespuesta[4];
	ADD	W10, #4, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraRespuestaSPI+4), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,271 :: 		RP1 = 1;
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;ConcentradorPrincipal.c,272 :: 		Delay_us(100);
	MOV	#800, W7
L_EnviarCabeceraRespuesta43:
	DEC	W7
	BRA NZ	L_EnviarCabeceraRespuesta43
	NOP
	NOP
;ConcentradorPrincipal.c,273 :: 		RP1 = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;ConcentradorPrincipal.c,275 :: 		}
L_end_EnviarCabeceraRespuesta:
	RETURN
; end of _EnviarCabeceraRespuesta

_CambiarEstadoBandera:

;ConcentradorPrincipal.c,280 :: 		void CambiarEstadoBandera(unsigned char bandera, unsigned char estado){
;ConcentradorPrincipal.c,281 :: 		if (estado==1){
	CP.B	W11, #1
	BRA Z	L__CambiarEstadoBandera317
	GOTO	L_CambiarEstadoBandera45
L__CambiarEstadoBandera317:
;ConcentradorPrincipal.c,283 :: 		banSPI0 = 3;
	MOV	#lo_addr(_banSPI0), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,284 :: 		banSPI1 = 3;
	MOV	#lo_addr(_banSPI1), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,286 :: 		switch (bandera){
	GOTO	L_CambiarEstadoBandera46
;ConcentradorPrincipal.c,287 :: 		case 0:
L_CambiarEstadoBandera48:
;ConcentradorPrincipal.c,288 :: 		banSPI0 = 1;
	MOV	#lo_addr(_banSPI0), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,289 :: 		break;
	GOTO	L_CambiarEstadoBandera47
;ConcentradorPrincipal.c,290 :: 		case 1:
L_CambiarEstadoBandera49:
;ConcentradorPrincipal.c,291 :: 		banSPI1 = 1;
	MOV	#lo_addr(_banSPI1), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,292 :: 		break;
	GOTO	L_CambiarEstadoBandera47
;ConcentradorPrincipal.c,293 :: 		case 2:
L_CambiarEstadoBandera50:
;ConcentradorPrincipal.c,294 :: 		banSPI2 = 1;
	MOV	#lo_addr(_banSPI2), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,295 :: 		break;
	GOTO	L_CambiarEstadoBandera47
;ConcentradorPrincipal.c,296 :: 		case 3:
L_CambiarEstadoBandera51:
;ConcentradorPrincipal.c,297 :: 		banSPI3 = 1;
	MOV	#lo_addr(_banSPI3), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,298 :: 		break;
	GOTO	L_CambiarEstadoBandera47
;ConcentradorPrincipal.c,299 :: 		}
L_CambiarEstadoBandera46:
	CP.B	W10, #0
	BRA NZ	L__CambiarEstadoBandera318
	GOTO	L_CambiarEstadoBandera48
L__CambiarEstadoBandera318:
	CP.B	W10, #1
	BRA NZ	L__CambiarEstadoBandera319
	GOTO	L_CambiarEstadoBandera49
L__CambiarEstadoBandera319:
	CP.B	W10, #2
	BRA NZ	L__CambiarEstadoBandera320
	GOTO	L_CambiarEstadoBandera50
L__CambiarEstadoBandera320:
	CP.B	W10, #3
	BRA NZ	L__CambiarEstadoBandera321
	GOTO	L_CambiarEstadoBandera51
L__CambiarEstadoBandera321:
L_CambiarEstadoBandera47:
;ConcentradorPrincipal.c,300 :: 		}
L_CambiarEstadoBandera45:
;ConcentradorPrincipal.c,302 :: 		if (estado==0){
	CP.B	W11, #0
	BRA Z	L__CambiarEstadoBandera322
	GOTO	L_CambiarEstadoBandera52
L__CambiarEstadoBandera322:
;ConcentradorPrincipal.c,303 :: 		banSPI0 = 0;
	MOV	#lo_addr(_banSPI0), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,304 :: 		banSPI1 = 0;
	MOV	#lo_addr(_banSPI1), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,305 :: 		banSPI2 = 0;
	MOV	#lo_addr(_banSPI2), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,306 :: 		banSPI3 = 0;
	MOV	#lo_addr(_banSPI3), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,307 :: 		}
L_CambiarEstadoBandera52:
;ConcentradorPrincipal.c,308 :: 		}
L_end_CambiarEstadoBandera:
	RETURN
; end of _CambiarEstadoBandera

_ProcesarSolicitudConcentrador:
	LNK	#4

;ConcentradorPrincipal.c,313 :: 		void ProcesarSolicitudConcentrador(unsigned char* cabeceraSolicitudCon, unsigned char* payloadSolicitudCon){
;ConcentradorPrincipal.c,319 :: 		switch (cabeceraSolicitudCon[1]){
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	ADD	W10, #1, W0
	MOV	W0, [W14+2]
	GOTO	L_ProcesarSolicitudConcentrador53
;ConcentradorPrincipal.c,320 :: 		case 2:
L_ProcesarSolicitudConcentrador55:
;ConcentradorPrincipal.c,325 :: 		numDatosPayload = 7;
	MOV	#7, W0
	MOV	W0, _numDatosPayload
;ConcentradorPrincipal.c,326 :: 		cabeceraSolicitud[3] = *(ptrNumDatosPayload);
	MOV	_ptrNumDatosPayload, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraSolicitud+3), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,327 :: 		cabeceraSolicitud[4] = *(ptrNumDatosPayload+1);
	MOV	_ptrNumDatosPayload, W0
	INC	W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraSolicitud+4), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,329 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_ProcesarSolicitudConcentrador56:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__ProcesarSolicitudConcentrador324
	GOTO	L_ProcesarSolicitudConcentrador57
L__ProcesarSolicitudConcentrador324:
;ConcentradorPrincipal.c,330 :: 		payloadConcentrador[x] = tiempo[x];
	MOV	#lo_addr(_payloadConcentrador), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;ConcentradorPrincipal.c,329 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,331 :: 		}
	GOTO	L_ProcesarSolicitudConcentrador56
L_ProcesarSolicitudConcentrador57:
;ConcentradorPrincipal.c,332 :: 		payloadConcentrador[6] = fuenteReloj;
	MOV	#lo_addr(_payloadConcentrador+6), W1
	MOV	#lo_addr(_fuenteReloj), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,334 :: 		EnviarCabeceraRespuesta(cabeceraSolicitud);
	PUSH	W10
	MOV	#lo_addr(_cabeceraSolicitud), W10
	CALL	_EnviarCabeceraRespuesta
	POP	W10
;ConcentradorPrincipal.c,336 :: 		break;
	GOTO	L_ProcesarSolicitudConcentrador54
;ConcentradorPrincipal.c,337 :: 		case 3:
L_ProcesarSolicitudConcentrador59:
;ConcentradorPrincipal.c,338 :: 		switch (cabeceraSolicitudCon[2]){
	ADD	W10, #2, W0
	MOV	W0, [W14+0]
	GOTO	L_ProcesarSolicitudConcentrador60
;ConcentradorPrincipal.c,339 :: 		case 1:
L_ProcesarSolicitudConcentrador62:
;ConcentradorPrincipal.c,341 :: 		horaSistema = RecuperarHoraRPI(payloadSolicitudCon);        //Recupera la hora de la RPi
	MOV	W11, W10
	CALL	_RecuperarHoraRPI
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;ConcentradorPrincipal.c,342 :: 		fechaSistema = RecuperarFechaRPI(payloadSolicitudCon);      //Recupera la fecha de la RPi
	MOV	W11, W10
	CALL	_RecuperarFechaRPI
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;ConcentradorPrincipal.c,343 :: 		DS3234_setDate(horaSistema, fechaSistema);                  //Configura la hora en el RTC
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	CALL	_DS3234_setDate
;ConcentradorPrincipal.c,344 :: 		horaSistema = RecuperarHoraRTC();                           //Recupera la hora del RTC
	CALL	_RecuperarHoraRTC
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;ConcentradorPrincipal.c,345 :: 		fechaSistema = RecuperarFechaRTC();                         //Recupera la fecha del RTC
	CALL	_RecuperarFechaRTC
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;ConcentradorPrincipal.c,346 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);    //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;ConcentradorPrincipal.c,347 :: 		fuenteReloj = 1;                                            //Fuente de reloj = RED
	MOV	#lo_addr(_fuenteReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,348 :: 		banSetReloj = 1;                                            //Activa esta bandera para usar la hora/fecha recuperada
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,349 :: 		banRespuestaPi = 1;                                         //Activa esta bandera para enviar la trama de tiempo a la RPi
	MOV	#lo_addr(_banRespuestaPi), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,353 :: 		numDatosPayload = 7;
	MOV	#7, W0
	MOV	W0, _numDatosPayload
;ConcentradorPrincipal.c,354 :: 		cabeceraSolicitud[3] = *(ptrNumDatosPayload);
	MOV	_ptrNumDatosPayload, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraSolicitud+3), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,355 :: 		cabeceraSolicitud[4] = *(ptrNumDatosPayload+1);
	MOV	_ptrNumDatosPayload, W0
	INC	W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraSolicitud+4), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,356 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_ProcesarSolicitudConcentrador64:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__ProcesarSolicitudConcentrador325
	GOTO	L_ProcesarSolicitudConcentrador65
L__ProcesarSolicitudConcentrador325:
;ConcentradorPrincipal.c,357 :: 		payloadConcentrador[x] = tiempo[x];
	MOV	#lo_addr(_payloadConcentrador), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;ConcentradorPrincipal.c,356 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,358 :: 		}
	GOTO	L_ProcesarSolicitudConcentrador64
L_ProcesarSolicitudConcentrador65:
;ConcentradorPrincipal.c,359 :: 		payloadConcentrador[6] = fuenteReloj;
	MOV	#lo_addr(_payloadConcentrador+6), W1
	MOV	#lo_addr(_fuenteReloj), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,360 :: 		EnviarCabeceraRespuesta(cabeceraSolicitud);
	PUSH	W10
	MOV	#lo_addr(_cabeceraSolicitud), W10
	CALL	_EnviarCabeceraRespuesta
	POP	W10
;ConcentradorPrincipal.c,363 :: 		break;
	GOTO	L_ProcesarSolicitudConcentrador61
;ConcentradorPrincipal.c,364 :: 		case 2:
L_ProcesarSolicitudConcentrador67:
;ConcentradorPrincipal.c,366 :: 		banRespuestaPi = 1;
	MOV	#lo_addr(_banRespuestaPi), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,367 :: 		banGPSI = 1;                                                //Activa la bandera de inicio de trama  del GPS
	MOV	#lo_addr(_banGPSI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,368 :: 		banGPSC = 0;                                                //Limpia la bandera de trama completa
	MOV	#lo_addr(_banGPSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,369 :: 		U1MODE.UARTEN = 1;                                          //Inicializa el UART1
	BSET	U1MODE, #15
;ConcentradorPrincipal.c,371 :: 		T1CON.TON = 1;
	BSET	T1CON, #15
;ConcentradorPrincipal.c,372 :: 		TMR1 = 0;
	CLR	TMR1
;ConcentradorPrincipal.c,373 :: 		break;
	GOTO	L_ProcesarSolicitudConcentrador61
;ConcentradorPrincipal.c,374 :: 		case 3:
L_ProcesarSolicitudConcentrador68:
;ConcentradorPrincipal.c,376 :: 		horaSistema = RecuperarHoraRTC();                          //Recupera la hora del RTC
	CALL	_RecuperarHoraRTC
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;ConcentradorPrincipal.c,377 :: 		fechaSistema = RecuperarFechaRTC();                        //Recupera la fecha del RTC
	CALL	_RecuperarFechaRTC
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;ConcentradorPrincipal.c,378 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);   //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;ConcentradorPrincipal.c,379 :: 		fuenteReloj = 3;                                           //Fuente de reloj = RTC
	MOV	#lo_addr(_fuenteReloj), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,380 :: 		banSetReloj = 1;                                           //Activa esta bandera para usar la hora/fecha recuperada del RTC
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,381 :: 		banRespuestaPi = 1;
	MOV	#lo_addr(_banRespuestaPi), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,385 :: 		numDatosPayload = 7;
	MOV	#7, W0
	MOV	W0, _numDatosPayload
;ConcentradorPrincipal.c,386 :: 		cabeceraSolicitud[3] = *(ptrNumDatosPayload);
	MOV	_ptrNumDatosPayload, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraSolicitud+3), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,387 :: 		cabeceraSolicitud[4] = *(ptrNumDatosPayload+1);
	MOV	_ptrNumDatosPayload, W0
	INC	W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraSolicitud+4), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,388 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_ProcesarSolicitudConcentrador70:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__ProcesarSolicitudConcentrador326
	GOTO	L_ProcesarSolicitudConcentrador71
L__ProcesarSolicitudConcentrador326:
;ConcentradorPrincipal.c,389 :: 		payloadConcentrador[x] = tiempo[x];
	MOV	#lo_addr(_payloadConcentrador), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;ConcentradorPrincipal.c,388 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,390 :: 		}
	GOTO	L_ProcesarSolicitudConcentrador70
L_ProcesarSolicitudConcentrador71:
;ConcentradorPrincipal.c,391 :: 		payloadConcentrador[6] = fuenteReloj;
	MOV	#lo_addr(_payloadConcentrador+6), W1
	MOV	#lo_addr(_fuenteReloj), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,392 :: 		EnviarCabeceraRespuesta(cabeceraSolicitud);
	PUSH	W10
	MOV	#lo_addr(_cabeceraSolicitud), W10
	CALL	_EnviarCabeceraRespuesta
	POP	W10
;ConcentradorPrincipal.c,395 :: 		break;
	GOTO	L_ProcesarSolicitudConcentrador61
;ConcentradorPrincipal.c,396 :: 		}
L_ProcesarSolicitudConcentrador60:
	MOV	[W14+0], W1
	MOV.B	[W1], W0
	CP.B	W0, #1
	BRA NZ	L__ProcesarSolicitudConcentrador327
	GOTO	L_ProcesarSolicitudConcentrador62
L__ProcesarSolicitudConcentrador327:
	MOV.B	[W1], W0
	CP.B	W0, #2
	BRA NZ	L__ProcesarSolicitudConcentrador328
	GOTO	L_ProcesarSolicitudConcentrador67
L__ProcesarSolicitudConcentrador328:
	MOV.B	[W1], W0
	CP.B	W0, #3
	BRA NZ	L__ProcesarSolicitudConcentrador329
	GOTO	L_ProcesarSolicitudConcentrador68
L__ProcesarSolicitudConcentrador329:
L_ProcesarSolicitudConcentrador61:
;ConcentradorPrincipal.c,397 :: 		break;
	GOTO	L_ProcesarSolicitudConcentrador54
;ConcentradorPrincipal.c,398 :: 		case 4:
L_ProcesarSolicitudConcentrador73:
;ConcentradorPrincipal.c,400 :: 		numDatosPayload = 10;
	MOV	#10, W0
	MOV	W0, _numDatosPayload
;ConcentradorPrincipal.c,401 :: 		cabeceraSolicitud[3] = *(ptrNumDatosPayload);
	MOV	_ptrNumDatosPayload, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraSolicitud+3), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,402 :: 		cabeceraSolicitud[4] = *(ptrNumDatosPayload+1);
	MOV	_ptrNumDatosPayload, W0
	INC	W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraSolicitud+4), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,404 :: 		for (x=0;x<numDatosPayload;x++){
	CLR	W0
	MOV	W0, _x
L_ProcesarSolicitudConcentrador74:
	MOV	_x, W1
	MOV	#lo_addr(_numDatosPayload), W0
	CP	W1, [W0]
	BRA LTU	L__ProcesarSolicitudConcentrador330
	GOTO	L_ProcesarSolicitudConcentrador75
L__ProcesarSolicitudConcentrador330:
;ConcentradorPrincipal.c,405 :: 		payloadConcentrador[x] = tramaPruebaSPI[x];
	MOV	#lo_addr(_payloadConcentrador), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_tramaPruebaSPI), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;ConcentradorPrincipal.c,404 :: 		for (x=0;x<numDatosPayload;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,406 :: 		}
	GOTO	L_ProcesarSolicitudConcentrador74
L_ProcesarSolicitudConcentrador75:
;ConcentradorPrincipal.c,408 :: 		EnviarCabeceraRespuesta(cabeceraSolicitud);
	PUSH	W10
	MOV	#lo_addr(_cabeceraSolicitud), W10
	CALL	_EnviarCabeceraRespuesta
	POP	W10
;ConcentradorPrincipal.c,409 :: 		break;
	GOTO	L_ProcesarSolicitudConcentrador54
;ConcentradorPrincipal.c,410 :: 		}
L_ProcesarSolicitudConcentrador53:
	MOV	[W14+2], W1
	MOV.B	[W1], W0
	CP.B	W0, #2
	BRA NZ	L__ProcesarSolicitudConcentrador331
	GOTO	L_ProcesarSolicitudConcentrador55
L__ProcesarSolicitudConcentrador331:
	MOV.B	[W1], W0
	CP.B	W0, #3
	BRA NZ	L__ProcesarSolicitudConcentrador332
	GOTO	L_ProcesarSolicitudConcentrador59
L__ProcesarSolicitudConcentrador332:
	MOV.B	[W1], W0
	CP.B	W0, #4
	BRA NZ	L__ProcesarSolicitudConcentrador333
	GOTO	L_ProcesarSolicitudConcentrador73
L__ProcesarSolicitudConcentrador333:
L_ProcesarSolicitudConcentrador54:
;ConcentradorPrincipal.c,411 :: 		}
L_end_ProcesarSolicitudConcentrador:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _ProcesarSolicitudConcentrador

_spi_1:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;ConcentradorPrincipal.c,421 :: 		void spi_1() org  IVT_ADDR_SPI1INTERRUPT {
;ConcentradorPrincipal.c,423 :: 		SPI1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI
	PUSH	W10
	PUSH	W11
	PUSH	W12
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;ConcentradorPrincipal.c,424 :: 		bufferSPI = SPI1BUF;                                                       //Guarda el contenido del bufeer (lectura)
	MOV	#lo_addr(_bufferSPI), W1
	MOV.B	SPI1BUF, WREG
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,429 :: 		if ((banSPI0==0)&&(bufferSPI==0xA0)){
	MOV	#lo_addr(_banSPI0), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1335
	GOTO	L__spi_1222
L__spi_1335:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#160, W0
	CP.B	W1, W0
	BRA Z	L__spi_1336
	GOTO	L__spi_1221
L__spi_1336:
L__spi_1220:
;ConcentradorPrincipal.c,430 :: 		i = 0;                                                                //Limpia el subindice para guardar la trama SPI
	CLR	W0
	MOV	W0, _i
;ConcentradorPrincipal.c,431 :: 		CambiarEstadoBandera(0,1);                                            //Activa la bandera 0
	MOV.B	#1, W11
	CLR	W10
	CALL	_CambiarEstadoBandera
;ConcentradorPrincipal.c,432 :: 		LED1 = 1;
	BSET	LATA1_bit, BitPos(LATA1_bit+0)
;ConcentradorPrincipal.c,429 :: 		if ((banSPI0==0)&&(bufferSPI==0xA0)){
L__spi_1222:
L__spi_1221:
;ConcentradorPrincipal.c,434 :: 		if ((banSPI0==1)&&(bufferSPI!=0xA0)&&(bufferSPI!=0xF0)){
	MOV	#lo_addr(_banSPI0), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1337
	GOTO	L__spi_1225
L__spi_1337:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#160, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1338
	GOTO	L__spi_1224
L__spi_1338:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#240, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1339
	GOTO	L__spi_1223
L__spi_1339:
L__spi_1219:
;ConcentradorPrincipal.c,435 :: 		tramaSolicitudSPI[i] = bufferSPI;                                     //Recupera la trama de solicitud SPI
	MOV	#lo_addr(_tramaSolicitudSPI), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,436 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,434 :: 		if ((banSPI0==1)&&(bufferSPI!=0xA0)&&(bufferSPI!=0xF0)){
L__spi_1225:
L__spi_1224:
L__spi_1223:
;ConcentradorPrincipal.c,438 :: 		if ((banSPI0==1)&&(bufferSPI==0xF0)){
	MOV	#lo_addr(_banSPI0), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1340
	GOTO	L__spi_1227
L__spi_1340:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#240, W0
	CP.B	W1, W0
	BRA Z	L__spi_1341
	GOTO	L__spi_1226
L__spi_1341:
L__spi_1218:
;ConcentradorPrincipal.c,440 :: 		for (j=0;j<5;j++){
	CLR	W0
	MOV	W0, _j
L_spi_186:
	MOV	_j, W0
	CP	W0, #5
	BRA LTU	L__spi_1342
	GOTO	L_spi_187
L__spi_1342:
;ConcentradorPrincipal.c,441 :: 		cabeceraSolicitud[j] = tramaSolicitudSPI[j];
	MOV	#lo_addr(_cabeceraSolicitud), W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_tramaSolicitudSPI), W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;ConcentradorPrincipal.c,440 :: 		for (j=0;j<5;j++){
	MOV	#1, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,442 :: 		}
	GOTO	L_spi_186
L_spi_187:
;ConcentradorPrincipal.c,444 :: 		idSolicitud = cabeceraSolicitud[0];
	MOV	#lo_addr(_idSolicitud), W1
	MOV	#lo_addr(_cabeceraSolicitud), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,445 :: 		funcionSolicitud = cabeceraSolicitud[1];
	MOV	#lo_addr(_funcionSolicitud), W1
	MOV	#lo_addr(_cabeceraSolicitud+1), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,446 :: 		subFuncionSolicitud = cabeceraSolicitud[2];
	MOV	#lo_addr(_subFuncionSolicitud), W1
	MOV	#lo_addr(_cabeceraSolicitud+2), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,447 :: 		*(ptrNumDatosPayload) = cabeceraSolicitud[3];
	MOV	#lo_addr(_cabeceraSolicitud+3), W1
	MOV	_ptrNumDatosPayload, W0
	MOV.B	[W1], [W0]
;ConcentradorPrincipal.c,448 :: 		*(ptrNumDatosPayload+1) = cabeceraSolicitud[4];
	MOV	_ptrNumDatosPayload, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_cabeceraSolicitud+4), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,450 :: 		for (j=0;j<numDatosPayload;j++){
	CLR	W0
	MOV	W0, _j
L_spi_189:
	MOV	_j, W1
	MOV	#lo_addr(_numDatosPayload), W0
	CP	W1, [W0]
	BRA LTU	L__spi_1343
	GOTO	L_spi_190
L__spi_1343:
;ConcentradorPrincipal.c,451 :: 		payloadSolicitud[j] = tramaSolicitudSPI[5+j];
	MOV	#lo_addr(_payloadSolicitud), W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], W2
	MOV	_j, W0
	ADD	W0, #5, W1
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;ConcentradorPrincipal.c,450 :: 		for (j=0;j<numDatosPayload;j++){
	MOV	#1, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,452 :: 		}
	GOTO	L_spi_189
L_spi_190:
;ConcentradorPrincipal.c,454 :: 		if (idSolicitud==0){
	MOV	#lo_addr(_idSolicitud), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1344
	GOTO	L_spi_192
L__spi_1344:
;ConcentradorPrincipal.c,456 :: 		ProcesarSolicitudConcentrador(cabeceraSolicitud, payloadSolicitud);
	MOV	#lo_addr(_payloadSolicitud), W11
	MOV	#lo_addr(_cabeceraSolicitud), W10
	CALL	_ProcesarSolicitudConcentrador
;ConcentradorPrincipal.c,457 :: 		} else {
	GOTO	L_spi_193
L_spi_192:
;ConcentradorPrincipal.c,459 :: 		EnviarTramaRS485(1, cabeceraSolicitud, payloadSolicitud);
	MOV	#lo_addr(_payloadSolicitud), W12
	MOV	#lo_addr(_cabeceraSolicitud), W11
	MOV.B	#1, W10
	CALL	_EnviarTramaRS485
;ConcentradorPrincipal.c,460 :: 		EnviarTramaRS485(2, cabeceraSolicitud, payloadSolicitud);
	MOV	#lo_addr(_payloadSolicitud), W12
	MOV	#lo_addr(_cabeceraSolicitud), W11
	MOV.B	#2, W10
	CALL	_EnviarTramaRS485
;ConcentradorPrincipal.c,461 :: 		}
L_spi_193:
;ConcentradorPrincipal.c,462 :: 		CambiarEstadoBandera(0,0);                                            //Limpia la bandera 0
	CLR	W11
	CLR	W10
	CALL	_CambiarEstadoBandera
;ConcentradorPrincipal.c,463 :: 		LED1 = 0;
	BCLR	LATA1_bit, BitPos(LATA1_bit+0)
;ConcentradorPrincipal.c,438 :: 		if ((banSPI0==1)&&(bufferSPI==0xF0)){
L__spi_1227:
L__spi_1226:
;ConcentradorPrincipal.c,468 :: 		if ((banSPI1==0)&&(bufferSPI==0xA1)) {
	MOV	#lo_addr(_banSPI1), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1345
	GOTO	L__spi_1229
L__spi_1345:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#161, W0
	CP.B	W1, W0
	BRA Z	L__spi_1346
	GOTO	L__spi_1228
L__spi_1346:
L__spi_1217:
;ConcentradorPrincipal.c,469 :: 		SPI1BUF = cabeceraRespuestaSPI[0];                                    //Carga en el buffer el primer elemento de la cabecera (id)
	MOV	#lo_addr(_cabeceraRespuestaSPI), W0
	ZE	[W0], W0
	MOV	WREG, SPI1BUF
;ConcentradorPrincipal.c,470 :: 		i = 1;
	MOV	#1, W0
	MOV	W0, _i
;ConcentradorPrincipal.c,471 :: 		CambiarEstadoBandera(1,1);                                            //Activa la bandera 1
	MOV.B	#1, W11
	MOV.B	#1, W10
	CALL	_CambiarEstadoBandera
;ConcentradorPrincipal.c,468 :: 		if ((banSPI1==0)&&(bufferSPI==0xA1)) {
L__spi_1229:
L__spi_1228:
;ConcentradorPrincipal.c,473 :: 		if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
	MOV	#lo_addr(_banSPI1), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1347
	GOTO	L__spi_1232
L__spi_1347:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#161, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1348
	GOTO	L__spi_1231
L__spi_1348:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#241, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1349
	GOTO	L__spi_1230
L__spi_1349:
L__spi_1216:
;ConcentradorPrincipal.c,474 :: 		SPI1BUF = cabeceraRespuestaSPI[i];                                    //Se envia la trama de respuesta
	MOV	#lo_addr(_cabeceraRespuestaSPI), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;ConcentradorPrincipal.c,475 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,473 :: 		if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
L__spi_1232:
L__spi_1231:
L__spi_1230:
;ConcentradorPrincipal.c,477 :: 		if ((banSPI1==1)&&(bufferSPI==0xF1)){
	MOV	#lo_addr(_banSPI1), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1350
	GOTO	L__spi_1234
L__spi_1350:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#241, W0
	CP.B	W1, W0
	BRA Z	L__spi_1351
	GOTO	L__spi_1233
L__spi_1351:
L__spi_1215:
;ConcentradorPrincipal.c,478 :: 		CambiarEstadoBandera(1,0);                                            //Limpia la bandera 1
	CLR	W11
	MOV.B	#1, W10
	CALL	_CambiarEstadoBandera
;ConcentradorPrincipal.c,477 :: 		if ((banSPI1==1)&&(bufferSPI==0xF1)){
L__spi_1234:
L__spi_1233:
;ConcentradorPrincipal.c,481 :: 		if ((banSPI2==0)&&(bufferSPI==0xA2)){
	MOV	#lo_addr(_banSPI2), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1352
	GOTO	L__spi_1236
L__spi_1352:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#162, W0
	CP.B	W1, W0
	BRA Z	L__spi_1353
	GOTO	L__spi_1235
L__spi_1353:
L__spi_1214:
;ConcentradorPrincipal.c,482 :: 		CambiarEstadoBandera(2,1);                                            //Activa la bandera 2
	MOV.B	#1, W11
	MOV.B	#2, W10
	CALL	_CambiarEstadoBandera
;ConcentradorPrincipal.c,483 :: 		SPI1BUF = pyloadRS485[0];
	MOV	#lo_addr(_pyloadRS485), W0
	ZE	[W0], W0
	MOV	WREG, SPI1BUF
;ConcentradorPrincipal.c,484 :: 		i = 1;
	MOV	#1, W0
	MOV	W0, _i
;ConcentradorPrincipal.c,481 :: 		if ((banSPI2==0)&&(bufferSPI==0xA2)){
L__spi_1236:
L__spi_1235:
;ConcentradorPrincipal.c,486 :: 		if ((banSPI2==1)&&(bufferSPI!=0xA2)&&(bufferSPI!=0xF2)){
	MOV	#lo_addr(_banSPI2), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1354
	GOTO	L__spi_1239
L__spi_1354:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#162, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1355
	GOTO	L__spi_1238
L__spi_1355:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#242, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1356
	GOTO	L__spi_1237
L__spi_1356:
L__spi_1213:
;ConcentradorPrincipal.c,487 :: 		SPI1BUF = pyloadRS485[i];
	MOV	#lo_addr(_pyloadRS485), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;ConcentradorPrincipal.c,488 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,486 :: 		if ((banSPI2==1)&&(bufferSPI!=0xA2)&&(bufferSPI!=0xF2)){
L__spi_1239:
L__spi_1238:
L__spi_1237:
;ConcentradorPrincipal.c,490 :: 		if ((banSPI2==1)&&(bufferSPI==0xF2)){
	MOV	#lo_addr(_banSPI2), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1357
	GOTO	L__spi_1241
L__spi_1357:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#242, W0
	CP.B	W1, W0
	BRA Z	L__spi_1358
	GOTO	L__spi_1240
L__spi_1358:
L__spi_1212:
;ConcentradorPrincipal.c,491 :: 		CambiarEstadoBandera(2,0);                                            //Limpia la bandera 2
	CLR	W11
	MOV.B	#2, W10
	CALL	_CambiarEstadoBandera
;ConcentradorPrincipal.c,490 :: 		if ((banSPI2==1)&&(bufferSPI==0xF2)){
L__spi_1241:
L__spi_1240:
;ConcentradorPrincipal.c,494 :: 		if ((banSPI3==0)&&(bufferSPI==0xA3)){
	MOV	#lo_addr(_banSPI3), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1359
	GOTO	L__spi_1243
L__spi_1359:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#163, W0
	CP.B	W1, W0
	BRA Z	L__spi_1360
	GOTO	L__spi_1242
L__spi_1360:
L__spi_1211:
;ConcentradorPrincipal.c,495 :: 		CambiarEstadoBandera(3,1);                                            //Activa la bandera 3
	MOV.B	#1, W11
	MOV.B	#3, W10
	CALL	_CambiarEstadoBandera
;ConcentradorPrincipal.c,496 :: 		SPI1BUF = payloadConcentrador[0];
	MOV	#lo_addr(_payloadConcentrador), W0
	ZE	[W0], W0
	MOV	WREG, SPI1BUF
;ConcentradorPrincipal.c,497 :: 		i = 1;
	MOV	#1, W0
	MOV	W0, _i
;ConcentradorPrincipal.c,494 :: 		if ((banSPI3==0)&&(bufferSPI==0xA3)){
L__spi_1243:
L__spi_1242:
;ConcentradorPrincipal.c,499 :: 		if ((banSPI3==1)&&(bufferSPI!=0xA3)&&(bufferSPI!=0xF3)){
	MOV	#lo_addr(_banSPI3), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1361
	GOTO	L__spi_1246
L__spi_1361:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#163, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1362
	GOTO	L__spi_1245
L__spi_1362:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#243, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1363
	GOTO	L__spi_1244
L__spi_1363:
L__spi_1210:
;ConcentradorPrincipal.c,500 :: 		SPI1BUF = payloadConcentrador[i];
	MOV	#lo_addr(_payloadConcentrador), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;ConcentradorPrincipal.c,501 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,499 :: 		if ((banSPI3==1)&&(bufferSPI!=0xA3)&&(bufferSPI!=0xF3)){
L__spi_1246:
L__spi_1245:
L__spi_1244:
;ConcentradorPrincipal.c,503 :: 		if ((banSPI3==1)&&(bufferSPI==0xF3)){
	MOV	#lo_addr(_banSPI3), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1364
	GOTO	L__spi_1248
L__spi_1364:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#243, W0
	CP.B	W1, W0
	BRA Z	L__spi_1365
	GOTO	L__spi_1247
L__spi_1365:
L__spi_1209:
;ConcentradorPrincipal.c,504 :: 		CambiarEstadoBandera(3,0);                                            //Limpia la bandera 3
	CLR	W11
	MOV.B	#3, W10
	CALL	_CambiarEstadoBandera
;ConcentradorPrincipal.c,503 :: 		if ((banSPI3==1)&&(bufferSPI==0xF3)){
L__spi_1248:
L__spi_1247:
;ConcentradorPrincipal.c,507 :: 		}
L_end_spi_1:
	POP	W12
	POP	W11
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	50
	POP	DSWPAG
	RETFIE
; end of _spi_1

_int_1:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;ConcentradorPrincipal.c,512 :: 		void int_1() org IVT_ADDR_INT1INTERRUPT {
;ConcentradorPrincipal.c,514 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;ConcentradorPrincipal.c,516 :: 		if (banSetReloj==1){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1367
	GOTO	L_int_1121
L__int_1367:
;ConcentradorPrincipal.c,517 :: 		horaSistema++;                                                         //Incrementa el reloj del sistema
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_horaSistema), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;ConcentradorPrincipal.c,518 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);
	MOV	_fechaSistema, W12
	MOV	_fechaSistema+2, W13
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;ConcentradorPrincipal.c,519 :: 		LED1 = ~LED1;
	BTG	LATA1_bit, BitPos(LATA1_bit+0)
;ConcentradorPrincipal.c,520 :: 		}
L_int_1121:
;ConcentradorPrincipal.c,523 :: 		if ((horaSistema!=0)&&(horaSistema%3600==0)){
	MOV	_horaSistema, W0
	MOV	_horaSistema+2, W1
	CP	W0, #0
	CPB	W1, #0
	BRA NZ	L__int_1368
	GOTO	L__int_1251
L__int_1368:
	MOV	#3600, W2
	MOV	#0, W3
	MOV	_horaSistema, W0
	MOV	_horaSistema+2, W1
	CLR	W4
	CALL	__Modulus_32x32
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__int_1369
	GOTO	L__int_1250
L__int_1369:
L__int_1249:
;ConcentradorPrincipal.c,524 :: 		banRespuestaPi = 0;                                                     //No envia respuesta a la RPi
	MOV	#lo_addr(_banRespuestaPi), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,526 :: 		banGPSI = 1;                                                            //Activa la bandera de inicio de trama  del GPS
	MOV	#lo_addr(_banGPSI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,527 :: 		banGPSC = 0;                                                            //Limpia la bandera de trama completa
	MOV	#lo_addr(_banGPSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,528 :: 		U1MODE.UARTEN = 1;                                                      //Inicializa el UART1
	BSET	U1MODE, #15
;ConcentradorPrincipal.c,530 :: 		T1CON.TON = 1;
	BSET	T1CON, #15
;ConcentradorPrincipal.c,531 :: 		TMR1 = 0;
	CLR	TMR1
;ConcentradorPrincipal.c,523 :: 		if ((horaSistema!=0)&&(horaSistema%3600==0)){
L__int_1251:
L__int_1250:
;ConcentradorPrincipal.c,534 :: 		}
L_end_int_1:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	50
	POP	DSWPAG
	RETFIE
; end of _int_1

_int_2:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;ConcentradorPrincipal.c,539 :: 		void int_2() org IVT_ADDR_INT2INTERRUPT {
;ConcentradorPrincipal.c,541 :: 		INT2IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT2
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	INT2IF_bit, BitPos(INT2IF_bit+0)
;ConcentradorPrincipal.c,543 :: 		if (banSyncReloj==1){
	MOV	#lo_addr(_banSyncReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_2371
	GOTO	L_int_2125
L__int_2371:
;ConcentradorPrincipal.c,545 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);
	MOV	_fechaSistema, W12
	MOV	_fechaSistema+2, W13
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;ConcentradorPrincipal.c,546 :: 		LED1 = ~LED1;                                                  //TEST
	BTG	LATA1_bit, BitPos(LATA1_bit+0)
;ConcentradorPrincipal.c,549 :: 		Delay_ms(499);
	MOV	#61, W8
	MOV	#59875, W7
L_int_2126:
	DEC	W7
	BRA NZ	L_int_2126
	DEC	W8
	BRA NZ	L_int_2126
	NOP
	NOP
	NOP
	NOP
;ConcentradorPrincipal.c,550 :: 		DS3234_setDate(horaSistema, fechaSistema);                             //Configura la hora en el RTC con la hora recuperada de la RPi
	MOV	_fechaSistema, W12
	MOV	_fechaSistema+2, W13
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	CALL	_DS3234_setDate
;ConcentradorPrincipal.c,552 :: 		banSyncReloj = 0;
	MOV	#lo_addr(_banSyncReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,553 :: 		banSetReloj = 1;                                                       //Activa esta bandera para continuar trabajando con el pulso SQW
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,555 :: 		}
L_int_2125:
;ConcentradorPrincipal.c,557 :: 		}
L_end_int_2:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	50
	POP	DSWPAG
	RETFIE
; end of _int_2

_Timer1Int:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;ConcentradorPrincipal.c,562 :: 		void Timer1Int() org IVT_ADDR_T1INTERRUPT{
;ConcentradorPrincipal.c,564 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del Timer1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;ConcentradorPrincipal.c,565 :: 		contTimeout1++;                                                            //Incrementa el contador de Timeout
	MOV.B	#1, W1
	MOV	#lo_addr(_contTimeout1), W0
	ADD.B	W1, [W0], [W0]
;ConcentradorPrincipal.c,568 :: 		if (contTimeout1==4){
	MOV	#lo_addr(_contTimeout1), W0
	MOV.B	[W0], W0
	CP.B	W0, #4
	BRA Z	L__Timer1Int373
	GOTO	L_Timer1Int128
L__Timer1Int373:
;ConcentradorPrincipal.c,569 :: 		T1CON.TON = 0;
	BCLR	T1CON, #15
;ConcentradorPrincipal.c,570 :: 		TMR1 = 0;
	CLR	TMR1
;ConcentradorPrincipal.c,571 :: 		contTimeout1 = 0;
	MOV	#lo_addr(_contTimeout1), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,573 :: 		horaSistema = RecuperarHoraRTC();                                       //Recupera la hora del RTC
	CALL	_RecuperarHoraRTC
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;ConcentradorPrincipal.c,574 :: 		fechaSistema = RecuperarFechaRTC();                                     //Recupera la fecha del RTC
	CALL	_RecuperarFechaRTC
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;ConcentradorPrincipal.c,575 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);                //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas del RTC
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;ConcentradorPrincipal.c,576 :: 		fuenteReloj = 7;                                                        //**Indica que se obtuvo la hora del RTC
	MOV	#lo_addr(_fuenteReloj), W1
	MOV.B	#7, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,579 :: 		if (banRespuestaPi==1){
	MOV	#lo_addr(_banRespuestaPi), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__Timer1Int374
	GOTO	L_Timer1Int129
L__Timer1Int374:
;ConcentradorPrincipal.c,580 :: 		numDatosPayload = 7;
	MOV	#7, W0
	MOV	W0, _numDatosPayload
;ConcentradorPrincipal.c,581 :: 		cabeceraSolicitud[3] = *(ptrNumDatosPayload);
	MOV	_ptrNumDatosPayload, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraSolicitud+3), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,582 :: 		cabeceraSolicitud[4] = *(ptrNumDatosPayload+1);
	MOV	_ptrNumDatosPayload, W0
	INC	W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraSolicitud+4), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,583 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_Timer1Int130:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__Timer1Int375
	GOTO	L_Timer1Int131
L__Timer1Int375:
;ConcentradorPrincipal.c,584 :: 		payloadConcentrador[x] = tiempo[x];
	MOV	#lo_addr(_payloadConcentrador), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;ConcentradorPrincipal.c,583 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,585 :: 		}
	GOTO	L_Timer1Int130
L_Timer1Int131:
;ConcentradorPrincipal.c,586 :: 		payloadConcentrador[6] = fuenteReloj;
	MOV	#lo_addr(_payloadConcentrador+6), W1
	MOV	#lo_addr(_fuenteReloj), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,587 :: 		EnviarCabeceraRespuesta(cabeceraSolicitud);
	MOV	#lo_addr(_cabeceraSolicitud), W10
	CALL	_EnviarCabeceraRespuesta
;ConcentradorPrincipal.c,588 :: 		}
L_Timer1Int129:
;ConcentradorPrincipal.c,590 :: 		}
L_Timer1Int128:
;ConcentradorPrincipal.c,592 :: 		}
L_end_Timer1Int:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	50
	POP	DSWPAG
	RETFIE
; end of _Timer1Int

_Timer2Int:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;ConcentradorPrincipal.c,597 :: 		void Timer2Int() org IVT_ADDR_T2INTERRUPT{
;ConcentradorPrincipal.c,599 :: 		T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del Timer2
	BCLR	T2IF_bit, BitPos(T2IF_bit+0)
;ConcentradorPrincipal.c,600 :: 		T2CON.TON = 0;                                                             //Apaga el Timer
	BCLR	T2CON, #15
;ConcentradorPrincipal.c,601 :: 		TMR2 = 0;
	CLR	TMR2
;ConcentradorPrincipal.c,603 :: 		LED1 = ~LED1;//TEST
	BTG	LATA1_bit, BitPos(LATA1_bit+0)
;ConcentradorPrincipal.c,606 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,607 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,608 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;ConcentradorPrincipal.c,611 :: 		numDatosPayload = 3;
	MOV	#3, W0
	MOV	W0, _numDatosPayload
;ConcentradorPrincipal.c,617 :: 		}
L_end_Timer2Int:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	50
	POP	DSWPAG
	RETFIE
; end of _Timer2Int

_urx_1:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;ConcentradorPrincipal.c,622 :: 		void urx_1() org  IVT_ADDR_U1RXINTERRUPT {
;ConcentradorPrincipal.c,625 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;ConcentradorPrincipal.c,626 :: 		byteGPS = U1RXREG;                                                         //Lee el byte de la trama enviada por el GPS
	MOV	#lo_addr(_byteGPS), W1
	MOV.B	U1RXREG, WREG
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,627 :: 		U1STA.OERR = 0;                                                            //Limpia este bit para limpiar el FIFO UART1
	BCLR	U1STA, #1
;ConcentradorPrincipal.c,630 :: 		if (banGPSI==3){
	MOV	#lo_addr(_banGPSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA Z	L__urx_1378
	GOTO	L_urx_1133
L__urx_1378:
;ConcentradorPrincipal.c,631 :: 		if (byteGPS!=0x2A){
	MOV	#lo_addr(_byteGPS), W0
	MOV.B	[W0], W1
	MOV.B	#42, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1379
	GOTO	L_urx_1134
L__urx_1379:
;ConcentradorPrincipal.c,632 :: 		tramaGPS[i_gps] = byteGPS;                                           //LLena la tramaGPS hasta recibir el ultimo simbolo ("*") de la trama GPS
	MOV	#lo_addr(_tramaGPS), W1
	MOV	#lo_addr(_i_gps), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteGPS), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,633 :: 		i_gps++;
	MOV	#1, W1
	MOV	#lo_addr(_i_gps), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,634 :: 		} else {
	GOTO	L_urx_1135
L_urx_1134:
;ConcentradorPrincipal.c,635 :: 		banGPSI = 0;                                                         //Limpia la bandera de inicio de trama
	MOV	#lo_addr(_banGPSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,636 :: 		banGPSC = 1;                                                         //Activa la bandera de trama completa
	MOV	#lo_addr(_banGPSC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,637 :: 		}
L_urx_1135:
;ConcentradorPrincipal.c,638 :: 		}
L_urx_1133:
;ConcentradorPrincipal.c,641 :: 		if ((banGPSI==1)){
	MOV	#lo_addr(_banGPSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1380
	GOTO	L_urx_1136
L__urx_1380:
;ConcentradorPrincipal.c,642 :: 		if (byteGPS==0x24){                                                     //Verifica si el primer byte recibido sea la cabecera de trama "$"
	MOV	#lo_addr(_byteGPS), W0
	MOV.B	[W0], W1
	MOV.B	#36, W0
	CP.B	W1, W0
	BRA Z	L__urx_1381
	GOTO	L_urx_1137
L__urx_1381:
;ConcentradorPrincipal.c,643 :: 		banGPSI = 2;
	MOV	#lo_addr(_banGPSI), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,644 :: 		i_gps = 0;
	CLR	W0
	MOV	W0, _i_gps
;ConcentradorPrincipal.c,645 :: 		}
L_urx_1137:
;ConcentradorPrincipal.c,646 :: 		}
L_urx_1136:
;ConcentradorPrincipal.c,647 :: 		if ((banGPSI==2)&&(i_gps<6)){
	MOV	#lo_addr(_banGPSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__urx_1382
	GOTO	L__urx_1256
L__urx_1382:
	MOV	_i_gps, W0
	CP	W0, #6
	BRA LTU	L__urx_1383
	GOTO	L__urx_1255
L__urx_1383:
L__urx_1254:
;ConcentradorPrincipal.c,648 :: 		tramaGPS[i_gps] = byteGPS;                                              //Recupera los datos de cabecera de la trama GPS: ["$", "G", "P", "R", "M", "C"]
	MOV	#lo_addr(_tramaGPS), W1
	MOV	#lo_addr(_i_gps), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteGPS), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,649 :: 		i_gps++;
	MOV	#1, W1
	MOV	#lo_addr(_i_gps), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,647 :: 		if ((banGPSI==2)&&(i_gps<6)){
L__urx_1256:
L__urx_1255:
;ConcentradorPrincipal.c,651 :: 		if ((banGPSI==2)&&(i_gps==6)){
	MOV	#lo_addr(_banGPSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__urx_1384
	GOTO	L__urx_1263
L__urx_1384:
	MOV	_i_gps, W0
	CP	W0, #6
	BRA Z	L__urx_1385
	GOTO	L__urx_1262
L__urx_1385:
L__urx_1253:
;ConcentradorPrincipal.c,653 :: 		T1CON.TON = 0;
	BCLR	T1CON, #15
;ConcentradorPrincipal.c,654 :: 		TMR1 = 0;
	CLR	TMR1
;ConcentradorPrincipal.c,656 :: 		if (tramaGPS[1]=='G'&&tramaGPS[2]=='P'&&tramaGPS[3]=='R'&&tramaGPS[4]=='M'&&tramaGPS[5]=='C'){
	MOV	#lo_addr(_tramaGPS+1), W0
	MOV.B	[W0], W1
	MOV.B	#71, W0
	CP.B	W1, W0
	BRA Z	L__urx_1386
	GOTO	L__urx_1261
L__urx_1386:
	MOV	#lo_addr(_tramaGPS+2), W0
	MOV.B	[W0], W1
	MOV.B	#80, W0
	CP.B	W1, W0
	BRA Z	L__urx_1387
	GOTO	L__urx_1260
L__urx_1387:
	MOV	#lo_addr(_tramaGPS+3), W0
	MOV.B	[W0], W1
	MOV.B	#82, W0
	CP.B	W1, W0
	BRA Z	L__urx_1388
	GOTO	L__urx_1259
L__urx_1388:
	MOV	#lo_addr(_tramaGPS+4), W0
	MOV.B	[W0], W1
	MOV.B	#77, W0
	CP.B	W1, W0
	BRA Z	L__urx_1389
	GOTO	L__urx_1258
L__urx_1389:
	MOV	#lo_addr(_tramaGPS+5), W0
	MOV.B	[W0], W1
	MOV.B	#67, W0
	CP.B	W1, W0
	BRA Z	L__urx_1390
	GOTO	L__urx_1257
L__urx_1390:
L__urx_1252:
;ConcentradorPrincipal.c,657 :: 		banGPSI = 3;
	MOV	#lo_addr(_banGPSI), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,658 :: 		i_gps = 0;
	CLR	W0
	MOV	W0, _i_gps
;ConcentradorPrincipal.c,659 :: 		} else {
	GOTO	L_urx_1147
;ConcentradorPrincipal.c,656 :: 		if (tramaGPS[1]=='G'&&tramaGPS[2]=='P'&&tramaGPS[3]=='R'&&tramaGPS[4]=='M'&&tramaGPS[5]=='C'){
L__urx_1261:
L__urx_1260:
L__urx_1259:
L__urx_1258:
L__urx_1257:
;ConcentradorPrincipal.c,660 :: 		banGPSI = 0;
	MOV	#lo_addr(_banGPSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,661 :: 		banGPSC = 0;
	MOV	#lo_addr(_banGPSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,662 :: 		i_gps = 0;
	CLR	W0
	MOV	W0, _i_gps
;ConcentradorPrincipal.c,664 :: 		horaSistema = RecuperarHoraRTC();                                    //Recupera la hora del RTC
	CALL	_RecuperarHoraRTC
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;ConcentradorPrincipal.c,665 :: 		fechaSistema = RecuperarFechaRTC();                                  //Recupera la fecha del RTC
	CALL	_RecuperarFechaRTC
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;ConcentradorPrincipal.c,666 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);             //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas del RTC
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;ConcentradorPrincipal.c,667 :: 		fuenteReloj = 5;                                                     //**Fuente de reloj = RTC
	MOV	#lo_addr(_fuenteReloj), W1
	MOV.B	#5, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,668 :: 		banGPSI = 0;
	MOV	#lo_addr(_banGPSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,669 :: 		banGPSC = 0;
	MOV	#lo_addr(_banGPSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,670 :: 		i_gps = 0;
	CLR	W0
	MOV	W0, _i_gps
;ConcentradorPrincipal.c,671 :: 		U1MODE.UARTEN = 0;                                                   //Desactiva el UART1
	BCLR	U1MODE, #15
;ConcentradorPrincipal.c,674 :: 		if (banRespuestaPi==1){
	MOV	#lo_addr(_banRespuestaPi), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1391
	GOTO	L_urx_1148
L__urx_1391:
;ConcentradorPrincipal.c,675 :: 		numDatosPayload = 7;
	MOV	#7, W0
	MOV	W0, _numDatosPayload
;ConcentradorPrincipal.c,676 :: 		cabeceraSolicitud[3] = *(ptrNumDatosPayload);
	MOV	_ptrNumDatosPayload, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraSolicitud+3), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,677 :: 		cabeceraSolicitud[4] = *(ptrNumDatosPayload+1);
	MOV	_ptrNumDatosPayload, W0
	INC	W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraSolicitud+4), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,678 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_urx_1149:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__urx_1392
	GOTO	L_urx_1150
L__urx_1392:
;ConcentradorPrincipal.c,679 :: 		payloadConcentrador[x] = tiempo[x];
	MOV	#lo_addr(_payloadConcentrador), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;ConcentradorPrincipal.c,678 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,680 :: 		}
	GOTO	L_urx_1149
L_urx_1150:
;ConcentradorPrincipal.c,681 :: 		payloadConcentrador[6] = fuenteReloj;
	MOV	#lo_addr(_payloadConcentrador+6), W1
	MOV	#lo_addr(_fuenteReloj), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,682 :: 		EnviarCabeceraRespuesta(cabeceraSolicitud);
	MOV	#lo_addr(_cabeceraSolicitud), W10
	CALL	_EnviarCabeceraRespuesta
;ConcentradorPrincipal.c,683 :: 		}
L_urx_1148:
;ConcentradorPrincipal.c,685 :: 		}
L_urx_1147:
;ConcentradorPrincipal.c,651 :: 		if ((banGPSI==2)&&(i_gps==6)){
L__urx_1263:
L__urx_1262:
;ConcentradorPrincipal.c,689 :: 		if (banGPSC==1){
	MOV	#lo_addr(_banGPSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1393
	GOTO	L_urx_1152
L__urx_1393:
;ConcentradorPrincipal.c,691 :: 		if (tramaGPS[12]==0x41) {
	MOV	#lo_addr(_tramaGPS+12), W0
	MOV.B	[W0], W1
	MOV.B	#65, W0
	CP.B	W1, W0
	BRA Z	L__urx_1394
	GOTO	L_urx_1153
L__urx_1394:
;ConcentradorPrincipal.c,692 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_urx_1154:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__urx_1395
	GOTO	L_urx_1155
L__urx_1395:
;ConcentradorPrincipal.c,693 :: 		datosGPS[x] = tramaGPS[x+1];                                     //Guarda los datos de hhmmss
	MOV	#lo_addr(_datosGPS), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaGPS), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;ConcentradorPrincipal.c,692 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,694 :: 		}
	GOTO	L_urx_1154
L_urx_1155:
;ConcentradorPrincipal.c,696 :: 		for (x=44;x<54;x++){
	MOV	#44, W0
	MOV	W0, _x
L_urx_1157:
	MOV	#54, W1
	MOV	#lo_addr(_x), W0
	CP	W1, [W0]
	BRA GTU	L__urx_1396
	GOTO	L_urx_1158
L__urx_1396:
;ConcentradorPrincipal.c,697 :: 		if (tramaGPS[x]==0x2C){
	MOV	#lo_addr(_tramaGPS), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV.B	#44, W0
	CP.B	W1, W0
	BRA Z	L__urx_1397
	GOTO	L_urx_1160
L__urx_1397:
;ConcentradorPrincipal.c,698 :: 		for (y=0;y<6;y++){
	CLR	W0
	MOV	W0, _y
L_urx_1161:
	MOV	_y, W0
	CP	W0, #6
	BRA LTU	L__urx_1398
	GOTO	L_urx_1162
L__urx_1398:
;ConcentradorPrincipal.c,699 :: 		datosGPS[6+y] = tramaGPS[x+y+1];                         //Guarda los datos de DDMMAA en la trama datosGPS
	MOV	_y, W0
	ADD	W0, #6, W1
	MOV	#lo_addr(_datosGPS), W0
	ADD	W0, W1, W2
	MOV	_x, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaGPS), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;ConcentradorPrincipal.c,698 :: 		for (y=0;y<6;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,700 :: 		}
	GOTO	L_urx_1161
L_urx_1162:
;ConcentradorPrincipal.c,701 :: 		}
L_urx_1160:
;ConcentradorPrincipal.c,696 :: 		for (x=44;x<54;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,702 :: 		}
	GOTO	L_urx_1157
L_urx_1158:
;ConcentradorPrincipal.c,703 :: 		horaSistema = RecuperarHoraGPS(datosGPS);                            //Recupera la hora del GPS
	MOV	#lo_addr(_datosGPS), W10
	CALL	_RecuperarHoraGPS
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;ConcentradorPrincipal.c,704 :: 		fechaSistema = RecuperarFechaGPS(datosGPS);                          //Recupera la fecha del GPS
	MOV	#lo_addr(_datosGPS), W10
	CALL	_RecuperarFechaGPS
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;ConcentradorPrincipal.c,705 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);             //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas del gps
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;ConcentradorPrincipal.c,706 :: 		fuenteReloj = 2;                                                     //Indica que se obtuvo la hora del GPS
	MOV	#lo_addr(_fuenteReloj), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,707 :: 		banSyncReloj = 1;
	MOV	#lo_addr(_banSyncReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,708 :: 		banSetReloj = 0;
	MOV	#lo_addr(_banSetReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,711 :: 		if (banRespuestaPi==1){
	MOV	#lo_addr(_banRespuestaPi), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1399
	GOTO	L_urx_1164
L__urx_1399:
;ConcentradorPrincipal.c,712 :: 		numDatosPayload = 7;
	MOV	#7, W0
	MOV	W0, _numDatosPayload
;ConcentradorPrincipal.c,713 :: 		cabeceraSolicitud[3] = *(ptrNumDatosPayload);
	MOV	_ptrNumDatosPayload, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraSolicitud+3), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,714 :: 		cabeceraSolicitud[4] = *(ptrNumDatosPayload+1);
	MOV	_ptrNumDatosPayload, W0
	INC	W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraSolicitud+4), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,715 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_urx_1165:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__urx_1400
	GOTO	L_urx_1166
L__urx_1400:
;ConcentradorPrincipal.c,716 :: 		payloadConcentrador[x] = tiempo[x];
	MOV	#lo_addr(_payloadConcentrador), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;ConcentradorPrincipal.c,715 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,717 :: 		}
	GOTO	L_urx_1165
L_urx_1166:
;ConcentradorPrincipal.c,718 :: 		payloadConcentrador[6] = fuenteReloj;
	MOV	#lo_addr(_payloadConcentrador+6), W1
	MOV	#lo_addr(_fuenteReloj), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,719 :: 		EnviarCabeceraRespuesta(cabeceraSolicitud);
	MOV	#lo_addr(_cabeceraSolicitud), W10
	CALL	_EnviarCabeceraRespuesta
;ConcentradorPrincipal.c,720 :: 		}
L_urx_1164:
;ConcentradorPrincipal.c,722 :: 		} else {
	GOTO	L_urx_1168
L_urx_1153:
;ConcentradorPrincipal.c,724 :: 		horaSistema = RecuperarHoraRTC();                                    //Recupera la hora del RTC
	CALL	_RecuperarHoraRTC
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;ConcentradorPrincipal.c,725 :: 		fechaSistema = RecuperarFechaRTC();                                  //Recupera la fecha del RTC
	CALL	_RecuperarFechaRTC
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;ConcentradorPrincipal.c,726 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);             //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas del RTC
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;ConcentradorPrincipal.c,727 :: 		fuenteReloj = 6;                                                     //**Indica que se obtuvo la hora del RTC
	MOV	#lo_addr(_fuenteReloj), W1
	MOV.B	#6, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,730 :: 		if (banRespuestaPi==1){
	MOV	#lo_addr(_banRespuestaPi), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1401
	GOTO	L_urx_1169
L__urx_1401:
;ConcentradorPrincipal.c,731 :: 		numDatosPayload = 7;
	MOV	#7, W0
	MOV	W0, _numDatosPayload
;ConcentradorPrincipal.c,732 :: 		cabeceraSolicitud[3] = *(ptrNumDatosPayload);
	MOV	_ptrNumDatosPayload, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraSolicitud+3), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,733 :: 		cabeceraSolicitud[4] = *(ptrNumDatosPayload+1);
	MOV	_ptrNumDatosPayload, W0
	INC	W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_cabeceraSolicitud+4), W0
	MOV.B	W1, [W0]
;ConcentradorPrincipal.c,734 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_urx_1170:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__urx_1402
	GOTO	L_urx_1171
L__urx_1402:
;ConcentradorPrincipal.c,735 :: 		payloadConcentrador[x] = tiempo[x];
	MOV	#lo_addr(_payloadConcentrador), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;ConcentradorPrincipal.c,734 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,736 :: 		}
	GOTO	L_urx_1170
L_urx_1171:
;ConcentradorPrincipal.c,737 :: 		payloadConcentrador[6] = fuenteReloj;
	MOV	#lo_addr(_payloadConcentrador+6), W1
	MOV	#lo_addr(_fuenteReloj), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,738 :: 		EnviarCabeceraRespuesta(cabeceraSolicitud);
	MOV	#lo_addr(_cabeceraSolicitud), W10
	CALL	_EnviarCabeceraRespuesta
;ConcentradorPrincipal.c,739 :: 		}
L_urx_1169:
;ConcentradorPrincipal.c,741 :: 		}
L_urx_1168:
;ConcentradorPrincipal.c,743 :: 		banGPSI = 0;
	MOV	#lo_addr(_banGPSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,744 :: 		banGPSC = 0;
	MOV	#lo_addr(_banGPSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,745 :: 		i_gps = 0;
	CLR	W0
	MOV	W0, _i_gps
;ConcentradorPrincipal.c,746 :: 		U1MODE.UARTEN = 0;                                                      //Desactiva el UART1
	BCLR	U1MODE, #15
;ConcentradorPrincipal.c,748 :: 		}
L_urx_1152:
;ConcentradorPrincipal.c,750 :: 		}
L_end_urx_1:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	50
	POP	DSWPAG
	RETFIE
; end of _urx_1

_urx_2:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;ConcentradorPrincipal.c,755 :: 		void urx_2() org  IVT_ADDR_U2RXINTERRUPT {
;ConcentradorPrincipal.c,758 :: 		U2RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART2
	PUSH	W10
	BCLR	U2RXIF_bit, BitPos(U2RXIF_bit+0)
;ConcentradorPrincipal.c,759 :: 		byteRS485 = U2RXREG;                                                       //Lee el byte de la trama enviada por el nodo
	MOV	#lo_addr(_byteRS485), W1
	MOV.B	U2RXREG, WREG
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,760 :: 		U2STA.OERR = 0;                                                            //Limpia este bit para limpiar el FIFO UART2
	BCLR	U2STA, #1
;ConcentradorPrincipal.c,763 :: 		if (banRSI2==2){
	MOV	#lo_addr(_banRSI2), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__urx_2404
	GOTO	L_urx_2173
L__urx_2404:
;ConcentradorPrincipal.c,765 :: 		if (i_rs4852<(numDatosPayload)){
	MOV	_i_rs4852, W1
	MOV	#lo_addr(_numDatosPayload), W0
	CP	W1, [W0]
	BRA LTU	L__urx_2405
	GOTO	L_urx_2174
L__urx_2405:
;ConcentradorPrincipal.c,766 :: 		pyloadRS485[i_rs4852] = byteRS4852;
	MOV	#lo_addr(_pyloadRS485), W1
	MOV	#lo_addr(_i_rs4852), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS4852), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,767 :: 		i_rs4852++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs4852), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,768 :: 		} else {
	GOTO	L_urx_2175
L_urx_2174:
;ConcentradorPrincipal.c,769 :: 		banRSI2 = 0;                                                       //Limpia la bandera de inicio de trama
	MOV	#lo_addr(_banRSI2), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,770 :: 		banRSC2 = 1;                                                       //Activa la bandera de trama completa
	MOV	#lo_addr(_banRSC2), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,771 :: 		}
L_urx_2175:
;ConcentradorPrincipal.c,772 :: 		}
L_urx_2173:
;ConcentradorPrincipal.c,775 :: 		if ((banRSI2==0)&&(banRSC2==0)){
	MOV	#lo_addr(_banRSI2), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_2406
	GOTO	L__urx_2268
L__urx_2406:
	MOV	#lo_addr(_banRSC2), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_2407
	GOTO	L__urx_2267
L__urx_2407:
L__urx_2266:
;ConcentradorPrincipal.c,776 :: 		if (byteRS4852==0x3A){                                                //Verifica si el primer byte recibido sea el byte de inicio de trama
	MOV	#lo_addr(_byteRS4852), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__urx_2408
	GOTO	L_urx_2179
L__urx_2408:
;ConcentradorPrincipal.c,777 :: 		banRSI2 = 1;
	MOV	#lo_addr(_banRSI2), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,778 :: 		i_rs4852 = 0;
	CLR	W0
	MOV	W0, _i_rs4852
;ConcentradorPrincipal.c,780 :: 		}
L_urx_2179:
;ConcentradorPrincipal.c,775 :: 		if ((banRSI2==0)&&(banRSC2==0)){
L__urx_2268:
L__urx_2267:
;ConcentradorPrincipal.c,782 :: 		if ((banRSI2==1)&&(byteRS4852!=0x3A)&&(i_rs4852<5)){
	MOV	#lo_addr(_banRSI2), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_2409
	GOTO	L__urx_2271
L__urx_2409:
	MOV	#lo_addr(_byteRS4852), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA NZ	L__urx_2410
	GOTO	L__urx_2270
L__urx_2410:
	MOV	_i_rs4852, W0
	CP	W0, #5
	BRA LTU	L__urx_2411
	GOTO	L__urx_2269
L__urx_2411:
L__urx_2265:
;ConcentradorPrincipal.c,783 :: 		tramaCabeceraRS485[i_rs4852] = byteRS4852;                            //Recupera los datos de cabecera de la trama UART: [Direccion, Funcion, Subfuncion, NumeroDatos]
	MOV	#lo_addr(_tramaCabeceraRS485), W1
	MOV	#lo_addr(_i_rs4852), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS4852), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,784 :: 		i_rs4852++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs4852), W0
	ADD	W1, [W0], [W0]
;ConcentradorPrincipal.c,782 :: 		if ((banRSI2==1)&&(byteRS4852!=0x3A)&&(i_rs4852<5)){
L__urx_2271:
L__urx_2270:
L__urx_2269:
;ConcentradorPrincipal.c,786 :: 		if ((banRSI2==1)&&(i_rs4852==5)){
	MOV	#lo_addr(_banRSI2), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_2412
	GOTO	L__urx_2273
L__urx_2412:
	MOV	_i_rs4852, W0
	CP	W0, #5
	BRA Z	L__urx_2413
	GOTO	L__urx_2272
L__urx_2413:
L__urx_2264:
;ConcentradorPrincipal.c,788 :: 		if (tramaCabeceraRS485[0]==idSolicitud){
	MOV	#lo_addr(_tramaCabeceraRS485), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_idSolicitud), W0
	CP.B	W1, [W0]
	BRA Z	L__urx_2414
	GOTO	L_urx_2186
L__urx_2414:
;ConcentradorPrincipal.c,790 :: 		funcionRS485 = tramaCabeceraRS485[1];
	MOV	#lo_addr(_funcionRS485), W1
	MOV	#lo_addr(_tramaCabeceraRS485+1), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,791 :: 		subFuncionRS485 = tramaCabeceraRS485[2];
	MOV	#lo_addr(_subFuncionRS485), W1
	MOV	#lo_addr(_tramaCabeceraRS485+2), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,792 :: 		*(ptrNumDatosPayload) = tramaCabeceraRS485[3];
	MOV	#lo_addr(_tramaCabeceraRS485+3), W1
	MOV	_ptrNumDatosPayload, W0
	MOV.B	[W1], [W0]
;ConcentradorPrincipal.c,793 :: 		*(ptrNumDatosPayload+1) = tramaCabeceraRS485[4];
	MOV	_ptrNumDatosPayload, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaCabeceraRS485+4), W0
	MOV.B	[W0], [W1]
;ConcentradorPrincipal.c,794 :: 		idSolicitud = 0;                                                   //Encera el idSolicitud
	MOV	#lo_addr(_idSolicitud), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,795 :: 		i_rs4852 = 0;                                                      //Encera el subindice para almacenar el payload
	CLR	W0
	MOV	W0, _i_rs4852
;ConcentradorPrincipal.c,796 :: 		banRSI2 = 2;                                                       //Cambia el valor de la bandera para salir del bucle
	MOV	#lo_addr(_banRSI2), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,798 :: 		} else {
	GOTO	L_urx_2187
L_urx_2186:
;ConcentradorPrincipal.c,799 :: 		banRSI2 = 0;
	MOV	#lo_addr(_banRSI2), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,800 :: 		banRSC2 = 0;
	MOV	#lo_addr(_banRSC2), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,801 :: 		i_rs4852 = 0;
	CLR	W0
	MOV	W0, _i_rs4852
;ConcentradorPrincipal.c,802 :: 		}
L_urx_2187:
;ConcentradorPrincipal.c,786 :: 		if ((banRSI2==1)&&(i_rs4852==5)){
L__urx_2273:
L__urx_2272:
;ConcentradorPrincipal.c,806 :: 		if (banRSC2==1){
	MOV	#lo_addr(_banRSC2), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_2415
	GOTO	L_urx_2188
L__urx_2415:
;ConcentradorPrincipal.c,808 :: 		EnviarCabeceraRespuesta(tramaCabeceraRS485);
	MOV	#lo_addr(_tramaCabeceraRS485), W10
	CALL	_EnviarCabeceraRespuesta
;ConcentradorPrincipal.c,810 :: 		banRSC2 = 0;
	MOV	#lo_addr(_banRSC2), W1
	CLR	W0
	MOV.B	W0, [W1]
;ConcentradorPrincipal.c,811 :: 		}
L_urx_2188:
;ConcentradorPrincipal.c,812 :: 		}
L_end_urx_2:
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	50
	POP	DSWPAG
	RETFIE
; end of _urx_2
