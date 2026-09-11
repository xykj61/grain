#!/bin/sh
# tools/fixtures/o/one_title_control.sh -- proves tools/fixtures/o/one_title_scan.sh both ways on
# miniature pages in a throwaway pen.
#
# Every refusal is planted and then LIFTED, so a refusal stays tellable from a bypass: a scan that
# always answered `outside=1` would pass the planted leg and fail the lifted one. Every welcome is
# asserted as hard as every refusal, because a meter that counts nothing reads exactly like a
# corpus with nothing to count.
#
#   sh tools/fixtures/o/one_title_control.sh

set -u
LC_ALL=C
export LC_ALL

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_ot_steps=0
while [ ! -d "$ROOT/tools/fixtures" ] || [ ! -d "$ROOT/.git" ]; do
  _ot_steps=$((_ot_steps + 1))
  if [ "$_ot_steps" -gt 8 ] || [ "$ROOT" = "/" ]; then
    echo "$0: no tree root within 8 steps" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
SCAN=${ONE_TITLE_SCAN:-$ROOT/tools/fixtures/o/one_title_scan.sh}

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
  d=$1
  shift
  ONE_TITLE_CORPUS="$d" sh "$SCAN" "$@" 2>&1
}

# ---------------------------------------------------------------- a plain, well-titled page
mkdir -p "$pen/live"
cat > "$pen/live/plain.md" <<'MD'
# A Plain Page

One title, nothing surprising.
MD

out=$(run_scan "$pen" ); rc=$?
leg plain_counts_one_page 1 "$(read_leg pages "$out")"
leg plain_titled 1 "$(read_leg titled "$out")"
leg plain_outside 0 "$(read_leg outside "$out")"
leg plain_verdict ok "$(read_leg verdict "$out")"
leg plain_exit_ok 0 "$rc"

# ---------------------------------------------------------------- the fenced decoy
# The discrimination this tree already proved once in `census_control_h1_fenced.md`: a naive line
# scan reads four titles here and a fence-aware one reads one.
cat > "$pen/live/fenced.md" <<'MD'
# The Only Real Title

```
# fenced decoy one
# fenced decoy two
# fenced decoy three
```

Text after the fence.
MD

out=$(run_scan "$pen")
leg fence_masked_titled 2 "$(read_leg titled "$out")"
leg fence_masked_outside 0 "$(read_leg outside "$out")"

# A tilde fence is a fence too -- the spelling a page reaches for when its body holds backticks.
cat > "$pen/live/tilde.md" <<'MD'
# Tilde Fenced

~~~
# decoy inside tildes
~~~
MD

out=$(run_scan "$pen")
leg tilde_fence_masked_titled 3 "$(read_leg titled "$out")"
leg tilde_fence_masked_outside 0 "$(read_leg outside "$out")"
rm -f "$pen/live/tilde.md" "$pen/live/fenced.md"

# ---------------------------------------------------------------- the HTML title
# `README.md` centers its title as HTML, so a `^# ` reading calls the tree's front door untitled.
cat > "$pen/live/html.md" <<'MD'
<p align="center">
  <img src="logo.svg" alt="a logo">
</p>

<h1 align="center">Grain</h1>

A front door that carries its title in HTML.
MD

out=$(run_scan "$pen")
leg html_title_counts_titled 2 "$(read_leg titled "$out")"
leg html_title_not_outside 0 "$(read_leg outside "$out")"
leg html_title_verdict ok "$(read_leg verdict "$out")"
rm -f "$pen/live/html.md"

# ---------------------------------------------------------------- a page that writes ABOUT titles
# The first live run of this guard called `context/TAME_GUIDANCE.md` and `construction/ITINERARY.md`
# violations, because both name the two title forms in backticks while explaining the rule. Inline
# code is masked before either test, and a page discussing titles stays a page with one title.
cat > "$pen/live/about.md" <<'MD'
# Writing About Titles

The lint row reads `# Title` per markdown, and `README.md` centers its own title as `<h1>`.

`<h1 align="center">` in backticks is a mention, never a heading.
MD

out=$(run_scan "$pen"); rc=$?
leg mention_in_backticks_titled 2 "$(read_leg titled "$out")"
leg mention_in_backticks_outside 0 "$(read_leg outside "$out")"
leg mention_in_backticks_exit_ok 0 "$rc"
rm -f "$pen/live/about.md"

# ---------------------------------------------------------------- plant: two titles
cat > "$pen/live/two.md" <<'MD'
# First Title

Some text.

# Second Title

More text.
MD

out=$(run_scan "$pen"); rc=$?
leg two_titles_multi 1 "$(read_leg many_titles "$out")"
leg two_titles_outside 1 "$(read_leg outside "$out")"
leg two_titles_still_under_ceiling ok "$(read_leg verdict "$out")"
leg two_titles_exit_ok 0 "$rc"

# ---------------------------------------------------------------- plant: none at all
cat > "$pen/live/none.md" <<'MD'
**Language:** EN

A page that never says what it is.
MD

out=$(run_scan "$pen"); rc=$?
leg none_untitled 1 "$(read_leg no_title "$out")"
leg none_outside_two 2 "$(read_leg outside "$out")"
leg none_over_ceiling outside_over_ceiling "$(read_leg verdict "$out")"
leg none_exit_refuses 1 "$rc"

# THE REFUSAL LIFTED. Remove the second offender and the same corpus walks free again, which is
# what tells a working gate from one that always says no.
rm -f "$pen/live/none.md"
out=$(run_scan "$pen"); rc=$?
leg lifted_outside 1 "$(read_leg outside "$out")"
leg lifted_verdict ok "$(read_leg verdict "$out")"
leg lifted_exit_ok 0 "$rc"

# THE CEILING PROVEN FROM BOTH SIDES. One offender stands; at a ceiling of zero it refuses.
out=$(ONE_TITLE_CEILING=0 run_scan "$pen"); rc=$?
leg ceiling_zero_refuses outside_over_ceiling "$(read_leg verdict "$out")"
leg ceiling_zero_exit 1 "$rc"
out=$(ONE_TITLE_CEILING=0 run_scan "$pen" --list)
leg ceiling_zero_names_the_page 1 "$(printf '%s\n' "$out" | grep -c 'titles=2 live/two.md')"
rm -f "$pen/live/two.md"
out=$(ONE_TITLE_CEILING=0 run_scan "$pen"); rc=$?
leg ceiling_zero_lifted_ok ok "$(read_leg verdict "$out")"
leg ceiling_zero_lifted_exit 0 "$rc"

# ---------------------------------------------------------------- the read-past classes
# Each one is planted with a violation a counted page would refuse for, then the whole corpus is
# asserted clean. A filter proven only by its absence proves nothing.
two_titles() {
  mkdir -p "$(dirname "$1")"
  printf '# One\n\ntext\n\n# Two\n' > "$1"
}

two_titles "$pen/live/date/20260101/20260101-010101_shelved.md"
out=$(run_scan "$pen")
leg date_shelf_read_past 1 "$(read_leg pages "$out")"
leg date_shelf_clean ok "$(read_leg verdict "$out")"

two_titles "$pen/live/archive/old.md"
two_titles "$pen/live/yonder/later.md"
out=$(run_scan "$pen")
leg archive_and_yonder_read_past 1 "$(read_leg pages "$out")"

two_titles "$pen/gratitude/teacher.md"
two_titles "$pen/vendor/upstream.md"
two_titles "$pen/seed/projected.md"
two_titles "$pen/research-silo/held.md"
out=$(run_scan "$pen")
leg vendored_rooms_read_past 1 "$(read_leg pages "$out")"

two_titles "$pen/live/fixtures/planted.md"
two_titles "$pen/tools/fixtures/c/decoy.md"
out=$(run_scan "$pen")
leg fixtures_read_past 1 "$(read_leg pages "$out")"

two_titles "$pen/live/20260911-101010_testimony.md"
out=$(run_scan "$pen")
leg dated_basename_read_past 1 "$(read_leg pages "$out")"
leg every_class_lifted_clean ok "$(read_leg verdict "$out")"

# THE ROOM ANCHORS ARE AT THE ROOT, and that is load-bearing: `recursion-prompts/seed/` holds three
# living pages in the field and is not the public seed. A nested room of the same name stays IN the
# population, so the widening that would have dropped them is refused here rather than argued.
two_titles "$pen/recursion-prompts/seed/nested.md"
out=$(run_scan "$pen"); rc=$?
leg nested_seed_stays_counted 2 "$(read_leg pages "$out")"
leg nested_seed_counts_outside 1 "$(read_leg outside "$out")"
leg nested_seed_exit_ok 0 "$rc"
rm -rf "$pen/recursion-prompts"

# ---------------------------------------------------------------- a walk that stops short
# The one failure a ratchet cannot catch: a reader that skipped pages reports a SMALLER `outside`
# and reads as a cleaner tree. An unreadable page makes the walk short without making it noisy.
mkdir -p "$pen/live"
printf '# Unreadable\n' > "$pen/live/locked.md"
chmod 000 "$pen/live/locked.md"
out=$(run_scan "$pen" 2>/dev/null); rc=$?
if [ "$(read_leg read_pages "$out")" = "$(read_leg pages "$out")" ]; then
  # A pen where everything is readable anyway (a root-owned runner) cannot plant this one.
  leg walk_short_unplantable 1 1
  leg walk_short_unplantable_exit 0 "$rc"
else
  leg walk_short_refuses walk_short "$(read_leg verdict "$out")"
  leg walk_short_exit 1 "$rc"
fi
chmod 644 "$pen/live/locked.md"
out=$(run_scan "$pen"); rc=$?
leg walk_short_lifted ok "$(read_leg verdict "$out")"
leg walk_short_lifted_exit 0 "$rc"
rm -f "$pen/live/locked.md"

# ---------------------------------------------------------------- an empty corpus refuses
mkdir -p "$pen/empty"
out=$(run_scan "$pen/empty"); rc=$?
leg empty_corpus_refuses no_corpus "$(read_leg verdict "$out")"
leg empty_corpus_exit 1 "$rc"
leg empty_corpus_says_why 1 "$(printf '%s\n' "$out" | grep -c 'lost its subject')"

echo "control_legs=$legs"
echo "control_fail=$fail"
[ "$fail" -eq 0 ] || exit 1
exit 0
