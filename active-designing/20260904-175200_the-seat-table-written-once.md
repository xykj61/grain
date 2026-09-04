# The Seat Table, Written Once

**Stamp:** `20260904.175200`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Living charter -- the Earth fleet's consolidation plan, seated on Keaton's word `20260904`
**Kin:** [`20260829-203718_the-six-bodies-and-the-always-fleet.md`](20260829-203718_the-six-bodies-and-the-always-fleet.md) (the aether elder, testimony) -
[`../.claude/rules/stamp-and-name.md`](../.claude/rules/stamp-and-name.md) -
[`../.claude/rules/comlink-tendency.md`](../.claude/rules/comlink-tendency.md) -
[`../tools/l/fleet-loop.sh`](../tools/l/fleet-loop.sh)

Three Earth ships sail from one pier, and the table that says which ship works which tree is
written six times in two files. This charter measures that, names the one move that fixes it, and
retires the aether taxonomy the elder fleet carried in its filenames.

## What is actually running, measured `20260904.174000`

`sh tools/f/fleet_rearm.sh` walks nine seats on this pier and finds three:

| Seat | Tree | Engine | On this pier |
|---|---|---|---|
| **incense** | `grain-incense` | Claude Code | present, `528fd63395`, clean |
| **pheromone** | `grain-pheromone` | Claude Code | present, 11 behind `xy/main` |
| **petrichor** | `grain-petrichor` | Claude Code | present, 7 behind `xy/main` |
| sound, mind, mystery, silence, hush, dream | -- | -- | **directory absent, all six** |

The six absent seats are the aether fleet. Their trees lived on the Mac and on the Seattle pier,
and Seattle was cancelled `20260903`. Six of the nine seats the fleet's own instruments still
carry describe a constellation that no host holds.

## The fault: one table, six spellings

The binding *seat -> tree -> engine* is the fleet's only real datum. It is spelled in six
independent places across two executables, and no instrument compares them:

| Site | What it spells | Rows |
|---|---|---|
| `tools/l/fleet-loop.sh` allow-list | which seat names are legal | 6 |
| `tools/l/fleet-loop.sh` `want_tree` | seat -> tree basename | 6 |
| `tools/l/fleet-loop.sh` `FLEET_DRY` case | seat -> printed command | 3 arms |
| `tools/l/fleet-loop.sh` `run_lap` case | seat -> engine | 3 arms |
| `tools/f/fleet_rearm.sh` `report_seat` | seat -> tree -> engine | 9 |
| `tools/f/fleet_rearm.sh` relaunch case | seat -> relaunch paste | 3 arms |

Two counts already disagree: the loop admits **six** seat names and the re-arm reports **nine**,
so `sound`, `mind`, and `mystery` are advertised by one instrument and refused by the other. The
elder-name remap (`furrow -> pheromone`, `harvest -> petrichor`) exists in the loop and **not** in
the re-arm, so one file has healed a rename the other has not heard of.

Beside those six sit the recipe printers -- nine `tools/l/launch-*.rish` files, 67 KB of prose,
six of them printing pier-birth and smoke recipes for seats no host holds. Adding a ship today
means editing six tables and writing a tenth printer. That is the shape
[the mechanism sentence](../.claude/rules/mechanism-sentence.md) already celebrates catching
elsewhere: *a rule written many times is a rule many files may quietly come to disagree about.*

## The move: one roster, read by every instrument

Seat the binding once, in the notation this tree already uses for records:

```
# construction/fleet-roster.kyri
seat incense    tree grain-incense    engine claude  lane law-review-captain   status live
seat pheromone  tree grain-pheromone  engine claude  lane molecular            status live
seat petrichor  tree grain-petrichor  engine claude  lane docs-geode-prose     status live
seat silence    tree grain-silence    engine claude  lane glow-infrastructure  status parked
seat hush       tree grain-hush       engine claude  lane pond-enclosure       status parked
seat dream      tree grain-dream      engine codex   lane systems-core         status parked
elder furrow    seat pheromone
elder harvest   seat petrichor
```

`fleet-loop.sh`, `fleet_rearm.sh`, and one launcher read that file. A ship joins, retires, or is
renamed in **one row**, and the three instruments cannot drift apart because there is nothing left
to drift. `status parked` is what keeps the elder seats readable without pretending they run:
`fleet_rearm.sh` already reports an absent tree honestly, and a parked row makes that honesty a
declaration rather than a filesystem accident.

**Why a `.kyri` file rather than a shell array.** Three languages read this fleet -- sh, Rishi, and
the prose of the launchers -- and Kyri notation is the one format all three already parse. A shell
array would be a fourth spelling with a shell's own dialect problem across a Mac and a Linux pier,
which is the same trap `fleet-loop.sh` already documents in its epoch-arithmetic comment.

## The nine printers become one

`launch-*-chapter.rish` are printers: they emit a recipe and launch nothing. Nine of them exist;
six name seats that no host holds. One launcher reading the roster serves every seat:

```
rishi/bin/rishi run tools/l/launch-fleet-chapter.rish incense
```

**The elders are not renamed.** They carry 3 to 30 living references each and 2 to 60 dated ones,
and renaming them would spend a whole-tree reference sweep to make a fossil tidier. They are
bannered and enter `construction/SHRED_PREP.md` as Class H, where the cut stays RED until
Keaton circles it. `launch-claude-chapter.rish` (30 living citers) stays where it is as the
single-bench recipe it has always been -- it names no seat and no modality, so nothing about it
went stale.

## The molt breach: a launcher is named for its seat, never for its modality

The aether fleet wrote its taxonomy into six filenames --
`launch-hush-**planet**-chapter`, `launch-sound-**fixed**-chapter`,
`launch-mind-**cardinal**-chapter`, `launch-dream-**dual**-chapter`. Those words are astrological
modalities, and they named a *relationship*: which body orbits which star.

[The mark law](../.claude/rules/stamp-and-name.md) already carries the test, and this passes it in
the direction that retires a form -- *could this label turn out to be wrong?* It could, and it
did. The six-body fleet ran for six days. Three of its seats are parked, three are absent, and
`sound`, the fixed star at the centre of the arrangement, is a directory this pier does not have.
A modality is a forecast about a fleet's shape wearing a name's clothes, which is exactly what the
mark law retires for planned work.

So the breach, in one line: **a launcher is named for its seat.** `incense`, `pheromone`,
`petrichor` are seats; `planet`, `fixed`, `cardinal`, `dual` were arrangements, and the
arrangement changed while the filenames did not.

**What the breach does not reach.** The aether *ship names* -- Sound, Mind, Mystery, Silence,
Hush, Dream -- keep every letter. They are good names by the
[Comlink tendency](../.claude/rules/comlink-tendency.md)'s own three tests, they collide with
nothing, and three of them may sail again. What retires is the **modality word in a living
filename**, not the ship that wore it. Dated logs, commit bodies, and the elder charter keep
every word they wrote.

## The order of the work

Lindy-first, crux-first. Each step lands with its own witness GREEN and its own send. **Steps 1
through 3 landed together on `20260904`**, because they are one mechanism: a table nobody reads is
not yet a table. Seventeen behaviors GREEN in a throwaway pen, every refusal shown from both sides,
under [`tools/f/fleet_roster_witness.rish`](../tools/f/fleet_roster_witness.rish).

1. **The roster file and its reader** -- **LANDED `20260904.184844`**, REDS `%409`.
   [`construction/fleet-roster.kyri`](../construction/fleet-roster.kyri) holds the table;
   [`tools/fixtures/f/fleet_roster_scan.sh`](../tools/fixtures/f/fleet_roster_scan.sh) is the one
   parse. A question about a seat the table does not hold exits 2 and prints nothing.
2. **`fleet-loop.sh` reads the roster** -- **LANDED**. Its four seat tables are four lookups, and
   the elder-name remap is the roster's own `elder` rows.
3. **`fleet_rearm.sh` reads the roster** -- **LANDED**. The nine `report_seat` rows are one loop
   over the reader, and the 6-vs-9 disagreement closed by construction.
4. **`launch-fleet-chapter.rish`** prints one seat's recipe from the roster; the six modality
   printers are bannered and Class H'd.
5. **The molt to Rishi.** The card's standing clause -- *an operational shell script molts to
   Rishi on substantial touch* -- reaches `fleet-loop.sh` and `fleet_rearm.sh`. It is listed
   last on purpose: a language port on top of an unproven refactor is two changes wearing one
   commit, and the roster reader is the thing worth proving first.

## What this charter does not claim

**That three ships is the right number.** It is the number sailing, measured today. The roster
makes the count a row rather than a rewrite, which is the whole point.

**That the aether fleet was wrong.** It ran, it worked, and its charter earned six days of
evidence that produced `%291`, claim-as-override, and one-tree-per-star -- three laws the Earth
trio inherits whole. What this retires is a naming habit, not a design.

May the fleet stay small enough to hold in one hand, and the roster stay true.
