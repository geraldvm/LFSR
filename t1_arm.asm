main:
    #Generador de números pseudo-aleatorios
    #Polinomio: X^4 + X^3 + 1
    #LFSR
    jal start

start:
    mov     r1, 0x100 #Se situa en la posicion de memoria 0X100
    ldr     r2,[r1]   #Carga la posicion
    li a0, 0x000 #Numero de iteraciones
    li a1, 0x007  #Letra en codigo ASCII
    li a2, 0x00B #Condicion de parada (11) 0x00B
    li a3, 0x004 #Offset de la posicion de memoria
    sw a1,0,r1 #Almacenar en memoria el valor semilla
    jal loop
    
shift_right:
    srli a1,a1,0x001 #Shift Right, se desplaza una posicion 
    addi r1,r1,0x004 #Offset de la posicion de memoria
    or a1,a1,a5 #Se le suma el resultado de las operaciones XOR
    sb a1,0,r1 #Almacenar en memoria
    jal loop
    
xor_operations:
    andi a4,a1,0x0001 #Mascara 00000 0001 (polinomio ) Calcula X^4
    srli a5,a1,0x001 #Shift Right Calculando x^3
    andi a5,a5,0x0001 #Mascara 00000 0001 (polinomio) Calcula X^3
    xor a4,a4,a5     #X^4 xor X^3
    slli a5,a4,0x003 #Shift Left se coloca el bit del resultado de la XOR en el MSB
    jal shift_right
    
loop:
    addi a0,a0,0x001 #Incrementa el numero de iteraciones
    blt a0,a2,xor_operations #Si interacion < 100
    jal end

end:
    ecall
    


# Use como semilla la primera letra de su primer nombre (G),
#G→71DEC→47H→0100 0111 B
#Los 4 bits LSB → 0111 B →0x0007 
    
