TOOLCHAIN=$(ANDROID_NDK_STANDALONE_TOOLCHAIN)
SYSROOT=$(TOOLCHAIN)/sysroot
CC=$(TOOLCHAIN)/bin/clang --sysroot=$(SYSROOT)
AS=$(TOOLCHAIN)/bin/arm-linux-androideabi-as
LD=$(TOOLCHAIN)/bin/arm-linux-androideabi-ld --sysroot=$(SYSROOT)
GDB=$(TOOLCHAIN)/bin/arm-linux-androideabi-gdb
CRT=$(SYSROOT)/usr/lib/crtbegin_dynamic.o $(SYSROOT)/usr/lib/crtend_android.o

CFLAGS=-fPIE -DANDROID -g
ASFLAGS=--gdwarf2
LDFLAGS=-pie --dynamic-linker=/system/bin/linker
GDBFLAGS=-tui

ASM_TARGET=asm-main-hello-world
ASM_PARAM=
ASM_DEPS=system.inc
ASM_OBJ=asm_main.o $(CRT)
ASM_LIBS=-lc

C_TARGET=c-main-hello-world
C_PARAM=
C_DEPS=
C_OBJ=c_main.o $(CRT)
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
	adb shell mkdir /data/data/test
	adb push $(ASM_TARGET) /data/data/test/
	adb push $(C_TARGET) /data/data/test/

test:
	adb shell "/data/data/test/$(ASM_TARGET) $(ASM_PARAM) && /data/data/test/$(C_TARGET) $(C_PARAM)"

debug_remote_asm:
	adb forward tcp:5555 tcp:5555
	adb shell gdbserver :5555 /data/data/test/$(ASM_TARGET)

debug_local_asm:
	$(GDB) $(GDBFLAGS) $(ASM_TARGET)
	# target remote :5555

debug_remote_c:
	adb forward tcp:5555 tcp:5555
	adb shell gdbserver :5555 /data/data/test/$(C_TARGET)

debug_local_c:
	$(GDB) $(GDBFLAGS) $(C_TARGET)
	# target remote :5555

clean:
	rm -rf $(ASM_TARGET) $(C_TARGET) *.o

