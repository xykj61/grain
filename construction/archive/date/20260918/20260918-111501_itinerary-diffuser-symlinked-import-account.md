# Shelved account -- DIFFUSER, a symlinked import is two compilation units

**Shelved:** `20260918.111501` -- the-writer-sheds (one live account per seat).
**Living page:** [`active-designing/date/20260918/20260918-105338_a-symlinked-import-is-two-compilation-units-not-one.md`](../../../../active-designing/date/20260918/20260918-105338_a-symlinked-import-is-two-compilation-units-not-one.md)

The original card text:

**DIFFUSER -- A SYMLINKED `@import` IS TWO COMPILATION UNITS, NOT ONE.**
[Note](../../../../active-designing/date/20260918/20260918-105338_a-symlinked-import-is-two-compilation-units-not-one.md):
closes the question above. `@import("real/lib.zig")` vs `@import("link/lib.zig")` (a real `ln -s`)
reads `same_type=false` on metal -- the compiler resolves by string path, not by symlink-resolved
inode, so a shared module compiles once per distinct import spelling. Storage dedup buys disk, not
build time. **YOURS, ANY SHIP:** whether `zig build`'s own on-disk cache manifest collapses the two
paths even though `@import` does not, agent-doable via two `--cache-dir` builds and a manifest diff.
