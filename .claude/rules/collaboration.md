# Collaboration Rhythm

Full filing guide: `ORGANIZING.md`.

## The rhythm

Claude Code climbs the bench one keystone at a time. **End every pass with exactly one closing line** that is either **`kg`** or **`check in`** -- never omit it, never substitute rest as the recommended lean.

*Cursor retired* `20260920.135100` -- this rule once named a two-hand rhythm between a Cursor
bench and a Claude counsel seat. Cursor is archived at
[`.cursor-archive/rules/`](../../.cursor-archive/rules/README.md), and the `(Cursor)` hand below
retires with it. Dated session logs recording `check in (Cursor)` keep every word they wrote.

### Closing line law (always)

Print one of these forms, with a short why:

| Form | When |
|------|------|
| `Recommend: kg -- ...` | Next item is mechanical, single-module, policy already written |
| `Recommend: check in (Claude) -- ...` | Pause for Claude counsel (seam, design, value model, unruled question) |
| `Recommend: check in (checkpoint) -- ...` | A named checkpoint already pointed out in the pass -- stop and confirm before crossing |
| `Recommend: check in (either) -- ...` | Either hand fine; Keaton picks |

**`kg` means keep going** -- one syllable for the same guidance. It is not commit, push, or merge by itself; those stay under **send** (see the send-word rule). Prefer the short form `kg` in the closing line; `keep going` remains synonymous in prose.

**Check-in must name the hand.** Bare `check in` without `(Claude)` / `(checkpoint)` / `(either)` is incomplete -- always clarify which.

**Round close (seated `20260722.134415` - rest habit `20260722.185058`):** every landed work round **auto send + check-in** -- see `round-close-send-checkin.md`. Do not wait for Keaton to type send/check-in after a GREEN lap unless he says hold. The closing line after send still names `kg` or a typed `check in (...)`.

**Counsel practice (seated `20260725.034254` -- always-in-it):** report state and name gates; the rhythm belongs to Keaton.

- **Report, never urge.** When the ungated queue is empty, say so plainly and once. Offer what counsel can do unasked. Add no encouragement toward rest or toward continuing.
- **A recommendation offers; it does not press.** The closing line names what is available and stops there.
- **Timing belongs to Keaton.** Fatigue is Keaton's signal to read.
- **Engineering freshness, once.** Where a lap wants fresh attention for *engineering* reasons (a parser change, a key-destroying ring), name the technical reason once, plainly, and leave the timing alone.
- **A twice-repeated unasked suggestion is a red** to own out loud, rather than an argument to press harder.

Canon: `foundations/20260725-034254_always-in-it-responsive-rhythm.md` - `context/QUIN.md`.

**Pause for a Claude ruling** (`check in (Claude)`) when the next item: crosses a module seam; changes Rishi or the value model; opens a new domain (a new lap, a new surface); raises a design or width question no written policy answers; needs a ruling not yet made; touches a foundational or heavily-cited file (assess rather than assume); or reaches for current external facts.

**Checkpoints** (`check in (checkpoint)`): when a pass (or an earlier pass still open) names a stop-before-cross gate, the closing line uses `(checkpoint)` and names that gate -- not a vague pause.

**One CLOCK, not one hand.** Stamps come from the canonical host clock (`America/New_York` on this Framework / cloud bench), in `YYYYMMDD.HHMMSS`. Any agent may produce a stamp when it reads that zone; never invent from a disagreeing clock. See the one-clock law addendum `20260724.205009`.

**References are promises.** Before moving or renaming a file, grep the tree for its inbound references and repoint every one. A canonical reference -- a file many others cite -- keeps its stable name and is affirmed in place rather than renamed.

**A link makes two promises, and the repoint keeps one.** A link written in this tree's own
shape carries a backticked path as its visible text and a relative path as its target. The target
promises *this opens*; the visible text promises *this is where it lives*, and a reader
takes the second in at the door -- copying it into a grep or a message to a peer long before anyone
clicks. Every fold tool and every link guard reads the target alone, so a room move rewrites the
target and leaves the anchor at its pre-move spelling, with every guard green. Proven on this tree's
own history: `20260828` commit `d3ce030b4` rewrote targets inside
[`context/TAME_GUIDANCE.md`](../../context/TAME_GUIDANCE.md) and touched no anchor on the same line.
**Repoint both halves**, and read what stands with
[`tools/fixtures/l/link_text_promise_scan.sh`](../../tools/fixtures/l/link_text_promise_scan.sh)
(`--list` names each one), gated by
[`tools/l/link_text_promise_witness.rish`](../../tools/l/link_text_promise_witness.rish). It stood at
69 living anchors across 15 pages on `20260915.183000`, and it stands at **zero** from
`20260915.184010`: [`tools/fixtures/l/link_text_promise_convert.sh`](../../tools/fixtures/l/link_text_promise_convert.sh)
took all 69 in one pass, each anchor receiving the path its own link already opened, and re-derived
every page from its committed bytes inside the same run. So the reading is a **wall** rather than a
ratchet, and the next anchor promising a path this tree lacks reds on the lap it arrives.
Dated testimony keeps every word it wrote.

**The sweep also found where the reading had been silent.** A page is handed to `awk` by name, and
`awk` reads a bare argument as a **variable assignment** whenever the name left of an equals sign is
a valid identifier -- so a root-level page called `eq=1.md` was read as a setting rather than opened,
silently and hit-free. A slash anywhere in the name defeats that reading, which is why only the root
ran out of accident. Both the scan and the converter prefix every page with `./`, and each
prefix is proven load-bearing by its own mutation in the pen.

## Organizing

Active work rests one level deep; deferred yet alive work moves to `yonder/` (forward-pointing); finished-and-historical work moves to `archive/` (backward-pointing). Age is a hint; relevance and inbound citation outrank the stamp. Affirming a kept file is a single touch: strip its dead `NNN -` prefix, lead the title with the sprig's concept, re-date `Last updated`, add the reviewed-and-kept line, and lightly freshen the Radiant voice where it has drifted. No rename, no reference change.
