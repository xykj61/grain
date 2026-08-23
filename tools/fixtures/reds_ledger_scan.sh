#!/bin/sh
# tools/fixtures/reds_ledger_scan.sh -- every red carries its three fields.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
#
# Voice v9 - slot 9 - happy_zone_witnesses_first (second appearance this journey).
#
# A red with fewer than three fields teaches nothing: what went wrong, what
# caught it, what it taught. This guard also refuses "I noticed" in the caught
# column, because the whole value of that column is naming the instrument.
#
# TWO ROW SHAPES, because the ledger grew one (REDS %96's fold surfaced it).
# The elder rows are table lines beginning with a digit cell. The living rows
# are prose: a bold `**REDS %96 ...**` opening followed by the three fields in
# italics. Counting only the elder shape read a 96-row ledger as empty the
# moment its last table row folded to the archive -- a counter that cannot see
# what it measures reports a number that is a guess wearing a measurement's
# clothes, which is REDS %93's own lesson one turn earlier in the process.
set -eu

# prove-red: scan a generated control rather than the real ledger, so the RED
# path is proven on metal without ever mutating the pin the guard protects.
# The control is generated here rather than tracked, so it can never drift from
# the shapes this scan actually enforces.
if [ "${1:-}" = "prove-red" ]; then
  ctl=$(mktemp)
  trap 'rm -f "$ctl"' EXIT
  {
    printf '# a planted control ledger\n\n'
    printf '**REDS %%99 (`20260820.030000`) -- a row that names no instrument.** *What went wrong:* something broke.\n\n'
    printf '**REDS %%98 CLOSED (`20260820.030000`) -- a closure that proves nothing.** It simply says so.\n'
  } >"$ctl"
  out=$(sh "$0" "$ctl" 2>&1) || true
  printf '%s\n' "$out" | sed 's/^/control: /'
  case "$out" in
    *verdict=incomplete_rows*)
      echo "RED_reds_ledger_thin_rows_caught"
      exit 1 ;;
  esac
  echo "verdict=prove_red_failed_to_refuse"
  exit 2
fi
f="${1:-construction/REDS.md}"
[ -f "$f" ] || { echo "verdict=missing_ledger"; exit 2; }

rows=0
thin=0
vague=0
while IFS= read -r line; do
  shape=""
  case "$line" in
    '| '[0-9]*'|'*) shape=table ;;
    '**REDS %'[0-9]*|'**REDS #'[0-9]*) shape=prose ;;
    *) continue ;;
  esac
  rows=$((rows + 1))

  if [ "$shape" = table ]; then
    # Four pipes minimum: | n | what | caught | taught |
    cells=$(printf '%s' "$line" | tr -cd '|' | wc -c | tr -d ' ')
    if [ "$cells" -lt 5 ]; then
      echo "detail: row missing a field -> $(printf '%s' "$line" | cut -c1-58)"
      thin=$((thin + 1))
    fi
  else
    # A prose row comes in two shapes, and each is held to its own promise.
    # A FULL ROW names the three fields, so both italic headings must stand
    # behind the bold opening that says what went wrong. A CLOSURE NOTE speaks
    # about a row already written elsewhere, so rather than restating fields it
    # must name its proof -- a fix closes on a witness on metal, never a claim
    # (`.claude/rules/reds-first.md`). A line that does both gets both checks.
    missing=0
    claims_fields=0
    case "$line" in *'What caught it'*|*'What it taught'*) claims_fields=1 ;; esac
    if [ "$claims_fields" -eq 1 ]; then
      case "$line" in *'What caught it'*) : ;; *) missing=1 ;; esac
      case "$line" in *'What it taught'*) : ;; *) missing=1 ;; esac
    else
      case "$line" in
        *GREEN*|*'on metal'*|*Released*) : ;;
        *) missing=1 ;;
      esac
    fi
    if [ "$missing" -ne 0 ]; then
      echo "detail: row missing a field -> $(printf '%s' "$line" | cut -c1-58)"
      thin=$((thin + 1))
    fi
  fi

  # The caught-column must name an instrument rather than a feeling, so the
  # first-person claim of having simply seen it is refused. The pronoun is the
  # check, never the bare verb: the arc's own measured quantity is the REALIZED
  # FALL of a fold -- a number a meter prints -- and a guard that reds on it
  # teaches the bench to route around the guard (`20260822.054053`).
  case "$line" in
    *'I noticed'*|*'i noticed'*|*'we noticed'*|\
    *'I realized'*|*'i realized'*|*'we realized'*|\
    *'I realised'*|*'we realised'*)
      echo "detail: caught-column names no instrument -> $(printf '%s' "$line" | cut -c1-58)"
      vague=$((vague + 1)) ;;
  esac
done < "$f"

bytes=$(wc -c < "$f" | tr -d ' ')
echo "rows=$rows"
echo "thin_rows=$thin"
echo "vague_rows=$vague"
echo "bytes=$bytes"
echo "living_pin_max_bytes=24576"
if [ "$bytes" -gt 24576 ]; then
  echo "detail: ledger past the living-pin bound; fold closed seasons to archive"
  echo "verdict=past_bound"; exit 1
fi
if [ "$rows" -eq 0 ]; then echo "verdict=no_rows"; exit 1; fi
if [ "$thin" -eq 0 ]; then
  if [ "$vague" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
fi
echo "verdict=incomplete_rows"
exit 1
