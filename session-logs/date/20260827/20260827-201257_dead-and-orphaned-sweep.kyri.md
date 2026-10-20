format session-log-v1
stamp 20260827.201257
editor Claude Code terminal
provider Anthropic
product Claude Code
role subagent survey hand
modality text
model claude-opus-5
model_status active runtime unverified
voice Kyri
title the dead-and-orphaned sweep, eight findings
prompt find dead and orphaned things -- unreferenced sources, empty rooms, retired vocabulary in living pages, dangling symlinks
think Built a whole-tree reference index rather than grepping per file -- rg extracted every filename-shaped token from every tracked file into a token-to-path map of 71,705 pairs, then a join against 5,029 source basenames left 37 referenced only by themselves.
think The reference sweep is the one standing whole-tree exception under read-scope, so no closed stack was browsed to build it.
think Verified each candidate against its own siblings rather than in isolation -- an orphan among ten referenced peers is a finding, an orphan among orphans is a convention.
think Ran the two suspect witnesses on metal instead of reading them; both refused, which turned a stale-citation guess into a proven RED.
obs The largest catch was not an orphan file at all -- a batch move to yonder on 20260726 left tools/h/hawm_log_harvest_witness.rish asserting a path that no longer exists, and its chain witness asserts on that witness, so one unrepointed reference reds two guards.
obs Four candidate classes were checked and discarded rather than reported: docs-geode's README-only rooms are declared index pages, the four README-only top-level rooms are documentation-first seats with 4-11 inbound references, Q-vane is a deliberate peer under REDS %300, and the equinox witnesses are standalone entrypoints the task excluded.
obs 267 tracked symlinks all resolve; the 26 dangling ones live in the gitignored seed projection, where the manifest withholds linengrow while its inbound links still ship.
file tools/h/hawm_log_harvest_witness.rish line 10 asserts active-designing/20260722-152523_stoa275-hawm-log-harvest-inventory.md, which stands at active-designing/yonder/
file tools/h/hawm0_boot_harvest_chain_witness.rish line 21 asserts the harvest witness is ok, so the break cascades
file tools/fixtures/mind_source_adaptation_control.sh a 17-case both-ways control that passes and that nothing runs
file linengrow/seva_r1_frame.rye 54 lines, zero external references, superseded by seva_r2_surface.rye
file active-designing/seam-season-hammock.md living Status line carrying retired tip five times
recommend check-in (Claude) -- the two RED witnesses book an allocation under reds-first; the repoint is one line, yet whether the almanac band e117-e123 was retired on purpose is an unruled question.
