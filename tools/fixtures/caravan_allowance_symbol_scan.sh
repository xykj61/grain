#!/bin/sh
# caravan_allowance_symbol_scan.sh -- read the bounds Microkit declares for one protection domain out of its
# own header, and diff both the SYMBOLS and their VALUES against what caravan/allowances.rye prints.
#
# WHY THE VALUES AND NOT ONLY THE NAMES. `refusals.rye` once carried the right eleven names with two meanings
# swapped, inside a rung whose parity check looked only at names (REDS %107). Here the whole subject IS the
# numbers, so a scan that checked names alone would be checking the least of it. Every one of the seven is
# compared as a name AND as a value.
#
# WHY TWO OF THE SEVEN ARE EVALUATED RATHER THAN READ. The header spells four numbers and derives three from
# them -- `PD_ROOT_CAP_SIZE` is a shift, `MICROKIT_MAX_CHANNEL_ID` is a subtraction, `MICROKIT_MAX_IOPORT_ID`
# is a copy. Reading those three as text would read an expression rather than a number, so this scan resolves
# each from the source the header names, which is also what the module does. If the header ever changes what
# a derived number is derived FROM, the two resolutions part and the diff says so.
#
# WHY A SCAN RATHER THAN A GREP IN THE WITNESS. Comparing seven name-and-value pairs wants a loop, and a loop
# that interpolates captured output into a shell-quoted word is the fragile shape REDS %85 built a loom to
# forbid. The comparison lives here; the witness reads a small integer report back.
#
# Usage: sh tools/fixtures/caravan_allowance_symbol_scan.sh <microkit.h> <table-output-file>
# Prints: header_count=<n> table_count=<n> name_mismatch=<n> value_mismatch=<n> derived_resolved=<n> verdict=ok|drift

set -eu

header="$1"
table="$2"

if [ ! -f "$header" ]; then
    echo "header_count=0 table_count=0 name_mismatch=0 value_mismatch=0 derived_resolved=0 verdict=missing-header"
    exit 0
fi
if [ ! -f "$table" ]; then
    echo "header_count=0 table_count=0 name_mismatch=0 value_mismatch=0 derived_resolved=0 verdict=missing-table"
    exit 0
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# The seven, in the order the header declares them. Spelled here because this is the scan's QUESTION rather
# than its answer -- it asks the header what each one is worth, and asks the module the same, and diffs.
cat > "$work/want" <<'WANT'
PD_ROOT_CAP_BITS
PD_ROOT_CAP_SIZE
MICROKIT_MAX_USER_CAPS
MICROKIT_MAX_CHANNELS
MICROKIT_MAX_CHANNEL_ID
MICROKIT_MAX_IOPORT_ID
MICROKIT_PD_NAME_LENGTH
WANT

# Pull each symbol's right-hand side out of the header exactly as written.
: > "$work/raw"
while IFS= read -r sym; do
    rhs=$(awk -v s="$sym" '$1 == "#define" && $2 == s { $1=""; $2=""; sub(/^[ \t]+/, ""); print; exit }' "$header")
    printf '%s\t%s\n' "$sym" "$rhs" >> "$work/raw"
done < "$work/want"

header_count=$(awk -F'\t' '$2 != "" { n++ } END { print n+0 }' "$work/raw")

# Resolve the four spelled numbers, then the three derived from them. A derived value is computed from the
# source the header names rather than from a number typed here, so a change of source shows up as a drift.
bits=$(awk -F'\t' '$1 == "PD_ROOT_CAP_BITS" { print $2 }' "$work/raw")
caps=$(awk -F'\t' '$1 == "MICROKIT_MAX_USER_CAPS" { print $2 }' "$work/raw")
chans=$(awk -F'\t' '$1 == "MICROKIT_MAX_CHANNELS" { print $2 }' "$work/raw")
namelen=$(awk -F'\t' '$1 == "MICROKIT_PD_NAME_LENGTH" { print $2 }' "$work/raw")

derived_resolved=0
size_rhs=$(awk -F'\t' '$1 == "PD_ROOT_CAP_SIZE" { print $2 }' "$work/raw")
chid_rhs=$(awk -F'\t' '$1 == "MICROKIT_MAX_CHANNEL_ID" { print $2 }' "$work/raw")
iop_rhs=$(awk -F'\t' '$1 == "MICROKIT_MAX_IOPORT_ID" { print $2 }' "$work/raw")

# Each derived symbol must still name the source the module believes it comes from. Checking the TEXT of the
# right-hand side is the point: a value that happens to match while the derivation changed is exactly the
# drift a value-only check would read as agreement.
size_val=""
case "$size_rhs" in *PD_ROOT_CAP_BITS*) size_val=$(awk -v b="$bits" 'BEGIN { print 2 ^ b }'); derived_resolved=$((derived_resolved + 1)) ;; esac
chid_val=""
case "$chid_rhs" in *MICROKIT_MAX_CHANNELS*-*1*) chid_val=$((chans - 1)); derived_resolved=$((derived_resolved + 1)) ;; esac
iop_val=""
case "$iop_rhs" in *MICROKIT_MAX_CHANNELS*) iop_val="$chans"; derived_resolved=$((derived_resolved + 1)) ;; esac

{
    printf 'PD_ROOT_CAP_BITS\t%s\n' "$bits"
    printf 'PD_ROOT_CAP_SIZE\t%s\n' "$size_val"
    printf 'MICROKIT_MAX_USER_CAPS\t%s\n' "$caps"
    printf 'MICROKIT_MAX_CHANNELS\t%s\n' "$chans"
    printf 'MICROKIT_MAX_CHANNEL_ID\t%s\n' "$chid_val"
    printf 'MICROKIT_MAX_IOPORT_ID\t%s\n' "$iop_val"
    printf 'MICROKIT_PD_NAME_LENGTH\t%s\n' "$namelen"
} > "$work/header"

# What the module printed: `allowances: <n> <SYMBOL> = <value> [...`
awk '$1 == "allowances:" && $4 == "=" { printf "%s\t%s\n", $3, $5 }' "$table" > "$work/module"
table_count=$(awk 'END { print NR+0 }' "$work/module")

name_mismatch=0
value_mismatch=0
line=0
while IFS="$(printf '\t')" read -r sym val; do
    line=$((line + 1))
    msym=$(awk -F'\t' -v n="$line" 'NR == n { print $1 }' "$work/module")
    mval=$(awk -F'\t' -v n="$line" 'NR == n { print $2 }' "$work/module")
    [ "$sym" = "$msym" ] || name_mismatch=$((name_mismatch + 1))
    [ "$val" = "$mval" ] || value_mismatch=$((value_mismatch + 1))
done < "$work/header"

echo "header_count=$header_count"
echo "table_count=$table_count"
echo "name_mismatch=$name_mismatch"
echo "value_mismatch=$value_mismatch"
echo "derived_resolved=$derived_resolved"
if [ "$header_count" -eq 7 ] && [ "$table_count" -eq 7 ] && [ "$name_mismatch" -eq 0 ] \
   && [ "$value_mismatch" -eq 0 ] && [ "$derived_resolved" -eq 3 ]; then
    echo "verdict=ok"
else
    echo "verdict=drift"
fi
