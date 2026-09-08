# Running the fleet -- launch, watch, and stop the ships

**Language:** EN - **Style:** Gauge, Field setting (see [`../../context/GAUGE_STYLE.md`](../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Written:** `20260907.160051`
**Status:** Living - **Room:** checkable -- every command below was run against this tree before it
was written down, and the two that launch a ship were run in their own dry-run form
**Where this sits:** home is [`../../README.md`](../../README.md) - a first hour in your hands is
[`the-first-hour.md`](the-first-hour.md) - the room index is [`README.md`](README.md)

---

## Who this is for

You have a pier with one or more Grain checkouts on it, and you want the unattended ships sailing.
[The First Hour](the-first-hour.md) puts a working tree in your hands; this page starts where that
one ends. Everything here lived in session logs and in the live operator card until now, and both of those
are written for a hand who already knows the fleet.

**One idea carries the whole page:** a seat is a chair rather than a computer, and one table binds
a seat to its tree, its engine, and its lane. That table is `construction/fleet-roster.kyri`, named
here rather than linked because the operator cards live in the maintainer's own field and the
public seed carries no such room. The loop reads it, the watch reads it, and
the launcher reads it, so all three read one answer. To add, retire, or rename a ship, you
edit one row.

```
sh tools/fixtures/f/fleet_roster_scan.sh --live     # the seats sailing today
sh tools/fixtures/f/fleet_roster_scan.sh --seats    # every seat, live and parked
sh tools/fixtures/f/fleet_roster_scan.sh --resolve harvest
```

The last line answers `petrichor`. An elder seat name resolves to its living seat and says so, so muscle memory keeps working
after a rename.

## Launching one ship

```
cd ~/grain-petrichor
mkdir -p session-output
FLEET_BARE=1 sh tools/f/fleet-loop.sh petrichor 2>&1 | tee session-output/petrichor.txt
```

Three things in that line earn a sentence each.

**The tree comes first, and the script holds it there.** `fleet-loop.sh` resolves the tree that
*contains it* rather than your current directory, and it runs the lap only when that tree's
basename matches the seat's `tree` row. So a bench holding eight sibling checkouts keeps each
seat's laps on its own files -- one writer per checkout, which the tree books as REDS `%291`.

**`FLEET_BARE=1` launches on the host directly.** A Linux lap runs inside
`tools/ag/agent-jail.sh` by default; on Keaton's word `20260906` this pier runs bare, so every
launch carries the flag. A pier that wants the enclosure simply drops it.

**The tee is the reading window.** Transcripts land inside the tree at
`session-output/<seat>.txt`, with raw NDJSON beside it at `<seat>.jsonl` for a Claude seat. That
directory is gitignored and shared on purpose: any ship reads a peer's output by named path rather
than a hand pasting it.

To see the command by itself, with the lap held:

```
FLEET_DRY=1 LOOP_LAPS=1 sh tools/f/fleet-loop.sh petrichor
```

which prints, on this tree today:

```
fleet-loop: seat=petrichor engine=claude root=/home/keeper/grain-petrichor hours=18 laps=1
fleet-loop: FLEET_DRY=1 -- command only, no round-open, no lap
claude --dangerously-skip-permissions --effort medium --output-format stream-json --verbose -p <tools/p/petrichor_seat_prompt.txt>
```

**The knobs, all bounded.** `LOOP_HOURS` sets the deadline (default 18, computed as epoch
arithmetic so one script serves a Mac and a Linux pier). `LOOP_LAPS` bounds the lap count, with `0`
meaning unbounded and `LOOP_LAPS=1` giving you exactly one round. `LOOP_LIMIT_WAIT` (default 300)
and `LOOP_LIMIT_WAIT_MAX` (default 72) govern the hold described under *A spent session limit* below.
`FLEET_STAGGER` offsets a launch by the seat's roster slot, so eight ships do not open their
expensive phases in the same second.

## The prompt a ship actually reads

A seat prompt is a **file**, `tools/<first-letter>/<seat>_seat_prompt.txt` -- `tools/p/` for
petrichor, `tools/b/` for bakery. The room is derived from the seat's own first letter, matching how
`tools/` folds by first sprig letter, so a seat added tomorrow arrives findable by the same rule.

What the agent receives is **the baton plus that stanza**.
[`../../tools/f/fleet_baton.txt`](../../tools/f/fleet_baton.txt) holds the opening every ship
shares -- voice, card, rota, thread, fleet, send, log, custody, close -- written once and prepended
at launch. A directive seated on the baton reaches every ship on its next lap with no per-seat edit.
A seat prompt is its lane stanza alone.

The loop runs a lap only when both files read clean, and it says which one failed otherwise. A lap
holding its lane is the whole point: on `20260906` seven ships ran a generic round because a prompt
path moved while that check was still to come.

## The watch -- so a loop that dies comes back

A fleet loop ends four ways: three instant laps against an unreachable agent, a spent `LOOP_HOURS`
deadline, an interrupt, or a closed terminal. Restarting itself is the one thing an exited loop
leaves to somebody else, so the watch runs beside the ships in the same tmux session and re-arms
any live seat whose `fleet-loop.sh` process is gone.

```
sh tools/f/fleet_watch.sh                # watch until you stop it
sh tools/f/fleet_watch.sh --once         # one pass, then exit
sh tools/f/fleet_watch.sh --dry-run      # decide and print; send no keystroke
```

The dry run answers, on this tree today:

```
fleet-watch 16:02:14: watching session 'pier' -- interval 60s, skip 'incense', arm-max 3, settle 180s (DRY RUN)
```

**Read that `skip 'incense'` twice, because it is the page's one surprise.** `WATCH_SKIP` defaults
to `incense`, the captain's own bench, so the watch leaves that seat to a hand. Ask for it by
passing `WATCH_SKIP=` explicitly, and the script reads that empty value as *skip nothing* on
purpose -- it uses the `${WATCH_SKIP-incense}` form rather than `${...:-...}`, since the colon form
treats an explicit empty as unset and restores the default. That one character cost a night of the
captain's laps on `20260907`.

**Every window is found by name.** The watch reads `tmux list-windows` on every pass and matches
each name against the live seats in the roster. Both bindings already exist -- seat to tree in the
roster, name to index in tmux -- so the watch keeps its own copy of neither, and reordering your
windows leaves each ship's relaunch aimed at its own keyboard.

**The enclosure choice travels with it.** The watch passes its own `FLEET_BARE` through to every
re-arm, so a bare-launched fleet stays bare across every arm the watcher will ever make. Launch
the watch the way you launched the ships.

**What it leaves alone**, each in the safe direction: a seat whose loop already runs, read from the
process table rather than guessed from a pane's words; a window whose pane sits mid-command, since
somebody else has that keyboard; a seat name worn by two windows, because a watcher leaves an
ambiguous choice to a hand; a tree carrying `.loop-gates-only`, `.mind-state/CUSTODY`, or
`.mind-state/TRANSACTION`, since a gated choice belongs to a hand; and a seat that has burned
`WATCH_ARM_MAX` arms while surviving under `WATCH_SETTLE`, which is the loop's own quickfail law
one level up.

Its other knobs: `WATCH_SESSION` names the tmux session (default: this pane's, else `pier`),
`WATCH_INTERVAL` the seconds between passes (60), `WATCH_ARM_MAX` the fruitless arms allowed (3),
`WATCH_SETTLE` the seconds an armed loop must survive to count as taking hold (180), and
`WATCH_PASSES` a pass ceiling (0, unbounded).

## Stopping for real

**The watch brings a stopped loop back, so a sentinel is what makes a stop stick.** That is the
whole consequence of the section above, and it changes what stopping means.

| To stop | Do this |
|---|---|
| One ship, and make it stick | `touch .loop-gates-only` in that ship's tree |
| One ship, this lap only | `LOOP_LAPS=1` at launch, or let `LOOP_HOURS` expire |
| The watch itself | interrupt it, or launch it with `WATCH_PASSES=<n>` or `--once` |

`.loop-gates-only` is a **file** rather than a printed word because the transcript echoes the
prompt, and the prompt itself carries the letters `GATES-ONLY` -- a grep on the stream would
false-stop the loop the moment it began. The loop clears the sentinel at the top of each lap and
reads for it again at the close, so an agent writing it mid-lap stops the loop at that lap's end.
The watch reads the same file and holds off.

**An interrupt or a pass bound is what stops the watch**, and those two are the whole list. Said
plainly here because a brief written from memory named a `.watch-stop` file, which appears nowhere
in the tree -- a stop instruction earns its place by being run.

### Ask before you signal

Eight ships run one program name from eight trees, so a name-matching killer reaches the pier
rather than your lap -- and the calling shell holds the pattern too, so it takes itself down with
the rest. `tools/f/fleet_call.sh` resolves every candidate to its working directory and refuses
anything outside this tree out loud:

```
sh tools/f/fleet_call.sh --pattern standing_equipment --dry-run
```

which answers, on this tree today:

```
candidates=24 would_send=0 refused_foreign=20 refused_self=3 refused_unknown=1 root=/home/keeper/grain-petrichor verdict=ok
```

**Keep the `--dry-run`, because sending is what the helper does by default.** `--signal` names
which signal rather than whether to send one, so the flagless form is the live one. Reading it the
other way costs a pass: on `20260908` this page's own author asked what was running in this tree,
left the flag off, and killed the roster measurement the ask was for.

## Where the effort setting lives

Four places name it, and on this tree today three agree:

| Site | Reads |
|---|---|
| `tools/f/fleet-loop.sh` (two lines: the dry-run printf and the real invocation) | `--effort medium` |
| `.claude/settings.json` -> `effortLevel` | `medium` |
| the untracked per-clone `GLOW_PROFILE.bron` | `effort medium` |
| the tracked `GLOW_PROFILE.template.kyri` | `effort max` |

**Read `ps` rather than a file to know what is running.** Editing any of these leaves already-running
shells on their old value, so a change goes live when the loops are relaunched.
`tools/d/declared_model_witness.rish` holds the *model* name in agreement across every site that
declares it -- green when this page was written -- and its scan reports `declared_effort` from
`.claude/settings.json` alone. So the fourth row above stands as a real difference outside any
guard's reading, named here rather than swept.

## A spent session limit is a hold, not a fault

The loop classifies each finished lap `ok`, `limit`, `quickfail`, or `fault`, and it asks the limit
question **first**, because a spent window answers instantly and an elder rule judging by elapsed
time alone read that speed as a crash. On a `limit` verdict the loop holds `LOOP_LIMIT_WAIT` seconds
at a time, up to `LOOP_LIMIT_WAIT_MAX` times, and the lap counter stays where it was. An overnight
window that clears at 07:30 is therefore worked at 07:30 rather than at breakfast.

**After a session limit or an account switch, log in on the host first.** Inside the enclosure,
`--private-home` swaps `$HOME` for a tmpfs, so `agent-jail.sh` is what carries a `claude login`
typed at the pier shell into a tree: it copies the host credential when the tree has yet to hold
one, and again when the host's is strictly newer. Whichever hand moved last wins. Freshness is read
only **after usability** -- a credential counts as copyable when its access token is a non-empty
string -- because signing out rewrites the file with the same seven fields and empty tokens, which
is valid JSON, correctly shaped, and the newest thing on disk. Reading mtime alone once turned one
logged-out checkout into three. On a bare pier like this one, where `$HOME` stays the host's, that
host login *is* the login every tree uses.

## What one lap does

1. **Round-open first.** `tools/f/fleet_round_open.sh` clears an interrupted rebase, stashes dead-lap
   leavings, adopts the anointed order, and parks a true divergence -- so the card the ship reads is
   the tree it stands on. When the fetch declines, the loop waits 60 seconds and asks again, which
   keeps every lap on bytes it fetched itself.
2. **The agent runs one round** against the baton plus its lane stanza.
3. **The lap closes at a commit** rather than at `git add`, and its session log is born on that
   day's shelf under `session-logs/date/YYYYMMDD/`.
4. **The sentinel is checked**, then the loop sleeps 20 seconds and opens the next lap, until
   `LOOP_LAPS` or the `LOOP_HOURS` deadline.

## What stays a hand's

The custody gates on the living operator card, `construction/ITINERARY.md`, are
manual by law: funds and keys, provisioning and paying, the maintainer's own identity, and the
public seed. Publishing the seed stays entirely a hand's. When gated work is all that remains, a
ship writes the sentinel, prints `GATES-ONLY`, and stops -- which is a report to you rather than a
failure.

---

*May your ships find their own trees, and may every stop you mean be a stop that holds.*
