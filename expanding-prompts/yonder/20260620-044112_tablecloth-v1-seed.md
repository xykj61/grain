# 10022 · Tablecloth v1 — Smallest Living Store

*Rung 4 of the Tablecloth ladder (`10018`). Expanded at `044112`: grow **Tablecloth v1** from Mantra's `.mantra/blobs/` into an independently queryable artifact store — the build execution rung after vocabulary (`10019`), build contract (`10020`), and value model (`10021`).*

**Language:** EN
**Version:** `20260620.044112` (Rye chronological stamp)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — hard bounds, narrow API; `external-research/20260619-220012_tablecloth-tame-datastore.md`; `996` Tablecloth v1

**Ladder:** `10018` → `10019` → `10020` → `10021` → **`10022`**

---

## The Mission

**Tablecloth v1** — made of: a general-purpose content-addressed store grown from Mantra's `.mantra/blobs/` into a full, independently queryable artifact store (`996`).

| Property | v1 claim |
|----------|----------|
| **Identity** | SHA3-256 digest names each blob |
| **Mutation** | Write-once; put under existing hash is no-op |
| **Bounds** | Memory and disk budget stated at open; enforced at edge |
| **Concurrency** | Single writer; MVCC readers |
| **API** | `put(blob) → hash`, `get(hash) → blob?`, metadata query |

Study `975_tablecloth_tame_datastore.md` for inherit/decline lists (LMDB, TigerBeetle, DuckDB, redb, Turbopuffer).

## Gall's Order

| Step | Seed | Green when |
|------|------|------------|
| **1** | Extract blob put/get from Mantra into `tablecloth/` module (or `mantra` § Tablecloth) | Round-trip one blob by hash |
| **2** | Hard cap on store size — assert on put | Oversize put fails loudly |
| **3** | Brix build stub: hash inputs → lookup → miss path logs only | Contract from `10020` exercised |
| **4** | `996` / `995` — mark Tablecloth v1 `[x]` when 1–2 green | Roadmap honest |

**Defer:** full Brix v1 combinator; SQL metadata; server process — module in-process only.

## Doc Sync

- `983` seed table — Tablecloth row matches running ground
- `10007` — Tablecloth no longer listed as "design only" when step 1 is green
- `rye/README.md` — store description matches v1 API

## Prove

- Parity gate GREEN if Rye programs touch Tablecloth
- One integration test: put bytes, get by hash, assert equality

---

*May the smallest store hold one honest blob — and grow only by adding, never by changing what it already laid out.*
