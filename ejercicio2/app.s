	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	.data
	// Posicion INICIAL en eje x de cada nube
		nube1:  .dword 95   // Nube 1
		nube2:  .dword 20   // Nube 2
		nube3:  .dword 39  // Nube 3 (descomentar si se usa)
		nube4:  .dword 282   // Nube 4
		nube5:  .dword 572   // Nube 5
		nube6:  .dword 506   // Nube 6
		delay_value_nubes: .dword 15500000 //delay para anmimacion nubes

	//Incluyo archivo con funciones auxiliares
	.include "funs.s"

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20

/*---Cielo---*/

	movz x10, 0x83, lsl 16 // Elijo color
	movk x10, 0xb6c1, lsl 00 //  Termino de elegir color: 0x79bacc

	mov x2, SCREEN_HEIGH         // Y Size

	loop1:
	mov x1, SCREEN_WIDTH         // X Size
	loop0:
	stur w10,[x0]  // Colorear el pixel N
	add x0,x0,4	   // Siguiente pixel
	sub x1,x1,1	   // Decrementar contador X
	cbnz x1,loop0  // Si no terminó la fila, salto
	sub x2,x2,1	   // Decrementar contador Y
	cbnz x2,loop1  // Si no es la última fila, salto

/*---Arboles---*/

	mov x1, SCREEN_WIDTH
	mov x2, #192
	mov x3, #0
	mov x4, #166
	
	movz x10, 0x04, lsl 16
	movk x10, 0x1e1b, lsl 00

	BL pintar_rectangulo

	mov x5, #50          // Posición inicial X
	mov x6, #166         // Posición Y fija
	mov x1, #60          // Radio del círculo
	mov x12, #6          // Contador para el bucle (6 árboles)

	loop_arboles_fila1:
	BL pintar_circulo
	add x5, x5, #110     // Incrementar posición X
	sub x12, x12, #1     // Decrementar contador
	cbnz x12, loop_arboles_fila1

	// Segunda fila de árboles
	mov x6, #116         // Nueva altura Y
	mov x5, #110         // Posición inicial X
	mov x1, #35          // Nuevo radio
	mov x12, #8         // 8 arboles (Se podrian hacer menos si la verdad)

	loop_arboles_fila2:
	BL pintar_circulo
	add x5, x5, #60      // Incrementar posición X
	sub x12, x12, #1     // Decrementar contador
	cbnz x12, loop_arboles_fila2

/*---Pasto---*/

	mov x1, SCREEN_WIDTH
	mov x2, #166
	mov x3, #0
	mov x4, #314
	
	movz x10, 0x91, lsl 16
	movk x10, 0xab49, lsl 00

	BL pintar_rectangulo

	mov x1, SCREEN_WIDTH
	mov x2, #104
	mov x3, #0
	mov x4, #376
	movz x10, 0x59, lsl 16
	movk x10, 0x803a, lsl 00

	BL pintar_rectangulo
 
/*----- lineas de la cancha -------*/

	// linea del fondo
	mov x1, SCREEN_WIDTH
	mov x2,	#5
	mov x3,	#0
	mov x4,	#373
	movz x10, 0xf5, lsl 16
	movk x10, 0xf2ce, lsl 00

	BL pintar_rectangulo

	// linea horiz. área chica
	mov x1, #498
	mov x3, #68
	mov x4, #400
	BL pintar_rectangulo

	//linea diagonal izq. área chica:
	mov x1, #4
	mov x2, #4
	mov x3, #92
	mov x4, #375

	loop_diag:
    BL pintar_rectangulo
    SUB x3, x3, #1
    ADD x4, x4, #1

    // Verificar si x3 > 68
    MOV x5, #67
    CMP x3, x5
    BLE end_loop     // Si x3 <= 68, salta al final

    // Verificar si x4 < 400
    MOV x6, #400
    CMP x4, x6
    BGE end_loop     // Si x4 >= 400, salta al final

    B loop_diag          // Repetir bucle si ambas condiciones se cumplen
	end_loop:

	//linea diagonal der. area chica:
	mov x3, #537
	mov x4, #375

	loop_diag2:
    BL pintar_rectangulo
    ADD x3, x3, #1
    ADD x4, x4, #1

    // Verificar si x3 > 68
    MOV x5, #566
    CMP x3, x5
    BGE end_loop2     // Si x3 <= 68, salta al final

    // Verificar si x4 < 400
    MOV x6, #400
    CMP x4, x6
    BGE end_loop2     // Si x4 >= 400, salta al final

    B loop_diag2          // Repetir bucle si ambas condiciones se cumplen
	end_loop2:

	//sombra bajo palos
	mov x1, #230
	mov x2, #5
	mov x3, #205
	mov x4, #373
	movz x10, 0xac, lsl 16
	movk x10, 0xaa8d, lsl 00
	BL pintar_rectangulo

/*-- Punto penal --*/
	mov x1, #6
	movz x10, 0xf5, lsl 16
	movk x10, 0xf2ce, lsl 00
	mov x5, #317
	mov x6, #428
	BL pintar_circulo
	/*-----*/

/*---- Fin lineas ---*/

/*---Arco---*/ 

	// travesaño
	mov x1, #243
	mov x2, #8
	mov x3, #201
	mov x4, #256
	
	movz x10, 0xde, lsl 16
	movk x10, 0xd3bc, lsl 00

	BL pintar_rectangulo

	//poste izquierdo
	mov x1, #9
	mov x2, #122
	mov x3, #201
	BL pintar_rectangulo

	//poste derecho
	mov x3, #435
	BL pintar_rectangulo

/*----Tablero----*/
	
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
		mov x1, #415
		mov x2, #144
		mov x3, #109
		mov x4, #63
		movz x10, 0x2b, lsl 16
		movk x10, 0x3536, lsl 00
		BL pintar_rectangulo
	
	//red
		movz x10, 0x00, lsl 16		//
		movk x10, 0x0000, lsl 00	// Le asigno el color negro a x10

		mov x9, #218		// uso el x9 como el eje x para las lineas verticales
		mov x11, #274		// uso el x11 como el eje y para las lineas horizontales
		mov x12, #22		// uso el x12 como contador para hacer el ciclo

		loop_red:
			mov x1, #1				// asigno el ancho 
			mov x2, #109			// asigno el alto
			mov x3, x9				// asigno el eje x
			mov x4, #264			// asigno el eje y

			BL pintar_rectangulo	// pinta las lineas verticales de la red

			cmp x12, #13			// comparo al contador con #13
			B.lt red_if				// si x12 < 13 pinta las lineas horizontales, sino no las pinta, porque son menos que las verticales

			mov x1, #225			// asigno el ancho
			mov x2, #1				// asigno el alto
			mov x3, #210			// asigno el eje x
			mov x4, x11				// asigno el eje y

			BL pintar_rectangulo	// pinta las lineas horizontales

			red_if:

			add x9, x9, #10			// al eje x le sumo 10 píxeles para dibujar todas las lineas verticales de la red
			add x11, x11, #10		// al eje y le sumo 10 píxeles para dibujar todas las lineas horizontales de la red
			sub x12, x12, #1		// le resto 1 al contador
			cbnz x12, loop_red		// si el contador llega a 0, deja de pintar

/*--Copa--*/
	/*-Base-*/
		movz x10, 0x4c, lsl 16 // Elijo color
		movk x10, 0x261a, lsl 00 //  Termino de elegir color

		mov x1, #40  // Ancho
		mov x2, #5  // Largo
		mov x3, #299 // eje x
		mov x4, #201  // eje y
		BL pintar_rectangulo // Pinto base que estaria en contacto con el piso en un trofeo real

		mov x1, #30  // Ancho
		mov x2, #14  // Largo
		mov x3, #304  // eje x
		mov x4, #188  // eje y
		BL pintar_rectangulo // Ultimo codigo para pintar la base de color marrón
	
	/*-cuerpo-*/
		movz x10, 0xff, lsl 16 // Elijo color
		movk x10, 0xff00, lsl 00 //  Termino de elegir color

		mov x1, #26 // Ancho
		mov x2, #3  // Largo
		mov x3, #305  // eje x
		mov x4, #185  // eje y
		BL pintar_rectangulo
		
		mov x1, #20 // Ancho
		mov x2, #3  // Largo
		mov x3, #308  // eje x
		mov x4, #182  // eje y
		BL pintar_rectangulo

		mov x1, #16 // Ancho
		mov x2, #3  // Largo
		mov x3, #311  // eje x
		mov x4, #179  // eje y
		BL pintar_rectangulo  // hasta aca se dibuja la parte inferior del trofeo

		mov x1, #6 // Ancho
		mov x2, #18  // Largo
		mov x3, #316  // eje x
		mov x4, #163  // eje y
		BL pintar_rectangulo  // se dibuja la coneccion entre la parte baja y alta del cuerpo


		mov x9, #16 // Ancho
		mov x11, #311  // eje x
		mov x12, #162  // eje y
		mov x13, #4   // restador para el ciclo

		loop_cop:
		mov x1, x9	// Ancho
		mov x2, #3	// Largo
		mov x3, x11   // eje x
		mov x4, x12   // eje y

		BL pintar_rectangulo // pinta las primera 4 lineas de la base, de la parte alta, del cuerpo.

		add x9, x9, #4  // sumo 4 pixeles al ancho, 2 por lado
		sub x11, x11, #2   // resto 2 pixeles el punto del eje x, para centralizar
		sub x12, x12, #3	// resto 3 pixeles que representa el largo de cada linea
		sub x13, x13, #1	// resto 1 al contador para hacer un total de 4 lineas
		
		cbnz x13, loop_cop	// si x13 llega a 0, sale del ciclo

		mov x1, #32 // Ancho
		mov x2, #6  // Largo
		mov x3, #303  // eje x
		mov x4, #147  // eje y
		BL pintar_rectangulo // sigue dibujando la parte alta del cuerpo

		mov x9, #32 // Ancho
		mov x11, #3  // Largo
		mov x12, #303  // eje x
		mov x13, #144  // eje y
		mov x14, #0  // contador para el ciclo y ademas se usa para multiplicar a x16 mientras pasa el ciclo
		mov x15, #3

		loop_cop1:
		mov x1, x9 // Ancho
		mov x2, x11  // Largo
		mov x3, x12  // eje x
		mov x4, x13  // eje y
		BL pintar_rectangulo // sigue dibujando la parte alta del cuerpo

		add x14, x14, #1 // aumento 1 al contador
		add x9, x9, #4	// Ancho = Ancho + 4 (2 pixeles para cada lado)
		add x11, x11, #3	// Largo = Largo + 3 (por cada reiteracion aumenta el largo por 3 pixeles)
		sub x12, x12, #2	// x = x - 2 (le resto 2 al eje x para dibujar en otra posicion)
		mul x16, x14, x15	// guardo en x16: 3 * x14 y sirve para restar el eje 'y' y asi poder aumentar el largo de las lineas
		sub x13, x13, x16	// resto al eje y lo guardado en x16
		cmp x14, #6	 // compara al contador (x14) con #6 para dibujar 6 veces
		B.LT loop_cop1	// si x14 < #6 salta a la etiqueta loop_cop1

		movz x10, 0xc0, lsl 16 // Elijo color
		movk x10, 0xc0c0, lsl 00 //  Termino de elegir color
		mov x1, #20  // Ancho
		mov x2, #6  // Largo
		mov x3, #309  // eje x
		mov x4, #192  // eje y
		BL pintar_rectangulo // Dibuja placa plateada del ganador

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
/*-------*/

/*---Nubes---*/
 
loop_nubes:
	movz x10, 0xff, lsl 16
	movk x10, 0xffff, lsl 00

  /*-Nube 2-*/
	mov x1, #30
	mov x2, #6
	ldr x3, nube2
	
	mov x4, #42
	BL pintar_nube
  /*-Nube 6-*/
	mov x1, #29
	mov x2, #7
	ldr x3, nube6
	
	mov x4, #34
	BL pintar_nube

  /*-Nube 1-*/
	mov x1, #63
	mov x2, #15
	ldr x3, nube1
	mov x4, #33
	BL pintar_nube

  /*-Nube 4-*/
	mov x1, #48
	mov x2, #12
	ldr x3, nube4
	mov x4, #20
	BL pintar_nube

  /*-Nube 5-*/
	mov x1, #42
	mov x2, #12
	ldr x3, nube5
	mov x4, #20
	BL pintar_nube

	ldr x7, delay_value_nubes
	BL delay
	
	//ESTO BORRA LAS NUBES EN C/ITERACION:
	mov x1, SCREEN_WIDTH
	mov x2, #56
	mov x3, #0
	mov x4, #0
	movz x10, 0x83, lsl 16 // Elijo color
	movk x10, 0xb6c1, lsl 00
	BL pintar_rectangulo
 
	//Incrementar pos x de c/nube:
	ldr x0, =nube1
	mov x8, #2
	bl incrementar_posX
	ldr x0, =nube4
	bl incrementar_posX
	ldr x0, =nube5
	bl incrementar_posX
	
	ldr x0, =nube2
	mov x8, #1
	bl incrementar_posX
	ldr x0, =nube6
	bl incrementar_posX
b loop_nubes

/*--------------------*/

	// Ejemplo de uso de gpios
	mov x9, GPIO_BASE

	// Atención: se utilizan registros w porque la documentación de broadcom
	// indica que los registros que estamos leyendo y escribiendo son de 32 bits

	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	ldr w10, [x9, GPIO_GPLEV0]

	// And bit a bit mantiene el resultado del bit 2 en w10
	and w11, w10, 0b10

	// w11 será 1 si había un 1 en la posición 2 de w10, si no será 0
	// efectivamente, su valor representará si GPIO 2 está activo
	lsr w11, w11, 1

	//---------------------------------------------------------------
	// Infinite Loop

InfLoop:
	b InfLoop

