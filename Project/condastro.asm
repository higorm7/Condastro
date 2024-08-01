.text
main:
	exec:
		jal printBanner
		jal getInput
		move $a0, $v0
		jal printString
		jal clearBuffer
		b exec
	
	jal exit

.include "mmio_utils.asm"
.include "static.asm"