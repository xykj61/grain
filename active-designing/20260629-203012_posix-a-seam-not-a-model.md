# POSIX — A Seam, Not a Model

*Rye meets the Unix world at the boundary; it does not adopt Unix as its architecture.*

**Stamp:** 20260629.203012  
**Style:** Radiant (see `context/RADIANT_STYLE.md`)  
**Cross-reference:** TAME root rule five (*one value model*) in `context/TAME_GUIDANCE.md`

---

## The Stance

**POSIX is a seam, not a model.** Rye runs on Unix hosts, spawns through `std.process`, and crosses libc at the edge — the same shape as authored Rye meeting inherited `std` at the seam: cross it, do not adopt its idioms.

POSIX *interop* at the boundary is welcome and necessary. POSIX *compliance* as a goal would contradict TAME.

---

## Why It Follows from TAME

**One value model** (root rule five): a value crosses a module boundary as a structured value, never serialized to text and reparsed. Unix pipes text streams at every boundary; Rishi's `run` returns `{ status, out, err, ok }` as a record — structured shell lineage, not a byte stream with an exit code beside it.

**Bounds on everything:** Tally's bounded regions stand against POSIX's unbounded-by-default heap and pipes.

**Capabilities over ambient authority:** Caravan and Aurora lean toward ownership tokens — against POSIX uid, inherited descriptors, and fork-inherits-all.

**RS-3 enacted the departure in the small:** the launcher graduated off POSIX `sh` into `launch-cursor.rish`.

---

## What This Means in Practice

- Meet POSIX where the host requires it (spawn, paths, sockets at the libc seam).
- Do not design Rye modules as if everything were a file descriptor and a text stream.
- Prefer structured records, named errors, and capability-shaped boundaries inside the family.

---

*May the stack keep its own model where the world expects another, and meet the seam only with the weight it must carry.*
