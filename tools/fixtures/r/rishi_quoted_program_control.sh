#!/bin/sh
# tools/fixtures/r/rishi_quoted_program_control.sh -- the plants that prove the quoted-program
# reading bites, and that it lets the tolerated forms stand.
#
# Every refusal is shown from both sides: planted and then lifted. A refusal proven only in the
# passing direction cannot be told from a bypass. The first two legs go further and prove the
# fault is REAL rather than a pattern -- awk is run on the planted program text and on the
# repaired text, and the first must refuse where the second answers.
#
#   sh tools/fixtures/r/rishi_quoted_program_control.sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
SCAN="$root/tools/fixtures/r/rishi_quoted_program_scan.sh"

pen=$(mktemp -d "${TMPDIR:-/tmp}/qprog.XXXXXX")
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0; fail=0
check() {
  if [ "$2" = "$3" ]; then pass=$((pass + 1)); else fail=$((fail + 1)); echo "FAIL: $1 -- wanted [$3] got [$2]"; fi
}
read_field() { sed -n "s/^$2=//p" "$1" | head -1; }

run_scan() {
  ( cd "$pen" && QPROG_ROOT="$pen" QPROG_LIST="$pen/list.txt" sh "$SCAN" > "$pen/out.txt" 2>"$pen/err.txt" ) || true
}

# ---- the fault is real, not a pattern: awk itself is asked ----
if awk '$0 == \"x\"' /dev/null 2>/dev/null; then broke=no; else broke=yes; fi
check "awk refuses a string literal spelled with a backslash-quote" "$broke" "yes"
if awk -v k=x '$0 == k' /dev/null 2>/dev/null; then repaired=yes; else repaired=no; fi
check "awk reads the repaired form that hands the literal in with -v" "$repaired" "yes"

# ---- a clean corpus ----
mkdir -p "$pen/tools"
cat > "$pen/tools/clean.rish" <<'EOF'
let a = run ["sh" "-c" "awk -v k=file '$1 == k { print $2 }' .brix"]
EOF
printf 'tools/clean.rish\n' > "$pen/list.txt"
run_scan
check "a clean corpus reads zero fatal sites" "$(read_field "$pen/out.txt" awk_fatal)" "0"
check "a clean corpus reads ok" "$(read_field "$pen/out.txt" verdict)" "ok"
check "a clean corpus counts its sources" "$(read_field "$pen/out.txt" sources)" "1"

# ---- the awk plant, and its lift ----
cat > "$pen/tools/planted.rish" <<'EOF'
let a = run ["sh" "-c" "awk '$1 == \"file\" { print $2 }' .brix"]
EOF
printf 'tools/clean.rish\ntools/planted.rish\n' > "$pen/list.txt"
run_scan
check "an awk string-literal plant is fatal" "$(read_field "$pen/out.txt" awk_fatal)" "1"
check "an awk string-literal plant refuses" "$(read_field "$pen/out.txt" verdict)" "refused"
rm -f "$pen/tools/planted.rish"
printf 'tools/clean.rish\n' > "$pen/list.txt"
run_scan
check "lifting the awk plant returns the reading to ok" "$(read_field "$pen/out.txt" verdict)" "ok"

# ---- grep and sed are tolerated, never fatal ----
cat > "$pen/tools/greppy.rish" <<'EOF'
let a = run ["sh" "-c" "grep -q 'const x = \"y\"' src.rye"]
EOF
cat > "$pen/tools/seddy.rish" <<'EOF'
let a = run ["sh" "-c" "sed -n 's/a\"b/OK/p' q.txt"]
EOF
printf 'tools/clean.rish\ntools/greppy.rish\ntools/seddy.rish\n' > "$pen/list.txt"
run_scan
check "grep and sed sites are never fatal" "$(read_field "$pen/out.txt" awk_fatal)" "0"
check "grep and sed sites are counted as tolerated" "$(read_field "$pen/out.txt" tolerated)" "2"
check "two tolerated sites under the ceiling read ok" "$(read_field "$pen/out.txt" verdict)" "ok"

# ---- the tolerated ceiling, from both sides ----
( cd "$pen" && QPROG_ROOT="$pen" QPROG_LIST="$pen/list.txt" QPROG_CEILING=2 sh "$SCAN" > "$pen/out.txt" 2>&1 ) || true
check "two tolerated sites AT a ceiling of two read ok" "$(read_field "$pen/out.txt" verdict)" "ok"
( cd "$pen" && QPROG_ROOT="$pen" QPROG_LIST="$pen/list.txt" QPROG_CEILING=1 sh "$SCAN" > "$pen/out.txt" 2>&1 ) || true
check "two tolerated sites over a ceiling of one refuse" "$(read_field "$pen/out.txt" verdict)" "refused"

# ---- what the reading must leave alone ----
cat > "$pen/tools/outside.rish" <<'EOF'
let a = run ["sh" "-c" "test -z \"$HOME\" || echo expanded"]
EOF
cat > "$pen/tools/prose.rish" <<'EOF'
# a comment naming awk '$1 == \"file\"' must be free to teach the fault
let a = run ["sh" "-c" "echo fine"]
EOF
cat > "$pen/tools/norun.rish" <<'EOF'
let a = "awk '$1 == \"file\"'"
EOF
printf 'tools/outside.rish\ntools/prose.rish\ntools/norun.rish\n' > "$pen/list.txt"
run_scan
check "a backslash-quote outside single quotes is left alone" "$(read_field "$pen/out.txt" quoted_program_sites)" "0"
check "prose and non-run lines are read past" "$(read_field "$pen/out.txt" verdict)" "ok"

# ---- a corpus of zero refuses rather than reporting a clean sweep ----
: > "$pen/list.txt"
rc=0
( cd "$pen" && QPROG_ROOT="$pen" QPROG_LIST="$pen/list.txt" sh "$SCAN" >/dev/null 2>&1 ) || rc=$?
check "a corpus of zero refuses" "$rc" "2"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
