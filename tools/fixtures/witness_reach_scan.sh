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
#   standing  reachable from construction/standing-equipment.kyri, transitively -- sung EVERY lap
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
#   sh tools/fixtures/witness_reach_scan.sh --families   # the unheard, grouped by name prefix
#
# Run from the repository root. WITNESS_REACH_CEILING overrides the ceiling, for the control alone.

set -u

# The ceiling only falls, and it carries no slack. Measured 20260825.092953 on the staged tree:
# 1,690 tracked witnesses, 167 sung every lap by the roster, 513 named by some runner on disk, and
# 1,177 named by nothing at all. Standing read 56 an hour earlier and moved to 167 in one roster
# row, when tools/ca/caravan_suite_witness.rish was seated and carried its 111 rungs with it.
# Lower the ceiling whenever a choir lands or a roster row is added.
CEILING=${WITNESS_REACH_CEILING:-1177}

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

# The roster's own rows are the runner's calls, read from the roster rather than spelled here.
: > "$pen/e_roster"
[ -f "$roster" ] && awk -v r="$roster" '$1 == "path" && NF == 2 { print r "\t" $2 }' "$roster" > "$pen/e_roster"

cat "$pen/e_call" "$pen/e_choir" "$pen/e_roster" | sort -u > "$pen/edges"

cut -f2 "$pen/edges" | sort -u > "$pen/invoked"
comm -12 "$pen/all" "$pen/invoked" > "$pen/sung"
comm -23 "$pen/all" "$pen/invoked" > "$pen/unheard"

# Standing: the transitive closure from the roster and the hooks, which are what actually run.
{ echo "$roster"; git ls-files 'tools/hooks/*'; } | sort -u > "$pen/frontier"
cp "$pen/frontier" "$pen/seen"
while [ -s "$pen/frontier" ]; do
  awk -F'\t' 'NR == FNR { f[$1] = 1; next } ($1 in f) { print $2 }' "$pen/frontier" "$pen/edges" \
    | sort -u > "$pen/next"
  comm -23 "$pen/next" "$pen/seen" > "$pen/frontier"
  cat "$pen/frontier" >> "$pen/seen"
  sort -u "$pen/seen" -o "$pen/seen"
done
comm -12 "$pen/all" "$pen/seen" > "$pen/standing"

total=$(wc -l < "$pen/all" | tr -d ' ')
standing=$(wc -l < "$pen/standing" | tr -d ' ')
sung=$(wc -l < "$pen/sung" | tr -d ' ')
unheard=$(wc -l < "$pen/unheard" | tr -d ' ')

case "$mode" in
  --list)     sed 's/^/unheard /' "$pen/unheard" ;;
  --sung)     sed 's/^/sung /' "$pen/sung" ;;
  --standing) sed 's/^/standing /' "$pen/standing" ;;
  --families) sed -E 's|^tools/[^/]+/||; s|^.*/||' "$pen/unheard" | cut -d_ -f1 \
                | sort | uniq -c | sort -rn | head -20 ;;
esac

if [ "$unheard" -le "$CEILING" ]; then under=yes; else under=no; fi
echo "WITNESS_REACH total=$total standing=$standing sung=$sung unheard=$unheard ceiling=$CEILING under_ceiling=$under"
