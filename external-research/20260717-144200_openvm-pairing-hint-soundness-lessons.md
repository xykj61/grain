# OpenVM pairing hint — soundness lessons for Glow

*Today's news (2026-07-17): ZK Security's zkao found a critical soundness bug in OpenVM's guest pairing library. This note silos what that finding teaches our compass — not a fork of OpenVM, and not a pairing stack for Glow.*

**Stamp:** `20260717.144200`
**Voice:** Quin
**Editor:** Cursor · **Model:** Cursor Grok 4.5 300k High Fast
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable-room research — understanding only; no purchase, no protocol change, no circuit code
**Source:** [AI meets Cryptography 2: What AI Found in OpenVM's zkVM](https://blog.zksecurity.xyz/posts/openvm-bugs/) (Stefanos Chaliasos, Hao Pham · ZK Security · 2026-07-17) · CVE-2026-46669 · fixed in OpenVM 1.6.0
**Ground:** counsel [`023112`](../counsel/20260709-023112_claude-counsel-zig-native-zk-path.md) · Pedersen/Sigma plainly [`200022`](20260709-200022_pedersen-and-sigma-plainly.md) · Two Rooms [`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md) · TAME Vocabulary of Correctness

*Addressed to an Acme Corporation employee reading this tree's research stack.*

---

## What happened, in kitchen language

OpenVM's guest library checked a cheap optimized pairing equation that is sound only when a prover-supplied **scaling factor** lies in a proper subfield. The code checked that one hint was non-zero and skipped the subfield membership test (three coefficient-is-zero checks). A malicious prover could then forge any pairing equality. The proving system itself was not the bug — the **guest library's incomplete check of an optimization hint** was.

That distinction matters here: a green module and a green optimization can still compose into an unsound door when the optimization's silent invariant is left unwitnessed.

---

## Lessons that already live in our compass

### 1. Composition is the soundness surface

Secure A plus secure B does not imply a secure A∘B. ZK Security's own framing of why naive folder-parallel AI audit fails on a zkVM is the same grain this tree already names for Pool, Caravan capabilities, Comlink seals, and the TUBE ladder: **the seam carries the claim**. TUBE2 publish without resolve-and-admit, TUBE3 sealed fetch without digest match, TUBE1 admit without a matching grant — each is the same class of miss as "optimized equation without the subfield check."

**Hold:** when you revive a vane-shaped piece or design a new door, name the invariant the *caller* must still prove, not only the invariant the *callee* proves in isolation.

### 2. Hints are a trust boundary

Anything an untrusted party supplies (prover hint, host callback, wire payload, "already verified" flag) must be constrained at the checkable boundary, or the fast path is a narrative wearing a witness's clothes. The OpenVM scaling factor was an honest optimization *only under a membership check that never ran*.

**Hold for Glow:** sealed digests before admit; capability tables before Pool host; Mantra tip recall that still proves the prior revision exists. Never let a fast path return success in a way that skips the slow honest path without proving they are equivalent.

### 3. Cheap checks that close forgeries earn their place

The missing test was three equality checks. The forgery needed the full field. TAME's Vocabulary of Correctness — *prove and state invariants; prevent error classes* — already points here. A bound or membership check that is cheap relative to the claim it protects is not ornament; it is the claim.

**Hold:** prefer one small, named assert at the boundary over a later "we meant to check that" in a design note.

### 4. Two Rooms still governs AI-assisted audit

The article's second learning is for how companions read this tree: asking a model for a "working PoC" is a weak triage signal — models can green-paint nonsensical exploits. Human validation closed the finding. That matches Two Rooms: a candidate finding lives in the visionary room until a human-checked witness (or an honest refusal) moves it into the checkable room.

**Hold for agent work here:** module knowledge upward — what a file assumes, what it delegates, which invariant it silently relies on — beats a bug list from a folder skim. A GREEN witness you did not run is still narrative.

### 5. Affirms the Zig-native ZK pin — do not reopen pairing for SLC-L4

Counsel [`023112`](../counsel/20260709-023112_claude-counsel-zig-native-zk-path.md) already chose Curve25519 Pedersen + Sigma over Groth16/BN254/BLS12-381 because Zig 0.16 has no pairing stack, and building one is a dissertation, not a lap. Today's bug is further evidence that **pairing-product optimizations are a specialized soundness minefield**. Linengrow's "mechanism transparent; individual private" path stays on the smaller Sigma tier proof; this silo does **not** reopen a pairing or zkVM guest-library track.

If a future season ever studies pairing-friendly verification for an external seat, treat every residue-witness / final-exponentiation shortcut as requiring its own membership witness before any claim of GREEN — and keep that study in `external-research/`, clean-room, never as a silent dependency in `linengrow/`.

---

## What this does *not* change today

| Surface | Verdict |
|---------|---------|
| SLC-L4 / Pedersen+Sigma | Unchanged — pin strengthened, not replaced |
| TUBE ladder / HAWM glass | Unchanged — pause holds TUBE2 glass look open |
| Pool / Caravan revival | Design reminder only — seams and grants stay the checkable surface |
| Proven-seat / GrapheneOS | Out of scope for this article |
| Shipping OpenVM or any zkVM | Not a gratitude clone target; ideas only |

---

## One sentence to carry forward

**An optimization that replaces an expensive honest check is sound only when every silent assumption of that optimization is itself checkable — preferably by a cheap membership or bound assert at the same door.**

---

*May every fast path keep the slow truth within reach, and every hint earn its membership before it earns trust.*
