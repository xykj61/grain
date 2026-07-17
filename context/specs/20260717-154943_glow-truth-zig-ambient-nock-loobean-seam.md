# Glow Truth — Zig Ambient, Nock Loobean Only at the Seam

**Language:** EN
**Version:** `20260717.154943`
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Voice:** Quin
**Status:** Living — seated ruling for Glow ambient truth vs Hoon/Nock loobeans
**Co-author:** Keaton Dunsford (`xykj61`)
**Witness:** [`../../tools/glow_truth_semantics_witness.rish`](../../tools/glow_truth_semantics_witness.rish) · module [`../../glow/truth_semantics.rye`](../../glow/truth_semantics.rye)

---

## The Ruling

**Glow's ambient truth is Zig / Rye's.** Ordinary conditionals, `bool`, and process exits follow Zig and POSIX:

| Meaning | Glow / Rye / Zig |
|---|---|
| Yes / true | `true` (or a non-zero integer in a numeric test) |
| No / false | `false` (or zero in a numeric test) |
| Process success | exit **0** |
| Process failure | exit **non-zero** (generators use **1**) |

**Glow does not inherit Hoon/Nock loobeans as ambient meaning.** In Nock and Hoon, the loobean convention is the opposite numeric polarity: **0 = yes**, **1 = no**. That encoding stays real where Nock is real — inside [`../../nock/`](../../nock/) and at any future Glow↔Nock noun boundary — and nowhere else by default.

## Why This Shape

- **Primary path is Glow → Rye → Zig → RISC-V.** Ambient truth that fights Zig's `bool` and POSIX exit codes would invert every witness, every shell check, and every reader's expectation for no gain on the primary path.
- **Nock is the second backend** (interop and verification), already named that way in [`../../nock/README.md`](../../nock/README.md). Loobeans belong to that world's noun law; they earn an **explicit conversion** when a value crosses the seam, never a silent reinterpretation of every `0` and `1` in Glow source.
- **Payload decimals are not truth.** Desk generators may use `1` and `0` as ordinary arm *values* (then vs else payloads). Those digits are not loobean yes/no. Welcome/unwelcome of a generator is still process exit 0 / 1.

## The Seam (Named, Not Ambient)

When Glow must speak a Nock/Hoon loobean:

1. Call the conversion in [`../../glow/truth_semantics.rye`](../../glow/truth_semantics.rye) — `loob_to_bool` / `bool_to_loob` — at the boundary.
2. Never treat a raw `u64` `0` as Glow ambient "yes" without that conversion.
3. Never invert process exit codes to match loobeans.

A future `@f` / loob aura, if seated, is a **named mold for the seam**, not a redefinition of Glow `bool`.

## What Already Agrees

- Glow generator lowers emit Zig `bool` for `ready` and POSIX exits (`0` welcome / `1` unwelcome).
- Nock opcode 6 keeps Nock's own "0 is yes" inside `nock/` — correct for Nock, not for Glow ambient.

## Related

- Counsel that named the gap: `session-logs/20260717-154803_glow-loobean-vs-zig-bool-counsel.bron`
- Glow supplement scoping (auras; this ruling accretes beside it): [`../../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md`](../../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md)
- Glow tooling home: [`../../glow/README.md`](../../glow/README.md)

---

*May every yes in Glow mean what Zig means, and may Nock's own yes stay named at the door where worlds meet.*
