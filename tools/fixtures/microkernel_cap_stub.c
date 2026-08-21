/* tools/fixtures/microkernel_cap_stub.c -- a capability-IPC-SHAPED C stub, authored here, standing in for the kind of C library a
 * capability microkernel exposes to its root task. Rung of the Microkernel Target arc's Equinox 3 question (Season G's neighbour arc).
 *
 * CLEAN ROOM, SAID PLAINLY. This file reproduces NO line and NO header from seL4, Genode, or any other kernel. seL4 is GPLv2 and Genode
 * is AGPLv3; both are studied for design concepts only and neither is fetched (.claude/rules/gratitude-licenses.md). The names below are
 * our own. What is being probed is the MECHANISM every such kernel requires of a client -- a freestanding binary, no libc, calling a C ABI
 * that traps into the kernel -- not any particular kernel's API surface.
 *
 * The shape: a capability is an opaque integer handle; an invocation takes a capability, a message label, and a word, and returns a word.
 * That is the common denominator of capability IPC across the family, and it is all the probe needs to answer whether Rye can reach it.
 */

#include <stdint.h>

/* The word a capability invocation carries. 64-bit on every target this probe builds for. */
typedef uint64_t cap_word;

/* An opaque capability handle -- an index into a table the kernel owns, never a pointer the client may follow. */
typedef uint64_t cap_handle;

/* Stand in for the kernel trap. A real kernel would issue a syscall instruction here; the probe returns a deterministic fold of its
 * arguments so a caller can prove the ABI carried every one of them across the boundary intact. */
cap_word cap_invoke(cap_handle capability, cap_word label, cap_word word);
cap_word cap_invoke(cap_handle capability, cap_word label, cap_word word) {
    return (capability * 1000000u) + (label * 1000u) + word;
}
