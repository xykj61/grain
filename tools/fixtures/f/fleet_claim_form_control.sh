#!/bin/sh
# fleet_claim_form_control.sh -- prove the claim board's FORM reading, plant by plant, in a pen.
#
# WHY (REDS %787). `construction/fleet-claims.kyri` is a file every ship writes and every ship
# reads, and only its CONTENT was ever checked. Its FORM was read by nobody, so a hand-resolved
# rebase conflict on `20260916` glued three records into one 1,547-byte line, ate a record's
# header, and `fleet_claim_scan.sh --check` answered `verdict=clear` with `claims_live=8`.
#
# EVERY REFUSAL IS SHOWN FROM BOTH SIDES. A refusal proven only in the passing direction cannot be
# told from a bypass, so each plant is made, bitten, removed, and shown to walk free again. The
# clean board is re-asserted between plants, so a reading that reds on everything fails here too.
#
# AND THE FOUNDING DAMAGE IS REPLAYED RATHER THAN DESCRIBED. Phase 20 rebuilds the exact glue that
# fired -- a header pressed against a sentence's full stop with no space, which is what the real
# bytes read and what this reader's own first draft got wrong by writing the pattern from the row's
# prose instead of from the line.
#
#   sh tools/fixtures/f/fleet_claim_form_control.sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
checks=0
failures=0
say() { checks=$((checks + 1)); printf '%s\n' "$1"; case "$1" in *=no) failures=$((failures + 1)) ;; esac; }

pen=$(mktemp -d 2>/dev/null || mktemp -d -t claimform)
cleanup() { rm -rf "$pen"; }
trap cleanup EXIT
mkdir -p "$pen/tools/fixtures/f"
cp "$ROOT/tools/fixtures/f/fleet_claim_form_scan.sh" "$pen/tools/fixtures/f/"
scan="$pen/tools/fixtures/f/fleet_claim_form_scan.sh"
board="$pen/board.kyri"

# A clean two-record board, written fresh before every plant so no plant can leak into the next.
clean() {
  cat > "$board" <<'BOARD'
# a pen board
format fleet-claims-v1

claim port-band
seat bakery
stamp 20260911.180000
epoch 1789000000
paths tools/fixtures/p/port_band_scan.sh
what Seat a port census over the tree.

claim receipt-cloth
seat diffuser
stamp 20260912.090000
epoch 1789100000
paths brushstroke/receipt_card.brix
what Describe the receipt card as a bounded Brushstroke component.
BOARD
}

read_form() { sh "$scan" --list "$board" 2>&1 || true; }
verdict() { read_form | sed -n 's/^verdict=//p'; }
counter() { read_form | sed -n "s/^$1=//p"; }

# A plant is bitten when the verdict refuses AND the named counter carries it. Asserting the
# verdict alone would pass for any reading that reds -- which is how a guard comes to prove that
# something is wrong without ever proving WHAT.
bite() {
  label=$1; key=$2
  v=$(verdict); n=$(counter "$key")
  if [ "$v" = "malformed" ] && [ "${n:-0}" -ge 1 ]; then say "$label=yes"; else say "$label=no"; fi
}
walks_free() {
  label=$1
  if [ "$(verdict)" = "well_formed" ]; then say "$label=yes"; else say "$label=no"; fi
}

clean; walks_free "a_clean_board_is_well_formed"
say "clean_board_records=$(read_form | sed -n 's/^records=//p')"

# 1 -- the orphan: a field above the first header. The content reader drops it in silence, because
# every one of its field rules guards on `if (name != "")`.
clean
printf 'seat ghost\n%s\n' "$(cat "$board")" > "$board.t" && mv "$board.t" "$board"
bite "an_orphan_field_above_the_first_header_is_caught" "orphan_fields"
clean; walks_free "lifting_the_orphan_returns_the_board"

# 2 -- the eaten header: the founding shape. Delete a `claim` line and its five fields land inside
# the record before it, one at a time.
clean
grep -v '^claim receipt-cloth$' "$board" > "$board.t" && mv "$board.t" "$board"
bite "an_eaten_header_is_caught_as_repeated_fields" "repeated_fields"
say "eaten_header_repeats_all_five=$([ "$(counter repeated_fields)" = "5" ] && echo yes || echo no)"
clean; walks_free "lifting_the_eaten_header_returns_the_board"

# 3 -- a record missing one of its five fields.
clean
grep -v '^epoch 1789100000$' "$board" > "$board.t" && mv "$board.t" "$board"
bite "a_record_missing_a_field_is_caught" "missing_fields"
clean; walks_free "lifting_the_missing_field_returns_the_board"

# 4 -- a key this board has no field for.
clean
printf 'owner keaton\n' >> "$board"
bite "an_unknown_key_is_caught" "unknown_keys"
clean; walks_free "lifting_the_unknown_key_returns_the_board"

# 5 -- one name declared twice, which makes two records indistinguishable to every reader.
clean
cat >> "$board" <<'DUP'

claim port-band
seat copal
stamp 20260913.100000
epoch 1789200000
paths tools/x.sh
what A second record wearing a name already taken.
DUP
bite "a_duplicate_claim_name_is_caught" "duplicate_names"
clean; walks_free "lifting_the_duplicate_returns_the_board"

# 6 -- a header carrying no name.
clean
printf '\nclaim\nseat copal\nstamp 20260913.100000\nepoch 1789200000\npaths tools/x.sh\nwhat No name.\n' >> "$board"
bite "a_nameless_header_is_caught" "nameless_records"
clean; walks_free "lifting_the_nameless_header_returns_the_board"

# 7 -- a stamp that is not the one clock's shape.
clean
sed 's/^stamp 20260911.180000$/stamp 2026-09-11 18:00/' "$board" > "$board.t" && mv "$board.t" "$board"
bite "a_stamp_off_the_one_clock_shape_is_caught" "bad_stamps"
clean; walks_free "lifting_the_bad_stamp_returns_the_board"

# 8 -- an epoch that is not UTC seconds. Age is read from this field alone, so a value that does
# not parse makes every staleness reading on the board a guess.
clean
sed 's/^epoch 1789000000$/epoch yesterday/' "$board" > "$board.t" && mv "$board.t" "$board"
bite "an_epoch_that_is_not_seconds_is_caught" "bad_epochs"
clean; walks_free "lifting_the_bad_epoch_returns_the_board"

# 9 -- a field with a key and no value.
clean
sed 's|^paths tools/fixtures/p/port_band_scan.sh$|paths|' "$board" > "$board.t" && mv "$board.t" "$board"
bite "an_empty_field_is_caught" "empty_fields"
clean; walks_free "lifting_the_empty_field_returns_the_board"

# 10 -- an indented field. The content reader anchors on `$1` of an unindented line, so an indented
# key is a key it never sees at all.
clean
sed 's/^seat bakery$/  seat bakery/' "$board" > "$board.t" && mv "$board.t" "$board"
bite "an_indented_field_is_caught" "indented_lines"
clean; walks_free "lifting_the_indent_returns_the_board"

# 11 -- a kebab-case name is the board's own convention; anything else reads as a stray word.
clean
sed 's/^claim port-band$/claim Port Band/' "$board" > "$board.t" && mv "$board.t" "$board"
bite "a_name_outside_kebab_case_is_caught" "bad_names"
clean; walks_free "lifting_the_bad_name_returns_the_board"

# 12 -- a format line inside a record, which means a board was concatenated onto another.
clean
printf 'format fleet-claims-v1\n' >> "$board"
bite "a_format_line_inside_a_record_is_caught" "late_formats"
clean; walks_free "lifting_the_late_format_returns_the_board"

# 13 -- THE FOUNDING SIGNATURE, REPLAYED OFF THE REAL BYTES. The header pressed against the elder
# sentence's full stop with NO space, which is what commit `4bd99090c` actually reads. This
# reader's first draft required a space here, written from the ledger row's prose rather than from
# the line, and it missed the very case it was built for.
clean
sed 's|^what Seat a port census over the tree.$|what Seat a port census over the tree.claim receipt-cloth|' "$board" > "$board.t" && mv "$board.t" "$board"
bite "a_header_glued_to_a_sentence_with_no_space_is_caught" "glued_headers"
clean; walks_free "lifting_the_glue_returns_the_board"

# 14 -- length REPORTS and never gates, and the reason is measured: across 400 revisions of the
# living board the longest honest `what` runs 1,198 bytes against the damaged line's 1,547, so a
# gate would sit in a 349-byte window ordinary work is expected to cross.
clean
# Lengthen an EXISTING `what` rather than appending one -- an appended `what` would land inside the
# last record as a second field and be caught as a repeated field, which would prove the wrong
# thing. The plant must make the line long and nothing else.
longtext=$(awk 'BEGIN { while (i++ < 1600) printf "x" }')
awk -v t="$longtext" '$1 == "what" && !done { print "what " t; done = 1; next } { print }' "$board" > "$board.t" && mv "$board.t" "$board"
long=$(read_form | sed -n 's/^long_lines=//p')
say "a_long_line_is_reported=$([ "${long:-0}" -ge 1 ] && echo yes || echo no)"
say "a_long_line_alone_does_not_refuse=$([ "$(verdict)" = "malformed" ] && echo no || echo yes)"
clean; walks_free "lifting_the_long_line_returns_the_board"

# 15 -- comments and blank lines are the board's own head, and must stay free.
clean
printf '\n# a trailing note about the board\n\n' >> "$board"
walks_free "a_comment_and_a_blank_line_walk_free"

# 16 -- a `what` that merely SAYS the word claim is ordinary prose, and must not be glue.
clean
sed 's|^what Seat a port census over the tree.$|what This claim is a declaration, and every claim expires.|' "$board" > "$board.t" && mv "$board.t" "$board"
walks_free "a_sentence_that_merely_says_claim_walks_free"

# 17 -- an absent board refuses rather than reading as empty and well formed.
missing=$(sh "$scan" "$pen/no-such-board.kyri" 2>&1 || true)
say "an_absent_board_refuses=$(printf '%s' "$missing" | grep -q 'verdict=no_board' && echo yes || echo no)"

# 18 -- the reading must come off stdin as well as off a path, because the content reader hands it
# the ANOINTED REMOTE's bytes, which exist at no path in this tree.
clean
stdin_v=$(sh "$scan" - < "$board" 2>&1 | sed -n 's/^verdict=//p')
say "a_board_on_stdin_is_read=$([ "$stdin_v" = "well_formed" ] && echo yes || echo no)"

# 19 -- MUTATION. Removing the repeated-field reading must red the founding leg. A leg that passes
# with its own reading deleted is a leg proving nothing.
clean
grep -v '^claim receipt-cloth$' "$board" > "$board.t" && mv "$board.t" "$board"
mut="$pen/mutant.sh"
sed 's|^  if ($1 in seen) note("repeated_field".*$|  if (0) note("repeated_field", "");|' "$scan" > "$mut"
mut_v=$(sh "$mut" --list "$board" 2>&1 | sed -n 's/^verdict=//p' || true)
say "mutation_dropping_repeated_fields_bites=$([ "$mut_v" = "well_formed" ] && echo yes || echo no)"

# 20 -- MUTATION. Requiring a space before the glued header reproduces this reader's own first
# draft, which read the row's prose rather than the damaged line. It must go blind to phase 13.
clean
sed 's|^what Seat a port census over the tree.$|what Seat a port census over the tree.claim receipt-cloth|' "$board" > "$board.t" && mv "$board.t" "$board"
sed 's|(\^\|\[\^a-z\])claim|(^\|[ ])claim|' "$scan" > "$mut"
mut_g=$(sh "$mut" --list "$board" 2>&1 | sed -n 's/^glued_headers=//p' || echo 1)
say "mutation_requiring_a_space_before_the_header_bites=$([ "${mut_g:-1}" = "0" ] && echo yes || echo no)"

# 21 -- MUTATION. Restoring the content reader's own forgiving guard -- attributing an orphan field
# to nothing rather than counting it -- must go blind to phase 1.
clean
printf 'seat ghost\n%s\n' "$(cat "$board")" > "$board.t" && mv "$board.t" "$board"
sed 's|^  if (name == "") { note("orphan_field".*$|  if (name == "") { next }|' "$scan" > "$mut"
mut_o=$(sh "$mut" --list "$board" 2>&1 | sed -n 's/^orphan_fields=//p' || echo 1)
say "mutation_restoring_the_forgiving_guard_bites=$([ "${mut_o:-1}" = "0" ] && echo yes || echo no)"

# 22 -- THE INTEGRATION THE RED ACTUALLY BOOKED. The content reader must refuse rather than answer
# `clear` over a malformed board. This is the whole repair: the founding fault was not that the
# board broke, it was that the reader every ship runs said the board was well.
content="$pen/content.sh"
mkdir -p "$pen/c/tools/fixtures/f" "$pen/c/tools/f" "$pen/c/construction"
cp "$ROOT/tools/fixtures/f/fleet_claim_scan.sh"      "$pen/c/tools/fixtures/f/"
cp "$ROOT/tools/fixtures/f/fleet_claim_form_scan.sh" "$pen/c/tools/fixtures/f/"
cp "$ROOT/tools/fixtures/f/fleet_roster_scan.sh"     "$pen/c/tools/fixtures/f/" 2>/dev/null || true
: > "$pen/c/construction/fleet-roster.kyri"
clean
grep -v '^claim receipt-cloth$' "$board" > "$pen/c/construction/fleet-claims.kyri"
c_out=$(cd "$pen/c" && ANOINTED_REMOTE=nowhere sh tools/fixtures/f/fleet_claim_scan.sh --check tools/x.sh 2>&1 || true)
say "the_content_reader_refuses_a_malformed_board=$(printf '%s' "$c_out" | grep -q 'verdict=malformed' && echo yes || echo no)"
say "the_content_reader_offers_no_clear_on_a_broken_board=$(printf '%s' "$c_out" | grep -q 'verdict=clear' && echo no || echo yes)"
clean
cp "$board" "$pen/c/construction/fleet-claims.kyri"
c_ok=$(cd "$pen/c" && ANOINTED_REMOTE=nowhere sh tools/fixtures/f/fleet_claim_scan.sh --check tools/x.sh 2>&1 || true)
say "a_well_formed_board_still_reads_clear=$(printf '%s' "$c_ok" | grep -q 'verdict=clear' && echo yes || echo no)"
say "the_content_reader_names_the_form_it_read=$(printf '%s' "$c_ok" | grep -q 'form=readable' && echo yes || echo no)"

# 22b -- THE SPLIT, PROVEN FROM THE SIDE THAT COSTS SOMETHING. A CONFINED finding must NOT make the
# content reader refuse. `fleet_claim_control.sh`'s own pen board carries a record with no `epoch`
# on purpose, to prove the content reader names it `undated` -- so a form reading that refused on
# the total rather than on `corrupting` would red a peer's proven guard for a record that corrupts
# nothing. The board below is that exact shape.
clean
grep -v '^epoch 1789100000$' "$board" > "$pen/c/construction/fleet-claims.kyri"
c_conf=$(cd "$pen/c" && ANOINTED_REMOTE=nowhere sh tools/fixtures/f/fleet_claim_scan.sh --check tools/x.sh 2>&1 || true)
say "a_confined_finding_does_not_make_the_reader_refuse=$(printf '%s' "$c_conf" | grep -q 'verdict=clear' && echo yes || echo no)"
say "a_confined_finding_is_still_counted_to_the_reader=$(printf '%s' "$c_conf" | grep -q 'confined=1' && echo yes || echo no)"
clean
grep -v '^claim receipt-cloth$' "$board" > "$pen/c/construction/fleet-claims.kyri"
say "and_a_corrupting_finding_still_refuses=$(cd "$pen/c" && ANOINTED_REMOTE=nowhere sh tools/fixtures/f/fleet_claim_scan.sh --check tools/x.sh 2>&1 | grep -q 'verdict=malformed' && echo yes || echo no)"

# 22c -- MUTATION. Pointing the content reader at the TOTAL rather than at `corrupting` must red
# the confined leg, since that is precisely the over-refusal the split exists to prevent.
clean
grep -v '^epoch 1789100000$' "$board" > "$pen/c/construction/fleet-claims.kyri"
sed "s|sed -n 's/\^corrupting=//p'|sed -n 's/^malformed=//p'|" "$pen/c/tools/fixtures/f/fleet_claim_scan.sh" > "$pen/c/tools/fixtures/f/mutant_scan.sh"
c_mut=$(cd "$pen/c" && ANOINTED_REMOTE=nowhere sh tools/fixtures/f/mutant_scan.sh --check tools/x.sh 2>&1 || true)
say "mutation_refusing_on_the_total_bites=$(printf '%s' "$c_mut" | grep -q 'verdict=malformed' && echo yes || echo no)"
rm -f "$pen/c/tools/fixtures/f/mutant_scan.sh"

# 23 -- a missing form reader is NAMED rather than passed over, since a silent skip is the same
# silence that let the damaged board read clear.
rm -f "$pen/c/tools/fixtures/f/fleet_claim_form_scan.sh"
c_no=$(cd "$pen/c" && ANOINTED_REMOTE=nowhere sh tools/fixtures/f/fleet_claim_scan.sh --check tools/x.sh 2>&1 || true)
say "an_absent_form_reader_is_named_out_loud=$(printf '%s' "$c_no" | grep -q 'form=unread' && echo yes || echo no)"

say "control_legs=$checks"
say "control_failures=$failures"
if [ "$failures" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=failed"; exit 1; fi
