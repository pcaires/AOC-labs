# Data section
        .data
# IMPORTANT: do not change this section
a:	.word  1, 5, 6, 6, 7, 2, 5, 2, 3, 2, 3, 4
b:	.word  4, 3, 1, 7, 2, 4, 9, -3, 5, 8, 1, 9
x: 	.word  1
n:	.word  0   

# Program section
	.text
		                # NOTE: Upon start, the Global-Pointer (gp=x3) points to the beginning of .data section
        addi   x11, x3, 0		# x11 - a's left index
        addi   x13, x11, 48		# x13 - b's left index
        addi   x12, x13, -4		# x12 - a's right index
		
        lw     x14, 100(x3)		# x14 - n - index distance accumulator
        lw     x15, 96(x3)		# x15 - x
        li     x16, 0			# x16 - i

while:	
        lw     x22, 0(x11)		# x22 = a[i]   
        
        add    x20, x13, x16		# x20 = &b[i]
     
        lw     x23, 0(x12)		# x23 = a[N-1-i] 
        lw     x21, 0(x20)		# x21 = b[i]      

        lw     x24, 4(x20)		# x21 = b[i]
        lw     x25, 4(x11)		# x22 = a[i]        
        lw     x26, -4(x12)		# x23 = a[N-1-i]     
	
        blez   x21, end			# if b[i] <= 0 end the loop
        
        add    x22, x22, x23		# x22 = a[i] + a[N-1-i]
        mul    x15, x15, x22		# x15 = x15*x22 (x *= a[i] + a[N-1-i])

        sub    x22, x12, x11		# x22 = 4*((N-1-i)-i)
        srai   x22, x22, 2		# x22 = x22/4
        add    x14, x14, x22		# n += x22

        blez   x24, end			# if b[i] <= 0 end the loop   
        
        add    x25, x25, x26		# x22 = a[i] + a[N-1-i]
        mul    x15, x15, x25		# x15 = x15*x22 (x *= a[i] + a[N-1-i])

        add    x14, x14, x22		# n += x22
        addi   x14, x14, -2
        
        addi   x12, x12, -8
        addi   x16, x16, 8		# i++
        addi   x11, x11, 8

        jal    x0, while

end:    sw     x14, 100(x3)		# store n's final value
        sw     x15, 96(x3)		# store x's final value	

        addi   a7, x0, 10
        ecall


# Expected result: M[x] = 1270080 = 136140h
#                  M[n] = 35      = 23h
