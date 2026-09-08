#!/bin/sh
# tools/fixtures/g/glow_desk_run_control.sh -- prove the desk-run reading on real desk rooms.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every refusal
# below is shown from both sides: planted, and then lifted back to ok. Every welcome is asserted as
# hard as every refusal, because a runner that declined an ordinary desk would read exactly like a
# runner with nothing to do.
#
# The pen is a miniature desk room rather than a copy of this tree, and the per-desk run is a STUB
# named through GLOW_DESK_RUN_ONE. That boundary is deliberate: this control proves the READING --
# which desks are selected, how they are counted, and where the ceiling bites -- while the real
# lower-build-run is proven by tools/g/glow_desk_run_witness.rish against the live corpus on metal.
# A control that dragged a Zig toolchain into a pen would be slower, would red on a bench without
# one, and would still not prove the thing the witness proves.
#
#   sh tools/fixtures/g/glow_desk_run_control.sh
set -eu

root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "refused: not a git repository" >&2; exit 1; }
scan="$root/tools/fixtures/g/glow_desk_run_scan.sh"
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
  cp "$scan" "$d/tools/fixtures/g/glow_desk_run_scan.sh"
  worker "$d" ""
  stub "$d" ""
  echo "$d"
}

# A miniature run worker. The scan reads its `case` PATTERN lines for the sample-permission list,
# so the pen writes a real one, with a comment naming a stem the pattern lines do not -- which is
# how the pattern anchor is proven rather than assumed.
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

# The stub standing in for one desk's lower-build-run. It records every desk handed to it, and
# refuses the desks named in its second argument, so a failure is planted by name.
stub() {
  {
    printf '#!/bin/sh\n'
    printf 'printf "%%s\\n" "$*" >> "%s/calls"\n' "$1"
    printf 'case "${1##*/}" in\n'
    if [ -n "$2" ]; then printf '%s) exit 1 ;;\n' "$2"; fi
    printf '*) exit 0 ;;\n'
    printf 'esac\n'
  } > "$1/stub.sh"
  chmod +x "$1/stub.sh"
}

# a plain runnable desk
desk() { printf '::  A desk (pen).\n|^  sample\nsample\n' > "$1"; }
# a desk declaring both ways that it must not run
norun() { printf '::  Refuse desk -- pen negative space.\n::  Parse-only; do not glow_run -- nest refuses.\n|^  sample\nsample\n' > "$1"; }
# a desk declaring only in its head
norun_head() { printf '::  Parse-only; do not glow_run.\n|^  sample\nsample\n' > "$1"; }
# a sample-taking desk that declares the values which prove it, in its own head band
sampled_desk() { printf '::  A desk (pen).\n::  Sample: %s\n|^  sample\nsample\n' "$2" > "$1"; }
# the same declaration written below the six-line band, where the scan does not read
late_sample() { printf '::  a\n::  b\n::  c\n::  d\n::  e\n::  f\n::  Sample: 9\n|^  sample\nsample\n' > "$1"; }
# a desk whose refusal words sit below the head band the scan reads
late_words() { printf '::  A desk (pen).\n::  b\n::  c\n::  d\n::  e\n::  f\n::  do not glow_run -- too late to count.\n|^  sample\nsample\n' > "$1"; }

runscan() {
  _dir=$1; _out=$2; shift 2
  ( cd "$_dir" && rm -f calls && env GLOW_DESK_RUN_ONE="$_dir/stub.sh" "$@" sh tools/fixtures/g/glow_desk_run_scan.sh ) > "$_out" 2>&1 || true
}

echo "glow_desk_run control -- planted refusals, each lifted"

# --- 1. a clean room selects the bare-runnable desks, and the arithmetic closes ----------------
d=$(newpen clean)
desk "$d/glow/gen/g/gate-one.glow"
desk "$d/glow/gen/g/gate-two.glow"
norun "$d/glow/gen/g/gate-three-refuse.glow"
runscan "$d" "$pen/o"
check ok "$(field "$pen/o" verdict)" "a clean room reads ok"
check 3 "$(field "$pen/o" desks)" "every .glow counted"
check 1 "$(field "$pen/o" declined)" "the refuse desk is declined"
check 0 "$(field "$pen/o" sampled)" "no desk takes a sample here"
check 2 "$(field "$pen/o" selected)" "selected is desks minus declined minus sampled"
check 2 "$(field "$pen/o" ran)" "every selected desk ran"
check 0 "$(field "$pen/o" failed)" "nothing failed"
check 2 "$(wc -l < "$d/calls" | tr -d ' ')" "the runner was handed exactly the selection"

# --- 2. a desk declared in its HEAD alone is still declined (union, not intersection) ----------
d=$(newpen head_only)
desk "$d/glow/gen/g/gate-one.glow"
norun_head "$d/glow/gen/g/gate-two.glow"
runscan "$d" "$pen/o"
check 1 "$(field "$pen/o" declined)" "a head-only declaration declines the desk"
check 1 "$(field "$pen/o" selected)" "and it is not handed to the runner"

# --- 3. a desk declared in its NAME alone is still declined -----------------------------------
d=$(newpen name_only)
desk "$d/glow/gen/g/gate-one.glow"
desk "$d/glow/gen/g/gate-two-refuse.glow"
runscan "$d" "$pen/o"
check 1 "$(field "$pen/o" declined)" "a name-only declaration declines the desk"
check 1 "$(field "$pen/o" selected)" "and it is not handed to the runner"

# --- 4. refusal words below the head band do not decline a desk -------------------------------
d=$(newpen late)
desk "$d/glow/gen/g/gate-one.glow"
late_words "$d/glow/gen/g/gate-two.glow"
runscan "$d" "$pen/o"
check 0 "$(field "$pen/o" declined)" "words below the sixth head line decline nothing"
check 2 "$(field "$pen/o" selected)" "the desk stays in the selection"

# --- 5. a sample-permitted desk leaves the selection; a commented stem does not ----------------
d=$(newpen sampled)
desk "$d/glow/gen/g/gate-one.glow"
desk "$d/glow/gen/g/gate-two.glow"
desk "$d/glow/gen/g/gate-mentioned-in-a-comment.glow"
worker "$d" "gate-two"
runscan "$d" "$pen/o"
check 1 "$(field "$pen/o" sampled)" "the permitted stem is read off the case pattern"
check 2 "$(field "$pen/o" selected)" "a sample-taking desk leaves the bare selection"
check 3 "$(field "$pen/o" desks)" "the commented stem is no permission -- it stays selected"

# --- 5b. a sampled desk that declares its sample rejoins the selection, args and all -----------
d=$(newpen declared)
desk "$d/glow/gen/g/gate-one.glow"
sampled_desk "$d/glow/gen/g/gate-two.glow" "3 5"
worker "$d" "gate-two"
runscan "$d" "$pen/o"
check ok "$(field "$pen/o" verdict)" "a declared sample reads ok"
check 1 "$(field "$pen/o" sampled)" "the desk is still sample-taking"
check 1 "$(field "$pen/o" sample_declared)" "and its head declares the sample"
check 0 "$(field "$pen/o" sample_undeclared)" "so nothing stands undeclared"
check 2 "$(field "$pen/o" selected)" "the declared desk rejoins the selection"
check 1 "$(grep -c '^.*gate-two.glow 3 5$' "$d/calls")" "and its own words reach the runner, split"
check 1 "$(grep -c '^.*gate-one.glow$' "$d/calls")" "a bare desk is handed no words at all"

# --- 5c. an undeclared sampled desk is counted, named, and refused ----------------------------
d=$(newpen undeclared)
desk "$d/glow/gen/g/gate-one.glow"
desk "$d/glow/gen/g/gate-two.glow"
worker "$d" "gate-two"
runscan "$d" "$pen/o"
check sample_undeclared "$(field "$pen/o" verdict)" "a sampled desk declaring nothing refuses"
check 1 "$(field "$pen/o" sample_undeclared)" "and it is counted"
check 1 "$(grep -c 'gate-two.glow' "$pen/o")" "and named"
check 1 "$(grep -c 'Sample: <the values that prove it>' "$pen/o")" "and the cure is named beside it"
check 1 "$(field "$pen/o" selected)" "an undeclared sampled desk stays out of the selection"
runscan "$d" "$pen/o" GLOW_DESK_SAMPLE_UNDECLARED_CEILING=1
check ok "$(field "$pen/o" verdict)" "the same desk under a ceiling of one reads ok"
sampled_desk "$d/glow/gen/g/gate-two.glow" "7"
runscan "$d" "$pen/o"
check ok "$(field "$pen/o" verdict)" "giving it a sample returns the pen to ok at a ceiling of zero"
check 2 "$(field "$pen/o" selected)" "and the selection grows by it"

# --- 5d. a declaration below the head band is no declaration ----------------------------------
d=$(newpen late_sample)
desk "$d/glow/gen/g/gate-one.glow"
late_sample "$d/glow/gen/g/gate-two.glow"
worker "$d" "gate-two"
runscan "$d" "$pen/o"
check 1 "$(field "$pen/o" sample_undeclared)" "a Sample line below the sixth head line declares nothing"
check sample_undeclared "$(field "$pen/o" verdict)" "and the desk refuses like any undeclared one"

# --- 5e. a DECLINED sampled desk is never asked for a sample -----------------------------------
d=$(newpen declined_sampled)
desk "$d/glow/gen/g/gate-one.glow"
norun "$d/glow/gen/g/gate-two-refuse.glow"
worker "$d" "gate-two-refuse"
runscan "$d" "$pen/o"
check ok "$(field "$pen/o" verdict)" "a desk that declined to run is not asked to declare a sample"
check 0 "$(field "$pen/o" sample_undeclared)" "and it is counted nowhere"

# --- 6. a failing desk is counted and named, and the ceiling bites from both sides -------------
d=$(newpen failing)
desk "$d/glow/gen/g/gate-one.glow"
desk "$d/glow/gen/g/gate-bad.glow"
stub "$d" "gate-bad.glow"
runscan "$d" "$pen/o" GLOW_DESK_RUN_FAILED_CEILING=1
check ok "$(field "$pen/o" verdict)" "one failure under a ceiling of one reads ok"
check 1 "$(field "$pen/o" failed)" "the failure is counted"
check 1 "$(grep -c 'gate-bad.glow' "$pen/o")" "and the failing desk is named"
runscan "$d" "$pen/o" GLOW_DESK_RUN_FAILED_CEILING=0
check over_failed_ceiling "$(field "$pen/o" verdict)" "the same failure past a ceiling of zero refuses"
stub "$d" ""
runscan "$d" "$pen/o" GLOW_DESK_RUN_FAILED_CEILING=0
check ok "$(field "$pen/o" verdict)" "lifting the failure returns the pen to ok"
check 0 "$(field "$pen/o" failed)" "and the count falls with it"

# --- 7. --list prints the selection and runs nothing -------------------------------------------
d=$(newpen listing)
desk "$d/glow/gen/g/gate-one.glow"
desk "$d/glow/gen/g/gate-two.glow"
norun "$d/glow/gen/g/gate-three-refuse.glow"
( cd "$d" && rm -f calls && env GLOW_DESK_RUN_ONE="$d/stub.sh" sh tools/fixtures/g/glow_desk_run_scan.sh --list ) > "$pen/o" 2>&1 || true
check 2 "$(wc -l < "$pen/o" | tr -d ' ')" "--list prints one line per selected desk"
check 1 "$(grep -c 'gate-one.glow' "$pen/o")" "and the selection is the bare-runnable set"
check no "$(test -f "$d/calls" && echo yes || echo no)" "--list hands the runner nothing"

# --- 8. the refusals a caller can make -------------------------------------------------------
d=$(newpen args)
desk "$d/glow/gen/g/gate-one.glow"
rc=0; ( cd "$d" && sh tools/fixtures/g/glow_desk_run_scan.sh --nonsense ) >/dev/null 2>&1 || rc=$?
check 2 "$rc" "an unknown argument refuses by name"
rm -rf "$d/glow/gen"
rc=0; ( cd "$d" && sh tools/fixtures/g/glow_desk_run_scan.sh --list ) >/dev/null 2>&1 || rc=$?
check 2 "$rc" "a missing desk room refuses"
d=$(newpen noworker)
desk "$d/glow/gen/g/gate-one.glow"
rm -f "$d/tools/g/glow_run_worker.sh"
rc=0; ( cd "$d" && sh tools/fixtures/g/glow_desk_run_scan.sh --list ) >/dev/null 2>&1 || rc=$?
check 2 "$rc" "a missing run worker refuses"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
