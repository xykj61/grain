# Recovered parked REDS draft

**Language:** EN
**Style:** Gauge, Meter
**Voice:** Kyri
**Status:** Recovery record -- an unpublished draft
**Room:** checkable -- source text recovered from Bakery's preserved stashes

The quoted draft below retains its original wording and local number. Upstream
had already assigned that number to another stamp. This page preserves the parked
record; its quotation adds no row to the published ledger. The original file name
keeps the older session log's citation reachable.

> # REDS -- ask before you truncate
>
> **Language:** EN
> **Style:** Gauge, Meter setting
> **Voice:** Kyri
> **Status:** Shelf -- one folded row, immutable once written
> **Room:** checkable -- a ledger row, its repair proven from both sides on a real process and a real lock
> **Folded:** `20260908.141811` from [`../REDS.md`](../REDS.md)
>
> **Born here rather than folded here.** The pin stood at `pin_headroom=24` bytes with
> `pin_foldable_rows=0` and `pin_deadlocked=1` -- thirteen rows, every one of them OPEN, so
> `tools/fixtures/r/reds_fold.sh` had no lawful move and this red had nowhere to land. The move is the
> one [`REDS-a-number-measured-before-its-own-commit-rows-638.md`](REDS-a-number-measured-before-its-own-commit-rows-638.md)
> records the fleet taking six hours earlier: a row born directly onto a single-row shelf, saying so in
> its own header and recorded in [`REDS-fold-recital.md`](REDS-fold-recital.md), so the spine stays
> gapless and the trail stays readable. This row is **CLOSED**, so `shelf_open_rows` does not move.
>
> It is the fourth firing of one family and the first to bite the repair built for the third. Read it
> beside [`REDS-ten-names-for-one-transcript-rows-639.md`](REDS-ten-names-for-one-transcript-rows-639.md),
> whose cure is the code this row corrects.
>
> ---
>
> **REDS %641 (`20260908.140846`) -- the launch that named its own transcript emptied it before asking
> whether a live pass was writing there.** *What went wrong:* `--detach` landed on `20260908.113404` to
> close a three-red family -- `%541` signaled a pass by command line, `%549` redirected one to a
> constant `/tmp` name, `%620` globbed a unique one back -- all three splitting the redirect and the
> naming across two shells. The flag put both in one shell, and rested the safety of a constant name
> per mode on a sentence in its own header: *a second pass in one tree already refuses under
> `run_verdict=run_in_flight`, so there is never a second live pass of one mode to collide with.* That
> refusal is taken by the **child**, at the run lock three hundred lines below, and the truncation is
> taken by the **parent**, before the child exists. The guarantee and the write ran in different
> shells, which is the family's own shape wearing the repair's clothes. *What caught it:* the fire
> rota, on the first command of this lap. `sh tools/fixtures/s/standing_equipment_run.sh --detach`
> printed a path; the transcript at that path carried this launch's header, then
> `run_verdict=run_in_flight`, then thirteen green guard lines and a second `run_verdict=guard_red`
> belonging to a pass launched by a lap that had since died (`pid 3666939`, `parent=gone`,
> `group_leader=gone`) and still appending. **One header over two passes' verdicts, and the tool's own
> predicate for finished -- the transcript carries a `run_verdict=` line -- could not tell them apart.**
> The first hundred and thirty lines were gone, and with them the names of two of the three guards that
> pass found red; `tools/s/standing_equipment_witness.rish` recovered them from the run card
> (`crushed_index`, `reds_pin_capacity`) because the card is written at the close and the transcript is
> not. *What it taught:* **a shell may only truncate what it has first established nobody is writing.**
> The launch reads the run lock before a byte moves, by exactly `lock_acquire`'s rule -- a lock whose
> owner is gone is stale and the child will reap it, a lock with an empty or unreadable pid file is one
> caught mid-creation and counts as held -- and refuses `detach_verdict=run_in_flight` naming the
> holder's pid and the transcript it declined to touch. Read rather than taken: acquiring a lock to
> release it a line later opens the window it closes. Five control legs in
> `tools/fixtures/s/standing_equipment_control.sh`, planted over a live `sleep` and lifted over its
> corpse: the held lock refuses, names the holder, names the transcript, and leaves the live pass's
> bytes byte-identical; the stale lock launches and truncates as before. The fault was reproduced on
> the elder runner from `HEAD` in a throwaway pen before the cure was written, so the legs are proven
> load-bearing rather than assumed. **What is left, said plainly:** two launches racing inside one
> instant both read a free lock and both truncate, which is two writers in one checkout that `%291`
> forbids outright, and it costs a header rather than a finished pass's record. **CLOSED**
