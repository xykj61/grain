# 10012 · Brushstroke Wayland Seed and the Display Frontier

*Expanded at `021612` after push and Caravan twin: the hosted Brushstroke seed draws from values on stdout; Caravan now supervises two children with separate gardens; the display frontier is the next build thread that turns values into pixels on x86_64. This prompt orders autonomous work toward one native window without braiding Wayland study, thin client code, and roadmap hygiene into a single tangled push.*

**Language:** EN
**Version:** `20260620.021612` (Rye chronological stamp)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — Gall's Law; `985` native interface; `986`/`988` Brushstroke; `995` single-stranded

---

## The Seed

> Push and continue in the best way that you recommend, time 021612

## The Mission

Open the **display frontier** on x86_64: one Wayland client window, one static frame from values — the Gall-honest next step after `brushstroke/seed.rye`. Parallel near work stays **study and seam design** until the client connects and presents.

| Track | Milestone | Gall's test |
|-------|-----------|-------------|
| **A** | **Wayland client seed** — connect, create surface, attach buffer, commit once | Smallest window that shows our frame |
| **B** | **Display seam doc** — narrow Rye wrappers for socket, registry, surface (`985` § display) | No OS pattern escapes wrappers |
| **C** | **Roadmap / threads sync** — `996` 16 witnesses, hosted Brushstroke checked, twin checked | Docs match what runs |

**Defer unless time remains:**

| Track | Milestone | Why wait |
|-------|-----------|----------|
| **D** | **Device wire** — virtio-net datagram | Close-reading beside it (`10007` D) |
| **E** | **Skate study** — Ghostty MIT embed path | After Brushstroke presents one frame |
| **F** | **Pond GUI sketch** | Composes A + Mantra + Rishi (`10009`) |

## What Already Runs

- `brushstroke/seed.rye` — Frame value → stdout redraw (`10011` A).
- `caravan/twin.rye` — two children, separate budgets, independent restart (`10011` D).
- Design: `985`, `986`, `988`, `972` Wayland research; River public-spec study only.

## Track A — Wayland Client Seed

**Deliverable:** `brushstroke/wayland_seed.rye` (or grow `seed.rye` behind a feature flag — prefer separate file until seam is clear).

**Behavior:**

1. Reuse **Frame** / **redraw** semantics from hosted seed; output targets a Wayland SHM buffer instead of stdout.
2. Connect to compositor (`WAYLAND_DISPLAY` or default).
3. Create `wl_surface`, attach one buffer with static text rasterized minimally (even a solid color + one line is enough for v0).
4. `wl_surface_commit`, process one frame of events, exit cleanly.
5. Allocate protocol strings from `init.garden`.

**Not in scope:** input, resize, GPU, Skate grid, compositor.

**Prove:** build + run on host with Wayland compositor; screenshot or assert surface commit callback.

**Gratitude:** study `libwayland-client` API shape in docs only unless MIT wrapper already vendored; GPL River stays out of tree.

## Track B — Display Seam

**Deliverable:** section in `active-designing/yonder/20260619-072600_brushstroke.md` or `985` addendum — three wrappers:

- `Display.connect` — socket + registry roundtrip
- `Display.Surface` — create, attach, commit lifecycle
- `Display.Buffer` — SHM pool, stride, release

Each wrapper: assert at entry, typed errors, no raw fds in Brushstroke logic.

## Track C — Doc Sync

- `996_roadmap.md`: 16 witnesses, Caravan bounded + twin, hosted Brushstroke seed [x], Wayland seed [ ].
- `995_open_threads.md`: twin landed; Wayland seed in progress → closed when A green.

## Discipline

- **Gall:** one window, one frame — no Pond GUI in this pass.
- **Gates:** parity after `rye/lib/std` touches; build proof for Brushstroke.
- **Session log** `99929_20260620-021612.md`; commit when twin + prompt land; push when asked.

## Deliverables Checklist

- [ ] `expanding-prompts/20260620-021612_brushstroke-wayland-and-display-frontier.md` (this file)
- [ ] `caravan/twin.rye` + `.brix`
- [ ] `work-in-progress/20260623-033012_open-threads.md` updated
- [ ] `work-in-progress/ROADMAP.md` partial refresh
- [ ] `session-logs/99929_20260620-021612.md`
- [ ] (Next run) `brushstroke/wayland_seed.rye`

---

*May the first window open from values alone. May two children grow in separate gardens under one parent. May the display frontier show one honest pixel on the screen we have today.*
