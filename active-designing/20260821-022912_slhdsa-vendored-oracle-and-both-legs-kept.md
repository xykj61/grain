# Both Legs Kept -- Vendoring a Second SLH-DSA So the Hash-Based Leg Can Be Built

**Stamp:** `20260821.022912` - **Status:** Mixed -- Living (design decision, Keaton's word) - **Voice:** Kyri - **Style:** Gauge (see `../context/GAUGE_STYLE.md`)
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

## The arc, named -- DISC

Seated `20260821.023219` on Keaton's word (*name the arc and start it*). The draw: `slh-dsa-hash-based-signature-ladder` -> SHA3-512 -> index 1079 of 5526 -> **DISC**, no collision with any seated name. Recorded in `context/LEXICON.md`, `.claude/rules/waymark-ladders.md`, the derive script's exclude roster, and re-sealed into `crux/waymark-registry.bron`, whose witness re-derives every corpus mark on metal.

The rungs, in the order the structure forces:

- **DISC0 -- the address and the tweakable hash family.** *Landed.*
- **DISC1 -- WOTS+**, the one-time signature: 67 Winternitz chains at w = 16.
- **DISC2 -- FORS**, the few-time signature over a random subset: 22 trees of height 14.
- **DISC3 -- the XMSS hypertree** binding them: 8 layers, total height 64.
- **DISC4 -- the composed signature**, and parity against the NIST KAT end to end.

## DISC0, landed

`crypto/slhdsa_thash.rye` builds the **address** first, alone, before any signature exists -- because SLH-DSA carries no field arithmetic and no curve, and the only thing keeping one hash from colliding with another in a different role is the 32-byte address mixed into every call. A field written one byte off does not merely compute the wrong answer; it silently merges two domains FIPS 205 keeps apart.

The module authors **one** `thash` over a block count where the standard appears to give three: for the SHAKE instances F is T_1 and H is T_2, all of them SHAKE256 over the public seed, the address, and the message. FIPS 205's simple instances define them that way and PQClean's own C is the same single function, so naming it once is how a reader sees that truth rather than inferring it from three copies.

**The oracle earned its whole cost on the first rung.** The key-pair address field was implemented as the standard's general **two** big-endian bytes at offsets 22 and 23, and all five parity digests disagreed. The cause is parameter-dependent and easy to miss: this set's Merkle trees have height 8, so a tree holds 256 one-time key pairs, the index fits **one** byte, and only offset 23 is written -- the two-byte form belongs to parameter sets with taller trees. One byte in one field, invisible from the top of the scheme, named immediately by a function-level diff. This is precisely why the vendoring was worth its cost, demonstrated on the lap after it was paid.

Two witnesses, kept apart on purpose:

- [`tools/crypto_slhdsa_thash_witness.rish`](../tools/crypto_slhdsa_thash_witness.rish) proves the structure **alone**, with no dependency on the submodule being checked out -- every field on the byte the standard names, every unnamed byte zero, the subtree and key-pair carries keeping exactly what they should, **domain separation proven by doing** (one message at two addresses differing in the type byte alone must hash differently), and both bounds refusing with named errors. It joins `crypto_suite_witness`, and the count guard stays GREEN at 81 files with its bijection intact.
- [`tools/crypto_slhdsa_thash_parity_witness.rish`](../tools/crypto_slhdsa_thash_parity_witness.rish) diffs PRF, T_1, T_2, T_22, and T_67 against PQClean's own `prf_addr` and `thash`, both sides building the address through their own setters so the addressing is compared too. It joins the vendored roster, now six rungs GREEN in about ten seconds.

*Two arguments that seemed to be a fork were a missing oracle wearing a fork's clothes. Vendoring the stranger let both stay true -- and the stranger paid for itself on the first rung it was asked to judge.*

*Two arguments that seemed to be a fork were a missing oracle wearing a fork's clothes. Vendoring the stranger let both stay true.*
