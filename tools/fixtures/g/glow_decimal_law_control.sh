#!/bin/sh
# tools/fixtures/g/glow_decimal_law_control.sh -- prove the decimal-law reading on miniature
# Glow compiler rooms.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every refusal
# below is shown from both sides: planted, and then lifted back to ok. Every welcome is asserted as
# hard as every refusal, because a reading that counted an emitted argv parser as a source-decimal
# reader would grow the ratchet's denominator with files nobody wrote.
#
# The pen is a miniature glow/ room rather than a copy of this tree, so the scan under proof reads
# the pen and never this bench.
#
# THE LEG THAT MATTERS MOST IS THE RULING-NEUTRAL PAIR. A pen where every reader refuses a leading
# zero and a pen where every reader accepts one must BOTH read verdicts=1 and pass. That is the
# whole claim of the ratchet's shape: it holds the split still without taking either side of a
# language custody ruling that stays Keaton's.
#
#   sh tools/fixtures/g/glow_decimal_law_control.sh
set -eu

root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "refused: not a git repository" >&2; exit 1; }
scan="$root/tools/fixtures/g/glow_decimal_law_scan.sh"
[ -f "$scan" ] || { echo "refused: the scan under proof is missing -- $scan" >&2; exit 1; }

pen=$(mktemp -d) || { echo "refused: no temporary directory" >&2; exit 1; }
trap 'rm -rf "$pen"' EXIT

pass=0
fail=0
check() {
  want=$1; got=$2; what=$3
  if [ "$want" = "$got" ]; then
    pass=$((pass + 1)); echo "  ok   $what"
  else
    fail=$((fail + 1)); echo "  FAIL $what -- want $want, got $got"
  fi
}
field() { sed -n "s/^$2=//p" "$1" | head -1; }

# A pen carries the two directories the scan's upward root walk looks for, so it resolves to the
# pen rather than climbing out into this tree.
newpen() {
  d="$pen/$1"; rm -rf "$d"
  mkdir -p "$d/tools/fixtures/g" "$d/glow/nock" "$d/glow/.cache" "$d/glow/bin"
  cp "$scan" "$d/tools/fixtures/g/glow_decimal_law_scan.sh"
  echo "$d"
}

# A reader that REFUSES a leading zero -- the house parse law's own shape.
reader_refuse() {
  cat > "$1" <<'RYE'
const std = @import("std");

fn parse_decimal_u32(text: []const u8) ParseError!u32 {
    if (text.len == 0) return error.MalformedBody;
    if (text.len > 1 and text[0] == '0') return error.MalformedBody;
    var v: u32 = 0;
    for (text) |ch| {
        if (ch < '0' or ch > '9') return error.MalformedBody;
        const d: u32 = ch - '0';
        v = v * 10 + d;
    }
    return v;
}
RYE
}

# A reader that ACCEPTS a leading zero -- the same shape minus the one line.
reader_accept() {
  cat > "$1" <<'RYE'
const std = @import("std");

fn parse_decimal(text: []const u8) ParseError!u32 {
    if (text.len == 0) return error.MalformedBody;
    var v: u32 = 0;
    for (text) |ch| {
        if (ch < '0' or ch > '9') return error.MalformedBody;
        const d: u32 = ch - '0';
        v = v * 10 + d;
    }
    return v;
}
RYE
}

run() { ( cd "$1" && sh tools/fixtures/g/glow_decimal_law_scan.sh > "$1/out.txt" 2>&1 ) || true; }

echo "glow_decimal_law_control -- miniature Glow rooms in $pen"

# --- 1. one reader, refusing: one verdict, and the tree is whole ---
d=$(newpen a); reader_refuse "$d/glow/rune_shop_gate.rye"; run "$d"
check 1 "$(field "$d/out.txt" readers)"  "a reader is found by shape rather than by name"
check 1 "$(field "$d/out.txt" law_held)" "the refusing reader reads law_held"
check 1 "$(field "$d/out.txt" verdicts)" "one reader is one verdict"
check ok "$(field "$d/out.txt" verdict)" "a room that agrees with itself passes"

# --- 2. one reader, accepting: ALSO one verdict -- the ruling-neutral half ---
d=$(newpen b); reader_accept "$d/glow/rune_assert.rye"; run "$d"
check 1 "$(field "$d/out.txt" law_absent)" "the accepting reader reads law_absent"
check 1 "$(field "$d/out.txt" verdicts)"   "a room that accepts everywhere is ALSO one verdict"
check ok "$(field "$d/out.txt" verdict)"   "the meter takes neither side of the ruling"

# --- 3. both: two verdicts, at the ceiling ---
d=$(newpen c)
reader_refuse "$d/glow/rune_shop_gate.rye"; reader_accept "$d/glow/rune_assert.rye"; run "$d"
check 2 "$(field "$d/out.txt" readers)"  "both readers found"
check 2 "$(field "$d/out.txt" verdicts)" "one literal, two verdicts"
check ok "$(field "$d/out.txt" verdict)" "two verdicts stands at the ceiling of two"

# --- 4. the ceiling, shown from both sides ---
( cd "$d" && GLOW_DECIMAL_VERDICTS_CEILING=1 sh tools/fixtures/g/glow_decimal_law_scan.sh > out1.txt 2>&1 ) || true
check over_verdicts_ceiling "$(field "$d/out1.txt" verdict)" "one past the ceiling refuses"
rm -f "$d/glow/rune_assert.rye"
( cd "$d" && GLOW_DECIMAL_VERDICTS_CEILING=1 sh tools/fixtures/g/glow_decimal_law_scan.sh > out2.txt 2>&1 ) || true
check ok "$(field "$d/out2.txt" verdict)" "lifting the plant returns the room to green"

# --- 5. a hex reader is not a decimal reader ---
d=$(newpen e)
cat > "$d/glow/lower_face_lit.rye" <<'RYE'
fn hex_nibble(c: u8) ?u8 {
    if (c >= '0' and c <= '9') return c - '0';
    if (c >= 'a' and c <= 'f') return c - 'a' + 10;
    return null;
}
RYE
run "$d"
check 0 "$(field "$d/out.txt" readers)" "a hex nibble reader is not counted -- a leading zero is ordinary in hex"

# --- 6. a comment is not code ---
d=$(newpen f)
cat > "$d/glow/comment_only.rye" <<'RYE'
fn nothing(x: u8) u8 {
    // std.fmt.parseInt(u32, text, 10) would go here one day
    return x;
}
RYE
run "$d"
check 0 "$(field "$d/out.txt" readers)" "a parseInt named in a comment is not a reader"

# --- 7. emitted Zig is a different subject ---
d=$(newpen g)
cat > "$d/glow/lower_shop_gate.rye" <<'RYE'
fn emit(out: []u8, used: *u32) void {
    try append_print(out, used, "    const s = std.fmt.parseInt(u32, argv[1], 10) catch return 2;\n", .{});
}
RYE
run "$d"
check 0 "$(field "$d/out.txt" readers)" "an emitted argv parseInt is the desk's runtime, not the compiler's source read"

d=$(newpen h)
cat > "$d/glow/lower_cast.rye" <<'RYE'
fn emit_multiline(out: []u8) !u32 {
    return std.fmt.bufPrint(out,
        \\    const sample = std.fmt.parseInt(u32, argv[1], 10) catch return 2;
    , .{});
}
RYE
run "$d"
check 0 "$(field "$d/out.txt" readers)" "a parseInt inside a multiline literal is emitted, not read"

# --- 8. a witness is a prover, not a reader ---
d=$(newpen i); reader_accept "$d/glow/expr_witness.rye"; run "$d"
check 0 "$(field "$d/out.txt" readers)" "a _witness.rye plant is not counted"

# --- 9. lowered output is the product, not the source ---
d=$(newpen j)
reader_accept "$d/glow/.cache/lowered.rye"
reader_accept "$d/glow/bin/built.rye"
run "$d"
check 0 "$(field "$d/out.txt" readers)" "glow/.cache/ and glow/bin/ hold lowered output and are read past"

# --- 10. a claimed law with no check, shown from both sides ---
d=$(newpen k)
cat > "$d/glow/rune_borrowed.rye" <<'RYE'
/// STOA331: decimal literal to u32 -- refuses empty, leading zero (house parse law), overflow.
fn parse_decimal_u32(text: []const u8) ParseError!u32 {
    if (text.len == 0) return error.MalformedBody;
    var v: u32 = 0;
    for (text) |ch| {
        const d: u32 = ch - '0';
        v = v * 10 + d;
    }
    return v;
}
RYE
run "$d"
check 1 "$(field "$d/out.txt" law_claimed_absent)" "a comment naming the law over a body without it is counted"
check law_claimed_absent "$(field "$d/out.txt" verdict)" "and it refuses"
# Insert the refusing line after the empty-source line. Written with awk through a temporary
# and copied back through the original inode rather than `sed -i`: the GNU spelling takes no
# argument and the BSD one requires a backup suffix, so neither runs on both piers, and `cat`
# back through the inode keeps the mode the repository tracks (the exec-bit law).
_lift="$d/glow/rune_borrowed.rye"
awk '{ print }
     /if \(text\.len == 0\) return error\.MalformedBody;/ {
       print "    if (text.len > 1 and text[0] == '"'"'0'"'"') return error.MalformedBody;"
     }' "$_lift" > "$_lift.tmp"
cat "$_lift.tmp" > "$_lift"
rm -f "$_lift.tmp"
run "$d"
check 0 "$(field "$d/out.txt" law_claimed_absent)" "adding the check clears the claim"
check ok "$(field "$d/out.txt" verdict)" "and the room returns to green"

# A claim inside the reader has the same duty as its doc comment.
d=$(newpen body_claim); reader_accept "$d/glow/body.rye"
awk '{ print } /^fn / { print "    // house parse law" }' "$d/glow/body.rye" > "$d/body.tmp"
cat "$d/body.tmp" > "$d/glow/body.rye"
run "$d"
check 1 "$(field "$d/out.txt" law_claimed_absent)" "an unchecked body claim is counted"
check law_claimed_absent "$(field "$d/out.txt" verdict)" "an unchecked body claim refuses"
reader_refuse "$d/glow/body.rye"
awk '{ print } /^fn / { print "    // house parse law" }' "$d/glow/body.rye" > "$d/body.tmp"
cat "$d/body.tmp" > "$d/glow/body.rye"
run "$d"
check 0 "$(field "$d/out.txt" law_claimed_absent)" "the body claim clears with its check"
check ok "$(field "$d/out.txt" verdict)" "a checked body claim passes"

# --- 11. a nested room is walked ---
d=$(newpen l); reader_accept "$d/glow/nock/nock_dec.rye"; run "$d"
check 1 "$(field "$d/out.txt" readers)" "a reader in a nested Glow room is found"

# --- 12. an empty room reads zero rather than failing ---
d=$(newpen m); run "$d"
check 0 "$(field "$d/out.txt" readers)"  "a room with no readers reads zero"
check 0 "$(field "$d/out.txt" verdicts)" "no readers is no verdicts"
check ok "$(field "$d/out.txt" verdict)" "and an empty room is green rather than an error"

# --- 13. no tree root within the walk ---
bare=$(mktemp -d); mkdir -p "$bare/x"; cp "$scan" "$bare/x/glow_decimal_law_scan.sh"
set +e
( cd "$bare/x" && sh ./glow_decimal_law_scan.sh >/dev/null 2>&1 )
rc=$?
set -e
rm -rf "$bare"
check 2 "$rc" "a copy outside any tree root exits 2 rather than reading this bench"

echo
echo "glow_decimal_law_control: pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
