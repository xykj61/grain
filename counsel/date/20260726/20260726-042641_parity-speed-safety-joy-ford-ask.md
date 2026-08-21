# Parity Speed — Safety · Performance · Joy · Ford-Shaped Ask

**Language:** EN  
**Stamp:** `20260726.042641`  
**Voice:** Quin  
**Status:** Counsel ask — propose-never-seat; awaits Claude ruling  
**Ground:** Full parity F re-running on Framework metal · prior full sitting ~106 min · ch01 still in flight past fifteen minutes at this stamp (lantern zig `build-exe` after the pristine-std rye map) · suite already chaptered for Env bindings, not for wall time  
**Extends:** [`counsel/20260726-014013_which-gate-belongs-to-which-lap.md`](20260726-014013_which-gate-belongs-to-which-lap.md) · [`counsel/20260725-223409_the-tool-the-door-the-rung-and-the-lane.md`](20260725-223409_the-tool-the-door-the-rung-and-the-lane.md) · metal chaptering pin in [`work-in-progress/ready-to-ask-claude.md`](../work-in-progress/ready-to-ask-claude.md)  
**External study:** [Ford Fusion](https://urbit.org/blog/ford-fusion) (~rovnys-ricfer, 2020) — Urbit build/OTA rewrite; Clay dependency tracking; atomic · self-contained · ordered layers  
**Counsel model this ask targets:** Claude Opus (standing counsel)

*Written together by Keaton and Quin.*

---

## Why We Are Asking

Full parity is honest and load-bearing — and it is also slow enough that a single GREEN sitting costs an afternoon. The last measured full run landed near **106 minutes**. A re-run started this sitting remains on chapter one after fifteen-plus minutes, currently compiling `lantern` via Zig after finishing the opening pristine-std rye map. Counsel once guessed thirty to forty minutes; the tree has outgrown that guess. We want guidance before we invent a speed fix that quietly weakens the gate.

## What the Suite Is Today (measured)

| Fact | Number / shape |
|---|---|
| Driver | `tools/parity.rish` → ch01 · ch02 · jam/cue · glow REPL · waymark · list1024 · digraph twin |
| Chapters | 2 — opened for `TooManyBindings` / Env[512], **not** for wall-clock |
| `run [` sites | ~296 in `parity_ch01.rish` · ~132 in `parity_ch02.rish` |
| GREEN say-lines | ~294 ch01 · ~130 ch02 · plus driver trails |
| Opening rye map | **116** sequential `rye run rye/tests/*.rye` against pristine std (each may compile) |
| Process model | Every chapter and nearly every witness is a **fresh Rishi process**; no shared cache between steps |
| Wall time | ~106 min full sitting; this re-run already >15 min still inside ch01 |
| Live sample | At stamp, process tree showed `rishi → parity_ch01 → … → zig build-exe lantern/…` |

The slowness is not one mysterious loop. It is **serial correctness**: hundreds of subprocesses, many Zig compiles, no skip of unchanged inputs, and a chapter cut that resets bindings rather than short-circuiting work.

## What We Are Not Asking Claude to Seat Yet

We are not asking for a rewrite this hour. We are asking for a **ruling shape** under the three virtues and TAME — which of the lanes below (or which blend) belongs next, and which must wait for Ojjo / a named season.

## Four Lanes Offered

### 1. Safety · performance · joy — TAME guidance for speed

Ask: name the discipline before the optimization. What may a faster suite change without lying? What must stay cold-start honest (host ABSENT preflight, no false GREEN, pin-what-prints)? Where does joy live — shorter feedback for the hand that just touched one module, versus one afternoon oracle that proves the whole pier?

### 2. Archive parts that are no longer relevant

Ask: which witness families may move to `archive/` or a rarely-run shelf without shrinking the living gate? Criteria we already feel — replaced by a later witness, guarding retired surface, duplicating another GREEN — want your word before any cut.

### 3. Break into smaller Rishi scripts (selective smoke)

Ask: more chapters / named packs (std · caravan · lantern-lattice-scribble · glow) that a lap can run alone, with full parity remaining the release oracle. Chaptering already exists for Env; this lane would chapter for **intent and time**, not only bindings.

### 4. Ford-like dependency graph (old F / Clay shape)

Ford Fusion's lasting lesson for us is less "copy the vane" and more the three properties and the graph:

- **Atomic** — a rebuild finishes or rolls back; the suite does not strand a half-green story.
- **Self-contained** — a witness recipe does not depend on ambient history to mean the same thing twice.
- **Ordered** — lower layers invalidate upper; upper changes do not force lower rebuilds.

Clay rebuilt only modules whose inputs changed. A parity analogue would track edges from source (and pins) to witnesses, cache GREEN products by content, and re-run the transitive fan-out — Ojjo's yardstick seat may already be the right home for measurement; the ask is whether Glow wants a **Ford-shaped witness graph** now, later, or never under TAME's "slower to go faster" law.

Study link kept living: https://urbit.org/blog/ford-fusion

## The Question, One Paragraph

Under safety, performance, and joy — and under TAME — how should Grain speed full parity without teaching the bench to distrust GREEN? Prefer guidance among: (a) written speed discipline only, (b) archive stale witnesses, (c) smaller selectable Rishi packs beside the full oracle, (d) a Ford/Clay-like dependency graph with cached products, or a named blend and order. Name what parks until Ojjo or a Brix season if anything must.

## What Stays True While We Wait

- Full parity F continues measuring; H (Brix survey) still waits on suite GREEN.
- Send may stay PARTIAL under the seated ABSENT law when only host tools are missing; a true RED still holds code sends.
- No suite surgery lands from this ask alone.

---

*May the gate stay honest when it grows faster. May every skipped witness be a named skip. And may Ford's three properties — atomic, self-contained, ordered — teach the graph without inviting Amazon's hell.*
