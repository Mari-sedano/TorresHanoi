.eqv Disk 3 # N�mero de discos

.text

main:
  addi s0, zero, Disk # Limite para el for por el n�mero de discos
  
  lui s1, 0x10010 # Direcci�n de inicio de la torre origen
  addi s5, zero, Disk
  addi t0, zero, Disk # N�mero de discos a 3 para el for de inicializaci�n
  addi s2, s1, 4 # Direcci�n de inicio de la torre auxiliar
  addi s3, s2, 4 # Direcci�n de inicio de la torre destino

  # Inicializar la torre origen con los valores de los discos
  addi t0, zero, Disk # N�mero de discos para el for de inicializaci�n
for:
  sw t0, 0(s1) # Almacena el valor del disco en la direcci�n de memoria
  addi s1, s1, 32 # Mueve al siguiente espacio de memoria
  addi t0, t0, -1 # Disminuye el valor del disco
  bne t0, zero, for # Repite hasta que todos los discos est�n en la torre origen

  jal towerOfHanoi
  jal endcode

towerOfHanoi:
  addi t0, zero, 1 # t0 para la comparaci�n para el caso base a 1
  beq s0, t0, case_base # Si el n�mero de discos es 1, salta al caso base

  # Guardar en el stack -> ra, s0, s1, s2, s3
  addi sp, sp, -4
  sw ra, 16(sp)
  addi sp, sp, -4
  sw s0, 12(sp)
  addi sp, sp, -4
  sw s1, 8(sp)
  addi sp, sp, -4
  sw s2, 4(sp)
  addi sp, sp, -4
  sw s3, 0(sp)

  # Mover N-1 discos de la torre origen a la torre auxiliar
  addi s0, s0, -1 # Disminuye el n�mero de discos
  add s4, s2, zero # Guarda temporalmente la direcci�n de la torre auxiliar
  add s2, s3, zero # swap: torre auxiliar a la torre destino
  add s3, s4, zero # swap: torre destino a la torre auxiliar
  jal towerOfHanoi # Llamada recursiva

  # Recuperar del stack -> ra, s0, s1, s2, s3
  lw s3, 0(sp)
  addi sp, sp, 4
  lw s2, 4(sp)
  addi sp, sp, 4
  lw s1, 8(sp)
  addi sp, sp, 4
  lw s0, 12(sp)
  addi sp, sp, 4
  lw ra, 16(sp)
  addi sp, sp, 4

  jal mov
endmov:
  # Recuperar del stack -> ra, s0, s1, s2, s3
  addi sp, sp, -4
  sw ra, 16(sp)
  addi sp, sp, -4
  sw s0, 12(sp)
  addi sp, sp, -4
  sw s1, 8(sp)
  addi sp, sp, -4
  sw s2, 4(sp)
  addi sp, sp, -4
  sw s3, 0(sp)

  # Mover N-1 discos de la torre auxiliar a la torre destino
  addi s0, s0, -1 # Disminuye el n�mero de discos
  add s4, s1, zero # Guarda temporalmente la direcci�n de la torre origen
  add s1, s3, zero # swap: torre origen a la torre destino
  add s3, s4, zero # swap: torre destino a la torre origen
  jal towerOfHanoi # Llamada recursiva

  # Recuperar del stack -> ra, s0, s1, s2, s3
  lw s3, 0(sp)
  addi sp, sp, 4
  lw s2, 4(sp)
  addi sp, sp, 4
  lw s1, 8(sp)
  addi sp, sp, 4
  lw s0, 12(sp)
  addi sp, sp, 4
  lw ra, 16(sp)
  addi sp, sp, 4
  jalr ra

case_base:
  addi s1, s1, -32
  lw t0, 0(s1)
  sw t0, 0(s3)
  addi s3, s3, 32
  addi t1, zero, 0
  sw t1, 0(s1)
  
  jalr ra

count_zeros:
  addi a3, zero, 0   # Inicializar el contador de ceros en a3
  addi t0, s1, 0     # Copiar la direcci�n de inicio de la torre de origen a t0

count_zeros_loop:
  lw t1, 0(t0)       # Cargar el valor en la direcci�n t0
  beqz t1, increment # Si el valor es cero, incrementar el contador de ceros
  addi t0, t0, 32    # Si no es cero, pasar al siguiente valor en la torre
  jal zero count_zeros_loop # Repetir el bucle

increment:
  addi a3, a3, 1     # Incrementar el contador de ceros
  addi t0, t0, 32    # Pasar al siguiente valor en la torre
  jal zero count_zeros_loop # Repetir el bucle

  lw ra, 0(sp)       # Restaurar el valor de retorno
  addi sp, sp, 4     # Ajustar el puntero de pila
  jalr ra            # Retornar de la subrutina

count_disk:
   sub a4, s0, a3
   jal zero, endcount

mov:
    jal count_disk  # Llama a la funci�n count_disk para contar los discos
endcount:
    sub t0, s5, a4    # Resta el n�mero de discos restantes (s0) y el n�mero de discos en la torre origen (a4), y guarda el resultado en t0
    slli t0, t0, 5   # Desplaza a la izquierda el valor en t0 por 5 bits (multiplica por 32), para obtener el desplazamiento en bytes
    add t0, s1, t0   # Suma el desplazamiento al inicio de la torre origen (s1), y guarda el resultado en t0
    lw t1, 0(t0)   # Carga el valor del disco en la direcci�n calculada (t0), y guarda el valor en t1
    sw zero, 0(t0)  # Escribe un cero en la posici�n del disco que se acaba de mover en la torre origen
    sw t1, 0(s3)  # Escribe el valor del disco en la cima de la torre destino (s3)
    jal zero, endmov      
    

endcode: nop
