#!/bin/sh
# link_witness_scan.sh -- walk relative markdown links; assert targets resolve.
#
# Modes (env):
#   LINK_WITNESS_FILES          -- newline paths; fixture / scoped walk
#   LINK_WITNESS_ALLOW_BASELINE -- tree walk only; print count, exit 0 with debt
#   LINK_WITNESS_SNAPSHOT=path  -- ROUND MODE capture: write sorted dangling set, exit 0
#   LINK_WITNESS_COMPARE=path   -- ROUND MODE assert: no new missing targets
#
# ROUND MODE binding (counsel 20260726.025120 - refined 20260726.034200):
#   Compare missing *targets* (resolved paths that do not exist), not source:href
#   keys. Relocating a file that already pointed at a missing path must not RED
#   the gate; introducing a newly missing destination must.
#   ALLOW_BASELINE is IGNORED in compare mode.
#
# Counsel 20260726.020825 - T0 - ROUND MODE 20260726.025120
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
# pairs: (key source:href, missing target as root-relative posix)
pairs = []
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
            key = f"{path.as_posix()}:{href}"
            try:
                trel = dest.relative_to(root).as_posix()
            except ValueError:
                trel = dest.as_posix()
            pairs.append((key, trel))

keys = sorted({k for k, _ in pairs})
targets = sorted({t for _, t in pairs})
print(
    f"link_witness: files={len(paths)} relative_links_checked={checked} dangling={len(keys)} missing_targets={len(targets)}"
)

def load_snapshot(text: str):
    """Return (keys, targets). Supports v2 (key\\ttarget) and v1 (key only)."""
    lines = [ln for ln in text.splitlines() if ln.strip() and not ln.startswith("#")]
    if not lines:
        return set(), set()
    if any("\t" in ln for ln in lines):
        ks, ts = set(), set()
        for ln in lines:
            if "\t" in ln:
                k, t = ln.split("\t", 1)
                ks.add(k)
                ts.add(t)
            else:
                ks.add(ln)
        return ks, ts
    # v1 key-only — derive targets by re-resolving keys is unavailable offline;
    # fall back to key-subset compare by returning keys as both sets' stand-in
    # via empty targets and keys for legacy.
    return set(lines), None

if snapshot:
    out = Path(snapshot)
    body = ["# link_witness_snapshot_v2"]
    # unique by key, stable
    seen = set()
    rows = []
    for k, t in sorted(pairs):
        if k in seen:
            continue
        seen.add(k)
        rows.append(f"{k}\t{t}")
    out.write_text("\n".join(body + rows) + ("\n" if rows else "\n"), encoding="utf-8")
    print(f"SNAPSHOT link_witness wrote {len(rows)} keys / {len(targets)} targets -> {out}")
    sys.exit(0)

if compare:
    before_path = Path(compare)
    if not before_path.is_file():
        print(f"FAIL link_witness COMPARE: missing snapshot {before_path}")
        sys.exit(1)
    before_keys, before_targets = load_snapshot(before_path.read_text(encoding="utf-8"))
    after_keys = set(keys)
    after_targets = set(targets)
    if before_targets is None:
        # legacy v1: key ⊆ only
        added = sorted(after_keys - before_keys)
        removed = sorted(before_keys - after_keys)
        print(
            f"COMPARE link_witness (v1 keys) before={len(before_keys)} after={len(after_keys)} added={len(added)} removed={len(removed)}"
        )
        if added:
            print("FAIL link_witness ROUND MODE — new dangling keys (AFTER not ⊆ BEFORE):")
            for a in added[:100]:
                print(f"NEW dangling: {a}")
            if len(added) > 100:
                print(f"... and {len(added) - 100} more NEW")
            sys.exit(1)
        print("OK   link_witness ROUND MODE — AFTER ⊆ BEFORE (zero new dangling keys)")
        sys.exit(0)

    added_t = sorted(after_targets - before_targets)
    removed_t = sorted(before_targets - after_targets)
    added_k = sorted(after_keys - before_keys)
    removed_k = sorted(before_keys - after_keys)
    print(
        f"COMPARE link_witness targets before={len(before_targets)} after={len(after_targets)} added={len(added_t)} removed={len(removed_t)}"
    )
    print(
        f"COMPARE link_witness keys    before={len(before_keys)} after={len(after_keys)} added={len(added_k)} removed={len(removed_k)} (informational)"
    )
    if added_t:
        print("FAIL link_witness ROUND MODE — new missing targets (AFTER not ⊆ BEFORE):")
        for a in added_t[:100]:
            print(f"NEW missing_target: {a}")
        if len(added_t) > 100:
            print(f"... and {len(added_t) - 100} more NEW targets")
        # show example keys for first few
        for t in added_t[:10]:
            ex = [k for k, tt in pairs if tt == t][:2]
            for k in ex:
                print(f"  via {k}")
        sys.exit(1)
    if added_k:
        print(
            f"ADVISE link_witness ROUND MODE — {len(added_k)} relocated dangling keys; zero new missing targets"
        )
    print("OK   link_witness ROUND MODE — no new missing targets (AFTER targets ⊆ BEFORE)")
    sys.exit(0)

for d in keys[:50]:
    print(f"FAIL dangling: {d}")
if len(keys) > 50:
    print(f"... and {len(keys) - 50} more")

if keys and not allow:
    print(f"FAIL link_witness count={len(keys)}")
    sys.exit(1)
if keys and allow:
    print(f"BASELINE link_witness dangling={len(keys)} — honest start; not a stop")
    sys.exit(0)
print("OK   link_witness clean — every relative target resolves")
sys.exit(0)
PY
