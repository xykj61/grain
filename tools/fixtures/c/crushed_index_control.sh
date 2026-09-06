#!/bin/sh
# tools/fixtures/c/crushed_index_control.sh -- prove the crushed-index readings by doing, in a pen.
#
# WHY. A guard that cannot red guards nothing (REDS row 59), and a rule proven only where it passes
# cannot be told from a rule that answers zero to everything. This builds real git repositories in a
# temporary directory, plants one condition in each, runs the REAL
# tools/fixtures/c/crushed_index_scan.sh inside them, and reads its own lines back. The scan is RUN
# rather than copied, so the control and the rule can never drift apart -- a body shared by copying
# is shared only until somebody improves one of them (REDS %215).
#
# WHAT IS PROVEN, each refusal from the side that bites AND the side that walks free.
#   1, 2.   A member of a declared room with no row is counted; adding its row clears it.
#   3, 4.   A declaration naming a room that is not on disk is counted; creating the room clears it.
#   5, 6.   A row whose link target is absent is counted; creating the target clears it.
#   7, 8.   A row whose Stamp cell disagrees with the stamp in the file it links is counted; making
#           them agree clears it. This is the reading no link check can take, because the link
#           resolves perfectly either way.
#   9, 10,  A signature naming no instrument is counted; a standing-roster row backs it, and so
#   11.     does a tracked file under tools/ that names it -- two doors, each proven alone.
#   12.     A page carrying no declaration is not read as an index at all, so the guard reaches
#           only pages that opted in.
#   13.     Dated testimony is read past: a stamp disagreement inside a file whose own basename
#           carries a one-clock stamp counts zero. Accrete-never-break is a rule about what a guard
#           may demand, not only about what a hand may edit.
#   14.     A bare mention of a member's name in PROSE is not a row. The whole failure this guard
#           catches is a page that talks about a room without listing it, so a loose match would
#           have credited exactly the fault it hunts.
#   15.     A link carrying a `#fragment` still names its file, since a fragment is a place inside
#           a page rather than a different page.
#   16.     An empty corpus REFUSES rather than reading clean (REDS %170) -- the shape a guard is
#           least able to notice about itself, since every gate answers zero at once.
#   17.     THE PEN IS INNOCENT: a repository with nothing planted reads `verdict=ok`, so every
#           refusal above is the plant rather than the scaffolding.
#
# WHAT IS NOT PROVEN. Whether a row says anything TRUE about the member it names. This proves the
# counting, not the prose.
#
# USAGE
#   sh tools/fixtures/c/crushed_index_control.sh
#
# Driven by tools/cr/crushed_index_witness.rish. Run from the repository root.

set -u

scan=${1:-$(pwd)/tools/fixtures/c/crushed_index_scan.sh}
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

# `sed -i` has no portable spelling -- GNU takes no argument and BSD REQUIRES a backup suffix, so
# each host misreads the other's line. `sed_inplace` writes through a temporary and copies back
# through the original inode, which every host runs and which keeps the mode the repository tracks.
. "$(pwd)/tools/fixtures/s/shell_portable.sh"

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0
check() {
    label=$1
    got=$2
    want=$3
    if [ "$got" = "$want" ]; then
        pass=$((pass + 1))
        echo "ok: $label -- read $got"
    else
        fail=$((fail + 1))
        echo "REFUSED: $label -- read '$got', wanted '$want'"
    fi
}

# A repository holding one shelf, one declared index, and one room with two members. Every case
# below starts from this and plants exactly one thing.
build() {
    d=$pen/$1
    rm -rf "$d"
    mkdir -p "$d/shelf" "$d/room" "$d/tools" "$d/construction"
    (
        cd "$d" || exit 1
        git init -q .
        git config user.email pen@example.invalid
        git config user.name Pen
        printf '# room door\n' > room/README.md
        printf '# one\n' > room/one.md
        printf '# two\n' > room/two.md
        printf '# a pen tool\n' > tools/pen_tool.sh
        cat > shelf/README.md <<'PAGE'
# The shelf index

**Kind:** crushed index of [`../room/`](../room/)

---

| Page | What it says |
|---|---|
| [one](../room/one.md) | the first |
| [two](../room/two.md) | the second |
PAGE
        git add -A
        git commit -qm 'pen: one shelf, one declared index, one room'
    ) >/dev/null 2>&1
    echo "$d"
}

read_of() {
    ( cd "$1" && CRUSHED_ROOT="$1" sh "$scan" 2>/dev/null ) | sed -n "s/^$2=//p"
}

# --- 17. THE PEN IS INNOCENT, taken first so every refusal below is known to be the plant ---------
d=$(build clean)
check "a pen with nothing planted reads ok" "$(read_of "$d" verdict)" "ok"
check "the declared index is found" "$(read_of "$d" declared_indexes)" "1"
check "both members are counted" "$(read_of "$d" index_members)" "2"

# --- 1, 2. A MEMBER WITH NO ROW -------------------------------------------------------------------
d=$(build unlisted)
( cd "$d" && printf '# three\n' > room/three.md && git add -A && git commit -qm 'pen: a third member' ) >/dev/null 2>&1
check "a member with no row is counted" "$(read_of "$d" index_unlisted)" "1"
check "and the verdict refuses" "$(read_of "$d" verdict)" "index_disagrees"
( cd "$d" && printf '| [three](../room/three.md) | the third |\n' >> shelf/README.md \
  && git add -A && git commit -qm 'pen: the row that was missing' ) >/dev/null 2>&1
check "adding its row clears the count" "$(read_of "$d" index_unlisted)" "0"
check "and the verdict walks free" "$(read_of "$d" verdict)" "ok"

# --- 3, 4. A DECLARATION NAMING A ROOM THAT IS NOT THERE ------------------------------------------
d=$(build gone)
( cd "$d" && sed_inplace 's|crushed index of \[`../room/`\](../room/)|crushed index of [`../attic/`](../attic/)|' shelf/README.md \
  && git add -A && git commit -qm 'pen: declare a room that is not there' ) >/dev/null 2>&1
check "a declared room absent from disk is counted" "$(read_of "$d" index_rooms_missing)" "1"
( cd "$d" && mkdir -p attic && printf '# attic door\n' > attic/README.md \
  && git add -A && git commit -qm 'pen: the room arrives' ) >/dev/null 2>&1
check "creating the room clears it" "$(read_of "$d" index_rooms_missing)" "0"

# --- 5, 6. A ROW WHOSE DOOR DOES NOT OPEN ---------------------------------------------------------
d=$(build door)
( cd "$d" && printf '| [four](../room/four.md) | absent |\n' >> shelf/README.md \
  && git add -A && git commit -qm 'pen: a row naming a file that is not there' ) >/dev/null 2>&1
check "a row naming an absent file is counted" "$(read_of "$d" index_doors_missing)" "1"
( cd "$d" && printf '# four\n' > room/four.md && git add -A && git commit -qm 'pen: the file arrives' ) >/dev/null 2>&1
check "creating the file clears it" "$(read_of "$d" index_doors_missing)" "0"

# --- 7, 8. A STAMP CELL AGAINST THE STAMP IN THE FILE IT LINKS ------------------------------------
# The link resolves in BOTH readings, which is why no link check can take this one. A molt moves the
# file and a repoint sweep follows the link; a stamp in a table is not a link, so it stays behind.
d=$(build stamp)
( cd "$d" && printf '# dated\n' > room/20260101-010101_a-dated-piece.md \
  && printf '| `20250505.050505` | [dated](../room/20260101-010101_a-dated-piece.md) | disagrees |\n' >> shelf/README.md \
  && git add -A && git commit -qm 'pen: a row whose stamp cell disagrees' ) >/dev/null 2>&1
check "a stamp cell disagreeing with its link is counted" "$(read_of "$d" row_stamp_disagrees)" "1"
( cd "$d" && sed_inplace 's/`20250505.050505`/`20260101.010101`/' shelf/README.md \
  && git add -A && git commit -qm 'pen: the cell follows the file' ) >/dev/null 2>&1
check "making them agree clears it" "$(read_of "$d" row_stamp_disagrees)" "0"

# --- 13. DATED TESTIMONY IS READ PAST -------------------------------------------------------------
d=$(build testimony)
( cd "$d" && printf '# dated\n' > room/20260101-010101_a-dated-piece.md \
  && cat > shelf/20260202-020202_a-dated-page.md <<'PAGE'
# A dated page

| `20250505.050505` | [dated](../room/20260101-010101_a-dated-piece.md) | disagrees |
PAGE
  git add -A && git commit -qm 'pen: the same disagreement inside testimony' ) >/dev/null 2>&1
check "the same disagreement inside dated testimony counts zero" "$(read_of "$d" row_stamp_disagrees)" "0"

# --- 9, 10, 11. A GREEN SIGNATURE, AND THE TWO DOORS THAT BACK ONE --------------------------------
d=$(build sig)
( cd "$d" && printf '\nwitness:pen-seat GREEN -- a claim with no instrument behind it\n' >> shelf/README.md \
  && git add -A && git commit -qm 'pen: a signature naming nothing' ) >/dev/null 2>&1
check "a signature naming no instrument is counted" "$(read_of "$d" signature_unbacked)" "1"
check "and the signed page is reported" "$(read_of "$d" signed_pages)" "1"
( cd "$d" && printf 'format standing-equipment-v1\nguard pen_seat\npath tools/pen_tool.sh\n' > construction/standing-equipment.kyri \
  && git add -A && git commit -qm 'pen: back it with a roster row' ) >/dev/null 2>&1
check "a standing-roster row backs it" "$(read_of "$d" signature_unbacked)" "0"
( cd "$d" && rm -f construction/standing-equipment.kyri \
  && printf '# a pen tool that names witness:pen-seat\n' > tools/pen_tool.sh \
  && git add -A && git commit -qm 'pen: back it with a tools file instead' ) >/dev/null 2>&1
check "a tracked tools file naming it backs it too" "$(read_of "$d" signature_unbacked)" "0"

# --- 12. A PAGE THAT DECLARES NOTHING IS NOT AN INDEX ---------------------------------------------
d=$(build undeclared)
( cd "$d" && sed_inplace 's|^\*\*Kind:\*\* crushed index of.*|**Kind:** an ordinary page|' shelf/README.md \
  && printf '# three\n' > room/three.md \
  && git add -A && git commit -qm 'pen: withdraw the declaration, add a member' ) >/dev/null 2>&1
check "a page declaring nothing is not read as an index" "$(read_of "$d" declared_indexes)" "0"
check "so its room's third member is not demanded" "$(read_of "$d" index_unlisted)" "0"

# --- 14. A BARE MENTION IN PROSE IS NOT A ROW -----------------------------------------------------
# This is the failure the guard exists to catch, wearing a friendlier face: a page that TALKS about
# a member without listing it. A loose substring match would credit exactly that.
d=$(build prose)
( cd "$d" && printf '# three\n' > room/three.md \
  && printf '\nThe room also holds three.md, which this sentence merely mentions.\n' >> shelf/README.md \
  && git add -A && git commit -qm 'pen: mention the member without a row' ) >/dev/null 2>&1
check "a bare mention in prose is not a row" "$(read_of "$d" index_unlisted)" "1"

# --- 15. A FRAGMENT STILL NAMES ITS FILE ----------------------------------------------------------
d=$(build fragment)
( cd "$d" && printf '# three\n' > room/three.md \
  && printf '| [three](../room/three.md#a-section) | the third |\n' >> shelf/README.md \
  && git add -A && git commit -qm 'pen: a row whose link carries a fragment' ) >/dev/null 2>&1
check "a link carrying a fragment still names its file" "$(read_of "$d" index_unlisted)" "0"

# --- 16. AN EMPTY CORPUS REFUSES ------------------------------------------------------------------
d=$pen/empty
mkdir -p "$d"
( cd "$d" && git init -q . && git config user.email pen@example.invalid && git config user.name Pen ) >/dev/null 2>&1
out=$( cd "$d" && CRUSHED_ROOT="$d" sh "$scan" 2>&1 )
case "$out" in
  *"refused: no living Markdown found"*) check "an empty corpus refuses rather than reading clean" yes yes ;;
  *) check "an empty corpus refuses rather than reading clean" no yes ;;
esac

echo "control_pass=$pass"
echo "control_fail=$fail"
if [ "$fail" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=broken"
  exit 1
fi
