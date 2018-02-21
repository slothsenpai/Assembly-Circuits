Addison Beall - aeb95@pitt.edu
Assignment 1 CS447 2016

Extra credit completed:
Did not use syscall 34 to print hex code
only used immediate values corresponding to used labels


Process:
inputs received
stored on stack
counters initialized
loaded input
checks value of input
executes proper instruction printing
hex code also generated within same function that prints instructions, hex stored on stack
cycle until all instructions have been processed
Hex codes are loaded from stack
each byte is processed four bits at a time
each four bytes is converted to an eight bit character corresponding to the hex code of those initial four bits
cycle until all hex codes have been processed, then exit


My program accomplishes the requirements set out in the instructions by performing the following:

First, the user is prompted to enter five integers (1 - 9) which correspond to MIPS instructions.

Next, those integers are stored on the stack so the registers in which they were temporarily saved may be reused.

Several counters are used throughout my program, so those counters are initiallized here. Most notable are the register counter,
the immediate counter, the pseudo PC counter, and the line counter.

	The register counter will start at zero and be modulo'd with 10 to calculate the current register value (the remainder will be used). At the start of each block corresponding to
	an instruction the register counter is incremented by 1 or 2 depending on the number of registers required for that function. This leaves the register
	counter potentially pointing to the "largest" register to be used for that instruction, so when "smaller" registers are need, subtraction is performed before the modulo.
	This works nicely because calculations regarding the switch from $t9 to $t0 are eliminated as the modulo remainder always moves from 0 to 9.
	
	The immediate counter is initialized at 100 and is only incremented by one when an instuction requiring an immediate is printed.
	
	The pseudo PC counter is used in the j, beq, and bne instructions as they require an address to which to jump. The pseudo PC counter starts at 0x00400000
	like it does in MIPS and is incremented by 0x4 after each instruction is printed
	
	The line counter also starts at 100 and is used to print the line number corresponding to the instruction printed. It is incremented by one after every instruction.
	
The integers the user entered are then loaded into a register starting with the first integer entered.
At this point the program enters a loop in which all the integers are eventually loaded and acted upon.

When a user input is loaded it passes through a series of beq instructions which check if the user input equals one of the numbers from 1 to 9. 
If so, the program jumps to a function which prints the instruction corresponding to that number (Ex: user input 3 prints the "or" instruction)
	
	These functions also generate the hex code which corresponds to the instruction, but saves the hex code on the stack to be printed later.
		
		The general process for generating the hex code is:
			Clear a register of its contents, always used $t1
			or $t1 with an immediate corresponding to the op code, then shift $t1 left five bits
			or $t1 with the hex code of the proper number of registers for the instruction, shifting $t1 left five bits after each register (usually, not always though)
				The hex code for registers is or'd into $t1 in the proper order as well, depending on the instruction of course
			if the instruction requires an immediate, either calculate that immediate or use the immediate counter, and or $t1 with the immediate in which case the hex code is complete
			if the instruction doesn't require an immediate, shift $t1 left by an amount such that the function code can be ori'd into $t1.
				None of the instructions use a shift amount, so that field is left as zeros and we can move straight to the function code in those cases.

After the all the instructions have been printed, the program moves to another loop which will process and print the hex code without using syscall 34.
	
	The process for printing the hex code is as follows:
		
		Each word of hex code is loaded into a register, from there each byte of the hex code is loaded into a different register.
		Next, the upper four bits and the lower four bits of the byte of hex code are isolated and converted to an eight bit ascii value by adding the 
		difference between the binary representation of that character and the ascii representation of that same character.
		These ascii values are then printed using syscall 11. Each four bits corresponds to a character of hex code, so through this process the hex code
		is printed a character at a time.
		
After all the hex codes have been printed using the method above, the program exits
