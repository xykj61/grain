#!/bin/sh
# tools/fixtures/p/pen_release_scan.sh -- a runner that makes a throwaway pen and never removes it
# leaks it into a pier eight ships share.
#
#   sh tools/fixtures/p/pen_release_scan.sh [--list] [--standing]
#
# WHY. REDS %745: tools/am/amphora_mark_wreck_witness.rish makes a 24MB pen with
# `mktemp -d /tmp/amphora_mark_wreck.XXXXXX` and never removes it. Nine days of a rostered witness
# put 1,312 pens and 32G into /tmp, the pier read 990M free, and the first instrument to notice was
# a `pwd` builtin answering `write error: No space left on device`. Each run costs 24MB, which is
# nothing; the leaker never feels it, and the cost lands on whichever ship needs space next.
#
# THE THIRD QUESTION ABOUT ONE PEN. `shared_pen` asks whether a pen is CONTENDED -- one constant
# name, eight checkouts. `pen_entry` asks whether a pen is ENTERED -- REDS %729, a case body that
# ran at the repository root. Neither asks whether it is RELEASED, and a pen is one object with
# three failure modes.
#
# AND THE TWO STANDING GUARDS READ ONE LANGUAGE. `pen_entry`'s population is `git ls-files '*.sh'`
# plus files whose first line is a POSIX shell shebang. `amphora_mark_wreck_witness.rish` is
# neither: Rishi carries no shebang in this tree, so the runner that actually filled the pier stood
# outside the pen family's whole population. This reading opens BOTH -- 449 shell runners and 2,496
# Rishi sources -- because the language a pen is made in says nothing about whether it is swept.
#
# WHAT IS COUNTED, in two classes, because they want two different cures.
#
#   never_removed -- a runner names a pen variable from `mktemp -d` and no line anywhere in the
#     file removes it. This is a certain leak on every run, success or failure. GATED under a
#     ceiling that only falls.
#
#   unreleased_on_refusal -- the removal exists and stands on the straight-line success path, so a
#     refusal above it leaves the pen behind. In shell the cure is `trap 'rm -rf "$pen"' EXIT`,
#     which every control in tools/fixtures/ already carries. REPORTED, never gated: this
#     population is large, its cure differs by language, and a gate that reds on ordinary work is
#     a gate somebody turns off.
#
#   runtime_pens -- a Rishi source whose pen comes from `make-pen`, the builtin seated
#     `20260916.010000` under REDS %745. This one is counted apart and enters NEITHER class above,
#     because the runtime releases it after a return, a refusal, an `exit`, HUP, INT and TERM, and
#     `tools/r/rishi_make_pen_witness.rish` proves all four paths on metal. THE ELDER HEADER SAID
#     RISHI HAS NO TRAP AT ALL, and that was already false when it was written: the runtime has
#     carried a CleanupRegistry since `acquire-lock`, and what it lacked was a pen kind. So the
#     second class is a shell question now, and a Rishi source in it is a source awaiting one
#     line.
#
#   THE TWO POPULATIONS ARE DISJOINT BY CONSTRUCTION. A file is read for `mktemp -d` pens and,
#     separately, for `make-pen` pens; converting a file moves it from one reading to the other
#     rather than out of the census. A count that fell because a file left the population would
#     read exactly like a repair, which is the shape this scan exists to refuse.
#
# WHAT COUNTS AS A REMOVAL. A line naming `rm` with `-r` in its flags whose argument names one of
# that file's pen variables -- `rm -rf "$pen"`, `rm -rf ${pen}`, and Rishi's
# `run ["sh" "-c" "rm -rf ${pen}"]` alike. A removal inside a `trap ... EXIT` is RELEASED; a
# removal anywhere else is straight-line.
#
# A PEN VARIABLE is one assigned from `mktemp -d`, or derived from a string naming an existing pen
# variable -- the same collection `pen_entry` makes, and for the same reason: `d="$pen/t"` is the
# pen too. Rishi's `let pen = trim pen_made.out` beside `run [... "mktemp -d ..."]` is read as the
# same shape, since that is how every Rishi witness in this tree spells it.
#
# A COMMENT LINE AND A HEREDOC BODY ARE READ PAST. This file's own header spells `mktemp -d` and
# `rm -rf "$pen"` to teach the rule, and a reading that counted its own prose would count itself --
# which is the fault `pen_entry` booked by first residency. A heredoc body is text a script WRITES
# rather than shell it RUNS; the emitted file is read on its own once tracked.
#
# --standing READS THE PIER ITSELF, and is a separate question deliberately kept separate. It
# counts directories under the shared temporary root whose basename prefix matches a pen name this
# tree's own runners write, so a reader can see what the counted classes have actually left behind.
# It is REPORTED and gates nothing, and it reads NO free space: whether the fleet should read its
# own free space is named in %745 as Keaton's word, and this stays on our own litter.
#
# THE THREE MUTATION SWITCHES. `JOIN`, `DERIVE` and `TRAP` each turn one predicate off, so
# tools/fixtures/p/pen_release_control.sh can flip a single literal and require the reading to
# change. A predicate nobody can break is a predicate nobody has tested.
#
# WHAT IT DOES NOT REACH. Whether a straight-line removal is ever actually reached -- that is
# control flow rather than a scan, and it is why the second class is reported. A pen removed by a
# helper the runner calls reads as never_removed, which OVERCOUNTS in the safe direction and is
# written here so nobody reads a number as a proof. And a pen made without `mktemp -d` at all is
# `shared_pen`'s subject rather than this one's.
#
# READINGS: `runners=N rish_runners=N pen_files=N runtime_pens=N never_removed=N
# unreleased_on_refusal=N`, then `ceiling_ok=yes|no` and a `verdict=` line. Exit 1 when
# `never_removed` stands above its ceiling.

set -u

# 16 at seating `20260915.230045`; 14 when the runtime took two, 9 from `20260916.012247` when the
# eight `tools/am/` witnesses REDS %745 names each took a root sweep. A ceiling only falls.
CEILING="${PEN_RELEASE_CEILING:-9}"
list=no
standing=no
for a in "$@"; do
  [ "$a" = "--list" ] && list=yes
  [ "$a" = "--standing" ] && standing=yes
done

shell_files=$( { git ls-files -- '*.sh' 2>/dev/null
                 git grep -I -n -E '^#!.*[/ ](sh|bash|dash|ksh)$' -- . 2>/dev/null \
                   | awk -F: '$2 == 1 { print $1 }'
               } | sort -u | grep -v '^vendor/' | grep -v '^gratitude/' || true )
rish_files=$( git ls-files -- '*.rish' 2>/dev/null | grep -v '^vendor/' | grep -v '^gratitude/' || true )

# ONE `git grep -l` NARROWS BOTH POPULATIONS BEFORE ANY FILE IS OPENED. The reading only ever
# concerns a file naming `mktemp -d`, and opening 2,957 sources one at a time to ask cost 48
# seconds against under four. The per-file `grep -q` below stays as the exact test, since this
# prefilter is a superset by construction.
# NO PATHSPEC. The shell population includes files found by their shebang rather than by a `.sh`
# name, so narrowing the prefilter to two extensions dropped one of them -- 461 runners read 460.
carriers=$( git grep -l -E 'mktemp[[:space:]]*-d' 2>/dev/null | sort -u || true )
narrow() { # narrow <newline-separated paths> -- keep only those the prefilter named
  printf '%s\n' "$1" | sort -u | comm -12 - "$pre" 2>/dev/null
}
pre=$(mktemp) || { echo "refused: prefilter file absent"; echo "verdict=no_pen"; exit 1; }
trap 'rm -f "$pre"' EXIT INT TERM
printf '%s\n' "$carriers" | sort -u > "$pre"
# The UNNARROWED lists are kept, because the standing half below reads a second pen spelling that
# names no `mktemp` at all -- narrowing its source would have made it structurally unable to find
# the `${TMPDIR:-/tmp}/<name>` pens its own header promises, which is what first residency caught:
# the standing count read 627 before the prefilter and 309 after, for no change on the pier.
all_shell_files="$shell_files"
all_rish_files="$rish_files"
shell_files=$(narrow "$shell_files")
rish_files=$(narrow "$rish_files")

runners=0
rish_runners=0
pen_files=0
runtime=0
never=0
straight=0

# ONE RULE FOR PROSE, AT BOTH DEPTHS. The per-line reading below passes over a comment, so the
# coarse per-file test does too -- otherwise a source whose only `mktemp -d` stands in a sentence
# explaining why it no longer makes one is counted as a runner carrying no pen. That is exactly the
# fault `pen_entry` booked by first residency, one level up from where it booked it: the two
# converted tally witnesses named the elder spelling in their own repair comment and inflated
# `rish_runners` by two while `pen_files` correctly fell.
carries_pen() {
  awk '/^[[:space:]]*#/ { next } /mktemp[[:space:]]*-d/ { found = 1 } END { exit !found }' "$1"
}

read_one() {
  awk -v want="$list" '
    BEGIN { JOIN=1; DERIVE=1; TRAP=1; heredoc=""; made=0; removed=0; trapped=0 }
    {
      line = $0
      if (JOIN) {
        while (line ~ /\\$/) {
          sub(/\\$/, "", line)
          if ((getline nxt) > 0) line = line " " nxt; else break
        }
      }

      # Inside a heredoc body: pass over every line until the tag closes it.
      if (heredoc != "") {
        t = line
        sub(/^[[:space:]]+/, "", t); sub(/[[:space:]]+$/, "", t)
        if (t == heredoc) heredoc = ""
        next
      }
      # A comment line is prose, never a command -- in both languages.
      if (line ~ /^[[:space:]]*#/) next
      if (match(line, /<<-?[[:space:]]*['"'"'"]?[A-Za-z_][A-Za-z_0-9]*['"'"'"]?/)) {
        tag = substr(line, RSTART, RLENGTH)
        gsub(/^<<-?[[:space:]]*|['"'"'"]/, "", tag)
        heredoc = tag
      }

      # A pen variable: assigned from mktemp -d anywhere on the line, or derived from one that is.
      # EVERY assignment on the line is read rather than the first, because this tree writes a
      # whole pen lifetime inside one `sh -c` string -- `d=$(mktemp -d); ...; rm -rf $d` -- and a
      # reading that took the outer `let blind =` alone called two honest witnesses leaks.
      rest = line
      while (match(rest, /[A-Za-z_][A-Za-z_0-9]*[[:space:]]*=/)) {
        name = substr(rest, RSTART, RLENGTH)
        sub(/[[:space:]]*=$/, "", name)
        tail = substr(rest, RSTART + RLENGTH)
        head = tail
        sub(/;.*$/, "", head)
        if (head ~ /mktemp[[:space:]]+-d/) { pen[name] = 1; made = 1 }
        else if (DERIVE) {
          for (p in pen)
            if (head ~ ("[$]" p "([^A-Za-z_0-9]|$)") || head ~ ("[$][{]" p "[^A-Za-z_0-9]") \
                || head ~ ("(^|[^A-Za-z_0-9])" p "\\.out")) pen[name] = 1
        }
        rest = tail
      }

      # A removal whose argument names a pen variable.
      # A removal: `rm -r` or `rmdir`. arbor/author.sh sweeps its pen with
      # `trap '"'"'rm -f ...; rmdir "$temp_dir"'"'"' EXIT`, which is a release and reads as one.
      if (line ~ /(^|[^A-Za-z_0-9])rm[[:space:]]+-[A-Za-z]*r/ || line ~ /(^|[^A-Za-z_0-9])rmdir[[:space:]]/) {
        for (p in pen)
          if (line ~ ("[$]" p "([^A-Za-z_0-9]|$)") || line ~ ("[$][{]" p "[^A-Za-z_0-9]")) {
            removed = 1
            if (TRAP && line ~ /(^|[^A-Za-z_0-9])trap[[:space:]]/ && line ~ /EXIT/) trapped = 1
            if (want == "yes" && !trapped) print "straight\t" FILENAME "\t" FNR "\t" substr(line, 1, 90)
          }
      }
    }
    END {
      if (!made) { print "COUNT\t0\t0\t0"; exit }
      if (!removed) print "COUNT\t1\t1\t0"
      else if (!trapped) print "COUNT\t1\t0\t1"
      else print "COUNT\t1\t0\t0"
    }
  ' "$1"
}

for f in $shell_files; do
  [ -f "$f" ] || continue
  carries_pen "$f" || continue
  runners=$((runners + 1))
  out=$(read_one "$f")
  [ "$list" = yes ] && printf '%s\n' "$out" | awk -F'\t' '$1 != "COUNT" { print $1, $2, $3, $4 }'
  counts=$(printf '%s\n' "$out" | awk -F'\t' '$1 == "COUNT" { print $2, $3, $4 }')
  # shellcheck disable=SC2086
  set -- $counts
  pen_files=$((pen_files + $1)); never=$((never + $2)); straight=$((straight + $3))
  if [ "$list" = yes ] && [ "$2" -gt 0 ]; then echo "never_removed $f"; fi
done

for f in $rish_files; do
  [ -f "$f" ] || continue
  carries_pen "$f" || continue
  rish_runners=$((rish_runners + 1))
  out=$(read_one "$f")
  [ "$list" = yes ] && printf '%s\n' "$out" | awk -F'\t' '$1 != "COUNT" { print $1, $2, $3, $4 }'
  counts=$(printf '%s\n' "$out" | awk -F'\t' '$1 == "COUNT" { print $2, $3, $4 }')
  # shellcheck disable=SC2086
  set -- $counts
  pen_files=$((pen_files + $1)); never=$((never + $2)); straight=$((straight + $3))
  if [ "$list" = yes ] && [ "$2" -gt 0 ]; then echo "never_removed $f"; fi
done

# THE RUNTIME-OWNED PEN, read on its own -- and read as a CALL rather than as the word. A comment
# is skipped exactly as above, and that was not enough: `tools/r/rishi_make_pen_witness.rish` names
# `make-pen` inside two `assert ... else` MESSAGES, so prose inside a string literal counted its
# file as a carrier. That is `%753` one depth further down, found by first residency the same way.
# A call is always bound -- `let pen = make-pen "label"` -- since the builtin returns a value, so
# the equals sign ahead of it is what tells a call from a mention. WHAT THIS DOES NOT REACH: a
# string literal that happens to spell `= make-pen ` inside it, which no source here writes and
# which would OVERCOUNT in the safe direction.
for f in $all_rish_files; do
  [ -f "$f" ] || continue
  hit=$(awk '/^[[:space:]]*#/ { next } /=[[:space:]]*make-pen[[:space:]]/ { found = 1 } END { print found + 0 }' "$f")
  [ "$hit" = 1 ] || continue
  runtime=$((runtime + 1))
  [ "$list" = yes ] && echo "runtime_pen $f"
done

echo "runners=$runners"
echo "rish_runners=$rish_runners"
echo "pen_files=$pen_files"
echo "runtime_pens=$runtime"
echo "never_removed=$never"
echo "unreleased_on_refusal=$straight"

if [ "$standing" = yes ]; then
  root="${TMPDIR:-/tmp}"
  # The standing half reads the PIER rather than the class, so it collects pen names in both
  # spellings -- `mktemp -d /tmp/<name>.XXXXXX` and a `${TMPDIR:-/tmp}/<name>` literal. The second
  # is `shared_pen`'s subject and stands outside the gated classes above by construction, and it is
  # where the pier's largest single litter actually lives: tools/fixtures/t/tlb_reach_census.sh
  # writes `${TMPDIR:-/tmp}/tlb_reach_census_pen.$$`, which left 253 directories standing when this
  # reading was written. A standing half blind to it would report our litter and miss its biggest
  # pile.
  names=$( { for f in $all_shell_files $all_rish_files; do
               [ -f "$f" ] || continue
               grep -h -o 'mktemp[[:space:]]*-d[[:space:]]*["]*[^"$ ]*' "$f" 2>/dev/null
               grep -h -o '[$]{TMPDIR:-/tmp}/[A-Za-z_][A-Za-z_0-9.-]*' "$f" 2>/dev/null
             done
             # Every runtime-owned pen wears one basename prefix, so the pier half asks after it
             # by name. A release proven on metal still leaves the question of what STANDS, and a
             # standing `rishi-pen-` directory is a run that died past every path the runtime owns.
             echo "rishi-pen-"
           } | sed -E 's|.*/||; s/\.?X+$//; s/\.$//' | grep -E '^[A-Za-z_][A-Za-z_0-9.-]+$' | sort -u )
  total=0
  for n in $names; do
    c=$(find "$root" -maxdepth 1 -name "$n*" 2>/dev/null | wc -l)
    [ "$c" -gt 0 ] && echo "standing_pen $n $c"
    total=$((total + c))
  done
  echo "standing_pens=$total"
  echo "standing_root=$root"
fi

echo "ceiling=$CEILING"
if [ "$never" -le "$CEILING" ]; then
  echo "ceiling_ok=yes"
  echo "verdict=released"
  exit 0
fi
echo "ceiling_ok=no"
echo "verdict=leaking"
exit 1
