#!/usr/bin/env sh
# instrument_absence_control.sh -- the pen for instrument_absence_scan.sh.
#
# Every refusal is shown from BOTH sides: the fault planted and bitten, then removed and the
# reading returned to green. A refusal proven only in the passing direction cannot be told from a
# bypass, which is this tree's own standing lesson about vacuous guards.
#
#   sh tools/fixtures/i/instrument_absence_control.sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_ac_steps=0
while [ ! -d "$ROOT/tools/fixtures" ]; do
  _ac_steps=$((_ac_steps + 1))
  if [ "$_ac_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps" >&2; exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
SCAN="$ROOT/tools/fixtures/i/instrument_absence_scan.sh"
[ -f "$SCAN" ] || { echo "control: scan absent at $SCAN" >&2; exit 2; }

pen=$(mktemp -d 2>/dev/null) || { echo "control: cannot make a pen" >&2; exit 2; }
trap 'rm -rf "$pen"' EXIT INT TERM
mkdir -p "$pen/tools/fixtures/z"

pass=0; fail=0
check() { # check <name> <wanted ok|red> <reading>
  if [ "$2" = "$3" ]; then pass=$((pass + 1)); printf 'ok    %s\n' "$1"
  else fail=$((fail + 1)); printf 'FAIL  %s -- wanted %s read %s\n' "$1" "$2" "$3"; fi
}
read_pen() { # -> ok | red, and leaves the full reading in $pen/out
  if sh "$SCAN" --root "$pen" > "$pen/out" 2>"$pen/err"; then echo ok; else echo red; fi
}
count_of() { grep "^$1=" "$pen/out" | tail -1 | cut -d= -f2; }

# ---- an empty pen reads green, so every later red is the plant rather than the pen ------------
check "empty pen is green" ok "$(read_pen)"
check "empty pen counts zero open" 0 "$(count_of blind_captures_open)"

# ---- THE FAULT, planted: a borrowed capture whose emptiness is the pass branch ----------------
cat > "$pen/tools/fixtures/z/planted_scan.sh" <<'PLANT'
#!/bin/sh
set -eu
hits="$(rg -n 'pattern' some/room 2>/dev/null || true)"
if [ -n "$hits" ]; then
  echo "$hits" >&2
  exit 1
fi
echo "GREEN: nothing found"
PLANT
check "planted blind capture refuses" red "$(read_pen)"
check "planted blind capture counted once" 1 "$(count_of blind_captures_open)"
check "planted site is named" ok "$(grep -q 'blind_capture: .*planted_scan.sh.*tool=rg' "$pen/out" && echo ok || echo red)"

# ---- ... and removed, the reading returns. A ceiling proven one way is not proven -------------
rm -f "$pen/tools/fixtures/z/planted_scan.sh"
check "plant removed returns to green" ok "$(read_pen)"

# ---- THE REPAIR frees it: asking for the instrument by name is the whole reflex ---------------
cat > "$pen/tools/fixtures/z/armed_scan.sh" <<'ARMED'
#!/bin/sh
set -eu
require_instrument rg
hits="$(rg -n 'pattern' some/room 2>/dev/null || true)"
if [ -n "$hits" ]; then exit 1; fi
echo "GREEN"
ARMED
check "armed file is green" ok "$(read_pen)"
check "armed file counted as armed" 1 "$(count_of blind_captures_armed)"
check "armed file not counted open" 0 "$(count_of blind_captures_open)"
rm -f "$pen/tools/fixtures/z/armed_scan.sh"

# ---- THE NARROWING, four ways. Each of these is innocent and must stay uncounted --------------
cat > "$pen/tools/fixtures/z/granted_scan.sh" <<'GRANTED'
#!/bin/sh
set -eu
hits="$(grep -n 'pattern' some/file 2>/dev/null || true)"
if [ -n "$hits" ]; then exit 1; fi
GRANTED
check "granted instrument uncounted" ok "$(read_pen)"
rm -f "$pen/tools/fixtures/z/granted_scan.sh"

cat > "$pen/tools/fixtures/z/carried_scan.sh" <<'CARRIED'
#!/bin/sh
set -eu
hits="$(git log --oneline 2>/dev/null || true)"
if [ -n "$hits" ]; then exit 1; fi
CARRIED
check "carried git uncounted" ok "$(read_pen)"
rm -f "$pen/tools/fixtures/z/carried_scan.sh"

cat > "$pen/tools/fixtures/z/checked_scan.sh" <<'CHECKED'
#!/bin/sh
set -eu
hits="$(rg -n 'pattern' some/room)"
if [ -n "$hits" ]; then exit 1; fi
CHECKED
check "capture that checks its status uncounted" ok "$(read_pen)"
rm -f "$pen/tools/fixtures/z/checked_scan.sh"

cat > "$pen/tools/fixtures/z/counted_scan.sh" <<'COUNTED'
#!/bin/sh
set -eu
hits="$(rg -n 'pattern' some/room 2>/dev/null || true)"
n=$(printf '%s\n' "$hits" | wc -l)
echo "n=$n"
COUNTED
check "capture never read for emptiness uncounted" ok "$(read_pen)"
rm -f "$pen/tools/fixtures/z/counted_scan.sh"

# ---- THE REAL SHAPE spans physical lines, which is why logical lines are rebuilt --------------
cat > "$pen/tools/fixtures/z/multiline_scan.sh" <<'MULTI'
#!/bin/sh
set -eu
hits="$(rg -n 'pattern' tools edu \
  --glob '!**/one/**' \
  --glob '!**/two/**' 2>/dev/null | grep -v 'context' || true)"
if [ -n "$hits" ]; then exit 1; fi
MULTI
check "multi-line capture refuses" red "$(read_pen)"
check "multi-line capture counted once" 1 "$(count_of blind_captures_open)"
rm -f "$pen/tools/fixtures/z/multiline_scan.sh"

# ---- TWO PLANTS COUNT TWICE, so the reading is a count rather than a flag ---------------------
cat > "$pen/tools/fixtures/z/two_a.sh" <<'TA'
#!/bin/sh
hits="$(jq -r '.x' f.json 2>/dev/null || true)"
if [ -z "$hits" ]; then echo empty; fi
TA
cat > "$pen/tools/fixtures/z/two_b.sh" <<'TB'
#!/bin/sh
out="$(mktemp -d 2>/dev/null || true)"
if [ -n "$out" ]; then echo made; fi
TB
check "two plants refuse" red "$(read_pen)"
check "two plants counted twice" 2 "$(count_of blind_captures_open)"
rm -f "$pen/tools/fixtures/z/two_a.sh" "$pen/tools/fixtures/z/two_b.sh"
check "both removed returns to green" ok "$(read_pen)"

# ---- THE METER OBEYS ITS OWN LAW: pointed where it cannot read, it refuses by name ------------
if sh "$SCAN" --root "$pen/nowhere" >/dev/null 2>&1; then
  check "absent root refuses" red ok
else
  check "absent root refuses" red red
fi

# ---- AND THE BEHAVIORAL PROOF, on the two sites this lap repaired, against TRUE absence.
# A shim answering 127 is not absence: `command -v` still finds it, which is the mistake this
# control exists to not repeat. The pen holds symlinks to every binary on PATH except ripgrep.
if command -v rg >/dev/null 2>&1; then
  nopath="$pen/nopath"; mkdir -p "$nopath"
  rgbin=$(command -v rg)
  IFS=:
  for d in $PATH; do
    [ -d "$d" ] || continue
    for b in "$d"/*; do
      [ -x "$b" ] || continue
      n=$(basename "$b")
      [ "$n" = rg ] && continue
      [ -e "$nopath/$n" ] || ln -s "$b" "$nopath/$n" 2>/dev/null || :
    done
  done
  unset IFS
  # The pen must be complete but for ripgrep, or a refusal below proves nothing about ripgrep.
  check "pen lacks only ripgrep" ok "$(PATH=$nopath sh -c 'command -v rg >/dev/null 2>&1 && echo red || (command -v git >/dev/null 2>&1 && command -v awk >/dev/null 2>&1 && echo ok || echo red)')"
  for s in inner_i1_twah_residual inner_i2_djin_prose; do
    f="$ROOT/tools/fixtures/i/$s.sh"
    [ -f "$f" ] || continue
    if (cd "$ROOT" && PATH=$nopath sh "$f") >/dev/null 2>&1; then
      check "$s refuses without ripgrep" red ok
    else
      check "$s refuses without ripgrep" red red
    fi
    if (cd "$ROOT" && sh "$f") >/dev/null 2>&1; then
      check "$s green with ripgrep" ok ok
    else
      check "$s green with ripgrep" ok red
    fi
  done
  ln -s "$rgbin" "$nopath/rg" 2>/dev/null || :
else
  echo "note  ripgrep absent on this host -- the behavioral legs are skipped, and said so"
fi


# ---- REDS %443: a heredoc body is FIXTURE, and the exemption is proven from both sides --------
# The meter must be able to read a control like this one without counting the plants it writes.
# An exemption proven only in the freeing direction cannot be told from a hole, so each leg below
# is paired: the same capture is freed inside a heredoc and bitten outside one.
rm -f "$pen"/tools/fixtures/z/*.sh
check "pen cleared is green again" ok "$(read_pen)"

cat > "$pen/tools/fixtures/z/fixture_scan.sh" <<'FIXT'
#!/bin/sh
set -eu
cat > /tmp/generated_probe.sh <<'INNER'
hits="$(rg -n 'pattern' some/room 2>/dev/null || true)"
if [ -n "$hits" ]; then
  exit 1
fi
INNER
echo "GREEN: wrote a probe"
FIXT
check "capture inside a heredoc does not refuse" ok "$(read_pen)"
check "capture inside a heredoc counts as fixture" 1 "$(count_of blind_captures_in_fixture)"
check "capture inside a heredoc is not counted open" 0 "$(count_of blind_captures_open)"
check "fixture capture is named in the reading" ok "$(grep -q '^fixture_capture: .*fixture_scan.sh.*tool=rg' "$pen/out" && echo ok || echo red)"

# THE PAIR. The very same two lines, outside a heredoc, must still be bitten -- otherwise the
# exemption above is a bypass wearing a reason.
cat > "$pen/tools/fixtures/z/fixture_scan.sh" <<'BARE'
#!/bin/sh
set -eu
hits="$(rg -n 'pattern' some/room 2>/dev/null || true)"
if [ -n "$hits" ]; then
  exit 1
fi
echo "GREEN: nothing found"
BARE
check "the same capture outside a heredoc refuses" red "$(read_pen)"
check "the same capture outside a heredoc counts open" 1 "$(count_of blind_captures_open)"
check "the same capture outside a heredoc is not fixture" 0 "$(count_of blind_captures_in_fixture)"
rm -f "$pen/tools/fixtures/z/fixture_scan.sh"

# ---- and the arming half of the same distinction ---------------------------------------------
# A file exempted by a `require_instrument` it merely WRITES is exempted by luck. This control's
# own source was, before %443: its plant at line 64 sits inside a heredoc, and it armed the whole
# file for the meter's live pass.
cat > "$pen/tools/fixtures/z/false_armed.sh" <<'FALSEARM'
#!/bin/sh
set -eu
cat > /tmp/generated_armed.sh <<'GEN'
require_instrument rg
GEN
hits="$(rg -n 'pattern' some/room 2>/dev/null || true)"
if [ -n "$hits" ]; then
  exit 1
fi
echo "GREEN: nothing found"
FALSEARM
check "require_instrument in a heredoc does not arm the file" red "$(read_pen)"
check "the falsely-armed capture is counted open" 1 "$(count_of blind_captures_open)"
check "the falsely-armed capture is not counted armed" 0 "$(count_of blind_captures_armed)"

# THE PAIR. The same file, asking in its OWN code, is armed and free.
cat > "$pen/tools/fixtures/z/false_armed.sh" <<'TRUEARM'
#!/bin/sh
set -eu
require_instrument rg
hits="$(rg -n 'pattern' some/room 2>/dev/null || true)"
if [ -n "$hits" ]; then
  exit 1
fi
echo "GREEN: nothing found"
TRUEARM
check "require_instrument in own code still arms the file" ok "$(read_pen)"
check "the truly-armed capture is counted armed" 1 "$(count_of blind_captures_armed)"
rm -f "$pen/tools/fixtures/z/false_armed.sh"
check "pen cleared after the %443 legs" ok "$(read_pen)"
echo "---"
echo "control_pass=$pass"
echo "control_fail=$fail"
[ "$fail" -eq 0 ] || { echo "refused: $fail control behaviors did not hold." >&2; exit 1; }
echo "verdict=ok"
