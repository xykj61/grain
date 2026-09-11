#!/bin/sh
# tools/fixtures/g/gate_example_control.sh -- proves tools/fixtures/g/gate_example_scan.sh from both
# sides, on miniature gate rooms in a throwaway pen.
#
#   sh tools/fixtures/g/gate_example_control.sh
#
# WHY A PEN RATHER THAN THE LIVE ROOM. The scan's run half lowers and builds each desk with Zig,
# about six seconds a case, so proving `answers_wrong` against the real room would cost eleven
# minutes to learn one thing. Here the worker is a stub the control writes: it states an arity when
# asked, prints an answer and the `EXIT:<code>` tail when run, and lies on command. Every refusal
# below is planted and then lifted, so a passing reading is shown to be a reading rather than a
# silence.
#
# THE LEG THAT CARRIES THE DESIGN. `first_case_only_would_miss` plants a desk whose FIRST case the
# worker accepts and whose SECOND it does not. A reading taken from the first case -- the obvious
# one, and the one the measuring lap wrote before it met gate-lantern-face-core -- calls the desk
# arity 1 and walks free. The scan reads per case, so it bites.
#
# THE LEG THAT KEEPS %310 SHUT. `silence_is_not_zero` runs a stub that prints the `EXIT:0` tail and
# nothing else against a desk declaring the answer `0`. Read by substring, `EXIT:0` satisfies a test
# for `0` and the case passes while the program said nothing at all. The scan reads the last line
# before the tail, exactly, so silence answers `<silence>` and counts wrong.
#
# EVERY PLANT PROVES ITSELF. Each mutation runs through plant_apply, which refuses by name when a
# sed matches nothing -- so a leg can never pass by testing a file it failed to break (REDS %519).

set -u

ROOT=$(pwd)
while [ ! -d "$ROOT/.git" ]; do
  if [ "$ROOT" = "/" ]; then
    echo "gate_example_control: no repository root above $(pwd)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
cd "$ROOT" || exit 2

_fd_root=$ROOT
. "$ROOT/tools/fixtures/p/plant.sh"

SCAN="$ROOT/tools/fixtures/g/gate_example_scan.sh"
[ -f "$SCAN" ] || { echo "gate_example_control: no scan at $SCAN" >&2; exit 2; }

PEN=$(mktemp -d 2>/dev/null || echo "/tmp/gate_example_control.$$")
mkdir -p "$PEN" || exit 2
trap 'rm -rf "$PEN"' EXIT INT TERM

legs=0
faults=0

note() {
  legs=$((legs + 1))
  if [ "$1" = ok ]; then
    echo "leg: $2 ok"
  else
    faults=$((faults + 1))
    echo "leg: $2 FAULT -- $3"
  fi
}

# desk NAME EXAMPLE -- write one placarded gate desk into the pen room.
desk() {
  cat > "$ROOM/$1.glow" <<DESK
::  name       $1
::  shape      n - int (@u32) -> lawful - int (@u32)
::  invariant  answers what its example says
::  example    $2
::  readers    control pen
::  nib        pen-v0
::
|=  sample=@u32
%-  double  sample
DESK
}

# worker_stub ARITY_TABLE ANSWER_MODE -- write the stub the scan asks and runs.
# ARITY_TABLE is `stem=accepts` rows; ANSWER_MODE is echo | wrong | silent | fail.
worker_stub() {
  cat > "$PEN/worker.sh" <<STUB
#!/bin/sh
set -u
MODE=$2
if [ "\${1-}" = "--arity" ]; then
  stem=\$(basename "\$2" .glow)
  echo "stem=\$stem"
  case "\$stem" in
$1
  esac
  exit 0
fi
glow=\$1
shift
case "\$MODE" in
  fail) echo "FAIL: stub refuses"; echo "EXIT:2"; exit 2 ;;
  silent) echo "EXIT:0"; exit 0 ;;
esac
# The stub answers from the desk's own example table, so a correct run is correct by construction
# and a wrong one is planted deliberately.
ex=\$(sed -n 's/^::  example  *//p' "\$glow" | head -1)
want=""
printf '%s\n' "\$ex" | sed 's/ - /\n/g' | while IFS= read -r chunk; do
  ins=\${chunk%%->*}
  ans=\${chunk#*->}
  ins=\$(printf '%s' "\$ins" | sed 's/  */ /g; s/^ //; s/ \$//')
  ans=\$(printf '%s' "\$ans" | tr -d ' ')
  if [ "\$ins" = "\$*" ]; then
    if [ "\$MODE" = wrong ]; then
      echo "999"
    else
      echo "\$ans"
    fi
  fi
done
echo "EXIT:0"
exit 0
STUB
  chmod +x "$PEN/worker.sh"
}

run_scan() {
  GATE_EXAMPLE_DIR="$ROOM" GATE_EXAMPLE_WORKER="$PEN/worker.sh" sh "$SCAN" "$@" > "$PEN/out" 2>"$PEN/err"
  echo $?
}

read_field() {
  sed -n "s/^$1=//p" "$PEN/out" | head -1
}

fresh_room() {
  rm -rf "$PEN/room"
  mkdir -p "$PEN/room"
  ROOM="$PEN/room"
}

# ---- a clean room reads what stands in it -----------------------------------------------------
fresh_room
desk gate-alpha-u32 "3 -> 1 - 9 -> 0"
desk gate-beta-u32 "4 -> 1"
worker_stub '    gate-alpha-u32|gate-beta-u32) echo "accepts=1" ;;' echo
rc=$(run_scan)
[ "$rc" = 0 ] && [ "$(read_field verdict)" = ok ] \
  && note ok clean_room_verdict \
  || note fault clean_room_verdict "exit $rc verdict $(read_field verdict)"
[ "$(read_field desks)" = 2 ] && note ok clean_room_desks || note fault clean_room_desks "desks $(read_field desks)"
[ "$(read_field cases)" = 3 ] && note ok clean_room_cases || note fault clean_room_cases "cases $(read_field cases)"
[ "$(read_field machine_tabled)" = 2 ] && note ok clean_room_tabled || note fault clean_room_tabled "machine_tabled $(read_field machine_tabled)"

# ---- prose is reported and never refused ------------------------------------------------------
cp "$ROOM/gate-beta-u32.glow" "$PEN/beta.before"
plant_apply "$ROOM/gate-beta-u32.glow" 's/^::  example    4 -> 1$/::  example    argv 4 -> 10 (inc of 3)/' prose_example || faults=$((faults + 1))
rc=$(run_scan)
[ "$rc" = 0 ] && [ "$(read_field prose_tabled)" = 1 ] && [ "$(read_field verdict)" = ok ] \
  && note ok prose_reported_never_gated \
  || note fault prose_reported_never_gated "exit $rc prose $(read_field prose_tabled) verdict $(read_field verdict)"
[ "$(read_field cases)" = 2 ] && note ok prose_cases_not_counted || note fault prose_cases_not_counted "cases $(read_field cases)"
cp "$PEN/beta.before" "$ROOM/gate-beta-u32.glow"
rc=$(run_scan)
[ "$(read_field prose_tabled)" = 0 ] && note ok prose_lifts || note fault prose_lifts "prose $(read_field prose_tabled)"

# ---- an example line absent is not a placard -------------------------------------------------
fresh_room
desk gate-alpha-u32 "3 -> 1"
cat > "$ROOM/gate-bare-u32.glow" <<'BARE'
::  Thin bartis with no placard at all, the shape three desks of the live room take.
|=  sample=@u32
%-  inc  sample
BARE
worker_stub '    gate-alpha-u32|gate-bare-u32) echo "accepts=1" ;;' echo
rc=$(run_scan)
[ "$rc" = 0 ] && [ "$(read_field desks)" = 2 ] && [ "$(read_field placarded)" = 1 ] \
  && note ok unplacarded_counted_apart \
  || note fault unplacarded_counted_apart "desks $(read_field desks) placarded $(read_field placarded)"

# ---- arity the worker does not accept ---------------------------------------------------------
fresh_room
desk gate-alpha-u32 "3 5 -> 1"
worker_stub '    gate-alpha-u32) echo "accepts=1" ;;' echo
rc=$(run_scan)
[ "$rc" = 1 ] && [ "$(read_field verdict)" = arity_unaccepted ] && [ "$(read_field arity_unaccepted)" = 1 ] \
  && note ok arity_unaccepted_bites \
  || note fault arity_unaccepted_bites "exit $rc verdict $(read_field verdict)"
grep -q '^unaccepted: gate-alpha-u32 case 3 5 -> 1 takes 2 input(s), accepts=1$' "$PEN/out" \
  && note ok arity_unaccepted_names_the_case \
  || note fault arity_unaccepted_names_the_case "no named case in the printout"
worker_stub '    gate-alpha-u32) echo "accepts=2" ;;' echo
rc=$(run_scan)
[ "$rc" = 0 ] && [ "$(read_field verdict)" = ok ] \
  && note ok arity_unaccepted_lifts \
  || note fault arity_unaccepted_lifts "exit $rc verdict $(read_field verdict)"

# ---- a set of accepted arities, and the per-case reading --------------------------------------
fresh_room
desk gate-mixed-u32 "1 38 -> 1 - 2 2 5 -> 0"
worker_stub '    gate-mixed-u32) echo "accepts=2 3" ;;' echo
rc=$(run_scan)
[ "$rc" = 0 ] && [ "$(read_field verdict)" = ok ] && [ "$(read_field cases)" = 2 ] \
  && note ok mixed_arity_welcome \
  || note fault mixed_arity_welcome "exit $rc verdict $(read_field verdict)"
worker_stub '    gate-mixed-u32) echo "accepts=2" ;;' echo
rc=$(run_scan)
[ "$rc" = 1 ] && [ "$(read_field arity_unaccepted)" = 1 ] \
  && note ok first_case_only_would_miss \
  || note fault first_case_only_would_miss "exit $rc unaccepted $(read_field arity_unaccepted)"

# ---- a stem the worker cannot answer for ------------------------------------------------------
fresh_room
desk gate-alpha-u32 "3 -> 1"
worker_stub '    gate-nobody) echo "accepts=1" ;;' echo
rc=$(run_scan)
[ "$rc" = 1 ] && [ "$(read_field verdict)" = arity_unreadable ] \
  && note ok arity_unreadable_bites \
  || note fault arity_unreadable_bites "exit $rc verdict $(read_field verdict)"
grep -q '^unreadable: gate-alpha-u32$' "$PEN/out" \
  && note ok arity_unreadable_names_the_desk \
  || note fault arity_unreadable_names_the_desk "no named desk"
worker_stub '    gate-alpha-u32) echo "accepts=1" ;;' echo
rc=$(run_scan)
[ "$rc" = 0 ] && note ok arity_unreadable_lifts || note fault arity_unreadable_lifts "exit $rc"

# ---- the run half -----------------------------------------------------------------------------
fresh_room
desk gate-alpha-u32 "3 -> 1 - 9 -> 0"
worker_stub '    gate-alpha-u32) echo "accepts=1" ;;' echo
rc=$(run_scan --run)
[ "$rc" = 0 ] && [ "$(read_field ran)" = 2 ] && [ "$(read_field answers_wrong)" = 0 ] \
  && note ok run_every_case \
  || note fault run_every_case "exit $rc ran $(read_field ran) wrong $(read_field answers_wrong)"
[ "$(read_field ran)" = "$(read_field cases)" ] \
  && note ok run_drops_nothing \
  || note fault run_drops_nothing "ran $(read_field ran) of cases $(read_field cases)"
[ "$(grep -c '^ran: ' "$PEN/out")" = 2 ] \
  && note ok run_names_each_case \
  || note fault run_names_each_case "named $(grep -c '^ran: ' "$PEN/out") of 2"
grep -q '^ran: gate-alpha-u32 9 -> 0$' "$PEN/out" \
  && note ok run_line_carries_the_answer \
  || note fault run_line_carries_the_answer "no case line naming its answer"

worker_stub '    gate-alpha-u32) echo "accepts=1" ;;' wrong
rc=$(run_scan --run)
[ "$rc" = 1 ] && [ "$(read_field verdict)" = answers_wrong ] && [ "$(read_field answers_wrong)" = 2 ] \
  && note ok answers_wrong_bites \
  || note fault answers_wrong_bites "exit $rc verdict $(read_field verdict) wrong $(read_field answers_wrong)"
grep -q '^answer_wrong: gate-alpha-u32 3 -> declared 1, answered 999$' "$PEN/out" \
  && note ok answers_wrong_names_both \
  || note fault answers_wrong_names_both "no named answer"

# a desk declaring the answer 0, run by a program that says nothing: `EXIT:0` must not stand in.
fresh_room
desk gate-zero-u32 "7 -> 0"
worker_stub '    gate-zero-u32) echo "accepts=1" ;;' silent
rc=$(run_scan --run)
[ "$rc" = 1 ] && [ "$(read_field answers_wrong)" = 1 ] \
  && note ok silence_is_not_zero \
  || note fault silence_is_not_zero "exit $rc wrong $(read_field answers_wrong)"
grep -q 'answered <silence>' "$PEN/out" \
  && note ok silence_named_as_silence \
  || note fault silence_named_as_silence "silence not named"

worker_stub '    gate-zero-u32) echo "accepts=1" ;;' fail
rc=$(run_scan --run)
[ "$rc" = 1 ] && [ "$(read_field verdict)" = run_failed ] && [ "$(read_field run_failed)" = 1 ] \
  && note ok run_failed_named \
  || note fault run_failed_named "exit $rc verdict $(read_field verdict)"

worker_stub '    gate-zero-u32) echo "accepts=1" ;;' echo
rc=$(run_scan --run)
[ "$rc" = 0 ] && [ "$(read_field answers_wrong)" = 0 ] \
  && note ok run_half_lifts \
  || note fault run_half_lifts "exit $rc wrong $(read_field answers_wrong)"

# ---- the free readings never run anything -----------------------------------------------------
rc=$(run_scan)
[ "$(read_field run)" = no ] && [ "$(read_field ran)" = 0 ] \
  && note ok free_reading_runs_nothing \
  || note fault free_reading_runs_nothing "run $(read_field run) ran $(read_field ran)"

# ---- bounds and absences ----------------------------------------------------------------------
fresh_room
long=$(awk 'BEGIN{ s="1 -> 1"; for (i = 0; i < 80; i++) s = s " - 1 -> 1"; print s }')
desk gate-long-u32 "$long"
worker_stub '    gate-long-u32) echo "accepts=1" ;;' echo
rc=$(run_scan)
[ "$rc" = 2 ] && note ok case_bound_refuses || note fault case_bound_refuses "exit $rc"

fresh_room
worker_stub '    gate-none) echo "accepts=1" ;;' echo
rc=$(run_scan)
[ "$rc" = 0 ] && [ "$(read_field desks)" = 0 ] && [ "$(read_field verdict)" = ok ] \
  && note ok empty_room_is_honest \
  || note fault empty_room_is_honest "exit $rc desks $(read_field desks)"

rc=$(GATE_EXAMPLE_DIR="$PEN/absent" GATE_EXAMPLE_WORKER="$PEN/worker.sh" sh "$SCAN" >/dev/null 2>&1; echo $?)
[ "$rc" = 2 ] && note ok absent_room_refuses || note fault absent_room_refuses "exit $rc"
rc=$(GATE_EXAMPLE_DIR="$ROOM" GATE_EXAMPLE_WORKER="$PEN/absent.sh" sh "$SCAN" >/dev/null 2>&1; echo $?)
[ "$rc" = 2 ] && note ok absent_worker_refuses || note fault absent_worker_refuses "exit $rc"
rc=$(GATE_EXAMPLE_DIR="$ROOM" GATE_EXAMPLE_WORKER="$PEN/worker.sh" sh "$SCAN" --nonsense >/dev/null 2>&1; echo $?)
[ "$rc" = 2 ] && note ok unknown_argument_refuses || note fault unknown_argument_refuses "exit $rc"

echo "legs=$legs"
echo "faults=$faults"
if [ "$faults" -gt 0 ]; then
  echo "control_verdict=faults"
  exit 1
fi
echo "control_verdict=ok"
