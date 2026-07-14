# Grok Counsel — MALA M1 Names, TASKS Fit, and What Stays Parked

**Stamp:** `20260709.184051`
**Editor:** Cursor · **Model:** Grok 4.5 High Fast · **Voice:** Rio 3
**Register:** Decision counsel — name clarity before M1 code; TASKS/ROADMAP fit check
**Ground:** design [`20260702-031312`](../active-designing/20260702-031312_modules-aspects-and-mailable-money.md) · counsel [`152612`](20260709-152612_claude-counsel-mala-wov-already-designed.md) · lap-open [`182354`](../expanding-prompts/20260709-182354_mala-m1-one-issuer-one-holder.md) · SLC-L4 prompt [`031612`](../expanding-prompts/20260709-031612_slcl4-lap1-fixed-tier-sigma-protocol.md) · foundations [`20260629-014512`](../foundations/20260629-014512_money-that-stays-close-to-home.md) · LEXICON MALA/WOV/Mycelium

*Written by Kaeden and Rio 3 (Grok), after Kaeden opened the lap and asked for clarity on proposed names.*

---

## Verdict in One Breath

**TASKS makes sense.** ROADMAP and TASKS already put **MALA M1** at the front of the Linengrow climb, with **SLC-L4** waiting its own word. Opening M1 now honors counsel `152612` and the July 2 design. No TASKS reorder is required before code — only status lines after the witness greens.

---

## Names That Matter for *This* Round (MALA M1)

These are the only new names this lap should introduce. They are already proposed in `182354` and match how SLC-L1 landed (`receipt.rye` + witness + golden).

| Name | Role this round | Affirm? |
|------|-----------------|---------|
| `linengrow/mala.rye` | Module home + selftest binary source | **Yes — introduce** |
| `linengrow/bin/mala` | Emitted binary | **Yes — introduce** |
| `tools/mala_m1_witness.rish` | Build + selftest witness | **Yes — introduce** |
| `tools/fixtures/mala_m1_mint.bron` | Pinned first mint fact | **Yes — introduce** |
| `mala:mint` / `mala:send` | Memo prefixes on the existing SLC-L1 `.bron` envelope | **Yes — bind as M0 shapes** (no new `kind` field this lap) |

**Optional, not this round unless width forces it:**

| Name | Role | Affirm? |
|------|------|---------|
| `linengrow/mala_core.rye` | Split core from selftest | **Park** — start monolithic like early `receipt.rye`; split only if TAME width asks |

**Already named in LEXICON — not new, not built this lap:**

| Name | Meaning | This round |
|------|---------|------------|
| **MALA** | Mailable money; issuer log is authority; balance is a fold | **M1 builds the first code rung** |
| **WOV** | TigerBeetle throughput overlay; 1–2 monarchs | **Out of scope** — after MALA M2 |
| **Mycelium** | Byzantine ordering among strangers | **Gated at M4** — do not open |

---

## Names From the *Other* Lap (SLC-L4) — Still Parked

These appeared in the last agent's SLC-L4 brief (`031612`) and evening close. They are **not** part of MALA M1. Opening M1 does not affirm them.

| Name | Proposed role | Relevance now |
|------|---------------|---------------|
| `linengrow/disclosure_core.rye` | SLC-L4 module home (Sigma / donor-amount privacy) | **Parked** until Kaeden's SLC-L4 lap word |
| `tally/pedersen.rye` | Optional home for Pedersen commitment + `H` derivation | **Parked** — propose again at SLC-L4 build time if the logic earns a file |

The settlement-core pattern those names mirrored is **gone from the tree** (`152612`). When SLC-L4 opens, `disclosure_core` remains a reasonable mirror name; it simply is not today's work.

---

## Memo Prefix vs Dedicated `kind` Field

Evening brief `183326` asked whether `mala:mint` / `mala:send` on the SLC-L1 envelope is enough, or whether MALA needs a dedicated `kind` before M1 code.

**Counsel for M1:** keep memo prefixes. Reasons that stay inside written policy:

1. SLC-L1 envelope + `receipt_core` already parse `from` / `to` / `amount` / `memo` / `stamp` — zero new dependencies.
2. Open Asks already discriminates operations by memo shape on the same spine; MALA follows that grain.
3. A dedicated `kind` field is a seam change to the fact envelope — that is a design width question for a later lap, not required to prove one-issuer mint/send/fold.

If a later consumer needs typed discrimination without string prefixes, that earns its own word.

---

## Mint Fold Semantics (Binding for Implementation)

The welcome path in `182354` offers two phrasings. Only one conserves cleanly when mint **creates** units into `to` without debiting `from`:

| Op | Fold |
|----|------|
| `mala:mint` | Credit `to` by `amount` (creation). Require signer = pinned issuer and `from` = issuer pubkey. |
| `mala:send` | Debit `from`, credit `to`; refuse if `from` would go negative. |

**Welcome path this lap uses:** issuer mints `1000` to holder → holder sends `200` back to issuer → holder `800`, issuer `200`. That is the parenthetical path in `182354`, chosen because it proves send after a holder-credited mint without inventing an issuer treasury balance from thin air.

---

## TASKS / ROADMAP Fit

| Item | Assessment |
|------|------------|
| Priority **2** MALA M1 | Correct front of climb once lap word lands |
| SLC-L4 still waiting | Correct — separate word; names above stay parked |
| Realidream thin-demo | Parallel optional; do not block M1 |
| WOV gate | Still after M2 — unchanged |
| Edit 5 / designed-not-built | M0 shapes live in `182354`; slot was open (`count=0`); M1 is the first lap of that design, not a second in-flight functional spec |

After M1 greens: check the TASKS boxes, bump ROADMAP status from "waits Kaeden" to landed, wire parity **198**.

---

## What This Counsel Does *Not* Open

- SLC-L4 code or `disclosure_core` / `pedersen`
- WOV / TigerBeetle link
- Comlink carriage (M2)
- Mycelium
- A new fact-envelope `kind` field

---

*May every new name earn its door on the lap that needs it. May MALA's first mint credit exactly one holder, and may the names that wait for donor-amount privacy stay quiet until that word arrives.*
