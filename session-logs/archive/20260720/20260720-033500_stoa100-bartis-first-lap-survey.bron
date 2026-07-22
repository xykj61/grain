format session-log-v1
stamp 20260720.033500
editor Cursor
model Cursor Sonnet 4.6
voice Rio 3
host linux 6.12.94+ cloud agent
title STOA100 bartis first-lap survey
prompt Explore what exists for implementing a thin Glow bartis (|=) first lap: tokens match_rune2, glow_run dispatch, closed demo gates, sample-u32 argv path, rune_alphabet_worker break analysis, existing |= stubs, STOA99 brief checklist. Recommend thinnest checkable STOA100 claim.
think Read tokens.rye to map match_rune2 pairs array (25 entries, explicit horizon refuse). Read glow_run.rye to trace multi-line dispatch ladder. Read lower_core.rye and lower_call.rye to understand baked-sample demo pattern. Read sample-u32.glow, cast-u32.glow, core-double.glow for fixture vs generator shapes. Read glow_rune_alphabet_worker.sh to identify every assertion that breaks on count change. Grep for any existing bartis stubs. Read STOA99 brief and glow_bartis_horizon_witness.rish for the checklist and bound pins.
think tokens.rye match_rune2: array of 25 two-byte string literals (line 95-98). Tokenizer calls starts_with for longest-match before bare = / %. Adding |= means appending "|=" to pairs. The tokenizer itself requires no other change — Kind.rune2 covers all digraphs.
think glow_run.rye dispatch: line_count >= 2 runs a priority ladder (named-cast → cross-desk → mold-only → |% core → compose variants). Single-line uses bare 2-char head checks. A |= multi-line desk would slot in after the |% check at line 160, matching lines[0][0]=='|' and lines[0][1]=='='.
think Closed demo gates pattern: lower_call.rye bakes call_demo_sample=5 as a comptime constant; the emitted Rye text contains the literal value. lower_core.rye uses core_demo_sample=5 the same way. A bartis fixture desk would follow the same convention — bake a u32 sample in lower_bartis.rye, emit it literally into the generated Rye.
think sample-u32.glow (^-  @u32, G3 generator) reads sample from argv via lower_cast.lower_line_argv_sample. It is not bartis. The brief explicitly says it is the precursor; bartis does not rewrite it. A bartis fixture desk sits beside it, not replacing it.
think glow_rune_alphabet_worker.sh breaks at three points on |= addition: (1) line 17 asserts COUNT="25"; (2) lines 22-25 grep for |= and fail if present; (3) line 70-73 asserts n="25" head-rows; (4) line 75-78 asserts **25** in the table. Each requires a coordinated update in the same lap.
think Existing |= stubs: grep across glow/ found only comments (lower_cast.rye line 116 "Not bartis", sample-u32.glow comment "Not bartis — |= horizon"). No rune_bartis.rye, no lower_bartis.rye, no gate-*.glow bartis desk. Zero implementation.
think STOA99 five-step checklist (from active-designing/20260720-033340_stoa99-bartis-horizon-wording.md): (1) Add |= to match_rune2 + G1 table row + TAME family spoken example; (2) thin parse: sample face + optional mold + body; (3) lower to Rye with explicit parameter; (4) fixture desk with baked sample; (5) leave wet/gold held.
obs Thinnest checkable STOA100: a fixture desk gate-double.glow (|= sample=@u32 / ++ double / --) that lowers to emitted Rye calling double(5)==10. The token step (adding |= to match_rune2) is prerequisite but tiny. Parse is a new rune_bartis.rye GateSpec. Lower is a new lower_bartis.rye that emits a baked u32 sample program. glow_run needs one new dispatch branch. Alphabet worker + table need coordinated 25→26 update. No argv path needed for this fixture.
obs The dispatch branch in glow_run.rye for |= should slot after the |% branch (line 160) and before the compose variants, since a |= desk has a distinct first line head.
obs All witnesses that currently assert the 25-count and the bartis refuse must flip in the same commit: glow_rune_alphabet_worker.sh (three assertion sites), the G1 closed table (**25** → **26**), TAME family index pin, glow_bartis_horizon_witness.rish (either retired or rewritten as a positive bartis GREEN witness), and the STOA99 brief itself.
file glow/tokens.rye match_rune2 pairs array — add "|=" to enable tokenization
file glow/glow_run.rye line 160 — add |= multi-line dispatch branch
file glow/rune_bartis.rye (new) — GateSpec: sample face + mold + one arm name
file glow/lower_bartis.rye (new) — emit baked u32 sample Rye program
file glow/gen/gate-double.glow (new) — fixture desk (baked sample, no argv)
file tools/glow_rune_alphabet_worker.sh — 25→26, remove bartis-refuse checks, add heredoc row
file active-designing/20260719-220814_glow-rune-pronunciation-closed-table.md — add |= bartis row, update **25** → **26**
file context/TAME_GUIDANCE.md — add bartis to family index spoken example
file tools/glow_bartis_horizon_witness.rish — retire horizon pin or replace with positive GREEN witness
file glow/README.md — update status, add gate-double to fixture list
recommend check-in next step crosses rune seam (rune_bartis.rye + lower_bartis.rye), changes alphabet count, and updates TAME pin — Kaeden ruling before implementation opens
