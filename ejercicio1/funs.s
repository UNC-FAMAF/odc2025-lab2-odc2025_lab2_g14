	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480

//-----Funciones Auxiliares-----///




calcular_posicion:
	//Direccion = Direccion de inicio + 4*[x+(y*640)]
	// x3 = X
	// x4 = Y
	
	mov x0, SCREEN_WIDTH   // x0 = 640
	mul x0, x0, x4 		   // x0 = 640 * Y
	add x0, x0, x3         // x0 = (640 * y) + X
	lsl x0, x0, 2          // x0 = ((640 * y) * x) *4
	add x0, x0, x20        // x0 = ((640 * y) * x) *4 + posicion inicial
ret


pintar_rectangulo:
		// 	w10 -> Color
		//	x1 -> Ancho
		//	x2 -> Alto
		// x3 -> x
		// x4 -> y
		// reservamos y guardamos las variables

		
    	SUB SP, SP, 48                                        
    	STUR x30, [SP, 40]
    	STUR x20, [SP, 32]  // <-- Guardamos x20
    	STUR x13, [SP, 24]
    	STUR x12, [SP, 16]
    	STUR x11, [SP, 8]
    	STUR x9,  [SP, 0]

		BL calcular_posicion  	
		mov x9, x2							// guardamos el alto
		mov x11, x0							// guardamos x0
		loopO:
			mov x13, x1						// x13 = x1 
			mov x12, x11					// guardamos en x12 el inicio de la linea
			loopI:
				stur w10, [x11]				// pintamos
				add x11, x11, 4				// movemos 1 pixel a la derecha
				sub x13, x13, 1				
				cbnz x13, loopI	
				mov x11, x12				//reseteamos x11 al inicio de la linea
				add x11, x11, 2560			// salto de linea
				sub x9, x9, 1				
				cbnz x9, loopO	

		// Devolvemos los valores previos del stack
		LDR x9, [SP, 0]                             
   		LDR x11, [SP, 8]                             
    	LDR x12, [SP, 16]                             
    	LDR x13, [SP, 24]                             
    	LDR x20, [SP, 32]  // <-- Restauramos x20
    	LDR x30, [SP, 40]
    	ADD SP, SP, 48

ret


pintar_E:
	SUB SP, SP, 64                                        
	STUR x30, [SP, 48]
	STUR x20, [SP, 40]  // <-- Guardamos x20
	STUR x5, [SP, 32]
	STUR x4, [SP, 24]
 	STUR x3, [SP, 16]
    STUR x2,  [SP, 8]
	STUR x1, [SP, 0]
	// x1 -> grosor
	// x2 -> Alto
	// x3 -> posición inicial eje x
	// x4 -> posición inicial eje y
	// x5 -> Ancho
	BL pintar_rectangulo	// Pinta la columna de la 'E'
	mov x7, x4
	mov x6, x2
	mov x2, x1	// x2 = grosor
	mov x1, x5	// x1 = Ancho
	mov x5, x6	// x5 = Alto
	sub x2, x2, #2	// El grosor de las lineas en horizontal son menores a la columna de la 'E'

	BL pintar_rectangulo	//Pinta la linea de arriba de la 'E'

	add x4, x4, x6
	sub x4, x4, x2	// calculo la posicion inicial de la ultima linea de la 'E' en el eje y

	BL pintar_rectangulo	// Pinta la última linea de la 'E'

	and x6, x2, #1

	cbz x6, par
	add x2, x2, #1
	and x6, x5, #1
	cbz x6, par
	sub x5, x5, #1		// Para calcular la linea del medio el grosor y el largo deben ser pares

	par:
	sub x1, x1, #1	// la linea del medio es menos ancha que las demas
	mov x6, x2
	lsr x6, x6, #1	//calculo la mitad del grosor
	mov x4, x7
	sub x4, x4, x2
	add x5, x4, x5	//calculo el eje Y al final de la 'E'
	add x4, x4, x5

	lsr x4, x4, #1	// Calculo la posicion del medio en el eje Y
	add x4, x4, x6	// Apunta a la posicion inicial de la linea del medio

	BL pintar_rectangulo

	LDR x1, [SP, 0]
	LDR x2, [SP, 8]                             
   	LDR x3, [SP, 16]                             
    LDR x4, [SP, 24]                             
    LDR x5, [SP, 32]                             
    LDR x20, [SP, 40]  // <-- Restauramos x20
    LDR x30, [SP, 48]
    ADD SP, SP, 64
	

ret


