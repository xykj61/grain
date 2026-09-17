#!/bin/sh
# tools/fixtures/f/fleet_claim_form_scan.sh -- is the claim board itself well formed?
#
#   sh tools/fixtures/f/fleet_claim_form_scan.sh            # the living board
#   sh tools/fixtures/f/fleet_claim_form_scan.sh <path>     # a named board
#   sh tools/fixtures/f/fleet_claim_form_scan.sh -          # a board on stdin
#   sh tools/fixtures/f/fleet_claim_form_scan.sh --list     # every finding, one per line
#
# WHY THIS EXISTS (REDS %787). `construction/fleet-claims.kyri` is a file every ship writes and
# every ship reads, and this tree checked only one of its two shapes. Its CONTENT is read on every
# lap by `tools/fixtures/f/fleet_claim_scan.sh` -- overlap, staleness, expiry, the `what` sentences
# a hand compares by eye. Its FORM was read by nobody.
#
# THE READER IS FORGIVING BY CONSTRUCTION, WHICH IS RIGHT FOR READING AND EXACTLY WRONG FOR
# NOTICING. Every field rule in that reader's awk program guards on `if (name != "")`, so a field
# standing above the first `claim` header is dropped in silence, and a record whose own header is
# eaten donates its five fields to the record declared before it, overwriting them one at a time.
#
# ON `20260916` A HAND RESOLVING A REBASE CONFLICT DID EXACTLY THAT. Three lines were joined with
# their newlines missing: one peer's `what`, 827 duplicated bytes of another's, and the bare
# `claim` header of the record standing after them. One line, 1,547 bytes. The record whose header
# was eaten stood on the board as a headerless body, so a live claim of a working ship was
# invisible to the one instrument built to show it -- and `--check` answered `verdict=clear` with
# `claims_live=8`. Every ship that opened a lap in those minutes was told the board was well.
#
# THE DAMAGE CAME FROM THE ONE OPERATION NO TOOL PERFORMS: a conflict resolved by a hand on a
# shared append-only file. `%291`'s one-writer-per-checkout law does not reach it, because the two
# writers sat in two different checkouts and both obeyed it.
#
# TWO KINDS OF FINDING, AND THE KIND DECIDES WHO REFUSES. A CORRUPTING finding puts a field or a
# record in the wrong place, so some OTHER record reads false -- an orphan, an eaten header, a
# glued line, an indented key, a duplicated name. The content reader refuses on those, because its
# own answer has stopped being about the board. A CONFINED finding stays inside its own record --
# a missing field, a stray key, a stamp that does not parse -- and the content reader already
# models the honest cases, printing `status=undated` for a record carrying no `epoch`. Those are
# reported here and held at zero on the LIVING board by the witness.
#
# WHAT GATES, AND WHY LENGTH DOES NOT. The seven structural readings gate at zero, because each
# names a shape no honest writer produces. `long_lines` REPORTS, and the measurement is why:
# across 400 revisions of this board the longest honest `what` runs **1,198 bytes** and the one
# damaged line ran **1,547**, so a gate would sit in a 349-byte window that ordinary work is
# expected to cross. A bound that reds on honest work is a bound somebody turns off. The founding
# damage is caught at zero anyway, structurally and with no magic number, by `repeated_fields`:
# the eaten record's `seat` landed inside a record that already had one.
#
# WHAT THIS DOES NOT REACH. Whether a `what` sentence is TRUE, whether a `seat` names a live ship
# (a new seat is lawful and a roster read would refuse it), and whether a claim should have been
# written at all. This reads shape and stops there; the content reader beside it reads the rest.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$ROOT"

# Above every honest line ever written and below the one damaged line -- a sentinel, never a gate.
LONG_LINE_BYTES=${FLEET_CLAIM_LINE_BYTES:-1536}
# A board nobody clears is a board nobody reads; the content reader bounds the LIVE claims at 64,
# so the same number bounds the records this one parses.
MAX_RECORDS=${FLEET_CLAIM_MAX:-64}

list=no
board=${FLEET_CLAIM_BOARD:-construction/fleet-claims.kyri}
for a in "$@"; do
  case "$a" in
    --list) list=yes ;;
    -) board=- ;;
    -*) echo "detail: unknown flag $a"; echo "verdict=bad_flag"; exit 2 ;;
    *) board=$a ;;
  esac
done

if [ "$board" = "-" ]; then
  text=$(cat)
  board_name=stdin
elif [ -f "$board" ]; then
  text=$(cat "$board")
  board_name=$board
else
  echo "detail: no board at $board"
  echo "verdict=no_board"
  exit 2
fi

echo "board=$board_name"
echo "long_line_bytes=$LONG_LINE_BYTES"
echo "max_records=$MAX_RECORDS"

printf '%s\n' "$text" | awk -v list="$list" -v longbytes="$LONG_LINE_BYTES" -v maxrec="$MAX_RECORDS" '
function note(kind, msg) {
  count[kind]++
  if (list == "yes") printf "%s line %d: %s\n", kind, NR, msg
}
# A record is judged whole, at its close, because a missing field is only knowable once the next
# header arrives or the file ends.
function close_record(   k, i) {
  if (name == "") return
  records++
  for (i = 1; i <= nreq; i++) {
    k = req[i]
    if (!(k in seen)) note("missing_field", name " carries no " k)
  }
  delete seen
  name = ""
}
BEGIN {
  nreq = split("seat stamp epoch paths what", req, " ")
  for (i = 1; i <= nreq; i++) known[req[i]] = 1
  known["claim"] = 1
  known["format"] = 1
}
{ if (length($0) > longbytes) note("long_line", "a line of " length($0) " bytes") }
/^[ \t]*#/ { next }
/^[ \t]*$/ { next }
# A field key indented is a field key the reader never sees, since its rules anchor on $1 of an
# unindented line. Named rather than passed over in silence.
/^[ \t]+[a-z]/ { note("indented_line", "a field line begins with whitespace"); next }
$1 == "claim" {
  close_record()
  name = $2
  if (name == "") { note("nameless_record", "a claim header carries no name"); name = "<unnamed>" }
  else if (name !~ /^[a-z0-9]+(-[a-z0-9]+)+$/) note("bad_name", name " is not a kebab-case name")
  if (name in taken) note("duplicate_name", name " is declared twice")
  taken[name] = 1
  next
}
$1 == "format" { if (name != "") note("late_format", "a format line stands inside record " name); next }
!($1 in known) { note("unknown_key", "first word " $1 " is no field of this board"); next }
{
  # Every field rule below is the mirror of the content reader s `if (name != "")` guard -- there
  # the orphan is dropped, here it is counted.
  if (name == "") { note("orphan_field", $1 " stands above the first claim header"); next }
  if ($1 in seen) note("repeated_field", name " carries " $1 " twice")
  seen[$1] = 1
  value = $0; sub(/^[^ ]+ +/, "", value)
  if (value == "" || value == $1) { note("empty_field", name " has an empty " $1); next }
  if ($1 == "stamp" && value !~ /^[0-9]{8}\.[0-9]{6}$/) note("bad_stamp", name " stamp " value " is not YYYYMMDD.HHMMSS")
  if ($1 == "epoch" && value !~ /^[0-9]+$/) note("bad_epoch", name " epoch " value " is not UTC seconds")
  # The founding signature: a value ending in a bare record header, which is what a lost newline
  # leaves behind. Narrow on purpose -- a sentence ending in exactly `claim some-kebab-name` is a
  # sentence a writer would reword, and the broad reading would catch every honest use of the word.
  # THE CHARACTER BEFORE `claim` IS ANY NON-LETTER, READ OFF THE DAMAGED BYTES RATHER THAN OFF THE
  # ROW THAT DESCRIBES THEM. This pattern first required a space, because the row says three lines
  # were joined; the actual line in `4bd99090c` reads `...named rather than hidden.claim
  # petrichor-shelf-graded-whole`, the header pressed straight against the sentence s full stop. A
  # lost newline leaves whatever character ended the elder line, which is punctuation as often as
  # a space.
  if (($1 == "what" || $1 == "paths") && value ~ /(^|[^a-z])claim[ ]+[a-z0-9]+(-[a-z0-9]+)+$/)
    note("glued_header", name " " $1 " ends in a bare claim header -- a lost newline")
}
END {
  close_record()
  print "records=" records + 0
  if (records > maxrec) note("over_records", "the board holds " records " records")
  # TWO TOTALS, BECAUSE THE FINDINGS DIFFER IN KIND AND THE KIND DECIDES WHO REFUSES.
  #
  # A CORRUPTING finding puts a field or a record in the WRONG PLACE: an orphan lands nowhere, an
  # eaten header sends five fields into the record before it, a glued line hides a header inside a
  # sentence, an indented key is invisible to a reader anchored on `$1`, and two records wearing
  # one name are indistinguishable to every reader there is. Each makes some OTHER record read
  # false, so `fleet_claim_scan.sh` refuses on these.
  #
  # A CONFINED finding stays inside its own record: a missing field, a stray key, a stamp or an
  # epoch that does not parse. The content reader already models the honest cases -- a record with
  # no `epoch` prints `status=undated` on purpose -- so refusing the whole board over one untidy
  # record would red on work nobody got wrong. Confined findings are reported here and held at zero
  # on the LIVING board by the witness, which is where a standard the fleet holds itself to belongs.
  #
  # Key and printed label stand side by side, because an "s" appended to every key spells one of
  # them wrong and a reader greps the label rather than the key.
  corrupting = 0; confined = 0
  n = split("orphan_field repeated_field glued_header duplicate_name indented_line nameless_record late_format", ckeys, " ")
  split("orphan_fields repeated_fields glued_headers duplicate_names indented_lines nameless_records late_formats", clabels, " ")
  for (i = 1; i <= n; i++) { print clabels[i] "=" count[ckeys[i]] + 0; corrupting += count[ckeys[i]] }
  m = split("missing_field unknown_key bad_name bad_stamp bad_epoch empty_field over_records", fkeys, " ")
  split("missing_fields unknown_keys bad_names bad_stamps bad_epochs empty_fields over_records", flabels, " ")
  for (i = 1; i <= m; i++) { print flabels[i] "=" count[fkeys[i]] + 0; confined += count[fkeys[i]] }
  print "long_lines=" count["long_line"] + 0
  print "corrupting=" corrupting
  print "confined=" confined
  print "malformed=" corrupting + confined
  if (corrupting + confined > 0) { print "verdict=malformed"; exit 1 }
  print "verdict=well_formed"
}
'
