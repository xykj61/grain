#!/bin/sh
# rishi_brief_control.sh -- the bounded capture fields, shown answering every way they can.
#
#   sh tools/fixtures/r/rishi_brief_control.sh
#
# WHY THEY EXIST (REDS %740). Composing a WHOLE capture into an `assert ... else` message drops it
# in silence past 4,096 bytes: the composed string emits the literal `${x.out}` rather than the
# value, a truncation, or a named refusal. So the reason is lost exactly when there is most of it.
# `out_brief` and `err_brief` are the same captures bounded to 512 bytes, which fit.
#
# EVERY LEG IS PROVEN FROM BOTH SIDES -- a capture under the bound arrives whole and UNMARKED, and
# one over it arrives cut and SAID. A brief proven only on long input cannot be told from a field
# that always truncates.
set -eu

root=$(cd "$(dirname "$0")/../../.." && pwd -P)
cd "$root"
rishi=${RISHI_BIN:-rishi/bin/rishi}
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT
legs=0
faults=0
note() {
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then echo "leg $1=ok"
  else echo "leg $1=FAULT want=$2 got=$3"; faults=$((faults + 1)); fi
}

# say <n> <stream> <field> -- run a script whose capture is n bytes on that stream, print the message
say_brief() {
  n=$1; stream=$2; field=$3
  if [ "$stream" = err ]; then redir='>&2'; else redir=''; fi
  cat > "$pen/s.rish" <<RISH
let probe = run ["sh" "-c" "head -c $n /dev/zero | tr '\\0' 'x' $redir; exit 1"]
assert probe.ok else "MSG:\${probe.$field}"
RISH
  "$rishi" run "$pen/s.rish" 2>&1 | head -1
}

# ---- UNDER the bound: whole, and no elision marker
m=$(say_brief 100 err err_brief)
note short_err_whole yes "$(printf '%s' "$m" | grep -qE 'MSG:x{100}$' && echo yes || echo no)"
note short_err_unmarked yes "$(printf '%s' "$m" | grep -q 'more bytes' && echo no || echo yes)"

m=$(say_brief 100 out out_brief)
note short_out_whole yes "$(printf '%s' "$m" | grep -qE 'MSG:x{100}$' && echo yes || echo no)"
note short_out_unmarked yes "$(printf '%s' "$m" | grep -q 'earlier bytes' && echo no || echo yes)"

# ---- OVER the bound: cut, and the elision SAID with its size
m=$(say_brief 20000 err err_brief)
note long_err_said yes "$(printf '%s' "$m" | grep -q '\[19488 more bytes\]' && echo yes || echo no)"
note long_err_not_literal yes "$(printf '%s' "$m" | grep -q '${probe' && echo no || echo yes)"

m=$(say_brief 20000 out out_brief)
note long_out_said yes "$(printf '%s' "$m" | grep -q 'earlier bytes' && echo yes || echo no)"
note long_out_not_literal yes "$(printf '%s' "$m" | grep -q '${probe' && echo no || echo yes)"

# ---- THE CLIFF ITSELF, from both sides: the WHOLE capture still fails past 4,096, which is why
# the briefs exist -- and the brief at the same size does not.
cat > "$pen/whole.rish" <<'RISH'
let probe = run ["sh" "-c" "head -c 20000 /dev/zero | tr '\0' 'x' >&2; exit 1"]
assert probe.ok else "MSG:${probe.err}"
RISH
w=$("$rishi" run "$pen/whole.rish" 2>&1 | head -1)
note whole_still_literal yes "$(printf '%s' "$w" | grep -q '${probe.err}' && echo yes || echo no)"

# ---- the head keeps the FIRST bytes and the tail keeps the LAST, which is the whole reason there
# are two fields rather than one.
cat > "$pen/ends.rish" <<'RISH'
let probe = run ["sh" "-c" "printf 'FIRST-WORD\n' >&2; head -c 20000 /dev/zero | tr '\0' 'y' >&2; exit 1"]
assert probe.ok else "MSG:${probe.err_brief}"
RISH
note head_keeps_first yes "$("$rishi" run "$pen/ends.rish" 2>&1 | grep -q 'FIRST-WORD' && echo yes || echo no)"

cat > "$pen/ends2.rish" <<'RISH'
let probe = run ["sh" "-c" "head -c 20000 /dev/zero | tr '\0' 'y'; printf '\nLAST-WORD\n'; exit 1"]
assert probe.ok else "MSG:${probe.out_brief}"
RISH
note tail_keeps_last yes "$("$rishi" run "$pen/ends2.rish" 2>&1 | grep -q 'LAST-WORD' && echo yes || echo no)"

# ---- the whole captures are UNTOUCHED beside the briefs, so nothing that reads every byte loses it
cat > "$pen/whole2.rish" <<'RISH'
let probe = run ["sh" "-c" "head -c 20000 /dev/zero | tr '\0' 'x'; exit 1"]
assert probe.out contains "xxxx" else "the whole capture went missing"
say "WHOLE-OK"
RISH
note whole_capture_kept WHOLE-OK "$("$rishi" run "$pen/whole2.rish" 2>&1 | grep -o 'WHOLE-OK' | head -1)"

# ---- an empty capture is empty rather than marked
cat > "$pen/empty.rish" <<'RISH'
let probe = run ["sh" "-c" "exit 1"]
assert probe.ok else "MSG:${probe.err_brief}END"
RISH
note empty_unmarked yes "$("$rishi" run "$pen/empty.rish" 2>&1 | grep -q 'MSG:END' && echo yes || echo no)"

echo "legs=$legs"
echo "faults=$faults"
if [ "$faults" -eq 0 ]; then echo "verdict=ok"; else echo "verdict=fault"; fi
