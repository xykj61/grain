# Incense, the cheap-pass session -- a prompt to open a fresh session from

**Language:** EN
**Stamp:** `20261001.133549` (EDT)
**Voice:** Kyri
**Style:** Gauge, Meter setting
**Status:** Living -- a handoff prompt; read it whole, then work from it
**Room:** checkable -- every step names a command, a file, or a number read on `20261001`
**Git nib:** `485750370f`

Paste this to a fresh Claude Code session in `~/grain-incense`, after the baton and the seat prompt.

## Goal

Make the fusion build's cheap `--scoped` pass earn its receipt, so every ship stops paying the full
cold endurance run on every lap. A full pass writes `construction/standing-equipment-receipt.kyri`
only when no guard reads red (gated is fine). The last receipt is dated `20260914.210448`.

## What stands, read `20261001`

- **Two of the eight standing reds are repaired and folded:** REDS `%756` (the wire's `max_path` is
  57, three hits fit, `query_wire_retention` is GREEN) and `%785` (`ignored_walk` reads 27 of 27,
  GREEN with 35 legs). Commits `e553a6ba0`, `b578154b2`, `485750370`.
- **Six reds remain:** `standing_equipment_redleg` (REDS `%827`, OPEN), `shim_reason`,
  `ceiling_teeth`, `rye_compiled_reach`, `falsifier_form_outcome`, `standing_equipment`. The last
  five carry no ledger row at all.
- **The ledger pin has room:** `construction/REDS.md` reads 57,906 of 65,536 bytes, about 7.6K, so
  roughly three rows fit. Re-read it with `wc -c construction/REDS.md`.
- **The ruling:** `active-designing/date/20261001/20261001-124643_the-fusion-build-ruling.md`, with
  its erratum. Clause three stands: a guard red and unchanged for more than three laps gets a ledger
  row that same lap.
- **The fleet default model is `claude-sonnet-5-5`** in the tracked settings. The six peer ships'
  local pins were set to the same on Keaton's word; bakery keeps `claude-opus-5-5`.

## The order of work

1. **Round-open and claim.** `sh tools/f/fleet_round_open.sh`, then
   `sh tools/fixtures/f/fleet_claim_scan.sh --check <paths>`, then open and push a claim before
   building (the baton's ORDER clause).
2. **Read each remaining red by name** from `construction/standing-equipment-runs.kyri` and run its
   witness alone to read the real failure. Measure first; two of the earlier eight read differently
   from their ledger rows.
3. **Repair the cheapest, smallest first,** one claim and one commit each. A repair that adds an
   enforcing check beside a constant belongs in one commit.
4. **Book the unbooked reds** that cannot be repaired this session, three fields each (what went
   wrong, what caught it, what it taught), citing by stamp until the anointed spine binds a number.
5. **Only when no red remains:** launch one cold run with
   `sh tools/fixtures/s/standing_equipment_run.sh --detach --cadence-slice 1` at the front of a lap,
   hold still until the transcript carries `run_verdict=`, then confirm the receipt date moved and
   `--scoped` runs.

## Hazards met this session

- **Sends contest.** Eight ships push constantly. Pull-rebase, push `xy` then `gp405`, and on a Git
  nib conflict keep the newer peer value. Land the nib follow-up as its own commit.
- **The commit-msg hook counts mechanism words:** name the file, field, constant, function or script
  changed in the body, three distinct words at least.
- **Stamps come from the clock:** `TZ=America/New_York date +%Y%m%d.%H%M%S`, read before every log.
- **Ledger folds use the tool:** flip the row's last status marker to BOOKED, write a shelf head,
  run `tools/fixtures/r/reds_fold.sh`, then run `reds_fold_witness` and the monotone witness.
- **Classifier stops:** several replies were stopped mid-work. Keep each step small and plain, check
  `git status` after any interrupted command, and redo only what did not land.
- **Peer clones stay theirs** except where Keaton's word says otherwise for a named change.

## What this prompt does not decide

The fleet's shape (fewer concurrent ships, invoked-only grass and petrichor) and the shared build
cache across checkouts stay Keaton's call. Offer them once and leave the timing to him.

End each reply on one line: `kg`, or a named `check in (...)`.
