        section .text
        global lin_comb

lin_comb:
        push rdi                       ; pointer to mat1
        push rsi                       ; scaler 1
        push rdx                       ; pointer to mat2
        push rcx                       ; scaler 2
        push r8                        ; pointer to mat3
        push r9                        ; number of rows/ columns of the matrix (n)
        push r11
        push r12

; ; 0-indexing on all matrices
; ; mat1[j][i] = rdi+(r9*j+i)*8
; ; GOAL - Perform matrix linear combination of mat1, mat2 and save result in mat3
; ; Note : mat1, mat2 and mat3 here are not the same as one given in problem statement.
; ; They are just placeholders for any three matrices using this functionality.

; ; TODO - Fill your code here performing the matrix linear combination in the following order
; ; for(int i = 0; i < n; i++){for(int j = 0; j < n; j++){mat3[i][j] = s1*mat1[i][j] + s2*mat2[i][j];}}

        ; we define r15 as our outer loop iterator - i and set it to zero
        mov qword r15, 0x0             ; this is our variable i
        mov r10, r8                    ; address of mat3
        mov r11, rdi                   ; address of mat1
        mov r12, rdx                   ; address of mat2

outer:
        mov qword r14, 0x0                   ; sets our inner loop iterator to zero
inner:
        ; here we define the logic for mat3 updation

        mov qword r13, rsi             ; copies in the value of rsi - s1 into r13
        imul r13, [r11]                ; gets the value s1*mat1[i][j] in r13
        mov qword [r10], r13           ; starts generating the addition in r10

        mov qword r13, rcx             ; copies in the value of rcx - s2 into r13
        imul r13, [r12]                ; gets the value s2*mat2[i][j]
        add [r10], r13                 ; adds this value into the address of mat3

        ; now update inner loop variable that is j -> j+1 - r14
        add r14, 1

        ; update the addresses 
        add r10, 8
        add r11, 8
        add r12, 8

        cmp r14, r9                    ; if j < n then we continue the inner loop other wise we fall back into the outer loop
        jl inner

        ; now update the outer loop variable that is i -> i+1
        add r15, 1
        
        cmp r15, r9
        jl outer                       ; if i < n then we continue to loop otherwise obviously exit

; ; End of code to be filled
        pop r12
        pop r11
        pop r9
        pop r8
        pop rcx
        pop rdx
        pop rsi
        pop rdi
        ret
