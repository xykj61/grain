#!/bin/sh
# tools/fixtures/t/two_rooms_doorway_control.sh -- prove the doorway reading by doing, in a pen.
#
# WHY. A guard that cannot red guards nothing (REDS row 59), and this one had never been proven
# from the failing side at all. It builds small git repositories in a temporary pen, plants one
# condition in each, runs the real scan inside them, and checks that the refusals bite and the
# honest readings stay free. Nothing here touches the tree it is run from.
#
# THE TWO SHARPEST LEGS ARE ABOUT REACH RATHER THAN VERDICT. `folded_page_read` proves a page on a
# `date/` shelf is seen at all -- the 607 pages a shell glob dropped in silence -- and
# `flat_only_roster_refused` plants the elder glob back and proves the scan now REFUSES rather
# than reporting a smaller clean tree. A refusal proven only in the passing direction cannot be
# told from a bypass.
#
# USAGE
#   sh tools/fixtures/t/two_rooms_doorway_control.sh
#
# Driven by tools/t/two_rooms_doorway.rish. Run from the repository root.

set -u

root=$(pwd)
rishi_bin=$root/rishi/bin/rishi
for f in \
  tools/fixtures/t/two_rooms_doorway_roster.sh \
  tools/fixtures/t/two_rooms_doorway_scan_one.sh \
  tools/fixtures/t/two_rooms_doorway_scan.rish
do
  [ -f "$root/$f" ] || { echo "control_verdict=fixture_missing:$f" >&2; exit 1; }
done
[ -x "$rishi_bin" ] || { echo "control_verdict=rishi_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

# A page: $1 path, $2 the Status body (empty means no Status line at all).
page() {
  mkdir -p "$(dirname "$1")"
  printf '# pen page\n\n' > "$1"
  [ -n "$2" ] && printf '**Status:** %s\n' "$2" >> "$1"
  printf '\nbody\n' >> "$1"
}

# A page whose door speaks under **Room:** instead: $1 path, $2 the Room body, $3 optional Status.
page_room() {
  mkdir -p "$(dirname "$1")"
  printf '# pen page\n\n' > "$1"
  [ -n "${3:-}" ] && printf '**Status:** %s\n' "$3" >> "$1"
  printf '**Room:** %s\n' "$2" >> "$1"
  printf '\nbody\n' >> "$1"
}

# A repository holding one page of each honest kind, plus whatever the caller plants.
build() {
  d=$pen/$1
  mkdir -p "$d"
  ( cd "$d" \
    && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name Pen \
    && mkdir -p tools/fixtures/t \
    && cp "$root/tools/fixtures/t/two_rooms_doorway_roster.sh" tools/fixtures/t/ \
    && cp "$root/tools/fixtures/t/two_rooms_doorway_scan_one.sh" tools/fixtures/t/ \
    && cp "$root/tools/fixtures/t/two_rooms_doorway_scan.rish" tools/fixtures/t/ ) >/dev/null 2>&1
  echo "$d"
}

commit_all() { ( cd "$1" && git add -A && git commit -qm 'pen: doorway subject' ) >/dev/null 2>&1; }

# Every leg runs the REAL scan, at ceiling zero unless the leg says otherwise, so a single
# counted page is the difference between free and refused.
scan_at() {
  ( cd "$1" && TWO_ROOMS_DOORWAY_CEILING="$2" "$rishi_bin" run tools/fixtures/t/two_rooms_doorway_scan.rish 2>/dev/null )
}

# The honest tree: one page per room, one of them folded onto a date/ shelf, each naming a room.
honest() {
  d=$1
  page "$d/external-research/20260901-010101_a.md" 'Living -- checkable'
  page "$d/active-designing/20260901-010102_b.md" 'Living -- vision'
  page "$d/docs/20260901-010103_c.md" 'Living -- mixed'
  page "$d/docs-geode/20260901-010105_e.md" 'Living -- checkable'
  page "$d/manual/20260901-010106_f.md" 'Living -- mixed'
  page "$d/active-designing/date/20260901/20260901-010104_d.md" 'Living -- research for understanding'
}

# 1. The honest tree -- every page names its room. Free, reading zero, all four rooms reached.
d=$(build honest); honest "$d"; commit_all "$d"
out=$(scan_at "$d" 0)
echo "$out" | grep -q 'verdict=ok' && echo "named_room_free=yes" || echo "named_room_free=no"
echo "$out" | grep -q 'doorway fails=0 ' && echo "clean_reads_zero=yes" || echo "clean_reads_zero=no"
echo "$out" | grep -q 'folded=1' && echo "folded_page_read=yes" || echo "folded_page_read=no"
echo "$out" | grep -q 'geode=1 ' && echo "geode_room_read=yes" || echo "geode_room_read=no"
echo "$out" | grep -q 'manual=1 ' && echo "manual_room_read=yes" || echo "manual_room_read=no"

# 2. A Status that names no room -- counted, named, refused.
d=$(build no_room); honest "$d"
page "$d/external-research/20260902-020202_silent.md" 'Living'
commit_all "$d"
out=$(scan_at "$d" 0)
echo "$out" | grep -q 'doorway fails=1 ' && echo "no_room_counted=yes" || echo "no_room_counted=no"
echo "$out" | grep -q 'FAIL external-research/20260902-020202_silent.md Status does not name a room' \
  && echo "no_room_named=yes" || echo "no_room_named=no"

# 3. No Status line at all -- counted.
d=$(build no_status); honest "$d"
page "$d/external-research/20260902-030303_bare.md" ''
commit_all "$d"
scan_at "$d" 0 | grep -q 'doorway fails=1 ' && echo "no_status_counted=yes" || echo "no_status_counted=no"

# 4. Stamped before the seating -- grandfathered, free.
d=$(build before); honest "$d"
page "$d/external-research/20260101-010101_elder.md" 'Living'
commit_all "$d"
scan_at "$d" 0 | grep -q 'verdict=ok' && echo "before_seating_free=yes" || echo "before_seating_free=no"

# 5. No one-clock stamp in the basename -- grandfathered, free.
d=$(build unstamped); honest "$d"
page "$d/external-research/PLAIN.md" 'Living'
commit_all "$d"
scan_at "$d" 0 | grep -q 'verdict=ok' && echo "unstamped_free=yes" || echo "unstamped_free=no"

# 6. A folded page naming no room -- counted. The three the fold hid, in miniature.
d=$(build folded_fail); honest "$d"
page "$d/active-designing/date/20260820/20260820-131713_landed.md" 'LANDED -- fold C'
commit_all "$d"
out=$(scan_at "$d" 0)
echo "$out" | grep -q 'doorway fails=1 ' && echo "folded_fail_counted=yes" || echo "folded_fail_counted=no"

# 7. yonder and a README stay outside the reach, even carrying a failing Status.
d=$(build excluded); honest "$d"
page "$d/active-designing/yonder/20260902-040404_deferred.md" 'Living'
page "$d/active-designing/date/20260901/README.md" 'Living'
commit_all "$d"
out=$(scan_at "$d" 0)
echo "$out" | grep -q 'verdict=ok' && echo "yonder_excluded=yes" || echo "yonder_excluded=no"
# Counted rather than grepped-for-absence: `grep -qv PATTERN` answers yes whenever ANY line
# fails to match, which is a test that cannot fail (REDS %503). The honest tree holds six
# pages -- one per room, `manual/` joining 20260908 -- and two more were planted, so the reach
# must still read six. This number moves whenever a room joins, and that is the point: the leg
# reads a count rather than an absence, so a room added to `honest()` without being added here
# says so out loud on the lap it lands.
echo "$out" | grep -q 'doorway pages=6 ' && echo "readme_excluded=yes" || echo "readme_excluded=no"

# 8. THE ELDER DEFECT, planted. A roster narrowed to the flat room must refuse rather than
#    report a smaller clean tree -- the folded floor is what tells those two apart.
d=$(build flat_only); honest "$d"
page "$d/active-designing/date/20260820/20260820-131713_landed.md" 'LANDED -- fold C'
commit_all "$d"
cat > "$d/tools/fixtures/t/two_rooms_doorway_roster.sh" <<'ELDER'
#!/bin/sh
for f in external-research/*.md active-designing/*.md docs/*.md; do
  [ -f "$f" ] || continue
  case "$f" in */README.md) continue ;; esac
  echo "$f"
done
ELDER
out=$(scan_at "$d" 0)
echo "$out" | grep -q 'FAIL doorway reach: no folded page read' \
  && echo "flat_only_roster_refused=yes" || echo "flat_only_roster_refused=no"

# 9. The ratchet, from both sides: two failing pages free at a ceiling of two, refused at one.
d=$(build ratchet); honest "$d"
page "$d/external-research/20260902-050505_one.md" 'Living'
page "$d/external-research/20260902-050506_two.md" 'Living'
commit_all "$d"
scan_at "$d" 2 | grep -q 'verdict=ok' && echo "under_ceiling_free=yes" || echo "under_ceiling_free=no"
scan_at "$d" 1 | grep -q 'FAIL doorway ratchet: 2 pages name no room' \
  && echo "over_ceiling_refused=yes" || echo "over_ceiling_refused=no"

# 10. THE SECOND KEY. A page naming its room under **Room:** is free -- the elder read only
#     **Status:** and counted two pages spelling `Mixed` as pages that named no room.
d=$(build room_key); honest "$d"
page_room "$d/external-research/20260902-060601_room_key.md" 'Mixed. The curve is measured; the reading is proposed.'
commit_all "$d"
scan_at "$d" 0 | grep -q 'verdict=ok' && echo "room_key_free=yes" || echo "room_key_free=no"

# 11. THE OTHER LAW WEARING THE SAME WORD. `.claude/rules/design-rooms.md` calls a DIRECTORY a
#     room, so a **Room:** naming one names no register -- counted, and named as a Room line
#     rather than misreported as a missing Status.
d=$(build room_directory); honest "$d"
page_room "$d/active-designing/20260902-060602_directory.md" 'Design essay -- worth reading with the code deleted'
commit_all "$d"
out=$(scan_at "$d" 0)
echo "$out" | grep -q 'doorway fails=1 ' && echo "room_directory_counted=yes" || echo "room_directory_counted=no"
echo "$out" | grep -q 'FAIL active-designing/20260902-060602_directory.md Room does not name a room' \
  && echo "room_directory_named=yes" || echo "room_directory_named=no"

# 12. BOTH KEYS ARE READ. A lifecycle Status beside a Room token is free; neither key alone
#     decides, so a page is never counted for answering under the other one.
d=$(build both_keys); honest "$d"
page_room "$d/docs/20260902-060603_both.md" 'vision' 'Living'
commit_all "$d"
scan_at "$d" 0 | grep -q 'verdict=ok' && echo "both_keys_free=yes" || echo "both_keys_free=no"

# 13. THE ROOM A HAND FORGOT TO NAME. The roster's rooms are a hand-written list, so the way it
#     narrows now is by room rather than by depth: a roster reading every depth of only the elder
#     three passes every other leg in this file and still leaves the shipping shelf unread. It
#     must refuse. This is leg 8's defect one axis over, planted the same way -- the elder list
#     restored -- and proven from the failing side, because a reach leg is exactly the kind of
#     check that reports a smaller clean tree instead of an error.
d=$(build room_missing); honest "$d"
commit_all "$d"
cat > "$d/tools/fixtures/t/two_rooms_doorway_roster.sh" <<'THREEROOM'
#!/bin/sh
git ls-files 'external-research/*.md' 'active-designing/*.md' 'docs/*.md' 2>/dev/null |
while IFS= read -r f; do
  [ -n "$f" ] || continue
  case "$f" in
    */README.md) continue ;;
    */yonder/*|*/archive/*) continue ;;
  esac
  [ -f "$f" ] || continue
  printf '%s\n' "$f"
done
THREEROOM
out=$(scan_at "$d" 0)
echo "$out" | grep -q 'FAIL doorway reach: docs-geode read no page' \
  && echo "geode_missing_refused=yes" || echo "geode_missing_refused=no"
# And the same plant must not walk free on its verdict either -- a scan that names a refusal and
# then reports ok is a report wearing a gate's clothes.
echo "$out" | grep -q 'verdict=ok' && echo "geode_missing_verdict_refused=no" || echo "geode_missing_verdict_refused=yes"

# 14. THE SIBLING PREFIX. `docs/` and `docs-geode/` part at the fourth character, and a reach leg
#     written with a loose prefix would let one room's pages satisfy the other's. With ONLY a
#     docs-geode page planted and no `docs/` page at all, the docs reach must still refuse.
d=$(build sibling_prefix)
page "$d/external-research/20260901-010101_a.md" 'Living -- checkable'
page "$d/active-designing/20260901-010102_b.md" 'Living -- vision'
page "$d/active-designing/date/20260901/20260901-010104_d.md" 'Living -- mixed'
page "$d/docs-geode/20260901-010105_e.md" 'Living -- checkable'
commit_all "$d"
out=$(scan_at "$d" 0)
echo "$out" | grep -q 'FAIL doorway reach: docs read no page' \
  && echo "sibling_prefix_distinct=yes" || echo "sibling_prefix_distinct=no"
echo "$out" | grep -q 'geode=1 ' && echo "sibling_prefix_geode_counted=yes" || echo "sibling_prefix_geode_counted=no"

# 15. THE ROOM BOUGHT RATHER THAN FOUND FREE. `manual/` joined 20260908 after its 7 silent doors
#     were repaired, and a room admitted by a repair narrows exactly like a room admitted free: a
#     roster reading the elder four passes every other leg here and leaves the manual unread. It
#     must refuse, and it must not report ok while refusing -- leg 13 one room over.
d=$(build manual_missing); honest "$d"
commit_all "$d"
cat > "$d/tools/fixtures/t/two_rooms_doorway_roster.sh" <<'FOURROOM'
#!/bin/sh
git ls-files 'external-research/*.md' 'active-designing/*.md' 'docs/*.md' 'docs-geode/*.md' 2>/dev/null |
while IFS= read -r f; do
  [ -n "$f" ] || continue
  case "$f" in
    */README.md) continue ;;
    */yonder/*|*/archive/*) continue ;;
  esac
  [ -f "$f" ] || continue
  printf '%s\n' "$f"
done
FOURROOM
out=$(scan_at "$d" 0)
echo "$out" | grep -q 'FAIL doorway reach: manual read no page' \
  && echo "manual_missing_refused=yes" || echo "manual_missing_refused=no"
echo "$out" | grep -q 'verdict=ok' && echo "manual_missing_verdict_refused=no" || echo "manual_missing_verdict_refused=yes"

# 16. AND THE REPAIR ITSELF IS A READING. The seven manual doors each carried a Status line that
#     answered the lifecycle question and never the register one -- the split `context/TWO_ROOMS.md`
#     tabulates. A page shaped like those, planted in the manual, must be counted and named rather
#     than passed by its room's membership.
d=$(build manual_silent); honest "$d"
page "$d/manual/20260902-020204_setup.md" 'Setup guide -- the general shape runs today'
commit_all "$d"
out=$(scan_at "$d" 0)
echo "$out" | grep -q 'doorway fails=1 ' && echo "manual_silent_counted=yes" || echo "manual_silent_counted=no"
echo "$out" | grep -q 'FAIL manual/20260902-020204_setup.md Status does not name a room' \
  && echo "manual_silent_named=yes" || echo "manual_silent_named=no"
echo "$out" | grep -q 'verdict=ok' && echo "manual_silent_refused=no" || echo "manual_silent_refused=yes"
# And the same door repaired the way this lap repaired the real seven walks free.
d=$(build manual_repaired); honest "$d"
page "$d/manual/20260902-020204_setup.md" 'Setup guide -- the general shape runs today. **Mixed room**: what runs now is checkable; what waits is named as a horizon.'
commit_all "$d"
out=$(scan_at "$d" 0)
echo "$out" | grep -q 'doorway fails=0 ' && echo "manual_repaired_free=yes" || echo "manual_repaired_free=no"
echo "$out" | grep -q 'verdict=ok' && echo "manual_repaired_verdict=yes" || echo "manual_repaired_verdict=no"

echo "control_verdict=ok"
