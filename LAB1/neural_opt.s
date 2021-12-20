.text
################################################################
# This is the "main" part of your code
# Develop test cases for 00, 01, 10, and 11
# Should call neural_network_xor multiple times
################################################################
# Develop your code here
li a0,0
li a1,0
jal neural_network_xor
sw a0, 0(x3)

li a0,1
li a1,0
jal neural_network_xor
sw a0, 4(x3)

li a0,0
li a1,1
jal neural_network_xor
sw a0, 8(x3)

li a0,1
li a1,1
jal neural_network_xor
sw a0, 12(x3)

end:             # exit your program with this sequence
    li a7, 10    # sets register a7 (x17) to 10
    ecall        # system call: exit the program with code 0


###############################################################
# multiply: multiplies two numbers and returns the result
# 	Inputs:  2 (multiplier a1 multiplicand a0, passed via stack)
#	Outputs: 1 (result a0 passed via stack)
# 	Effects: deletes inputs from stack, reduces stack size by 1 (inneficient for large multipliers)
###############################################################
# Develop your code here
multiply:
addi sp, sp, -12
sw s0,0(sp)
sw s1,4(sp)   #save s
sw s2,8(sp)   
    
lw s1,12(sp)   #load inputs
lw s0,16(sp)

beqz s0, return #If a0 is zero, skip (result is 0)

mv s2,s0      #copy multiplier
mv s0,zero    #Set s0 to 0

bgez s1,loop  # if s1 > 0 proceed
neg s1,s1 # else negate sign
neg s2,s2 #and negate the "adder", aka negate final signal

loop: beqz s1,return
add s0,s0,s2
addi s1,s1,-1
j loop

return:
sw s0,16(sp)  #store result    
    
lw s0,0(sp)  #restore s
lw s1,4(sp)
lw s2,8(sp)
lw s3,12(sp)

addi sp, sp, 16

jr ra        #return 

###############################################################
# neuron: computes the output of a neuron
# 	Inputs:  5 - [x1 x2 w1 w2 b] (passed via register)
#	Outputs: 1 - s (returned via register a0) 
# 	Effects: deletes inputs from register
###############################################################
# Develop your code here
neuron:
        
addi sp,sp,-20
sw a2,0(sp)
sw a0,4(sp)
sw ra,8(sp) #Store s and stack for 1st neuron
sw s1,12(sp)
sw s0,16(sp)

mv s1,a1 #copy input (a1)

jal multiply #multiply x1 w1

lw s0,0(sp) # get output

addi sp,sp,-4 # alocate 4 more bytes

sw a3,0(sp)
sw s1,4(sp) # stack -->[ra s0 a1 a3]

jal multiply #multiply x2 w2

lw s1,0(sp)  # get output

add s0,s0,s1 # x1*w1 + x2*w2
add s0,s0,a4 # + b
addi s0,s0,1 # +1

sgtz a0,s0   # s + 1 > 0 <=> s >= 0

addi sp,sp,4 #decrease stack

lw ra,0(sp)  #restore s
lw s1,4(sp)
lw s0,8(sp)  #restore ra

addi sp,sp,12 #decrease stack

jr ra

###############################################################
# neural_network_xor: computes the output of XOR gate 
# using a small neural network
# 	Inputs:  2 passed via register
#	Outputs: 1 passed via register
# 	Effects: TODO - does this function have some side effects?
###############################################################
# Develop your code here
neural_network_xor:
li a2,2
li a3,-2 #Constant inputs
li a4,-1

addi sp,sp,-16
sw s0,0(sp)
sw s1,4(sp)
sw s2,8(sp) #Store s and ra
sw ra,12(sp)

mv s0,a0 #Copy input a0 and a1
mv s1,a1

jal neuron #Call 1st neuron
mv s2,a0 #Move result to s2

li a2,-2 #Inputs for neuron 2
li a3,2
li a4,-1
mv a0,s0
mv a1,s1

jal neuron #Call second neuron

li a2,2
li a3,2
li a4,-1 #Inputs for final neuron
mv a1,a0 #s2 had result of 1st neuron, a0 of second
mv a0,s2

jal neuron #Final neuron - Final result on a0

lw s0,0(sp)
lw s1,4(sp) #Restore s and pointer
lw s2,8(sp)
lw ra,12(sp)
addi sp,sp,16

jr ra #Return



