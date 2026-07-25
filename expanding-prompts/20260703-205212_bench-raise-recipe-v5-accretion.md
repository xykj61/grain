# Bench Raise Recipe — v5 Accretion (Zip Extraction Hygiene)

*Paid for by zip 39 on the Claude bench (`20260703.203712 UDT`): symlink flattening broke bootstrap; stripped execute bits made RW-1 red twice. Cursor metal at `bad68b4` already holds parity **148** with intact permissions.*

**Stamp:** `20260703.205212`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Supersedes:** accretes every prior bench-raise zip step (v3 recursion prompt, v4 handoff additions)
**Status:** Proposed — wire into the next full-tree zip comment and fresh-sitter instruction

---

## Before bootstrap (mandatory on every fresh bench)

1. **Extract preserving permissions** — use `unzip` (or equivalent that restores mode bits), never a flat extractor that drops execute bits. After extract, spot-check `tools/fixtures/rw1_stub_mantra/mantra` reads **executable** (`755` or `+x`).

2. **Restore flattened symlinks** — if the forge zip turned relative symlinks into one-line text files holding a path, convert path-shaped one-liners with existing targets back into symlinks before `rye` bootstrap. The `178d2fa` raise needed **20** restored, **0** ambiguous.

3. **Confirm fixtures executable** — `find tools/fixtures -type f` and verify any stub or script the gate trio execs directly (not via `sh`) carries execute permission. RW-1 shell collaboration is the canary.

Then: pinned toolchain · symlink · cold bootstrap · Rishi built · gate trio from bare.

---

## Zip comment discipline

The archive comment must equal `git rev-parse HEAD` of the tree inside. Zip 38 was one commit early; zip 39 was **five** commits early (`178d2fa` vs reported `bad68b4`). To pin parity **148**, cut the full-tree zip at **`bad68b4`** (or the true tip after the next push).

---

*May every bench raise with its bits and links intact. May red twice mean the code, not the zip.*
