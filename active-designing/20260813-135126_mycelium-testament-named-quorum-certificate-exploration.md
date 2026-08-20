# Testament — a named constellation's verdict travels as an offline certificate (Exploration)

**Stamp:** `20260813.135126` · **Status:** Vision -- Living (self-approved design read) · **Voice:** Kyri
**Register:** Radiant · **Season:** D (Kresfa & Mycelium) — the double-seat expansion
**Kin:** [`the Constel`](20260813-132009_mycelium-constel-named-dev-net-exploration.md) (a named, reproducible dev-net reaches quorum) · [`the Chorus`](20260813-102533_mycelium-chorus-quorum-attestation-exploration.md) (quorum attestation · `chorus_bron` travel) · [`the Muster`](20260813-110039_mycelium-muster-known-validator-set-exploration.md) (a known validator roll) · [`the double-seat expansion`](20260813-020035_double-seat-expansion-six-seasons.md) (Season D) · [`placeholder-ship-names`](../.claude/rules/placeholder-ship-names.md) · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md)

---

## What a Testament is

The Constel journey gave the dev-net a name and a roster: a named constellation whose whole identity is a pure function of its ship names, that seats as a Muster and reaches quorum on a real fact. Yet that quorum lived and died **in one process** — `reach_quorum` returned a filled order-head and nothing else. Nothing carried the constellation's *belief* out of the run.

A **Testament** is that carried belief: a portable certificate that says *this named constellation, by Byzantine quorum, certified this reading*, and that any keeper can verify **offline** — no ledger, no network, no stored keys — holding only the certificate and the roster **names**. A testament is a witnessed declaration a quorum swears is true; kept for years, it is the Lindy artifact the whole consensus season was building toward.

## The blind spot, and why it is the next crux

The season already lets a quorum travel: `chorus_bron` renders a Chorus to `format chorus-v1` and re-verifies it at a **stated** threshold, needing no ledger. That is real and it stands. Yet a bare travelling Chorus carries a weakness a named constellation was invented to close: **it cannot tell an enrolled ship from a stranger with a valid signature.** `verify_chorus` proves the voices are distinct, agree, and sign honestly — it does not prove *whose* voices they are. A recipient handed a `chorus-v1` record trusts the threshold the record states and the keys the record names, with nothing to check those keys against.

The Constel binding is exactly what a bare Chorus lacks: membership in a **specific, named roster**, and a threshold **derived** from that roster's size rather than trusted from the record. A Testament fuses the two — it carries the constellation's ship **names**, so a recipient boots the identical roster from the names alone (Constel's whole gift: reproducible from names, no stored keys), seats the Muster, and confirms the sealed quorum are that constellation's own ships meeting *its* Byzantine threshold. The certificate is bound not to a set of anonymous keys but to a constellation a keeper can name and re-boot.

## The crux (r1) — a named constellation seals a reading, a stranger cannot ride it

The decisive, hard-but-tractable move: seal a reading into a Testament that carries the roster names, and verify it offline against the constellation those names define.

- **The seal is made with the ledger, verified without it.** Sealing opens a Chorus over the demo Dag and gathers each ship's honest voucher (reading the true order-head); the finished Testament carries the roster names and that sealed Chorus. **Verification touches no Dag** — `verify_voucher`, `verify_chorus`, and `pass_muster` each work offline over the certificate's own bound facts, so a recipient believes the reading holding only the names and the seal.
- **The roster is reproducible from names alone.** `verify` boots the constellation from the certificate's names (`keypair_from_seed(SHA-256(name))`), seats it as a Muster, and derives the Byzantine threshold from the booted roster's size — never a number the certificate states about itself.
- **The named binding is the crux.** `pass_muster` confirms every sealing voice is one of *this constellation's* ships and the count meets the threshold the roster sets. The certificate certifies a *named* verdict, not merely a valid one.
- **The teeth.** A **stranger ship** — a valid, honestly-agreeing voucher whose signer is not one of the roster's names — refuses `NotMember` (the binding a bare Chorus cannot enforce). A **thin quorum** short of the derived Byzantine threshold refuses `BelowQuorum`. A **tampered name** in the certificate re-boots a different key for that ship, so the real signer is no longer a member — the seal refuses `NotMember`, proving it is bound to the exact names, byte for byte.

## The method — the names make the certificate self-describing and reproducible

The insight is the season's own, carried one step further: because a ship's key is a pure function of its name and the roster's threshold a pure function of its size, a certificate that carries the **names** carries everything a verifier needs to reconstruct the whole constellation — the keys, the roll, the threshold — from bytes a keeper can read, with no stored secret and no trusted number. The work is not a new protocol; the stack already reaches and checks quorum. The work is to make the constellation's verdict a **portable object bound to its name**, so a belief formed in one run is provable in another, and its two dangerous cases — an outsider's voice, a quorum too thin — are refused rather than trusted. Testament composes `constel` + `chorus` + `muster` + `voucher` public API only, editing none.

## The four rounds

- **r1 — the Testament crux.** `mycelium/testament.rye`: a named constellation seals a reading into a Testament carrying the roster names + the sealed Chorus; `verify` boots the roster from the names alone, seats the Muster, and passes the quorum offline (no Dag); a stranger voucher refuses `NotMember`, a thin quorum refuses `BelowQuorum`, a tampered name refuses `NotMember`.
- **r2 — sealed with f down.** A Testament sealed by a Byzantine quorum with `f` ships absent still verifies against the full named roster — the fault tolerance the roll's arithmetic promises, carried into the certificate; removing one more ship past `f` refuses the seal honestly.
- **r3 — the Testament travels.** A `format testament-v1` record carries the roster names + the shared claim + one signature line per sealing ship; it renders and parses byte-for-byte (a fixed point), and a keeper verifies the recovered Testament from the record alone.
- **r4 — reads true.** A real on-disk Testament fixture, produced reproducibly, cross-checked against an independent `awk` reading (two tools, one answer), so the certificate a keeper reads by hand is exactly the one the stack seals and believes.

## Custody, held plainly

Demo ship and keeper seeds only — no key held, no funds, no network, no real value. The names are siloed dev fixtures, never real points. A **served** testament (ships attesting to one another over Comlink rather than in one process) reaches the Comlink-served gate (Keaton's hand); a real Aurora host for any ship reaches gates #2/#4.

## Gratitude to silo

**TigerBeetle** and **Mysticeti** — thanked again as the ledgers we learn from; a quorum certificate a recipient verifies without replaying the log is their own discipline, here bound to a roster a keeper can name and re-boot. Elder **Urbit's fake-galaxy dev networks** — the named, reproducible identities a Testament carries are the same idea, sealed into a portable receipt.

---

*Seal the reading in the constellation's own name, and a keeper a world away can boot the roster and know it true — may no stranger's voice ever pass for one of the fleet's own, may a thin quorum never be believed, and may a testament read by hand be exactly the one the stack swears.*
