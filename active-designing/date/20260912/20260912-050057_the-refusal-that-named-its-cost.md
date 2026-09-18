# The refusal that named its cost and never its cause

**Stamp:** `20260912.050057`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every reading here is taken by
[`tools/fixtures/s/standing_equipment_run.sh`](../tools/fixtures/s/standing_equipment_run.sh) and
proven by [`tools/s/standing_equipment_witness.rish`](../tools/s/standing_equipment_witness.rish)
**Kin:** [`the-baton`](../.claude/rules/the-baton.md) -- [`reds-first`](../.claude/rules/reds-first.md) -- [`stamp-and-name`](../.claude/rules/stamp-and-name.md)

## The bill, first

This lap opened a cold roster pass, read its card, chose its work, and opened a fleet claim -- the
order the baton asks for, step by step. Fifty-four minutes later the pass closed:

```
guards_green=272
guards_red=0
guards_seconds=3232
tree_moved=yes
run_verdict=tree_moved
refused: the tree changed while this ran -- these verdicts describe neither one
```

Every guard verdict was thrown away, which is right: readings spread across two trees answer no
question about either. What the transcript could not say is **which file moved**. The runner
compares two twelve-character digests, and a digest cannot be diffed from -- the receipt's own
comment three hundred lines below says exactly that about the commit hash it stores beside one.

The file was `construction/fleet-claims.kyri`, and it moved because
[`tools/f/fleet_baton.txt`](../tools/f/fleet_baton.txt) tells every ship to open a claim before it
builds. So the lap followed two seated directives and lost its pass to the pair of them.

## Why this is a loom rather than a lantern

Copal reported the same shape one lap earlier, from its own door and in its own words: *I edited
the tree while the cold pass ran, which this baton tells every ship not to do.* It stopped its pass
and closed on a hot scoped one. Two ships, two causes, one afternoon, and in both cases the
instrument named the cost and left the cause to a hand's memory of what it had just typed.

A memory is a fine reader when the window is four minutes. Across fifty-four, on a pier where eight
ships write and a peer's commit can land in a checkout mid-pass, it is a guess.

## The mechanism

`tree_digest()` hashes a stream and returns twelve characters. A second function, `tree_paths()`,
now emits the same tree keyed by **path** -- one `<hash> <path>` line per path that differs from
HEAD or is untracked, plus one line for HEAD itself -- and the runner writes it into its own
`mktemp` pen at the open and again at the close. The pen stands outside the tree, so taking the
reading can never be one of the things it measures.

The listing is path-keyed because the digest's own inputs cannot be. `git hash-object
--stdin-paths` prints hashes and no names, so an untracked file's content change leaves no path in
the digest's stream at all. One process hashes the whole list, for the reason the digest already
gives beside its own call: measured in a pen at 2,003 untracked files, one process took 45ms where
a call per file took 10,393ms. A path git names and the filesystem lacks carries the literal
`deleted` in its hash column, since `hash-object` refuses a missing path and would take the batch
down with it.

At the close, one `awk` over the two listings and `git ls-files` prints the difference in three
verbs:

```
tree_moved_paths=1
detail: moved appeared construction/first-resident-probe.txt
tree_moved_unnamed=0
tree_moved=yes
run_verdict=tree_moved
```

That reading is from the real runner on this tree, with a file written into `construction/` while a
named pass ran.

## The verb the pen caught

The first draft read its verbs off set membership: a path in the close listing and not the open one
had *appeared*. The pen answered `named_changed=no` on the first run, and the reason is the whole
lesson. **The listing holds what differs from HEAD, never the whole tree.** A committed file that
was clean when the pass opened stands in no open listing at all, so rewriting it mid-pass looks
exactly like a file arriving from nowhere.

The verbs are read against the tree now rather than against the instrument:

| Verb | Read from |
|---|---|
| `vanished` | gone from disk at the close -- a `deleted` hash, or no close line |
| `appeared` | the path is untracked and stood in no open listing; every untracked file is listed, so its absence then means it did not exist |
| `changed` | everything else, which is the tracked file that was clean at the open |

A verb read off set membership describes the instrument. These three describe the tree.

## Bounds, and what is said out loud

Sixteen paths are named and the remainder counted. A rebase mid-pass moves hundreds, and a
transcript printing all of them buys a scroll where a hand wanted a sentence; one that prints some
and says how many it withheld keeps both. `tree_moved_unnamed=` carries that number on every
refusal, zero included.

A pass that stood still prints none of this. A reading nobody needs on every green pass is noise a
reader learns to skip, and a reader who skips one line skips the next.

When the digest moves and no path-keyed line does -- a rename, or a path moving between the index
and the working tree -- the runner says so in a named sentence rather than printing an empty list.
An instrument with a stated reach is worth more than one that quietly missed.

## What it cost, and what it did not

The reading takes **162ms** on this tree at three dirty paths, run twice per pass, against the
3,232 guard-seconds a cold pass spends. The refusal is unchanged: a moved tree still exits 1 under
`run_verdict=tree_moved`, and a guard red still outranks it.

## Proven

Nine legs in [`tools/fixtures/s/standing_equipment_control.sh`](../tools/fixtures/s/standing_equipment_control.sh),
asserted by name in the witness, each verb apart -- a single leg standing for three would pass on
whichever one happened to work. Two mutations bite: collapsing `changed` into `appeared` reds
`named_changed`, and lifting the naming bound reds `named_bound_rows=16`. The bound is proven from
both sides by planting seventeen files against a ceiling of sixteen.

## What this does not reach

**Whether the claim board should move the digest at all.** A tracked coordination file every ship
writes mid-lap by instruction is arguably the same kind of thing as the runner's own gitignored
card, which the digest already reads past -- and weakening a digest is a decision rather than a
repair. Named here for Keaton's word; the naming above helps whichever way it falls.

**The habit.** Opening a claim before launching the pass costs nothing and avoids the whole case.
That is a sentence for the baton, which is a different lap.
