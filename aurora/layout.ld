/* aurora/layout.ld — where a freestanding stage lives in memory.
 *
 * QEMU's `virt` machine begins executing at the base of RAM, 0x8000_0000, so we
 * lay `_start` down there and make it the entry. `.text.init` is placed first,
 * so the very first instruction the machine runs is the one that gives the hart
 * its stack. Orphan sections the toolchain may emit — unwind tables, attributes —
 * are discarded, so nothing can slip in ahead of `_start` at the reset address.
 * Small-data sections are folded into their parents, so a global never lands in
 * an unplaced section near address zero. */
ENTRY(_start)
SECTIONS {
  . = 0x80000000;
  .text : { KEEP(*(.text.init)) *(.text*) }
  .rodata : { *(.rodata*) *(.srodata*) }
  .data : { *(.data*) *(.sdata*) }
  .bss : { *(.bss*) *(.sbss*) *(COMMON) }
  /DISCARD/ : { *(.eh_frame) *(.eh_frame_hdr) *(.riscv.attributes) *(.comment) }
}
