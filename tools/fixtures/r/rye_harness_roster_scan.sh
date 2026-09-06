#!/bin/sh
# tools/fixtures/r/rye_harness_roster_scan.sh -- a harness that assembles its paths must roster
# the directory it assembles them from.
#
# WHY. tools/p/parity_ch01.rish builds and runs 116 Rye programs, and not one of their paths is
# written anywhere in this tree. The harness holds `let dir = "rye/tests"` and a list of 116 bare
# stems, and reaches each file as `${dir}/${s}.rye`. Two consequences follow, and both are quiet.
#
#   A census that reads for filenames calls all 116 unbuilt. On 20260906 one did, and its count
#   reached the operator card as a fact.
#
#   A test file added to rye/tests/ and left out of the list is never run, and the suite still
#   reports GREEN -- because the suite asserts over the list it holds rather than over the
#   directory it names. That failure is open, silent, and looks exactly like success.
#
# The tree already keeps this discipline in two other rooms: crypto_tool_declaration_scan.sh reds
# a `ghost_module` whose stem names no file, and module_roster_scan.sh reds an `unrostered` file
# that stands on disk with no row. Neither reaches the largest assembled site in the tree. This
# scan carries the same rule to every harness that builds a path out of a directory and a stem.
#
# WHAT IS GATED, hard, at zero.
#   stems_absent -- a stem names no .rye file in the harness's own directory, so the harness
#     claims to run a program that is not there.
#   files_unlisted -- a .rye file stands in the harness's directory and no stem names it, so
#     nothing runs it while the suite reads green.
#
# WHAT IS REPORTED. The build-site census behind the rule: how many rye build/run/test sites name
# their target as a literal path, and how many assemble it from a variable or a glob. A literal
# site is legible to any reader; an assembled one is legible only to the shell. And `unresolved`
# -- an assembled `${A}/${B}.rye` shape whose directory or stem list this scan could not read.
# Reported rather than gated, because a shape nobody has taught it is a gap in the instrument
# rather than a fault in the tree, and an instrument that reds for its own blindness gets turned
# off. The ceiling only ever falls.
#
# And `assemblers_not_harnesses` -- scripts that spell the shape and hand it to no builder. They are
# not this scan's subject and never were: a census resolving a module path in order to READ it
# assembles exactly the shape a harness does. Ten stood inside `unresolved` until `20260906`, so the
# ceiling that was meant to bound this instrument's blindness was mostly bounding the tree's
# ordinary censuses instead, and it rose whenever anybody wrote one. They are counted in the open
# and named by --list, because a reading declined in silence is a reading nobody can question.
#
# WHAT IS NOT PROVEN. That a listed program compiles, that it asserts anything, or that running
# it is worth the seconds. Only that the set the harness names and the set on disk are one set.
#
# USAGE
#   sh tools/fixtures/r/rye_harness_roster_scan.sh          # counts and verdict
#   sh tools/fixtures/r/rye_harness_roster_scan.sh --list   # name each fault, one per line
#
# Driven by tools/r/rye_harness_roster_witness.rish. Run from the repository root, or from the
# root of a pen laid out the same way.

set -u

# Root by upward walk (seated 20260828): the letter fold moves a script a directory deeper, and
# fixed ../.. depth arithmetic is what breaks. The walk finds the first ancestor holding rishi/bin
# and tools/fixtures -- git-free, so a pen copy outside a repository still resolves -- bounded at
# 8 steps, loud past the bound.
_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/s/shell_portable.sh"

# --paths answers a different question than the gate does, so it computes only what that question
# needs. A consumer wants the paths a harness assembles; it does not want the build-site census,
# which is one awk over three thousand scripts and very nearly the whole of this scan's wall time --
# 3.8s against 0.08s for the candidate grep, measured 20260906. So paths mode short-circuits before
# that census and prints `paths_mode=1` as its own marker. Without the marker, a consumer calling
# --paths on a copy too old to know the flag would read an ordinary count-mode reading, find no
# paths in it, and credit nothing -- silence that looks exactly like an honest empty answer.
# An unknown argument refuses for the same reason: a flag read past is a question read as answered.
MODE=count
case "${1:-}" in
  '')      ;;
  --list)  MODE=list ;;
  --paths) MODE=paths ;;
  *) echo "detail: unknown argument $1 -- this scan takes --list or --paths"
     echo "verdict=bad_argument"; exit 2 ;;
esac

# Bounds, both named here and checked at the edge below.
# A harness is a whole test suite, and this tree holds one; sixty-four leaves room for a
# generation of them and still refuses a runaway match.
max_harnesses=64
# The largest list standing today is 116 stems. A thousand and twenty-four is three orders over
# that, and small enough that a pathological file cannot turn the scan into a sort of the tree.
max_stems=1024
# The ceiling only ever falls, and it fell 10 -> 1 on 20260906 when the reading was narrowed to
# its own subject. The elder ten were scripts that spell `${A}/${B}.rye` and hand it to nothing --
# six roster guards comparing a directory against a page, three pens planting a corpus, and one
# witness census resolving a subject's path to read it. None is a harness, so none was ever a gap
# in this instrument; they are counted in the open as `assemblers_not_harnesses` and named by
# --list. What remains at 1 is the honest residue: caravan_reply_control.sh assembles
# $build_dir/$neighbour.rye AND builds it, so its stems are a list this scan genuinely cannot read.
unresolved_ceiling=1

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT INT TERM

# The scripts a harness could live in. find rather than a glob, so nothing matches when nothing
# is there, and a pen with no such directory reads zero rather than printing its own pattern.
#
# This guard's own three files are read past by name. A scan, its witness, and its control all
# necessarily spell the shape the scan hunts for -- the scan in its header and its fault messages,
# the witness in its reason, the control in the pens it plants -- so an instrument that reads its
# own family counts its documentation as tree evidence. Four false unresolved shapes stood on the
# lap it was written, and the eleventh took the guard red against itself. An instrument must know
# where it stands (REDS %458).
#
# `rye_compile_reach_control.sh` joins that list on 20260906 for the same reason and by the same
# rule: it is the control of the census that CONSUMES --paths below, so it plants a working harness
# into a pen, and a plant is written by spelling the assembled shape into a printf. Read as tree
# evidence it is an unresolvable site; read honestly it is this flag's own test. Its scan is NOT
# excluded and must never be -- that file consumes the answer without spelling the shape, so it
# stays out of this corpus on its own merit, and the day somebody writes the shape into it the
# count rises and says so. An exclusion is a claim about one file, never about a family.
find . -name '*.rish' -o -name '*.sh' 2>/dev/null \
  | sed 's|^\./||' | grep -vE '^(vendor|gratitude|seed)/' \
  | grep -vE 'rye_harness_roster|rye_compile_reach_control' | sort > "$TMP/scripts"

# A build site is the token in argument position after a rye verb, with the verb bound to the rye
# driver itself -- so the prose `rye build failed for RW-2` is read past rather than counted.
# BOTH SPELLINGS. Shell writes `rye/bin/rye build x.rye`; Rishi writes the same call as a quoted
# list, `run ["env" rye "build" "x.rye"]`. The elder program stripped quotes from the driver
# token and from the target and not from the VERB, so every Rishi-spelled build was invisible to
# it -- 47 of them, measured 20260906 over 3,127 tracked scripts (2,120 -> 2,167). That blind
# spot grows with the tree, since operational shell molts to Rishi by standing law, and it is
# load-bearing twice over now that this same program decides below what counts as a harness. A
# backslash continuation is joined first, since a multi-line invocation carries its target on the
# next line, and the join stops at a file boundary: awk's getline reads on into the NEXT file, so a
# script whose last line ends in a backslash would otherwise swallow the first line of its
# neighbour and invent a site that neither file holds.
#
# One awk over batched files rather than one awk per file. Three thousand scripts is three thousand
# processes in the shape this started as, and it measured 35s under load where the batched form
# takes about one -- the same cure REDS %460 applied to the runner census, for the same reason.
: > "$TMP/targets"
sites_total=0; sites_literal=0; sites_assembled=0; sites_unparsed=0
# The build-site program is written in EVERY mode, because it answers two questions rather than
# one. Below it drives the census; further down it is the predicate that decides whether an
# assembled `${A}/${B}.rye` shape belongs to a harness at all. One program, asked twice -- rather
# than a second spelling of "what counts as a build" that could drift from this one.
cat > "$TMP/sites.awk" <<'AWK'
{ line = $0; f0 = FILENAME
  while (line ~ /\\$/) {
    if ((getline nxt) <= 0 || FILENAME != f0) break
    sub(/\\$/, " ", line); line = line nxt
  }
  n = split(line, w, /[ \t]+/)
  for (i = 1; i < n; i++) {
    v = w[i]; gsub(/^["'\''\[(]+|["'\'']+$/, "", v); sub(/^.*\//, "", v)
    if (v == "build" || v == "build-lib" || v == "build-exe" || v == "run" || v == "test") {
      p = w[i-1]; gsub(/^["'\''\[(]+|["'\'']+$/, "", p)
      if (p ~ /(^|\/)rye$/) { t = w[i+1]; gsub(/^["'\''\[(]+|["'\'']*[\])]*["'\'']*$/, "", t); print t }
    } } }
AWK
if [ "$MODE" != paths ]; then
# An `awk -f` that produces OUTPUT has no found-nothing exit, so any non-zero is a failure and
# discarding it would let a broken instrument and an empty tree report the same green (REDS %413,
# %416). The error text is kept and named rather than sent to /dev/null.
if ! xargs_lines_batched 400 "$TMP/scripts" awk -f "$TMP/sites.awk" >> "$TMP/targets" 2>"$TMP/awk.err"; then
  echo "detail: awk could not read the script corpus -- $(head -1 "$TMP/awk.err" 2>/dev/null)"
  echo "verdict=instrument_failed"
  exit 2
fi

sites_total=$(wc -l < "$TMP/targets" | tr -d ' ')
# THE THREE CLASSES ARE DISJOINT, and they are read in this order because a target carrying a
# variable is assembled whether or not it also ends in `.rye`. Counted independently they overlap:
# `${dir}/${s}.rye` matches both patterns, so it was added twice and the leftover absorbed the
# difference as if it were prose. The elder spelling could only ever understate `sites_unparsed`,
# never overstate it, so the fault looked like a small honest residue -- until this program learned
# the Rishi spelling above and the residue went NEGATIVE, which is the instrument declaring its own
# arithmetic broken. A count that cannot go below zero cannot tell you it is wrong.
sites_assembled=$(grep -cE '[$*]' "$TMP/targets" || true)
sites_literal=$(grep -vE '[$*]' "$TMP/targets" | grep -cE '\.rye$' || true)
# What is left over is prose that happened to follow the driver's name -- `rye build failed for
# RW-2` -- and a residue nobody can see is a residue nobody can question.
sites_unparsed=$((sites_total - sites_literal - sites_assembled))
fi

# The assembled shape this scan can read: a directory held in one variable, a stem held in
# another, joined into a path. Everything else is counted as unresolved and named.
: > "$TMP/harnesses"
: > "$TMP/unresolved"
# Only the scripts that actually spell the shape are opened one at a time. One batched grep -l
# names them -- thirteen of three thousand -- so the per-file work below runs thirteen times.
: > "$TMP/candidates"
# grep exits 1 on no match, and xargs answers 123 when any invocation in a batch does -- the
# ordinary reading here, since only eleven files in the tree spell this shape and a batch holds
# four hundred. So a non-zero exit alone says nothing. What separates a found-nothing from a
# failure is whether grep wrote to stderr, so stderr is kept rather than discarded and the two are
# told apart by reading it. A `|| true` here would swallow both alike (REDS %413, %416).
if ! xargs_lines_batched 400 "$TMP/scripts" \
       grep -lE '\$\{?[A-Za-z_][A-Za-z0-9_]*\}?/\$\{?[A-Za-z_][A-Za-z0-9_]*\}?\.rye' \
       > "$TMP/candidates_raw" 2>"$TMP/grep.err"; then
  if [ -s "$TMP/grep.err" ]; then
    echo "detail: grep could not read the script corpus -- $(head -1 "$TMP/grep.err")"
    echo "verdict=instrument_failed"
    exit 2
  fi
fi
sort -u "$TMP/candidates_raw" > "$TMP/candidates_all"

# A HARNESS BUILDS. Spelling `${dir}/${stem}.rye` is not what makes a script a harness -- handing
# that path to the rye driver is. A census that resolves a module path to READ it assembles the
# same shape and builds nothing, so counting it here asks a question about a file that file never
# claimed to answer. Measured 20260906: of eleven scripts carrying the shape and unreadable stems,
# ten invoke no build at all -- six roster guards that compare a directory against a page, three
# pens that plant a corpus, and one witness census. The reading was named for harnesses and had
# grown into a count of everything that mentions a Rye path.
#
# The predicate is the census program above, run over the candidate rather than over the tree, so
# a build is whatever this scan already says a build is. `sites.awk` prints one line per build
# target, so a candidate with no output builds nothing.
: > "$TMP/candidates"
: > "$TMP/nonharness"
while IFS= read -r c; do
  [ -f "$c" ] || continue
  if [ -n "$(awk -f "$TMP/sites.awk" "$c" 2>/dev/null | head -1)" ]; then
    echo "$c" >> "$TMP/candidates"
  else
    echo "$c" >> "$TMP/nonharness"
  fi
done < "$TMP/candidates_all"
n_nonharness=$(wc -l < "$TMP/nonharness" | tr -d ' ')

while IFS= read -r s; do
  [ -f "$s" ] || continue
  grep -oE '\$\{?[A-Za-z_][A-Za-z0-9_]*\}?/\$\{?[A-Za-z_][A-Za-z0-9_]*\}?\.rye' "$s" 2>/dev/null \
    | sed -E 's/\$\{?([A-Za-z_][A-Za-z0-9_]*)\}?\/\$\{?([A-Za-z_][A-Za-z0-9_]*)\}?\.rye/\1 \2/' \
    | sort -u \
    | while read -r dvar svar; do
        [ -n "${dvar:-}" ] || continue
        # The directory: `let d = "lit"` in Rishi, or `d=lit` / `d="lit"` in shell.
        dir=$(grep -oE "(^|[[:space:]])let[[:space:]]+${dvar}[[:space:]]*=[[:space:]]*\"[^\"]+\"" "$s" 2>/dev/null \
              | head -1 | sed -E 's/.*"([^"]+)"$/\1/')
        [ -n "$dir" ] || dir=$(grep -oE "^[[:space:]]*${dvar}=\"?[A-Za-z0-9_./-]+\"?" "$s" 2>/dev/null \
              | head -1 | sed -E "s/^[[:space:]]*${dvar}=//; s/\"//g")
        # The stems: Rishi binds them with `map <list> as <svar>:`; shell with `for <svar> in ...`.
        list=$(grep -oE "map[[:space:]]+[A-Za-z_][A-Za-z0-9_]*[[:space:]]+as[[:space:]]+${svar}[[:space:]]*:" "$s" 2>/dev/null \
               | head -1 | sed -E 's/map[[:space:]]+([A-Za-z_][A-Za-z0-9_]*)[[:space:]]+as.*/\1/')
        stems=""
        if [ -n "$list" ]; then
          stems=$(grep -oE "let[[:space:]]+${list}[[:space:]]*=[[:space:]]*\[[^]]*\]" "$s" 2>/dev/null \
                  | head -1 | grep -oE '"[A-Za-z0-9_][A-Za-z0-9_.-]*"' | tr -d '"')
        fi
        if [ -z "$stems" ]; then
          stems=$(grep -oE "for[[:space:]]+${svar}[[:space:]]+in[[:space:]]+[A-Za-z0-9_ .-]+" "$s" 2>/dev/null \
                  | head -1 | sed -E "s/for[[:space:]]+${svar}[[:space:]]+in[[:space:]]+//")
        fi
        if [ -n "$dir" ] && [ -d "$dir" ] && [ -n "$stems" ]; then
          printf '%s\t%s\t%s\n' "$s" "$dir" "$(echo $stems | tr ' ' ',')" >> "$TMP/harnesses"
        else
          printf '%s\t%s\t%s\n' "$s" "${dvar}" "${svar}" >> "$TMP/unresolved"
        fi
      done
done < "$TMP/candidates"

n_harnesses=$(wc -l < "$TMP/harnesses" | tr -d ' ')
n_unresolved=$(wc -l < "$TMP/unresolved" | tr -d ' ')

# Bound checked at the edge, before any per-harness work, and named in the refusal.
if [ "$n_harnesses" -gt "$max_harnesses" ]; then
  echo "harnesses=$n_harnesses"
  echo "verdict=harness_bound_exceeded"
  exit 1
fi

# --paths: the paths, one per line, each carrying the script that assembles it. The consumer needs
# the script because the credit it grants is conditional on that script compiling anything -- this
# scan answers WHAT a harness assembles and says nothing about whether it builds, which is the
# other half and somebody else's question. Every stem bound is enforced above this line, so a
# runaway list refuses here as it does in count mode.
if [ "$MODE" = paths ]; then
  : > "$TMP/paths"
  while IFS="$(printf '\t')" read -r src dir stems; do
    echo "$stems" | tr ',' '\n' | grep -v '^$' | sort -u > "$TMP/named"
    c=$(wc -l < "$TMP/named" | tr -d ' ')
    if [ "$c" -gt "$max_stems" ]; then
      echo "paths_mode=1"; echo "harnesses=$n_harnesses"
      echo "verdict=stem_bound_exceeded"; exit 1
    fi
    sed "s|^|harness_path $src $dir/|; s|\$|.rye|" "$TMP/named" >> "$TMP/paths"
  done < "$TMP/harnesses"
  cat "$TMP/paths"
  # The residue, named rather than only counted. `unresolved=N` says how many sites this scan
  # could not read; it does not say whether any of them matters to the consumer, because the
  # consumer's credit is CONDITIONAL on the assembling script compiling anything and this scan
  # does not ask that question. So the sites are named here and the weighing is left where the
  # condition lives. Measured on the field 20260906: ten sites, nine of them in scripts that never
  # invoke the Rye compiler, so nine could not have credited a path whether resolved or not.
  while IFS="$(printf '\t')" read -r src dvar svar; do
    [ -n "${src:-}" ] && echo "harness_unresolved $src $dvar $svar"
  done < "$TMP/unresolved"
  # The marker rides ahead of the counters and is printed even when the corpus is empty, so a
  # consumer can tell "this tree holds no harness" from "this copy does not know the flag". Those
  # two readings look identical in the paths alone, and only one of them is a fault.
  echo "paths_mode=1"
  # A second marker for a second promise. A copy that knows --paths but not the naming above would
  # print zero `harness_unresolved` lines beside a positive `unresolved=`, which reads exactly like
  # a residue that is entirely harmless -- the most convincing wrong answer this seam can give. The
  # marker separates "no unresolved site here" from "this copy does not name them".
  echo "unresolved_named=1"
  echo "assemblers_not_harnesses=$n_nonharness"
  echo "harnesses=$n_harnesses"
  echo "harness_units=$(wc -l < "$TMP/paths" | tr -d ' ')"
  echo "unresolved=$n_unresolved"
  if [ "$n_harnesses" -eq 0 ]; then echo "verdict=empty_corpus"; exit 1; fi
  echo "verdict=ok"
  exit 0
fi

n_stems=0
n_absent=0
n_unlisted=0
: > "$TMP/faults"
while IFS="$(printf '\t')" read -r src dir stems; do
  echo "$stems" | tr ',' '\n' | grep -v '^$' | sort -u > "$TMP/named"
  c=$(wc -l < "$TMP/named" | tr -d ' ')
  if [ "$c" -gt "$max_stems" ]; then
    echo "harnesses=$n_harnesses"
    echo "verdict=stem_bound_exceeded"
    exit 1
  fi
  n_stems=$((n_stems + c))
  # A seam symlink is a program here, so the type test welcomes a regular file and a link alike.
  find "$dir" -maxdepth 1 -name '*.rye' \( -type f -o -type l \) 2>/dev/null \
    | sed 's|.*/||; s|\.rye$||' | sort -u > "$TMP/ondisk"
  comm -23 "$TMP/named" "$TMP/ondisk" > "$TMP/absent"
  comm -13 "$TMP/named" "$TMP/ondisk" > "$TMP/unlisted"
  n_absent=$((n_absent + $(wc -l < "$TMP/absent" | tr -d ' ')))
  n_unlisted=$((n_unlisted + $(wc -l < "$TMP/unlisted" | tr -d ' ')))
  while IFS= read -r m; do [ -n "$m" ] && \
    echo "stem_absent: $src names $dir/$m.rye, which stands nowhere on disk" >> "$TMP/faults"; done < "$TMP/absent"
  while IFS= read -r m; do [ -n "$m" ] && \
    echo "file_unlisted: $dir/$m.rye stands on disk and $src names no stem for it" >> "$TMP/faults"; done < "$TMP/unlisted"
done < "$TMP/harnesses"

if [ "$MODE" = list ]; then
  cat "$TMP/faults"
  while IFS="$(printf '\t')" read -r src dvar svar; do
    echo "unresolved: $src assembles \$$dvar/\$$svar.rye and this scan cannot read one of the two"
  done < "$TMP/unresolved"
  # Named, never merely counted. A script dropped for building nothing is a reading this scan
  # deliberately declines to make, and a decline nobody can see is a decline nobody can question.
  while IFS= read -r c; do
    [ -n "${c:-}" ] && echo "not_a_harness: $c assembles a .rye path and hands none to the rye driver"
  done < "$TMP/nonharness"
fi

echo "scripts=$(wc -l < "$TMP/scripts" | tr -d ' ')"
echo "build_sites=$sites_total"
echo "sites_literal=$sites_literal"
echo "sites_assembled=$sites_assembled"
echo "sites_unparsed=$sites_unparsed"
echo "harnesses=$n_harnesses"
echo "harness_units=$n_stems"
echo "stems_absent=$n_absent"
echo "files_unlisted=$n_unlisted"
echo "assemblers_not_harnesses=$n_nonharness"
echo "unresolved=$n_unresolved"
echo "unresolved_ceiling=$unresolved_ceiling"

# A reading over an empty corpus finds no fault and would report clean while measuring nothing,
# so the corpus size is published beside the verdict and an empty corpus refuses (REDS %170).
if [ "$n_harnesses" -eq 0 ]; then
  echo "verdict=empty_corpus"
  exit 1
fi
if [ "$n_unresolved" -gt "$unresolved_ceiling" ]; then
  echo "verdict=unresolved_over_ceiling"
  exit 1
fi
if [ "$n_absent" -eq 0 ] && [ "$n_unlisted" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=roster_disagrees"
exit 1
