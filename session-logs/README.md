# Session logs

**Language:** EN
**Style:** Gauge, Meter setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Living pin -- newest-first index of the logs still flat in this room
**Bound:** under `living_pin_max_bytes[session-logs/README.md]` (57344)
**Seasons roster:** [`SEASONS.md`](SEASONS.md)

Every session in this tree leaves a log, and this table is the way in. It reads **newest first**,
and one row is one lap: when it happened, what it is called, and what it found.

**This page carries its own byte bound** -- `living_pin_max_bytes[session-logs/README.md]` = **57,344**,
which is `256 x 192` rows plus 8,192 for prose, so the index can hold a full room of 256 flat logs.
Every other living pin keeps 24,576; the two serve different readings, since that number bounds a
page an agent reads *whole* and this one is read from the *top* (REDS %205, Keaton's word `20260824`).

**A row points; it does not summarise.** The log is the record, and the index is the way in, so a
row stays **at or under 192 bytes** -- a stamp, a linked title, and one clause. The number is the
pin's own arithmetic rather than a preference: a row costs about 123 bytes before it says anything,
the prose above takes about 2,100, and 192 leaves room for roughly 116 rows inside the 24,576 this
page declares. Rows once ran to 2,223 bytes apiece, which made this page a second copy of the logs
(REDS %204). Held by [`../tools/in/index_row_bound_witness.rish`](../tools/in/index_row_bound_witness.rish);
shelved rows keep every byte they wrote.

**This index holds exactly the logs still flat in this room.** A log folds by day into
`date/YYYYMMDD/`, and its row folds with it, onto `date/README-index-YYYYMMDD.md` -- one shelf per
closed day, listed in the [seasons roster](SEASONS.md). So the index and the room always describe
the same set, and neither can grow while the other shrinks. That pairing is what keeps this file
under the bound its header declares; it stood at 2,895,849 bytes before the rows learned to fold
(REDS %182).

**A day's own order is this table, rather than filename sort.** One-clock stamps sort ascending on
disk; within a day, trust the rows. Naming law:
[`../context/specs/20260627-102012_one-clock-naming-law.md`](../context/specs/20260627-102012_one-clock-naming-law.md).

**The living notation is Kyri** (`.kyri`) -- immutable key-value at the seam, sibling to the elder
`.bron`, with historical Markdown logs folded under `date/YYYYMMDD/` beside them. Rules:
[`../.claude/rules/session-logs.md`](../.claude/rules/session-logs.md) -
[`../.cursor/rules/session-logs.mdc`](../.cursor/rules/session-logs.mdc). Growth law:
[`../context/specs/append-only-growth-law.md`](../context/specs/append-only-growth-law.md).

*Erratum `20260724.203617` -- UTC window:* four logs were stamped from `Etc/UTC` and read in index
order rather than by stamp; they rest on the `20260724` and `20260725` shelves. The host zone is
`America/New_York`, and from `20260724.205009` the one-clock witness is **blocking**.

| Stamp | Log | What it recorded |
|---|---|---|
| `20260824.215225` | [a directory says it and means it](20260824-215225_a-directory-says-it-and-means-it.kyri) | rye closed; 456 reasons sit above an assert unlabelled. |
| `20260824.214523` | [the tail read not generated](20260824-214523_the-tail-read-not-generated.kyri) | linengrow closes at 100%; the tail was read rather than class-generated. |
| `20260824.213203` | [a room that really was empty](20260824-213203_a-room-that-really-was-empty.kyri) | linengrow 41.6% to 62.6% -- the first room in eight whose number held. |
| `20260824.211134` | [a check that shared the bug](20260824-211134_a-check-that-shared-the-bug.kyri) | crypto was 89.8%, not 57.5%; 483 lines carried a label the meter could not read. |
| `20260824.205510` | [the ring that destroys by name](20260824-205510_the-ring-that-destroys-by-name.kyri) | mand 0% to 100% -- custody code, where a reason is worth most. |
| `20260824.205156` | [glow reads its own reasons](20260824-205156_glow-reads-its-own-reasons.kyri) | glow 3.4% to 100%, and a sixth measurement fault owned. |
| `20260824.203812` | [the reasons were on the wrong line](20260824-203812_the-reasons-were-on-the-wrong-line.kyri) | glow 3.4% to 48%; its reasons were trailing comments all along. |
| `20260824.202727` | [the role is in the call graph](20260824-202727_the-role-is-in-the-call-graph.kyri) | photos.rye needed no sweep; the bin reads reachability and the law reads 92%. |
| `20260824.201311` | [the first room swept](20260824-201311_the-first-room-swept.kyri) | drawn_terminal swept 0% to 100%; the bin missed a third role word. |
| `20260824.195807` | [a refusal that must stop the lap](20260824-195807_a-refusal-that-must-stop-the-lap.kyri) | Refused three times; twice the commit shipped anyway. Now a guard. |
| `20260824.195429` | [the sweep target that was a test](20260824-195429_the-sweep-target-that-was-a-test.kyri) | The caravan falsifier does not fire; lattice was a selftest. |
| `20260824.194605` | [a number without its bins](20260824-194605_a-number-without-its-bins.kyri) | The figure was 2.8x the truth; the law runs at 79%, and coverage is a room property. |
| `20260824.192810` | [two weak tests one strong one](20260824-192810_two-weak-tests-one-strong-one.kyri) | The planted-name roster held 2 and the tree held 47; census 186 -> 177. |
| `20260824.183958` | [one reading two numbers](20260824-183958_one-reading-two-numbers.kyri) | The pin bound rises to 57,344 for one page, and the one reading answers per page. |
| `20260824.182308` | [a row points](20260824-182308_a-row-points.kyri) | 36 rows rewritten as pointers, the pin 291,781 -> 7,563, and two seated bounds found incompatible. |
| `20260824.180216` | [the room folds and two numbers meet](20260824-180216_the-room-folds-and-two-numbers-meet.kyri) | 169 logs and their rows carried across, the census unmoved. |
| `20260824.173816` | [the ratchet reaches its floor](20260824-173816_the-ratchet-reaches-its-floor.kyri) | 41 rows across; every folding room enforced, ceiling zero. |
| `20260824.173245` | [the prompts room carried across](20260824-173245_the-prompts-room-carried-across.kyri) | 78 rows onto 21 shelves, 120 links landing, pin under bound. |
| `20260824.170955` | [the denominator was the whole question](20260824-170955_the-denominator-was-the-whole-question.kyri) | Two denominators, opposite verdicts; a seated law at 59.6%. |
| `20260824.165609` | [the live prompt carries it too](20260824-165609_the-live-prompt-carries-it-too.kyri) | Both printed season prompts now carry the QA read. |
| `20260824.165456` | [the dial booked before it is built](20260824-165456_the-dial-booked-before-it-is-built.kyri) | Two gaps booked, each with its falsifier named. |
| `20260824.164836` | [a cited path exists](20260824-164836_a-cited-path-exists.kyri) | A recalled stamp shipped a citation resolving nowhere; the hook gains a fourth wall. |
| `20260824.164559` | [the grade a writer can aim at](20260824-164559_the-grade-a-writer-can-aim-at.kyri) | The negative ceiling read upward is a school grade; below B pushes a frame. |
| `20260824.162940` | [one model named once](20260824-162940_one-model-named-once.kyri) | A model id written four ways; one reading answers it now. |
| `20260824.154722` | [the closed rooms way in](20260824-154722_the-closed-rooms-way-in.kyri) | The closed room's way in. |
| `20260824.145109` | [a tool proven on one shape](20260824-145109_a-tool-proven-on-one-shape.kyri) | A tool proven on one shape. |
| `20260824.142925` | [the number with six homes](20260824-142925_the-number-with-six-homes.kyri) | The number with six homes. |
| `20260824.133802` | [the bound with two meters and no wall](20260824-133802_the-bound-with-two-meters-and-no-wall.kyri) | The bound with two meters and no wall. |
| `20260824.121445` | [the promise no tool could read](20260824-121445_the-promise-no-tool-could-read.kyri) | The promise no tool could read. |
| `20260824.112806` | [the number that looked like a fault](20260824-112806_the-number-that-looked-like-a-fault.kyri) | The number that looked like a fault. |
| `20260824.104946` | [the door that was already right](20260824-104946_the-door-that-was-already-right.kyri) | The door that was already right. |
| `20260824.095920` | [the guard that was right and unheard](20260824-095920_the-guard-that-was-right-and-unheard.kyri) | The guard that was right and unheard. |
| `20260824.091754` | [the glob that was not a path](20260824-091754_the-glob-that-was-not-a-path.kyri) | The glob that was not a path. |
| `20260824.084007` | [the page that named half its directory](20260824-084007_the-page-that-named-half-its-directory.kyri) | The page that named half its directory. |
| `20260824.082436` | [staging is not shipping](20260824-082436_staging-is-not-shipping.kyri) | Staging is not shipping. |
| `20260824.075640` | [the meter that read six of thirty four](20260824-075640_the-meter-that-read-six-of-thirty-four.kyri) | The meter that read six of thirty-four. |
| `20260824.071500` | [the rule that reached 95 of 98](20260824-071500_the-rule-that-reached-95-of-98.kyri) | The rule that reached 95 of 98, and the door nobody measured. |
| `20260824.062207` | [the ladder that named 73 of 110](20260824-062207_the-ladder-that-named-73-of-110.kyri) | The ladder table that named 73 of 110. |
| `20260824.060012` | [the card that narrated itself](20260824-060012_the-card-that-narrated-itself.kyri) | The card that narrated itself. |
| `20260824.052950` | [the index that outgrew its room](20260824-052950_the-index-that-outgrew-its-room.kyri) | The index that outgrew its room, and the depth a patch forgot. |
| `20260824.043930` | [the rule written as arithmetic](20260824-043930_the-rule-written-as-arithmetic.kyri) | The rule written as arithmetic, and the citation that named nothing. |
| `20260824.040212` | [one shape for a dated name](20260824-040212_one-shape-for-a-dated-name.kyri) | One shape for a dated name. |
| `20260824.030821` | [the recipe that would not parse](20260824-030821_the-recipe-that-would-not-parse.kyri) | The recipe that would not parse. |
| `20260824.023652` | [recursion loops gauge complete](20260824-023652_recursion-loops-gauge-complete.kyri) | Recursion loops updated for Gauge. |
| `20260824.021623` | [standfast complete gauge molt](20260824-021623_standfast-complete-gauge-molt.kyri) | The Gauge standfast completes. |
| `20260824.021344` | [design research gauge molt](20260824-021344_design-research-gauge-molt.kyri) | Design and research rooms molt to Gauge. |
| `20260824.021019` | [specs foundations gauge molt](20260824-021019_specs-foundations-gauge-molt.kyri) | Specs, context root, and foundations molt to Gauge. |
| `20260824.020306` | [readme sweep gauge molt](20260824-020306_readme-sweep-gauge-molt.kyri) | Every README front door molts to Gauge. |
| `20260824.015422` | [front doors gauge molt](20260824-015422_front-doors-gauge-molt.kyri) | Front doors and context home molt to Gauge. |
| `20260824.014209` | [source md gauge molt](20260824-014209_source-md-gauge-molt.kyri) | SOURCE.md molts to Gauge. |
| `20260824.012716` | [studies gauge molt](20260824-012716_studies-gauge-molt.kyri) | The studies room molts to Gauge. |

