# The Headwaters Infusion -- seat five writings, project the seed, stop at the custody gate

**Stamp:** `20260825.171918` -- taken from the one clock at seating, never typed by counsel
**Language:** EN
**Style:** Gauge -- Field setting for the prose, Meter setting for the lap tables (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Mixed -- proposed. Every lap below stays PROPOSED until the bench runs it and the witness prints green; the push is Keaton's word
**Expands:** the counsel cell pasted with this prompt (ANSWER - SHAPE - PROPOSE - BATON), applied per [`.claude/rules/cell.md`](../.claude/rules/cell.md)
**Trees:** `xykj61/grain` (the full tree, where everything is written once) and `grain-os/grain` (the public seed, *projected* from the full tree by `tools/fixtures/sow_project.sh` rather than written by hand)

---

## The counsel this expands

Counsel delivered five writings as a relay bundle, each with `STAMP` standing where a one-clock stamp belongs:

| Bundle file | Home in the full tree | Room token | Setting | Seed disposition |
|---|---|---|---|---|
| `foundations/20260825-171913_the-first-user.md` | `foundations/` | vision | Door | ships, scrubbed |
| `active-designing/20260825-171914_headwaters-water-shapes.md` | `active-designing/` | mixed | Field | ships, scrubbed |
| `external-research/20260825-171915_gallatin-headwaters-water-and-fiber.md` | `external-research/` | mixed, research for understanding | Field | ships, scrubbed |
| `active-designing/20260825-171916_the-water-sleeve-siya.md` | `active-designing/` | design | Field | **withheld** by construction -- it names the fund; confirm the line in `.sow-withheld.log` |
| `active-designing/20260825-171917_gleaner-the-gauge-source-family.md` | `active-designing/` | vision (yonder) | Field | ships, scrubbed |

The bench writes each file once into the full tree. The seed receives what the projector ships.

## The dependency, and how to handle it either way

**These five writings link to four files from the earlier Kansas City bundle** -- `the water and the work`, `fiber corridor shapes`, `the Kansas City fiber corridor`, `the fiber sleeve`, and `Gleaner, the public signal fetcher`. At the tip counsel read, none of the five had landed in the tree.

Check first, then branch:

```
git rev-parse --short HEAD
ls foundations/*the-water-and-the-work* active-designing/*fiber-corridor-shapes* \
   active-designing/*gleaner-the-public-signal-fetcher* \
   external-research/*kansas-city-fiber-corridor* 2>/dev/null; echo "kc rc=$?"
```

- **Both bundles land together** -- take stamps for all eleven files in one pass and rewrite every cross-link with the hyphen form of the linked file's own stamp.
- **The Kansas City bundle landed earlier** -- read its stamps off disk and point the new links at them.
- **The Kansas City bundle waits** -- park this bundle beside it and report that plainly, because a shipped page linking to a page the seed lacks is exactly what `seed_link_witness` exists to catch. Parking is the correct answer here; place nothing.

## What this prompt asks for

Take real stamps, place the five writings at their homes, index them, run the witnesses that guard prose and rooms, log the round, commit in the tree's own shape, project the seed, prove the three seed gates, and stop at custody gate 1. Seat no name. Move no money. Type no stamp.

## Pre-flight

Read, in this order, before touching a file: `CLAUDE.md`; `.claude/rules/kyri.md`; `.claude/rules/gauge-style.md`; `.claude/rules/stamp-and-name.md`; `.claude/rules/design-rooms.md`; `.claude/rules/ascii-first.md`; `.claude/rules/session-logs.md`; `.claude/rules/commit-messages.md`; `.claude/rules/cell.md`; `context/TWO_ROOMS.md`; `context/SILO_TECHNIQUE.md`. Then confirm the basis:

```
git rev-parse --short HEAD          # counsel read c2ea226 at clone; name the tip you hold
git grep -il headwaters | wc -l     # counsel read 0 at tip; the collision lap
git grep -il "bozeman\|gallatin" | wc -l   # counsel read 0 at tip
```

Measurement beats memory: the tip you print is the basis, and counsel's `c2ea226` is only what counsel saw.

## Lap 1 -- take the stamps

One stamp per file, taken at the moment that file is written, into a shell variable:

```
STAMP_DOT=$(TZ=America/New_York date "+%Y%m%d.%H%M%S")
STAMP_HYPHEN=$(printf '%s' "$STAMP_DOT" | tr '.' '-')
```

Rename each bundle file from `STAMP_<sprig>.md` to `${STAMP_HYPHEN}_<sprig>.md`. Inside each file, replace the header's `` `STAMP` `` with the dot form, and every cross-link's `STAMP_` with the hyphen form of *that linked file's* stamp. Take all five stamps first, rewrite links second, then confirm every relative link resolves:

```
for f in <the five placed files>; do
  grep -o ']([^)]*\.md)' "$f" | sed 's/](//; s/)//' | while read -r p; do
    [ -e "$(dirname "$f")/$p" ] || echo "UNRESOLVED $f -> $p"
  done
done
```

A link that lands nowhere is a red, and reds go first.

## Lap 2 -- place and check the surface

Copy each file to its home at the room root; new files are born flat and the room's own tool folds them to `date/YYYYMMDD/` later. Then check three surface laws on each, capturing `$?` before any pipe:

```
LC_ALL=C grep -nP '[^\x00-\x7F]' <file>; echo "ascii rc=$?"   # expect rc=1, no match
grep -c '^# ' <file>                                           # expect 1
grep -n '^\*\*Status:\*\*' <file>                              # the room token must be present
```

## Lap 3 -- index rows

Where a room keeps a living index, prepend one row directly below the table's delimiter row: the stamp, the linked title, and one clause, at or under 192 bytes. A row points; it does not summarise. The foundation's row names it the headwaters companion to *the water and the work*.

## Lap 4 -- Lexicon accretion, proposed rows only

Append two **Proposed** rows to `context/LEXICON.md`, in the shape the *Sheaf* row already uses:

- **headwaters water shapes** -- the six fill-in shapes (source, load ladder, town, works, reuse, money), sibling to the fiber corridor shapes, with the design's path.
- **gauge source family** -- Gleaner's second source family for public water readings, with this yonder note's path, marked as conditional on Gleaner's own seat.

A Proposed row records the proposal. Seating is the word. The rest of the Lexicon stays as written.

## Lap 5 -- witnesses

Run from bare, in this order, and print each green line:

```
rishi/bin/rishi run tools/t/two_rooms_doorway.rish
rishi/bin/rishi run tools/p/prose_register_witness.rish
rishi/bin/rishi run tools/l/living_docs_lint.rish
rishi/bin/rishi run tools/p/parity.rish
rishi/bin/rishi run tools/p/parity-selftest.rish
rishi/bin/rishi run tools/ad/additive-gate.rish
```

Record the foundation's negation share and grade exactly as the register witness reports them. A Door reading above 20% takes a softening pass by the Gauge moves -- turn the refusal into the capability, reach for the warmer word -- with every number, path, and stamp held exactly through the pass, then a re-run. A red outside the bench's hands stops the lap and is named in the log; reds book the allocation.

## Lap 6 -- the session log

Write `session-logs/${STAMP_HYPHEN}_the-headwaters-infusion.kyri` in `format session-log-v1` with `voice Kyri`, the prompt, the think steps, the witness readings as `obs` lines, one `file` line per placed file with its why, and a `recommend` line. Prepend its index row to `session-logs/README.md` below the delimiter, at or under 192 bytes.

## Lap 7 -- commits

Component-prefixed subjects under 50 characters, present tense, Meter setting, bodies naming each file, and a `Related` section pointing at the counsel cell and this prompt. Sign with the sandbox key.

```
foundations: add the first user
active-designing: add headwaters water shapes
external-research: add the Missouri's first rung
active-designing: add the water sleeve and gauge sources
context: propose headwaters shapes in the Lexicon
session-logs: log the headwaters infusion
```

## Lap 8 -- project the seed and prove the gates

```
sh tools/fixtures/sow_project.sh; echo "sow rc=$?"        # expect SOW_OK copied=N scrubbed=N withheld=N
sh tools/fixtures/sow_leak_scan.sh; echo "leak rc=$?"      # expect IDENT_CLEAN
rishi/bin/rishi run tools/s/sow_witness.rish               # expect NO_PERSONAL
rishi/bin/rishi run tools/s/seed_link_witness.rish         # a shipped link lands in the shipped tree
grep -n 'the-water-sleeve-siya' seed/.sow-withheld.log     # expect exactly one line
```

Then read the four shipped copies once in `seed/` for the scrub's effect. A farmer's name in a gratitude section becoming *a public figure* is the standing behaviour and is accepted. Any other substitution that changes a claim is a red, named in the log, and the file is sub-excluded rather than shipped altered.

**One extra read this bundle earns:** the Gallatin study names living companies, agencies, and advocacy groups in its gratitude section. Confirm the scrub leaves the *organisations* intact and the claims unchanged, since the external-research room allows outside names plainly and a scrub that renamed an agency would break a citation.

## Lap 9 -- stop at custody gate 1

Report the tip, the witness lines, the sow counts, and the withheld line. The push to the `xykj61` remotes and the projection push to `grain-os/grain` are Keaton's word by the standing custody rule; the bench surfaces the gate rather than crossing it.

## What the bench holds to, every lap

- **One clock.** Stamps come from `TZ=America/New_York date` into a variable. A typed stamp is a red.
- **Accrete, never break.** Dated files on disk stay whole; these five are additions; the Lexicon grows by rows.
- **Propose, never seat.** The shapes' names, the gauge source family, the sleeve, and every home named here stay proposals until the word.
- **Money parks.** The sleeve memo is read, placed, and withheld; nothing in it is acted on.
- **The seed is projected.** Write once in the full tree; ship what `sow` ships; confirm the withheld line rather than assuming it.
- **ASCII first.** Bytes above 0x7F in a new file are a red.
- **No completion claim survives unverified.** The witness prints the green line, or the lap stays open.

## Recommend

**Recommend: check-in after Lap 5.** The five files placed and the doorway, register, lint, and parity lines printed are the honest checkpoint. Laps 6 through 9 follow on the same word once the readings are on the record, and the push waits on Keaton.
