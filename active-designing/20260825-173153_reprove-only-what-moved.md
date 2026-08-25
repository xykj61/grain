# Reprove only what moved -- three ranked moves for the harness

**Stamp:** `20260825.173153`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- design, proposal; no code written this round, no ruling assumed, no custody gate crossed
**Kin:** [`../external-research/20260825-173153_dependency-tracked-proving-the-worlds-answers.md`](../external-research/20260825-173153_dependency-tracked-proving-the-worlds-answers.md) -- the Mantra witness-receipts hammock (`counsel/date/20260726/20260726-050047`) -- [`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md)

## The costs, named first

The every-lap roster measures 20m20s to 22m19s on the Linux pier and runs twice per lap -- a cold
open and a hot close -- so a lap pays about forty minutes of proving. The tree's own record
already treats that price as a driver of failure: REDS %220 reads *"a close costing twenty-five
minutes is a close that gets skipped."* Separately, 1,314 witnesses rebuild their Rye modules
unconditionally on every run, and one measured witness spent 80-90% of its wall time in the
compiler. Those are two different wastes, and they earn two different fixes.

## The question this design answers

Keaton asked two things. First: can the harness tell which proofs a `.rye` change actually
touches, so the rest keep their greens? Second: if the whole suite proves GREEN at a lap's close,
and this loop is the tree's only writer, why reprove everything at the next restart?

The second question has a sharp honest answer. **The waste is real, and the skip is currently
unlawful.** The seated witness-receipts design (`20260726-050047`) already rules that FAST --
any mode that consults a cache -- never satisfies a COLD gate, and the cold open is a COLD gate.
So the restart skip is first a policy amendment only Keaton can make, and an engineering trick second. The design below makes the skip *safe to rule on*, and the ruling stays his.

There is also a mechanical surprise: today the skip would rarely fire anyway. The hot roster runs
at `git add`, the commit lands after it, and the pre-commit hook regenerates README pages when a
witness shipped. The tree at the next cold open therefore differs from the tree the hot roster
measured. Making the digests match means reordering the lap tail -- roster last, after the
commit -- which is its own small choreography change, named here so it is chosen rather than
discovered.

## Three moves, ranked TAME-first

### Move 1 -- the build skip: content-keyed compilation, zero proofs skipped

Teach `rye/bin/rye build` (or a thin wrapper the witnesses call) to compute a digest over the
staged source set, the flags, the `rye/lib` overlay, the Zig version, and the `rye` binary
itself; stamp that digest beside the emitted binary; and skip spawning Zig when the digest
matches. Every witness still runs. Every assertion still executes on metal. Only recompilation of
byte-identical inputs is skipped, so the worst outcome is running a binary rebuilt from identical bytes -- an old timestamp at most, with a fabricated green structurally out of reach.

This is the move that respects the FAST/COLD law by never entering its territory: a build skip is
not a proof skip. It lands without a ruling, lives in one tool, and the compile fraction says it
carries most of the recoverable time. Git's index supplies the content hashes for tracked inputs
free of charge (`git ls-files -s`), so the digest costs little.

**Falsifier:** a control witness flips each key component in turn -- one source byte, one flag,
one `rye/lib` byte, the Zig version, the `rye` binary -- and proves each flip MISSES; an
unchanged-input run proves the skip fires; then one instrumented roster pass on the Linux pier.
If wall time barely moves, the compile fraction was wrong and the move dies on its own
measurement. A cache proven only in the hit direction cannot be told from a bypass, so the MISS
legs are the gate.

### Move 2 -- the restart skip: a whole-roster verdict record, gated on a ruling

Persist what the runner already computes and discards: at a hot close where every guard is green,
write `{tree_digest, roster_version, verdict, stamp}` to a gitignored shelf. At the next cold
open, compare. On a match, the runner MAY print the recorded green with its receipt named --
`GREEN (receipt <digest> <stamp>)` -- and skip only the rows whose inputs live entirely in
tracked content. The always-run set (clock, network, untracked state, the interpreters
themselves) runs regardless, every time.

Safety rests on the digest rather than the sole-writer assumption: a second writer, a
hook, or a hand-edit changes the digest and forces the full run. Sole-writer only raises the hit
rate. This is also why the mechanism stays honest under the three-MOX horizon
([`20260825-133156_three-real-mox-and-the-outer-loop.md`](20260825-133156_three-real-mox-and-the-outer-loop.md)):
more writers means more misses, and every hit stays true.

**What it waits on, in order:** (1) Keaton's ruling amending the FAST/COLD law for the cold open
specifically -- the seated design forbids this today, and landing it without the ruling would
breach the tree's own written law; (2) a measured hit rate -- instrument the runner to record the
hot-close digest for a week of real laps and count matches at the next open, because if the lap
tail keeps moving the tree, the cache stays idle and the complexity is declined; (3) the lap-tail
reorder, so the recorded digest describes the tree the commit actually shipped.

**Falsifier:** a planted tracked edit must miss; a planted untracked file in a bounded room must
miss; a chmod must miss (the exec-bit lesson); and the measured hit rate must clear a floor worth
the machinery. Any drift class that hits converts the roster from evidence to rumor, and that is
a red, not a tuning knob.

### Move 3 -- per-witness receipts: the seated hammock, plus the verify mode it lacks

The witness-receipts hammock already designed the fine-grained end: a receipt per witness keyed
on `SHA3(script_bytes || sorted_input_hashes || toolchain_pins || ABSENT_set)`, a gitignored
shelf, FAST and COLD modes. Two additions from this round's research before it lands:

- **Input digests read from git's index**, never fresh hashing over the tracked set.
- **A cadence-tier verify witness from day one**: re-run a sample of receipt-hits cold each
  cadence lap and assert verdict equality. This is rustc's `verify-ich` made standing -- the Rust
  compiler shipped silently unsound incremental caching for 28 releases and found it only when
  recompute-and-compare was forced on. A single verify mismatch disables the whole shelf and
  books a red under reds-first, because flakiness under an unchanged closure means an undeclared
  input exists.

Manifests are declared, then verified: the living-build counsel wants dependencies as declared
values, the rustc record shows declarations drift, and the synthesis is the tree's own both-sides
habit -- declare the manifest, and let a cadence check trace real file opens against it. Before
any code, hand-write manifests for five witnesses spanning the classes (a choir, a build-heavy
module witness, a tree scan) and trace one run's actual opens; any opened path absent from the
declaration falsifies declared manifests at that grain.

**Falsifier:** the five-witness manifest trace above, then the verify sample in production. The
hammock's own gate stands unchanged: an instrumented cost table first, and Keaton's word.

## Why this order

Safety first: Move 1 keeps every proof running and lands free of any ruling. Measurement second: Move
2 is cheap to instrument and its hit rate decides it; its ruling is surfaced rather than assumed.
The ceiling third: Move 3 scales past the 63-row roster to the full 1,690-witness suite, and it
costs the most machinery, so it goes last and rides on the two measurements the first moves
produce. The three compose rather than compete -- if Move 1 alone collapses the roster's compile
fraction, the residual payoff of Moves 2 and 3 shrinks and is re-measured before their soundness
risk is bought.

## The adversarial paragraph, kept where it can be read

Every cache replaces a run with a claim of equivalence, inside a tree whose seated epistemology
is *measurement beats memory* and *a fix closes on a witness on metal, never a claim*. The
runner's own header calls a second exemption "the hiding place the refusal exists to close." And
this harness has a reader rustc never had to fear: an autonomous loop is often the only thing
reading the greens, so a wrong cached GREEN persists until it ships a broken seed. That is why
every move above carries its MISS-side control, why the verify mode is load-bearing, and why the
one move that skips no proof at all goes first.

## What this document does not do

It stays at design altitude: zero code, the seated designs held as written, the Linux pier left to its own laps. The
FAST/COLD ruling, the hammock's cost-table gate, and the lap-tail reorder are all named and left
standing for Keaton's word.
