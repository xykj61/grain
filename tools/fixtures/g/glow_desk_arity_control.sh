#!/bin/sh
# tools/fixtures/g/glow_desk_arity_control.sh -- prove glow_desk_arity_scan.sh on planted rooms.
#
# WHY A CONTROL. The scan's whole worth is that it refuses. A refusal proven only in the passing
# direction cannot be told from a bypass, so every gate below is planted, watched to bite, and
# then lifted and watched to go quiet. The pen holds miniature desk rooms and a stub worker
# shaped like the real one -- `case` pattern lines for the permission reading, `--arity` for the
# count -- so the scan is asked its own questions rather than the real corpus's.
#
# THE ONE CASE THAT IS ABOUT THE SCAN'S ARITHMETIC RATHER THAN ITS GATES: a stub lowering that
# emits two argv gates, a floor of one and a payload of two, standing for the tag families. The
# scan must read the MAXIMUM. Reading the first gate is what called four real desks split when
# nothing was wrong, so that reading is planted here and shown green.
#
#   sh tools/fixtures/g/glow_desk_arity_control.sh

set -eu

_fd_root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$_fd_root"

SCAN=tools/fixtures/g/glow_desk_arity_scan.sh
PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM
export LC_ALL=C

legs=0
failed=0

check() {
  legs=$((legs + 1))
  if [ "$1" = "$2" ]; then
    echo "leg ok   -- $3"
  else
    failed=$((failed + 1))
    echo "leg FAIL -- $3 (wanted '$1', read '$2')"
  fi
}

field() { sed -n "s/^$2=//p" "$1" | head -1; }

# A stub worker: the permission list lives in `case` pattern lines exactly as the real one's does,
# and --arity prints one `accepts=` line. ARITY_SILENT makes it answer nothing, which is the
# instrument-cannot-answer leg.
make_worker() {
  cat > "$1" <<'W'
#!/bin/sh
set -eu
if [ "${1-}" = "--arity" ]; then
  shift
  stem=$(basename "$1" .glow)
  if [ -n "${ARITY_SILENT-}" ]; then exit 0; fi
  case "$stem" in
  pen-one) echo "stem=$stem"; echo "accepts=1" ;;
  pen-two) echo "stem=$stem"; echo "accepts=2" ;;
  pen-tag) echo "stem=$stem"; echo "accepts=1 2" ;;
  *) echo "stem=$stem"; echo "accepts=0" ;;
  esac
  exit 0
fi
case "$1" in
pen-one|pen-two|pen-tag)
  exit 0
  ;;
*)
  exit 2
  ;;
esac
W
  chmod +x "$1"
}

# A stub lowering: prints the path of a file holding the argv gates the emitted program would
# carry, chosen per stem, so the scan's reading of the emitted Rye is exercised with no Zig.
make_lower() {
  cat > "$1" <<'L'
#!/bin/sh
set -eu
shift
stem=$(basename "$1" .glow)
out="$PEN_OUT/$stem.rye"
case "$stem" in
pen-one) printf '    if (argv.len < 2) return 2;\n' > "$out" ;;
pen-two) printf '    if (argv.len < 3) return 2;\n' > "$out" ;;
pen-tag)  printf '    if (argv.len < 2) return 2;\n    if (argv.len < 3) return 2;\n' > "$out" ;;
pen-quiet) : > "$out" ;;
*) : > "$out" ;;
esac
echo "$out"
L
  chmod +x "$1"
}

desk() {
  # desk <room> <stem> <sample-line-or-empty>
  if [ -n "$3" ]; then
    printf ':: pen desk\n::  Sample: %s\n^-  @u32\n' "$3" > "$1/$2.glow"
  else
    printf ':: pen desk\n^-  @u32\n' > "$1/$2.glow"
  fi
}

run() {
  # run <room> <out> [env...]
  room=$1; out=$2; shift 2
  env GLOW_DESK_DIR="$room" GLOW_DESK_WORKER="$PEN/worker.sh" \
      GLOW_ARITY_LOWER="$PEN/lower.sh" PEN_OUT="$PEN/emit" "$@" \
      sh "$SCAN" --explain > "$out" 2>&1 || true
}

mkdir -p "$PEN/emit"
make_worker "$PEN/worker.sh"
make_lower "$PEN/lower.sh"

# ---- the agreeing room -------------------------------------------------------------------
A="$PEN/agree"; mkdir -p "$A"
desk "$A" pen-one "7"
desk "$A" pen-two "3 5"
desk "$A" pen-tag "mint 7"
desk "$A" pen-plain ""
run "$A" "$PEN/o.agree"
check 4 "$(field "$PEN/o.agree" desks)" "the room's whole population is counted"
check 3 "$(field "$PEN/o.agree" permitted)" "only the worker's permitted stems are read for arity"
check 3 "$(field "$PEN/o.agree" declared)" "a permitted desk carrying a Sample line is declared"
check 0 "$(field "$PEN/o.agree" faults)" "three agreeing statements read no fault"
check agree "$(field "$PEN/o.agree" verdict)" "the agreeing room's verdict is agree"
check 3 "$(field "$PEN/o.agree" lowering_read)" "each permitted desk's lowering answered"
check 0 "$(field "$PEN/o.agree" lowering_split)" "the tag desk agrees on its MAXIMUM gate, not its first"

# ---- contract_split: the head and the worker disagree -------------------------------------
C="$PEN/contract"; mkdir -p "$C"
desk "$C" pen-one "7 9"
run "$C" "$PEN/o.contract"
check 1 "$(field "$PEN/o.contract" contract_split)" "a head declaring more than the worker accepts bites"
check split "$(field "$PEN/o.contract" verdict)" "contract_split turns the verdict"
grep -q 'detail: contract_split' "$PEN/o.contract" \
  && check yes yes "the split names the desk under --explain" \
  || check yes no "the split names the desk under --explain"
desk "$C" pen-one "7"
run "$C" "$PEN/o.contract2"
check 0 "$(field "$PEN/o.contract2" contract_split)" "lifting the plant returns contract_split to zero"
check agree "$(field "$PEN/o.contract2" verdict)" "lifting the plant returns the verdict to agree"

# ---- sample_unpermitted: a promise the worker would refuse ---------------------------------
U="$PEN/unpermitted"; mkdir -p "$U"
desk "$U" pen-stranger "4"
run "$U" "$PEN/o.unpermitted"
check 1 "$(field "$PEN/o.unpermitted" sample_unpermitted)" "a Sample line on an unpermitted stem bites"
check 0 "$(field "$PEN/o.unpermitted" permitted)" "an unpermitted desk is never counted as permitted"
check split "$(field "$PEN/o.unpermitted" verdict)" "sample_unpermitted turns the verdict"
desk "$U" pen-stranger ""
run "$U" "$PEN/o.unpermitted2"
check 0 "$(field "$PEN/o.unpermitted2" sample_unpermitted)" "dropping the Sample line goes quiet"

# ---- arity_unanswered: the instrument that cannot answer ------------------------------------
run "$A" "$PEN/o.silent" ARITY_SILENT=1
check 3 "$(field "$PEN/o.silent" arity_unanswered)" "a worker naming no count is a fault, not a pass"
check split "$(field "$PEN/o.silent" verdict)" "an unanswered arity turns the verdict"
check 0 "$(field "$PEN/o.silent" declared)" "an unanswered desk is not read further"

# ---- lowering_split: the head and the emitted program disagree ------------------------------
L2="$PEN/lowering"; mkdir -p "$L2"
desk "$L2" pen-two "3 5"
run "$L2" "$PEN/o.lower"
check 0 "$(field "$PEN/o.lower" lowering_split)" "a head matching the emitted gate reads no split"
cat > "$PEN/emit_override" <<'X'
X
cp "$PEN/lower.sh" "$PEN/lower_orig.sh"
cat > "$PEN/lower.sh" <<'L3'
#!/bin/sh
set -eu
shift
stem=$(basename "$1" .glow)
out="$PEN_OUT/$stem.rye"
printf '    if (argv.len < 2) return 2;\n' > "$out"
echo "$out"
L3
chmod +x "$PEN/lower.sh"
run "$L2" "$PEN/o.lower2"
check 1 "$(field "$PEN/o.lower2" lowering_split)" "a program reading fewer arguments than the head declares bites"
check 0 "$(field "$PEN/o.lower2" contract_split)" "the worker still agrees, so only the lowering gate fires"
check split "$(field "$PEN/o.lower2" verdict)" "lowering_split turns the verdict"
cp "$PEN/lower_orig.sh" "$PEN/lower.sh"
run "$L2" "$PEN/o.lower3"
check 0 "$(field "$PEN/o.lower3" lowering_split)" "restoring the lowering returns the split to zero"

# ---- lowering_unread: reported, never gated --------------------------------------------------
Q="$PEN/quiet"; mkdir -p "$Q"
desk "$Q" pen-one "7"
cat > "$PEN/lower.sh" <<'L4'
#!/bin/sh
set -eu
shift
stem=$(basename "$1" .glow)
out="$PEN_OUT/$stem.rye"
: > "$out"
echo "$out"
L4
chmod +x "$PEN/lower.sh"
run "$Q" "$PEN/o.quiet"
check 1 "$(field "$PEN/o.quiet" lowering_unread)" "a lowering emitting no argv gate is counted"
check 0 "$(field "$PEN/o.quiet" lowering_split)" "an unread lowering never invents a split"
check 0 "$(field "$PEN/o.quiet" faults)" "lowering_unread is reported rather than gated"
check agree "$(field "$PEN/o.quiet" verdict)" "an unread lowering leaves the verdict alone"
cp "$PEN/lower_orig.sh" "$PEN/lower.sh"

# ---- refusals ---------------------------------------------------------------------------------
env GLOW_DESK_DIR="$PEN/absent-room" GLOW_DESK_WORKER="$PEN/worker.sh" \
  sh "$SCAN" > "$PEN/o.noroom" 2>&1 && rc=0 || rc=$?
check 2 "$rc" "an absent desk room refuses rather than reading zero desks"
env GLOW_DESK_DIR="$A" GLOW_DESK_WORKER="$PEN/absent-worker.sh" \
  sh "$SCAN" > "$PEN/o.noworker" 2>&1 && rc=0 || rc=$?
check 2 "$rc" "an absent worker refuses rather than permitting nothing"
env GLOW_DESK_DIR="$A" GLOW_DESK_WORKER="$PEN/worker.sh" \
  sh "$SCAN" --bogus > "$PEN/o.bogus" 2>&1 && rc=0 || rc=$?
check 2 "$rc" "an unknown argument refuses"

# ---- the real worker answers every family it serves --------------------------------------------
for pair in "gate-say-u32 1" "gate-pair-max 0 2" "gate-surface-lit-area-u32 3" \
            "gate-lantern-face-core 2 3" "gate-xact-tag 1 2" "gate-xfer-tag 1 3" \
            "gate-nona-fields 9" "shape-amount 0"; do
  stem=${pair%% *}
  want=${pair#* }
  got=$(sh tools/g/glow_run_worker.sh --arity "glow/gen/x/$stem.glow" | sed -n 's/^accepts=//p')
  check "$want" "$got" "the worker states $stem's accepted count(s) when asked"
done

echo "legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=failed"
fi
