# incense-inner next log -- archive 50

**Language:** EN
**Status:** Archive -- one lap account shed whole from `recursion-prompts/incense-inner.md`'s `next`
section under the writer-sheds rule, to clear headroom for a fresh entry.
**Checkpoint:** `20260929.231348` -- **Nib:** `c99fa8ee47`

---

**This lap (`20260929.194259`) round-opened clean at `5dd0d7974a`, found four session logs stranded
in the dead-letter box (`stash@{0}`-`{3}`, each titled "holding still ... same inflight run"), a
claim board clear of overlap, and a cold run already in flight at the same HEAD (pid `2593511`,
`--cadence-slice 1` present) -- held fully still, watching via Monitor across six re-arms (roughly
64 minutes total), reading nothing until it carried `run_verdict=`.** This lap wrote its own
held-still log mid-run rather than waiting for the close, and that log -- left uncommitted, with no
later round-open to stash it away first -- was still on disk when the pass's own tree digest closed:
`tree_moved=yes`, `tree_moved_paths=1`, naming the log itself. **That is the lesson.** The four
stranded logs before it survived only because each was safely tucked into a stash by the NEXT
turn's round-open before its pass ended; a turn that watches one pass to completion within itself,
as this one did with Monitor, has no such round-open in between, so a log written mid-run stays an
untracked file straight through to the close. `run_verdict=guard_red`, 369 green, 10 red, 3 gated --
the standing eight plus two: `stash_record` (the four stranded logs, `unlanded=4`) and
`log_has_a_row` (this lap's own log, written without its index row). Held still through the close,
then restored all four stranded logs from their stash blobs (each parenting onto this same HEAD),
added all five missing index rows (the four plus this lap's own), and re-ran both guards directly:
`stash_record_scan.sh` reads `unlanded=0`; `log_has_a_row_scan.sh` reads
`post_law_logs_without_a_row=0`; both witnesses GREEN. Ran `remember_git_nib_witness.rish`: card nib
`38b0445918` resolved to state `parent`, GREEN. `N mod 5` on commit count 6807 (this lap's own
round-open HEAD) lands row 2, Fire -- sees, already read today at commit 6805 -- an honest repeat,
noted per the rota's own words rather than advanced past a cycle already exhausted for the day. This
lap also found the card lacked room for its own entry and shed the oldest standing account to a
fresh archive shelf before writing this one, per the writer-sheds rule. No REDS row booked; two
genuine repairs landed (four stranded logs recovered, one self-caused missing index row fixed)
rather than an ordinary read. Next lap: fresh round-open; check for an in-flight pass at the current
HEAD before launching a second; if writing a held-still log while watching a pass to its own close
within one turn, prefer writing it once `run_verdict=` has landed rather than mid-run, since nothing
between now and then will stash it away; hold fully still with `--cadence-slice 1` until
`run_verdict=` lands, and confirm `stash_record` and `log_has_a_row` both stay green on the next cold
run; the untriaged set stays six (`query_wire_retention` %756, `ceiling_teeth`'s `asserted_only`
population, `ignored_walk`'s tree-walks-past-git ceiling, `rye_compiled_reach`'s uncompiled-body
ceiling, `falsifier_form_outcome`'s 21 falsifier-less ranked rows, `shim_reason`'s
unrostered-swallow ceiling; `rule_twin`/`pond_enclosure_*` gated) -- each still wanting Keaton's word
or a larger plan than one lap affords.
