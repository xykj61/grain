# REDS -- rows %347 through %349, folded from the living pin

**Folded:** `20260830.041500` -- **Status:** Archived, complete, never edited
**Living pin:** [`../REDS.md`](../REDS.md) -- **Law:** [`.claude/rules/reds-first.md`](../../.claude/rules/reds-first.md)

*The three rows a body found that could not have made the repair -- the fleet catching itself across benches, on one day.*

Three rows, all stamped `20260829`, and together they are the clearest account this ledger holds of
what a fleet of six bodies is actually for. Two were found by **Mind's supervised lap from a bench
holding no Rye proof product at all**: it did the arithmetic, named a line bound sized to a familiar
case rather than the worst one (%347) and a caller-reachable condition standing behind an assert
where a named error belonged (%349), parked both honestly as custody, and handed the repairs across
the orbit rule. The third was found by **both supervisors refusing at once**, when one fixed
interpreter spelling in a commit hook left two jailed loops half-alive from a single line (%348) --
and Mind proved the repair from both sides before parking.

The through-line is worth keeping where a reader finds it: **a bench that cannot make the repair can
still make the finding**, and a fleet whose bodies read each other's work catches what any one of
them, running alone and green, would have shipped. %348's own lesson generalizes the shape -- an
interpreter is an environment fact -- and it kept teaching after this fold: `%355` records the two
spellings that same family's sweep could not see, nested one level down inside a string.

Each row stands here exactly as it was written. A closed row leaves the living pin so the pin stays
the length a reader will actually read; the lesson travels forward in the guards these rounds built,
and the row itself stays one click away.

---

**REDS %347 (`20260829.212731`) -- a line bound sized to the wrong verb refused a valid maximum crop.** *What went wrong:* `image/photo_edits.rye` declared `per_line_bound = 48` with a comment sizing the longest line to `adjust -255 65536 65536` -- but crop's four u32 fields at their maxima render `crop 4294967295 4294967295 4294967295 4294967295` plus newline at exactly **49 bytes** (4 + 1 + 4x10 + 3 + 1), so a fully valid edit overflowed the bound its own module promised to hold, and the record capacity read 3,094 where the true arithmetic is 3,158. *What caught it:* **Mind's supervised lap, from a bench that could not touch Rye** -- it measured 48- and 49-byte crop controls, named the mismatch a tree defect against its two machine limits, parked the ruling as custody, and handed the repair across the orbit rule; the second cross-bench catch of the day after the surface-claims exact-length drift. *What it taught:* **a bound's said-why must name the worst case, not a familiar case** -- the comment's example was honest and irrelevant, and every reviewer since read the example instead of doing the arithmetic; a said-why that shows the worst-case computation is a bound a reader can check in their head. *Repaired (`20260829.212731`):* `per_line_bound` widens to 49 on the granted word with the crop worst case computed in the comment, `max_edits_bytes` follows by derivation, and `tools/h/hunk_photo_edits_witness.rish` answers GREEN over the widened bound -- render-parse fixed points, refusals, and the whole verb vocabulary standing. **CLOSED.**

**REDS %348 (`20260829.222718`) -- the hook's fixed interpreter spelling crashed two jailed loops from one line.** *What went wrong:* `tools/hooks/pre-commit` invoked its pin scan as a literal `/bin/sh` -- itself the `20260828` repair for a jail whose PATH `sh` was the macOS selector wrapper -- and the `20260829` Codex jail denies that wrapper's own read of `/private/var/select/sh`, leaving it half-alive: the scan's opening substitution-plus-cd garbled, the wall refused every commit, Mystery's finished lap died at the signer, and Mind reached custody with a proven candidate stranded in `stash@{0}`. *What caught it:* both supervisors refusing honestly -- and Mind proving the repair from both sides before parking: the same scan under explicit bash answers `verdict=ok` inside the same jail. *What it taught:* **an interpreter is an environment fact, so a wall that needs one probes at run time on the exact shape that fails** -- a fixed spelling repairs one bench by breaking the next, and an honest probe is the failing operation itself (a substitution, a CDPATH-clean cd, a pwd), never a no-op. *Repaired (`20260829.222718`):* the hook probes `/bin/bash`, `bash`, `/bin/sh` in order and runs both scan call sites under the winner; proven by `tools/p/pin_bound_touch_witness.rish` -- 36 cases arming the repaired hook in real pens -- and by both interpreters answering the live scan identically on this bench. **CLOSED.**

**REDS %349 (`20260829.235814`) -- a caller-reachable condition guarded by an assert instead of a named error.** *What went wrong:* `brushstroke/image_skate.rye`'s `down_map` checks its grid request against `max_map_cols` and `max_map_rows` at the edge yet never against the SOURCE dimensions -- so a grid wider or taller than the image empties the integer partition, and `assert(y1 > y0)` / `assert(x1 > x0)` (the comment beside them says "the partition never empties") panic on input a caller can lawfully hand in. An assert states an internal invariant; a condition the caller can reach earns a refusal by name. *What caught it:* **Mind's supervised lap, from a bench holding no Rye proof product** -- it read the arithmetic, named the mismatch a tree defect against its machine limits, and handed the repair across the orbit rule; the third cross-bench catch of the day. *What it taught:* **the said-why beside a wall must name the wall's own precondition** -- "the partition never empties" is true only while the request stays inside the source, and the entry checks never established that. *Repaired (`20260830.001449`):* `GridExceedsSource` refuses at the edge before the partition, the assert comments now name the precondition the wall establishes, and `tools/h/hunk_skate_witness.rish` answers GREEN with both refusal axes and the exact source-sized welcome proven in the selftest -- closed by Sound under the captain's hat after Mind's bench, holding no Rye proof product, proved the defect empirically and parked honestly; Mind's provisioning rides the same round. **CLOSED.**
