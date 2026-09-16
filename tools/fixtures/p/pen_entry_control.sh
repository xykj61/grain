#!/bin/sh
# tools/fixtures/p/pen_entry_control.sh -- the pen-entry reading, shown from both sides.
#
#   sh tools/fixtures/p/pen_entry_control.sh
#
# WHY THIS EXISTS. A guard that refuses everything passes a one-sided proof. So every case here is
# planted and then LIFTED: the same file, guarded each of the three lawful ways, must walk free, and
# the ceiling is shown from both sides.
#
# Each case builds a real git repository in a throwaway pen and runs the scan from inside it. The
# scan's population comes from `git ls-files`, so a pen holding a repository is what lets it read at
# all. The scan itself is invoked by its ABSOLUTE path from outside the pen, which keeps the file
# under test out of the population it reads.
#
# FOUR MUTATIONS are asserted to BITE: the continuation join, the `&&` guard test, the
# transitive pen-variable collection, and the comment-and-heredoc skip. Each is a `BEGIN` switch in the scan's awk program, flipped
# here by replacing one literal, so a mutation carries no regular-expression escaping of its own.
# Each is then required to walk free unmutated, since a bite proves only half of a predicate.
#
# READINGS: `pass=N fail=N` and a `control_verdict=` line. Exit 1 when any case fails.

set -u

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
SCAN="$ROOT/tools/fixtures/p/pen_entry_scan.sh"
[ -f "$SCAN" ] || { echo "refused: scan absent -- $SCAN"; echo "control_verdict=no_scan"; exit 1; }

pen=$(mktemp -d) || { echo "refused: pen absent -- $0 did not enter its pen; fixtures would land in the live tree" >&2; echo "control_verdict=no_pen"; exit 1; }
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0

ck() { # ck <name> <want-substring> <haystack>
  if printf '%s\n' "$3" | grep -q -- "$2"; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
    echo "FAIL $1 -- wanted '$2'"
    printf '%s\n' "$3" | sed 's/^/     /'
  fi
}

# build <name> -- a fresh repository under the pen, entered safely.
build() {
  rm -rf "$pen/$1"
  mkdir -p "$pen/$1" || return 1
  ( cd "$pen/$1" || { echo "refused: pen absent" >&2; exit 1; }
    git init -q -b main .
    git config user.email pen@example.invalid
    git config user.name pen
    git config commit.gpgsign false ) >/dev/null 2>&1
}

# run <name> [ceiling] [scan] -- the scan's output, read from inside that pen repository.
run() {
  ( cd "$pen/$1" || exit 0
    git add -A >/dev/null 2>&1
    PEN_ENTRY_CEILING="${2:-0}" sh "${3:-$SCAN}" 2>&1 )
}

# code <name> [ceiling] -- that run's exit status.
code() {
  ( cd "$pen/$1" || { echo 99; exit 0; }
    git add -A >/dev/null 2>&1
    PEN_ENTRY_CEILING="${2:-0}" sh "$SCAN" >/dev/null 2>&1; echo $? )
}

# ---- 1. the bare shape refuses ----------------------------------------------------------------

build bare || { echo "control_verdict=no_pen"; exit 1; }
cat > "$pen/bare/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d)
cd "$pen"
printf 'x\n' > README.md
EOF
out=$(run bare)
ck "an unguarded cd into the pen is counted"        "unguarded=1"          "$out"
ck "the site itself is counted"                     "pen_sites=1"          "$out"
ck "the file is counted as a runner"                "runners=1"            "$out"
ck "the bare shape refuses"                         "verdict=unguarded"    "$out"
ck "the bare shape exits 1"                         "^1$"                  "$(code bare)"

# ---- 2. each of the three lawful guards walks free ---------------------------------------------

build guard_or
cat > "$pen/guard_or/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d) || exit 1
cd "$pen" || exit 1
printf 'x\n' > README.md
EOF
out=$(run guard_or)
ck "cd guarded by || walks free"                    "unguarded=0"          "$out"
ck "the guarded site is still counted"              "pen_sites=1"          "$out"
ck "the || shape passes"                            "verdict=guarded"      "$out"
ck "the || shape exits 0"                           "^0$"                  "$(code guard_or)"

build guard_and
cat > "$pen/guard_and/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d) || exit 1
( cd "$pen" && printf 'x\n' > README.md )
EOF
out=$(run guard_and)
ck "cd chained by && walks free"                    "unguarded=0"          "$out"
ck "the chained site is still counted"              "pen_sites=1"          "$out"

build guard_sete
cat > "$pen/guard_sete/case.sh" <<'EOF'
#!/bin/sh
set -eu
pen=$(mktemp -d)
cd "$pen"
printf 'x\n' > README.md
EOF
out=$(run guard_sete)
ck "cd under set -e walks free"                     "unguarded=0"          "$out"
ck "set -eu is read as set -e"                      "verdict=guarded"      "$out"

build guard_sete_late
cat > "$pen/guard_sete_late/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d) || exit 1
cd "$pen"
set -e
EOF
out=$(run guard_sete_late)
ck "set -e AFTER the cd does not guard it"          "unguarded=1"          "$out"

# ---- 3. the continuation join -------------------------------------------------------------------

build cont
printf '#!/bin/sh\npen=$(mktemp -d) || exit 1\n( cd "$pen" \\\n    && printf x > README.md )\n' \
  > "$pen/cont/case.sh"
out=$(run cont)
ck "a backslash-continued && guard walks free"      "unguarded=0"          "$out"
ck "the continued site is still counted"            "pen_sites=1"          "$out"

# ---- 4. only a pen variable counts ---------------------------------------------------------------

build other_var
cat > "$pen/other_var/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d) || exit 1
HOMEBASE=$(pwd)
cd "$HOMEBASE"
EOF
out=$(run other_var)
ck "a cd to a non-pen variable is not a site"       "pen_sites=0"          "$out"
ck "and is never counted unguarded"                 "unguarded=0"          "$out"

build derived
cat > "$pen/derived/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d) || exit 1
d="$pen/t"
cd "$d"
EOF
out=$(run derived)
ck "a variable derived from the pen is reached"     "pen_sites=1"          "$out"
ck "and its unguarded cd is counted"                "unguarded=1"          "$out"

build no_pen_file
cat > "$pen/no_pen_file/case.sh" <<'EOF'
#!/bin/sh
cd /var/empty
EOF
out=$(run no_pen_file)
ck "a file making no pen is not a runner"           "runners=0"            "$out"

# ---- 4b. a comment line and a heredoc body are read past -------------------------------------

build commented
cat > "$pen/commented/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d) || exit 1
# teaching line: a bare ( cd "$pen"; work ) is the fault this guard reads
printf 'x\n' > /dev/null
EOF
out=$(run commented)
ck "a cd inside a comment is not a site"             "pen_sites=0"          "$out"
ck "and never counts unguarded"                      "unguarded=0"          "$out"

build heredoc
cat > "$pen/heredoc/case.sh" <<'OUTER'
#!/bin/sh
pen=$(mktemp -d) || exit 1
cat > "$pen/inner.sh" <<'INNER'
cd "$pen"
INNER
OUTER
out=$(run heredoc)
ck "a cd inside a heredoc body is not a site"        "pen_sites=0"          "$out"
ck "and never counts unguarded"                      "unguarded=0"          "$out"

# ---- 5. the unchecked mktemp reading -------------------------------------------------------------

build mk_bare
cat > "$pen/mk_bare/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d)
EOF
out=$(run mk_bare)
ck "a bare mktemp assignment is reported"           "unchecked_mktemp=1"   "$out"
ck "and it does not refuse on its own"              "verdict=guarded"      "$out"

build mk_or
cat > "$pen/mk_or/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d) || exit 1
EOF
out=$(run mk_or)
ck "mktemp guarded by || is not reported"           "unchecked_mktemp=0"   "$out"

build mk_sete
cat > "$pen/mk_sete/case.sh" <<'EOF'
#!/bin/sh
set -e
pen=$(mktemp -d)
EOF
out=$(run mk_sete)
ck "mktemp under set -e is not reported"            "unchecked_mktemp=0"   "$out"

# ---- 6. the ceiling, from both sides -------------------------------------------------------------

ck "one unguarded over a ceiling of 0 refuses"      "^1$"                  "$(code bare 0)"
ck "the same site under a ceiling of 1 passes"      "^0$"                  "$(code bare 1)"
out=$(run bare 1)
ck "and says so"                                    "ceiling_ok=yes"       "$out"
ck "while still printing the true count"            "unguarded=1"          "$out"

# ---- 7. --list names the site ---------------------------------------------------------------------

listed=$( cd "$pen/bare" && git add -A >/dev/null 2>&1 && sh "$SCAN" --list 2>&1 )
ck "--list names the unguarded line"                "unguarded case.sh"    "$listed"
ck "--list names the unchecked mktemp"              "unchecked_mktemp case.sh" "$listed"

# ---- 8. three mutations, each asserted to bite -----------------------------------------------------

mutant() { # mutant <file> <literal-from> <literal-to>
  sed "s/$2/$3/" "$SCAN" > "$pen/$1"
}

mutant mut_join.sh 'JOIN=1' 'JOIN=0'
out=$(run cont 0 "$pen/mut_join.sh")
ck "mutation: dropping the continuation join bites" "unguarded=1"          "$out"

mutant mut_and.sh 'GUARD_AND=1' 'GUARD_AND=0'
out=$(run guard_and 0 "$pen/mut_and.sh")
ck "mutation: dropping the && guard test bites"     "unguarded=1"          "$out"

mutant mut_derive.sh 'DERIVE=1' 'DERIVE=0'
out=$(run derived 0 "$pen/mut_derive.sh")
ck "mutation: dropping transitive pens bites"       "pen_sites=0"          "$out"

mutant mut_skip.sh 'SKIP=1' 'SKIP=0'
out=$(run commented 0 "$pen/mut_skip.sh")
ck "mutation: reading comment lines as code bites"  "unguarded=1"          "$out"
out=$(run heredoc 0 "$pen/mut_skip.sh")
ck "mutation: reading heredoc bodies as code bites" "unguarded=1"          "$out"

# And the unmutated scan must walk each of those cases free, or the mutation proved nothing.
ck "unmutated: the continued guard still passes"    "unguarded=0"          "$(run cont)"
ck "unmutated: the chained guard still passes"      "unguarded=0"          "$(run guard_and)"
ck "unmutated: the derived pen is still seen"       "pen_sites=1"          "$(run derived)"
ck "unmutated: the comment line is still read past" "pen_sites=0"          "$(run commented)"
ck "unmutated: the heredoc body is still read past" "pen_sites=0"          "$(run heredoc)"

# ---- close -----------------------------------------------------------------------------------------

echo "pass=$pass fail=$fail"
if [ "$fail" -eq 0 ]; then
  echo "control_verdict=ok"
  exit 0
fi
echo "control_verdict=failed"
exit 1
