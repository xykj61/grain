# Claude Counsel — the Zig-Native Path, One Real Gap Found, and One Genuinely Promising Way Through It

**Stamp:** `20260709.023112 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** the same distinction held through every prior round of this exchange — implementation risk and protocol-design risk are different categories — applied here to a genuinely different, more carefully sequenced plan than the one this bench weighed before
**Register:** A real update to this bench's own position, where the new plan earns it, alongside honest technical ground-truth checked directly on the vendored Zig 0.16 stdlib rather than assumed
**Ground:** `/usr/local/lib/.../ziglang/lib/std/crypto/25519/edwards25519.zig` and `pcurves/` read directly on this bench — not recalled, not assumed — to answer exactly what Zig's own standard library does and does not provide

*Written by Kaeden and Rio 3.*

---

## First, a Real Update to This Bench's Own Position

The testnet-only, low-value-only, audit-before-anything-real sequencing is exactly the fuller picture the last round's counsel asked for, named in Kaeden's own words rather than this bench's. That counsel drew a hard line between implementation discipline and the protocol-level, adversarial scrutiny a settlement system also needs — and this plan supplies the second half explicitly, on a timeline that never risks real value before that scrutiny happens. This bench is glad to say so plainly: this is a more responsible plan than the one it was weighing two rounds ago, and its own earlier caution stands answered, not overruled.

## The Real Technical Ground, Checked Rather Than Assumed

Groth16 — the verification scheme `sui::groth16` offers, and the one the ZK pin study and last round's counsel both built toward — depends on pairing-friendly elliptic curves: BN254 or BLS12-381, curves whose entire purpose is supporting a bilinear pairing operation. This bench checked Zig 0.16's actual vendored standard library rather than assume, and the finding is unambiguous: `std.crypto.pcurves` offers exactly three curves — P256, P384, secp256k1 — and a direct search for pairing support anywhere in the crypto tree returns nothing. **A Zig-only implementation cannot reach Groth16, or any pairing-based scheme, without first writing an entire pairing-friendly curve stack from raw field arithmetic — the Miller loop, the tower of field extensions, final exponentiation — a specialized undertaking on the order of a PhD dissertation, not a lap.** This is a fact about the library, not a preference of this bench's, and it is worth naming exactly that plainly.

## The Genuinely Promising Way Through It

Groth16 is not the only shape a zero-knowledge threshold proof can take, and this bench looked for one that actually fits what Zig already has before concluding anything. `std.crypto.ecc.Edwards25519` — the identical curve family Kumara already signs with — exposes `mulDoubleBasePublic(p1, s1, p2, s2)`, computing `s1·p1 + s2·p2` as one real, optimized operation. That is, letter for letter, the Pedersen commitment: `amount·G + blinding·H`, where `G` and `H` are two independent, nothing-up-my-sleeve generator points — the second derivable with the same file's own `fromUniform`, a hash-to-curve function already present for exactly this purpose. A Pedersen commitment hides `amount` perfectly on its own; proving *the hidden value clears a threshold* on top of it is a **Sigma protocol** — a Fiat-Shamir-transformed proof of knowledge, built from nothing more than the group operations already read here and a hash function (SHA-3, already used throughout this tree) standing in for the verifier's random challenge. No pairing. No trusted setup ceremony at all, which Groth16 could never avoid. No language beyond Zig, because every operation this construction needs is already sitting in the vendored stdlib this bench just read.

## What This Honestly Still Costs

A Sigma-protocol range proof is real cryptographic protocol design, and this bench will not soften that the way it would not soften it for a pairing circuit. Proving `amount >= threshold` for an arbitrary threshold, rather than a fixed small set of buckets, needs the value's bit decomposition proven correct — Zig's own comparator logic, expressed as constraints over commitments rather than as ordinary code, which is exactly where subtle range-proof bugs have historically lived in every ZK ecosystem, this project's chosen tools included. TAME's own discipline — bounds named before code, assertions on both sides of every boundary — narrows the *implementation* of whatever protocol gets chosen. It does not, on its own, prove the *protocol* is sound; that is a different kind of correctness; the same distinction the last two rounds of this exchange were built on. This bench's honest recommendation for the very first lap, given that: **prove membership in a small, fixed set of pre-approved threshold tiers before attempting an arbitrary-range proof.** "Donation clears $10, $50, or $100" is a genuinely smaller Sigma protocol than "donation clears any threshold whatsoever," and it is enough to prove the whole pattern — commitment, challenge, response, verify, `.bron` receipt — end to end before the harder general case is worth reaching for. Smallest first, exactly as this tree already keeps it everywhere else.

## MALA and WOV, Named Separately From the Proof Question

Selective disclosure and "our own settlement layer" are two different problems wearing one conversation, and they deserve being pulled apart plainly. Donor-amount privacy needs the Sigma-protocol construction above, or nothing at all. MALA and WOV — a signed, append-only ledger and whatever settles on top of it — need almost none of that. Weave already is a signed, append-only ledger, Ed25519-authenticated through Kumara, SHA3-addressed through resin, entirely Zig-native today. What MALA-as-L1 would actually add beyond what Weave already is comes down to one real, hard question this bench named plainly two rounds ago and has not found reason to soften: some form of consensus among more than one party who does not fully trust each other — Byzantine agreement, sybil resistance, economic security against a rational attacker. That is protocol-design risk of the largest kind this bench has discussed all week, language choice notwithstanding — Zig implemented with total discipline still leaves the *design* of the agreement rule itself to be gotten right, and getting it right is not a coding problem. This bench's recommendation stands unchanged from before: hold "our own L1" at Horizon 3, and let the testnet-and-audit trial Kaeden just proposed apply to the *proof* work above first, since that work is smaller, more tractable, and closer to ground this tree already stands on.

## What This Changes on the Living Plans

TASKS gains a corrected pin: Groth16 is out for a Zig-only build, named as a real finding rather than a preference; the Curve25519 Sigma-protocol path is in, scoped to a fixed threshold-tier set for its first lap; MALA/WOV stays exactly where Horizon 3 already held it, now with the reasoning current rather than dated. Nothing here opens a lap on its own — the same lap-word gate this whole arc has kept applies exactly as before.

---

*May every gap this tree finds in its own tools be named as plainly as this one was, rather than argued around. May the smallest true version of a hard proof always be tried before the largest one is assumed necessary. And may a plan that answers its own critic in advance be recognized for what it is, rather than met with the same caution it already accounted for.*
