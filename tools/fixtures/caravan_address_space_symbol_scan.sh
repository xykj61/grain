#!/bin/sh
# caravan_address_space_symbol_scan.sh -- read the fields Microkit declares an address space with, out
# of its own BSD-2-Clause source, and diff both the FIELD NAMES and their ORDER against what
# caravan/address_space.rye prints.
#
# WHY THE ORDER AND NOT ONLY THE MEMBERSHIP. The module claims to list the parts "in the order the
# framework's own source declares the fields in", and a claim about order that only membership is
# checked against is a claim nothing holds. Both structs are walked top to bottom and compared
# position by position, so a field that moves is caught as surely as one that leaves.
#
# WHY TWO FIELDS ARE EXCLUDED, and why the exclusion is spelled here rather than inferred. Both
# structs carry `text_pos`, which records where in the parsed file a declaration sat, and the region
# carries `page_size_specified_by_user`, which records whether a person named the page size or the
# tool chose it. Each describes the TOOL rather than the memory, so neither is a part of an address
# space. Naming the two here means a THIRD bookkeeping field arriving upstream is caught as a count
# mismatch rather than silently absorbed -- an exclusion list that grows on its own excludes anything.
#
# WHY A SCAN RATHER THAN A GREP IN THE WITNESS. Comparing twelve struct-and-field pairs in order wants
# a loop, and a loop that interpolates captured output into a shell-quoted word is the fragile shape
# REDS %85 built a loom to forbid. The comparison lives here; the witness reads a small integer report.
#
# Usage: sh tools/fixtures/caravan_address_space_symbol_scan.sh <memory_region.rs> <table-output-file>
# Prints: source_count=<n> table_count=<n> field_mismatch=<n> order_mismatch=<n> excluded=<n> verdict=ok|drift

set -eu

source_file="$1"
table="$2"

if [ ! -f "$source_file" ]; then
    echo "source_count=0 table_count=0 field_mismatch=0 order_mismatch=0 excluded=0 verdict=missing-source"
    exit 0
fi
if [ ! -f "$table" ]; then
    echo "source_count=0 table_count=0 field_mismatch=0 order_mismatch=0 excluded=0 verdict=missing-table"
    exit 0
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# The two structs an address space is made of, in the order the module lists them. Spelled here
# because this is the scan's QUESTION rather than an answer it reads out of the tree.
structs="SysMemoryRegion SysMap"

# The bookkeeping fields, excluded by name and counted so the exclusion stays visible.
excluded_fields="text_pos page_size_specified_by_user"

# 1. Read each struct's fields out of the source, in declaration order, skipping the bookkeeping.
: > "$work/source.txt"
: > "$work/excluded.txt"
for s in $structs; do
    awk -v want="$s" -v skip="$excluded_fields" '
        BEGIN { inside = 0; n = split(skip, drop, " ") }
        $0 ~ ("^pub struct " want " \\{") { inside = 1; next }
        inside && /^\}/ { inside = 0 }
        inside && /^[ \t]*pub [a-z_]+:/ {
            line = $0
            sub(/^[ \t]*pub /, "", line)
            sub(/:.*$/, "", line)
            for (i = 1; i <= n; i++) if (line == drop[i]) { print "EXCLUDED " want "." line > "/dev/stderr"; next }
            print want "." line
        }
    ' "$source_file" >> "$work/source.txt" 2>> "$work/excluded.txt"
done

source_count=$(wc -l < "$work/source.txt" | tr -d ' ')
excluded=$(wc -l < "$work/excluded.txt" | tr -d ' ')

# 2. Read the module's own table, in the order it prints. The table line carries the pair as the
#    third field: `address-space: <n> <Struct>.<field> [...]`.
awk '/^address-space: [0-9]+ /{ print $3 }' "$table" > "$work/table.txt"
table_count=$(wc -l < "$work/table.txt" | tr -d ' ')

# 3. Membership, both ways. A field in one list and absent from the other is a mismatch either way.
sort "$work/source.txt" > "$work/source.sorted"
sort "$work/table.txt" > "$work/table.sorted"
field_mismatch=$(comm -3 "$work/source.sorted" "$work/table.sorted" | wc -l | tr -d ' ')

# 4. Order, position by position, over the shorter of the two lists. Membership already reports a
#    length difference, so this reading stays about position alone.
order_mismatch=$(awk '
    NR == FNR { src[FNR] = $0; src_n = FNR; next }
    { tbl[FNR] = $0; tbl_n = FNR }
    END {
        n = (src_n < tbl_n) ? src_n : tbl_n
        bad = 0
        for (i = 1; i <= n; i++) if (src[i] != tbl[i]) bad++
        print bad
    }
' "$work/source.txt" "$work/table.txt")

verdict=drift
if [ "$source_count" = "$table_count" ] && [ "$field_mismatch" = "0" ] && [ "$order_mismatch" = "0" ] && [ "$source_count" != "0" ]; then
    verdict=ok
fi

echo "source_count=${source_count} table_count=${table_count} field_mismatch=${field_mismatch} order_mismatch=${order_mismatch} excluded=${excluded} verdict=${verdict}"
