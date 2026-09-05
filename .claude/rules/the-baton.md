# The Baton -- the opening every ship reads, written once

**Seated:** `20260904.214754` on Keaton's word -- **Status:** Living
**The file:** [`../../tools/l/fleet_baton.txt`](../../tools/l/fleet_baton.txt) -- **The roster:** [`../../construction/fleet-roster.kyri`](../../construction/fleet-roster.kyri) -- **The guard:** [`../../tools/f/fleet_roster_witness.rish`](../../tools/f/fleet_roster_witness.rish)

**Every ship in the fleet opens the same way, and that opening is written once.**
`tools/l/fleet_baton.txt` holds it; `tools/l/fleet-loop.sh` prepends it to whichever seat is
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
| **ROTA** | **this rule** -- it had none |
| **THREAD** | [`session-logs`](session-logs.md) |
| **FLEET** | **this rule** -- one writer per checkout had none |
| **CLAIM-AS-OVERRIDE** | **this rule** -- it had none |
| **SEND** | [`send-word`](send-word.md) - [`commit-messages`](commit-messages.md) - [`mechanism-sentence`](mechanism-sentence.md) - [`remember-git-nib`](remember-git-nib.md) - [`git-signing`](git-signing.md) |
| **LOG** | [`session-logs`](session-logs.md) - [`session-log-provenance`](session-log-provenance.md) |
| **PINS** | [`checkpoint`](checkpoint.md) - [`debride`](debride.md) - the bound law at `context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md` |
| **CUSTODY** | the ITINERARY gate list - [`git-signing`](git-signing.md) *(the seed)* - **GATES-ONLY seated here** |
| **CLOSE** | [`collaboration`](collaboration.md) |

**Four of the eleven had no rule at all**, measured `20260904.214754` by grepping `.claude/rules/` for each:
`%291` appeared once, in passing, inside an unrelated rule; *claim-as-override*, the *council rota*,
and *GATES-ONLY* appeared nowhere. All four were load-bearing behaviors every ship performed every
lap, carried only in a seat prompt and a design essay. They are seated below.

## One writer per checkout (REDS `%291`)

**A checkout answers to one writer.** Two loops claiming one tree refuse; two loops on two trees is
a token spend and welcome. **Name any peer before a file moves.** A commit stages exactly its own
set and the index is proven to hold nothing else; a retry is path-limited the same way, and the
commit's file count is read back. The wound bit four times in four spellings in one day, which is
why it is a law rather than a habit.

**Machines are doors.** A seat is a chair, not a computer: the same ship may sit at a Mac or at the
pier, and what makes that safe is proving the other door is closed and opening with the twice-pull.

## Claim-as-override

**When a lane's agent-doable queue is empty, the loop takes the oldest unclaimed booked lap from any
lane rather than stopping.** The claim is named in the session log and in that day's shelf row; the
lane's owner reviews at their next sitting; **custody gates still stop the lap**; and a claim never
touches a peer's in-flight work. An idle ship is a worse outcome than a claimed lap, and a claim
written down is reviewable where an idle night is not.

## The council rota

**Each lap deep-reads ONE ROW of the 5 x 3 council grid** in
[`../../recursion-prompts/seed/autonomous-loop.seed.md`](../../recursion-prompts/seed/autonomous-loop.seed.md)
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
`tools/l/fleet_baton.txt` are the record**, and the guard reads the file.

Canonical Cursor twin: `.cursor/rules/the-baton.mdc`.
