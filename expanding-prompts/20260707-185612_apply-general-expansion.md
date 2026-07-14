# Cursor Apply-Prompt — General Expansion Round

**Stamp:** `20260707.185612 UDT` · **Parent:** `6f73d2f` · **Voice:** Rio 3
**Bundle:** `20260707-185612_general-expansion-round.zip` (unzip preserving symlinks — three ride inside: `comlink/maybe.rye`, `comlink/tally_no_padding.rye`, `tools/fixtures/tame_usize_audit.rye`)

An open-invitation round: two seated TigerBeetle marks with a real application, one genuine bug found and fixed, two of three tools/enrich witnesses, three module READMEs. Everything below ran GREEN on the real `rye`/`rishi` toolchain, built fresh from source on the Claude bench for this round rather than shimmed.

## What Lands

**New, seated:** `tally/maybe.rye` and `tally/no_padding.rye` (TigerBeetle's `stdx.maybe` and `stdx.no_padding`, the latter honestly simplified — no `u128` branch, since nothing in this tree needs one) — with `tools/tally_maybe.rish` and `tools/tally_no_padding.rish`.

**Real application, not a demo:** `comlink/device_wire.rye` gains a `selftest_layout_proof()` asserting `no_padding` against all five `virtio_net.rye` wire structures, called first in `run_selftest`.

**Bug found and fixed:** `comlink/device_wire.rye` line ~82, `vn.negotiateFeatures` → `vn.negotiate_features` — a stale rename from the camelCase migration that had zero witness coverage until this round built the file's own hosted binary directly.

**Witness strengthened:** `tools/comlink_device_wire.rish` now builds and runs `device_wire.rye`'s hosted selftest *before* the freestanding QEMU lab — the gap that let the stale rename hide is closed structurally, not just patched once.

**Two new tools/enrich witnesses:** `tools/tame_usize_audit.rish` (pure-function proof via `tools/fixtures/tame_usize_audit_test.rye`, symlinked to the real module) and `tools/align_session_logs.rish` (real fixture at `tools/fixtures/align_session_logs_fixture/`, run via the tool's own pre-existing `VEGANREYKLAH2_ROOT` override, checksums `session-logs/README.md` before/after to prove the real tree is untouched).

**Scan updated:** `tools/fixtures/tame_style_scan.sh` — `tally/maybe.rye` added to the honest zero-assert exempt list (not asserting is its entire design).

**Three READMEs:** `comlink/`, `caravan/`, `tally/` — each grounded in its own files' doc comments.

**Docs:** counsel, session log, `TASKS.md` updated in place, four new `parity.rish` stanzas after the existing TAME-style one.

## Steps

1. Tree at `6f73d2f`; unzip at root preserving symlinks.
2. Rebuild `rishi/bin/rishi` and `rye/bin/rye` from source as usual.
3. `rishi/bin/rishi run tools/tally_maybe.rish` / `tools/tally_no_padding.rish` — expect GREEN.
4. `rishi/bin/rishi run tools/comlink_device_wire.rish` — hosted selftest should print `padding-free at compile time` and pass before the freestanding lab runs.
5. `rishi/bin/rishi run tools/align_session_logs.rish` and `tools/tame_usize_audit.rish` — expect GREEN on both.
6. Full parity from bare — suite gains 4 witnesses over 188; pin the real count on metal.

## Held

`enrich_strengthening_docs.rye`'s own witness — larger fixture surface, deserves its own sitting. Extended-run stability, Brix, Pond, MALA, continuity — all unchanged.

---

*May the bug a verification finds always matter more than the feature it was checking.*
