# Hoon Core Polymorphism, Glow TAME, and Port Order

*Keaton asked whether Urbit Hoon's core polymorphism model fits Glow under TAME guidance, and how to proceed when reimplementing vane and userspace roles in Glow — recommended order, with Rye staying TAME-guided until Glow can host the shape. This brief answers for the iOS language season and the Framework break.*

**Language:** EN  
**Version:** `20260719.204650` (Eastern)  
**Style:** Radiant  
**Voice:** Quin  
**Status:** Design — verdicts seated; wet/gold polymorphism and Glow-authored vanes remain horizon  
**Register:** Mixed (Two Rooms) — fit/order are **design**; today's `|%` · payload · `|=`-shaped closed demo gates are **checkable** on STOA  
**Grounds in:** [`20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md`](20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md) · [`20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md`](20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md) · [`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md) · [`../external-research/20260715-172000_pool-keystone-revival-realidream-landscape.md`](../external-research/20260715-172000_pool-keystone-revival-realidream-landscape.md) · [`../context/specs/20260713-214400_urbit-parallel-naming-mapping-proposal.md`](../context/specs/20260713-214400_urbit-parallel-naming-mapping-proposal.md)

---

## Verdict in one breath

Hoon's **dry, named, typed cores** fit Glow TAME when every expansion stays bounded and explicit. Hoon's **wet / gold polymorphic cores** (sample type varies; variance games the type system) do **not** land as ambient Glow yet — they wait on a nest/type surface that can check at expansion the same way `|-` already checks its bound. Port **roles** clean-room into Rye first (already the green spine); rewrite a module in Glow only when fixture desks and lowers already cover its shapes.

---

## What Hoon's core model is (study, not copy)

| Shape | Hoon sense | Glow today |
|-------|------------|------------|
| **Glow gate** (`\|=`, bartis) | One-arm core + typed **sample** | Closed demo gates in `%` call desks; not yet a free bartis lower for arbitrary samples |
| **Trap** (`\|-`, barhep) | Recursing core | **Bounded** only — TAME hard rule |
| **Battery core** (`\|%` … `--`) | Named arms | GREEN — bare / payload / open / nest / library |
| **Door** | Core with sample that yields further cores | Horizon — needs typed sample + arm battery both checked |
| **Wet gate / gold core** | Polymorphic sample; type variance | **Hold** — no ambient Glow wet polymorphism |
| **Molds** (`+$` · `$:` · `$%`) | Named types · tags | GREEN thin molds + named-cast |

Bare Lexicon **Gate** stays the itinerary word. Language prose says **Glow gate** / **bartis**.

---

## Fit against TAME (root + Glow pins)

| TAME pressure | Dry cores / molds / asserts | Wet / gold polymorphism |
|---------------|----------------------------|-------------------------|
| Bounds at expansion | Welcome — payload sizes, arm counts, `|-` bounds already assert | Risk — unbounded type games hide size |
| Explicit types / fixed widths | Welcome — `@u32` faces, `$%` tags | Conflict — "any sample that nests" without a stated mold |
| Assert density / crash on programmer error | Welcome — `?>` / `?<` → Rye `assert` | Ambiguous — type-system "crash" is not a Rye assert site unless lowered that way |
| Closed rune vocabulary | Welcome — curated bar/wut/buc set | Temptation to invent sugar for variance |
| Docs ↔ implementation | Each new core shape costs a TAME Glow page | A page must exist before any wet lower |

**Proceed rule:** prefer **explicit molds + tagged unions + dry Glow gates + named-arm cores**. When Hoon code relies on wet polymorphism, re-express the same *role* with named molds and separate dry gates (or Rye generics with TAME `assert` on every cast site) rather than importing wetness into Glow syntax.

---

## Port order — vane and userspace into Glow

This is **role revival**, not line-copy from `old/pkg/arvo`. Clean-room: study Hoon; implement Glow/Rye vocabulary; witnesses prove claims.

### Phase L — Language (iOS / no-adb priority)

1. **STOA90+** — pronunciation table G1 · TAME alphabet pin G2 · thin argv **sample** G3 · token-driven lower G4 · tidy `lower_mold` as needed.  
2. Seat this brief's core-polymorphism verdicts (done here).  
3. Grow dry bartis / door only when a TAME Glow page names the expansion asserts.

### Phase R — Rye hosts the system (current green spine)

Keep implementing and hardening vanes/userspace **in Rye under TAME** until Glow can emit the same shapes:

| Priority | Role | Glow name / status |
|----------|------|--------------------|
| Already green | Ames · Clay · identity half · Gall host · Landscape view | Comlink · Mantra · Kumara · **Pool** · **Sala**/Realidream |
| Next product | Agents inside Pool | Stay Rye agents with capability table until Glow generators + cores host them |
| Later | Further Arvo roles | Per naming map — revive when Pool + language can admit them |

Do **not** pause green Rye vanes waiting for Glow to catch up. Glow authors the happy-zone spelling; Rye remains the TAME implementation language of the spine.

### Phase G — Glow rewrite of a module (only when ready)

A module may move from Rye-authored to Glow-authored when:

1. Every rune head it needs is GREEN with a fixture desk.  
2. Its **sample** is an explicit mold (or thin argv generator).  
3. Expansion asserts cover bounds (no wet sample).  
4. A witness lowers → builds → exit 0 (and RISC-V when that path is in the claim).  
5. The elder Rye module keeps witnesses until the Glow path earns them (accrete-never-break).

**First Glow userspace target (recommended):** one thin Pool **ledger-shaped** agent arm (or generator) that already has a Rye twin — not a whole vane dump from `old/`.

### Explicitly later

- Wet/gold polymorphism as Glow syntax.  
- Line-by-line Arvo Hoon ports.  
- Nock as primary compile path (stays second backend).  
- Device/adb / Pixel eyes — Framework host or outer terminal only; **not** Cursor iOS cloud sandbox.

---

## Recommended wording in Glow docs

> Glow carries Hoon's **dry core shapes** — bartis gates, bounded traps, named-arm batteries, explicit molds — checked at expansion under TAME. Polymorphic **wet** cores stay outside the curated set until a nest surface can assert them the same way. System roles revive clean-room: Rye implements under TAME today; Glow re-spells a module only when fixture desks already prove every head it needs.

---

## What this brief does not do

- Implement doors or wet gates.  
- Open Pool P0 again (already GREEN in Rye).  
- Change STOA90's recommended lean (still G1 pronunciation table unless Keaton redirects).

---

*May every core name its sample, every expansion earn its assert, and every port revive a role rather than a dialect.*
