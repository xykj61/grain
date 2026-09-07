# The operator manual, and whether `manual/` and `docs-geode/` are one room

**Language:** EN - **Style:** Gauge, Field - **Voice:** Kyri
**Stamp:** `20260907.074407` - **Status:** Booked for **petrichor**, whose lane docs-geode is
**Asked by:** Keaton, `20260907` -- *update docs-geode with all of these operating user manual
instructions, and maybe unify `manual/` and docs-geode*
**Card row:** `construction/ITINERARY.md` -> *Next, the ranked remainder*

Two halves. The first is the one that earns its keep, and the second is a measurement before a move.

## (a) The operator surface exists and is written nowhere a newcomer looks

The fleet has grown a real set of operating instructions over the past week, and every one of them
lives in a session log or in the live card -- which is to say, in the two places a person arriving
tomorrow will not read. What a hand actually needs:

- **Launching one ship:** `cd ~/grain-<seat> && mkdir -p session-output && FLEET_BARE=1 sh tools/f/fleet-loop.sh <seat> 2>&1 | tee session-output/<seat>.txt`
- **The watch, and its one surprising default.** `tools/f/fleet_watch.sh` re-arms any live seat whose
  loop has died -- **except the captain's bench**, since `WATCH_SKIP` defaults to `incense`. A hand
  who wants the captain's seat looped too passes `WATCH_SKIP=` explicitly. That empty value only
  began meaning *skip nothing* on `20260907.074309`; before it, the shell's `:-` form read empty as
  unset and quietly restored the default, which cost a night's incense loop.
- **Why a window is found by name.** The watch matches `tmux list-windows` names against seats in
  `construction/fleet-roster.kyri`. Nothing stores an index, so reordering the windows cannot make
  the watcher type a ship's relaunch into a stranger's keyboard.
- **Where effort is set:** three files per tree -- the `--effort` flag in `tools/f/fleet-loop.sh`
  (twice, the dry-run printf and the real invocation), `effortLevel` in `.claude/settings.json`, and
  an `effort` line in the untracked per-clone `GLOW_PROFILE.bron`. A `sed` leaves running shells on
  the old value, so a change is not live until the loops are relaunched -- **read `ps` rather than
  the file** to know which is running.
- **After a session limit or an account switch:** log in on the host **first**, since `agent-jail.sh`
  seeds a tree's credential only from a host credential that is live and newer.
- **Stopping for real:** the watch brings a stopped loop back, so `touch .loop-gates-only` is what
  makes a custody stop stick, and `.watch-stop` is what stops the watch.

**docs-geode is petrichor's lane** -- *tend, never rename* (`construction/fleet-roster.kyri`), and
grass's own lane note warns against this exact mix-up, which is why the lap is booked to petrichor
rather than to grass.

**Falsifier:** if a hand can already restart the fleet from a single existing page, this is a
pointer rather than a manual, and the lap should add the pointer and stop.

## (b) One room or two -- measure, then propose

`manual/` holds **33** tracked files; `docs-geode/` holds **41** (measured `20260907.074407`). They
may be one room wearing two names, or two rooms with an honest boundary. What decides it:

- **What each actually holds** -- read both indexes rather than inferring from the names.
- **Who cites each** -- a whole-tree inbound sweep, which is lawful and required before any move
  (*references are promises*).
- **How the seed manifest treats them** -- `template-manifest.bron` may already give them different
  verdicts, and a merge would have to choose one.

**A merge that turns out to be two rooms costs every inbound reference**, so the proposal comes back
for Keaton's word rather than landing on measurement alone.
