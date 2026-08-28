#!/bin/sh
# tools/fixtures/glow_gate_answer_scan.sh -- does a Glow gate wall read what the gate answered?
#
# WHAT THIS IS FOR. A Glow gate is a tiny program that answers 1 or 0 -- within the cap, past the
# cap. A witness proves the wall by running the gate on both sides and reading the answer. This
# scan asks whether the reading is real, because two shapes in this tree look like a reading and
# are not.
#
# READING ONE -- indistinct_refusals. GATED, under a ceiling that only falls.
# tools/g/glow_run_worker.sh prints the gate's answer and then appends its own line, `EXIT:0`.
# Rishi's `contains` is a plain substring test (rishi/src/main.rye eval_expr). So
# `assert over.out contains "0"` is satisfied by the exit line by itself, on every successful run,
# whatever the gate said. Measured on metal 20260828: an ACCEPT run of
# src/gate/gate-caravan-caps-bound-u32.glow prints `1\nEXIT:0\n`, and that output satisfies the
# refusal assertion. The refusal half of such a wall cannot fail, so it proves nothing.
#
# THE REPAIRED FORM, and why it is exact. `assert (over.out contains "1") == false` -- the accept
# answer is the only "1" a 0/1 gate run can produce, since `EXIT:0` carries none. Proven both ways
# in Rishi's existing grammar; no new tooling and no second build.
#
# READING TWO -- silent_pair_gates. REPORTED, never gated.
# A desk whose body is a two-face cond -- `|=  [count=@u32 cap=@u32]` -- lowers through the
# `.cond_*_faces` arm of glow/lower_shop_gate.rye, which at its lines 1442 and 1449 emits the gate
# body and the `expect` it is compared against from the SAME format arguments. The generated main
# is `return if (bartis_pair(a, b) == expect) 0 else 1`, so it compares the gate to a textual copy
# of itself, returns 0 for every input, and prints no answer at all. Proven on metal 20260828: a
# planted gate with its arms swapped exits 0 exactly like the true one.
#
# It is reported rather than gated because the cure is a change to the lowering, which belongs to
# Glow language custody rather than to this scan's hand. A guard that reds on work another lane
# must do is a guard someone turns off.
#
# WHAT THIS DOES NOT REACH, named rather than left to be found. Whether a gate's invariant is the
# RIGHT invariant, and whether the sample values a wall picks are the interesting ones. This reads
# whether the assertion can fail, and stops there. And the repaired form is exact for a 0/1 gate;
# for a gate that speaks an arbitrary number -- a fold's accumulator -- `(out contains "1") ==
# false` bites on 1, 10 and 15 and would still pass on 20, so it is a strengthening rather than an
# exact check. Reading the answer line alone would be exact, and it costs a second process.
#
# THE CEILING. indistinct_refusals is held under a ceiling that only falls -- 20 on 20260828, after
# the eight walls of the infrastructure half (Comlink, Mantra, and the Caravan seams) took the
# repaired form. A ceiling rather than a zero because the remaining twenty stand in other lanes'
# rooms -- Tally, Aurora, Rishi, and the Glow corpus -- and a guard that reds on work another hand
# must do is a guard someone turns off. Lower it when a repair lands; there is no override.
#
# USAGE
#   sh tools/fixtures/glow_gate_answer_scan.sh                 # the real witness surface
#   sh tools/fixtures/glow_gate_answer_scan.sh report <file>   # one planted file, for the pen
#   sh tools/fixtures/glow_gate_answer_scan.sh pen <dir>       # a planted corpus, for the pen
#
# Driven by tools/g/glow_gate_answer_witness.rish. Run from the repository root.

set -u

mode=${1:-tree}
src=${2:-}

# The ceiling lives here, in one place, and the pen proves it from both sides by planting a corpus
# rather than by handing the scan a different number.
indistinct_ceiling=20

if [ ! -f tools/g/glow_run_worker.sh ]; then
  echo "verdict=not_at_root"
  echo "refused: tools/g/glow_run_worker.sh is missing, so this is not the tree this scan reads" >&2
  exit 1
fi

work=$(mktemp -d) || exit 1
trap 'rm -rf "$work"' EXIT

# THE READING, in one awk program so the rule lives in exactly one place. A variable becomes a
# gate run when it is bound to a `run [...]` naming the worker or the runner; an assertion counts
# only against a variable bound that way, so `contains "0"` over some other command's output is
# free.
cat > "$work/read.awk" <<'AWK'
FNR == 1 { for (v in gate) delete gate[v] }
/^[ \t]*let [a-zA-Z_][a-zA-Z_0-9]* = run \[/ && (/glow_run_worker\.sh/ || /glow_run\.rish/) {
  match($0, /let [a-zA-Z_][a-zA-Z_0-9]*/)
  gate[substr($0, RSTART + 4, RLENGTH - 4)] = FNR
  next
}
/^[ \t]*assert [a-zA-Z_][a-zA-Z_0-9]*\.out contains "0"([ \t]|$)/ {
  match($0, /assert [a-zA-Z_][a-zA-Z_0-9]*/)
  v = substr($0, RSTART + 7, RLENGTH - 7)
  if (v in gate) printf "indistinct\t%s\t%d\t%s\n", FILENAME, FNR, v
}
AWK

if [ "$mode" = report ]; then
  if [ -z "$src" ] || [ ! -f "$src" ]; then
    echo "verdict=no_such_file"
    echo "refused: ${src:-<none>} is the witness file this scan reads, and it is absent" >&2
    exit 1
  fi
  set -- "$src"
elif [ "$mode" = pen ]; then
  if [ -z "$src" ] || [ ! -d "$src" ]; then
    echo "verdict=no_such_pen"
    echo "refused: ${src:-<none>} is the planted corpus this scan reads, and it is absent" >&2
    exit 1
  fi
  set -- $(find "$src" -name '*.rish' -type f | sort)
else
  # DISCOVERED RATHER THAN NAMED, so the wall written tomorrow is read on the lap it arrives.
  set -- $(git ls-files 'tools/*.rish' 2>/dev/null | xargs grep -l 'glow_run_worker\.sh\|glow_run\.rish' 2>/dev/null)
  if [ "$#" -eq 0 ] || [ ! -f "$1" ]; then
    echo "verdict=no_gate_walls"
    echo "refused: no tracked .rish under tools/ invokes the Glow runner, and those are the walls this scan reads" >&2
    exit 3
  fi
fi

walls=0
: > "$work/hits.txt"
for f in "$@"; do
  [ -f "$f" ] || continue
  walls=$((walls + 1))
  awk -f "$work/read.awk" "$f" >> "$work/hits.txt"
done

indistinct=$(grep -c '^indistinct	' "$work/hits.txt" 2>/dev/null || true)
[ -n "$indistinct" ] || indistinct=0

while IFS='	' read -r kind file line var; do
  [ "$kind" = indistinct ] || continue
  echo "detail: $file line $line asserts $var.out contains \"0\", which the worker's own EXIT:0 line satisfies"
done < "$work/hits.txt"

# Reading two, reported. Read from the desks themselves rather than from a list, for the same
# reason reading one discovers its walls.
silent=0
if [ "$mode" = tree ]; then
  silent=$(git ls-files 'src/gate/*.glow' 'glow/gen/*.glow' 2>/dev/null \
    | xargs grep -lE '^\|=  \[[a-z_]+=@u32 [a-z_]+=@u32\]' 2>/dev/null | wc -l | tr -d ' ')
  [ -n "$silent" ] || silent=0
fi

echo "gate_walls=$walls"
echo "indistinct_refusals=$indistinct"
echo "indistinct_ceiling=$indistinct_ceiling"
echo "silent_pair_gates=$silent"

if [ "$walls" -eq 0 ]; then
  echo "verdict=no_gate_walls"
  echo "refused: no gate wall was read, so this run measured nothing" >&2
  exit 3
fi

# `report` reads one file and counts; the ceiling governs a whole corpus, so it is applied to the
# tree and to a planted pen alike.
if [ "$mode" != report ] && [ "$indistinct" -gt "$indistinct_ceiling" ]; then
  echo "verdict=indistinct_over_ceiling"
  echo "refused: $indistinct refusal assertions cannot fail, against a ceiling of $indistinct_ceiling" >&2
  exit 4
fi

echo "verdict=read"
exit 0
