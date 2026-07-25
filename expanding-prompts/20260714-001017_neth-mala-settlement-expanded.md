# Expanded Prompt — Neth, Mala, and the Settlement Layer

**Language:** EN
**Version:** `20260714.001017` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Living — the expanded, research-grounded form of the Neth seed, addressed to a generic Acme Corporation employee. Design and social-experiment framing only; not financial, investment, or legal advice.

---

## The Seed

Add an N-vane after Maze called **Neth** — the Glow OS version of Sui, evolved from what was called MALA, interoperating with Ethereum. Adapt MALA to Glow/Maze/TAME guidance. Make MALA a social experiment: a fractal universe of ETH/SOL/SUI/Azimuth, with an L2 that is a WOV Glow OS implementation fusing a Glow reimplementation of TigerBeetle as a pinned sidechain to the Mala (Mycelium/Weave/Mantra/Ford) L1, bootstrapped from Neth, woven with the Kumara+Ames fusion and the existing Comlink designs, with new Neth cores, libs, marks, and surs.

## The Seed, Expanded and Made Robust (after research)

Research grounded three things that turn this from a buzzword pile into a coherent architecture:

1. **TigerBeetle is a Replicated State Machine** (VSR + hash-chained append-only log + deterministic execution) — the correct substrate for an L2 sequencer. "Glow reimplementation of TigerBeetle as a pinned sidechain" is real.
2. **The tree already has the pieces:** MALA (issuer mint, conservation, balance-as-fold) is L1 money; WOV (exit-honesty settlement) already had a **TigerBeetle pin seam, retired but explicitly revivable**. Neth is that revival, grown up.
3. **Azimuth is Urbit's own Ethereum PKI** — the natural, no-new-trust external anchor, versus inventing four bridges at once.

So the expanded, robust statement:

> Neth is a Glow, TAME-bounded reimplementation of TigerBeetle's replicated-state-machine shape that sequences MALA transfers into a hash-chained log, folds them to balances, and pins its state-root — first internally to the Mala/Weave L1, later (optionally) to Azimuth/Ethereum. The Kumara+Ames/Comlink seam signs and carries every fact. The "fractal universe of four chains" is the social-experiment vision around this core, kept in its own register and not built toward all at once.

## What Running It Produced (this turn)

- The full architecture, load-bearing core separated from visionary register, naming collision flagged, minimal-first-lap recommended: [`../external-research/20260714-001017_neth-mala-settlement-l1-l2-design.md`](../external-research/20260714-001017_neth-mala-settlement-l1-l2-design.md).
- Neth added to the names checklist with the Nethermind collision and the Neith/other-name options: [`../context/specs/20260713-235600_names-awaiting-confirmation.md`](../context/specs/20260713-235600_names-awaiting-confirmation.md).

## The Honest Shape of My Answer

- **The core is strong and continuous** with WOV/MALA/TigerBeetle work already here — I affirm it.
- **The name Neth collides** with Nethermind exactly where it hurts (Ethereum interop) — I flag it and lean toward Neith or another N-name.
- **Four bridges at once is too much** — I recommend one anchor (Azimuth/Ethereum) and a single deterministic-root witness as the first lap, per Gall's Law and the project's own sobriety anchor.
- **It stays design + social experiment** — explicitly not a token, a security, or a deployment, until Keaton decides otherwise with real legal grounding.

## What Waits on Keaton's Word

The Neth name; whether to build the minimal WOV-TB-revival root witness first; the single external anchor (recommended Azimuth); and confirmation of the design/social-experiment framing.

---

*May the settlement layer be small enough to prove before it is grand enough to trust, and may every root it pins be one anyone can recompute from the log alone.*
