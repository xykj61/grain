#!/bin/sh
# tools/fixtures/e/error_member_reach_control.sh -- proves tools/fixtures/e/error_member_reach_scan.sh
# both ways on miniature Rye sources in a throwaway pen.
#
# Every refusal is planted and then LIFTED, so a refusal stays tellable from a bypass: a scan that
# always answered `dead_sites=1` would pass the planted leg and fail the lifted one. Every welcome
# is asserted as hard as every refusal, because a meter that counts nothing reads exactly like a
# tree with nothing to count.
#
#   sh tools/fixtures/e/error_member_reach_control.sh

set -u
LC_ALL=C
export LC_ALL

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_em_steps=0
while [ ! -d "$ROOT/tools/fixtures" ] || [ ! -d "$ROOT/.git" ]; do
  _em_steps=$((_em_steps + 1))
  if [ "$_em_steps" -gt 8 ] || [ "$ROOT" = "/" ]; then
    echo "$0: no tree root within 8 steps" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
SCAN=${ERROR_MEMBER_SCAN:-$ROOT/tools/fixtures/e/error_member_reach_scan.sh}

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT INT TERM

legs=0
fail=0

leg() {
  legs=$((legs + 1))
  name=$1
  want=$2
  got=$3
  if [ "$want" = "$got" ]; then
    echo "leg $legs $name ok"
  else
    fail=$((fail + 1))
    echo "leg $legs $name FAIL want=$want got=$got"
  fi
}

read_leg() {
  key=$1
  out=$2
  printf '%s\n' "$out" | sed -n "s/^$key=//p"
}

run_scan() {
  # $1 pen corpus directory; remaining arguments pass through
  d=$1
  shift
  ERROR_MEMBER_CORPUS="$d" sh "$SCAN" "$@" 2>&1
}

# ---------------------------------------------------------------- pen: produced
mkdir -p "$pen/live"
cat > "$pen/live/a.rye" <<'RYE'
pub const ParseError = error{
    Produced,
};
pub fn f() ParseError!void {
    return error.Produced;
}
RYE

out=$(run_scan "$pen/live"); rc=$?
leg produced_not_dead 0 "$(read_leg dead_sites "$out")"
leg produced_counts_as_member 1 "$(read_leg members "$out")"
leg produced_exit_ok 0 "$rc"
leg produced_verdict ok "$(read_leg verdict "$out")"

# ---------------------------------------------------------------- plant: a dead member
cat > "$pen/live/b.rye" <<'RYE'
pub const OtherError = error{
    NeverMade,
};
RYE
out=$(run_scan "$pen/live")
leg planted_dead_site 1 "$(read_leg dead_sites "$out")"
leg planted_dead_name 1 "$(read_leg dead_names "$out")"
out=$(run_scan "$pen/live" --list)
leg planted_named "1" "$(printf '%s\n' "$out" | grep -c 'b.rye NeverMade')"

# lift the plant -- the refusal must go away, or it is not a refusal
rm -f "$pen/live/b.rye"
out=$(run_scan "$pen/live")
leg lifted_dead_site 0 "$(read_leg dead_sites "$out")"

# ---------------------------------------------------------------- qualified production
cat > "$pen/live/c.rye" <<'RYE'
pub const QualError = error{
    QualMade,
};
pub fn g() QualError!void {
    return QualError.QualMade;
}
RYE
out=$(run_scan "$pen/live")
leg qualified_production_counts 0 "$(read_leg dead_sites "$out")"

# ---------------------------------------------------------------- comment-only mention
cat > "$pen/live/d.rye" <<'RYE'
pub const DocError = error{
    OnlyInProse,
};
// This module refuses with error.OnlyInProse when the tide is out.
RYE
out=$(run_scan "$pen/live")
leg comment_mention_is_not_production 1 "$(read_leg dead_sites "$out")"
rm -f "$pen/live/d.rye"

# ---------------------------------------------------------------- inline set in a signature
# An inline set stands in a DECLARATION rather than a function body, so no `}` follows it to
# close a block opened by mistake. That is the shape where the open guard earns its place: with
# the guard gone, `Ghost` below reads as a declared error member nothing produces.
cat > "$pen/live/e.rye" <<'RYE'
pub const Handler = fn () error{Inline}!void;
pub const Kind = enum {
    Ghost,
};
RYE
out=$(run_scan "$pen/live")
leg inline_set_opens_no_block 0 "$(read_leg dead_sites "$out")"
leg inline_set_member_uncounted 2 "$(read_leg members "$out")"
rm -f "$pen/live/e.rye"

# ---------------------------------------------------------------- trailing comment on a member
cat > "$pen/live/f.rye" <<'RYE'
pub const TrailError = error{
    WithComment, // the reason this refusal exists
};
RYE
out=$(run_scan "$pen/live")
leg trailing_comment_member_counted 1 "$(read_leg dead_sites "$out")"
out=$(run_scan "$pen/live" --list)
leg trailing_comment_named 1 "$(printf '%s\n' "$out" | grep -c 'f.rye WithComment')"
rm -f "$pen/live/f.rye"

# ---------------------------------------------------------------- shared vocabulary across files
cat > "$pen/live/g1.rye" <<'RYE'
pub const SharedError = error{
    SharedName,
};
RYE
cat > "$pen/live/g2.rye" <<'RYE'
pub const SharedError = error{
    SharedName,
};
pub fn k() SharedError!void {
    return error.SharedName;
}
RYE
out=$(run_scan "$pen/live")
leg shared_vocabulary_not_dead 0 "$(read_leg dead_sites "$out")"
leg shared_vocabulary_unreached 1 "$(read_leg unreached_in_file "$out")"
rm -f "$pen/live/g1.rye" "$pen/live/g2.rye"

# ---------------------------------------------------------------- the ceiling, both sides
cat > "$pen/live/h.rye" <<'RYE'
pub const CeilError = error{
    CeilOne,
    CeilTwo,
};
RYE
out=$(ERROR_MEMBER_DEAD_CEILING=2 run_scan "$pen/live"); rc=$?
leg ceiling_at_bound_ok ok "$(read_leg verdict "$out")"
leg ceiling_at_bound_exit 0 "$rc"
out=$(ERROR_MEMBER_DEAD_CEILING=1 run_scan "$pen/live"); rc=$?
leg ceiling_over_refuses dead_over_ceiling "$(read_leg verdict "$out")"
leg ceiling_over_exit 1 "$rc"
rm -f "$pen/live/h.rye"

# ---------------------------------------------------------------- a corpus with no sources
mkdir -p "$pen/empty"
out=$(run_scan "$pen/empty"); rc=$?
leg empty_corpus_refuses no_corpus "$(read_leg verdict "$out")"
leg empty_corpus_exit 1 "$rc"

# ---------------------------------------------------------------- lowercase field is no member
cat > "$pen/live/i.rye" <<'RYE'
pub const Row = struct {
    name: u32,
    other: u32,
};
RYE
out=$(run_scan "$pen/live")
leg struct_field_is_no_member 0 "$(read_leg dead_sites "$out")"
rm -f "$pen/live/i.rye"

echo "control_legs=$legs control_fail=$fail"
if [ "$fail" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=control_failed"
exit 1
