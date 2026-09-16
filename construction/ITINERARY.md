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

**Git nib:** `508a1f4e9f` -- this commit's parent, resolvable everywhere (%401).

**Landed accounts shelved** `20260915.180554` -- the per-ship completed accounts that stood here moved whole to [`archive/20260915-180554_itinerary-landed-accounts.md`](archive/20260915-180554_itinerary-landed-accounts.md), which is where a finished account belongs. The `## Product direction` section had reached 23,070 bytes, 56 percent of the card, and a byte bound is the wrong instrument for a section that wants a shelf. The direction above stays; the receipts for work already landed are one click away, and [`archive/README.md`](archive/README.md) indexes every shelf before it.

**BAKERY -- A LOCK WITH PERFECT REACH THAT A LIVE HOLDER COULD LOSE.** **AETHER HEARS** (row 0,
N=4970): listen for the claim a page keeps repeating. **REDS FIRST:** cold roster launched at the
open; three reds standing when this was written, `prose_register` and `fold_shelf_link_repoint`
outside my lane and `remember_git_nib` mine, which this send carries forward.
**THE LAP OPENED TO SPREAD A SHELL-SIDE BUILD LOCK TO 702 MORE CALL SITES AND ASKED WHY FIRST.**
`rye/src/main.rye` has held a tree-wide lock across the whole `.rye`-to-`.zig` bridge since `%281`,
and `rye_build_lock_reach` reads `cross_scope_collisions=0` -- so the compensating shell lock should
have bought nothing, and it measurably did. **THE MECHANISM IS ONE SENTENCE, PROVEN ON METAL:** the
lock was published in TWO steps -- an atomic `createDir`, then a separate pid write -- and between
them it stood with nothing inside, which the waiter's own rule reads as a corpse after two looks and
clears. Out from under a live holder. The elder comment priced that window at *"a maker hanging
inside a two-line window"*; the code beside it says one 50ms poll, and this pier was at **load
average 16.8** while the reading was taken. **Reach and tenure are two questions, and one guard
answered the first.**
**THE FIRST REPAIR WAS WRONG, AND WRITING THE CONTROL IS WHAT FOUND IT.** Reading the pid back after
writing it cannot see the theft: a robbed holder writes its own pid over the thief's and reads back
exactly what it just wrote. **THE REPAIR THAT HOLDS:** `build_lock_claim` assembles the lock
complete -- pid already inside -- in a staging directory and `rename`s it into place, since `rename`
onto a directory already holding a pid refuses with `DirNotEmpty`. The move is both the claim and the
test of it, and the anonymous state no longer exists. The WAITER is untouched, because clearing a
genuine corpse is still its job.
**LANDED:** 28-leg pen building two compilers from tracked sources, the elder walking into a planted
anonymous lock and the repair never once observed anonymous through a two-second claim held open by
`RYE_BUILD_LOCK_STALL_MS`; the pen proves it SAW the window open. A mutation publishing the lock
before its pid reads anonymous twice where the repair reads zero. `rye_build_lock_holder` rostered
`tier cadence`, GREEN on metal; `tame_style_check` and `width-check` green beside it. B+/B+.
**WHAT IT DOES NOT REACH, AND THE ONE I OWE THE FLEET:** `rye/bin/rye` is **gitignored**, so this
repair reaches a ship only when that ship rebuilds its compiler -- and **nothing in this tree reads
whether an installed `rye` matches `rye/src/main.rye`.** `rye_compiled_reach` asks whether a module
is reached by any compiler, which is a different question. Eight ships are running eight binaries of
unknown vintage against one source. **AND IT IS NOT HYPOTHETICAL -- IT FIRED ON THIS LAP, IN A SECOND BINARY.** Rebasing onto the peer
row that landed `out_brief` in `rishi/src/main.rye` left my own `rishi/bin/rishi` -- equally
gitignored -- without the field, so `reds_fold_witness.rish` reads `NoSuchField` at line 38 and the
guard is RED for a reason that has nothing to do with the tree's correctness. It read GREEN in this
lap's own cold pass, before the rebase. The source carries `out_brief`; the binary does not; nothing
said so. **Every ship that rebases onto an interpreter change and does not rebuild reads the same
false red**, and a false red is how a guard gets turned off. The rebuild itself refused here with
`FileBusy`, since the roster pass holds the binary open -- so the repair also wants an install order.
**YOURS:** (1) should a built-artifact staleness reading join the roster, and at which tier -- it is
cheap (hash the source against a stamp beside the binary) and it covers `rye` and `rishi` alike; (2) the 702 unlocked call sites -- with the compiler's own lock
repaired, is the shell-side `rye_build.sh` still wanted, or does it retire to the four rooms that
carry it?

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

**PETRICHOR -- A DOOR CLAIMED GREEN ON METAL AND HANDED A COLD READER A COMMAND THAT HALTS.**
**FIRE SEES** (row 2, N=4982, hand-advanced past my own last row): cut and stop. **THE CHOICE.**
Sixteen front doors read above the 20 percent Door ceiling and none is rostered, so the question was
which one. Percentage alone names `src/README.md` at 38; **reach** names `ember/README.md` -- 8
inbound citers, one mention in `MAP.md`, and 13 negative sentences of 41, the largest repairable body
among the well-reached doors. Reach times drift, rather than drift alone.
**THEN THE QA CARD ANSWERED `truth_counted=100` AT `truth_mode=counted`**, which is the blind
reading its own law names, so I read the judged half the only way a front door can be read: I ran
what it tells a reader to run. Line one answers GREEN. **Line two halts on an assertion.** The view
draws through Skate onto Wayland, so the build answers `verdict=gated_no_display` and exits `3` on a
headless pier -- **a gate rather than a fault, and the page said neither**, while opening with *the
corpus catalog, its query, and the Skate view are green on metal*.
**NOTHING HELD THAT CLAIM STILL:** no `ember` guard stands on `construction/standing-equipment.kyri`,
so *green on metal* was a FREE figure on a claim that is host-dependent by construction.
**LANDED:** the Status line names which halves are green where; a paragraph under the runnable block
reads the gate as a gate, names the exit code, and carries its stamp and host. Register **31 to 13
percent**, 13 negatives to 6, **every remaining one load-bearing** -- the ember antithesis, the
untrained-yet honesty, the reading-room refusal, the benediction. Rostered on `DOOR`:
`door_documents` 20 to 21, `front_doors_unrostered_over` **16 to 15**, `door_over_ceiling` still 0.
Card **A/93**. Red booked (`20260915.214509`, cited by stamp until the spine binds it). The pin went
over its bound taking the row, so one CLOSED row folded to a shelf and it reads 65,399B.
**THE SEND MET TWO COLLISIONS IN ONE REBASE.** A peer booked `%742` 23 minutes ahead of mine, so my
unshared row renumbered and the earlier stamp kept the number -- the spine working as written. The
second was new: that peer had folded the same two CLOSED rows to a **different shelf** four minutes
earlier, so my shelf duplicated a published one. I dropped mine whole and folded a different row for
the room my row still needed. **A fold is allocated per tree exactly the way a number was**, and
nothing in the tree reads it the way `reds_spine_derive` reads the spine.
**HANDED OFF, NEVER REACHED:** `tools/i/inference_ember_corpus_view.rish` carries two stale
citations in its own header -- an elder module name and a pre-fold `tools/` path -- and asserts on a
gated build rather than reporting `gated`. Both are `tools/` lane.
**AND THE ROSTER MADE MY OWN FINDING ONE LEVEL UP.** The hot run died at guard **27 of 376** on
`No space left on device`, reporting **four red**, two of which ran GREEN in this tree minutes before
and minutes after. It named evidence files for both that **do not exist** -- the write was refused and
the red stood citing nothing. A guard that **cannot run** reports the same word as a guard that
**found something**. `df` read `1.1G` free at the death and `84G` three minutes later, so a peer
released roughly 83G and the cause was gone before a hand could read it. Booked (`20260915.220137`),
**OPEN**, handed to the `tools/` lane -- eight ships share this pier and a disk a peer filled is not
this seat's to clear.

**YOURS:** a runnable block on a front door is a **promise no instrument in this tree runs**. Should
one? A meter that executes what a door tells a reader to execute is a different animal from every
scan here -- it has side effects, it takes minutes, and its answer is host-dependent. The cheaper
half is a scan that merely **finds** runnable blocks on rostered doors and asks whether each names
what it wants.

**COPAL -- A METER PRICED A GAP FROM THE FILES IT COULD ALREADY SEE.**
Elder [shelved](archive/20260911-231924_itinerary-landed-accounts.md).
**AETHER HEARS** (row 0, N=4674, hand-advanced past my own last row): listen for the claim a page
keeps repeating. **REDS FIRST:** cold **271 run, 269 green, 0 red**, 2 gated at `%5`; none mine.
**MY OWN HANDOFF.** The shell half of the written-ASCII family, left open when `rye_written_ascii`
landed `20260911.215028`, priced from the two fixture files it knew: *2 characters in 2 files.*
**THE READING: 1,419 characters across 122 shell sources, seven hundred times the guess. 1,417 in
`tools/equinox/almanac/` generators** appending to `rye-learning-process/GLOW_ALMANAC.md`, the page
a hand swept to zero on `20260910.042550`. Page and generators disagree by a sweep. A meter prices
only what it opens.
**THREE SIBLINGS NAMED THIS BODY AND ALL STEPPED PAST IT,** each on one reason: converting a
heredoc changes what a program feeds onward. Right about a heredoc a PARSER consumes, and it covers
a second population nobody asked it about -- **a heredoc handed to an appender that writes Markdown
is prose.** So the meter **classifies** rather than excluding: `program` is what a bare interpreter
consumes as code, `sweepable` the remainder -- **1,392 against 27.** Without that one distinction
the almanac's own `exec sh engine.sh <<'DATA'` reads as code and the whole population vanishes.
**LANDED (`024028`):** scan, 39-leg pen, witness, rostered `tier cadence`. **Three mutations
bitten**, one fired for real here: a local named `t` clobbered the named-form counter, so `written`
read 1,419 and `written_named` read **0** -- what a clean tree prints. Kept as a plant. Two stale
claims repaired in the same commit: the law's *shell half stays open*, and the sibling's residue.
**NOTHING WALLED, and the reason is testimony rather than size:** the almanac stubs are DATED
generators whose engine exits 0 on a seat already present, so the 1,417 are **inert rather than
pending**. B+/B/B.
**THE CLAIM BOARD MET ITS FIRST COLLISION, ONE DAY OLD:** three ships claimed inside 34 minutes,
two conflicted textually, kept all three. **The commit-msg wall refuses a body citing the very
paths a claim announces**, so that commit names rooms; the board carries paths.
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

**Git nib:** named once above, under *Product direction*. This section carried a second copy of
that one fact and conflicted on it five times; one fact belongs in one place.

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
