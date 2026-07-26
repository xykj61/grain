#!/bin/sh
# link_witness_scan.sh — walk relative markdown links; assert targets resolve.
#
# Modes (env):
#   LINK_WITNESS_FILES          — newline paths; fixture / scoped walk
#   LINK_WITNESS_ALLOW_BASELINE — tree walk only; print count, exit 0 with debt
#   LINK_WITNESS_SNAPSHOT=path  — ROUND MODE capture: write sorted dangling set, exit 0
#   LINK_WITNESS_COMPARE=path   — ROUND MODE assert: AFTER ⊆ BEFORE; ALLOW_BASELINE ignored
#
# Counsel 20260726.020825 · T0 · ROUND MODE 20260726.025120
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

python3 - <<'PY'
import os, re, sys
from pathlib import Path

root = Path(".").resolve()
files_env = os.environ.get("LINK_WITNESS_FILES", "").strip()
snapshot = os.environ.get("LINK_WITNESS_SNAPSHOT", "").strip()
compare = os.environ.get("LINK_WITNESS_COMPARE", "").strip()

if snapshot and compare:
    print("FAIL link_witness: set SNAPSHOT or COMPARE, not both")
    sys.exit(1)

# Baseline allow only on plain tree walks — never fixtures, never compare, never snapshot.
allow = (
    os.environ.get("LINK_WITNESS_ALLOW_BASELINE", "") == "1"
    and (not files_env)
    and (not snapshot)
    and (not compare)
)

if files_env:
    paths = [Path(p) for p in files_env.splitlines() if p.strip()]
else:
    paths = sorted(root.rglob("*.md"))
    skip_parts = {".git", "vendor", "gratitude", "old", "vere", "node_modules", ".cursor-state"}
    skip_files = {"link_witness_broken.md"}
    paths = [
        p
        for p in paths
        if not any(part in skip_parts for part in p.parts)
        and p.name not in skip_files
    ]

link_re = re.compile(r"\[[^\]]*\]\(([^)]+)\)")
dangling = []
checked = 0

for path in paths:
    if not path.is_file():
        continue
    try:
        text = path.read_text(encoding="utf-8")
    except Exception as e:
        print(f"FAIL read {path}: {e}")
        sys.exit(1)
    for m in link_re.finditer(text):
        target = m.group(1).strip()
        if not target or target.startswith("#"):
            continue
        target = target.split()[0].strip('"').strip("'")
        if target.startswith(("http://", "https://", "mailto:", "data:")):
            continue
        href, _, _frag = target.partition("#")
        if not href:
            continue
        checked += 1
        dest = (path.parent / href).resolve()
        try:
            dest.relative_to(root)
        except ValueError:
            continue
        if not dest.exists():
            # Stable key for set compare: relative path + href as written
            key = f"{path.as_posix()}:{href}"
            dangling.append(key)

after = sorted(set(dangling))
print(
    f"link_witness: files={len(paths)} relative_links_checked={checked} dangling={len(after)}"
)

if snapshot:
    out = Path(snapshot)
    out.write_text("\n".join(after) + ("\n" if after else ""), encoding="utf-8")
    print(f"SNAPSHOT link_witness wrote {len(after)} keys -> {out}")
    sys.exit(0)

if compare:
    before_path = Path(compare)
    if not before_path.is_file():
        print(f"FAIL link_witness COMPARE: missing snapshot {before_path}")
        sys.exit(1)
    before_text = before_path.read_text(encoding="utf-8")
    before = sorted({ln for ln in before_text.splitlines() if ln.strip()})
    before_set = set(before)
    after_set = set(after)
    added = sorted(after_set - before_set)
    removed = sorted(before_set - after_set)
    print(f"COMPARE link_witness before={len(before_set)} after={len(after_set)} added={len(added)} removed={len(removed)}")
    if added:
        print("FAIL link_witness ROUND MODE — new dangling (AFTER not ⊆ BEFORE):")
        for a in added[:100]:
            print(f"NEW dangling: {a}")
        if len(added) > 100:
            print(f"... and {len(added) - 100} more NEW")
        # ALLOW_BASELINE is ignored here by construction (allow stays false).
        sys.exit(1)
    print("OK   link_witness ROUND MODE — AFTER ⊆ BEFORE (zero new dangling)")
    sys.exit(0)

for d in after[:50]:
    print(f"FAIL dangling: {d}")
if len(after) > 50:
    print(f"... and {len(after) - 50} more")

if after and not allow:
    print(f"FAIL link_witness count={len(after)}")
    sys.exit(1)
if after and allow:
    print(f"BASELINE link_witness dangling={len(after)} — honest start; not a stop")
    sys.exit(0)
print("OK   link_witness clean — every relative target resolves")
sys.exit(0)
PY
