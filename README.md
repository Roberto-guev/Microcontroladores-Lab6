# Microcontroladores-Lab6

Funcionamiento del programa:
El programa consta de un archivo Main.s, ivt.s, exti.s, delay.s, reset_handler.s, default_handler.s y el uso de los mapas de direcciones de memoria que forman parte del codigo. En la funcion main se inicializan los perifericos de nuestro microcontrolador de la siguiente manera: se activa el reloj del puerto A, se establece el pin 0, 1 del perto A como input para colocar los push buttoms de nuestro hardware a la blue-pill, se establecen los pin del 2 al 11 como output para conectar los 9 leds que integraran nuestro sistema. Se configuran los registros para leer las interrupciones externas y se les asignan los pines 0 y 1 para leer interrupciones. Tambien se almacenan las variables requeridas para el funcionamiento del programa, se establece un contador que nos permitira representar la cuenta del programa mediante los leds del hardware, esta variable se almacena en la pila del programa, se usa r5 para almacenar la variable que nos ayudara a modificar la velocidad con la cual opera el contador, este registro sera exclusivo para almacenar esta variable, por ultimo, se almacena la variable que nos ayudara a definir el sentido de la cuenta de nuestro programa (ascendente- descendente). Inmediatamente viene nuestro "Loop" en el cual se inicia verificando la variable del sentido del contador del sistema, si es par la cuenta del sistema sera creciente, de lo contrario sera decreciente, esta variable se modifica mediante una interrupcion en el sistema que se explicara mas adelante su funcionamiento. Ya antes establecida la suma o resta en la cuenta se procede a modificar el tiempo en el cual se efectua dicha suma, para eso se verifica la variable de velocidad de la cuenta mediante una estructura if else de 4 posiblws valores que puede tomar la variable y cambia entre las 4 velocidades que puede tomar el sistema.

Configuracion del reloj del sistema:
Para configurar el reloj del sistema se debe configurar el registro de control del reloj (Clock Control Register) para seleccionar la fuente de reloj deseada y establecer la velocidad de reloj, configurar los registros de división del reloj (Clock Divider Registers) para ajustar la frecuencia del reloj según sea necesario y habilitar el reloj del sistema y otros periféricos relacionados según tus necesidades utilizando los registros de habilitación del reloj (Clock Enable Registers), en este caso el puerto A.

Configuracion de las interrupciones del sistema:
Para configurar las interrupciones externas de nuestro microcontrolador se debe configurar el registro de máscara de interrupción (Interrupt Mask Register) para habilitar o deshabilitar las interrupciones externas específicas que deseas utilizar, configurar los registros de control de interrupción (Interrupt Control Registers) para establecer el tipo de interrupción (bordes de subida, bordes de bajada) y la prioridad de cada interrupción, tambien se deben implementar las rutinas que se ejecutaran en las interrupciones en el archivo ivt.s.

Subrutina exti_isr.s:
Esta subrutina esta implementada como una interrupcion externa del sistema conectada al pin 0 del puerto A, cuando se presiona el boton y se invoca a esta funcion se aumenta en 1 el registro r6 el cual almacena la variable de sentido del contador.

Subrutina delay.s:
Esta subrutina al igual que la anterior es una interrupcion externa del sistema y se invoca mediante el boton conectado al pin 1 del perto A, cuando se invoca esta funcion se aumenta en 1 el registro r5 el cual almacena la variable de velocidad del sistema, se le hace una operacion AND con 3 para mantener la variable en un ciclo de 4 posibles valores.



Diagrama del sistema: 
![image](https://github.com/Roberto-guev/Microcontroladores-Lab6/assets/124948069/3687fac2-1a37-42d1-9653-53de29916029)

