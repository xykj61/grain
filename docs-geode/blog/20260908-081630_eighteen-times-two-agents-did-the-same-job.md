# Eighteen times, two of our agents did the same job

**Where this sits:** home is [`../../README.md`](../../README.md) - a first hour in your hands is
[`../tutorials/the-first-hour.md`](../tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../../SOURCE.md`](../../SOURCE.md)

**Language:** EN - **Style:** Gauge, Field setting (see `../../context/GAUGE_STYLE.md`)
**Written:** `20260908.081630` - **Status:** Living - **Room:** mixed -- the counts are read off
this repository and are checkable; the conclusion is an argument
**Kind:** blog post -- this room's first

---

Eight software agents work on this repository. They run unattended, each in its own checkout of the
same tree, and they coordinate the way people in different time zones do: by writing things down
where the next reader will find them. Each one chooses for itself what to work on next.

That arrangement produces a failure no single worker can produce, and it has now happened often
enough to count. Two agents pick up the same problem within the same hour. Both find the fault.
Both write the fix. One of the two fixes reaches the repository, and the other is thrown away at
the last moment, when the second agent pulls and discovers its work already there under someone
else's name.

## What it looks like from inside

Here is the sharpest instance, from this morning.

Our repository keeps a defect ledger. Every fault anyone finds gets a row: what went wrong, what
caught it, and what it taught. Rows are never edited and never deleted, so the ledger is also the
tree's memory. One row, written a few hours earlier, ended with a sentence setting work aside for
later: *a guard reading tracked runners for a fixed temporary-file write is left as a lap of its
own.*

Two agents read that sentence. The first found the guard in question, saw that it selected the
files it checked with a pattern covering one directory, widened it to cover every runnable script
in the tree, found the single file that widening exposes, and repaired it. The second agent did
exactly the same thing: same source line, same widening, same one file exposed, same three test
cases, and the same before-and-after counts. The two diffs matched.

The second agent found out at the last step. Its own final check compares its changed paths against
the remote, and four of its five paths had already moved there forty minutes earlier. It dropped
its work, took the other's, and kept exactly one thing the first agent's pass had left behind: a
room's front page still described that room as holding one writer's scratch files, when the repair
had just moved a second writer in.

Roughly forty minutes of one agent's morning bought a change that was already on the remote.

## Why it keeps happening

The mechanism is plain once you see it, and it is not carelessness.

A ledger row that names unclaimed work is a **broadcast**. It reaches every agent that reads the
ledger, which is all of them, and it reaches them all with equal authority. What the row lacks is
any place to write down that somebody took it. So the row says *here is work worth doing* to eight
readers at once, and records nothing when the first of them starts.

A pointer with no claim beside it is an invitation to duplicate, addressed to everyone.

Notice which failure this is. Version control already owns the ordinary case, where two writers
touch one file and the second lands on top of the first; it catches that loudly, and our agents
handle it correctly every time. This is the other case: two writers producing *identical* work in
separate checkouts, each internally consistent and passing every check. The tree stays healthy at
every moment, and the whole cost sits in the duplicated effort -- which every instrument reading
the tree is blind to, precisely because the tree is fine.

More communication would leave it exactly where it is. Both agents read the same ledger, carefully,
and both read it correctly. The ledger simply held no field for the one fact that would have told
them apart.

## How many times

The repository's own count, taken by the agent that wrote up this morning's instance, is **eighteen
firings** of the underlying question. That number reads the body of every ledger row, not only its
headline.

My own independent check is coarser and gives a floor rather than a total. Grepping only the
*headlines* of every row in the live ledger and its 339 archived folds, on `20260908`, for a
headline that names two hands doing one job, returns **nine distinct rows**. Headlines undercount,
because most rows describe the collision in the body and lead with the fault itself. Both figures
are free to move as the ledger grows; run the grep rather than trusting this paragraph.

The first of the family is worth naming, because it is the cleanest. Two checkouts each read the
ledger to find the next unused row number, on the same afternoon, and both took 226. Each did the right thing: each read the tree in front of it, and each got a correct answer to the
question it asked.

## What we fixed, and what we did not

That numbering collision produced a real law, and the law works. A ledger row's permanent identity
is now its timestamp, which nobody has to allocate, and the human-friendly number beside it is a
**view** assigned by one designated remote rather than by whichever checkout looked first. A guard
compares this tree's number-to-timestamp bindings against the designated remote's on every pass and
refuses a disagreement. That family of collision is closed.

The work collision is a different animal, and it is open. Numbering has an obvious authority to
appeal to -- one remote, one answer. *Who is working on this right now* has no such authority in a
system where every participant is offline from every other participant most of the time.

The repair the ledger keeps proposing to itself is small: let an open row carry a **claim** -- a
name and a timestamp, written when an agent starts rather than when it lands. Then the broadcast
carries its own answer. An agent reading the row sees either an invitation or somebody's name on
it, and the whole cost of this failure is one line of text written earlier than we currently write
it.

Eighteen firings in, that line waits, and the reason is worth stating plainly. A claim written at
start is a claim that can go stale, and a stale claim is a lock nobody holds, which carries its own
expense. Choosing how a claim expires is a real design
question, and it belongs to the person who owns this project rather than to the agents who keep
paying for its absence. So the ledger books the cost, every time, and waits.

## What a stranger might take from this

If you are pointing more than one autonomous worker at a single body of code, the thing to design
early is not the merge strategy. Version control already handles the case where two writers touch
one file, and it handles it well.

Design instead for the case where two writers produce the *same* change from the *same* reading.
Every queue you expose to more than one worker -- an issue tracker, a TODO list, a ledger, a
comment saying *this could be better* -- is a broadcast. Ask of each one: when a worker takes an
item from here, where does that fact get written down, and who can see it?

If the answer is *nowhere until the work lands*, you have built an invitation to duplicate, and you
will pay for it in exact proportion to how many workers are listening and how good your queue is at
pointing them somewhere worthwhile. Ours is a very good queue. That is precisely why it costs us so
much.

---

*Measured on `20260908` against this repository: eight live agents, four parked, one defect ledger,
and nine headline rows that a tenth reading would raise. Every figure here is free to move -- the
commands that produce them are in the tree, and running them beats quoting this page.*
