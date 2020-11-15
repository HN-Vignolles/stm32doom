ENTRY(Reset_Handler)

/* Internal Memory Map*/
MEMORY
{
	rom (rx)	: ORIGIN = 0x08000000, LENGTH = 2048K
	ram (rwx)   : ORIGIN = 0x20000000, LENGTH = 256K
	sdram (rwx) : ORIGIN = 0xD004B000, LENGTH = 7892K /* first 300K is used as LCD frame buffer */
}

/* Section Definitions */ 
SECTIONS 
{
	/* external SDRAM */
	.sdram (NOLOAD) :
	{
		. = ALIGN(4);
		*(.sdram .sdram.*)
		bin/chocdoom/i_video.o(COMMON)
		bin/chocdoom/r_bsp.o(COMMON)
		bin/chocdoom/w_wad.o(COMMON)
		bin/chocdoom/r_main.o(COMMON)
		bin/chocdoom/r_plane.o(COMMON)
	} > sdram
	
	.isr_vector :
	{
		. = ALIGN(4);
		KEEP(*(.isr_vector))
		. = ALIGN(4);
	} > rom
	
	/* program code */
	.text : 
	{
		. = ALIGN(4);
		*(.text)
		*(.text*)
		*(.gnu.linkonce.t.*)
		*(.glue_7)
		*(.glue_7t)
		*(.eh_frame)
		KEEP(*(.init))
		KEEP(*(.fini))
		. = ALIGN(4);
		_etext = .;
	} > rom

	.rodata :
	{
		. = ALIGN(4);
		*(.rodata)
		*(.rodata*)
		*(.gnu.linkonce.r.*)
		. = ALIGN(4);
	} > rom
	
	.ARM.extab : { *(.ARM.extab* .gnu.linkonce.armextab.*) } > rom

	.ARM : {
		__exidx_start = .;
		*(.ARM.exidx*)
		*(.gnu.linkonce.armexidx.*)
		__exidx_end = .;
	} > rom
	
	/*. = ALIGN(4);
	_etext = .;
	_sidata = .;*/

	_sidata = LOADADDR(.data);
	
	/* initialized data */
	.data : /* AT (_etext) */
	{
		. = ALIGN(4);
		_sdata = .;
		*(.data)
		*(.data*)
		. = ALIGN(4);
		_edata = . ;
	} > ram AT> rom

	/* uninitialized data */
	.bss (NOLOAD) : 
	{
		_sbss = . ;
		*(.bss)
		*(.bss*)
		*(COMMON)
		. = ALIGN(4);
		_ebss = . ;
	} > ram
	
	/* stack section */
	.stack (NOLOAD):
	{
		. = ALIGN(8);
		*(.stack .stack.*)
	} > ram

	/* heap section */
	.heap (NOLOAD):
	{
		*(.heap .heap.*)
	} > ram
	
	. = ALIGN(4); 
	_end = . ;
}
