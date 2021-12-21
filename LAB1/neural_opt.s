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

li a0,1
li a1,0
jal neural_network_xor

li a0,0
li a1,1
jal neural_network_xor

li a0,1
li a1,1
jal neural_network_xor

end:             # exit your program with this sequence
    li a7, 10    # sets register a7 (x17) to 10
    ecall        # system call: exit the program with code 0


###############################################################
# multiply: multiplies two numbers and returns the result
# 	Inputs:  2 (multiplier and multiplicand, passed via stack)
#   Outputs: 1 (result passed via stack)
# 	Effects: Deletes inputs from stack, reduces stack size by 1 
#            (inneficient for large multipliers)
###############################################################
# Develop your code here
multiply:
addi sp, sp, -12
sw s0,0(sp)
sw s1,4(sp)     # save s
sw s2,8(sp)   
    
lw s0,12(sp)    # load inputs
lw s1,16(sp)

beqz s0, return # If s0 is zero, skip (result is 0)

mv s2,s0        # copy multiplicand
mv s0,zero      # Set s0 to 0

beqz s1, return # If s1 is zero, skip (result is 0)

bgez s1,loop    # if s1 > 0 proceed
neg s1,s1       # else negate sign
neg s2,s2       # and negate the "adder", i.e negate final signal

loop: 
add s0,s0,s2    # accumulate multiplicand
addi s1,s1,-1   # reduce Multiplier
bnez s1,loop    # if multiplier 0, proceed

return:
sw s0,16(sp)    # store result    
    
lw s0,0(sp)     # restore s
lw s1,4(sp)
lw s2,8(sp)

addi sp, sp, 16

jr ra # return 

###############################################################
# neuron: computes the output of a neuron
# 	Inputs:  5 - [x1 x2 w1 w2 b] (passed via register, a0 to a4)
#   Outputs: 1 - s (returned via register a0) 
# 	Effects: Deletes inputs from register
###############################################################
# Develop your code here
neuron:
addi sp,sp,-28  
sw a0,0(sp)   # store inputs in convenient order 
sw a2,4(sp)   
sw a1,8(sp)
sw a3,12(sp)
sw a4,16(sp)
sw s0,20(sp)  # store s0 
sw ra,24(sp)  # store return adress

jal multiply  # multiply x1 w1
lw s0,0(sp)   # retrieve result
addi sp,sp,4  # decrease stack

jal multiply  # multiply x2 w2 = a1

lw a1,0(sp)   # retrieve useful from stack
lw a4,4(sp)


add a0,s0,a1  # a0 + a1
add a0,a0,a4  # a0 + a1 + b
addi a0,a0,1  # a0 + a1 + b + 1 

sgtz a0,a0    # s + 1 > 0 <=> s >= 0

lw s0,8(sp)   # restore s0
lw ra,12(sp)  # restore ra
addi sp,sp,16 # decrease stack

jr ra #Return

###############################################################
# neural_network_xor: computes the output of XOR gate 
# using a small neural network
# 	Inputs:  2 passed via register (a0,a1)
#   Outputs: 1 passed via register (a0)
# 	Effects: Will change a2 to a4 (constant parameters of neuron)
###############################################################
# Develop your code here
neural_network_xor:
li a2,2
li a3,-2    # constant inputs
li a4,-1

addi sp,sp,-16
sw s0,0(sp)
sw s1,4(sp)
sw s2,8(sp) # store s and ra
sw ra,12(sp)

mv s0,a0    # copy input a0 and a1
mv s1,a1

jal neuron  # call 1st neuron
mv s2,a0    # move result to s2

li a2,-2    # inputs for neuron 2
li a3,2
li a4,-1
mv a0,s0
mv a1,s1

jal neuron  # call second neuron

li a2,2
li a3,2
li a4,-1    # inputs for final neuron
mv a1,a0    # s2 had result of 1st neuron, a0 of second
mv a0,s2

jal neuron  # final neuron - final result on a0

lw s0,0(sp)
lw s1,4(sp) # restore s and pointer
lw s2,8(sp)
lw ra,12(sp)
addi sp,sp,16

jr ra       # return



