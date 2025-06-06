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
		nube3:  .dword 39  // Nube 3 
		nube4:  .dword 282   // Nube 4
		nube5:  .dword 572   // Nube 5
		nube6:  .dword 506   // Nube 6
		nube7: .dword 10
		nube8: .dword 580
		delay_value_nubes: .dword 40000000 //delay para anmimacion nubes
		pelota_x: .dword 460
		pelota_y: .dword 560
		rebote_realizado: .dword 0
		gol: .dword 0 //valor que determina si el gol ya ocurrio (1)
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
	mov x2, #150
	mov x3, #0
	mov x4, #212
	
	movz x10, 0x04, lsl 16
	movk x10, 0x1e1b, lsl 00

	BL pintar_rectangulo

	mov x5, #50          // Posición inicial X
	mov x6, #212         // Posición Y fija
	mov x1, #60          // Radio del círculo
	mov x12, #6          // Contador para el bucle (6 árboles)

	loop_arboles_fila1:
	BL pintar_circulo
	add x5, x5, #110     // Incrementar posición X
	sub x12, x12, #1     // Decrementar contador
	cbnz x12, loop_arboles_fila1

	// Segunda fila de árboles
	mov x6, #180         // Nueva altura Y
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

 
/*--Red del arco--*/
movz x10, 0x00, lsl 16		//
		movk x10, 0x0000, lsl 00	// Le asigno el color negro a x10

		mov x9, #218		// uso el x9 como el eje x para las lineas verticales
		mov x11, #274		// uso el x11 como el eje y para las lineas horizontales
		mov x12, #22		// uso el x12 como contador para hacer el ciclo

		loop_red:
			mov x1, #1				// asigno el ancho 
			mov x2, #100			// asigno el alto
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

/*-FIN RED*/

//Pinto parte del tablero que
//no requiere repintado:
mov x1, #80
mov x2, #144
mov x3, #287
mov x4, #63
movz x10, 0x2b, lsl 16
movk x10, 0x3536, lsl 00
BL pintar_rectangulo

/*Pinto copa*/

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
/*Fin copa*/

mov x9, #0 
loop_animacion:
//ESTO BORRA LAS NUBES EN C/ITERACION:
	mov x1, SCREEN_WIDTH
	mov x2, #56
	mov x3, #0
	mov x4, #0
	movz x10, 0x83, lsl 16 // Elijo color
	movk x10, 0xb6c1, lsl 00
	BL pintar_rectangulo
	mov x1, #109
	mov x2, #80
	mov x3, #0
	mov x4, #63
	BL pintar_rectangulo
	mov x1, #117
	mov x3, #523
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

	sub sp, sp, 16
	stur x9, [sp, #0]
	stur x11, [sp, #8]
	//red
		
	ldur x11, [sp, #8]
	ldur x9, [sp, #0]
	add sp, sp, 16

/*---Nubes---*/
 
	movz x10, 0xff, lsl 16
	movk x10, 0xffff, lsl 00

  /*-Nube 2-*/
	mov x1, #30
	mov x2, #6
	LDR x3, nube2
	mov x4, #42
	BL pintar_nube
  /*-Nube 6-*/
	mov x1, #29
	mov x2, #7
	LDR x3, nube6
	
	mov x4, #34
	BL pintar_nube

  /*-Nube 1-*/
	mov x1, #63
	mov x2, #15
	LDR x3, nube1
	mov x4, #33
	BL pintar_nube

 /*-Nube 3-*/
	mov x1, #46
	mov x2, #6
	LDR x3, nube3
	mov x4, #89
	BL pintar_nube

  /*-Nube 4-*/
	mov x1, #48
	mov x2, #12
	LDR x3, nube4
	mov x4, #20
	BL pintar_nube

  /*-Nube 5-*/
	mov x1, #42
	mov x2, #12
	LDR x3, nube5
	mov x4, #20
	BL pintar_nube

  /*Nube 7 */
	LDR x3, nube7
	mov x4, #80
	BL pintar_nube

  /*Nube 8*/
	mov x1, #69
	mov x2, #17
	LDR x3, nube8
	mov x4, #90
	BL pintar_nube

	/*TABLERO*/
	ldr x0, gol
	BL pintar_tablero

	//pinto pequeño rectangulo del color del pasto p/eliminar trazo
	mov x1, #225
	mov x2, #9
	mov x3, #210
	mov x4,	#365
	movz x10, 0x91, lsl 16
	movk x10, 0xab49, lsl 00
	BL pintar_rectangulo
	/*-----*/
	
	/*--  pelota --*/
	ldr x5, pelota_x
	ldr x6, pelota_y
	ldr x7, rebote_realizado
	cmp x7, 1 
	b.eq skip_rebote
	BL pintar_pelota
	ldr x0, =pelota_x
	ldr x1, =pelota_y
	mov x8, #3
	ldr x2, =rebote_realizado
	BL trayectoria_rebote
	b skip_marcador
	
skip_rebote:
	cmp x6, #369
	b.le marcador1
	BL pintar_pelota
	ldr x0, =pelota_x
	ldr x1, =pelota_y
	mov x8, #3
	BL trayectoria_gol
	b skip_marcador
	//codigo para el marcador
	//Borro el 0
marcador1:
	LDR X0, =gol      // Cargar dirección de 'gol' en X0
    MOV X1, #1        // Valor que queremos guardar
    STUR X1, [X0, #0] // Guardar 1 en la dirección 'gol'
	mov x1, #66
	mov x2, #66
	mov x3, #180
	mov x4, #130
	movz x10, 0x2b, lsl 16
	movk x10, 0x3536, lsl 00
	BL pintar_rectangulo
	// Pinto el 1
	// Rectangulo vertical del 1
		mov x1, #12
		mov x2, #50
		mov x3, #195
		mov x4, #138
		movz x10, 0xde, lsl 16
		movk x10, 0xd3bc, lsl 00
		BL pintar_rectangulo
	BL pintar_pelota //pinto posicion final

skip_marcador:
	ldr x7, delay_value_nubes
	BL delay
 
	//Incrementar pos x de c/nube:
	ldr x0, =nube1
	mov x8, #2
	bl incrementar_posX
	ldr x0, =nube4
	bl incrementar_posX
	ldr x0, =nube5
	bl incrementar_posX
	ldr x0, =nube7
	bl incrementar_posX
	ldr x0, =nube2
	mov x8, #1
	bl incrementar_posX
	ldr x0, =nube6
	bl incrementar_posX
	ldr x0, =nube8
	bl incrementar_posX
	mov x8, #3
	ldr x0, =nube3 
	bl incrementar_posX

b loop_animacion


