# Rishi file I/O witness scratch

**Where this sits:** home is [`../../../README.md`](../../../README.md) - a first hour in your hands is
[`../../../docs-geode/tutorials/the-first-hour.md`](../../../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../../../SOURCE.md`](../../../SOURCE.md)

Two programs write their scratch here. The witness at `tools/r/rish_file_io_witness.rish` writes
`roundtrip.txt` and `number.txt`; the language test at `rishi/tests/file_io.rish` writes
`rishi_io_test.txt`, `rishi_io_test_num.txt` and `rishi_io_var_path.txt`. Generated `*.txt` files
are gitignored; the directory itself is the fixture anchor.

**The test joined the witness here on `20260908.052557`** (`ac25bfffc0`, *the shared-pen guard reads
a class*). It had written those three names under `/tmp` since it was seated. Eight ships run this
suite from eight checkouts on one pier, so a constant `/tmp` name is one name eight hands reach
for -- and what that shape invites here is a **false green** rather than a crash, since the test's
`list-dir` assertions would find a peer's files and pass even with `write-file` broken. A path
inside the checkout is per-ship by construction, because every ship owns its own checkout.
`tools/fixtures/s/shared_pen_scan.sh` reads every tracked `.sh` and `.rish` for that shape; until
the same day it read only `tools/`, which is why this file's move waited.
