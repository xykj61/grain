#!/bin/sh
# qa_setting_declared_control.sh -- prove the setting census on planted pages in a throwaway pen.
#
# Every refusal is planted and then LIFTED, and every welcome is asserted as hard as every refusal,
# since a refusal proven only in the passing direction cannot be told from a bypass. Each bucket is
# proven by MOVING a member into its neighbour, so a scan that put every page in one bucket would
# fail rather than pass three counts that happened to sum correctly.
#
# BOUNDS: one pen, at most 40 planted pages, removed on exit.
set -eu

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SCAN=${QA_SETTING_SCAN:-$here/qa_setting_declared_scan.sh}

pass=0
fail=0
ok()   { pass=$((pass + 1)); }
bad()  { fail=$((fail + 1)); echo "FAIL $1"; }
check(){ if [ "$2" = "$3" ]; then ok; else bad "$1 -- wanted [$3] read [$2]"; fi }

pen=$(mktemp -d "${TMPDIR:-/tmp}/qa-setting-pen.XXXXXX")
trap 'rm -rf "$pen"' EXIT INT TERM

cd "$pen"
git init -q . 2>/dev/null
git config user.email pen@example.invalid
git config user.name "pen"

plant() {  # plant <path> <header-body>
  mkdir -p "$(dirname "$1")"
  printf '%s\n' "$2" > "$1"
}

run_scan() { QA_SETTING_ROOT="$pen" sh "$SCAN" "$@" 2>&1; }
field()    { printf '%s\n' "$1" | sed -nE "s/.*$2=([0-9]+).*/\1/p" | head -1; }

# --- the three buckets, each with one member ----------------------------------------------------
plant named.md   '# N

**Style:** Gauge, Door setting
**Voice:** Kyri'
plant unnamed.md '# U

**Style:** Gauge
**Voice:** Kyri'
plant bare.md    '# B

**Voice:** Kyri'
git add -A && git commit -qm plant

out=$(run_scan)
check "pages reads three"        "$(field "$out" pages)"           3
check "one names a setting"      "$(field "$out" setting_named)"   1
check "one leaves it unnamed"    "$(field "$out" setting_unnamed)" 1
check "one carries no style"     "$(field "$out" no_style_line)"   1
check "verdict ok on a clean pen" "$(printf '%s' "$out" | grep -c '^verdict=ok')" 1

# --- the discriminating move: unnamed -> named --------------------------------------------------
plant unnamed.md '# U

**Style:** Gauge, Field setting
**Voice:** Kyri'
git add -A && git commit -qm move
out=$(run_scan)
check "the move raises named"     "$(field "$out" setting_named)"   2
check "the move empties unnamed"  "$(field "$out" setting_unnamed)" 0
plant unnamed.md '# U

**Style:** Gauge
**Voice:** Kyri'
git add -A && git commit -qm back
out=$(run_scan)
check "and lifting it restores"   "$(field "$out" setting_unnamed)" 1

# --- the header rule: a BODY that names a setting declares nothing -------------------------------
plant body.md '# Body

**Style:** Gauge

---

This page is written at the Door setting, which it says only down here.'
git add -A && git commit -qm body
out=$(run_scan)
check "a body naming a setting declares nothing" "$(field "$out" setting_unnamed)" 2

# --- Meter counts as named, and the read is case-insensitive -------------------------------------
plant meter.md '# M

**Style:** Gauge, Meter setting'
plant lower.md '# L

**Style:** gauge, field setting'
git add -A && git commit -qm named2
out=$(run_scan)
check "Meter is a named setting"      "$(field "$out" setting_named)" 3
check "the read is case-insensitive"  "$(field "$out" pages)"         6

# --- what the population rule reads past ---------------------------------------------------------
plant "20260101-010101_dated.md"        '# D

**Style:** Gauge'
plant "date/20260101/inside-a-shelf.md" '# S

**Style:** Gauge'
plant "gratitude/borrowed.md"           '# G

**Style:** Gauge'
plant "vendor/theirs.md"                '# V

**Style:** Gauge'
plant "seed/projected.md"               '# P

**Style:** Gauge'
plant "tools/fixtures/q/a-fixture.md"   '# F

**Style:** Gauge'
plant "archive/old.md"                  '# A

**Style:** Gauge'
plant "yonder/later.md"                 '# Y

**Style:** Gauge'
git add -A && git commit -qm readpast
out=$(run_scan)
check "eight read-past rooms change nothing" "$(field "$out" pages)" 6

# --- a path in the INDEX the working tree lacks is counted, never silently dropped ----------------
plant vanish.md '# V

**Style:** Gauge'
git add -A && git commit -qm vanish
rm -f vanish.md
out=$(run_scan)
check "an absent path is counted"        "$(field "$out" absent_in_worktree)" 1
check "and left out of the population"   "$(field "$out" pages)"              6
git rm -q --cached vanish.md && git commit -qm unvanish
out=$(run_scan)
check "lifting it clears the count"      "$(field "$out" absent_in_worktree)" 0

# --- an untracked page is nobody's fault yet ------------------------------------------------------
plant untracked.md '# X

**Style:** Gauge'
out=$(run_scan)
check "an untracked page is not read" "$(field "$out" pages)" 6
rm -f untracked.md

# --- a tracked path holding a SPACE is one page, never two ---------------------------------------
plant "a page with spaces.md" '# Sp

**Style:** Gauge'
git add -A && git commit -qm spaced
out=$(run_scan)
check "a spaced path reads as one page" "$(field "$out" pages)" 7

# --- list mode names the undeclared ----------------------------------------------------------------
out=$(run_scan list)
check "list names the unnamed pages" "$(printf '%s\n' "$out" | grep -c '^unnamed_setting ')" 3

# --- price mode: refuses without the card, and prices with one --------------------------------
out=$(run_scan price 2>&1 || true)
check "price refuses when the card is absent" "$(printf '%s\n' "$out" | grep -c 'detail=card_absent')" 1

# A stub card, planted so the pricing arithmetic is proven rather than assumed: it answers 77 at
# Door and 82 at Field, which is one page whose grade CROSSES the B door at 80 on a word the page
# never says -- the very shape this census was built to price.
mkdir -p tools/fixtures/q
cat > tools/fixtures/q/qa_report_card.sh <<'STUB'
#!/bin/sh
for a in "$@"; do case "$prev" in --setting) s=$a ;; esac; prev=$a; done
[ "$s" = door ] && echo "composite=77" || echo "composite=82"
STUB
git add -A && git commit -qm stubcard
out=$(QA_SETTING_STRIDE=1 run_scan price 2>&1 || true)
check "price reports how many it priced"   "$(field "$out" priced)"          3
check "every priced page scores apart"     "$(field "$out" spread_differs)"  3
check "and every one crosses the B door"   "$(field "$out" crosses_b)"       3
check "the mean spread is five points"     "$(field "$out" mean_spread_x100)" 500

# The judged SERVICE stand-in cancels out of the spread and does NOT cancel out of a crossing, and
# the pen proves both halves: this stub adds the service word to its answer, so 77/82 at one
# stand-in becomes 87/92 at another -- same spread, no crossing.
cat > tools/fixtures/q/qa_report_card.sh <<'STUB'
#!/bin/sh
for a in "$@"; do
  case "$prev" in --setting) s=$a ;; --service) v=$a ;; esac
  prev=$a
done
base=77; [ "$s" = field ] && base=82
echo "composite=$((base + v - 90))"
STUB
git add -A && git commit -qm servicecard
out=$(QA_SETTING_STRIDE=1 QA_SETTING_SERVICE=90 run_scan price 2>&1 || true)
check "at the low stand-in every page crosses"  "$(field "$out" crosses_b)" 3
check "and the spread is five points"           "$(field "$out" mean_spread_x100)" 500
out=$(QA_SETTING_STRIDE=1 QA_SETTING_SERVICE=100 run_scan price 2>&1 || true)
check "at the high stand-in none crosses"       "$(field "$out" crosses_b)" 0
check "yet the spread is unchanged"             "$(field "$out" mean_spread_x100)" 500
check "and the reading names its stand-in"      "$(printf '%s\n' "$out" | grep -c 'crosses_b=0 at service=100')" 1

# lifted: a card that answers the SAME at both settings crosses nothing, so the counter is proven
# to move rather than merely to be printed.
cat > tools/fixtures/q/qa_report_card.sh <<'STUB'
#!/bin/sh
echo "composite=82"
STUB
git add -A && git commit -qm flatcard
out=$(QA_SETTING_STRIDE=1 run_scan price 2>&1 || true)
check "a flat card crosses nothing"        "$(field "$out" crosses_b)"       0
check "and reports no spread"              "$(field "$out" spread_differs)"  0

# --- the instrument refuses rather than reporting an empty tree as a clean one --------------------
# Two refusals wearing one verdict, told apart by their DETAIL: a directory git cannot read at all,
# and a repository holding no documents. Both must refuse, and a reader must be able to tell which.
outside=$(mktemp -d "${TMPDIR:-/tmp}/qa-setting-bare.XXXXXX")
out=$(QA_SETTING_ROOT="$outside" sh "$SCAN" 2>&1 || true)
check "a directory outside any repository refuses" "$(printf '%s\n' "$out" | grep -c 'git_ls_files_refused')" 1
rm -rf "$outside"
emptypen=$(mktemp -d "${TMPDIR:-/tmp}/qa-setting-empty.XXXXXX")
( cd "$emptypen" && git init -q . && git config user.email p@e.invalid && git config user.name p )
out=$(QA_SETTING_ROOT="$emptypen" sh "$SCAN" 2>&1 || true)
check "a tree with no documents refuses" "$(printf '%s\n' "$out" | grep -c 'no_tracked_documents')" 1
rm -rf "$emptypen"

# --- the declaration rule, repaired 20260910: WHERE a page writes the key ------------------------
# Two shapes stood outside the elder readings, and each was missed by a different instrument. A
# page may open with a logo block, a title and badges above its first `---` rule and write its
# front matter BELOW it -- README.md does -- which the block rule read as declaring nothing. And a
# page may write the key INLINE after another -- docs/README.md does -- which the card's anchored
# `^**Style:**` read as absent. Both are declarations, and both are proven here.
plant below_rule.md '# Badged

<p align="center">a badge block</p>

---

**Language:** EN - **Voice:** Kyri
**Style:** Gauge, Door setting'
plant inline_key.md '# Inline

**Language:** EN - **Voice:** Kyri - **Style:** Gauge, Field setting'
git add -A && git commit -qm shapes
out=$(run_scan)
check "a declaration below the first rule is read"   "$(field "$out" style_declared)" 8
check "an inline key is a declaration too"           "$(field "$out" setting_named)"  5

# The head bound is what keeps body prose out, now that the first `---` no longer does. A page
# discussing the word forty lines down declares nothing.
{
  printf '# Deep\n\n'
  i=0; while [ "$i" -lt 45 ]; do printf 'filler line %s\n' "$i"; i=$((i + 1)); done
  printf '**Style:** Gauge, Door setting\n'
} > deep.md
git add -A && git commit -qm deep
out=$(run_scan)
check "a style key past the head bound declares nothing" "$(field "$out" no_style_line)" 2

# --- the reader is CITED from the card, never copied ---------------------------------------------
# Three legs, because a citation has three failure modes and only one of them is the good one. An
# absent card refuses; a card that no longer publishes the function refuses; and a card publishing
# a DIFFERENT function changes this scan's answer, which is what proves the citation is live rather
# than decorative.
inst=$(mktemp -d "${TMPDIR:-/tmp}/qa-setting-inst.XXXXXX")
cp "$SCAN" "$inst/qa_setting_declared_scan.sh"
out=$(QA_SETTING_ROOT="$pen" sh "$inst/qa_setting_declared_scan.sh" 2>&1 || true)
check "an absent card refuses" "$(printf '%s\n' "$out" | grep -c 'card_absent')" 1
printf '#!/bin/sh\n# a card with no reader\n' > "$inst/qa_report_card.sh"
out=$(QA_SETTING_ROOT="$pen" sh "$inst/qa_setting_declared_scan.sh" 2>&1 || true)
check "a card without the reader refuses" "$(printf '%s\n' "$out" | grep -c 'card_no_longer_publishes_declared_style_line_of')" 1
{
  printf '#!/bin/sh\n'
  printf 'QA_HEAD_LINES=40\n'
  printf 'declared_style_line_of() {\n'
  printf '  :\n'
  printf '}\n'
} > "$inst/qa_report_card.sh"
out=$(QA_SETTING_ROOT="$pen" sh "$inst/qa_setting_declared_scan.sh" 2>&1 || true)
check "a card publishing a blind reader is believed" "$(field "$out" no_style_line)" "$(field "$out" pages)"
rm -rf "$inst"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
