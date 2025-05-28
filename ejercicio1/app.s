	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

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

/*---Nubes---*/
  /*-Nube 1-*/
	movz x10, 0xff, lsl 16
	movk x10, 0xffff, lsl 00

	mov x1, #39
	mov x2, #30
	mov x3, #107
	mov x4, #18

	BL pintar_rectangulo

	mov x1, #63
	mov x2, #15
	mov x3, #95
	mov x4, #33
	BL pintar_rectangulo
  /*-Nube 2-*/
	mov x1, #19
	mov x2, #7
	mov x3, #25
	mov x4, #35

	BL pintar_rectangulo

	mov x1, #30
	mov x2, #6
	mov x3, #20
	mov x4, #42
	BL pintar_rectangulo
  /*-Nube 3-*/
	mov x1, #32
	mov x2, #11
	mov x3, #46
	mov x4, #78

	BL pintar_rectangulo

	mov x1, #46
	mov x2, #6
	mov x3, #39
	mov x4, #89
	BL pintar_rectangulo

  /*-Nube 4-*/
	mov x1, #32
	mov x2, #11
	mov x3, #290
	mov x4, #9

	BL pintar_rectangulo

	mov x1, #48
	mov x2, #12
	mov x3, #282
	mov x4, #20
	BL pintar_rectangulo

  /*-Nube 5-*/
	mov x1, #26
	mov x2, #12
	mov x3, #580
	mov x4, #59

	BL pintar_rectangulo

	mov x1, #42
	mov x2, #12
	mov x3, #572
	mov x4, #70
	BL pintar_rectangulo

  /*-Nube 6-*/
	mov x1, #19
	mov x2, #7
	mov x3, #511
	mov x4, #27

	BL pintar_rectangulo

	mov x1, #29
	mov x2, #7
	mov x3, #506
	mov x4, #34
	BL pintar_rectangulo

/*-Sombras de Nube-*/
   /*-Nube 1-*/
	movz x10, 0xdf, lsl 16
	movk x10, 0xdfdd, lsl 00
	mov x1, #63
	mov x2, #3
	mov x3, #95
	mov x4, #48
	BL pintar_rectangulo

   /*-Nube 2-*/
	mov x1, #30
	mov x2, #3
	mov x3, #20
	mov x4, #48
	BL pintar_rectangulo

   /*-Nube 3-*/
	mov x1, #46
	mov x2, #3
	mov x3, #39
	mov x4, #95
	BL pintar_rectangulo

   /*-Nube 4-*/
	mov x1, #48
	mov x2, #3
	mov x3, #282
	mov x4, #32
	BL pintar_rectangulo

   /*-Nube 5-*/
	mov x1, #42
	mov x2, #3
	mov x3, #572
	mov x4, #82
	BL pintar_rectangulo

   /*-Nube 6-*/
	mov x1, #29
	mov x2, #3
	mov x3, #506
	mov x4, #41
	BL pintar_rectangulo

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
		add x11, x11, #166
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
		mov x3, #459
		mov x4, #78
		mov x5,	#31
		mov x6, #467
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
		mov x3, #435        // X
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
		mov x3, #449        // X
		mov x4, #96         // Y
		BL pintar_rectangulo

	//Letra G
        // Línea vertical izquierda
        mov x1, #6          // Ancho
        mov x2, #31         // Alto
        mov x3, #360        // X
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
        mov x3, #368        // X
        mov x4, #90         // Y
        BL pintar_rectangulo

        // Línea vertical derecha (más corta)
        mov x1, #6          // Ancho
        mov x2, #14         // Alto
        mov x3, #374        // X
        BL pintar_rectangulo

    //Letra U
        // Línea vertical izquierda
        mov x1, #6          // Ancho
        mov x2, #27         // Alto
        mov x3, #385        // X
        mov x4, #78         // Y
        BL pintar_rectangulo

        // Línea vertical derecha
        mov x3, #399        // X
        BL pintar_rectangulo

        // Línea horizontal inferior
        mov x1, #20         // Ancho
        mov x2, #6          // Alto
        mov x3, #385        // X
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
        mov x1, #6 
        mov x5, #316
        mov x6, #155
        movz x10, 0xec, lsl 16
        movk x10, 0xd226, lsl 00
        BL pintar_circulo  
        mov x1, #4
        movz x10, 0x2b, lsl 16
        movk x10, 0x3536, lsl 00
        BL pintar_circulo
        movz x10, 0xec, lsl 16
        movk x10, 0xd226, lsl 00
        mov x1, #3
        mov x2, #16
        mov x3, #320
        mov x4, #146
        BL pintar_rectangulo
    // letra o 
        mov x1, #8 
        mov x5, #300
        mov x6, #154
        BL pintar_circulo  
        mov x1, #4
        movz x10, 0x2b, lsl 16
        movk x10, 0x3536, lsl 00
        BL pintar_circulo
    // letra c 
        mov x1, #3
        mov x2, #16 
        mov x3, #326
        mov x4, #146
        movz x10, 0xec, lsl 16
        movk x10, 0xd226, lsl 00
        BL pintar_rectangulo

        mov x1, #10
        mov x2, #3
        mov x3, #326
        mov x4, #146
        BL pintar_rectangulo
        mov x1, #10
        mov x2, #3
        mov x3, #326
        mov x4, #159
        BL pintar_rectangulo

/*-------*/

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

