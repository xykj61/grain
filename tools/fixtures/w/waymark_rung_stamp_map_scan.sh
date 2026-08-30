#!/bin/sh
# waymark_rung_stamp_map_scan.sh -- prove the CION conversion map against the landed history.
#
# The fixture keeps waymark and rung in separate tab fields. That makes it useful to a converter
# without teaching the living drift meter hundreds of new joined marks. The commit author stamp is
# the one-clock reading seated by stamp-and-name; an explicit ledger row must agree with it. A
# CENSUS stamp means no recoverable landing commit exists, so the numbered citation must stay.
#
# RUNG_MAP_ROOT, RUNG_MAP_PATH, and RUNG_STOA_LEDGER are control knobs for planted copies.

set -eu

root=${RUNG_MAP_ROOT:-.}
map=${RUNG_MAP_PATH:-$root/tools/fixtures/w/waymark_rung_stamp_map.tsv}
stoa_ledger=${RUNG_STOA_LEDGER:-$root/docs/STOA.md}
ales_ledger=$root/lotus/LADDER.md

fail() {
  echo "detail=$2"
  echo "verdict=$1"
  exit 1
}

[ -f "$map" ] || fail map_absent "the tracked rung-to-stamp fixture is absent"
[ -f "$stoa_ledger" ] || fail stoa_ledger_absent "the STOA ledger is absent"
[ -f "$ales_ledger" ] || fail ales_ledger_absent "the ALES ledger is absent"

mkdir -p .mind-state/tmp
tmp_dir=$(mktemp -d .mind-state/tmp/rung-map-scan.XXXXXX)
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM
data=$tmp_dir/data.tsv
expected=$tmp_dir/expected.tsv
actual=$tmp_dir/actual.tsv
history_dates=$tmp_dir/history-dates.tsv
ledger_stamps=$tmp_dir/ledger-stamps.tsv
issue=$tmp_dir/issue.txt

awk 'substr($0, 1, 1) != "#" && NF { print }' "$map" > "$data"

if ! LC_ALL=C grep -q '[^ -~	]' "$map"; then
  :
else
  fail non_ascii "the map carries a non-ASCII byte"
fi

awk -F '\t' '
  NF != 5 { print "field_count line=" NR; exit 1 }
  $1 != "STOA" && $1 != "ALES" { print "waymark line=" NR; exit 1 }
  $2 !~ /^[0-9]+[A-Za-z]?$/ { print "rung line=" NR; exit 1 }
  $3 != "CENSUS" && $3 !~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\.[0-9][0-9][0-9][0-9][0-9][0-9]$/ { print "stamp line=" NR; exit 1 }
  $3 == "CENSUS" && ($4 != "-" || $5 != "underivable") { print "census line=" NR; exit 1 }
  $3 != "CENSUS" && (length($4) != 40 || $4 ~ /[^0-9a-f]/) { print "commit line=" NR; exit 1 }
  $3 != "CENSUS" && $5 != "docs-log" && $5 != "head-log" && $5 != "ledger+head-log" { print "source line=" NR; exit 1 }
  { key=$1 "\t" $2; if (seen[key]++) { print "duplicate " key; exit 1 } }
' "$data" > "$issue" || fail malformed "$(sed -n '1p' "$issue")"

awk 'BEGIN {
  for (i=0; i<=198; i++) print "STOA\t" i
  print "STOA\t199A"
  for (i=200; i<=337; i++) print "STOA\t" i
  print "STOA\t338a"
  print "STOA\t339"
  print "STOA\t339b"
  print "STOA\t338b"
  for (i=340; i<=346; i++) print "STOA\t" i
  for (i=0; i<=238; i++) print "ALES\t" i
}' | LC_ALL=C sort > "$expected"
cut -f1,2 "$data" | LC_ALL=C sort > "$actual"
if ! cmp -s "$expected" "$actual"; then
  diff_line=$(comm -3 "$expected" "$actual" | sed -n '1p')
  fail coverage "the landed rung population differs at: $diff_line"
fi

command -v perl >/dev/null 2>&1 || fail clock_reader_absent "the one-clock epoch reader is absent"
git -C "$root" log HEAD --format='%H%x09%at' \
  | TZ=America/New_York perl -MPOSIX=strftime -F'\t' -lane \
      'print "$F[0]\t", strftime("%Y%m%d.%H%M%S", localtime($F[1]))' \
  > "$history_dates"

awk -F '\t' '
  NR == FNR { author[$1]=$2; next }
  $3 == "CENSUS" { next }
  !($4 in author) { print "commit_absent " $1 " " $2 " " $4; exit 1 }
  author[$4] != $3 {
    print "author_stamp_mismatch " $1 " " $2 " want=" author[$4] " got=" $3; exit 1
  }
' "$history_dates" "$data" > "$issue" || fail history "$(sed -n '1p' "$issue")"

sed -n 's/^| \*\*STOA\([^*]*\)\*\*.*\*\*GREEN\*\* `\([^`]*\)`.*/\1\	\2/p' \
  "$stoa_ledger" | awk -F '\t' '$1 ~ /^[0-9]+[A-Za-z]?$/ { print }' > "$ledger_stamps"
awk -F '\t' '
  NR == FNR { ledger[$1]=$2; next }
  $1 == "STOA" && ($2 in ledger) {
    seen[$2]=1
    if (ledger[$2] == $3) next
    print "ledger_stamp_mismatch " $1 " " $2 " want=" ledger[$2] " got=" $3; exit 1
  }
  END {
    for (rung in ledger) if (!(rung in seen)) {
      print "ledger_row_unmapped STOA " rung; exit 1
    }
  }
' "$ledger_stamps" "$data" > "$issue" || fail ledger "$(sed -n '1p' "$issue")"

spot_checks=0
spot_check() {
  spot_mark=$1
  spot_rung=$2
  spot_commit=$(awk -F '\t' -v mark="$spot_mark" -v rung="$spot_rung" \
    '$1 == mark && $2 == rung { print $4 }' "$data")
  [ -n "$spot_commit" ] || fail spot_absent "the spot row $spot_mark $spot_rung is absent"
  spot_token=$spot_mark$spot_rung
  git -C "$root" show -s --format='%s%n%b' "$spot_commit" | grep -Fq "$spot_token" \
    || fail spot_source "the mapped commit does not name spot row $spot_mark $spot_rung"
  spot_checks=$((spot_checks + 1))
}

# The sample crosses the opening group, elder and late STOA landings, and both ends of ALES.
spot_check STOA 31
spot_check STOA 332
spot_check STOA 333
spot_check STOA 338a
spot_check STOA 338b
spot_check STOA 342
spot_check STOA 346
spot_check ALES 0
spot_check ALES 94
spot_check ALES 238

grep -q '^# STOA ' "$stoa_ledger" \
  || fail stoa_ledger_drift "the STOA derivation source no longer identifies its ladder"
grep -q '^# The ALES ladder ' "$ales_ledger" \
  || fail ales_ledger_drift "the ALES derivation source no longer identifies its ladder"
ales_index_count=$(sed -n 's/^- ALES\([0-9][0-9]*\) .*/\1/p' "$ales_ledger" | wc -l | tr -d ' ')

rows=$(wc -l < "$data" | tr -d ' ')
stoa_rows=$(awk -F '\t' '$1 == "STOA" { n++ } END { print n+0 }' "$data")
ales_rows=$(awk -F '\t' '$1 == "ALES" { n++ } END { print n+0 }' "$data")
census_rows=$(awk -F '\t' '$3 == "CENSUS" { n++ } END { print n+0 }' "$data")
ledger_rows=$(wc -l < "$ledger_stamps" | tr -d ' ')
resolved_rows=$((rows - census_rows))

echo "map_rows=$rows"
echo "stoa_rows=$stoa_rows"
echo "ales_rows=$ales_rows"
echo "ales_ledger_numeric_index_rows=$ales_index_count"
echo "resolved_rows=$resolved_rows"
echo "census_rows=$census_rows"
echo "ledger_rows=$ledger_rows"
echo "spot_checks=$spot_checks"
echo "verdict=ok"
