# The refusal that leaves no trace

**Stamp:** `20260906.003146`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Living -- research for understanding. A Civic Style audit of the Mand custody vane; every
count below is measured on this pier at the stamp above, and every measurement is re-derivable from
the commands quoted beside it.
**Kin:** [`../mand/README.md`](../mand/README.md) -- [`../context/CIVIC_STYLE.md`](../context/CIVIC_STYLE.md) -- [`../caravan/capabilities.rye`](../caravan/capabilities.rye) -- [`../foundations/20260826-021735_earth-the-row-that-breathes-in.md`](../foundations/20260826-021735_earth-the-row-that-breathes-in.md)

Civic Style asks one question of anything that spends public trust: **name the outcome you want, name
what the design rewards, and check that the two stay aligned.** Mand is the room where this tree
keeps custody -- who may see a record, how long it is held, when a per-subject key is destroyed. So
it is the room where that question earns its keep.

This reading takes the question to the three rings and finds one answer running through all of them,
on two floors. **The trail records the welcome and stays quiet about the turn-away.** And the table
that would name why somebody was turned away sits in a room Mand copied from before the naming
was written.

## What the trail actually holds

The concrete fact first, read off the code rather than off the README.

`mand/mand_ring1.rye` gates one seam: may this reader see this record. Line 124 writes the audit
line, and lines 122 and 123 refuse ahead of it -- once for a reader whose label differs from the
authority it claims, once for an authority the capability table does not grant. Both refusals return
before the trail is touched.

The same shape holds one ring up and one ring down. `decide_retention` in `mand/mand_ring2.rye`
writes its line at 186, and four refusal paths reach it from behind -- 138, 156, 157, 158 -- each
returning first. `destroy_key` in `mand/mand_ring3.rye` writes its removal fact at 234, and six
refusals stand ahead of it at 221, 222, 223, 227, 228 and 229.

**Twelve refusal sites across three rings return before their own trail is written.** Reproduce the
count:

```sh
grep -n "return error\.\|audit.append\|removal_log.append" \
  mand/mand_ring1.rye mand/mand_ring2.rye mand/mand_ring3.rye
```

## The silence is proven, which is what makes it interesting

A gap left by accident is a slip. This one is held by proof.

Six assertions across the three witnesses state that a refusal leaves the trail exactly as it found
it: `mand_ring1_witness.rye` at lines 53, 63 and 73, `mand_ring2_witness.rye` at 91, and
`mand_ring3_witness.rye` at 61 and 86. Each reads `assert(audit.count == before)` or
`assert(removal_log.count == 0)`.

So the rings do precisely what they were built and witnessed to do. The design is intact. Civic
Style's question is the other one: is this what anyone wants?

The witness even says the quiet part in its own report line:

```
mand-ring1: refused path -- stranger Refused, audit unchanged -- GREEN unwelcome path
```

*Audit unchanged* is printed there as the good news. An auditor reading that a stranger was turned
away would want the second clause to be the alarm.

## What the design rewards

**The outcome anyone would want:** an auditor opens the trail and can answer *who reached for this
record, and what happened?*

**What the trail measures:** successful reaches, only.

**Where they part.** A reader who probes a hundred record identifiers and is refused a hundred times
leaves the trail byte-identical to the trail before they arrived. That holds for a stranger sweeping
identifiers, for an over-broad role discovering its own edges, and for a record whose retention
schedule stands unpublished -- ring 2 answers that last one closed, which is right, and answers it
in silence, so the gap in the schedule stays undiscovered.

Read as an incentive: a prober pays on the record only where a reach succeeds. Civic Style's own
Accountability Layer names the standard this falls under -- *surface anomalies as readily as
successes* -- and a trail of grants alone surfaces the second.

## The bound turns the asymmetry into pressure

`max_audit_entries` is **8** (`mand/mand_ring1.rye:28`), and the ceiling is spent by grants alone.
Once eight lawful reads have landed, `try audit.append` at line 124 answers `AuditFull`, and a
**granted** read becomes a refusal. Refusals at 122 and 123 never reach the append and never spend a
slot.

So the trail's cost falls entirely on the authorized, and the quiet belongs to whoever was
turned away. Under a bounded log, a busy lawful reader is turned away at the ceiling while a
prober runs indefinitely clear of it.

The bound itself is right -- TAME asks every collection to name a maximum, and this one does. What
the reading names is who pays for it.

## The second floor: a note addressed to a reader who cannot receive it

Caravan built the instrument this gap wants. `caravan/capabilities.rye` publishes `refusal_reason`,
which answers with one of `no_such_dependent`, `no_such_resource` or `rights_insufficient` where
`allows` hands back a bare boolean. Its own comment, at lines 183 to 185, says why:

> A capability system that cannot say which one cannot audit its own refusals, so this names the
> reason. Mand's ring-1 audits on grant; a refusal deserves the same legibility.

That sentence names Mand. Mand's own copy predates it.

`mand/capabilities.rye` is a **copy**, mode `100644`, 262 lines against Caravan's 305. It publishes
`Refusal` nowhere and `refusal_reason` nowhere, so `may_see` in `mand/mand_ring1.rye:93` reaches
`table.allows(...)` and receives a bare boolean. The three reasons exist one room over, in the file
this one was copied from, behind a sentence written after the copy was taken.

```sh
git ls-files -s mand/capabilities.rye caravan/capabilities.rye linengrow/capabilities.rye
comm -13 <(grep -oE "pub (fn|const) [a-zA-Z_]+" mand/capabilities.rye | sort -u) \
         <(grep -oE "pub (fn|const) [a-zA-Z_]+" caravan/capabilities.rye | sort -u)
```

## The tree already knows the answer, and applies it next door

Three rooms hold a `capabilities.rye`, and the modes tell the story at a glance:

| Path | Mode | Held as |
|---|---|---|
| `caravan/capabilities.rye` | `100644` | the original, 305 lines |
| `linengrow/capabilities.rye` | `120000` | a symlink to Caravan's |
| `mand/capabilities.rye` | `100644` | a copy, 262 lines |

The symlink is the tree's own habit, and Mand keeps it for a different file in the same directory:
`mand/tally_copy.rye` is mode `120000`, pointing at `../tally/copy.rye`. Zig admits an import
only from the root file's own directory, so a symlink is how one
implementation reaches two rooms here.
Mand has the tool and uses it beside the file that lacks it.

## How rare this is, measured

A tree this size could hold many such copies, which would make this one ordinary.
Measured across every tracked Rye file at the stamp above, the reading runs the other way.

**140 basenames live in two or more rooms**, across 414 paths -- 220 held as symlinks, 194 as
regular files. **108 of those basenames are held both ways somewhere**, and those 108 carry **113**
regular files between them -- the population worth comparing, where a room symlinks the shared
implementation while another room keeps a file of its own under the same name.

Comparing each such file against the implementation its siblings link:

| Reading | Count |
|---|---|
| byte-identical to the linked original | 108 |
| differing in content | 5 |

Of the five, three are separate modules sharing a word: `lotus/fold.rye` folds a waveform where
`mycelium/fold.rye` folds a ledger, `lotus/stack.rye` is a program with a `main` where
`tally/stack.rye` is a 36-line generic, and `mikrophone/verify.rye` publishes one `verify` where
`crypto/verify.rye` publishes a constant-time family. Each of those publishes something its
namesake lacks, which is the signature of a sibling rather than a lag.

**The detector falls out of the data.** A file that publishes nothing its namesake lacks, while
lacking things its namesake publishes, is *behind* rather than *different*. Two files carry that
signature. `caravan/parse_int.rye` trails `tally/parse_int.rye` by two comment lines, its
code identical.
`mand/capabilities.rye` trails `caravan/capabilities.rye` by four published items.

So, at this stamp, **exactly one file in this tree is a stale copy of live code, and it is the
capability table of the custody vane.**

## Two rooms, kept honest

The counted half of this reading is checkable and stands in the checkable room: the twelve refusal
sites, the six assertions, the ceiling of eight, the four missing published items, the 108 and the
5. Each carries the command that reproduces it.

The judged half stays where it belongs. Whether a custody trail *should* record refusals is a policy
question with real costs on both sides -- a trail that records every turn-away is a trail an
adversary can flood, and a bounded one that admits refusals is a trail an adversary can flood
*deliberately*, evicting the grants. That trade is exactly why this reading names the finding and
leaves the ruling to a hand rather than proposing a patch.

## What a repair would look like, sized

Named so whoever holds these rooms can weigh it, rather than taken here. Mand and Caravan both sit
outside this seat's lane, and a lagging copy is repaired by the room that owns it.

**The copy.** Replace `mand/capabilities.rye` with a symlink to `../caravan/capabilities.rye`,
matching `linengrow/` exactly. The copy publishes nothing of its own, so the three rings compile
against a superset. One line, plus the three ring witnesses run GREEN.

**The trail.** Give `AuditLog` a second outcome per line -- granted or refused, with the refusal's
reason where `refusal_reason` supplies one -- and let each refusal path write before it returns. The
six witness assertions become assertions that the count rises by one and the line reads *refused*.
The ceiling of eight then wants a second look, since grants and refusals would share it.

**The meter.** Nothing in the tree today compares a copy against the file its siblings symlink. The
measurement above is one shell pipeline, so the guard is small: hold the differing count at its
measured five, and let a sixth red the lap it arrives.

## What this reading does not reach

Whether Mand's rings are correct: they are witnessed, and this reading confirms what they
decide. Whether the missing `refusal_reason` has ever mattered in practice: ring 3 carries test-only
reach today, so the answer is very likely no, and that is the best hour to fix it.

And whether the trail should change at all stays Keaton's word. Civic Style's job finishes at
naming what the design rewards; the choosing belongs to a hand.

---

*May every refusal be as legible as every welcome, and may the record hold the whole of what
happened at the door.*
