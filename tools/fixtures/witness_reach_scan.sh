#!/bin/sh
# tools/fixtures/witness_reach_scan.sh -- which witnesses on disk does a runner actually run?
#
# WHY THIS EXISTS. construction/standing-equipment.kyri opens with the sentence this meter measures:
# "a guard that is never run guards nothing either." The roster names what stands; nothing counted
# what stands OUTSIDE it. active-designing/20260824-080208_the-roster-that-decides-what-gets-measured.md
# booked the question by name and left it open: "whether every witness on disk is reached by
# something ... means tracing reachability rather than comparing counts, which is a round of its own."
# This is that round. It traces reachability.
#
# WHAT IT READS. Every tracked *.rish and *.sh source plus tools/hooks/*, for paths in INVOCATION
# position, and follows them from the roster outward. Four readings come out:
#
#   total     every tracked *_witness.rish on disk
#   standing  reachable from the roster's EVERY-LAP rows, transitively -- sung on every lap
#   cadence   reachable from the roster's CADENCE rows and not from the every-lap ones -- heard on
#             the fifth round, which is a slower promise and so a separate number. Reading the two
#             as one would report 75 crypto witnesses as sung every lap on the strength of a row
#             that runs once in five, which is a truer-SOUNDING number than the one before it.
#   sung      named in an invocation position by any runner on disk, roster or choir
#   unheard   named by no runner at all -- these guard nothing, and this is the gated number
#
# WHAT COUNTS AS AN INVOCATION, and why the distinction is the whole difficulty. A path NAMED is not
# a path RUN. REDS %218 taught the same line one direction over: a citation in a comment is a promise
# rather than a call. Three shapes here look like calls and are not, and each was found in real
# sources on 20260825 while this meter was being written:
#
#   grep -oE '...' tools/cr/crypto_suite_witness.rish     a file read as DATA (crypto_count_guard:73)
#   "**Ran:** `rishi/bin/rishi run ..._witness.rish`"     a string a script PRINTS (the almanac)
#   #   rishi/bin/rishi run tools/x/foo_witness.rish      a comment's usage line, in every witness
#
# So the rule is command position, applied uniformly: a comment line is skipped, a quoted span is
# data, and what remains is split at the shell's own command separators. A `-c` payload is unwrapped
# first and read by the same rule, because `run ["sh" "-c" "rishi run x"]` genuinely calls x while
# `run ["sh" "-c" "grep x"]` genuinely does not. In Rishi, `run ["rishi/bin/rishi" "run" "<path>"]`
# and `run ["sh" "<path>"]` are calls by shape. A choir -- a file handing a VARIABLE to `rishi run`
# and singing a list -- reaches every witness in its `let ... = [ ... ]` literals.
#
# THE HONEST LIMIT, named rather than hidden. An invocation through a variable the meter cannot
# resolve (`rishi/bin/rishi run "$generator"` in tools/hooks/pre-commit) is invisible to it, so
# `unheard` is an UPPER bound on what is truly unrun and every name in it is worth reading before
# it is believed. The meter proves a witness is named by a runner; whether that runner ever runs is
# the reading beside it, `standing`, and only the roster answers that one.
#
# USAGE
#   sh tools/fixtures/witness_reach_scan.sh              # the four readings
#   sh tools/fixtures/witness_reach_scan.sh --list       # the unheard, one per line
#   sh tools/fixtures/witness_reach_scan.sh --sung       # the sung, one per line
#   sh tools/fixtures/witness_reach_scan.sh --standing   # the every-lap set, one per line
#   sh tools/fixtures/witness_reach_scan.sh --cadence    # the every-fifth-lap set, one per line
#   sh tools/fixtures/witness_reach_scan.sh --families   # the unheard, grouped by name prefix
#
# Run from the repository root. WITNESS_REACH_CEILING overrides the ceiling, for the control alone.

set -u

# The ceiling only falls, and it carries no slack. Measured 20260825.132121: 1,692 tracked
# witnesses, 168 sung every lap, 322 heard on the cadence lap, 755 named by some runner on disk,
# and 937 named by nothing at all. Standing read 56 on the morning this meter was written and
# moved to 167 in one roster row, when tools/ca/caravan_suite_witness.rish was seated and carried
# its 111 rungs with it; the cadence column opened at 82 the same way, when
# tools/cr/crypto_suite_witness.rish took the first `tier cadence` row and brought its family with
# it. That choir was itself UNHEARD until that row, which is why unheard fell by exactly one while
# cadence rose by 82: its rungs were already sung, by a choir nothing ran.
#
# Then the largest family moved in one round. tools/al/ales_suite_witness.rish was WRITTEN on
# 20260825.132121 -- Season C's Lotus suite had 239 witnesses on disk and no choir at all -- and
# took the second `tier cadence` row, carrying 240 into cadence and dropping unheard by 239 to 937.
# Its cheap half, tools/al/ales_roster_witness.rish, took a `lap` row and lifted standing by one.
# Lower the ceiling whenever a choir lands or a roster row is added.
CEILING=${WITNESS_REACH_CEILING:-937}

mode="${1:-}"
roster=construction/standing-equipment.kyri

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT INT TERM

git ls-files '*_witness.rish' | sort -u > "$pen/all"
git ls-files '*.rish' '*.sh' 'tools/hooks/*' | sort -u > "$pen/sources"

# One awk pass over every source, emitting "<caller>TAB<callee>" for each invocation it can see.
xargs -a "$pen/sources" awk '
  function emit(p) { if (p ~ /\.(rish|sh)$/) print FILENAME "\t" p }

  # Command position, applied to one stretch of shell text.
  function commands(text,   n, part, i, s, t) {
    gsub(/[;&|(){}`]|\$\(/, "\n", text)
    n = split(text, part, "\n")
    for (i = 1; i <= n; i++) {
      s = part[i]; sub(/^[[:space:]]+/, "", s)
      if (match(s, /^(sh|bash)[[:space:]]+[A-Za-z0-9_.\/-]+\.(sh|rish)/)) {
        t = substr(s, RSTART, RLENGTH); sub(/^[a-z]+[[:space:]]+/, "", t); emit(t)
      }
      if (match(s, /^(rishi\/bin\/)?rishi[[:space:]]+run[[:space:]]+[A-Za-z0-9_.\/-]+\.rish/)) {
        t = substr(s, RSTART, RLENGTH); sub(/.*[[:space:]]/, "", t); emit(t)
      }
    }
  }

  /^[[:space:]]*#/ { next }
  {
    # Rishi calls by shape: run ["rishi/bin/rishi" "run" "<path>"].
    line = $0
    while (match(line, /run \[[[:space:]]*"rishi\/bin\/rishi"[[:space:]]+"run"[[:space:]]+"[^"]+"/)) {
      st = RSTART; ln = RLENGTH
      seg = substr(line, st, ln); sub(/.*"run"[[:space:]]+"/, "", seg); sub(/"$/, "", seg)
      emit(seg); line = substr(line, st + ln)
    }

    # Rishi calls by shape: run ["sh" "<path>"], where the first argument is never a flag.
    line = $0
    while (match(line, /run \[[[:space:]]*"(sh|bash)"[[:space:]]+"[^"-][^"]*"/)) {
      st = RSTART; ln = RLENGTH
      seg = substr(line, st, ln); sub(/^run \[[[:space:]]*"(sh|bash)"[[:space:]]+"/, "", seg); sub(/"$/, "", seg)
      emit(seg); line = substr(line, st + ln)
    }

    # A -c payload is shell text in either language. RSTART and RLENGTH are saved BEFORE the call,
    # because commands() runs match() of its own and would otherwise leave RLENGTH at -1 here --
    # substr(line, -1) returns the whole line, and the loop never advances. Found by hanging.
    line = $0
    while (match(line, /("-c"[[:space:]]+"[^"]*"|-c[[:space:]]+"[^"]*")/)) {
      st = RSTART; ln = RLENGTH
      seg = substr(line, st, ln); sub(/^"?-c"?[[:space:]]+"/, "", seg); sub(/"$/, "", seg)
      commands(seg); line = substr(line, st + ln)
    }

    # What is left once every quoted span is blanked: a quoted span is data, never a command.
    line = $0
    gsub(/"[^"]*"/, " ", line); gsub(/\047[^\047]*\047/, " ", line)
    commands(line)
  }
' > "$pen/e_call" 2>/dev/null

# A choir hands a VARIABLE to `rishi run`, so every witness in its list literals is sung by it.
xargs -a "$pen/sources" grep -lE 'run \[[[:space:]]*"rishi/bin/rishi"[[:space:]]+"run"[[:space:]]+[A-Za-z_]' 2>/dev/null \
  | sort -u > "$pen/choirs"
: > "$pen/e_choir"
while IFS= read -r c; do
  grep -vE '^[[:space:]]*#' "$c" 2>/dev/null | grep -E '^[[:space:]]*let [A-Za-z_]+ = \[' \
    | grep -oE '[A-Za-z0-9_./-]+_witness\.rish' | sort -u | sed "s|^|$c	|" >> "$pen/e_choir"
done < "$pen/choirs"

# The roster's own rows are the runner's calls, read from the roster rather than spelled here --
# and each row's TIER decides which reading it feeds. A record naming no tier means `lap`, which is
# what every row meant before the field existed.
: > "$pen/e_roster"; : > "$pen/roots_lap"; : > "$pen/roots_cadence"
if [ -f "$roster" ]; then
  awk '
    function flush() {
      if (n != "" && p != "") print p "\t" (t == "" ? "lap" : t)
      n = ""; p = ""; t = ""
    }
    $1 == "guard" { flush(); n = $2; next }
    $1 == "path"  { if (n != "") p = $2; next }
    $1 == "tier"  { if (n != "") t = $2; next }
    END { flush() }
  ' "$roster" > "$pen/roster_rows"
  awk -F'\t' -v r="$roster" '{ print r "\t" $1 }' "$pen/roster_rows" > "$pen/e_roster"
  awk -F'\t' '$2 == "lap"     { print $1 }' "$pen/roster_rows" | sort -u > "$pen/roots_lap"
  awk -F'\t' '$2 == "cadence" { print $1 }' "$pen/roster_rows" | sort -u > "$pen/roots_cadence"
fi

cat "$pen/e_call" "$pen/e_choir" "$pen/e_roster" | sort -u > "$pen/edges"

cut -f2 "$pen/edges" | sort -u > "$pen/invoked"
comm -12 "$pen/all" "$pen/invoked" > "$pen/sung"
comm -23 "$pen/all" "$pen/invoked" > "$pen/unheard"

# Reachability, from whichever roots a reading starts at. One walk, called twice, so the two
# readings can never drift apart by being written twice.
closure() {  # closure <roots-file> <out-file>
  sort -u "$1" > "$pen/f"
  cp "$pen/f" "$pen/s"
  while [ -s "$pen/f" ]; do
    awk -F'\t' 'NR == FNR { f[$1] = 1; next } ($1 in f) { print $2 }' "$pen/f" "$pen/edges" \
      | sort -u > "$pen/n"
    comm -23 "$pen/n" "$pen/s" > "$pen/f"
    cat "$pen/f" >> "$pen/s"
    sort -u "$pen/s" -o "$pen/s"
  done
  cp "$pen/s" "$2"
}

# Standing: what the every-lap tier and the hooks reach, which is what actually runs each lap.
{ cat "$pen/roots_lap"; git ls-files 'tools/hooks/*'; } | sort -u > "$pen/frontier_lap"
closure "$pen/frontier_lap" "$pen/seen_lap"
comm -12 "$pen/all" "$pen/seen_lap" > "$pen/standing"

# Cadence: what the slower tier reaches and the every-lap tier does not already carry.
closure "$pen/roots_cadence" "$pen/seen_cadence"
comm -12 "$pen/all" "$pen/seen_cadence" > "$pen/cadence_all"
comm -23 "$pen/cadence_all" "$pen/standing" > "$pen/cadence"

total=$(wc -l < "$pen/all" | tr -d ' ')
standing=$(wc -l < "$pen/standing" | tr -d ' ')
cadence=$(wc -l < "$pen/cadence" | tr -d ' ')
sung=$(wc -l < "$pen/sung" | tr -d ' ')
unheard=$(wc -l < "$pen/unheard" | tr -d ' ')

case "$mode" in
  --list)     sed 's/^/unheard /' "$pen/unheard" ;;
  --sung)     sed 's/^/sung /' "$pen/sung" ;;
  --standing) sed 's/^/standing /' "$pen/standing" ;;
  --cadence)  sed 's/^/cadence /' "$pen/cadence" ;;
  --families) sed -E 's|^tools/[^/]+/||; s|^.*/||' "$pen/unheard" | cut -d_ -f1 \
                | sort | uniq -c | sort -rn | head -20 ;;
esac

if [ "$unheard" -le "$CEILING" ]; then under=yes; else under=no; fi
echo "WITNESS_REACH total=$total standing=$standing cadence=$cadence sung=$sung unheard=$unheard ceiling=$CEILING under_ceiling=$under"
