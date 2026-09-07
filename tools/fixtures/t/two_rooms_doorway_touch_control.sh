#!/bin/sh
# tools/fixtures/t/two_rooms_doorway_touch_control.sh -- the pen for two_rooms_doorway_touch_scan.sh.
#
# WHAT THIS PROVES. Thirty behaviors, each on a real git repository built in a throwaway pen.
# The scan reads a commit's staged set and asks whether every page it ADDS names its room at the
# door. So the pen builds exactly that: a room with pages in it, a commit that adds one, a commit
# that changes one, and a commit that touches neither.
#
# Each refusal is shown from both sides -- planted, then lifted. A refusal proven only in the
# passing direction reads the same as a bypass. Each welcome is asserted as hard as each refusal,
# because a guard that reds on ordinary work is a guard somebody turns off.
#
# THE SEAM THIS PEN EXISTS FOR is a boundary two readings share. The cadence guard
# two_rooms_doorway walks every page in three rooms and holds the unnamed ones under a ceiling
# that only falls. This scan reads what a commit ADDS and holds those at zero. The two classes
# differ on purpose, so the pen measures the seam: a MODIFIED page naming no room is reported and
# walks free, while the same page ADDED refuses. Both directions matter. Loosen one and the guard
# reds on ordinary work; loosen the other and it waves through the class it was built for.
#
# THE WALL ITSELF IS DRIVEN, rather than the reading alone. A scan's refusal says little about a
# commit somebody actually makes. So the last five cases copy tools/hooks/pre-commit into the
# pen's own hooks directory and run real git commit calls through it: one refused, one freed by
# naming the room, one adding no page at all.
#
# THE PEN SEATS ITS ROOM FIRST, because an empty roster is itself a refusal. The roster reads
# git ls-files over three rooms. A reading that returns nothing has narrowed, which is the defect
# its own header records three firings of, so the scan refuses there. One page is therefore
# committed before anything else is asked.
#
#   sh tools/fixtures/t/two_rooms_doorway_touch_control.sh
#
# Run from the repository root; the pen is removed on exit whether it passes or fails.
set -u

if [ -n "${GRAIN_MIND_GIT:-}" ] && [ -f "$GRAIN_MIND_GIT" ]; then
  git() { bash "$GRAIN_MIND_GIT" "$@"; }
fi

scan=tools/fixtures/t/two_rooms_doorway_touch_scan.sh
hook=tools/hooks/pre-commit
roster=tools/fixtures/t/two_rooms_doorway_roster.sh
one=tools/fixtures/t/two_rooms_doorway_scan_one.sh
seat_src=tools/fixtures/t/two_rooms_doorway_scan.rish
for f in "$scan" "$roster" "$one" "$seat_src"; do
  if [ ! -f "$f" ]; then
    echo "control=refused"
    echo "refused: $f is what this pen drives, and it is absent" >&2
    exit 1
  fi
done

mkdir -p .mind-state/tmp
pen=$(mktemp -d .mind-state/tmp/doorway-touch.XXXXXX) || exit 1
trap 'rm -rf "$pen"' EXIT

fails=0
ok() { echo "case=$1 ok"; }
no() { echo "case=$1 FAILED -- $2"; fails=$((fails + 1)); }

mkdir -p "$pen/tools/fixtures/t" "$pen/external-research" "$pen/active-designing/date/20260830" "$pen/docs"
cp "$scan"     "$pen/tools/fixtures/t/two_rooms_doorway_touch_scan.sh"
cp "$roster"   "$pen/tools/fixtures/t/two_rooms_doorway_roster.sh"
cp "$one"      "$pen/tools/fixtures/t/two_rooms_doorway_scan_one.sh"
# Only the seating line is carried, since that is the one fact this scan reads from the cadence
# scan. Copying the whole Rishi source would drag a parser this pen has no reason to hold.
grep -m1 '^let seating = "' "$seat_src" > "$pen/tools/fixtures/t/two_rooms_doorway_scan.rish"

( cd "$pen" && git init -q . && git config user.email pen@example.invalid \
  && git config user.name Pen && git config commit.gpgsign false ) || {
  echo "control=refused"; echo "refused: the pen could not become a git repository" >&2; exit 1; }

run()     { ( cd "$pen" && sh tools/fixtures/t/two_rooms_doorway_touch_scan.sh "$@" 2>/dev/null ); }
verdict() { run "$@" | grep '^verdict=' | head -1 | cut -d= -f2; }
key()     { k=$1; shift; run "$@" | grep "^$k=" | head -1 | cut -d= -f2; }

# A page in the doorway's shape: a one-clock basename after the seating, and a Status the caller
# chooses. Written as a here-document so the head reads exactly as a real page's does.
page() { # page <path> <status-tail>
  cat > "$pen/$1" <<PAGE
# A pen page

**Stamp:** \`20260830.101010\`
**Language:** EN
**Voice:** Kyri
**Status:** $2

Body.
PAGE
}

named=external-research/20260830-101010_a-page-that-names-its-room.md
unnamed=external-research/20260830-101011_a-page-that-names-no-room.md
folded=active-designing/date/20260830/20260830-101012_a-folded-page.md
elder=external-research/20260601-101013_a-page-from-before-the-seating.md
door=external-research/README.md
yonder=external-research/yonder/20260830-101014_a-deferred-page.md

# -- the room is populated first, because an EMPTY roster is itself a refusal ---------------------
# The roster reads `git ls-files` over three rooms. A reading that returns nothing has narrowed --
# the exact defect the roster's own header records three firings of -- so the scan refuses rather
# than reporting a smaller clean tree. The pen therefore seats one page before asking anything else.
page "$named" 'Living -- checkable, bound by a witness.'
( cd "$pen" && git add "$named" && git commit -qm "pen: the room's first page" )

# -- the resting state: a commit that stages nothing this scan speaks for -------------------------
echo "x" > "$pen/unrelated.txt"
( cd "$pen" && git add unrelated.txt )
[ "$(verdict)" = ok ] && ok resting_commit_walks_free || no resting_commit_walks_free "a commit staging no page refused"
[ "$(key added_read)" = 0 ] && ok resting_reads_no_page || no resting_reads_no_page "added_read was not zero"
( cd "$pen" && git commit -qm "pen: an unrelated commit" )

# -- the gated class, planted -------------------------------------------------------------------
page "$unnamed" 'Proposed -- external research. The numbers are measured.'
( cd "$pen" && git add "$unnamed" )
[ "$(verdict)" = misread ] && ok added_unnamed_refuses || no added_unnamed_refuses "an added page naming no room walked free"
[ "$(key added_unnamed)" = 1 ] && ok added_unnamed_counted || no added_unnamed_counted "the count did not read one"
run | grep -q "^detail=RED_added_page_names_no_room" \
  && ok added_unnamed_names_its_class || no added_unnamed_names_its_class "the detail line was absent"
run | grep -q "^detail_page=$unnamed" \
  && ok added_unnamed_names_the_page || no added_unnamed_names_the_page "the page was not named"
run | grep -q "^detail_repair=name one of" \
  && ok added_unnamed_names_the_repair || no added_unnamed_names_the_repair "the repair was not named"
run | grep -q "$pen" \
  && no pen_path_stays_out_of_the_report "the temporary pen path reached the reader" \
  || ok pen_path_stays_out_of_the_report

# -- the same page, repaired: the refusal lifts ---------------------------------------------------
page "$unnamed" 'Proposed -- mixed, external research. The numbers are measured.'
( cd "$pen" && git add "$unnamed" )
[ "$(verdict)" = ok ] && ok repaired_page_walks_free || no repaired_page_walks_free "the repaired page still refused"

# -- the reading is off the INDEX, not off disk ---------------------------------------------------
# The index holds the repaired page; the worktree is spoiled afterwards. A scan reading disk would
# refuse a commit that carries a perfectly good page.
page "$unnamed" 'Proposed -- external research, no room named.'
[ "$(verdict)" = ok ] && ok reads_the_index_not_the_disk || no reads_the_index_not_the_disk "a spoiled worktree refused a clean index"
( cd "$pen" && git checkout -q -- "$unnamed" 2>/dev/null || git cat-file -p ":$unnamed" > "$unnamed" )
( cd "$pen" && git commit -qm "pen: a page that names its room" )

# -- a page that names its room, added ------------------------------------------------------------
named2=external-research/20260830-101016_a-second-page-that-names-its-room.md
page "$named2" 'Living -- checkable, bound by a witness.'
( cd "$pen" && git add "$named2" )
[ "$(verdict)" = ok ] && ok added_named_walks_free || no added_named_walks_free "a page naming its room refused"
[ "$(key added_read)" = 1 ] && ok added_named_was_read || no added_named_was_read "the page was not read at all"
( cd "$pen" && git commit -qm "pen: a named page" )

# -- the seam: MODIFIED and unnamed is reported, never gated --------------------------------------
page "$unnamed" 'Proposed -- external research, the room dropped again.'
( cd "$pen" && git add "$unnamed" )
[ "$(verdict)" = ok ] && ok modified_unnamed_walks_free || no modified_unnamed_walks_free "an elder page refused an unrelated commit"
[ "$(key changed_unnamed_reported)" = 1 ] && ok modified_unnamed_is_reported || no modified_unnamed_is_reported "the modified page was not reported"
run | grep -q "^doorway_changed_unnamed=" \
  && ok modified_unnamed_names_itself || no modified_unnamed_names_itself "the report line was absent"
( cd "$pen" && git commit -qm "pen: the room dropped again" )

# -- the roster's own exclusions travel, rather than being respelled ------------------------------
page "$folded" 'Proposed -- no room.'
( cd "$pen" && git add "$folded" )
[ "$(verdict)" = misread ] && ok folded_shelf_is_read || no folded_shelf_is_read "a page on a date/ shelf left the reach"
( cd "$pen" && git reset -q )

cat > "$pen/$door" <<'DOOR'
# external-research -- the room's front door

**Status:** Foundation
DOOR
( cd "$pen" && git add "$door" )
[ "$(verdict)" = ok ] && ok front_door_stays_out || no front_door_stays_out "a room's README was read as a page"
( cd "$pen" && git commit -qm "pen: the front door" )

mkdir -p "$pen/external-research/yonder"
page "$yonder" 'Proposed -- no room.'
( cd "$pen" && git add "$yonder" )
[ "$(verdict)" = ok ] && ok yonder_stays_out || no yonder_stays_out "a yonder page was gated"
( cd "$pen" && git commit -qm "pen: a deferred page" )

# -- a page from before the seating is grandfathered ----------------------------------------------
page "$elder" 'Proposed -- no room.'
( cd "$pen" && git add "$elder" )
[ "$(verdict)" = ok ] && ok before_seating_walks_free || no before_seating_walks_free "a pre-seating page was gated"
( cd "$pen" && git commit -qm "pen: an elder page" )

# -- head mode reads the commit just made ---------------------------------------------------------
page external-research/20260830-101015_a-head-mode-page.md 'Proposed -- no room.'
( cd "$pen" && git add external-research/20260830-101015_a-head-mode-page.md \
  && git commit -qm "pen: a page committed without its room" )
[ "$(verdict head)" = misread ] && ok head_mode_reads_the_commit || no head_mode_reads_the_commit "head mode did not see the committed page"

# -- the planted refusal, and the arguments the scan refuses --------------------------------------
[ "$(verdict prove-red)" = misread ] && ok prove_red_refuses || no prove_red_refuses "prove-red did not refuse"
[ "$(verdict nonsense)" = misread ] && ok unknown_argument_refuses || no unknown_argument_refuses "an unknown argument walked free"

# -- a scan that cannot find its seating refuses rather than grandfathering everything -------------
mv "$pen/tools/fixtures/t/two_rooms_doorway_scan.rish" "$pen/seating.aside"
[ "$(verdict)" = misread ] && ok missing_seating_refuses || no missing_seating_refuses "an unreadable seating stamp read as clean"
run | grep -q "^detail=RED_seating_stamp_unreadable" \
  && ok missing_seating_names_itself || no missing_seating_names_itself "the seating refusal did not name itself"
mv "$pen/seating.aside" "$pen/tools/fixtures/t/two_rooms_doorway_scan.rish"
[ "$(verdict head)" = misread ] && ok seating_restored || no seating_restored "the reading did not return after the seating came back"

# -- the WALL itself, not merely the reading -------------------------------------------------------
# A scan that refuses proves nothing about a commit somebody actually makes. This drives the real
# tools/hooks/pre-commit over a real `git commit` in the pen, so the refusal is the one a hand meets.
if [ -f "$hook" ]; then
  mkdir -p "$pen/tools/hooks" "$pen/.git/hooks" "$pen/rishi/bin"
  cp "$hook" "$pen/.git/hooks/pre-commit"
  chmod +x "$pen/.git/hooks/pre-commit"
  # The hook opens `[ -x rishi/bin/rishi ] || exit 0`, so a tree without the interpreter is one the
  # hook declines to speak in. The pen plants an executable stub rather than the interpreter: this
  # rule shells out to `sh`, and a hook that silently exits would prove nothing at all.
  printf '#!/bin/sh\nexit 0\n' > "$pen/rishi/bin/rishi"
  chmod +x "$pen/rishi/bin/rishi"

  hookpage=external-research/20260830-101017_a-page-the-wall-must-refuse.md
  page "$hookpage" 'Proposed -- external research, and no room named.'
  ( cd "$pen" && git add "$hookpage" )
  if hook_said=$( cd "$pen" && git commit -qm "pen: a page the wall must refuse" 2>&1 ); then
    no hook_refuses_unnamed_page "the wall let an unnamed page commit"
  else
    ok hook_refuses_unnamed_page
  fi
  printf '%s' "$hook_said" | grep -q "names no room" \
    && ok hook_says_why || no hook_says_why "the refusal did not say what was wrong"
  printf '%s' "$hook_said" | grep -q "detail_repair=name one of" \
    && ok hook_names_repair || no hook_names_repair "the refusal did not name the repair"

  page "$hookpage" 'Proposed -- mixed, external research. The numbers are measured.'
  ( cd "$pen" && git add "$hookpage" )
  if ( cd "$pen" && git commit -qm "pen: the page names its room now" >/dev/null 2>&1 ); then
    ok hook_frees_repaired_page
  else
    no hook_frees_repaired_page "the wall refused a page that names its room"
  fi

  echo "y" > "$pen/unrelated2.txt"
  ( cd "$pen" && git add unrelated2.txt )
  if ( cd "$pen" && git commit -qm "pen: a commit that adds no page" >/dev/null 2>&1 ); then
    ok hook_rests_off_pages
  else
    no hook_rests_off_pages "the wall refused a commit that adds no page"
  fi
else
  no hook_present "tools/hooks/pre-commit is absent, so the wall could not be driven"
fi

echo "cases_failed=$fails"
if [ "$fails" -gt 0 ]; then
  echo "control=misread"
  exit 1
fi
echo "control=ok"
