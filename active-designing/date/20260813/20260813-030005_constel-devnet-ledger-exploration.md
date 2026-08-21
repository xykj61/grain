# The Constel Dev-Net Ledger — the fake net's money moves only by the identity that holds its genesis

**Stamp:** `20260813.030005` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Living (design capture, self-approved round) · **Season:** double-seat expansion D — Constel test-networks × Mycelium
**Kin:** [the dev-net harness](20260813-022908_constel-devnet-harness-exploration.md) · [the naming law](20260813-022222_constel-test-network-naming-law.md) · [the six-season expansion](20260813-020035_double-seat-expansion-six-seasons.md) · [`.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## Where this sits on the road

The Constel dev-net harness closed its own four-round arc — a fake constellation, quarantined by a
law-safe name, running the real settlement protocol from genesis (r1 named genesis · r2 settled the
fractal · r3 travels as Bron · r4 reads a fixture true). That harness was named the **crux of Season D**
for one reason: *build the dev-net once and every later Season-D rung has a bench.* Its own exploration
named the rungs waiting on that bench — **Mycelium consensus** first among them.

This round takes that first step. The tree already carries a real Mycelium primitive, `mycelium/fold.rye`:
the myc supply as a **pure fold over Kumara-signed facts** — supply is `Σ issued − Σ taxed` at every
prefix, non-negative, an overdraw refusing the whole fold, each fact sealed by a real signature. It has
stood on its own since the Build Journey. What it has never had is a **network to belong to** — the facts
were signed by a bare demo keypair, tied to no settled identity.

The dev-net gives it that home. A spun-up Constel opens a genuine genesis galaxy whose Deed names a
**keeper** — a real settled identity. This round binds the Mycelium ledger to that keeper, so the fake
net's money can move only by the hand that holds the fake net's genesis.

## The crux, in one line

**An economic ledger runs from genesis inside the fake net — its money signed by the net's own settled
identity, refused for anyone else — and it can never run under a name that could be real.**

Two promises fused into one module:

- **The quarantine wraps the ledger, not only the net.** The ledger opens only through `spin_up`, which
  refuses `UnsafeName` before a single genesis opens. There is no code path to a ledger under a name that
  could parse as a real `@p` — the money is sealed inside the sandbox by the same wall the harness proved.
- **Sovereignty is structural.** A fact enters the ledger only when its signer's public key equals the
  genesis galaxy Deed's `keeper`. The keeper keypair mints the net's issue and tax; a fact minted by any
  other keypair is refused `NotSovereign` before it touches the log. So the settlement identity *gates*
  the Mycelium supply — the two modules meet, and neither is weakened.

## Why bind the ledger to the genesis keeper

Mycelium's fold already proves a fact's signature is internally honest (the signer really signed these
bytes). That is integrity, not authority — it says *someone* signed, not *whose net this is*. The dev-net
supplies the missing half: the genesis Deed names exactly one keeper, and that keeper is the fake net's
sovereign. Requiring every folded fact to carry the sovereign's key turns "a signed fact" into "a fact the
net's own identity authorized," the same way `mandate/keyed.rye` and `tablecloth_keyed` bind bytes to a
settled point. The money and the identity become one story: to move the fake net's supply, you must hold
the fake net's genesis.

## The four rounds (Lindy-first, crux-first)

- **r1 — the sovereign ledger (this round's crux).** `pond/apps/constel_net_ledger.rye`: `open_ledger`
  spins up a law-safe dev-net and derives its sovereign keeper keypair, asserting the sovereign's pubkey
  equals the galaxy Deed's keeper. `issue`/`tax` mint sovereign-signed facts and fold them through the
  real `mycelium/fold` law; `admit` refuses any fact whose signer is not the sovereign (`NotSovereign`).
  Proven: the supply folds `issued − taxed`; an unsafe name opens **no** ledger; a tax overdraw refuses
  the whole fold (supply unchanged); an alien signer's fact is refused before the log.
- **r2 — star reservations settle beside the topology.** A `star_reserve` fact reserves a star name under
  the sovereign, draining supply like tax, mirroring the harness's r2 topology settlement — the ledger and
  the address space grow together inside the fake net.
- **r3 — the ledger travels.** Render a folded ledger to a `format constel-ledger-v1` Bron record and parse
  it back byte-for-byte, the safe name and the sovereign key riding with it, so a dev-net's books cross as
  readable text.
- **r4 — read a real ledger fixture true.** Cross-check the harness's fold of a genuine on-disk ledger
  record against an independent measure — two tools, one answer — so a fake net's supply can never drift
  from the bytes.

## Boundaries

Siloed and dev-only. Demo keeper seeds only — no real key, no funds, no network, no custody. The Mycelium
fold is a supply *model*, not a payment rail; this moves no dollar and holds no key (custody gate #3
untouched). The maintainer's own Kumara instance stays gate #4; a ledger served over the wire reaches the
serve gate. Agent-doable, reaches no custody gate. Composes over public API only — `constel_net.spin_up`
and `mycelium/fold`'s minting and folding — inventing no storage and weakening no bound.

---

*A fake economy that runs the real supply law, where the only hand that can move the money is the one that
holds the net's own genesis — and no name it wears could ever be someone else's address.*
