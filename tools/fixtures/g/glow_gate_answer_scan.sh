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
# THE IDIOM THIS READS, ON BOTH ROADS TO IT. A witness captures a lowered binary either directly,
#     let run_x = run ["sh" "-c" "${bin}; echo EXIT:$?"]
# or by handing the run to the shared harness, which prints the identical tail on its behalf:
#     let run_x = run ["env" "RYE_ZIG=${zig}" "sh" "tools/g/glow_run_worker.sh" desk "600"]
# tools/g/glow_run_worker.sh writes `echo "EXIT:$?"` at both its exits, so either way run_x.out
# always holds `EXIT:<code>`, whatever the binary did or did not say.
#
# THE SECOND ROAD WAS INVISIBLE HERE FOR ELEVEN DAYS. Until 20260908 both the file filter and the
# run-variable pattern keyed on the literal string `echo EXIT:` appearing in the .rish, so a
# delegated run matched neither, and this scan read 35 files while 52 more stood unread -- 38% of
# its own subject. The head above says the surface is DISCOVERED rather than named, and it was:
# discovered by one spelling of the idiom rather than by the fact of the tail. In the unread half
# stand 91 needles of exactly the %310 shape this scan exists to refuse, among them
# tools/au/aurora_wire_a1_gate_bound_witness.rish line 18, which asserts `contains "EXIT:0"` and
# then `contains "0"` on the same run -- the line above it guaranteeing the line below, so that
# wall's refusal side cannot red.
#
# THE TWO HALVES ARE COUNTED APART, for the reason exec_bit keeps its ratchet apart from its two
# gates: the direct half reads zero and a lap can keep it there, while the delegated 91 sit across
# rooms belonging to six other lanes, and a wall that reds on work no single lap can clear is a wall
# somebody turns off. Every direct reading below is byte-identical to what it was before the
# widening -- 35 files, 0 laundered, 152 blind, 0 unread, 7 never-refused -- which the pen asserts
# rather than leaving to be trusted.
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

# THE DELEGATED CEILINGS, measured 20260908 on this tree, falling only. A witness reaches the same
# EXIT tail a second way -- by handing the run to tools/g/glow_run_worker.sh, which prints the
# identical `echo "EXIT:$?"` itself. That surface was invisible here until 20260908 because both
# the file filter and the run-variable pattern keyed on the literal string `echo EXIT:` appearing
# in the .rish, so a delegated run matched neither. It is counted apart from the direct surface
# rather than folded into it, for the reason exec_bit keeps its ratchet apart from its two gates:
# the direct reading holds at zero and a lap can keep it there, while the delegated reading stands
# at 91 across rooms belonging to six other lanes and no single lap can clear it.
delegated_laundered_ceiling=91
delegated_blind_ceiling=150
delegated_never_refused_ceiling=50

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
    # THE EXACT CODE THIS RUN CLAIMS. Remembered per run, so a laundered needle can be told apart
    # from one the run's OWN asserted tail already supplies -- the difference between a needle that
    # could be laundered by some exit code and one that provably is, by the line above it.
    if (needle == "EXIT:0") { clean++; exitcode[target] = "EXIT:0"; next }
    if (needle ~ /^EXIT:[1-9][0-9]*$/) { refuse++; exitcode[target] = needle; next }
    if (laundered(needle)) {
      if (target in exitcode && index(exitcode[target], needle) > 0)
        printf "certified\t%s\t%d\t%s\t%s\n", FILENAME, FNR, target, needle
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
  # BOTH SPELLINGS OF THE ONE IDIOM. A witness reaches the EXIT tail either by printing it itself
  # (`; echo EXIT:$?`) or by handing the run to tools/g/glow_run_worker.sh, which prints exactly the
  # same tail on the witness's behalf. Discovering by the first spelling alone read 35 files and left
  # 52 unread -- 38% of its own subject -- so the offer is made on the FACT of the tail rather than
  # on one way of writing it. The worker is named rather than discovered because it is the only
  # tracked non-.rish file in the tree that prints the tail, and a second one would be a new fact
  # worth a hand's attention rather than a silent widening.
  set -- $(git ls-files '*.rish' 2>/dev/null \
    | xargs grep -l -e 'echo EXIT:' -e 'glow_run_worker' 2>/dev/null | sort -u)
  if [ "$#" -eq 0 ] || [ ! -f "${1:-}" ]; then
    echo "verdict=no_exit_idiom_files"
    echo "refused: no tracked .rish carries the EXIT-tail idiom, and that is the surface this scan reads" >&2
    exit 3
  fi
fi

files=0
dfiles=0
: > "$work/hits.txt"
: > "$work/dhits.txt"
# THE `let` IS NOT ANCHORED TO THE LINE START. tools/g/glow_run.rish writes `if args.len == 2 then
# let gate = run [...]`, and an anchored pattern reads straight past it. Today that costs one file
# on the delegated side and nothing on the direct side, which is a reading rather than a fault --
# it is unanchored here so the next one written that way is seen on the lap it arrives.
for f in "$@"; do
  [ -f "$f" ] || continue
  vars=$(grep -oE 'let[[:space:]]+[a-z_0-9]+[[:space:]]*=[[:space:]]*run[[:space:]]*\[[^]]*echo[[:space:]]+EXIT:' "$f" \
    | sed -E 's/.*let[[:space:]]+([a-z_0-9]+).*/\1/' | sort -u | tr '\n' ' ')
  dvars=$(grep -oE 'let[[:space:]]+[a-z_0-9]+[[:space:]]*=[[:space:]]*run[[:space:]]*\[[^]]*glow_run_worker' "$f" \
    | sed -E 's/.*let[[:space:]]+([a-z_0-9]+).*/\1/' | sort -u | tr '\n' ' ')
  if [ -n "$vars" ]; then
    files=$((files + 1))
    awk -v vars="$vars" -f "$work/read.awk" "$f" >> "$work/hits.txt"
  fi
  if [ -n "$dvars" ]; then
    dfiles=$((dfiles + 1))
    awk -v vars="$dvars" -f "$work/read.awk" "$f" >> "$work/dhits.txt"
  fi
done

count() { c=$(grep -c "^$2	" "$1" 2>/dev/null || true); [ -n "$c" ] || c=0; echo "$c"; }
launder=$(count "$work/hits.txt" launder)
blind=$(count "$work/hits.txt" blind)
unread=$(count "$work/hits.txt" unread)
norefuse=$(count "$work/hits.txt" norefuse)
certified=$(count "$work/hits.txt" certified)
dlaunder=$(count "$work/dhits.txt" launder)
dblind=$(count "$work/dhits.txt" blind)
dunread=$(count "$work/dhits.txt" unread)
dnorefuse=$(count "$work/dhits.txt" norefuse)
dcertified=$(count "$work/dhits.txt" certified)

detail_lines() {
  while IFS='	' read -r kind file line var extra; do
    case "$kind" in
      launder)  echo "detail:$1 $file line $line asserts contains \"$extra\" on $var -- the EXIT tail supplies it, so the wall cannot red" ;;
      blind)    echo "detail:$1 $file line $line run $var carries $extra assertions and reads no spoken answer" ;;
      unread)   echo "detail:$1 $file run $var is captured and never asserted at all" ;;
      norefuse) echo "detail:$1 $file asserts a clean exit $extra times and never proves a refusal" ;;
      certified) echo "detail:$1 $file line $line asserts contains \"$extra\" on $var -- the SAME run asserts that exact tail above, so this needle provably cannot red" ;;
    esac
  done < "$2"
}
detail_lines "" "$work/hits.txt"
detail_lines " delegated" "$work/dhits.txt"

echo "witness_files=$files"
echo "laundered_needles=$launder"
echo "certified_needles=$certified"
echo "answer_blind_runs=$blind"
echo "answer_blind_ceiling=$answer_blind_ceiling"
echo "unread_runs=$unread"
echo "never_refused_files=$norefuse"
echo "never_refused_ceiling=$never_refused_ceiling"
echo "delegated_witness_files=$dfiles"
echo "delegated_laundered_needles=$dlaunder"
echo "delegated_certified_needles=$dcertified"
echo "delegated_laundered_ceiling=$delegated_laundered_ceiling"
echo "delegated_blind_runs=$dblind"
echo "delegated_blind_ceiling=$delegated_blind_ceiling"
echo "delegated_unread_runs=$dunread"
echo "delegated_never_refused_files=$dnorefuse"
echo "delegated_never_refused_ceiling=$delegated_never_refused_ceiling"

# READ NOTHING MEANS NEITHER HALF READ ANYTHING. Keyed on the direct count alone, a run over a
# purely delegated surface refuses here before a single delegated gate can speak -- which is the
# elder blindness wearing a new coat, one line further down.
if [ "$((files + dfiles))" -eq 0 ]; then
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

# THE DELEGATED GATE, at zero, and the three delegated ratchets. `delegated_unread_runs` reads zero
# today and is gated for the same reason its direct twin is: nothing has to be repaired for it to
# hold. The other three are ratchets because their populations sit in six other lanes' rooms, and a
# wall that reds on work no single lap can clear is a wall somebody turns off.
if [ "$dunread" -ne 0 ]; then
  echo "verdict=delegated_run_never_read"
  exit 8
fi
if [ "$dlaunder" -gt "$delegated_laundered_ceiling" ]; then
  echo "verdict=delegated_launder_rose"
  exit 9
fi
if [ "$dblind" -gt "$delegated_blind_ceiling" ]; then
  echo "verdict=delegated_blind_rose"
  exit 10
fi
if [ "$dnorefuse" -gt "$delegated_never_refused_ceiling" ]; then
  echo "verdict=delegated_never_refused_rose"
  exit 11
fi

echo "verdict=every_needle_outlives_the_framing"
exit 0
