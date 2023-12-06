.data
newline: .asciiz "\n"

.text
main:
    #inputs n -- number of element and stores it in $s1
    li $v0,5
    syscall
    move $s1,$v0

    li $v0, 9
    sll $s1,$s1,2
    move $a0, $s1
    srl $s1,$s1,2
    syscall          # Dynamically allocating memory of size 4n bytes
    move $s0,$v0

    li $v0, 9
    sll $s1,$s1,2
    move $a0, $s1
    srl $s1,$s1,2
    syscall          # Dynamically allocating memory of size 4n bytes
    move $s4,$v0     # declare a new array of size 4n which will be useful to us in mergesort

    li $t0,0 #define the iterator
input_N:
    beq $t0,$s1,next #if t0==n then we are done inputing N
    mul $t1,$t0,4 #word size is 4 bytes
    add $t1,$t1,$s0 #t1 = t1 + s0 shift the base address by the necessary amount
    li $v0, 5         
    syscall  #syscall to input the element
    sw $v0,($t1) #stores the input number into the array
    addi $t0,$t0,1 #updates the iterator
    j input_N #continues the loop

next:
    #inputs q -- number of element and stores it in $s3
    li $v0,5
    syscall
    move $s3,$v0 

    li $v0, 9
    sll $s3,$s3,2
    move $a0, $s3
    srl $s3,$s3,2
    syscall     # Dynamically allocating memory of size 4q bytes
    move $s2,$v0

    li $t0,0 #define the iterator
input_Q:
    beq $t0,$s3,logic #if t0==q then we are done inputing Q
    mul $t1,$t0,4 #word size is 4 bytes
    add $t1,$t1,$s2 #t1 = t1 + s2 shift the base address by the necessary amount
    li $v0, 5         
    syscall  #syscall to input the element
    sw $v0,($t1) #stores the input number into the array
    addi $t0,$t0,1 #updates the iterator
    j input_Q #continues the loop

logic:
    #s0 contains array N , $s1 contains n, $s2 contains Q, $s3 contains q, $s4 contains temporary array
    #now we proceed to sort the array N using Merge Sort algorithm

    #we use four arguments, the left index, right index and the mid index
    #store these in a1,a2,a3 respectively
    li $a1,0        #left index into a1
    sub $a2,$s1,1   #right index into a2
    jal mergesort

    #now we do the final part where we have to run the queries
    li $t0,0 #this is our iterator for the query array - $s2
    jal runqueries

    li $v0, 10             
    syscall                # exit system call

runqueries:
    beq $s3,$t0,queriesdone   #if iterator==q, queries over so we return to the main logic block
    #perform binary search on the query, print its index if found and -1 if not found
    li $t1,0       #left index
    sub $t2,$s1,1  #right index = n-1
    #load the target into t7
    mul $t7,$t0,4   #word size is 4
    add $t7,$t7,$s2 #finds the memory location of target in queries array
    lw $t6,($t7)    #loads the value into temporary register t6 -- this is the target

binarysearch:
    blt $t2,$t1,notfound #if right<left at any point it implies that the element is not inside the array so we print -1
    #else we have 3 cases

    #first create mid 
    add $t3,$t1,$t2   #mid = left + right
    sra $t3,$t3,1     #mid = left + right/2

    #get the value of the middle index in the Numbers Array
    mul $t4,$t3,4   #word size is 4
    add $t4,$t4,$s0 #finds the memory location of mid in the N array
    lw $t5,($t4)    #loads the value into temporary register t4 -- this is the middle element

    #case 1 N[mid]==target
    beq $t5,$t6,found  #if the target found jump to print

    #case 2 N[mid] > target, we put right = mid-1 and run the algorithm again
    bgt $t5,$t6,leftsub   #do binary search on the left subpart

    #else do binary search on the right subpart
    addi $t1,$t3,1
    j binarysearch

leftsub:
    addi $t2,$t3,-1   #right = mid-1
    j binarysearch

found:
    li $v0,1
    move $a0,$t3     # this is the "mid" location at which the target was found so we print it
    syscall        # system call prints number of integers less than it in N

    li $v0,4
    la $a0,newline
    syscall        # system call prints newline string

    addi $t0,$t0,1 #increment $t0 by 1
    j runqueries   #jumps to the next query

notfound:
    li $v0,1
    li $a0,-1
    syscall        # system call prints -1

    li $v0,4
    la $a0,newline
    syscall        # system call prints newline string

    addi $t0,$t0,1 #increment $t0 by 1
    j runqueries   #jumps to the next query

queriesdone:
    jr $ra

mergesort:
    #base case
    bge $a1,$a2,return      #if left index>= right index we jump to return
    #otherwise we proceed to the core logic
    sub $sp,$sp,16          # allocates space on the stack for our parameters	
	sw $ra,($sp)	        # stores return address
	sw $a1,4($sp)        	# stores left index
    sw $a2,8($sp)           # stores right index
    #generation of the middle index and storing its value on the stack
    add $a3,$a1,$a2 
    sra $a3,$a3,1  # create the middle element in a3 left+right/2
    sw $a3,12($sp) # stores mid on the stack since it will get overwritten in recursive calls
    #mergesort on the left sub-array
    move $a2,$a3    # make the right = mid for the left sub array and then merge sort the left sub-array
    jal mergesort
    #mergesort on the right sub-array
    lw $a3,12($sp)   # load the value for mid that was stored in the stack because we overwrite it during recursive calls
    addi $a1,$a3,1   # make the left = mid+1 
    lw $a2,8($sp)    # reload the right child from the stack since we overwrote it earlier
    jal mergesort    #now merge sort the right subarray
    #now load all values that we stored on the stack and go to merge -- which merges the two arrays into a temporary array and then copies it into the original
    #left, right and mid are the arguments for the merge function
    lw $a1,4($sp)
    lw $a2,8($sp)
    lw $a3,12($sp)
    jal merge
    #get the return address, clear the stack and return to the caller
    lw $ra,($sp)	#get the return address 
    addi $sp,$sp,16 #pop all the values off the stack
    jr $ra          #return to the caller

return:
    jr $ra          #this is the case where we have single element so we don't have to do anything

merge:
    move $t0,$a1  	        # initial element of the left sub-array --i
	addi $t1,$a3,1  	    # initial element of the right sub-array --j = mid + 1
    move $t2,$a1	        # counter initialized at a1 = left of left sub-array -- x
    li $s6,0                # index in the temporary array where we insert 
    move $s7,$a1            # need a temporary copy of the original left index which we don't alter until the end. We use this for copying

mainloop:
    blt $a2,$t2,copy        # x>right - completely merged so we are done , now we can copy
    blt $a3,$t0,rightinsert # i>mid left subarray complete, right pending jump to that case
    blt $a2,$t1,leftinsert  # j>right, right subarray is complete, left pending jump to that case

    #otherwise both are in bounds so we proceed by comparing both values and storing the lower one into the temporary array
    #retrieve the values from the original array
    sll $t3,$t0,2	# $t3 = i*4
    add $t3,$t3,$s0 # adds a shift to the base address of N
    lw  $t4,($t3)   # loads the value into temporary register

    sll $t5,$t1,2	# $t5 = j*4
    add $t5,$t5,$s0 # adds a shift to the base address of N
    lw  $t6,($t5)   # loads the value into temporary register -- same as above

    #we compare the values and store smaller one into the temporary array, increment the appropriate pointers and continue to iterate
    blt $t4,$t6,leftsmaller #if the value in left subarray is smaller we jump to leftsmaller

    #otherwise right i.e. t6 is smaller
    #use a temporary register for address arithmetic with s6
    sll $t7,$s6,2   # store 4xs6 into t7
    add $t7,$t7,$s4 # find the required location in the temporary array
    sw $t6,($t7)	# store the smaller of the two values ie t6 into the memory location

    addi $t1,$t1,1  #increment j
    addi $s6,$s6,1  #increment s6 -- pointer to temporary array
    addi $t2,$t2,1  #increment x  -- counter

    j mainloop

leftsmaller: 
    #here left i.e. t4 is smaller
    #use a temporary register for address arithmetic with s6
    sll $t7,$s6,2   # store 4xs6 into t6
    add $t7,$t7,$s4 # find the required location in the temporary array
    sw $t4,($t7)	# store the smaller of the two values ie t4 into the memory location

    addi $t0,$t0,1  # increment i
    addi $s6,$s6,1  # increment s6 -- pointer to temporary array
    addi $t2,$t2,1  # increment x
    j mainloop

rightinsert:
    #we come here if the left subarray is completed and only elements in the right subarray are left
    sll $t3,$t1,2	# $t3 = j*4
    add $t3,$t3,$s0 # adds a shift to the base address of N
    lw  $t4,($t3)   # loads the value into temporary register t4 

    sll $t5,$s6,2   # stores 4xs6 into t5
    add $t5,$t5,$s4 # find the required location in the temporary array
    sw $t4,($t5)    # stores the value from t4 into the address in the temporary array

    addi $t1,$t1,1  # increment j
    addi $s6,$s6,1  # increment s6 -- pointer to temporary array
    addi $t2,$t2,1  # increment x

    j mainloop

leftinsert:
    #we come here if the right subarray is completed and only elements in the left subarray are left
    sll $t3,$t0,2	# $t3 = i*4
    add $t3,$t3,$s0 # adds a shift to the base address of N
    lw  $t4,($t3)   # loads the value into temporary register t4 

    sll $t5,$s6,2   # stores 4xs6 into t5
    add $t5,$t5,$s4 # find the required location in the temporary array
    sw $t4,($t5)    # stores the value from t4 into the address in the temporary array

    addi $t0,$t0,1  #increment i
    addi $s6,$s6,1  #increment s6 -- pointer to temporary array
    addi $t2,$t2,1  #increment x
    j mainloop

copy:
    li $s6,0             # resets the iterator of the temporary array to initial index
copy_loop:
    bgt $s7,$a2,exit     # if iterator is bigger than the rightmost value, we are fully copied so we exit

    #load the value stored at s6 index in temporary array
    sll $t3,$s6,2	# $t3 = s6*4
    add $t3,$t3,$s4 # adds a shift to the base address of temporary array
    lw  $t4,($t3)   # loads the value into temporary register t4

    #loads the value into the corresponding index in the original array
    sll $t5,$s7,2   # stores 4xs7 into t5
    add $t5,$t5,$s0 # find the required location in the original array
    sw $t4,($t5)    # stores the value from t4 into the address in the original array

    #increment the iterators for the temporary array
    addi $s7,$s7,1
    addi $s6,$s6,1
    j copy_loop

exit:
    jr $ra

