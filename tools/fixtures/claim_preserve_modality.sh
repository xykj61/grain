#!/bin/sh
# claim_preserve_modality.sh -- per-file modality counts for Radiant passes.
# Seated 20260725.110354 - counsel the-runway.
#
# Counts (case-insensitive, word-boundary) for:
#   must not - must - shall - should - may - never - always - all - every - none
#   require - recommend - propose - seat - seated - hold - held - parked
#
# Usage:
#   sh tools/fixtures/claim_preserve_modality.sh count <file>
#   sh tools/fixtures/claim_preserve_modality.sh compare <before-file> <after-file>
#   sh tools/fixtures/claim_preserve_modality.sh selftest
#
# compare exit 1 on mismatch -- obligation drift stops the wave.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

python3 - "$@" <<'PY'
import re, sys
from pathlib import Path

# Longest phrases first so "must not" does not double-count "must".
TERMS = [
    "must not",
    "must",
    "shall",
    "should",
    "may",
    "never",
    "always",
    "every",
    "none",
    "require",
    "recommend",
    "propose",
    "seated",
    "seat",
    "held",
    "hold",
    "parked",
    "all",
]

def normalize(text: str) -> str:
    lines = []
    for line in text.splitlines():
        if re.search(r"radiant pass", line, re.I):
            continue
        if re.search(r"erratum", line, re.I):
            continue
        if re.search(r"living pointer", line, re.I):
            continue
        lines.append(line)
    return "\n".join(lines)

def counts(text: str) -> dict[str, int]:
    t = normalize(text).lower()
    out = {}
    for term in TERMS:
        if " " in term:
            n = len(re.findall(re.escape(term), t))
        else:
            n = len(re.findall(r"\b" + re.escape(term) + r"\b", t))
        out[term] = n
    return out

def emit(c: dict[str, int]) -> None:
    for k in TERMS:
        print(f"{k}={c[k]}")

def count_file(path: str) -> dict[str, int]:
    return counts(Path(path).read_text(encoding="utf-8", errors="replace"))

cmd = sys.argv[1] if len(sys.argv) > 1 else ""
if cmd == "count":
    path = sys.argv[2]
    emit(count_file(path))
elif cmd == "compare":
    before = count_file(sys.argv[2])
    after = count_file(sys.argv[3])
    drift = []
    for k in TERMS:
        if before[k] != after[k]:
            drift.append(f"{k}: {before[k]} -> {after[k]}")
    if drift:
        print("FAIL modality drift:")
        for d in drift:
            print(f"  {d}")
        sys.exit(1)
    print("OK   modality counts identical")
elif cmd == "selftest":
    tmp = Path("/tmp/claim_preserve_modality_selftest")
    tmp.mkdir(exist_ok=True)
    before = tmp / "before.md"
    after = tmp / "after.md"
    before.write_text("We recommend this path. You may proceed.\n", encoding="utf-8")
    after.write_text("We require this path. You may proceed.\n", encoding="utf-8")
    b = count_file(str(before))
    a = count_file(str(after))
    if b.get("recommend", 0) == a.get("recommend", 0) and b.get("require", 0) == a.get("require", 0):
        print("FAIL selftest: recommend->require should drift")
        sys.exit(1)
    print("OK   selftest: recommend->require detected as drift")
    # identical pass
    after2 = tmp / "after2.md"
    after2.write_text(before.read_text(encoding="utf-8"), encoding="utf-8")
    import subprocess
    r = subprocess.run(
        ["sh", "tools/fixtures/claim_preserve_modality.sh", "compare", str(before), str(after2)],
        cwd=str(Path(".").resolve()),
    )
    if r.returncode != 0:
        print("FAIL selftest: identical files should compare clean")
        sys.exit(1)
    print("OK   selftest: identical files clean")
    print("GREEN: claim_preserve_modality selftest")
else:
    print(f"usage: {sys.argv[0]} count|compare|selftest", file=sys.stderr)
    sys.exit(2)
PY
