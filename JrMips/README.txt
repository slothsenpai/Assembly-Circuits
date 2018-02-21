Addison Beall
aeb95@pitt.edu

As far as I can tell, every instruction asked for in the project description works. I've included the tests I performed, and most of them are still saved in the instruction memory.
This processor does not check for overflow errors and will blindly perform addition/subtraction since that was not asked for in the project description.
The lw and sw instructions use the lower eight bits from the $rt register as that seemed to be the only way to get an address from the 16 bit registers.
Sorry its ugly. Its a tangled mess, but it works!

Instructions tested:

23ff				addui $r1 255
0200				put $r1
13c0				add $r1 $r7
03c0				put $r1 (w/ $r7 following to see if a second register affects the put instruction)
2e4a				addi $r7 37
0e00				put $r7
2b64				addi $r5 -50
0a00				put $r5
1540				add $r2 $r5
0400				put $r2
1a81				sub $r5 $r2
0a00				put $r5
35c0				and $r2 $r7
0400				put $r2
3541				nor $r2 $r5
0400				put $r2
4e08				sll $r7 4
0e00				put $r7
4e07				srl $r7 3
0e00				put $r7

// instructions between comments I tested but removed from instruction memory as they impeded other instruction tests, instructions removed worked as far as I can tell
	8400				bx $r2 0
	8401				bx $r2 0 (Should work the same as above since func doesn't matter)
	9010				bz $r0 8
	9011				bz $r0 8 (Should work the same as above since func doesn't matter)	
	a000				jr $r0
	a001				jr $r0 (Should work the same as above since func doesn't matter)
	bc1f				jal $r6 15
	bc1e				jal $r6 15 (Should work the same as above since func doesn't matter)
	c050				j 40
	c051				j 40 (Should work the same as above since func doesn't matter)
//

7e81				sw $r7 $r2
7080				lw $r0 $r2

//
	f000				halt
	f001				halt(Should work the same as above since func doesn't matter)
//

0a00				put $r5
0a01				put $r5 (Should work the same as above since func doesn't matter)










