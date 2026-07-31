#!/bin/sh
# Census control — H1 fence-count seam (POSIX). Counts only; orchestration validates.
# No backtick characters in patterns.
#
#   sh tools/fixtures/census_control_h1_seam.sh
set -eu

H1_FIXTURE=tools/fixtures/census_control_h1_fenced.md

if ! test -f "$H1_FIXTURE"; then
  echo "CONTROL=ABSENT"
  echo "duty=h1_fixture"
  echo "verdict=absent"
  exit 1
fi

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
exit 0
