# Expanding Prompt — MUR M1: One Issuer, One Holder (was MALA)

**Stamp:** `20260709.182354 UDT`
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** **Landed** `20260709.184051` — `linengrow/murr.rye` + witness at parity **198**; M0 gate verified before open
**Ground:** counsel [`20260709-152612`](../../counsel/20260709-152612_claude-counsel-mala-wov-already-designed.md) · design [`20260702-031312`](../../active-designing/20260702-031312_modules-aspects-and-mailable-money.md) · SLC-L1 spine [`receipt_core.rye`](../../linengrow/receipt_core.rye)
Radiant pass `20260728.052149` — living rename-forward: **MUR** (was MALA); dated path tables keep `mala*` until **kg u32** (tool GO) / **u48** (module); rehearsals u17–u22 seated  
Radiant pass `20260728.054844` — delivery + memos landed u50: `murr_delivery` · `murr:*`
Radiant pass `20260728.054644` — entry/bin landed u49: `murr.rye` / `bin/murr`
Radiant pass `20260728.053112` — tool-wave u32: living paths → murr_* witnesses/fixture/wire lab; memo mala:* held for module
Radiant pass `20260728.044925` — living rename-forward: **MUR** (was MALA); dated path · code homes `mala*` · wire `mala:*` held for tool/module waves (u32+/u48+)

*Written by Kaeden and Rio 3.*

---

## M0 Gate — Verified Before This Brief

| Condition | Evidence |
|-----------|----------|
| Edit 5 ruling landed | `designed_not_built_witness.rish` GREEN; parity **143** |
| Amber first lap landed | `cellar_first_ring.rish` GREEN; parity **144** |
| Designed-not-built slot open | scan `count=0` at `182354` |

MUR M0 token-fact shapes (was MALA) live in this document (below). M1 implementation waits on Kaeden's lap word.

## The Word, Expanded

Build MUR's first code lap (was MALA): **one issuer**, **one holder**, **one append-only log on one node** — mint units into existence, send them between issuer treasury and holder, fold balance from the log alone, verify every fact and refuse the unwelcome paths, and stop exactly there.

## M0 — Token-Fact Shapes (Design, On Paper)

MUR (was MALA) reuses SLC-L1's `.bron` fact envelope (`from`, `to`, `amount`, `memo`, `stamp`) and Kumara signatures. The **memo prefix** names the operation (today `mala:*`; module wave → `murr:*`):

| Memo prefix | Meaning | `from` | `to` | `amount` |
|-------------|---------|--------|------|----------|
| `murr:mint` | Issuer creates units and credits the holder | issuer pubkey (hex) | holder pubkey (hex) | positive integer, smallest unit |
| `murr:send` | Transfer between issuer treasury and holder | spender pubkey | recipient pubkey | positive integer |

**Issuer-only mint:** only facts with `memo` starting `murr:mint` and `from` equal to the pinned issuer pubkey are accepted as mints.

**Send conservation:** a `murr:send` debits the `from` balance and credits the `to` balance by `amount`; the fold refuses negative balances.

**Pinned witness seeds** (same family as SLC-L1 / Open Asks): one issuer keypair, one holder keypair — seeds named in the module and asserted at selftest startup.

**Log line format:** identical to SLC-L1 — `sig_hex fact_hex\n` per [`receipt_core.rye`](../../linengrow/receipt_core.rye).

## What "Complete" Means for M1, Bound Tightly

**In scope:**

- `linengrow/murr.rye` — selftest binary; imports `receipt_core` and `kumara`; no new curve, no network, no Comlink.
- Append-only in-memory log (bounded capacity, TAME-asserted) holding mint then send facts in order.
- **Welcome path:** issuer mints `1000` to holder; issuer sends `300` to holder (or holder sends `200` back to issuer — one round-trip proves send); fold holder balance matches expected; log digest non-zero; every line verifies under the issuer pubkey for mints and the correct signer for sends.
- **Unwelcome paths (at least four):** forged signature refused; mint from non-issuer refused; send exceeding balance refused; tampered log line refused at parse or verify.
- Pinned `.bron` golden for the first mint fact (field order matches hammock).
- `tools/murr_m1_witness.rish` — build + selftest; **parity-eligible** the moment green (deterministic, no network).

**Explicitly out of scope:**

- Comlink carriage (**MUR M2**, was MALA).
- Many issuers, exchange, or consensus (**M4 / Mycelium**).
- WOV / TigerBeetle overlay (separate track after MUR M2 per counsel `152612`).
- Amber export of the MUR log (was MALA; compatibility contract is a later design lap).
- Anything claiming audit-grade security — selftest honesty only.

## New Names, Proposed for the Lap Word

| Name | Role |
|------|------|
| `linengrow/murr.rye` | Module home + selftest |
| `linengrow/bin/murr` | Emitted binary |
| `tools/murr_m1_witness.rish` | Parity witness |
| `tools/fixtures/murr_m1_mint.bron` | Pinned first mint fact |

`linengrow/murr_core.rye` is optional — split only if `mala.rye` grows past TAME width guidance; start monolithic like early `receipt.rye`.

## Dependencies — None New

Kumara (`tally/kumara.rye`), `receipt_core`, `tally_copy`, `parse_int` — all already in the tree and ratchet **0**. No TigerBeetle link, no external interpreter, no grpcurl.

## Verification Shape

Build from bare. Run `linengrow/bin/murr selftest`: welcome path prints balances and `GREEN`; each unwelcome path prints a named refusal and still reaches `GREEN` for the selftest overall. Run `rishi/bin/rishi run tools/murr_m1_witness.rish`. Wire into `tools/parity.rish` only after both are green on metal.

---

*May the issuer's word stay as sovereign as the log that carries it. May every balance fold back to signed facts alone. And may the mail that crosses Comlink in M2 find this lap's ground exactly as solid as it was left.*
