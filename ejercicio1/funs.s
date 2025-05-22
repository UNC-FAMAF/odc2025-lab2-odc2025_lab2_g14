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
		SUB SP, SP, 40 										
		STUR x9,  [SP, 0]
		STUR x11, [SP, 8]
		STUR x12, [SP, 16]
		STUR x13, [SP, 24]
		STUR x14, [SP, 32]

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
		LDR x14, [SP, 32]					 			
		ADD SP, SP, 40
	ret

