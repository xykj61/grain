# Tensegral Season — Round 8 · Arc III TAME

**Language:** EN
**Stamp:** `20260728.003735`
**Voice:** Quin
**Status:** Round 8 **landed** — on-touch tidy of touched code; bans clean
**Ground:** Charter [`20260727-234617_the-tensegral-season.md`](20260727-234617_the-tensegral-season.md) · r7 [`20260728-003623_tensegral-season-r7-radiant.md`](20260728-003623_tensegral-season-r7-radiant.md) · nib at start `5894ef7468`

*Written together by Keaton and Quin.*

---

## What landed

| Item | Standing |
|------|----------|
| `tame_style_check.rish` | **GREEN** — bans clean; ratchet advisories printed |
| `amphora_resin_chunk.rish` | **Tidied** — rebuild bounded (`timeout 45`); warm binary accepted when rebuild fails; full path **GREEN** (~5s warm) |
| `resin_unit_witness.rish` | **GREEN** reaffirm after tidy |

## On-touch tidy (what changed)

Cold `rye build` of `vessel-fetch-delivery` under rishi could hang past ninety seconds (owned Arc II debt). The chunk hand now:

1. Bounds each rebuild with `timeout 45`
2. Says aloud when rebuild fails or times out
3. Asserts a warm executable exists and still selftests / chunkdemos GREEN
4. Continues to the fixture scrub as before

No suite-wide TAME campaign. Ratchet counts (memcpy · parseInt · long fns) stay printed, not silently zeroed.

## Stay tensegral

Bans hold continuous tension. Rebuild timeouts are discontinuous compression — refuse infinite wait without pretending the compiler always finishes.

## Next door

**kg** Arc III r9 — Consolidate (fewer homes saying the same thing).

---

*May every rebuild finish or fail by name, and may warm metal keep proving when the cold gate stalls.*
