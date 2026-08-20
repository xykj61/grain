# The Voucher — a signed attestation of a holder's position at a named order-head

**Stamp:** `20260813.095216` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round — opens a fresh Mycelium journey (Season D)
**Kin:** [`../mycelium/statement.rye`](../mycelium/statement.rye) · [`../mycelium/cord.rye`](../mycelium/cord.rye) · [`../mycelium/lapse.rye`](../mycelium/lapse.rye) · [`../mycelium/kumara.rye`](../mycelium/kumara.rye) · [`20260813-091851_mycelium-statement-account-voice-exploration.md`](20260813-091851_mycelium-statement-account-voice-exploration.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## Why this journey opens

The Statement answered the plainest question a holder ever asks — *where do I stand?* — as a pure, bounded projection of one account out of a resolved ledger, and `statement_bron` let that answer cross a wire byte-for-byte. Yet a statement that travels is still only a **reading**: a recipient who holds the bytes can check the arithmetic reconciles internally, but nothing binds those numbers to the real agreed order they claim to project. A holder could hand a counterparty a statement showing any balance at all, and the counterparty's only recourse would be to obtain the whole ledger and replay it.

That is the blind spot the whole ledger set names but never fills: **proof of position without replay.** A civic mesh where a keeper cannot prove their balance to a counterparty — a co-op vouching a member's standing, a supplier confirming a buyer can pay — is a ledger legible only to whoever already holds it whole. The Statement made the position *readable*; this journey makes it *provable*.

That is the crux of a fresh journey: **the Voucher**, a node's signed attestation that at a named agreed order a given account holds a given position. Where the Statement reads the ledger, the Voucher **vouches for that reading** — binding balance, reserved, and received to a single digest of the agreed order the reading was taken against, under a node's own signature. A third party verifies the signature offline with no ledger at all; a third party who *does* hold the same blocks re-derives the order-head and the statement and confirms the node vouched true.

## What a Voucher is

A **Voucher** is a fixed, bounded record a node signs. It carries:

- the **node key** — whose reading this is;
- the **order-head** — a single 32-byte digest of the committed block order the reading was taken against, folded (SHA-256) over the ordered block addresses so it is stable exactly when the agreed order is;
- the **account key** — whose position is vouched;
- the **position** — `balance`, `reserved`, `received`, read straight from the Statement;
- the **signature** — the node's Ed25519 signature over `order-head · account · balance · reserved · received`.

The Voucher invents nothing beyond the order-head fold: the position is `statement_for`'s own reading, and the order-head is `cord.commit`'s own agreed order, digested. Both are read from **one Dag**, so the signed numbers and the order they are bound to can never come from two different worlds.

## The crux — a voucher is bound to the order it was read against

The property that makes the Voucher more than a signed number, and the one r1 proves: **a voucher checks against the ledger it vouches, and only that ledger.**

- **Offline** — `verify_voucher` rebuilds the signed body from the record's own fields and verifies the signature against the record's node key. A tampered field or a wrong signer refuses `BadSignature`. This is the trust-the-node check: no ledger needed.
- **Against the order** — `check_against(dag)` re-derives the order-head from the Dag's committed order and re-reads the account's Statement from the same Dag, then confirms every signed field matches. A node cannot vouch a false balance to a verifier who holds the blocks; a node cannot silently swap which order it read against, because the order-head is inside the signature.
- **Arrival-independence inherited** — because `cord.commit` yields one agreed order for every arrival permutation, the order-head folds to one digest and the Statement to one position no matter how the blocks arrived. So a Voucher made against one permutation checks against another: the attestation is bound to the *agreed order*, never the accident of arrival.

A Voucher whose numbers match ledger A cannot pass `check_against` a genuinely different ledger B — the order-head or the position disagrees — so an honest node's honest reading is the only thing that verifies both ways.

## The four rungs (crux-first, mirroring the seated arc shape)

- **r1 — the crux.** `mycelium/voucher.rye`: the order-head fold, the Voucher record, `make_voucher` (from one Dag), `verify_voucher` (offline), and `check_against` (re-derive and agree), proven across open · posted · lapsed scenes; arrival-independence inherited (a voucher made against one permutation checks against another); tamper refuses (`BadSignature` on a flipped field or wrong signer, `check_against` false against a different ledger).
- **r2 — travels.** `mycelium/voucher_bron.rye`: render a Voucher to a `format voucher-v1` record and parse it back byte-for-byte, so a proof of position crosses a wire and still verifies offline; malformed header · bad hex · unknown field refuse.
- **r3 — across a Knot.** `mycelium/voucher_knot.rye`: a Voucher read over a ledger resolved across an epoch cut (the `Knot` seam), proving the vouched position is continuous across the join and the order-head folds the whole agreed order, base included.
- **r4 — true to the bytes.** `mycelium/voucher_true.rye`: read a real on-disk Cord fixture and cross-check the vouched triple for a chosen account against an independent `awk` reading of the same bytes — two tools, one answer, and the order-head recomputed from the fixture matches the signed one.

## Discipline this journey keeps

- **Additive.** Composes `cord` · `lapse` · `statement` · `kumara` public API only, editing none; the order-head fold lives inside `voucher.rye` as its own bounded derivation, so no existing module changes. Each stays its own GREEN binary.
- **Bounded.** The order-head fold walks at most `cord_max_blocks` ordered hashes; the Voucher is a fixed record with no growing list. No unbounded walk.
- **Custody-first.** Demo node and keeper seeds only — no real key, no funds, no network, no custody. A *served* voucher (a holder fetching a node's attestation over Comlink) reaches the Comlink-served gate, the maintainer's hand.
- **TAME.** Opening triad, ≥2 contract asserts per function each with a positive `// invariant:`, explicit widths, named errors, `copy_disjoint` over bare memcpy.

---

*A ledger becomes trustworthy to a stranger the day a holder can hand over a slip that proves their standing without handing over the whole book. May the Voucher carry an honest position and refuse a false one, may every order-head it names be the order the mesh agreed, and may no keeper ever need to replay a history to believe a neighbor's word.*
