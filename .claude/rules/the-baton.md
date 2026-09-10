# The Baton -- the opening every ship reads, written once

**Seated:** `20260904.214754` on Keaton's word -- **Status:** Living
**The file:** [`../../tools/f/fleet_baton.txt`](../../tools/f/fleet_baton.txt) -- **The roster:** `construction/fleet-roster.kyri` (working tree) -- **The guard:** [`../../tools/f/fleet_roster_witness.rish`](../../tools/f/fleet_roster_witness.rish)

**Every ship in the fleet opens the same way, and that opening is written once.**
`tools/f/fleet_baton.txt` holds it; `tools/f/fleet-loop.sh` prepends it to whichever seat is
launching; a seat prompt is its **lane stanza** alone. A directive seated on the baton reaches every
ship on its next lap with no per-seat edit.

The shape is REDS `%409`'s lesson one room over. Six seat prompts each restated the whole opening --
voice, card, rota, thread, send, log, custody, close -- which is one rule written six times and the
same drift waiting to happen. It is written once now, and
[`../../tools/fixtures/f/fleet_roster_control.sh`](../../tools/fixtures/f/fleet_roster_control.sh)
holds it there: a stanza that restates the baton, a looping seat with no stanza, and an invocation
that reaches the agent without the baton are each counted at zero.

## What the baton says, and the rule behind each section

| Baton section | Governed by |
|---|---|
| **VOICE** | [`kyri`](kyri.md) - [`gauge-style`](gauge-style.md) - [`radiant-style`](radiant-style.md) - [`twilight-style`](twilight-style.md) - [`vocabulary-aroma`](vocabulary-aroma.md) *(the G-friendly default)* |
| **CARD** | [`ascii-first`](ascii-first.md) - [`stamp-and-name`](stamp-and-name.md) - [`quality-assurance`](quality-assurance.md) - [`reds-first`](reds-first.md) - [`read-scope`](read-scope.md) |
| **ABSENCE** | **this rule** -- the instrument is [`../../tools/fixtures/p/path_absence_scan.sh`](../../tools/fixtures/p/path_absence_scan.sh); it had no directive surface at all |
| **DOOR** | [`../../context/TWO_ROOMS.md`](../../context/TWO_ROOMS.md) - [`design-rooms`](design-rooms.md) *(the other law wearing the word)* |
| **ROTA** | **this rule** -- it had none |
| **THREAD** | [`session-logs`](session-logs.md) |
| **FLEET** | **this rule** -- one writer per checkout had none |
| **WATCH** | **this rule** -- the watch is new on `20260906` and had none |
| **CLAIM-AS-OVERRIDE** | **this rule** -- it had none |
| **SEND** | [`send-word`](send-word.md) - [`commit-messages`](commit-messages.md) - [`mechanism-sentence`](mechanism-sentence.md) - [`remember-git-nib`](remember-git-nib.md) - [`git-signing`](git-signing.md) |
| **LOG** | [`session-logs`](session-logs.md) - [`session-log-provenance`](session-log-provenance.md) |
| **PINS** | [`checkpoint`](checkpoint.md) - [`debride`](debride.md) - the bound law at `context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md` |
| **CUSTODY** | the ITINERARY gate list - [`git-signing`](git-signing.md) *(the seed)* - **GATES-ONLY seated here** |
| **CLOSE** | [`collaboration`](collaboration.md) |

**Four of the eleven sections standing then had no rule at all**, measured `20260904.214754` by grepping `.claude/rules/` for each:
`%291` appeared once, in passing, inside an unrelated rule; *claim-as-override*, the *council rota*,
and *GATES-ONLY* appeared nowhere. All four were load-bearing behaviors every ship performed every
lap, carried only in a seat prompt and a design essay. They are seated below.

## Absence is the one reading a seat may not take from local bytes alone (REDS %457)

**A whole-tree grep at a stale HEAD is the strongest evidence a lap can gather about a tree nobody
else is standing in.** A seat was handed `tools/fixtures/f/fleet_login_scan.sh` to run, reported
that no file and no reference to that name stood anywhere in the tree, tracked or untracked, and
reasoned onward to a conclusion about which meters the fleet owns. Every word was true of the bytes
it could see. The file had landed three commits earlier and that checkout had not fetched.

**On a fleet this is the ordinary case rather than the edge.** Eight ships push to one remote, the
round-open pulls at lap START, and a grep happens mid-lap -- so a checkout is behind within minutes
of opening. Read on the lap that seated this clause, mid-round: `commits_behind=1`.

The instrument is [`../../tools/fixtures/p/path_absence_scan.sh`](../../tools/fixtures/p/path_absence_scan.sh),
which fetches the anointed remote before it answers, prints `commits_behind`, and reports `here=`
and `upstream=` per path. `verdict=absent` wants **both** to say no; a path upstream holds and this
tree lacks reads `verdict=behind` and says so by name. Re-proven on metal `20260910` against live
divergence rather than a pen -- a path both sides hold, a fabricated name reading `absent`, and
`tools/t/tilak_root_count_witness.rish`, a witness upstream carried and this checkout did not,
reading `behind`.

**It is on the baton because the remainder is a habit, and a lap's own grep sits in no file.** That
is the same structural wall `%512` met for a tracked-source scan, `%549` for a shell redirect and
`%569` for a signal: no instrument this tree can own reaches a command typed at a session prompt.
Measured four days after the repair landed, the scan stood on **zero** living directive surfaces --
`tools/f/fleet_baton.txt`, `construction/ITINERARY.md`, every rule room, both prompt rooms, and the
standing roster. So it is set where habits are set.

## One writer per checkout (REDS `%291`)

**A checkout answers to one writer.** Two loops claiming one tree refuse; two loops on two trees is
a token spend and welcome. **Name any peer before a file moves.** A commit stages exactly its own
set and the index is proven to hold nothing else; a retry is path-limited the same way, and the
commit's file count is read back. The wound bit four times in four spellings in one day, which is
why it is a law rather than a habit.

**Machines are doors.** A seat is a chair, not a computer: the same ship may sit at a Mac or at the
pier, and what makes that safe is proving the other door is closed and opening with the twice-pull.

**And never signal a process by name.** `pkill -f standing_equipment_run` matches a command line
rather than a directory, so on a pier eight ships share it reaches the fleet, and the calling
shell's own command line holds the pattern, so it kills the caller too (exit 144). The bounded form
is `sh tools/f/fleet_call.sh --pattern <substring>`, which **reads**; `--signal TERM` is what acts.
**Naming a signal is the verb** (`20260908.071628`, the sixth firing): a bare call reports and sends
nothing, because that firing used this very helper to ASK whether a pass was alive and the bare form
TERMed it. The wall was perfect -- two peer trees refused out loud by name -- and the default verb
was the fault. It resolves each candidate
through `/proc/<pid>/cwd` and refuses a process outside this tree out loud rather than signaling it
in silence -- a false refusal costs one line, a false send costs a peer's pass.

**The clause is on the baton because the tool was not enough.** `fleet_call.sh` has stood with its
own witness since REDS `%541`, `process_reach` is rostered, and the wound has now fired **five**
times: three inside two laps at `%541`, once more at `%569`, and again on `20260908` when a ship
that had read the card typed the raw `pkill` at its own cold open and took a peer's pass with it.
Every guard that could see this reads **tracked sources**, and a command typed at a session prompt
is in no file -- which `%569` had already written down in its own third field. A defect nothing in
the tree can measure is set where habits are set, or it is not set at all.

**And a lap's own output lands in the tree, under a name the tool hands it.** `session-output/` is
gitignored and per seat, so a path under one root cannot be reached by another ship -- or by another
day. That habit was seated on the baton twice, at `%549` (a redirect to a constant name under a
shared `/tmp`) and `%620` (a unique name found again by globbing, which returned the same pid's file
from the day before), and eight hands then wrote **ten spellings** of one runner's cold-pass
transcript under it. A glob over `grain-copal`'s returned 07:17's pass rather than 08:56's, on live
state, inside the room `%620`'s own repair had moved the file to.

So the row of `20260908.113404` moved the naming into the tool: `sh tools/fixtures/s/standing_equipment_run.sh --detach`
derives the transcript path from the flags it was handed, truncates it, writes a header naming this
launch before the child starts, and prints the path and the child's pid. One shell owns the redirect
and the naming, which is what all three firings had split. The pass is finished when its transcript
carries a `run_verdict=` line -- a predicate on content, since an mtime and a process table are both
things a second shell can read wrongly. **A habit that must be typed is a habit that will be typed
differently**, so a rule asking a lap to choose a good name cannot close this class and a tool
handing it one can.

## A tree carries its own keys (REDS `%427`)

**`agent-jail.sh` binds ONE tree, so every path a ship needs lives inside that tree.** Its keyring
is its own `.gnupg-rye`, its transport keys its own `.ssh`, and `gpg.program`, `core.sshCommand`,
and every `IdentityFile` name paths under the ship's own root. A path into a sibling is a path the
ship cannot see from inside its jail -- it signs fine at a host prompt and refuses every commit in
the enclosure, which is the worst shape a fault can take: invisible from outside the wall, total
inside it.

**The shim resolves its own home.** `.gnupg-rye/gpg.sh` reads `GNUPGHOME` from its own `$0` rather
than from a typed absolute path, so the file is correct in whatever tree it is copied into.
`birth_a_clone.rish` copies the keyring and the ssh material into a newborn, rewrites the copied
config from field to newborn, and refuses if the field's name survives the rewrite.

**Nothing tracked can check this**, which is why the guard reads untracked files:
`.git/config` and `.git/ssh_config_jail` hold custody paths and are untracked by design, so
`tracked_link_scan`, the commit hook, and the link duty are each blind to them by construction.
Gated by [`../../tools/f/fleet_key_locality_witness.rish`](../../tools/f/fleet_key_locality_witness.rish)
over [`../../tools/fixtures/f/fleet_key_locality_scan.sh`](../../tools/fixtures/f/fleet_key_locality_scan.sh),
foreign paths at zero, a seat whose tree is absent from this pier reported rather than counted,
and every path resolved with `cd`/`pwd -P` before it is compared -- a symlinked keyring reads local
in the config and lands in the sibling on disk, which is the same fault wearing a disguise.

## A round-open clears a rebase before it reads the tree (REDS `%428`)

**An interrupted rebase is a corpse, and `tools/f/fleet_round_open.sh` clears it first.** The
pre-rebase tip is parked by name out of `orig-head`, then `git rebase --abort` restores the exact
pre-rebase branch and HEAD; a rebase that will not abort exits 2 and asks for a hand rather than
resetting. Every later step misreads a standing rebase -- the worktree reads dirty, HEAD is
detached at a half-replayed commit, and the `reset --hard` abandons the rebase and leaves the real
branch behind. **Do not run `git rebase --continue` on a tree that opens mid-rebase**; the open
has already parked what was there.

## The watch -- a loop that dies comes back (REDS `%471`)

**A fleet loop can die four ways, and a loop that has exited cannot hold.** Three instant laps
against an unreachable agent, a spent `LOOP_HOURS` deadline, an interrupt, a closed terminal. On
`20260906` six ships stopped themselves between 07:21 and 07:28 against a session limit that reset
at **07:30**, and the fleet sat dark until a hand woke and read the panes.

Two mechanisms answer that, at two levels:

- **Inside a lap**, `tools/fixtures/f/fleet_lap_verdict.sh` classifies a finished lap
  `ok | limit | quickfail | fault`, asking the **limit question first** because a limit refusal
  returns instantly and the elder rule classified it by elapsed time alone. `fleet-loop.sh` holds
  `LOOP_LIMIT_WAIT` (300s) up to `LOOP_LIMIT_WAIT_MAX` (72) times without counting a lap, so an
  overnight window that clears at 07:30 is worked at 07:30.
- **Above the loop**, [`../../tools/f/fleet_watch.sh`](../../tools/f/fleet_watch.sh) runs beside the
  ships in the same tmux session and re-arms any live seat whose `fleet-loop.sh` process is gone.

**Nothing is numbered.** The watch reads `tmux list-windows` for window **names** on every pass and
matches them against the live seats in `construction/fleet-roster.kyri`. A layout written into a
script is a layout that stays true until somebody moves a window -- and then the watcher types a
ship's relaunch into a stranger's keyboard. Seat to tree is the roster's binding; name to index is
tmux's; the watch adds no third copy of either.

**What it refuses, each in the safe direction:** a seat whose loop is already running (`%291` --
read from the process table, never guessed from a pane's words); a pane not ending at a shell
prompt; a seat name worn by two windows; a tree carrying `.loop-gates-only`, `.mind-state/CUSTODY`
or `.mind-state/TRANSACTION`; and a seat that has burned `WATCH_ARM_MAX` arms without surviving
`WATCH_SETTLE` -- the loop's own quickfail law one level up, so a watcher can never become the
thing it was built to prevent.

**One consequence every ship must hold: exiting no longer stops you.** The watch brings a stopped
loop back, so `touch .loop-gates-only` is what makes a custody stop stick. Printing GATES-ONLY
without the sentinel now reads as a loop that merely died.

**The enclosure choice travels with the watch.** `fleet-loop.sh` wraps a Linux lap in `agent-jail`
unless `FLEET_BARE=1`, and a watcher that re-armed the default would put a bare-launched fleet back
into the enclosure one ship at a time, unannounced -- the worst shape a disagreement can take. The
watch passes its **own** `FLEET_BARE` through, so a hand launching it chooses for every re-arm it
will ever make.

Proven by [`../../tools/fixtures/f/fleet_watch_control.sh`](../../tools/fixtures/f/fleet_watch_control.sh)
-- seventeen behaviors on a **real tmux session** in a throwaway pen, every refusal planted and then
lifted -- under [`../../tools/f/fleet_watch_witness.rish`](../../tools/f/fleet_watch_witness.rish).

## Claim-as-override

**When a lane's agent-doable queue is empty, the loop takes the oldest unclaimed booked lap from any
lane rather than stopping.** The claim is named in the session log and in that day's shelf row; the
lane's owner reviews at their next sitting; **custody gates still stop the lap**; and a claim never
touches a peer's in-flight work. An idle ship is a worse outcome than a claimed lap, and a claim
written down is reviewable where an idle night is not.

## The council rota

**Each lap deep-reads ONE ROW of the 5 x 3 council grid** in
`recursion-prompts/seed/autonomous-loop.seed.md`
section 1 -- lap `N` reads row `N mod 5`, where `N` is `git rev-list --count HEAD`, **advancing by
hand past a row already read that day**. Three documents a lap, so the canon returns roughly daily.

The five rows are the five senses: **aether hears, air feels, fire sees, water tastes, earth
breathes in.** Read the row *through* its sense -- an aether lap listens for the page nobody
answered, an earth lap takes in the concrete fact at the door before any argument about it. The
rota is a **meter**, not a ritual: it has caught a sleeping doorway guard and a silent page in two
commanded laps, which is what earns it a rule.

## GATES-ONLY

**When the only work remaining is behind a custody gate, a loop stops rather than circling.** Run
`touch .loop-gates-only`, print `GATES-ONLY`, and stop. The sentinel is a **file** rather than a
printed word because the stream echoes the prompt, which contains those letters, so a grep on the
stream would false-stop the loop the moment it began.

## Where the baton is printed

The captain prints the baton as a raw code block in the round's reply, so a hand at any door can
paste it without opening a file. That printing is a courtesy; **this file and
`tools/f/fleet_baton.txt` are the record**, and the guard reads the file.

## A page names its room at the door (`20260907.094712`)

**The doorway census was repaired by hand twice in two days and regrew both times.** It stood at 44
pages naming no room on `20260907.001500` and read **48** nine hours later; every one of the four
new pages was written by a hand that had read the law, and two of them cite
[`../../context/TWO_ROOMS.md`](../../context/TWO_ROOMS.md) inside the very `**Status:**` line that
names no room. `tools/t/two_rooms_doorway.rish` runs at `tier cadence`, so no lap-tier pass hears
it; a hand meets the finding a day late, repairs the pages, and the next night's pages arrive the
same way.

So the clause is on the baton, where a habit is set, rather than only in the guard that counts the
damage afterward. **A page written into `external-research/`, `active-designing/` or `docs/` names
its room -- checkable, vision, mixed, or research for understanding -- in its `**Status:**` or
`**Room:**` line.** `Proposed`, `Living`, `Landed` and `Design` answer a different question and
belong beside the token rather than instead of it, which the law's own three-question table already
says.

**Two laws in this tree use the word room, and that is half of why the habit slipped.**
`TWO_ROOMS.md` names a **register**; [`design-rooms`](design-rooms.md) names a **directory**,
decided by *would this still be worth reading if the code were deleted?* Nine pages under the
roster answered at the door under a key literally named `**Room:**`, two of them spelling `Mixed`,
and the guard read only `**Status:**` -- so the tree's own honest answers were being counted as
silence. The guard reads both keys now.

Canonical Cursor twin: `.cursor/rules/the-baton.mdc`.
