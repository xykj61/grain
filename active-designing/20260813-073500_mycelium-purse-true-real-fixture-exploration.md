# Mycelium Purse r4 — a real per-account double-spend reads true (the arc closes)

**Stamp:** `20260813.073500` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design read for one rung
**Kin:** [`../mycelium/purse.rye`](../mycelium/purse.rye) · [`../mycelium/purse_bron.rye`](../mycelium/purse_bron.rye) · [`../mycelium/purse_knot.rye`](../mycelium/purse_knot.rye) · the mirror [`20260813-064129_mycelium-till-double-spend-exploration.md`](20260813-064129_mycelium-till-double-spend-exploration.md)

---

## Where the arc stands

r1 fixed the Purse's crux — one holder's double-spend decided per account by the agreed
order. r2 let the verdict travel as a `format purse-v1` record. r3 read it across a Knot,
so a per-account ledger runs forever without carrying its whole past unbroken. Each of
those rungs stood over Dags seated in code.

This closing rung carries the reader onto a **real on-disk Cord record** carrying a
genuine per-account double-spend a keeper can open and walk by hand, and proves the one
property the whole purse rests on: **the spent-out holder is true to the bytes.** It is
the exact mirror of `till_true` (the Till's r4), carried from the treasury's single
shared drawer to many private purses.

## The crux — two tools, one answer

The app (`mycelium/purse_true.rye`) parses the real record through `cord_bron`, **rebuilds**
the Dag under `cord.add` (re-verifying every signature), resolves it through `purse`, and
reports the triple **`<loser-hex> <moved> <short>`** — the signer of the spent-out
transfer, the count of transfers that moved coins, the count that came up short. An
independent awk reading of the same bytes (`tools/fixtures/purse_dag_truth.awk`), applying
the simplest honest slice of the agreed order — **per-account balance accounting in
committed file order** — names the SAME spent-out signer and the same counts.

So the loser of a contested purse can never drift from an order a keeper can walk by hand.

## The fixture scene

`tools/fixtures/purse_dag.bron`, produced reproducibly by `mycelium/purse_fixture_gen.rye`
and `@embedFile`-bound through a symlink in `mycelium/corpora/`:

- a demo funder issues a genesis credit of **100 to Alice** (round 0);
- **Alice → Bob 100** (round 1) — the winning transfer, moves her coins;
- **Bob → Dan 40** (round 2) — an uncontested onward move, so `moved` is two, not one;
- **Alice → Carol 100** (round 2, referencing the winner) — Alice's purse emptied in
  round 1, so this comes up **short** (lawful: `100 <= received 100`, she once held it).

The losing transfer is unambiguously the round-2 one referencing the winner, and the two
round-1-and-earlier moves touch disjoint accounts, so the app's full commit tie-break and
the awk's file-order per-account accounting name the **same** loser (Alice) — exactly the
honesty the Till fixture earned with its round-2 spent-out draw. Conservation holds: the
balances (Alice 0 · Bob 60 · Dan 40 · Carol 0) sum to the 100 genesis issued.

## Why the awk is honest here

The awk keys balances by the hex `from`/`to` fields the record already carries — an issue
credits its `body` recipient, a tax moves `amount` from its `signer` to its `body`
recipient when the signer's running balance can pay, else names the signer the spent-out
loser (the first one). This file-order slice is honest on this fixture because the genesis
comes first, the round-1 move is affordable, the onward move touches a different account,
and the only transfer that comes short is the round-2 one — so no ordering choice the awk
lacks (the full commit tie-break) could change which holder loses.

## Discipline

Additive — composes `cord_bron` + `cord` + `purse` public API only (each re-runs GREEN at
the witness door). Siloed, dev-only, demo seeds — no real key, no funds, no network, no
custody. A tampered record refuses `BadFormat`, never read as true. The fixture is
reproducible: the generator re-emits byte-identical bytes.

*One order through the dark, and a keeper can walk the block lines and name the same
spent-out purse the ledger does. The Mycelium Purse's agent-doable arc closes here.*
