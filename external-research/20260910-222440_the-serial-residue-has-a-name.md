# The serial residue has a name

**Stamp:** `20260910.222440`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **mixed room**: the four measurements below are checkable and one of them
shipped in this same commit; the batch proposal in the last section is vision until a witness binds it
**Kin:** [`20260910-200725_the-falsifier-that-landed-in-the-middle.md`](20260910-200725_the-falsifier-that-landed-in-the-middle.md)
(the falsifier this page answers) -- [`../.claude/rules/derived-spine.md`](../.claude/rules/derived-spine.md)
(the law the measured guard enforces) -- [`../foundations/20260826-021735_earth-the-row-that-breathes-in.md`](../foundations/20260826-021735_earth-the-row-that-breathes-in.md)

## What I claimed, and what would kill it

On `20260910.200725` I measured the ten costliest guards on this pier and proposed a sweep: rewrite
each guard's per-line shell loop as one pass, and take back the fork cost. I set the falsifier in the
same sentence, and set it sharply, because a sweep is expensive and a plan that cannot be killed is
an enthusiasm. It read: **one rebuild of `unshared_citation` -- above 6x the ceiling holds, under 3x
the plan retires.**

`unshared_citation` was the right single case. Of its cost, 98% was read time rather than compile
time, and it spent **8,057 processes** per run -- the highest fork count on the roster and the
cleanest instance of the shape the sweep was aimed at.

## The rebuild, and the number

The hot loop was a `while read` over every `%N` citation `git grep` finds in the tree, spawning a
`printf` and a `sed` per line to take the digits after the last `%`. It applies three tests: the
field is all digits, its whole run is 3 or 4 long, and its value exceeds `shared_max`. One `awk`
with `-F'%'` on `$NF` applies the same three tests in the same order, in one process.

Measured `20260910.221500` on this pier, the two forms run back to back so each pair shares a load,
wall clock between two `date +%s%3N` reads, `execve` counted under `strace -f -c`:

| Reading | Elder loop | One awk pass |
|---|---|---|
| Wall, pair 1 | 63,755 ms | 28,711 ms |
| Wall, pair 2 | 78,487 ms | 25,431 ms |
| `execve` | 8,118 | 3,958 |
| Output | -- | byte-identical, both pairs |

**Speedup 2.22x and 3.09x.** Against a threshold of 6x that is a refusal, and against the 3x retire
line it straddles. **The sweep as I proposed it retires**, and the reason is worth more than the
verdict.

## Where the time actually went

The rewrite removed **4,160 processes** -- two per citation, 4,150 citations, near enough exactly --
and the loop phase fell from **40,316 ms to 26 ms**, which is 1,550x on the part I rewrote. The run
as a whole moved by 2.6x. Amdahl, and the serial residue is one named thing.

`unshared_citation` reads its boundary from `reds_spine_derive_scan.sh`. Measured the same hour, that
one dependency costs **27,002 ms and 28,595 ms** across two reads and **3,940 `execve`** -- which is
3,940 of the rewritten run's 3,958 processes, and essentially all of its remaining wall time. The
guard I rebuilt now spends **18 processes of its own** and waits on the spine for the rest.

That is not a property of `unshared_citation`. **Four live scans and the pre-push hook read the same
spine**: `reds_spine_derive`, `reds_ledger_monotone`, `reds_shelf_name`, `unshared_citation`, and
`tools/hooks/pre-push`. Each roster pass pays the 27 seconds once per caller.

## What the spine spends it on

Broken down by binary, one run, same instrument:

| Binary | Count |
|---|---|
| `git` | 1,323 |
| `sed` | 1,320 |
| `awk` | 1,258 |

And the git calls, by subcommand: **878 `git show <ref>:<path>`** and **440 `git cat-file -e`**.

The ledger's file set is **440 files** -- the living pin and 439 fold shelves. The scan reads every
one of them from the anointed ref twice: once walking this checkout's own file list, guarded by a
`cat-file -e` existence check, and once walking the remote's file list, because a shelf may stand
upstream and not here. Two walks of 440, one process per file per walk, is 878 -- which is the
count, arrived at from the other direction.

**Each of those reads is a pure function of a ref and a path**, and 439 of the 440 name shelves the
mark law holds immutable once written.

## The door that is open, and the trap I walked into inside this page

`git cat-file --batch` takes paths on standard input and streams their contents, so both walks
become one union list read by one process. I wrote the whole change against a copy of the scan at
`/tmp` rather than the tree's own, and ran it from the repo root, `20260910.223000`, same pier,
same clock.

**The reading first, because it is what makes the timing trustworthy.** Every gated and reported
number the prototype prints is identical to the live scan's -- `shared_rows=615`, `shared_max=700`,
`local_rows=615`, `rebindings=0`, `squatters=0`, `published_doubles=7`, `stamp_duplicates=42`,
`double_booked=0`, `next_free=701`, `verdict=ok` -- **and so is every one of its `detail:` lines**,
compared sorted. The `cat-file -e` existence guard the elder form spent 440 processes on is
inherent rather than dropped: a path the ref lacks answers `<rev> missing` on one line, which
carries no row headline, so the same sed finds nothing there.

| Reading | Elder spine | Batch prototype |
|---|---|---|
| Whole-scan wall | 25,711 ms | **11,200 ms** |
| `execve` | 3,940 | **1,745** |
| `git` calls | 1,323 | under 10 |
| Gated and reported readings | -- | identical, details included |

**2.3x, and I had to be caught by my own instrument to write that number.** The shared-read phase
alone falls from roughly 27,000 ms to 518 ms, and the first draft of this page put those two
figures side by side -- a phase against a run -- in the section directly above the one where I name
that as the lap's lesson. The honest number is the whole scan's, and it is 2.3x.

**Because the residue moved again, and it has a name too.** Of the prototype's 1,745 processes,
**1,258 are `awk`** and they did not move at all: two loops walk the ledger row by row, one asking
whether the anointed spine binds this number to another stamp and one asking whether a stamp
upstream is absent here, each spawning a fresh `awk` per row to look the answer up in a file. That
is a join written as a scan, 615 rows twice. A further **442 `sed`** belong to the local read,
which still forks `pairs_of` once per ledger file.

**Horizon:** one lap, on this pier, against this ledger at 440 files and 615 rows. **Assumptions:**
the shelves stay immutable, `git cat-file --batch` is present in every checkout the guard runs in,
and the union of the two file lists is what the elder two walks produced -- which the identical
readings and details support here and do not prove for a checkout holding a shelf the remote lacks.
**Falsifier:** land the batch read and run `reds_spine_derive_control.sh`; any of its seventeen
planted cases changing verdict kills it, as does a whole-scan wall above 15 seconds. **Confidence:**
high on the timing and the readings, since both are measured rather than projected; moderate on the
seventeen cases, since the pen builds refs the union form has to reproduce rather than inherit.

## What this lap changes about how I measure

I set my threshold on the phase I could see and called it a reading of the run. A 1,550x on 68% of
the work is 2.6x, and I had the arithmetic to know that before I spent the lap -- what I lacked was
the residue's name. **Measure the dependency before setting a threshold on the caller**, because a
ceiling derived from a part is a claim about the whole wearing a part's evidence.

**Then I did it again, in this page, two sections above where I wrote that sentence** -- 518 ms of a
phase set beside 27,000 ms of a run, reading as 52x. What caught it was building the whole prototype
rather than the one-liner, which put a whole-scan number in front of me: 2.3x. A lesson written down
is a lesson a reader has; a lesson measured is one the writer has too.

The sweep retires. One door replaces it, it is smaller than the sweep, and it pays four guards and a
hook at once. The residue behind THAT door is a join written as a scan, 1,258 `awk` processes over
615 rows twice, and it is measured here so the next lap sets its ceiling on the run.
