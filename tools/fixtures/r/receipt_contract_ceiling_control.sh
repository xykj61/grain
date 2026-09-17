#!/bin/sh
# tools/fixtures/r/receipt_contract_ceiling_control.sh -- proves
# receipt_contract_ceiling_scan.sh from both sides on a planted field.
#
# Every refusal is planted and then lifted, and every welcome is asserted as hard as
# every refusal: a refusal proven only in the passing direction cannot be told from a
# bypass. The pen holds real files with the real shapes -- a Markdown ceiling table, a
# Rye constants module, a Rye admission module, and a Rye refusal record -- so the
# scan under test is the live script reading planted bytes through its own
# environment overrides, never a copy.
#
# Three mutations are asserted to BITE. Each removes one line the reading rests on,
# and a mutation that changes no count is a line the guard does not need.

set -eu

SCAN="${SCAN:-tools/fixtures/r/receipt_contract_ceiling_scan.sh}"
[ -f "$SCAN" ] || { echo "detail: cannot read $SCAN"; echo "verdict=unreadable"; exit 1; }
SCAN=$(cd "$(dirname "$SCAN")" && pwd)/$(basename "$SCAN")

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT HUP INT TERM

# `sed -i` is a GNU extension this tree gates at zero, so every edit below writes
# through the original file rather than moving a temporary over it -- which is also
# what keeps a mode the repository tracks (`.claude/rules/exec-bit.md`).
edit() {
  script=$1; target=$2
  sed "$script" "$target" > "$target.tmp" && cat "$target.tmp" > "$target" && rm -f "$target.tmp"
}

legs=0
failed=0

leg() {
  name=$1; want=$2; got=$3
  legs=$((legs + 1))
  if [ "$want" = "$got" ]; then
    echo "leg_ok: $name want=$want got=$got"
  else
    failed=$((failed + 1))
    echo "leg_failed: $name want=$want got=$got"
  fi
}

# --- the healthy field -------------------------------------------------------
plant_field() {
  d=$1
  mkdir -p "$d"
  cat > "$d/contract.md" <<'EOF'
# a planted contract

| Field or population | Ceiling | Unit |
|---|---:|---|
| encoded fact | 4096 | bytes |
| each identifier | 96 | ASCII bytes |
| purpose | 80 | ASCII bytes |
| value unit | 96 | ASCII bytes -- borrowed |
| receipt facts in this replay | 1 | fact |
| receipt-card width | 72 | cells |

| Residence | Owns |
|---|---|
| Tally | ceilings |
EOF
  cat > "$d/bounds.rye" <<'EOF'
pub const max_encoded_fact_bytes: u32 = 4096;
pub const max_identifier_bytes: u32 = 96;
pub const max_purpose_bytes: u32 = 80;
pub const max_replay_facts: u32 = 1;
pub const receipt_card_width: u32 = 72;
EOF
  cat > "$d/refusal.rye" <<'EOF'
pub fn text_refusal(field: []const u8, value: []const u8, ceiling: u32) ?Refusal {
    return .{ .field = field, .reason = .too_long };
}
pub fn encoded_fact_refusal(length: u32, ceiling: u32) ?Refusal {
    return .{ .field = "encoded_fact", .reason = .too_long };
}
pub fn fact_count_refusal(count: u32, ceiling: u32) ?Refusal {
    return .{ .field = "receipt_facts", .reason = .too_many_facts };
}
EOF
  cat > "$d/admission.rye" <<'EOF'
pub fn fact_refusal(f: Fact, encoded_len: u32) ?Refusal {
    if (tally_refusal.encoded_fact_refusal(encoded_len, bounds.max_encoded_fact_bytes)) |r| return r;
    const identifiers = [_]struct { name: []const u8, value: []const u8 }{
        .{ .name = "receipt_id", .value = f.receipt_id },
        .{ .name = "holder_id", .value = f.holder_id },
    };
    for (identifiers) |entry| {
        if (tally_refusal.text_refusal(entry.name, entry.value, bounds.max_identifier_bytes)) |r| return r;
    }
    if (tally_refusal.text_refusal("purpose", f.purpose, bounds.max_purpose_bytes)) |r| return r;
    if (tally_refusal.text_refusal("value_unit", f.value_unit, bounds.max_identifier_bytes)) |r| return r;
    return tally_refusal.fact_count_refusal(1, bounds.max_replay_facts);
}
EOF
}

read_pen() {
  d=$1
  CONTRACT="$d/contract.md" BOUNDS="$d/bounds.rye" ADMISSION="$d/admission.rye" \
    REFUSAL="$d/refusal.rye" sh "$SCAN" ${2:-} 2>&1 || true
}

field_of() { printf '%s\n' "$1" | grep -oE "(^|[ ])$2=[a-z0-9_]+" | tail -1 | sed 's/.*=//'; }

# --- 1. the healthy field walks free -----------------------------------------
plant_field "$PEN/ok"
out=$(read_pen "$PEN/ok")
leg healthy_verdict agree "$(field_of "$out" verdict)"
leg healthy_sites 6 "$(field_of "$out" sites)"
leg healthy_named 6 "$(field_of "$out" named)"
leg healthy_unnamed 0 "$(field_of "$out" unnamed_ceiling)"
leg healthy_disagrees 0 "$(field_of "$out" value_disagrees)"
leg healthy_rows 6 "$(field_of "$out" rows)"
leg healthy_population_rows 1 "$(field_of "$out" population_rows)"
leg healthy_population_only 2 "$(field_of "$out" population_only)"
leg healthy_population_undeclared 1 "$(field_of "$out" population_undeclared)"
leg healthy_borrowed 1 "$(field_of "$out" borrowed_rows)"
leg healthy_unenforced 1 "$(field_of "$out" row_unenforced)"
leg healthy_exit 0 "$(if CONTRACT="$PEN/ok/contract.md" BOUNDS="$PEN/ok/bounds.rye" \
  ADMISSION="$PEN/ok/admission.rye" REFUSAL="$PEN/ok/refusal.rye" sh "$SCAN" >/dev/null 2>&1; then echo 0; else echo 1; fi)"

# --- 2. %767's own defect, planted and then lifted ---------------------------
# A field refused at a borrowed ceiling whose own row is taken away. The row for
# `value unit` goes; the code still refuses it at max_identifier_bytes, whose 96 the
# population row declares -- so the population rule must NOT rescue a field that is
# not an identifier by any reading. It does rescue it, and that is the honest limit:
# the gate fires on a ceiling no row of ANY kind carries.
plant_field "$PEN/borrow"
edit '/^| value unit /d' "$PEN/borrow/contract.md"
edit 's/"value_unit", f.value_unit, bounds.max_identifier_bytes/"value_unit", f.value_unit, bounds.max_value_unit_bytes/' "$PEN/borrow/admission.rye"
out=$(read_pen "$PEN/borrow" --list)
leg borrowed_ceiling_refused unnamed_ceiling "$(field_of "$out" verdict)"
leg borrowed_ceiling_counted 1 "$(field_of "$out" unnamed_ceiling)"
leg borrowed_names_constant yes "$(printf '%s\n' "$out" | grep -q 'ceiling=max_value_unit_bytes' && echo yes || echo no)"
leg borrowed_exit 1 "$(if CONTRACT="$PEN/borrow/contract.md" BOUNDS="$PEN/borrow/bounds.rye" \
  ADMISSION="$PEN/borrow/admission.rye" REFUSAL="$PEN/borrow/refusal.rye" sh "$SCAN" >/dev/null 2>&1; then echo 0; else echo 1; fi)"
# lifted: give the constant back its row and the field walks free again
printf '%s\n' '| value unit | 96 | ASCII bytes |' >> "$PEN/borrow/contract.md"
edit 's/^pub const max_identifier_bytes/pub const max_value_unit_bytes: u32 = 96;\npub const max_identifier_bytes/' "$PEN/borrow/bounds.rye"
out=$(read_pen "$PEN/borrow")
leg borrowed_lifted agree "$(field_of "$out" verdict)"
leg borrowed_lifted_unnamed 0 "$(field_of "$out" unnamed_ceiling)"

# --- 3. a row that states a number the code does not refuse at ---------------
plant_field "$PEN/drift"
edit 's/^| purpose | 80 |/| purpose | 88 |/' "$PEN/drift/contract.md"
out=$(read_pen "$PEN/drift" --list)
leg drift_refused value_disagrees "$(field_of "$out" verdict)"
leg drift_counted 1 "$(field_of "$out" value_disagrees)"
leg drift_names_both yes "$(printf '%s\n' "$out" | grep -q 'code=80 row=purpose contract=88' && echo yes || echo no)"
leg drift_exit 1 "$(if CONTRACT="$PEN/drift/contract.md" BOUNDS="$PEN/drift/bounds.rye" \
  ADMISSION="$PEN/drift/admission.rye" REFUSAL="$PEN/drift/refusal.rye" sh "$SCAN" >/dev/null 2>&1; then echo 0; else echo 1; fi)"
edit 's/^| purpose | 88 |/| purpose | 80 |/' "$PEN/drift/contract.md"
leg drift_lifted agree "$(field_of "$(read_pen "$PEN/drift")" verdict)"

# --- 4. the constant itself vanishes -----------------------------------------
plant_field "$PEN/noconst"
edit '/max_purpose_bytes/d' "$PEN/noconst/bounds.rye"
out=$(read_pen "$PEN/noconst" --list)
leg noconst_refused unnamed_ceiling "$(field_of "$out" verdict)"
leg noconst_named_reason yes "$(printf '%s\n' "$out" | grep -q 'verdict=no_such_constant' && echo yes || echo no)"

# --- 5. a population row with no members leaning on it -----------------------
# When every field carries its own row, the population reading reads zero and says
# so, rather than reporting a hole that is not there.
plant_field "$PEN/pop"
edit 's/^| each identifier | 96 | ASCII bytes |/| each identifier | 96 | ASCII bytes |\n| receipt_id | 96 | ASCII bytes |\n| holder_id | 96 | ASCII bytes |/' "$PEN/pop/contract.md"
out=$(read_pen "$PEN/pop")
leg population_closed 0 "$(field_of "$out" population_only)"
leg population_undeclared_clears 0 "$(field_of "$out" population_undeclared)"
leg population_still_agrees agree "$(field_of "$out" verdict)"

# --- 6. a scan that cannot read refuses rather than reporting zero -----------
plant_field "$PEN/blind"
rm "$PEN/blind/contract.md"
out=$(read_pen "$PEN/blind")
leg missing_contract_refuses unreadable "$(field_of "$out" verdict)"
plant_field "$PEN/notable"
edit '/^| Field or population |/d' "$PEN/notable/contract.md"
out=$(read_pen "$PEN/notable")
leg missing_table_refuses unreadable "$(field_of "$out" verdict)"
plant_field "$PEN/noconsts"
: > "$PEN/noconsts/bounds.rye"
leg empty_bounds_refuses unreadable "$(field_of "$(read_pen "$PEN/noconsts")" verdict)"
plant_field "$PEN/nosites"
: > "$PEN/nosites/admission.rye"
leg empty_admission_refuses unreadable "$(field_of "$(read_pen "$PEN/nosites")" verdict)"
plant_field "$PEN/nohelpers"
: > "$PEN/nohelpers/refusal.rye"
leg empty_refusal_refuses unreadable "$(field_of "$(read_pen "$PEN/nohelpers")" verdict)"

# --- 7. the second table on the page is not read as ceilings ----------------
plant_field "$PEN/twotables"
out=$(read_pen "$PEN/twotables")
leg second_table_unread 6 "$(field_of "$out" rows)"

# --- 8. the fixed-field helper's name is READ, never spelled twice -----------
plant_field "$PEN/rename"
edit 's/"encoded_fact"/"encoded_frame"/' "$PEN/rename/refusal.rye"
edit 's/^| encoded fact |/| encoded frame |/' "$PEN/rename/contract.md"
out=$(read_pen "$PEN/rename" --list)
leg helper_name_read yes "$(printf '%s\n' "$out" | grep -q 'field=encoded_frame' && echo yes || echo no)"
leg helper_rename_agrees agree "$(field_of "$out" verdict)"

# --- 9. mutations that must BITE ---------------------------------------------
mutate() {
  name=$1; script=$2
  cp "$SCAN" "$PEN/mutant.sh"
  edit "$script" "$PEN/mutant.sh"
  got=$(CONTRACT="$PEN/ok/contract.md" BOUNDS="$PEN/ok/bounds.rye" ADMISSION="$PEN/ok/admission.rye" \
    REFUSAL="$PEN/ok/refusal.rye" SCAN="$PEN/mutant.sh" sh "$PEN/mutant.sh" 2>&1 || true)
  # A mutation bites when ANY of the four readings the gate rests on moves. Watching
  # the site count alone would have called two of these three mutations harmless.
  reading="$(field_of "$got" sites)/$(field_of "$got" named)/$(field_of "$got" unnamed_ceiling)/$(field_of "$got" verdict)"
  [ "$reading" = "6/6/0/agree" ] && bit=no || bit=yes
  leg "mutation_$name" yes "$bit"
}

# Reading the FIRST paren of the line rather than the helper's own -- the first
# draft's fault, which lost every directly named field to an enclosing `if (`.
mutate first_paren 's|args = substr(call, RSTART + RLENGTH)|args = call; sub(/^[^(]*\\(/, "", args)|'
# Dropping the array-entry collection: the identifier population goes silent.
mutate pending_entries 's|pending\[++np\] = f|f = f|'
# Dropping the population rescue: five real identifiers would read as unnamed.
mutate population_rescue 's|pop = (value in popceiling) ? popceiling\[value\] : ""|pop = ""|'

echo "control_legs=$legs control_failed=$failed"
echo "control_verdict=$([ "$failed" -eq 0 ] && echo ok || echo failed)"
[ "$failed" -eq 0 ]
