# The Glow Tree, and the Rooms That Say What They Hold

*Two surveys measured the language and the network on `20260827`. This charter reports what they
found, names where the Glow ladder has drifted from laws seated after it, proposes a room naming
and tree layout in this tree's own warm words rather than in borrowed three-letter ones, and seats
the closed-stack paths for loop information. It proposes; it cuts nothing.*

**Stamp:** `20260827.174816`
**Language:** EN
**Style:** Gauge (see `../context/GAUGE_STYLE.md`), Field setting
**Voice:** Kyri
**Status:** Proposed -- the naming and the layout await Keaton's word; the measurements stand as taken
**Molted:** born at this stamp
**Kin:** [`../.claude/rules/comlink-tendency.md`](../.claude/rules/comlink-tendency.md) (the naming law this applies) -
[`../.claude/rules/stamp-and-name.md`](../.claude/rules/stamp-and-name.md) (the room bound and the fold rule) -
[`../.claude/rules/read-scope.md`](../.claude/rules/read-scope.md) (the closed stacks this extends) -
[`../.claude/rules/docs-implementation-sync.md`](../.claude/rules/docs-implementation-sync.md) (the law the ladder broke) -
[`../docs/STOA.md`](../docs/STOA.md) (the ladder itself) - home is [`../README.md`](../README.md)

---

## What was measured

Two read-only surveys walked the tree on `20260827`, one for the language and one for the network.
Every figure below is a count from `git ls-files` or a `grep` over tracked files on that day.

**The language is large and quiet.** 933 tracked files carry `glow` in their path. The compiler is
125 flat files in `glow/` (124 `.rye`), the desk corpus is 340 flat entries in `glow/gen/`, the Nock
backend is 9 files, and the programs written in the language are 75 desks across six rooms under
`src/`. The language proves itself with **89 `glow_*_witness.rish` files**, and all 89 stand off the
standing roster: `construction/standing-equipment.kyri` seats 76 guards, every one from another
module. Six of the 89 still await their first caller, and those six are precisely the newest rungs:
STOA338, 339b, 340, 341, 346, and the gate horizon.

**The last commit that advanced the language was `43638521d` on `2026-08-04`** -- STOA345. Every
Glow commit in the twenty-three days since has been a lint, an ASCII sweep, a README repoint, or a
path fold, and `glow/gen/` holds the same desks it held that day.

**The network is real and small, and it lives beside the language rather than with it.** Comlink holds 14 original
source modules under 113 tracked files, crosses localhost UDP over `AF_INET` with 23 witnesses, and
is IPv4-only by assertion. Kumara is 2 original files composing crypto borrowed from `tally/` and an
address space borrowed from `comlink/`, with 15 witnesses. `constel/` is 31 modules and 31 witnesses
executing a complete Raft -- joint consensus, prevote, leases, learners, flexible quorums --
**entirely in memory**, which `grep -rnE '@cImport|std\.posix|std\.os|std\.net|extern "c"'
constel/*.rye` confirms by coming back empty. FORA31, the socket rung, waits to be written.

**Each side's vocabulary stops at its own border.** `grep -rilE 'comlink|pier|constel|socket|udp'
glow/` comes back empty, and so does `grep -rilE '\bglow\b' comlink/ constel/ kumara/`. The three
`comlink`-named `.glow` files under `src/` are a constants pedestal: a witness greps the `.glow`
source for `ipv4_addr_len=4`, greps `comlink/hosted_wire.rye` for `const AF_INET`, and compares the
two in a shell. Everything Glow produces stays inside the witness that ran it. The shape's own
header says as much -- *"Pedestal only -- no change to comlink/ wire semantics."*

---

## Where the ladder has drifted from laws seated after it

The STOA rungs were climbed between `20260718` and `20260804`. Four laws seated during and after
that window now read against it, and each reads as a measurement rather than an opinion.

**The mark law asks for a stamp and a name, and STOA counts.**
[`stamp-and-name`](../.claude/rules/stamp-and-name.md) retires the ascending rung as a mark for
*planned* work, keeping it for work already done. STOA334 through STOA346 name work that is GREEN
on metal, so **they are census numbers and they keep their place** -- the law's own test, *could this
number turn out to be wrong*, answers no. What the law does reach is STOA347: a rung still ahead is a
forecast, and the ladder's own history is why. `docs/STOA.md` announced `STOA0-294` in its head and
kept its last row at STOA333 while the work ran on to STOA346 -- the fourth time this tree has
watched a counted ladder announce a length the work then overtook.

**The sync law asks that a doc's claim be checked rather than believed, and thirteen rungs live
only in their witnesses.** [`docs-implementation-sync`](../.claude/rules/docs-implementation-sync.md)
names this exactly. The compressor's head is repaired as of `20260827.173952` and now says where the thirteen are;
folding them in is a lap still looking for its owner.

**The roster is the tree's ear, and the language waits outside it.** Eighty-nine witnesses, zero
rostered, six still without a caller. This is REDS %219's 295-of-298 class arriving at the
language's door: a witness earns its keep on the day someone runs it, and the six uncalled ones are
the newest rungs -- the half of the distribution worth hearing most.

**The Comlink tendency retires the borrowed three-letter room, and `src/` runs five of them.**
This is the largest of the four and it has its own section.

---

## The rooms, and the words they should wear

`src/` holds the programs written in Glow, in six rooms: `app/`, `gen/`, `lib/`, `sec/`, `sur/`,
`til/`. Five of those six are Urbit desk-category abbreviations. The
[Comlink tendency](../.claude/rules/comlink-tendency.md), seated `20260808.205404`, says the
opposite: reach for the clearest, most fun, safest word at whatever length it wants to be, and an
abstract coinage is now **the exception that must justify itself**. `sur` and `til` and `sec` are exactly the abstract
coinage the law released, and each arrived by inheritance rather than by choice.

**The tree has already chosen better words, and put them in the filenames.** Every file in
`src/lib/` is named `gate-something.glow`. Every file in `src/sur/` is named `shape-something.glow`.
The `shape` word is seated in the language itself -- STOA330 renamed `GateSpec`/`BarketSpec` to
`shape_name`, and `glow/rune_shape.rye` carries it. So the room says one word and its contents say another, and the contents are the ones to keep.

**A second classification runs underneath, saying what the first already says.** `src/app/`, `src/sec/`, and
`src/til/` hold `shape-*.glow` files too -- shapes about pool agents, grant families, and tilaks. So
four rooms hold one kind of thing, split by subject, while the subject is *already* the middle of
every filename. A reader learns two sorting rules to find a file that either rule alone would have found.

**The proposal is subtraction: name the room for what its files are, in the word the files already
wear, and let the filename keep the subject.**

| Today | Proposed | Holds | Why |
|---|---|---|---|
| `src/lib/` | **`src/gate/`** | `gate-*.glow` | the room and its 38 members finally say one word |
| `src/sur/` | **`src/shape/`** | `shape-*.glow` | `shape` is seated in the language; `sur` is inherited |
| `src/app/` `src/sec/` `src/til/` | folded into **`src/shape/`** | their `shape-*.glow` | one kind, one room; the subject stays in the filename |
| `src/gen/` | **`src/gen/`** unchanged | generators | `gen` is seated in this tree already, in two rooms |

Three rooms rather than six, each named for what it holds, each name predictable from any filename
inside it and each filename predictable from the room. `app` stays on the table deliberately: it is a plain,
universally understood word the tendency welcomes, and it earns a room again the day `src/` holds a
running program rather than a shape about one.

**What this costs, said before anyone asks.** 205 living files reference these room paths --
`src/lib/` 151, `src/sur/` 39, `src/app/` 8, `src/til/` 4, `src/sec/` 3. That is a breach in the seated sense: it relocates
and re-points, keeping every byte. It is one round's work with the repointer already
built, and it waits here as a **proposal**.

---

## The two homes for one file type

`.glow` desks live in two places: **340 flat entries in `glow/gen/`** and 75 across `src/`. The
first number is the finding.

**`glow/gen/` stands at 1.33 times the 256-entry room bound, and every meter reads it as green.**
The reason is the one `tools/` taught at 7.4 times over: `tools/fixtures/room_bound_scan.sh` counts
a day-folded room by **dated basenames**, and not one file in `glow/gen/` carries a stamp, so its
dated count reads zero for the room's whole life. The room is advisory rather than enforced, and an
advisory reading that always says zero is a reading a lap can safely ignore.

`stamp-and-name` already answers which fold shape applies, and it answers by asking what the files
are found by. A hand looks for `gate-sumto-u32.glow` rather than for the desk it wrote on a Tuesday.
So `glow/gen/` folds **by first sprig letter**, the way `tools/` did -- `glow/gen/g/`, `glow/gen/s/`
-- and `tools/t/tool_path_resolve.rish` is the shape its resolver copies.

**The deeper split is worth naming even though it is not this charter's ask.** `glow/` holds the
compiler, written in Rye. `src/` holds programs written in Glow. `glow/gen/` holds 340 desks that are
the language's own corpus -- a third thing beside compiler and program, the fixtures that prove the
compiler on real input. Three things, two rooms, and the corpus rests in the compiler's house because that
is where it was first written. Naming it a corpus costs nothing; moving it is a second breach, and
it belongs to its own round.

---

## The closed-stack seats for loop information

[`read-scope`](../.claude/rules/read-scope.md) seated the open shelves and the closed stacks on
`20260827.155213`. The loops' own state was left out of it, and it is exactly the kind of room a lap
should never walk.

**Six dotted directories hold it today, all at the tree root:** `.mind-state/`, `.dream-state/`,
`.cursor-state/`, `.zed-state/`, `.claude-state/`, `.cursor-agent-state/`. Three exist on disk right
now; all six are gitignored; together they are cited by 54 living files, and they are six of the 97
doors that face a lap opening the root.

**Proposed: one gitignored room, `loops/`, one subdirectory per body.**

```
loops/mind/    loops/mystery/    loops/sound/
loops/silence/ loops/dream/      loops/hush/
```

Six root doors become one. The name is the plainest word for what is inside, which is the tendency's
whole test, and it matches the six-body charter that already names these hands. The room is a **closed stack by name**: a lap fetches its own
body's file by path and leaves the room unwalked, since another body's loop state is exactly what a
lap does best to leave alone.

`loops/` is runtime state, so the tracked tree stands untouched and every reference promise holds;
the 54 citers are launcher scripts and prompts naming the old paths, repointed in the same motion. It is one round, and it is **proposed**.

---

## A development plan for the Glow ships and piers

The surveys hand this section its shape, and the honest reading is that **the language and the
network are each real and have grown up separately**. A plan that treats them as one system is
describing a thing still ahead of us.

**The crux, in the seated sense of the word -- the hardest solvable problem, whose solving opens the
rest -- is the socket.** `constel/` runs a complete consensus in memory with 31 witnesses. `comlink/` sends bytes over
localhost UDP with 23 witnesses and leaves ordering to its caller. FORA31 is the one rung that crosses that line, `constel/README.md` names it as the
unbuilt rung in exactly those words, and it waits on Keaton. Everything else in both modules stands ready behind it.

**Lindy-first says the order is: the words, then the roster, then the socket.**

1. **The roster hears the language.** Eighty-nine witnesses proving nothing on a cadence is the
   cheapest fix on this list and the one that makes every later claim checkable. The six unreached
   ones come first, since they are the newest rungs and nothing runs them today.
2. **The ladder folds its thirteen rungs home**, and STOA347 onward is marked by stamp and name.
   The compressor stops being a ladder that announces a length and becomes a record of what ran.
3. **The rooms take their own words** -- `gate/`, `shape/`, `gen/` -- and `glow/gen/` folds by
   letter under a resolver, so the corpus is inside a bound rather than outside a meter.
4. **Then the socket**, on Keaton's word, and not before: FORA31, where `constel/` meets
   `comlink/hosted_wire.rye`, with `comlink/rehearsal_wire.rye` -- three real processes on real
   ports, and today the most network-real file in the tree, still awaiting its
   first witness -- as the pen it is proven in.

**Two defects the surveys found on the way, both booked rather than fixed here.**
`tools/co/comlink_r1_dual_stack_witness.rish:72` runs `python3 tools/comlink_r1_dual_bind_probe.py`,
a file that became `tools/co/comlink_r1_dual_bind_probe.rish` on `20260811`; the witness now reds on
a missing path rather than on a dual-stack fact, while `tools/g/glow_tend_era_suite.rish:9` still
calls it the metal lap.
And the word **Constel** names two things under two laws that disagree: `constel/name.rye` admits
only vowel-free names, while `tools/fixtures/constel_names.txt` ships `xzkerith58` and
`maqwintel06` -- so every seated name in that fixture is one the code would turn away.

---

## What this charter refuses

**The deep debride is not taken, and the reason is its own precondition.** Keaton's word names it
as following *after all code organization structure and code comments and interlinking and path
references are all updated*. All three are still ahead, and this page proposes them. A
history rewrite asks every clone to clone again, and with six always-on hands holding trees, taking
it before the reorganization lands would spend that cost on a shape we would then change again. The
word is **held**, and the checkpoint law asks for a walk-back row on the day it is crossed.

**Room renaming waits for its own round.** A rename is a promise to 205 files, and a promise is
kept in the round that makes it rather than announced in the round that proposes it.

---

*May every room say plainly what it holds, may every ladder count only what it has already climbed,
and may the language and the network meet on the day a hand is ready to watch them.*
