# The Microkernel License Read -- and the Premise It Overturns

**Stamp:** `20260821.041056` - **Status:** Living (verification record) - **Voice:** Kyri - **Style:** Radiant
**Gate:** the per-component license read named in [`the microkernel target and the OS parity question`](20260817-185851_microkernel-target-and-the-os-parity-question.md), blind spot one -- **granted by Keaton `20260821`**
**Kin:** [`.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md) - [`the study-weight recenter`](20260819-094721_microkernel-target-study-weight-recenter.md) - [`the toolchain question answered`](20260817-185851_microkernel-target-and-the-os-parity-question.md#addendum----the-toolchain-question-answered-on-metal-20260821040637)

---

## What this closes, and what it opens

The Microkernel Target arc carried two gates on its Equinox 1 and 3. The **toolchain gate** closed hours ago and the answer was yes-by-freestanding. This is the **license gate**, granted and now read -- each component's license verified from its own authoritative text rather than from memory, exactly as the study asked when it marked two of them *to verify*.

The read produced a finding large enough to reorder the arc's design. **The study's central premise about seL4 is wrong in the half that matters.**

## The verified table

| Component | License, verified | Source | Verdict for this tree |
|---|---|---|---|
| **seL4 kernel** | **GPL-2.0** | [`seL4/LICENSE.md`](https://github.com/seL4/seL4/blob/master/LICENSE.md) | copyleft -- **study only**, no source in our history |
| **seL4 userlevel (libsel4, libraries, tools)** | **BSD-2-Clause** | same | **permissive -- a genuine dependency is thinkable** |
| **seL4 syscall headers** | **BSD-2-Clause** | same | permissive |
| **seL4 Microkit** | **BSD-2-Clause** (code), CC-BY-SA-4.0 (docs) | [`seL4/microkit`](https://github.com/seL4/microkit) `LICENSE.md` | permissive |
| **LionsOS** | **BSD-2-Clause** (code), CC-BY-SA-4.0 (docs) | [`au-ts/lionsos`](https://github.com/au-ts/lionsos) `LICENSE.md` | permissive |
| **Genode** | **AGPLv3** + an open-source linking clause; dual-licensed commercially by Genode Labs | [`genode.org/about/licenses`](https://genode.org/about/licenses) | strong copyleft -- **study only**, unchanged |
| **s6 / skalibs** | **ISC** | `COPYING`, skarnet | permissive -- already recorded, now verified |
| **musl** | **MIT** | [`musl COPYRIGHT`](https://git.musl-libc.org/cgit/musl/plain/COPYRIGHT) | permissive |

## The finding, stated plainly

seL4's own `LICENSE.md` splits the project in two and then says what the split means:

- *"Generally, kernel-level code is licensed under GPLv2"* and *"user-level code under the 2-clause BSD license."*
- The GPL **"does *not* cover user-level code that uses kernel services by normal system calls"**, and such usage **"does *not* fall under the heading of 'derived work'."**
- *"Syscall headers are provided under BSD."*

Read that against what Caravan actually is. **Caravan is a userland supervisor -- a root task.** It sits above the kernel, links the userlevel libraries, and reaches the kernel by ordinary system calls. Every one of those is the permissive side of the line, and the project states outright that doing so does not make a derived work of the GPL kernel.

So the study's conclusion --

> *"Fetch seL4/Genode to implement Caravan to completion" therefore means **clean-room study to completion**, not code incorporation.*

-- is **correct for Genode and for the seL4 kernel, and wrong for the seL4 userlevel.** Caravan may link `libsel4` as a real dependency, the way `vendor/monocypher` is a real dependency, rather than studying it through a clean-room wall it never needed.

That is the difference between designing *toward* a capability model from the outside and building *on* one. It removes the largest piece of unnecessary work the arc was carrying.

## What does not change

**The kernel stays study-only.** GPL-2.0 covers the kernel, and no kernel source enters our git history. Nothing in this read touches that.

**Genode is unchanged.** AGPLv3 with a linking clause is still strong copyleft, and the linking clause consents to linking with established open-source licenses rather than relieving anyone of the AGPL. Genode remains design-concept study, and its C++ component framework remains the harder fit that the toolchain probe deliberately did not address.

**Clean-room discipline still governs everything copyleft**, exactly as [`gratitude-licenses`](../.claude/rules/gratitude-licenses.md) already writes it. This read narrows *where* the wall stands; it does not lower it.

**Our own code stays our own.** A permissive licence permits linking; it does not make copying wise. Caravan is Rye, inheriting discipline rather than lines, exactly as it already does from s6.

## The caveat, named rather than smoothed over

[Issue #245](https://github.com/seL4/seL4/issues/245) on the seL4 repository reported in September 2020 that roughly fourteen files inside `libsel4` carried `GPL-2.0-only` headers despite the project's stated intent that user-level code be BSD -- RISC-V architecture headers, `include/sel4/functions.h`, and a `CMakeLists.txt` among them. The issue page shows no visible closure.

So the files themselves were checked rather than the issue. On `master` today, both `libsel4/include/sel4/functions.h` and `libsel4/sel4_arch_include/riscv64/sel4/sel4_arch/syscalls.h` -- two of the most prominent named -- carry **`SPDX-License-Identifier: BSD-2-Clause`**. The complaint appears resolved in practice even though the issue was never visibly closed.

**The obligation that follows is a per-file SPDX sweep at fetch time, not a blanket assumption.** A project that once shipped mixed headers can ship them again, and "the project intends BSD" is not a licence. Any fetch of the userlevel tree checks every file's own tag and records the result.

## What this unlocks, and what still waits

**Unlocked by this read:** designing Caravan directly against the seL4 userlevel API rather than through a clean-room wall; treating `libsel4`, Microkit, and LionsOS as permissive references that may be read closely and, on a later word, vendored the way Monocypher and PQClean are.

**FETCH GRANTED AND TAKEN `20260821.042612`** (Keaton: *I grant the fetch, vendor sel4 userlevel and microkit*). `vendor/sel4` and `vendor/microkit` are gitlink submodules -- no vendored source in our history. **The per-file SPDX sweep this document named as an obligation was run, and is now a standing check** ([`../tools/sel4_userlevel_license_witness.rish`](../tools/sel4_userlevel_license_witness.rish)): **185 of 185 libsel4 files tagged, all 185 BSD-2-Clause, zero GPL** -- issue #245 genuinely resolved, checked rather than assumed. The kernel counts **618** GPL tags, proving the split from both sides. Microkit is **303** BSD-2-Clause with **exactly two** GPL files, both board device-tree overlays under `custom_dts/` and neither linkable code, bounded **by path** so a new one elsewhere reds. Both RED legs proven on metal.

**Superseded below, kept for the record:** the fetch itself. The gate the study wrote is *"license read per component precedes any fetch"* -- the read comes first and its output is a verdict, which is what this document is. Bringing any of these into `vendor/` is the next step and a separate one, and it stays Keaton's word. Nothing has been cloned, vendored, or added to the tree by this document.

**Also still waiting:** hardware, which was never at issue here, and the Genode C++ question, which this read leaves exactly where it stood.

## The arc, after both gates

Equinox 3's toolchain question is answered yes. Equinox 1's license question is answered, and better than expected. What remains on the arc's crux -- **Caravan on the capability model** -- is now ordinary design and build work against a permissively-licensed userland API, with a formally verified kernel beneath it that we study and never copy.

*A gate opened carefully is worth more than a wall built where none was needed.*

**Sources:** [seL4 LICENSE.md](https://github.com/seL4/seL4/blob/master/LICENSE.md) - [What does seL4's license imply? (microkerneldude)](https://microkerneldude.org/2019/12/09/what-does-sel4s-license-imply/) - [seL4 issue #245](https://github.com/seL4/seL4/issues/245) - [seL4 Microkit](https://github.com/seL4/microkit) - [LionsOS](https://github.com/au-ts/lionsos) - [Genode licensing conditions](https://genode.org/about/licenses) - [musl COPYRIGHT](https://git.musl-libc.org/cgit/musl/plain/COPYRIGHT)
