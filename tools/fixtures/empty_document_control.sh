#!/bin/sh
# tools/fixtures/empty_document_control.sh -- prove the empty-document reading by doing.
#
# WHY. A guard that cannot red guards nothing (REDS row 59). This control builds git repositories
# in a temporary pen, plants one condition in each, runs tools/fixtures/empty_document_scan.sh
# inside them, and checks that the refusals bite and the honest readings stay free. Nothing here
# touches the tree it is run from.
#
# USAGE
#   sh tools/fixtures/empty_document_control.sh
#
# Driven by tools/e/empty_document_witness.rish. Run from the repository root.

set -u

scan=$(pwd)/tools/fixtures/empty_document_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

# Each pen carries one full document, so a refusal is never merely "the pen was empty".
build() {
  name=$1; path=$2; content=$3
  d=$pen/$name
  mkdir -p "$d/$(dirname "$path")" "$d/tools/fixtures" 2>/dev/null
  ( cd "$d" \
    && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name Pen \
    && printf '# a real document\nwith a real sentence in it.\n' > README.md \
    && printf '%s' "$content" > "$path" \
    && git add -A && git commit -qm 'pen: one real document and one planted condition' ) >/dev/null 2>&1
  echo "$d"
}

verdict_of() { ( cd "$1" && sh "$scan" 2>/dev/null; ) }

# 1. A tree whose documents all say something. Free, and reading zero.
d=$(build agreeing notes/real.md '# real
This document holds a sentence.
')
out=$(verdict_of "$d")
echo "$out" | grep -q 'verdict=ok' && echo "agreeing_free=yes" || echo "agreeing_free=no"
echo "$out" | grep -q 'empty_documents=0' && echo "clean_reads_zero=yes" || echo "clean_reads_zero=no"
echo "$out" | grep -q 'tracked_documents=2' && echo "documents_counted=yes" || echo "documents_counted=no"

# 2. The regression itself -- a zero-byte tracked document. Refused, counted, named.
d=$(build zero_byte notes/hollow.md '')
out=$(verdict_of "$d")
echo "$out" | grep -q 'verdict=empty_document' && echo "zero_byte_refused=yes" || echo "zero_byte_refused=no"
echo "$out" | grep -q 'empty_documents=1' && echo "zero_byte_counted=yes" || echo "zero_byte_counted=no"
echo "$out" | grep -q 'empty: notes/hollow.md' && echo "zero_byte_named=yes" || echo "zero_byte_named=no"

# 3. Whitespace says exactly as much as nothing. Refused.
d=$(build whitespace notes/blank.md '   

	
')
verdict_of "$d" | grep -q 'verdict=empty_document' && echo "whitespace_refused=yes" || echo "whitespace_refused=no"

# 4. A single honest sentence is enough. The fix for a thin document is a reader, not a byte count.
d=$(build one_line notes/brief.md 'x')
verdict_of "$d" | grep -q 'verdict=ok' && echo "one_character_free=yes" || echo "one_character_free=no"

# 5. A session log and a Kyri record are documents too.
d=$(build bron logs/a.bron '')
verdict_of "$d" | grep -q 'verdict=empty_document' && echo "bron_refused=yes" || echo "bron_refused=no"
d=$(build kyri logs/a.kyri '')
verdict_of "$d" | grep -q 'verdict=empty_document' && echo "kyri_refused=yes" || echo "kyri_refused=no"

# 6. A control that plants an empty file is doing its job -- instrument, never field.
#    REDS %157 and %158 each paid for this lesson once; it is a rule here rather than a memory.
d=$(build fixture_exempt tools/fixtures/planted_empty.md '')
out=$(verdict_of "$d")
echo "$out" | grep -q 'verdict=ok' && echo "fixture_free=yes" || echo "fixture_free=no"
echo "$out" | grep -q 'empty_documents=0' && echo "fixture_not_counted=yes" || echo "fixture_not_counted=no"

# 7. A placeholder whose whole purpose is to be empty.
d=$(build gitkeep notes/.gitkeep '')
verdict_of "$d" | grep -q 'verdict=ok' && echo "gitkeep_free=yes" || echo "gitkeep_free=no"

# 8. An extension this rung does not own belongs to a different guard. One duty per guard.
d=$(build other_ext data/view.tsv '')
verdict_of "$d" | grep -q 'verdict=ok' && echo "other_extension_free=yes" || echo "other_extension_free=no"

echo "control_verdict=ok"
