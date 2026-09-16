#!/bin/sh
# tools/fixtures/c/chemical_formula_control.sh -- prove the formula reading on real repositories.
#
# Every refusal is planted and then lifted, and every welcome is asserted as hard as every refusal,
# because a refusal proven only in the passing direction cannot be told from a bypass. Four
# mutations of the scan itself are asserted to bite, so a leg that would pass with the check removed
# is named here rather than trusted. The control tallies its own legs and prints the count beside
# its verdict: `control_verdict=ok` says only that the script reached its last line, so a leg
# written tomorrow is heard the day it lands rather than a year later.
#
# USAGE
#   sh tools/fixtures/c/chemical_formula_control.sh
#
# Driven by tools/c/chemical_formula_witness.rish. Run from the repository root.

set -eu

root=$(pwd)
scan="$root/tools/fixtures/c/chemical_formula_scan.sh"
portable="$root/tools/fixtures/s/shell_portable.sh"
[ -f "$scan" ] || { echo "control_verdict=no_scan"; exit 1; }
[ -f "$portable" ] || { echo "control_verdict=no_portable"; exit 1; }

pen=$(mktemp -d) || { echo "control_verdict=no_pen"; exit 1; }
trap 'rm -rf "$pen"' EXIT INT TERM

legs=0
failed=0

leg() {
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    echo "leg_ok: $1"
  else
    failed=$((failed + 1))
    echo "leg_no: $1 -- wanted $3, read $2"
  fi
}

read_key() { awk -F= -v k="$1" '$1 == k { print $2 }'; }

# A mutated copy lands in a flat pen holding fixtures/c and fixtures/s and no tree at all, so the
# scan's root walk finds nothing and takes its named sibling fallback. That fallback is what makes a
# mutation testable at all.
mkdir -p "$pen/fixtures/c" "$pen/fixtures/s"
cp "$portable" "$pen/fixtures/s/shell_portable.sh"

# One repository holding every planted shape at once, so one reading proves many legs.
repo="$pen/tree"
mkdir -p "$repo"
( cd "$repo" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )
cd "$repo"
mkdir -p room room/date/20260101 room/archive room/yonder src vendor

# The declaration roster the scan reads: a real fn, and an import binding that must NOT count.
cat > src/thing.rye <<'RYE'
pub fn brew(x: u32) u32 {
    return x;
}
const steep = @import("steep.rye");
RYE

# --- the welcomes: every one of these stays out of the gated count ---
cat > room/welcomes.md <<'MD'
A declared operation, counted and welcome:

```
brew(leaf) + water  ->  cup
```

A tagged fence is somebody's transcript rather than a formula:

```sh
absent_one(x)  ->  y
```

An untagged fence with no arrow at all:

```
absent_two(x) = y
```

An arrow line standing outside every fence: absent_three(x) -> y

A token that starts with a digit, and a shell substitution:

```
sha3-512(8)  ->  index        $(dirname "$f")  ->  room
```
MD

# An import binding proves a module exists rather than that the operation does.
cat > room/import.md <<'MD'
```
steep(leaf)  ->  tea
```
MD

# --- the erratum: a quoted elder is testimony, and the section CLOSES at the next heading ---
cat > room/erratum.md <<'MD'
# A page that molted a formula

## Erratum `20260101.010101` -- the word this page spent twice

It read:

```
gone_word(name)  ->  bytes
```

## After the erratum

```
alsogone(name)  ->  bytes
```
MD

# --- testimony shelves, counted apart and never gated ---
cat > room/date/20260101/20260101-010101_folded.md <<'MD'
```
shelf_one(x)  ->  y
```
MD
cat > room/archive/kept.md <<'MD'
```
shelf_two(x)  ->  y
```
MD
cat > room/yonder/deferred.md <<'MD'
```
shelf_three(x)  ->  y
```
MD

# Held rather than authored here.
cat > vendor/theirs.md <<'MD'
```
vendored(x)  ->  y
```
MD

# The spaced name. This tree carries exactly one tracked page whose name holds a blank, and a bare
# xargs splits on it: awk meets a file that does not exist, which is FATAL, so the whole batch dies
# and every hit in it vanishes. The first draft of this scan read 375 hits where it carried 1,343.
cat > "room/spaced name.md" <<'MD'
```
spaced_op(x)  ->  y
```
MD

git add -A >/dev/null 2>&1
git -c commit.gpgsign=false commit -qm pen >/dev/null 2>&1

out=$(CHEMICAL_FORMULA_CEILING=99 sh "$scan" --list 2>/dev/null)

leg "a declared fn counts as declared"        "$(echo "$out" | read_key declared)"          1
leg "tagged fence read past"                  "$(echo "$out" | grep -c 'absent_one' || true)"   0
leg "untagged fence with no arrow read past"  "$(echo "$out" | grep -c 'absent_two' || true)"   0
leg "arrow outside a fence read past"         "$(echo "$out" | grep -c 'absent_three' || true)" 0
leg "a digit-leading token is no operation"   "$(echo "$out" | grep -c '512' || true)"          0
leg "a shell substitution is no operation"    "$(echo "$out" | grep -c 'dirname' || true)"      0
leg "an import binding is not a declaration"  "$(echo "$out" | grep -c '^undeclared room/import.md steep' || true)" 1
leg "the erratum quotation is read past"      "$(echo "$out" | read_key erratum_read_past)"  1
leg "the erratum closes at the next heading"  "$(echo "$out" | grep -c '^undeclared room/erratum.md alsogone' || true)" 1
leg "three shelves counted apart"             "$(echo "$out" | read_key shelved_tokens)"     3
leg "a vendored page is read past"            "$(echo "$out" | grep -c 'vendored' || true)"     0
# Anchored on the --list verdict column: --list prints one row per token AND an `undeclared_at`
# line per gated hit, so a bare grep for the name counts one finding twice.
leg "a spaced page name is still read"        "$(echo "$out" | grep -c '^undeclared room/spaced name.md spaced_op' || true)" 1
leg "the living tokens total"                 "$(echo "$out" | read_key tokens)"             4
leg "undeclared names each hit"               "$(echo "$out" | grep -c '^undeclared_at ' || true)" 3

# --- the gate, from both sides ---
if CHEMICAL_FORMULA_CEILING=3 sh "$scan" >/dev/null 2>&1; then gate_at=ok; else gate_at=refused; fi
leg "a ceiling at the standing count passes" "$gate_at" ok
if CHEMICAL_FORMULA_CEILING=2 sh "$scan" >/dev/null 2>&1; then gate_over=ok; else gate_over=refused; fi
leg "one token past the ceiling refuses"     "$gate_over" refused
leg "and it says which reading refused"      "$(CHEMICAL_FORMULA_CEILING=2 sh "$scan" 2>/dev/null | read_key verdict)" over_ceiling

# --- the scan's own doors ---
if sh "$scan" --nonsense >/dev/null 2>&1; then flag=ok; else flag=refused; fi
leg "an unknown flag refuses"                "$flag" refused
mkdir -p "$pen/bare" && cd "$pen/bare"
if sh "$scan" >/dev/null 2>&1; then norepo=ok; else norepo=refused; fi
leg "outside a repository it refuses"        "$norepo" refused
cd "$repo"

# --- the mutations: each is asserted to BITE, against this pen's own baseline ---
mutate() {
  cp "$scan" "$pen/fixtures/c/mutant.sh"
  python3 - "$pen/fixtures/c/mutant.sh" "$1" "$2" <<'PY'
import sys
path, old, new = sys.argv[1], sys.argv[2], sys.argv[3]
s = open(path).read()
if old not in s:
    sys.exit(3)
open(path, 'w').write(s.replace(old, new, 1))
PY
  chmod +x "$pen/fixtures/c/mutant.sh"
}

mutate 'xargs_lines_batched 400 "$work/pages.txt" awk -f "$work/prog.awk"' 'xargs awk -f "$work/prog.awk" < "$work/pages.txt"'
leg "mutation 1 -- a bare xargs loses the spaced page" \
  "$(CHEMICAL_FORMULA_CEILING=99 sh "$pen/fixtures/c/mutant.sh" --list 2>/dev/null | grep -c 'spaced_op' || true)" 0
# And the same mutation proves the refusal path, which is the other half of the same lesson: the
# short reading must REFUSE rather than report itself as finished.
leg "mutation 1 -- and the short read refuses rather than reporting" \
  "$(CHEMICAL_FORMULA_CEILING=99 sh "$pen/fixtures/c/mutant.sh" 2>/dev/null | read_key verdict)" read_failed

mutate '    if (erratum) { print "erratum\t" page "\t" tok; continue }' ''
leg "mutation 2 -- without the erratum branch the quotation is counted" \
  "$(CHEMICAL_FORMULA_CEILING=99 sh "$pen/fixtures/c/mutant.sh" --list 2>/dev/null | grep -c '^undeclared room/erratum.md gone_word' || true)" 1

mutate "'^[[:space:]]*(pub )?fn [a-z_][a-zA-Z0-9_]*\\('" "'^[[:space:]]*(pub )?(fn|const) [a-z_][a-zA-Z0-9_]*[( ]'"
leg "mutation 3 -- accepting const reads an import as a declaration" \
  "$(CHEMICAL_FORMULA_CEILING=99 sh "$pen/fixtures/c/mutant.sh" --list 2>/dev/null | grep -c '^undeclared room/import.md steep' || true)" 0

mutate 'inb && tag == "" && /->/ {' 'inb && /->/ {'
leg "mutation 4 -- without the tag test a transcript reads as a formula" \
  "$(CHEMICAL_FORMULA_CEILING=99 sh "$pen/fixtures/c/mutant.sh" --list 2>/dev/null | grep -c '^undeclared room/welcomes.md absent_one' || true)" 1

cd "$root"
echo "control_legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=failed"; exit 1; fi
