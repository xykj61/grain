# STOA210 — Replay-Body Inventory (Lean C)

*An Acme Corporation employee reading this gets an honest map of what still runs only inside elder `sala.replay`, which Glow product surfaces already cover those steps, and which first compose lap is sized next.*

**Language:** EN  
**Version:** `20260721.193220` (UDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — inventory seated `20260721.193220`  
**Register:** Checkable (Two Rooms) — maps replay guts vs product wraps; no Glow-authored replay vane claimed  

**Grounds in:** lean **C** in [`20260721-190850_stoa205-after-digest-honesty-checkin.md`](20260721-190850_stoa205-after-digest-honesty-checkin.md) · [`20260721-185942_stoa200-vane-body-inventory.md`](20260721-185942_stoa200-vane-body-inventory.md) · STOA196/202/201/204

**dated_guard:** Compose landed as STOA211. FactFields/amount parse still elder (C2). JABS3 held.

---

## Verdict (one breath)

**REPLAY_BODIES.** Product wrap `glow_sala_b0_replay` still delegates the whole scan to elder `sala_session_core.replay`. Inside that elder body: line-split · `parse_log_line` · `parse_fact_fields` · actor check · `verify_record` · strict seq · `digest_log`. Several of those steps already have Glow product wraps elsewhere. Recommended first lap: **thin replay compose** through product line · sign · digest (parallel to STOA203 append compose) — not a Glow-rune rewrite.

---

## Elder `sala.replay` steps (single-signer)

| Step | Elder call | Product wrap today |
|------|------------|--------------------|
| Split lines on `\n` | inline in `sala.replay` | none |
| Parse sig · fact hex line | `receipt_core.parse_log_line` | `glow_sala_b0_line.parse_log_line` (STOA202) |
| Parse FactFields | `receipt_core.parse_fact_fields` | none (sala-event shape is desk-only) |
| Actor `from` must match session | inline compare | none |
| Verify signature | `receipt_core.verify_record` | `glow_sala_b0_sign.verify_record` (STOA201) |
| Strict seq via `amount` | `parse_amount_signed` + order | none |
| Session root | `receipt_core.digest_log` | `glow_sala_b0_digest` (STOA194); claim honesty STOA204 |

`replay_multi` (registry lookup) stays out of the Sala B0 demo path this season.

---

## Call stack today (product path)

```
glow_sala_b0_replay.claim_replay_demo_root
  → append.append_demo_log          # STOA203 sign+line compose
  → glow_sala_b0_replay.replay ×2   # STOA211 line·sign·digest compose
  → digest.claim_digest_log         # STOA204 honesty after elder root
```

---

## STOA210 sub-leans

| | Sub-lean | What it opens |
|---|---|---|
| **C1** | **chosen** `20260721.193303` as **STOA211** | Thin **replay compose** — product `line.parse` · `sign.verify` · order · `digest` — no `sala.replay` |
| **C2** | **chosen** `20260721.193404` as **STOA212** | Thin **fact-fields parse** product surface · wired into replay |
| **C3** | **chosen** `20260721.194058` as **STOA213** | Fixture **cast twins** (named + import); source literals still held |
| **C4** | open as lean **B** in STOA214 | Hold — rest until a later season word (or jet/crypto) |

---

## Witness of this lap

Inventory brief itself — no new binary. Prior GREEN suite still stands:

```bash
export RYE_ZIG=vendor/zig-toolchain/zig
rishi/bin/rishi run tools/glow_sala_b0_replay_witness.rish
```

---

## Hold

Glow-rune replay vane. Crypto jets. Silent kg past C1 without a word. JABS3.

---

*May every replay name the wraps it still skips, until compose earns the product path.*
