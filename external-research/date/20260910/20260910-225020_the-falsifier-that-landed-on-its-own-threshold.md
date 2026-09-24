# The falsifier that landed on its own threshold

**Stamp:** `20260910.225020` - **Voice:** Kyri - **Style:** Gauge, Field setting
**Status:** Landed - **Room:** checkable -- the change ships in this commit and
`tools/r/reds_spine_derive_witness.rish` binds it; the load caveat below is an observation about
this pier and is bound by nothing
**Lens:** TAME priority -- safety, then performance, then the joy of the craft
**Kin:** [`20260910-222440_the-serial-residue-has-a-name.md`](20260910-222440_the-serial-residue-has-a-name.md)
(the elder, whose falsifier this answers) -- [`../.claude/rules/derived-spine.md`](../.claude/rules/derived-spine.md)

The paper before this one measured the ledger spine's read, named the door, built the change against
a copy at `/tmp`, and wrote down exactly what would kill it. This lap lands the change in the tree
and runs that falsifier. One clause survives cleanly. The other lands on its own threshold, and
saying so is the whole point of having written it down.

## What changed, in plain words

`tools/fixtures/r/reds_spine_derive_scan.sh` read the anointed spine by walking two file lists. The
first walk spent a `git cat-file -e` existence check and a `git show <ref>:<path>` on each of this
checkout's 440 ledger files. The second walk spent another `git show` on each path `git ls-tree`
reported under the same ref, because a fold shelf may stand upstream and not here. Two walks of 440
files, one or two processes per file, is 878 `git show` calls and 440 existence checks.

Both walks are now one. The two lists are unioned with `sort -u`, each path is prefixed with the
ref by one `sed`, and `git cat-file --batch` streams every blob through the same `pairs_of` sed the
elder form used. The existence check is inherent rather than dropped: a path the ref lacks answers
`<input> missing` on one line, which carries no row headline, so the pattern finds nothing there.
The header line `<oid> blob <size>` is passed over for the same reason -- the pattern anchors on
`**REDS %` at the start of a line.

## The falsifier, clause by clause

**Clause one: any of the control's planted cases changing verdict kills it.**
`tools/fixtures/r/reds_spine_derive_control.sh` builds real git repositories in a throwaway pen and
proves each refusal from both sides. It reads `cases_ok=19 cases_red=0` with the batch form in
place -- 19 rather than the 17 the elder paper named, since a peer added two between the stamps.
The clause survives.

**And the live reading is identical, which the clause did not ask for.** Elder and batch forms were
run at the tree's own path, `20260910.224600`, and their whole outputs compared sorted: every gated
and reported number agrees (`shared_rows=615`, `shared_max=700`, `local_rows=615`, `rebindings=0`,
`squatters=0`, `published_doubles=7`, `stamp_duplicates=42`, `double_booked=0`, `next_free=701`,
`verdict=ok`) and so does every one of the 49 `detail:` lines.

**Clause two: a whole-scan wall above 15 seconds kills it.** This is where the honest answer sits.
Five runs on this pier, `20260910.224600` to `20260910.224719`, read **14,584 / 16,962 / 14,993 /
14,683 / 14,678 ms**. The median is 14,683 ms and one sample is above the line.

The elder form, timed in the same minutes on the same tree, read **36,118** and **35,014 ms**. So
the ratio is **2.4x**, which is what the prototype projected.

**The load is named rather than waved at.** `uptime` read a one-minute load average of **17.88** on
an **8-core** guest at `20260910.224719`, because seven peer ships were working their own trees.
The 15-second threshold was set against a prototype run at `20260910.223000`, whose load I did not
record -- so the two numbers are not comparable, and I decline to claim the clause passed.

**What is comparable is the process count, which no load can move.** `strace -f -e trace=execve`
over the batch form counts **1,745** execve, against the elder form's 3,940 measured in the paper
before this one: **4 `git` calls** where there were 1,323. That figure matches the prototype's
projection exactly, program by program -- 1,258 `awk`, 442 `sed`, 4 `git` -- which is the reading
that makes the wall-clock band believable rather than the other way around.

## What this pays for, and what it does not

Four live guards and one hook read this scan: `reds_spine_derive`, `reds_shelf_name`,
`reds_ledger_monotone`, `unshared_citation`, and `tools/hooks/pre-push`. All four witnesses are
GREEN here with the batch form in place, and the pre-push witness proves the hook's own path.

**The residue did not move, and it has the same name it had.** Of the 1,745 processes, **1,258 are
`awk`** and **442 are `sed`**. The awk belong to two loops that walk the ledger's 615 rows twice,
spawning a fresh `awk` per row to look one answer up in a file -- a join written as a scan. The sed
belong to the local read, which still forks `pairs_of` once per ledger file. Neither was touched
this lap, on purpose: the git calls were the keystone, and one keystone per round.

## Projection

**Horizon:** one lap, on this pier, against this ledger at 440 files and 615 rows.
**Assumptions:** the fold shelves stay immutable; `git cat-file --batch` is present in every
checkout this guard runs in; and the union of the two file lists is what the elder two walks
produced between them.
**Falsifier for the next door:** rewrite the two row-joins as one `awk` pass each and expect the
execve count to fall from 1,745 to roughly 490; a count above 900, or any of the control's 19 cases
changing verdict, kills it.
**Confidence:** high on the readings and the process counts, since both are measured and the
process count is load-independent; moderate on the wall-clock ratio, since this pier was carrying
seven peer ships while it was taken.

## What the lap taught about its own threshold

A wall-clock threshold is a claim about a machine as much as about a program. The process count
survived the loaded hour and the wall-clock did not, so the falsifier that earned its keep was the
one counting something the machine could not change underneath it. **Prefer a load-independent
falsifier where one exists**, and when only a wall-clock one is available, write the load down
beside it at the moment the threshold is set.
