;---------------------------------------------------------------
;Generador de números pseudo-aleatorios
;Polinomio: X^4 + X^3 + 1
;LFSR
;---------------------------------------------------------------



    global      _start
    section     .text



_start:
       mov      rax, 0x100 ;Se situa en la posicion de memoria 0X100
       mov      rsi, 0xc000 ;Numero de iteraciones
       mov      r1, 0xc007D ;Letra en codigo ASCII -> Ver final
       mov      r2, 0xc00B ;Condicion de parada (11) 0x00B
       mov      r3, 0xc004 ;Offset de la posicion de memoria
       push     r1 ;Almacenar en memoria el valor semilla

_loop:
       inc      rsi ;Incrementa el numero de iteraciones
       cmp      rsi,r2
       jl       _xor_operations ;Si interacion < 100
       syscall
    
_shift_right:
    shl    r1,1 ;Shift Right, se desplaza una posicion 
    addi t0,t0,0x004 ;Offset de la posicion de memoria
    or     r1,rax ;Se le suma el resultado de las operaciones XOR
    push   r1 ;Almacenar en memoria
    jmp    loop
    
_xor_operations:
        mov     rax,r1
        and     rax,0xc0001 ;Mascara 00000 0001 (polinomio ) Calcula X^4
        mov     rcx,r1
        shr     rcx,1 ;Shift Right Calculando x^3
        and     rcx,0x0001 ;Mascara 00000 0001 (polinomio) Calcula X^3
        xor     rax,rcx     ;X^4 xor X^3
        shl     rax,3 ;Shift Left se coloca el bit del resultado de la XOR en el MSB

        jmp      _shift_right
    



; Use como semilla la primera letra de su primer nombre (G),
;G→71DEC→47H→0100 0111 B
;Los 4 bits LSB → 0111 B →0x0007 
    
