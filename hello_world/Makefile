TOOLCHAIN=$(ANDROID_NDK_STANDALONE_TOOLCHAIN)
SYSROOT=$(TOOLCHAIN)/sysroot
CC=$(TOOLCHAIN)/bin/clang --sysroot=$(SYSROOT)
AS=$(TOOLCHAIN)/bin/arm-linux-androideabi-as
LD=$(TOOLCHAIN)/bin/arm-linux-androideabi-ld --sysroot=$(SYSROOT)
GDB=$(TOOLCHAIN)/bin/arm-linux-androideabi-gdb
CRT=$(SYSROOT)/usr/lib/crtbegin_dynamic.o $(SYSROOT)/usr/lib/crtend_android.o
INSTALL=/system/test

CFLAGS=-fPIE -DANDROID -g
ASFLAGS=--gdwarf2
LDFLAGS=-pie --dynamic-linker=/system/bin/linker
GDBFLAGS=-tui

ASM_TARGET=asm-hello-world
ASM_PARAM=
ASM_DEPS=system.inc
ASM_OBJ=start.o
ASM_LIBS=

C_TARGET=c-hello-world
C_PARAM=
C_DEPS=
C_OBJ=main.o $(CRT)
C_LIBS=-lc

all: $(ASM_TARGET) $(C_TARGET)

force: clean all

$(C_TARGET): $(C_OBJ)
	$(LD) $(LDFLAGS) $^ -o $@ $(C_LIBS)

$(ASM_TARGET): $(ASM_OBJ)
	$(LD) $(LDFLAGS) $^ -o $@ $(ASM_LIBS)

%.o: %.c $(C_DEPS)
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s $(ASM_DEPS)
	$(AS) $(ASFLAGS) $< -o $@

install: all
	adb root
	adb remount
	adb shell "mkdir $(INSTALL)"
	adb push $(ASM_TARGET) $(INSTALL) 
	adb push $(C_TARGET) $(INSTALL) 
	adb shell "chmod +x $(INSTALL)/$(ASM_TARGET) $(INSTALL)/$(C_TARGET)"

uninstall:
	adb root
	adb remount
	adb shell "mkdir $(INSTALL)"
	adb shell "rm -rf $(INSTALL)/$(ASM_TARGET) $(INSTALL)/$(C_TARGET)"
	adb shell "rmdir $(INSTALL)"

test:
	adb root
	adb shell "$(INSTALL)/$(ASM_TARGET) $(ASM_PARAM) && $(INSTALL)/$(C_TARGET) $(C_PARAM)"

debug_remote_asm:
	adb root
	adb forward tcp:5555 tcp:5555
	adb shell gdbserver :5555 $(INSTALL)/$(ASM_TARGET)

debug_local_asm:
	echo "Enter the following line to connect."
	echo "target remote :5555"
	$(GDB) $(GDBFLAGS) $(ASM_TARGET)

debug_remote_c:
	adb root
	adb forward tcp:5555 tcp:5555
	adb shell gdbserver :5555 $(INSTALL)/$(C_TARGET)

debug_local_c:
	echo "Enter the following line to connect."
	echo "target remote :5555"
	$(GDB) $(GDBFLAGS) $(C_TARGET)

clean:
	rm -rf $(ASM_TARGET) $(C_TARGET) *.o

