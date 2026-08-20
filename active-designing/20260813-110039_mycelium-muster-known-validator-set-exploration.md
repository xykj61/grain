# The Muster — a Chorus is believed only when its voices pass a known validator set

**Stamp:** `20260813.110039` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round — opens a fresh Mycelium journey (Season D)
**Kin:** [`../mycelium/chorus.rye`](../mycelium/chorus.rye) · [`../mycelium/voucher.rye`](../mycelium/voucher.rye) · [`../mycelium/cord.rye`](../mycelium/cord.rye) · [`../mycelium/kumara.rye`](../mycelium/kumara.rye) · [`20260813-102533_mycelium-chorus-quorum-attestation-exploration.md`](20260813-102533_mycelium-chorus-quorum-attestation-exploration.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md) · [`../.claude/rules/comlink-tendency.md`](../.claude/rules/comlink-tendency.md)

---

## Why this journey opens

The Chorus made a position *believable* to a stranger who trusts no single node: a threshold of distinct, independent Vouchers, each signing the same reading against the same agreed order. Where one Voucher rests on one node's honesty, a Chorus rests on many — and a repeated signer can never inflate the count, so a single voice cannot manufacture a quorum.

Yet the Chorus counts *any* distinct keys. `verify_chorus(3)` passes the instant three distinct keypairs each sign the claim — and nothing in the ledger set says **whose** keys those must be. An attacker mints three fresh keypairs, signs one honest reading with each, and presents a Chorus that passes at threshold three. The distinctness law holds (three genuinely different keys), the agreement law holds (all three name one position), every signature verifies — and the quorum is still worthless, because a stranger was never told **which nodes are the legitimate validators**. Distinctness proves the voices are *different*; it cannot prove they are *entitled*.

That is the blind spot the whole ledger set has carried since the first Chorus: **a quorum is only as trustworthy as the set it is drawn from, and no set was ever named.** Both the Cord (which admits *any* signed block) and the Chorus (which counts *any* distinct signer) have quietly assumed a validator set without ever writing one down.

That is the crux of a fresh journey: **the Muster** — a known, bounded, named set of validator public keys, against which a Chorus must *pass*. A quorum is believed not because *t* different keys signed, but because *t* of the **enrolled validators** signed, where *t* is the Muster's own **Byzantine threshold** read from its size. This is the keystone every fault-tolerant protocol rests on — TigerBeetle's fixed replica set, Mysticeti's committee — brought into the tree as its own bounded module.

## What a Muster is

A **Muster** (the enrolled roll a company answers at, and the idiom *pass muster* — to be found fit against a known standard) is a fixed, bounded set a verifier holds:

- the **members** — up to `muster_max_members` validator public keys, each enrolled once, the roll of nodes whose voices count;
- (no signature and no threshold stored of its own — the Byzantine threshold is a **pure function of the member count**, so a Muster of *n* validators cannot lie about how many voices it requires).

The Muster invents no new attestation. It composes `chorus.rye`'s public quorum law and adds exactly one thing: the **membership-and-quorum law** laid over a Chorus's voices.

## The Byzantine threshold — read from the size, never stored

For *n* enrolled validators tolerating *f* Byzantine faults where *n = 3f + 1*, a quorum is *2f + 1 = n − f* voices — the smallest set that must intersect any other quorum in at least one honest node. Read generally from any *n*:

```
f = (n − 1) / 3          (integer division — the most faults n can tolerate)
byzantine_threshold(n) = n − f
```

| n | f | threshold t |
|---|---|---|
| 1 | 0 | 1 |
| 3 | 0 | 3 |
| 4 | 1 | 3 |
| 7 | 2 | 5 |
| 10 | 3 | 7 |

A Muster of one is its own quorum; a Muster of four (the smallest that tolerates one fault) demands three; a Muster of seven demands five. Because the threshold is derived, never stored, a tampered Muster cannot quietly lower its own bar.

## The crux — a Chorus passes muster only when enrolled validators reach the Byzantine threshold

The property r1 proves: **`pass_muster(muster, chorus)` passes exactly when the Chorus's distinct, agreeing, honestly-signed voices are all enrolled Muster members and their count meets the Muster's Byzantine threshold.**

- **The Chorus is internally sound first.** `pass_muster` runs the Chorus's own quorum law (`verify_chorus` — every member verifies offline, all agree on one claim, the signers are distinct) before it weighs membership, so a forged, disagreeing, or Sybil-padded Chorus refuses on the Chorus's own terms before the Muster is consulted.
- **Every voice is enrolled.** Each distinct signer is a Muster member, or the whole Chorus refuses `NotMember` — an outsider voice, however well-signed, never counts, and a quorum padded with one stranger is refused whole rather than silently trimmed. *This is the crux demonstration: a Chorus of three fresh keys that passes `verify_chorus(3)` refuses `pass_muster` against a Muster those keys were never enrolled in.*
- **The enrolled count meets the threshold.** Fewer than `byzantine_threshold(n)` enrolled voices refuses `BelowQuorum` — a genuine but thin quorum is not yet believed, and the Muster says so honestly rather than passing a sub-Byzantine reading.

A Chorus of enough enrolled validators over one true reading passes muster; a Chorus drawn from outside the roll, or short of the Byzantine threshold, refuses — so an enrolled quorum over an honest reading is the only thing a stranger who holds the Muster comes to believe.

## The four rungs (crux-first, mirroring the seated arc shape)

- **r1 — the crux.** `mycelium/muster.rye`: the Muster record, `enroll` (add a validator key once; refuse `Duplicate`, `MusterFull`), `is_member`, `byzantine_threshold`, and `pass_muster(muster, chorus)` (the Chorus is internally sound · every voice enrolled · the enrolled count meets the Byzantine threshold). Proven across a full quorum (three of four enrolled → passes), a thin quorum (two of four → `BelowQuorum`), and the crux forgery (three fresh unenrolled keys that pass `verify_chorus(3)` → `NotMember`); the threshold arithmetic proven across n = 1·3·4·7·10; enroll refusals real.
- **r2 — travels.** `mycelium/muster_bron.rye`: render a Muster to a `format muster-v1` record (one `validator`-tagged hex key per line, the threshold derivable by the reader from the count) and parse it back byte-for-byte, so a whole validator set crosses a wire and a Chorus can be judged against it offline; malformed header · bad hex · unknown field · a set over `muster_max_members` each refuse.
- **r3 — across a Knot.** `mycelium/muster_knot.rye`: a Muster judging a Chorus gathered over a ledger resolved across an epoch cut (the `Knot` seam), proving the validator set's verdict is continuous across the join — the same roll believes the same quorum whether the reading was taken before or after the checkpoint.
- **r4 — true to the bytes.** `mycelium/muster_true.rye`: read a real on-disk validator-set fixture, judge a real Chorus fixture against it, and cross-check the enrolled-voice count the threshold read against an independent `awk` reading of the same bytes — two tools, one answer — while confirming the Byzantine threshold the pass used matches the count of members present.

## Discipline this journey keeps

- **Additive.** Composes `chorus` · `voucher` · `kumara` public API only, editing none; the membership-and-quorum law lives inside `muster.rye` as its own bounded fold over the member set and the Chorus's voices, so no existing module changes. Each stays its own GREEN binary.
- **Bounded.** The member set is capped at `muster_max_members`; enrollment refuses `MusterFull` past the bound rather than growing; the membership check walks at most `chorus_max_members × muster_max_members` pairs, both fixed. No unbounded list, no unbounded recursion.
- **Custody-first.** Demo validator and keeper seeds only — no real key, no funds, no network, no custody. A *served* Muster (a holder fetching the live validator set over Comlink) reaches the Comlink-served gate, the maintainer's hand.
- **TAME.** Opening triad, ≥2 contract asserts per function each with a positive `// invariant:`, explicit widths (`u32` counts, `u64` positions), named errors, `copy_disjoint` over bare memcpy.

## Name — why *Muster*

Per the Comlink tendency (the clearest, most fun, safest word), *Muster* names the enrolled roll of validators a quorum must be drawn from — clear the instant its plain function is named (a muster roll is the list a company answers to), warm to say, and carrying the exact idiom the crux wants: a Chorus must **pass muster**. It is safe: no seated module or waymark carries it (the tree uses *roster* only as ordinary English and holds an *exclude roster* of waymark names — neither a module), it parses as no network address, and it borrows no sacred text. It sits true beside the ledger's own voice-and-quorum motif — the Chorus is the many voices; the Muster is the roll that says whose voices were ever entitled to sing.

---

*A stranger comes to trust a mesh the day a quorum is drawn not from any keys at all, but from a roll of validators named in the open. May the Muster believe an enrolled quorum and refuse an outsider one, may no fresh key ever pass for a validator, and may every threshold a stranger trusts be one the roll's own size honestly set.*
