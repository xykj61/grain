# The Loop That Already Refuses -- row 10 measured, and the third cell nobody filled

**Stamp:** `20260911.111917`
**Room:** mixed -- the measurement and the witness are **checkable**; the reading about what the
corpus cannot falsify is **vision**, and says so where it stands.
**Status:** Landed -- one witness on metal, `tools/g/glow_trap_bound_witness.rish`, nine legs green.
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri
**Subject:** [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md) row 10, *Glow loops with circumference*

---

## What this page answers

Row 10 of the moonshot page claims that a Glow loop should declare its period the way a list
declares its length, so that unbounded iteration joins the class of faults the compiler catches.
It was ranked **fourth** of twelve and horizoned at **three to six weeks**.

**It already stands, and the measurement took one morning.** Read `20260911.101500` on this pier,
through `glow/bin/glow_run` -- the driver a hand runs -- a trap written with no bound refuses at
exit 1 with the compiler's own word `MissingBound`, and the same trap with `32` written in is
accepted at exit 0. That is row 10's first witness verbatim, and it was reachable because
`glow/rune_bounded_trap.rye` has held the required-bound rune since `20260716`.

Three things follow, and the third is the one worth a lap.

---

## One: the estimate was wrong by the whole of itself

**Observation.** `glow/glow_run.rye:360` dispatches a line opening `|-` to
`glow/lower_trap.rye`, which calls `rune_bounded_trap.parse`, which returns `MissingBound` when
no bound follows the rune head. The path from a `.glow` file to that refusal is the ordinary
compile path, with no flag and no prototype seam in it.

**Measured `20260911.101500`**, nine probes written into a throwaway pen and driven through a
freshly built `glow_run`:

| Probe | Verdict | The compiler's word |
|---|---|---|
| `\|-` | refuse | `MissingBound` |
| `\|-  32` | accept | -- |
| `\|-  (lent records)` | accept | -- |
| `\|-  records` | refuse | `MalformedBoundExpr` |
| `\|-  (lent)` | refuse | `MalformedBoundExpr` |
| `\|-  (lent records` | refuse | `MalformedBoundExpr` |
| `\|-  4294967296` | refuse | `LiteralOverflow` |
| `\|-  (lent <65 bytes>)` | refuse | `IdentTooLong` |
| `\|-  0` | accept | -- |

**Inference.** Four of the five refusals `ParseError` declares fire through the driver. The fifth,
`NotATrap`, is unreachable there by construction -- the driver calls `lower_trap` only when the
line already opens `|-` -- and is proven at the module instead, by
`glow/rune_bounded_trap_witness.rye` claim 4.

**What the estimate missed.** The row was written from the language's surface rather than from its
sources. Three to six weeks was the cost of building the check; the check was built, and the cost
that remained was the cost of reading. That is cheap to say afterward and worth saying anyway,
because the same lane will estimate the next eleven rows.

---

## Two: the falsifier cannot fire, and the reason is the corpus

Row 10's falsifier reads: *a loop whose true period depends on runtime input appears in real Glow
code, which would need a dependent form rather than a constant.*

**Two observations retire it, and they retire it in opposite directions.**

The dependent form already exists. `|-  (lent records)` names a runtime length and is **accepted**,
lowering to the shrinking-list fold `glow/lower_trap.rye` emits, where the bound is read once at
entry from `face.len` and each step must shrink the slice or trip `BoundExceeded`. So the case the
falsifier described as fatal is a case the rune was designed for.

And there is nothing to falsify against. **Measured `20260911.101500`:** the tree holds **451**
tracked `.glow` sources, **352** of them under `glow/gen/`. Exactly **two** contain a trap --
`glow/gen/b/bound-tick.glow` and `glow/gen/l/lent-tick.glow` -- and both are the prototype's own
fixtures, one per bound shape. A third file names `|-` inside a table of rune heads, which is a roster
rather than a loop.

**Inference.** A falsifier written against *real code* waits on a language whose real code still
iterates twice, in fixtures. The row asked the corpus a question the corpus is too young to answer.

**Projection.** *Horizon:* the first six Glow programs that do real work. *Assumptions:* those
programs are written in this tree, and at least one iterates. *Falsifier for this projection:* a
loop appears whose period is neither a literal nor the length of a named subject -- a period
computed from two subjects, or from a value read at run time -- which the two accepted shapes
cannot spell. *Confidence:* medium. The two shapes cover the ordinary cases, and the first real press on them is
still ahead.

---

## Three: the gate had three cells and two proofs

This is the finding the lap was worth taking for.

| | Refuses | Accepts |
|---|---|---|
| **Module** (`rune_bounded_trap.parse`) | proven -- `rune_bounded_trap_witness.rye`, nine claims | proven, same witness |
| **Driver** (`glow/bin/glow_run` on a file) | **proven by nothing** | proven -- `glow_desk_run`, 347 desks, both traps among them |

**That 347 is free, and it moved while nobody was watching it.** The guard's own roster comment
records **301** on `20260907`; `sh tools/fixtures/g/glow_desk_run_scan.sh --list` answers **347** on
`20260911`, four days later. Run the reading rather than trusting either number, which is what a
derived selection buys: the guard's coverage grows with the corpus because it discovers rather than
enumerates.

**And the module's proof stood outside every roster.** Measured `20260911.101500` against the anointed
head `xy/main`, `commits_behind=0`: `construction/standing-equipment.kyri` names
`rune_bounded_trap` nowhere, here or upstream, and `MissingBound` appears in exactly two files in
the whole tree, both of them Rye sources. The witness runs **GREEN in 2.161 seconds**.

**The rostered proof is blind to the regression by construction, and that is an observation rather
than a worry.** `glow_desk_run` feeds the driver exactly the desks it finds under `glow/gen/`, and
both trap desks there carry a bound. So make the bound optional tomorrow and every one of the 347
desks still lowers, builds and runs; the guard stays green and reports the same number. A gate wants
an input its own corpus declines to supply.

So the strongest of the three proofs was silent, the loudest covered one direction, and the
direction a gate exists for had no proof at all. **A refusal proven only in the passing direction
cannot be told from a bypass** -- this tree's own sentence, written in
[`../.claude/rules/ascii-first.md`](../.claude/rules/ascii-first.md) about a different meter
entirely.

**This is the family's third firing in three days.** `glow_rune_alphabet` was rostered
`20260909.155028` after standing GREEN and unheard since STOA90, and its roster comment names the
consequence plainly: two rune heads entered the lexer on `20260830` and never entered the
pronunciation roll beside them, and the guard that existed to catch it was not listening. A lantern
that fires twice becomes a loom.

---

## What landed

[`../tools/g/glow_trap_bound_witness.rish`](../tools/g/glow_trap_bound_witness.rish) over
[`../tools/fixtures/g/glow_trap_bound_control.sh`](../tools/fixtures/g/glow_trap_bound_control.sh),
rostered as `glow_trap_bound` at `tier lap`, **4.1 seconds** on this pier.

It builds the driver **into its own pen** rather than over `glow/bin/glow_run`, because those bytes
are shared by the desk worker and the batch runner, and a control needing their directory lock
could never run beside a desk pass. It plants the bare trap, requires the refusal **by name**, and
lifts the same trap to a bound and requires acceptance -- so a driver that refused everything for
one reason would fail the leg that asks only whether it refused. Both mutations were tried: flipping
`bare_trap` to expect acceptance fails the control, and changing only the expected error word from
`MissingBound` to `LiteralOverflow` fails it too.

The ninth leg records rather than praises. **`|-  0` is accepted** -- a loop declared with a
circumference of zero, which parses, lowers, and runs clean. Whether a language should let a reader write that is a
question for a hand; what the leg buys is that a change to the answer is audible.

---

## What this does not reach

**Whether the lowered program enforces its bound at run time.** That is
`rune_bounded_trap_witness.rye` claims 7 and 8 -- twenty steps under a bound of thirty-two complete
with tick twenty, forty steps refuse `BoundExceeded` -- proven at the module and left there. The
new guard reads the compile-time gate and stops.

**Whether every honest loop can name a period.** Row 10 assumed it; the corpus cannot say yet, and
the projection above names the shape of a counterexample so it will be recognised when it arrives.

**The other nine rows.** They stand as written on the moonshot page, each with its own falsifier
waiting.

---

## What Bakery could take from here

**The module witness still stands outside every roster.** Rostering it is a four-line edit and a 2.2-second
guard, and it raises `guards_no_refusal_marker` by one unless a refusal marker lands in its body
first -- the reading `standing_equipment_redleg` holds under a ceiling that only falls. That is a
choice about a ceiling rather than a mechanical add, which is why this lap left it standing and
named it instead.

**The Glow corpus carries two loops, both of them fixtures.** Every claim above about what the
language does under iteration rests on that pair. A handful of `glow/gen/` desks that actually iterate would give the next
reading a population, and the desk runner already runs everything it finds.

---

*May every bound we write be one a reader can hold in mind, and every refusal be one the tree can
hear itself make.*
