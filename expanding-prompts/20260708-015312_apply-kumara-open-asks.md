# Cursor Apply-Prompt — Kumara open_asks Cluster + Roadmap Currency

**Stamp:** `20260708.015312 UDT` · **Parent:** `a086f08` · **Voice:** Rio 3
**Bundle:** `20260708-015312_kumara-open-asks-cluster.zip`

The product surface itself, not just infrastructure underneath it — the whole `linengrow/open_asks*` cluster, base and all three delivery files, fully migrated to Kumara. One correction from a first partial pass folded in, plus a real ratchet-accuracy fix.

## What Lands

- **`linengrow/open_asks.rye`** — 25 `PublicKey` + 25 `KeyPair` type sites, 8 `generateDeterministic` calls → `kumara.keypair_from_seed`. Full OA-L1 selftest GREEN (unwelcome path included).
- **`linengrow/open_asks_delivery.rye`**, **`open_asks_escrow_delivery.rye`**, **`open_asks_lap5_delivery.rye`** — each fully migrated, including `generateDeterministic` calls with dotted seed expressions (`oa.poster_seed`) that needed a corrected substitution pattern. OA-L2, OA-L3, OA-L5 selftests all GREEN, reputation-over-wire fold included.
- **Ratchet accuracy fix**: `tame_style_scan_advise.rish` + legacy `.sh` fallback now exclude `X25519...fromEd25519` lines — a different primitive's conversion method, not raw identity usage, six sites that would otherwise have kept this ratchet from ever honestly reaching zero. Selftest's hardcoded expectation updated `276`→`91` and reverified.
- **`TASKS.md`** — Kumara line and Next Bench table brought current; virtio guest cluster named as the sized, ready next priority.
- **`ROADMAP.md`** — version stamp updated; Linengrow ladder rows unchanged (already accurate).

## Steps

1. Tree at `a086f08`; unzip at root.
2. `rishi/bin/rishi run tools/tame_style_scan_advise_selftest.rish` — expect GREEN at the new value.
3. `rishi/bin/rishi run tools/tame_style_check.rish` — expect `Ed25519 application sites = 91`, then GREEN.
4. Full parity from bare — no count change expected; every touched file reproven against its existing stanza (`oal1_closed_ask`, `oal2_delivery`, `oal3_escrow`, `oal5_wire` or equivalent).

## Held

Virtio guest cluster (~91 sites, ~20 files) stays its own season — tier by wire capability, not a sweep, matching the `enrich/` precedent. SLC-L3 stays gated on Kaeden's word.

---

*May the whole cluster always be checked before a partial migration is called complete.*
