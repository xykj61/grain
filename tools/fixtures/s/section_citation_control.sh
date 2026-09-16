#!/bin/sh
# tools/fixtures/s/section_citation_control.sh -- prove the section-citation reading on real repositories.
#
# Every refusal is planted and then lifted, and every welcome is asserted as hard as every refusal,
# because a refusal proven only in the passing direction cannot be told from a bypass. Three
# mutations of the scan itself are asserted to bite, so a leg that would pass with the check removed
# is named here rather than trusted.
#
# USAGE
#   sh tools/fixtures/s/section_citation_control.sh
#
# Driven by tools/s/section_citation_witness.rish. Run from the repository root.

set -eu

root=$(pwd)
scan="$root/tools/fixtures/s/section_citation_scan.sh"
[ -f "$scan" ] || { echo "control_verdict=no_scan"; exit 1; }

pen=$(mktemp -d) || { echo "control_verdict=no_pen"; exit 1; }
cleanup() { rm -rf "$pen"; }
trap cleanup EXIT INT TERM HUP

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
  mkdir -p "$d"
  ( cd "$d" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )
  echo "$d"
}

repo=$(mk_repo one)
cd "$repo"
mkdir -p .claude/rules room room/date/20260101 room/archive tools/fixtures/s

# The page every citation points at: two headings and one bold table-row key.
cat > room/canon.md <<'P'
# Canon

## Quality assurance -- the report card

Body.

## Custody gates -- an autonomous agent STOPS here and surfaces

Body.

| Word | Job |
|---|---|
| **calendar** | the bounded round-runs |
P

# The honest citations -- each names a place that stands.
cat > room/honest.md <<'P'
# Honest

The arrow join: `room/canon.md` -> *Quality assurance -- the report card* says where to look.
The spoken join: `room/canon.md` section **Quality assurance -- the report card** says it again.
The link join: [`room/canon.md`](canon.md) *Quality assurance -- the report card* says it a third way.
A citation naming the head of a longer heading: `room/canon.md` -> *Custody gates* is honest.
A table row is a named place too: `room/canon.md` -> **calendar** opens one.
A parenthetical gloss is no section: [`room/canon.md`](canon.md) *(the page beside this one)*.
P

git add -A >/dev/null 2>&1
out=$(sh "$scan" 2>&1) || true
leg "clean pen passes" "$(printf '%s\n' "$out" | read_key verdict)" "ok"
leg "clean pen reads zero stale" "$(printf '%s\n' "$out" | read_key stale)" "0"
leg "five honest citations counted" "$(printf '%s\n' "$out" | read_key citations)" "5"
leg "a parenthetical gloss is not a citation" "$(printf '%s\n' "$out" | read_key dash_candidates)" "0"

# Plant the arrow join naming a place that does not stand.
cat > room/stale_arrow.md <<'P'
# Stale arrow

`room/canon.md` -> *The Compass Chapter* names nothing.
P
git add -A >/dev/null 2>&1
out=$(sh "$scan" 2>&1) || true
leg "an arrow citation naming no place refuses" "$(printf '%s\n' "$out" | read_key verdict)" "over_ceiling"
leg "and is counted once" "$(printf '%s\n' "$out" | read_key stale)" "1"
leg "and is named by --list" "$(sh "$scan" --list 2>/dev/null | grep -c 'The Compass Chapter' || true)" "1"
rm -f room/stale_arrow.md
git add -A >/dev/null 2>&1
out=$(sh "$scan" 2>&1) || true
leg "lifting the plant returns the pen to green" "$(printf '%s\n' "$out" | read_key verdict)" "ok"

# The spoken join.
cat > room/stale_section.md <<'P'
# Stale section

`room/canon.md` section **Next, the ranked remainder** names nothing.
P
git add -A >/dev/null 2>&1
out=$(sh "$scan" 2>&1) || true
leg "a spoken section citation naming no place refuses" "$(printf '%s\n' "$out" | read_key verdict)" "over_ceiling"
rm -f room/stale_section.md

# The link-close join -- the compass rose's own shape.
cat > room/stale_link.md <<'P'
# Stale link

[`room/canon.md`](canon.md) *Now -- the live front*: what is open.
P
git add -A >/dev/null 2>&1
out=$(sh "$scan" 2>&1) || true
leg "a link-close citation naming no place refuses" "$(printf '%s\n' "$out" | read_key verdict)" "over_ceiling"
leg "the ceiling lifts it from both sides" \
  "$(SECTION_CITATION_CEILING=1 sh "$scan" 2>&1 | read_key verdict)" "ok"
rm -f room/stale_link.md

# The dash join -- counted, printed, never gated.
cat > room/dashed.md <<'P'
# Dashed

`room/canon.md` -- *a word a writer emphasised* is ordinary prose.
P
git add -A >/dev/null 2>&1
out=$(sh "$scan" 2>&1) || true
leg "a dash-joined candidate never gates" "$(printf '%s\n' "$out" | read_key verdict)" "ok"
leg "and is counted apart" "$(printf '%s\n' "$out" | read_key dash_unmatched)" "1"
leg "and is named by --dash" "$(sh "$scan" --dash 2>/dev/null | grep -c 'a word a writer emphasised' || true)" "1"
rm -f room/dashed.md

# Dated testimony keeps every word it wrote.
cat > room/20260101-010101_elder.md <<'P'
# Elder

`room/canon.md` -> *The Compass Chapter* stood true the day this was written.
P
cp room/20260101-010101_elder.md room/date/20260101/20260101-010101_elder.md
cp room/20260101-010101_elder.md room/archive/20260102-010101_shelved.md
git add -A >/dev/null 2>&1
out=$(sh "$scan" 2>&1) || true
leg "dated testimony is read past" "$(printf '%s\n' "$out" | read_key verdict)" "ok"

# A dated page a rule room cites is canon whatever its basename says.
cat > .claude/rules/pointer.md <<'P'
# Pointer

The return habit stands at `room/20260101-010101_elder.md`.
P
git add -A >/dev/null 2>&1
out=$(sh "$scan" 2>&1) || true
leg "a dated page the law cites is read" "$(printf '%s\n' "$out" | read_key verdict)" "over_ceiling"
leg "and joins the derived roster" "$(printf '%s\n' "$out" | read_key pages_derived)" "1"
rm -f .claude/rules/pointer.md

# A fixtures path may plant a citation that must stay false.
cat > tools/fixtures/s/planted.md <<'P'
# Planted

`room/canon.md` -> *The Compass Chapter* must stay false in here.
P
git add -A >/dev/null 2>&1
out=$(sh "$scan" 2>&1) || true
leg "a fixtures page is read past" "$(printf '%s\n' "$out" | read_key verdict)" "ok"

# A citation whose target is absent belongs to the link guards.
cat > room/gone.md <<'P'
# Gone

`room/absent.md` -> *Some Section* opens nowhere.
P
git add -A >/dev/null 2>&1
out=$(sh "$scan" 2>&1) || true
leg "an unresolved target is not called stale" "$(printf '%s\n' "$out" | read_key stale)" "0"
leg "and is counted as unresolved" "$(printf '%s\n' "$out" | read_key unresolved)" "1"
rm -f room/gone.md
git add -A >/dev/null 2>&1

out=$(sh "$scan" --nonsense 2>&1) || true
leg "an unknown flag refuses" "$(printf '%s\n' "$out" | read_key verdict)" "bad_flag"

# MUTATIONS -- each removes one check and is asserted to bite.
mut="$pen/mutant.sh"

# 1. Drop the parenthetical-gloss filter: the gloss in room/honest.md becomes a citation.
sed 's|if (n !~ /\^\\(/ \&\& n != "")|if (n != "")|' "$scan" > "$mut"
out=$(sh "$mut" 2>&1) || true
leg "mutation: dropping the gloss filter bites" \
  "$(printf '%s\n' "$out" | read_key verdict)" "over_ceiling"

# 2. Read headings only: the table-row citation in room/honest.md reads stale.
sed '/^\/\^\\|\[ \]\*\\\*\\\*/d' "$scan" > "$mut"
out=$(sh "$mut" 2>&1) || true
leg "mutation: reading headings alone bites" \
  "$(printf '%s\n' "$out" | read_key verdict)" "over_ceiling"

# 3. Demand an exact heading match: the head-of-heading citation reads stale.
sed 's|if (index(h, want) == 1)|if (0)|' "$scan" > "$mut"
out=$(sh "$mut" 2>&1) || true
leg "mutation: refusing a head-of-heading match bites" \
  "$(printf '%s\n' "$out" | read_key verdict)" "over_ceiling"

cd "$root"
echo "control_legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -gt 0 ]; then
  echo "control_verdict=failed"
  exit 1
fi
echo "control_verdict=ok"
