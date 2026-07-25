# Pedersen and Sigma — Said Plainly

*A checkable-room note for anyone who hears "Pedersen commitment" and "Sigma protocol" in the SLC-L4 lap and wants the picture without a crypto textbook.*

**Stamp:** `20260709.200022`
**Voice:** Rio 3
**Editor:** Cursor · **Model:** Grok 4.5 High Fast
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable-room research — explains living practice; cites `tally/pedersen.rye` and `linengrow/disclosure_core.rye`
**Ground:** counsel [`023112`](../counsel/20260709-023112_claude-counsel-zig-native-zk-path.md) · prompt [`031612`](../expanding-prompts/20260709-031612_slcl4-lap1-fixed-tier-sigma-protocol.md) · hammock [`194500`](../active-designing/20260708-194500_slcl4-selective-disclosure.md)

*Written by Kaeden and Rio 3 (Grok).*

---

## In One Breath

A **Pedersen commitment** is a sealed envelope for a number: anyone can see the envelope; almost no one can read the number inside; later you can open it and prove you sealed that exact number.

A **Sigma protocol** is a short conversation that proves you know a secret *without handing the secret over*. In our lap it proves: "I know the blinding factor that sealed this envelope for this public tier."

Together they let a donor show "this gift sits in an allowed bucket" while keeping the random seal private. Lap 1 still names the bucket in public; later laps can hide more.

---

## The Everyday Picture

Imagine three donation tiers on a poster: **1000**, **5000**, **10000**.

You pick **5000**. You also pick a huge random secret (the **blinding**). You mix them into one sealed blob — the **commitment**. People see the blob. They do not see your random secret. In lap 1 they *do* see which tier you claim, because the proof is built for a **declared** tier.

Then you run a tiny ritual (the **Sigma proof**) that says: "I really do know the blinding that makes this blob equal `5000·G + blinding·H`." A verifier checks the ritual math. If it checks, the blob and the claimed tier fit. If someone forged a blob without knowing a real blinding, the ritual fails.

That is the whole lap-1 story in kitchen language.

---

## Pedersen — the Sealed Envelope

**Named for** Torben Pedersen (1991). The idea is older than this tree; we implement our own copy in Zig.

**Formula we use** (Curve25519, same family as Kumara signatures):

```text
C = amount · G + blinding · H
```

| Piece | Role |
|-------|------|
| `amount` | The number you seal (here: a tier like 5000) |
| `blinding` | Fresh random secret — the seal |
| `G` | Fixed public base point (the curve's usual generator) |
| `H` | Second fixed public point, derived from a pinned domain string so nobody "picked a sneaky H" |
| `C` | The commitment — 32 bytes anyone can store or ship |

**Why two points?** If you only did `amount · G`, anyone who knows the amount could recognize it. Adding `blinding · H` scrambles the point so that, without the blinding, the amount stays hidden *when the amount itself is secret*. (In lap 1 the amount/tier is public on purpose; the blinding still matters so the proof has a real secret to know.)

**Properties people care about:**

1. **Hiding** — looking at `C` alone does not reveal `amount` (when blinding is random and secret).
2. **Binding** — once you publish `C`, you cannot later open it to a *different* amount with a different story and still be consistent (under standard curve assumptions).

On this tree: `tally/pedersen.rye` (symlink `linengrow/pedersen.rye`). `H` is pinned; the selftest asserts the bytes.

---

## Sigma — the Prove-You-Know Ritual

**Sigma** (Σ) names a family of interactive proofs with three moves:

1. **Commit** (sometimes called the first message) — prover sends a fresh random "nonce point"
2. **Challenge** — verifier sends a random question
3. **Response** — prover answers using the secret

If the answer fits the challenge and the public data, the verifier accepts. The prover never sends the secret itself.

**Fiat–Shamir** turns that conversation into a single blob: instead of a live verifier picking the challenge, both sides hash the public transcript (commitment, nonce point, tier, tier list, domain string) with SHA3 and treat the hash as the challenge. No back-and-forth on the wire. That is what `disclosure_core.rye` does.

**What lap 1 proves:** knowledge of `blinding` such that

```text
C = tier · G + blinding · H
```

with `tier` **public** and in `{1000, 5000, 10000}`.

**What lap 1 does *not* prove yet:** "this commitment is one of those tiers, and I will not tell you which." That needs a harder construction (an OR-proof or a range proof). Counsel `023112` deliberately started with the smaller ritual.

**Proof bytes on disk:** 64 bytes — nonce point `A` (32) plus response scalar `z` (32) — plus the commitment `C` beside them in the golden `.bron`.

---

## How the Two Fit Together

```text
Pedersen          →  make the sealed blob C
Sigma (Fiat–Shamir) →  prove you know the seal for a stated tier
.bron receipt       →  store C + proof for the witness to re-check
```

Parity's `tools/slcl4_sigma.rish` builds the binary, runs selftest, and checks the golden fixture. That is how "Pedersen + Sigma" earn a green line in the suite.

---

## Tiny Glossary

| Word | Plain meaning here |
|------|--------------------|
| Commitment | Sealed blob for a number |
| Blinding / blinding factor | Random secret mixed into the seal |
| Generator (`G`, `H`) | Fixed public curve points everyone agrees on |
| Sigma protocol | Prove-you-know ritual (commit → challenge → response) |
| Fiat–Shamir | Replace the live challenge with a hash of the transcript |
| Fixed-tier | Only a small public list of amounts is allowed |
| Declared tier | The proof names which tier; hiding *which* tier is later work |
| Zero-knowledge (informal) | Verifier learns the claim is true and little else about the secret |

---

## What to Read Next

- Living code: `tally/pedersen.rye`, `linengrow/disclosure_core.rye`
- Why this path instead of Groth16: counsel [`023112`](../counsel/20260709-023112_claude-counsel-zig-native-zk-path.md)
- Lap scope: prompt [`031612`](../expanding-prompts/20260709-031612_slcl4-lap1-fixed-tier-sigma-protocol.md)
- Parity as the green-light suite: [`194437`](20260709-194437_what-parity-is.md)

---

*May every sealed number stay sealed until its owner chooses the light, and may every proof we ask of metal stay small enough to hold in one breath before it grows.*
