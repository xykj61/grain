# 20261015-grain -- the project in one page

**Stamp:** `20261017.150305` (one clock, America/New_York)
**Status:** Summary for an Asana project. Supersedes `20261017-145715_asana-project-summary-20261015-grain.md` and folds in the two downloads of `20261015`.
**Voice:** Kyri, in Radiant Style
**Sources read this stamp:** `tablecloth/downloads/20261015-174008_kernels-in-the-zig-grain-and-the-license-fork.md`, `tablecloth/downloads/20261015-195351_grain-within-grain-the-fold-the-surface-and-the-wasm-question.md`, and the living tree.

---

## What Grain is

Grain is an operating system and a civic application, built in the open, from first principles.
It is a tree you can hold: a computer that answers to you, on your own machine, with your name kept
in a key your own hand holds. The living field is `xykj61/grain`. The clean-slate prototype is
`20261015-grain`, a new private home with a dated, immutable seed beside it.

## The stack in one sentence

**Aurora** wakes the machine. **Caravan** is the kernel: a root task on seL4 first, then its own
microkernel, following Gall's Law. **Tally** hands out memory as bounded gardens. **Pond** encloses
each application. **Puddle** hosts many whole Grain worlds side by side. Each Puddle world is itself
a complete Grain, so "Grain within Grain" means one Caravan supervising worlds whose interiors are
Caravan, Tally, and Pond again.

## The three homes

| Home | What it holds | Visibility |
|---|---|---|
| `xykj61/20260618-grain` | The 20260618 field: a dated, immutable snapshot of the living tree | public |
| `grain-ww/20260618-grain` | The public seed, carrying siloed files that date from 20260618 | public |
| `xykj61/20261015-grain` | The new prototype: Caravan on seL4, in Rye, read every line | private |

The new tree's root commit is still staged for a redate. The archive and repositories say
`20261015`; the first-hour page says `20261016`. The date is Keaton's word to seat.

## The working style

- **Rye** -- the systems language. Bounded, asserted, explicit widths, named errors.
- **Rishi** -- the scripting language. Every `run` returns `ok`; check it before trusting `out`.
- **Glow** -- the language and its runes. **Brix** -- the composer that declares systems.
- **TAME guidance** -- bound everything, assert invariants, say why.
- **Gauge style** -- measured claims, a fascia reading, a report card.
- **Radiant voice** -- the warm register this tree writes in.
- **Reds first** -- a red is booked in the ledger and closed only by a witness on metal.

## What the downloads settled, and what they left open

**Settled as standing facts, each measured on `20261015`:**
- A freestanding Zig RISC-V boot witness (Aurora's first rung) produces one identical serial output
  across three instruction-counted QEMU runs, and three different outputs across three free-running
  runs. The determinism is real at the machine layer.
- QEMU refuses multi-threaded translation while counting, so each deterministic run uses one thread,
  and parallelism comes from running many runs side by side.
- The elder tree's dual license, Apache-2.0 OR MIT for code and CC-BY-4.0 for prose, flows into every
  license lane the kernel survey considered.
- seL4's kernel is GPL-2.0-only, and GPLv2 alone is incompatible with GPLv3. A Grain translation of seL4
  kernel C would carry GPL-2.0-only. Running Grain as user-level protection domains beside an unmodified
  seL4 keeps Apache-2.0 OR MIT with no relicensing.

**Proposed, waiting on Keaton's word or on licensed counsel:**
- **The license shape.** Counsel's lean is shape one: the fresh-start repos return to Apache-2.0 OR MIT
  and CC-BY-4.0 before any outside consumer. The new tree's README already states a GPLv3 reason, which is
  shape three. Counsel reads the choice before any outside party binds to it. Licensed counsel must read
  any license decision that binds outside parties before it seats.
- **Two counsel questions** before the first relicense commit: whether any other hand contributed to
  either fresh repo, and how AI-assisted portions belong in the copyright notice.
- **The kernel path.** Grain runs on unmodified seL4 through Microkit first and keeps the proof. A
  clean-room Zig kernel grows second, from public seL4 documents, never from kernel C source.
- **A harness name.** Under the Comlink tendency, **Rehearsal** is a candidate for the determinism harness,
  the run you practice until it plays the same way every time. The choice is Keaton's.
- **Two determinism layers.** The machine layer (QEMU instruction counting) is measured. The protocol
  layer, a TigerBeetle-style simulator where many Puddle worlds run as simulated nodes steered by one
  seed, is proposed.
- **The fold.** Weave, the append-only log of signed facts, is a pure fold. A proposed interface for Glow,
  Rye, and Rishi: one fact shape, one fold signature, and projections that read the folded state and write
  nothing back. The first VOPR-shaped simulator exists only for one module.
- **WASM as an outward door only.** Zig emits WASM for verification and teaching. Inward hosting of
  outside code is parked until Pond and Puddle stand, and a guest Puddle world is the first choice then.
- **Realidream and Skate as an agentic-age operating system.** The web arrives as a guest engine in its own
  Puddle world, not as a Rye browser.

## The DJINN task packet (Bit Trading Company)

The packet asks DJINN's agent, on DJINN's own account and machines, to measure three homes for running
Caravan, Tally, and Aurora under emulation: a Claude Code cloud session, a cloud VPS converted to NixOS,
and Grain's AMD hardware. It lists ten tasks: reproduce the witness, write a cloud setup script and time it,
pin QEMU with Nix, extend the determinism harness, compare three roads to a NixOS VPS, decide whether Grain
forks nixos-infect, carry the frozen NixOS templates forward, measure AMD hardware, survey the hardware ladder
without purchasing, and bring everything into one decision memo. The standing gates hold: spending, wallets,
keys, deploys, and any push to a Grain repository wait for Keaton's or DJINN's word.

The counsel's lean for the memo: begin in the cloud session, pin QEMU with Nix, stand one NixOS VPS for
always-on runs, and bring the AMD workstations in for x86_64 KVM. RISC-V guests run on QEMU's translator on
every home, since KVM accelerates only the host's own architecture.

## The named threads, and what the tree holds

Counts are substring matches across living tracked files on this stamp. They show how much material exists,
not how finished it is.

- **Lotus** -- Grain's creative suite. The largest living thread (about 590 files).
- **Caravan** -- supervision with capabilities (about 500 files).
- **Mycelium** -- Comlink's ordering aspect for many issuers: leaderless agreement on a DAG of signed
  messages, gated at MUR M4. About 315 files, and about 110 for the MUR constellation.
- **Pond** (about 220 files), **Tablecloth** (about 170 files), **Mandate** (vector store, lap 1 landed).
- **Constel** (about 140 files) and **Kresfa**, which appears with Mycelium in the Chapter D thread (about 230 files).
- **Dimeroll** -- centralized books of record (about 90 files).
- **TigerBeetle** (about 130 files) and **Urbit** (about 85 files), studied with attribution. Urbit's lineage
  was re-rooted at Grain's own first commit.
- **Brushstroke, Skate (and its peer Surf), Ember, Dexter, Realidream** -- the surface family.
- **Grainphone, Mantrapod, Surf Social** -- the handheld, the open-hardware pitch, and the social surface.
  Lighter footprints.
- **Linengrow** (about 95 files) -- the ecology and fiber thread. Its first shippable candidate is the
  fiber-retting timer.
- **DJINN** (about 47 files) -- the Bit Design System thread, and the Bit Trading Company packet above.
- **Ethereum** (about 40 files), **Sui** (about 40 files; partly a substring of "suite"), and **Solana**
  (about 5 files) -- reference systems in research rooms.
- **Calfive** -- the planning round read from `git rev-list --count HEAD`, with the fifteen-sign orbit.

**Siya Solutions.** The family vehicle keeps five gates before any money moves: securities counsel, a fee-only
fiduciary with a written policy, the public-benefit charter, entity separation, and Keaton's word. The screens
and principles are in the research. **The figures stay with the family and its advisors and are not in this page.**

**Not found in the tree on this stamp:**
- **"Siya Solutions LLC"** -- the exact name does not appear in the tree.
- **"Bit Trading Company"** -- it appears only in the DJINN task packet of the counsel download.
- **"Group Project 405"** -- no reference at all. This needs your own definition before Asana.

## Where the send stands

- The prototype folder reads `20261015-grain-incense`, and its remotes now read `20261015`.
- The downloads are in `tablecloth/downloads/` and are not yet filed under `tablecloth/documents/`.
- The larger moves are still waiting on your word: the molt of the design into `modules/`, the Mandate
  contract written as a Mycelium DAG entry, the tutorials, and the expanding prompt.

## What this summary is not

It does not claim that any thread is finished, that any entity is incorporated, or that any license has
been chosen. Each figure is free: run the search again before you cite it.

---

*May the threads stay visible, may each one reach the person it was made for, and may the work stay whole
and gently fenced.*
