# Cursor Pass — TH-3: Mantra Width, and the Seam Policy It Sets

*The width migration reaches the SLC-1 path. Mantra carries only seven authored `usize`, in two files, so the work is small — and that is the gift, because it lets us set the seam policy clearly on the module the shell leans on, and write that policy down so every width pass after this one inherits a rule rather than a fresh judgment.*

**Stamp:** `20260629.173912`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Guidance:** TAME (`context/TAME_GUIDANCE.md`) — width policy, the inherited-std seam
**For:** Cursor Composer 2.5 in the jail (typecheck), Claude Code on the host (metal)
**Tip:** pull the TH-2c commit first.

*Written together by Kaeden and Reya 2.*

---

## The Ruling — Mantra Only, and Write the Policy Down

This pass migrates **`mantra/src/*` only**, and its lasting deliverable is the **seam policy written into `TAME_GUIDANCE`**, with Mantra as the worked example. Comlink and Rishi migrate later under the *same* written policy; do not pull them into this pass, since Comlink's wire widths are a different judgment than Mantra's in-memory indices. **Aurora is out of scope** — its `deciding.rye` is freestanding and plays by bare-metal width rules of its own, deferred to a separate question.

The width surface (verified):

| File | Authored `usize` | Action |
|------|------------------|--------|
| `mantra/src/diff.rye` | 2 | migrate first — learn the pattern |
| `mantra/src/main.rye` | 5 | migrate second |
| `mantra/src/store.rye` | 0 | already clean — leave untouched |
| `mantra/src/weave.rye` | 0 | already clean — leave untouched |

---

## The Seam Policy — Canonical, for `TAME_GUIDANCE`

Write this into the Rye supplement's width section as the reusable rule. Three widths, one rule for the boundary:

- **`u32`** — authored in-memory counts, indices, and lengths bounded by a named constant. The default width for "how many in this region."
- **`u64`** — wire- or disk-persistent sizes, offsets, and timestamps; anything that must mean the same on every target.
- **`usize`** — **only at the cast site, never as an authored field or a flowing variable.** Two seam moves cover nearly everything:
  - *Indexing a slice with an authored `u32`:* cast at the index — `buf[@as(usize, pos)]` or `const i: usize = @intCast(pos);`. Assert the value is in range first where the bound is not already guaranteed.
  - *Taking a std-provided length into authored arithmetic:* assert `len <= std.math.maxInt(u32)`, then `@intCast` down to `u32` — mirroring Tally's existing `bufLenU32` helper, which is the pattern to reuse rather than re-roll.

For Mantra's seven sites specifically: they are in-memory indices and lengths, so they land in **`u32`** with seam casts at the indexing points; reuse the `bufLenU32` shape wherever a std length enters. No `u64` is expected here — Mantra's persistence already lives in the clean `store.rye` and `weave.rye`.

This is correct Tiger code at the seam, not debt — the same stance `width-check` already encodes since TH-1.

---

## File Order and the Migration

Migrate **`diff.rye` first** (two sites), establishing the pattern on the smaller file, then **`main.rye`** (five). Each `usize` either becomes a fixed-width authored value (`u32`) or a blessed seam cast at the boundary. Change widths and casts only — assert no new conditions, alter no logic. This is a width refinement, behavior-identical.

After each file, run `tools/width-check.rish` and watch that file leave the authored-`usize` count. When both are done, **Mantra contributes zero** to the count.

---

## Gate Timing — Don't Wire a Red Gate Into the Green Suite

`width-check.rish` is already a hard gate that asserts zero authored `usize`; it stays RED while any module still carries debt, and it stays **out of the green parity suite** until the whole corpus reaches zero. So:

- Each Mantra file reads green the moment its authored `usize` is gone.
- Mantra is fully green after this pass.
- `width-check` overall **remains RED** until Rishi and Comlink migrate too. Add it to `parity.rish` as a blocking gate **only when the global count hits zero** — not before.

Add a small witness for this pass (extend the width witness or add `tools/width_check_th3.rish`) asserting **Mantra carries zero authored `usize`**, registered so parity rises and stays green. Gate the module you cleaned, even while the global gate waits.

---

## Verify on Metal (host)

A width refinement should leave behavior untouched; prove it:

```
rishi/bin/rishi run tools/width_check_th3.rish   → mantra zero authored usize, GREEN
rishi/bin/rishi run tools/parity.rish            → GREEN (count risen by one)
rye build  +  mantra's own witnesses             → unchanged, GREEN
rishi/bin/rishi run tools/width-check.rish        → mantra clean; overall still RED (rishi, comlink remain) — expected
```

If a mantra witness shifts, stop — a width cast touched behavior, and the diff wants a second look.

---

## Record and Push

Commit as one honest unit — the two Mantra files, the `TAME_GUIDANCE` policy section, the witness, and the session log together. Write the log at `session-logs/<stamp>_th3-mantra-width.md`: the sites cleared, the seam policy now written down, the gate timing, and the note that Comlink and Rishi inherit the policy. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

---

## What Comes Next (not this pass)

- **TH-4** — `.brix` dead-path mend. Mechanical; Cursor can run it without a strategy stop.
- **TH-5** — Rishi width, following *this* seam policy. In-memory REPL buffers → `u32` with seam casts. No strategy stop needed **unless** a value appears that the policy does not clearly place; then check in.
- **Comlink width** — wire formats lean on `u64`; the policy covers it, yet flag any genuinely new wire-width question.
- **Flip `width-check` into parity** — once the global authored-`usize` count reaches zero.

---

## Before You Move On — Recommend the Next Step

End this pass with an explicit recommendation to Kaeden, and say why. The rhythm:

- **Recommend keep going** when the next bench item is mechanical, single-module, and follows a policy already written down — TH-4, or TH-5 where the seam policy plainly applies.
- **Recommend checking in with Claude** when the next item crosses module seams, changes Rishi or value-model behavior, raises a width or design question no written policy answers, needs a ruling not yet made, or reaches for horizon facts.

State it in one line — *"Recommend: keep going to TH-4 (mechanical)"* or *"Recommend: check in with Claude before … (new seam question)"* — so the next move is always Kaeden's to confirm. Carry this close into every pass from here on; it can live as a line in the session-log convention.

---

## Definition of Done

- [ ] `diff.rye` and `main.rye` carry zero authored `usize`; `store.rye` and `weave.rye` untouched; Aurora untouched
- [ ] The seam policy is written into `TAME_GUIDANCE` (three widths; `usize` only at the cast site; reuse `bufLenU32`)
- [ ] A witness asserts Mantra clean; parity green and risen; `rye build` and mantra witnesses unchanged on metal
- [ ] `width-check` overall correctly still RED (rishi, comlink remain) and still outside parity
- [ ] Session log shipped; four remotes pushed; the next-step recommendation stated

---

*May the widths we choose be honest about how large each thing can grow. May the seam hold exactly the weight it must, and no more. And may the rule we write down today carry every pass that follows, so the work grows wider without ever growing unsure.*
