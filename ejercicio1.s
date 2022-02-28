main:
    #Generador de números pseudo-aleatorios
    #LFSR
    jal start

start:
    li t0, 0x100 #Se situa en la posicion de memoria 0X100
    li a0, 0x000 #Numero de iteraciones
    li a1, 0x04D #Letra M en codigo ASCII
    li a2, 0x065 #Condicion de parada (101) 0x065
    li a3, 0x004 #Offset de la posicion de memoria
    sw a1,0,t0 #Almacenar en memoria el valor semilla
    jal loop
    
shift_right:
    srli a1,a1,0x001 #Shift Right, se desplaza una posicion 
    addi t0,t0,0x004 #Offset de la posicion de memoria
    or a1,a1,a5 #Se le suma el resultado de las operaciones XOR
    sb a1,0,t0 #Almacenar en memoria
    jal loop
    
xor_operations:
    andi a4,a1,0x0001 #Mascara 00000 0001 (polinomio ) Calcula X^8
    srli a5,a1,0x002 #Shift Right Calculando x^6
    andi a5,a5,0x0001 #Mascara 00000 0001 (polinomio) Calcula X^6
    xor a4,a4,a5     #X^8 + X^6
    srli a5,a1,0x003 #Shift Right Calculando x^5
    andi a5,a5,0x0001 #Mascara 00000 0001 (polinomio) Calcula X^5
    xor a4,a4,a5     #X^8 + X^6 + X^5
    srli a5,a1,0x004 #Shift Right Calculando x^4
    andi a5,a5,0x0001 #Mascara 00000 0001 (polinomio) Calcula X^4
    xor a4,a4,a5     #a4= X^8 + X^6 + X^5 + X^4
    slli a5,a4,0x007 #Shift Left se coloca el bit del resultado de la XOR en el MSB
    jal shift_right
    
loop:
    addi a0,a0,0x001 #Incrementa el numero de iteraciones
    blt a0,a2,xor_operations #Si interacion < 100
    jal end

end:
    ecall
    