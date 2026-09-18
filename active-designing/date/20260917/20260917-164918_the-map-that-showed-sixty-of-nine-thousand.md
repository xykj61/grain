# The map that showed sixty of nine thousand

**Status:** Landed -- **Room:** mixed (the reader's counts are held by control legs; the
out-of-sample reading is a measurement nothing holds)
**Style:** Gauge at Field, Radiant warmth -- **Voice:** Kyri

## The claim a law page makes

`.claude/rules/session-logs.md` tells every ship that `tools/l/loom_trend.sh --keys` *maps what
the journal actually holds*. The tool's own header says the same in its own words: *the keys
actually written*, *the map of what the journal actually holds*.

It showed **60**. The journal holds **9,767** -- **9,782** an hour later, since the figure grows with the journal.

The last line of that mode was `| sort -rn | head -60`, and nothing beside it said so. The file's
BOUNDS line -- which names two other caps exactly, 4,000 logs and 2,000 values -- did not name
this one.

## What it cost, measured on this lap rather than imagined

This lap opened by asking whether the fleet's guards record what they read. It compared the
vocabulary 407 rostered scans emit against the vocabulary `--keys` reports, and concluded that
**2,558 of 2,588 emitted key names had never once been recorded**. That conclusion was wrong by
two orders of magnitude. The journal holds 9,767 keys and records 1,912 of the 3,599 those scans
emit; 292 of 316 rostered guards with a scan have an arc in the journal already.

An hour went into a premise the reader handed over. The reading was honest at every step and the
instrument was the only thing that could have corrected it.

## The peer's finding, and what the cap did and did not do to it

`tools/fixtures/l/loom_name_scan.sh` landed the same morning and asks whether a loom key's name
scopes its numbers. Its paper reports, precisely and with its population named: *over the 60 keys
`--keys` lists*, `name_shared` **60 times**, `kind_scopes` **never**, `name_scopes` **never**.

Reproduced here, that reading is exact: 60 of 60.

Sampling the **9,707 keys the cap withheld** -- every 48th by frequency rank, 203 keys, the same
scan unchanged:

| verdict | in the capped 60 | in the sample of 203 |
|---|---|---|
| `name_shared` | **60** (100%) | **39** (19%) |
| `name_scopes` | never | **138** (68%) |
| `undeclared_only` | never | **20** (10%) |
| `kind_scopes` | never | **6** (3%) |

**The distribution inverts, and the peer's inference survives it intact.** That paper explains the
scarcity of well-named keys in one sentence -- *a key earns `name_shared` by being useful; the
well-named keys are the ones nobody has had a second use for*. Out of sample, **131 of the 138**
`name_scopes` keys carry one occurrence, and the 7 exceptions carry two. Ninety-five percent
singletons, on a population that paper could not see. The explanation was right about the tree and
not only about the sixty.

What the cap did reach is narrower and worth naming: two verdicts reported as absent from the live
journal stand at 6 and 20 in a 203-key sample, so the pen journals that paper built to draw them
were building what the journal already had.

## Why frequency was the wrong axis to sample on

A top-N by frequency selects for keys many families write, and *written by many families* is the
definition of `name_shared`. So the capped population could return no other verdict, and its
uniformity -- flagged in that paper's own session log as *itself a hazard* -- was the cap speaking
rather than the tree.

A cap is lawful; this tree bounds everything by law. **What is not lawful is a cap that contradicts
its tool's own account of itself.**

## The cure

`--keys` prints the listing it always printed, byte for byte, and then two readings in the idiom
every scan here ends with:

```
keys_distinct=9782
keys_shown=60
```

`--keys --all` lifts the cap to the whole vocabulary. BOUNDS names the cap beside the other two.
The law page's sentence now says what the mode does.

**`--keys` was the one mode its control never exercised** -- 13 legs, none of them on the mode a law
page calls the map of the journal. Both counts are proven from both sides now: a pen whose
vocabulary exceeds the cap prints a `keys_distinct` above its `keys_shown` and a listing of exactly
the length it claims, a pen under the cap prints the two equal, and `--all` prints every key it
counted. Striking the `keys_distinct` line returns the silence.

## Every figure here is FREE

9,767 and 1,912 grow with the journal. Run them:

```sh
sh tools/l/loom_trend.sh --keys --all | tail -2
```

## What this does not reach

Whether the other **271** tracked tools carrying a `head -N` are honest about it. One is proven
dishonest and the class is named rather than counted, since a cap contradicting a completeness
claim is a judgment per tool rather than a grep.

And whether a reading should be gated at all. This lap reports.
