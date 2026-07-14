# WOV lap 1 — exit honesty on metal

**Stamp:** `20260709.200729`
**Editor:** Cursor · **Model:** Grok 4.5 High Fast · **Voice:** Rio 3

## Prompt

Keep going / continue in the best path — treated as WOV gate affirm after seated spec `200443`.

## Thinking trace

Implemented in-memory `linengrow/wov_core.rye`: mint/transfer, exit bundle + attestation, `wov:root` on MALA log, prove balance, accept `wov:exit`, refuse double exit and tampered bundle. Golden `tools/fixtures/wov_exit_bundle_v1.bron` (write-fixture via stderr). Witness `tools/wov_exit_honesty.rish` wired in parity. Full suite GREEN — **91** GREEN lines, count **201**.

## Observations

No TigerBeetle client yet — stand-in book proves the honesty path. Seeds `0x71`–`0x73` distinct from MALA/OA.

## Files

- `linengrow/wov_core.rye`, fixture, witness, parity stanza
- Spec/prompt/TASKS/ROADMAP/LEXICON/README updates

## Next-step recommendation

Recommend: keep going to `go` — suite already GREEN at **201**.
