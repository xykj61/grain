# REDS -- a message read mid-rebase

**Language:** EN
**Status:** Shelf -- one folded row from `construction/REDS.md`, kept whole
**Voice:** Kyri -- **Room:** checkable
**Folded:** `20260908.233626`
**Row:** `%653` (`20260908.233626`) -- CLOSED on the repaired commit, booked against the anointed
spine after `git fetch xy`.

The row folds on the lap it closed: the living pin stands 173 bytes under its bound with every
remaining row OPEN, and `reds_pin_capacity` answers `rows_that_fit=0`.

What the row is for, said once here so a reader arriving from a citation knows before they read.
A commit message in this tree is written to a file and handed to `git commit -F`, and a lap that
wants to edit the message it already wrote reads it back with `git log -1`. During a rebase, the
commit `git log -1` answers with is the last one successfully replayed, which on a tree that just
pulled is somebody else's. One law already tells a lap to ask whether a rebase is standing before
it amends. This is the same question asked one step earlier, of the read rather than of the write.

---

**REDS %653 (`20260908.233626`) -- a commit message read back mid-rebase is a peer's, and a silent substitution published it as mine.** *What went wrong:* this lap's round needed one word changed in a commit body that named a ledger shelf, and the body had to change again when a second rebase renumbered the row. The lap read the body back with `git log -1 --format=%B > .lap/msg-src.txt` **while a rebase was standing**, so what it captured was the peer commit `9de43937f` -- *tools: what a Rye program prints is prose too* -- rather than its own. The Python that edited the captured text used `str.replace` with **no assertion that the pattern was found**, so a substitution matching nothing wrote the peer's message out unchanged, and `git commit --amend -F` published it as the body of a commit whose eleven files were entirely this lap's. The **content was never in danger** -- `git show --stat` names exactly the round's own files -- and the body described a different change in another room. *What caught it:* `git log --oneline -1` printed a subject the lap had not written, in the same command that checked the amend had landed. *What it taught:* **`git log -1` answers about HEAD, and mid-rebase HEAD belongs to whoever was replayed last.** [`remember-git-nib`](../../.claude/rules/remember-git-nib.md) already asks a lap whether a rebase is standing before it *amends*, seated after an amend folded a lap into a peer's commit (`20260906.230614`). The read is the same question one step earlier, and the elder law does not reach it -- an amend guarded by `[ -d .git/rebase-merge ]` still writes the wrong body when the body was captured before the rebase ended. The second half is a habit rather than a law: **a text substitution that must match is an assertion**, and `s.replace(a, b)` with no `assert a in s` beside it is a rewrite that reports success for having done nothing. This lap's earlier edits all carried that assert; the one written under a rebase did not. *Repaired (`20260908.233626`):* the body rewritten from scratch rather than from a captured file, and the amend taken with the rebase finished, the index empty and HEAD re-read -- `024937fe4` carries this lap's own mechanism sentence. **CLOSED** on the landed commit, read back with `git log -1 --format=%B` at a settled HEAD.
