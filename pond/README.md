# Pond — The Enclosure and Its Applications

**Language:** EN
**Last updated:** 2026-07-10 (Radiant pass `182821`; Granary weave view `163557`; customs first policy lap `161125`)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable — enclosure applications floor

---

Pond holds **applications** that compose Rye OS modules above the kernel and compositor — the first lap where isolation policy meets a running whole a person can use. The `apps/` floor keeps enclosure code and application code apart.

**Pond clause:** Pond's enclosure aspect runs what Brix composes under policy.

**Customs (landed `20260710.161125`):** [`customs.rye`](customs.rye) — first policy concept. At receipt, each Tilak mark earns **place**, **hold**, or **refuse**. Root allow-list: `plain-bytes` may be placed; `await-word` waits for a human word; unknown marks refuse whole. Amphora cold scrub calls `customs inspect` on the Amber manifest before restore. Witness: `tools/pond_customs.rish` (parity **230**).

**First application:** [`apps/drawn_terminal.rye`](apps/drawn_terminal.rye) — SLC-2a Lap 3, the drawn terminal (Rishi session mirrored in a Brushstroke/Skate window). Granary weave view (`granaryviewtest`) folds resolve + Scribble onto Skate (parity **233**). Inference and commerce folds share that same glass.

Policy-as-value horizon: `rishi/examples/pond.rish` and `external-research/20260618-180812_pond-foundation.md`.

---

## Compile layout

Rye resolves modules from the compile directory. Under `pond/apps/`:

| Path | Points to |
|------|-----------|
| `rishi` | `../../rishi/src` |
| `brushstroke` | `../../brushstroke` |
| `granary/` | `../../../granary` core + Kumara / Tally / Scribble seams |

These symlinks are required for `drawn_terminal.rye` to import `rishi/main.rye` and `brushstroke/wayland_seed.rye`.

---

## Build and run — drawn terminal

**Prefer `rishi run` for every hosted step** — build, witnesses, preflight, and parity slices. Rishi carries staged TAME output and asserts GREEN before the step completes. Run binaries directly only for **live** interactive mode on GNOME Wayland.

From the repository root:

```bash
# Build (prepare → compile → prove)
rishi/bin/rishi run tools/fixtures/pond_build_drawn_terminal.rish
```

| Step | Command | Purpose |
|------|---------|---------|
| **Build** | `rishi/bin/rishi run tools/fixtures/pond_build_drawn_terminal.rish` | Staged compile; asserts prepare/compile/prove/GREEN |
| **Witness (Lap 3)** | `rishi/bin/rishi run tools/slc2a_ring3_session.rish` | Headless session mirror (build + `sessiontest`) |
| **Witness (SLC-2b)** | `rishi/bin/rishi run tools/slc2b_keyboard.rish` | Dexter keyboard path (build + `keyboardtest`) — parity **145** |
| **Metalsmoke** | `rishi/bin/rishi run tools/slc2a_ring3_metal.rish` | Thin-lap Wayland slice (needs `WAYLAND_DISPLAY`) |
| **Live** | `pond/bin/drawn-terminal` | Keyboard in the window; stdin still works for dev |

**Metal close (Kaeden):** rishi preflight and metalsmoke, then live on GNOME Wayland:

```bash
rishi/bin/rishi run tools/fixtures/pond_metal_close_preflight.rish
rishi/bin/rishi run tools/slc2a_ring3_metal.rish
pond/bin/drawn-terminal
```

Confirm each interactive step:

1. **Build** — preflight or `pond_build_drawn_terminal.rish` via rishi above; binary at `pond/bin/drawn-terminal`
2. **Type** — enter a few Rishi lines; frame updates in the window
3. **Idle ~one minute** — leave the window focused; pong keeps the compositor honest
4. **Ceiling** — fill past `max_transcript_bytes` (65536); status row still updates (invitation visible)
5. **Exit** — `:quit` closes clean

Witness and metalsmoke already **GREEN** through rishi; live mode is the hand confirmation only.

<details>
<summary>Manual compile (escape hatch — prefer rishi build witness)</summary>

```bash
mkdir -p pond/bin
export RYE_ZIG="$PWD/vendor/zig-toolchain/zig"
rye/bin/rye build pond/apps/drawn_terminal.rye brushstroke/xdg-shell-protocol.c \
  -Ibrushstroke -lc -lwayland-client -lxkbcommon -lrt \
  -femit-bin=pond/bin/drawn-terminal
```

To watch build lines stream during a long compile (rishi buffers until exit), run the hosted script directly:

```bash
sh tools/fixtures/pond_build_drawn_terminal.sh
```

</details>

Retired `.sh` fixtures live in [`tools/fixtures/yonder/`](../tools/fixtures/yonder/).

---

*May each app rest above the modules it composes, and may the enclosure stay honest about what it grants.*
