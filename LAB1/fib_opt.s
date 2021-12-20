.data 
    numbers: .zero 40     # allocate 40 bytes
    
.text
     auipc a3 0x10000       # load address
     
     li x11,1               # initialize useful registers
     li x10,0
     addi a4,a3,36
     
     sw x11, 0(a3)
         
proc:                       # algorithm
     add x11,x11,x10
     sub x10,x11,x10
     
     addi a3,a3,4           # increment adress 
     sw x11, 0(a3)          # store result
               
     bne a3,a4,proc         # check for completion
    
end:                     # exit your program with this sequence
    li a7, 10            # sets register a7 (x17) to 10
    ecall                # system call: exit the program with code 0
