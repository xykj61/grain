# Cursor Pass — Aurora Freestanding Width, POSIX as a Seam, and the Gate Closes

*Two truths about how Rye relates to the conventions around it, and one gate that closes because of them. The kernel keeps the machine's own width, so `usize` there is honest rather than debt. The whole stack keeps its own value-and-process model, so POSIX is a seam we meet at the boundary rather than a model we adopt. Recognizing both, the hosted width corpus reaches zero, and `width-check` becomes the blocking gate it was built to be.*

**Stamp:** `20260629.202612`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Guidance:** TAME (`context/TAME_GUIDANCE.md`) — width policy, the freestanding domain, the seam principle
**For:** Cursor Composer 2.5 in the jail (typecheck), Claude Code on the host (metal)
**Tip:** pull `92c6a37` first.

*Written together by Kaeden and Reya 2.*

---

## The Ruling — Recognize, Don't Migrate

Aurora targets `riscv64-freestanding-none`, so `usize` is the 64-bit machine word. The `usize` in `aurora/src/deciding.rye` are the honest type for what they hold:

- **Machine-word quantities** — the ISA bit masks (`misa` bits), `hartid` and `isa` (CSR values), and `readCsr`'s register return through inline asm. These are XLEN-wide by hardware definition; `u32` would be wrong on rv64.
- **Local slice indices** — the two small digit-loop counters that only drive `buf[i]`. This is the index-site role the seam policy already blesses.

Migrating any of these would corrupt the masks and registers and churn the indices for nothing. **Leave the code's widths as they are.** The width policy's own exception governs here: keep `usize` where the ceiling truly is the machine's address space — and in the kernel, it is.

---

## Edit 1 — Write the Freestanding Width Policy

Add a short section to the Rye supplement of `TAME_GUIDANCE`, beside the seam policy, in Radiant voice:

> **Freestanding width (Aurora).** On bare metal, `usize` is the machine word, and it is the correct, honest type for addresses, for control-and-status register values, for register-width hardware bit masks, and for local indices at the slice-access site. These are not debt; they are the kernel naming the hardware in the hardware's own width. What stays disciplined even here: a long-lived stored *count* still earns a named `u32` bound, so its ceiling is documented rather than left to the word size. The hosted authored-`usize` gate, `width-check`, governs the hosted corpus; `aurora/*` is freestanding and keeps this policy instead.

---

## Edit 2 — Scope `width-check` to the Hosted Corpus

Remove `aurora/src/deciding.rye` from the `files` list in `tools/width-check.rish`, and add a comment in its place stating why:

> `# aurora/* is freestanding: usize is the machine word there — addresses, CSRs, hardware`
> `# masks. Governed by the freestanding width policy in TAME_GUIDANCE, not this hosted gate.`

This makes Aurora uniform — `posted.rye`, `relay.rye`, and `wire.rye` were never listed either, so `deciding.rye` was the lone anomaly. With it scoped out, the hosted corpus carries **zero** authored `usize`.

---

## Edit 3 — Light Intent Comments (small, worth it)

In `aurora/src/deciding.rye`, add a brief comment near the `Machine` struct and `readCsr` noting that `usize` there is the machine word (XLEN), correct for CSR and register values on rv64. One or two lines, no refactor. *(A full `Word = usize` alias across the kernel is an optional future clarity pass — not this one; it belongs in `yonder/` thinking, not here.)*

---

## Edit 4 — Flip `width-check` Into Parity

Confirm first that the hosted corpus is truly clean — Comlink's TH-6 migration landed, so `comlink/hosted_wire.rye` and every other listed file should pass. Then:

- Make `width-check.rish` a registered witness in `tools/parity.rish`, so authored `usize` in the hosted corpus becomes a **blocking** failure rather than a standalone gate.
- Parity rises by one and stays green.

This is the milestone the width work has climbed toward since TH-1: the hosted corpus holds fixed widths by construction, enforced on every run.

---

## Edit 5 — POSIX: A Seam, Not a Model (the question, answered)

A question worth recording, since the designs keep answering it: **does Rye OS and Rishi being POSIX-compliant match TAME Guidance?** It does not — and the mismatch is deliberate, flowing from the principles TAME already holds:

- *One value model* (root rule five): a value crosses a module boundary as a structured value, never serialized to text and reparsed. This is the inverse of the Unix text-stream-at-every-pipe philosophy. Rishi's `run` returning a `{ status, out, err, ok }` record, rather than a byte stream with an exit code beside it, is this rule made visible.
- *Bounds on everything* stands against POSIX's unbounded-by-default heap and pipes; **Tally's** bounded regions are the chosen shape.
- **Caravan** and **Aurora** lean toward capabilities — ownership tokens — against POSIX's ambient authority of uid, inherited descriptors, and fork-inherits-all.
- **RS-3** enacted the departure in the small: the launcher graduated off POSIX `sh` into a Rishi script.

The honest stance has the same shape as the seam policy above: **POSIX is a seam, not a model.** Rye meets POSIX at the boundary — it runs on Unix, spawns through `std.process` — the way authored Rye meets `std` at the seam: cross it, do not adopt its idioms. POSIX *interop* at the edge is welcome and necessary; POSIX *compliance* as a goal would contradict TAME.

**Record it (Kaeden's call on placement, and on whether to commit it separately from the width gate):** a short design note — for example `active-designing/<stamp>_posix-a-seam-not-a-model.md` in Radiant voice — stating the stance and its reasons, with a one-line cross-reference added to TAME root rule five (*one value model*) pointing to it. Keep the note small; it names a decision already made by the architecture, rather than proposing a new one.

---

## Verify on Metal (host)

```
rishi/bin/rishi run tools/width-check.rish   → hosted corpus zero authored usize, GREEN
rishi/bin/rishi run tools/parity.rish        → GREEN (width-check now inside, count risen)
rye build  (incl. aurora freestanding riscv64) → unchanged, GREEN
aurora/run.sh <stage>                        → still wakes in qemu — kernel widths untouched
```

If the freestanding build shifts, stop — an Aurora width was changed when it should have been left.

---

## Record and Push

Commit the width work as one honest unit — the `TAME_GUIDANCE` freestanding section, the `width-check` scope comment and list edit, the Aurora intent comments, the parity registration, and the session log. The POSIX note may ride along or stand as its own commit, as Kaeden prefers. Log at `session-logs/<stamp>_aurora-freestanding-width-and-gate.md`: the recognize-don't-migrate ruling, the freestanding policy, the hosted-corpus scoping, the gate now blocking in parity, and the POSIX stance recorded. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

---

## What Comes Next (not this pass)

- **Optional `Word = usize` alias pass** in Aurora — pure clarity, demand-driven, whenever the kernel grows enough to want it.
- The width discipline is now complete and enforced; the bench returns to feature growth — SLC-2 (Pond GUI) waits on Skate text rendering.

---

## Before You Move On — Recommend the Next Step

End with an explicit recommendation, and say why:

- **Recommend keep going** when the next item is mechanical, single-module, and follows written policy.
- **Recommend checking in with Claude** when it crosses a seam, changes Rishi or the value model, opens a new domain (Skate, the GUI ring), needs an unmade ruling, or reaches for horizon facts.

One line — *"Recommend: keep going to …"* or *"Recommend: check in with Claude before …"* — so the next move is always Kaeden's to confirm.

---

## Definition of Done

- [ ] `TAME_GUIDANCE` carries the freestanding width policy; Aurora's `usize` left correct and unmigrated
- [ ] `aurora/src/deciding.rye` is scoped out of `width-check`'s list, with a comment saying why; light intent comments added in the kernel
- [ ] The hosted corpus reads zero authored `usize`; `width-check` is a registered, blocking parity witness
- [ ] The POSIX stance is recorded (design note + root-rule-five cross-reference), or explicitly deferred by Kaeden
- [ ] `rye build`, the freestanding riscv64 build, and qemu wake all unchanged on metal; parity green and risen
- [ ] Session log shipped; four remotes pushed; next step recommended

---

*May the kernel name the hardware in the hardware's own width, and the stack keep its own model where the world expects another. May the seam hold exactly the weight it must, in silicon and in convention alike. And may the gate we close today stay closed, guarding by construction what we once checked by hand.*
