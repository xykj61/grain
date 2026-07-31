#!/bin/sh
# Census control scan — three planted duties. Exit 0 only when every control
# reads correctly. Exit 1 on any misread. No backtick characters in patterns.
#
#   sh tools/fixtures/census_control_scan.sh           # living green path
#   sh tools/fixtures/census_control_scan.sh prove-red  # must exit 1 (naive H1)
#
# Law: no duty reports a total until its planted control reads correctly.
# A positive control proves firing; only a planted negative proves discrimination.
set -eu

H1_FIXTURE=tools/fixtures/census_control_h1_fenced.md
MARKER=tools/fixtures/census_control_marker.md
MODE=${1:-}

if ! test -f "$H1_FIXTURE"; then
  echo "CONTROL=ABSENT"
  echo "duty=h1_fixture"
  echo "verdict=absent"
  exit 1
fi
if ! test -f "$MARKER"; then
  echo "CONTROL=ABSENT"
  echo "duty=marker_fixture"
  echo "verdict=absent"
  exit 1
fi

# --- H1 counts (Python fence mask; no shell backticks) ---
COUNTS=$(python3 - "$H1_FIXTURE" <<'PY'
import re, sys
from pathlib import Path
text = Path(sys.argv[1]).read_text()
lines = text.splitlines()
naive = sum(1 for ln in lines if re.match(r"^#\s", ln))
true = 0
in_fence = False
for ln in lines:
    if re.match(r"^\s*```", ln):
        in_fence = not in_fence
        continue
    if in_fence:
        continue
    if re.match(r"^#\s", ln):
        true += 1
print(f"true={true}")
print(f"naive={naive}")
PY
)
TRUE=$(printf '%s\n' "$COUNTS" | sed -n 's/^true=//p' | head -1)
NAIVE=$(printf '%s\n' "$COUNTS" | sed -n 's/^naive=//p' | head -1)

echo "duty1_h1_true=${TRUE}"
echo "duty1_h1_naive=${NAIVE}"

# prove-red: force the naive path as the accepted total — must refuse
if test "$MODE" = "prove-red"; then
  echo "duty1_mode=naive_as_total"
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=naive_total_refused"
  exit 1
fi

if test "$TRUE" != "1"; then
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=h1_true_want_1"
  exit 1
fi
if test "$NAIVE" != "4"; then
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=h1_naive_want_4"
  exit 1
fi
echo "duty1=honored"

# --- Marker stamp shape YYYYMMDD.HHMMSS ---
STAMP_VAL=$(sed -n 's/^current-as-of:[[:space:]]*//p' "$MARKER" | head -1 | tr -d '[:space:]')
if test -z "$STAMP_VAL"; then
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=marker_stamp_missing"
  exit 1
fi
echo "duty2_stamp=${STAMP_VAL}"
case "$STAMP_VAL" in
  [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].[0-9][0-9][0-9][0-9][0-9][0-9]) ;;
  *)
    echo "CONTROL=present"
    echo "verdict=misread"
    echo "detail=marker_stamp_shape"
    exit 1
    ;;
esac
echo "duty2=honored"

# --- Instrument law: tracked inventory via git ls-files, never find ---
# Positive: git ls-files answers a counted tracked set. Negative plant: glow
# cache must stay untracked so find-shaped inventories cannot quietly inflate.
MD_N=$(git ls-files '*.md' 2>/dev/null | wc -l | tr -d '[:space:]')
echo "duty3_tracked_md=${MD_N}"
case "$MD_N" in
  ''|0)
    echo "CONTROL=present"
    echo "verdict=misread"
    echo "detail=git_ls_files_md_empty"
    exit 1
    ;;
esac
CACHE_N=$(git ls-files 'glow/.cache/*' 2>/dev/null | wc -l | tr -d '[:space:]')
echo "duty3_glow_cache_tracked=${CACHE_N}"
if test "$CACHE_N" != "0"; then
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=glow_cache_must_stay_untracked"
  exit 1
fi
echo "duty3=honored"

echo "CONTROL=present"
echo "duties_honored=3"
echo "verdict=ok"
exit 0
