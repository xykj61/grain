#!/bin/sh
# tools/fixtures/r/rye_enum_variants_control.sh -- the variant reader, broken on purpose.
#
# WHAT THIS DOES. tools/fixtures/r/rye_enum_variants_scan.sh claims to read a Rye enum's declared
# variants, in order. This control builds a throwaway pen holding a small Rye file, changes ONE
# thing in it per phase, and asserts what the scan answers. Every refusal is shown from both
# sides -- planted and then absent -- so a real reading stays tellable from a bypass.
#
# THE THREE SPELLINGS ARE EACH EXERCISED, because the tree writes all three and a reader that
# handles one is a reader that quietly under-counts the other two. Measured 20260915 over the
# tracked Rye corpus: one-line bare, one-line tagged `enum(u8)` with `= <n>` values, and the
# many-line form with `///` doc comments between variants.
#
# THE SHARPEST PHASE IS `documented`. Its struct sibling learned on 20260907 that a `///` line
# read as the end of the block makes a reader under-count exactly the declarations written the
# way TAME asks. `aurora/src/deciding.rye` writes `Path` that way, so this reader would have
# answered zero for an enum declaring two.
#
# THE PEN IS A DIRECTORY, and the file inside it is Rye-shaped text rather than a compiled
# module -- this scan reads source, never a build.
#
# EXPECTED: every phase agrees with the table in its own line, and behaviors=26.
#
# Driven by tools/r/rye_enum_variants_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
scan="$root/tools/fixtures/r/rye_enum_variants_scan.sh"
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

# Write a pen file holding the given declaration text.
pen_file() {
  name="$1"; body="$2"
  dir="$work/$name"
  mkdir -p "$dir"
  printf '//! a planted module\n\n%s\n' "$body" > "$dir/mod.rye"
  echo "$dir/mod.rye"
}

count_of()    { sh "$scan" --count    "$1" "$2" 2>/dev/null || true; }
variants_of() { sh "$scan" --variants "$1" "$2" 2>/dev/null || true; }
verdict_of()  { sh "$scan" "$1" "$2" 2>/dev/null | sed -n 's/^verdict=//p'; }

# ---- the clean pen, proven innocent before anything is broken ----------------
f=$(pen_file clean 'pub const Meaning = enum { answered, stopped, fallen };')
check "clean/count"    "$(count_of "$f" Meaning)"    "3"
check "clean/variants" "$(variants_of "$f" Meaning)" "answered stopped fallen"
check "clean/verdict"  "$(verdict_of "$f" Meaning)"  "ok"

# ---- a fourth variant is counted ---------------------------------------------
f=$(pen_file fourth 'pub const Meaning = enum { answered, stopped, fallen, deferred };')
check "fourth/count"    "$(count_of "$f" Meaning)"    "4"
check "fourth/variants" "$(variants_of "$f" Meaning)" "answered stopped fallen deferred"

# ---- a reorder is read in the order it stands --------------------------------
f=$(pen_file reordered 'pub const Meaning = enum { fallen, answered, stopped };')
check "reordered/variants" "$(variants_of "$f" Meaning)" "fallen answered stopped"

# ---- the bare `const` spelling reads like the `pub const` one ----------------
f=$(pen_file bare 'const Meaning = enum { answered, stopped };')
check "bare/count" "$(count_of "$f" Meaning)" "2"

# ---- the many-line spelling ---------------------------------------------------
f=$(pen_file manyline 'pub const Meaning = enum {
    answered,
    stopped,
    fallen,
};')
check "manyline/count"    "$(count_of "$f" Meaning)"    "3"
check "manyline/variants" "$(variants_of "$f" Meaning)" "answered stopped fallen"

# ---- a comment line is read past, never taken as the end of the block --------
# This is the phase the struct sibling was repaired for on 20260907, and the reason the tree's
# own `aurora/src/deciding.rye` reads two rather than zero. BOTH comment spellings are planted,
# because the reader holds one clause for the two and a phase exercising only `///` would leave
# the plain `//` half unproven.
f=$(pen_file documented 'pub const Meaning = enum {
    /// The dependent answered.
    answered,
    /// A deliberate stop at a safe boundary.
    stopped,
    fallen,
};')
check "documented/count"    "$(count_of "$f" Meaning)"    "3"
check "documented/variants" "$(variants_of "$f" Meaning)" "answered stopped fallen"

f=$(pen_file noted 'pub const Meaning = enum {
    answered,
    // a plain note, not a doc comment
    stopped,
    fallen,
};')
check "noted/count"    "$(count_of "$f" Meaning)"    "3"
check "noted/variants" "$(variants_of "$f" Meaning)" "answered stopped fallen"

# ---- a tagged enum: the backing type is not a variant, a tag value is not a name ----
f=$(pen_file tagged 'pub const Kind = enum(u8) { key_down = 1, key_up = 2, mouse_down = 3 };')
check "tagged/count"    "$(count_of "$f" Kind)"    "3"
check "tagged/variants" "$(variants_of "$f" Kind)" "key_down key_up mouse_down"

f=$(pen_file tagged_many 'pub const Kind = enum(u8) {
    key_down = 1,
    key_up = 2,
};')
check "tagged_many/variants" "$(variants_of "$f" Kind)" "key_down key_up"

# ---- a method body under the declaration is never read as a variant list -----
f=$(pen_file methods 'pub const Meaning = enum {
    answered,
    stopped,
};

pub fn label(m: Meaning) []const u8 {
    return switch (m) {
        .answered => "answered",
        .stopped => "stopped",
    };
}')
check "methods/count" "$(count_of "$f" Meaning)" "2"

# ---- a near-miss name must not answer for the one asked about ----------------
f=$(pen_file prefix 'pub const MeaningOther = enum { a, b, c, d };
pub const Meaning = enum { answered, stopped };')
check "prefix/count" "$(count_of "$f" Meaning)" "2"

# ---- a struct is not an enum, and must refuse rather than count its fields ---
f=$(pen_file notenum 'pub const Meaning = struct {
    text: []const u8,
    gen: u32,
};')
check "notenum/verdict" "$(verdict_of "$f" Meaning)" "no_enum"

# ---- the three refusals, each by name and each exiting non-zero --------------
f=$(pen_file empty 'pub const Meaning = enum {
};')
check "no_variants/verdict" "$(verdict_of "$f" Meaning)" "no_variants"
if sh "$scan" "$f" Meaning >/dev/null 2>&1; then rc=0; else rc=1; fi
check "no_variants/exit" "$rc" "1"

f=$(pen_file absent 'pub const Meaning = enum { answered };')
check "no_enum/verdict" "$(verdict_of "$f" Absent)" "no_enum"
if sh "$scan" "$f" Absent >/dev/null 2>&1; then rc=0; else rc=1; fi
check "no_enum/exit" "$rc" "1"

check "no_file/verdict" "$(verdict_of "$work/nowhere/mod.rye" Meaning)" "no_file"
if sh "$scan" "$work/nowhere/mod.rye" Meaning >/dev/null 2>&1; then rc=0; else rc=1; fi
check "no_file/exit" "$rc" "1"

# A missing argument is a caller's error rather than a reading, and exits 2 so it is tellable
# from a refusal about the file.
if sh "$scan" "$f" >/dev/null 2>&1; then rc2=0; else rc2=$?; fi
check "no_name/exit" "$rc2" "2"

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
