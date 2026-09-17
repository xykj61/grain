#!/bin/sh
# tools/fixtures/b/backtick_path_control.sh -- prove the backticked-path reading on real repositories.
#
# Every refusal is planted and then lifted, and every welcome is asserted as hard as every refusal,
# because a refusal proven only in the passing direction cannot be told from a bypass. Three
# mutations of the scan itself are asserted to bite, so a leg that would pass with the check removed
# is named here rather than trusted.
#
# USAGE
#   sh tools/fixtures/b/backtick_path_control.sh
#
# Driven by tools/b/backtick_path_witness.rish. Run from the repository root.

set -eu

root=$(pwd)
scan="$root/tools/fixtures/b/backtick_path_scan.sh"
[ -f "$scan" ] || { echo "control_verdict=no_scan"; exit 1; }
portable="$root/tools/fixtures/s/shell_portable.sh"
[ -f "$portable" ] || { echo "control_verdict=no_portable"; exit 1; }

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

# The scan is copied into a flat pen holding fixtures/b and fixtures/s and no tree at all, which is
# why its root walk keeps a named sibling fallback.
mkdir -p "$pen/kit/fixtures/b" "$pen/kit/fixtures/s"
cp "$scan" "$pen/kit/fixtures/b/backtick_path_scan.sh"
cp "$portable" "$pen/kit/fixtures/s/shell_portable.sh"
kit="$pen/kit/fixtures/b/backtick_path_scan.sh"

mk_repo() {
  d="$pen/$1"
  mkdir -p "$d"
  ( cd "$d" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )
  echo "$d"
}

repo=$(mk_repo one)
cd "$repo"
mkdir -p room shelf room/sub/deep room/date/20260101 room/archive room/yonder construction
: > room/real.md
: > room/sub/deep/leaf.md
: > shelf/target.md

# --- the welcomes: every one of these must stay uncounted ---
cat > room/welcomes.md <<'MD'
Root-relative and tracked: `shelf/target.md`.
Page-relative and tracked: `../shelf/target.md`.
A tracked directory: `room/sub/`.
No slash at all: `gone.md`.
Holding a space: `gone/not a path.md`.
An extension this tree does not write: `gone/x.pdf`.
Holding a glob: `gone/*.md`.
Holding a brace shorthand: `gone/x_{scan,control}.sh`.
A gitignore allow-back line: `!/publish-seed.sh`.
A home path rather than a tree path: `~/.config/gone/x.json`.
An absolute path: `/etc/gone/x.txt`.
On the web: `https://example.invalid/gone/x.md`.
A link whose anchor is broken belongs to link_text_promise: [`gone/anchor.md`](../shelf/target.md).
MD

# The room-relative try is the one this tree's own reading room taught, and it needs a page standing
# BELOW the room root or the page-relative try answers first. classical-vedic-astrology's reading
# template sits in templates/ and writes `studies/life-frame/...` in a table cell, while linking
# `../studies/life-frame/...` one line above -- both honest to a reader standing in that room.
mkdir -p room/templates
cat > room/templates/cell.md <<'MD'
Room-relative from a page one level down: `sub/deep/leaf.md`.
MD

# --- the plant: one living citation of a path the tree does not carry ---
cat > room/plant.md <<'MD'
The elder room: `work-in-progress/ROADMAP.md`.
MD

# --- testimony keeps every word it wrote, and is counted apart ---
cat > room/20260101-010101_stamped.md <<'MD'
A stamped basename is testimony: `work-in-progress/ROADMAP.md`.
MD
cat > room/date/20260101/folded.md <<'MD'
A dated shelf is testimony: `work-in-progress/ROADMAP.md`.
MD
cat > room/archive/old.md <<'MD'
An archive shelf is testimony: `work-in-progress/ROADMAP.md`.
MD
cat > room/yonder/later.md <<'MD'
A deferred shelf is testimony: `work-in-progress/ROADMAP.md`.
MD

# --- a placeholder is an illustration, counted apart from a citation ---
cat > room/shapes.md <<'MD'
The filing shape: `session-logs/date/YYYYMMDD/YYYYMMDD-HHMMSS_sprig.kyri`.
A named slot: `<room>/<page>.md`.
A shell expansion: `$ROOT/gone/x.sh`.
MD

# --- the two append-only ledgers record what was true when a row was written ---
cat > construction/REDS.md <<'MD'
A row cites the room as it stood: `work-in-progress/ROADMAP.md`.
MD
cat > construction/CHECKPOINTS.md <<'MD'
A checkpoint cites the room as it stood: `work-in-progress/ROADMAP.md`.
MD

git add -A && git commit -q -m pen

out=$(BACKTICK_PATH_CEILING=99999 sh "$kit" 2>/dev/null)
leg "thirteen welcome shapes and a room-relative cell stay uncounted, and one plant is read" "$(printf '%s\n' "$out" | read_key living)" "1"
leg "four testimony shapes are counted apart" "$(printf '%s\n' "$out" | read_key testimony)" "4"
leg "three placeholder shapes are counted apart" "$(printf '%s\n' "$out" | read_key placeholder)" "3"
leg "the plant stands on one page" "$(printf '%s\n' "$out" | read_key living_pages)" "1"

list=$(BACKTICK_PATH_CEILING=99999 sh "$kit" --list 2>/dev/null)
leg "--list names the page and the path it cites" \
  "$(printf '%s\n' "$list" | grep -c 'promise: room/plant.md cites work-in-progress/ROADMAP.md')" "1"
leg "--list stays silent about testimony" \
  "$(printf '%s\n' "$list" | grep -c 'promise: room/archive/old.md')" "0"

# --- the ceiling, proven from both sides with no slack ---
at=$(BACKTICK_PATH_CEILING=1 sh "$kit" 2>/dev/null; echo "exit=$?")
leg "standing exactly at the ceiling walks free" "$(printf '%s\n' "$at" | read_key verdict)" "ok"
over=$(BACKTICK_PATH_CEILING=0 sh "$kit" 2>/dev/null || true; echo "exit=$?")
leg "one over the ceiling refuses" "$(printf '%s\n' "$over" | read_key verdict)" "over_ceiling"
leg "and it leaves a non-zero exit" "$(BACKTICK_PATH_CEILING=0 sh "$kit" >/dev/null 2>&1 && echo yes || echo no)" "no"

# --- lifting the plant returns the reading ---
rm room/plant.md
git add -A && git commit -q -m lift
lifted=$(BACKTICK_PATH_CEILING=0 sh "$kit" 2>/dev/null; echo "exit=$?")
leg "with the plant lifted the living reading is zero" "$(printf '%s\n' "$lifted" | read_key living)" "0"
leg "and the clean tree reaches ok at a ceiling of zero" "$(printf '%s\n' "$lifted" | read_key verdict)" "ok"

# --- a fresh clone answers this, never one pier's disk ---
cat > room/untracked.md <<'MD'
Present on this disk and in no clone: `shelf/ondisk.md`.
MD
git add room/untracked.md && git commit -q -m untracked
: > shelf/ondisk.md
disk=$(BACKTICK_PATH_CEILING=99999 sh "$kit" 2>/dev/null)
leg "an untracked file on disk keeps the promise broken" "$(printf '%s\n' "$disk" | read_key living)" "1"
git add -A && git commit -q -m tracknow
now=$(BACKTICK_PATH_CEILING=99999 sh "$kit" 2>/dev/null)
leg "tracking that same file keeps the promise" "$(printf '%s\n' "$now" | read_key living)" "0"

# --- an instrument that cannot answer refuses rather than answering ---
bare="$pen/bare"
mkdir -p "$bare"
outside=$(cd "$bare" && sh "$kit" 2>/dev/null || true)
leg "outside a repository the scan refuses rather than answering" \
  "$(printf '%s\n' "$outside" | read_key verdict)" "no_repo"
badflag=$(cd "$repo" && sh "$kit" --nope 2>/dev/null || true)
leg "an unknown flag refuses by name" "$(printf '%s\n' "$badflag" | read_key verdict)" "bad_flag"

# --- a root page whose name holds an equals sign, the awk assignment trap ---
cd "$repo"
cat > 'eq=1.md' <<'MD'
A root page awk would read as a setting: `work-in-progress/ROADMAP.md`.
MD
git add -A && git commit -q -m eq
eq=$(BACKTICK_PATH_CEILING=99999 sh "$kit" 2>/dev/null)
leg "the scan sees a root page whose name holds an equals sign" "$(printf '%s\n' "$eq" | read_key living)" "1"

# --- the mutations: each check removed must change an answer ---
mut="$pen/kit/fixtures/b/mutant.sh"
# A mutation removes one whole line by fixed string, so no quoting of the scan's own regexes is
# needed and the removal is visible in the pen rather than encoded in a sed expression.
drop() { grep -vF "$1" "$kit" > "$mut"; }
# A whole-line swap, compared literally, so the scan's own quoting needs no escaping here.
# Handed through the environment rather than through -v: awk processes escape sequences in a -v
# assignment, so a line holding a tab escape would be compared against a real tab and never match.
swap() { SWAP_OLD="$1" SWAP_NEW="$2" awk '$0 == ENVIRON["SWAP_OLD"] { print ENVIRON["SWAP_NEW"]; next } { print }' "$kit" > "$mut"; }

drop 'if (room != "" && here(norm(room "/" s))) continue'
m1=$(BACKTICK_PATH_CEILING=99999 sh "$mut" 2>/dev/null)
leg "dropping the room-relative try makes an honest room cell read broken" \
  "$([ "$(printf '%s\n' "$m1" | read_key living)" -gt "$(printf '%s\n' "$eq" | read_key living)" ] && echo bit || echo silent)" "bit"

drop 'gsub(/\[`[^`]*`\]\(/, "[ANCHOR](", line)'
m2=$(BACKTICK_PATH_CEILING=99999 sh "$mut" 2>/dev/null)
leg "dropping the anchor strip pulls in link_text_promise's own reading" \
  "$([ "$(printf '%s\n' "$m2" | read_key living)" -gt "$(printf '%s\n' "$eq" | read_key living)" ] && echo bit || echo silent)" "bit"

swap "  | sed 's|^|./|' > \"\$work/pages.txt\" || true" "  | cat > \"\$work/pages.txt\" || true"
m3=$(BACKTICK_PATH_CEILING=99999 sh "$mut" 2>/dev/null || true)
leg "dropping the ./ prefix hides the equals-sign page from the reading" \
  "$([ "$(printf '%s\n' "$m3" | read_key living)" -lt "$(printf '%s\n' "$eq" | read_key living)" ] && echo bit || echo silent)" "bit"

drop 'if (ledger) next'
m4=$(BACKTICK_PATH_CEILING=99999 sh "$mut" 2>/dev/null)
leg "dropping the ledger exclusion counts the two append-only rows as living" \
  "$([ "$(printf '%s\n' "$m4" | read_key living)" -eq "$(( $(printf '%s\n' "$eq" | read_key living) + 2 ))" ] && echo bit || echo silent)" "bit"

drop 'if (placeholder(s)) { print "placeholder\t" page "\t" s; continue }'
m5=$(BACKTICK_PATH_CEILING=99999 sh "$mut" 2>/dev/null)
leg "dropping the placeholder test prices three illustrations as citations" \
  "$([ "$(printf '%s\n' "$m5" | read_key living)" -gt "$(printf '%s\n' "$eq" | read_key living)" ] && echo bit || echo silent)" "bit"

# The testimony split is a report rather than a gate, so its mutation is asserted on the GATED
# number: without it every stamped and shelved page joins the living reading.
swap '    print (testimony(page) ? "testimony" : "living") "\t" page "\t" s' '    print "living\t" page "\t" s'
m6=$(BACKTICK_PATH_CEILING=99999 sh "$mut" 2>/dev/null)
leg "dropping the testimony split pulls four shelved pages into the gate" \
  "$([ "$(printf '%s\n' "$m6" | read_key living)" -eq "$(( $(printf '%s\n' "$eq" | read_key living) + 4 ))" ] && echo bit || echo silent)" "bit"

echo "control_legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=red"; exit 1; fi
