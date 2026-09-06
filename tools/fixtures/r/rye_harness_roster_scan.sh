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

MODE=count
[ "${1:-}" = "--list" ] && MODE=list

# Bounds, both named here and checked at the edge below.
# A harness is a whole test suite, and this tree holds one; sixty-four leaves room for a
# generation of them and still refuses a runaway match.
max_harnesses=64
# The largest list standing today is 116 stems. A thousand and twenty-four is three orders over
# that, and small enough that a pathological file cannot turn the scan into a sort of the tree.
max_stems=1024
# The ceiling only ever falls. Measured 20260906: 10 assembled shapes whose directory or stem
# list this scan cannot read, because each binds its stems from a `while read` over a find rather
# than from a literal list. Six of the ten are the roster guards this rule descends from --
# crypto_tool_declaration, module_roster, mycelium_map_roster, and their controls -- which already
# compare their own directory against their own page, so their shape is covered by their own
# witness rather than by this one. The other four are pen and probe scripts that build a corpus at
# runtime, where there is no list on disk to compare a directory against.
unresolved_ceiling=10

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
find . -name '*.rish' -o -name '*.sh' 2>/dev/null \
  | sed 's|^\./||' | grep -vE '^(vendor|gratitude|seed)/' \
  | grep -v 'rye_harness_roster' | sort > "$TMP/scripts"

# A build site is the token in argument position after a rye verb, with the verb bound to the rye
# driver itself -- so the prose `rye build failed for RW-2` is read past rather than counted. A
# backslash continuation is joined first, since a multi-line invocation carries its target on the
# next line, and the join stops at a file boundary: awk's getline reads on into the NEXT file, so a
# script whose last line ends in a backslash would otherwise swallow the first line of its
# neighbour and invent a site that neither file holds.
#
# One awk over batched files rather than one awk per file. Three thousand scripts is three thousand
# processes in the shape this started as, and it measured 35s under load where the batched form
# takes about one -- the same cure REDS %460 applied to the runner census, for the same reason.
: > "$TMP/targets"
cat > "$TMP/sites.awk" <<'AWK'
{ line = $0; f0 = FILENAME
  while (line ~ /\\$/) {
    if ((getline nxt) <= 0 || FILENAME != f0) break
    sub(/\\$/, " ", line); line = line nxt
  }
  n = split(line, w, /[ \t]+/)
  for (i = 1; i < n; i++) {
    v = w[i]; sub(/^.*\//, "", v)
    if (v == "build" || v == "build-lib" || v == "build-exe" || v == "run" || v == "test") {
      p = w[i-1]; gsub(/^["'\''(]+/, "", p)
      if (p ~ /(^|\/)rye$/) { t = w[i+1]; gsub(/^["'\'']+|["'\'']+$/, "", t); print t }
    } } }
AWK
# An `awk -f` that produces OUTPUT has no found-nothing exit, so any non-zero is a failure and
# discarding it would let a broken instrument and an empty tree report the same green (REDS %413,
# %416). The error text is kept and named rather than sent to /dev/null.
if ! xargs_lines_batched 400 "$TMP/scripts" awk -f "$TMP/sites.awk" >> "$TMP/targets" 2>"$TMP/awk.err"; then
  echo "detail: awk could not read the script corpus -- $(head -1 "$TMP/awk.err" 2>/dev/null)"
  echo "verdict=instrument_failed"
  exit 2
fi

sites_total=$(wc -l < "$TMP/targets" | tr -d ' ')
sites_literal=$(grep -cE '\.rye$' "$TMP/targets" || true)
sites_assembled=$(grep -cE '[$*]' "$TMP/targets" || true)
# The three must add to the total, so nothing is quietly dropped. What is left over is prose that
# happened to follow the driver's name -- `rye build failed for RW-2` -- and a residue nobody can
# see is a residue nobody can question.
sites_unparsed=$((sites_total - sites_literal - sites_assembled))

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
sort -u "$TMP/candidates_raw" > "$TMP/candidates"
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
