/* tools/fixtures/libsel4_reach_include/autoconf.h -- OUR OWN configuration header for
 * the libsel4 reach probe. No seL4 source appears here.
 *
 * libsel4's hand-written headers read a handful of CONFIG_ macros from the
 * autoconf.h that seL4's CMake build generates from a kernel configuration.
 * The probe never builds a kernel, so it supplies the few macros the
 * hand-written core actually reads, at the values a 64-bit RISC-V build uses.
 *
 * Say why: CONFIG_WORD_SIZE fixes seL4_Word at 64 bits, which is the word the
 * qemu-riscv-virt target runs; CONFIG_NUM_PRIORITIES is seL4's own default
 * scheduling-priority count and only feeds seL4_MaxPrio in constants.h.
 */
#pragma once

#define CONFIG_WORD_SIZE 64
#define CONFIG_NUM_PRIORITIES 256
