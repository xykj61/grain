#!/bin/sh
# tools/fixtures/comment_citation_control.sh -- prove the comment-citation guard by doing.
#
# WHY. A guard that cannot red guards nothing (REDS row 59), and this one refuses on a pattern that
# matches four honest constructions it must NOT refuse. So the control plants a real git repository
# in a throwaway pen and proves both directions: one broken citation bitten, and each blessed shape
# left free -- including the symlink case, which is the one that would have damaged six correct
# files if the guard had guessed instead of resolving.
#
# USAGE
#   sh tools/fixtures/comment_citation_control.sh
#
# Driven by tools/co/comment_citation_witness.rish. Run from the repository root.

set -u

scan=tools/fixtures/comment_citation_scan.sh
card=tools/fixtures/qa_report_card.sh
reg=tools/fixtures/prose_register_scan.sh
for f in "$scan" "$card" "$reg"; do
  [ -f "$f" ] || { echo "control_verdict=missing_$f" >&2; exit 1; }
done

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
mkdir -p "$pen/tools/fixtures" "$pen/context/specs" "$pen/lib" "$pen/apps/one"
cp "$scan" "$card" "$reg" "$pen/tools/fixtures/"

( cd "$pen" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )

printf 'a spec\n' > "$pen/context/specs/a-spec.md"
printf 'ORGANIZING\n' > "$pen/ORGANIZING.md"

run() { ( cd "$pen" && COMMENT_CITATION_ROOT=. sh tools/fixtures/comment_citation_scan.sh 2>&1 ); }
stage() { ( cd "$pen" && git add -A >/dev/null 2>&1 ); }

# The planted comment lines go through printf rather than a heredoc, because a heredoc line
# beginning `//!` IS a comment line in THIS file too, and its relative target resolves from the
# pen rather than from tools/fixtures. The guard said so on its first run, and it was right.

# 1 -- a resolving comment citation costs nothing.
{ printf '%s\n' "//! Ground: [\`context/specs/a-spec.md\`](../context/specs/a-spec.md)"
  printf '%s\n' 'const std = @import("std");'
} > "$pen/lib/good.rye"
stage; o=$(run)
echo "$o" | grep -q 'verdict=ok' && echo "resolving_citation_free=yes" || echo "resolving_citation_free=no"

# 2 -- a broken comment citation is refused, and named so it can be repaired.
{ printf '%s\n' "//! Ground: [\`context/specs/a-spec.md\`](../../context/specs/a-spec.md)"
  printf '%s\n' 'const std = @import("std");'
} > "$pen/lib/bad.rye"
stage; o=$(run)
echo "$o" | grep -q 'verdict=broken_citation' && echo "broken_citation_bitten=yes" || echo "broken_citation_bitten=no"
echo "$o" | grep -q 'broken: lib/bad.rye' && echo "broken_citation_named=yes" || echo "broken_citation_named=no"
echo "$o" | grep -q 'broken_citations=1' && echo "broken_citation_counted=yes" || echo "broken_citation_counted=no"
rm -f "$pen/lib/bad.rye"

# 3 -- link syntax in CODE is data the program emits, and a path in emitted output is relative to
# wherever that output lands. Never a citation.
cat > "$pen/lib/emits.rye" <<'EOF'
//! Writes an index page.
const row = "| [`x`](../../nowhere/at/all.md) |";
EOF
stage; o=$(run)
echo "$o" | grep -q 'verdict=ok' && echo "code_line_free=yes" || echo "code_line_free=no"
rm -f "$pen/lib/emits.rye"

# 4 -- a placeholder shape illustrates a path rather than citing one.
cat > "$pen/lib/shape.rye" <<'EOF'
//! Folds under date/YYYYMMDD/, so a row reads [a log](date/YYYYMMDD/name) after the move,
//! and a room one deeper reads [a log](date/<day>/name) instead.
const std = @import("std");
EOF
stage; o=$(run)
echo "$o" | grep -q 'verdict=ok' && echo "placeholder_free=yes" || echo "placeholder_free=no"
rm -f "$pen/lib/shape.rye"

# 5 -- a backticked span illustrates syntax. exec_bit_scan.sh writes exactly this.
cat > "$pen/lib/backtick.rish" <<'EOF'
# A Markdown link `](./nowhere.md)` invokes nothing at all.
say "hello"
EOF
stage; o=$(run)
echo "$o" | grep -q 'verdict=ok' && echo "backticked_syntax_free=yes" || echo "backticked_syntax_free=no"
rm -f "$pen/lib/backtick.rish"

# 6 -- array-index-then-value arithmetic is not a citation. lotus/allpass.rye writes exactly
# this shape. The VALUES differ from that file on purpose: its own line works the example
# through to a difference that happens to equal the seated living-pin bound, and
# declared_ceiling counts every tool line that spells that number. A plant carries a shape
# rather than a transcription, so it brings its own values.
cat > "$pen/lib/math.rye" <<'EOF'
//    y[2] = -3/4-0 + x[1](32000) + 3/4-y[1](-30000) = 32000 - 24000 = 8000.
const std = @import("std");
EOF
stage; o=$(run)
echo "$o" | grep -q 'verdict=ok' && echo "math_notation_free=yes" || echo "math_notation_free=no"
rm -f "$pen/lib/math.rye"

# 7 -- a symlink is a second door onto one body, and git lists the body alone. So a break is
# reported once rather than once per door, and the guard never asks a body to satisfy two depths.
# That the CARD resolves a link when a reader grades one directly is proven in
# tools/fixtures/qa_report_card_control.sh, where the card can be called on the link's own path.
( cd "$pen/apps/one" && ln -sf ../../lib/good.rye good.rye )
stage
listed=$( cd "$pen" && git grep -l -- '](' -- ':!*.md' 2>/dev/null | grep -c 'good.rye' )
[ "$listed" -eq 1 ] && echo "body_listed_once=yes" || echo "body_listed_once=no ($listed)"
o=$(run)
echo "$o" | grep -q 'verdict=ok' && echo "symlink_door_adds_nothing=yes" || echo "symlink_door_adds_nothing=no"

# 8 -- and when the body itself breaks, it is reported once, naming the body rather than a door.
{ printf '%s\n' "//! Ground: [\`context/specs/a-spec.md\`](../../context/specs/a-spec.md)"
  printf '%s\n' 'const std = @import("std");'
} > "$pen/lib/good.rye"
stage; o=$(run)
echo "$o" | grep -q 'broken_citations=1' && echo "body_break_reported_once=yes" || echo "body_break_reported_once=no"
echo "$o" | grep -q 'broken: lib/good.rye' && echo "body_named_not_door=yes" || echo "body_named_not_door=no"

# 9 -- a prose file is another guard's population; this one reads programs.
printf '# doc\n\n[gone](nowhere/at/all.md)\n' > "$pen/lib/doc.md"
{ printf '%s\n' "//! Ground: [\`context/specs/a-spec.md\`](../context/specs/a-spec.md)"
  printf '%s\n' 'const std = @import("std");'
} > "$pen/lib/good.rye"
stage; o=$(run)
echo "$o" | grep -q 'verdict=ok' && echo "prose_left_to_its_own_guard=yes" || echo "prose_left_to_its_own_guard=no"

# 10 -- the reading is CITED, so losing the card makes the scan refuse rather than report zero.
mv "$pen/tools/fixtures/qa_report_card.sh" "$pen/keep.sh"
o=$(run)
echo "$o" | grep -q 'verdict=card_missing' && echo "card_load_bearing=yes" || echo "card_load_bearing=no"
mv "$pen/keep.sh" "$pen/tools/fixtures/qa_report_card.sh"

echo "control_verdict=ok"
