# Grok Counsel — SLC-L4 W0: Lightweight Design Review of Lap-1 Fixed-Tier Sigma

**Stamp:** `20260709.224426`
**Editor:** Cursor · **Model:** Grok 4.5 · **Voice:** Rio 3
**Register:** Design review for selftest honesty — **not** a security audit, **not** an adversarial soundness proof
**Ground:** `tally/pedersen.rye` · `linengrow/disclosure_core.rye` · width design [`224325`](../context/specs/20260709-224325_slcl4-lap2-width.md) · counsel [`023112`](20260709-023112_claude-counsel-zig-native-zk-path.md) · plainly [`200022`](../external-research/20260709-200022_pedersen-and-sigma-plainly.md)

*Written by Kaeden and Rio 3 (Grok). Affirmed by keep-going after W0 lean.*

---

## Verdict

**W0 cleared for soak.** Lap 1's construction matches the expanding prompt and the kitchen-language note. The selftest proves the pattern it claims. Nothing in this review authorizes W1 (OR-across-tiers) or W2 (arbitrary range). Those still wait a separate affirm.

---

## What Was Reviewed

| Surface | Role |
|---------|------|
| `tally/pedersen.rye` | `C = amount·G + r·H`; pinned `H` via SHA3 domain → `fromUniform` |
| `linengrow/disclosure_core.rye` | Sigma prove/verify for a **declared** public tier |
| Golden `tools/fixtures/slcl4_tier_proof.bron` | Receipt field order |
| Witness `tools/slcl4_sigma.rish` | Parity **200** |

---

## Protocol Shape (as implemented)

1. **Commit:** `C = tier·G + r·H` with public `tier ∈ {1000, 5000, 10000}`.
2. **Nonce point:** `A = k·H` (nonce `k` is witness-only).
3. **Challenge:** `e = SHA3-256(domain ‖ C ‖ A ‖ tier_le ‖ all_tiers_le)` reduced to a scalar.
4. **Response:** `z = e·r + k` (Edwards scalar `mulAdd`).
5. **Verify:** check `z·H = A + e·(C − tier·G)` and refuse identity points / bad tiers.

This is a standard Schnorr-style proof of knowledge of the discrete log of `(C − tier·G)` in base `H` — i.e. knowledge of blinding `r` for a commitment that opens to the declared tier. The tier list in the Fiat-Shamir transcript binds the public candidate set.

---

## Affirmations (selftest scope)

| Check | Finding |
|-------|---------|
| Domain separation | Distinct strings for `H` (`pedersen-H/v1`) and Sigma (`sigma-tier/v1`) |
| Pinned `H` | `assert_pinned_h` / selftest equality to `pinned_h_bytes` |
| Tier allow-list | Prove and verify both refuse unknown tiers |
| Welcome path | All three tiers prove + verify in selftest |
| Unwelcome | Forged proof refused; wrong-tier claim against true `C` refused |
| Receipt | `.bron` fields match prompt: claim, log_digest, commitment, tier_claimed, proof, stamp |
| Clean room | No pairing, no external ZK toolchain; Edwards25519 + SHA3 only |

---

## Limits Named Honestly

1. **Declared tier is public.** Lap 1 hides blinding, not which bucket. Product language must not claim "amount privacy" beyond that.
2. **Witness scalars are fixed.** Deterministic selftest uses constant blinding/nonce — correct for golden fixtures; production prove must draw fresh randomness.
3. **`mulPublic` / variable-time.** Acceptable for witness and offline verify in this lap; timing side-channels are out of scope until a live adversarial surface exists.
4. **Scalar reduction of SHA3 digest.** Uses `Edwards25519.scalar.reduce` on 32 bytes — standard for this curve family in Zig; not re-proven here as a number-theory paper.
5. **No OR, no range.** A verifier who sees `tier_claimed` learns the bucket. W1 would change the transcript; W2 is a different protocol.
6. **Not an audit.** Soundness against a studying adversary, transcript malleability under composition, and multi-proof aggregation wait testnet-then-audit sequencing from counsel `023112`.

---

## Recommendation

| Next | Action |
|------|--------|
| **Soak** | Leave lap 1 on metal; cite this review from TASKS / width gate |
| **W1** | Only when a product surface needs hidden tiers — new expanding prompt, new transcript domain |
| **W2** | Hold until W1 is green and measured need appears |
| **Hygiene** | Optional later: document "fresh randomness required" beside `prove_tier` for the first non-witness caller |

---

*May every proof we call finished still name what it has not proven. May declared tiers stay as honest as their commitments. And may the next width we open be smaller than the story we wish the math already told.*
