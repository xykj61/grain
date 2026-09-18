#!/bin/sh
# tools/fixtures/r/receipt_contract_ceiling_scan.sh -- does every field the receipt
# contract refuses at a ceiling carry a ceiling that contract declares?
#
# REDS %767 found four fields -- product_digest, value_unit, return_kind, signature --
# refused at `bounds.max_identifier_bytes`, the 96 the contract declares for *each
# identifier* and for none of them. A reader met `ceiling=96` on a refusal line and
# could not find that number in the contract. A water-row reading caught it; no
# instrument could, and the row's own second field says so.
#
# This scan holds three documents to one answer:
#
#   CONTRACT   the ceiling table of the accepted receipt contract -- the rows a
#              reader is promised they may look a refusal number up in.
#   BOUNDS     the Rye module where each ceiling is a named constant.
#   ADMISSION  the admission module, where each field is refused at one of them.
#   REFUSAL    the refusal record, read for the field names its two fixed-field
#              helpers write -- `encoded_fact` and `receipt_facts` are literals there
#              rather than call arguments, so the scan reads them rather than
#              spelling them again.
#
# GATED AT ZERO
#   unnamed_ceiling   a field refused at a ceiling that no contract row names --
#                     neither its own row, nor a declared population row whose
#                     ceiling it shares. This is %767's defect exactly.
#   value_disagrees   a field whose own contract row states a number other than the
#                     one the code refuses it at. The contract would read complete
#                     and lie about the number.
#
# REPORTED, NEVER GATED
#   population_undeclared  the contract declares a ceiling for a POPULATION -- a row
#                     whose label opens with `each` -- and never enumerates its
#                     members. That undeclared membership is the hole product_digest
#                     fell through: it travels inside an array named `identifiers`,
#                     so the borrow looked compliant from both sides. Reported rather
#                     than gated because enumerating a population changes what the
#                     contract publishes, which the contract's own closing clause
#                     returns to Keaton.
#   population_only   how many fields lean on a population row alone.
#   borrowed_rows     rows whose unit text says `borrowed` -- the four %767 named,
#                     each still owing its own derivation.
#   row_unenforced    a declared ceiling no admission site reads. `receipt-card
#                     width` and `receipt-card height` stand here: the card is
#                     described in the contract and drawn by nothing yet.
#
# HOW A ROW AND A FIELD ARE MATCHED. A row's label is lowercased with spaces and
# hyphens turned to underscores. A row matches a field when the two are equal, or
# when the label opens with the field name and an underscore -- so `receipt facts in
# this replay` matches the field `receipt_facts` that a refusal line actually writes.
# Both directions are stated here rather than inferred, because a matching rule
# nobody wrote down is the next borrowed bound.
#
# WHAT IT CANNOT SEE. A ceiling applied outside the admission module,
# and whether a declared number is the RIGHT number for its field -- that is the half
# %767 left OPEN, and it is a judgment about the product rather than a reading.
#
# A scan that cannot read one of its three documents answers `verdict=unreadable`
# and exits non-zero, rather than reporting a comfortable zero.
#
# Usage: sh tools/fixtures/r/receipt_contract_ceiling_scan.sh [--list]
# Environment: CONTRACT, BOUNDS, ADMISSION, REFUSAL, TABLE_HEADER override the
# inputs, so a pen may
# drive this same script against a planted field.

set -eu

CONTRACT="${CONTRACT:-active-designing/date/20260912/20260912-201126_the-receipt-you-can-read-contract.md}"
BOUNDS="${BOUNDS:-mantra/src/tally_receipt_offer_bounds.rye}"
ADMISSION="${ADMISSION:-mantra/src/receipt_offer.rye}"
REFUSAL="${REFUSAL:-mantra/src/tally_receipt_refusal.rye}"
TABLE_HEADER="${TABLE_HEADER:-| Field or population | Ceiling | Unit |}"

LIST=no
for arg in "$@"; do
  case "$arg" in
    --list) LIST=yes ;;
    *) echo "detail: unknown argument $arg" >&2; exit 2 ;;
  esac
done

unreadable() {
  echo "detail: $1"
  echo "verdict=unreadable"
  exit 1
}

for p in "$CONTRACT" "$BOUNDS" "$ADMISSION" "$REFUSAL"; do
  [ -f "$p" ] || unreadable "cannot read $p"
done

WORK=$(mktemp -d) || unreadable "cannot make a work directory"
trap 'rm -rf "$WORK"' EXIT HUP INT TERM

# --- the contract's ceiling table -------------------------------------------
# label<TAB>number<TAB>unit<TAB>is_population
awk -v header="$TABLE_HEADER" '
  index($0, header) == 1 { intable = 1; next }
  intable && substr($0, 1, 1) != "|" { intable = 0 }
  intable {
    line = $0
    if (line ~ /^\|[ -]*-+/) next
    n = split(line, cell, "|")
    if (n < 4) next
    label = cell[2]; number = cell[3]; unit = cell[4]
    gsub(/^[ \t]+|[ \t]+$/, "", label)
    gsub(/^[ \t]+|[ \t]+$/, "", number)
    gsub(/^[ \t]+|[ \t]+$/, "", unit)
    if (label == "") next
    norm = tolower(label)
    gsub(/[ -]/, "_", norm)
    gsub(/,/, "", number)
    if (number !~ /^[0-9]+$/) next
    pop = (norm ~ /^each_/) ? "yes" : "no"
    printf "%s\t%s\t%s\t%s\n", norm, number, unit, pop
  }
' "$CONTRACT" > "$WORK/rows"

[ -s "$WORK/rows" ] || unreadable "the ceiling table under \"$TABLE_HEADER\" read no rows in $CONTRACT"

# --- the bounds module's named constants ------------------------------------
# name<TAB>value
awk '
  /^pub const [a-z_]+:[^=]*=[ ]*[0-9_]+;/ {
    name = $3; sub(/:.*/, "", name)
    value = $0; sub(/^.*=[ ]*/, "", value); sub(/;.*$/, "", value)
    gsub(/_/, "", value)
    printf "%s\t%s\n", name, value
  }
' "$BOUNDS" > "$WORK/consts"

[ -s "$WORK/consts" ] || unreadable "no ceiling constants read in $BOUNDS"

# --- the field names the fixed-field refusal helpers write -------------------
# helper<TAB>field
awk '
  /^pub fn [a-z_]+_refusal\(/ { fn = $3; sub(/\(.*/, "", fn); next }
  fn != "" && /\.field = "/ {
    f = $0; sub(/^.*\.field = "/, "", f); sub(/".*$/, "", f)
    if (!(fn in seen)) { printf "%s\t%s\n", fn, f; seen[fn] = 1 }
  }
' "$REFUSAL" > "$WORK/helpers"

[ -s "$WORK/helpers" ] || unreadable "no refusal helper field names read in $REFUSAL"

# --- the admission function's ceiling sites ---------------------------------
# field<TAB>constant
awk -v helpers="$WORK/helpers" '
  BEGIN {
    while ((getline line < helpers) > 0) {
      split(line, h, "\t"); helper_field[h[1]] = h[2]
    }
    close(helpers)
  }
  # An array entry naming a field, collected until a call consumes the list.
  /\.\{ \.name = "/ {
    f = $0; sub(/^.*\.name = "/, "", f); sub(/".*$/, "", f)
    pending[++np] = f
    next
  }
  /_refusal\(/ {
    call = $0
    # The helper is the identifier immediately left of its own paren, so an
    # enclosing `if (` cannot be mistaken for it -- the first draft read that paren
    # and lost every directly named field.
    if (!match(call, /[a-z_]+_refusal\(/)) next
    helper = substr(call, RSTART, RLENGTH - 1)
    args = substr(call, RSTART + RLENGTH)
    ceiling = ""
    if (match(call, /bounds\.[a-z_]+/)) ceiling = substr(call, RSTART + 7, RLENGTH - 7)
    if (ceiling == "") next
    if (args ~ /^"/) {
      f = args; sub(/^"/, "", f); sub(/".*$/, "", f)
      printf "%s\t%s\n", f, ceiling
    } else if (helper in helper_field) {
      printf "%s\t%s\n", helper_field[helper], ceiling
    } else if (np > 0) {
      for (i = 1; i <= np; i++) printf "%s\t%s\n", pending[i], ceiling
      np = 0
    }
  }
' "$ADMISSION" > "$WORK/sites"

[ -s "$WORK/sites" ] || unreadable "no ceiling sites read in $ADMISSION"

# --- the reading -------------------------------------------------------------
awk -v list="$LIST" -v rowsf="$WORK/rows" -v constsf="$WORK/consts" '
  BEGIN {
    FS = "\t"
    while ((getline line < rowsf) > 0) {
      split(line, r, "\t")
      rows++
      label[rows] = r[1]; rownum[rows] = r[2]; rowunit[rows] = r[3]; rowpop[rows] = r[4]
      if (r[4] == "yes") { poprows++; popceiling[r[2]] = r[1] } else fieldrows++
      if (tolower(r[3]) ~ /borrowed/) borrowed++
    }
    close(rowsf)
    while ((getline line < constsf) > 0) {
      split(line, c, "\t"); cval[c[1]] = c[2]
    }
    close(constsf)
  }
  {
    field = $1; ceiling = $2
    sites++
    if (!(ceiling in cval)) {
      unnamed++
      if (list == "yes") printf "site field=%s ceiling=%s verdict=no_such_constant\n", field, ceiling
      next
    }
    value = cval[ceiling]
    own = ""
    for (i = 1; i <= rows; i++) {
      if (rowpop[i] == "yes") continue
      if (label[i] == field || index(label[i], field "_") == 1) { own = i; break }
    }
    pop = (value in popceiling) ? popceiling[value] : ""
    if (own != "") {
      if (rownum[own] != value) {
        disagrees++
        if (list == "yes") printf "site field=%s ceiling=%s code=%s row=%s contract=%s verdict=value_disagrees\n", field, ceiling, value, label[own], rownum[own]
        next
      }
      named++
      if (list == "yes") printf "site field=%s ceiling=%s value=%s row=%s verdict=named\n", field, ceiling, value, label[own]
      seen_row[own] = 1
      next
    }
    if (pop != "") {
      named++; poponly++
      if (list == "yes") printf "site field=%s ceiling=%s value=%s population=%s verdict=named_by_population\n", field, ceiling, value, pop
      next
    }
    unnamed++
    if (list == "yes") printf "site field=%s ceiling=%s value=%s verdict=unnamed_ceiling\n", field, ceiling, value
  }
  END {
    for (i = 1; i <= rows; i++) {
      if (rowpop[i] == "yes" || seen_row[i]) continue
      unenforced++
      if (list == "yes") printf "row label=%s ceiling=%s verdict=row_unenforced\n", label[i], rownum[i]
    }
    popundeclared = (poprows > 0 && poponly > 0) ? poprows : 0
    printf "rows=%d field_rows=%d population_rows=%d\n", rows, fieldrows + 0, poprows + 0
    printf "sites=%d named=%d unnamed_ceiling=%d value_disagrees=%d\n", sites + 0, named + 0, unnamed + 0, disagrees + 0
    printf "population_only=%d population_undeclared=%d\n", poponly + 0, popundeclared + 0
    printf "borrowed_rows=%d row_unenforced=%d\n", borrowed + 0, unenforced + 0
    if (unnamed > 0) verdict = "unnamed_ceiling"
    else if (disagrees > 0) verdict = "value_disagrees"
    else verdict = "agree"
    printf "verdict=%s\n", verdict
  }
' "$WORK/sites" > "$WORK/report"

cat "$WORK/report"
grep -q '^verdict=agree$' "$WORK/report" || exit 1
