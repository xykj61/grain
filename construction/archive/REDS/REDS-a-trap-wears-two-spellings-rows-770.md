# REDS -- row %770, folded from the living pin

**Folded:** `20260916.103937` -- **Status:** Archived, complete, never edited
**Living pin:** [`../REDS.md`](../../REDS.md) -- **Law:** [`.claude/rules/reds-first.md`](../../../.claude/rules/reds-first.md)

*One row that called twelve fully-released pens leaks, because its trap predicate knew one of the
two spellings a trap wears.* The census marked a removal released only when one line carried both
`trap` and `EXIT`. The two-line form puts the removal inside a function and registers it below,
so the removal line names no trap and the strongest pens in this tree -- the ones releasing on four
signals -- read as the leakiest.

Two readings inside it are worth carrying. The damage landed entirely in the REPORTED half:
`never_removed` was gated and never moved, since a function body sets `removed` either way, so no
gate reddened and no ship stopped -- the inflation sat in `unreleased_on_refusal`, which is what a
ship reads as its work queue. And it was the SECOND firing of one fault: `%758` named the first, a
Rishi removal spelled `run ["rm" "-rf" home]` unseen for want of a `$` sigil. Both are a reading
that recognises a removal by its SPELLING where it means to recognise it by its ROLE, so the lantern
became a loom.

What the row leaves behind reaches past pens. A predicate written from the shape its author
happened to have in front of them will read every other shape as absent, and absence is the one
answer that looks like a finding. The cure is the same each time: enumerate the spellings a thing
actually wears in this tree before writing the pattern that counts them, and count the shapes rather
than sampling one.

*Folded here because the pin stood 295 bytes over its 65,536 bound once `%773` was booked, and this
row was closed. No open row was touched to seat it.*


**REDS %770 (`20260916.073000`) -- a leak census called twelve fully-released pens leaks, because its trap predicate knew one of the two spellings a trap wears.** *What went wrong:* `tools/fixtures/p/pen_release_scan.sh` marked a removal released only when the same line carried both `trap` and `EXIT` -- the inline `trap 'rm -rf "$pen"' EXIT`. The two-line form puts the removal inside a function and the registration below it -- `cleanup() { rm -rf "$PEN"; }` above `trap cleanup EXIT INT TERM HUP` -- so the removal line names no trap and the file read straight-line. `tools/fixtures/a/aurora_placement_control.sh` releases its pen on four signals, which is the strongest shape in this tree, and was counted a leak. *What caught it:* the air rota's own instruction, that a claimed boundary is tested by pressing on it. The first `--list` line read on this lap was a `cleanup()` body, and `trap cleanup EXIT INT TERM HUP` stood on the next line of the same file. *What it taught:* **a predicate built from the majority spelling goes blind to the minority, and the minority is where the careful writers are.** Measured this stamp: of 323 controls under `tools/fixtures/`, **287 spell the trap inline and 9 spell it as a function** -- so the witness header's claim that the inline form is what *every* control carries was true of 287 and false of exactly the nine it then miscounted. Inside the class, **12 of the 18 shell files** wore that shape. *And the damage landed in the half that looked harmless:* the GATED `never_removed` reading never moved, since a function body sets `removed` either way, so no gate ever reddened and no ship was stopped. The inflation sat entirely in `unreleased_on_refusal`, which is REPORTED -- and a reported census is what a ship reads as its work queue. `construction/ITINERARY.md` had assigned *the other 324 straight-line pens, a room a lap* to this seat, and twelve of that queue were files already correct on four signals. **This is the second false positive in one predicate.** `%758` named the first: a Rishi removal spelled `run ["rm" "-rf" home]`, unseen for want of a `$` sigil. A lantern that fires twice is a loom, and the two are one fault -- a reading that recognises a removal by its spelling where it means to recognise it by its role. *What this lap did:* a first pass collects the bare names a `trap ... EXIT` registers, because the registration follows the definition in all twelve, so one pass cannot know at the removal line that its function will later be trapped; a second pass marks a removal released inside that function, from `name() {` to the first lone `}`, bounded by `max_fn_lines` at 40 so a brace this reading misses can never swallow the rest of a file. The bound errs toward calling a later removal straight-line, which is the safe direction for a leak census. `unreleased_on_refusal` falls **324 to 312** with no file changing a byte. **A function no trap names is no release:** an untrapped `sweep()` is planted to prove the registration is the whole predicate, and the closing brace is proven by a trapped function that sweeps nothing, so the removal below it must still read straight -- a cleanup that swept the pen would set the file-level flag either way and the leg would pass without proving anything. *What this does not reach:* whether a straight-line removal is ever actually reached, which is control flow rather than a scan; and the file-level `trapped` flag, which calls a whole file released on one trapped removal, so three files still print a straight line while classifying released -- each honest here, the first being a deliberate `rmdir` before `git worktree add`. **CLOSED** on `tools/p/pen_release_witness.rish` GREEN on metal, 55 control legs with 0 failures, and the `FN` and scope-close mutations each proven to bite.
