#!/bin/sh
# caravan_object_symbol_scan.sh -- read seL4's riscv64 object-type vocabulary out of its own three headers,
# in the numbering order the three tiers compose into, and diff it against what caravan/objects.rye prints.
#
# WHY THREE HEADERS. seL4 declares its object types in tiers: a portable enum, a mode enum that BEGINS at the
# portable enum's sentinel, and an architecture enum that begins at the mode enum's sentinel. So the numbering
# is one sequence spread across three files, and reading only one of them would measure a third of the truth.
#
# WHY A SCAN RATHER THAN A GREP IN THE WITNESS. Comparing ordered lists wants a loop, and a loop that
# interpolates captured output into a shell-quoted word is the fragile shape REDS %85 built a loom to forbid.
# The comparison lives here; the witness reads a small integer report back. Each tier is scanned by its own awk
# process, so the guarded list is APPENDED rather than written -- a truncating redirect would keep only the last
# tier, and the count of configuration-guarded symbols is one of the things this scan is here to report.
#
# WHY SYMBOLS ARE READ ONLY FROM INSIDE THE ENUM BRACES. The portable header also carries a deprecated alias
# that mentions two real symbols in prose, so a file-wide grep would count names the vocabulary does not hold.
#
# Usage: sh tools/fixtures/caravan_object_symbol_scan.sh <generic.h> <mode.h> <arch.h> <table-output-file>
# Prints: header_count=<n> table_count=<n> mismatch=<n> conditional=<n> anchor_mode=<0|1> anchor_arch=<0|1> verdict=ok|drift

set -eu

generic="$1"
mode="$2"
arch="$3"
table="$4"

for f in "$generic" "$mode" "$arch"; do
    if [ ! -f "$f" ]; then
        echo "header_count=0 table_count=0 mismatch=0 conditional=0 anchor_mode=0 anchor_arch=0 verdict=missing-header"
        exit 0
    fi
done
if [ ! -f "$table" ]; then
    echo "header_count=0 table_count=0 mismatch=0 conditional=0 anchor_mode=0 anchor_arch=0 verdict=missing-table"
    exit 0
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# Pull the members of every `typedef enum { ... }` block, in order, splitting the unconditional members from
# the ones standing behind a configuration guard. A member behind `#ifdef CONFIG_KERNEL_MCS` is real seL4 and
# absent from the configuration this arc brings up first, so it is counted rather than silently dropped.
extract() {
    awk '
        /typedef[ \t]+enum/ { inenum = 1 }
        inenum && /^[ \t]*#(if|ifdef|ifndef)/ { depth += 1; next }
        inenum && /^[ \t]*#endif/ { if (depth > 0) depth -= 1; next }
        inenum && /^[ \t]*#else/ { next }
        inenum && /^[ \t]*}/ { inenum = 0; next }
        inenum {
            line = $0
            while (match(line, /seL4_[A-Za-z0-9_]+/)) {
                name = substr(line, RSTART, RLENGTH)
                line = substr(line, RSTART + RLENGTH)
                if (depth > 0) { print name >> guarded; continue }
                print name
            }
        }
    ' guarded="$1" "$2"
}

: > "$work/guarded.txt"
{
    extract "$work/guarded.txt" "$generic"
    extract "$work/guarded.txt" "$mode"
    extract "$work/guarded.txt" "$arch"
} > "$work/raw.txt"

# The sentinels are counts and tier anchors rather than object types, so they leave the vocabulary. Each is
# named here so a reader can see exactly what was dropped and why.
grep -vxE 'seL4_(NonArchObjectTypeCount|ModeObjectTypeCount|ObjectTypeCount)' "$work/raw.txt" > "$work/header.txt" || true

# What the module prints, in the order it prints it.
grep -oE 'seL4_[A-Za-z0-9_]+' "$table" > "$work/table.txt" || true

header_count=$(wc -l < "$work/header.txt" | tr -d ' ')
table_count=$(wc -l < "$work/table.txt" | tr -d ' ')
conditional=$(sort -u "$work/guarded.txt" | grep -c . || true)

mismatch=$(diff "$work/header.txt" "$work/table.txt" | grep -c '^[<>]' || true)

# The tiers compose only because each enum's first member begins at the previous enum's sentinel. Read that
# anchoring from the headers themselves, so a re-tiering that opens a gap or an overlap reds here.
anchor_mode=0
anchor_arch=0
grep -qE '=[ \t]*seL4_NonArchObjectTypeCount' "$mode" && anchor_mode=1
grep -qE '=[ \t]*seL4_ModeObjectTypeCount' "$arch" && anchor_arch=1

verdict=drift
if [ "$header_count" = "$table_count" ] && [ "$mismatch" = "0" ] && [ "$header_count" != "0" ] \
   && [ "$anchor_mode" = "1" ] && [ "$anchor_arch" = "1" ]; then
    verdict=ok
fi

echo "header_count=$header_count table_count=$table_count mismatch=$mismatch conditional=$conditional anchor_mode=$anchor_mode anchor_arch=$anchor_arch verdict=$verdict"
