# RW-3 run-record witness and Amber brief

**Editor:** Cursor · **Model:** Composer
**Stamp:** 20260702.183020

## Thinking trace

Kaeden asked to save RTAC and continue the mechanical lane. Repo was clean at `e5dff5c`; three doors still gate Claude. Chose RW-3 from the audit memo — self-contained, no Kaeden ruling required, closes the uneven run-record coverage gap.

Wrote `tools/run_record_witness.rish`: success path pins `.ok`, `.code`, `.out`, `.err` empty; failure path pins non-zero code and stderr capture. Wired into `tools/parity.rish` after RS-3. Parity **141** GREEN.

Prepared Claude sitting brief at `work-in-progress/20260702-190000_amber-first-ring-claude-brief.md` so the Amber session opens with concrete deliverables. Updated Edit 5 apply bundle and TASKS ladder: Edit 5 → **142** after RW-3; Amber witness → **143** after implementation counsel.

Refreshed RTAC at `20260702.190000`, ROADMAP gate count, testing audit RW-3 line.

## Observations

Mechanical lane is again idle until Kaeden walks doors 1–3. RW-4 (SLC failure paths) and RW-1 (mirrored pair) remain gated on warmer seams or post-SLC-2b.

## Files

- `tools/run_record_witness.rish` — RW-3 witness (new)
- `tools/parity.rish` — wire RW-3 block
- `work-in-progress/20260702-190000_amber-first-ring-claude-brief.md` — Claude prep (new)
- `work-in-progress/ready-to-ask-claude.md` — RTAC refresh
- `work-in-progress/20260702-edit5-ready-to-apply.md` — parity 142 note
- `work-in-progress/TASKS.md` — RW-3 checked; Edit 5 parity
- `work-in-progress/ROADMAP.md` — 141 witness count
- `work-in-progress/20260702-180812_testing-audit-first-pass.md` — RW-3 landed note
