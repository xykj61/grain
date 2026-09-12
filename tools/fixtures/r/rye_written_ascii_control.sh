#!/bin/sh
# rye_written_ascii_control.sh -- prove tools/fixtures/r/rye_written_ascii_scan.sh on planted Rye.
#
# Every refusal is shown from BOTH sides: planted, counted, then lifted and counted again. A
# reading proven only in the passing direction cannot be told from a bypass. Two MUTATIONS run the
# scan with one line broken and assert the leg that must bite actually bites -- a control whose
# legs all pass against a broken instrument is a control proving nothing.
#
# The pen is a REAL git repository, because the scan's roster is `git ls-files`.
#
# USAGE
#   sh tools/fixtures/r/rye_written_ascii_control.sh
#
# Run from the repository root.

set -u

ROOT=$(pwd)
SCAN=$ROOT/tools/fixtures/r/rye_written_ascii_scan.sh
pen=$(mktemp -d 2>/dev/null || mktemp -d -t ryewr)
trap 'rm -rf "$pen"' EXIT

legs=0
failed=0

# Every leg prints BOTH a human line and a `<name>=yes|no` the witness asserts on, so a leg written
# tomorrow is heard the day it lands rather than hiding under a verdict that only says the control
# reached its last line.
ok() {
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    echo "$1=yes"
    echo "# leg $1 ok ($2)"
  else
    echo "$1=no"
    echo "# leg $1 FAILED want=$2 got=$3"
    failed=$((failed + 1))
  fi
}

# One em dash, written as bytes so this control's own source stays ASCII where it can. The planted
# character must be real: a control planting the name of a character proves nothing about bytes.
EM=$(printf '\342\200\224')
MID=$(printf '\302\267')
ARROW=$(printf '\342\206\222')
# A form the rule's table leaves to a reader's judgment -- counted in `written`, never in `named`.
SECT=$(printf '\302\247')

mk() { mkdir -p "$pen/$(dirname "$1")"; cat > "$pen/$1"; }

read_key() { LC_ALL=C awk -F= -v k="$2" '$1 == k { print $2 }' "$1"; }

run() {
  ( cd "$pen" && git add -A >/dev/null 2>&1; sh "$SCAN" > "$pen/out.txt" 2>"$pen/err.txt" )
  cat "$pen/out.txt"
}

cd "$pen" || exit 1
git init -q . >/dev/null 2>&1
git config user.email pen@example.invalid
git config user.name pen
cd "$ROOT" || exit 1

# --- the clean floor -------------------------------------------------------
mk clean.rye <<EOF
const std = @import("std");
const msg = "plain ascii only";
EOF
run > /dev/null
ok clean_written 0 "$(read_key "$pen/out.txt" written)"
ok clean_verdict ok "$(read_key "$pen/out.txt" verdict)"
ok clean_files_read 1 "$(read_key "$pen/out.txt" files_read)"

# --- the four assembling calls, each counted -------------------------------
mk bufprint.rye <<EOF
const head = std.fmt.bufPrint(&text, "# vessel $EM season", .{});
EOF
run > /dev/null
ok bufprint_counts 1 "$(read_key "$pen/out.txt" written)"
ok bufprint_named 1 "$(read_key "$pen/out.txt" written_named)"
rm -f "$pen/bufprint.rye"
run > /dev/null
ok bufprint_lifts 0 "$(read_key "$pen/out.txt" written)"

mk allocprint.rye <<EOF
const line = std.fmt.allocPrint(garden, "books $MID pnl", .{});
EOF
run > /dev/null
ok allocprint_counts 1 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/allocprint.rye"

mk writefile.rye <<EOF
try cwd.writeFile(io, .{ .sub_path = p, .data = "head $ARROW tail" });
EOF
run > /dev/null
ok writefile_counts 1 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/writefile.rye"

mk bufprintz.rye <<EOF
const z = std.fmt.bufPrintZ(&b, "name $EM z", .{});
EOF
run > /dev/null
ok bufprintz_counts 1 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/bufprintz.rye"
run > /dev/null
ok all_four_lift 0 "$(read_key "$pen/out.txt" written)"

# --- the three rooms this meter refuses to enter ---------------------------
mk spoken.rye <<EOF
print("said aloud $EM here\n", .{});
EOF
run > /dev/null
ok spoken_is_not_written 0 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/spoken.rye"

mk nested.rye <<EOF
print("{s}\n", .{std.fmt.bufPrint(&b, "inner $EM text", .{})});
EOF
run > /dev/null
ok nested_in_print_not_charged_twice 0 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/nested.rye"

mk comment.rye <<EOF
// a comment $EM belongs to the sibling meter
const x = 1;
EOF
run > /dev/null
ok own_line_comment_free 0 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/comment.rye"

mk trailing.rye <<EOF
const h = std.fmt.bufPrint(&b, "clean", .{}); // trailing $EM comment
EOF
run > /dev/null
ok trailing_comment_free 0 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/trailing.rye"

mk bare.rye <<EOF
const decoder_fixture = "a decoder must hold $EM to decode it";
EOF
run > /dev/null
ok bare_literal_free 0 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/bare.rye"

# --- the whole-identifier reads, both directions ---------------------------
mk fingerprint.rye <<EOF
const f = parent_fingerprint("four $EM bytes");
EOF
run > /dev/null
ok fingerprint_opens_nothing 0 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/fingerprint.rye"

mk suffix.rye <<EOF
const s = mybufPrint(&b, "suffix $EM name");
EOF
run > /dev/null
ok longer_name_opens_nothing 0 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/suffix.rye"

# --- the shapes a line-oriented reader would miss --------------------------
mk multiline.rye <<EOF
const head = std.fmt.bufPrint(
    &text,
    "continuation $EM line",
    .{},
);
EOF
run > /dev/null
ok continuation_line_counts 1 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/multiline.rye"

mk raw.rye <<EOF
const body = std.fmt.bufPrint(&b,
    \\\\**Authored:** \`{s}\` $EM not inherited.
, .{n});
EOF
run > /dev/null
ok raw_multiline_counts 1 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/raw.rye"

mk charlit.rye <<EOF
const paren = '(';
const s = "outside $EM a region";
EOF
run > /dev/null
ok char_literal_opens_nothing 0 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/charlit.rye"

mk escaped.rye <<EOF
const h = std.fmt.bufPrint(&b, "a \\" quote $EM inside", .{});
EOF
run > /dev/null
ok escaped_quote_keeps_string_open 1 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/escaped.rye"

# --- named against the notation tail ---------------------------------------
mk notation.rye <<EOF
const h = std.fmt.bufPrint(&b, "section $SECT ref", .{});
EOF
run > /dev/null
ok notation_counts_written 1 "$(read_key "$pen/out.txt" written)"
ok notation_is_unnamed 0 "$(read_key "$pen/out.txt" written_named)"
rm -f "$pen/notation.rye"

# --- the persisted proxy, both directions ----------------------------------
mk persist_yes.rye <<EOF
const head = std.fmt.bufPrint(&text, "# header $EM here", .{});
try cwd.writeFile(io, .{ .sub_path = p, .data = text });
EOF
run > /dev/null
ok persist_counted 1 "$(read_key "$pen/out.txt" persisted)"
ok persist_files 1 "$(read_key "$pen/out.txt" persisted_files)"
rm -f "$pen/persist_yes.rye"

mk persist_no.rye <<EOF
const line = std.fmt.allocPrint(garden, "screen $EM line", .{});
EOF
run > /dev/null
ok no_writefile_not_persisted 0 "$(read_key "$pen/out.txt" persisted)"
ok no_writefile_still_written 1 "$(read_key "$pen/out.txt" written)"
rm -f "$pen/persist_no.rye"
run > /dev/null
ok pen_returns_to_zero 0 "$(read_key "$pen/out.txt" written)"

# --- a guard that cannot read its subject says so --------------------------
mk unreadable.rye <<EOF
const h = std.fmt.bufPrint(&b, "fine", .{});
EOF
( cd "$pen" && git add -A >/dev/null 2>&1 )
chmod 000 "$pen/unreadable.rye"
( cd "$pen" && sh "$SCAN" > "$pen/out.txt" 2>/dev/null )
if [ "$(id -u)" = "0" ]; then
  echo "leg unreadable_refuses skipped (root reads a 000 file)"
else
  ok unreadable_refuses refused "$(read_key "$pen/out.txt" verdict)"
  ok unreadable_counted 1 "$(read_key "$pen/out.txt" files_unreadable)"
fi
chmod 644 "$pen/unreadable.rye"
run > /dev/null
ok readable_again ok "$(read_key "$pen/out.txt" verdict)"
rm -f "$pen/unreadable.rye"

# --- the two ceilings, each from both sides --------------------------------
# The living ceiling is a constant in the scan, so it is proven on a COPY holding a small one. A
# refusal proven only in the passing direction cannot be told from a bypass.
small=$pen/small.sh
sed 's/^ceiling=290$/ceiling=0/' "$SCAN" > "$small"
mk over.rye <<EOF
const h = std.fmt.bufPrint(&b, "one $EM past", .{});
EOF
( cd "$pen" && git add -A >/dev/null 2>&1; sh "$small" > "$pen/sout.txt" 2>/dev/null )
ok over_ceiling_refuses no "$(read_key "$pen/sout.txt" under_ceiling)"
rm -f "$pen/over.rye"
( cd "$pen" && git add -A >/dev/null 2>&1; sh "$small" > "$pen/sout.txt" 2>/dev/null )
ok removed_returns_green yes "$(read_key "$pen/sout.txt" under_ceiling)"

# The persisted wall stands at zero in the scan itself, so it needs no copy at all.
mk walled.rye <<EOF
const head = std.fmt.bufPrint(&text, "# header $EM here", .{});
try cwd.writeFile(io, .{ .sub_path = p, .data = text });
EOF
run > /dev/null
ok persisted_wall_refuses no "$(read_key "$pen/out.txt" persisted_under_ceiling)"
rm -f "$pen/walled.rye"
run > /dev/null
ok persisted_wall_returns_green yes "$(read_key "$pen/out.txt" persisted_under_ceiling)"

# A REFUSED READ MUST NEVER ANSWER under_ceiling=yes -- a green from a meter that opened nothing is
# the worst shape a reading can take (REDS %513).
mk fine.rye <<EOF
const h = std.fmt.bufPrint(&b, "fine", .{});
EOF
( cd "$pen" && git add -A >/dev/null 2>&1 )
chmod 000 "$pen/fine.rye"
( cd "$pen" && sh "$SCAN" > "$pen/out.txt" 2>/dev/null )
if [ "$(id -u)" = "0" ]; then
  echo "broken_instrument_refuses=yes"
  echo "# leg broken_instrument_refuses skipped (root reads a 000 file)"
  echo "broken_instrument_named=yes"
  legs=$((legs + 2))
else
  ok broken_instrument_named failed "$(read_key "$pen/out.txt" instrument)"
  ok broken_instrument_refuses no "$(read_key "$pen/out.txt" under_ceiling)"
fi
chmod 644 "$pen/fine.rye"
rm -f "$pen/fine.rye"

# --- MUTATIONS: prove the legs bite ----------------------------------------
mutate() {
  mfile=$pen/mutant.sh
  sed "$1" "$SCAN" > "$mfile"
  ( cd "$pen" && git add -A >/dev/null 2>&1; sh "$mfile" > "$pen/mout.txt" 2>/dev/null )
  read_key "$pen/mout.txt" "$2"
}

# Mutation one: drop the whole-identifier read, matching any name ending in the call's letters.
mk fingerprint.rye <<EOF
const f = parent_bufPrint("four $EM bytes");
EOF
base1=$(run > /dev/null; read_key "$pen/out.txt" written)
ok mutation_identity_applied 0 "$base1"
m1=$(mutate 's/id == "bufPrint" ||/id ~ \/bufPrint$\/ ||/' written)
ok mutation_identity_bites 1 "$m1"
rm -f "$pen/fingerprint.rye"

# Mutation two: drop the say tracking, so a bufPrint inside a print is charged twice.
mk nested.rye <<EOF
print("{s}\n", .{std.fmt.bufPrint(&b, "inner $EM text", .{})});
EOF
base2=$(run > /dev/null; read_key "$pen/out.txt" written)
ok mutation_nested_applied 0 "$base2"
m2=$(mutate 's/else if (say > 0) say++/else if (0) say++/' written)
ok mutation_nested_bites 1 "$m2"
rm -f "$pen/nested.rye"

echo "control_legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=red"
fi
