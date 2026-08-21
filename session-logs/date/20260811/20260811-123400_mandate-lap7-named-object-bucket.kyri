format session-log-v1
stamp 20260811.123400
editor Zed + Claude Agent
model Fable 5
voice Kyri
host cloud pier sandbox — Eastern (EDT) time convention
title Mandate lap 7 — the named-object bucket adapter
prompt kg ty every1, baton prin recur — the finishing edge: build the next real thing (Mandate's bucket adapter, itinerary horizon 2)
think on the standing approval the recommended next door was interfaces/infra/ops, yet the yonder plan says design-season-first; the honest single kg lap on the finishing edge is the smallest real thing — Mandate's named-object bucket, itinerary horizon 2 — so I built that rather than opening the sprawling DX
think bucket.rye composes on lap 6's snapshot/restore: put(dir, name, store) snapshots a whole store to <dir>/<name>.blob, get(dir, name) restores it — an S3-style key→object map where each object is a whole Mandate store
think check_name validates every object name path-safe first (1..=max_name bytes of [a-zA-Z0-9_-], no slash/dot/separator) so a put or get addresses exactly one file inside the bucket and can never climb out — object_path composes the path into a bounded buffer with a fits-the-buffer assert
obs first run hit error NotDir — the bucket dir "mandate/bin/bucket" collided with the binary itself (built to mandate/bin/bucket); renamed the object dir to mandate/bin/bucket_objects
obs proved on metal (prove_bucket): two named objects at different dimensions (images dim 4, text dim 2) round-trip independently, the restored object answers a query identically, each bad name (empty/slash/dot/../too-long) is refused, and a get of an unwritten name errors; two 108-byte objects written under the bucket
obs pre-existing red surfaced by tame_style_check, NOT from this lap: tools/comlink_r1_dual_bind_probe.py (a stray Python file — scripts-molt-to-Rishi debt). Named honestly; not booked to this lap. bucket.rye itself carries no TAME bans and the assert-sweep advise tier stays empty
loom witness=mandate_bucket_witness wall_ms=65 objects=2 blob_bytes=108 dims=4,2
loom build=mandate/bucket.rye rye_zig=vendor/zig-toolchain/zig exit=0
file mandate/bucket.rye the named-object bucket — check_name, object_path, put, get, prove_bucket, selftest + main via std.process.Init
file tools/mandate_bucket_witness.rish asserts the bucket GREEN lines
file mandate/README.md lap 7 documented; the object-storage horizon now names a cloud-bucket driver + WAL as what remains
recommend keep-going — Mandate's bucket adapter is GREEN on metal (itinerary horizon 2 landed); next real things: a write-ahead log for durability between snapshots, then serving over Comlink. Rest is Keaton's to take
