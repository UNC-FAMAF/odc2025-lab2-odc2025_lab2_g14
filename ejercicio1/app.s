	.equ SCREEN_WIDTH, 		640
	.equ SCREEN_HEIGH, 		480
	.equ BITS_PER_PIXEL,  	32

	.equ GPIO_BASE,      0x3f200000
	.equ GPIO_GPFSEL0,   0x00
	.equ GPIO_GPLEV0,    0x34

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
 	mov x20, x0	// Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------

	movz x10, 0xff, lsl 16 // ff 0000
	movk x10, 0xff00, lsl 00 //  Termino de elejir color amarillo ff ff00

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


	add x0, xzr, x20 // Reinicio el FrameBuffer
	movz x10, 0xff, lsl 00 // Elijo color azul 00 00ff

	mov x2, SCREEN_HEIGH         // Y Size
	mov x1, SCREEN_WIDTH         // X Size

	//Voy a intentar dibujar un cuadrado en el medio de la pantalla
	//Tamaño del cuadrado
	mov x13, #100 
	mov x14, #100

	//Esquina izquierda del cuadrado (cord1, cord2)
	sub x15, x1, x13
	lsr x15, x15, #1 // cord1 = (SCREEN_WIDTH - 100 ) / 2

	sub x16, x2, x14
	lsr x16, x16, #1 // cord2 = (SCREEN_HEIGH - 100 ) / 2


	// y loop (desde cord1 hasta cord1+100)
	mov x17, #0          // y_offset = 0

loop_cuadrado_y:
	cmp x17, x14
	b.ge end_cuadrado

	// calcular fila actual
	add x18, x16, x17                // y = cord1 + y_offset
	mov x24, SCREEN_WIDTH      // x24 = 640
	mul x19, x18, x24       // y * SCREEN_WIDTH

	// x loop (desde cx hasta cx+100)
	mov x20, #0          // x_offset = 0
loop_cuadrado_x:
	cmp x20, x13
	b.ge next_row

	add x21, x15, x20                // x = cord2 + x_offset
	add x22, x19, x21                // offset en píxeles = y * WIDTH + x
	lsl x22, x22, #2                 // offset en bytes = *4

	add x23, x0, x22                 // dirección absoluta del píxel
	str w10, [x23]                   // escribir color

	add x20, x20, #1
	b loop_cuadrado_x

next_row:
	add x17, x17, #1
	b loop_cuadrado_y

end_cuadrado:


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
