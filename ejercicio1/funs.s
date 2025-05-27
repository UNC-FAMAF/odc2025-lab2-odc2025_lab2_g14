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

pintar_pixel:
		// x3 -> pos X
		// x4  -> pos y 
		//w10 color 
		SUB SP, SP, 8 										
		STUR x30, [SP, 0]

		BL calcular_posicion 					

		stur w10, [x0]                     

		LDR x30, [SP, 0]
		ADD SP, SP, 8	
ret


check_pos_in_circle:
    // x3 = X a verificar
    // x4 = Y a verificar
    // x5 = X centro
    // x6 = Y centro
    // x1 = radio
    sub sp, sp, #32
    stur x30, [sp, #24]
    stur x15, [sp, #16]
    stur x14, [sp, #8]
    stur x13, [sp, #0]

    // Calcular (X-Xc)² + (Y-Yc)²
    sub x13, x3, x5         // x13 = X - Xc
    mul x13, x13, x13       // x13 = (X-Xc)²
    
    sub x14, x4, x6         // x14 = Y - Yc
    mul x14, x14, x14       // x14 = (Y-Yc)²
    
    add x13, x13, x14       // x13 = (X-Xc)² + (Y-Yc)²
    
    mul x15, x1, x1         // x15 = radio²
    
    cmp x13, x15
    b.ge fuera_circulo
    
    // Si está dentro del círculo, pintar
    bl pintar_pixel

fuera_circulo:
    ldur x13, [sp, #0]
    ldur x14, [sp, #8]
    ldur x15, [sp, #16]
    ldur x30, [sp, #24]
    add sp, sp, #32


ret

pintar_circulo:
    // x5 = X centro
    // x6 = Y centro
    // x1 = radio
    // x10 = color
    sub sp, sp, #56
    stur x30, [sp, #48]
    stur x12, [sp, #40]
    stur x11, [sp, #32]
    stur x9, [sp, #24]
    stur x8, [sp, #16]
    stur x7, [sp, #8]
    stur x6, [sp, #0]

    // Calcular límites del área a recorrer
    sub x7, x5, x1          // X inicio = Xcentro - radio
    add x8, x5, x1          // X fin = Xcentro + radio
    
    sub x9, x6, x1          // Y inicio = Ycentro - radio
    add x11, x6, x1         // Y fin = Ycentro + radio

    // Ajustar coordenada X mínima
    cmp x7, #0
    b.ge ajuste_x_max
    mov x7, #0              // Si X inicio < 0, ajustar a 0
ajuste_x_max:
    cmp x8, SCREEN_WIDTH
    b.le ajuste_y_min
    mov x8, SCREEN_WIDTH    // Si X fin > ancho, ajustar
ajuste_y_min:
    cmp x9, #0
    b.ge ajuste_y_max
    mov x9, #0              // Si Y inicio < 0, ajustar a 0
ajuste_y_max:
    cmp x11, SCREEN_HEIGH
    b.le iniciar_bucles
    mov x11, SCREEN_HEIGH  // Si Y fin > alto, ajustar

iniciar_bucles:
    mov x4, x9              // Y actual = Y inicio

bucle_y:
    cmp x4, x11             // Comparar con Y fin
    b.gt fin_pintar

    mov x3, x7              // X actual = X inicio

bucle_x:
    cmp x3, x8              // Comparar con X fin
    b.gt siguiente_y
    
    bl check_pos_in_circle  // Verificar si (x3,x4) está en el círculo
    
    add x3, x3, #1          // Siguiente columna
    b bucle_x

siguiente_y:
    add x4, x4, #1          // Siguiente fila
    b bucle_y

fin_pintar:
    ldur x6, [sp, #0]
    ldur x7, [sp, #8]
    ldur x8, [sp, #16]
    ldur x9, [sp, #24]
    ldur x11, [sp, #32]
    ldur x12, [sp, #40]
    ldur x30, [sp, #48]
    add sp, sp, #56
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

pintar_H:
	// x1 -> grosor
	// x2 -> Alto
	// x3 -> eje x (empieza)
	// x4 -> eje y (empieza)
	// x5 -> Ancho
	// x6 -> eje x (Linea horizontal)
	// x7 -> eje y (Linea horizontal)

	SUB SP, SP, 80                                      
	STUR x30, [SP, 64]
	STUR x20, [SP, 56]  // <-- Guardamos x20
	STUR x7, [SP, 48]
	STUR x6, [SP, 40]
	STUR x5, [SP, 32]
	STUR x4, [SP, 24]
 	STUR x3, [SP, 16]
    STUR x2,  [SP, 8]
	STUR x1, [SP, 0]

	BL pintar_rectangulo

	add x3, x3, x5
	sub x3, x3, x1

	BL pintar_rectangulo

	mov x8, x1	// x8 = grosor
	mov x1, x5	// x1 = Ancho
	mov x5, x2	// x5 = Alto
	mov x2, x8	// x2 = grosor

	sub x1, x1, x8
	sub x1, x1, x8

	sub x2, x2, #2

	mov x3, x6
	mov x4, x7

	BL pintar_rectangulo

	LDR x1, [SP, 0]
	LDR x2, [SP, 8]                             
   	LDR x3, [SP, 16]                             
    LDR x4, [SP, 24]                             
    LDR x5, [SP, 32]
	LDR x6, [SP, 40]
	LDR x7, [SP, 48]
    LDR x20, [SP, 56]  // <-- Restauramos x20
    LDR x30, [SP, 64]
    ADD SP, SP, 80

ret


pintar_T:
	SUB SP, SP, 80                                      
	STUR x30, [SP, 64]
	STUR x20, [SP, 56]  // <-- Guardamos x20
	STUR x7, [SP, 48]
	STUR x6, [SP, 40]
	STUR x5, [SP, 32]
	STUR x4, [SP, 24]
 	STUR x3, [SP, 16]
    STUR x2,  [SP, 8]
	STUR x1, [SP, 0]	

	// x1 -> Ancho
	// x2 -> grosor
	// x3 -> eje x (empieza)
	// x4 -> eje y (empieza)
	// x5 -> Alto
	// x6 -> eje x (Linea vertical)
	// x7 -> eje y (Linea vertical)

	BL pintar_rectangulo

	mov x3, x6	// x3 = eje x (comienzo de linea vertical)
	mov x4, x7	// x4 = eje y (comienzo de linea vertical)
	sub x5, x5, x2
	add x2, x2, #2	//distinto grosor
	
	mov x8, x1	// x8 = Ancho
	mov x1, x2	// x1 = grosor
	mov x2, x5	// x2 = Alto
	mov x5, x8	// x2 = grosor

	BL pintar_rectangulo



	LDR x1, [SP, 0]
	LDR x2, [SP, 8]                             
   	LDR x3, [SP, 16]                             
    LDR x4, [SP, 24]                             
    LDR x5, [SP, 32]
	LDR x6, [SP, 40]
	LDR x7, [SP, 48]
    LDR x20, [SP, 56]  // <-- Restauramos x20
    LDR x30, [SP, 64]
    ADD SP, SP, 80
ret

