#!/bin/sh
# tools/fixtures/p/pen_release_control.sh -- the pen-release reading, shown from both sides.
#
#   sh tools/fixtures/p/pen_release_control.sh
#
# WHY THIS EXISTS. A guard that refuses everything passes a one-sided proof. So every refusal here
# is planted and then LIFTED: the same file, released each lawful way, must walk free, and the
# ceiling is shown from both sides.
#
# Each case builds a real git repository in a throwaway pen and runs the scan from inside it. The
# scan's population comes from `git ls-files`, so a pen holding a repository is what lets it read at
# all. The scan is invoked by its ABSOLUTE path from outside the pen, which keeps the file under
# test out of the population it reads.
#
# EACH CASE DIRECTORY IS BUILT ONCE UNDER A FRESH `mktemp -d`, so the build makes and never
# removes. A control for a leak guard that opened with a recursive removal of a derived path would
# be teaching the shape it exists to refuse.
#
# A FOURTH CASE PROVES THE STANDING HALF sees the second pen spelling, `${TMPDIR:-/tmp}/<name>`,
# against a probe directory made inside this control's own pen.
#
# THREE MUTATIONS are asserted to BITE -- the continuation join, the transitive pen-variable
# collection, and the trap reading -- each a `BEGIN` switch in the scan's awk program, flipped here
# by replacing one literal so a mutation carries no regular-expression escaping of its own. Each is
# then required to walk free unmutated, since a bite proves only half of a predicate.
#
# TWO CASES CARRY THE FAULTS FIRST RESIDENCY FOUND IN THE SCAN ITSELF, both planted before the
# reading was trusted: a pen made and removed inside ONE `sh -c` string, which the first draft read
# as never_removed because it took only the first assignment on the line; and a pen released with
# `rmdir` in a trap, which the first draft could not see because it required `rm -r`.
#
# READINGS: `pass=N fail=N` and a `control_verdict=` line. Exit 1 when any case fails.

set -u

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
SCAN="$ROOT/tools/fixtures/p/pen_release_scan.sh"
[ -f "$SCAN" ] || { echo "refused: scan absent -- $SCAN"; echo "control_verdict=no_scan"; exit 1; }

pen=$(mktemp -d) || { echo "refused: pen absent -- fixtures would land in the live tree" >&2; echo "control_verdict=no_pen"; exit 1; }
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

build() {
  mkdir -p "$pen/$1" || return 1
  ( cd "$pen/$1" || { echo "refused: pen absent" >&2; exit 1; }
    git init -q -b main .
    git config user.email pen@example.invalid
    git config user.name pen
    git config commit.gpgsign false ) >/dev/null 2>&1
}

run() { # run <name> [ceiling] [scan] [flag]
  ( cd "$pen/$1" || exit 0
    git add -A >/dev/null 2>&1
    PEN_RELEASE_CEILING="${2:-0}" sh "${3:-$SCAN}" ${4:-} 2>&1 )
}

code() { # code <name> [ceiling]
  ( cd "$pen/$1" || { echo 99; exit 0; }
    git add -A >/dev/null 2>&1
    PEN_RELEASE_CEILING="${2:-0}" sh "$SCAN" >/dev/null 2>&1; echo $? )
}

# ---- 1. a shell pen never removed refuses ------------------------------------------------------

build never_sh || { echo "control_verdict=no_pen"; exit 1; }
cat > "$pen/never_sh/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d)
printf 'x\n' > "$pen/a.txt"
EOF
out=$(run never_sh)
ck "a shell pen never removed is counted"        "never_removed=1"            "$out"
ck "the file is counted as a shell runner"       "runners=1"                  "$out"
ck "it carries a pen"                            "pen_files=1"                "$out"
ck "it is not counted as straight-line"          "unreleased_on_refusal=0"    "$out"
ck "the bare shape refuses"                      "verdict=leaking"            "$out"
ck "the bare shape exits 1"                      "^1$"                        "$(code never_sh)"

# ---- 2. the trap release walks free ------------------------------------------------------------

build trap_sh
cat > "$pen/trap_sh/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT
printf 'x\n' > "$pen/a.txt"
EOF
out=$(run trap_sh)
ck "a trapped removal is released"               "never_removed=0"            "$out"
ck "a trapped removal is not straight-line"      "unreleased_on_refusal=0"    "$out"
ck "the trapped shape walks free"                "verdict=released"           "$out"
ck "the trapped shape exits 0"                   "^0$"                        "$(code trap_sh)"

# ---- 3. a straight-line removal is reported, never gated ---------------------------------------

build straight_sh
cat > "$pen/straight_sh/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d)
printf 'x\n' > "$pen/a.txt"
rm -rf "$pen"
EOF
out=$(run straight_sh)
ck "a straight-line removal is not never_removed" "never_removed=0"           "$out"
ck "a straight-line removal is reported"          "unreleased_on_refusal=1"   "$out"
ck "a straight-line removal walks free"           "verdict=released"          "$out"
ck "a straight-line removal exits 0"              "^0$"                       "$(code straight_sh)"

# ---- 4. rmdir in a trap is a release ------------------------------------------------------------
# arbor/author.sh sweeps with `rm -f <files>; rmdir "$temp_dir"` in its EXIT trap. The first draft
# required `rm -r` and called that file a leak.

build rmdir_sh
cat > "$pen/rmdir_sh/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d)
f="$pen/a.txt"
trap 'rm -f "$f"; rmdir "$pen"' EXIT
printf 'x\n' > "$f"
EOF
out=$(run rmdir_sh)
ck "rmdir in a trap is a release"                "never_removed=0"            "$out"
ck "rmdir in a trap is not straight-line"        "unreleased_on_refusal=0"    "$out"
ck "the rmdir shape walks free"                  "verdict=released"           "$out"

# ---- 5. a Rishi pen never removed is counted, in a file carrying no shebang ---------------------
# This is the population `pen_entry` cannot reach at all, and the one the pier's own leak lives in.

build never_rish
cat > "$pen/never_rish/case.rish" <<'EOF'
let mk = run ["sh" "-c" "mktemp -d /tmp/case_pen.XXXXXX"]
assert mk.ok else "the pen must be made"
let pen = trim mk.out
let made = run ["sh" "-c" "printf 'x' > ${pen}/a.txt"]
assert made.ok else "the file must be written"
EOF
out=$(run never_rish)
ck "a Rishi pen never removed is counted"        "never_removed=1"            "$out"
ck "the Rishi file is counted as a runner"       "rish_runners=1"             "$out"
ck "no shell runner is claimed"                  "runners=0"                  "$out"
ck "the Rishi shape refuses"                     "verdict=leaking"            "$out"

# ---- 6. a Rishi pen swept on the success path is reported ---------------------------------------

build straight_rish
cat > "$pen/straight_rish/case.rish" <<'EOF'
let mk = run ["sh" "-c" "mktemp -d /tmp/case_pen.XXXXXX"]
let pen = trim mk.out
let swept = run ["sh" "-c" "rm -rf ${pen}"]
assert swept.ok else "the pen must be swept"
EOF
out=$(run straight_rish)
ck "a swept Rishi pen is not never_removed"      "never_removed=0"            "$out"
ck "a swept Rishi pen is reported"               "unreleased_on_refusal=1"    "$out"
ck "the swept Rishi shape walks free"            "verdict=released"           "$out"

# ---- 7. a whole pen lifetime inside one sh -c string is a release -------------------------------
# tools/r/radiant_negation_witness.rish and tools/ca/card_pin_claim_witness.rish write this shape.
# The first draft took the first assignment on the line -- the outer `let blind =` -- and called
# both of them leaks.

build oneline_rish
cat > "$pen/oneline_rish/case.rish" <<'EOF'
let blind = run ["sh" "-c" "d=$(mktemp -d); printf 'x' > $d/b.txt; s=$?; rm -rf $d; exit $s"]
assert blind.ok else "the case must run"
EOF
out=$(run oneline_rish)
ck "a one-line pen lifetime is not a leak"       "never_removed=0"            "$out"
ck "a one-line pen lifetime is reported"         "unreleased_on_refusal=1"    "$out"
ck "the one-line shape walks free"               "verdict=released"           "$out"

# ---- 8. a derived pen variable is the pen too ---------------------------------------------------

build derived_sh
cat > "$pen/derived_sh/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d)
work="$pen/w"
trap 'rm -rf "$work"' EXIT
mkdir -p "$work"
EOF
out=$(run derived_sh)
ck "a derived pen name is the pen too"           "never_removed=0"            "$out"

# ---- 9. a comment and a heredoc body are read past ----------------------------------------------

build prose_sh
cat > "$pen/prose_sh/case.sh" <<'EOF'
#!/bin/sh
# This header teaches the rule: pen=$(mktemp -d) and rm -rf "$pen".
cat > /dev/null <<'INNER'
pen=$(mktemp -d)
INNER
printf 'no pen here\n'
EOF
out=$(run prose_sh)
ck "prose and a heredoc body carry no pen"       "pen_files=0"                "$out"
ck "a file with no real pen is no runner"        "runners=0"                  "$out"

# ---- 10. the ceiling, from both sides -----------------------------------------------------------

build ceiling
cat > "$pen/ceiling/one.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d)
printf 'x\n' > "$pen/a.txt"
EOF
ck "one leak over a ceiling of zero refuses"     "^1$"                        "$(code ceiling 0)"
ck "one leak under a ceiling of one walks free"  "^0$"                        "$(code ceiling 1)"
ck "the ceiling is named in the reading"         "ceiling=1"                  "$(run ceiling 1)"

# ---- 11. the standing half reads the pier and gates nothing -------------------------------------

build standing
cat > "$pen/standing/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d)
printf 'x\n' > "$pen/a.txt"
EOF
out=$(run standing 1 "" --standing)
ck "the standing half names its root"            "standing_root="             "$out"
ck "the standing half counts"                    "standing_pens="             "$out"
ck "the standing half gates nothing"             "verdict=released"           "$out"
# THE SECOND PEN SPELLING, which the standing half MUST see. First residency caught this from the
# other side: narrowing the standing half's source to the mktemp carriers made it structurally
# unable to find a `${TMPDIR:-/tmp}/<name>` pen, and the count fell 627 to 309 for no change on the
# pier. The probe directory is made inside this control's own pen, with TMPDIR pointed at it, so
# the leg reads a real directory and leaves nothing behind.
build standing_tmpdir
cat > "$pen/standing_tmpdir/case.sh" <<'EOF'
#!/bin/sh
PEN="${TMPDIR:-/tmp}/pen_release_probe.$$"
mkdir -p "$PEN"
EOF
mkdir -p "$pen/probe_root/pen_release_probe.1"
out=$( cd "$pen/standing_tmpdir" || exit 0
       git add -A >/dev/null 2>&1
       TMPDIR="$pen/probe_root" PEN_RELEASE_CEILING=1 sh "$SCAN" --standing 2>&1 )
ck "the standing half sees a non-mktemp pen name"  "standing_pen pen_release_probe"  "$out"
ck "the standing half counts it"                   "standing_pens=1"                 "$out"
ck "that file is no mktemp carrier"                "pen_files=0"                     "$out"

out=$(run standing 1)
case "$out" in
  *standing_pens=*) fail=$((fail + 1)); echo "FAIL the standing half ran unasked" ;;
  *) pass=$((pass + 1)) ;;
esac

# ---- 12. three mutations, each bitten and then lifted --------------------------------------------

mutate() { # mutate <from> <to>
  sed "s/$1/$2/" "$SCAN" > "$pen/mutated.sh"
  echo "$pen/mutated.sh"
}

build mut_join
cat > "$pen/mut_join/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d)
trap 'rm -rf \
  "$pen"' EXIT
printf 'x\n' > "$pen/a.txt"
EOF
ck "the join mutation bites"                     "never_removed=1"            "$(run mut_join 0 "$(mutate 'JOIN=1' 'JOIN=0')")"
ck "unmutated, the joined trap walks free"       "never_removed=0"            "$(run mut_join)"

ck "the derive mutation bites"                   "never_removed=1"            "$(run derived_sh 0 "$(mutate 'DERIVE=1' 'DERIVE=0')")"
ck "unmutated, the derived pen walks free"       "never_removed=0"            "$(run derived_sh)"

ck "the trap mutation bites"                     "unreleased_on_refusal=1"    "$(run trap_sh 0 "$(mutate 'TRAP=1' 'TRAP=0')")"
ck "unmutated, the trap is no straight line"     "unreleased_on_refusal=0"    "$(run trap_sh)"

# ---- the function form of the trap, proven from both sides -------------------------------------
# A trap reaches a removal two ways and this control only ever planted one of them, so the
# two-line form -- `cleanup() { rm -rf "$pen"; }` above `trap cleanup EXIT` -- was proven in no
# direction and read as a leak on 12 of the 18 shell files in the class. The four legs below plant
# the shape, its multi-line body, the untrapped function that must NOT pass, and the brace that
# closes the scope.

build trap_fn
cat > "$pen/trap_fn/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d)
cleanup() { rm -rf "$pen"; }
trap cleanup EXIT INT TERM HUP
printf 'x\n' > "$pen/a.txt"
EOF
out=$(run trap_fn)
ck "a one-line trapped function is released"     "never_removed=0"            "$out"
ck "a one-line trapped function is no straight line" "unreleased_on_refusal=0" "$out"
ck "the trapped function shape walks free"       "verdict=released"           "$out"
ck "the trapped function shape exits 0"          "^0$"                        "$(code trap_fn)"

build trap_fn_multi
cat > "$pen/trap_fn_multi/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d)
cleanup() {
  printf 'sweeping\n' >&2
  rm -rf "$pen"
}
trap cleanup EXIT
printf 'x\n' > "$pen/a.txt"
EOF
ck "a multi-line trapped function is released"   "unreleased_on_refusal=0"    "$(run trap_fn_multi)"

# A function no trap names is NOT a release -- the registration is the whole predicate. Without
# this leg, FN would call every function-wrapped removal released and the reading would go blind
# in the unsafe direction.
build fn_untrapped
cat > "$pen/fn_untrapped/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d)
sweep() { rm -rf "$pen"; }
sweep
EOF
ck "an untrapped function stays straight-line"   "unreleased_on_refusal=1"    "$(run fn_untrapped)"

# The scope closes at the lone brace. The trapped function here sweeps NOTHING, so the removal
# below its brace is the only one in the file: reading the scope correctly leaves that removal
# outside the function and straight-line, while a scope that ran on would call it released. The
# case discriminates because `trapped` is a file-level flag -- a cleanup that removed the pen
# would set it either way and the leg would pass without proving anything.
build fn_scope_closes
cat > "$pen/fn_scope_closes/case.sh" <<'EOF'
#!/bin/sh
pen=$(mktemp -d)
cleanup() {
  printf 'nothing swept\n' >&2
}
trap cleanup EXIT
rm -rf "$pen"
EOF
ck "the function scope closes at its brace"      "unreleased_on_refusal=1"    "$(run fn_scope_closes)"

ck "the function mutation bites"                 "unreleased_on_refusal=1"    "$(run trap_fn 0 "$(mutate 'FN=1' 'FN=0')")"
ck "unmutated, the trapped function is no straight line" "unreleased_on_refusal=0" "$(run trap_fn)"

echo "pass=$pass"
echo "fail=$fail"
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=failed"
exit 1
