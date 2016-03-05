# You can define your st-link directory in here
STFLASH=st-flash


LDSCRIPT = ./libs/libopencm3/stm32f0-discovery.ld

PREFIX	?= arm-none-eabi
LD		= $(PREFIX)-gcc
OBJCOPY	= $(PREFIX)-objcopy
OBJDUMP	= $(PREFIX)-objdump
GDB		= $(PREFIX)-gdb
INCDIRS=-I./libs/stm32f0xx

LINKERFILE = ./libs/stm32f0xx/stm32f0_linker.ld 

ARCH_FLAGS = -mthumb -mcpu=cortex-m0 -msoft-float
CFLAGS		+= -Ofast \
		   -fno-common $(ARCH_FLAGS) -MD -DSTM32F0 \
		   -s\
		   -Wl,--gc-sections\
		   -nostdlib
LDFLAGS		+= --static -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group \
		   -T$(LDSCRIPT) -nostartfiles -Wl,--gc-sections,--print-gc-sections \
		   $(ARCH_FLAGS) 


STMOBJ = libs/stm32f0xx/system_stm32f0xx.o  \
         libs/stm32f0xx/stm32f0xx_gpio.o  \
         libs/stm32f0xx/stm32f0xx_rcc.o  \
         libs/stm32f0xx/stm32f0xx_usart.o  \
         libs/stm32f0xx/startup_stm32f0xx.o \
				 libs/stm32f0xx/sbrk.o

OBJS = poly.o  error_correction.o crypto_stream_chacha20.o newhope.o fips202.o stm32f0_wrapper.o randombytes.o asm_poly.o asm_ntt.o asm_ec.o keccakf1600.o asm_chacha.o


all: lib test/client.bin test/server.bin test/speed.bin test/memsize.bin 


lib: $(OBJS)
	@rm -f test/*.a  
	$(PREFIX)-ar cq test/libnewhopearm.a $(OBJS)
	@rm -f $(OBJS)



runClient: test/client.bin scripts/test_client.py
	$(STFLASH) write test/client.bin 0x8000000 >/dev/null 2>&1
	./scripts/test_client.py

runServer: test/server.bin scripts/test_server.py
	$(STFLASH) write test/server.bin 0x8000000 >/dev/null 2>&1
	./scripts/test_server.py

runSpeed: test/speed.bin scripts/monitor.sh
	./scripts/monitor.sh $(STFLASH) test/speed.bin

runMemsize: test/memsize.bin scripts/monitor.sh
	./scripts/monitor.sh $(STFLASH) test/memsize.bin

test/client.elf: test/client.o test/libnewhopearm.a  $(LDSCRIPT) libs/libopencm3/lib/libopencm3_stm32f0.a
	$(LD) -o test/client.elf test/client.o test/libnewhopearm.a  $(LDFLAGS) libs/libopencm3/lib/libopencm3_stm32f0.a
	@rm -f test/client.o
	@rm -f test/client.d

test/server.elf: test/server.o test/libnewhopearm.a $(LDSCRIPT) libs/libopencm3/lib/libopencm3_stm32f0.a
	$(LD) -o test/server.elf test/server.o test/libnewhopearm.a $(LDFLAGS) libs/libopencm3/lib/libopencm3_stm32f0.a
	@rm -f test/server.o
	@rm -f test/server.d


test/speed.elf: $(STMOBJ) test/libnewhopearm.a test/speed.o print.o
	$(LD) $(CFLAGS) $(STMOBJ) $(INCDIRS) -T $(LINKERFILE) print.o test/speed.o test/libnewhopearm.a -o $@
	@rm -f test/speed.o

test/memsize.elf: $(STMOBJ) test/memsize.o print.o test/libnewhopearm.a
	$(LD) $(CFLAGS) $(STMOBJ) $(INCDIRS) -T $(LINKERFILE) print.o test/memsize.o test/libnewhopearm.a -o $@
	@rm -f test/memsize.o
	@rm -f print.o
	@rm -f *.d
	@rm -f test/*.d


%.bin: %.elf
	$(OBJCOPY)   -O binary $^ $@

%.o: %.s
	$(LD) $(CFLAGS) -c $^ -o $@

%.o: %.c
	$(LD) $(CFLAGS) -o $@ -c $<

clean:
	@find . -name \*.o -type f -exec rm -f {} \;
	@find . -name \*.d -type f -exec rm -f {} \;
	-rm -f test/*.elf
	-rm -f test/*.bin
	-rm -f test/*.a
