.text
.globl main
main:
        li $t0, 10 # t0 = 10 numbre of iterations
        li $t1, 0 # t1 = counter(i)
        li $t2, 17 # value
loop:
        beq $t1, $t0, end
        add $t2, $t2, $t1
        addi $t1, $t1, 1
        j loop
end:
        li $v0, 10
        syscall
