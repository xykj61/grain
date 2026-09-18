# REDS -- the build lock a send tracked

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- one folded row, immutable once written
**Room:** checkable -- a ledger row, its reading proven by a witness on real commits
**Folded:** `20260917.201500` from [`../REDS.md`](../REDS.md)

One row, folded to hold the pin under the 65,536-byte bound eight ships share.

It teaches that `git add -A` cannot tell a lap's own work from this machine's weather: a send that
stages the whole index beside a live build can carry a transient lock path into a commit, and the
narrow repair (untracking the one file) leaves the wider question -- whether the ignore list should
name the pattern, and whether a guard should read the index for transient paths at all -- for the
card rather than for a repair made inside a repair.

**REDS %805 (`20260917.023800`) -- a lap's own send tracked a build lock, and the sweep that took it is the one every lap runs.** *What went wrong:* commit `4046be3a4` added `caravan/.rye-build.lock/pid` -- one process id a `rye build` writes to hold its lock and removes when it finishes. It reached the index through `git add -A`, run while a build held the lock, during a send that took two rebases and a stash cycle. *What caught it:* reading `git show --stat` on this seat's own landed commit, after the push. Nothing else did: the pre-commit hook reads the pin bound, `exec_bit` reads modes, and no standing guard asks whether a path in the index is transient. *What it taught:* **`git add -A` is the one command in the send that cannot tell this lap's work from this machine's weather.** The baton already asks a send to *stage exactly its own set and prove the index holds nothing else*, and this lap did neither -- it ran the whole-index form the same clause permits for the staging hook's pages, on a tree where a peer's build was live. The two halves of that sentence pull against each other and the weaker one won. *The narrow half is closed:* `git rm --cached` untracks the file, the directory stays on disk for whichever build owns it, and `git ls-files` reads zero `.rye-build.lock` paths. *What this does not reach, and it is the whole class:* **no ignore rule names the pattern.** `git check-ignore -v caravan/.rye-build.lock/pid` answers nothing, so the next `git add -A` beside a live build takes it again -- and `.gitignore` here denies the root with `/*` and allows paths back one at a time, so a build-output path inside an allowed room stands outside that deny by construction. Eight ships build in eight trees. Whether the ignore list names the pattern, and whether a guard should read the index for transient paths at all, wants the card rather than a repair made inside a repair. *Repaired:* commit `27da27db0` ("tools: name the build lock a round-open swept") gave `.gitignore` one line, `.rye-build.lock/`, as a pattern rather than a path -- so `git add -A` beside a live build takes no lock path, proven on that send's own evidence, three lock directories standing on disk while the index carried none. `tools/b/build_lock_ignore_witness.rish` reads GREEN on metal, twenty-nine legs, three mutations bitten, and the commit's own body names the closure: "This closes the deferred half REDS %805 named." *What this does not reach:* whether a guard should also read the index for transient paths at all -- a second question this row asked and the same commit left standing, since naming the pattern removes the need rather than answering it. **CLOSED** (`20260917.193431`).
