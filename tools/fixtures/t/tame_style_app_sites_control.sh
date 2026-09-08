#!/bin/sh
# tools/fixtures/t/tame_style_app_sites_control.sh -- prove tame_style_app_sites.sh by doing.
#
# WHY A CONTROL. The fixture decides whether an occurrence is a CALL or the TEXT of a call, and
# that decision moved two published ratchet numbers the day it landed -- `parseInt(` 125 to 46,
# `Ed25519` 26 to 1. A predicate that moves a number is a predicate that has to be shown working
# from both sides: every accept asserted as hard as every refusal, because a refusal proven only
# in the passing direction cannot be told from a bypass.
#
# Every case is planted into a throwaway pen, read, and then removed, so nothing here depends on
# the tree's own contents and the control still passes on a fresh clone.
#
#   sh tools/fixtures/t/tame_style_app_sites_control.sh
#
# Prints one `pass=N fail=M` line and exits non-zero on any failure. Run from the repository root.

set -u

APP="tools/fixtures/t/tame_style_app_sites.sh"
[ -f "$APP" ] || { echo "control: $APP absent" >&2; exit 2; }

PEN=$(mktemp -d) || exit 2
trap 'rm -rf "$PEN"' EXIT INT TERM

pass=0
fail=0

check() {
  want="$1"; got="$2"; what="$3"
  if [ "$want" = "$got" ]; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
    echo "  FAIL  $what -- wanted [$want] got [$got]"
  fi
}

# ---- program position ------------------------------------------------------
cat > "$PEN/call.rye" <<'EOF'
const v = std.fmt.parseInt(u32, text, 10) catch return error.Overflow;
EOF
check 1 "$(sh "$APP" 'parseInt(' "$PEN/call.rye")" "a bare call counts"

cat > "$PEN/trailing.rye" <<'EOF'
const exact: u64 = 32; // Ed25519 seed length
EOF
check 1 "$(sh "$APP" 'Ed25519' "$PEN/trailing.rye")" \
  "a TRAILING comment reads as program -- the documented overcount, asserted so it cannot move in silence"

cat > "$PEN/quoted_arg.rye" <<'EOF'
@memcpy(arm.face[0..6], "minted");
EOF
check 1 "$(sh "$APP" '@memcpy(' "$PEN/quoted_arg.rye")" \
  "a call whose ARGUMENT is a string is still a call -- the parity test reads only what precedes the match"

# ---- prose -----------------------------------------------------------------
cat > "$PEN/comments.rye" <<'EOF'
// parseInt( in an ordinary comment
/// parseInt( in a doc comment
//! parseInt( in a module comment
    // parseInt( indented
EOF
check 0 "$(sh "$APP" 'parseInt(' "$PEN/comments.rye")" "every // /// //! comment form refuses"

# ---- emitted text ----------------------------------------------------------
cat > "$PEN/emitter.rye" <<'EOF'
try append_print(out, &used, "    const a = std.fmt.parseInt(u32, argv[2], 10) catch return 2;\n", .{});
assert(std.mem.indexOf(u8, rye_argv, "parseInt(u32") != null);
EOF
check 0 "$(sh "$APP" 'parseInt(' "$PEN/emitter.rye")" \
  "an emitter writing a call, and a witness asserting on that emitted text, are not calls"

printf 'const src =\n    \\\\    const s = std.fmt.parseInt(u32, argv[1], 10) catch return 2;\n;\n' > "$PEN/multiline.rye"
check 0 "$(sh "$APP" 'parseInt(' "$PEN/multiline.rye")" "a \\\\ multiline-string continuation is program OUTPUT, not a call"

# ---- the two parity traps --------------------------------------------------
cat > "$PEN/escaped.rye" <<'EOF'
print("a \"quoted\" word\n", .{});
const v = std.fmt.parseInt(u32, text, 10) catch return 0;
EOF
check 1 "$(sh "$APP" 'parseInt(' "$PEN/escaped.rye")" "an escaped quote on an earlier line cannot reach this line"

cat > "$PEN/samelinequote.rye" <<'EOF'
if (c == '"') { const v = std.fmt.parseInt(u32, text, 10) catch return 0; }
EOF
check 1 "$(sh "$APP" 'parseInt(' "$PEN/samelinequote.rye")" \
  "a '\"' character literal earlier on the line does not flip parity and hide the call"

cat > "$PEN/both.rye" <<'EOF'
const v = std.fmt.parseInt(u32, t, 10) catch 0; // see "parseInt(" above
EOF
check 1 "$(sh "$APP" 'parseInt(' "$PEN/both.rye")" "code and text on one line counts once -- the elder greps' unit"

# ---- the carried exclusion -------------------------------------------------
cat > "$PEN/x25519.rye" <<'EOF'
const alice_x = X25519.KeyPair.fromEd25519(alice_id) catch unreachable;
const bob_x_pub = X25519.publicKeyFromEd25519(bob_pub) catch unreachable;
const kp = Ed25519.KeyPair.generate();
EOF
check 3 "$(sh "$APP" 'Ed25519' "$PEN/x25519.rye")" "without --exclude all three lines count"
check 1 "$(sh "$APP" --exclude fromEd25519 'Ed25519' "$PEN/x25519.rye")" \
  "--exclude drops the X25519 conversions and keeps the signing site"
check 1 "$(sh "$APP" --exclude FROMED25519 'Ed25519' "$PEN/x25519.rye")" "--exclude is case-insensitive"

# ---- shape and refusal -----------------------------------------------------
check "1 2 4" "$(sh "$APP" --detail 'parseInt(' "$PEN/call.rye" "$PEN/comments.rye" "$PEN/emitter.rye" | head -1)" \
  "--detail prints program, emitted and comment -- 1 call, 2 emitted lines, 4 comment forms"

: > "$PEN/empty.rye"
check 0 "$(sh "$APP" 'parseInt(' "$PEN/empty.rye")" "a file with no hits reads zero rather than refusing"

sh "$APP" 'parseInt(' >/dev/null 2>&1
check 2 "$?" "no file operand refuses with exit 2"
sh "$APP" >/dev/null 2>&1
check 2 "$?" "no pattern at all refuses with exit 2"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
