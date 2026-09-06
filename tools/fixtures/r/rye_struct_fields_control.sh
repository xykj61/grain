#!/bin/sh
# tools/fixtures/r/rye_struct_fields_control.sh -- the field reader, broken on purpose, and the
# elder grep shown waving the break through.
#
# WHAT THIS DOES. tools/fixtures/r/rye_struct_fields_scan.sh claims to read a Rye struct's
# declared fields, in order. This control builds a throwaway pen holding a small Rye file,
# changes ONE thing in it per phase, and asserts what the scan answers. Every refusal is shown
# from both sides: planted and then absent, so a real reading stays tellable from a bypass.
#
# AND IT PROVES THE RED THAT BOOKED THE WORK (REDS %500). Four rostered guards checked the same
# claim with a presence grep -- `grep -Fq 'text: []const u8,'` once per field. Two phases below
# run that elder predicate verbatim beside the new scan on the same mutated pen:
#
#   fourth_field  -- a fourth field is added. The elder predicate PASSES. Every field it names
#                    is still present, and presence is all it ever asked.
#   reordered     -- the three fields are shuffled. The elder predicate PASSES. `grep -Fq` has
#                    no notion of order at all, though the guard refused with the words
#                    "missing or reordered".
#
# Those two passes are the sharpest phases here, for the reason the diff control already names:
# every other phase proves the new scan bites, and these two prove what the elder form waved
# through. The identity gap wanted a fourth field on `Line` and the diff anchor wanted one on
# `Diff`; both were recorded as waiting on a lock that would not have noticed either.
#
# THE PEN IS A DIRECTORY, and the file inside it is Rye-shaped text rather than a compiled
# module -- this scan reads source, never a build, so a directory and a here-document are the
# honest pen.
#
# EXPECTED: every phase agrees with the table in its own line, and behaviors=19.
#
# Driven by tools/r/rye_struct_fields_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
scan="$root/tools/fixtures/r/rye_struct_fields_scan.sh"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

pass=0
fail=0

# Assert one reading, and say which way it went. Every check runs through here so the count at
# the foot is the count of behaviors actually exercised rather than of lines written.
check() {
  what="$1"; got="$2"; want="$3"
  if [ "$got" = "$want" ]; then
    pass=$((pass + 1))
    echo "ok    $what -- $got"
  else
    fail=$((fail + 1))
    echo "FAIL  $what -- got '$got' want '$want'"
  fi
}

# The elder predicate, copied verbatim out of tools/m/mantra_glow_tend_limb1_witness.rish as it
# stood before this round. It is quoted here rather than described, because a control that
# paraphrases the thing under test proves the paraphrase.
elder() {
  f="$1"
  if grep -q 'pub const Line = struct' "$f" \
     && grep -Fq 'text: []const u8,' "$f" \
     && grep -Fq 'gen: u32,' "$f" \
     && grep -Fq 'pos: u32,' "$f"; then
    echo pass
  else
    echo fail
  fi
}

# Write a pen file holding a Line struct with the given field block.
pen_file() {
  name="$1"; fields="$2"
  dir="$work/$name"
  mkdir -p "$dir"
  {
    echo 'const std = @import("std");'
    echo ''
    echo 'pub const Line = struct {'
    printf '%s\n' "$fields"
    echo '};'
  } > "$dir/weave.rye"
  echo "$dir/weave.rye"
}

three='    text: []const u8,
    gen: u32,
    pos: u32,'

echo "rye-struct-fields-control: the reader, broken on purpose"
echo

# --- clean: the unmutated pen reads exactly what it declares -------------------------------
f=$(pen_file clean "$three")
check "clean/count"  "$(sh "$scan" --count "$f" Line)"  "3"
check "clean/fields" "$(sh "$scan" --fields "$f" Line)" "text gen pos"
check "clean/elder"  "$(elder "$f")"                    "pass"

# --- fourth_field: the break the elder cannot see ------------------------------------------
f=$(pen_file fourth "$three
    anchor: u32,")
check "fourth_field/count"  "$(sh "$scan" --count "$f" Line)"  "4"
check "fourth_field/fields" "$(sh "$scan" --fields "$f" Line)" "text gen pos anchor"
check "fourth_field/elder"  "$(elder "$f")"                    "pass"

# --- reordered: the second break the elder cannot see --------------------------------------
f=$(pen_file reorder '    pos: u32,
    text: []const u8,
    gen: u32,')
check "reordered/count"  "$(sh "$scan" --count "$f" Line)"  "3"
check "reordered/fields" "$(sh "$scan" --fields "$f" Line)" "pos text gen"
check "reordered/elder"  "$(elder "$f")"                    "pass"

# --- renamed: a break both forms catch, which keeps the elder's honest half visible ---------
f=$(pen_file rename '    text: []const u8,
    era: u32,
    pos: u32,')
check "renamed/fields" "$(sh "$scan" --fields "$f" Line)" "text era pos"
check "renamed/elder"  "$(elder "$f")"                    "fail"

# --- removed: a field dropped ---------------------------------------------------------------
f=$(pen_file remove '    text: []const u8,
    gen: u32,')
check "removed/count" "$(sh "$scan" --count "$f" Line)" "2"
check "removed/elder" "$(elder "$f")"                   "fail"

# --- method_body: a method's body must never be read as a field list -----------------------
f=$(pen_file method "$three
    };
pub const Other = struct {
    pub fn f(self: *Other) void {
        const x: u32 = 1;
        _ = x;
    }
")
check "method_body/count" "$(sh "$scan" --count "$f" Line)" "3"

# --- the three refusals, each by name and each exiting non-zero -----------------------------
f=$(pen_file nofields '    pub fn empty() void {}')
check "no_fields/verdict" "$(sh "$scan" "$f" Line 2>/dev/null | sed -n 's/^verdict=//p')" "no_fields"
if sh "$scan" "$f" Line >/dev/null 2>&1; then rc=0; else rc=1; fi
check "no_fields/exit" "$rc" "1"

f=$(pen_file nostruct "$three")
check "no_struct/verdict" "$(sh "$scan" "$f" Absent 2>/dev/null | sed -n 's/^verdict=//p')" "no_struct"

check "no_file/verdict" "$(sh "$scan" "$work/nowhere/weave.rye" Line 2>/dev/null | sed -n 's/^verdict=//p')" "no_file"
if sh "$scan" "$work/nowhere/weave.rye" Line >/dev/null 2>&1; then rc=0; else rc=1; fi
check "no_file/exit" "$rc" "1"

echo
echo "behaviors=$((pass + fail))"
echo "passed=$pass"
echo "failed=$fail"
if [ "$fail" -eq 0 ]; then
  echo "verdict=ok"
else
  echo "verdict=broken"
  exit 1
fi
