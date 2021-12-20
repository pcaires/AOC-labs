.data 
    numbers: .zero 40     # allocate 40 bytes
    
.text
      li x10, 1       #Initialize registers
      li x11, 1
      
      la a3, numbers  #Get adress to start and end of allocation
      addi a4, a3, 32
      
      sw x11, 0(a3)   #Store first Fibonacci number
      
loop: 
      addi a3, a3, 4 #Step by 4
      sw x11, 0(a3)  #Store fibonnacci number
      
      mv x12, x11
      add x11, x11, x10 #Obtain next number to store
      mv x10,x12
      
      bgt a4,a3,loop #Check for completion
      
      sw x11, 4(a3) #Save last Fibonacci number
    
end:                     # exit your program with this sequence
    li a7, 10            # sets register a7 (x17) to 10
    ecall                # system call: exit the program with code 0
