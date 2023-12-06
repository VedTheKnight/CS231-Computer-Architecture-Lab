        section .text
        global  alt_sum

alt_sum:
        push rdi                       ; pointer to mat
        push rdx                       ; number of rows/ columns of the matrix (n)
        push r11
        push r12

; ; 0-indexing on all matrices
; ; mat1[j][i] = rdi+(r9*j+i)*8
; ; GOAL - Perform matrix alternate summation of elements in matrix and return the sum

; ; TODO - Fill your code here performing the matrix alternate summation in the following order
; ; for(int i = 0; i < n; i++){for(int j = 0; j < n; j++){sum += (-1)^(i+j)*mat1[i][j];}}
         
        mov qword r15, 0x0             ; we define r15 as our outer loop iterator - i and set it to zero
        mov r11, rdi                   ; address of mat
        mov qword r10, 0x0

outer:
        mov qword r14, 0x0             ; sets our inner loop iterator to zero
inner:
        ; here we define the logic for mat3 updation
        mov qword r13, [r11]           ; copies in the value of mat[i][j] into r13

        mov qword r8, r14              ; moves in j
        add r8, r15                    ; adds i so we now have i+j
        and r8, 1                      ; take its 'and' with 1 so that we get the lsb which determines the value mod 2
        
        ; now we make an if case on where i+j is odd or even
        cmp r8, 1                      ; if r8 is odd, we will subtract
        je take_sub
        ; otherwise we add in the case it was it was even
        jmp take_add

take_sub:
        sub r10, r13           ; subtracts the value of mat[i][j]
        jmp next

take_add:
        add r10, r13           ; adds the value of mat[i][j]

next:
        
        ; now update inner loop variable that is j -> j+1 -- r14
        add r14, 1
        ; update the address
        add r11, 8


        cmp r14, rdx                    ; if j < n then we continue the inner loop other wise we fall back into the outer loop
        jl inner

        ; now update the outer loop variable that is i -> i+1
        add r15, 1
        
        cmp r15, rdx
        jl outer                       ; if i < n then we continue to loop otherwise obviously exit

        mov qword rax, r10
; ; End of code to be filled
        pop r12
        pop r11
        pop rdx
        pop rdi
        ret
