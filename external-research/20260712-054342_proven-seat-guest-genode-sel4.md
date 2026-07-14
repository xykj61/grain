# Proven-Seat Guest — Genode, seL4, and Caravan’s Horizon

*Seam study 3. Claude’s counsel applied the tree’s own succession pattern to the kernel: NixOS now, sixos later; Rust for identity-bearing work, Zig as horizon — so for the seat beneath Caravan, borrow a proven capability microkernel and a living component OS this season, and keep Caravan’s name as the horizon. This study names seL4 and Genode/Sculpt as teachers, states guest-never-merger as law, and sketches the smallest witness that proves Rye userland on that seat without renaming anything we already grow. Research for understanding — no purchase, no Genode vendoring, no Caravan rewrite.*

**Stamp:** `20260712.054342`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety first, performance second, the joy of the craft third
**Category:** External research — survey and design study; recommends no dependency; every gate stays Kaeden’s
**Companions:** counsel [`../counsel/20260712-052806_claude-counsel-three-doors-and-teacher.md`](../counsel/20260712-052806_claude-counsel-three-doors-and-teacher.md) · hammock [`../active-designing/20260712-052806_seam-season-hammock.md`](../active-designing/20260712-052806_seam-season-hammock.md) · microkernel vs monolith [`yonder/20260619-171112_microkernel-vs-monolith-for-caravan.md`](yonder/20260619-171112_microkernel-vs-monolith-for-caravan.md) · seL4/Redox through TAME [`20260622-232912_sel4-redox-through-tame-rye.md`](20260622-232912_sel4-redox-through-tame-rye.md) · Caravan improvements [`../active-designing/yonder/20260622-232912_caravan-kernel-improvements.md`](../active-designing/yonder/20260622-232912_caravan-kernel-improvements.md) · s6/SixOS inheritance [`yonder/20260619-225212_s6-sixos-nix-infuse.md`](yonder/20260619-225212_s6-sixos-nix-infuse.md) · Seam study 2 [`20260712-054135_component-model-one-seed.md`](20260712-054135_component-model-one-seed.md) · Caravan README [`../caravan/README.md`](../caravan/README.md)
**Status:** Proposed — research for understanding, not advice; guest witness is a sketch; metal green waits on Kaeden’s word and a machine that can hold the seat
**Register:** checkable room for published seL4 / Genode claims; design-toward named as such
**Licenses (gratitude discipline):** seL4 — GPL-2.0-only for the kernel (study concepts; no link into Rye ship binaries without a deliberate license ruling). Genode — AGPLv3 for framework (study / separate host image; clean-room for our modules). Hold teachers in `gratitude/` or local clones per existing license table — never copy into `caravan/`.

*Written by Rio 3 for Kaeden · Seam season study 3.*

---

## The Question

What is the smallest guest witness that proves Rye userland on a proven seat without renaming Caravan?

## The Pattern We Already Trust

The tree already chose succession over fork-first:

| Domain | Now | Later |
|--------|-----|-------|
| Host composition | NixOS / living Linux tools | sixos horizon |
| Identity-bearing crypto posture | pragmatic hosts | Zig / Rye-native horizon |
| Kernel | **QEMU + hosted supervision seeds** (Caravan rings green today) | **Caravan as named kernel horizon** |

Writing Caravan from scratch as the *first* daily-usable seat is the compiler-fork pattern wearing a new name — and the tree already made the right call on that once. **Guest, never merger:** Rye userland (and Caravan’s *supervision* rings as userland processes where they fit) may run atop a proven seat this season; Caravan keeps its vocabulary, its ladder, and its horizon identity.

## What the Teachers Offer

### seL4 — the strongest assert TAME could ask of a seat

seL4 is a capability microkernel with a machine-checked proof (Isabelle/HOL) that the C implementation refines its specification and that capability integrity and information-flow isolation hold. TCB on the order of ~10K lines of C. IPC is the communication path; bulk data moves by page grant / shared regions — kin to Tally-bounded zero-copy already named in our microkernel study.

**Transfer:** a seat whose isolation is proven, not hoped. Capabilities as the only access model. Memory distributed explicitly, not by a hidden kernel allocator after boot.

**Leave:** C as the language of *our* kernel; `word_t` width drift; absorbing seL4’s API as Caravan’s surface. Caravan’s improvements brief already names explicit widths, assertions-as-spec, and Tally gardens as *our* climb toward that strength.

### Genode / Sculpt — the living component system atop a seat

**Genode** is a component framework: sandboxed services, capability-based routing, a long release cadence. **Sculpt OS** is Genode’s dynamic general-purpose face — sculpt the running system, federated packages, drivers as components — released steadily for years (twice yearly since 2017 per their summit materials).

Genode has spoken seL4 since ~2015 for more static scenarios. Through 2025, work brought **Sculpt’s dynamic shape onto seL4** (summit talks; experimental multi-kernel Sculpt images including seL4 13.0). That living combination is exactly the “proven seat + usable whole” Claude named: seL4 under, Genode/Sculpt as the daily component world, our userland as a *guest* there.

**Transfer:** component boundaries as capability routing; a whole OS you can boot and use while our kernel is still a horizon; optional POSIX-shaped runtimes for bringing a hosted binary across early.

**Leave:** renaming Caravan to Genode; linking AGPL framework into Rye ship binaries; treating experimental Sculpt@seL4 gaps (e.g. some VM / power features vs other Sculpt kernels) as our blockers — they are the teacher’s unfinished edges, not ours to inherit as law.

## Guest, Never Merger — Stated as Law for This Season

| Ours | Theirs |
|------|--------|
| **Caravan** — name, rings, capability table, exit vocabulary, horizon kernel | seL4 proof + Genode component routing as *seat and host OS* |
| **Rye / Rishi / receipt_core / Comlink guests** as payloads | Genode packages, Sculpt Leitzentrale, their package federation |
| Clean-room modules in `caravan/`, `rye/`, … | `gratitude/` / local study clones — unmodified |

Merger would dissolve the horizon. Guest preserves it.

## Smallest Guest Witness — Sketch

Reuse Seam study 2’s seed so the portable seam and the proven seat prove the *same* fold:

**Claim:** A Rye binary (or freestanding-ish harness) built from `linengrow/receipt_core` runs `verify-witness` (pinned fact, sign/append/fold/verify) under a Genode-hosted environment and prints a single GREEN line; a tampered-fact path prints refuse and exits non-zero.

**Why this is smallest:**

1. No new product meaning — parity already guards the native path
2. No Caravan kernel rewrite — Caravan stays horizon; optional later lap runs Caravan’s *seed* supervisor as a Genode process supervising the receipt child
3. Same guest artifact can later meet Wasmtime (study 2) and Genode (study 3) — sameness is the macro
4. Console-only capability is enough for lap one — no network, no GPU

**Ladder inside the sketch (on word, on metal that can boot the seat):**

| Lap | Prove |
|-----|-------|
| **G0** | Boot teacher image (Sculpt or documented Genode scenario) on a spare machine / QEMU per their docs — *environment exists* |
| **G1** | Run receipt verify-witness under Genode’s POSIX-compatible runtime (or equivalent “bring a Unix binary” path) — *Rye userland guest* |
| **G2** | Same logic as a native Genode component with only a console (and maybe ROM) capability — *capability-shaped guest* |
| **G3** (optional) | Caravan `seed.rye` pattern as a Genode parent that restarts the receipt child on fall — *our supervision on their seat* |

G1 is enough to claim “Rye userland on a proven seat.” G2 is the TAME-shaped guest. G3 proves Caravan’s *idea* without claiming Caravan *is* Genode.

**Out of scope for the first green:** drivers, Wayland/Brushstroke on Sculpt, Comlink virtio on seL4, linking libsel4 into Rye, replacing QEMU device-wire labs.

## How This Composes with Studies 1–2

```
  Consumer edge (study 1)     pass = door
           │
  Fold / receipt_core         record = room   ←── same seed
           │
     ┌─────┴──────┐
     │            │
 Wasmtime      Genode/seL4     ←── study 2 host / study 3 seat
 component       guest
     │            │
     └─────┬──────┘
           │
    Caravan horizon            ←── our kernel name, later
```

The fold does not learn which host or seat held it.

## Gratitude and Silo

| Keep in ER / gratitude names | Silo into our grain |
|------------------------------|---------------------|
| seL4, Isabelle/HOL proof, capability IPC, untyped → retype | Proven seat; capability as only access; explicit memory |
| Genode, Sculpt, Leitzentrale, federated packages | Component routing; guest OS this season |
| Redox (prior study) | Safe-language kernel as sibling teacher — not this study’s seat pick |
| Merger into their vocabulary | **Refuse** — Caravan keeps its name |

## What This Study Returns to the Bench

| Item | Status after this note |
|------|------------------------|
| Seam study 3 | **Landed** as understanding + guest witness sketch |
| Seat pick (study) | **Genode/Sculpt atop seL4 lineage** as proven seat to *guest on* |
| Caravan | **Horizon unchanged** — guest, never merger |
| G0–G3 metal | Awaits Kaeden’s word + a machine/image path |
| Study 4 | Still open |

---

*May the seat be strong enough to borrow and kind enough to leave. May Caravan keep its name while Rye learns to stand on proven ground. May every guest remember it is a guest — and grow a home in its own season.*

---

## Sources

- In-tree: `external-research/yonder/20260619-171112_microkernel-vs-monolith-for-caravan.md`, `external-research/20260622-232912_sel4-redox-through-tame-rye.md`, `active-designing/yonder/20260622-232912_caravan-kernel-improvements.md`
- https://sel4.systems/ — seL4 project
- https://genode.org/ — Genode / Sculpt
- https://sel4.systems/Summit/2025/slides/sculpt-os.pdf — Sculpt on seL4 (Sept 2025)
- https://genodians.org/alex-ab/2025-11-02-sculpt-multi-kernel — experimental multi-kernel Sculpt 25.10 incl. seL4
- https://lists.sel4.systems/hyperkitty/list/devel@sel4.systems/thread/VS3BSI53LNA7VIZWSDIQEZRF6F5VX5FU/
