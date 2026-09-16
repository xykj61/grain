#!/bin/sh
# tools/fixtures/p/pen_entry_scan.sh -- a script that makes a throwaway pen and never enters it
# writes its fixtures against the live checkout.
#
#   sh tools/fixtures/p/pen_entry_scan.sh [--list]
#
# WHY. REDS %729: tools/fixtures/r/readme_reach_control.sh built each case with
# `build() { rm -rf "$pen/t"; mkdir -p "$pen/t"; cd "$pen/t"; }` -- no `set -e`, and the `cd`
# unchecked. When the pen could not be made the function returned with the working directory still
# at the repository root, and every case body then ran there: `printf ... > README.md` truncated
# this tree's tracked front door, and three `git config` calls rewrote this checkout's own identity.
# Twelve commits on main carry `pen <pen@example.invalid>` and signature `N` as a result.
#
# The repair at the edge was made in 23 control files. The class was not: `shared_pen` asks whether
# a pen is SHARED -- one constant name, eight checkouts -- and nothing in this tree asked whether a
# pen was ever ENTERED. Contention and containment are two questions, and one guard answered the
# first.
#
# WHAT IS COUNTED. In every living tracked shell runner that assigns a variable from `mktemp -d`:
# a `cd` command whose argument names one of that file's pen variables, where nothing stops the
# script if the `cd` fails. A pen variable is one assigned from `mktemp -d` directly, or assigned
# from a string naming an existing pen variable -- collected as the file is read, so `pen=$(mktemp -d)`
# followed by `d="$pen/t"` makes both.
#
# WHAT COUNTS AS GUARDED, and every one of the three is a real stop rather than a style:
#
#   1. `set -e` in force -- `set -eu`, `set -ue`, `set -euo pipefail`. A failed `cd` exits the
#      shell, and it exits a SUBSHELL too, so `( cd "$pen"; work )` is safe under it.
#   2. `cd "$pen" || <anything>` -- the author named the failure and answered it.
#   3. `cd "$pen" && <work>` -- the work is chained to the arrival, so a failed `cd` skips it.
#
# THE `set -e` READING IS A PROXY AND IS NAMED AS ONE. POSIX suspends `set -e` inside a condition,
# on the left of a `&&` chain, and anywhere a command is followed by `||`, so a `cd` in one of those
# positions is not protected by it. Reading that exactly means tracking shell context rather than
# lines. The proxy is honest in the safe direction for this tree's own shape -- a control's pen `cd`
# stands in a case body rather than in a condition -- and it UNDERCOUNTS, which is written here so
# nobody reads a zero as a proof.
#
# A COMMENT LINE AND A HEREDOC BODY ARE BOTH READ PAST, and the first was learned by first
# residency: this file's own header spells `( cd "$pen"; work )` to teach the rule, and the reading
# counted it as a site. A `#` line is prose; a heredoc body is text a script WRITES rather than
# shell it RUNS, and a control plants exactly that shape on purpose. Skipping the heredoc body
# UNDERCOUNTS a generator that emits an unguarded `cd` -- the emitted file is read on its own once
# it is tracked, which is where the fault would actually run.
#
# A LINE CONTINUATION IS JOINED BEFORE THE READING. This tree writes `( cd "$d" \` with the `&&` on
# the next line, and a line-at-a-time reading calls every one of those unguarded. The reading joins
# a trailing backslash to the line after it first.
#
# THE THREE MUTATION SWITCHES. `JOIN`, `GUARD_AND` and `DERIVE` below each turn one predicate off,
# so tools/fixtures/p/pen_entry_control.sh can flip a single literal and require the reading to
# change. A predicate nobody can break is a predicate nobody has tested.
#
# READINGS: `runners=N pen_sites=N unguarded=N unchecked_mktemp=N`, then `ceiling_ok=yes|no` and a
# `verdict=` line. `unguarded` is a WALL at zero. `unchecked_mktemp` -- an `x=$(mktemp -d)` with no
# `set -e` and no `||` beside it -- is REPORTED, because an empty pen variable is a different fault
# with a different cure, and its population is large enough to want its own lap.
#
# Exit 1 when `unguarded` stands above its ceiling.

set -u

CEILING="${PEN_ENTRY_CEILING:-0}"
list=no
[ "${1:-}" = "--list" ] && list=yes

files=$( { git ls-files -- '*.sh' 2>/dev/null
           git grep -I -n -E '^#!.*[/ ](sh|bash|dash|ksh)$' -- . 2>/dev/null \
             | awk -F: '$2 == 1 { print $1 }'
         } | sort -u | grep -v '^vendor/' | grep -v '^gratitude/' || true )

runners=0
pen_sites=0
unguarded=0
unchecked=0

for f in $files; do
  [ -f "$f" ] || continue
  grep -q 'mktemp -d' "$f" 2>/dev/null || continue
  runners=$((runners + 1))
  out=$(awk -v want="$list" '
    BEGIN { JOIN=1; GUARD_AND=1; DERIVE=1; SKIP=1; sete=0; heredoc="" }
    {
      line = $0
      if (JOIN) {
        while (line ~ /\\$/) {
          sub(/\\$/, "", line)
          if ((getline nxt) > 0) line = line " " nxt; else break
        }
      }

      if (SKIP) {
        # Inside a heredoc body: pass over every line until the tag closes it.
        if (heredoc != "") {
          t = line
          sub(/^[[:space:]]+/, "", t); sub(/[[:space:]]+$/, "", t)
          if (t == heredoc) heredoc = ""
          next
        }
        # A comment line is prose, never a command.
        if (line ~ /^[[:space:]]*#/) next
        # A heredoc opens: remember its tag, quoted or bare.
        if (match(line, /<<-?[[:space:]]*['"'"'"]?[A-Za-z_][A-Za-z_0-9]*['"'"'"]?/)) {
          tag = substr(line, RSTART, RLENGTH)
          gsub(/^<<-?[[:space:]]*|['"'"'"]/, "", tag)
          heredoc = tag
        }
      }

      if (line ~ /^[[:space:]]*set[[:space:]]+-[A-Za-z]*e/) sete = 1

      # A pen variable: assigned from mktemp -d, or from a string naming a pen variable.
      if (match(line, /[A-Za-z_][A-Za-z_0-9]*=/)) {
        name = substr(line, RSTART, RLENGTH - 1)
        rest = substr(line, RSTART + RLENGTH)
        if (rest ~ /mktemp[[:space:]]+-d/) {
          pen[name] = 1
          if (!sete && line !~ /\|\|/) {
            unchecked++
            if (want == "yes") print "unchecked_mktemp\t" FILENAME "\t" FNR "\t" substr(line, 1, 100)
          }
        } else if (DERIVE) {
          for (p in pen)
            if (rest ~ ("[$]" p "([^A-Za-z_0-9]|$)") || rest ~ ("[$][{]" p "[^A-Za-z_0-9]")) pen[name] = 1
        }
      }

      # A cd whose argument names a pen variable.
      if (match(line, /(^|[;&|(}][[:space:]]*|^[[:space:]]*)cd[[:space:]]+/)) {
        arg = substr(line, RSTART + RLENGTH)
        hit = 0
        for (p in pen)
          if (arg ~ ("[$]" p "([^A-Za-z_0-9]|$)") || arg ~ ("[$][{]" p "[^A-Za-z_0-9]")) hit = 1
        if (hit) {
          sites++
          guarded = 0
          if (sete) guarded = 1
          if (line ~ /\|\|/) guarded = 1
          if (GUARD_AND && match(line, /cd[[:space:]]+[^;&|]*&&/)) guarded = 1
          if (!guarded) {
            bad++
            if (want == "yes") print "unguarded\t" FILENAME "\t" FNR "\t" substr(line, 1, 100)
          }
        }
      }
    }
    END { print "COUNT\t" sites + 0 "\t" bad + 0 "\t" unchecked + 0 }
  ' "$f")
  [ "$list" = yes ] && printf '%s\n' "$out" | awk -F'\t' '$1 != "COUNT" { print $1, $2, $3, $4 }'
  counts=$(printf '%s\n' "$out" | awk -F'\t' '$1 == "COUNT" { print $2, $3, $4 }')
  # shellcheck disable=SC2086
  set -- $counts
  pen_sites=$((pen_sites + $1))
  unguarded=$((unguarded + $2))
  unchecked=$((unchecked + $3))
done

echo "runners=$runners"
echo "pen_sites=$pen_sites"
echo "unguarded=$unguarded"
echo "unchecked_mktemp=$unchecked"
echo "ceiling=$CEILING"

if [ "$unguarded" -le "$CEILING" ]; then
  echo "ceiling_ok=yes"
  echo "verdict=guarded"
  exit 0
fi
echo "ceiling_ok=no"
echo "verdict=unguarded"
exit 1
