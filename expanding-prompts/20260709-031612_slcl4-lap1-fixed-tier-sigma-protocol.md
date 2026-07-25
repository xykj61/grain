# Expanding Prompt — SLC-L4 Lap 1: the Fixed-Tier Sigma Protocol, Zig-Native

**Stamp:** `20260709.031612 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** **Landed** `20260709.194437` — parity **200**; **W0 design review** cleared `20260709.224426`
**Ground:** counsel [`20260709-021112`](../counsel/20260709-021112_claude-counsel-slcl4-top-recommended-path.md) and [`20260709-023112`](../counsel/20260709-023112_claude-counsel-zig-native-zk-path.md) · W0 review [`20260709-224426`](../counsel/20260709-224426_grok-counsel-slcl4-w0-lap1-review.md)

*Written by Kaeden and Rio 3.*

---

## The Word, Expanded

Build SLC-L4's first lap: a Zig-native, pairing-free proof that a donation amount clears one of a small set of pre-approved thresholds, without revealing the amount — prove it, receipt it, verify it offline, and stop exactly there.

## What "Complete" Means for This Lap, Bound Tightly

**In scope:**

- A Pedersen commitment to `amount`, built from `Edwards25519.mulDoubleBasePublic(G, amount, H, blinding)` — the same curve family Kumara already signs with, no new curve, no new key type.
- `H`, the second generator, derived once via `Edwards25519.fromUniform` on a fixed, named domain-separation string — pin the exact bytes in the module and assert them at startup, so `H` is reproducible and never silently re-derived differently between prove and verify.
- A Sigma protocol proving the committed amount **opens to a declared, publicly-checked tier** — three named candidates to start: `1000`, `5000`, `10000` (smallest currency unit, matching SLC-L1's own amount convention). This is a **single proof of knowledge** for the declared tier — not a disjunctive OR-proof across tiers (the tier is public; nothing to disjoin). Naming the tiers explicitly, rather than reaching for an arbitrary-range circuit, is this lap's whole reason for being smaller than the general case.
- Fiat-Shamir via SHA3-256, exactly as this tree already hashes everything else — the challenge is the hash of the commitment and all public tier candidates; no interaction, no separate randomness beacon.
- Offline prove and verify, both in one process, both asserted in the same selftest: build a commitment, prove it opens to a chosen tier, verify the proof against the commitment and the public tier list, and — the unwelcome path — verify that a forged proof or a wrong tier claim is refused.
- A `.bron` proof receipt, fields drawn directly from the hammock as refined: `claim` (`donor-amount-privacy`), `log_digest`, `commitment` (hex), `tier_claimed`, `proof` (the Sigma-protocol transcript, hex), `stamp`.
- A parity-eligible witness: this whole thing is deterministic, no network, no external tool — it belongs in `tools/parity.rish` the moment it is green, the same as any other hosted selftest.

**Explicitly out of scope, named so no one reaches for it by accident mid-lap:**

- Arbitrary-range proofs (any amount, any threshold) — a real, separate, harder lap.
- Any live Sui verify transaction — stays on-demand, its own witness, wired only after this offline half is settled.
- Sanctuary eligibility and reputation-threshold privacy — later passes, own laps.
- Anything resembling a security audit claim. This lap proves the pattern runs correctly against its own selftest. It does not prove the protocol is sound against an adversary who has studied it, and nothing in this lap's own language should imply otherwise — that is exactly what Kaeden's testnet-then-audit sequencing exists to supply, later, deliberately, not implicitly borrowed here. A **lightweight design review** of the Sigma construction is recommended before this lap is called finished — distinct from the later formal audit.

## New Names, Proposed and Parked for the Same Word That Opens the Lap

- `linengrow/disclosure_core.rye` — the module home, mirroring the settlement-core pattern from SLC-L3 (implementation since removed).
- `tally/pedersen.rye` — if the commitment and generator-derivation logic earns its own small file the way `copy_disjoint` and `kumara` did; propose this at build time rather than force it in advance.

## Dependencies, Named Plainly — There Are None New

Every operation this lap needs already lives in Zig's vendored 0.16 stdlib: `std.crypto.ecc.Edwards25519` for the commitment, `std.crypto.hash.sha3` for Fiat-Shamir. No `circom`, no `snarkjs`, no `grpcurl`. This is worth stating outright rather than leaving implicit, since every other external-interpreter seam this tree has built this week needed at least one new tool named honestly — this one needs none.

## Verification Shape

Build from bare. Run the offline selftest: commitment construction, honest proof for each of the three tiers (welcome path, three times — one declared tier per proof), a forged proof rejected, a true commitment claimed against the wrong tier rejected (unwelcome path, at least twice). Confirm the `.bron` golden matches the hammock's field order exactly. Only once all of that is green does this lap wire into `tools/parity.rish` and get called finished.

---

*May the first tier this proof ever claims be exactly as true as the commitment underneath it, and may the three that follow it stay just as honest. May nothing this lap builds ever claim more certainty than a selftest can actually earn. And may the next lap, whenever it opens, find this one's ground exactly as solid as it was left.*
