# 10014 · Device Wire and Comlink's Next Rung

*Expanded at `032012` after Caravan chain-loading: supervision now runs seed → bounded → twin → chain on hosted ground; Comlink's posted datagram crosses shared memory between harts; the display frontier opened on Wayland. The device wire is the next build thread that carries a sealed datagram over a true network link — virtio-net between two QEMU machines — without braiding driver work, close-reading, and format hardening into one push.*

**Language:** EN
**Version:** `20260620.032012` (Rye chronological stamp)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — Gall's Law; `993` bounded network; `979` Comlink remoting

---

## The Seed

> Let's keep going, time 032012

## The Mission

Caravan **chain-loading** lands in this session (`caravan/chain.rye`). The **device wire** is the next autonomous run.

| Track | Milestone | Gall's test |
|-------|-----------|-------------|
| **A** | **Caravan chain** — wake → prove, ordered startup, per-stage restart | Smallest chain that does not rewind |
| **B** | **Doc sync** — `976`, `995`, `996`, `984` path step 4 | Catalog matches repo |
| **C** | **10014** (this file) — frame device wire for next run | Named deferrals |

**Next run (10014 execution):**

| Track | Milestone | Why separate |
|-------|-----------|--------------|
| **D** | **Hosted wire seed** — UDP or UNIX datagram between two processes | Before virtio |
| **E** | **virtio-net** — two QEMU guests, sealed payload copied | Needs driver study |
| **F** | **Close-reading notes** — packet format from `gratitude/` | Before format hardens |

## Track A — Caravan Chain (this session)

**Deliverable:** `caravan/chain.rye`

- Stages: `wake` (readiness line) → `prove` (bounded garden)
- Prove falls once, restarts, holds; wake succeeds first try
- Assert total restarts == 1; stage 2 never starts until stage 1 green

## Discipline

- **Gall:** chain is one file, one proof — no capability table yet (step 5 in `984`).
- **Session log** `99926_20260620-032012.md`; commit + push when green.

---

*May the startup read as a clear sentence — one stage at a time, each proven before the next speaks.*
