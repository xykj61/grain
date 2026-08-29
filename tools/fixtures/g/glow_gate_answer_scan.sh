#!/bin/sh
# tools/fixtures/g/glow_gate_answer_scan.sh -- a witness that runs a lowered binary must read what the
# binary answered, rather than only the exit tail the harness itself printed.
#
# WHY. On 20260828 REDS %310 found three sites in glow/lower_shop_gate.rye emitting an argv plant
# whose main computed its expected value from the SAME expression as the gate body, so the plant
# returned 0 for every input and spoke nothing. `gate-caravan-caps-pair-bound-u32 9 8` -- a count
# past its cap -- exited clean and silent. Above it a witness asserted `contains "0"` against output
# whose tail was `EXIT:0`, and Rishi `contains` is a plain substring test, so the harness's own
# framing satisfied the assertion before the binary opened its mouth. The gate proved itself against
# its own copy. Sound's language custody repaired the emitters; this is the meter over the witness
# surface -- the half REDS %310 left parked and named for Silence.
#
# THE IDIOM THIS READS. A witness captures a lowered binary as
#     let run_x = run ["sh" "-c" "${bin}; echo EXIT:$?"]
# so run_x.out always holds `EXIT:<code>`, whatever the binary did or did not say.
#
# WHAT IS GATED, hard, at zero. A `contains` needle on such a run that the framing ALONE satisfies:
# `contains "0"`, `contains "1"`, `contains "EXIT"`, `contains "EXIT:"`, `contains ":"`. Each is true
# of `EXIT:0` unconditionally, so the wall cannot red. This is the literal %310 shape, and after the
# one standing hit is repaired it reads zero, which is why it is a gate rather than a ratchet:
# nothing further has to be fixed for it to hold, and it makes the fault unwritable from here on.
#
# WHAT PASSES FREE, and why each is honest.
#   contains "EXIT:0"                       the exit code IS the claim -- welcome exits clean
#   contains "EXIT:1"                       the refusal side, read exactly
#   (run_x.out contains "EXIT:0") == false  the same refusal, spelled by negation
#   contains "gardens_lawful 1"             the spoken answer, which is the shape %310 landed on
# An exit-code wall is a true wall. What it is not is an ANSWER, and the ratchets count that
# difference rather than forbidding it.
#
# THE THREE RATCHETS, reported under ceilings that only fall.
#   answer_blind_runs    a run whose every assertion reads the framing -- .ok, .status, an exact
#                        EXIT:<code>. It proves the program launched and exited with a code, and
#                        reads nothing the program said. Some are legitimately answer-free, since a
#                        lowered plant may print nothing by design, so this is a reading rather than
#                        a refusal.
#   unread_runs          a run captured and never asserted at all -- it ran, and nobody looked.
#   never_refused_files  a file asserting a clean exit on one or more runs and never once, by any of
#                        the three forms above, a refusal. Its walls stand proven in the passing
#                        direction only, and a guard proven only in the passing direction cannot be
#                        told from a bypass.
#
# WHAT THIS DOES NOT REACH, said plainly rather than left to be discovered. Whether an asserted
# answer is the RIGHT answer -- that is the placard's job and a reader's. Whether a witness proves
# the LOWERING refuses (`SampleDoesNotNest` in a selftest) is a different and real proof, and this
# scan reads only the lowered BINARY's own runs, so a file may prove its compiler refuses and still
# stand in never_refused_files. And needle satisfaction is a substring fact rather than a
# comprehension: it reads whether the framing supplies the needle, never whether the author meant it.
#
# USAGE
#   sh tools/fixtures/g/glow_gate_answer_scan.sh                # the real tracked .rish surface
#   sh tools/fixtures/g/glow_gate_answer_scan.sh report <file>  # one planted file, for the pen
#
# Driven by tools/g/glow_gate_answer_witness.rish. Run from the repository root.

set -u

# THE CEILINGS, measured 20260828 on this tree and falling only. They live here rather than in the
# witness so the number has one home, and the pen reads them off this scan's own output rather than
# spelling them again -- removing one makes the pen refuse rather than guess.
answer_blind_ceiling=152
never_refused_ceiling=7

mode=${1:-tree}

if [ ! -f construction/ITINERARY.md ]; then
  echo "verdict=not_at_root"
  echo "refused: construction/ITINERARY.md is missing, so this is not the tree this scan reads" >&2
  exit 1
fi

work=$(mktemp -d) || exit 1
trap 'rm -rf "$work"' EXIT

cat > "$work/read.awk" <<'AWK'
# Classify every assertion naming an EXIT-tail run variable, for one file.
#   framing -- .ok / .status, an exact EXIT:<code>, or a negated EXIT:<code>
#   launder -- a contains needle the framing "EXIT:<digit>" already supplies
#   answer  -- anything else: it reads what the program said
BEGIN {
  n = split(vars, v, " ")
  for (i = 1; i <= n; i++) if (v[i] != "") isrun[v[i]] = 1
}

function laundered(needle,   d, framing) {
  if (needle == "") return 0
  if (needle ~ /^EXIT:[0-9]+$/) return 0          # there the exit code IS the claim
  for (d = 0; d <= 9; d++) {
    framing = "EXIT:" d
    if (index(framing, needle) > 0) return 1
  }
  return 0
}

$0 ~ /^[ \t]*assert[ \t]/ {
  target = ""
  s = $0
  while (match(s, /[a-z_0-9]+\./)) {
    cand = substr(s, RSTART, RLENGTH - 1)
    if (cand in isrun) { target = cand; break }
    s = substr(s, RSTART + RLENGTH)
  }
  if (target == "") next

  if (!(target in asserts)) { asserts[target] = 0; answers[target] = 0; line_of[target] = FNR }
  asserts[target]++

  if ($0 ~ /\)[ \t]*==[ \t]*false/ && $0 ~ /contains[ \t]+"EXIT:[0-9]+"/) { refuse++; next }
  if ($0 ~ /^[ \t]*assert[ \t]+[a-z_0-9]+\.(ok|status)([ \t]|$)/) next

  if (match($0, /contains[ \t]+"[^"]*"/)) {
    needle = substr($0, RSTART, RLENGTH)
    sub(/^contains[ \t]+"/, "", needle)
    sub(/"$/, "", needle)
    if (needle == "EXIT:0") { clean++; next }
    if (needle ~ /^EXIT:[1-9][0-9]*$/) { refuse++; next }
    if (laundered(needle)) {
      printf "launder\t%s\t%d\t%s\t%s\n", FILENAME, FNR, target, needle
      next
    }
    answers[target]++
    next
  }
  answers[target]++
}

END {
  for (t in asserts)
    if (answers[t] == 0) printf "blind\t%s\t%d\t%s\t%d\n", FILENAME, line_of[t], t, asserts[t]
  for (t in isrun)
    if (!(t in asserts)) printf "unread\t%s\t0\t%s\t0\n", FILENAME, t
  if (clean > 0 && refuse == 0) printf "norefuse\t%s\t0\t-\t%d\n", FILENAME, clean
}
AWK

if [ "$mode" = report ]; then
  # One planted file or many, so the pen can prove a file-counted ceiling from both sides without
  # an override. A wall with a door beside it is a habit again.
  shift
  if [ "$#" -eq 0 ] || [ ! -f "$1" ]; then
    echo "verdict=no_such_file"
    echo "refused: ${1:-<none>} is the witness file this scan reads, and it is absent" >&2
    exit 1
  fi
else
  # DISCOVERED RATHER THAN NAMED. A roster typed by hand grows when somebody remembers (REDS %277).
  # Every tracked .rish is offered; only those carrying the EXIT idiom are read, so the surface
  # follows the tree rather than a list.
  set -- $(git ls-files '*.rish' 2>/dev/null | xargs grep -l 'echo EXIT:' 2>/dev/null)
  if [ "$#" -eq 0 ] || [ ! -f "${1:-}" ]; then
    echo "verdict=no_exit_idiom_files"
    echo "refused: no tracked .rish carries the EXIT-tail idiom, and that is the surface this scan reads" >&2
    exit 3
  fi
fi

files=0
: > "$work/hits.txt"
for f in "$@"; do
  [ -f "$f" ] || continue
  vars=$(grep -oE '^[[:space:]]*let[[:space:]]+[a-z_0-9]+[[:space:]]*=[[:space:]]*run[[:space:]]*\[.*echo[[:space:]]+EXIT:' "$f" \
    | sed -E 's/^[[:space:]]*let[[:space:]]+([a-z_0-9]+).*/\1/' | sort -u | tr '\n' ' ')
  [ -n "$vars" ] || continue
  files=$((files + 1))
  awk -v vars="$vars" -f "$work/read.awk" "$f" >> "$work/hits.txt"
done

count() { c=$(grep -c "^$1	" "$work/hits.txt" 2>/dev/null || true); [ -n "$c" ] || c=0; echo "$c"; }
launder=$(count launder)
blind=$(count blind)
unread=$(count unread)
norefuse=$(count norefuse)

while IFS='	' read -r kind file line var extra; do
  case "$kind" in
    launder)  echo "detail: $file line $line asserts contains \"$extra\" on $var -- the EXIT tail supplies it, so the wall cannot red" ;;
    blind)    echo "detail: $file line $line run $var carries $extra assertions and reads no spoken answer" ;;
    unread)   echo "detail: $file run $var is captured and never asserted at all" ;;
    norefuse) echo "detail: $file asserts a clean exit $extra times and never proves a refusal" ;;
  esac
done < "$work/hits.txt"

echo "witness_files=$files"
echo "laundered_needles=$launder"
echo "answer_blind_runs=$blind"
echo "answer_blind_ceiling=$answer_blind_ceiling"
echo "unread_runs=$unread"
echo "never_refused_files=$norefuse"
echo "never_refused_ceiling=$never_refused_ceiling"

if [ "$files" -eq 0 ]; then
  echo "verdict=no_exit_idiom_files"
  echo "refused: no witness file was read, so this run measured nothing" >&2
  exit 3
fi

# THE TWO GATES, at zero. Both read zero once the one standing hit is repaired, so neither asks for
# a sweep before it can hold.
if [ "$launder" -ne 0 ]; then
  echo "verdict=framing_satisfies_needle"
  exit 4
fi
if [ "$unread" -ne 0 ]; then
  echo "verdict=run_never_read"
  exit 5
fi

# THE TWO RATCHETS, under ceilings that only fall.
if [ "$blind" -gt "$answer_blind_ceiling" ]; then
  echo "verdict=answer_blind_rose"
  exit 6
fi
if [ "$norefuse" -gt "$never_refused_ceiling" ]; then
  echo "verdict=never_refused_rose"
  exit 7
fi

echo "verdict=every_needle_outlives_the_framing"
exit 0
