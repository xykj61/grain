# The Headwater Works Infusion -- seat five writings beside the fiber corridor bundle, project the seed, stop at the custody gate

**Stamp:** `20260825.171924` -- taken from the one clock at seating, never typed by counsel
**Language:** EN
**Style:** Gauge -- Field setting for the prose, Meter setting for the lap tables (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Mixed -- proposed. Every lap below stays PROPOSED until the bench runs it and the witness prints green; the push is Keaton's word
**Expands:** the counsel cell pasted with this prompt (ANSWER - SHAPE - PROPOSE - BATON), applied per [`.claude/rules/cell.md`](../.claude/rules/cell.md)
**Grows beside:** [`the fiber corridor infusion`](20260825-171912_the-fiber-corridor-infusion.md) -- the same nine laps, the same laws; this prompt names only what a second bundle landing beside a first changes
**Trees:** `xykj61/grain` (the full tree, written once) and `grain-os/grain` (the public seed, *projected* from the full tree by `tools/fixtures/sow_project.sh` rather than written by hand)

---

## The counsel this expands

Counsel delivered five writings as a second relay bundle of the same season, each with `STAMP` standing where a one-clock stamp belongs:

| Bundle file | Home in the full tree | Room | Setting | Seed disposition |
|---|---|---|---|---|
| `foundations/20260825-171919_where-the-water-enters.md` | `foundations/` | vision | Door | ships, scrubbed |
| `active-designing/20260825-171920_headwater-works-shapes.md` | `active-designing/` | mixed - design | Field | ships, scrubbed |
| `external-research/20260825-171921_brazos-headwaters-works-and-fiber.md` | `external-research/` | mixed - research for understanding | Field | ships, scrubbed (one farmer's name in its gratitude section becomes *a public figure* by the standing scrub; accepted) |
| `active-designing/20260825-171922_the-headwater-sleeve-siya.md` | `active-designing/` | design | Field | **withheld** by construction -- it names the fund; confirm it lands in `.sow-withheld.log` |
| `active-designing/20260825-171923_gleaner-second-watch-the-doors.md` | `active-designing/` | vision - yonder | Field | ships, scrubbed |

The bench writes each file once into the full tree. The seed receives what the projector ships, and the projection is the only second copy.

## What this prompt asks for

Resolve the links across both bundles, take real stamps, place the five writings at their homes, index them, run the witnesses that guard prose and rooms, log the round, commit in the tree's own shape, project the seed, prove the three seed gates, and stop at custody gate 1. Seat no name. Move no money. Type no stamp.

## Pre-flight

Read, in this order, before touching a file: `CLAUDE.md`; `.claude/rules/kyri.md`; `.claude/rules/gauge-style.md`; `.claude/rules/stamp-and-name.md`; `.claude/rules/design-rooms.md`; `.claude/rules/ascii-first.md`; `.claude/rules/session-logs.md`; `.claude/rules/commit-messages.md`; `.claude/rules/cell.md`; `context/TWO_ROOMS.md`; `context/SILO_TECHNIQUE.md`. Then confirm the basis:

```
git rev-parse --short HEAD          # counsel read ae8286e at clone; name the tip you actually hold
git grep -il gleaner | wc -l        # 0 if the first bundle is unseated; otherwise the count the first bundle placed
ls foundations active-designing external-research expanding-prompts | grep -i 'water-and-the-work\|fiber-corridor\|gleaner\|fiber-sleeve\|infusion'
```

Measurement beats memory: the tip you print is the basis, and the counsel's `ae8286e` is only what counsel saw. The third line tells you which of the two cases below you are in.

## Lap 0 -- which case, and the links across bundles

Five files in this bundle link to five files in the first bundle by their `STAMP_` names: `the-water-and-the-work`, `fiber-corridor-shapes`, `kansas-city-fiber-corridor`, `the-fiber-sleeve-siya`, `gleaner-the-public-signal-fetcher`, and `the-fiber-corridor-infusion`.

- **Case A -- the first bundle is already seated.** Read each seated file's real hyphen-form stamp from its filename and rewrite every cross-link in this bundle to it. A link to a first-bundle file that the projector withheld (the fiber sleeve memo) stays as a relative link in the second sleeve memo only, which is itself withheld; confirm both land in `.sow-withheld.log`.
- **Case B -- the first bundle is unseated.** Seat both bundles in one round, first bundle first, following the fiber corridor infusion's Laps 1-5 for it and this prompt's laps for the five files here; take all ten stamps before rewriting any link.

Either case ends with every relative link in both bundles resolving on disk:

```
for f in <the placed files>; do grep -o '](\.\./[^)]*\.md)\|]([^)]*\.md)' "$f"; done
```

A link that lands nowhere is a red, and reds go first.

## Lap 1 -- take the stamps

One stamp per file, taken at the moment that file is written, into a shell variable, never typed:

```
STAMP_DOT=$(TZ=America/New_York date "+%Y%m%d.%H%M%S")
STAMP_HYPHEN=$(printf '%s' "$STAMP_DOT" | tr '.' '-')
```

Rename each bundle file from `STAMP_<sprig>.md` to `${STAMP_HYPHEN}_<sprig>.md`. Inside each file, replace the header's `` `STAMP` `` with the dot form and every cross-link's `STAMP_` with the hyphen form of *that linked file's* stamp.

## Lap 2 -- place and check the surface

Copy each file to its home at the room root (rooms fold to `date/YYYYMMDD/` by their own tool later; new files are born flat). Then check three surface laws on each:

```
LC_ALL=C grep -nP '[^\x00-\x7F]' <file>; echo "ascii rc=$?"     # expect rc=1 (no match) -- ascii-first
grep -c '^# ' <file>                                             # expect 1 -- one H1
grep -n '^\*\*Status:\*\*' <file>                                # the room token must be present: vision, checkable, mixed, or research for understanding
```

Capture `$?` before any pipe, every time.

## Lap 3 -- index rows

Where a room keeps a living index (`foundations/README.md` does), prepend one row directly below the table's delimiter row: the stamp, the linked title, and one clause, at or under 192 bytes. The foundation's row names it the headwater companion to *the water and the work*.

## Lap 4 -- Lexicon accretion, proposed rows only

Append two **Proposed** rows to `context/LEXICON.md`, in the shape the *Sheaf* row already uses ("awaits Keaton's word to seat"):

- **headwater works shapes** -- four fill-in shapes (basin, aquifer, works, residual) that grow beside the fiber corridor shapes, with the design's path.
- **door** (water) -- the place where a load enters a basin; used in the headwater shapes and study, with the foundation's path. Check `git grep -iw door` first: the word may already carry a meaning in the tree, and if it does, the row proposes *basin door* instead and says why.

If the first bundle's two Proposed rows (Gleaner; fiber corridor shapes) are absent because Case B applies, add them in the same lap. A Proposed row records the proposal. Seating is the word. The rest of the Lexicon stays as written.

## Lap 5 -- witnesses

Run from bare, in this order, and print the green line of each:

```
rishi/bin/rishi run tools/t/two_rooms_doorway.rish        # every new stamped page names its room
rishi/bin/rishi run tools/p/prose_register_witness.rish   # Door roster gated; the new foundation is reported
rishi/bin/rishi run tools/l/living_docs_lint.rish         # links, orphans, retired words, Status rooms
rishi/bin/rishi run tools/p/parity.rish                   # the trio, from bare, before any claim
rishi/bin/rishi run tools/p/parity-selftest.rish
rishi/bin/rishi run tools/ad/additive-gate.rish
```

Record the foundation's negation share and grade as the register witness reports them. If the Door reading sits above 20%, soften by the Gauge moves and re-run; hold every number, path, and stamp exactly through the pass. A red the bench holds no writ to fix stops the lap and is named in the log; reds book the allocation.

## Lap 6 -- the session log

Write `session-logs/${STAMP_HYPHEN}_the-headwater-works-infusion.kyri` in `format session-log-v1` with `voice Kyri`, the prompt, the think steps, which case Lap 0 found, the witness readings as `obs` lines, one `file` line per placed file with its why, and a `recommend` line. Prepend its index row to `session-logs/README.md` below the delimiter, at or under 192 bytes.

## Lap 7 -- commits

Component-prefixed subjects under 50 characters, present tense, Meter setting, a body that names each file and a `Related` section pointing at the counsel cell and this prompt. Sign with the sandbox key. Sensible grouping:

```
foundations: add where the water enters
active-designing: add headwater works shapes and two notes
external-research: add the Brazos headwaters study
context: propose headwater shapes and door in the Lexicon
session-logs: log the headwater works infusion
```

## Lap 8 -- project the seed and prove the gates

```
sh tools/fixtures/sow_project.sh; echo "sow rc=$?"          # expect SOW_OK copied=N scrubbed=N withheld=N
sh tools/fixtures/sow_leak_scan.sh; echo "leak rc=$?"        # expect IDENT_CLEAN
rishi/bin/rishi run tools/s/sow_witness.rish                 # expect NO_PERSONAL
rishi/bin/rishi run tools/s/seed_link_witness.rish           # a link in a shipped document lands in the shipped tree
grep -n 'the-headwater-sleeve-siya' seed/.sow-withheld.log   # expect exactly one line: the memo is withheld by construction
grep -c 'brazos-headwaters\|where-the-water-enters\|headwater-works-shapes\|gleaner-second-watch' seed/.sow-scrubbed.log
```

Then read the four shipped copies once in `seed/` for the scrub's effect: the farmer's name in the study's gratitude becomes *a public figure*, which is the standing behaviour and is accepted; any other substitution that changes a claim is a red, named in the log, and the file is sub-excluded rather than shipped altered. The seed-link witness is the one most likely to red in Case A: a shipped study linking to a withheld memo is exactly what it catches, and the fix is to keep the sleeve link only inside the withheld memo.

## Lap 9 -- stop at custody gate 1

Report the tip, which case, the witness lines, the sow counts, and the withheld lines. The push to the `xykj61` remotes and the projection push to `grain-os/grain` are Keaton's word, by the standing custody rule; the bench surfaces the gate rather than crossing it.

## What the bench holds to, every lap

- **One clock.** Stamps come from `TZ=America/New_York date` into a variable. A typed stamp is a red.
- **Accrete, never break.** Dated files already on disk stay whole; the five new files are additions; the first bundle's files, seated or in flight, stay as they were written; the Lexicon grows by rows.
- **Propose, never seat.** The shapes' names, the word *door*, the sleeve, and every home named here are proposals in the record until the word.
- **Money parks.** The sleeve memo is read, placed, and withheld; nothing in it is acted on.
- **The seed is projected.** Write once in the full tree; ship what `sow` ships; confirm the withheld lines rather than assuming them.
- **ASCII first.** Bytes above 0x7F in a new file are a red.
- **No completion claim survives unverified.** The witness prints the green line, or the lap is open.

## Recommend

**Recommend: check-in after Lap 5.** Which case Lap 0 found, the ten or five stamps taken, the files placed, and the doorway, register, lint, and parity lines printed are the honest checkpoint; Laps 6 through 9 follow on the same word once the readings are on the record, and the push waits on Keaton.
