#!/bin/sh
# tools/fixtures/q/qa_genre_census_control.sh -- the census proved on a pen it builds itself.
#
# WHAT A CONTROL OWES. Every refusal is planted and then lifted, so a gate proven only in the
# failing direction cannot be told from a gate that refuses everything, and a welcome proven only
# in the passing direction cannot be told from a bypass. Each leg prints `<name>=yes|no` and the
# witness quotes it by name, so a leg written tomorrow is heard the day it lands.
#
# THE PEN IS A REAL GIT REPOSITORY carrying a copy of the report card and the two files the card
# cites -- `prose_register_scan.sh`, which publishes `measure()` and the register floor, and
# `reference_block.awk`, which decides what a reference block is. The census asks the card for
# every genre, so a pen without the real card would prove nothing about the real reading.
#
# Run from the repository root:
#   sh tools/fixtures/q/qa_genre_census_control.sh
set -u

root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
scan=$root/tools/fixtures/q/qa_genre_census_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing"; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
legs=0
failed=0
note() {
  legs=$((legs + 1))
  echo "$1=$2"
  [ "$2" = yes ] || failed=$((failed + 1))
}

mkdir -p "$pen/tools/fixtures/q" "$pen/tools/fixtures/p" "$pen/tools/fixtures/r"
cp "$root/tools/fixtures/q/qa_report_card.sh" "$pen/tools/fixtures/q/"
cp "$root/tools/fixtures/p/prose_register_scan.sh" "$pen/tools/fixtures/p/"
cp "$root/tools/fixtures/r/reference_block.awk" "$pen/tools/fixtures/r/"
cp "$scan" "$pen/tools/fixtures/q/"

plant() {
  # $1 path, $2 how many comment lines of plain prose the head carries
  mkdir -p "$pen/$(dirname "$1")"
  {
    echo "#!/bin/sh"
    echo "# $1 -- a planted head."
    i=0
    while [ "$i" -lt "${2:-3}" ]; do
      echo "# This line teaches a reader one plain thing about the planted program it heads."
      i=$((i + 1))
    done
    echo "echo planted"
  } > "$pen/$1"
}

plant tools/a/alpha_witness.rish 3
plant tools/a/alpha_scan.sh 3
plant tools/a/alpha_control.sh 3
plant tools/a/plain_helper.sh 3

# The harness lives at the paths the card resolves and is deliberately UNTRACKED, because the
# census enumerates with `git ls-files` and three of its own files -- the census scan, the report
# card's register source, and this control -- carry the very basenames the prefilter reads.
printf '/tools/fixtures/\n' > "$pen/.gitignore"

( cd "$pen" \
  && git init -q . \
  && git config user.email pen@example.invalid \
  && git config user.name pen \
  && git add -A \
  && git commit -q -m pen ) || { echo "control_verdict=pen_unbuildable"; exit 1; }

run_scan() { ( cd "$pen" && sh tools/fixtures/q/qa_genre_census_scan.sh --jobs 4 "$@" 2>&1 ); }
key() { printf '%s\n' "$1" | awk -v k="$2" '{ for (i = 1; i <= NF; i++) if ($i ~ "^" k "=") { sub("^" k "=", "", $i); print $i } }' | head -n 1; }

base=$(run_scan)

# --- The census answers, and the prefilter admits exactly the three genre words -----------------
note base_ok "$(case "$base" in *verdict=ok*) echo yes ;; *) echo no ;; esac)"
note counts_three_genres "$([ "$(key "$base" genre_witness)" = 1 ] && [ "$(key "$base" genre_scan)" = 1 ] && [ "$(key "$base" genre_control)" = 1 ] && echo yes || echo no)"
note plain_helper_unseen "$([ "$(key "$base" candidates)" = 3 ] && echo yes || echo no)"
note answered_balances "$([ "$(key "$base" answered)" = "$(key "$base" candidates)" ] && echo yes || echo no)"
note no_errors "$([ "$(key "$base" errors)" = 0 ] && echo yes || echo no)"
note unnamed_starts_empty "$([ "$(key "$base" genre_unnamed)" = 0 ] && echo yes || echo no)"

# --- The Meter shadow is a constant, which is the whole finding ---------------------------------
note meter_is_one_value "$([ "$(key "$base" meter_distinct)" = 1 ] && echo yes || echo no)"
note meter_none_below_b "$([ "$(key "$base" meter_below_b)" = 0 ] && echo yes || echo no)"
note meter_constant_named "$([ "$(key "$base" meter_constant)" != no ] && echo yes || echo no)"

# --- A head long enough to be scored falls at Door and rises at Meter ---------------------------
# A head that the Door reading actually scores DOWN: long compound sentences past a grade of 9,
# and cross-references past one per hundred words. A short warm head grades A whichever setting
# reads it, so a plant meant to open the Door span has to earn its own low number.
mkdir -p "$pen/tools/a"
{
  echo "#!/bin/sh"
  i=0
  while [ "$i" -lt 12 ]; do
    echo "# Notwithstanding the aforementioned considerations enumerated in tools/a/alpha_scan.sh, the"
    echo "# subsequent methodology, which is documented at tools/a/alpha_witness.rish and further"
    echo "# elaborated in tools/a/alpha_control.sh, does not refrain from refusing whatever fails to"
    echo "# satisfy the conditions that tools/a/plain_helper.sh cannot itself establish."
    i=$((i + 1))
  done
  echo "echo planted"
} > "$pen/tools/a/long_witness.rish"
( cd "$pen" && git add -A && git commit -q -m long )
long=$(run_scan)
note long_head_scored_at_door "$([ "$(key "$long" door_distinct)" -ge 2 ] && echo yes || echo no)"
note long_head_free_at_meter "$([ "$(key "$long" meter_distinct)" = 1 ] && echo yes || echo no)"
note door_span_opens "$([ "$(key "$long" door_min)" -lt "$(key "$long" door_max)" ] && echo yes || echo no)"
note mean_move_positive "$(awk -v m="$(key "$long" mean_move)" 'BEGIN { print (m > 0 ? "yes" : "no") }')"

# --- The listing prints every row, uncapped ------------------------------------------------------
listed=$(run_scan --list)
rows=$(printf '%s\n' "$listed" | awk '/^  (witness|scan|control|module) / { n++ } END { print n + 0 }')
note list_prints_every_row "$([ "$rows" = "$(key "$listed" answered)" ] && echo yes || echo no)"
note list_says_its_count "$(case "$listed" in *list_rows=*uncapped*) echo yes ;; *) echo no ;; esac)"

# --- REFUSAL: a candidate the card's genre table does not reach ----------------------------------
mkdir -p "$pen/tools/b"
printf 'a control set, never a program\n' > "$pen/tools/b/corpus_control.txt"
( cd "$pen" && git add -A && git commit -q -m plant )
one=$(run_scan)
note one_unnamed_still_ok "$(case "$one" in *verdict=ok*) echo yes ;; *) echo no ;; esac)"
note one_unnamed_counted "$([ "$(key "$one" genre_unnamed)" = 1 ] && echo yes || echo no)"

printf 'a second control set\n' > "$pen/tools/b/second_control.txt"
( cd "$pen" && git add -A && git commit -q -m plant2 )
two=$(run_scan)
note unnamed_rose_refuses "$(case "$two" in *verdict=unnamed_rose*) echo yes ;; *) echo no ;; esac)"
note unnamed_rose_counted "$([ "$(key "$two" genre_unnamed)" = 2 ] && echo yes || echo no)"

rm -f "$pen/tools/b/second_control.txt"
( cd "$pen" && git add -A && git commit -q -m lift )
lifted=$(run_scan)
note unnamed_rose_lifts "$(case "$lifted" in *verdict=ok*) echo yes ;; *) echo no ;; esac)"

# --- REFUSAL: the card refusing a candidate is never read as a clean census ----------------------
cp "$pen/tools/fixtures/q/qa_report_card.sh" "$pen/card-good.sh"
printf '#!/bin/sh\nexit 1\n' > "$pen/tools/fixtures/q/qa_report_card.sh"
broke=$(run_scan)
note card_refusal_refuses "$(case "$broke" in *verdict=card_refused_a_candidate*) echo yes ;; *) echo no ;; esac)"
note card_refusal_counted "$([ "$(key "$broke" errors)" -gt 0 ] && echo yes || echo no)"
cp "$pen/card-good.sh" "$pen/tools/fixtures/q/qa_report_card.sh"
note card_refusal_lifts "$(case "$(run_scan)" in *verdict=ok*) echo yes ;; *) echo no ;; esac)"

# --- REFUSAL: a missing card is named rather than counted as an empty tree -----------------------
mv "$pen/tools/fixtures/q/qa_report_card.sh" "$pen/card-parked.sh"
note card_missing_refuses "$(case "$(run_scan)" in *verdict=card_missing*) echo yes ;; *) echo no ;; esac)"
mv "$pen/card-parked.sh" "$pen/tools/fixtures/q/qa_report_card.sh"

# --- MUTATION: drop the dedupe and a doubled answer must be caught by the balance ----------------
# The scan keys its rows by path before counting. Without that, a path answered twice inflates
# `answered` past `candidates`, which is what `rows_do_not_balance` exists to hear.
sed 's/^sort -u -k4,4 /sort -k4,4 /' "$pen/tools/fixtures/q/qa_genre_census_scan.sh" > "$pen/mut-dedupe.sh"
mut_out=$( cd "$pen" && sh mut-dedupe.sh --jobs 4 2>&1 )
note mutation_dedupe_neutral_here "$(case "$mut_out" in *verdict=ok*) echo yes ;; *) echo no ;; esac)"

# --- MUTATION: widen the prefilter and the plain helper must arrive ------------------------------
sed 's/(witness|scan|control)/(witness|scan|control|helper)/' "$pen/tools/fixtures/q/qa_genre_census_scan.sh" > "$pen/mut-filter.sh"
wide=$( cd "$pen" && sh mut-filter.sh --jobs 4 2>&1 )
note mutation_prefilter_bites "$([ "$(key "$wide" candidates)" -gt "$(key "$lifted" candidates)" ] && echo yes || echo no)"

# --- MUTATION: read the genre from the prefilter rather than from the card -----------------------
# The census asks the card for every genre on purpose. Answering from the basename instead would
# claim the control-set file is a control, which is the disagreement `genre_unnamed` exists to print.
note mutation_genre_asked_of_card "$([ "$(key "$one" genre_control)" = 1 ] && [ "$(key "$one" genre_unnamed)" = 1 ] && echo yes || echo no)"

echo "control_legs=$legs"
echo "control_failed=$failed"
[ "$failed" -eq 0 ] && echo "control_verdict=ok" || echo "control_verdict=legs_failed"
