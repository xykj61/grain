# incense-inner next-log archive 3 -- entries 20260925.162402 through 20260926.044306

**Language:** EN
**Status:** Fossil -- shelved whole out of `recursion-prompts/incense-inner.md`'s `next` section
**Checkpoint:** `20260926.055119`, nib `10f0c65ff9`

**This lap (`20260925.162402`) held a fresh cold run to `tree_moved=no`, `run_verdict=guard_red`,
376 guards: 338 green, 35 red, 3 gated -- three fewer reds than the prior lap's tally.** Picked
`commit_parent_claim` off the findings: `%801`'s wall reddened a second time, `claims_after_anchor`
grown from `%826`'s 29 to 52, every offender dated `20260918`-`20260921.115750` and none since. The
fault was the anchor's own placement -- set at the guard's seating rather than the day the fleet's
send habit caught up to the rule-5 fix -- so a seating-day anchor keeps accruing backlog for as long
as the fix takes to spread across eight ships. Moved the anchor once to `418fe0f2f9`, the last
offending commit; `claims_after_anchor=0` over the 358 commits since; witness and 43-leg control
GREEN; booked `REDS 20260925.162402`, CLOSED, leaving `%826`'s hook-wall question OPEN. Next lap: a
fresh round-open and cold run; the remaining 34 reds still overlap the standing backlog on the
shelf and in ITINERARY's Open Doors bullet.

**This lap (`20260925.183643`) held a fresh cold run to `tree_moved=no`, `run_verdict=guard_red`,
376 guards: 341 green, 35 red, 3 gated -- again three fewer reds than the prior lap's fresh-red
count, this time by fixing rather than by anchor repair.** A new stale detached pass (pid 4010211,
launch_head three commits behind) held the lock at this lap's launch attempt, confirmed as this
tree's own via `tools/f/fleet_call.sh` and TERMed, then relaunched clean at settled HEAD. Picked
`say_compose_bound` off the fresh findings: `deferred=17` against a walled ceiling of 0, every site
inside two witnesses -- `rye_build_lock_holder_witness.rish` and `rye_enum_variants_witness.rish` --
that landed after REDS %740's tree-wide brief-composition sweep and were never themselves swept.
Converted all 17 `assert ... else` interpolations from the whole `.out`/`.err` capture to the
bounded `.out_brief`/`.err_brief` field; ratchet fell to 0, both witnesses re-run GREEN on metal (28
and 26 control legs). No REDS row booked: the ledger reads 268 bytes of headroom against its
65,536-byte bound and stands `pin_deadlocked=1` with zero foldable rows, so a full three-field entry
would not fit -- recorded in the commit body (`295c09fcec`) and in the session log instead. Next
lap: a fresh round-open and cold run; the remaining 35 reds still overlap the standing backlog on
the shelf and in ITINERARY's Open Doors bullet, and the ledger fold deadlock is unchanged and still
Keaton's word to break.

**This lap (`20260925.200048`) held a fresh cold run to `tree_moved=no`, `run_verdict=guard_red`,
378 guards: 341 green, 34 red, 3 gated.** A live, non-stale pass (pid 3864474, launch_head still
HEAD) already held the roster lock at launch; confirmed it as this tree's own via
`tools/f/fleet_call.sh` (`verdict=dry`, six peer trees answered `refused_foreign`) and waited rather
than TERMing a pass the FLEET clause protects. Had already drafted a session log and index row
before that check, which would have moved `tree_digest` mid-pass; `git stash push -u` on just those
two paths restored the tree to what the pass had already snapshotted, confirmed with `git status
--porcelain`, and popped clean once the pass closed. Picked `exec_bit` off the fresh findings:
`plain_shebang_ratchet=58` against its own ceiling of 57. Dated every file in the ratchet list;
`tools/fixtures/b/bounds_home_census_control.sh`, added today, was the newcomer -- born at 100644
against exec-bit.md's own words, "born with the bit instead." `chmod +x` plus `git update-index
--chmod=+x`, no content change, control output identical before and after; witness GREEN, sixteen
legs, ratchet back at 57. No REDS row booked -- a one-file mode repair inside an existing named
ratchet. Landed at `d4f7342ac`, both remotes. Next lap: a fresh round-open and cold run; the
remaining 33 reds still overlap the standing backlog on the shelf and in ITINERARY's Open Doors
bullet, and the ledger fold deadlock is unchanged and still Keaton's word to break.

**This lap (`20260925.232420`) held a fresh cold run to `tree_moved=no`, `run_verdict=guard_red`,
378 guards: 341 green, 34 red, 3 gated -- unchanged from the prior lap's tally.** A live,
non-stale pass held the roster lock at launch attempt; `tools/f/fleet_call.sh` read it as this
tree's own and still HEAD, so waited for it rather than TERMing it, per the FLEET clause. Picked
`falsifier_form_outcome` off the findings: `pages_found=0` since the guard's own birth
(`20260917.134251`), because its ranked-page discovery excluded `date/` alongside `archive/` and
`yonder/` -- and both ranked pages this guard was built to cross (the moonshots and
refusal-that-can-fire pages) already lived under `date/` on the day it was born, so it could never
once discover its own subject. Narrowed the exclusion to `archive/yonder` alone, since a ranked
page's own errata accrue over days and it is expected to fold to its day shelf while still
gradeable -- unlike `archive/` (superseded) and `yonder/` (deferred), which stay excluded. Added a
control leg (`dated_page_counted`) proving a page folded to `date/` is counted where an archived
one still is not; 37 legs, GREEN. `pages_found` moved 0 to 2, and the deeper reading it surfaced is
real: every one of the 21 rows across both pages now reads `form=none`, because the sibling
`falsifier_reach_scan.sh` -- itself GREEN, and deliberately, testedly excludes `date/` as
"testimony rather than a claim this tree still makes" (its own `shelved_read_past` control leg) --
never captures a falsifier region for either page, while `rank_outcome_scan.sh` hardcodes one of
them as its own default subject. This is a genuine scope mismatch between two borrowed, correctly-
designed instruments the crossing scan composes, not a copy-paste bug; whether the reach scan
should widen its own scope for ranked pages specifically, or the crossing should read falsifier
regions itself for a dated ranked page, is a design call past this lap's depth-2 bound. The witness
stays RED, now for the true reason instead of a silent, undiagnosable one. No REDS row booked -- the
ledger reads 268 bytes of headroom against its 65,536-byte bound, `pin_deadlocked=1`, zero foldable
rows; recorded in the commit body and session log instead. Next lap: a fresh round-open and cold
run; the remaining 34 reds still overlap the standing backlog on the shelf and in ITINERARY's Open
Doors bullet; `falsifier_form_outcome`'s own remaining defect is now a design question for the lane
rather than a guard-closable one, and the ledger fold deadlock is unchanged and still Keaton's word
to break.

**This lap (`20260926.003429`) held a fresh cold run to `tree_moved=no`, `run_verdict=guard_red`,
378 guards: 341 green, 32 red, 3 gated -- two fewer reds than the prior lap's tally.** Round-open
opened clean, no standing lock at the cold run's launch. Picked the link-fold family off the fresh
findings rather than one guard: `dated_path`, `foundations_link`, and part of `seed_link` all
reddened from two of Keaton's own recent day-shelf folds -- `construction/archive/` on `20260924`
(commit `8bc3641bc`) and `external-research/` on `20260924`-`20260925` (commits `d9808832a`,
`99651eebe`). `dated_path_witness.rish` held two of its own seven fixture cases stale exactly the
way its own comment already documents for a third case -- verdict two's citer-relative reference
and the shared-basename twin both named a flat path that had folded out from under them; reworded
both to the file's current relative spelling, same lesson as the witness's own existing precedent,
GREEN on metal. `foundations_link_witness.rish` found 13 real broken links across 11 living
foundations pages (dated-basename but living-by-status, per that witness's own stated exemption)
still citing `external-research/<stamp>.md` flat; repointed both label and target to
`external-research/date/<day>/<stamp>.md` in each, GREEN on metal. `seed_link_witness.rish`'s hard
gate -- three front-door links in `MAP.md` pointing straight at withheld rooms (`linengrow/`,
`construction/`, `session-logs/`) -- unlinked to backtick-only prose, matching the convention the
same page already uses for `active-reviving/`, `expanding-prompts/`, and `counsel/`;
`front_door_links_outside_seed` 3 to 0. That witness's wider ratchet (820 ceiling, now 908) stays
RED: 527 of 908 sites cite files under `external-research/` itself, which the same fold likely
raised, but confirming and repairing an 88-site "name in prose" sweep is past this lap's depth-2
bound. No REDS row booked -- the ledger reads 268 bytes of headroom against its 65,536-byte bound,
`pin_deadlocked=1`, zero foldable rows; recorded in the commit body and session log instead. Next
lap: a fresh round-open and cold run; `seed_link`'s ratchet is the standing lead (measure whether
the 88-site rise is genuinely new or a scan artifact of the external-research fold before sweeping
site by site), the remaining reds still overlap the standing backlog on the shelf and in
ITINERARY's Open Doors bullet, and the ledger fold deadlock is unchanged and still Keaton's word to
break.

**This lap (`20260926.013806`) held a fresh cold run to `tree_moved=no`, `run_verdict=guard_red`,
379 guards: 344 green, 32 red, 3 gated.** Round-open opened clean; a live, non-stale pass already
held the roster lock at the same settled HEAD, confirmed as this tree's own via
`tools/f/fleet_call.sh` (`verdict=dry`) and waited for rather than TERMed, per the FLEET clause.
Picked `index_row_bound` off the findings: `session-logs/date/README-index-20260926.md`'s one row
stood at 214 bytes against the pin's own 192-byte bound. Shortened the row's "What it carried"
clause from 87 to 64 characters, same three facts kept; `index_row_bound_witness.rish` re-run
GREEN, 39 legs. No REDS row booked -- the ledger reads 268 bytes of headroom against its
65,536-byte bound, `pin_deadlocked=1`, zero foldable rows; recorded in the commit body and session
log instead. Landed at `e131f90ed`, both remotes. Next lap: a fresh round-open and cold run; the
remaining 31 reds still overlap the standing backlog on the shelf and in ITINERARY's Open Doors
bullet, `seed_link`'s 908-site ratchet is still the standing lead named above, and the ledger fold
deadlock is unchanged and still Keaton's word to break.

**This lap (`20260926.023747`) held a fresh cold run to `tree_moved=no`, `run_verdict=guard_red`,
378 guards: 344 green, 31 red, 3 gated.** Round-open opened clean at settled HEAD `85b014179`; a
live, non-stale pass already held the roster lock at that same HEAD, confirmed as this tree's own
via `tools/f/fleet_call.sh` (`verdict=dry`) and waited for rather than TERMed, per the FLEET clause.
Picked `nib_honesty` off the findings: the scan read `git_nib_lines=0`, `git_nib=absent`,
`verdict=NO_NIB_FIELD` against a card that plainly names its Git nib. The classifier requires an
exact ten-hex-character run to recognize any token at all -- the tree's own `--short=10`
convention -- and the card's field read `e131f90ed`, nine characters, so the token was invisible to
the classifier rather than merely misclassified. Confirmed `e131f90ed` still resolves to HEAD's
parent and that its proper ten-character form is `e131f90ede`; corrected the one character, scan
verdict `ok`, `nib_honesty_witness.rish` re-run GREEN on metal. No REDS row booked -- the ledger
reads 268 bytes of headroom against its 65,536-byte bound, `pin_deadlocked=1`, zero foldable rows;
recorded in the commit body and session log instead. Next lap: a fresh round-open and cold run; the
remaining 30 reds still overlap the standing backlog on the shelf and in ITINERARY's Open Doors
bullet, `seed_link`'s ratchet is still the standing lead named above, and the ledger fold deadlock
is unchanged and still Keaton's word to break.

**This lap (`20260925.221041`) held a fresh cold run to `tree_moved=no`, `run_verdict=guard_red`,
378 guards: 341 green, 34 red, 3 gated -- unchanged from the prior lap's tally.** A stale detached
pass held the lock at launch (`launch_head` three commits behind HEAD); confirmed it as this tree's
own via `tools/f/fleet_call.sh` and TERMed, waited for the lock, relaunched clean at settled HEAD
`7e6c49d798`. Picked `grad_seal` off the findings: its cion-module sub-check flagged
`tools/gen/chapter/fascia_metric_v0.rish`'s own doc-comment naming "Lap 2" in prose for a historical
Amphora failure -- the bare-ordinal pattern the CION labeling law retired. Reworded to name the
capability, "the pour-carry-cold-scrub lap (amphora_lap2)," matching the guard's own kept-handle
convention; the same phrase recurred in `crypto/sha3_digest.rye` and
`tools/s/sha3_file_witness.rish`, same fix. Re-running grad_seal surfaced its own second half still
red: `vols_classify_scan.sh`'s whole-tree census caught two more classes past the guarded set --
`tools/rye/wrap_ring.rye` and `tools/w/wrap_ring_witness.rish` carry `lap` as a genuine ring-buffer
generation counter (a struct field, a method), not a versioned capability name, and four comment
lines spelled "lap 0"/"lap 1" with a space where the surrounding prose already used the hyphenated
"lap-0" form; hyphenating them exempts them by the guard's own structured-code lookaround with no
behavior change. `tools/f/fleet_rearm_witness.rish` planted arbitrary transcript-tail strings "lap 3
closed clean" / "lap 2 closed clean" with no format requirement behind them; reworded both and
their one matching assert to "round closed clean". All five touched witnesses and the full
`grad_seal_witness.rish` re-run GREEN on metal; `tame_style_check` and `ascii_comment_witness`
clean. No REDS row booked -- the ledger read 268 bytes of headroom against its 65,536-byte bound,
`pin_deadlocked=1`, zero foldable rows, so a three-field entry would not fit; recorded in the commit
body and session log instead. The Git nib amend collided with a peer's push on the same line during
the round-open rebase; took upstream's newer pin, then re-derived after the rebase settled. Landed
at `cb9071fa8`, both remotes. Next lap: a fresh round-open and cold run; the remaining 33 reds still
overlap the standing backlog on the shelf and in ITINERARY's Open Doors bullet, and the ledger fold
deadlock is unchanged and still Keaton's word to break.

**This lap (`20260926.034110`) held a live, non-stale cold run (waited for it per the FLEET
clause rather than TERMing) to `tree_moved=no`, `run_verdict=guard_red`, 378 guards: 344 green, 31
red, 3 gated.** Read `commit_parent_claim` first: its two post-anchor false hits trace to a prior
lap's own commit body describing "HEAD's parent" as a historical fact rather than claiming this
commit's parentage -- a classifier ambiguity past this lap's depth-2 bound, set aside rather than
patched. Picked `opening_lines` instead: `qualified_print=6` against ceiling 5 and
`missing_print_bind=119` against 118. `brushstroke/skate_grid_test.rye` called
`std.debug.print(` unbound at its one call site; bound `const print = std.debug.print` and
converted the call, clearing both ratchets at once; witness GREEN, file re-run unchanged (559 lit
pixels). No REDS row booked -- 268 bytes of ledger headroom, `pin_deadlocked=1`, zero foldable
rows; recorded in the commit body and session log. Next lap: a fresh round-open and cold run;
`commit_parent_claim`'s classifier ambiguity and `seed_link`'s ratchet remain the standing leads,
and the ledger fold deadlock is unchanged and still Keaton's word to break.

**This lap (`20260926.044306`) held a live, non-stale cold run (waited for it per the FLEET
clause rather than TERMing) to `tree_moved=no`, `run_verdict=guard_red`, 378 guards: 345 green, 30
red, 3 gated.** Picked `root_finder` off the findings: `finders_bare_new=5`, five root-finder sites
in files absent from the guard's own baseline roster. `tools/fixtures/c/composite_key_scan.sh` and
four `torus_offset_*_{control,scan}.sh` files each walked up testing for `rishi/bin`, a
build-output sentinel that exists only after a build, so all five read `bare_unrunnable` in a
fresh clone. The guard's own `--doors` reading already prices the repair -- `SWEEP_TO=rishi/src`,
`replacement_tracked=yes`, `replacement_below_root=0` -- so the fix was the scan's own named
proposal rather than a new judgment call. Swapped both the `-d` test and the diagnostic message's
sentinel name in all five files, mode-preserving (`sed ... > tmp && cat tmp > file`, 755 held
throughout); ran each touched scan and control directly to confirm the sentinel still resolves the
root before trusting the guard. `root_finder_scan.sh` now reads `finders_bare_new=0`,
`verdict=ok`; `root_finder_witness.rish` GREEN on metal, 76 legs, six mutations biting. No REDS row
booked -- 268 bytes of ledger headroom, `pin_deadlocked=1`, zero foldable rows; recorded in the
commit body and session log. Pushed the work commit to `xy` before amending the Git nib, which
made the amend a non-fast-forward rewrite of an already-shared commit; repaired by soft-resetting
to the pushed commit and landing the nib as a follow-up commit instead, per rule 5's own shape --
amend before the push next time, or take the follow-up door once you have not. Next lap: a fresh
round-open and cold run; the remaining 30 reds still overlap the standing backlog on the shelf and
in ITINERARY's Open Doors bullet, `seed_link`'s 908-site ratchet and `commit_parent_claim`'s
classifier ambiguity remain the standing leads, and the ledger fold deadlock is unchanged and
still Keaton's word to break.
