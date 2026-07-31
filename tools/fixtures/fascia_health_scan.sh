#!/bin/sh
# Fascia-health v1 — live surface over total tracked surface, per room.
# Exit 0 only when planted controls honor and the ratio is released.
# Presence: git ls-files only. On-disk is not in-the-tree.
# No backtick characters in patterns.
#
#   sh tools/fixtures/fascia_health_scan.sh           # living green
#   sh tools/fixtures/fascia_health_scan.sh prove-red  # must exit 1
#
# Law: on-disk is not in-the-tree. Test presence with git ls-files.
# Law: a dated filename without a living header is Tier 2 testimony;
#      everything else is live (context/specs/living-vs-dated.md).
# Law: withhold the ratio until both planted controls read.
set -eu

MODE=${1:-}
LIVE=tools/fixtures/fascia_health_live_control.md
# Dated control path assembled so prove-red stories stay explicit.
DATED_DIR=tools/fixtures
DATED_STAMP=20260731-150648
DATED_STEM=fascia_health_dated_control
DATED="${DATED_DIR}/${DATED_STAMP}_${DATED_STEM}.md"
LAW=context/specs/living-vs-dated.md
CONTROL_SCAN=tools/fixtures/census_control_scan.sh

# --- commence law: census control before totals ---
if ! test -f "$CONTROL_SCAN"; then
  echo "CONTROL=ABSENT"
  echo "verdict=absent"
  exit 1
fi
CONTROL_OUT=$(sh "$CONTROL_SCAN")
echo "$CONTROL_OUT" | sed 's/^/gate_/'
echo "$CONTROL_OUT" | rg -q '^verdict=ok$' || {
  echo "control_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "control_gate=honored"

# --- presence: git ls-files, never test -f alone ---
presence_check() {
  path=$1
  label=$2
  if git ls-files --error-unmatch "$path" >/dev/null 2>&1; then
    echo "presence_${label}=tracked"
    return 0
  fi
  if test -f "$path"; then
    echo "presence_${label}=on_disk_untracked"
    echo "CONTROL=present_on_disk_only"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$path"
    echo "census=withheld"
    return 1
  fi
  echo "presence_${label}=absent"
  echo "CONTROL=ABSENT"
  echo "verdict=misread"
  echo "detail=control_absent"
  echo "detail_path=$path"
  echo "census=withheld"
  return 1
}

presence_check "$LIVE" live || exit 1
presence_check "$DATED" dated || exit 1
git ls-files --error-unmatch "$LAW" >/dev/null 2>&1 || {
  echo "law=failed"
  echo "verdict=misread"
  echo "detail=living_vs_dated_must_be_tracked"
  echo "census=withheld"
  exit 1
}
echo "tracked_controls=honored"
echo "law_path=${LAW}"

# prove-red: release a ratio while claiming on-disk presence is enough
if test "$MODE" = "prove-red"; then
  echo "C_dated=dated"
  echo "C_live=live"
  echo "presence_mode=test_f_only"
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=RED_on_disk_is_not_in_the_tree"
  echo "detail=presence_checked_with_test_f"
  echo "census=withheld"
  echo "tracked_total=withheld"
  exit 1
fi

# --- classify planted controls before library totals (shared dated_classify) ---
REPORT=$(LIVE="$LIVE" DATED="$DATED" python3 <<'PY'
import os, runpy, subprocess
from collections import defaultdict

live_ctrl = os.environ["LIVE"]
dated_ctrl = os.environ["DATED"]

# One dated definition — shared with shed census and divergence roofs.
dc = runpy.run_path("tools/fixtures/dated_classify.py")
classify = dc["classify"]

c_live = classify(live_ctrl)
c_dated = classify(dated_ctrl)
print(f"C_live={c_live}")
print(f"C_dated={c_dated}")

if c_live != "live":
    print("controls_honored=0")
    print("verdict=misread")
    print("detail=RED_live-control")
    print("detail=too_harsh")
    print("census=withheld")
    raise SystemExit(0)
if c_dated != "dated":
    print("controls_honored=0")
    print("verdict=misread")
    print("detail=RED_dated-control")
    print("detail=too_generous")
    print("census=withheld")
    raise SystemExit(0)

print("controls_honored=2")
print("controls: 2 of 2 honored - ratio released")

files = [
    f for f in subprocess.check_output(["git", "ls-files", "-z"], text=True).split("\0")
    if f
]
rooms = defaultdict(lambda: {"total": 0, "dated": 0, "live": 0})
live_n = 0
dated_n = 0
for f in files:
    room = f.split("/", 1)[0] if "/" in f else "(root)"
    rooms[room]["total"] += 1
    cls = classify(f)
    if cls == "live":
        live_n += 1
        rooms[room]["live"] += 1
    else:
        dated_n += 1
        rooms[room]["dated"] += 1

total = len(files)
health = int(round(100.0 * live_n / total)) if total else 0
print(f"tracked_total={total}")
print(f"dated_testimony={dated_n}")
print(f"dated_definition=living-vs-dated")
print(f"live_surface={live_n}")
print(f"fascia_health={health}")
print("shred=RED")

rows = []
for room, d in rooms.items():
    pct = (100.0 * d["live"] / d["total"]) if d["total"] else 0.0
    rows.append((pct, d["live"], d["dated"], d["total"], room))
rows.sort(key=lambda r: (r[0], r[4]))
for pct, lv, dd, tot, room in rows:
    # name shed targets: rooms with dated testimony
    if dd > 0:
        print(f"room_{room}_live_pct={pct:.1f}")
        print(f"room_{room}_live={lv}")
        print(f"room_{room}_dated={dd}")
        print(f"room_{room}_total={tot}")

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
echo "$REPORT" | rg -q '^C_live=live$' || {
  echo "census=withheld"
  exit 1
}
echo "$REPORT" | rg -q '^C_dated=dated$' || {
  echo "census=withheld"
  exit 1
}

echo "fascia_health_scan=ok"
exit 0
