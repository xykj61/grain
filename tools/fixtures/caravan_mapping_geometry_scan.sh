#!/bin/sh
# caravan_mapping_geometry_scan.sh -- read Sv39's geometry out of seL4's own riscv64 constants header
# and diff it against the geometry caravan/mapping.rye plans with.
#
# WHY THIS SCAN EXISTS. A mapping plan is exact integer arithmetic over five numbers -- the three page
# sizes, the index width of one page-table level, and the width of one entry. Every one of them is a
# fact about the machine, published by seL4 in a header we may read. A module that recites them is a
# module that will keep planning for a machine that changed underneath it, so the numbers are read
# from the header on every run and compared against what the module itself prints.
#
# WHY A SCAN RATHER THAN GREPS IN THE WITNESS. Five paired comparisons want a loop, and a loop that
# hands captured output to the shell inside a quoted word is the fragile shape REDS %85 built a loom
# to forbid. The comparison lives here; the witness reads a small integer report back.
#
# WHY THE HEADER VALUES ARE READ BY NAME. seL4 also defines a tera-page and a Sv48 fourth level in the
# same file, behind configuration. Reading by name takes exactly the five this arc's configuration
# uses and leaves the rest measured elsewhere.
#
# Usage: sh tools/fixtures/caravan_mapping_geometry_scan.sh <constants.h> <table-output-file>
# Prints: header_values=<n> matched=<n> mismatch=<n> symbols=<n> symbol_mismatch=<n> verdict=ok|drift

set -eu

header="$1"
table="$2"

if [ ! -f "$header" ]; then
    echo "header_values=0 matched=0 mismatch=0 symbols=0 symbol_mismatch=0 verdict=missing-header"
    exit 0
fi
if [ ! -f "$table" ]; then
    echo "header_values=0 matched=0 mismatch=0 symbols=0 symbol_mismatch=0 verdict=missing-table"
    exit 0
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# Read one `#define seL4_Name value` by name, taking the first definition so a configuration guard
# further down the file cannot shadow the value this arc actually compiles with.
define_of() {
    awk -v want="$1" '
        $1 == "#define" && $2 == want && $3 ~ /^[0-9]+$/ { print $3; exit }
    ' "$header"
}

page_bits=$(define_of seL4_PageBits)
large_bits=$(define_of seL4_LargePageBits)
huge_bits=$(define_of seL4_HugePageBits)
index_bits=$(define_of seL4_PageTableIndexBits)
entry_bits=$(define_of seL4_PageTableEntryBits)

header_values=0
matched=0
mismatch=0

# Compare a header-derived byte count against the byte count the module printed for that page size.
# The module prints bytes rather than bits, which is the number a reader can check by eye, so the
# scan raises two to the power the header names and compares the two decimals.
compare_bytes() {
    name="$1"
    bits="$2"
    if [ -z "$bits" ]; then
        mismatch=$((mismatch + 1))
        return
    fi
    header_values=$((header_values + 1))
    want=$(awk -v b="$bits" 'BEGIN { printf "%d", 2 ^ b }')
    got=$(awk -v n="$name" '$1 == n { print $3; exit }' "$table")
    if [ "$want" = "$got" ]; then
        matched=$((matched + 1))
    else
        mismatch=$((mismatch + 1))
    fi
}

compare_bytes four_k "$page_bits"
compare_bytes mega "$large_bits"
compare_bytes giga "$huge_bits"

# The index width and the entry width are printed in the module's own header block rather than in the
# size table, so each is read from its own labelled line.
compare_labelled() {
    label="$1"
    want="$2"
    if [ -z "$want" ]; then
        mismatch=$((mismatch + 1))
        return
    fi
    header_values=$((header_values + 1))
    got=$(awk -v l="$label" '$0 ~ l { print $NF; exit }' "$table")
    if [ "$want" = "$got" ]; then
        matched=$((matched + 1))
    else
        mismatch=$((mismatch + 1))
    fi
}

compare_labelled "index bits per level" "$index_bits"
entry_bytes=""
if [ -n "$entry_bits" ]; then
    entry_bytes=$(awk -v b="$entry_bits" 'BEGIN { printf "%d", 2 ^ b }')
fi
compare_labelled "entry bytes" "$entry_bytes"

# The three page symbols must be the names seL4's own object-type headers publish, so a rename in the
# kernel's interface reds here rather than surfacing as a plan for a page the kernel no longer offers.
#
# TWO HEADERS, AND THE REASON IS A MEASURED FACT. The gigabyte page is declared in the riscv64 MODE
# header while the megabyte and four-kilobyte pages are declared in the riscv ARCHITECTURE header --
# because the gigabyte page is the sole member of the mode tier, which is exactly the width
# caravan/objects.rye reads as `tier_width(.mode) == 1`. Scanning one header found two of three and
# said so, which is the guard doing its work rather than a fault in it.
mode_header="vendor/sel4/libsel4/sel4_arch_include/riscv64/sel4/sel4_arch/objecttype.h"
arch_header="vendor/sel4/libsel4/arch_include/riscv/sel4/arch/objecttype.h"
symbols=0
symbol_mismatch=0
for symbol in seL4_RISCV_Giga_Page seL4_RISCV_Mega_Page seL4_RISCV_4K_Page; do
    symbols=$((symbols + 1))
    in_table=0
    in_header=0
    grep -q "$symbol" "$table" && in_table=1
    for candidate in "$mode_header" "$arch_header"; do
        if [ -f "$candidate" ] && grep -q "$symbol" "$candidate"; then
            in_header=1
        fi
    done
    if [ "$in_table" != "1" ] || [ "$in_header" != "1" ]; then
        symbol_mismatch=$((symbol_mismatch + 1))
    fi
done

verdict=drift
if [ "$header_values" = "5" ] && [ "$mismatch" = "0" ] && [ "$matched" = "5" ] \
   && [ "$symbol_mismatch" = "0" ] && [ "$symbols" = "3" ]; then
    verdict=ok
fi

echo "header_values=$header_values matched=$matched mismatch=$mismatch symbols=$symbols symbol_mismatch=$symbol_mismatch verdict=$verdict"
