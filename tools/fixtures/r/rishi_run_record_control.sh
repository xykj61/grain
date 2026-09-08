#!/bin/sh
# tools/fixtures/r/rishi_run_record_control.sh -- prove the run-record reading from both sides.
#
# Every refusal is planted and then LIFTED, and every welcome is asserted as hard as every refusal,
# because a refusal proven only in the passing direction cannot be told from a bypass. The wall
# stands at zero, so it is shown at the wall and one claim past it.
#
# The field set is DERIVED rather than spelled, so the control plants a pen source carrying a fifth
# field and asserts the reading follows the source. A guard that hard-coded `out,err,code,ok` would
# be a fifth copy of the claim it exists to check, and this leg is what proves it is not.
#
# The pen is named by mktemp, because eight checkouts share one /tmp and a constant name is a name
# every ship chose (the shared-pen law).
#
#   sh tools/fixtures/r/rishi_run_record_control.sh

set -u
root=$(pwd -P)
scan="$root/tools/fixtures/r/rishi_run_record_scan.sh"
[ -f "$scan" ] || { echo "control_verdict=no_scan"; echo "refused: the scan under test is absent" >&2; exit 1; }

pen=$(mktemp -d "${TMPDIR:-/tmp}/rishi_run_record_control.XXXXXX") || { echo "control_verdict=no_pen"; exit 1; }
trap 'rm -rf "$pen"' EXIT INT TERM

faults=0
behaviors=0
say() { echo "$1"; }
claim() { # name expected actual
  behaviors=$((behaviors + 1))
  if [ "$2" = "$3" ]; then say "$1=yes"; else say "$1=no ($3, wanted $2)"; faults=$((faults + 1)); fi
}

# A pen tree carries a real implementation and one innocent law page, so every reading below is
# taken over a population that is never empty -- an empty page set would read zero and hide a
# miscount.
newtree() { # name [extra field]
  d="$pen/$1"
  rm -rf "$d"; mkdir -p "$d/rishi/src" "$d/.claude/rules" "$d/.cursor/rules" "$d/context"
  {
    printf 'fn run_result_record(allocator: std.mem.Allocator, result: std.process.RunResult) EvalError!Value {\n'
    printf '    fields[0] = .{ .name = "out", .value = .{ .string = result.stdout } };\n'
    printf '    fields[1] = .{ .name = "err", .value = .{ .string = result.stderr } };\n'
    printf '    fields[2] = .{ .name = "code", .value = .{ .int = code } };\n'
    printf '    fields[3] = .{ .name = "ok", .value = .{ .boolean = code == 0 } };\n'
    [ -n "${2:-}" ] && printf '    fields[4] = .{ .name = "%s", .value = .{ .boolean = true } };\n' "$2"
    printf '}\n'
  } > "$d/rishi/src/main.rye"
  printf -- '- **Rishi** -- `run` returns `{ out, err, code, ok }`; check `ok` before trusting `out`.\n' \
    > "$d/.claude/rules/tame-guidance.md"
}
plant() { printf '%s\n' "$2" >> "$pen/$1/.claude/rules/tame-guidance.md"; }
readout() { # tree key [mode]
  ( cd "$root" && RISHI_RUN_RECORD_ROOT="$pen/$1" sh "$scan" ${3:-} 2>/dev/null ) |
    sed -n "s/^$2=//p" | head -1
}
exitof() { # tree
  ( cd "$root" && RISHI_RUN_RECORD_ROOT="$pen/$1" sh "$scan" >/dev/null 2>&1 ); echo $?
}
listing() { # tree
  ( cd "$root" && RISHI_RUN_RECORD_ROOT="$pen/$1" sh "$scan" --list 2>/dev/null )
}

# The clean page states four fields and one check clause, so five claims are SEEN and none is
# unknown -- the diagnosis count and the gate count are different readings and must not collapse.
# --- a clean tree reads zero, names its verdict, and passes free ------------------------------
newtree clean
claim clean_claims_zero 0 "$(readout clean claims_unknown_field)"
claim clean_verdict_ok ok "$(readout clean verdict)"
claim clean_free 0 "$(exitof clean)"
claim clean_fields_four 4 "$(readout clean derived_fields_n)"
claim clean_fields_named "code,err,ok,out" "$(readout clean derived_fields)"
claim clean_claim_sites_seen 5 "$(readout clean claim_sites)"

# --- the field set follows the SOURCE, never a list typed into the scan ------------------------
newtree derived verdict
claim derived_fields_five 5 "$(readout derived derived_fields_n)"
claim derived_fifth_named "code,err,ok,out,verdict" "$(readout derived derived_fields)"

# --- the fault as it actually stood: a brace list naming a field that does not exist -----------
newtree shape
plant shape '| **Rishi** | `run` always returns `{ status, out, err }`. Check `status` before trusting `out`. |'
claim shape_counted 2 "$(readout shape claims_unknown_field)"
claim shape_verdict over_wall "$(readout shape verdict)"
claim shape_refused 1 "$(exitof shape)"
claim shape_named yes "$(listing shape | grep -c 'tame-guidance.md.*status' >/dev/null 2>&1 && echo yes || echo no)"

# --- and lifting the plant returns the reading to zero -----------------------------------------
newtree shape_lifted
claim shape_lifted_zero 0 "$(readout shape_lifted claims_unknown_field)"
claim shape_lifted_free 0 "$(exitof shape_lifted)"

# --- the check clause alone, with no brace list beside it --------------------------------------
newtree check
plant check 'Rishi note: with `run`, check `status`/`.ok` before trusting `out`.'
claim check_counted 1 "$(readout check claims_unknown_field)"
claim check_refused 1 "$(exitof check)"

# --- a page may compress: naming FEWER fields than exist is not a fault ------------------------
newtree fewer
plant fewer 'Short form: `run` gives `{ out, ok }`.'
claim fewer_free 0 "$(readout fewer claims_unknown_field)"
claim fewer_passes 0 "$(exitof fewer)"

# --- an erratum keeps the wrong belief visible on purpose, and is read past ---------------------
newtree erratum
plant erratum '**Erratum `20260729.214600`** -- this section read `{ status, out, err }` and the field is `ok`.'
claim erratum_free 0 "$(readout erratum claims_unknown_field)"
claim erratum_passes 0 "$(exitof erratum)"

# --- and the erratum rule is not a door: a live wrong claim in the same file still counts -------
plant erratum 'Live claim: `run` returns `{ status, out }`.'
claim erratum_rule_not_a_door 1 "$(readout erratum claims_unknown_field)"

# --- ordinary English is not a claim about this record -----------------------------------------
newtree prose
plant prose 'With `run`, check before trusting `out`, and read the record it returns.'
plant prose 'A witness may run a scan and { compare, contrast } its two channels.'
claim prose_free 0 "$(readout prose claims_unknown_field)"
claim prose_passes 0 "$(exitof prose)"

# --- dated testimony keeps every word it wrote --------------------------------------------------
newtree dated
printf '`run` returns `{ status, out, err }`.\n' > "$pen/dated/.claude/rules/20260101-000000_elder-note.md"
claim dated_free 0 "$(readout dated claims_unknown_field)"
claim dated_absent_from_listing 0 "$(listing dated | grep -c 'elder-note' || true)"

# --- three refusals for a tree that cannot answer -----------------------------------------------
newtree nosource
rm -f "$pen/nosource/rishi/src/main.rye"
claim no_source_refused no_source "$(readout nosource verdict)"
claim no_source_exit 1 "$(exitof nosource)"

newtree nofields
printf 'fn run_result_record(allocator: std.mem.Allocator) EvalError!Value {\n}\n' > "$pen/nofields/rishi/src/main.rye"
claim no_fields_refused no_fields "$(readout nofields verdict)"

claim no_root_refused no_root "$( ( cd "$root" && RISHI_RUN_RECORD_ROOT="$pen/absent-tree" sh "$scan" 2>/dev/null ) | sed -n 's/^verdict=//p' | head -1 )"

# --- the interpreter is a build artifact: its absence is reported, never gated ------------------
claim metal_absent_reported absent "$(readout clean metal)"
claim metal_absent_still_gates over_wall "$(readout shape verdict)"

say "behaviors=$behaviors"
say "faults=$faults"
if [ "$faults" -eq 0 ]; then say "control_verdict=proven"; else say "control_verdict=disagrees"; exit 1; fi
exit 0
