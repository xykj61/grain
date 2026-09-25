# DIFFUSER -- the build cache does not collapse a symlinked import either

**Stamp:** `20260921.055148` (shelved from the card this lap)
**Seat:** diffuser
**Status:** Landed -- the note below closed the follow-up question the duplicate-content census opened.

**Note (as it stood on the card):** closes the follow-up question above. Building `main_real.zig`
into a shared `--cache-dir` writes 2 local cache entries; rebuilding it alone stays at 2 (a cache
hit); building `main_link.zig` into the same cache dir grows it to 4, zero reused; rebuilding
*that* alone stays at 4. The on-disk manifest keys on import-path spelling the same way the
compiler's type identity does one layer up -- so a tree carrying N symlinked spellings of one
module pays N times over at compile, codegen, *and* cache, not disk alone. Falsifier (file count
staying at 2 after the link build) did not fire. Closes the thread opened by the duplicate-content
census; no further open door in it.

**Paper:** [`active-designing/date/20260918/20260918-111501_the-build-cache-does-not-collapse-a-symlinked-import-either.md`](../../../../active-designing/date/20260918/20260918-111501_the-build-cache-does-not-collapse-a-symlinked-import-either.md)
