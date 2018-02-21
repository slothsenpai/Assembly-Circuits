# Assignment 1
# Author: Addison Beall aeb95@pitt.edu
.data
Welcome: .asciiz "Welcome to AutoCoder!\n"
OpPrompt: .asciiz "The opcode (1-9 : 1=add, 2=addi, 3=or, 4=ori, 5=lw, 6=sw, 7=j, 8=beq, 9=bne)\n"
OneProm: .asciiz "Please enter the 1st opcode: "
TwoProm: .asciiz "Please enter the 2nd opcode: "
ThreeProm: .asciiz "Please enter the 3rd opcode: "
FourProm: .asciiz "Please enter the 4th opcode: "
FiveProm: .asciiz "Please enter the 5th opcode: "
codeComplete: .asciiz "\nThe completed code is\n"
machComplete: .asciiz "\nThe machine code is" 
TTT: .asciiz "$t"
LLL: .asciiz "L"
comm: .asciiz ", "
oParen: .asciiz "("
cParen: .asciiz ")"
colon: .asciiz ": "
addop: .asciiz "add "
addiop: .asciiz "addi "
orop: .asciiz "or "
oriop: .asciiz "ori "
lwop: .asciiz "lw "
swop: .asciiz "sw "
jop: .asciiz "j "
beqop: .asciiz "beq "
bneop: .asciiz "bne "
string: .asciiz "\n"
hexStart: .asciiz "\n0x"
# The above lines are strings which will be used to properly format output
.text
la $a0 Welcome
li $v0 4
syscall
# loads the welcome message and displays it
la $a0 OpPrompt
li $v0 4
syscall
# loads the prompt which displays inputs and the operations to which they correspond
la $a0 OneProm
li $v0 4
syscall
# loads and displays a message asking the user for his/her first input
li $v0 5
syscall
# reads in an integer entered by the user and stores it in the register $v0
add $s0 $v0 $0
# moves the integer from $v0 to $s0, necessary as $v0 will be overwritten in the next section
la $a0 TwoProm
li $v0 4
syscall
# loads and displays a message asking the user for his/her second input
li $v0 5
syscall
# reads in an integer entered by the user and stores it in the register $v0
add $s1 $v0 $0
# moves the integer from $v0 to $s1
la $a0 ThreeProm
li $v0 4
syscall
# loads and displays a message asking the user for his/her third input
li $v0 5
syscall
# reads in an integer and stores it in the register $v0
add $s2 $v0 $0
# moves the interger from $v0 to $s2
la $a0 FourProm
li $v0 4
syscall
# loads and displays a message asking the user for his/her fourth input
li $v0 5
syscall
# reads in an integer and stores it in the register $v0
add $s3 $v0 $0
# moves the integer from $v0 to $s3
la $a0 FiveProm
li $v0 4
syscall
# loads and displays a message asking the user for his/her fifth input
li $v0 5
syscall
# reads in an integer and stores it in the register $v0
add $s4 $v0 $0
# moves the integer from $v0 to $s4
la $a0 codeComplete
li $v0 4
syscall
# loads and displayes a message indicating that the following lines comprise the code 
# that results from the inputs provided above
li $s5 0 # $s5 will be the register counter, this register will be incremented by 1 or 2 depending on the instruction
# and will then be divided by $s7 to accomplish modulo division
li $s6 100 # $s6 will be the "address" counter, the address for the displayed instructions, not the actual MIPS address
li $s7 10 # $s7 will be the modulo divisor for $s5
move $t8 $sp
# the line above copies the current value of the stack pointer to the register $t8
# this will be used as a check to end the looping of this program
addi $sp $sp -20
# the line above shifts the stack point "down" by five words, thus making room to store the five inputs collected from 
# the user and clearing the register $s0 - $s4 for other uses
sw $s0 ($sp)
sw $s1 4($sp)
sw $s2 8($sp)
sw $s3 12($sp)
sw $s4 16($sp)
# the five lines above store the inputs provided by the user on the stack, in the order they were input
move $t9 $sp
# the line above copies the current value of the stack pointer to the register $t9
# $t9 will be incremented until it matches $t8, at that point the program knows it has processed every input provided 
# by the user and can begin the exit process
li $s0 0x00
addi $s0 $s0 0x400000
# the above two lines first clear the register $t0 of its contents then stores the value 0x400000 in that register
# $s0 is going to serve as an analog to the PC counter as it is necessary for the beq and bne instructions
li $s4 100 # $s4 will be the immediate value to use next if a function requiring an immediate is called, will only be 
# incremented after an instruction uses an immediate value

inputCheck:
beq $t9 $t8 printMachine # check to see if $t9 and $t8 are equal yet, recall $t9 is pointing to the "top" of the stack
# where the user inputs are stored, while $t8 is pointing to the "bottom"
la $a0 LLL
li $v0 4
syscall
# the lines above load and print the letter "L" required for each line of instructions
add $a0 $s6 $0
li $v0 1
syscall
# the above copies te value in $s6 to $a0 and prints it next to the "L" printed in the previous block, this is the
# line number
la $a0 colon
li $v0 4
syscall
# the above loads and prints the following ": ", necessary as per instructions
addi $sp $sp -4
# the line above decrements the stack pointer by 4 bytes, thus making room for another word to be stored at the current
# stack pointer address
lw $t0 ($t9)
# line above loads the word stored at the "top" of the stack where the user inputs were stored
beq $t0 1 PrintAddOp
beq $t0 2 PrintAddiOp
beq $t0 3 PrintOrOp
beq $t0 4 PrintOriOp
beq $t0 5 PrintLwOp
beq $t0 6 PrintSwOp
beq $t0 7 PrintJOp
beq $t0 8 PrintBeqOp
beq $t0 9 PrintBneOp
# the ten lines above check the value of the word that was loaded into $t0 and branch to the corresponding instruction 
# set, I realize this is repetitive, but it was the method I felt best about implementing
ctd:
addi $t9 $t9 4
addi $s6 $s6 1
addi $s0 $s0 0x4
j inputCheck
# the block above increments the $t9 register by 4, which moves it "down" the stack where the user inputs were stored
# then increments the line counter, $s6. Finally, the pseudo PC counter, $s0, is incremented by 4 then the program 
# jumps back up to the inputCheck block 


exit: 
li $v0 10
syscall
# this is the last instruction block to be run, loads the exit command into $v0, then exits



PrintAddOp: # opcode = 0, function = 32
la $a0 addop
li $v0 4
syscall
# the three lines above load the text "add " and displays it
lw $t1 ($sp)
add $t1 $0 $0
# the two lines above load the word stored at the current register value into $t1 and clears $t1 of its contents
addi $s5 $s5 2
# the line above adds two to the register $s5 which is serving as the counter for the register number to be used 
# when printing out the instructions. Here it is incremented by two because the destination register ($d) for the 
# add instruction is about to be printed
div $s5 $s7
mfhi $t4
# $s5 is divided by $s7 which contains 10, this results in the correct register number as the hi register will contain
# the remainder of the division, which always ends up being the register number no matter the value $s5 ends up taking
la $a0 TTT
li $v0 4
syscall
# the lines above load the string "$t" and prints it out, will be followed by the register number below
add $a0 $t4 $0
li $v0 1
syscall
# the destination register value ($d) for the add instruction, which was previous stored in $t4, is now moved to $a0 and 
# is printed
la $a0 comm
li $v0 4
syscall
# the string ", " is now loaded and printed
addi $t3 $s5 -2
# $t3 now contains the register counter decremented by 2 which will shortly become the source register ($s) value to
# be printed in the add instruction
div $t3 $s7
mfhi $t4
# after $t3 is divided by $s7, which contains 10, the register hi contains the register number ($s) to be used, thus the 
# value in hi is moved to $t4
la $a0 TTT
li $v0 4
syscall
# the string "$t" is loaded and printed
add $a0 $t4 $0
li $v0 1
syscall
# the source register value ($s) is loaded into $a0 and printed
la $a0 comm
li $v0 4
syscall
# the string ", " is loaded and printed
addi $t3 $s5 -1
# $t3 now contains the register counter decremented by one which will become the target register ($t) value to be printed
# in the add instruction
div $t3 $s7
mfhi $t4
# after $t3 is divided by $s7, which contains 10, the register hi contains the appropriate register value to be printed
# the value stored in hi is moved to $t4
la $a0 TTT
li $v0 4
syscall
# the string "$t" is loaded and printed
add $a0 $t4 $0
li $v0 1
syscall
# the target register value ($t) is loaded into $a0 and printed
la $a0 string
li $v0 4
syscall
# a string containing the newline character is loaded and printed in order to properly format the output as required
addi $t3 $s5 -2
# the smallest register value ($s) is needed again in order to calculate the appropriate hex code, so the line above
# decrements the register counter by two which will eventually become the "numeric" name of the register
div $t3 $s7
mfhi $a0
# the smallest register value, as it was displayed in the add instruction is now loaded into $a0 where it will be
# passed to the function registerCorrect
jal registerCorrect # explanation of registerCorrect is below
add $t4 $v0 $0
# the numeric representation of the source register ($s) is now copied from $v0 into $t4
or $t1 $t1 $t4
# recall from above the $t1 currently contains nothing, so the contents of $t4 are copied into $t1
sll $t1 $t1 5
# $t1 is shifted left logically by five bits to make room for the next register value, the target register
# $t1 currently looks like:
# 0000 0000 0000 0000 0000 00ss sss0 0000
addi $t3 $s5 -1
# the target register ($t) is needed next, so the result of decrementing the register counter by one is stored in $t3
div $t3 $s7
mfhi $a0
# after $t3 is divided by $s7, which contains 10, the register hi will contain the value which corresponds the sybolic 
# representation of the target register ($t)
jal registerCorrect
add $t4 $v0 $0
# the numeric representation of the target register ($t) is copied from $v0 into $t4
or $t1 $t1 $t4
# $t1 is now or'd with $t4 which contains the target register ($t) value
sll $t1 $t1 5
# $t1 is shifted left logical by five bits to make room for the next register, the destination register ($d)
# $t1 now looks like:
# 0000 0000 0000 0000 0sss sstt ttt0 0000
add $t3 $s5 $0
div $t3 $s7
mfhi $a0
# finally, the destination register ($d) is needed, thus the register counter doesn't need to be modified
# the value of the register counter is copied into $t3 and $t3 is then divided by $s7, which contains 10
# after that hi will contain the symbolic representation of the destination register ($d) which is then passed to 
# registerCorrect
jal registerCorrect
add $t4 $v0 $0
# the numeric representation of the destination register ($d) is copied from $v0 into $t4
or $t1 $t1 $t4
sll $t1 $t1 9
# $t1 is now or'd with $t4 then $t1 is shifted left logically by nine bits
# Here we shift left by nine bits as that leaves the shift amount as zero which is how the add instruction is encoded
# $t1 now looks like:
# 0000 0000 ssss sttt ttdd ddd0 0000 0000
or $t1 $t1 0x08
# $t1 is now ori'd with 0x08 as the function code of the add instruction is 32, but ori'ing with 0x08 at this point will
# eventually get the function code to be 32
sll $t1 $t1 2
# $t1 is now shifted left logically by 2 bits which results in the final hex code for this add instruction
# $t1 now looks like:
# 0000 00ss ssst tttt dddd d000 0010 0000
# the first six bits are zero as these bits signify the op code for the add instruction, which is zero
sw $t1 ($sp)
# completed hex code is then stored at the current address of the stack pointer then control jumps to the ctd instructions
j ctd



PrintAddiOp: # opcode = 8
la $a0 addiop
li $v0 4
syscall
# the string "addi " is loaded and printed
add $t1 $0 $0
# the contents of $t1 are cleared to make room for the hex code of this instruction
addi $s5 $s5 1
# given that there are only two registers needed for the addi instruction, the register counter is only incremented by one
move $t5 $s4
# $s4 contains the current immediate value, so it is copied into $t5 from where it will eventually be loaded/printed
la $a0 TTT
li $v0 4
syscall
# the string "$t" is loaded and printed
add $t3 $s5 $0
div $t3 $s7
mfhi $t4
add $a0 $t4 $0
li $v0 1
syscall
# the register counter is copied into $t3 then divided by $s7, which contains 10, then the contents of the register hi
# are copied into $t4 which is then loaded and printed, this produces the target register ($t) in the instruction
la $a0 comm
li $v0 4
syscall
# the string ", " is loaded then printed
la $a0 TTT
li $v0 4
syscall
# the string "$t" is loaded then printed
addi $t3 $s5 -1
div $t3 $s7
mfhi $t4
add $a0 $t4 $0
li $v0 1
syscall
# the result of decrementing the register counter is copied into $t3 then divided by $s7, which contains 10, 
# then the contents of the register hi are copied into $t4 which is then loaded and printed
la $a0 comm
li $v0 4
syscall
# the string ", " is loaded then printed
add $a0 $t5 $0
li $v0 1
syscall
# the immediate value, which was stored in $t5 earlier is now loaded then printed
la $a0 string
li $v0 4
syscall
# the newline character is loaded then printed in order to maintain proper formatting
li $t1 8
# the opcode for the addi instruction is 8, so 8 is loaded into the least significant bits of $t1
# this will eventually end up in the proper position to represent the opcode
sll $t1 $t1 5
# $t1 is shifted left five bits the make room for the source register ($s)
addi $t3 $s5 -1
div $t3 $s7
mfhi $a0
jal registerCorrect
add $t4 $v0 $0
or $t1 $t1 $t4
sll $t1 $t1 5
# the symbolic representation of the source register is loaded and passed to the registerCorrect function
# which returns the numeric representation of the source register. the source register is then or'd with $t1, then 
# shifted left five bits to make room for the target register
add $t3 $s5 $0
div $t3 $s7
mfhi $a0
jal registerCorrect
add $t4 $v0 $0
or $t1 $t1 $t4
sll $t1 $t1 16
# the symbolic representation of the target register is loaded and passed to the registerCorrect function
# which returns the numeric representation of the target register. the target register is then or'd with $t1, then 
# shifted left 15 bits to make room for the immediate
or $t1 $t1 $t5
# the immediate is now or'd with $t1, thus completing the hex code
# $t1 looks like:
# 0010 00ss ssst tttt iiii iiii iiii iiii
sw $t1 ($sp)
# the hex code is stored at the current address of the stack pointer
addi $s4 $s4 1
# the immediate counter is now incremented by one so the next time a register is used, the correct value is supplied
# as per the extra credit instructions
j ctd
# control is passed to the ctd function

PrintOrOp: # opode = 0, function = 37
la $a0 orop
li $v0 4
syscall
# the string "or " is loaded then printed
addi $s5 $s5 2
add $t1 $0 $0
# the register counter is incremented by two as there will be three registers used in this instruction, 
# additionally, the contents of $t1 are cleared to make room for the hex code
la $a0 TTT
li $v0 4
syscall
add $t3 $s5 $0
div $t3 $s7
mfhi $a0
li $v0 1
syscall
# the symbolic representation of the destination register ($d) is calculated/, oaded, then printed
la $a0 comm
li $v0 4
syscall
# the string ", " is loaded then printed
la $a0 TTT
li $v0 4
syscall
addi $t3 $s5 -2
div $t3 $s7
mfhi $a0
li $v0 1
syscall
# the symbolic representation of the source register ($s) is calculated, loaded, then printed
la $a0 comm
li $v0 4
syscall
# the string ", " is loaded then printed
la $a0 TTT
li $v0 4
syscall
addi $t3 $s5 -1
div $t3 $s7
mfhi $a0
li $v0 1
syscall
# the symbolic representation of the target register ($t) is calculated, loaded, then printed
la $a0 string
li $v0 4
syscall
# the newline character is loaded then printed to maintain proper string formatting
addi $t3 $s5 -2
div $t3 $s7
mfhi $a0
jal registerCorrect
move $t4 $v0
or $t1 $t1 $t4
sll $t1 $t1 5
# the numeric representation of the source register ($s) is calculated, or'd with $t1, then shifted left five bits
# to make room for the target register ($t)
addi $t3 $s5 -1
div $t3 $s7
mfhi $a0
jal registerCorrect
move $t4 $v0
or $t1 $t1 $t4
sll $t1 $t1 5
# the numeric representation of the target register ($t) is calculated, or'd with $t1, then shifted left five bits
# to make room for the destination register ($d)
add $t3 $s5 $0
div $t3 $s7
mfhi $a0
jal registerCorrect
move $t4 $v0
or $t1 $t1 $t4
sll $t1 $t1 11
# the numeric representation of the destination register ($d) is calculated, or'd with $t1, then shifted left 
# 11 bits to make room for the shift amount (Here, it's zero) and the function code (Here, its 37)
ori $t1 $t1 37
# the immediate 37 is ori'd with $t1, thus completing the hex code
sw $t1 ($sp)
# the hex code is now stored at the current stack address
j ctd
# control is now passed to the ctd instructions




PrintOriOp: # op code = 13
la $a0 oriop
li $v0 4
syscall
# the string "ori " is loaded then printed
addi $s5 $s5 1
# the register counter is incremented by one as there are one two registers used in the ori instruction
add $t1 $0 $0
la $a0 TTT
li $v0 4
syscall
add $a0 $s5 $0
li $v0 1
syscall
# the symbolic representation of the target register ($t) is calculated, loaded, then printed
la $a0 comm
li $v0 4
syscall
# the string ", " is loaded then printed
la $a0 TTT
li $v0 4
syscall
addi $a0 $s5 -1
li $v0 1
syscall
la $a0 comm
li $v0 4
syscall
# the symbolic representation of the source register ($s) is calculated, loaded, then printed
move $t5 $s4
move $a0 $t5
li $v0 1
syscall
# the immediate counter is loaded then printed
la $a0 string
li $v0 4
syscall
# the newline character is loaded then printed to maintain proper output formatting
addi $t1 $t1 13
# the op code for the ori instruction is 13, so 13 is added to the empty $t1. 13 will eventually end 
# up in the op code position
sll $t1 $t1 5
# $t1 is shifted left five bits to make room for the source register ($s)
addi $t3 $s5 -1
div $t3 $s7
mfhi $a0
jal registerCorrect
move $t4 $v0
or $t1 $t1 $t4
sll $t1 $t1 5
# the numeric representation of the source register is calculated, loaded, then or'd with $t1
# then $t1 is shifted left five bits to make room for the target register ($t)
add $t3 $s5 $0
div $t3 $s7
mfhi $a0
jal registerCorrect
move $t4 $v0
or $t1 $t1 $t4
sll $t1 $t1 16
# the numeric representation of the target register ($t) is calculated, loaded, then or'd with $t1
# then $t1 is shifted left 16 bits to make room for the immediate value
or $t1 $t1 $t5
# the immediate value, which was stored in $t5 earlier, is now or'd with $t1 thus completing the hex code
# $t1 looks like:
# 0011 01ss ssst tttt iiii iiii iiii iiii
sw $t1 ($sp)
addi $s4 $s4 1
j ctd
# the hex code is stored at the current address of the stack pointer, the immediate counter is incremented by one
# and control is passed to the ctd instructions



PrintSwOp: # opcode = 43
la $a0 swop
li $v0 4
syscall
# the string "sw " is loaded then printed
addi $s5 $s5 1
# the register counter is incremented by one since there will only by two registers used in this instruction
add $t1 $0 $0
la $a0 TTT
li $v0 4
syscall
add $a0 $s5 $0
li $v0 1
syscall
# the symbolic representation of the target register ($t) is calculated, loaded, then printed
la $a0 comm
li $v0 4
syscall
# the string ", " is loaded then printed
move $t5 $s4
move $a0 $t5
li $v0 1
syscall
# the current value of the immediate counter is loaded then printed
la $a0 oParen
li $v0 4
syscall
la $a0 TTT
li $v0 4
syscall
addi $a0 $s5 -1
li $v0 1
syscall
la $a0 cParen
li $v0 4
syscall
# the symbolic representation of the source register ($s) is calculated, loaded, then printed between parentheses
# Example: ($t5)
la $a0 string
li $v0 4
syscall
# the newline character is loaded then printed to maintain proper output formatting
addi $t1 $t1 43
sll $t1 $t1 5
# the op code for the sw instruction is 43, so 43 is added to $t1, then shifted right five bits to make room
# for the source register. 43 will eventually be in the op code position
addi $t3 $s5 -1
div $t3 $s7
mfhi $a0
jal registerCorrect
move $t4 $v0
or $t1 $t1 $t4
sll $t1 $t1 5
# the numeric representation of the source register is calculated, or'd with $t1, then shifted left five bits
# to make room for the target register
add $t3 $s5 $0
div $t3 $s7
mfhi $a0
jal registerCorrect
move $t4 $v0
or $t1 $t1 $t4
sll $t1 $t1 16
# the numeric representation of the target register is calculated, or'd with $t1, then shifted left 16 bits
# to make room for the immediate value
or $t1 $t1 $t5
# the immediate value previously stored in $t5 is or'd with $t1, which completes the hex code
# $t1 looks like: 
# 1010 11ss ssst tttt iiii iiii iiii iiii
sw $t1 ($sp)
addi $s4 $s4 1
j ctd
# the hex code is stored at the current address of the stack pointer, the immediate counter is incremented by one, 
# then control is passed to the ctd instructions

PrintLwOp: # opcode = 35
la $a0 lwop
li $v0 4
syscall
# the string "lw " is loaded then printed
addi $s5 $s5 1
# the register counter is incremented by one since there will only be two registers used in this instruction
add $t1 $0 $0
la $a0 TTT
li $v0 4
syscall
add $a0 $s5 $0
li $v0 1
syscall
# the symbolic representation of the target register is calculated, loaded, then printed
la $a0 comm
li $v0 4
syscall
# the string ", " is loaded then printed
move $t5 $s4
move $a0 $t5
li $v0 1
syscall
# the current value of the immediate counter is loaded, then printed
la $a0 oParen
li $v0 4
syscall
la $a0 TTT
li $v0 4
syscall
addi $a0 $s5 -1
li $v0 1
syscall
la $a0 cParen
li $v0 4
syscall
la $a0 string
li $v0 4
syscall
# the symbolic representation of the source register is calculated, loaded, then printed between parentheses
# Example: ($t7)
addi $t1 $t1 35
sll $t1 $t1 5
# the op code for the sw instruction is 35, so 35 is added to $t1 then shifted left five bits to make room
# for the source register. 35 will eventually end up in the op code position
addi $t3 $s5 -1
div $t3 $s7
mfhi $a0
jal registerCorrect
move $t4 $v0
or $t1 $t1 $t4
sll $t1 $t1 5
# the numeric representation of the source register is calculated, or'd with $t1, then shifted left five bits 
# to make room for the target register
add $t3 $s5 $0
div $t3 $s7
mfhi $a0
jal registerCorrect
move $t4 $v0
or $t1 $t1 $t4
sll $t1 $t1 16
# the numeric representation of the target register is calculated, or'd with $t1, then shifted left 16 bits
# to make room for the immediate value
or $t1 $t1 $t5
# the immediate value, which was previously stored in $t5, is or'd with $t1 which completes the hex code
sw $t1 ($sp)
addi $s4 $s4 1
j ctd
# the hex code is stored at the current address of the stack pointer, the immediate counter is incremented by one
# then control is passed to the ctd instructions

PrintJOp: # opcode = 2
addi $s5 $s5 1
# the register counter is incremented by one even though this instruction requires no registers
# this is done as per the instructions of the assignment
li $t1 0x0
# the contents of $t1 are replaced with zeros
la $a0 jop
li $v0 4
syscall
# the string "j " is loaded then printed
la $a0 LLL
li $v0 4
syscall
addi $a0 $s4 0
li $v0 1
syscall
# the "address" of the instruction to which we are jumping is loaded then printed, this consists of the string "L"
# followed by the current value of the immediate counter. Given how the ouput is to be formatted this will align with
# an instruction listed earlier (or itself if jump is the first instruction)
la $a0 string
li $v0 4
syscall
# the newline character is loaded then printed to maintain proper output formatting
addi $t1 $t1 2
sll $t1 $t1 26
# the op code of the jump instruction is 2, so 2 is added to $t1, then shifted left 26 bits
# to make room for the immediate value of the absolute address of the instruction to which we are "jumping"
li $t5 0x4 # the contents of $t5 ar set to 0x4 as well will need to perform division with this value below
sub $t2 $s6 $s4
mult $t2 $t5
mflo $t2
# the "distance" from the jump instruction to the destination of said instruction is here calculated by subtracting 
# the current value of the immediate counter from the value of the current line (i.e. L100 L101, L102, etc)
# the result is then multiplied by 0x4, which is stored in $t5, the result of the multiplication is stored in $t2
sub $t3 $s0 $t2
div $t3 $t5
mflo $t3
# finally the absolute address of the target instruction is obtained by subtracting the distance amount from the pseudo PC counter
# which is stored in $s0. the result of that subtraction is then divided by 0x4 which produces the absolute address of the 
# instruction to which we are jumping
or $t1 $t1 $t3
sw $t1 ($sp)
addi $s4 $s4 1
j ctd
# the absolute address of the target instruction is now or'd with $t1, the finished hex code is stored at the current 
# address of the stack pointer, the immediate counter is incremented by one, and control is passed to the ctd instructions



PrintBeqOp: # opcode = 4
li $t1 0
addi $s5 $s5 1
# the contents of $t1 are cleared and the register counter is incremented by one as there will be only two registers
# used for this instruction
la $a0 beqop
li $v0 4
syscall
# the string "beq " is loaded then printed
la $a0 TTT
li $v0 4
syscall
add $a0 $s5 $0
li $v0 1
syscall
# the symbolic representation of the source register is calculated, loaded, then printed
la $a0 comm
li $v0 4
syscall
# the string ", " is loaded then printed
la $a0 TTT
li $v0 4
syscall
addi $a0 $s5 -1
li $v0 1
syscall
# the symbolic representation of the target register is calculated, loaded, then printed
la $a0 comm
li $v0 4
syscall
# the string ", " is loaded then printed
la $a0 LLL
li $v0 4
syscall
addi $a0 $s4 0
li $v0 1
syscall
# the current value of the immediate counter is loaded and printed following the string "L"
la $a0 string
li $v0 4
syscall
# the newline character is loaded and printed to maintain proper output formatting
li $t5 0x4 # 0x4 is required for some calculations below, so it is stored in $t5 to be used later
sub $t2 $s6 $s4
mult $t2 $t5
mflo $t2
sub $s1 $s0 $t2 
# the lines above are calculating the PC value of the label to which the beq instruction will jump if 
# the registers are equal. This is accomplished by subtracting the current value of the immediate counter
# from the line number on which this instruction is being printed (Example: L103 - 101 = 2)
# The result of that subtraction is then multiplied by 0x4 and stored in $t2 since the PC increments by 0x4 for each instruction
# The value stored in $t2 is now subtracted from the current pseudo PC which produces the pseudo PC of the instruction to 
# which the beq instruction will branch
addi $s2 $s0 0x4 
# Given that the current PC in MIPS is always the PC of the current instruction + 4, we add four here to 
# simulate that characteristic. This is also necessary to calculate the correct immediate value for the hex code
sub $s3 $s1 $s2
div $s3 $t5
mflo $s3
# the difference between the current pseudo PC and the pseudo PC of the branch instruction is calculated,
# then divided by 0x4. This is necessary as branch instructions use relative addressing
# the result of the division is stored in $s3
andi $s3 $s3 0xFFFF
# Since the immediate value for the beq instruction is only 16 bits, we andi the relative address with 
# 0xFFFF which will result in the upper half of the relative address to return to 0 while preserving
# the lower 16 bits which is going to serve as our immediate in the hex code
addi $t1 $t1 4
sll $t1 $t1 5
# the op code for the beq instruction is 4, so 4 is added to $t1 then shifted left five bits to make 
# room for the source register. 4 will end up in the op code position
add $a0 $s5 $0
jal registerCorrect
move $t4 $v0
or $t1 $t1 $t4
sll $t1 $t1 5
# the numeric representation of the source register is calculated, or'd with $t1, then shifted left five bits
# to make room for the target register
addi $a0 $s5 -1
jal registerCorrect
move $t4 $v0
or $t1 $t1 $t4
sll $t1 $t1 16
# the numeric representation of the target register is calculated, or'd with $t1, then shifted left 16 bits
# to make room for the immediate value we calculated above
or $t1 $t1 $s3
sw $t1 ($sp)
addi $s4 $s4 1
j ctd
# the immediate value corresponding to the relative address is or'd with $t1 which completes the hex code
# The hex code is then stored at the current address of the stack pointer, the immediate counter is incremented
# by one, and control is passed to the ctd instructions



PrintBneOp: # opcode = 5
li $t1 0
addi $s5 $s5 1
# $t1 is cleared of its contents and the register counter is incremented by one since the bne instruction only requires 
# two registers
la $a0 bneop
li $v0 4
syscall
# the string "bne " is loaded and printed
la $a0 TTT
li $v0 4
syscall
add $a0 $s5 $0
li $v0 1
syscall
# the symbolic representation of the source register is calculated, loaded, then printed
la $a0 comm
li $v0 4
syscall
# the string ", " is loaded then printed
la $a0 TTT
li $v0 4
syscall
addi $a0 $s5 -1
li $v0 1
syscall
# the symbolic representation of the target register is calculated, loaded, then printed
la $a0 comm
li $v0 4
syscall
# the string ", " is loaded then printed
la $a0 LLL
li $v0 4
syscall
addi $a0 $s4 0
li $v0 1
syscall
# the current value of the immediate counter is loaded then printed following the string "L"
la $a0 string
li $v0 4
syscall
# the newline character is loaded then printed to maintain proper output formatting
li $t5 0x4 # 0x4 is required for some calculations below, so it is stored in $t5 to be used later
sub $t2 $s6 $s4
mult $t2 $t5
mflo $t2
sub $s1 $s0 $t2
# the lines above are calculating the PC value of the label to which the bne instruction will jump if 
# the registers are not equal. This is accomplished by subtracting the current value of the immediate counter
# from the line number on which this instruction is being printed (Example: L103 - 101 = 2)
# The result of that subtraction is then multiplied by 0x4 and stored in $t2 since the PC increments by 0x4 for each instruction
# The value stored in $t2 is now subtracted from the current pseudo PC which produces the pseudo PC of the instruction to 
# which the beq instruction will branch
addi $s2 $s0 0x4
# Given that the current PC in MIPS is always the PC of the current instruction + 4, we add four here to 
# simulate that characteristic. This is also necessary to calculate the correct immediate value for the hex code
sub $s3 $s1 $s2
div $s3 $t5
mflo $s3
# the difference between the current pseudo PC and the pseudo PC of the branch instruction is calculated,
# then divided by 0x4. This is necessary as branch instructions use relative addressing
# the result of the division is stored in $s3
andi $s3 $s3 0xFFFF
# Since the immediate value for the beq instruction is only 16 bits, we andi the relative address with 
# 0xFFFF which will result in the upper half of the relative address to return to 0 while preserving
# the lower 16 bits which is going to serve as our immediate in the hex code
addi $t1 $t1 5
sll $t1 $t1 5
# the op code for the beq instruction is 5, so 5 is added to $t1 then shifted left five bits to make 
# room for the source register. 4 will end up in the op code position
add $a0 $s5 $0
jal registerCorrect
move $t4 $v0
or $t1 $t1 $t4
sll $t1 $t1 5
# the numeric representation of the source register is calculated, or'd with $t1, then shifted left five bits
# to make room for the target register
addi $a0 $s5 -1
jal registerCorrect
move $t4 $v0
or $t1 $t1 $t4
sll $t1 $t1 16
# the numeric representation of the target register is calculated, or'd with $t1, then shifted left 16 bits
# to make room for the immediate value we calculated above
or $t1 $t1 $s3
sw $t1 ($sp)
addi $s4 $s4 1
j ctd
# the immediate value corresponding to the relative address is or'd with $t1 which completes the hex code
# The hex code is then stored at the current address of the stack pointer, the immediate counter is incremented
# by one, and control is passed to the ctd instructions





# the function below, registerCorrect, takes the symbolic name of a register and converts it to the numeric representation
# of the same register, i.e. if $t0 were passed as an argument, the resulting value in $v0 would be 8. Likewise, if $t7 were
# passed as an argument, the resulting value in $v0 would be 15
registerCorrect:
blt $a0 8 justeight
# the line above checks to see if the value currently stored in $a0 is less than eight, if so, it branches to the 
# appropriate instruction, otherwise the function adds 16 to the value in $a0 and returns the resulting value
# in register $v0
addi $v0 $a0 16
j return
justeight:
addi $v0 $a0 8
# if the value in $a0 was less than eight, eight is added to the value in $a0 and the result is returned in register
# $v0
#
# if the value in $a0 was less than eight, that means the register argument is in the range of $t0 - $t7 which are
# numerically represented as $8 - $15, thus adding eight to those values results in the correct numeric representation
# if the value in $a0 was greater than eight, that means the register being used is either $t8 or $t9, thus
# adding 16 results in the correct numeric representations, $24 or $25, respectively
j return


return:
jr $ra
# a function which simply jumps to the current return address




# the function below will load the hex codes saved on the stack earlier and convert them in such a way
# that they can be printed without using syscall 34

printMachine:
addi $sp $sp 16
# we add 16 to the stack pointer here because we are currently pointing at the top of the portion of the stack 
# which contains the hex codes, by adding 16 we return to the bottom of that portion and will work our way up
li $s0 3 # $s0 will serve as the byte address we will be loading for each hex code, will be decremented with each loop
li $s2 0 # $s2 will serve as a counter for the number of hex codes we have processed, when $s2 reaches 5 we are done
la $a0 machComplete
li $v0 4
syscall
# the string "The machine code is " is loaded then printed
la $a0 hexStart
li $v0 4
syscall
# the string "0x" is loaded then printed
innerPrintMachine:
beq $s2 5 exit # as stated above, if $s2 equals 5, the program is finished and can exit
blt $s0 $0 reset # if $s0 equals 0, the loop is reset and iterated through again
la $s1 ($sp)
add $s1 $s1 $s0
# the two lines above calculate the byte address of the first, second, third, or fourth byte of the hex code
# loaded from the stack. This depends on the value of $s0, but follows the pattern fourth, third, second, first
lbu $t3 ($s1)
srl $a0 $t3 4
# the byte determined by $s0 is loaded into $t3 which is then shifted right four bits to isolate the upper four
# bits of that byte. This corresponds to a single character in the hex code. These four bits are then passed as
# an argument to the function decoder which is described below
jal decoder
andi $a0 $t3 0x0f
# now the lower four bits of the byte previously loaded into $t3 are isolated and passed as an argument to the
# function decoder
jal decoder
addi $s0 $s0 -1
j innerPrintMachine
# after decoder returns $s0 is decremented by 1 which will be used to select the next byte in the hex code
# the loop then repeats



# the function below, decoder, take an input of four bits and converts it to the corresponding hex code character.
# this is accomplished by first determining the decimal value of the argument.
# If the argument is less then the decimal value ten, then the argument has the decimal value 48 added to it.
# Here, 48 is the difference between the binary representation of the numbers 0 - 9 and the ascii representation of
# those same numbers, 0 - 9. 
# Using syscall 11 the character corresponding to the hex code of the argument is printed, which will one of the numbers 0 - 9.
# Example: 0100 is passed as an argument. This corresponds to the decimal value 4. When 48 is added to 4 the result is
# 52 which in binary is 0011 0100. 52 corresponds to the ascii character value of 4, which when using syscall 11, is exactly what is printed
# Similar logic is used for arguments which have a decimal value greater than or equal to 10. These arguments correspond
# to the hex characters a - f. The difference for those arguments is that the decimal value 87 is added to them
# to obtain the correct ascii character code.
# So after the ascii value is calculated, syscall 11 is used to print out the character, then control jumps to the return function
decoder:
blt $a0 $s7 numeric
j alpha
numeric:
addi $a0 $a0 0x30
li $v0 11
syscall
jr $ra
alpha:
addi $a0 $a0 0x57
li $v0 11
syscall
jr $ra


# the function below, reset, resets the values that enable the function innerPrintMachine above to loop
# this function is only called after the entire word corresponding to a line a hex code has been printed
reset:
li $s0 3 # $s0 is set back to three so we can select the bytes of the hex code in the proper order again
addi $sp $sp -4 # the stack pointer is decremented by four so we move on to the next hex code stored in the stack
addi $s2 $s2 1 # $s2 is incremented by one since we know we have processed a line of hex code, this is the counter for hex codes processed
beq $s2 5 exit # if we have processed five hex codes, we know we are done so the program exits, this line primarily prevents the string below from printing
	       # an extra time before the program exits
la $a0 hexStart
li $v0 4
syscall
# the string "0x" is loaded then printed
j innerPrintMachine
# control jumps back to the innerPrintMachine instructions