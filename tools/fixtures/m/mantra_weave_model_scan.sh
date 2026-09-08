#!/bin/sh
# tools/fixtures/m/mantra_weave_model_scan.sh -- every copy of Mantra's weave model, compared.
#
# WHAT THIS ANSWERS. Mantra's weave model is the triple `Line` - `Diff` - `Weave`. This scan
# finds every tracked Rye file that declares all three, reads each one's fields in order, and
# compares every copy against the published module:
#
#   sh tools/fixtures/m/mantra_weave_model_scan.sh
#   module=mantra/src/weave.rye
#   module_line=text gen pos site
#   copy=mantra/src/main.rye line=declares [text gen pos] diff=declares [inserts deletes] weave=agree
#   copies=2  agreeing=0  disagreements=2  disagreement_ceiling_held=yes  unreadable=0
#   verdict=ok
#
# WHY IT EXISTS. `tools/m/mantra_glow_tend_limb1_witness.rish` proves that `Line` carries the
# fields its Glow placard names, and `construction/ITINERARY.md` calls that guard the lock on
# widening `Line`. It reads ONE file. Measured the day this was written, Mantra's model is
# declared in THREE: `mantra/src/weave.rye` (the module, guarded), `mantra/src/main.rye` (the
# CLI seed, guarded by nothing), and `rye/tests/mantra_weave_test.rye`, whose own comment reads
# `Weave (inlined from mantra/src/main.rye)`. All three agreed field for field when this was
# measured, so nothing was wrong -- and a hand widening the module would have reddened one lock
# and left two copies standing. That is REDS %500's finding one turn deeper: %500 repaired HOW
# a guard reads a struct, and this repairs WHAT it reads.
#
# HOW THE SET IS BOUND, and why by discovery rather than by a list. A list of copies kept here
# would be a fourth copy of the same fact, which is the shape this scan exists to refuse. So
# membership is derived: a file declaring all three of `Line`, `Diff` and `Weave` is carrying
# the model. The triple is what discriminates -- eight other tracked files declare a `Line` or
# a `Diff` for their own unrelated subjects (Brushstroke, Caravan, Mycelium, Lotus, Pond), and
# not one of them declares a `Weave`. A file declaring `Weave` without the other two is named
# `skipped` rather than judged, since it is not this model.
#
# WHAT IT FOUND ON THE DAY IT LANDED, and why the count is a ceiling rather than a zero. This scan
# was written on `20260906` when all three copies agreed, and it sat unlanded in a round-open stash
# (REDS %499) while `bc37657e8` widened the module: `Line` gained `site` and `Diff` gained `site`,
# so a line is now named by the pair its `id()` returns. Neither the CLI seed nor its test moved.
# The predicted hazard is therefore the measured one -- and the cure is not a lap's to take, since
# `mantra/src/main.rye` writes `gen`, `pos` and text into `.mantra/` and adding a field rewrites a
# shipped record. So the two known-lagging copies stand under a ceiling that only falls, and every
# copy ARRIVING disagreeing is refused, which is the reading the guard was drawn for.
#
# WHAT IT CANNOT READ it says so rather than guessing. `rye_struct_fields_scan.sh` reads a
# struct whose fields stand one per line, and refuses a single-line declaration by name. A copy
# it cannot read is counted in `unreadable` and named, because a copy nobody can check is
# exactly the door this scan was written to find.
#
# VERDICTS. ok - disagree (more disagreeing copies than the ceiling welcomes) - unreadable -
# unbalanced (the copies do not sum) - no_module (the module itself is gone or unreadable).
#
# Read by tools/m/mantra_weave_model_witness.rish. Proven by
# tools/fixtures/m/mantra_weave_model_control.sh. Run from the repository root.

set -eu

fields_of=${FIELDS_SCAN:-tools/fixtures/r/rye_struct_fields_scan.sh}
module=${MODULE_PATH:-mantra/src/weave.rye}

# HOW MANY DISAGREEING COPIES THIS SCAN WELCOMES. Zero by default, because agreement is what the
# scan is for and a pen proving a break should meet the strict reading. The caller may raise it,
# and exactly one caller does: `tools/m/mantra_weave_model_witness.rish` passes 2 for the live
# tree, where `mantra/src/main.rye` and `rye/tests/mantra_weave_test.rye` still carry the
# three-field `Line` the module widened to four at `bc37657e8`. Reconciling them rewrites the
# on-disk `.mantra/` record, which is a seam at Keaton's word, so the count is held under a
# ceiling that only falls rather than gated at a zero no lap may reach.
ceiling=${DISAGREE_CEILING:-0}

# One struct's fields, or the empty string when the reader refuses. The refusal is the caller's
# to interpret: an empty answer for the module is fatal, and for a copy it is `unreadable`.
read_fields() {
  sh "$fields_of" --fields "$1" "$2" 2>/dev/null || true
}

module_line=$(read_fields "$module" Line)
module_diff=$(read_fields "$module" Diff)
module_weave=$(read_fields "$module" Weave)

echo "module=$module"
echo "module_line=$module_line"
echo "module_diff=$module_diff"
echo "module_weave=$module_weave"

if [ -z "$module_line" ] || [ -z "$module_diff" ] || [ -z "$module_weave" ]; then
  echo "copies=0"
  echo "agreeing=0"
  echo "disagreements=0"
  echo "unreadable=0"
  echo "verdict=no_module"
  exit 1
fi

# Every tracked Rye file declaring a struct named Weave, found in ONE pass. `git grep` reads
# tracked files only, so a copy added and staged this lap is judged on the lap it arrives and an
# untracked scratch file is not. A grep per file read the same 3,000 sources three thousand
# times and cost seven seconds; this costs one pass, and a guard nobody can afford to run every
# lap is a guard that ends up on a slower clock than its subject deserves.
candidates=$(git grep -lE '^(pub )?const Weave = struct \{' -- '*.rye' 2>/dev/null || true)

copies=0
agreeing=0
disagreements=0
unreadable=0
skipped=0

for file in $candidates; do
  [ -f "$file" ] || continue
  [ "$file" = "$module" ] && continue

  has_line=$(grep -Ec "^(pub )?const Line = struct" "$file" || true)
  has_diff=$(grep -Ec "^(pub )?const Diff = struct" "$file" || true)
  if [ "$has_line" -eq 0 ] || [ "$has_diff" -eq 0 ]; then
    echo "skipped=$file reason=not_the_triple"
    skipped=$((skipped + 1))
    continue
  fi

  copies=$((copies + 1))
  copy_line=$(read_fields "$file" Line)
  copy_diff=$(read_fields "$file" Diff)
  copy_weave=$(read_fields "$file" Weave)

  if [ -z "$copy_line" ] || [ -z "$copy_diff" ] || [ -z "$copy_weave" ]; then
    echo "copy=$file line=${copy_line:-unreadable} diff=${copy_diff:-unreadable} weave=${copy_weave:-unreadable} verdict=unreadable"
    unreadable=$((unreadable + 1))
    continue
  fi

  verdict_line=agree
  verdict_diff=agree
  verdict_weave=agree
  [ "$copy_line" = "$module_line" ] || verdict_line="declares [$copy_line]"
  [ "$copy_diff" = "$module_diff" ] || verdict_diff="declares [$copy_diff]"
  [ "$copy_weave" = "$module_weave" ] || verdict_weave="declares [$copy_weave]"

  if [ "$verdict_line" = agree ] && [ "$verdict_diff" = agree ] && [ "$verdict_weave" = agree ]; then
    agreeing=$((agreeing + 1))
    echo "copy=$file line=agree diff=agree weave=agree"
  else
    disagreements=$((disagreements + 1))
    echo "copy=$file line=$verdict_line diff=$verdict_diff weave=$verdict_weave"
  fi
done

ceiling_held=yes
[ "$disagreements" -le "$ceiling" ] || ceiling_held=no

echo "copies=$copies"
echo "agreeing=$agreeing"
echo "disagreements=$disagreements"
echo "disagreement_ceiling=$ceiling"
echo "disagreement_ceiling_held=$ceiling_held"
echo "unreadable=$unreadable"
echo "skipped_not_the_triple=$skipped"

# The arithmetic is stated so a reader can check the reading rather than trust it. Every copy is
# counted exactly once -- agreeing, disagreeing, or unreadable -- and a set that does not sum has
# measured something other than the copies. It is asked FIRST, because a ceiling over a number
# that does not sum would welcome or refuse for a reason nobody could act on.
if [ "$((agreeing + disagreements + unreadable))" -ne "$copies" ]; then
  echo "verdict=unbalanced"
  exit 1
fi

# The copy COUNT is reported and never gated. Deleting a copy is the cure for a duplicated
# model, so a guard pinned to today's count would red the day somebody applied it.
verdict=ok
[ "$ceiling_held" = yes ] || verdict=disagree
[ "$unreadable" -eq 0 ] || verdict=unreadable
echo "verdict=$verdict"
[ "$verdict" = ok ]
