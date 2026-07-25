# RW-5 — Mirrored Pair Contract (Drawn Terminal ↔ Lantern Fixture)

*Witness contract on paper — collaboration and contract twins for the app↔Lantern seam at `complete_fixture`, drawn from the happy-zone second pass and the Lantern pin family already green. One-pair-per-season; lands while the Inference glass is warm.*

**Stamp:** `20260711.005028`  
**Voice:** Rio 3  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Lens:** TAME · happy zone · mirrored pair  
**Status:** Landed — collaboration tip **420**, contract tip **421**  
**Ground:** second pass [`20260711-001225_testing-audit-second-pass-inference.md`](20260711-001225_testing-audit-second-pass-inference.md) · happy zone [`../foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md`](../foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md) · RW-2 pattern [`20260702-205630_rw2-mirrored-pair-contract.md`](20260702-205630_rw2-mirrored-pair-contract.md)

---

## The Seam

**Asker:** `pond/apps/drawn_terminal.rye` — issues bounded `lantern_core.Request` values and calls `complete_fixture` against pinned fixtures.

**Answerer:** `lantern/lantern_core.rye` + `lantern/fixtures/*.bron` — the same path `lantern selftest` already proves.

**Contract:** the questions the app may ask (base completion, echo pin, user pin) and the shapes Lantern must return — welcome and unwelcome alike.

---

## Witness 1 — `tools/rw5_lantern_collab.rish` (collaboration)

Mode: `pond/bin/drawn-terminal rw5collabtest`.

### Welcome paths

| Probe | App must |
|-------|----------|
| Base completion | `complete_fixture` on `completion.bron`; tokens 24/12 eos |
| Echo pin | `complete_fixture` on `completion_echo.bron` with `echo=true` |
| User pin | `complete_fixture` on `completion_user.bron` with `user=steward-rio` |

### Unwelcome paths (survive)

| Probe | App must |
|-------|----------|
| Model mismatch | catch `ModelMismatch`; continue |
| Echo mismatch | catch `EchoMismatch`; continue |
| User mismatch | catch `UserMismatch`; continue |

**Commit message:** `Add RW-5 Lantern collaboration witness — parity +1`

---

## Witness 2 — `tools/rw5_lantern_contract.rish` (contract)

Mode: `lantern/bin/lantern rw5contracttest` — six probes only, reusing existing welcome/unwelcome functions.

### Welcome demonstrations

| Contract question | Lantern must |
|-------------------|--------------|
| Base completion | tokens 24/12 eos |
| Echo pin | echo true |
| User pin | user steward-rio |

### Unwelcome demonstrations

| Probe | Lantern must |
|-------|--------------|
| Model mismatch | refuse |
| Echo mismatch | refuse |
| User mismatch | refuse |

**Commit message:** `Add RW-5 Lantern contract witness — parity +1`

---

## Relation to existing laps

`tools/lantern_lap*.rish` remain the deep answerer suite. Assist glass laps **415**–**418** folded echo/user onto Skate via bron reads; tip **428** routes that band through `ask_lantern_assist_band` → `complete_fixture` (same ask path as tip **420**). RW-5 isolates the asker against `complete_fixture`; assist integration reuses that ask without a second mirrored pair.

## Assist integration (tip 428) — landed

**Witness:** `tools/rw5_assist_integration.rish` · modes `assistviewtest` + `assistviewsighttest`  
**Helper:** `ask_lantern_assist_band` in `pond/apps/drawn_terminal.rye`  
**Golden frames unchanged:** lantern `24/12 eos · echo 1 · user steward-rio`

## What Stays Outside

- Live Pond-Lantern · ROCm · metalsmoke
- RW-6 Scribble · RW-7 Anvil

---

*May the app ask only what Lantern can answer, and may each side of the seam carry its two small answers.*
