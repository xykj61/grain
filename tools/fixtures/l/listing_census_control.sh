#!/bin/sh
# listing_census_control.sh -- prove tools/fixtures/l/listing_census_scan.sh on planted scans.
#
# Every refusal is shown from BOTH sides: planted, counted, then lifted and counted again. A
# reading proven only in the passing direction cannot be told from a bypass. Four MUTATIONS run the
# scan with one line broken and assert the leg that must bite actually bites -- a control whose legs
# all pass against a broken instrument is a control proving nothing.
#
# The pen is a REAL git repository, because the scan's roster is `git ls-files`.
#
# USAGE
#   sh tools/fixtures/l/listing_census_control.sh
#
# Run from the repository root.

set -u

ROOT=$(pwd)
SCAN=$ROOT/tools/fixtures/l/listing_census_scan.sh
pen=$(mktemp -d 2>/dev/null || mktemp -d -t lisc) || exit 1
trap 'rm -rf "$pen"' EXIT

legs=0
failed=0

# Every leg prints BOTH a human line and a `<name>=yes|no` the witness asserts on, so a leg written
# tomorrow is heard the day it lands rather than hiding under a verdict that only says the control
# reached its last line.
ok() {
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    echo "$1=yes"
    echo "# leg $1 ok ($2)"
  else
    echo "$1=no"
    echo "# leg $1 FAILED want=$2 got=$3"
    failed=$((failed + 1))
  fi
}

mk() { mkdir -p "$pen/$(dirname "$1")"; cat > "$pen/$1"; }

read_key() { LC_ALL=C awk -F= -v k="$2" '$1 == k { print $2 }' "$1"; }

run() {
  ( cd "$pen" && git add -A >/dev/null 2>&1; sh "$SCAN" > "$pen/out.txt" 2>"$pen/err.txt" )
}

mutate() {
  mfile=$pen/mutant.sh
  sed "$1" "$SCAN" > "$mfile"
  ( cd "$pen" && git add -A >/dev/null 2>&1; sh "$mfile" > "$pen/mout.txt" 2>/dev/null )
  read_key "$pen/mout.txt" "$2"
}

cd "$pen" || exit 1
git init -q . >/dev/null 2>&1
git config user.email pen@example.invalid
git config user.name pen
cd "$ROOT" || exit 1

# --- an empty population refuses rather than reading zero -------------------
# REDS %513: a refused read and a clean tree print the same zero, and only one is good news.
run
ok empty_instrument failed "$(read_key "$pen/out.txt" instrument)"
ok empty_verdict misread "$(read_key "$pen/out.txt" verdict)"

# --- the clean floor --------------------------------------------------------
mk tools/fixtures/z/plain_scan.sh <<'EOF'
#!/bin/sh
echo "count=1"
EOF
run
ok clean_caps 0 "$(read_key "$pen/out.txt" caps)"
ok clean_other 0 "$(read_key "$pen/out.txt" other_uncensused)"
ok clean_verdict ok "$(read_key "$pen/out.txt" verdict)"
ok clean_instrument ok "$(read_key "$pen/out.txt" instrument)"
ok clean_scans_read 1 "$(read_key "$pen/out.txt" scans_read)"

# --- the subject: a capped listing that says nothing ------------------------
mk tools/fixtures/z/silent_scan.sh <<'EOF'
#!/bin/sh
printf '%s' "$report" | sort -rn | head -40
EOF
run
ok silent_caps 1 "$(read_key "$pen/out.txt" caps)"
ok silent_uncensused 1 "$(read_key "$pen/out.txt" other_uncensused)"
ok silent_files 1 "$(read_key "$pen/out.txt" files_with_cap)"
rm -f "$pen/tools/fixtures/z/silent_scan.sh"
run
ok silent_lifts 0 "$(read_key "$pen/out.txt" caps)"

# --- the repair: the same cap, naming what it dropped -----------------------
mk tools/fixtures/z/honest_scan.sh <<'EOF'
#!/bin/sh
printf '%s' "$report" | sort -rn | head -n "$list_cap"
echo "list_shown=$a list_hidden=$b list_total=$c"
EOF
run
ok honest_caps 1 "$(read_key "$pen/out.txt" caps)"
ok honest_uncensused 0 "$(read_key "$pen/out.txt" other_uncensused)"
ok honest_verdict ok "$(read_key "$pen/out.txt" verdict)"

# The other honest spelling: a `shown=` key beside a total the file already prints. The narrow
# reading counted only `hidden=` and called `standing_equipment_scan.sh` four short when three of
# its four caps are named.
mk tools/fixtures/z/shown_scan.sh <<'EOF'
#!/bin/sh
echo "runs_slowest_shown=5"
sort -rn "$rows" | head -n "$show" | sed 's/^/named: /'
EOF
run
ok shown_is_a_census 0 "$(read_key "$pen/out.txt" other_uncensused)"
rm -f "$pen/tools/fixtures/z/shown_scan.sh" "$pen/tools/fixtures/z/honest_scan.sh"

# A census is an EMIT, never an assignment. This fired for real while the meter was being written:
# the repaired blocks set `list_shown` twice before echoing it once, so one honest block read as
# three censuses and a file could earn slack from two extra caps by being verbose.
mk tools/fixtures/z/assign_scan.sh <<'EOF'
#!/bin/sh
printf '%s' "$report" | sort -rn | head -40
printf '%s' "$other" | sort -rn | head -40
list_shown=$a
list_hidden=$b
echo "list_shown=$a list_hidden=$b"
EOF
run
ok assignment_is_not_a_census 1 "$(read_key "$pen/out.txt" other_uncensused)"
rm -f "$pen/tools/fixtures/z/assign_scan.sh"

# --- what is NOT a cap, each boundary shown on its own ----------------------
# A scalar read: the single worst row drops nothing a reader expected.
mk tools/fixtures/z/scalar_scan.sh <<'EOF'
#!/bin/sh
worst=$(sort -rn "$rows" | head -1)
least=$(sort -n "$rows" | head -n 1)
EOF
run
ok scalar_not_a_cap 0 "$(read_key "$pen/out.txt" caps)"
rm -f "$pen/tools/fixtures/z/scalar_scan.sh"

# A redirected cap bounds an INPUT set -- TAME asking a collection to name a maximum -- and drops
# rows nobody was reading.
mk tools/fixtures/z/redirect_scan.sh <<'EOF'
#!/bin/sh
sort -u "$in" | head -n "$max_citations" > "$work/cited.txt"
EOF
run
ok redirect_not_a_cap 0 "$(read_key "$pen/out.txt" caps)"
rm -f "$pen/tools/fixtures/z/redirect_scan.sh"

# A comment naming the shape is not the shape -- the reading this meter would otherwise apply to
# its own header.
mk tools/fixtures/z/comment_scan.sh <<'EOF'
#!/bin/sh
# This file explains that `sort -rn | head -40` drops rows in silence.
echo "count=0"
EOF
run
ok comment_not_a_cap 0 "$(read_key "$pen/out.txt" caps)"
rm -f "$pen/tools/fixtures/z/comment_scan.sh"

# --- the wall: a family member is gated where a stranger ratchets ------------
mk tools/fixtures/r/rish_spoken_ascii_scan.sh <<'EOF'
#!/bin/sh
printf '%s' "$report" | sort -rn | head -40
EOF
run
ok family_caps_seen 1 "$(read_key "$pen/out.txt" family_caps)"
ok family_uncensused 1 "$(read_key "$pen/out.txt" family_uncensused)"
ok family_walled no "$(read_key "$pen/out.txt" family_walled)"
ok family_verdict silent_cap "$(read_key "$pen/out.txt" verdict)"
ok family_not_in_other 0 "$(read_key "$pen/out.txt" other_uncensused)"
mk tools/fixtures/r/rish_spoken_ascii_scan.sh <<'EOF'
#!/bin/sh
printf '%s' "$report" | sort -rn | head -n "$list_cap"
echo "list_shown=$a list_hidden=$b list_total=$c"
EOF
run
ok family_repair_lifts 0 "$(read_key "$pen/out.txt" family_uncensused)"
ok family_repair_verdict ok "$(read_key "$pen/out.txt" verdict)"
rm -f "$pen/tools/fixtures/r/rish_spoken_ascii_scan.sh"

# --- the ceiling, from both sides -------------------------------------------
# The ceiling is read from the scan rather than spelled here, so lowering it in one file moves this
# control with no hand -- the fault a sibling booked when a plant stood against a literal.
run
ceiling=$(read_key "$pen/out.txt" ceiling)
i=0
while [ "$i" -le "$ceiling" ]; do
  mk "tools/fixtures/z/fill${i}_scan.sh" <<'EOF'
#!/bin/sh
printf '%s' "$report" | sort -rn | head -40
EOF
  i=$((i + 1))
done
run
ok ceiling_over $((ceiling + 1)) "$(read_key "$pen/out.txt" other_uncensused)"
ok ceiling_refuses no "$(read_key "$pen/out.txt" under_ceiling)"
ok ceiling_verdict silent_cap "$(read_key "$pen/out.txt" verdict)"
rm -f "$pen/tools/fixtures/z/fill0_scan.sh"
run
ok ceiling_at yes "$(read_key "$pen/out.txt" under_ceiling)"
ok ceiling_at_verdict ok "$(read_key "$pen/out.txt" verdict)"
i=1
while [ "$i" -le "$ceiling" ]; do
  rm -f "$pen/tools/fixtures/z/fill${i}_scan.sh"
  i=$((i + 1))
done

# --- mutations: each leg above must bite when its line is broken -------------
mk tools/fixtures/z/silent_scan.sh <<'EOF'
#!/bin/sh
printf '%s' "$report" | sort -rn | head -40
EOF
mk tools/fixtures/z/scalar_scan.sh <<'EOF'
#!/bin/sh
worst=$(sort -rn "$rows" | head -1)
EOF
mk tools/fixtures/z/redirect_scan.sh <<'EOF'
#!/bin/sh
sort -u "$in" | head -n "$max" > "$work/cited.txt"
EOF
mk tools/fixtures/z/comment_scan.sh <<'EOF'
#!/bin/sh
# a comment naming `sort -rn | head -40` in prose
echo "count=0"
EOF
mk tools/fixtures/z/shown2_scan.sh <<'EOF'
#!/bin/sh
echo "runs_slowest_shown=5"
sort -rn "$rows" | head -n "$show" | sed 's/^/named: /'
EOF
mk tools/fixtures/z/assign2_scan.sh <<'EOF'
#!/bin/sh
printf '%s' "$report" | sort -rn | head -40
printf '%s' "$other" | sort -rn | head -40
list_shown=$a
list_hidden=$b
echo "list_shown=$a list_hidden=$b"
EOF
run
# The floor carries TWO caps: the silent one, and `shown2_scan.sh`, whose cap is real and censused.
ok mutation_floor 4 "$(read_key "$pen/out.txt" caps)"
ok mutation_floor_uncensused 2 "$(read_key "$pen/out.txt" other_uncensused)"

# Mutation one: the comment skip. Without it a comment NAMING the shape counts as the shape, and
# this meter refuses its own header first.
ok mutation_comment_bites 5 "$(mutate 's|substr(line, 1, 1) == "#"|0|' caps)"

# Mutation two: the `head -1` exclusion, made unmatchable. Nine scalar reads in the live tree read
# as silent caps. This leg read a FALSE PASS on its first writing -- a sed that matched nothing
# left the count at the floor, and the floor happened to equal the number the leg wanted.
ok mutation_scalar_bites 5 "$(mutate 's|line !~ /head|line !~ /ZZZhead|' caps)"

# Mutation three: the redirect exclusion. An input bound reads as a listing.
ok mutation_redirect_bites 5 "$(mutate 's|(line ~ />|(line ~ /ZZZ>|' caps)"

# Mutation four: the `shown=` half of the census key. The honest other spelling stops counting and
# a file naming three of its four caps reads silent.
ok mutation_shown_bites 3 "$(mutate 's;|shown);|ZZZshown);' other_uncensused)"

# Mutation five: the emit anchor. Every assignment counts as a census, and the verbose file above
# buys itself two caps of slack.
ok mutation_emit_anchor_bites 1 "$(mutate 's|line ~ /\^(echo\|printf)/|1|' other_uncensused)"

echo "control_legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=red"
fi
