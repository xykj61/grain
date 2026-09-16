#!/bin/sh
# tools/fixtures/c/chemical_formula_scan.sh -- a formula names an operation, and the tree either declares it or does not.
#
# WHY. context/CHEMICAL_FORMULAS.md writes this tree's operations as reactions -- `batch(bolt,
# revision) + held -> manifest + bytes` -- and says on its own face that two guards read it and a
# wrong formula travels past both. tools/fixtures/d/document_mirror_scan.sh proves the page and its
# declared mirror byte-identical, so a false line reaches both homes intact and green.
# tools/fixtures/q/qa_report_card.sh scores Truth by whether cited paths RESOLVE, and a formula
# names a module rather than a path, so it cites nothing to resolve. The word `weave` stood in that
# page for seventeen days under both.
#
# THE ROAD IT ARRIVES BY, measured rather than argued. The repair of `20260909` corrected the
# formula in context/CHEMICAL_FORMULAS.md and swept its declared mirror biochemistry/README.md,
# proven byte-identical. foundations/20260825-211056_what-mantra-is.md -- the beginner door the root
# README.md and docs-geode/tutorials/the-first-hour.md both send a first hour to -- carried the same
# sentence, sat outside the mirror, outside that commit, and outside every guard. It read
# `weave(name_1 ... name_n) -> bytes_1 ... bytes_n` for six more days. A DECLARED MIRROR GUARANTEES
# TWO FILES AND CLAIMS NOTHING ABOUT THE THIRD PAGE THAT WROTE THE SAME SENTENCE.
#
# WHAT IS READ. A CALL-FORM TOKEN -- `name(` -- standing on a line that carries `->` inside an
# untagged fenced block, in a tracked .md page. That shape is narrow on purpose: it is the exact
# shape of the defect, it holds the one part of a formula the tree can answer for, and it refuses to
# guess about the prose operands beside it. `bytes + store -> resin + store'` names no operation the
# tree declares under those spellings and never claimed to; `infusion(world')` does.
#
# Measured on the seating lap over 1,200 living pages: 8 call-form tokens across 5 pages, and NOT
# ONE false positive from a shell transcript, an ASCII diagram, or a box-drawing block, though all
# three carry arrows in untagged fences throughout this tree. A token must start with a letter, so
# `sha3-512(8)` and `$(dirname "$f")` are both read past by the shape alone.
#
# WHAT COUNTS AS DECLARED. `fn <name>(` or `pub fn <name>(` in a tracked .rye source. A formula
# names an OPERATION, and in this tree an operation is a function -- so a `const <name> =
# @import(...)` binding is read past deliberately, since an import alias proves a module exists
# rather than that the operation does. The bound is named: a formula naming a Rishi builtin or a
# Glow arm would read undeclared today and wants its own widening, on the lap one arrives.
#
# WHY AN ERRATUM IS READ PAST. A page that molts a formula quotes the elder passage WHOLE under an
# `Erratum` heading, because the accretion law keeps every word. That quotation is testimony rather
# than a live claim, and a guard reading it as one would refuse the law that keeps the record
# honest -- so a fenced block standing under an `## Erratum` heading is read past, and counted
# aloud as `erratum_read_past` so a reader can see how much sits there.
#
# WHY A STAMPED BASENAME IS STILL LIVING HERE, against this tree's usual reading. The testimony rule
# of .claude/rules/stamp-and-name.md reads a one-clock basename as dated testimony, and
# foundations/20260825-211056_what-mantra-is.md carries exactly such a name -- yet it is a beginner
# door two front pages send a first hour to, and it is where the founding defect actually stood. A
# guard blind to its own founding case proves nothing. So the LIVING set is every tracked .md
# outside the shelves; a page on a date/, archive/ or yonder/ shelf is reported and never gated.
#
# WHAT IS GATED. `undeclared` across living pages, under a ceiling that only falls. It stands at 3
# on the seating lap, every one the noun `infusion` where brix/infuse.rye declares `fn infuse` --
# context/CHEMICAL_FORMULAS.md, its mirror biochemistry/README.md, and
# foundations/20260823-222019_what-brix-infuse-is.md, which is the water-cardinal rota seat. Whether
# those three take `infuse` is a seated word rather than a lap's choice, so they are NAMED here and
# left alone; the ceiling at exactly the standing count is what makes the next arrival red. `weave`
# would have taken it 3 to 4 on the lap it landed.
#
# USAGE
#   sh tools/fixtures/c/chemical_formula_scan.sh
#   sh tools/fixtures/c/chemical_formula_scan.sh --list    # name every token, page and verdict
#
# Driven by tools/c/chemical_formula_witness.rish. Run from the repository root.

set -eu

# `xargs -a FILE` and `xargs -d` are GNU extensions, and the macOS pier is a living seat, so the one
# portable spelling lives in tools/fixtures/s/shell_portable.sh. THE ROOT IS WALKED from this
# script's own $0 rather than computed by depth arithmetic, since a fold moving this file one
# directory deeper would break a fixed `../s` reach in silence. The sibling reach stays as a named
# fallback, because the control copies this scan into a flat pen holding fixtures/c and fixtures/s
# and no tree at all.
#
# IT IS LOAD-BEARING RATHER THAN A COURTESY, learned by running this scan's first draft. A bare
# `xargs` splits a path on a BLANK, and this tree holds exactly one tracked page whose name carries
# a space. awk met `./expanding-prompts/yonder/cursor-prompt_reorg-chunk-3_external-research` as a
# file that does not exist, and a missing operand is FATAL to awk -- so that whole batch died and
# the reading came back 375 hits where it should have carried 1,343. One spaced name in six thousand
# silenced three quarters of the tree, and the summary looked entirely reasonable.
_here=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_root="$_here"
_steps=0
while [ ! -d "$_root/rishi/bin" ] || [ ! -d "$_root/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$_root" = "/" ] || [ -z "$_root" ]; then
    _root=""
    break
  fi
  _root=$(dirname "$_root")
done
if [ -n "$_root" ]; then
  _portable="$_root/tools/fixtures/s/shell_portable.sh"
else
  _portable="$_here/../s/shell_portable.sh"
fi
[ -f "$_portable" ] || { echo "$0: shell_portable.sh absent -- looked in a walked root and beside \$0" >&2; exit 2; }
. "$_portable"

ceiling="${CHEMICAL_FORMULA_CEILING:-3}"
list=no
case "${1:-}" in
  --list) list=yes ;;
  "") ;;
  *) echo "verdict=bad_flag"; echo "refused: unknown flag ${1} -- this scan takes --list" >&2; exit 1 ;;
esac

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads the tracked tree, so it wants git" >&2; exit 1; }
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "verdict=no_repo"; echo "refused: run me from inside the repository" >&2; exit 1; }

work=$(mktemp -d) || { echo "verdict=no_pen"; exit 1; }
trap 'rm -rf "$work"' EXIT INT TERM

# vendor/, gratitude/ and seed/ are held or projected rather than authored here.
# Each page is handed to awk with a leading `./`: awk reads a bare argument as a VARIABLE ASSIGNMENT
# whenever the name left of an equals sign is a valid identifier, so a root-level page called
# `eq=1.md` would be read as a setting rather than opened -- no error, no hit, silence. The prefix
# is stripped inside the program, so every reported path stays the tracked spelling.
git ls-files '*.md' \
  | grep -v '^vendor/' | grep -v '^gratitude/' | grep -v '^seed/' \
  | sed 's|^|./|' > "$work/pages.txt" || true

pages=$(wc -l < "$work/pages.txt" | tr -d ' ')
[ "$pages" -gt 0 ] || { echo "pages=0"; echo "verdict=no_pages"; exit 1; }

# The declaration roster, read once. A process per token ran a git grep per name.
git ls-files '*.rye' | grep -v '^vendor/' \
  | xargs grep -hE '^[[:space:]]*(pub )?fn [a-z_][a-zA-Z0-9_]*\(' 2>/dev/null \
  | sed -E 's/^[[:space:]]*(pub )?fn ([a-z_][a-zA-Z0-9_]*)\(.*/\2/' \
  | sort -u > "$work/declared.txt" || true

cat > "$work/read.awk" <<'AWK'
BEGIN { FS = "\n" }
FNR == 1 {
  page = FILENAME
  sub(/^\.\//, "", page)
  shelved = (page ~ /(^|\/)(date|archive|yonder)\//) ? 1 : 0
  inb = 0; tag = ""; erratum = 0
}
# A heading closes the previous section's reading. `## Erratum` opens a quoted-elder section, and
# any later heading at the same depth or shallower closes it, so a page keeps reading after its
# erratum rather than falling silent from there down.
/^#/ {
  if ($0 ~ /^#+[[:space:]]+[Ee]rratum/) erratum = 1
  else if ($0 ~ /^##?[[:space:]]/) erratum = 0
  next
}
/^```/ {
  if (inb) { inb = 0; next }
  inb = 1
  tag = substr($0, 4)
  gsub(/[ \t\r]/, "", tag)
  next
}
inb && tag == "" && /->/ {
  line = $0
  while (match(line, /[a-z][a-z0-9_]*\(/)) {
    tok = substr(line, RSTART, RLENGTH - 1)
    line = substr(line, RSTART + RLENGTH)
    if (erratum) { print "erratum\t" page "\t" tok; continue }
    if (shelved) { print "shelved\t" page "\t" tok; continue }
    print (tok in DECL ? "declared" : "undeclared") "\t" page "\t" tok
  }
}
AWK

# The roster reaches awk as a file rather than through -v, since a name list has no bound a single
# variable could carry.
{
  echo 'BEGIN {'
  sed -E 's/.*/  DECL["&"] = 1/' "$work/declared.txt"
  echo '}'
  cat "$work/read.awk"
} > "$work/prog.awk"

# THE FAILURE IS NOT SWALLOWED, and the reason is this scan's own first draft. A `|| true` here
# would have hidden the fatal awk the spaced page name caused, and the summary would have reported a
# short count as a finished reading -- which is exactly what it did for one round. An instrument that
# cannot read must refuse rather than answer.
if ! xargs_lines_batched 400 "$work/pages.txt" awk -f "$work/prog.awk" > "$work/hits.txt"; then
  echo "verdict=read_failed"
  echo "refused: the page read failed -- a short count reported as a finished reading is worse than no reading" >&2
  exit 1
fi

declared=$(grep -c '^declared	' "$work/hits.txt" || true)
undeclared=$(grep -c '^undeclared	' "$work/hits.txt" || true)
erratum=$(grep -c '^erratum	' "$work/hits.txt" || true)
shelved=$(grep -c '^shelved	' "$work/hits.txt" || true)
declared=${declared:-0}; undeclared=${undeclared:-0}; erratum=${erratum:-0}; shelved=${shelved:-0}
tokens=$((declared + undeclared))
decl_names=$(wc -l < "$work/declared.txt" | tr -d ' ')

if [ "$list" = yes ]; then
  sort "$work/hits.txt" | while IFS='	' read -r verdict page tok; do
    echo "$verdict $page $tok"
  done
fi

echo "pages=$pages"
echo "fn_names_declared=$decl_names"
echo "tokens=$tokens"
echo "declared=$declared"
echo "undeclared=$undeclared"
echo "erratum_read_past=$erratum"
echo "shelved_tokens=$shelved"
echo "ceiling=$ceiling"

# Each undeclared token is named whatever the flag says. A count a reader cannot locate is a count
# somebody argues with rather than repairs.
grep '^undeclared	' "$work/hits.txt" 2>/dev/null | while IFS='	' read -r _ page tok; do
  echo "undeclared_at $page $tok"
done

if [ "$undeclared" -gt "$ceiling" ]; then
  echo "verdict=over_ceiling"
  echo "refused: $undeclared undeclared formula operations against a ceiling of $ceiling -- a formula names an operation this tree declares, or it names nothing" >&2
  exit 1
fi

echo "verdict=ok"
