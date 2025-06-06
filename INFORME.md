### Nombre y apellido 
- Integrante 1: Santiago Issetta | DNI: 46450747
- Integrante 2: Maximiliano Tomás Castelle | DNI: 43812258
- Integrante 3: Tomás Agustín Castro | DNI: 46033073
- Integrante 4: Fernando Agustín Lara | DNI: 44346500


### Descripción ejercicio 1: 
El programa pinta una imagen de una cancha de fútbol con un marcador, arboles y nubes de fondo, con funciones parametrizadas de rectangulo, circulo y otras funciones auxiliares en el archivo "funs.s". 


### Descripción ejercicio 2:
La animacion se realiza sobre las nubes moviendose infinitamente (cada una con su velocidad y tamaño), y sobre una pelota que, recien cuando entra al arco, aumenta el marcador local en 1.

### Justificación instrucciones ARMv8:
En el trabajo se requiere acceder a valores definidos en memoria mediante .dword, asociadas a etiquetas (por ejemplo nube1: .dword 95). Pero el conjunto de instrucciones LEGv8 no nos permitió cargar estos valores a registros directamente (se podría, pero el codigo se extendería muchisimo más). Tratamos de usar LDUR pero tuvimos que recurrir al uso de LDR es varias ocasiones ya que en la práctica es la forma mas directa para acceder a un valor definido con una etiqueta en .data. Esta instrucción permite cargar el valor a un registro desde una dirección simbólica sin necesidad de manejar las direcciones base. Por lo tanto, se justifica su uso como una excepción necesaria para poder acceder a datos en memoria de una forma 'llevadera' (dada la extensión de este programa)
