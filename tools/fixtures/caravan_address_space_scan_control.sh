#!/bin/sh
# caravan_address_space_scan_control.sh -- prove caravan_address_space_symbol_scan.sh on real files in a
# throwaway pen: six refusals bitten and one welcome left free.
#
# WHY A CONTROL RATHER THAN SIX PLANTS IN THE WITNESS. Each plant edits a Rust source with an awk or a
# sed whose program carries its own quotes, and a quoted program interpolated into a shell word inside
# a witness string is the fragile shape REDS %85 built a loom to forbid. The plants live here, where
# they are ordinary shell; the witness reads a small integer report back.
#
# WHY THE WELCOME IS PROVEN FIRST. A refusal proven only in the refusing direction cannot be told from
# a bypass. The unedited source must read `verdict=ok` in this same pen, or every refusal below is
# measuring a broken pen rather than a working guard.
#
# THE SIX REFUSALS, and what each one is for:
#
#   renamed     a field's name changes upstream          membership parts both ways, 2
#   moved       two fields swap places, names intact     membership reads clean; ORDER refuses
#   removed     a field leaves upstream                  the source falls short of twelve
#   added       a third bookkeeping field arrives        an exclusion list that grows on its own excludes anything
#   no-source   the source file is absent                refuses rather than reading as zero disagreement
#   no-table    the module's table is absent             likewise
#
# The moved case is the one that earns the scan. `refusals.rye` once carried the right eleven names
# with two meanings swapped, inside a rung whose parity check looked only at names (REDS %107).
#
# Usage: sh tools/fixtures/caravan_address_space_scan_control.sh <memory_region.rs> <table-output-file>
# Prints: welcome=<ok|failed> renamed=<n> moved=<n> removed=<n> added=<n> no_source=<n> no_table=<n> bitten=<n> verdict=ok|drift

set -u

source_file="$1"
table="$2"
scan="tools/fixtures/caravan_address_space_symbol_scan.sh"

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

report() {
    echo "welcome=$1"
    echo "renamed=$2"
    echo "moved=$3"
    echo "removed=$4"
    echo "added=$5"
    echo "no_source=$6"
    echo "no_table=$7"
    echo "bitten=$8"
    echo "verdict=$9"
    exit 0
}

if [ ! -f "$source_file" ] || [ ! -f "$table" ]; then
    report failed 0 0 0 0 0 0 0 drift
fi

# THE WELCOME, first and in this same pen.
welcome=failed
case "$(sh "$scan" "$source_file" "$table")" in
    *"verdict=ok"*) welcome=ok ;;
esac

bitten=0
bite() {
    # $1 the scan output, $2 the reading that must also hold. Prints 1 when both hold, 0 otherwise.
    case "$1" in
        *"verdict=drift"*|*"verdict=missing-source"*|*"verdict=missing-table"*) ;;
        *) echo 0; return ;;
    esac
    case "$1" in
        *"$2"*) echo 1 ;;
        *) echo 0 ;;
    esac
}

# 1. RENAMED -- a field's name changes upstream. Membership parts both ways: one gone, one arrived.
sed 's|^    pub cached: bool,|    pub cacheable: bool,|' "$source_file" > "$pen/renamed.rs"
renamed=$(bite "$(sh "$scan" "$pen/renamed.rs" "$table")" "field_mismatch=2")

# 2. MOVED -- two fields swap places with every name intact. This is the reading a membership-only
#    check cannot make, and the module claims to list the parts in the source's own order.
awk '
    /^    pub mr: String,$/ { held = $0; next }
    /^    pub vaddr: u64,$/ { print; print held; next }
    { print }
' "$source_file" > "$pen/moved.rs"
moved_out=$(sh "$scan" "$pen/moved.rs" "$table")
moved=0
case "$moved_out" in
    *"field_mismatch=0"*) moved=$(bite "$moved_out" "order_mismatch=2") ;;
esac

# 3. REMOVED -- a field leaves upstream.
grep -v '^    pub prefill_bootinfo:' "$source_file" > "$pen/removed.rs"
removed=$(bite "$(sh "$scan" "$pen/removed.rs" "$table")" "source_count=11")

# 4. ADDED -- a third bookkeeping field arrives and must be read by a person rather than absorbed.
awk '
    /^    pub cached: bool,$/ { print; print "    pub sdf_line_hint: u32,"; next }
    { print }
' "$source_file" > "$pen/added.rs"
added=$(bite "$(sh "$scan" "$pen/added.rs" "$table")" "source_count=13")

# 5. NO SOURCE -- refuses rather than reading as zero disagreement.
no_source=$(bite "$(sh "$scan" "$pen/never-existed.rs" "$table")" "verdict=missing-source")

# 6. NO TABLE -- likewise.
no_table=$(bite "$(sh "$scan" "$source_file" "$pen/never-existed.txt")" "verdict=missing-table")

bitten=$((renamed + moved + removed + added + no_source + no_table))

verdict=drift
if [ "$welcome" = ok ] && [ "$bitten" = 6 ]; then
    verdict=ok
fi

report "$welcome" "$renamed" "$moved" "$removed" "$added" "$no_source" "$no_table" "$bitten" "$verdict"
