        section .text
        global hadarmard_prod

hadarmard_prod:
        push rdi                       ; pointer to mat1
        push rdx                       ; pointer to mat2
        push r8                        ; pointer to mat3
        push r9                        ; number of rows/ columns of the matrix (n)
        push r11
        push r12

; ; 0-indexing on all matrices
; ; mat1[j][i] = rdi+(r9*j+i)*8
; ; GOAL - Compute hadarmard product of of mat1, mat2 and save the result in mat3
; ; Note : mat1, mat2 and mat3 here are not the same as one given in problem statement.
; ; They are just placeholders for any three matrices using this functionality.

; ; TODO - Fill your code here performing the hadarmard product in the following order
; ; for(int i = 0; i < n; i++){for(int j = 0; j < n; j++){mat3[j][i] = mat1[j][i] * mat2[j][i];}}
        ; we define r15 as our outer loop iterator - i and set it to zero
        mov qword r15, 0x0             

outer:
        mov qword r14, 0x0                    ; sets our inner loop iterator to zero
inner:
        ; here we define the logic for mat3 updation
        ; we first create the relevant addresses of insertion in r10,r11 and r12
        ; first create the shift and scale (r9*j+i)*8
        mov r13, r15                   ; copy in i
        mov rax, r14                   ; copy j into rax
        imul rax, r9                   ; multiply by r9 which is n
        add r13, rax                   ; add rax into r13 which basically gives us (r9*j+i)
        shl r13, 3                     ; multiply by 8 and we have our offset

        mov r10, r8                    ; address of mat3
        add r10,r13

        mov r11, rdi                   ; address of mat1
        add r11,r13

        mov r12, rdx                   ; address of mat2
        add r12,r13

        ; this is the main computation
        mov qword r13, [r11]           ; copies in the value of mat1[j][i] into r13
        imul r13, [r12]                ; multiplies with the value mat2[j][i]
        mov qword [r10], r13           ; copies this value into the address of mat3

        ; now update inner loop variable that is j -> j+1 - r14
        add r14, 1

        cmp r14, r9                    ; if j < n then we continue the inner loop other wise we fall back into the outer loop
        jl inner

        ; now update the outer loop variable that is i
        add r15, 1
        
        cmp r15, r9
        jl outer                       ; if i < n then we continue to loop otherwise obviously exit
        
; ; End of code to be filled
        pop r12
        pop r11
        pop r9
        pop r8
        pop rdx
        pop rdi
        ret
