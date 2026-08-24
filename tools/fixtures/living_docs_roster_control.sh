#!/bin/sh
# tools/fixtures/living_docs_roster_control.sh -- the roster-coverage guard, proven from both sides.
#
# WHY. A refusal proven only in the passing direction cannot be told from a bypass. This pen
# builds real git repositories holding real .rye sources, real READMEs, and a real roster script,
# plants one fault at a time, and asks the scan what it reads -- so every gate is shown biting and
# every honest shape is shown passing free.
#
# Three of the sixteen carry the load. Case 2 drops one front door from the roster and watches the
# gate bite, which is the whole fault of REDS %187 in miniature. Case 7 leaves a README UNTRACKED
# beside a tracked source and watches it pass free, which proves the tree is asked with git rather
# than with a glob -- a glob would have manufactured a door out of a scratch file. And cases 12 and
# 13 show the ratchet ceiling from both sides, six over-bound pages free and seven bitten, so no
# override exists and none is wanted.
#
# Each case prints one line naming what was planted and whether it was bitten or left free. The
# tally at the end is what tools/l/living_docs_roster_witness.rish asserts on.
#
# Run from the repository root:  sh tools/fixtures/living_docs_roster_control.sh
set -eu

SCAN=$(pwd)/tools/fixtures/living_docs_roster_scan.sh
PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

fail=0
n=0

# pen <name> -- a fresh git repository with an empty roster.
pen() {
  d="$PEN/$1"
  rm -rf "$d"
  mkdir -p "$d"
  ( cd "$d" && git init -q . )
  : >"$d/roster.sh"
}

# door <pen> <dir> <bytes> -- a module: a .rye source and a README of the given size.
door() {
  d="$PEN/$1"
  if [ "$2" = "." ]; then t="$d"; else t="$d/$2"; fi
  mkdir -p "$t"
  printf '// a module\n' >"$t/thing.rye"
  head -c "$3" /dev/zero | tr '\0' 'x' >"$t/README.md"
}

# roster_add <pen> <path> -- one line on the pen's roster.
roster_add() {
  echo "echo '$2'" >>"$PEN/$1/roster.sh"
}

stage() { ( cd "$PEN/$1" && git add -A . >/dev/null 2>&1 ) || true; }

# check <label> <pen> <ok|red> <key that must appear>
check() {
  n=$((n + 1))
  out=$(sh "$SCAN" census "$PEN/$2" 2>&1) && code=0 || code=$?
  bad=0
  if [ "$3" = ok ]; then [ "$code" -eq 0 ] || bad=1; else [ "$code" -ne 0 ] || bad=1; fi
  case "$out" in *"$4"*) ;; *) bad=1 ;; esac
  if [ "$bad" -eq 0 ]; then
    if [ "$3" = ok ]; then echo "$n free: $1"; else echo "$n bitten: $1"; fi
  else
    fail=$((fail + 1))
    echo "$n MISREAD: $1 -- wanted $3 with $4, read code=$code"
    echo "$out" | sed 's/^/    /'
  fi
}

# 1 -- the honest shape, first, so every later bite means something.
pen a; door a mod1 100; door a mod2 100; stage a
roster_add a mod1/README.md; roster_add a mod2/README.md
check "a roster naming both front doors reads clean at two" a ok "unrostered=0"

# 2 -- the gate this guard exists for: REDS %187 in miniature.
pen b; door b mod1 100; door b mod2 100; stage b
roster_add b mod1/README.md
check "a front door missing from the roster counts against the gate" b red "unrostered=1"

# 3 -- the mirror: a roster naming a file that has moved or folded away.
pen c; door c mod1 100; stage c
roster_add c mod1/README.md; roster_add c gone/README.md
check "a rostered path naming no file counts against the gate" c red "phantom=1"

# 4 -- a room's index is not a module's door.
pen d; door d mod1 100; mkdir -p "$PEN/d/room"; printf '# room\n' >"$PEN/d/room/README.md"; stage d
roster_add d mod1/README.md
check "a README with no .rye beside it is a room index, left free" d ok "front_doors=1"

# 5 -- sources with no front door yet are not a fault this guard names.
pen e; door e mod1 100; mkdir -p "$PEN/e/bare"; printf '// bare\n' >"$PEN/e/bare/thing.rye"; stage e
roster_add e mod1/README.md
check "a .rye directory carrying no README yet is left free" e ok "unrostered=0"

# 6 -- planted corpora are read by scans, never entered by readers.
pen f; door f mod1 100; door f tools/fixtures/corpus 100; stage f
roster_add f mod1/README.md
check "a fixture corpus under tools/fixtures/ is never a front door" f ok "front_doors=1"

# 7 -- the load-bearing one: the tree is asked with git, not with a glob.
pen g; door g mod1 100; stage g
door g scratch 100
roster_add g mod1/README.md
check "an UNTRACKED README beside a tracked source is invisible to the rule" g ok "front_doors=1"

# 8 -- the root is a directory too.
pen h; door h . 100; stage h
roster_add h README.md
check "a .rye at the repository root makes the root README a front door" h ok "front_doors=1"

# 9 -- a page held by hand for a reason the rule cannot see stays welcome.
pen i; door i mod1 100; mkdir -p "$PEN/i/deep/src"; printf '// deep\n' >"$PEN/i/deep/src/thing.rye"
printf '# deep\n' >"$PEN/i/deep/README.md"; stage i
roster_add i mod1/README.md; roster_add i deep/README.md
check "a hand-held page the rule cannot reach adds no fault" i ok "roster_reaches_tree=yes"

# 10 -- the corpus is published, so a reading over nothing can never look like a pass.
pen j; : >"$PEN/j/roster.sh"; stage j
check "an empty tree publishes front_doors=0 rather than hiding it" j ok "front_doors=0"

# 11 -- a rostered page under the bound is ordinary work.
pen k; door k mod1 24576; stage k
roster_add k mod1/README.md
check "a page exactly at the bound is under it, and passes free" k ok "over_bound=0"

# 12 -- the ratchet ceiling, from below.
pen l; door l mod1 100; stage l; roster_add l mod1/README.md
i=1
while [ "$i" -le 6 ]; do
  mkdir -p "$PEN/l/big$i"; head -c 24577 /dev/zero | tr '\0' 'x' >"$PEN/l/big$i/README.md"
  roster_add l "big$i/README.md"; i=$((i + 1))
done
stage l
check "six over-bound pages sit at the ceiling and pass free" l ok "over_bound=6"

# 13 -- the ratchet ceiling, from above.
pen m; door m mod1 100; stage m; roster_add m mod1/README.md
i=1
while [ "$i" -le 7 ]; do
  mkdir -p "$PEN/m/big$i"; head -c 24577 /dev/zero | tr '\0' 'x' >"$PEN/m/big$i/README.md"
  roster_add m "big$i/README.md"; i=$((i + 1))
done
stage m
check "seven over-bound pages cross the ceiling and are bitten" m red "over_bound=7"

# 14 -- an over-bound page is named, never merely counted.
pen o; door o mod1 100; stage o; roster_add o mod1/README.md
mkdir -p "$PEN/o/huge"; head -c 30000 /dev/zero | tr '\0' 'x' >"$PEN/o/huge/README.md"
roster_add o huge/README.md; stage o
check "an over-bound page is named with its byte count" o ok "page_over_bound=huge/README.md bytes=30000"

# 15 -- a roster regressed to a short hand list reds, which is the whole point of the guard.
pen p
i=1
while [ "$i" -le 6 ]; do door p "mod$i" 100; i=$((i + 1)); done
stage p
roster_add p mod1/README.md; roster_add p mod2/README.md
check "a roster regressed to a hand list of two over six doors is bitten" p red "unrostered=4"

# 16 -- both faults at once report the coverage one, since it is the larger.
pen q; door q mod1 100; door q mod2 100; stage q
roster_add q mod1/README.md; roster_add q gone/README.md
check "coverage and phantom together name the coverage verdict" q red "verdict=front_door_off_the_meter"

echo "control_cases=$n"
echo "control_fail=$fail"
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=misread"; exit 1; fi
