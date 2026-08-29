#!/bin/sh
# tools/equinox/almanac/almanac_engine.sh -- the one body of the almanac seat stubs.
#
# Each equinox_*_almanac.sh stub feeds this engine its per-seat data on stdin
# and keeps its own name, so every caller that names the stub keeps working.
# The engine holds, exactly once, what all 114 stubs held 114 times: the
# present-seat guard, the one-clock stamp, the census hook, and the python
# insert before the sealed closing marker.
#
# Data lines (order free; chapter/entry lines keep their order):
#   seat N          required -- the seat number the guard and re-guard check
#   print TEXT      required -- stdout on the append path
#   bump OLD|NEW    0..3     -- t.replace(OLD, NEW, 1); silent no-op when absent
#   census CMD      0..1     -- runs only past the guard; {CENSUS} in the entry
#   rows CMD        0..1     -- runs only past the guard; {ROWS} in the entry
#   chapter TEXT    chapter-open markdown line; 'chapter.' alone is a blank line
#   entry TEXT      entry markdown line; 'entry.' alone is a blank line
# Placeholders {STAMP} {CENSUS} {ROWS} are literal-replaced, so brace text in
# an entry (the kendras' {1,4,7,10}) passes through untouched.
#
# KIN, the way home: the book is rye-learning-process/GLOW_ALMANAC.md (its charter
# amended 20260829 to the bound it actually keeps); the callers are the witness
# choir in tools/equinox/witness/ plus tools/e/ and tools/gen/chapter/, one stub
# each by name; the family rename this room still awaits is REDS %330, and this
# engine's own name stays ring-neutral so that draw can move the room whole.
# Runs from the repo root, as every elder did -- the witnesses' own cwd.
set -eu

ALMANAC=rye-learning-process/GLOW_ALMANAC.md

DATA=$(cat)
SEAT=$(printf '%s\n' "$DATA" | sed -n 's/^seat //p' | sed -n '1p')
if [ -z "$SEAT" ]; then
  echo "almanac engine: data names no seat" >&2
  exit 1
fi

# The steady state: the seat already sits in the almanac, so say so and stop.
if grep -q "^### ${SEAT}\\." "$ALMANAC"; then
  echo "almanac seat ${SEAT} already present"
  exit 0
fi

STAMP=$(TZ=America/New_York date '+%Y%m%d.%H%M%S')
export STAMP

# Census commands run only past the guard, exactly as the elder scripts did.
CENSUS_CMD=$(printf '%s\n' "$DATA" | sed -n 's/^census //p' | sed -n '1p')
ROWS_CMD=$(printf '%s\n' "$DATA" | sed -n 's/^rows //p' | sed -n '1p')
CENSUS=""
ROWS=""
if [ -n "$CENSUS_CMD" ]; then
  CENSUS=$(sh -c "$CENSUS_CMD")
fi
if [ -n "$ROWS_CMD" ]; then
  ROWS=$(sh -c "$ROWS_CMD")
  ROWS=${ROWS:-unknown}
fi
export CENSUS ROWS
ALMANAC_DATA=$DATA
export ALMANAC_DATA

python3 - <<'PY'
from pathlib import Path
import os

data = os.environ["ALMANAC_DATA"].split("\n")
seat = ""
final = ""
bumps = []
chapter_lines = []
entry_lines = []
for line in data:
    if line.startswith("seat "):
        seat = line[5:]
    elif line.startswith("print "):
        final = line[6:]
    elif line.startswith("bump "):
        old, _, new = line[5:].partition("|")
        bumps.append((old, new))
    elif line == "chapter.":
        chapter_lines.append("")
    elif line.startswith("chapter "):
        chapter_lines.append(line[8:])
    elif line == "entry.":
        entry_lines.append("")
    elif line.startswith("entry "):
        entry_lines.append(line[6:])

p = Path("rye-learning-process/GLOW_ALMANAC.md")
t = p.read_text()
stamp = os.environ["STAMP"]
census = os.environ.get("CENSUS", "").replace("\n", " · ")
rows = os.environ.get("ROWS", "")

if "### " + seat + "." in t:
    raise SystemExit(0)

for old, new in bumps:
    t = t.replace(old, new, 1)


def fill(text):
    return (
        text.replace("{STAMP}", stamp)
        .replace("{CENSUS}", census)
        .replace("{ROWS}", rows)
    )


entry = fill("\n".join(entry_lines)) + "\n\n"
block = entry
if chapter_lines:
    block = fill("\n".join(chapter_lines)) + "\n\n" + entry

marker = "---\n\n*May every line"
if marker not in t:
    raise SystemExit("almanac marker missing")
t = t.replace(marker, block + marker, 1)
p.write_text(t)
print(fill(final))
PY
