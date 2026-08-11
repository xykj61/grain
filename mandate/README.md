# Mandate — Grain's turbopuffer

**Language:** EN
**Status:** Living — the vector store · lap 1 seated `20260810.031234` · lap 2 (**remove** — full CRUD) `20260810` · lap 3 (**profile-loaded dim**) `20260810` · lap 4 (**dim from a real Bron profile**) `20260810` · lap 5 (**approximate index**) `20260810` · lap 6 (**object-storage backing**) `20260811`
**Voice:** Kyri
**Kin:** the first build of the breach's new arc (`../expanding-prompts/20260810-025942_the-handoff-baton-vision-checkpoint.md`)

Mandate is Grain's search organ — a **vector store**, its own answer to turbopuffer. It holds the embeddings a model turns meaning into, and answers the one question a vector store exists for: *which of my records is nearest this query?*

## The design

- **Cosine similarity, via unit vectors.** Nearness is the angle between two directions. Mandate normalizes every vector to length one **on upsert**, so a query is a plain **dot product** — no norms recomputed at search time. That is the turbopuffer trick, in our own hand.
- **Zero-copy.** A query never copies a stored vector; it reads each record **in place**, by reference, and accumulates the dot product. The store owns the bytes once; search borrows them.
- **Bounded, exact.** The store (`max_records`), the dimension (`max_dim`), and the result count (`max_k`) each name a maximum, enforced at the edge. Search is exact brute-force k-nearest — every record considered — which is correct at this scale. An approximate index (for scale past a single node) is a named horizon, not a shortcut taken silently.
- **Profile-loaded dimension (lap 3, `20260810`).** The active dimension is **data**, carried on the `Store` and set at `init(dim)` — the way topology loads a sky — bounded by the comptime `max_dim`. One compiled binary serves any dimension from 1 to `max_dim`; a dimension outside that range is **refused (`error.BadDim`), never clamped**. Vectors are stored at `max_dim` width with only the leading `dim` components meaningful (the tail zero). Proven by `prove_profile_dim`: a second store at a different dimension runs in the same binary, and out-of-bound dims are rejected.
- **Approximate index (lap 5, `20260810`).** Beside the exact path, `query_approx(vec, k, filter, max_hamming)` is a **SimHash / random-hyperplane LSH** index: each record carries a `sig_bits`-wide **signature** (the sign of its dot with fixed, deterministic Hadamard planes — no runtime randomness), computed on upsert; a query scores only records whose signature is within `max_hamming` bits of the query's, then ranks those exactly. So at scale it touches a bounded fraction of the store, at the honest cost of missing a neighbour that fell in a distant bucket. `max_hamming == sig_bits` degrades to exact; `0` is same-bucket only. Proven by `prove_approx`: recall (radius 0 still finds the aligned nearest), determinism, a reduced candidate set, and full-radius-equals-exact. The exact `query` stays the default.
- **Object-storage backing (lap 6, `20260811`).** The whole store serializes to **one portable blob** — the "object" a bucket holds — so a fresh node hydrates the entire store from a single read, the serverless shape turbopuffer takes. `snapshot(store, buf)` writes a bounded, little-endian object (`magic · version · dim · filled`, then a fixed-width record each: `id · tag · sig · vec`) and returns its length; `restore(bytes)` rebuilds an identical store, validating every field against the store's bounds and **refusing** a bad magic, wrong version, short header, out-of-bound dimension, or over-count rather than trusting it. Proven by `prove_snapshot`: the object round-trips byte-for-byte, the restored store answers a query identically (the object *is* the store), a too-small buffer is refused before any partial write, and each corruption is rejected. And proven **on metal** by `prove_file_backing`: the blob is written to a real file (`mandate/bin/store.blob`, gitignored build output) and read back into a fresh store, identical — a node hydrating from a bucket. Max object size is a named constant (`max_blob_bytes`).
- **`dim` from a real Bron profile (lap 4, `20260810`).** `dim_from_profile(bron)` reads the active dimension from a Bron profile's `dim` field — plain key-value, one field per line, `#` comments and blank lines skipped, the first `dim` line winning — bounded to `1..=max_dim` (`error.BadDimValue` otherwise, `error.NoDimField` if absent). The store embeds a real profile file, [`dim.profile.bron`](dim.profile.bron), via `@embedFile`, and `seat_store` opens through `init_from_profile` — so the store's dimension genuinely comes from a file on disk, not a constant. Proven by `prove_profile_read`.
- **A metadata filter.** Each record carries a **tag** beside its vector, so a query may filter — *the nearest images, but only nature ones* — the filter every real vector store owes.
- **Full CRUD (lap 2, `20260810`).** `remove(id)` drops a record by a **swap-remove** — the last filled record fills the gap — so the store never grows a hole and never reallocates; a missing id changes nothing and returns `false`. With `upsert` (create/update) and `query` (read), the store now closes create · read · update · delete, each bounded. Order does not matter, since a query re-sorts by score. Proven by `prove_remove` in the selftest: a removed record leaves the store and never returns in a search.

## Build and prove

```
rye build mandate/store.rye -femit-bin=mandate/bin/store
mandate/bin/store selftest
rishi/bin/rishi run tools/mandate_store_witness.rish
```

The selftest frames its vectors as image embeddings (nature and city tags) so the nearest neighbours are legible by hand; the vectors are plainly synthetic, so no key or network is touched.

## Kumara-keyed records (`keyed.rye`, landed `20260810`)

A bare store keys a vector by any `u32`. [`keyed.rye`](keyed.rye) makes the key an **identity**: a record belongs to a settled Kumara **point**, and only that point's owner may store its vector. The gate mirrors the name registry — the owner presents the point's **Deed**, verified against the constellation's shared surface, and **signs** the exact vector (its SHA-256 digest, with the point and tag). So a stolen id cannot poison another identity's search, and a query returns *who*, not merely *which number*: `place_of` resolves each match to its galaxy, star, or planet. Refusals proven: a non-owner, a forged signature, a tampered vector.

## Horizons

- **Unsplash** as the first real data source — image embeddings, and a real-world camera feed (consent-gated partnership).
- A **profile-loaded dimension** — **landed lap 3 `20260810`** (`dim` is data, bounded by `max_dim`), read from a **real Bron profile file** — **landed lap 4 `20260810`** (`dim.profile.bron`, `@embedFile`).
- An **approximate index** for scale — **landed lap 5 `20260810`** (SimHash LSH, `query_approx`); a multi-probe / larger-signature refinement for real scale is the remaining horizon.
- **Object-storage backing** so the store is serverless like its inspiration — **landed lap 6 `20260811`** (`snapshot`/`restore`, one portable blob, file round-trip on metal); a real bucket adapter (S3-style put/get keyed by name) and a write-ahead log for durability between snapshots are the remaining horizons.
- Served over **Comlink**, rendered on **Skate**; resolved to a spoken name via `../settlement/names.rye`.

---

*May the nearest thing always be found, the bytes read once and borrowed kindly, and every bound named before it is reached.*
