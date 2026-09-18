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
# AND FOR ITS FIRST DAY THAT SENTENCE WAS HALF TRUE. A second filter stood one line below it: the
# default room list read `foundations context docs`, so six of the eight pages that declare the key
# were never read at all -- `caravan/HARNESS.md`, `caravan/LADDER.md`, `constel/LADDER.md`,
# `constel/MODULES.md`, `crypto/CONSTANT_TIME.md` and `lotus/LADDER.md`, each naming its own room
# README. All six keep their promise today, and their keeping it was luck rather than a wall, which
# is this guard's own founding case: the Lindy foundation's promise stood broken eighteen days and
# nothing in the tree could hear it. The default population is now every living tracked `.md` page.
# Room arguments still narrow it, because the witness proves its own vacuum by naming a room that
# declares nothing.
#
# HOW THE KEY'S VALUE IS BOUNDED, and why the widening forced it. This tree writes several keys on
# one line, joined by ` - `: `**Front door:** [...] - **Compressed guide:** [...] - **Clean-room
# law:** [...]`. Read as a whole line, that page claims three front doors and two of them are
# promises it never made -- and one of those, a clean-room LAW page, has no reason to name a module
# note back. Four of the eight declaring pages carry the compact idiom, so the widened reading would
# have counted five borrowed claims and reddened the tree on the first of them. The value is
# therefore cut at the next `**Word:**` on the line. The colon is what makes the cut safe: emphasis
# inside a value, `**start here**`, carries none and survives.
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
# With no argument it reads the whole living tree; a room narrows it.
#
# Driven by tools/f/front_door_claim_witness.rish. Run from the repository root.

set -eu

# `xargs_lines` runs a command over a newline-delimited path list in a spelling GNU and BSD userland
# both accept. It is sourced from the tree's own helper, found by an upward walk from `$0` bounded
# at 8 steps rather than by fixed `../..` arithmetic, which is what breaks when a room folds.
#
# THE FALLBACK IS FOR THE PEN. This scan's control drives MUTATED COPIES of it written outside any
# tree, and a copy that cannot find the helper exits before it reads a line -- which reads exactly
# like a mutation that did not bite. So the helper is defined locally when the walk finds no tree,
# and `helper=` says which branch ran, because a fallback nobody can see is a fallback nobody can
# tell from the real thing.
_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/tools/fixtures/s" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    _fd_root=""
    break
  fi
  _fd_root=$(dirname "$_fd_root")
done
if [ -n "$_fd_root" ] && [ -f "$_fd_root/tools/fixtures/s/shell_portable.sh" ]; then
  . "$_fd_root/tools/fixtures/s/shell_portable.sh"
  helper=tree
else
  xargs_lines() {
    _sp_list=$1
    shift
    [ -s "$_sp_list" ] || return 0
    tr '\n' '\0' < "$_sp_list" | xargs -0 "$@"
  }
  key_value() {
    printf '%s\n' "$2" | awk -v k="$1" '
      {
        if (!match($0, "\\*\\*" k "[^:]*:\\*\\*")) next
        rest = substr($0, RSTART + RLENGTH)
        if (match(rest, /\*\*[^*][^*]*:\*\*/)) rest = substr(rest, 1, RSTART - 1)
        print rest
        exit
      }'
  }
  helper=local
fi

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads the tracked tree, so it wants git" >&2; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=no_repo"; echo "refused: not inside a git repository" >&2; exit 1; }

# No argument reads the whole living tree, because the key is the population filter and a room list
# is a second one. Rooms stay accepted so a caller can narrow the reading -- the witness proves its
# own vacuum by naming a room that declares nothing.
if [ "$#" -gt 0 ]; then rooms="$*"; else rooms="(whole tree)"; fi

# Bound named at the door: the living tree holds 1,529 such pages today, read `20260917`, so this
# leaves headroom of better than two and a half times. Past it the scan refuses rather than reading
# on. That figure is free -- `git ls-files | grep -E '\.md$' | grep -vE '/(date|archive|yonder)/'`
# is the reading -- and the bound is the number to trust.
max_pages=4096

pen=${TMPDIR:-/tmp}/fdc-pen-$$
mkdir -p "$pen" || exit 2
trap 'rm -rf "$pen"' EXIT INT TERM
: > "$pen/unkept"
: > "$pen/pages"

git ls-files > "$pen/tracked.txt"

if [ "$#" -gt 0 ]; then
  for room in "$@"; do
    grep -E "^$room/" "$pen/tracked.txt" | grep -E '\.md$' | grep -vE '/(date|archive|yonder)/' >> "$pen/pages" || :
  done
else
  grep -E '\.md$' "$pen/tracked.txt" | grep -vE '/(date|archive|yonder)/' >> "$pen/pages" || :
fi
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

# THE POPULATION IS PREFILTERED IN ONE PASS. Asking each page for the key separately spent one
# `grep` process per page, which the room list kept small and the whole tree does not. One `grep -l`
# over the list names the claiming pages, and the loop below then opens only those -- so the reading
# widened sevenfold while starting fewer processes than it did over three rooms.
: > "$pen/claiming"
xargs_lines "$pen/pages" grep -lE '^\*\*Front door:\*\*' >> "$pen/claiming" 2>/dev/null || :
sort -u "$pen/claiming" -o "$pen/claiming"

# A key's value ends where the next key begins. This tree writes several keys on one line joined by
# ` - `, so a whole-line read lends the front-door key its neighbors' links and publishes promises
# the page never made. The cut takes the text after `**Front door:**` up to the next `**Word:**`;
# requiring the colon is what lets emphasis inside a value, `**start here**`, survive the cut.
# ONE READER, RATHER THAN THIS SCAN'S OWN (20260917). This function was written here first, for
# this key alone. `key_value` in `tools/fixtures/s/shell_portable.sh` is the same cut taking the key
# as an argument, and the two guards that adopted it the same lap found a LIVE fault -- one page
# passing the two-rooms doorway on a token belonging to its neighbour. A reader written three times
# is a reader three scans may come to disagree about, which is why this one moved out.

claims=0
unkept=0
claiming_pages=0

while IFS= read -r page; do
  line=$(grep -m1 '^\*\*Front door:\*\*' "$page" 2>/dev/null || :)
  [ -n "$line" ] || continue
  line=$(key_value "Front door" "$line")
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
done < "$pen/claiming"

echo "rooms=$rooms"
echo "helper=$helper"
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
