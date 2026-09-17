#!/bin/sh
# tools/fixtures/l/living_pin_fence_control.sh -- prove the fence reading on real repositories.
#
# Every refusal is planted and then lifted, and every welcome is asserted as hard as every refusal,
# because a refusal proven only in the passing direction cannot be told from a bypass. Three
# mutations of the scan itself are asserted to bite, so a leg that would pass with the check removed
# is named here rather than trusted. And the firing that earned the guard is REPLAYED FROM THIS
# TREE'S OWN HISTORY rather than imitated in a pen, because a plant proves the reader and only the
# real commit proves the reader would have caught the thing it was built for.
#
# USAGE
#   sh tools/fixtures/l/living_pin_fence_control.sh
#
# Driven by tools/l/living_pin_fence_witness.rish. Run from the repository root.

set -eu

root=$(pwd)
scan="$root/tools/fixtures/l/living_pin_fence_scan.sh"
[ -f "$scan" ] || { echo "control_verdict=no_scan"; exit 1; }

pen=$(mktemp -d) || { echo "control_verdict=no_pen"; exit 1; }
trap 'rm -rf "$pen"' EXIT INT TERM

legs=0
failed=0

leg() {
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    echo "leg_ok: $1"
  else
    failed=$((failed + 1))
    echo "leg_no: $1 -- wanted $3, read $2"
  fi
}

read_key() { awk -F= -v k="$1" '$1 == k { print $2 }'; }

mk_repo() {
  d="$pen/$1"
  mkdir -p "$d/tools/fixtures/l"
  cp "$scan" "$d/tools/fixtures/l/living_pin_fence_scan.sh"
  ( cd "$d" && git init -q . \
      && git config user.email pen@example.invalid \
      && git config user.name pen )
  echo "$d"
}

# Runs the copied scan from inside the pen, so the reading is the pen's tracked tree and never this
# one. Stderr is kept, since a refusal says which pages and that sentence is part of the behavior.
run_in() {
  ( cd "$1" && sh tools/fixtures/l/living_pin_fence_scan.sh ${2:-} 2>&1 ) || true
}

commit_all() { ( cd "$1" && git add -A && git commit -qm pen ) ; }

# ---------------------------------------------------------------- the ordinary tree welcomes
d=$(mk_repo clean)
printf '# page\n\nprose\n\n```sh\necho hi\n```\n\nmore prose\n' > "$d/CARD.md"
commit_all "$d"
out=$(run_in "$d")
leg clean_verdict "$(printf '%s\n' "$out" | read_key verdict)" ok
leg clean_unbalanced "$(printf '%s\n' "$out" | read_key unbalanced_living)" 0
leg clean_counts_the_page "$(printf '%s\n' "$out" | read_key living_pages)" 1

# ---------------------------------------------------------------- a backtick fence left open
printf '# page\n\nprose\n\n```sh\necho hi\n' > "$d/CARD.md"
commit_all "$d"
out=$(run_in "$d")
leg open_backtick_bites "$(printf '%s\n' "$out" | read_key verdict)" over_ceiling
leg open_backtick_counts "$(printf '%s\n' "$out" | read_key unbalanced_living)" 1
leg open_backtick_names_line "$(run_in "$d" --list | grep -c 'CARD.md open_line=5')" 1
leg open_backtick_says_living "$(run_in "$d" --list | grep -c '^living ')" 1

# the same plant lifted -- the welcome is asserted as hard as the refusal
printf '# page\n\nprose\n\n```sh\necho hi\n```\n' > "$d/CARD.md"
commit_all "$d"
leg open_backtick_lifted "$(run_in "$d" | read_key verdict)" ok

# ---------------------------------------------------------------- a tilde fence left open
printf '# page\n\n~~~\nliteral\n' > "$d/CARD.md"
commit_all "$d"
leg open_tilde_bites "$(run_in "$d" | read_key verdict)" over_ceiling
printf '# page\n\n~~~\nliteral\n~~~\n' > "$d/CARD.md"
commit_all "$d"
leg open_tilde_lifted "$(run_in "$d" | read_key verdict)" ok

# ---------------------------------------------------------------- the character must match
# A tilde line inside a backtick block is CONTENT by CommonMark's own rule, so it closes nothing.
printf '# page\n\n```\nliteral\n~~~\n' > "$d/CARD.md"
commit_all "$d"
leg tilde_never_closes_backtick "$(run_in "$d" | read_key verdict)" over_ceiling

# ---------------------------------------------------------------- length, both directions
# A closer may be LONGER than its opener, and may not be shorter.
printf '# page\n\n```\nliteral\n`````\n' > "$d/CARD.md"
commit_all "$d"
leg longer_closer_welcomed "$(run_in "$d" | read_key verdict)" ok
printf '# page\n\n`````\nliteral\n```\n' > "$d/CARD.md"
commit_all "$d"
leg shorter_closer_refused "$(run_in "$d" | read_key verdict)" over_ceiling

# ---------------------------------------------------------------- a closer carries nothing after it
printf '# page\n\n```\nliteral\n``` trailing words\n' > "$d/CARD.md"
commit_all "$d"
leg closer_with_words_is_content "$(run_in "$d" | read_key verdict)" over_ceiling

# ---------------------------------------------------------------- the info-string rule
# A backtick opener's info string may hold no backtick. Without that rule a line of ordinary prose
# quoting two code spans would read as an opening fence and the page would red for nothing.
printf '# page\n\n```see `this` and `that`\n\nplain prose\n' > "$d/CARD.md"
commit_all "$d"
leg info_string_backtick_not_a_fence "$(run_in "$d" | read_key verdict)" ok

# ---------------------------------------------------------------- indentation, both sides of three
printf '# page\n\n   ```\nliteral\n' > "$d/CARD.md"
commit_all "$d"
leg three_space_fence_read "$(run_in "$d" | read_key verdict)" over_ceiling
# Four spaces is an indented code block rather than a fence, and the header names this as the
# reading's own bound: a pair indented that far reads balanced and this scan stays silent.
printf '# page\n\n    ```\n    literal\n' > "$d/CARD.md"
commit_all "$d"
leg four_space_fence_unread "$(run_in "$d" | read_key verdict)" ok

# ---------------------------------------------------------------- testimony reports, never gates
d2=$(mk_repo testimony)
mkdir -p "$d2/room/date/20260916"
printf '# ok\n' > "$d2/CARD.md"
printf '# log\n\n```sh\nopen forever\n' > "$d2/room/date/20260916/20260916-010203_sprig.md"
commit_all "$d2"
out=$(run_in "$d2")
leg dated_not_gated "$(printf '%s\n' "$out" | read_key verdict)" ok
leg dated_reported "$(printf '%s\n' "$out" | read_key unbalanced_dated)" 1
leg dated_out_of_living "$(printf '%s\n' "$out" | read_key unbalanced_living)" 0
leg dated_listed_as_testimony "$(run_in "$d2" --list | grep -c '^testimony ')" 1

# a stamped basename standing OUTSIDE a shelf is testimony by its name alone
d3=$(mk_repo stamped)
printf '# ok\n' > "$d3/CARD.md"
printf '# essay\n\n```\nopen forever\n' > "$d3/20260916-010203_essay.md"
commit_all "$d3"
out=$(run_in "$d3")
leg stamped_basename_is_testimony "$(printf '%s\n' "$out" | read_key unbalanced_dated)" 1
leg stamped_basename_not_living "$(printf '%s\n' "$out" | read_key verdict)" ok

# ---------------------------------------------------------------- planted input is read past
# A fixtures/ path must be free to carry a broken fence, or a control proving this very reading
# could not plant one. This leg is why that clause exists.
d4=$(mk_repo planted)
mkdir -p "$d4/tools/fixtures/x"
printf '# ok\n' > "$d4/CARD.md"
printf '# plant\n\n```\nopen forever\n' > "$d4/tools/fixtures/x/plant.md"
commit_all "$d4"
out=$(run_in "$d4")
leg fixtures_read_past "$(printf '%s\n' "$out" | read_key verdict)" ok
leg fixtures_out_of_both "$(printf '%s\n' "$out" | read_key unbalanced_dated)" 0

# ---------------------------------------------------------------- a page name holding a space
# This tree carries one such page. A word-split file list drops it from the reading in silence,
# which is the one failure a gate can least afford, so the plant is kept.
d5=$(mk_repo spaced)
printf '# ok\n' > "$d5/CARD.md"
printf '# spaced\n\n```\nopen forever\n' > "$d5/a page (1).md"
commit_all "$d5"
out=$(run_in "$d5")
leg spaced_name_read "$(printf '%s\n' "$out" | read_key verdict)" over_ceiling
leg spaced_name_counted "$(printf '%s\n' "$out" | read_key unbalanced_living)" 1

# ---------------------------------------------------------------- untracked bytes are not read
d6=$(mk_repo untracked)
printf '# ok\n' > "$d6/CARD.md"
commit_all "$d6"
printf '# stray\n\n```\nopen forever\n' > "$d6/STRAY.md"
leg untracked_unread "$(run_in "$d6" | read_key verdict)" ok

# ------------------------------------------------- a path the index holds and the tree lacks
# A staged deletion mid-lap. Handed to awk it exits 2 and takes the whole reading with it, which
# is how this leg was found: the scan died on its own lap's staged delete.
d10=$(mk_repo staged_delete)
printf '# ok\n' > "$d10/CARD.md"
printf '# going\n' > "$d10/GONE.md"
commit_all "$d10"
rm -f "$d10/GONE.md"
out=$(run_in "$d10")
leg staged_delete_survives "$(printf '%s\n' "$out" | read_key verdict)" ok
leg staged_delete_counted "$(printf '%s\n' "$out" | read_key unread_paths)" 1
leg staged_delete_not_a_fence "$(printf '%s\n' "$out" | read_key unbalanced_living)" 0

# ---------------------------------------------------------------- the flags
leg bad_flag_refused "$(run_in "$d6" --nonsense | read_key verdict)" bad_flag
leg empty_flag_welcomed "$(run_in "$d6" "" | read_key verdict)" ok

# ---------------------------------------------------------------- THE FIRING, replayed from history
# construction/ITINERARY.md at commit 99d4948e6 is the real fault: a wrapped sentence put a bare
# triple-backtick opener at column 0 in prose. A plant proves the reader; only this proves the
# reader would have caught the thing it was built for.
d7=$(mk_repo firing)
printf '# ok\n' > "$d7/OTHER.md"
if ( cd "$root" && git cat-file -e 99d4948e6:construction/ITINERARY.md 2>/dev/null ); then
  ( cd "$root" && git show 99d4948e6:construction/ITINERARY.md ) > "$d7/ITINERARY.md"
  commit_all "$d7"
  out=$(run_in "$d7")
  leg real_firing_bites "$(printf '%s\n' "$out" | read_key verdict)" over_ceiling
  leg real_firing_names_the_line "$(run_in "$d7" --list | grep -c 'ITINERARY.md open_line=103')" 1
  # and the card as this tree carries it TODAY, which is the same page repaired
  rm -f "$d7/ITINERARY.md"
  cp "$root/construction/ITINERARY.md" "$d7/ITINERARY.md"
  commit_all "$d7"
  leg repaired_card_welcomed "$(run_in "$d7" | read_key verdict)" ok
else
  echo "leg_skip: real_firing -- commit 99d4948e6 absent from this checkout"
fi

# ---------------------------------------------------------------- mutations, asserted to bite
mutate() {
  m="$pen/mutant_$1"
  rm -rf "$m"; mkdir -p "$m"
  # The planted repository is copied FIRST and the mutant scan written OVER it. Written the other
  # way round the copy restores the pristine scan and every mutation reads as not biting, which is
  # the shape a mutation leg can least afford: it passes by measuring the wrong program.
  cp -r "$3/." "$m/" 2>/dev/null || true
  rm -rf "$m/.git"
  mkdir -p "$m/tools/fixtures/l"
  sed "$2" "$scan" > "$m/tools/fixtures/l/living_pin_fence_scan.sh"
  ( cd "$m" && git init -q . && git config user.email pen@example.invalid \
      && git config user.name pen && git add -A && git commit -qm mutant )
  ( cd "$m" && sh tools/fixtures/l/living_pin_fence_scan.sh 2>&1 ) || true
}

# Drop the info-string rule: a prose line quoting two code spans becomes an opening fence.
d8=$(mk_repo infoprose)
printf '# page\n\n```see `this` and `that`\n\nplain prose\n' > "$d8/CARD.md"
commit_all "$d8"
leg infoprose_welcomed_whole "$(run_in "$d8" | read_key verdict)" ok
leg mutation_info_string_bites \
  "$(mutate info '/index(rest, "`") > 0/d' "$d8" | read_key verdict)" over_ceiling

# Drop the same-character rule: a tilde line closes a backtick block and the page reads balanced.
d9=$(mk_repo charmix)
printf '# page\n\n```\nliteral\n~~~\n' > "$d9/CARD.md"
commit_all "$d9"
leg charmix_bites_whole "$(run_in "$d9" | read_key verdict)" over_ceiling
leg mutation_same_char_bites \
  "$(mutate char 's/ch == ochar \&\& len >= olen \&\&/len >= olen \&\&/' "$d9" | read_key verdict)" ok

# Drop the newline IFS: the walk splits a page name on its space, awk is handed half a path, the
# absent-path step swallows it, and the spaced page falls out of the reading in SILENCE -- the
# mutant answers ok over a tree holding an unclosed fence. That silence is the point: before the
# absent-path step existed this mutation crashed instead, which is a louder and less dangerous
# failure, so the leg asserts the quiet one.
leg mutation_newline_ifs_bites \
  "$(mutate ifs 's/^IFS=\$NL$/IFS=" "/' "$d5" | read_key unbalanced_living)" 0

echo "behaviors=$legs"
echo "failed=$failed"
if [ "$failed" -gt 0 ]; then echo "control_verdict=failed"; exit 1; fi
echo "control_verdict=ok"
