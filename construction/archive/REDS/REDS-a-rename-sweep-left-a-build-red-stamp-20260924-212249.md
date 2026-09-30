# REDS shelf -- a rename sweep left a build red

**Language:** EN
**Status:** Archive -- one closed, stamp-cited REDS row shed from `construction/REDS.md` under the
writer-sheds rule, to clear headroom for a fresh row while the pin's numbered rows sat all **OPEN**
and unfoldable by the automated tool (`tools/fixtures/r/reds_fold.sh` matches only `**REDS %<N> `).
The row carries no shared `%N` -- it stayed local, cited by stamp per
[`derived-spine`](../../../.claude/rules/derived-spine.md) rule 4 -- so this shelf was written by
hand, following the same shape the tool writes.

---

*Row `20260924.212249` folded here on `20260930.005500`, **CLOSED** -- a rename sweep left
`session_logs_archive` refusing to build, its selftest untested underneath.*

**REDS `20260924.212249` -- a rename sweep left `session_logs_archive` refusing to build, its
selftest untested underneath.** *What went wrong:* the `20260921` bron-to-kyri breach left a
duplicate `const is_kyri` -- a compile error blocking every caller. Underneath, `cc9053b03` had
widened a fixture link one fold-depth further, unfollowed by the selftest's fixed-string assert.
*What caught it:* opening this seat's own owed archive-fold repair found the build refusing. *What
it taught:* a tool invoked only by name, ungated in the cold pass, reads absent rather than red
until used. *Repaired:* duplicate removed; assert follows the widened link. Witness GREEN; stale
`rye`/`rishi` binaries rebuilt; `fold_shelf_link_repoint.sh` then closed seventeen depth-lost links
this absence had left unrepaired. **CLOSED**.
