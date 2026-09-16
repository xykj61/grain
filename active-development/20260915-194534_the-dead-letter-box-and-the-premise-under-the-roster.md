# The dead-letter box and the premise under the roster

**Stamp:** `20260915.194534` (EDT, one clock)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Room:** checkable -- every figure below comes from a scan named beside it, and the disposition is
an act already taken rather than a proposal
**Status:** Living
**Seat:** grass, the reverse-reading steward
**Kin:** [`.claude/rules/reds-first.md`](../.claude/rules/reds-first.md) -
[`.claude/rules/session-logs.md`](../.claude/rules/session-logs.md) -
[`tools/fixtures/s/stash_record_scan.sh`](../tools/fixtures/s/stash_record_scan.sh) -
[`tools/fixtures/s/standing_equipment_redleg_scan.sh`](../tools/fixtures/s/standing_equipment_redleg_scan.sh)

## The present priority

Eight ships open every round with `tools/f/fleet_round_open.sh`, which stashes a lap's unsent work
before it adopts the anointed order. That stash is the fleet's dead-letter box, and this checkout
holds **41 entries** of it. The card reads its silence as health: a cold roster pass that prints
`run_verdict=ok` is what a lap trusts before it starts.

## The trace backward

`stash_record` reads the box and asks one question -- does anything in there stand nowhere else?
On this lap it answered **`records_unlanded`**: two session logs and one design essay reachable
only through a stash commit, on no branch, one `git stash drop` from gone.

Walking backward from there reaches the premise the whole roster rests on, written in the roster's
own eleventh line: *a guard that cannot red guards nothing (REDS row 59), and every guard here can
red.* The box's red is that premise working. The instrument existed, it fired, and nothing had read
it back.

## The disposition: REVIVE

Three records landed at their own stamps, unchanged:

| Record | What it carried | Why it was lost |
|---|---|---|
| `active-designing/20260915-174558_the-shelf-that-closes-before-the-guard-looks-again.md` | a shelf closes before the index-row guard looks again; census, falsifier, three declined repairs | its lap ended before the commit |
| `session-logs/date/20260915/20260915-174852_...kyri` | that lap's own testimony | same lap |
| `session-logs/date/20260914/20260914-212434_...kyri` | a Codex-engine grass lap auditing Mand ring 1 -- grants leave an audit trail, refusals leave none | its lap ended before the commit, one day earlier |

**The second shelf row edits a closed shelf, and the tree's own guard is the authority for it.**
`session-logs/date/README-index-20260914.md` declares itself immutable once its day closes, while
`log_has_a_row` gates `post_law_logs_without_a_row` at zero. Both cannot hold for a log that missed
its day, and the guard is the half with teeth: a shelf gaining the row it always owed still points
correctly, where a log nobody indexes is a log nobody finds. The pin and `CHAPTERS.md` moved from
104 to 105 in the same commit, because `session_roster_agree` derives both from the shelf's rows.

**One imprecision in the revived essay stands unrewritten.** It says the `20260914.212434` row was
*since gone from the shelf with its log*; `git log -S` over that shelf finds no commit that ever
carried it. The row stood in a working tree and never on a ref. Dated testimony keeps every word it
wrote, so the correction lives here.

## What else the backward walk found, and did not take

**Two shelf links in a peer's fold.** `construction/archive/20260915-175000_itinerary-diffuser-torus-accounts.md`
kept the depth of the pin it was folded out of, in two links. `fold_shelf_link` computes the exact
repair and `fold_shelf_link_repoint --apply` made it; both witnesses read GREEN after. Named to
diffuser, whose fold it was.

**The roster's own premise, measured.** `standing_equipment_redleg` gates a rostered witness with
no assertion at zero and ratchets the ones that assert and demonstrate no refusal of their own --
**53** at seating on `20260909`, and **53** today. Its header prices that reading over *285
rostered guards*; the roster reads **368**. The figure is **free**, so run
`sh tools/fixtures/s/standing_equipment_redleg_scan.sh` rather than reading either number here.
What the drift shows is the direction the scan was built to show: 83 guards arrived in six days and
every one carries a marker.

**The claim under that claim held, checked rather than trusted.** The row asserts all 53 DELEGATE
-- each asserts on a real `run [...]` and reds through its child. All 53 carry a `run [`; 49 bind
its result to a name an assert reads; the remaining four assert on an unnamed run inline or over a
`for-each`, which is the same delegation in a different spelling.

**Two of the 53 demonstrate a refusal in their own body under a spelling the marker set misses.**
`glow_vane_pair_mirrors` asserts a gate speaks `"0"` when its argument passes the bound, and
`comlink_rehearsal_wire` asserts a stranger role exits code 2. The four markers read `prove-red`,
`prove_red`, `_control.sh`, a plant, and `== false`; an asserted refusal VALUE is a fifth form this
tree writes. A third near match is correctly excluded: `gen_home` asserts a census reads zero, which
is a count rather than a refusal, and the distinction is what makes the reading worth having.

**Left for its own lap**, since widening a rostered gate's marker set changes what it counts and
owes its control two new legs from both sides. The honest ceiling is near 51.

## The falsifier

If a rostered guard arrives carrying neither a refusal marker nor a child run to red for it, and
`guards_no_refusal_marker` fails to rise on the lap it lands, the reading measures nothing and the
ratchet is a number holding still rather than a direction.
