/* tools/fixtures/libsel4_reach_probe.c -- OUR OWN probe over the vendored,
 * BSD-2-Clause libsel4 userlevel headers. It reproduces no seL4 line; it
 * includes seL4's headers, which the license read of `20260821.041056`
 * established we may link rather than only study.
 *
 * What it asks: does the hand-written half of the libsel4 userlevel core
 * compile under our own toolchain, freestanding riscv64, with no CMake and no
 * kernel build -- and what capability vocabulary does it hand a root task?
 *
 * The counts are read from the compiled enums rather than recited, so a
 * vendored bump that moves seL4's vocabulary reds this probe rather than
 * passing quietly beneath a design that assumed the older shape.
 */
#include <sel4/simple_types.h>
#include <sel4/objecttype.h>
#include <sel4/sel4_arch/objecttype.h>
#include <sel4/arch/objecttype.h>
#include <sel4/errors.h>
#include <sel4/constants.h>

/* invariant: the error enum's terminator counts every error a capability
   invocation may answer with -- the whole refusal vocabulary Caravan's
   supervision must map onto, stated positively as a bound. */
seL4_Word probe_error_count(void) { return (seL4_Word) seL4_NumErrors; }

/* invariant: object types chain generic -> mode -> arch, each tier starting
   where the one beneath it ended, so the arch terminator counts them all. */
seL4_Word probe_object_count(void) { return (seL4_Word) seL4_ObjectTypeCount; }
seL4_Word probe_nonarch_object_count(void) { return (seL4_Word) seL4_NonArchObjectTypeCount; }

/* invariant: a word is the machine word the root task and kernel share; the
   probe reports its width so a 32-bit drift cannot pass unnoticed. */
seL4_Word probe_word_bits(void) { return (seL4_Word) (sizeof(seL4_Word) * 8); }

/* invariant: the highest schedulable priority is one below the count. */
seL4_Word probe_max_prio(void) { return (seL4_Word) seL4_MaxPrio; }
