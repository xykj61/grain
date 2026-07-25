# Sui ZK Primitives — Pinned for SLC-L4 Donor-Amount Privacy

*A study, not a build: what Sui actually offers today for proving a donation claim without revealing the exact amount — and which seam Linengrow should grow toward first.*

**Stamp:** `20260708.223327`
**Voice:** Rio 3
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME · [SLC](../context/SIMPLE_LOVABLE_COMPLETE.md) · CIVIC · clean-room gratitude
**Status:** Checkable-room research — understanding only; **implementation superseded** by counsel [`023112`](../counsel/20260709-023112_claude-counsel-zig-native-zk-path.md) for Zig-native builds (no pairing in Zig 0.16 stdlib). Kept for the Sui on-chain record and gratitude study surface.

**Ground:** hammock [`../active-designing/20260708-194500_slcl4-selective-disclosure.md`](../active-designing/20260708-194500_slcl4-selective-disclosure.md) · counsel [`../counsel/20260708-221612_claude-counsel-six-open-points.md`](../counsel/20260708-221612_claude-counsel-six-open-points.md) · SLC-L3 rail [`../active-designing/20260708-182500_slcl3-settlement-rail.md`](../active-designing/20260708-182500_slcl3-settlement-rail.md) · Linengrow privacy prose [`../linengrow/README.md`](../linengrow/README.md) · Sui docs (public) + `gratitude/sui` (Apache-2.0 / MIT study surface)

---

## What This Study Pins

Counsel `221612` named the real first step for SLC-L4: **pin what Sui's ZK primitives actually offer** — a study, not a build — aimed at **donor-amount privacy**. This file is that pin.

| Question | Answer in one line |
|----------|---------------------|
| What can verify a ZK proof on Sui today? | Native Move module `sui::groth16` — Groth16 over BN254 or BLS12-381 |
| What is zkLogin? | Auth / wallet onboarding — **not** a general claim prover for donation amounts |
| What are Seal / Nautilus? | Encryption + TEE attestation layers — useful later; **not** the first donor-amount seam |
| What claim shape fits donor-amount privacy? | Circom (or equivalent) circuit: private amount; public threshold / policy flag + binding digests |
| What stays ours? | Log remains source of truth; chain verifies a proof receipt; POSIX external-interpreter seam (SLC-L3 family) |

---

## The Four Surfaces — Named Honestly

Sui's privacy story in mid-2026 spans several products. Only one of them is the right first pin for Linengrow's donor-amount pass.

### 1. `sui::groth16` — the pin for SLC-L4 v1

**What it is:** On-chain verification of Groth16 zk-SNARK proofs. Any NP statement expressible as a circuit (Circom is the documented path) can be verified in Move without revealing private witness inputs.

**Documented facts that bind our design:**

| Fact | Source shape | Consequence for us |
|------|--------------|--------------------|
| Curves: BN254 or BLS12-381 | `sui::groth16::{bn254, bls12381}` | Prefer **BN254** for Circom / ark-circom ecosystem familiarity unless a later study proves otherwise |
| Max **eight** public inputs | Sui Groth16 docs | Donor-amount public inputs must stay ≤ 8 field elements — design the receipt around that budget |
| Trusted setup per circuit | Groth16 property | Production keys need a ceremony; test keys are for selftest only — name this in every witness |
| Contract must pin the verifying key | Docs warning | Attacker-chosen VK would accept forged proofs — our Move package (or pinned bytes in the seam) holds the expected VK |
| Prove off-chain, verify on-chain | Circom → ark-circom → Move | Matches our **POSIX external-interpreter** habit: prove on the host, verify via a thin seam |

**Gratitude study surface:** `gratitude/sui/docs/content/develop/cryptography/groth16.mdx` and `gratitude/sui/examples/move/crypto/groth16/` — read for shapes; never copy into Rye modules.

### 2. zkLogin — adjacent, not the pass

zkLogin proves "this OAuth identity controls this Sui address" without exposing the OAuth token on-chain. It is a **wallet and auth** primitive. Donor-amount privacy proves a **numeric policy claim** about a donation fact. Different statement, different circuit, different lap. Keep zkLogin out of SLC-L4 v1 scope.

### 3. Seal — selective *access*, not selective *proof*

Seal (threshold encryption, on-chain access policies) answers "who may decrypt this ciphertext, when." Donor-amount privacy answers "prove the amount meets a threshold without revealing the amount." Seal may later wrap encrypted donation metadata; it does not replace a Groth16 range / threshold proof for the first pass.

### 4. Nautilus — TEE attestations

Nautilus runs confidential logic in TEEs and returns attestations Move can check. Powerful for private oracles and AI agents. For a single-value threshold on a donation amount, a pure Groth16 circuit is simpler, more portable, and closer to Gall's Law growth from SLC-L3's already-public receipt shape. Park Nautilus for a later season unless a concrete sanctuary need forces TEE.

---

## Donor-Amount Privacy — Claim Shape Mapped to Groth16

Linengrow's privacy law (mechanism transparent, individual private) wants:

> Prove: a donation occurred, linked to our signed log, and the amount satisfies policy **P** — without publishing the exact amount on the public fold.

### Proposed circuit (conceptual — not implemented)

| Signal | Visibility | Meaning |
|--------|------------|---------|
| `amount` | **private** | Exact donation in smallest unit (matches SLC-L1 fact) |
| `threshold` | **public** | Policy floor (or encoded policy id) |
| `log_digest` | **public** | SHA3-256 of the signed SLC-L1 log line (binds proof to our log) |
| `settlement_tx` or `receipt_digest` | **public** (optional) | Links to SLC-L3 settlement when dollars moved |
| `ok` | **public** (or implicit) | Constraint: `amount >= threshold` (or policy predicate) |

Public-input budget: keep `threshold`, `log_digest` (as two field elements if needed), and at most one settlement binding — stay under eight.

### Proof receipt (`.bron`) — refined from the hammock

Hammock proposed fields wait on this pin. With Groth16 pinned:

| Field | Meaning |
|-------|---------|
| `claim` | `donor-amount-privacy` |
| `log_digest` | 64-char hex — same as SLC-L3 |
| `curve` | `bn254` \| `bls12381` |
| `vk_id` | content id or pinned hash of the verifying key bytes |
| `proof` | hex of Groth16 proof points (or path to fixture in selftest) |
| `public_inputs` | hex of serialized public inputs (≤ 8) |
| `stamp` | `YYYYMMDD.HHMMSS` witness pin |

`proof_id` from the hammock becomes either the on-chain object id after a verify tx, or the content hash of `proof` + `public_inputs` for offline verify — name which at lap open.

---

## Seam Pattern — Same Family as SLC-L3 (removed from tree)

SLC-L3 taught the thin rail: POSIX script as external interpreter; Rishi host; witness on demand. Implementation **removed** `152612`; hammock [`182500`](../active-designing/20260708-182500_slcl3-settlement-rail.md) holds the record.

| Layer | SLC-L3 (removed) | SLC-L4 donor-amount (proposed) |
|-------|------------------|--------------------------------|
| Core | ~~`linengrow/settlement_core.rye`~~ | future `linengrow/disclosure_core.rye` (name waits on lap word) |
| Selftest | ~~pinned lane goldens~~ | pinned offline fixture verify (Zig-native path per counsel `023112`) |
| Live seam | ~~`chain_read_*.sh` / settle scripts~~ | prove host; no Sui/Monad dependency on MALA path |
| Witness | ~~`slcl3_settlement_witness.rish`~~ | offline fixture witness first; parity-eligible when lap lands |

**TAME:** prove and verify paths assert invariants before algorithms; bounds on proof size and public-input count; no SDK link into Rye — Move verify stays behind a POSIX or `sui client` seam until a clean-room Rye verifier earns its own season.

**Clean room:** Circom circuits and Move packages we author are ours; we study Sui's examples and never paste Mysten source into `linengrow/` or `rye/`.

---

## What Is Ready vs What Still Waits

### Ready (this study closes the pin)

- Native on-chain verifier identified: `sui::groth16`
- Curve and public-input budget named
- zkLogin / Seal / Nautilus scoped out of v1
- Claim shape and receipt fields refined for donor-amount privacy
- Seam family chosen (external interpreter + offline fixture first)

### Still waits (Kaeden's lap word + build season)

- Circom circuit authored and ceremony / test keys policy
- Move package that pins VK and exposes verify
- `disclosure_core` + witness + golden bron
- Live testnet verify path (on-demand witness, not parity)
- Monad lane: no native Groth16 twin assumed — Sui is the first verify seat; Monad stays settlement-only until a separate study

---

## Compass Check

| Discipline | How this study keeps it |
|------------|-------------------------|
| **SLC** | One claim, one proof object, one verify path — Simple; sanctuary donor privacy — Lovable; prove→receipt→verify — Complete when the lap opens |
| **TAME** | Invariants and bounds named before code; external interpreter; trusted-setup honesty |
| **CIVIC** | Mechanism (policy threshold) can stay public; individual amount stays private |
| **TWO_ROOMS** | Research for understanding — no treasury recommendation |
| **Gall's Law** | Grows from SLC-L3 receipt + log digest already GREEN |

---

## Recommendation (propose, never seat)

1. Treat **`sui::groth16` + Circom threshold circuit** as the pinned foundation for SLC-L4 donor-amount privacy.
2. Open the lap only when Kaeden supplies the lap word — this study removes the "unknown ground" blocker, not the custody of opening.
3. First build slice, when opened: offline prove/verify selftest with fixture keys; then optional Sui testnet verify seam; never wire live network into `parity.rish`.

---

*May the proof name only what the donor chose to prove, and may the log keep every fact the room still needs to trust.*
