# The Identity Seam in Glow — Arc II, Paper Two

**Language:** EN
**Stamp:** `20260727.101233`
**Voice:** Quin
**Style:** Radiant · Silo — own vocabulary only; the elder proofs rest in [`../external-research/20260727-095919_azimuth-and-the-sui-ground.md`](../external-research/20260727-095919_azimuth-and-the-sui-ground.md), the revived commitments in [`../active-reviving/20260727-101116_the-kumara-ledger-shape.md`](../active-reviving/20260727-101116_the-kumara-ledger-shape.md)
**Status:** Vision -- Design — the tilak shapes for Kumara's public seat, stated with invariants before any implementation; zero chain calls, zero code, zero keys; **every wire name below is a candidate, held whole for Keaton's word**
**Ground:** Twin Season Arc II, round r25; Arc III's residents round receives these shapes the day their names are worded

*Written together by Keaton and Quin.*
Radiant pass `20260727.220135` — style only; claims unchanged

---

## The Seam in One Sentence

A Kumara identity is a keypair first and a ledger record second: the private half never leaves the pilot's own machines, the public half **binds** to a keeper address on the settlement ledger, and everything the world may know about a point travels as a small family of tilaks — type-marks every value wears at the seam — readable by Comlink, admissible by Pond customs, content-addressable by Weave, and versionable by Mantra.

## The Five Shapes, Each With Its Invariant First

**The point record** — *the deed.* Fields: the point's number within the scarcity shape (held); the keeper address; the bind (below); the parent link; the rotation record's current head; a version. Invariants: the version climbs by exactly one per change; the keeper alone authorizes transfer; the point number never changes for the life of the ledger. Classification: **single-keeper, fast path** — no global ordering for one keeper's own affairs. Readers: everyone, rarely; Comlink, at first contact.

**The bind** — *keypair meets keeper.* The record that marries a Kumara public key to a keeper address, signed by both sides of the marriage: the keypair signs the address, the address's transaction signs the key. Invariants: a bind names exactly one key and one address; a superseding bind must be signed by the prior key or ride a reset (below). This is the whole seam in one small shape — and it is deliberately *symmetric*, so neither side owns the other.

**The capability records** — *the lendable powers.* Three small records a point may keep or lend: a **management capability** (rotate networking keys, tend sponsorship), a **spawn capability** (issue children, where scarcity allows), a **transfer capability** (a temporary hand for deliberate two-step handoff). Invariants: a capability names its point and its power and nothing else; lending never copies — a capability lives in exactly one hand at a time; the keeper may revoke by superseding version. Classification: single-keeper records that move between keepers — still the fast path.

**The rotation record** — *what Comlink reads.* The networking public key with its two counters: the **key counter**, climbing on ordinary rotation, and the **reset counter**, climbing only when continuity starts over. Invariants: counters never descend; a reset zeroes the key counter; the record is authorized by the management capability, never by the keeper's cold key. This is the one tilak the wire reads on every fresh handshake, so it stays the smallest of the five.

**The parent link** — *sponsorship, default with escape.* The chosen parent beside the arithmetic default. Invariants: escape rewrites the link at the child's word alone; the arithmetic default is derivable and therefore never stored; an orphaned link falls back to the default. Readers: Comlink for routing courtesy; nobody for permission.

## The Rival, Weighed Where It Bites

The bare-keys shape — identity as keys alone, no ledger, no scarcity — wins outright on three of the five: it needs no point record, no parent link, and no bind, because the key *is* the name. It loses exactly where the ledger earns its keep: **transfer** (a bare key cannot be sold or inherited without becoming someone else), **healing** (a stolen bare key is a stolen name forever; the rotation record heals ours while the deed sleeps), and **pricing trust** (scarcity plus sponsorship is what makes an unknown caller worth answering). The design therefore keeps both lanes open at the seam: the bind accepts a bare Kumara key as a first-class citizen, and the ledger adds transfer, healing, and trust *on top* — membership by degree, never a wall. Whether Grain's network requires the ledger tier or merely offers it is a shape-of-the-network word, held with the scarcity question for Keaton.

## The Candidate Names — Held Whole

| Shape | Candidate tilak name | Held because |
|---|---|---|
| the point record | `point` | wire vocabulary |
| the bind | `bind` | wire vocabulary |
| management capability | `tend` | wire vocabulary · a coin |
| spawn capability | `sow` | wire vocabulary · a coin |
| transfer capability | `hand` | wire vocabulary · a coin |
| the rotation record | `turn` | wire vocabulary · a coin |
| the parent link | `sponsor` | wire vocabulary |

Seven rows, zero seated. The day Keaton words them, Arc III's residents round lands each as one file in `til/` with one pedestal in `sur/` — and not an hour before.

## What Paper Three Takes

The onboarding story: a pilot with only an internet connection and a fresh keypair, walked to a bound point in their own jurisdiction's terms — the `JURISDICTION` block instantiated, the custody park stated on every page, and every step Acme-generic so the walk reads the same from any county on Earth.

---

*May the seam stay one sentence wide, the five shapes stay small enough to read aloud, the rival keep us honest at every row — and may the names arrive in Keaton's voice, exactly when they are ready to be worn.*
