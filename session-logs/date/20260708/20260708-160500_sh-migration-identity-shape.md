# Sh-migration kg — identity_shape native

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.160500

## Prompt

`kg` — next mechanical cluster after `55e2b58`.

## Thinking trace

`identity_shape.sh` used grep regex for PGP fingerprints. Native port: SSH via `starts-with "SHA256:"`; PGP via map+record shape checks (ten four-char groups, line length 49). Guard split indexing by filtering `parts == 10` before field lengths.

Confirmed the where-input wall precisely: nested `where (where list as x: …) as x: …` fails with `UndefinedName`; sequential `let passN = where passN-1 …` chains work (`identity_shape.rish` uses eleven passes).

Output matches grep elder on `context/PUBKEYS.md` copied to root; template-only path unchanged; `identity_check.rish` GREEN.

Also repaired a TAME_GUIDANCE POSIX paragraph merge glitch (`only. — all eleven` → proper Structural QEMU sentence).

## Verification

- `diff` native vs `identity_shape.sh` (with root `PUBKEYS.md`) — identical
- `rishi/bin/rishi run tools/identity_check.rish` — **GREEN**

## Files

- `tools/fixtures/identity_shape.rish` — created
- `tools/fixtures/identity_shape.sh` — thin delegate
- `tools/identity_check.rish` — repointed
- `context/TAME_GUIDANCE.md` — identity + where-chain note; paragraph fix
- `work-in-progress/TASKS.md` — census extended

**Recommend:** say **`go`** to ship; `two_rooms_doorway_scan` (stamp compare + case-insensitive room names), `designed_not_built_scan`, `slc1_*` stay `.sh`.
