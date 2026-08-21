# FORA27 — Constel flexible quorums: the truth beneath the majority lemma

**Stamp:** `20260814.075309` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** Six-Season double-seat, Season D thread (Kresfa & Mycelium — the tree's own consensus) · **waymark** FORA · **rung** FORA27
**Kin:** [`../constel/quorum.rye`](../constel/quorum.rye) (FORA9) · [`../constel/elect.rye`](../constel/elect.rye) (FORA10) · [`../constel/commit.rye`](../constel/commit.rye) (FORA18) · [`../constel/roster.rye`](../constel/roster.rye) (FORA1)

---

## The rung

FORA9 proved that any two strict majorities of a constellation must intersect — the one lemma the whole ladder leans on: a unique leader, a no-fork commit, a no-fork joint switch. This rung proves the more general truth beneath it (Flexible Paxos, Howard, Malkhi & Spiegelman 2016): consensus never needed *every* quorum to intersect every other. It needs only every **election** quorum to intersect every **replication** quorum.

## Why it matters

A leader is elected by an election quorum Qe; it commits an entry by replicating to a replication quorum Qr. Safety needs exactly one thing: a newly-elected leader must **see** every entry a prior leader committed — that is, Qe must intersect every Qr. It does *not* need Qe to intersect another Qe, nor Qr another Qr. So any split with **qe + qr > n** is safe, and a deployment may trade the two against each other: a small Qe for fast, cheap elections paired with a large Qr, or a small Qr for fast commits paired with a large Qe. The strict-majority choice (qe = qr = ⌊n/2⌋+1) is the single point on that line where both are equal — and FORA9's `2·majority > n` is exactly its `qe + qr > n` instance.

## The shape

`safe_split(qe, qr, n)` is the whole condition in one line — `qe + qr > n`, computed in `u64` so the sum cannot wrap. `min_overlap(qe, qr, n)` is the pigeonhole *strength* of the guarantee: `qe + qr − n` piers when safe, zero when not. The proof is not left to arithmetic alone: `enumerated_min_overlap` exhaustively walks every real size-qe election subset against every size-qr replication subset of the n piers (bounded 2ⁿ per side, n ≤ `roster.max_piers`) and returns the smallest true intersection — so the theorem is grounded in genuine set intersection, not merely stated. Composed over `quorum.majority_of` and `roster.max_piers` only, adding no new state.

## The crux, proven and enumerated

- **`safe_split` is `qe + qr > n`, exact at the boundary** — n=5: 2+4 safe, 2+3 not.
- **The strict-majority pair is the symmetric special case** — for every n, `safe_split(majority, majority, n)` holds because `2·majority_of(n) > n` is FORA9's own lemma.
- **`min_overlap` is the pigeonhole strength** — `qe + qr − n` when safe, 0 when not.
- **Enumerated over real subset pairs** — for a safe split (n=5, qe=2, qr=4) every election quorum meets every replication quorum (enumerated minimum = `min_overlap` = 1); for an unsafe split (n=5, qe=2, qr=3) a genuine disjoint pair *exists* (enumerated minimum = 0), so an election could raise a leader that never saw a committed entry.
- **The asymmetric tradeoff** — the fastest commit (qr = 1) demands the whole cluster to elect (qe = n); the fastest election (qe = 1) demands every pier to commit (qr = n); both endpoints safe, every interior point below the line unsafe.

## What it does not touch

Purely local — bounded size arithmetic and a bounded subset enumeration on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address ever formed (custody gate #2 — real hardware / any real wire — and gate #4 — real Kumara — both untouched).
