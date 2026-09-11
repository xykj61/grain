#!/bin/sh
# tools/fixtures/f/front_door_claim_scan.sh -- a page that says a front door names it is checked
# against that front door.
#
# WHY. A foundation often tells its reader where it is reached from: "the root README leans on this
# foundation in its opening; this foundation links back." That sentence is a claim about ANOTHER
# page's contents, and it is the one kind of claim a page cannot keep by itself. The link out is
# the author's to write; the link back belongs to a page somebody else edits next week.
#
# It went quiet exactly that way. `foundations/20260811-211431_the-lindy-effect-and-the-long-return.md`
# carried that sentence from the AHOY front-door weave of `20260811`. On `20260823` commit
# `7191a938b` rewrote the root `README.md` for the two-repository projection, and the word Lindy
# left the page. The claim stood unchanged for eighteen days, and `foundations/20260826-024943_follow-our-compass.md`
# carried the same broken promise in its Kin block -- two of the room's three oldest orientation
# pages, both saying the front door points at them, and it pointed at neither.
#
# WHAT NOTHING ELSE READ. `tools/fixtures/f/foundations_link_scan.sh` proves the links a page writes
# land. `tools/fixtures/f/foundations_reach_scan.sh` asks whether the ROOM's index names a page.
# Neither reads the ROOT front door, and neither reads a sentence as a promise. This does.
#
# WHAT MAKES IT CHECKABLE: the claim is DECLARED rather than inferred. A page opts in by carrying a
# `**Front door:**` key naming one or more pages as Markdown links, the way a page declares its
# `**Style:**` and its `**Room:**`. Opting in is the whole population filter, so no reading here
# guesses which prose sentence meant to be a promise.
#
# WHAT IS GATED, hard, at zero. `claims_unkept` -- a declared front door that does not name the
# claiming page. Three causes are told apart in the printout and counted once each: `no_target`
# (the key carries no Markdown link at all), `absent` (the named page is not in the tracked tree),
# and `no_backlink` (the page is there and never names the claimant).
#
# WHAT IS READ PAST. The `date/`, `archive/` and `yonder/` shelves, which are closed stacks holding
# testimony; a page there keeps every word it wrote.
#
# HOW THE BACK LINK IS READ. By the claimant's BASENAME, which is globally unique in this tree --
# the one-clock naming law makes it so, and `foundations_reach_scan.sh` reads reach the same way.
# So a front door naming the page by any relative path, from any depth, keeps the claim.
#
# WHAT IT DOES NOT REACH. Whether the front door's sentence about the page says anything true, and
# whether a page that SHOULD declare a front door has declined to. This proves the declared promise
# is kept, no more.
#
# USAGE
#   sh tools/fixtures/f/front_door_claim_scan.sh [room ...]
#
# Driven by tools/f/front_door_claim_witness.rish. Run from the repository root.

set -eu

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads the tracked tree, so it wants git" >&2; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=no_repo"; echo "refused: not inside a git repository" >&2; exit 1; }

if [ "$#" -gt 0 ]; then rooms="$*"; else rooms="foundations context docs"; fi

# Bound named at the door: ten times the living population these rooms hold today. Past it the scan
# refuses rather than reading on.
max_pages=4096

pen=${TMPDIR:-/tmp}/fdc-pen-$$
mkdir -p "$pen" || exit 2
trap 'rm -rf "$pen"' EXIT INT TERM
: > "$pen/unkept"
: > "$pen/pages"

git ls-files > "$pen/tracked.txt"

for room in $rooms; do
  grep -E "^$room/" "$pen/tracked.txt" | grep -E '\.md$' | grep -vE '/(date|archive|yonder)/' >> "$pen/pages" || :
done
sort -u "$pen/pages" -o "$pen/pages"

pages_read=$(wc -l < "$pen/pages" | tr -d ' ')
if [ "$pages_read" -eq 0 ]; then
  echo "rooms=$rooms"
  echo "pages_read=0"
  echo "verdict=no_pages"
  exit 1
fi
if [ "$pages_read" -gt "$max_pages" ]; then
  echo "rooms=$rooms"
  echo "pages_read=$pages_read"
  echo "verdict=too_many_pages"
  exit 1
fi

# A path with an interior `..` is resolved textually rather than by touching the filesystem, so the
# reading is the same on a checkout where the target is missing as on one where it stands.
normalize() {
  p=$1
  while :; do
    q=$(printf '%s\n' "$p" | sed 's|[^/][^/]*/\.\./||')
    [ "$q" = "$p" ] && break
    p=$q
  done
  printf '%s\n' "$p" | sed 's|^\./||'
}

claims=0
unkept=0
claiming_pages=0

while IFS= read -r page; do
  line=$(grep -m1 '^\*\*Front door:\*\*' "$page" 2>/dev/null || :)
  [ -n "$line" ] || continue
  claiming_pages=$((claiming_pages + 1))
  base=$(basename "$page")
  dir=$(dirname "$page")
  targets=$(printf '%s\n' "$line" | grep -oE '\]\([^)]+\)' | sed 's/^](//; s/)$//' | sort -u || :)
  if [ -z "$targets" ]; then
    claims=$((claims + 1))
    unkept=$((unkept + 1))
    echo "$page -> (none) no_target" >> "$pen/unkept"
    continue
  fi
  for t in $targets; do
    claims=$((claims + 1))
    target=$(normalize "$dir/$t")
    if ! grep -qxF "$target" "$pen/tracked.txt"; then
      unkept=$((unkept + 1))
      echo "$page -> $target absent" >> "$pen/unkept"
      continue
    fi
    if ! grep -qF "$base" "$target"; then
      unkept=$((unkept + 1))
      echo "$page -> $target no_backlink" >> "$pen/unkept"
    fi
  done
done < "$pen/pages"

echo "rooms=$rooms"
echo "pages_read=$pages_read"
echo "claiming_pages=$claiming_pages"
echo "claims=$claims"
echo "claims_unkept=$unkept"
[ "$unkept" -eq 0 ] || sed 's/^/unkept: /' "$pen/unkept"

# A population that came back empty would print a green zero and read exactly like a tree whose
# every declared front door is kept. The key is opt-in, so zero of them means the key has died and
# this guard is measuring nothing (REDS %240's confident wrong zero).
if [ "$claims" -eq 0 ]; then
  echo "verdict=no_claims"
  exit 1
fi
if [ "$unkept" -gt 0 ]; then
  echo "verdict=claim_unkept"
  exit 1
fi
echo "verdict=ok"
exit 0
