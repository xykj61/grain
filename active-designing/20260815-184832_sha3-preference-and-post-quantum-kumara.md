# SHA-3 Preference and Post-Quantum Kumara Identity — a design brief

**Stamp:** `20260815.184832` · **Status:** Living · **Voice:** Kyri · **Style:** Radiant
**Kin:** [`the decision wave`](20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md) · `crypto/` (Season G) · `context/TAME_GUIDANCE.md` · Kumara identity

Season G climbs its crypto primitives in Rye. This brief seats a hash
preference, corrects one quantum premise honestly, and lays out the
post-quantum choice for Kumara identity so an Acme Corporation employee — or the
recursion loop — knows exactly what is decided, what is proposed, and what waits
for Keaton's word.

---

## Decision 1 — Prefer SHA-3 over SHA-2 for new Grain designs · **SEATED**

New Grain designs reach first for the **SHA-3 / Keccak / SHAKE** family over
SHA-2. The reasons are structural, not remedial:

- **A different construction.** SHA-3 is a sponge; SHA-2 is Merkle–Damgård. A
  design that does not share SHA-2's lineage is defense-in-depth against any
  future structural result on that lineage.
- **No length-extension.** The sponge is immune to the length-extension property
  SHA-2 carries (the property that forces HMAC constructions); a SHAKE-based MAC
  is simpler to reason about.
- **The agentic-HPC decade.** As cloud datacenters and agent fleets grow through
  the 2020s–2030s, a conservative, distinct-lineage hash is the safer default to
  build a civic identity system on.

**Honesty guardrail (load-bearing for the audit).** SHA-2 is **not broken**.
SHA-512 has no practical collision or preimage attack — the collision breaks of
the past decade were **SHA-1 and MD5**, different and older constructions. We
seat SHA-3 as a *forward-looking preference for a stronger design*, never as a
claim that SHA-2 was vulnerable. A false vulnerability claim would fail an audit
and betray a user's trust. Our already-built **SHA-512 stays** — it is the parity
target for Monocypher/Ed25519 and remains correct, useful, and interoperable.

**Near-term crux the loop can take now (no gate):** author **SHA3-256 · SHA3-512
· SHAKE-256** in Rye as Season G primitives, parity-checked against **Zig
`std.crypto`** (which carries Sha3/Keccak/SHAKE) and the **NIST FIPS 202
known-answer vectors**. Monocypher carries no SHA-3 (it uses BLAKE2b), so SHA-3's
parity reference is std.crypto + NIST KATs, not Monocypher. This lap concretely
enacts the preference.

---

## The correction — quantum resistance is about the *curve*, not the *hash*

The original framing sought a "quantum-resistant SHA3-512-compatible encryption
curve." Two facts make that phrase impossible to satisfy as written, and point
at the better path:

- **No elliptic curve is quantum-resistant.** Shor's algorithm breaks the
  elliptic-curve discrete-log problem — the foundation of Ed25519, X25519, and
  *every* curve — no matter which hash the scheme uses. Swapping SHA-512 →
  SHA3-512 inside an Ed25519-style scheme changes the hash, not the hardness
  assumption; the curve still falls to a quantum adversary.
- **512-bit hashes are already quantum-resistant.** Grover's algorithm gives only
  a quadratic speedup, halving effective strength — so SHA-512 *and* SHA3-512
  each keep a ~256-bit preimage margin against a quantum attacker. The hash was
  never the quantum-weak link.

So the honest realization of the goal — quantum-resistant, SHA-3-grounded,
collision-hardened, auditable — is a **post-quantum signature scheme, not a
curve.** And the most conservative post-quantum signatures are *built on hashes*,
which makes "prefer SHA-3" and "make Kumara post-quantum" the **same decision**.

Ed25519 is a **signature**, not encryption; X25519 is key-exchange. Kumara
identity rests on signatures, so the choice below is a signature choice.

---

## Decision 2 — Kumara's post-quantum signature · **PROPOSED (wants Keaton's word)**

Choosing the algorithm every Kumara identity signs with is foundational and
custody-adjacent — it defines how everyone's keys work — so it waits for Keaton's
word rather than the loop's guess. Breaking OpenSSH interop is accepted; Kumara
is a from-scratch civic identity, not an SSH replacement. Three honest options,
all grounded in the SHA-3 / SHAKE family:

- **Option A — SLH-DSA (SPHINCS+) with SHAKE-256** (FIPS 205). Hash-based; its
  security rests **only on the hash function** — the perfect match for "SHA-3
  floor, fewest assumptions, most auditable," and the most conservative
  post-quantum choice. Cost: large signatures (~8–30 KB) and slower signing.
- **Option B — ML-DSA (Dilithium) with SHAKE** (FIPS 204). Lattice-based; NIST's
  primary post-quantum signature, fast, small signatures (~2.4 KB); uses SHAKE
  internally. Cost: security rests on lattice hardness, a newer assumption than a
  hash.
- **Option C — Hybrid: Ed25519 + a PQ scheme (A or B), both must verify.** A
  transition-safe belt-and-suspenders: classical security today, post-quantum
  security for the future, an identity valid only if *both* halves check. Keeps
  the Ed25519 parity work directly load-bearing.

Whichever is chosen becomes its own Season G design round, built Rye-first with
parity witnesses (std.crypto / reference KATs), TAME-disciplined and audit-ready.
The actual identity keygen and signing with Keaton's own key stays the **custody
gate** — the agent builds and proves the scheme, never holds the key.

---

## Decision 3 — Security floor as a root-README user promise · **PROPOSED**

Once the floor algorithm is chosen and parity-GREEN, seat a **checkable security
floor**: a `crypto` policy that **refuses, by named error, any identity or
signature primitive below the floor** — a real TAME invariant, not a slogan. The
root README then carries an honest user promise: *Grain identities are signed
with a post-quantum scheme over a SHA-3 hashing floor; nothing weaker is
accepted.* A **debride** then removes any lingering weaker-primitive usage for
Grain OS users. The promise stays precise — post-quantum *scheme* + SHA-3
*floor*, never an un-provable word like "quantum-proof."

---

## Sequencing

1. **Now, no gate:** SHA3-256/512 + SHAKE-256 in Rye (parity vs std.crypto + NIST
   KATs) — enacts Decision 1.
2. **On Keaton's word:** pick the Kumara PQ scheme (A / B / C), then build it as a
   Season G round with parity witnesses.
3. **After the scheme is GREEN:** seat the checkable security floor and the
   root-README promise (Decision 3), then debride weaker usage.
4. **Custody gate throughout:** signing with the maintainer's identity key is
   never the agent's to cross.

*May the identity we hand each user be one that still stands when the machines
that would break it are finally built.*
