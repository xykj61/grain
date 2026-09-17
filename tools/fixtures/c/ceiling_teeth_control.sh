#!/bin/sh
# tools/fixtures/c/ceiling_teeth_control.sh -- the ceiling-teeth reading, proven on real Rye
# sources in a throwaway pen.
#
# WHY A CONTROL. tools/fixtures/c/ceiling_teeth_scan.sh sorts every declared `pub const max_*`
# into the strongest thing its own file does with it, and gates the one reading that needs no
# judgment -- a ceiling nothing reads. A gate is a claim about a refusal, and a refusal nobody has
# tried to produce is a hope. So every class is shown from both sides here: the honest form passes
# free, the fault is planted and bites, and the repair lifts it again.
#
# THE LOAD-BEARING LEG IS THE REPAIR. A guard that refuses an unread ceiling and keeps refusing
# after the ceiling is given teeth would punish the fix, and a guard that punishes the fix is a
# guard somebody turns off. Leg 8 plants the fault, leg 9 repairs it in the same pen, and the
# scan is run again.
#
# THE PEN IS A REAL GIT REPOSITORY, because the scan reads its corpus with `git ls-files` and asks
# `git grep` whether a constant is read anywhere else. A pen of loose files would make every
# constant read as unread, which is the answer the gate is built to give, so the pen would agree
# with the guard for the wrong reason.
#
# Run from the repository root.

set -f

root="$(pwd)"
scan="$root/tools/fixtures/c/ceiling_teeth_scan.sh"
[ -f "$scan" ] || { echo "control_verdict=broken"; echo "detail: $scan is absent"; exit 1; }

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

fail=0
ok() { echo "$1 -- ok"; }
no() { echo "$1 -- FAILED"; fail=$((fail + 1)); }

# One pen: a git repository holding a single room the scan is pointed at by name.
make_pen() {
  _pen="$1"
  mkdir -p "$_pen/room"
  ( cd "$_pen" && git init -q . && git config user.email pen@example.invalid \
      && git config user.name pen ) >/dev/null 2>&1
}

stage() { ( cd "$1" && git add -A ) >/dev/null 2>&1; }

read_scan() { ( cd "$1" && sh "$scan" room 2>&1 ); }

# ---------------------------------------------------------------------------
# 1 free: a ceiling refused by a named error reads as refused.
pen="$work/refused"
make_pen "$pen"
cat > "$pen/room/a.rye" <<'EOF'
const std = @import("std");
pub const RoomError = error{TooMany};
pub const max_items: u32 = 8;
pub fn take(n: u32) RoomError!void {
    if (n > max_items) return RoomError.TooMany;
}
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"refused=1"*) ok "1 free: a ceiling refused by name reads as refused" ;;
  *) no "1 free: a ceiling refused by name reads as refused"; echo "$out" ;;
esac
case "$out" in
  *"verdict=ok"*) ok "1 free: an honest room passes" ;;
  *) no "1 free: an honest room passes"; echo "$out" ;;
esac

# ---------------------------------------------------------------------------
# 2 free: a ceiling sizing an array is held by the compiler.
pen="$work/structural"
make_pen "$pen"
cat > "$pen/room/a.rye" <<'EOF'
pub const max_slots: u32 = 4;
pub const Table = struct {
    slots: [max_slots]u32,
};
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"structural=1"*) ok "2 free: a ceiling sizing an array reads as structural" ;;
  *) no "2 free: a ceiling sizing an array reads as structural"; echo "$out" ;;
esac

# ---------------------------------------------------------------------------
# 3 free: a value clamped to the ceiling is bounded by construction.
pen="$work/cut"
make_pen "$pen"
cat > "$pen/room/a.rye" <<'EOF'
const std = @import("std");
pub const max_body: u32 = 96;
pub fn take(remain: u32) u32 {
    return @min(remain, max_body);
}
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"cut=1"*) ok "3 free: a clamped value reads as cut" ;;
  *) no "3 free: a clamped value reads as cut"; echo "$out" ;;
esac

# ---------------------------------------------------------------------------
# 4 free: a ceiling a second constant derives from carries its teeth there.
pen="$work/derived"
make_pen "$pen"
cat > "$pen/room/a.rye" <<'EOF'
const std = @import("std");
pub const RoomError = error{TooBig};
pub const max_table_bytes: u64 = 1 << 20;
pub const max_table_cells: u64 = max_table_bytes / @sizeOf(u32);
pub fn take(cells: u64) RoomError!void {
    if (cells > max_table_cells) return RoomError.TooBig;
}
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"derived=1"*) ok "4 free: a ceiling a second constant derives from reads as derived" ;;
  *) no "4 free: a ceiling a second constant derives from reads as derived"; echo "$out" ;;
esac

# ---------------------------------------------------------------------------
# 5 bitten: an assert-only ceiling counts, and refuses past its own ceiling.
pen="$work/asserted"
make_pen "$pen"
cat > "$pen/room/a.rye" <<'EOF'
const std = @import("std");
const assert = std.debug.assert;
pub const max_wire: u32 = 340;
pub fn take(off: u32) void {
    assert(off <= max_wire);
}
EOF
cat > "$pen/room/b.rye" <<'EOF'
const std = @import("std");
const assert = std.debug.assert;
pub const max_frame: u32 = 64;
pub fn take(off: u32) void {
    assert(off <= max_frame);
}
EOF
stage "$pen"
out="$(CEILING_TEETH_ASSERTED_CEILING=1 read_scan "$pen")"
case "$out" in
  *"verdict=asserted_spread"*) ok "5 bitten: an assert-only population past its ceiling refuses" ;;
  *) no "5 bitten: an assert-only population past its ceiling refuses"; echo "$out" ;;
esac
case "$out" in
  *"asserted_only=2"*) ok "5 bitten: the count is the population rather than a file" ;;
  *) no "5 bitten: the count is the population rather than a file"; echo "$out" ;;
esac

# 6 free: the same population at exactly its ceiling passes, so it is a ceiling and not a wall.
out="$(CEILING_TEETH_ASSERTED_CEILING=2 read_scan "$pen")"
case "$out" in
  *"verdict=ok"*) ok "6 free: the same population at exactly its ceiling passes free" ;;
  *) no "6 free: the same population at exactly its ceiling passes free"; echo "$out" ;;
esac

# ---------------------------------------------------------------------------
# 7 bitten: a ceiling nothing reads refuses, and the refusal names its file and its constant.
pen="$work/unread"
make_pen "$pen"
cat > "$pen/room/a.rye" <<'EOF'
const std = @import("std");
pub const max_mirror_pairs: u32 = 4;
pub fn walk(pairs: []const u32) u32 {
    var i: u32 = 0;
    var total: u32 = 0;
    while (i < pairs.len) : (i += 1) total += pairs[i];
    return total;
}
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"verdict=unread_ceiling"*) ok "7 bitten: a ceiling nothing reads refuses" ;;
  *) no "7 bitten: a ceiling nothing reads refuses"; echo "$out" ;;
esac
case "$out" in
  *"room/a.rye declares max_mirror_pairs"*) ok "7 bitten: the refusal names the file and the constant" ;;
  *) no "7 bitten: the refusal names the file and the constant"; echo "$out" ;;
esac

# 8 free: the repair is rewarded -- the same ceiling, given a named refusal, leaves the population.
cat > "$pen/room/a.rye" <<'EOF'
const std = @import("std");
pub const RoomError = error{TooManyPairs};
pub const max_mirror_pairs: u32 = 4;
pub fn walk(pairs: []const u32) RoomError!u32 {
    if (pairs.len > max_mirror_pairs) return RoomError.TooManyPairs;
    var i: u32 = 0;
    var total: u32 = 0;
    while (i < pairs.len) : (i += 1) total += pairs[i];
    return total;
}
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"unread=0"*) ok "8 free: the same ceiling given a named refusal leaves the population" ;;
  *) no "8 free: the same ceiling given a named refusal leaves the population"; echo "$out" ;;
esac
case "$out" in
  *"verdict=ok"*) ok "8 free: the repaired room passes" ;;
  *) no "8 free: the repaired room passes"; echo "$out" ;;
esac

# ---------------------------------------------------------------------------
# 9 free: a ceiling read by a SIBLING file is read, so it never counts as unread.
pen="$work/sibling"
make_pen "$pen"
cat > "$pen/room/a.rye" <<'EOF'
pub const max_peers: u32 = 6;
EOF
cat > "$pen/room/b.rye" <<'EOF'
const a = @import("a.rye");
pub const RoomError = error{TooMany};
pub fn take(n: u32) RoomError!void {
    if (n > a.max_peers) return RoomError.TooMany;
}
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"unread=0"*) ok "9 free: a ceiling read by a sibling file is not unread" ;;
  *) no "9 free: a ceiling read by a sibling file is not unread"; echo "$out" ;;
esac

# ---------------------------------------------------------------------------
# 10 free: a private ceiling is the module's own business, never a promise to a caller.
pen="$work/private"
make_pen "$pen"
cat > "$pen/room/a.rye" <<'EOF'
pub const max_items: u32 = 8;
pub const RoomError = error{TooMany};
const max_private: u32 = 3;
pub fn take(n: u32) RoomError!void {
    if (n > max_items) return RoomError.TooMany;
}
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"ceilings_declaring=1"*) ok "10 free: a private const is not a declared ceiling" ;;
  *) no "10 free: a private const is not a declared ceiling"; echo "$out" ;;
esac

# ---------------------------------------------------------------------------
# 11 free: a witness source is read past, since a witness bounds its own fixtures.
pen="$work/witness"
make_pen "$pen"
cat > "$pen/room/a_witness.rye" <<'EOF'
pub const max_planted_rows: u32 = 4;
EOF
cat > "$pen/room/a.rye" <<'EOF'
pub const max_items: u32 = 8;
pub const RoomError = error{TooMany};
pub fn take(n: u32) RoomError!void {
    if (n > max_items) return RoomError.TooMany;
}
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"ceilings_declaring=1"*) ok "11 free: a witness source is read past" ;;
  *) no "11 free: a witness source is read past"; echo "$out" ;;
esac

# ---------------------------------------------------------------------------
# 12 bitten: a room with no declared ceiling says so rather than reading clean.
pen="$work/empty"
make_pen "$pen"
cat > "$pen/room/a.rye" <<'EOF'
pub fn take(n: u32) u32 {
    return n;
}
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"verdict=empty_corpus"*) ok "12 bitten: a reading over no ceilings says so rather than passing" ;;
  *) no "12 bitten: a reading over no ceilings says so rather than passing"; echo "$out" ;;
esac

# ---------------------------------------------------------------------------
# 13 free: an honest file beside a faulty one never masks it.
pen="$work/mixed"
make_pen "$pen"
cat > "$pen/room/good.rye" <<'EOF'
pub const max_items: u32 = 8;
pub const RoomError = error{TooMany};
pub fn take(n: u32) RoomError!void {
    if (n > max_items) return RoomError.TooMany;
}
EOF
cat > "$pen/room/bad.rye" <<'EOF'
pub const max_orphan: u32 = 5;
pub fn take(n: u32) u32 {
    return n;
}
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"unread=1"*) ok "13 free: an honest file never masks an unread ceiling beside it" ;;
  *) no "13 free: an honest file never masks an unread ceiling beside it"; echo "$out" ;;
esac

# ---------------------------------------------------------------------------
# THE BLOCK READING (REDS `20260917.040203`). Until 20260917 a refusal was read three lines forward from the
# condition. That window failed both ways at once: it MISSED a refusal record filled between the
# test and the return, and it ADMITTED a comment whose prose carried the word `and` above an
# unrelated named-error return. Every leg below is one half of one of those two faults.

# 14 free: a refusal record filled between the condition and the return still reads as refused --
# the founding case, glow/tokens.rye in miniature.
pen="$work/record"
make_pen "$pen"
cat > "$pen/room/a.rye" <<'EOF'
const std = @import("std");
pub const RoomError = error{BadToken};
pub const max_name_len: u32 = 64;
pub const Slot = struct { value: u32, ceiling: u32 };
pub fn scan_name(n: u32, slot: *Slot) RoomError!u32 {
    if (n > max_name_len) {
        // invariant: the record names the measure rather than the offending text, because the
        // text is exactly what did not fit, and a caller tells this refusal from its siblings
        // without holding the oversized name to do it.
        slot.* = .{
            .value = n,
            .ceiling = max_name_len,
        };
        return RoomError.BadToken;
    }
    return n;
}
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"refused=1"*) ok "14 free: a refusal record between the test and the return still reads as refused" ;;
  *) no "14 free: a refusal record between the test and the return still reads as refused"; echo "$out" ;;
esac

# 15 bitten: the same file with its return removed falls out of refused -- the plant lifted from
# leg 14, so the block walk is proven to read the RETURN rather than merely the distance.
pen="$work/record_toothless"
make_pen "$pen"
cat > "$pen/room/a.rye" <<'EOF'
const std = @import("std");
pub const max_name_len: u32 = 64;
pub const Slot = struct { value: u32, ceiling: u32 };
pub fn scan_name(n: u32, slot: *Slot) u32 {
    if (n > max_name_len) {
        // invariant: the record names the measure rather than the offending text.
        slot.* = .{
            .value = n,
            .ceiling = max_name_len,
        };
    }
    return n;
}
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"refused=0"*) ok "15 bitten: the same block without a named-error return leaves refused" ;;
  *) no "15 bitten: the same block without a named-error return leaves refused"; echo "$out" ;;
esac

# 16 bitten: a COMMENT naming the ceiling, carrying the word `and`, standing above an unrelated
# named-error return is not a refusal -- crypto/vault_seal.rye's shape, which the window admitted.
pen="$work/comment_prose"
make_pen "$pen"
cat > "$pen/room/a.rye" <<'EOF'
const std = @import("std");
pub const RoomError = error{PayloadTooLong};
pub const max_plain_bytes: u32 = 64;
pub const max_frame_bytes: u32 = 128;
pub fn seal(plain: []const u8) RoomError!void {
    // invariant: the plaintext fits the AEAD's bound and the whole frame fits max_frame_bytes.
    if (plain.len > max_plain_bytes) return RoomError.PayloadTooLong;
}
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"asserted-only: room/a.rye declares max_frame_bytes"*) ok "16 bitten: a ceiling named only in a comment is not refused by the return below it" ;;
  *) no "16 bitten: a ceiling named only in a comment is not refused by the return below it"; echo "$out" ;;
esac
case "$out" in
  *"refused=1"*) ok "16 bitten: the ceiling the condition actually names keeps its refusal" ;;
  *) no "16 bitten: the ceiling the condition actually names keeps its refusal"; echo "$out" ;;
esac

# 17 free: the two-line braceless form keeps its place -- the condition on one line, the return on
# the next, which this tree writes as often as the single line.
pen="$work/braceless_two"
make_pen "$pen"
cat > "$pen/room/a.rye" <<'EOF'
const std = @import("std");
pub const RoomError = error{TooMany};
pub const max_items: u32 = 8;
pub fn take(n: u32) RoomError!void {
    if (n > max_items)
        return RoomError.TooMany;
}
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"refused=1"*) ok "17 free: the two-line braceless refusal reads as refused" ;;
  *) no "17 free: the two-line braceless refusal reads as refused"; echo "$out" ;;
esac

# 18 free: a condition spanning several lines closes where its parentheses close, rather than after
# a line count somebody guessed.
pen="$work/multiline_cond"
make_pen "$pen"
cat > "$pen/room/a.rye" <<'EOF'
const std = @import("std");
pub const RoomError = error{TooMany};
pub const max_items: u32 = 8;
pub fn take(n: u32, m: u32) RoomError!void {
    if (n > max_items or
        m > max_items or
        n + m > max_items)
    {
        return RoomError.TooMany;
    }
}
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"refused=1"*) ok "18 free: a multi-line condition closes at its parentheses" ;;
  *) no "18 free: a multi-line condition closes at its parentheses"; echo "$out" ;;
esac

# 19 bitten: a named-error return standing AFTER the condition's block closes belongs to the
# function rather than to the test, and never reads as that ceiling's refusal.
pen="$work/after_block"
make_pen "$pen"
cat > "$pen/room/a.rye" <<'EOF'
const std = @import("std");
pub const RoomError = error{Elsewhere};
pub const max_items: u32 = 8;
pub fn take(n: u32, flag: bool) RoomError!u32 {
    if (n > max_items) {
        return n;
    }
    if (flag) return RoomError.Elsewhere;
    return n;
}
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"refused=0"*) ok "19 bitten: a return past the closing brace is not that ceiling's refusal" ;;
  *) no "19 bitten: a return past the closing brace is not that ceiling's refusal"; echo "$out" ;;
esac

# 20 bitten: a ceiling named inside a STRING LITERAL is not refused by the error return that
# literal is built with -- glow/lower_shop_gate.rye's shape, where the emitted Glow source spells
# its own `if (` and the emitter's `catch return error.Overflow` sits on the same line.
pen="$work/string_lit"
make_pen "$pen"
cat > "$pen/room/a.rye" <<'EOF'
const std = @import("std");
pub const RoomError = error{Overflow};
pub const max_sumto_call: u32 = 65535;
pub fn emit(buf: []u8, face: []const u8) RoomError![]u8 {
    return std.fmt.bufPrint(buf, "if ({s} > {d}) 0 else 1", .{ face, max_sumto_call }) catch return RoomError.Overflow;
}
EOF
stage "$pen"
out="$(read_scan "$pen")"
case "$out" in
  *"asserted-only: room/a.rye declares max_sumto_call"*) ok "20 bitten: a ceiling named inside a string literal is not refused by that line" ;;
  *) no "20 bitten: a ceiling named inside a string literal is not refused by that line"; echo "$out" ;;
esac

# ---------------------------------------------------------------------------
# MUTATIONS. Each removes one half of the block reading from a copy of the scan and asserts the
# leg above it goes the other way. A repair proven only by its new number cannot be told from a
# number that was always there.

# A mutation removes one line from a copy of the scan by its own text, rather than by a line
# number a later edit would move. Each marker is asserted to stand in the scan first, since a
# mutation that removes nothing runs the unmutated file and reads as a passing leg -- a dead plant.
mutate() { grep -vF "$2" "$scan" > "$1"; }
marker_stands() {
  if [ "$(grep -cF "$1" "$scan")" -eq 1 ]; then ok "$2"; else no "$2"; fi
}

m_str='gsub(/"[^"]*"/, "", s)'
m_com='sub(/\/\/.*$/, "", s)'
m_blk='if (j > h && strip[j] ~ /return [A-Za-z]*[Ee]rror\./) { exit 0 }'

marker_stands "$m_str" "M0: the string-blanking line stands once in the scan"
marker_stands "$m_com" "M0: the comment-stripping line stands once in the scan"
marker_stands "$m_blk" "M0: the block-walk return test stands once in the scan"

# M1: without the string blanking, leg 20's literal reads as a refusal again.
mutate "$work/m_strings.sh" "$m_str"
out="$( cd "$work/string_lit" && sh "$work/m_strings.sh" room 2>&1 )"
case "$out" in
  *"refused=1"*) ok "M1 bitten: removing the string blanking admits a refusal spelled inside a literal" ;;
  *) no "M1 bitten: removing the string blanking admits a refusal spelled inside a literal"; echo "$out" ;;
esac

# M2: without the comment stripping, leg 16's prose reads as a refusal again.
mutate "$work/m_comments.sh" "$m_com"
out="$( cd "$work/comment_prose" && sh "$work/m_comments.sh" room 2>&1 )"
case "$out" in
  *"refused=2"*) ok "M2 bitten: removing the comment stripping admits a refusal spelled in prose" ;;
  *) no "M2 bitten: removing the comment stripping admits a refusal spelled in prose"; echo "$out" ;;
esac

# M3: without the block walk the reading falls back to the header line alone, so leg 14's record
# between the test and the return stops reading as a refusal.
mutate "$work/m_block.sh" "$m_blk"
out="$( cd "$work/record" && sh "$work/m_block.sh" room 2>&1 )"
case "$out" in
  *"refused=0"*) ok "M3 bitten: removing the block walk loses the refusal it was built to find" ;;
  *) no "M3 bitten: removing the block walk loses the refusal it was built to find"; echo "$out" ;;
esac

echo "control_fail=$fail"
if [ "$fail" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=broken"
  exit 1
fi
