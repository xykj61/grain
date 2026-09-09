#!/bin/sh
# tools/fixtures/d/docs_command_path_control.sh -- prove the printed-path guard from both sides.
#
# WHY. A refusal proven only in the passing direction cannot be told from a bypass. Every
# behavior below is exercised on a real git repository in a throwaway pen, so the scan is asked
# the question a tree asks it rather than a question shaped to the answer. The plants are
# lifted afterward and the pen re-read, because a guard that reds forever proves nothing about
# the day the fault leaves.
#
# WHAT IT PROVES -- refusals bitten, honest readings left free:
#
#   BITTEN                                       FREE
#   1  a moved path printed in a code block      1  the same path once it is corrected
#   2  a moved path under a cd that misses       2  a path the tree carries at the root
#   3  two moved paths counted, not one          3  a path rescued by an earlier `cd`
#                                                4  a path rescued by the page's own directory
#                                                5  a path the tree carries NOWHERE (the reader
#                                                   writes it -- a tutorial placeholder)
#                                                6  a basename standing at two paths, where no
#                                                   repair has one answer
#                                                7  a moved path on DATED testimony, counted and
#                                                   never gated
#                                                8  the same path in PROSE rather than a block
#                                                9  a basename whose only home is gratitude/,
#                                                   which is a teacher's own path
#
# USAGE
#   sh tools/fixtures/d/docs_command_path_control.sh
#
# Driven by tools/d/docs_command_path_witness.rish. Run from the repository root.
set -eu

SCAN=$(cd "$(dirname "$0")" && pwd)/docs_command_path_scan.sh
[ -f "$SCAN" ] || { echo "control=absent detail=no_scan"; exit 1; }

PEN=$(mktemp -d "${TMPDIR:-/tmp}/docs-command-path-control.XXXXXX")
trap 'rm -rf "$PEN"' EXIT

pass=0
fail=0
# A case carries a KEY and a sentence: the witness asserts on the key, and a reader reads the
# sentence. Asserting on prose alone makes a reworded line look like a broken guard.
note() {
  if [ "$1" = ok ]; then pass=$((pass + 1)); echo "case=$2 ok -- $3"
  else fail=$((fail + 1)); echo "case=$2 FAIL -- $3"; fi
}

mkdir -p "$PEN/repo"
cd "$PEN/repo"
git init -q .
git config user.email pen@example.invalid
git config user.name pen
git config commit.gpgsign false

# The tree the pen carries: one moved fixture, one root-level tool, one two-homed basename, and
# one teacher's file under gratitude/.
mkdir -p docs-geode/edu/yonder/pleac/ch01 tools/g rye/src a/deep b/deep gratitude
printf 'gate\n' > docs-geode/edu/yonder/pleac/ch01/gate-say-u32.glow
printf '#!/bin/sh\n' > tools/g/glow_run.rish
printf 'const std\n' > rye/src/main.rye
printf 'twin\n' > a/deep/twin.rye
printf 'twin\n' > b/deep/twin.rye
printf 'style\n' > gratitude/TIGER_STYLE.md

run_scan() { sh "$SCAN" 2>/dev/null || true; }
reading() { run_scan | grep -E "^$1=" | cut -d= -f2; }
verdict() { run_scan | grep -E '^verdict=' | cut -d= -f2; }
details() { run_scan | grep -c '^detail:' || true; }

# --- FREE 2, 3, 4, 5, 6, 8, 9: an honest page in every shape the tree writes -------------
mkdir -p docs-geode/tutorials a/deep
cat > docs-geode/tutorials/honest.md <<'EOF'
# Honest

A root path, resolving as printed:

```sh
rishi/bin/rishi run tools/g/glow_run.rish
```

Rescued by a `cd` earlier in the same block:

```sh
cd rye
src/main.rye
```

Rescued by the page's own directory -- and the prose may name docs/TIGER_STYLE.md freely,
since only a fenced block is read.

```sh
sh honest-neighbor.sh
```

A path the tree carries nowhere, which the reader is being asked to write:

```sh
rishi/bin/rishi run tools/fixtures/my_first_witness.rish
```

A basename standing at two paths, where no repair has one answer:

```sh
rye run other/deep/twin.rye
```

A teacher's own path, whose only home here is the reading library:

```sh
cat docs/TIGER_STYLE.md
```
EOF
printf '#!/bin/sh\n' > docs-geode/tutorials/honest-neighbor.sh
git add -A >/dev/null
git commit -qm pen
v=$(verdict); [ "$v" = ok ] && note ok honest_free "an honest page in seven shapes passes free" || note bad honest_free "honest page reads $v"

# --- BITTEN 1: the moved path, printed ---------------------------------------------------
cat > docs-geode/edu/yonder/pleac/ch01/page.md <<'EOF'
# Page

```sh
rishi/bin/rishi run tools/g/glow_run.rish edu/pleac/ch01/gate-say-u32.glow 21
```
EOF
git add -A >/dev/null; git commit -qm plant
v=$(verdict); [ "$v" = moved_path_printed ] && note ok moved_bitten "a moved path printed in a block is bitten" || note bad moved_bitten "planted moved path reads $v"
[ "$(reading moved_living)" = 1 ] && note ok moved_counted "the moved path is counted once" || note bad moved_counted "moved_living reads $(reading moved_living)"
run_scan | grep -q 'the tree carries it at docs-geode/edu/yonder/pleac/ch01/gate-say-u32.glow' \
  && note ok repair_named "the detail names the repair rather than only the complaint" \
  || note bad repair_named "the detail does not name where the file stands"

# --- BITTEN 2: a cd that does not rescue -------------------------------------------------
cat > docs-geode/edu/yonder/pleac/ch01/page2.md <<'EOF'
# Page two

```sh
cd tools
edu/pleac/ch01/gate-say-u32.glow
```
EOF
git add -A >/dev/null; git commit -qm plant2
[ "$(reading moved_living)" = 2 ] && note ok cd_miss_bitten "a cd that misses leaves the path bitten, and two count as two" || note bad cd_miss_bitten "two plants read $(reading moved_living)"
[ "$(details)" -ge 2 ] && note ok detail_per_path "each bitten path prints its own detail line" || note bad detail_per_path "details read $(details)"

# --- FREE 7: the same fault on dated testimony, counted and never gated -------------------
rm -f docs-geode/edu/yonder/pleac/ch01/page.md docs-geode/edu/yonder/pleac/ch01/page2.md
mkdir -p active-designing/date/20260101
cat > active-designing/date/20260101/20260101-010101_elder.md <<'EOF'
# Elder

```sh
rishi/bin/rishi run tools/g/glow_run.rish edu/pleac/ch01/gate-say-u32.glow 21
```
EOF
git add -A >/dev/null; git commit -qm testimony
v=$(verdict)
[ "$v" = ok ] && note ok testimony_free "dated testimony keeps its words and gates nothing" || note bad testimony_free "testimony reads $v"
[ "$(reading moved_testimony)" = 1 ] && note ok testimony_counted "testimony is COUNTED rather than silent" || note bad testimony_counted "moved_testimony reads $(reading moved_testimony)"

# --- FREE 1: the plant lifted, the pen green again ---------------------------------------
rm -rf active-designing
cat > docs-geode/edu/yonder/pleac/ch01/page.md <<'EOF'
# Page

```sh
rishi/bin/rishi run tools/g/glow_run.rish docs-geode/edu/yonder/pleac/ch01/gate-say-u32.glow 21
```
EOF
git add -A >/dev/null; git commit -qm repair
v=$(verdict)
[ "$v" = ok ] && note ok repair_free "the corrected path walks free, so the guard is a gate and not a wall" || note bad repair_free "corrected path reads $v"
[ "$(reading moved_living)" = 0 ] && note ok returns_to_zero "the living count returns to zero when the fault leaves" || note bad returns_to_zero "moved_living reads $(reading moved_living)"

echo "control=docs_command_path pass=$pass fail=$fail"
[ "$fail" -eq 0 ] && echo "control=ok"
[ "$fail" -eq 0 ] || exit 1
