#!/bin/sh
# Exercise the silent-leg reading on real Rishi files in isolated repositories, and prove the
# assertion semantics the reading rests on with a real Rishi run.
#
# Two claims hold this family up, and each is checked apart from the other:
#   1. `tools/g/glow_run_worker.sh` echoes a constant trailer after every desk run.
#   2. A substring assertion whose needle stands inside that trailer passes however the desk
#      answered, and the exact list read refuses the same stream.
# Claim 1 is read off the worker's own source; claim 2 is run through this tree's own Rishi.
#
# The scan reads a SECOND family on the same corpus, and a third claim holds that one up:
#   3. A digit needle the trailer cannot supply is satisfied by any WIDER number carrying it, so
#      `assert p.out contains "1"` passes on a desk answering 105, and the list read refuses it.
# The two families are disjoint by construction -- a needle inside the trailer pays as SILENT and
# never as WIDE -- so one loose leg pays exactly once, and the partition is checked here rather
# than trusted. Claim 3 runs through this tree's own Rishi beside claim 2.
#
# Proven once on metal `20260910`, and recorded here rather than rebuilt every lap: a copy of
# `src/gate/gate-mantra-gen-floor-u32.glow` answering 7 where its stated invariant says 0 printed
# `7` then `EXIT:0`, the elder assertion passed, and the list assertion refused. The desk build
# costs about forty seconds and proves only what the worker source already says.
#
# Exit 0 when every check passes, 1 when a check fails. All pens stay under TMPDIR.
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"
SCAN="$HERE/silent_leg_scan.sh"
WORKER="$ROOT/tools/g/glow_run_worker.sh"
RISHI="$ROOT/rishi/bin/rishi"
[ -f "$SCAN" ] || { echo "control: scan missing at $SCAN"; exit 1; }

pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT
trap 'rm -rf "$pen"; exit 130' INT
trap 'rm -rf "$pen"; exit 143' TERM

pass=0
fail=0
check_says() { # name needle haystack
  case "$3" in
    *"$2"*) pass=$((pass + 1)); echo "  ok   $1" ;;
    *) fail=$((fail + 1)); echo "  FAIL $1 -- [$2] absent"; echo "$3" | sed 's/^/       | /' ;;
  esac
}
check_lacks() { # name needle haystack
  case "$3" in
    *"$2"*) fail=$((fail + 1)); echo "  FAIL $1 -- [$2] present and should not be" ;;
    *) pass=$((pass + 1)); echo "  ok   $1" ;;
  esac
}
check_eq() { # name expected actual
  if [ "$2" = "$3" ]; then pass=$((pass + 1)); echo "  ok   $1"
  else fail=$((fail + 1)); echo "  FAIL $1 -- wanted [$2] got [$3]"; fi
}

new_pen() { # name -> echoes the pen root
  _p="$pen/$1"
  mkdir -p "$_p/rishi/bin" "$_p/tools/fixtures/s" "$_p/tools/a" "$_p/tools/t"
  cp "$SCAN" "$_p/tools/fixtures/s/silent_leg_scan.sh"
  ( cd "$_p" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )
  echo "$_p"
}
seal() { ( cd "$1" && git add -A . >/dev/null 2>&1 && true ); }
run_pen() { # pen [args...]
  _r=$1; shift
  out=$( cd "$_r" && sh tools/fixtures/s/silent_leg_scan.sh "$@" 2>&1 ) && rc=0 || rc=$?
}

worker_line='let g = run ["env" "RYE_ZIG=${zig}" "sh" "tools/g/glow_run_worker.sh" desk "0"]'

echo "silent-leg control -- the reading, then the semantics it rests on"

# 1. The plain silent leg: a worker run, a needle inside the trailer.
p=$(new_pen silent)
{ echo "$worker_line"; echo 'assert g.out contains "0" else "did not speak 0"'; } > "$p/tools/a/a_witness.rish"
seal "$p"; run_pen "$p"
check_says "a worker leg reading 0 counts silent" "silent=1" "$out"
check_says "the plain silent leg refuses nothing here" "verdict=ok" "$out"

# 2. The honest exit read passes free, and so does an answer no trailer can supply.
p=$(new_pen honest)
{ echo "$worker_line"
  echo 'assert g.out contains "EXIT:0" else "did not exit 0"'
  echo 'assert g.out contains "15" else "did not fold to 15"'; } > "$p/tools/a/a_witness.rish"
seal "$p"; run_pen "$p"
check_says "the exit read and an answer outside the trailer stay free" "silent=0" "$out"
check_says "and the digit answer is read by the wide family instead" "wide=1" "$out"

# 3. A binding that never ran the worker is nobody's business here.
p=$(new_pen foreign)
{ echo 'let g = run ["sh" "-c" "echo hi"]'
  echo 'assert g.out contains "0" else "no"'; } > "$p/tools/a/a_witness.rish"
seal "$p"; run_pen "$p"
check_says "a non-worker binding is not counted" "silent=0" "$out"

# 4. Rebinding the name clears the worker mark, so a later plain run is read as itself.
p=$(new_pen rebound)
{ echo "$worker_line"
  echo 'let g = run ["sh" "-c" "echo hi"]'
  echo 'assert g.out contains "0" else "no"'; } > "$p/tools/a/a_witness.rish"
seal "$p"; run_pen "$p"
check_says "a rebound name drops the worker mark" "silent=0" "$out"

# 5. A comment executes nothing.
p=$(new_pen commented)
{ echo "$worker_line"
  echo '# assert g.out contains "0" else "no"'; } > "$p/tools/a/a_witness.rish"
seal "$p"; run_pen "$p"
check_says "a commented leg is not counted" "silent=0" "$out"

# 6. The conditional binding form of tools/g/glow_run.rish binds past its leading keyword.
p=$(new_pen conditional)
{ echo 'if args.len == 2 then let gate = run ["sh" "tools/g/glow_run_worker.sh" glow_path args[1]]'
  echo 'assert gate.out contains "0" else "no"'; } > "$p/tools/a/a_witness.rish"
seal "$p"; run_pen "$p"
check_says "the conditional worker binding is read" "silent=1" "$out"

# 7. The lane ceiling bites at one, from both sides, and the tree ceiling stays out of its way.
p=$(new_pen lane)
# A quiet runner keeps the pen a corpus once the plant is lifted; an empty corpus refuses by name,
# which would read as the plant still biting.
echo 'say "quiet"' > "$p/tools/a/quiet_witness.rish"
{ echo "$worker_line"; echo 'assert g.out contains "0" else "no"'; } > "$p/tools/t/t_witness.rish"
seal "$p"; run_pen "$p"
check_eq "a lane leg refuses" 1 "$rc"
check_says "the lane refusal names its own verdict" "verdict=lane_over_ceiling" "$out"
check_says "the lane refusal names the site" "detail: silent lane leg -- tools/t/t_witness.rish" "$out"
rm -f "$p/tools/t/t_witness.rish"; seal "$p"; run_pen "$p"
check_eq "the same pen with the plant lifted walks free" 0 "$rc"

# 8. The tree ceiling bites one past itself, and the count is the whole basis.
ceiling=$(sed -n 's/^ceiling=\([0-9][0-9]*\)$/\1/p' "$SCAN" | head -1)
[ -n "$ceiling" ] || { echo "  FAIL the scan states no ceiling"; fail=$((fail + 1)); ceiling=0; }
p=$(new_pen ceiling)
i=0
while [ "$i" -le "$ceiling" ]; do
  { echo "$worker_line"; echo 'assert g.out contains "0" else "no"'; } > "$p/tools/a/w$i.rish"
  i=$((i + 1))
done
seal "$p"; run_pen "$p"
check_eq "one leg past the tree ceiling refuses" 1 "$rc"
check_says "the tree refusal names its own verdict" "verdict=silent_over_ceiling" "$out"
rm -f "$p/tools/a/w$ceiling.rish"; seal "$p"; run_pen "$p"
check_eq "standing exactly at the tree ceiling walks free" 0 "$rc"

# 9. Misuse and an unreadable corpus refuse by name rather than reading zero.
p=$(new_pen misuse)
seal "$p"; run_pen "$p" --list
check_eq "a bare --list refuses" 2 "$rc"
run_pen "$p" --list nonesuch
check_eq "an unknown set refuses" 2 "$rc"
run_pen "$p" --heave
check_eq "an unknown argument refuses" 2 "$rc"

# 10. --list prints the sites it counted.
p=$(new_pen listing)
{ echo "$worker_line"; echo 'assert g.out contains "0" else "no"'; } > "$p/tools/a/a_witness.rish"
seal "$p"; run_pen "$p" --list silent
check_says "--list silent names the site" "tools/a/a_witness.rish:2" "$out"

# 11. CLAIM ONE, off the worker's own source: it echoes a constant trailer after every run.
if [ -f "$WORKER" ]; then
  trailer_echoes=$(grep -c 'echo "EXIT:\$?"' "$WORKER" || true)
  check_eq "the worker echoes its trailer on both arms" 2 "$trailer_echoes"
  check_says "the scan names the trailer it reads" "trailer='EXIT:0'" "$(cat "$SCAN")"
else
  echo "  ok   worker absent -- claim one unread here"; pass=$((pass + 1))
fi

# 12. CLAIM TWO, run through this tree's own Rishi: the substring read passes a wrong answer and
#     the exact list read refuses it. `printf` stands in for the desk, and the stream is the one
#     the worker actually produced on metal.
if [ -x "$RISHI" ]; then
  probe="$pen/semantics.rish"
  {
    echo 'let stream = run ["printf" "7\nEXIT:0"]'
    echo 'assert stream.out contains "0" else "SEMANTICS: the substring read refused -- it can red"'
    echo 'assert ((lines stream.out) contains "0") == false else "SEMANTICS: the list read passed -- it cannot red"'
    echo 'assert (lines stream.out) contains "EXIT:0" else "SEMANTICS: the list read lost the trailer"'
    echo 'say "SEMANTICS: substring true, list false, on one stream."'
  } > "$probe"
  sem=$( cd "$ROOT" && "$RISHI" run "$probe" 2>&1 ) && semrc=0 || semrc=$?
  check_eq "the semantics probe holds" 0 "$semrc"
  check_says "the substring read passes a wrong answer; the list read refuses it" \
    "SEMANTICS: substring true, list false, on one stream." "$sem"
else
  echo "  ok   rishi absent -- claim two unread here"; pass=$((pass + 1))
fi

# 13. The repair is what the lane actually carries, read off the tree rather than asserted.
if [ -f "$ROOT/tools/m/mantra_gen_floor_a1_gate_witness.rish" ]; then
  check_says "the lane's own gate witness carries the list read" \
    'assert (lines reserved.out) contains "0"' \
    "$(cat "$ROOT/tools/m/mantra_gen_floor_a1_gate_witness.rish")"
  check_lacks "and no longer carries the substring read" \
    'assert reserved.out contains "0"' \
    "$(cat "$ROOT/tools/m/mantra_gen_floor_a1_gate_witness.rish")"
fi

# 14. THE PARTITION. A needle inside the trailer pays as silent and never as wide, so one loose
#     leg pays once. Checked from both sides on one pen.
p=$(new_pen partition)
{ echo "$worker_line"
  echo 'assert g.out contains "0" else "no"'
  echo 'assert g.out contains "15" else "no"'; } > "$p/tools/a/a_witness.rish"
seal "$p"; run_pen "$p"
check_says "the trailer needle pays as silent" "silent=1" "$out"
check_says "the digit needle pays as wide" "wide=1" "$out"

# 15. A needle that is neither inside the trailer nor a digit run is nobody's business.
p=$(new_pen word)
{ echo "$worker_line"; echo 'assert g.out contains "GREEN" else "no"'; } > "$p/tools/a/a_witness.rish"
seal "$p"; run_pen "$p"
check_says "a word needle is not silent" "silent=0" "$out"
check_says "a word needle is not wide" "wide=0" "$out"

# 16. The list read is the repair, so it leaves both families.
p=$(new_pen repaired)
{ echo "$worker_line"; echo 'assert (lines g.out) contains "15" else "no"'; } > "$p/tools/a/a_witness.rish"
seal "$p"; run_pen "$p"
check_says "the repaired leg leaves the wide family" "wide=0" "$out"

# 17. The lane wide ceiling bites at one, from both sides.
p=$(new_pen lanewide)
echo 'say "quiet"' > "$p/tools/a/quiet_witness.rish"
{ echo "$worker_line"; echo 'assert g.out contains "15" else "no"'; } > "$p/tools/t/t_witness.rish"
seal "$p"; run_pen "$p"
check_eq "a lane wide leg refuses" 1 "$rc"
check_says "the lane wide refusal names its own verdict" "verdict=lane_wide_over_ceiling" "$out"
check_says "the lane wide refusal names the site" "detail: wide lane leg -- tools/t/t_witness.rish" "$out"
rm -f "$p/tools/t/t_witness.rish"; seal "$p"; run_pen "$p"
check_eq "the same pen with the wide plant lifted walks free" 0 "$rc"

# 18. The tree wide ceiling bites one past itself, and the count is the whole basis.
wceiling=$(sed -n 's/^wide_ceiling=\([0-9][0-9]*\)$/\1/p' "$SCAN" | head -1)
[ -n "$wceiling" ] || { echo "  FAIL the scan states no wide ceiling"; fail=$((fail + 1)); wceiling=0; }
p=$(new_pen wideceiling)
i=0
while [ "$i" -le "$wceiling" ]; do
  { echo "$worker_line"; echo 'assert g.out contains "15" else "no"'; } > "$p/tools/a/w$i.rish"
  i=$((i + 1))
done
seal "$p"; run_pen "$p"
check_eq "one leg past the tree wide ceiling refuses" 1 "$rc"
check_says "the tree wide refusal names its own verdict" "verdict=wide_over_ceiling" "$out"
rm -f "$p/tools/a/w$wceiling.rish"; seal "$p"; run_pen "$p"
check_eq "standing exactly at the tree wide ceiling walks free" 0 "$rc"

# 19. --list wide and --list lane_wide print the sites they counted.
p=$(new_pen widelisting)
{ echo "$worker_line"; echo 'assert g.out contains "15" else "no"'; } > "$p/tools/a/a_witness.rish"
seal "$p"; run_pen "$p" --list wide
check_says "--list wide names the site" "tools/a/a_witness.rish:2" "$out"
run_pen "$p" --list lane_wide
check_lacks "--list lane_wide leaves a non-lane site out" "tools/a/a_witness.rish:2" "$out"

# 20. CLAIM THREE, run through this tree's own Rishi: a wider number satisfies the substring read
#     and refuses the list read. The stream is the one a fold desk answering 105 actually produces,
#     and the needle is the one `tally_a2_list_reducer_witness.rish` uses for its identity leg.
if [ -x "$RISHI" ]; then
  probe="$pen/wide.rish"
  {
    echo 'let stream = run ["printf" "105\nEXIT:0"]'
    echo 'assert stream.out contains "1" else "WIDE: the substring read refused -- it can red"'
    echo 'assert ((lines stream.out) contains "1") == false else "WIDE: the list read passed -- it cannot red"'
    echo 'assert (lines stream.out) contains "105" else "WIDE: the list read lost the real answer"'
    echo 'say "WIDE: substring true, list false, on one stream."'
  } > "$probe"
  wsem=$( cd "$ROOT" && "$RISHI" run "$probe" 2>&1 ) && wrc=0 || wrc=$?
  check_eq "the wide semantics probe holds" 0 "$wrc"
  check_says "a wider answer passes the substring read and refuses the list read" \
    "WIDE: substring true, list false, on one stream." "$wsem"
else
  echo "  ok   rishi absent -- claim three unread here"; pass=$((pass + 1))
fi

# 21. The wide repair is what the lane actually carries, read off the tree rather than asserted.
if [ -f "$ROOT/tools/t/tally_a2_list_reducer_witness.rish" ]; then
  check_says "the lane's own reducer witness carries the list read" \
    'assert (lines p2.out) contains "1"' \
    "$(cat "$ROOT/tools/t/tally_a2_list_reducer_witness.rish")"
  check_lacks "and no longer carries the substring read" \
    'assert p2.out contains "1"' \
    "$(cat "$ROOT/tools/t/tally_a2_list_reducer_witness.rish")"
fi

echo "legs_pass=$pass"
echo "legs_fail=$fail"
if [ "$fail" -gt 0 ]; then echo "control_verdict=fail"; exit 1; fi
echo "control_verdict=ok"
exit 0
