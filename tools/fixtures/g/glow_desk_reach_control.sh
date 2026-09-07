#!/bin/sh
# tools/fixtures/g/glow_desk_reach_control.sh -- prove the desk-reach reading on real desk rooms.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every refusal
# below is shown from both sides: planted, and then lifted back to ok. Every welcome is asserted as
# hard as every refusal, because a reading that called an ordinary covered desk uncovered would
# cost a hand an hour before they stopped believing it.
#
# The pen is a miniature desk room -- a glow/gen/ tree and a witness naming some of it -- rather
# than a copy of this tree, so the scan under proof reads the pen and never this bench.
#
#   sh tools/fixtures/g/glow_desk_reach_control.sh
set -eu

root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "refused: not a git repository" >&2; exit 1; }
scan="$root/tools/fixtures/g/glow_desk_reach_scan.sh"
[ -f "$scan" ] || { echo "refused: the scan under proof is missing -- $scan" >&2; exit 1; }

pen=$(mktemp -d) || { echo "refused: no temporary directory" >&2; exit 1; }
trap 'rm -rf "$pen"' EXIT

pass=0
fail=0
check() {
  want=$1; got=$2; what=$3
  if [ "$want" = "$got" ]; then
    pass=$((pass + 1)); echo "  ok   $what"
  else
    fail=$((fail + 1)); echo "  FAIL $what -- want $want, got $got"
  fi
}
field() { sed -n "s/^$2=//p" "$1" | head -1; }

# A pen carries the two directories the scan's upward root walk looks for, so it resolves to the
# pen rather than climbing out into this tree.
newpen() {
  d="$pen/$1"; rm -rf "$d"
  mkdir -p "$d/tools/fixtures/g" "$d/tools/g" "$d/glow/gen/g" "$d/glow/gen/s"
  cp "$scan" "$d/tools/fixtures/g/glow_desk_reach_scan.sh"
  worker "$d" ""
  echo "$d"
}

# A miniature run worker. The scan reads its `case` PATTERN lines for the sample-permission list,
# so the pen writes a real one: a comment naming a stem the pattern lines do not, which is how the
# pattern anchor is proven rather than assumed.
worker() {
  {
    printf '#!/bin/sh\n'
    printf '# gate-mentioned-in-a-comment) is not a permission.\n'
    printf 'case "$STEM" in\n'
    if [ -n "$2" ]; then printf '%s)\n  echo sampled ;;\n' "$2"; fi
    printf '*)\n  echo bare ;;\n'
    printf 'esac\n'
  } > "$1/tools/g/glow_run_worker.sh"
}

# a plain runnable desk
desk() { printf '::  A desk (pen).\n|^  sample\nsample\n' > "$1"; }
# a desk declaring both ways that it must not run
norun() { printf '::  Refuse desk -- pen negative space.\n::  Parse-only; do not glow_run -- nest refuses.\n|^  sample\nsample\n' > "$1"; }

# runscan <pen-dir> <out-file> [VAR=value ...]. The elder body shifted once and then passed the
# remaining words -- out-file included -- to `env`, so `env` read the output path as its first
# assignment and the scan never ran. It was dead code, called by nothing, and the first case to
# call it read every field as empty. A helper nobody calls is a helper nobody has checked.
runscan() {
  _rs_dir=$1; _rs_out=$2; shift 2
  ( cd "$_rs_dir" && env "$@" sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$_rs_out" 2>&1 || true
}

echo "glow_desk_reach control -- planted refusals, each lifted"

# --- 1. a clean room reads ok, and the arithmetic closes -------------------------------------
d=$(newpen clean)
desk "$d/glow/gen/g/gate-one.glow"
desk "$d/glow/gen/g/gate-two.glow"
norun "$d/glow/gen/g/gate-three-refuse.glow"
cat > "$d/tools/g/glow_run_desk_witness.rish" <<'PEN'
let a = run ["rishi/bin/rishi" "run" "tools/g/glow_run.rish" "glow/gen/g/gate-one.glow"]
let b = run ["rishi/bin/rishi" "run" "tools/g/glow_run.rish" "glow/gen/g/gate-two.glow"]
PEN
( cd "$d" && GLOW_DESK_UNCOVERED_BARE_CEILING=0 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=0 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check ok "$(field "$pen/o" verdict)" "a clean room reads ok"
check 3 "$(field "$pen/o" desks)" "every .glow counted"
check 1 "$(field "$pen/o" declared_norun)" "the refuse desk is declared by both markers"
check 2 "$(field "$pen/o" runnable)" "runnable is desks minus declared_norun"
check 2 "$(field "$pen/o" covered)" "both runnable desks are covered"
check 0 "$(field "$pen/o" uncovered)" "nothing is left uncovered"

# --- 2. an uncovered desk refuses at the ceiling, and is welcomed once covered ----------------
desk "$d/glow/gen/g/gate-four.glow"
( cd "$d" && GLOW_DESK_UNCOVERED_BARE_CEILING=0 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=0 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check over_bare_ceiling "$(field "$pen/o" verdict)" "a desk nothing runs refuses at a ceiling of zero"
check 1 "$(field "$pen/o" uncovered)" "the uncovered desk is counted"
( cd "$d" && GLOW_DESK_UNCOVERED_BARE_CEILING=1 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=0 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check ok "$(field "$pen/o" verdict)" "the same room reads ok one ceiling higher -- the ratchet, not a gate"
printf 'let d = run ["glow/gen/g/gate-four.glow"]\n' >> "$d/tools/g/glow_run_desk_witness.rish"
( cd "$d" && GLOW_DESK_UNCOVERED_BARE_CEILING=0 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=0 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check ok "$(field "$pen/o" verdict)" "covering the desk lifts the refusal"
rm -f "$d/glow/gen/g/gate-four.glow"
sed -i.bak '/gate-four/d' "$d/tools/g/glow_run_desk_witness.rish" && rm -f "$d/tools/g/glow_run_desk_witness.rish.bak"

# --- 3. a marker disagreement refuses, from both sides ----------------------------------------
# the head says refuse, the name does not
printf '::  Refuse desk -- head says so, name does not.\n|^  sample\nsample\n' > "$d/glow/gen/g/gate-five.glow"
( cd "$d" && GLOW_DESK_UNCOVERED_BARE_CEILING=9 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=9 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check marker_disagree "$(field "$pen/o" verdict)" "a head marker without a name marker refuses"
check 1 "$(field "$pen/o" norun_disagree)" "the disagreement is counted"
mv "$d/glow/gen/g/gate-five.glow" "$d/glow/gen/g/gate-five-refuse.glow"
( cd "$d" && GLOW_DESK_UNCOVERED_BARE_CEILING=9 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=9 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check ok "$(field "$pen/o" verdict)" "renaming to carry the marker lifts the refusal"
# the name says refuse, the head does not
printf '::  An ordinary desk wearing a refuse name.\n|^  sample\nsample\n' > "$d/glow/gen/g/gate-six-refuse.glow"
( cd "$d" && GLOW_DESK_UNCOVERED_BARE_CEILING=9 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=9 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check marker_disagree "$(field "$pen/o" verdict)" "a name marker without a head marker refuses -- the other side"
rm -f "$d/glow/gen/g/gate-six-refuse.glow" "$d/glow/gen/g/gate-five-refuse.glow"
( cd "$d" && GLOW_DESK_UNCOVERED_BARE_CEILING=9 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=9 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check ok "$(field "$pen/o" verdict)" "removing both plants returns the room to ok"

# --- 4. a phantom refuses, and is lifted by the file arriving ---------------------------------
printf 'let p = run ["glow/gen/g/gate-absent.glow"]\n' >> "$d/tools/g/glow_run_desk_witness.rish"
( cd "$d" && GLOW_DESK_UNCOVERED_BARE_CEILING=9 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=9 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check phantom "$(field "$pen/o" verdict)" "a witness naming a desk that is not on disk refuses"
check 1 "$(field "$pen/o" phantom)" "the phantom is counted"
desk "$d/glow/gen/g/gate-absent.glow"
( cd "$d" && GLOW_DESK_UNCOVERED_BARE_CEILING=9 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=9 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check ok "$(field "$pen/o" verdict)" "the desk arriving lifts the phantom refusal"

# --- 5. a contradiction refuses, and is lifted by the witness letting go ----------------------
printf 'let c = run ["glow/gen/g/gate-three-refuse.glow"]\n' >> "$d/tools/g/glow_run_desk_witness.rish"
( cd "$d" && GLOW_DESK_UNCOVERED_BARE_CEILING=9 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=9 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check contradicted "$(field "$pen/o" verdict)" "a witness running a declared-unrunnable desk refuses"
check 1 "$(field "$pen/o" contradicted)" "the contradiction is counted"
sed -i.bak '/gate-three-refuse/d' "$d/tools/g/glow_run_desk_witness.rish" && rm -f "$d/tools/g/glow_run_desk_witness.rish.bak"
( cd "$d" && GLOW_DESK_UNCOVERED_BARE_CEILING=9 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=9 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check ok "$(field "$pen/o" verdict)" "the witness letting go lifts the contradiction"

# --- 6. the scan refuses to describe a subject it cannot read ---------------------------------
d2=$(newpen nowitness)
desk "$d2/glow/gen/g/gate-one.glow"
( cd "$d2" && sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 && rc=0 || rc=$?
check 2 "$rc" "a missing desk witness refuses by name rather than reading zero coverage"

d3=$(newpen noroom)
printf 'let a = run ["glow/gen/g/gate-one.glow"]\n' > "$d3/tools/g/glow_run_desk_witness.rish"
rm -rf "$d3/glow/gen"
( cd "$d3" && sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 && rc=0 || rc=$?
check 2 "$rc" "a missing desk room refuses rather than reporting an empty corpus as clean"

# --- 7. the split: a sample-taking desk is a different debt from a bare one -------------------
# The two gates must fire independently, or the split buys nothing over the sum it replaced.
d4=$(newpen split)
worker "$d4" "gate-sampled"
desk "$d4/glow/gen/g/gate-sampled.glow"
desk "$d4/glow/gen/g/gate-plain.glow"
printf 'let a = run ["glow/gen/g/gate-plain.glow"]\n' > "$d4/tools/g/glow_run_desk_witness.rish"
runscan "$d4" "$pen/o" GLOW_DESK_UNCOVERED_BARE_CEILING=9 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=9
check 1 "$(field "$pen/o" sample_permitted)" "the worker's permission list names one desk in this room"
check 1 "$(field "$pen/o" uncovered_sampled)" "an uncovered permitted desk counts as sampled"
check 0 "$(field "$pen/o" uncovered_bare)" "and not as bare -- the two are disjoint"
check 1 "$(field "$pen/o" uncovered)" "the sum is still the whole uncovered set"

# The sampled gate fires while the bare gate stands wide open. The elder single ceiling could not
# express this reading at all, which is the whole argument for splitting it.
runscan "$d4" "$pen/o" GLOW_DESK_UNCOVERED_BARE_CEILING=9 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=0
check over_sampled_ceiling "$(field "$pen/o" verdict)" "a sample-taking desk refuses at its own ceiling"
runscan "$d4" "$pen/o" GLOW_DESK_UNCOVERED_BARE_CEILING=0 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=9
check ok "$(field "$pen/o" verdict)" "and passes a bare ceiling of zero -- the gates are independent"

# The other side: a bare uncovered desk moves the bare count and leaves the sampled one alone.
desk "$d4/glow/gen/g/gate-second-plain.glow"
runscan "$d4" "$pen/o" GLOW_DESK_UNCOVERED_BARE_CEILING=0 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=9
check over_bare_ceiling "$(field "$pen/o" verdict)" "a bare desk refuses at the bare ceiling"
check 1 "$(field "$pen/o" uncovered_bare)" "the bare desk is counted as bare"
check 1 "$(field "$pen/o" uncovered_sampled)" "and the sampled count is untouched"
rm -f "$d4/glow/gen/g/gate-second-plain.glow"

# The sum is derived from its parts rather than spelled, so it can never disagree with them.
runscan "$d4" "$pen/o" GLOW_DESK_UNCOVERED_BARE_CEILING=7 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=5
check 12 "$(field "$pen/o" uncovered_ceiling)" "the printed sum ceiling is the two parts added"

# --- 8. the permission list is read from `case` patterns, never from a mention ----------------
# The pen's worker carries `gate-mentioned-in-a-comment)` inside a comment line. A grep for
# stem-shaped words would take it as a permission; the pattern-line anchor does not.
desk "$d4/glow/gen/g/gate-mentioned-in-a-comment.glow"
runscan "$d4" "$pen/o" GLOW_DESK_UNCOVERED_BARE_CEILING=9 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=9
check 1 "$(field "$pen/o" sample_permitted)" "a stem named only in a comment is not a permission"
check 1 "$(field "$pen/o" uncovered_bare)" "so it is read as an ordinary bare desk"
rm -f "$d4/glow/gen/g/gate-mentioned-in-a-comment.glow"

# --- 9. a permission naming no Glow file anywhere refuses, and the file lifts it ---------------
worker "$d4" "gate-sampled|gate-nowhere"
runscan "$d4" "$pen/o" GLOW_DESK_UNCOVERED_BARE_CEILING=9 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=9
check sample_phantom "$(field "$pen/o" verdict)" "a permission for a stem with no .glow refuses"
check 1 "$(field "$pen/o" sample_phantom)" "the dead branch is counted"
desk "$d4/glow/gen/g/gate-nowhere.glow"
runscan "$d4" "$pen/o" GLOW_DESK_UNCOVERED_BARE_CEILING=9 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=9
check ok "$(field "$pen/o" verdict)" "the desk arriving lifts the sample_phantom refusal"
check 0 "$(field "$pen/o" sample_phantom)" "and the count returns to zero"

# A permission whose desk lives in ANOTHER room is not a fault of this one -- 48 of the 94 on this
# bench name desks under src/gate and src/shape, and counting them would red an honest tree.
rm -f "$d4/glow/gen/g/gate-nowhere.glow"
mkdir -p "$d4/src/gate"
desk "$d4/src/gate/gate-nowhere.glow"
runscan "$d4" "$pen/o" GLOW_DESK_UNCOVERED_BARE_CEILING=9 GLOW_DESK_UNCOVERED_SAMPLED_CEILING=9
check ok "$(field "$pen/o" verdict)" "a permission whose desk lives in another room reads ok"
check 0 "$(field "$pen/o" sample_phantom)" "it is elsewhere, not absent"
check 1 "$(field "$pen/o" sample_permitted)" "and it is not counted in this room's population"

# --- 10. the scan refuses to describe a subject it cannot read, third instrument ---------------
d5=$(newpen noworker)
desk "$d5/glow/gen/g/gate-one.glow"
printf 'let a = run ["glow/gen/g/gate-one.glow"]\n' > "$d5/tools/g/glow_run_desk_witness.rish"
rm -f "$d5/tools/g/glow_run_worker.sh"
( cd "$d5" && sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 && rc=0 || rc=$?
check 2 "$rc" "a missing run worker refuses by name rather than reading an empty permission list"

echo "glow_desk_reach control: pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
