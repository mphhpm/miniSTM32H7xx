ENTRY(Reset_Handler)

SECTIONS
{
	.text : {
		. = ALIGN(4);
		*(.isr_vector)
		*(.text)
		*(.text*)
		*(.glue_7)
		*(.glue_7t)
		*(.eh_frame)

	    KEEP (*(.isr_vector))
	    KEEP (*(.init))
    	KEEP (*(.fini))
		
		. = ALIGN(4);
    	_etext = .;        /* define a global symbols at end of code */
    	} >rom
	
	/* Constant data goes into rom */
	.rodata :
	{
		. = ALIGN(4);
		*(.rodata)         /* .rodata sections (constants, strings, etc.) */
		*(.rodata*)        /* .rodata* sections (constants, strings, etc.) */
		. = ALIGN(4);
	} >rom
	
	.preinit_array : {
		. = ALIGN(4);
		__preinit_array_start = .;
		KEEP (*(.preinit_array))
		__preinit_array_end = .;
	} >rom
	
	.init_array : {
		. = ALIGN(4);
		__init_array_start = .;
		KEEP (*(SORT(.init_array.*)))
		KEEP (*(.init_array))
		__init_array_end = .;
	} >rom

	.fini_array : {
		. = ALIGN(4);
		__fini_array_start = .;
		KEEP (*(.fini_array))
		KEEP (*(SORT(.fini_array.*)))
		__fini_array_end = .;
	} >rom

	.ARM.extab : {
		*(.ARM.extab*)
	} >rom
 
	.ARM.exidx : {
		__exidx_start = .;
		*(.ARM.exidx*)
		__exidx_end = .;
	} >rom
	 . = ALIGN(4);
	 _etext = .;

	.noinit (NOLOAD) : {
		*(.noinit*)
	} >axisram
	. = ALIGN(4);
 
   /* Used by the startup to initialize data */
     _sidata = LOADADDR(.data);
 
	.data : {
		_data = .;
		_sdata = .;
		*(.data*)
		*(.ramtext*)
		. = ALIGN(4);
		_edata = .;
	} >axisram AT >rom
	_data_loadaddr = LOADADDR(.data);
    
	.bss : {
        . = ALIGN(4);
        _sbss = .;
		*(.bss)
		*(.bss*)
		*(COMMON)
		. = ALIGN(4);
		_ebss = .;
	} >axisram

    .itcm : {
        . = ALIGN(4);
        _sitcm = .;
		KEEP (*(.itcm))
        *(.itcmram)
        *(.itcmram*)
        . = ALIGN(4);
        _eitcm = .;
    } >itcmram AT> rom
	_itcm_loadaddr = LOADADDR(.itcm);
	.dtcm : {
        . = ALIGN(4);
        _sdtcm = .;
        KEEP (*(.dtcm))
        *(.dtcmram)
        *(.dtcmram*)
        . = ALIGN(4);
        _edtcm = .;
  } >dtcmram

    .backup : {
        . = ALIGN(4);
        _sbackup = .;
		KEEP (*(.backup))
        *(.backupram)
        *(.backupram*)
        . = ALIGN(4);
        _ebackup = .;
    } > backupram

	. = ALIGN(4);
	end = .;
}

PROVIDE(_stack = ORIGIN(axisram) + LENGTH(axisram));
PROVIDE(_etack = ORIGIN(axisram));
_estack = ORIGIN(axisram) + LENGTH(axisram);
_stack = ORIGIN(axisram) + LENGTH(axisram);
