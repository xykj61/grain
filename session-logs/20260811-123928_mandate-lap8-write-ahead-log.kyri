format session-log-v1
stamp 20260811.123928
editor Zed + Claude Agent
model Fable 5
voice Kyri
host cloud pier sandbox — Eastern (EDT) time convention
title Mandate lap 8 — the write-ahead log
prompt kg ty every1, baton prin recur — next real thing: Mandate's write-ahead log (durability between snapshots)
think a snapshot captures the store at a moment; a WAL captures every mutation since, so a crash between snapshots loses nothing — recovery restores the snapshot then replays the log in order
think wal.rye composes on store: Entry (kind upsert/remove · id · tag · vec), a bounded Wal (max_entries 256), record_upsert/record_remove, apply (replays via the same store.upsert/store.remove the live path used), encode/decode to bytes, and recover(snapshot_bytes, wal_bytes)
think replaying the same store mutations means a recovered store is IDENTICAL, not approximate — ordering (upsert id then later remove id) resolves exactly; the raw vec is logged and replay normalizes it exactly as the live upsert did
obs proved crash recovery in memory: base snapshot of {red,green}, then live mutations {+blue,+teal,-green} each logged; recover(base, wal) equals live — filled/dim match, removed id 2 gone from both, added ids 3/4 present, query-identity held
obs proved bounds + corruption: a full log (256 entries) refuses another record; bad magic and an unknown kind are refused on decode; the log round-trips through bytes
obs proved on metal: base.blob (108 B) + log.wal (148 B = 16 + 3*44) written to real files and replayed into an identical store; wal.rye carries no TAME bans, assert-sweep advise tier stays empty
obs the pre-existing stray-Python red (tools/comlink_r1_dual_bind_probe.py) still stands, unrelated to this lap — named, not booked here
loom witness=mandate_wal_witness wall_ms=21 entries=3 base_blob_bytes=108 wal_bytes=148 max_entries=256
loom build=mandate/wal.rye rye_zig=vendor/zig-toolchain/zig exit=0
file mandate/wal.rye the write-ahead log — Entry/Wal, record_upsert/remove, apply, encode/decode, recover, prove_wal, selftest + main via std.process.Init
file tools/mandate_wal_witness.rish asserts the WAL GREEN lines
file mandate/README.md lap 8 documented; storage horizon now names a real cloud-bucket driver + log-compaction as what remains
recommend keep-going — Mandate's WAL is GREEN on metal (durability between snapshots landed); next real things: serving Mandate over Comlink, or the Acme DX design season. Rest is Keaton's to take
