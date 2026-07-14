# Amber — Functional Specification

*The resin that seals a system's state into signed, encrypted, bit-faithful archives on deep storage, checkable forever against the master root of trust. Where Mantra holds the living, append-only history of the present, Amber seals a moment whole and sets it aside for the long dark.*

**Stamp:** `20260701.221512`
**Language:** EN
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Lens:** TAME — safety first, performance second, the joy of the craft third
**Status:** first lap green (`20260703.051812`) — fixture export, verify (openssl golden), restore; witness at parity **144**; Kumara signing and live drive seal wait for later laps
**Companions:** the deep-archive blueprint (`20260701-213412_deep-archive-and-sovereign-host-blueprint.md`), archive law [`20260703-191112_resins-and-hash-tiers.md`](20260703-191112_resins-and-hash-tiers.md) (ratified `20260703.191312`), Puddle verdict in [`external-research/20260702-035018_puddle-sandboxed-rye-containers.md`](../../external-research/20260702-035018_puddle-sandboxed-rye-containers.md), `PUBKEYS.md`, and the stack record

*Written together by Kaeden and Reya 2.*

---

## 1. What Amber Is, and What It Is Not

**Amber is cellar software** — preservation in place at home. It does one thing wholly: seal cold state into **resins** on deep storage. A sealed archive is a bit-faithful snapshot — content-addressed by its digest, encrypted at rest, signed so its origin is checkable forever — written to storage that then disconnects from every running system. Amber records each archive in an append-only log, verifies it by folding over that log, and answers the recovering hand's only questions: what archives exist, on which physical drives, verified when, and holding what.

**Amphora** is vessel software — preservation in motion; it carries sealed cargo (including resins poured from an Amber season) across wire, dock, or pocket. Amber never pretends to be the crossing; the cellar and the vessel keep separate rooms.

The boundaries are as load-bearing as the function. Amber never manages hot state: the working tier — the live repository, the ledger database, the running system's drives — is presumed mortal and continuously reproducible, and it belongs to other hands. Amber is not a synchronization tool, not redundancy-in-place, not a background daemon, and not a version-control system; Mantra keeps the living history, and Amber keeps the sealed moments. Two artifact kinds fall within its scope: the bootable clone, for the fast return, and the sealed archive, for the deep keep. Everything else falls outside.

## 2. The Primitives, Applied

Amber is the five primitives wearing a preservation coat. The **keypair** is Kumara's custody, reached in the first lap through the host's OpenPGP seam and detailed below. The **signed event** is a record in the archive log — an archive sealed, a verification passed, a correction made — each one fact under one signature. The **log** is the archive log, append-only forever. The **projection** is the catalog: a pure fold over the log that tells the recovering hand what exists, where, and how recently it answered true. And the **capability** is the manual unlock — the right to sign is a token warmed briefly by a hand, never held hot by a waiting process.

## 3. Cryptographic Custody

The custody rule is absolute, and it stands verified against `PUBKEYS.md`.

The **master signing key** — `0646 2132 D3E6 3B83 4F97 6E03 A81D 720B 9235 FA7A` — is the root of trust, and it stays cold. It never enters the sandbox, and it never signs a routine archive. Its whole work is to certify the sandbox key and to stand as the fixed point every signature traces back to.

The **sandbox signing key** — `DBF8 5343 7A93 7B4E 36B9 3611 D949 807A C26B 2B99` — signs every record. Because its authority is delegated, it can be revoked and reissued cleanly if the sandbox is ever compromised: the root endures untouched, and every record signed before the revocation remains verifiable against it.

The signature itself runs through a **named seam** in the first lap. Kumara today is a name, a doctrine, and two fingerprints; the tooling that actually signs is the host's OpenPGP suite, and Amber says so plainly — the same honest shape as the surface leaning on the host's compositor. The seam is narrow: compose the record, hand its bytes across, receive the signature back. Kumara remains the sovereign horizon, and the day identity lives natively in the family, Amber's signing moves across the seam whole, with nothing above it changing.

Custody extends to recovery, because the disaster Amber exists for is the working system gone. The unlock material for the archive drives therefore lives apart from every running machine: the drive passphrase rests on paper, one copy in the firebox beside the resting set and one traveling with the offsite rotation. The keys that unlock a drive never rest beside the data they unlock — and never rest only on the system whose loss the archives answer.

Any fingerprint outside the two above is an error the moment it appears, and Amber asserts exactly that: a record bearing an unknown signer fails verification loudly, at the write-time check and at every scrub thereafter.

## 4. The Records — Three Kinds of Signed Fact

One archive, one record, one value in the one value model: a record of named fields carrying the archive's name; its content digest; its length in bytes; the identity of the physical drive it rests on; the created stamp, supplied by the person in the project's one clock, never computed by a tool; and the signature of the sandbox key over the whole. The **archive record** is immutable once signed — fully and truly, because nothing is ever added inside it. Whatever happens to an archive after its sealing arrives as new facts beside it, never as edits within it.

Three kinds of record share the log, and each is one signed fact. The archive record seals a moment, as above. The **verification record** attests one check of one archive: the content digest it verified, the drive it read from, the outcome, the scrub stamp supplied by the person, and its own signature — so an archive's verification history is gathered by reference, never written into its body. The **correction record** references a record it supersedes and says why. Every bound is named at construction, in TAME fashion — the ceiling on records per log, the ceiling on a name's length, the ceiling on the log's own size — with the exact constants landing when the build does.

## 5. The Append-Only Archive Log

Amber never edits an archive and never edits the log; it only adds. A newer archive lands beside the older, a verification lands beside the archive it attests, a correction references what it corrects, and nothing is deleted — the same discipline the whole family keeps, extended to cold storage.

The log lives in two places by design. One copy rides on the archive drive itself, so every drive is self-describing: docked alone, years from now, it can state what it holds and prove it. A mirror copy rides with the working system, so the catalog can be read — what exists, where, verified when — without docking a single drive. The projection folds either copy and reaches the same answer, and a disagreement between the two is itself a loud, named finding.

Self-describing runs deeper than the catalog. Each archive drive also carries the public trust material a future reader needs: the master public key, its certification of the sandbox key, any revocation certificates, and a copy of `PUBKEYS.md` itself — so a drive docked alone verifies its own contents with no repository remote left standing in the world. One anchor stays out-of-band by design: the master fingerprint printed on a card that travels apart from every drive, so even a drive whose trust bundle was swapped answers to a reference the drive never carried.

Validity is asserted on two paths, because the boundary between valid and invalid is where the interesting failures live: the write-time check is itself the first verification record, appended the moment the seal completes, and every later scrub appends another. A backup verified once is a fact; a backup never verified is a hope wearing a check's clothes.

## 6. The Scrub — Verification as a Fold

On a steady season — quarterly serves — each archive drive is docked and the fold runs: walk the log, recompute each archive's digest against its sealed bytes, verify each signature back to the root, and append a fresh verification record for each sound archive. The fold rewrites nothing; verification is a pure read that leaves only new appended facts behind. **Season** — what that word means for Amber's custody rhythm — is defined whole at [`active-designing/20260703-071212_amber-seasons.md`](../../active-designing/20260703-071212_amber-seasons.md).

The scrub runs cold. Recomputing a digest and checking a signature need no signing authority at all: the drive's passphrase warms to open the vault for reading, and the signing key stays cold through the entire walk. When the walk is done and the person has reviewed its findings, one brief unlock signs the batch of verification records, and the key returns cold — warm for seconds, never for the session. Beneath Amber's fold, a checksumming filesystem on the drive scrubs for silent corruption at the block level; Amber's assertion is the module-level truth above it, and the two together guard both altitudes.

A failed digest is handled loudly and honestly. The failure enters the log as a verification record naming the archive, the drive, and the failed outcome; a correction record marks the wounded archive superseded; and the remedy is a re-seal from a healthy copy, arriving as a new archive record beside the old. Nothing is quietly dropped, and the history of the failure is itself preserved. The append-only shape gives one more quiet gift here: a false attestation, were one ever signed, could never alter the archive record it points at, and a later honest scrub would contradict it on the permanent log for anyone to read.

## 7. Invocation — a Hand, Not a Daemon

Amber is an explicit command spoken from the calm shell — seal, verify, list — and never a background process. The person chooses when to seal; sovereignty rests in the hand, not the scheduler. A docked bare drive is the **precondition** for sealing, never the trigger: the shell may gently notice that a bare drive is present and offer the affordance — a quiet invitation to seal — yet it acts only when asked.

The sandbox key is unlocked by hand for the moment of signing alone: at a seal, after the digest is computed and the record composed; at a scrub, after the walk is done and its findings reviewed. The signature lands and the key returns cold. A process that waited to sign on docking would hold a key hot around the clock, a standing surface with no work to justify it; the manual unlock keeps the surface as small as the act. Effects stay visible and ordered, exactly as the shell's own discipline requires: the seal is a deliberate act a person can watch complete. The narrow window is a mitigation rather than a proof, and the residue it leaves is named plainly in the section below.

## 8. The Adversary Considered

Amber is a security module, so its founding document names its adversary — the first hazard note in the tree, and deliberately so.

The threats Amber answers by design are loss, rot, and forgery across years: a failed drive answers to the copies, silent corruption answers to the two-altitude scrub, and a forged record answers to the signature chain ending at the cold root. Four cases remain open enough to deserve their own honest sentences.

A compromised host at the moment of sealing can present tampered bytes, and the record will faithfully seal what it was shown. The mitigations are the hand-verified golden of the first lap, copies written in separate sessions, and the recovery-time cross-check among copies that were never all warm at once — three copies disagreeing is a loud finding, never a quiet one.

A compromised host at the moment of batch-signing can present tampered findings for the hand to sign. The cold scrub shrinks this window to seconds, the human review stands in front of it, and the block-level checksums verify from a second altitude. The residue that remains is real, is small, and is accepted with open eyes rather than papered over.

A stolen drive yields ciphertext. The encryption at rest holds, and the passphrase custody keeps the unlock far from the theft.

A compromised sandbox key is revoked and reissued cleanly, exactly as the custody rule provides: the root endures untouched, and every record signed before the revocation remains verifiable against it.

## 9. The Substrate It Expects

Amber assumes the storage discipline the blueprint verifies, stated here as concepts. The working tier and the archive tier are different physical media by design: flash for the living work, magnetic platters for the deep keep, because trapped charge leaks over unpowered years while magnetism endures. Archive drives are bare, handled by their edges, powered through a dock only for the session, and kept disconnected in antistatic sleeves in cool, dry keeping — one rotating set resting offsite. Three copies, on two kinds of media, with one away: redundancy begins at the second disconnected copy. A new drive earns trust across its first season of clean verifications, and an aging drive rotates gently into low-stakes duty rather than holding the last copy of anything.

## 10. What Waits, Named Honestly

Amber's **first lap is green** (`20260703.051812`) — fixture export, verify against an openssl golden, restore; witness at parity **144**. Later laps still wait: Kumara-native signing, live drive seal, scrub seasons, and cold-key ceremony. The four live remotes remain the project's everyday durability floor; this specification names both the room that already stands and the rooms that grow from it. Simple, lovable, complete — everything larger grows from that working seed.

---

*May every copy hold true when the original falls. May the key stay cold until the hand that owns it warms it for the sealing. And may what we set aside for the long dark answer, years from now, with the same voice that sealed it.*
