# Mandate — Grain's turbopuffer

**Language:** EN
**Status:** Living — the vector store · seated `20260810.031234` · **remove — full CRUD** `20260810` · **profile-loaded dim** `20260810` · **dim from a real Bron profile** `20260810` · **approximate index** `20260810` · **object-storage backing** `20260811` · **named-object bucket** `20260811` · **write-ahead log** `20260811` · **serve protocol** `20260811` · **named serve — matches resolved to spoken names** `20260811` · **served over Comlink, sealed** `20260811`
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Voice:** Kyri
**Kin:** the first build of the breach's new arc (`../expanding-prompts/date/20260810/20260810-025942_the-handoff-baton-vision-checkpoint.md`)

Mandate is Grain's search organ — a **vector store**, its own answer to turbopuffer. It holds the embeddings a model turns meaning into, and answers the one question a vector store exists for: *which of my records is nearest this query?*

## The design

- **Cosine similarity, via unit vectors.** Nearness is the angle between two directions. Mandate normalizes every vector to length one **on upsert**, so a query is a plain **dot product** — no norms recomputed at search time. That is the turbopuffer trick, in our own hand.
- **Zero-copy.** A query never copies a stored vector; it reads each record **in place**, by reference, and accumulates the dot product. The store owns the bytes once; search borrows them.
- **Bounded, exact.** The store (`max_records`), the dimension (`max_dim`), and the result count (`max_k`) each name a maximum, enforced at the edge. Search is exact brute-force k-nearest — every record considered — which is correct at this scale. An approximate index (for scale past a single node) is a named horizon, not a shortcut taken silently.
- **Profile-loaded dimension (`20260810`).** The active dimension is **data**, carried on the `Store` and set at `init(dim)` — the way topology loads a sky — bounded by the comptime `max_dim`. One compiled binary serves any dimension from 1 to `max_dim`; a dimension outside that range is **refused (`error.BadDim`), never clamped**. Vectors are stored at `max_dim` width with only the leading `dim` components meaningful (the tail zero). Proven by `prove_profile_dim`: a second store at a different dimension runs in the same binary, and out-of-bound dims are rejected.
- **Approximate index (`20260810`).** Beside the exact path, `query_approx(vec, k, filter, max_hamming)` is a **SimHash / random-hyperplane LSH** index: each record carries a `sig_bits`-wide **signature** (the sign of its dot with fixed, deterministic Hadamard planes — no runtime randomness), computed on upsert; a query scores only records whose signature is within `max_hamming` bits of the query's, then ranks those exactly. So at scale it touches a bounded fraction of the store, at the honest cost of missing a neighbour that fell in a distant bucket. `max_hamming == sig_bits` degrades to exact; `0` is same-bucket only. Proven by `prove_approx`: recall (radius 0 still finds the aligned nearest), determinism, a reduced candidate set, and full-radius-equals-exact. The exact `query` stays the default.
- **Object-storage backing (`20260811`).** The whole store serializes to **one portable blob** — the "object" a bucket holds — so a fresh node hydrates the entire store from a single read, the serverless shape turbopuffer takes. `snapshot(store, buf)` writes a bounded, little-endian object (`magic · version · dim · filled`, then a fixed-width record each: `id · tag · sig · vec`) and returns its length; `restore(bytes)` rebuilds an identical store, validating every field against the store's bounds and **refusing** a bad magic, wrong version, short header, out-of-bound dimension, or over-count rather than trusting it. Proven by `prove_snapshot`: the object round-trips byte-for-byte, the restored store answers a query identically (the object *is* the store), a too-small buffer is refused before any partial write, and each corruption is rejected. And proven **on metal** by `prove_file_backing`: the blob is written to a real file (`mandate/bin/store.blob`, gitignored build output) and read back into a fresh store, identical — a node hydrating from a bucket. Max object size is a named constant (`max_blob_bytes`).
- **`dim` from a real Bron profile (`20260810`).** `dim_from_profile(bron)` reads the active dimension from a Bron profile's `dim` field — plain key-value, one field per line, `#` comments and blank lines skipped, the first `dim` line winning — bounded to `1..=max_dim` (`error.BadDimValue` otherwise, `error.NoDimField` if absent). The store embeds a real profile file, [`dim.profile.bron`](dim.profile.bron), via `@embedFile`, and `seat_store` opens through `init_from_profile` — so the store's dimension genuinely comes from a file on disk, not a constant. Proven by `prove_profile_read`.
- **A metadata filter.** Each record carries a **tag** beside its vector, so a query may filter — *the nearest images, but only nature ones* — the filter every real vector store owes.
- **Full CRUD (`20260810`).** `remove(id)` drops a record by a **swap-remove** — the last filled record fills the gap — so the store never grows a hole and never reallocates; a missing id changes nothing and returns `false`. With `upsert` (create/update) and `query` (read), the store now closes create · read · update · delete, each bounded. Order does not matter, since a query re-sorts by score. Proven by `prove_remove` in the selftest: a removed record leaves the store and never returns in a search.

## Build and prove

```
rye build mandate/store.rye -femit-bin=mandate/bin/store
mandate/bin/store selftest
rishi/bin/rishi run tools/m/mandate_store_witness.rish
```

The selftest frames its vectors as image embeddings (nature and city tags) so the nearest neighbours are legible by hand; the vectors are plainly synthetic, so no key or network is touched.

## Kumara-keyed records (`keyed.rye`, landed `20260810`)

A bare store keys a vector by any `u32`. [`keyed.rye`](keyed.rye) makes the key an **identity**: a record belongs to a settled Kumara **point**, and only that point's owner may store its vector. The gate mirrors the name registry — the owner presents the point's **Deed**, verified against the constellation's shared surface, and **signs** the exact vector (its SHA-256 digest, with the point and tag). So a stolen id cannot poison another identity's search, and a query returns *who*, not merely *which number*: `place_of` resolves each match to its galaxy, star, or planet. Refusals proven: a non-owner, a forged signature, a tampered vector.

## Named-object bucket (`bucket.rye`, landed `20260811`)

Where `store.rye` snapshots **one** store to one blob, [`bucket.rye`](bucket.rye) names **many** — an S3-style key→object map, `name → <store snapshot>`, kept as files in a bucket directory. `put(dir, name, store)` writes a store as the object `<dir>/<name>.blob`; `get(dir, name)` restores the store stored under `name`. Each object is a whole Mandate store, so a bucket holds a family of them side by side — the images index, the text index — each round-tripping independently. Every object **name is validated path-safe first** (1..=`max_name` bytes of `[a-zA-Z0-9_-]`, no slash, no dot, no separator), so a `put` or `get` addresses exactly one file inside the bucket and an object can never climb out of the directory. A missing object is refused, never a phantom store. Proven by `prove_bucket`: two named objects at different dimensions round-trip independently, the restored object answers a query identically, each bad name (empty · slash · dot · `..` · too long) is refused, and a get of an unwritten name errors.

## Write-ahead log (`wal.rye`, landed `20260811`)

A snapshot captures the whole store at a moment; a **write-ahead log** ([`wal.rye`](wal.rye)) captures every mutation *since* that moment, so a crash between snapshots loses nothing. Each entry is one bounded, fixed-width record — a kind (`upsert` / `remove`), an id, a tag, and the raw vector — appended in life, replayed in order at recovery. `recover(snapshot_bytes, wal_bytes)` restores the snapshot then replays the log; replay calls the **same** `store.upsert` / `store.remove` the live path used, so a recovered store is **identical** to the one that was lost — ordering (an upsert then a later remove of the same id) resolves exactly as it did live — not an approximation. The log is bounded (`max_entries`) and serializes to bytes (`magic · version · count · entries`). Proven by `prove_wal`: a base snapshot plus three logged mutations recovers a store equal to the live one (the removed id gone, the added ids present, query-identity held); the log round-trips through bytes; a full log refuses another record; and a bad magic or unknown kind is refused. Proven **on metal** too — the base snapshot and the log written to real files and replayed back.

## Serve protocol (`serve.rye`, landed `20260811`)

A store answers questions from elsewhere. [`serve.rye`](serve.rye) is the **wire shape** of a query and its answer: a `QueryRequest` (how many, an optional tag filter, and the query vector) and a `QueryResponse` (the matches, id and score), each serialized to bounded little-endian bytes — the messages a **Comlink** transport carries, independent of the socket underneath. `serve(store, request_bytes, out)` is the one-call server: decode a request, answer it against the store, encode the response — **bytes in, bytes out** — so the same store answers a caller in the same process or across a wire, by the same path. Proven by `prove_serve`: a request round-trips through bytes; a served query answers exactly as a direct in-process query (same nearest, same order); a tag filter narrows the answer; and a bad magic, wrong version, out-of-range k, or too-small buffer is refused at the door.

## Named serve — who, not just which number (`named_serve.rye`, landed `20260811`)

A bare query answers with point numbers; a **named** query answers with **who**. [`named_serve.rye`](named_serve.rye) resolves each match through the shared name registry to the spoken name its point wears, or marks it honestly **unnamed** when it wears none — never a fabricated name. This closes the resolution half of "served over Comlink, resolved to a spoken name," now that `names.rye` offers a public `sign_claim` (added the same day) so a name can be claimed from outside that module. Proven by `prove_named_serve`: a settled galaxy is claimed the name `polaris` through `sign_claim`, a store keyed by point numbers is queried, the nearest match resolves to `polaris`, an unnamed point resolves `named = false`, and the registry reads both ways (name→point, point→name).

## Served over Comlink, sealed (`comlink_serve.rye`, landed `20260811`)

The serve protocol gave the wire *shape* of a query; [`comlink_serve.rye`](comlink_serve.rye) rides it on Comlink's actual transport. A `QueryRequest`'s bytes become the plaintext of a **sealed datagram** (`wire_format.seal_message` — X25519 key agreement, ChaCha20-Poly1305, a Sha3 name, a kumara signature), opened on the far side by `open_datagram`, so a query crosses Comlink **encrypted, signed, and name-checked end to end**, and the answer returns the same way. `serve_sealed(store, request_frame, response_frame)` is the host side: open the sealed request, answer it against the store, seal the response. A compile-time assert proves both serve messages fit the sealed-message budget (340 bytes), so a query and its answer each ride one datagram — no fragmentation. Proven by `prove_comlink_serve`: a query served over a sealed round-trip returns exactly what a direct in-process query would (same nearest, same order), and a single flipped ciphertext byte fails to open — a forged or tampered datagram never reaches the store. The remaining transport horizon is a **live NIC** (a real `virtio_net` socket carrying these datagrams).

## Horizons

- **Unsplash** as the first real data source — image embeddings, and a real-world camera feed (consent-gated partnership).
- A **profile-loaded dimension** — **landed `20260810`** (`dim` is data, bounded by `max_dim`), read from a **real Bron profile file** — **landed `20260810`** (`dim.profile.bron`, `@embedFile`).
- An **approximate index** for scale — **landed `20260810`** (SimHash LSH, `query_approx`); a multi-probe / larger-signature refinement for real scale is the remaining horizon.
- **Object-storage backing** so the store is serverless like its inspiration — **landed `20260811`** (`snapshot`/`restore`, one portable blob, file round-trip on metal), and a **named-object bucket** — **landed `20260811`** (`bucket.rye`, S3-style put/get keyed by a path-safe name). A real cloud-bucket driver (an actual S3/GCS backend behind the same put/get) is the remaining storage horizon.
- **A write-ahead log** for durability between snapshots — **landed `20260811`** (`wal.rye`, record · encode/decode · replay for crash recovery, proven on metal); a log-compaction pass that folds a full log into a fresh snapshot is the remaining refinement.
- Served over **Comlink** — **the protocol landed `20260811`** (`serve.rye`), and **sealed onto Comlink's transport `20260811`** (`comlink_serve.rye`, sealed/signed/name-checked datagrams); a **live NIC** (real `virtio_net` socket) and rendering on **Skate** remain the horizons.
- Resolved to a spoken name via `../settlement/names.rye` — **landed `20260811`** (`named_serve.rye`, `names.rye` gained a public `sign_claim`). A match now resolves to **who** (spoken name) and can resolve to **where** (`keyed.place_of`, fractal place) side by side.

---

*May the nearest thing always be found, the bytes read once and borrowed kindly, and every bound named before it is reached.*
