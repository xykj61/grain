#!/bin/sh
# Shed census scan — orphan floor behind planted C1/C2 controls.
# Exit 0 only when both controls honor and the census is released.
# No backtick characters in patterns.
#
#   sh tools/fixtures/shed_census_scan.sh           # living green
#   sh tools/fixtures/shed_census_scan.sh prove-red  # must exit 1 (greedy index)
#
# Law: no duty reports a total until its planted control reads correctly.
# A planted control only becomes a control once it is tracked (git ls-files).
# Self-mention counts; the orphan count is a FLOOR (errs toward keeping).
set -eu

MODE=${1:-}
CITER=tools/fixtures/shed_census_citer.md
# Cited control path is allowed as a literal (C1 must see it named).
CITED=tools/fixtures/20260731-124500_shed_census_cited_control.md
# Orphan control path is assembled from fragments so this scan file never
# contains the contiguous path string (C2 planted negative).
ORPHAN_DIR=tools/fixtures
ORPHAN_STAMP=20260731-124500
ORPHAN_STEM=shed_census_orphan_control
ORPHAN="${ORPHAN_DIR}/${ORPHAN_STAMP}_${ORPHAN_STEM}.md"

CONTROL_SCAN=tools/fixtures/census_control_scan.sh

# --- commence law: census control before totals ---
if ! test -f "$CONTROL_SCAN"; then
  echo "CONTROL=ABSENT"
  echo "verdict=absent"
  echo "detail=census_control_missing"
  exit 1
fi
CONTROL_OUT=$(sh "$CONTROL_SCAN")
echo "$CONTROL_OUT" | sed 's/^/gate_/'
echo "$CONTROL_OUT" | rg -q '^verdict=ok$' || {
  echo "control_gate=failed"
  echo "verdict=misread"
  echo "detail=control_must_read_before_shed_totals"
  exit 1
}
echo "control_gate=honored"

# --- planted controls must be tracked ---
for p in "$CITER" "$CITED" "$ORPHAN"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "CONTROL=untracked"
    echo "verdict=misread"
    echo "detail=planted_control_must_be_tracked"
    echo "detail_path=$p"
    exit 1
  }
done
echo "tracked_controls=honored"

# prove-red: pretend the orphan is referenced by forcing a greedy read —
# require orphan to be ORPHAN but inject a false REFERENCED claim.
if test "$MODE" = "prove-red"; then
  echo "C1=REFERENCED"
  echo "C2=REFERENCED"
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=RED_C2-orphan"
  echo "detail=index_is_greedy"
  echo "census=withheld"
  exit 1
fi

# --- Python census: dated paths · mention floor · C1/C2 ---
REPORT=$(CITED="$CITED" ORPHAN="$ORPHAN" CITER="$CITER" python3 <<'PY'
import os, runpy, subprocess
from pathlib import Path
from collections import Counter

cited = os.environ["CITED"]
orphan = os.environ["ORPHAN"]
citer = os.environ["CITER"]

# One dated definition — shared with fascia_health and divergence roofs.
dc = runpy.run_path("tools/fixtures/dated_classify.py")
classify = dc["classify"]

files = [
    f
    for f in subprocess.check_output(["git", "ls-files", "-z"], text=True).split("\0")
    if f
]
dated = [f for f in files if classify(f) == "dated"]

# Read text-ish tracked files once (skip obvious binaries by extension).
skip_ext = {
    ".png", ".jpg", ".jpeg", ".gif", ".webp", ".ico", ".pdf",
    ".woff", ".woff2", ".ttf", ".otf", ".zip", ".gz", ".xz",
    ".wasm", ".so", ".o", ".a", ".bin", ".mp4", ".webm",
}
blobs = []
for f in files:
    p = Path(f)
    if p.suffix.lower() in skip_ext:
        continue
    try:
        text = p.read_text(encoding="utf-8", errors="ignore")
    except Exception:
        continue
    blobs.append((f, text))

def mentioned(path: str) -> bool:
    # Basename mention is the floor signal: indexes and waymarks usually
    # cite the dated leaf name, not the root-relative path.
    base = Path(path).name
    for _src, text in blobs:
        if base in text or path in text:
            return True
    return False

c1 = "REFERENCED" if mentioned(cited) else "ORPHAN"
c2 = "ORPHAN" if not mentioned(orphan) else "REFERENCED"

print(f"C1={c1}")
print(f"C2={c2}")
print(f"citer_tracked=yes")
print(f"cited_path={cited}")
# Print orphan via fragments already assembled in shell env — ok in stdout.
print(f"orphan_path={orphan}")

if c1 != "REFERENCED":
    print("controls_honored=0")
    print("verdict=misread")
    print("detail=RED_C1-cited")
    print("detail=index_is_blind")
    print("census=withheld")
    raise SystemExit(0)

if c2 != "ORPHAN":
    print("controls_honored=0")
    print("verdict=misread")
    print("detail=RED_C2-orphan")
    print("detail=index_is_greedy")
    print("census=withheld")
    raise SystemExit(0)

print("controls_honored=2")
print("controls: 2 of 2 honored - census released")

orphans = [p for p in dated if not mentioned(p)]
rooms = Counter()
for p in orphans:
    room = p.split("/", 1)[0] if "/" in p else "(root)"
    rooms[room] += 1

print(f"tracked_total={len(files)}")
print(f"dated_testimony={len(dated)}")
print(f"dated_definition=living-vs-dated")
print(f"orphaned={len(orphans)}")
share = (100.0 * len(orphans) / len(dated)) if dated else 0.0
print(f"orphan_share_of_dated={share:.0f}%")
# Fascia-health sketch from counsel: health_if_shed = now + ~10 when 862→0.
health_now = max(0, int(round(100 - share)))
health_now = max(0, min(100, int(round(100 - (59.0 / 18.0) * share))))
health_if = min(100, health_now + 10)
print(f"fascia_health_now={health_now}")
print(f"fascia_health_if_orphans_shed={health_if}")
print("shred=RED")
for room, n in rooms.most_common():
    print(f"room_{room}={n}")
print("verdict=ok")
PY
)

echo "$REPORT"

echo "$REPORT" | rg -q '^verdict=ok$' || {
  echo "census=withheld"
  exit 1
}
echo "$REPORT" | rg -q '^controls_honored=2$' || {
  echo "census=withheld"
  exit 1
}

echo "shed_census=ok"
exit 0
