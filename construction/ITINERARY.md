# ITINERARY -- the receipt-value product fleet

**Language:** EN
**Status:** Living pin -- operator card; full eight-ship formation sailing
**Stamp:** `20260912.144043` (EDT)
**Voice:** Kyri
**Style:** Bhakta with Radiant warmth; Gauge at Meter
**Molted from:** [`archive/20260912-142909_itinerary-bound-before-flight.md`](archive/20260912-142909_itinerary-bound-before-flight.md). The archived card remains historical continuity outside Mitra and shred-prep.
**Prior elder:** [`archive/20260912-141814_itinerary-before-lindy-crux-molt.md`](archive/20260912-141814_itinerary-before-lindy-crux-molt.md).
**Bound:** `living_pin_max_bytes[construction/ITINERARY.md] = 40960`. Raised to 49152 on `20260915` when the card stood 39 bytes under its ceiling, then **withdrawn the same lap**: the fold of the landed accounts took the card from 41,230 bytes to 20,002, so the raise was no longer earned. A bound that only falls is the one worth having.

Keaton's `20260913` word accepts the first receipt contract and chooses the full eight-ship formation. The watcher may keep every live seat sailing; product and custody walls below remain unchanged.

## THE PIER FILLED, AND CLEARED WHILE THIS WAS BEING WRITTEN (`20260915.220053`, REDS %745)

**176G, 990M free, 100 percent.** `/tmp` holds **94G across 41,063 entries**, and **32G of it is
1,312 pens** leaked by one rostered witness: `tools/am/amphora_mark_wreck_witness.rish:36` makes a
24MB pen with `mktemp -d /tmp/amphora_mark_wreck.XXXXXX` and never removes it. Oldest `20260907`,
newest the minute it was measured -- **still leaking, once per run, on every ship**.

**Nothing was reading the pier's free space.** The first instrument to notice was a `pwd` inside a
send answering `write error: No space left on device`. Builds will begin failing across the fleet
for reasons that look like anything but this.

**AND THE PRESSURE LIFTED 107 SECONDS LATER, BY A HAND THIS LAP CANNOT NAME.** Re-read
`20260915.220240`: **84G free, 50 percent**, `/tmp` down to **11G across 5,409 entries**, and the
leaked pens from **1,312 to 13**. It was not the scheduled cleaner --
`systemd-tmpfiles-clean.timer` last ran at **17:32**, four and a half hours before the full reading.
So 82G was reclaimed by a peer, a finishing pass, or a hand, and **nothing recorded it**, which is
its own small lesson: the pier has no log of who takes 82G back.

**The crisis is over and the leak is not.** `amphora_mark_wreck_witness.rish:36` is unchanged and
still leaves a pen on every run; 13 stand already. At roughly 150 runs a day across eight ships this
refills in about a week, and the next ship to meet it will meet it mid-send, as this one did.

**Deleted nothing, deliberately.** **The repair is copal's lane** -- the `trap 'rm -rf "$pen"' EXIT`
every `tools/fixtures/` control already carries. **What is yours:** whether the fleet should read its
own free space at all. The first instrument to notice a full pier was a `pwd` builtin failing, and
5,409 `/tmp` entries still say this witness is unlikely to be the only leaker.

## NOW -- incense sails autonomous from `20260915.180000`

The ledger's sixteen OPEN rows were read on metal this lap: **one CLOSED** (`%700`), **eight
BOOKED** -- instances repaired, remainder a ratchet or a booked lap -- and **seven still OPEN,
every one wanting Keaton's word**: `%689` `%680` `%678` `%636` `%626` `%568` `%456`. A lap opens
none of those.

**The agent-doable queue, Lindy first:**

1. `%642` -- build the scrub cache; design at `expanding-prompts/20260908-155715_the-scrub-that-remembers.md`.
2. `%519` -- spread `tools/fixtures/p/plant.sh`; liveness reads 56 resolved, 56 live, 0 dead.
3. `%646` -- sweep the precondition class; assert the failure as a negative on `verdict=thin`.
4. (`20260915.205116`) -- the Glow gate law ratchet stands at its **floor of 9**, down from 14: the `law` grammar learned two of the three homes its own header named, and five more desks linked (`linked` 11 to 16, ceiling 14 to 9). A law's middle field may now name `<Type>.fields` or `<Type>.variants`, and a dot selects which reader answers, since a Zig identifier can never carry one. Of the nine remaining, **five are permanent floor** -- generated language examples and planted fixtures, mirroring no module law -- and four want the two shapes still unbuilt: a const whose value is an expression (aurora's two Ed25519 lengths), and a module roster count (aurora's six living stages). `sh tools/fixtures/g/glow_gate_law_agree_scan.sh` reads it.

**EVERY SHIP OWES ITS `rishi` BINARY A REBUILD** (`20260915.223610`). A peer landed `out_brief` and
`err_brief` beside the whole captures in `rishi/src/main.rye`, and witnesses began interpolating
them within the hour. `rishi/bin/rishi` is untracked, so a checkout carries whatever it last built
-- mine was from `20260905` and answered `NoSuchField` on a line the hot roster had read green forty
minutes earlier, under a *different* copy of the same witness. The cure is one command:
`RYE_ZIG="$PWD/vendor/zig-toolchain/zig" sh tools/fixtures/r/rye_build.sh rishi/src/main.rye
-femit-bin=rishi/bin/rishi`. `tools/r/rishi_brief_witness.rish` already says so inside its own
assert message; this line is here because a ship meets the red somewhere else first.

**Stop line:** when only the seven gated rows remain, print `GATES-ONLY` and `touch
.loop-gates-only`. The watcher re-arms a stopped loop, so the sentinel is what makes a stop stick.

## INNER LOOP -- what every future lap carries

1. **Reds first.** Close a red touching the selected product seam. Surface custody and policy gates.
2. **Lindy first.** Stable product meaning, signed facts, bounded folds, portable receipts, public interfaces, and first-day teaching lead.
3. **Crux first.** Choose the hardest solvable step that closes the current Simple, Lovable, Complete loop.
4. **Product before workshop.** A new guard serves a named product acceptance condition. Nearby repository hygiene becomes a handoff.
5. **One named milestone.** Planned work uses a plain name. The completed whole receives its actual one-clock stamp when it lands. Forecast numbers stay out of names.
6. **Finish the loop.** One claim, one bounded change, one witness from both sides, one account, one commit.
7. **Prove on touch.** Run the cold endurance run before work and the hot endurance run after staging; grade touched prose B or better; keep Truth at 60 or higher.
8. **Coordinate before build.** Read and publish `construction/fleet-claims.kyri` before implementation. One tree keeps one writer.
9. **Fetch before booking and sending.** `xy` receives the first push, then `debrided`. A refusal leads to rebase and re-verification, never force.
10. **Keep scope and testimony.** Walk open shelves; enter closed stacks by named path; preserve dated records; write logs into their day shelf.
11. **ASCII-first and American spelling.** Motion, interfaces, prose, and commit messages keep plain ASCII except in a named Unicode fixture.
12. **Custody first.** Real people, data, keys, money, chains, provisioning, publishing, and collaborator design authority remain at their gates.

## Product direction

Linengrow and Dimeroll now share one source of truth and two faithful meanings.

**Linengrow** lets a person offer a small valuable data product, consent to a bounded use, see what return is promised, follow each permitted use, and carry their complete record away.

**Dimeroll** receives the same signed facts and keeps honest books: offer value, recognized value, obligation, settlement, expiration, and correction remain distinct and reconcilable.

**Tally** bounds every size, amount, duration, event count, view, and refusal. **Mantra** appends the facts and replays them into state. Neither product invents a second record beneath the first.

The product cards carry the complete ladders:

- [`LINENGROW_ITINERARY.md`](LINENGROW_ITINERARY.md) -- from readable receipt to portable data-value bundle and lawful return.
- [`DIMEROLL_ITINERARY.md`](DIMEROLL_ITINERARY.md) -- from recognized receipt to trustworthy portable books and distinct entities.
- [`the Linengrow Receipt Cloth Design System`](../active-designing/20260912-142909_the-linengrow-receipt-cloth-design-system.md) -- Linengrow meaning, Brushstroke description, Skate behavior.

**Git nib:** `0532177c50` -- this commit's parent, resolvable everywhere (%401).

**Landed accounts shelved** `20260915.180554` -- the per-ship completed accounts that stood here moved whole to [`archive/20260915-180554_itinerary-landed-accounts.md`](archive/20260915-180554_itinerary-landed-accounts.md), which is where a finished account belongs. The `## Product direction` section had reached 23,070 bytes, 56 percent of the card, and a byte bound is the wrong instrument for a section that wants a shelf. The direction above stays; the receipts for work already landed are one click away, and [`archive/README.md`](archive/README.md) indexes every shelf before it.

**BAKERY -- THE TWO BINARIES EVERY GUARD RUNS THROUGH WERE THE TWO NOTHING CHECKED.**
**WATER TASTES** (row 3, N=4993): run the actual thing up close, and ask what a second run would
change. **REDS FIRST:** `%746` stood OPEN in the ledger, booked three hours earlier by a peer, and
its own last line read *repaired on this ship only, and the class is open on eight*. This lap built
the instrument that closes it.
**THE FAULT WAS LIVE IN MY OWN TREE WHILE I READ THE ROW.** `rishi/bin/rishi` here was **877,180
seconds -- ten days -- behind `rishi/src/main.rye`**, and `rye/bin/rye` 13,174 seconds behind its
own. `tools/r/reds_fold_witness.rish` ran 62 legs green and then died `rishi: line 38: NoSuchField`
on `out_brief`, a field the source declares and the installed interpreter had never heard of. Both
rooms are gitignored, so a pull carries no rebuild and the error is attributed to whatever the
binary happened to be running.
**THE NEAREST GUARD IS RIGHT AND ANSWERS A DIFFERENT QUESTION.** `witness_own_build` passes both
binaries free on a named reason -- *if either is absent nothing runs at all, so their presence is a
bootstrap fact rather than a promise any single witness makes.* That is PRESENCE, and it is true.
Freshness is a second question wearing the same skip.
**LANDED:** `tools/fixtures/b/built_tool_freshness_scan.sh` declares each built tool as one
four-field row -- name, binary, module source directory, repair command -- and compares the
binary's modification time against the newest **tracked** source under that directory, one
`git ls-files` and one `find -newer` per tool. A stale tool refuses, names the source that outran
it, counts the seconds, and prints the command that repairs it. **36 legs** on real git
repositories in a throwaway pen, every refusal planted and then **lifted**, three mutations bitten
-- reading untracked files rather than the index, counting an absent binary as stale, and inverting
the comparison. Rostered `built_tool_freshness`, `tier lap`, beside the presence guard it completes.
**REPORTED RATHER THAN GATED, each for its own reason:** an **absent** binary, since a fresh clone
has none and the bootstrap is the documented first step; and a `rishi` older than the `rye` that
compiles it, since that chain is real and gating it would refuse every ship for the minutes between
two builds.
**PLAIN SHELL ON PURPOSE.** The subject of the reading is the interpreter the witness half runs
under, so a `rishi` too stale to parse the guard cannot silence it.
**AND THE REPAIR HAS AN ORDER.** Building straight over a running binary answers `FileBusy` --
ETXTBSY -- so the rebuild goes to `rishi/bin/rishi.new` and is renamed into place, which `rename`
permits over a busy executable where `open(O_TRUNC)` refuses. Proven before installing: the new
interpreter answers `out_brief` where the old answers `NoSuchField`.
**WHAT IT DOES NOT REACH:** modification time answers *later*, never *different*. A checkout
rewriting a source to byte-identical content reads stale when nothing changed, and `touch` fools
it. That false positive costs one rebuild; the false negative it avoids is a fleet attributing
phantom errors to the tree. A content digest would answer *different*, and it wants the build to
record one beside the binary -- a compiler change rather than a reading.
**I TOOK MY OWN OPEN QUESTION RATHER THAN HOLDING IT.** The elder account asked you whether a
staleness reading should join the roster and at what tier. `%746` was already an OPEN red and the
repair is one command per ship, so I seated it at `tier lap` and say so here; retiring the row is
one word.
**AND A PEER REPAIRED THE INSTANCES BY HAND IN THE SAME HOUR**, rebuilding `rishi` across four
peer checkouts with the same rename move and checking each tree for the source change first. The
guard is what keeps them fresh rather than a sweep that must be repeated.
**YOURS:** the 702 unlocked call sites -- with the compiler's own lock repaired, is the shell-side
`rye_build.sh` still wanted, or does it retire to the four rooms that carry it?
**MINE:** `merge` and `annotate` in `mantra/src/weave.rye` still reach the two counters through
`@max` alone and state no postcondition of their own.

**COPAL -- A GUARD COUNTED ONE FILE AS TWO ROOFS, AND THE PLANT MEASURED AS DRIFT.** Completed
account [shelved whole](archive/20260915-200611_itinerary-copal-plant-account.md): `roofs` counts
distinct files by inode, reading (5) reads the vessel's wire words, and `copy_lag` reads a
control's own plants past and counts them. **YOURS:** should `one_file` become a refusal once a
room declares it deliberately, or stay the honest name it is now?

**PATCHOULI -- TWO GUARDS WROTE ONE BINARY WHILE A LOCK WATCHED THEIR OTHER HALVES.**
**FIRE SEES** (row 2, N=4917): look at what must stop, then cut once.
**REDS FIRST.** Cold **286 run, 280 green, 4 red**, `tree_moved=no`, two custody gates.
`stash_record` read `unlanded=5`: `stash@{0}` held five 0914 session logs as untracked files in
`stash@{0}^3`, their five shelf rows, and a claims board from `220328`. The logs and rows are
restored and the board was left alone, since landing it would have reverted two peers' live claims
(%702's own shape). `20260914` closes at its derived **110** in both rosters, which is the five plus
the one a peer landed in the same window. `index_row_bound` and the 196-byte row it named were
repaired upstream while this lap ran, so that trim was withdrawn; the Git nib closes in this landing.
**THE CUT.** `tools/fixtures/b/build_target_scan.sh` reads `shared_paths` -- a path TWO guards write
collides whenever either runs beside a pass -- and the Mantra pair was mine:
`mantra_snapshot_hosted` and `mantra_udp_reuseaddr` each built `mantra/snapshot_export_delivery.rye`
into `mantra/bin/snapshot-export-delivery`. **A port lock already serialized their two RUN legs and
left their builds free of each other**, which is build-against-run, the one pairing neither
`.rye-build.lock` nor the pass lock reaches. Both build into their own `mktemp -d` pen now, swept at
the end. `emit_fixed` **51 -> 47**, `fixed_paths` **46 -> 43**, `shared_paths` **2 -> 1**, both
ceilings lowered to meet the reading and both refusals shown from the failing side at
`ceiling_source=env`, which the live witness refuses.
**AND THE MECHANISM IS NO LONGER INFERRED.** The query-wire half of this repair landed upstream
inside the same hour, and it caught the cause in the act: `FileBusy`, which is ETXTBSY -- one run
EXECUTING a binary while another run's linker opens the same path to write it, proven elder 3 green /
5 red against repaired 8 green / 0 red at eight concurrent. That is exactly the shape of the pair
this lap moved. My own copy of that half was **withdrawn to upstream's stronger one**, which folds
each build and its selftest into one shell so the pen is swept even on a failing leg.
**THE MERGE MADE `%702`'S FAULT IN MY OWN TREE.** A peer renamed nine `20260915` logs to stamps read
from their first commit and repointed the rows; the rebase's auto-merge kept BOTH sides, so five
stale rows stood beside five live ones naming filenames the tree no longer holds -- upstream read 34
rows clean, mine read 40 with 5 unresolved. `index_row_bound` caught it, because a resurrection and
an addition are one shape in a diff. Repaired by taking that shelf and the claims board whole from
upstream and re-applying one row and one claim close. **35 rows, 35 logs, `rows_unresolved=0`.**
**AND THE ROW DID NOT FIT.** Booking it took the REDS pin 291 bytes over its 65,536 bound, and the
pre-commit hook refused the amend by name. The capacity scan printed the lawful move rather than a
raise: `%736` and `%737`, both CLOSED hours earlier in one room on one reading, fold together onto a
shelf naming what they taught -- *a guard that counts its own instrument's material has measured the
instrument rather than the tree.* Pin **65,827 -> 62,732**.
**GREEN on metal:** both Mantra witnesses, `build_target` with its 33-leg pen, `index_row_bound`,
`log_has_a_row`, `dayshelf_merge`, `session_roster_agree`, `tame_style_check`, `width-check`.
**SURFACED, NOT TAKEN, TWICE.** `shim_reason` read `unsaid_rostered=925` against 922 -- three of
those were my own pen bindings asserting on `.ok` with no capture reported. All four carry theirs now
and the reading fell to **921**, one below the ceiling, since the delivery build assert gained the
compiler's stderr in the same move. **The lowering was then withdrawn:** the 30-commit rebase brought
`tools/p/pre_push_marker_witness.rish` with four fresh uncaptured bindings, so the live reading is
**923** against upstream's own 922 and the family is breached by a peer's newest guard rather than by
this lap. `%740`, one hour old, holds that family's tension -- giving an assert its reason raises the
already-breached `say_compose_bound` ratchet -- so pricing it belongs there rather than here.
The hot pass also found `fixture_depth red` one commit after
`tools/fixtures/l/link_text_promise_scan.sh` landed: it reaches its portable helper by
`dirname "$0"/../s`, the relative-hop arithmetic that guard's second census holds at zero by name.
The author's reason is right and the spelling is retired -- and the depth-proof walk needs
`rishi/bin` and `tools/fixtures` in the pen, which that instrument's control does not build, so the
repair reshapes its pen across seven path literals. Booked as a row (`20260915.213138`, renumbered twice by the spine) for its owning
seat rather than taken here. Every ship's pass carries one red line until that lap lands.
**YOURS:** `comlink/bin/handshake-turn`, written by `comlink_handshake_turn` and
`witness_own_build`, is the last shared pair, and `max_writers` reads 2 until it moves.
**MINE:** `merge` and `annotate` in `mantra/src/weave.rye` still reach the two counters through
`@max` alone and state no postcondition of their own.

## Simple, Lovable, Complete order

**GRASS -- TWO GUARDS DEMONSTRATED A REFUSAL IN A SPELLING THEIR METER COULD NOT READ.**
**EARTH BREATHES IN** (row 4, N=4944). **REDS FIRST:** the inherited `prose_register` red, reported
by the ship before me and left standing. Taken here.
**THE MECHANISM:** `tools/fixtures/s/standing_equipment_redleg_scan.sh` read whether a rostered
guard demonstrates its own refusal by grepping the file for one of four spellings. Reading all
fifty-three marker-less guards by eye found two it cannot see -- `glow_vane_pair_mirrors` calls a
gate past its bound and asserts the digit `"0"`, `comlink_rehearsal_wire` asserts a child handed a
stranger role exits 2. The decision moved into a `marker_present()` awk reading six
spellings, the two new ones scoped to an assertion LINE, and the count fell **53 to 51** with the
ceiling. **THE EXCLUSION IS THE WHOLE DISTINCTION:** a `"0"` read out of a captured stream is a
census rather than a refusal, so the value form reads past a line naming `.out`, `.err`, or `.code`.
**LANDED:** control **24 legs, 0 failures**, six new, three mutations bitten each on its own leg.
**THE REGISTER RED CLOSED** on six restatements across two rule pages, 36% and 46% to **26%**, the
law count **10 to 8** and the ceiling **9 to 8**.
**YOURS:** `claim_preserve_scan.sh` CANNOT TELL A REGISTER SWEEP FROM A WEAKENED OBLIGATION -- its
modality reading counts `never` and `none`, the very words `prose_register` asks a lap to recast.
Claim tokens held exactly on both pages (`20260915.213000`).
**INCENSE -- THE REFUSAL NAMED ITS COST AND NEVER ITS CAUSE.** Completed account
[shelved whole](archive/20260912-050057_itinerary-landed-accounts.md); its open question asks
whether the tree digest may read past `construction/fleet-claims.kyri` as it does its own card.
**DIFFUSER -- THE WHITEPAPER ROW'S PREMISE FAILS, AND ITS FALSIFIER CANNOT FIRE.**
Elder [shelved whole](archive/20260915-212827_itinerary-diffuser-row-eight-account.md).
**FIRE SEES** (row 2, N=4977): look at the thing itself rather than the account of it. **THE ROW.**
Row 11 is the last unopened row of the twelve and the only one whose subject is the other eleven:
*one paper binds the three definitions the other eleven rows lean on.* Nine rows now carry landed
readings, so its assumption and its falsifier are both checkable -- and they are checked by RUNNING
the sibling instruments and reading their emitted keys rather than the errata that describe them, so
the answer moves when an instrument moves.
**ONE DEFINITION OF THREE STANDS.** *A bound when space wraps* holds on `cost_half=stands` and
`wrap_worth_one_cut=yes`. *A radius when privilege is distance* is refuted on three keys across two
instruments -- **32** incomparable unordered pairs and **48** over-admissions where a line reads zero
of each, and a mapped saturation radius of **2** where a gradient needs three. *A topos when every
proof is a cycle* is left **unrun**, its instrument being the cadence-tier `cyclic_witness`, and the
scan proves the answer cannot turn on it by recomputing with that definition forced to stand.
**THE SURVIVORS NEED A RING.** Each definition states how many independent cycles the space must
carry; the maximum among the supported ones reads **1**, on a page titled for a torus. The second
axis is the one thing a torus has that a ring does not, and `torus_place` read
`second_axis_buys_spread=no` one row over on a different question -- two readings converging on the
same axis.
**AND THE FALSIFIER CANNOT FIRE AT ALL**, which is the sharper half. Each definition bounds the
space from below, lower bounds compose by maximum, and across all **27** verdict assignments the
conflicting count reads **0** under `atleast` and **5** under `exact`. Row 11 watches for a failure
its definitions are structurally incapable of having, while the failure they did have went
unwatched. The hinge is an **inference** and is named as one, with both answers printed.
**LANDED:** scan, 55-leg pen, witness, `whitepaper_definitions` rostered `tier cadence` (scan 11s,
control 19s). **Five mutations bitten.** **Two faults the pen found in the scan itself**, both fixed
before the rung was written: the missing-key counter incremented inside a command substitution, so
it read zero while four keys were absent; and three per-definition lines each carried a bare
`verdict=` key, so a reader taking the first match read a definition's classification as the scan's
own answer. Everything is **GATED** -- every figure is arithmetic over the assignment space or a key
from a sibling that is itself gated.
[Paper](../active-designing/20260915-212827_the-paper-that-checked-its-own-premise.md) **A 91**; the
moonshot page carries row 11's erratum at **A 94**.
**YOURS, STILL:** the card's Diffuser section names Brushstroke and Skate; `construction/fleet-roster.kyri`
and this seat's baton name moonshots and whitepaper research. Two living pins, two lanes, one ship.
Which stands?
**YOURS, NEW:** rows 2, 4 and 5 are now three refusals sharing one cause -- a radius over a
population carrying no usable distance. Fold them into one recorded finding, or keep three errata?
And does the page's title move from torus to what the survivors support?

**PETRICHOR -- A DOOR WHOSE BODY IS A PROOF CENSUS, HELD TO ITS OWN DECLARATION.**
Elder [shelved whole](archive/20260915-223304_itinerary-landed-accounts.md); its open question asks
whether a door may declare that it lists its whole room.
**FIRE SEES** (row 2, N=5002): look hard at what most laps route around. **REDS FIRST:** the cold
pass found a stale roster lock held by the previous lap, its verdict already fixed at `tree_moved`;
`fleet_call.sh --signal TERM` released it by working directory rather than by name, and the pass
reopened clean.
**THE DOOR.** Reach named `skate/README.md` -- **30 negatives of 109 sentences, 27 percent against a
20 percent declaration**, the largest repairable body among the fourteen unrostered doors over
ceiling. **563 living citers.**
**WHAT LOOKING HARD FOUND.** Eighteen of the thirty negatives stand in `## The owned bounds` and
`## Prove the seam` -- a refusal contract and a control census, which is Meter content inside a
Door-declared page. The tempting repair was to redeclare the page Field, where 27 percent passes
untouched. The scan's own header had already ruled on that shape: when `docs/` joined the roster,
*the room paid its way in rather than buying a raise*, and `WITNESS_PATTERNS.md` went 52 to 29 by
restating the incidental negatives while keeping every one whose subject is refusal.
**SO THE PAGE PAID.** Fourteen incidental sentences took the affirmative form and **no sentence was
deleted** -- 109 before, 109 after. `without pulling their implementations into Swift` became `while
their implementations stay in Rye`; `a peak no greater than 32,768` became `at or under`, which is
the `peak <= lotusSamplePeak` guard at `skate/Sources/SkateCore/FrameGrid.swift:79` spelled in the
tree's own ceiling words; `Swift does not decode QOI, meter PCM, recompute SHA3...` became those six
operations named where they live. **27 to 14 percent.**
**WHAT STAYED, AND WHY.** All sixteen survivors are the page's subject: `refuses empty, non-ASCII,
over-wide` is an initializer's contract, `neither hashes content nor claims those bytes came from
Grain's crypto` is the whole reason the type wears the word `Claim`, and eleven more are controls
reporting what they plant and refuse. A ceiling met by deleting those would be a worse page at a
better number.
**TRUTH, JUDGED RATHER THAN COUNTED.** The card reads `truth_mode=counted` when the judged half goes
unread, so I read it: every named error case (`EventRingError.counterExhausted`,
`ImageEditHistoryError.historyFull`, `AccessibilitySnapshotError.accessibilityTooLarge`), every
`public typealias` peer pair, and the Lotus bound all stand in the Swift sources; all six backticked
module paths resolve.
**LANDED:** rostered on `DOOR` in the same commit, so the reading is a wall rather than a ratchet --
proven from both sides by reverting the page, watching the scan refuse `register_drift` at exit 1,
and restoring it to green. `door_documents` **22 to 23**, `front_doors_unrostered_over` **14 to 13**,
`door_over_ceiling` still **0**, `door_setting_undeclared` **0** -- the page already declared the
Door setting, so rostering it cost one path. Card **B+/85** at `truth_mode=judged`. No red booked: a
low grade is never a red, and nothing here was wrong.
**YOURS:** a page whose closing two sections are a bounds table and a control census is Meter prose
under a Door declaration. Should a page be able to declare **one setting per section**, so a front
door's introduction is held at 20 while its proof census is read as the refusal-led writing it is --
or does one page keep one setting, and a body that drifts Meter-ward mean the page wants splitting?

**COPAL -- A METER PRICED A GAP FROM THE FILES IT COULD ALREADY SEE.** Completed account
[shelved whole](archive/20260915-223327_itinerary-copal-written-ascii-account.md): the shell half of
the written-ASCII family read **1,419 characters across 122 shell sources** against a guess of two,
**1,392 of them sweepable** rather than program text, landed with a 39-leg pen and three mutations
bitten.
**YOURS:** (1) the 1,417 -- swept, re-poured, or retired? A dated generator disagreeing with the
page it fills governs a family, the same shape as the dated equinox guards' standfast. (2) A
`printf` argument assembling one line stays unread by every meter in this family; closing it needs
a quote-depth walk. (3) Should a claim's `paths` be exempt from the commit-msg path wall?

The order is a ladder of working wholes. A later milestone begins from a complete earlier one.

| Growth milestone | Product whole | Completion signal |
|---|---|---|
| **The receipt you can read** | one synthetic data product with consent, value, and expiration | same meaning through fact, replay, projection, frame, and books intake |
| **The consent you can change** | grant and revoke one purpose-bound use | revoked use refuses while history remains visible |
| **The value you can follow** | one use and one promised return | Linengrow and Dimeroll reconcile to the same facts |
| **The offer another person can find** | one honest listing and acceptance with fake identities | listing, acceptance, receipt, and expiration close |
| **The bundle you can carry** | export and import the person's record | digest and rebuilt projections agree |
| **The books you can trust** | one entity and one closed period | journal, trial balance, statements, and receipt drill-down agree |
| **The return you can settle** | one simulated return; real rail later | obligation closes without crossing custody |
| **The two entities that stay apart** | Linengrow PBC and Siya Fund books | explicit two-sided facts, independent balances |

The first crossing is **The receipt you can read**. It is small enough to finish, useful enough to show, and complete only when both products agree without braiding their types.

## Design direction

The interface uses ASCII as structure, linen as material, and motion as a bounded response.

- **Still** is the complete base and the reduced-motion result.
- **Settle** moves one complete view into another in at most one second.
- **Respond** uses a fixed-radius, fixed-life local pulse and changes no product state.
- A renderer loss returns to Still before a boot deadline.
- Every action has a keyboard path, visible focus, text label, and accessibility snapshot.
- Personal details begin folded; terms, mechanism, receipt identity, value basis, and expiration begin visible.

Brushstroke declares each component's grid, role, state, tokens, and motion profile. Skate renders the fixed frame and bounded events. A correspondence witness forces meaning, description, and behavior to change together.

## Now -- the eight sailing ship itineraries

**Git nib:** named once above, under *Product direction* -- one fact in one place.

### Incense -- product captain

**Priority:** VERY HIGH Lindy; VERY HIGH crux.

1. Review and revise the proposed one-page contract for **[The receipt you can read](../active-designing/20260912-201126_the-receipt-you-can-read-contract.md)**: one synthetic input, four public types, module residences, eight acceptance cases, and one falsifier now stand at a checkable edge.
2. Keep Linengrow meaning and Dimeroll meaning separate over the same Mantra facts during implementation; the `20260913` review accepts this boundary.
3. Integrate the first whole and stamp its achieved name only after the dual-product witness passes.

**Stop:** product meaning, DJINN design authority, custody, or a new module seat returns to Keaton.

### Patchouli -- Mantra and Tally spine

**Priority:** VERY HIGH Lindy; VERY HIGH crux.

1. Define bounded offer, consent, use, value, expiration, and correction facts from existing value forms.
2. Append and replay them deterministically through Mantra.
3. Prove Tally ceilings refuse before durable state changes and preserve the elder fold.

**First proof:** identical facts replay to identical product projections; first-over-bound refuses unchanged.

### Copal -- Amphora receipt and portable bundle

**Priority:** VERY HIGH Lindy; HIGH crux.

1. Seal the receipt fields and provenance in an existing Amphora vessel.
2. Prove authentication, version refusal, and round-trip meaning.
3. Prepare the portable bundle seam for Granary without opening network or identity custody.

**First proof:** a decision-bearing byte mutation is caught before either product reads it.

### Pheromone -- Glow product language

**Priority:** HIGH Lindy; VERY HIGH crux.

1. Express the receipt facts and Tally bounds in the smallest Glow form already owned.
2. Carry them through lowering into Mantra and both projections.
3. Make refusal output stable: field, value, ceiling, unit, and reason.

**Stop:** a new rune or Glow language ruling returns to Incense and the interactive bench.

### Grass -- reverse-reading steward

**Priority:** VERY HIGH Lindy; VERY HIGH crux.

1. Walk foundations, active-designing, and session logs backward to find the oldest unresolved premise beneath the newest plans; navigate newest-to-oldest, then judge evidence oldest-to-newest.
2. Ask of each recovered matter whether it should be **revived, molted, breached, archived, standfasted, yondered, or prepared for a Mitra shed**, and record exactly one disposition with its evidence.
3. Bring forward only a matter that changes a living product or build crux; hand module work to its owning ship rather than taking the files.

**First proof:** one reverse-reading packet traces a present priority to its oldest deciding premise and names one evidenced disposition without rewriting dated testimony.

### Petrichor -- Bhakta product path

**Priority:** VERY HIGH Lindy; HIGH crux.

1. Write the first-hour walkthrough after the public seam lands.
2. Teach valuable data, consent, receipt, books recognition, and portability one idea at a time.
3. Let a cold reader create, verify, view, and reject one synthetic receipt.

**Stop:** prose waits for green interfaces and uses no private example.

### Bakery -- Rishi fusion-build spine

**Priority:** #1 FLEET PRIORITY; VERY HIGH Lindy; VERY HIGH crux.

1. Instrument Rishi's discovery, dependency closure, Rye/Zig compilation, proof execution, and receipt writing; measure where repeated work actually lives.
2. Land content-keyed compilation first: identical declared inputs may reuse a binary, while every owed proof still executes and every changed source, flag, overlay, compiler, executable bit, or toolchain pin forces a miss.
3. Derive the moved proof closure for the pull-twice rota; intersect the round's changes with upstream changes and escalate to the full roster whenever the manifest is absent, overlaps, or cannot prove independence.
4. Grow the same bounded, replayable fusion toward Caravan's toroidal aetheric scheduler for the Microkit/seL4 proven-seat road: named wrap invariants, word-wide bounds, deterministic drain, derived region addresses, and no capability or kernel claim beyond metal evidence.
5. Keep Tally's memory gardens and Aurora's verified handoff inside the same build graph, each with explicit ceilings, target/toolchain identities, and cold/hot endurance receipts.
6. On every touched shell seam ask whether orchestration or typed decision logic belongs in `.rish`; migrate on touch with parity, never by extension-count campaign, while retaining POSIX `.sh` launch edges where portability is the invariant.

**First proof:** identical inputs skip compilation but run the same proof; six independent mutations each miss the cache, and the emitted receipt names the complete deciding closure.

### Diffuser -- Brushstroke and Skate product surface

**Priority:** HIGH Lindy; VERY HIGH crux.

1. Implement the Receipt Card and Consent Rail as bounded Brushstroke descriptions shared by Linengrow and Dimeroll.
2. Render Still, Settle, and Respond on the existing Skate grid and event ring.
3. Prove reduced-motion, renderer-loss, hidden-document, settled-frame, deterministic-description, focus-order, and accessibility equivalence.
4. Measure frame time, pulse count, event capacity, and accessibility parity before proposing richer motion.

**First proof:** every animated state reaches the same final frame as Still inside its declared duration.

## Fleet dependency order

1. Bakery proves the first safe Rishi fusion-build rung; cheaper truthful proof accelerates every later ship without weakening one.
2. Incense names the first receipt contract.
3. Patchouli and Copal land the bounded facts and sealed receipt.
4. Pheromone proves the language seam while Grass reverse-reads one deciding premise and returns any live consequence to its owner.
5. Diffuser lands the Brushstroke and Skate component pair.
6. Petrichor writes the runnable first-hour path.
7. Incense runs the full witness and stamps the completed milestone.

Ships may rest while a dependency is open. Rest preserves the finishing edge.

## Under-the-hood module road

The build beneath every whole uses Rishi, Rye, Tally, Caravan, and Aurora with Brix describing the closure. The first receipt whole uses Kyri, Mantra, Dimeroll, Linengrow, Brushstroke, and Skate. Later named milestones earn Comlink, Pond, Amphora, Granary, Mandi, MUR, Lantern, Mycelium, and Cellar only when their job becomes necessary. Favorite names guide clear responsibility; they never justify an extra layer by themselves.

## Alignment measures

At check-in, count completed named wholes, dual-product acceptance cases green, false acceptances caught, user-runnable paths, deciding concepts, and operator gates. Commit totals, file totals, guard totals, and fleet utilization remain observations.

## Custody gates -- an autonomous agent STOPS here and surfaces

1. **Public seed publishing.** An agent may prove a projection; it must never run `publish-seed.sh` or perform its push.
2. **Provisioning and payment** for clouds, hardware, subscriptions, domains, services, or outside work.
3. **Real data, money, keys, wallets, custody, and payment rails.** Synthetic fixtures and simulated settlement remain agent-doable.
4. **Keaton's real Kumara instance** and every derivation from his keeper.
5. **Deep debride, history rewrite, or force push.** An agent must never run `git filter-repo`, `git filter-branch`, or `git push --force`.
6. **DJINN's design seat and collaborator domains.** Agents may build original implementation-floor components from the seated system; signature visual decisions and direct extensions wait for invitation.
7. **Bulk merging drifted rule twins.** Each pair receives its own reading.

## Open doors for Keaton

- The first receipt contract is accepted for bounded synthetic implementation; material scope changes return here.
- The full eight-ship formation is chosen and may remain under the watcher.
- Invite DJINN to accept, alter, or replace the proposed visual seats.
- Keep real personal data, valuation agreements, money, identity, and deployment behind their later gates.

## Archive and record

- The immediately departing itinerary rests at [`archive/20260912-142909_itinerary-bound-before-flight.md`](archive/20260912-142909_itinerary-bound-before-flight.md).
- Its elder rests at [`archive/20260912-141814_itinerary-before-lindy-crux-molt.md`](archive/20260912-141814_itinerary-before-lindy-crux-molt.md).
- The prior design system rests at [`../active-designing/archive/20260826-022443_the-linengrow-design-theme.md`](../active-designing/archive/20260826-022443_the-linengrow-design-theme.md).
- Archives are historical continuity outside Mitra and shred-prep.
- Fleet roster, engines, and trees remain unchanged; the operational state is the full live formation from `20260913`.

May every valuable fact remain the person's own. May every receipt make consent and return easy to see. May the books close gently around truth that can travel.
