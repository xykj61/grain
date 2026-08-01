#!/bin/sh
# Equinox e133 — fuse verify dialect already GREEN (e132). No second fix.
# Exit 0 when living tree carries the widen, e111 greens, census 10+1, shred held.
# No backtick characters.
#
#   sh tools/fixtures/equinox_e133_fuse_verify_dialect_scan.sh
#   sh tools/fixtures/equinox_e133_fuse_verify_dialect_scan.sh prove-red
#
# Law: do not manufacture a second fix for a red already cleared.
# Law: compact is one roof for date and full stamp.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
COUNSEL=counsel/20260801-003457_e133-fuse-verify-dialect-green.md
ELDER=counsel/20260801-001244_e132-date-dialect-timestamp.md
LEXICON=context/LEXICON.md
MAP=work-in-progress/EQUINOX_SEAT_MAP.md
REMEMBER=work-in-progress/REMEMBER.md
E111=tools/fixtures/equinox_e111_date_dialect_scan.sh
DD=tools/fixtures/date_dialect_scan.sh
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md

if test "$MODE" = "prove-red"; then
  echo "detail=RED_second_fix_manufactured"
  echo "verdict=misread"
  exit 1
fi

if ! test -f "$CONTROL_SCAN"; then
  echo "CONTROL=ABSENT"
  echo "verdict=absent"
  exit 1
fi
CONTROL_OUT=$(sh "$CONTROL_SCAN")
echo "$CONTROL_OUT" | rg -q '^verdict=ok$' || {
  echo "control_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "control_gate=honored"

for p in "$COUNSEL" "$ELDER" "$LEXICON" "$MAP" "$REMEMBER" "$E111" "$DD" "$PRIN"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# Elder e132 pattern still present (source \\. form)
rg -Fq '[0-9]{8}(\\.[0-9]{6})?' "$E111" "$DD" || {
  echo "pattern=failed"
  echo "detail=want_e132_widen_still_present"
  echo "verdict=misread"
  exit 1
}
echo "pattern=honored"
echo "elder_fix=e132"

E111_OUT=$(sh "$E111")
echo "$E111_OUT" | rg -q '^verdict=ok$' || {
  echo "e111=failed"
  echo "verdict=misread"
  exit 1
}
echo "e111=honored"
echo "dialect=already_green"

# Law library census: 10 bare · 1 stamp (Lexicon)
CENSUS=$(python3 - <<'PY'
import re, subprocess
from pathlib import Path
files = subprocess.check_output(["git","ls-files","-z","--",":(glob)context/*.md"], text=True).split("\0")
files=[f for f in files if f]
bare=0; stamp=0; stamp_paths=[]
pat=re.compile(r"^\*\*Last updated:\*\* `([0-9]{8})(\.[0-9]{6})?`")
for f in files:
    text=Path(f).read_text(encoding="utf-8", errors="ignore")
    for ln in text.splitlines()[:40]:
        m=pat.match(ln)
        if not m: continue
        if m.group(2):
            stamp += 1
            stamp_paths.append(f)
        else:
            bare += 1
        break
print(f"bare_date={bare}")
print(f"full_stamp={stamp}")
print("stamp_paths=" + ",".join(stamp_paths))
PY
)
echo "$CENSUS"
echo "$CENSUS" | rg -q '^bare_date=10$' || {
  echo "census=failed"
  echo "detail=want_bare_date_10"
  echo "verdict=misread"
  exit 1
}
echo "$CENSUS" | rg -q '^full_stamp=1$' || {
  echo "census=failed"
  echo "detail=want_full_stamp_1"
  echo "verdict=misread"
  exit 1
}
echo "$CENSUS" | rg -q 'LEXICON.md' || {
  echo "census=failed"
  echo "detail=want_lexicon_is_the_stamp_page"
  echo "verdict=misread"
  exit 1
}
echo "census=honored"
echo "first_of_eleven=lexicon"
echo "compact_roof=one"

rg -qi 'first of eleven|already GREEN|already green|two precisions|one compact roof' "$COUNSEL" "$REMEMBER" || {
  echo "living=failed"
  echo "verdict=misread"
  exit 1
}
echo "living=honored"
echo "no_second_fix=honored"

rg -qi 'shred \*\*RED\*\*|shred RED|shred=RED' "$REMEMBER" "$MAP" "$COUNSEL" || {
  echo "shred_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "shred_gate=honored"
echo "shred=RED"

rg -q 'RESERVED' "$MAP" || {
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
}
if rg -q 'seat \*\*128\*\*.*SPENT|128.*LANDED' "$MAP"; then
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
fi
echo "reserve_keep=honored"
echo "seat_128=reserved_close_choir"

if rg -q '^### 128\.' "$ALMANAC"; then
  echo "almanac=failed"
  echo "detail=seat_128_must_stay_unspent"
  echo "verdict=misread"
  exit 1
fi
echo "almanac=honored"
echo "no_content_seat_claimed=honored"

if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
fi
echo "fork=honored"
echo "gates_kept=shred_safe_geode_128"
echo "queue=empty_for_counsel"

echo "story=fuse_verify>e132_already_green>10_bare_1_stamp>shred_held>128_reserved"
echo "verdict=ok"
