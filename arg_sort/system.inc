@ Android Syscall Reference
https://code.google.com/p/android-source-browsing/source/browse/libc/SYSCALLS.TXT?repo=platform--bionic&r=cd15bacf334ab254a5f61c3bba100adde1b6b80a

.set stdin,  0
.set stdout, 1
.set stderr, 2

.set SYS_nosys, 0
.set SYS_exit,  1
.set SYS_fork,  2
.set SYS_read,  3
.set SYS_write, 4
.set SYS_open,  5
.set SYS_close, 6

.macro sys.syscall id
	mov	r7, \id
	swi	$0
.endm

.macro sys.exit
	sys.syscall $SYS_exit
.endm

.macro sys.fork
	sys.syscall $SYS_fork
.endm

.macro sys.read
	sys.syscall $SYS_read
.endm

.macro sys.write
	sys.syscall $SYS_write
.endm

.macro sys.open
	sys.syscall $SYS_open
.endm

.macro sys.close
	sys.syscall $SYS_close
.endm

