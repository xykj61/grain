# The libsel4 Reach, and the Vocabulary Caravan Inherits

**Language:** EN
**Stamp:** `20260821.043831`
**Voice:** Kyri
**Status:** Living -- measured on metal this round
**Arc:** the Lindy-priority Microkernel Target double-seat, **Equinox 1 -- Caravan on the microkernel**
**Witness:** [`../tools/microkernel_libsel4_reach_witness.rish`](../tools/microkernel_libsel4_reach_witness.rish) -- GREEN
**Kin:** [`the microkernel license read`](20260821-041056_the-microkernel-license-read.md) - [`the microkernel target and the OS-parity question`](20260817-185851_microkernel-target-and-the-os-parity-question.md) - [`the study-weight recenter`](20260819-094721_microkernel-target-study-weight-recenter.md)

---

## What you can now do that you could not do yesterday

An Acme Corporation employee designing a supervised root task on seL4 has, until this round, been designing against a description. The kernel was read as copyleft whole, so the honest posture was clean-room study, and the toolchain question was answered against a capability-shaped stub written in this tree rather than against seL4's own API.

The license read of `20260821.041056` moved that line, and it moved it in the half that matters. seL4 splits its licensing: the **kernel** is GPL-2.0, and the **userlevel** -- `libsel4`, its libraries, its tools, its syscall headers -- is **BSD-2-Clause**. seL4's own `LICENSE.md` says the kernel's GPL *"does not cover user-level code that uses kernel services by normal system calls,"* and that such usage *"does not fall under the heading of 'derived work'."* A root task lives on the userlevel side of that sentence. So `libsel4` may be **included and linked**, rather than only studied through a wall.

The fetch was granted the same night and swept per file. This round asks the question that grant makes askable: **does seL4's own published userlevel API compile under our compiler, freestanding, for the architecture the arc brings up first?**

It does. And the more useful finding is exactly where it stops.

## What was measured

Everything below is read from a compiled artifact or from a program that ran. The witness builds our own probe over seL4's headers twice -- once freestanding for riscv64, once for this host beside a reporter -- and reads the numbers out of the compiled enums rather than reciting them from a manual.

| Measured `20260821.043831` | Value |
|---|---|
| Freestanding riscv64 object, `e_machine` read from its own ELF header | **243** (RISC-V) |
| Dynamic `NEEDED` entries in that object | **0** -- no libc beneath it |
| Refusal codes a capability invocation may answer with (`seL4_NumErrors`) | **11** |
| Object types on riscv64 (`seL4_ObjectTypeCount`) | **9** |
| Architecture-independent object types (`seL4_NonArchObjectTypeCount`) | **5** |
| `seL4_Word` width | **64 bits** |
| Highest schedulable priority (`seL4_MaxPrio`) | **255** |
| Included headers carrying their own `BSD-2-Clause` tag | **6 of 6** |
| Included headers carrying a `GPL` tag | **0** |
| seL4 generator modules present on this pier (`jinja2`, `ply`) | **0 of 2** |

No CMake ran. No kernel was built. No capability was invoked, and no hardware was touched.

## The boundary, named by walking into it

`libsel4` is written in two halves. One half is hand-written C headers, checked into the repository as they read. The other half seL4 generates at build time, with its own Python tools, from XML interface descriptions and bitfield specifications.

The hand-written half compiles today, freestanding, with nothing beneath it. The generated half stops at exactly one missing file, and the witness proves that by reaching for it and reading the refusal:

| Header | Reaches |
|---|---|
| `sel4/simple_types.h`, `sel4/errors.h`, `sel4/constants.h`, `sel4/macros.h` | **compiles** |
| `sel4/objecttype.h` plus its `sel4_arch` and `arch` tiers | **compiles** |
| `sel4/types.h`, `sel4/syscalls.h`, `sel4/bootinfo.h`, `sel4/faults.h`, `sel4/sel4.h` | stop at `sel4/sel4_arch/types_gen.h` |

One generated header gates the rest. Producing it wants `bitfield_gen.py`, which imports **ply**; the syscall and invocation headers beside it want **jinja2**. This pier carries neither, and installing them changes the machine rather than the tree -- so it is surfaced as a small, cheap, named environment gate rather than crossed.

The gate is measured rather than assumed. [`tools/fixtures/libsel4_generator_deps_scan.sh`](../tools/fixtures/libsel4_generator_deps_scan.sh) counts what is missing and prints an integer, so a pier that later carries both modules reports `0` and the rest of the userlevel surface opens with no change to the witness at all.

## The vocabulary Caravan inherits

Here is the reading that makes the numbers worth having.

**Eleven refusals, and Caravan has four.** seL4 answers a capability invocation with one of eleven named errors: no error, invalid argument, invalid capability, illegal operation, range error, alignment error, failed lookup, truncated message, delete first, revoke first, not enough memory. `caravan/capabilities.rye` today names four outcomes -- allowed, no such dependent, no such resource, rights insufficient. Those four map cleanly onto seL4's *invalid capability*, *failed lookup*, and *illegal operation*, and the seven that remain are the ones a hosted policy table has never had to answer: **delete first** and **revoke first** are the derivation tree speaking, **not enough memory** is untyped retyping speaking, and **truncated message** is the IPC buffer speaking. Each names a real refusal Caravan's supervision will owe an answer to once it sits on a kernel rather than above one. That is a design list, arrived at by measurement.

**Five portable object types, and four more that are the architecture's.** The architecture-independent core is small and complete: **untyped** memory, a **TCB**, an **endpoint**, a **notification**, and a **capability table**. Everything else on riscv64 -- the giga page at the mode tier, then the four-kilobyte page, the mega page, and the page table at the arch tier -- belongs to the architecture, read from the headers rather than recalled. The chain is worth noticing on its own: the generic enum ends at `seL4_NonArchObjectTypeCount`, the mode tier *begins* there, and the arch tier begins where the mode tier ended, so the three tiers compose into one numbering with no overlap and no gap. That is the same compose-not-braid shape this tree already reaches for, arrived at independently by a formally verified kernel, and it is a good sign for the design that has to meet it.

**One word, and a bounded priority space.** `seL4_Word` is 64 bits on this target and every priority fits in a byte with 255 at the top. Both are bounds a supervision tree can assert at construction rather than discover at runtime, which is exactly what TAME asks of every table Caravan already keeps.

**Supervision is a userlevel matter, and that is the whole invitation.** seL4 provides no supervision tree. It provides endpoints, notifications, thread control blocks, and a capability space, and leaves policy entirely above the line. Caravan's ordered stages, bounded dependent table, and named refusals are therefore not competing with anything the kernel does; they are the thing the kernel expects someone to write. The arc's Caravan-before-Tally ordering reads better for knowing that.

## What this round does not claim

No kernel booted, so nothing here proves a capability invocation succeeds -- only that the vocabulary compiles and the calling convention is available. The generated half of the userlevel core stands unmeasured, behind the named gate. And a Rye binding over these headers is design work not yet begun; this round establishes that the ground is real, not that the building stands on it.

## The next rungs, in order

1. ~~**Design Caravan's refusal mapping** against the eleven, in Rye, on the hosted ground it already runs on~~ -- **LANDED `20260821.050317`**. [`caravan/refusals.rye`](../caravan/refusals.rye) states the whole eleven, maps Caravan's four onto them totally, and names for each of the seven remaining which subsystem owes the answer -- the derivation tree for delete-first and revoke-first, untyped retyping for not-enough-memory, the IPC buffer for truncated-message, and argument, bounds, and alignment checking for the rest. The eleven symbols and their order are diffed against this header at run time by [`tools/caravan_refusals_witness.rish`](../tools/caravan_refusals_witness.rish), GREEN on metal with both RED paths proven, so a vendored bump that moves the vocabulary reds the rung on the lap it lands.
2. **Open the generator gate** when convenient, by adding `jinja2` and `ply` to the pier's Python environment, which unlocks `types.h`, `syscalls.h`, `bootinfo.h`, `faults.h`, and the `sel4.h` umbrella in one step. Environment change, so it is Keaton's word.
3. **A root-task skeleton** freestanding for riscv64 once the generated headers stand, linking `libsel4` rather than a stub.
4. **Aurora on RISC-V under QEMU**, where Equinox 4's close waits: the parity-witness happy-zone suite running GREEN on the new target, which is the proof that ends the arc.

*A verified kernel offers a small, honest vocabulary and asks the userland to mean something with it. This round read that vocabulary in its own words, wrote down exactly where the reading stops, and left the design one clear step better grounded than it was an hour ago.*
