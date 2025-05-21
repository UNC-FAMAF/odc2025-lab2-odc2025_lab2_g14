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
