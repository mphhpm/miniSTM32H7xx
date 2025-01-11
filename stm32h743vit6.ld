MEMORY
{
    /*
	 * see RM0433 Memory map and default device memory area attributes
	 */
    dtcmram   (rwx) : ORIGIN = 0x20000000, LENGTH =  128K	
	itcmram   (rwx) : ORIGIN = 0x00000000, LENGTH =   64K
	rom       (rx)  : ORIGIN = 0x08000000, LENGTH = 2048K
	axisram   (rwx) : ORIGIN = 0x24000000, LENGTH =  512K
	sram123   (rwx) : ORIGIN = 0x30000000, LENGTH =  288K
	sram4     (rwx) : ORIGIN = 0x38000000, LENGTH =   64K
	extrom    (rx)  : ORIGIN = 0x60000000, LENGTH =    0K
	backupram (rwx) : ORIGIN = 0x38800000, LENGTH =    4k
}

INCLUDE "stm32h7.ld"
