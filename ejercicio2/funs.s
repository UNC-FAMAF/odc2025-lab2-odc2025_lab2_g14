	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480

//-----Funciones Auxiliares-----///

//Funcion delay para el video:

delay:
		//x7: duracion del delay
		SUB SP, SP, 8 										
		STUR x11,  [SP, 0]

		mov x11, x7  							
		loop_delay:
			sub x11, x11, 1
			cbnz x11, loop_delay

		LDUR x11, [SP, 0]					 			
		ADD SP, SP, 8
ret

pintar_pelota:
	sub sp, sp, 16
	stur x30, [sp, 0]
	stur x1, [sp, 8]
	//parámetros: 
	//x5, x6: centro x, centro y
	movz x10, 0x00, lsl 16 // Elijo color
	movk x10, 0x0000, lsl 00 //  Termino de elegir color
	mov x1, #10

	BL pintar_circulo
	movz x10, 0xff, lsl 16 // Elijo color
	movk x10, 0xffff, lsl 00 //  Termino de elegir color
	mov x1, #8
	BL pintar_circulo
	ldur x30, [sp, 0]
	ldur x1, [sp, 8]
	add sp, sp, 16

ret

pintar_nube:
	//PARAMETROS:
	//x1, x2:  ancho, alto del rectangulo principal (el +largo)
	//x3, x4: pos x, y 
	//w10 color 
	SUB SP, SP, 64
	STUR x9, [SP, 0]
	STUR X4, [SP, 8]
	STUR X12, [SP, 16]
	STUR X13, [SP, 24]
	STUR X30, [SP, 32]
	STUR X1, [SP, 40]
	STUR X2, [SP, 48]
	STUR X3, [SP, 56]

	/*------------------------------------------------------------
      Filtro: no pinto nubes si estan en posicion del tablero
	  (para disminuir parpaedo)
         (X ≥ 120  &&  X ≤ 470)  &&  (Y ≤ 63)
      X3 = pos-x   |   X4 = pos-y
    ------------------------------------------------------------*/

    CMP   X3, #120
    BLT   continuar_pintando

    CMP   X3, #470
    BGT   continuar_pintando

    CMP   X4, #63
    BLT   continuar_pintando

    // — Si entra acá, es porque está dentro del área tablero —
salir_sin_pintar:
    LDUR  X1,  [SP, 40]
    LDUR  X2,  [SP, 48]
    LDUR  X3,  [SP, 56]
    LDUR  X9,  [SP, 0]
    LDUR  X4,  [SP, 8]
    LDUR  X12, [SP, 16]
    LDUR  X13, [SP, 24]
    LDUR  X30, [SP, 32]
    ADD   SP, SP, #64
    RET

continuar_pintando:
    MOV   X13, X2           // guardar alto
    BL    pintar_rectangulo

    MOVZ  X10, 0xDF,  LSL #16
    MOVK  X10, 0xDFDD, LSL #0
    MOV   X2, #3
    SUB   X9, X13, X2
    ADD   X4, X4, X13
    BL    pintar_rectangulo       // sombra

    MOVZ  X10, 0xFF,  LSL #16
    MOVK  X10, 0xFFFF, LSL #0
    LSR   X9, X1, #1       // mitad del ancho
    SUB   X1, X1, X9
    LSR   X12, X1, #1
    ADD   X3, X3, X12
    SUB   X4, X4, X13
    SUB   X4, X4, X13
    MOV   X2, X13          // restaurar alto
    BL    pintar_rectangulo       // rectángulo pequeño

    // — EPÍLOGO —
    B     salir_sin_pintar

borrar_nube: 
	SUB SP, SP, 16
	STUR X30, [SP, 0]
	STUR X10, [SP, 8]
	//parametros:
	//x1, x2: ancho, alto
	//x3, x4 pos x, y 
	movz x10, 0x83, lsl 16 // Elijo color
	movk x10, 0xb6c1, lsl 00 //  Termino de elegir color: 0x79bacc
	sub x4, x4, x2 
	add x2, x2, x2
	add x2, x2, #3 
	BL pintar_rectangulo 
	LDUR X30, [SP, 0]
	LDUR X10, [SP, 8]
	ADD SP, SP, 8
	
ret 

incrementar_posX:
	//parametros: x0: pos x en memoria de la nube
	// x8: cuanto avanza
    sub sp, sp, #32         // Reservar espacio en pila
    stur x30, [sp, #0]     // Guardar registro de retorno
	stur x1, [sp, #8]
	stur x2, [sp, #16]
	stur x8, [sp, #24]
    LDUR W1, [x0]      // Cargar posX (tercer .word)
    ADD W1, W1, W8        // Incrementar X
    MOV W2, SCREEN_WIDTH
    CMP W1, W2
    B.LT no_reset
    MOV W1, #0            // Reiniciar a X=0 si sale de pantalla
no_reset:
    STUR W1, [x0]      // Guardar nueva posX
	ldur x2, [sp, #16]
	ldur x1, [sp, #8]
    ldur x30, [sp, #0]     // Restaurar registro de retorno
	ldur x8, [sp, #24]
    add sp, sp, #24       // Liberar pila
ret

trayectoria_rebote:
    sub sp, sp, 40         // Reservar espacio en pila
    stur x30, [sp, 0]      // Guardar registro de retorno
    stur x12, [sp, 8]    
    stur x13, [sp, 16]
    stur x8, [sp, 24]
	stur x15, [sp, 32]
    LDUR x12, [x0]           // Cargar posX
    LDUR x13, [x1]           // Cargar posY

	LDUR x15, [x2]

	cmp x12, #60
	b.lt fin_rebote

    cmp x12, #213
    b.lt rebote             // Si x12 < 210, salta a rebote

    // Movimiento normal
    sub x12, x12, #4
    sub x13, x13, x8
    STUR x12, [x0]          // Guardar nueva posX
    STUR x13, [x1]
    b fin                   // Salta al final, evitando ejecutar rebote

rebote:
    sub x12, x12, #2
    add x13, x13, #2
    STUR x12, [x0]
    STUR x13, [x1]
	b fin

fin_rebote:
	mov x15, #1
	stur x15, [x2]

fin:
    LDUR x13, [sp, 16]
    LDUR x12, [sp, 8]
    LDUR x30, [sp, 0]
    LDUR x8, [sp, 24]
	LDUR x15, [sp, 32]
    add sp, sp, 40

ret

trayectoria_gol:
    // Parámetros: 
    // x0: dirección de pelota_x en memoria
    // x1: dirección de pelota_y en memoria
    // x8: cantidad a incrementar en Y
    
    sub sp, sp, 32         // Reservar espacio para 4 registros (32 bytes)
    stur x30, [sp, 0]      // Guardar registro de retorno
    stur x12, [sp, 8]      // Guardar registros que usaremos
    stur x13, [sp, 16]
    stur x8, [sp, 24]      // Guardar x8 (valor del incremento)
    
	LDUR x12, [x0]           // Cargar posX actual
	LDUR x13, [x1]           // Cargar posY actual
    
    add x12, x12, #4        // incrementar X (movimiento horizontal)
    sub x13, x13, x8        // decrementar Y (movimiento vertical)
    
    STUR x12, [x0]           // Guardar nueva posX
    STUR x13, [x1]           // Guardar nueva posY
    

    // Restaurar registros
    ldur x8, [sp, 24]
    ldur x13, [sp, 16]
    ldur x12, [sp, 8]
    ldur x30, [sp, 0]      // Restaurar registro de retorno
    add sp, sp, 32         // Liberar espacio correctamente

ret                     // Retornar (en línea separada)

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

		LDUR x30, [SP, 0]
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
		LDUR x9, [SP, 0]                             
   		LDUR x11, [SP, 8]                             
    	LDUR x12, [SP, 16]                             
    	LDUR x13, [SP, 24]                             
    	LDUR x20, [SP, 32]  // <-- Restauramos x20
    	LDUR x30, [SP, 40]
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

	LDUR x1, [SP, 0]
	LDUR x2, [SP, 8]                             
   	LDUR x3, [SP, 16]                             
    LDUR x4, [SP, 24]                             
    LDUR x5, [SP, 32]                             
    LDUR x20, [SP, 40]  // <-- Restauramos x20
    LDUR x30, [SP, 48]
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

	LDUR x1, [SP, 0]
	LDUR x2, [SP, 8]                             
   	LDUR x3, [SP, 16]                             
    LDUR x4, [SP, 24]                             
    LDUR x5, [SP, 32]
	LDUR x6, [SP, 40]
	LDUR x7, [SP, 48]
    LDUR x20, [SP, 56]  // <-- Restauramos x20
    LDUR x30, [SP, 64]
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

	LDUR x1, [SP, 0]
	LDUR x2, [SP, 8]                             
   	LDUR x3, [SP, 16]                             
    LDUR x4, [SP, 24]                             
    LDUR x5, [SP, 32]
	LDUR x6, [SP, 40]
	LDUR x7, [SP, 48]
    LDUR x20, [SP, 56]  // <-- Restauramos x20
    LDUR x30, [SP, 64]
    ADD SP, SP, 80
ret

pintar_tablero:

	SUB SP, SP, 16
	STUR X30, [SP, 0]
	STUR X0, [SP, 8]
/*TABLERO */
	//patas
		mov x9, #166
		mov x11, #219
		mov x12, #2
		loopTablero:
			mov x1, #27 				//Ancho
			mov x2, #123				//Largo 
			mov x3, x9					//Posicion inicial eje x
			mov x4, x11					//Posicion inicial eje x
			movz x10, 0x2b, lsl 16		
			movk x10, 0x3536, lsl 00
			BL pintar_rectangulo
			mov x1, #27					//Ancho
			mov x2, #10					//Largo
			mov x3, x9					//Posicion inicial eje x
			sub x4, x11, #10			//Posicion inicial eje x
			movz x10, 0x0b, lsl 16
			movk x10, 0x1017, lsl 00

			BL pintar_rectangulo

			sub x12, x12, #1
			add x9, x9, #282
			cbnz x12, loopTablero
		
	//base del Tablero
		mov x1, #178
		mov x2, #144
		mov x3, #109
		mov x4, #63
		movz x10, 0x2b, lsl 16
		movk x10, 0x3536, lsl 00
		BL pintar_rectangulo
		mov x3, #345
		BL pintar_rectangulo

/*---Pintar Letras---*/
	//Letras E
		mov x9, #2
		mov x11, #243
		loop_E:
		mov x1, #8
		mov x2, #31
		mov x3, x11
		mov x4, #78
		mov x5, #22
		movz x10, 0xde, lsl 16
		movk x10, 0xd3bc, lsl 00
		BL pintar_E
		sub x9, x9, #1
		add x11, x11, #176
		cbnz x9, loop_E
		
	//Letra H
		mov x1, #9
		mov x2, #29
		mov x3, #148
		mov x4, #79
		mov x5,	#27
		mov x6, #157
		mov x7, #90

		BL pintar_H

	//Letra T
		mov x1, #25
		mov x2, #6
		mov x3, #469
		mov x4, #78
		mov x5,	#31
		mov x6, #477
		mov x7, #84

		BL pintar_T

	//Letra O 
		mov x1, #16 
		mov x5, #193
		mov x6, #94
		BL pintar_circulo  
		mov x1, #10
		movz x10, 0x2b, lsl 16
		movk x10, 0x3536, lsl 00
		BL pintar_circulo

	//Letra S
		// Línea superior horizontal
		mov x1, #20         // Ancho
		mov x2, #6          // Alto 
		mov x3, #445        // X
		mov x4, #78         // Y 
		movz x10, 0xde, lsl 16
		movk x10, 0xd3bc, lsl 00
		BL pintar_rectangulo

		// Línea media horizontal
		mov x4, #90         // Y
		BL pintar_rectangulo

		// Línea inferior horizontal
		mov x4, #103        // Y
		BL pintar_rectangulo

		// Línea vertical superior
		mov x1, #6          // Ancho
		mov x2, #12         // Alto 
		mov x4, #84         // Y
		BL pintar_rectangulo


		// Línea vertical inferior
		mov x3, #459        // X
		mov x4, #96         // Y
		BL pintar_rectangulo

	//Letra G
        // Línea vertical izquierda
        mov x1, #6          // Ancho
        mov x2, #31         // Alto
        mov x3, #370        // X
        mov x4, #78         // Y
        BL pintar_rectangulo

        // Línea horizontal superior
        mov x1, #20         // Ancho
        mov x2, #6          // Alto
        BL pintar_rectangulo

        // Línea horizontal inferior
        mov x4, #103        // Y
        BL pintar_rectangulo

        // Línea horizontal media
        mov x1, #12         // Ancho
        mov x3, #378        // X
        mov x4, #90         // Y
        BL pintar_rectangulo

        // Línea vertical derecha (más corta)
        mov x1, #6          // Ancho
        mov x2, #14         // Alto
        mov x3, #384        // X
        BL pintar_rectangulo

    //Letra U
        // Línea vertical izquierda
        mov x1, #6          // Ancho
        mov x2, #27         // Alto
        mov x3, #395        // X
        mov x4, #78         // Y
        BL pintar_rectangulo

        // Línea vertical derecha
        mov x3, #409        // X
        BL pintar_rectangulo

        // Línea horizontal inferior
        mov x1, #20         // Ancho
        mov x2, #6          // Alto
        mov x3, #395        // X
        mov x4, #103        // Y
        BL pintar_rectangulo

	// letra M
		mov x1, #6
		mov x2, #30
		mov x3, #212
		mov x4, #78
		BL pintar_rectangulo
		mov x3, #233
		BL pintar_rectangulo
	//diagonales M 
		mov x3, #217
		mov x4, #78
		mov x1, #3
		mov x2, #5
		loop_diag_M:
    	BL pintar_rectangulo
    	ADD x3, x3, #1
    	ADD x4, x4, #1

    	// Verificar si x3 > 68
    	MOV x5, #224 
    	CMP x3, x5
    	BGE end_loop_m     // Si x3 <= 224, salta al final

    	B loop_diag_M         
		end_loop_m:
		//fin diag 1

		loop_diag_M2:
    	BL pintar_rectangulo
    	ADD x3, x3, #1
    	SUB x4, x4, #1

    	// Verificar si x3 > 68
    	MOV x5, #232
    	CMP x3, x5
   		BGE end_loop_m2     // Si x3 <= 229, salta al final
    	B loop_diag_M2          // Repetir bucle si ambas condiciones se cumplen
		end_loop_m2:

// Marcadores en 0
	LDUR X0, [SP, 8]
	mov x1, #0
	cmp x1, x0 
	b.ne skip_0 
	mov x1, #22			// Radio del círculo exterior
	mov x5, #205		// Posición X
	mov x6, #155		// Posición Y inicial
	mov x12, #3			// Contador para 3 círculos
	movz x10, 0xde, lsl 16
	movk x10, 0xd3bc, lsl 00

	loop_marcador1_ext:
	BL pintar_circulo
	add x6, x6, #5		// Incrementar Y en 5
	sub x12, x12, #1
	cbnz x12, loop_marcador1_ext

	mov x1, #16			// Radio del círculo interior
	mov x6, #155		// Resetear posición Y
	mov x12, #3			// Resetear contador
	movz x10, 0x2b, lsl 16
	movk x10, 0x3536, lsl 00

	loop_marcador1_int:
	BL pintar_circulo
	add x6, x6, #5		// Incrementar Y en 5
	sub x12, x12, #1
	cbnz x12, loop_marcador1_int
skip_0:
// Segundo marcador
	mov x1, #22			// Radio del círculo exterior
	mov x5, #432		// Nueva posición X
	mov x6, #155		// Resetear posición Y
	mov x12, #3			// Resetear contador
	movz x10, 0xde, lsl 16
	movk x10, 0xd3bc, lsl 00

	loop_marcador2_ext:
	BL pintar_circulo
	add x6, x6, #5		// Incrementar Y en 5
	sub x12, x12, #1
	cbnz x12, loop_marcador2_ext

	mov x1, #16			// Radio del círculo interior
	mov x6, #155		// Resetear posición Y
	mov x12, #3			// Resetear contador
	movz x10, 0x2b, lsl 16
	movk x10, 0x3536, lsl 00

	loop_marcador2_int:
	BL pintar_circulo
	add x6, x6, #5		// Incrementar Y en 5
	sub x12, x12, #1
	cbnz x12, loop_marcador2_int

/*-Firma OdC--**/
    //letra d
        mov x1, #6 					// asigno el radio del circulo
        mov x5, #320 				// asigno el eje x del centro del circulo
        mov x6, #110 				// asigno el eje y del centro del circulo
        movz x10, 0x00, lsl 16
        movk x10, 0x0000, lsl 00    // asigno el color negro a x10
        BL pintar_circulo 			// pinto el circulo de la letra 'd' (circulo completo)

        mov x1, #4 					// asigno el radio del circulo
        movz x10, 0xff, lsl 16		
        movk x10, 0xff00, lsl 00	// asigno el color amarillo para que quede igual que el fondo
        BL pintar_circulo 			// pinto un segundo circulo dentro del primero para que quede un "huueco" en la d

        movz x10, 0x00, lsl 16
        movk x10, 0x0000, lsl 00	// asigno el color negro a x10
        mov x1, #3 					// asigno el ancho
        mov x2, #16 				// asigno el alto
        mov x3, #324 				// asigno el eje x
        mov x4, #101 				// asigno el eje y
        BL pintar_rectangulo		// pinto la unica recta de la 'd'

    // letra c 
        mov x3, #330 				// asigno el eje x
        mov x4, #101 				// asigno el eje y
        BL pintar_rectangulo		// pinto la unica linea vertical de la 'c'

        mov x1, #10 				// asigno el ancho
        mov x2, #3 					// asigno el alto
        mov x4, #101 				// asigno el eje y
        BL pintar_rectangulo		// pinto la linea horizontal superior de la 'c'

        mov x4, #114 				// asigno el eje y
        BL pintar_rectangulo		// pinto la linea horizontal inferior de la 'c'

    // letra o 
        mov x1, #8  				// asigno el radio del circulo
        mov x5, #304 				// asigno el eje x del centro del circulo
        mov x6, #109 				// asigno el eje y del centro del circulo
        BL pintar_circulo  			// pinto el circulo completo que va formando la 'c'

        mov x1, #4 			 		// asigno el radio del circulo
        movz x10, 0xff, lsl 16
        movk x10, 0xff00, lsl 00	// asigno a x10 el color amarillo para que sea igual al fondo
        BL pintar_circulo 			// pinto otro circulo en el centro para formar la letra 'o'

// Dibuja el 2025
		movz x10, 0x00, lsl 16
		movk x10, 0x0000, lsl 00	// asigno a x10 el color negro

		//variables para el '2'
			mov x9, #8	// x9 = ancho del 2
			mov x12, #300	// x12 = posicion inicial eje x
			mov x13, #124	// x13 = posicion inicial eje y
			mov x14, #2	// contador/restador para dibujar dos '2'

		//variables para el '0' y el '5'
			mov x11, #310		//asigna el eje x para el '0' y también se usa para el '5'
			mov x15, #124		//asigno el eje y para el '5' (lineas horizontales)
			mov x17, #124		//asigno el eje y para el '5' (lineas verticales)


		loop_año:
			// dibuja las tres lineas horizontales de los '2'
				mov x1, x9	// asigno el ancho guardado en x9
				mov x2, #3	// defino el alto
				mov x3, x12	// asigno el eje x guardado en x12
				mov x4, #124	// defino la posicion inicial en el eje y

				BL pintar_rectangulo  // pinta la linea horizontal superior del '2'



				add x4, x4, #6	// muevo la coordenada y 6 pixeles hacia abajo

				BL pintar_rectangulo // pinto la linea horizontal media del '2'


				add x4, x4, #6	// muevo nuevamente el eje y 6 pixeles hacia abajo

				BL pintar_rectangulo	// pinto la linea horizontal inferior del '2'
			

			// dibuja todo el 5 menos la linea horizontal media
				mov x3, #330			//asigno el eje x
				mov x4, x15				//asigno el eje y

				BL pintar_rectangulo	//pinta las lineas horizontales superior e inferior del '5'

				mov x1, #3				//asigno el ancho
				mov x2, #8				//asigno el alto
				mov x3, x11				//asigno al eje x el mismo que se usó para el numero '2'
				add x3, x3, #20			//agrego la diferencia para no dibujar lo mismo
				mov x4, x17				//asigno el eje y

				BL pintar_rectangulo	//pinta las dos lineas verticales del '5'


			// dibuja las dos lineas verticales de los '2'
				mov x1, #3				// reasigno el ancho
				mov x2, #6				// reasigno el alto
				add x3, x12, #5			// reasigno la posicion inicial en el eje x
				mov x4, #124			// reasigno la posicion inicial en el eje y
			
				BL pintar_rectangulo	// dibujo la linea vertical superior del '2'
			
				mov x3, x12				// reasigno la posicion inicial en el eje x
				mov x4, #130			// reasigno la posicion inicial en el eje y
			
				BL pintar_rectangulo	// dibujo la linea vertical inferior del '2'



			// dibuja el 0
				mov x2, #15				// reasigno el alto
				mov x3, x11				// reasigno la posicion inicial en el eje x
				mov x4, #124			// reasigno la posicion inicial en el eje y
				BL pintar_rectangulo	// dibujo las lineas verticales del '0'

				mov x1, #5				// reasigno el ancho
				mov x2, #3				// reasigno el alto
				mov x3, #310			// reasigno la posicion inicial en el eje x
				mov x4, x15				// reasigno la posicion inicial en el eje y
				BL pintar_rectangulo	// dibujo las lineas horizontales del '0'
		
			add x11, x11, #5	// sumo 5 al eje x para dibujar lineas verticales distintas
			add x12, x12, #20	// sumo 22 al eje inicial x para dibujar un segundo '2'
			add x15, x15, #12	// sumo 12 al eje y para dibujar lineas horizontales del '0' y del '5'
			add x17, x17, #6	// sumo 6 al eje y para dibujar las lineas verticales del '5'
			sub x14, x14, #1	// le resto 1 al contador para terminar el ciclo
			cbnz x14, loop_año	// si x14 = 0 entonces salta a la etiqueta loop_año
			// termino de dibujar la linea horizontal media del '5'
				mov x1, #8				//reasigno el ancho
				mov x2, #3				//reasigno el alto
				mov x3, #330			//reasigno el eje x
				mov x4, #130			//reasigno el eje y

				BL pintar_rectangulo	//dibujo la linea horizontal media del '5'
		
/*---fin tablero----*/
	LDUR X0, [SP, 8]
	LDUR X30, [SP, 0]
	ADD SP, SP, 16

ret 

