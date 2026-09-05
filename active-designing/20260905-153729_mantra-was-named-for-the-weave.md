# Mantra was named for the weave and built as a catalogue

**Stamp:** `20260905.153729` -- **Status:** Design, proposed -- **Setting:** Gauge, Field -- **Voice:** Kyri
**Kin:** [`what-mantra-is`](../foundations/20260825-211056_what-mantra-is.md) - [`the pen, the gossip, and the derived spine`](20260825-205011_the-pen-the-gossip-and-the-derived-spine.md) - [`derived-spine`](../.claude/rules/derived-spine.md) - [`lindy-first-crux`](../.claude/rules/lindy-first-crux.md)
**Provenance:** the weave's ancestry is studied and thanked in [`gratitude/README.md`](../gratitude/README.md) and [`external-research/yonder/20260617-195312_mantra.md`](../external-research/yonder/20260617-195312_mantra.md). This room names our own shapes only.

## The measurement, before the argument

Measured `20260905` on this pier, by `find`, `grep -c`, and `git ls-files`:

| Reading | Count |
|---|---|
| `mantra/` Rye modules | **32** |
| lines of authored Rye in them | **9,175** |
| Rye files outside `mantra/` that reach into it | **120** |
| witnesses named for Mantra, across `tools/` and `linengrow/` | **~26** |
| of those, entries on `construction/standing-equipment.kyri` | **0** |
| `mantra/*.rye` files mentioning conflict, merge, three-way, or diff3 | **0** |

Two of those rows are the whole of this essay. Mantra is the **most-depended-upon module in the
tree**, its proofs ran only when a hand remembered, and the shape it was named for still waits to be
built.

## What the name was given for

The name was chosen because a mantra is a faithful utterance, repeated and kept, never lost in the
saying -- and that is what a **weave** is: one structure holding every line a file has ever held,
each line carrying when it arrived and when it left, so the history lives *inside* the structure
rather than being reconstructed from a chain behind it.

From that one shape a cascade follows, and each item is a property rather than a hope:

- **Every merge succeeds.** Two states go in, one comes out, and the answer does not depend on the
  order the branches were combined in. Commutative and associative, structurally.
- **A conflict is shown.** When two edits land too near each other the merge still produces a
  result, annotated with what each side did -- *this side deleted the function, that
  side inserted a line inside it*. A story rather than two opaque blobs and a refusal.
- **A line's presence is a count.** An integer ticks up on every add-or-delete cycle, odd for
  present, even for gone, and the higher count wins on merge. No commit identifiers are consulted,
  so the algorithm stays structural, reading only the counts in front of it.
- **Rebase and squash keep the whole truth.** The tidy line is a presentation over a history that
  was never discarded.

One cost is named rather than hidden: the interpretation of an edit is baked into the weave at
commit time, so the diff that produces it must be excellent and changed only with great care.

## What was built instead, and it is good

`mantra/` today keeps a different promise, and keeps it well: **ask for a name, and you get exactly
the bytes you got last time, forever.** Content-addressed, immutable, only ever growing.
`recall_two_way_sync.rye` composes catalogue revisions symmetrically; `resin_batch.rye`,
`snapshot_export.rye`, and `bolt_apply_step.rye` carry the store. One hundred and twenty files
depend on it -- Brushstroke's whole photo library, Pond's apps, the editor's undo.

This is a real module doing load-bearing work under exactly the right name, because a name bound to
bytes is as faithful an utterance as a weave is. **Both promises belong to Mantra**, and one of them
stands built today.

## The evidence the weave still wants building

Three, each of them measured.

**The first is that the technique already works here, on a smaller structure.** The derived spine
law binds a ledger row's identity to its one-clock stamp and *derives* its `%N` from the merged
record rather than letting two writers race for it. That is a convergent, order-independent name
computed at merge time -- a weave's own reasoning, applied to one column of one file. It was seated
only after the collision fired **six times** and was repaired by hand every time. The pattern is
proven on this pier; what is missing is its general form.

**The second is that the fleet's git discipline is a workaround shaped exactly like the gap.**
`fleet_round_open.sh` adopts the anointed order by **reset, never merge**, and parks a genuinely
diverged line on a branch rather than merging it. That is correct, and it is correct *because*
merging is the dangerous operation -- the round-open's own rebase clause exists because an
interrupted merge in flight can lose work (REDS `%428`). A system whose merges always succeeded would
carry that weight as an ordinary merge instead.

**The third is that a hand reached for it.** The suggestion that opened this round -- *if you are
struggling with merge conflicts, use Mantra* -- is exactly right about what Mantra is for and
exactly wrong about what it can do today. An instinct that reaches for a tool by its name, and
finds the name has no such tool behind it, is the cleanest signal a design can get.

## The crux, ordered Lindy-first

Two candidates stand, and they are not the same size.

**Guard what exists** -- roster the ~26 Mantra witnesses that already pass and that nothing runs.
**All twenty run GREEN, timed `20260905`: 62s together.** Seated the same day by what each proves --
the module's own contracts at `lap` (**39s**), the Realidream surface built on it at `cadence`, the
fifth round (**23s**). Against a hot pass of 904s that is **+4.3%** on the lap clock. This
is the **cheap durable move**: 120 files depend on a module whose proofs run only when a hand
remembers.

**Grow the weave** -- give Mantra the shape it was named for. This is the **crux**: hardest of the
solvable moves, and the one that, once made, dissolves a class of problem rather than guarding
against it.

Lindy-first takes the guard first, because it protects nine thousand lines that many things already
stand on and it costs one round. Crux-first takes the weave next, because every round after it is
cheaper than every round before it.

## The arc, sized to one orbit

Fifteen rounds is one orbit's capacity, and this arc is drawn to fit inside one. Movements are
marked by stamp and name, never by an ascending number, and each is complete in itself -- a
movement that lands and stops leaves the tree better than it found it.

- **The proofs run** *(landed `20260905.153729`)* -- twenty Mantra witnesses joined
  `standing-equipment.kyri`, `tier_lap` 113 to 121 and `tier_cadence` 25 to 37. A module with 120
  dependants now has its proofs run on a clock rather than on a memory.
- **The line, and its count** *(three rounds)* -- one authored Rye module holding a line, its
  arrival, its departure, and the integer that ticks between them. Bounded, asserted, explicit
  widths. The witness proves the count's law on planted cases before any file is woven.
- **The weave, and its order** *(three rounds)* -- lines composed into one structure whose order,
  once decided, is permanent. The witness proves commutativity and associativity by *doing* --
  merging the same three states in all six orders and asserting one answer.
- **The showing** *(three rounds)* -- the annotation that says what each side did. This is the
  movement where the module earns its temper: a result always exists, and the human is told a
  story rather than handed a wall.
- **The seam** *(three rounds)* -- the weave meets Tablecloth by content, so a build draws its
  inputs from a source history rather than from a remembered pin.
- **The reading** *(two rounds)* -- one foundation, written for a first day, naming both of
  Mantra's promises as one promise wearing two clothes.

## What this claims, and what it leaves standing

**The catalogue stays exactly where it is.** Every module in `mantra/` keeps its name, its shape,
and its place. One hundred and twenty inbound references are a promise, and the weave grows beside
the catalogue rather than over it.

**The weave is real work.** It is an algorithm with a named cost, and the diff that feeds it earns
trust before the weave leans on it. Three rounds per movement is an estimate, and the falsifier is
the first movement running long.

**Merges are quiet today**, and the fleet's reset-never-merge discipline is why -- this round hit
zero conflicts. The argument is that the discipline is a wall standing where a door was designed,
and the door is still worth hanging.
