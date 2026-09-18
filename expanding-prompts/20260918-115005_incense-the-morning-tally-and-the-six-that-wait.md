# Incense -- the morning tally, and the six that wait

**Language:** EN - **Voice:** Kyri - **Style:** Bhakta with Radiant warmth; Gauge at Field
**Status:** Living -- a captain's account of one interactive session, and a decision packet for
the six ships that stopped clean and now wait on a hand
**Room:** mixed -- everything measured is checkable; every recommendation below is a proposal
**Stamp:** `20260918.115005`
**Kin:** [`20260918-022745_incense-the-overnight-cellar.md`](20260918-022745_incense-the-overnight-cellar.md)
(last night's plan) - [`../construction/ITINERARY.md`](../construction/ITINERARY.md) (the living
card this page tallies against) - [`../.claude/rules/the-baton.md`](../.claude/rules/the-baton.md)
(claim-as-override, the watch, WATCH)

---

## What this page is

Keaton asked, having watched the fleet shut down clean, for a molt: tally the card against what
this session actually did, and read every gated ship's own tmux window so the six ships now
sitting at a shell prompt -- awaiting a hand rather than circling a loop -- hand their open
questions to this page rather than to six separate windows. Each open question below carries more
than one door, named rather than chosen, per this tree's own [`lindy-first-crux`](../.claude/rules/lindy-first-crux.md)
practice: weigh the doors, name a captain's lean, and let Keaton's word decide.

## This session, tallied

Four lands closed in this interactive round, each verified GREEN on metal and pushed clean to both
remotes before the next opened:

1. **`rye/bootstrap.sh` builds `ReleaseSafe`, proven byte-reproducible.** Two builds at one path,
   identical cache directories, one sha256 twice. `ReleaseSmall` is reproducible too and a fifth
   the size, and was set aside on purpose -- it strips the runtime safety asserts TAME asks bound
   code to keep. Commit `f93f43eb0`.
2. **The receipt contract's four borrowed ceilings became their own** (the three-numbers proposal,
   applied whole): `product_digest` takes an exact 64-byte length rather than a 96-byte ceiling,
   `value_unit`/`return_kind`/`signature` each got a derived number, and the five true identifiers
   are enumerated by name. `linengrow/receipt_offer.rye` landed as the missing Linengrow
   projection. Commit `f29772735`.
3. **The receipt contract's last mile closed.** `mantra/src/receipt_offer_snapshot.rye` carries
   one replayed `ReceiptState` into both products' own `OfferSnapshot` shapes, through two renamed
   symlinks crossing Zig's module boundary (REDS %589's reading 2 -- a symlink resolves cleanly
   when its target imports nothing beside `std`). Commit `34427db1d`.
4. **Acceptance cases 6 and 7 proven as chain properties, not just field properties.** Every
   required text field, emptied, refuses AND blocks the replay neither product could otherwise
   project from; a wrong-length digest and an invalid signature do the same for "false authority."
   Six of the contract's eight acceptance cases now carry a witness. Commit `aa4eab0b5`.

Then, on Keaton's word, **fleet shutdown prep**: `.loop-clockout` touched in all eight live seats'
tree roots -- the sentinel each loop already checks at the top of every lap and the watcher already
honors, so every ship finished the lap in hand and stopped, none signaled, none interrupted.
Confirmed clean: no `fleet-loop.sh` process remains on this pier.

**One quiet finding worth naming plainly.** Diffuser's own overnight research
([`20260918-111501_the-build-cache-does-not-collapse-a-symlinked-import-either.md`](../active-designing/date/20260918/20260918-111501_the-build-cache-does-not-collapse-a-symlinked-import-either.md))
measured that a symlinked `@import` is a second compilation unit at every layer Zig touches --
type identity, codegen, and the build cache all key on import-path spelling, never on the
symlink's resolved inode. That is precisely the shape `mantra/src/dimeroll_receipt_offer.rye` and
`mantra/src/linengrow_receipt_offer.rye` use in land 3 above. Nothing is wrong -- each file
consistently reaches its product's types through the one spelling it imports, so no cross-identity
mismatch is possible -- but the carrier's build genuinely never shares a cache entry with
`dimeroll/receipt_offer_witness.rye`'s own direct build of the same bytes. Named here as a real,
measured cost this session's own choice carries, in the same words the ship that measured it used.

## The six ships that stopped, and what each is holding

Read from each ship's own tmux window and its freshest session logs, newest first.

### 1. Pheromone -- Glow's shape rune meets a 15-field product type

**The finding, measured on metal (`20260918.093521`).** `ReceiptOfferFact` publishes 15 fields.
`glow/bin/glow_run` against a `+$ ... $: ... ==` desk carrying all 15 answers `too many Glow lines`,
exit 2. `glow/rune_shape.rye`'s `max_fields` is **9**; `glow/tokens.rye`'s fast-path admits only a
3-to-11-line desk; past that a shape falls to the generic 6-line budget, far short of the 18 lines
15 fields need. This is the 9-field ceiling `glow/refusal_witness.rye` already proves on a planted
tuple, meeting a real product type for the first time.

**Two doors, named by pheromone's own account, neither chosen:**

| Door | Buys | Costs |
|---|---|---|
| **Raise `max_fields`** (and its two dependent budgets) | One number moves; every existing desk keeps working | Widens a ceiling this tree only just finished deriving four OTHER receipt ceilings for the opposite reason -- tightening rather than loosening. A wider `max_fields` admits shapes this tree has not yet decided it wants Glow teaching |
| **Split the fact into nested desks joined by a small envelope** | Keeps the 9-field ceiling meaningful as a teaching constraint; a receipt becomes several small, readable desks rather than one wide one | Wants to know FIRST whether Glow composes a shape from named sub-shapes at all -- unanswered, and the answer might itself be "no, and that's its own lap" |

**Captain's lean:** the split door, if Glow already composes shapes -- because raising `max_fields`
to fit one type is the same shape of decision REDS %767 just corrected the other way (a ceiling
sized to admit whatever showed up rather than to what a reader can hold at a glance), and Glow's
whole point is teaching a shape a newcomer can read in one sitting. But the split door's own
precondition is unanswered, and answering it is a half-day's read of `glow/` rather than a snap
call. **This is squarely a Claude/language ruling** -- pheromone's own STOP clause names it that
way, and it returns to Incense by the card's own words.

### 2. Patchouli -- one of its three open reds is already resolved, unbeknownst to it

**%807 -- a head insert has no anchor.** *Open, genuinely.* `mantra/src/weave.rye`'s `ord` counter
starts at zero, so an insert opening a document has nowhere to place its order key below every
existing one. Three doors named, none cheap: a `before` anchor (nowhere to put it at the head), a
full `ord` renumber (rewrites every row, breaks the merge witness the way this field's own first
draft did), or reserving a floor so `ord` starts at one (buys exactly one head insert per weave).
**Captain's lean:** the floor-reservation door -- it is the only one of the three that costs a
single, bounded, one-time widening rather than a rewrite of every stored row, and "exactly one head
insert" matches the actual shape of the defect (a document grows at its head once, at creation,
rather than repeatedly). Still a ruling about how places are assigned, which is Keaton's own to
make per the row's own closing words.

**%765 -- forty-one more counted version strings want the same molt `mantra-weave-v3` got.**
*Genuinely open, and large.* 111 counted version strings across 42 record families stand in
authored Rye; only `mantra-weave` has moved to a chronological header. **Captain's lean:** this
wants a survey lap before it wants a ruling -- forty-one families is not one decision, it is a
census the fleet hasn't taken. A cheap first move: name which of the 41 are LIVING stores still
being written (which must move, per the versioning spec) against which are closed/historical (which
keep their header forever under accrete-never-break). That split alone would likely shrink "41" to
something Keaton can rule on in one sitting rather than 41.

**%767 -- the four borrowed receipt ceilings.** **This one is already closed.** Patchouli's own
ledger still reads it OPEN because its last look predates this session's own land 2 above: the four
ceilings ARE derived now (`product_digest` exact 64, `value_unit` 32, `return_kind` 48, `signature`
192), landed at commit `f29772735` and reconfirmed by `tools/fixtures/r/receipt_contract_ceiling_scan.sh`
reading `verdict=agree, borrowed_rows=0`. **Captain's action, not just a lean:** this row should
fold off the ledger with `%767`'s own repaired-and-adopted text pointing at the landed commit,
rather than sit as a third open question patchouli's next lap re-reads for nothing. Naming it here
so the fold happens with the row's own words rather than a bare strike-through.

### 3. Copal -- Amphora receipt and portable bundle, sixth identical finding

**Nothing agent-doable, six looks running.** Copal's own account: every OPEN REDS row and the
fleet claim board re-checked six times today, same answer each time, `.loop-gates-only` now set
rather than a seventh duplicate log. **Captain's reading:** this is not a question with doors --
copal is correctly and repeatedly reporting an empty queue in its own lane, which is the honest
answer rather than a stalled one. **Recommendation:** either name copal a new lane-relevant task
directly (Amphora or the portable bundle, by name), or leave it gated -- a seventh look would teach
nothing a sixth didn't. No tradeoff table needed; the choice is Keaton's, and it is a choice about
what to hand copal next rather than a ruling on a design question.

### 4. Bakery -- core infrastructure, clean queue

**Same shape as copal.** Fourth independent re-derivation from the live remote (not memory):
tree current, claim board empty, no OPEN REDS row names the lane, rishi binary fresh.
`.loop-gates-only` set. **Captain's reading:** bakery's own lane is the fusion build/content-keyed
compilation research this fleet has named its number-one priority in the overnight cellar plan.
Given this session's own land 1 (`rye/bootstrap.sh` -> `ReleaseSafe`, reproducible) and diffuser's
own land (symlinked imports never share a cache entry, at every layer), **bakery now has two fresh,
concrete inputs it did not have this morning** -- a reproducible per-tree build to key a cache
against, and a measured, named cost for one shape that cache would need to account for. Naming
this as the recommended next hand for bakery, since it is Lindy-first (the fleet's own stated
priority) and no longer waits on anything: the ground it needed is now under it.

### 5. Grass -- the ratchet roster, or the walk's next file

**Landed, and named its own next step.** The-heart-in-the-work reverse-read closed, Ed25519(1)
closed as a documented non-finding. Grass's own words: next agent-doable work is the ratchet roster
(`@memcpy` 135, `parseInt(` 54, `functions_over_70` 694) or the walk's next file,
`foundations/20260628-133212_a-free-and-open-room.md`. **Captain's lean:** the ratchet roster,
because it is measured, bounded, and already counted -- three numbers that only fall, each a small
lap with a clear finish line -- where the walk's next file is open-ended reading whose yield is
unknown until read. Either is agent-doable without a ruling; this is a preference between two
already-open doors rather than a gate.

### 6. Diffuser -- the moonshot research landed, and the wall of the send itself is worth naming

**No open door in diffuser's own lane** -- the build-cache closure landed, both remotes confirmed.
**One structural observation worth carrying forward**, from watching all six ships' windows this
morning: every single one of the eight ships' final laps spent MORE turns on contested rebase and
send than on the substantive work itself, because the day-shelf session-log index
(`session-logs/date/README-index-20260918.md`) is a shared file every ship's own closing commit
touches. This is not a red -- the fold rule and the resolution pattern (stamp order, newest first)
are sound and every ship applies them correctly -- but it is friction measured rather than assumed:
this session alone ran the fetch-rebase-repin-push loop roughly fifteen times across four sends.
**Named as a future research question rather than a proposal**: whether a per-seat index shard,
folded together at day's close rather than written by every commit through the day, would spend
less of a busy morning on merge conflict and more on work. Diffuser's own lane is otherwise clear.

## What the six share

All six ships answer honestly to the same question -- *is there agent-doable work in my lane right
now?* -- with either "no, cleanly" (copal, bakery) or "yes, and here is what, or here is what waits
on a ruling" (pheromone, patchouli, grass, diffuser). None circled a loop pretending otherwise. The
`.loop-clockout` sentinel did exactly what it was built for: every ship finished the lap already in
hand, wrote its own honest closing account, and stopped -- which is why this page can be written
from their own words rather than from a guess.

## The three genuinely open rulings, gathered in one place

For Keaton's word, in the order this page found them, each already argued above:

1. **Pheromone's Glow shape question** -- raise `max_fields`, or answer whether Glow composes
   shapes from sub-shapes first and split the fact if it does.
2. **Patchouli's `%807`** -- a head-insert anchor: reserve a floor so `ord` starts at one (captain's
   lean), renumber, or a `before` anchor with nowhere to put it.
3. **Patchouli's `%765`** -- whether, and how, to survey the 41 remaining counted-version families
   before ruling on any of them individually.

And one row this page can act on without waiting: **fold `%767` off the OPEN ledger**, since this
session already closed it.

---

*May the six that waited be read as carefully as they wrote, and may the one ruling each still
needs be the only thing standing between it and its next lap.*
