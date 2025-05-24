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
	//---------------- CODE HERE ------------------------------------

//Pintamos el fonde de celeste

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

//Pinto Arboles:

	mov x1, SCREEN_WIDTH
	mov x2, #192
	mov x3, #0
	mov x4, #166
	
	movz x10, 0x04, lsl 16
	movk x10, 0x1e1b, lsl 00

	BL pintar_rectangulo

//pinto pasto desde y=314 hacia abajo:

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
 
/* lineas de la cancha */
	mov x1, SCREEN_WIDTH
	mov x2,	#5
	mov x3,	#0
	mov x4,	#373
	movz x10, 0xf5, lsl 16
	movk x10, 0xf2ce, lsl 00

	BL pintar_rectangulo


	mov x1, #230
	mov x2, #5
	mov x3, #205
	movz x10, 0xac, lsl 16
	movk x10, 0xaa8d, lsl 00

	BL pintar_rectangulo



// arco

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

//area chica
	mov x1, #498
	mov x2, #5
	mov x3, #68
	mov x4, #556
	movz x10, 0xf5, lsl 16
	movk x10, 0xf2ce, lsl 00

	BL pintar_rectangulo



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

