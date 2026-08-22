#!/bin/sh
# tools/fixtures/ladder_doc_attachment_scan.sh -- a doc block belongs to the
# declaration it describes, and the block says which one that is.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
#
# REDS %134. A lift moves one byte-identical function body into
# caravan/ladder_checks.rye and writes a doc block above it explaining what the
# body does, which rungs folded, and what the widening meter measured. The
# `seat_note` lift inserted its declaration BELOW an existing one while placing
# its doc block ABOVE it, so twenty-four lines describing `seat_note` attached
# to `read_words` and `seat_note` was left with none. Zig binds a doc comment to
# the next declaration, so a reader of `read_words` was told it writes a note,
# and both claims shipped inside a signed commit that ran green -- no witness
# reads prose for the declaration it lands on.
#
#   MEASURE: every doc block in the harness that carries the widening meter's
#   own citation, `REACH_OK family=X`, names the family it folded. That name is
#   the block's own statement of what it documents, so the check is a name
#   against a name rather than a reading of prose.
#
#   CHECK: a block citing `family=X` sits directly above `pub fn X`. When it
#   sits above anything else, two declarations' docs have merged and the lower
#   one stands undocumented.
#
# A harness carrying no citations answers `cited=0` and refuses, since a scan
# that proved nothing must never read as a green.
set -eu

harness="${HARNESS:-caravan/ladder_checks.rye}"

if [ "${1:-}" = "prove-red" ]; then
  fails=0
  ctl=$(mktemp)
  trap 'rm -f "$ctl"' EXIT

  # The exact shape the red wore: a block citing one family, bound to another.
  cat >"$ctl" <<'EOF'
/// Writes one note for a dependent.
///
/// Measured rather than read: `REACH_OK family=seat_note folding=44 widens=0
/// stub=3 fall=531`.
/// Reads the word list a dependent's domain has been handed so far.
pub fn read_words(comptime rung: type, io: std.Io) rung.NoteError!void {
    return;
}

pub fn seat_note(comptime rung: type, io: std.Io) rung.NoteError!void {
    return;
}
EOF
  out=$(HARNESS="$ctl" sh "$0" 2>&1) || true
  printf '%s\n' "$out" | sed 's/^/control-misattached: /'
  case "$out" in
    *verdict=doc_names_another_declaration*) echo "RED_misattached_doc_caught" ;;
    *) echo "verdict=prove_red_failed_to_refuse_misattachment"; fails=1 ;;
  esac

  # A harness with no citation at all proves nothing and must say so.
  blind=$(mktemp)
  trap 'rm -f "$ctl"; rm -f "$blind"' EXIT
  printf 'pub fn read_words(comptime rung: type) void {}\n' >"$blind"
  out=$(HARNESS="$blind" sh "$0" 2>&1) || true
  printf '%s\n' "$out" | sed 's/^/control-blind: /'
  case "$out" in
    *verdict=no_citations*) echo "RED_blind_scan_refused_rather_than_ok" ;;
    *) echo "verdict=prove_red_failed_to_refuse_blindness"; fails=1 ;;
  esac

  # A correctly attached block passes, so the guard is proven to welcome as
  # hard as it refuses -- a gate that reds on valid input teaches a bench to
  # route around it (context/RADIANT_STYLE.md, the pass playbook).
  good=$(mktemp)
  trap 'rm -f "$ctl"; rm -f "$blind"; rm -f "$good"' EXIT
  cat >"$good" <<'EOF'
/// Writes one note for a dependent.
///
/// Measured rather than read: `REACH_OK family=seat_note folding=44 widens=0
/// stub=3 fall=531`.
pub fn seat_note(comptime rung: type, io: std.Io) rung.NoteError!void {
    return;
}
EOF
  out=$(HARNESS="$good" sh "$0" 2>&1) || true
  printf '%s\n' "$out" | sed 's/^/control-attached: /'
  case "$out" in
    *verdict=ok*) echo "PASS_attached_doc_welcomed" ;;
    *) echo "verdict=prove_red_refused_a_correct_block"; fails=1 ;;
  esac

  [ "$fails" -eq 0 ] || exit 2
  exit 1
fi

[ -f "$harness" ] || { echo "verdict=missing_harness"; exit 2; }

report=$(
  awk '
    # A doc block runs unbroken to the declaration beneath it. Track where the
    # current block started, and every family the block cites along the way.
    /^\/\/\// {
      if (!in_doc) { in_doc = 1; cited = ""; cite_line = 0 }
      # The citation wraps: `REACH_OK` may close one line and `family=X` open
      # the next, so the family name is taken wherever it stands in the block.
      if (match($0, /family=[a-z_]+/)) {
        c = substr($0, RSTART, RLENGTH)
        sub(/family=/, "", c)
        cited = c
        cite_line = NR
      }
      next
    }
    /^pub fn [a-z_]+\(/ {
      if (in_doc && cited != "") {
        name = $0
        sub(/^pub fn /, "", name)
        sub(/\(.*/, "", name)
        printf "%d %s %s\n", cite_line, cited, name
      }
      in_doc = 0; cited = ""; next
    }
    { in_doc = 0; cited = "" }
  ' "$harness"
)

cited=$(printf '%s' "$report" | grep -c . || true)
if [ "${cited:-0}" -eq 0 ]; then
  echo "cited=0"
  echo "detail: no REACH_OK citation found in $harness -- the scan can prove nothing"
  echo "verdict=no_citations"
  exit 1
fi

adrift=0
printf '%s\n' "$report" | while read -r ln family decl; do
  [ -n "${family:-}" ] || continue
  [ "$family" = "$decl" ] && continue
  echo "detail: $harness:$ln documents family=$family yet binds to pub fn $decl"
done

adrift=$(printf '%s\n' "$report" | awk '$2 != $3' | grep -c . || true)

echo "cited=$cited"
echo "docs_adrift=$adrift"
if [ "${adrift:-0}" -ne 0 ]; then echo "verdict=doc_names_another_declaration"; exit 1; fi
echo "verdict=ok"
exit 0
