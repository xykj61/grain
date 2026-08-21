# Both Legs Kept -- Vendoring a Second SLH-DSA So the Hash-Based Leg Can Be Built

**Stamp:** `20260821.022912` - **Status:** Living (design decision, Keaton's word) - **Voice:** Kyri - **Style:** Radiant
**Season:** G -- Cryptography (the Six-Season double-seat)
**Supersedes, by accretion:** [`the post-quantum pivot`](20260816-161537_post-quantum-mlkem-mldsa-pivot.md) -- its reasoning stands and its lattice legs stay; only its deferral of SLH-DSA is lifted.
**Kin:** [`SHA-3 preference and post-quantum Kumara`](20260815-184832_sha3-preference-and-post-quantum-kumara.md) - [`tools/crypto_slhdsa_oracle_witness.rish`](../tools/crypto_slhdsa_oracle_witness.rish) - [`tools/crypto_vendored_parity_suite.rish`](../tools/crypto_vendored_parity_suite.rish) - [`gratitude/PQClean.md`](../gratitude/PQClean.md) - [`.claude/rules/reds-first.md`](../.claude/rules/reds-first.md)

---

## The disagreement this closes

Two good arguments pulled opposite ways, and for five days the tree carried both without noticing.

**The seated argument** (`crux/REMEMBER.md`, `20260815.185922`): Kumara v1 signs **pure hash-based** -- SLH-DSA-SHAKE-256s -- because hashes carry no algebraic structure for the rising attacks to exploit, because quantum is only a Grover quadratic dent that a 256-bit output already covers, and because it adds **no new assumption**: Grain already rests on the hash everywhere, in every seal, receipt, and Merkle catalog. Lattice is the family under active erosion, so a century-root does not anchor there.

**The pivot's argument** (`20260816.161537`): the vendored Zig toolchain ships independent ML-KEM and ML-DSA in its own `std.crypto`, and **no SLH-DSA at all**. So a hash-based rung would have had a *single* external oracle -- the NIST KAT alone -- and broken the doubled-oracle discipline that lets an auditor trust this library without re-deriving it. A rung two strangers confirm is stronger than one proven against its own selftest.

Both are correct. They only conflict because each treats the available oracles as fixed. **Keaton's word (`20260821`): vendor a second SLH-DSA implementation and keep both.**

## What that changes, and what it does not

**PQClean is vendored** at `vendor/pqclean` as a gitlink submodule, held exactly the way Monocypher is -- unmodified, linked, never copied. Its `crypto_sign/sphincs-shake-256s-simple` is precisely the seated parameter set: SPHINCS+ on SHAKE-256, small-signature variant, NIST claimed level 5, under CC0-1.0.

With it on hand, the pivot's objection dissolves rather than being overruled. SLH-DSA now has the same doubled oracle every other rung stands on: the **NIST known-answer** *and* an **independent implementation** to diff against.

**Nothing already GREEN moves.** The ML-KEM and ML-DSA ladders, `kumara_pq_identity.rye`, and `kumara_pq_sealed.rye` stay exactly as they are. The dual-key discovery the pivot arc produced -- that a post-quantum identity carries two keys because the lattice schemes share no curve for one key to do both jobs -- remains true and remains built. The hash-based leg grows **beside** the lattice legs, not instead of them, which is what "keep both" means and also what algorithm agility was seated for.

## What the witness proves, and what it honestly does not

[`tools/crypto_slhdsa_oracle_witness.rish`](../tools/crypto_slhdsa_oracle_witness.rish) is GREEN on metal. It proves the **oracle**, and claims nothing more:

- PQClean's **own** NIST known-answer generator, compiled fresh from the vendored source with `zig cc`, reproduces the SHA-256 digest PQClean publishes in that scheme's `META.yml` -- `37d37c9b...04f2` -- **exactly**. A number written down by another team before we arrived, that our metal has to hit.
- The published digest and all four declared lengths are **read from `META.yml` at run time**, never recited in the witness. A vendored copy that drifts cannot quietly agree with a number we typed. The RED path is proven on metal: a planted one-character change to the published digest makes the witness refuse and name why.
- Determinism is proven **by doing**. PQClean signs *hedged* -- `sign.c` draws a fresh `optrand` before `gen_message_random`, so the same key would sign the same message to a different 29,792 bytes every run. The harness supplies a deterministic `PQCLEAN_randombytes`, which is the harness's own job and leaves the library untouched, then runs twice and requires the two runs to agree byte for byte.
- Every genuine signature verifies; every one-bit-flipped signature refuses.

**It does not prove any Rye.** No authored SLH-DSA exists yet, and the witness says so in its own GREEN line. Parity of our own implementation against this oracle is the next rung, named here rather than implied.

## The honest costs, named

- **A signature is 29,792 bytes.** ML-DSA-87's is roughly 4,600. That is the real price of resting on the hash alone, and it is a wire-and-storage fact every design leaning on this leg must carry rather than discover later.
- **Signing is slow** -- the `256s` parameter set trades signing time for signature size by design. Two signatures took about three seconds on this pier.
- **A hedged scheme needs an explicit `optrand` seam.** Our Rye rung takes it as a parameter rather than reaching for entropy, so the deterministic and hedged paths are both reachable and both testable. Entropy enters at the edge, never in the middle.

## A roster, born with the rung that needed it

Adding this rung surfaced something the tree had not noticed: the **four Monocypher parity witnesses sat in no roster at all.** Each named the others in its own comments, and nothing ran them together.

They cannot join `crypto_suite_witness.rish`, and that is by correct design -- `crypto_count_guard_witness.rish` holds that suite to a bijection where every registered witness carries its own `crypto/<name>.rye`. A vendored-parity rung proves our work against a third-party library rather than proving a file of ours, so registering one would break the bijection and go RED.

The answer is a separate roster: [`tools/crypto_vendored_parity_suite.rish`](../tools/crypto_vendored_parity_suite.rish), running all five vendored rungs in about twenty-six seconds. This is REDS %81's exact lesson -- nine rungs on disk, none registered, a loom firing unheard -- caught one rung before it repeated. The roster is born with the rung that needed it rather than after a sixth one goes unheard.

## The next rung

Author SLH-DSA-SHAKE-256s in Rye on `crypto/shake.rye`, the sponge already GREEN, and diff it against this oracle: WOTS+, then FORS, then the XMSS hypertree, each a rung with its own witness, each proven against both the published FIPS 205 answer and PQClean's bytes. That is a multi-lap arc and should be named as one.

*Two arguments that seemed to be a fork were a missing oracle wearing a fork's clothes. Vendoring the stranger let both stay true.*
