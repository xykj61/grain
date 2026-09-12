#!/bin/sh
# tools/fixtures/g/glow_run_contract_control.sh -- prove the contract scan bites.
#
# Every refusal is planted and then lifted, so a leg that passes in only one direction cannot be
# told from a bypass. The pen is proven innocent first: a faithful stub binary and an untouched head
# table read `verdict=ok`, which is what makes each later refusal mean something.
#
# The stub stands in for glow/bin/glow_run so the probe half runs in milliseconds rather than
# rebuilding a Zig binary per leg. It answers the SAME contract the module declares -- 4 with no
# file argument, 3 for a source it cannot read, 0 for one it can -- so a mutation of the stub is a
# mutation of the metal answer, which is the half a table-versus-source reading can never catch.
#
#   sh tools/fixtures/g/glow_run_contract_control.sh
set -eu
export LC_ALL=C

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
SCAN="$ROOT/tools/fixtures/g/glow_run_contract_scan.sh"
REAL="$ROOT/glow/glow_run.rye"

PEN=$(mktemp -d "${TMPDIR:-/tmp}/glow-run-contract-pen.XXXXXX")
trap 'rm -rf "$PEN"' EXIT INT TERM

legs=0
failed=0
leg() {
  _name=$1
  _want=$2
  _got=$3
  legs=$((legs + 1))
  if [ "$_got" = "$_want" ]; then
    echo "leg $_name ok"
  else
    failed=$((failed + 1))
    echo "leg $_name FAIL want=$_want got=$_got"
  fi
}

# A faithful stub: the contract, spelled in shell.
cat > "$PEN/stub" <<'STUB'
#!/bin/sh
if [ "$#" -lt 1 ]; then exit 4; fi
if [ "$1" = "--sample-argv" ]; then shift; if [ "$#" -lt 1 ]; then exit 4; fi; fi
p=$1
[ -e "$p" ] || exit 3
[ -d "$p" ] && exit 3
sz=$(wc -c < "$p")
[ "$sz" -gt 65536 ] && exit 3
exit 0
STUB
chmod +x "$PEN/stub"
printf '|-  32\n' > "$PEN/desk.glow"

run_scan() {
  env GLOW_RUN_CONTRACT_SRC="$1" \
      GLOW_RUN_CONTRACT_BIN="${2:-$PEN/stub}" \
      GLOW_RUN_CONTRACT_DESK="$PEN/desk.glow" \
      sh "$SCAN" 2>&1
}
field() { printf '%s\n' "$1" | awk -F= -v k="$2" '$1 == k { print $2; exit }'; }

# ---- the pen is innocent ----------------------------------------------------
cp "$REAL" "$PEN/src.rye"
out=$(run_scan "$PEN/src.rye")
leg innocent_verdict ok "$(field "$out" verdict)"
leg innocent_undeclared 0 "$(field "$out" undeclared_returns)"
leg innocent_unreturned 0 "$(field "$out" unreturned_declared)"
leg innocent_mismatch 0 "$(field "$out" probe_mismatch)"
leg innocent_declared 5 "$(field "$out" declared_codes)"
leg innocent_returned 5 "$(field "$out" returned_codes)"
leg innocent_probes 6 "$(field "$out" probes)"

# ---- a code returned and not declared ---------------------------------------
cp "$REAL" "$PEN/src.rye"
grep -v '^//!   3  unreadable' "$PEN/src.rye" > "$PEN/t" && mv "$PEN/t" "$PEN/src.rye"
out=$(run_scan "$PEN/src.rye")
leg undeclared_bites table_disagrees "$(field "$out" verdict)"
leg undeclared_counts 1 "$(field "$out" undeclared_returns)"
leg undeclared_names 3 "$(field "$out" undeclared_return_codes)"
cp "$REAL" "$PEN/src.rye"
leg undeclared_lifts ok "$(field "$(run_scan "$PEN/src.rye")" verdict)"

# ---- a code declared and never returned -------------------------------------
cp "$REAL" "$PEN/src.rye"
sed 's|^//!   4  usage|//!   7  invented\n//!   4  usage|' "$PEN/src.rye" > "$PEN/t" && mv "$PEN/t" "$PEN/src.rye"
out=$(run_scan "$PEN/src.rye")
leg unreturned_bites table_disagrees "$(field "$out" verdict)"
leg unreturned_counts 1 "$(field "$out" unreturned_declared)"
leg unreturned_names 7 "$(field "$out" unreturned_declared_codes)"
leg unreturned_declared_n 6 "$(field "$out" declared_codes)"
cp "$REAL" "$PEN/src.rye"
leg unreturned_lifts ok "$(field "$(run_scan "$PEN/src.rye")" verdict)"

# ---- the derivation's own precondition --------------------------------------
cp "$REAL" "$PEN/src.rye"
sed 's|^fn stem_of|fn planted_helper() u8 {\n    return 9;\n}\n\nfn stem_of|' "$PEN/src.rye" > "$PEN/t" && mv "$PEN/t" "$PEN/src.rye"
out=$(run_scan "$PEN/src.rye")
leg unsound_bites derivation_unsound "$(field "$out" verdict)"
leg unsound_counts 1 "$(field "$out" early_integer_returns)"
cp "$REAL" "$PEN/src.rye"
leg unsound_lifts ok "$(field "$(run_scan "$PEN/src.rye")" verdict)"

# ---- a source with no main --------------------------------------------------
cp "$REAL" "$PEN/src.rye"
sed 's|^pub fn main(|pub fn renamed_main(|' "$PEN/src.rye" > "$PEN/t" && mv "$PEN/t" "$PEN/src.rye"
leg no_main_bites no_main "$(field "$(run_scan "$PEN/src.rye")" verdict)"
cp "$REAL" "$PEN/src.rye"
leg no_main_lifts ok "$(field "$(run_scan "$PEN/src.rye")" verdict)"

# ---- an absent source -------------------------------------------------------
leg no_source_bites no_source "$(field "$(run_scan "$PEN/gone.rye")" verdict)"

# ---- an unbuilt binary is named, never called proven ------------------------
cp "$REAL" "$PEN/src.rye"
out=$(run_scan "$PEN/src.rye" "$PEN/no-such-binary")
leg unprobed_bites unprobed "$(field "$out" verdict)"
leg unprobed_probes 0 "$(field "$out" probes)"
leg unprobed_keeps_table 0 "$(field "$out" undeclared_returns)"

# ---- metal that disagrees with a table that agrees with itself ---------------
# The half a source-versus-table reading can never reach: the elder collision, restored.
sed 's|exit 4|exit 2|g' "$PEN/stub" > "$PEN/stub_usage2" && chmod +x "$PEN/stub_usage2"
out=$(run_scan "$PEN/src.rye" "$PEN/stub_usage2")
leg metal_usage_bites metal_disagrees "$(field "$out" verdict)"
leg metal_usage_counts 2 "$(field "$out" probe_mismatch)"
leg metal_usage_table_clean 0 "$(field "$out" undeclared_returns)"

sed 's|exit 3|exit 1|g' "$PEN/stub" > "$PEN/stub_read1" && chmod +x "$PEN/stub_read1"
out=$(run_scan "$PEN/src.rye" "$PEN/stub_read1")
leg metal_read_bites metal_disagrees "$(field "$out" verdict)"
leg metal_read_counts 3 "$(field "$out" probe_mismatch)"
leg metal_read_names_one 1 "$(field "$out" probe_unreadable_absent)"

leg metal_lifts ok "$(field "$(run_scan "$PEN/src.rye")" verdict)"

# ---- prose carrying a digit is not a table row ------------------------------
cp "$REAL" "$PEN/src.rye"
sed 's|^//! THE EXIT CONTRACT.*|//! An elder note: 7 desks once shared this road and 9 more followed.|' \
  "$PEN/src.rye" > "$PEN/t" && mv "$PEN/t" "$PEN/src.rye"
out=$(run_scan "$PEN/src.rye")
leg prose_digit_ignored 5 "$(field "$out" declared_codes)"
leg prose_digit_verdict ok "$(field "$out" verdict)"

echo "legs=$legs"
echo "control_failed=$failed"
if [ "$failed" != "0" ]; then echo "control_verdict=red"; exit 1; fi
echo "control_verdict=ok"
