# The Chorus — a quorum of independent Vouchers, a position believed when distinct nodes agree

**Stamp:** `20260813.102533` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round — opens a fresh Mycelium journey (Season D)
**Kin:** [`../mycelium/voucher.rye`](../mycelium/voucher.rye) · [`../mycelium/statement.rye`](../mycelium/statement.rye) · [`../mycelium/cord.rye`](../mycelium/cord.rye) · [`../mycelium/kumara.rye`](../mycelium/kumara.rye) · [`20260813-095216_mycelium-voucher-attested-statement-exploration.md`](20260813-095216_mycelium-voucher-attested-statement-exploration.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md) · [`../.claude/rules/comlink-tendency.md`](../.claude/rules/comlink-tendency.md)

---

## Why this journey opens

The Voucher made a holder's position *provable* — a node reads an account's Statement out of a Dag and signs it, bound to the order-head the reading was taken against. A stranger with the bytes verifies the signature offline; a stranger holding the blocks re-derives the head and the Statement and confirms the node vouched true. That is proof of position without replay, and it is real.

Yet a Voucher rests its whole weight on **one** node's honesty. A verifier who does not hold the blocks — the ordinary case for a civic mesh, where the point of a proof is precisely that you need not obtain the whole ledger — must simply trust that the single signing node read the ledger faithfully. One node can sign a position it never honestly derived; the offline check confirms the signature is well-formed, not that the reading was true. That is the blind spot the whole ledger set has carried since the first Voucher: **a single attestation is only as trustworthy as its single author.**

That is the crux of a fresh journey: **the Chorus**, a bounded quorum of independent Vouchers — many nodes' voices — for the *same* account position at the *same* order-head. Where the Voucher is one node's word, the Chorus is a threshold of independent words that agree; a stranger who trusts no single node can trust that *t* distinct nodes, each signing on its own, all read the same position against the same agreed order. This is the fault-tolerant heart the Mycelium consensus vision named (improving on TigerBeetle's and Mysticeti's quorum discipline): a reading believed not because one node asserted it, but because a quorum sang it.

## What a Chorus is

A **Chorus** is a fixed, bounded gathering a verifier reads. It carries, plainly named on first use:

- the **claim** — one order-head, one account key, one position (`balance`, `reserved`, `received`) — the single reading the quorum is asked to attest;
- the **members** — up to `chorus_max_members` Vouchers, each an independent node's signed slip;
- (no separate signature of its own — a Chorus invents no new attestation; its trust is exactly the sum of its members' Voucher signatures, gathered).

The Chorus adds nothing a Voucher did not already carry. It composes `voucher.rye`'s public API only — each member is made by `voucher.make_voucher` and verified by `voucher.verify_voucher` — and its whole contribution is the **quorum law** laid over that set.

## The crux — a position is believed when a threshold of distinct nodes agree

The property that makes the Chorus more than a bag of vouchers, and the one r1 proves: **`verify_chorus(threshold)` passes exactly when at least `threshold` distinct, independent nodes have each honestly signed the one claimed reading.**

- **Every member verifies.** Each member Voucher's signature holds offline against its own node key (`voucher.verify_voucher`), or the Chorus refuses `BadSignature` — one forged voice spoils the reading, never silently dropped.
- **Every member agrees on one claim.** Each member names the same order-head, the same account, and the same `balance`/`reserved`/`received` as the Chorus claim, or it refuses `Disagreement` — a quorum attests one position, never a blur of several.
- **The signers are distinct.** No node key counts twice. A node signing the same claim ten times is one voice, not ten — the distinct-signer count is what the threshold reads, so one node can never manufacture a quorum. A repeated signer refuses `DuplicateNode` (the storm-proof crux: Sybil-by-repetition cannot inflate belief).
- **The count meets the threshold.** Fewer than `threshold` distinct honest agreeing voices refuses `BelowThreshold` — the reading is not yet believed, and the Chorus says so honestly rather than passing a thin quorum.

Then, for a verifier who *does* hold the blocks, **`check_against(dag)`** re-derives the order-head and re-reads the Statement from the given Dag once and confirms the Chorus's single claim is the true one — reusing exactly the Voucher's own `check_against` property, now asserted for the whole quorum at one cost. **Arrival-independence is inherited**: because `cord.commit` yields one agreed order per arrival permutation, every honest member folds to the same order-head and reads the same position, so a Chorus gathered against one permutation verifies and checks against another. The quorum binds the *agreed order*, never the accident of arrival.

A Chorus of honest distinct nodes over one true reading passes at its threshold and checks against the ledger it vouches; a Chorus one voice short, or padded with a repeated signer, or carrying one disagreeing or forged member, refuses — so an honest quorum over an honest reading is the only thing that a stranger comes to believe.

## The four rungs (crux-first, mirroring the seated arc shape)

- **r1 — the crux.** `mycelium/chorus.rye`: the Chorus record, `gather` (collect a member from each of several distinct node keypairs over one Dag+account), `verify_chorus(threshold)` (every member verifies · every member agrees on one claim · distinct signers · count ≥ threshold), and `check_against(dag)` (the agreed claim is true against the held ledger). Proven across open · posted · lapsed scenes; arrival-independence inherited (a chorus gathered against one permutation verifies against another); refusals real (`BelowThreshold` one voice short, `DuplicateNode` a repeated signer cannot inflate the count, `Disagreement` a member on a different position, `BadSignature` a forged member).
- **r2 — travels.** `mycelium/chorus_bron.rye`: render a Chorus to a `format chorus-v1` record (a `claim` header carrying head · account · position · threshold, then one `member`-tagged `format voucher-v1` block per voice) and parse it back byte-for-byte, so a whole quorum crosses a wire and still verifies at threshold offline; malformed header · bad hex · unknown field · a member whose signature does not verify each refuse.
- **r3 — across a Knot.** `mycelium/chorus_knot.rye`: a Chorus gathered over a ledger resolved across an epoch cut (the `Knot` seam), proving the quorum's agreed position is continuous across the join and every member's order-head folds the whole agreed order, base included.
- **r4 — true to the bytes.** `mycelium/chorus_true.rye`: read a real on-disk Cord fixture, gather a chorus for a chosen account, and cross-check the agreed triple against an independent `awk` reading of the same bytes — two tools, one answer — while confirming the distinct-node count the threshold read matches the members present and each member's order-head recomputed from the fixture matches the signed one.

## Discipline this journey keeps

- **Additive.** Composes `voucher` · `cord` · `lapse` · `statement` · `kumara` public API only, editing none; the quorum law lives inside `chorus.rye` as its own bounded fold over the member set, so no existing module changes. Each stays its own GREEN binary.
- **Bounded.** The member set is capped at `chorus_max_members`; the distinct-signer check walks at most that many keys pairwise; no unbounded list, no unbounded recursion. `gather` refuses `TooManyMembers` past the bound rather than growing.
- **Custody-first.** Demo node and keeper seeds only — no real key, no funds, no network, no custody. A *served* chorus (a holder fetching several nodes' attestations over Comlink) reaches the Comlink-served gate, the maintainer's hand.
- **TAME.** Opening triad, ≥2 contract asserts per function each with a positive `// invariant:`, explicit widths (`u32` counts, `u64` positions), named errors, `copy_disjoint` over bare memcpy.

## Name — why *Chorus*

Per the Comlink tendency (the clearest, most fun, safest word), *Chorus* names a bounded quorum of independent voices agreeing on one reading — clear the instant its plain function is named, warm to say, and safe: no seated module or waymark carries it (it appears only as an unchosen round-history word in the Verse Lexicon note), it parses as no network address, and it borrows no sacred text. It sits true beside the ledger's own **voice** motif — the ledger-voice and the account-voice already read positions; a Chorus is the many voices whose agreement makes a reading believed.

---

*A stranger comes to trust a mesh the day a reading no longer rests on one node's word, but on a chorus of them singing the same true position. May the Chorus believe an honest quorum and refuse a thin one, may no single voice ever stand in for many, and may every position a stranger trusts be one the mesh agreed together.*
