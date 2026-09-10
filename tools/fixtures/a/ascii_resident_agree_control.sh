#!/bin/sh
# tools/fixtures/a/ascii_resident_agree_control.sh -- the two readers answer alike, or they do not.
#
# WHAT IT PROVES. `tools/fixtures/a/ascii_document_resident_probe.sh` claims to be
# `tools/fixtures/a/ascii_document_scan.sh` with every per-file process removed and nothing else
# changed. That claim is worth exactly what it is tested on, so this control builds real git
# repositories in a throwaway pen and reads both instruments over each: same standard output, same
# exit status, character for character.
#
# WHY A PEN RATHER THAN THE TREE. The two agreed on the living tree at the first run and parted the
# moment a page broke the wall -- the probe answered `enforce=broken` where the scan answers
# `enforce=failed`, printed no `detail=` lines, and exited 0. A refusal proven only in the passing
# direction cannot be told from a bypass, so every case below is planted on purpose.
#
# USAGE
#   sh tools/fixtures/a/ascii_resident_agree_control.sh
set -u

root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "control_verdict=misread"; exit 1; }
SCAN="$root/tools/fixtures/a/ascii_document_scan.sh"
PROBE="$root/tools/fixtures/a/ascii_document_resident_probe.sh"
pen=$(mktemp -d "${TMPDIR:-/tmp}/ascii-agree.XXXXXX") || { echo "control_verdict=misread"; exit 1; }
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0
leg() {                                   # leg <name> <dir>
  a=$( cd "$2" && sh "$SCAN"  2>&1 ); ax=$?
  b=$( cd "$2" && sh "$PROBE" 2>&1 ); bx=$?
  if [ "$a" = "$b" ] && [ "$ax" -eq "$bx" ]; then
    pass=$((pass + 1)); echo "leg=$1 agree=yes exit=$ax"
  else
    fail=$((fail + 1)); echo "leg=$1 agree=no scan_exit=$ax probe_exit=$bx"
    printf 'scan:\n%s\nprobe:\n%s\n' "$a" "$b"
  fi
}

# EM is the em dash, MID the middle dot, SEC the section sign -- one named form, one named
# two-byte form, one the rule table leaves to a reader's judgment.
EM=$(printf '\342\200\224'); MID=$(printf '\302\267'); SEC=$(printf '\302\247')

seed() {                                  # seed <dir>
  mkdir -p "$1/.claude/rules" "$1/.cursor/rules" "$1/docs" "$1/date" "$1/vendor"
  ( cd "$1" && git init -q . )
  printf 'a plain rule page\n' > "$1/.claude/rules/a.md"
  printf 'a plain compressor\n' > "$1/docs/c.md"
  printf 'a plain cursor twin\n' > "$1/.cursor/rules/a.mdc"
}
commit() { ( cd "$1" && git add -A && git -c user.email=a@b -c user.name=t commit -qm x ); }

# 1 -- a clean tree: every roster empty of faults, verdict ok on both.
d="$pen/clean"; seed "$d"; commit "$d"; leg clean_tree "$d"

# 2 -- a dirty ratchet page, under the ceiling: counted, named split, still ok.
d="$pen/ratchet"; seed "$d"
printf 'a living page with %s and %s\n' "$EM" "$MID" > "$d/GUIDE.md"
commit "$d"; leg dirty_ratchet "$d"

# 3 -- the same page over a ceiling of zero: both must refuse, and refuse the same way.
d="$pen/over"; seed "$d"
printf 'a living page with %s\n' "$EM" > "$d/GUIDE.md"
commit "$d"
a=$( cd "$d" && ASCII_DOC_CEILING=0 sh "$SCAN"  2>&1 ); ax=$?
b=$( cd "$d" && ASCII_DOC_CEILING=0 sh "$PROBE" 2>&1 ); bx=$?
if [ "$a" = "$b" ] && [ "$ax" -eq "$bx" ] && [ "$ax" -ne 0 ]; then
  pass=$((pass + 1)); echo "leg=over_ceiling agree=yes exit=$ax"
else
  fail=$((fail + 1)); echo "leg=over_ceiling agree=no scan_exit=$ax probe_exit=$bx"
  printf 'scan:\n%s\nprobe:\n%s\n' "$a" "$b"
fi

# 4 -- a WALLED page carrying a character: the refusal path, with its detail lines and exit 1.
d="$pen/enforce"; seed "$d"
printf 'a compressor with %s\n' "$EM" > "$d/docs/c.md"
commit "$d"; leg enforced_dirty "$d"

# 5 -- two walled pages dirty by different amounts: the detail lines are ordered worst first.
d="$pen/enforce2"; seed "$d"
printf 'one %s\n' "$EM" > "$d/docs/c.md"
printf 'three %s %s %s\n' "$EM" "$MID" "$SEC" > "$d/.claude/rules/a.md"
commit "$d"; leg enforced_order "$d"

# 6 -- the DERIVED canon: a rule page names a living page, so that page is walled by citation.
d="$pen/derived"; seed "$d"
printf 'the law names `GUIDE.md` as canon\n' >> "$d/.claude/rules/a.md"
printf 'canon with %s\n' "$EM" > "$d/GUIDE.md"
commit "$d"; leg derived_canon "$d"

# 7 -- testimony and closed stacks: a dated basename and a `date/` shelf are read past by both.
d="$pen/testimony"; seed "$d"
printf 'dated %s\n' "$EM" > "$d/date/20260101-010101_x.md"
printf 'dated %s\n' "$EM" > "$d/20260102-020202_y.md"
printf 'vendored %s\n' "$EM" > "$d/vendor/v.md"
commit "$d"; leg testimony_read_past "$d"

# 8 -- a tracked path holding a space, the shape that splits a `for f in $LIST` in two.
d="$pen/spaced"; seed "$d"
printf 'a spaced page with %s\n' "$EM" > "$d/a note (1).md"
commit "$d"; leg spaced_path "$d"

# 9 -- a path in the index and absent from the working tree, which a staged rename produces.
d="$pen/absent"; seed "$d"
printf 'here %s\n' "$EM" > "$d/GONE.md"
commit "$d"
rm -f "$d/GONE.md"
leg absent_path "$d"

# 10 -- THE CONTROL BITES: a probe that stops counting the middle dot must part from the scan.
d="$pen/mutate"; seed "$d"
printf 'a page with %s\n' "$MID" > "$d/GUIDE.md"
commit "$d"
mutant="$pen/mutant.sh"
sed 's/^  T2\["\\302\\267"\] = 1.*$/  MUTATED = 1/' "$PROBE" > "$mutant"
a=$( cd "$d" && sh "$SCAN"    2>&1 )
b=$( cd "$d" && sh "$mutant"  2>&1 )
if [ "$a" != "$b" ]; then
  pass=$((pass + 1)); echo "leg=mutation_bites agree=no_as_required"
else
  fail=$((fail + 1)); echo "leg=mutation_bites agree=yes_which_is_wrong"
fi

echo "legs_pass=$pass"
echo "legs_fail=$fail"
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=broken"; exit 1; fi
