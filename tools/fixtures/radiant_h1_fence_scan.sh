#!/bin/sh
# Radiant H1 fence scan — M4 home land.
# Fence-aware ^#-space count. Control true=1 · naive=4 before any total.
# No backtick characters in patterns.
#
#   sh tools/fixtures/radiant_h1_fence_scan.sh
#   sh tools/fixtures/radiant_h1_fence_scan.sh prove-red
#
# Law: radiant_lint defers H1; this instrument carries the fence-aware duty.
# Shell and Zig comments inside fences must not count as governing H1s.
set -eu

H1_FIXTURE=tools/fixtures/census_control_h1_fenced.md
MODE=${1:-}

if ! test -f "$H1_FIXTURE"; then
  echo "CONTROL=ABSENT"
  echo "verdict=absent"
  exit 1
fi

CONTROL=$(python3 - "$H1_FIXTURE" <<'PY'
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
print(f"control_h1_true={true}")
print(f"control_h1_naive={naive}")
PY
)
echo "$CONTROL"
TRUE=$(printf '%s\n' "$CONTROL" | sed -n 's/^control_h1_true=//p' | head -1)
NAIVE=$(printf '%s\n' "$CONTROL" | sed -n 's/^control_h1_naive=//p' | head -1)

if test "$MODE" = "prove-red"; then
  echo "control_mode=naive_as_total"
  echo "verdict=misread"
  echo "detail=naive_total_refused"
  exit 1
fi

if test "$TRUE" != "1" || test "$NAIVE" != "4"; then
  echo "control_gate=failed"
  echo "verdict=misread"
  echo "detail=want_control_true_1_naive_4"
  exit 1
fi
echo "control_gate=honored"

# Radiant-adjacent roster + the template counsel named as governing offender.
ROSTER=$(python3 <<'PY'
import re
from pathlib import Path

roster = [
    "context/fixtures/radiant_lint_planted_but.md",
    "STEWARDS.md", "ORGANIZING.md", "README.md", "CONTRIBUTING.md",
    "context/THREATS.md", "context/OPEN_QUESTIONS.md", "context/REMOTE_ROSTER.md",
    "context/LEXICON.md", "context/TWO_ROOMS.md", "context/QUIN.md", "context/CIVIC_STYLE.md",
    "context/TAME_GUIDANCE.md", "context/SILO_TECHNIQUE.md", "context/SIMPLE_LOVABLE_COMPLETE.md",
    "construction/ITINERARY.md", "construction/TASKS.md", "construction/ROADMAP.md",
    "foundations/README.md", "counsel/README.md", "session-logs/README.md", "waymarks/README.md",
    "docs/README.md", "docs/COMPASS.md",
    "foundations/20260724-220625_five-pillars-direction.md",
    "foundations/20260724-200912_nothing-to-give-custody-first-principle.md",
    "counsel/date/20260724/20260724-141612_names-maps-and-open-questions.md",
    "counsel/date/20260724/20260724-135312_vanes-shelves-and-the-glow-ladder.md",
    "counsel/date/20260724/20260724-132812_the-workshop-and-the-warehouse.md",
    "waymarks/date/20260724/20260724-220625_threats-pillars-mand-home.md",
    "classical-vedic-astrology/templates/reading-template.md",
]
naive_total = 0
true_total = 0
multi = []
fenced_delta_files = 0
present = 0
for f in roster:
    p = Path(f)
    if not p.is_file():
        continue
    present += 1
    lines = p.read_text(errors="replace").splitlines()
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
    naive_total += naive
    true_total += true
    if naive != true:
        fenced_delta_files += 1
    if true > 1:
        multi.append(f"{f}:{true}")

print(f"roster_n={present}")
print(f"h1_naive={naive_total}")
print(f"h1_fence_aware={true_total}")
print(f"h1_fenced_delta={naive_total - true_total}")
print(f"h1_fenced_delta_files={fenced_delta_files}")
print(f"governing_offenders={len(multi)}")
if multi:
    print("governing_offender_paths=" + ",".join(multi))
else:
    print("governing_offender_paths=none")
template = "classical-vedic-astrology/templates/reading-template.md"
print("governing_template=" + ("yes" if any(template in m for m in multi) else "no"))
PY
)
echo "$ROSTER"

echo "$ROSTER" | rg -q '^h1_fenced_delta=[1-9]' || {
  echo "h1_fence=failed"
  echo "verdict=misread"
  echo "detail=want_naive_greater_than_fence_aware"
  exit 1
}
echo "$ROSTER" | rg -q '^governing_offenders=[1-9]' || {
  echo "h1_fence=failed"
  echo "verdict=misread"
  echo "detail=want_at_least_one_governing_offender"
  exit 1
}
echo "$ROSTER" | rg -q '^governing_template=yes$' || {
  echo "h1_fence=failed"
  echo "verdict=misread"
  echo "detail=want_reading_template_named"
  exit 1
}
echo "h1_fence=honored"
echo "h1_note=radiant_lint_duty3_carried_here"
echo "shred=RED"
echo "radiant_h1_fence=ok"
echo "verdict=ok"
