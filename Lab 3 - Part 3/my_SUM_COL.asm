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
; ; for(int i = 0; i < n; i++){for(int j = 0; j < n; j++){sum += (-1)^(i+j)*mat[j][i];}}
        ; we define r15 as our outer loop iterator - i and set it to zero
        mov qword r15, 0x0    
        mov qword r10, 0x0                    ; this is where we store our sum 

outer:
        mov qword r14, 0x0                    ; sets our inner loop iterator to zero
inner:
        ; here we define the logic for mat3 updation
        ; we first create the relevant addresses of insertion in r10,r11 and r12
        ; first create the shift and scale (r9*j+i)*8
        mov r13, r15                   ; copy in i
        mov rax, r14                   ; copy j into rax
        imul rax, rdx                  ; multiply by rdx which is n
        add r13, rax                   ; add rax into r13 which basically gives us (rdx*j+i)
        shl r13, 3                     ; multiply by 8 and we have our offset

        mov r11, rdi                   ; address of mat
        add r11, r13

        ; this is the core computation sum += (-1)^(i+j)*mat[j][i]; which we want to store in r10 and then rax ultimately
        mov qword r13, [r11]           ; copies in the value of mat[j][i] into r13

        mov qword r8, r14              ; moves in j
        add r8, r15                    ; adds i so we now have i+j
        and r8, 1                      ; take its and with 1 so that we get the lsb which determines the value mod 2
        ; now we make an if case on where i+j is odd or even
        cmp r8, 1                      ; if r8 is odd, we will subtract
        je take_sub
        ; otherwise we add in the case it was it was even
        jmp take_add

take_sub:
        sub r10, r13           ; subtracts the value of mat[j][i]
        jmp next

take_add:
        add r10, r13           ; adds the alue of mat[j][i]

next:
        ; now update inner loop variable that is j -> j+1 - r14
        add r14, 1

        cmp r14, rdx                    ; if j < n then we continue the inner loop other wise we fall back into the outer loop
        jl inner

        ; now update the outer loop variable that is i
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
