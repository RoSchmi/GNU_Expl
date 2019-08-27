
set OPTIONS_ARCH=-mthumb -mcpu=cortex-m0
set OPTIONS_OPTS=-Os   
set OPTIONS_COMP=-g -Wall
rem OPTIONS_LINK: = -Wl,--gc-sections,-Map=map.rpt,-lgcc,-lc,-lnosys -ffunction-sections -fdata-sections
rem -Wl (will make that the compiler will not drop linker options)
rem --gc-sections (enable Garbage collection of unused input sections)
rem -Map=map.rpt (print a mapfile to the file map.rpt)
rem -lgcc (makes that there are no unresolved references to gcc-library if options '-nostdlib' or '-nodefaultlibs' are used)
rem -lc (is automatically added by gcc-compiler unless option '-nostdlip' is there. Makes linker search in Standard C-library)
rem -lnoosys (lets the linker use the 'nosys' library and create separate ELF sections which can be omitted if not used)  
set OPTIONS_LINK=-Wl,--gc-sections,-Map=map.rpt,-lgcc,-lc,-lnosys -ffunction-sections -fdata-sections
set SEARCH_PATH1=CMSIS\Include
set SEARCH_PATH2=CMSIS\LPC1113\Include
set LINKER_SCRIPT=lpc1113F_301.ld
rem set LINKER_SEARCH="C:\Program Files (x86)\GNU Tools ARM Embedded\8 2018-q4-major\share\gcc-arm-none-eabi\samples\ldscripts"
set LINKER_SEARCH="C:\Users\Roland\source\GNU_Expl\Book\Lpc1113F_301_blinky"
rem Newlib-nano feature is available for v4.7 and after 
set OPTIONS_LINK=%OPTIONS_LINK% --specs=nano.specs

rem Compile the project
arm-none-eabi-gcc                         ^
   %OPTIONS_COMP% %OPTIONS_ARCH%          ^
   %OPTIONS_OPTS%                         ^
   -I %SEARCH_PATH1% -I %SEARCH_PATH2%    ^
   -T %LINKER_SCRIPT%                           ^
   -L %LINKER_SEARCH%                           ^
   %OPTIONS_LINK%                               ^
   CMSIS\LPC1113\Source\gcc\startup_LPC11xx.S   ^
   blinky.c                                     ^
   CMSIS\LPC1113\Source\system_LPC11xx.c        ^
   -o blinky.elf
if %ERRORLEVEL% NEQ 0 goto end

rem Generate disassembled listing for debug/checking
arm-none-eabi-objdump -S blinky.elf > list.txt

rem For Keil MDK flash programming
copy blinky.elf MDK_debug\Objects\blinky.axf
if %ERRORLEVEL% NEQ 0 goto end
copy blinky.elf MDK_debug\Objects\blinky.elf
if %ERRORLEVEL% NEQ 0 goto end
copy blinky.elf MDK_debug\blinky.elf
if %ERRORLEVEL% NEQ 0 goto end

rem Generate binary image file
arm-none-eabi-objcopy -O binary blinky.elf blinky.bin
if %ERRORLEVEL% NEQ 0 goto end

rem Generate Hex file (Intel Hex format)
arm-none-eabi-objcopy -O ihex   blinky.elf blinky.hex
if %ERRORLEVEL% NEQ 0 goto end

rem Generate Hex file (Verilog Hex format)
arm-none-eabi-objcopy -O verilog   blinky.elf blinky.vhx
if %ERRORLEVEL% NEQ 0 goto end

:end
pause
