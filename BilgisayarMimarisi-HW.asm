.data

zincir: .asciiz "ATGATGATGCTCGCGCTAGCCGTCGTAAACTATTTACGAATACTACTACG" # 1 ve 5 uyumlu

# deneme zincirleri
zincir2: .asciiz "ATGATGATGCTCGCGCTAGCCGTCGTAAACTATTTACGAATACTACCATG" # Uyumlu Yok
zincir3: .asciiz "ATGATGATGCTCGCGCTAGCAGCGCGATCGATATATGACGTACTACTACC" # 2 ve 3 uyumlu
zincir4: .asciiz "ATGATGATGCTCGCGCTAGCCGTCGTAAACGCAGCATTTGTAGTAGTACG" # 3 ve 4 uyumlu

a: .asciiz "A"
t: .asciiz "T"
g: .asciiz "G"
c: .asciiz "C"

.text
.globl main

main:   
    la $t0, zincir  # t0 zincirin başlangıç adresini tutar
    la $t1, a       # t1 A karakterinin adresini tutar
    la $t2, t       # t2 T karakterinin adresini tutar
    la $t3, g       # t3 G karakterinin adresini tutar
    la $t4, c       # t4 C karakterinin adresini tutar
    lb $t1, ($t1)   # t1 A karakterinin ascii karşılığını tutar
    lb $t2, ($t2)   # t2 T karakterinin ascii karşılığını tutar
    lb $t3, ($t3)   # t3 G karakterinin ascii karşılığını tutar
    lb $t4, ($t4)   # t4 C karakterinin ascii karşılığını tutar
    li $t5, 50      # t5 = 50 Döngü Bitme Kuralı
    li $t6, 0       # i = 0
    li $t7, 0       # j = 0
    li $t8, 0       # t = 0
    li $t9, 10      # t9 = 10 Döngü Bitme Kuralı
    li $a3, 9       # a3 = 9 Zincir uyumluluğu kontrol kuralı
    li $s5, 0       # bulundu
    li $s6, 0       # register1
    li $s7, 0       # register2
    li $s3, 0       # Zincirdeki bir elemanın (zincir[i + t]) adresini tutacak
    li $s4, 0       # Zincirdeki bir elemanın (zincir[i + t]) adresini tutacak

        
loop1:  
    beq $t6, $t5,endloop1   # while(i != 50)
    addi $t7,$t6,10         # j = i + 10
loop2:
    beq $t7, $t5, endloop2  # while(j != 50)
    li $t8, 0               # t = 0
loop3:
    beq $t8, $t9,endloop3   # while(t != 10)
    add $s3,$t6,$t8         # s3 = i + t    
    add $s3,$t0,$s3         # s3 = zincir[i + t] adresi
    add $s4, $t7, $t8       # s4 = j + t  
    add $s4,$t0,$s4         # s4 = zincir[j + t] adresi
    lb $s1, ($s3)           # s1 = zincir[i + t] (Karakterin ascii karşılığı)
    beq $s1, $t1, if        # if(s1 == "A") if'e git
    beq $s1, $t2, if3       # if(s1 == "T") if3'e git
    beq $s1, $t3, if5       # if(s1 == "G") if5'e git
    beq $s1, $t4, if7       # if(s1 == "C") if7'e git
endloop3:
    addi $t7,$t7,10         # j = j + 10
    j loop2
endloop2:
    addi $t6,$t6,10         # i = i + 10
    j loop1
endloop1:
    beq $s5,$zero, if10     # if(s5 == 0) ise if10'a git
    j end                   # else programı sonlandır

if:                         # zincir[i + t] == "A" 
    lb $s2, ($s4)           # s2 = zincir[j + t] (Karakterin ascii karşılığı)
    bne $s2, $t2, if2       # if(s2 != "T") if'2 ye git
    beq $t8, $a3, if9       # if(t == 9) zincir[i] ve zincir[j] uyumlu if9'a git
    addi $t8,$t8,1          # t = t + 1
    j loop3                 
if2:                        # zincir[i + t] == "A" ve zincir[j + t] != "T"
    addi $t7, $t7, 10       # j = j + 10
    j loop2                 # break i. ve j. zincirler uyumlu değil i ve j+1 e geç
                
if3:                        # zincir[i + t] == "T" 
    lb $s2, ($s4)
    bne $s2, $t1, if4
    beq $t8, $a3, if9       # if(t == 9) zincir[i] ve zincir[j] uyumlu if9'a git
    addi $t8,$t8,1
    j loop3
if4:                        # zincir[i + t] == "T" ve zincir[j + t] != "A"
    addi $t7, $t7, 10
    j loop2

if5:                        # zincir[i + t] == "G" 
    lb $s2, ($s4)
    bne $s2, $t4, if6
    beq $t8, $a3, if9       # if(t == 9) zincir[i] ve zincir[j] uyumlu if9'a git
    addi $t8,$t8,1
    j loop3
if6:                        # zincir[i + t] == "G" ve zincir[j + t] != "C"
    addi $t7, $t7, 10
    j loop2

if7:                        # zincir[i + t] == "C" 
    lb $s2, ($s4)
    bne $s2, $t3, if8
    beq $t8, $a3, if9       # if(t == 9) zincir[i] ve zincir[j] uyumlu if9'a git
    addi $t8,$t8,1
    j loop3
if8:                        # zincir[i + t] == "C" ve zincir[j + t] != "G"
    addi $t7, $t7, 10
    j loop2

if9:                        # Uyumlu Zincirler Var
    div $t6, $t9            # low = i / 10 (Bölüm)
    mflo $s6                # s6 = low register
    addi $s6, $s6, 1        # s6 = s6 + 1 (s6 = zincir idsi)
    div $t7, $t9            # lo = j / 10 (Bölüm)
    mflo $s7                # s7 = low register
    addi $s7, $s7, 1        # s7 = s7 + 1 (s7 = zincir idsi)
    addi $s5,$s5,1          # bulundu++
    addi $t8,$t8,1          # t++
    j loop3

if10:                       # Uyumlu Zincirler Yok
    li $s6,0                # s6 = 0
    li $s7,0                # s6 = 0
    j end                   # programı bitir

end: 
    li $v0, 10
    syscall
