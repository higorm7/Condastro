.text
main:
	exec:
		jal printBanner
		jal getInput
		move $a0, $v0
		jal removeNewline
		move $s0, $v0
		
		move $a0, $s0
		la $a1, cmd_1
		jal strcmp
		
		move $t0, $v0	
		beqz $t0, addMorador
		
		b error
		
		addMorador:
			li $v0, 4
			la $a0, cmd_1
			syscall
			
			b restart
		error:
			la $a0, invalid_cmd
			jal mmio_printString
		
		restart:
			b exec
	end_exec:
		jal exit


.include "mmio_utils.asm"
.include "static.asm"
.include "utils/utils.asm"