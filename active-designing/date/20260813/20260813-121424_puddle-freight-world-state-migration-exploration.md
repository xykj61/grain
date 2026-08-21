# Freight — a world carries its whole signed ledger to its new berth (Exploration)

**Stamp:** `20260813.121424` · **Status:** Vision -- Living (self-approved design read) · **Voice:** Kyri
**Register:** Radiant · **Season:** D (Kresfa & Mycelium) — the double-seat expansion
**Kin:** [`the Puddle berth`](20260813-114651_puddle-fleet-placement-exploration.md) (Freight rides Puddle) · [`the double-seat expansion`](20260813-020035_double-seat-expansion-six-seasons.md) · Lexicon **Puddle** · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md)

---

## What Freight is

A **world** in a Puddle fleet is a bounded Rye whole with its own Pond and its own Mycelium ledger — the Cord the consensus season built (order · supply · quorum · rotation). Puddle proved *which host runs which world*: a berth derived by every node alike, healing around a failed host by moving only the worlds that host carried. Yet the Puddle arc named a world by its id alone. It never carried the one thing a world exists to keep: **its state.**

**Freight** is what a world carries to its berth — its whole signed ledger. This journey proves the property a fleet is worthless without: when a host departs and Puddle re-berths a world, that world arrives on its new host reading the **byte-identical account position** it held on the old one. Placement moves; state does not.

## The blind spot, and the trap it hides

The Puddle convergence round (r2) proved *minimal disruption of placement* — a departed host costs one re-placement, never a migration. But a placement is only a pointer. A fleet that reshuffles the *pointers* while silently dropping or altering the *ledgers* they point at is worse than a scheduler that never moved anything — it is a bank that reassigns your account to a new branch and forgets your balance, or, worse, lets the branch that received you quietly rewrite it. Every long-lived fleet faces this trap: **who guarantees the moved world's state is the same state?**

Kubernetes answers with a control plane that ships volumes and hopes the bytes survive the wire. The content-addressed grain the Mycelium season already keeps answers differently, and for free: **a world's position is a pure function of its ledger bytes, never of its host** — so wherever the world berths, its position is the same, and any host that received a corrupted ledger can prove the corruption before it serves a single answer.

## The crux (r1) — a moved world reads the identical position on its new berth

The decisive, hard-but-tractable move is to show that migration changes the berth and nothing else. A world carries a `cord.Dag` (its owner-signed ledger). Its account position is read the way the Statement voice already reads it — `statement.statement_for(lapse.resolve(dag), account)` — a fold over the committed order that takes **no host as input**. Its ledger fingerprint is the whole-order digest the Voucher already computes — `voucher.order_head_of(dag)`. The freight law holds exactly when:

- **A moved world genuinely changed host.** Under a host departure the world re-berths (Puddle's own heal), so its berth public key is not the one it held before — this is a real migration, not a no-op dressed as one.
- **Its position is byte-identical across the move.** The order-head digest and the position triple (balance · reserved · received), read on the old host and re-read on the new one, agree byte for byte. The world arrives whole.
- **A world that stayed keeps its freight too.** A survivor-tenant's berth and position are both unchanged — the healing disturbs neither the placement nor the state of a world it did not move.
- **A freight tampered in transit refuses.** If the carrier alters one block of a moving world's ledger, the receiving host recomputes an order-head that disagrees with the freight's advertised head and refuses `FreightTampered` — a host cannot serve a silently-rewritten position. The world's state is as tamper-evident on the move as it is at rest.

The position is **derived, never re-declared** — there is no `set_position`; the receiving host reads the world's bytes exactly as the sending host did, so a steward cannot hand a world a balance the ledger does not prove.

## The method — content-addressing makes migration free and safe

This crux is almost given, and that is the point: because a ledger is content-addressed, its position is a pure function of its bytes, so moving *where* it runs cannot move *what it says*. The work is not to compute a migration — it is to **prove** that the trivial migration is the honest one: that the world genuinely moved, that its fingerprint held, and that the one dangerous case (a ledger altered mid-move) is caught rather than trusted. Freight inherits accrete-never-break from the Cord it carries — a move is a re-read, never a rewrite.

## The four rounds

- **r1 — the freight crux.** `mycelium/freight.rye`: a fleet of hosts, each world carrying its own Cord ledger; a host departs, a world re-berths; the moved world's order-head + position read byte-identical on its new host, a stayed world's unchanged, and a ledger tampered in transit refuses `FreightTampered`.
- **r2 — the whole fleet's state is conserved.** Every world in a healing fleet keeps its own freight — no world reads another's position (distinct ledgers stay distinct across the move), and the sum of the fleet's state before the departure equals the sum after: a host failure costs zero state.
- **r3 — the freight travels as text.** A `format freight-v1` record carries a world's id · berth · ledger order-head · position; it renders and parses byte-for-byte, and the recovered freight reads the identical position offline — a receiving node accepts a moving world by reading its record alone.
- **r4 — reads true.** A real on-disk fixture, produced reproducibly, cross-checked against an independent `awk` reading — two tools, one answer — so a fleet's migrated state can never drift from a record a keeper reads by hand.

## Custody, held plainly

Demo host, world, and keeper seeds only — no key held, no funds, no network, no real world provisioned or moved. A real Aurora host (Puddle's horizon substrate) and any provisioning reach custody gates #2/#4; a **served** migration (a node fetching a moving world's freight over Comlink) reaches the Comlink-served gate. This journey builds the freight law on the bench, exactly as the Puddle berth and the Constel dev-net run the real protocol under a quarantined name.

## Gratitude to silo

**Content-addressed storage** (the Merkle/IPFS lineage of naming bytes by their own digest) — the concept that identity follows content, so state need not trust its location — studied clean-room, our own SHA-256 order-head and our own bounded Rye. **Live migration** (the hypervisor idea of moving a running guest without losing its state) — carried as concept, not code; here a world's state is content-addressed, so the move is a re-read rather than a memory copy.

---

*A world that trusts its bytes need not trust its host — the ledger reads the same in every berth it is given. May each world arrive whole, and may the fleet that moves it never once have to be believed.*
