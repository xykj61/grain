#!/usr/bin/env python3
"""living_docs_lint_scan.py — ratchet-advisory living-docs lint (five duties).

Always exits 0 — print advisories every parity run; never fail the witness.
Hardening horizon: link-breaks may earn a gate once the shelf proves stable.

Duties:
  1. Retired LEXICON / Radiant words in living-voice lines (word-boundary; keeps.txt exemptions)
  2. Broken relative markdown links
  3. Orphan roster pages (no inbound link from roster + docs/README)
  4. Status room on rostered living pages (head-30)
  5. docs/ pin-strings must byte-match canon sources

Spec: active-designing/20260712-221600_docs-compression-layer-design.md
"""
from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]

# Word-boundary retired forms (living voice — judgment + machine hint).
RETIRED_WORDS = [
    r"\bfootgun\b",
    r"\bdead-peer\b",
    r"\bsanity check\b",
    r"\bempty plate\b",
    r"\bungated diet\b",
    r"\bthin ring\b",
    r"\bproduct tip\b",
    r"\bsuite tip\b",
    r"\bgit tip\b",
    r"\bproduct_tip\b",
    r"\bsuite_tip\b",
    r"\bgit_tip\b",
]
RETIRED_RE = re.compile("|".join(RETIRED_WORDS), re.IGNORECASE)


def load_keeps() -> list[tuple[str, re.Pattern[str]]]:
    keeps_path = ROOT / "tools/fixtures/living_docs_lint_keeps.txt"
    if not keeps_path.is_file():
        return []
    out: list[tuple[str, re.Pattern[str]]] = []
    for raw in keeps_path.read_text(encoding="utf-8", errors="replace").splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if "\t" not in line:
            continue
        path, pat = line.split("\t", 1)
        out.append((path.strip(), re.compile(pat.strip())))
    return out


def kept_line(rel: str, line: str, keeps: list[tuple[str, re.Pattern[str]]]) -> bool:
    for path, pat in keeps:
        if rel == path and pat.search(line):
            return True
    return False


LINK_RE = re.compile(r"\]\(([^)]+)\)")
FENCE_RE = re.compile(r"^```", re.MULTILINE)
HEX40_RE = re.compile(r"\b[0-9a-f]{40}\b")
HEX64_RE = re.compile(r"\b[0-9a-f]{64}\b")
FPR_COMPACT_RE = re.compile(r"\b[0-9A-F]{8}[0-9A-F]{24}\b")

ROOM_RE = re.compile(
    r"checkable|vision|mixed|research for understanding|\bliving\b", re.IGNORECASE
)


def roster_paths() -> list[Path]:
    out = subprocess.run(
        ["sh", "tools/fixtures/living_docs_lint_roster.sh"],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    if out.returncode != 0:
        print(f"ADVISE roster script failed: {out.stderr.strip()}")
        return []
    return [ROOT / p for p in out.stdout.splitlines() if p.strip()]


def strip_fences(text: str) -> str:
    lines = text.splitlines()
    kept: list[str] = []
    in_fence = False
    for line in lines:
        if line.strip().startswith("```"):
            in_fence = not in_fence
            continue
        if not in_fence:
            kept.append(line)
    return "\n".join(kept)


def load_canon_pins() -> str:
    blobs: list[str] = []
    for rel in (
        "context/PUBKEYS.md",
        "tools/pond_exit_bron_master_seal.sh",
        "context/keys/gpg_signing_06462132.pub.asc",
        "active-designing/20260712-210800_pond-supersede-exit-criteria.md",
        "active-designing/20260712-213600_pond-freeze-affirm-master-seal.md",
    ):
        p = ROOT / rel
        if p.is_file():
            blobs.append(p.read_text(encoding="utf-8", errors="replace"))
    return "\n".join(blobs)


def resolve_link(src: Path, target: str) -> Path | None:
    t = target.strip()
    if not t or t.startswith(("http://", "https://", "mailto:", "#")):
        return None
    if t.startswith("/"):
        cand = ROOT / t.lstrip("/")
    else:
        cand = (src.parent / t).resolve()
    try:
        cand.relative_to(ROOT)
    except ValueError:
        return None
    # strip anchor
    if "#" in t and not t.startswith("#"):
        frag = t.split("#", 1)[0]
        if frag:
            cand = (src.parent / frag).resolve()
    return cand


def duty1_retired(paths: list[Path]) -> int:
    keeps = load_keeps()
    n = 0
    for p in paths:
        rel = str(p.relative_to(ROOT))
        text = strip_fences(p.read_text(encoding="utf-8", errors="replace"))
        for i, line in enumerate(text.splitlines(), 1):
            if not RETIRED_RE.search(line):
                continue
            if kept_line(rel, line, keeps):
                continue
            print(f"ADVISE duty1 retired-word {rel}:{i}: {line.strip()[:100]}")
            n += 1
    if n == 0:
        print("OK   duty1 retired LEXICON words — none on roster")
    else:
        print(f"ADVISE duty1 count={n}")
    return n


def duty2_links(paths: list[Path]) -> int:
    n = 0
    for p in paths:
        text = p.read_text(encoding="utf-8", errors="replace")
        for m in LINK_RE.finditer(text):
            target = m.group(1)
            cand = resolve_link(p, target)
            if cand is None:
                continue
            if not cand.exists():
                print(f"ADVISE duty2 broken-link {p.relative_to(ROOT)} -> {target}")
                n += 1
    if n == 0:
        print("OK   duty2 relative links — roster clean")
    else:
        print(f"ADVISE duty2 count={n}")
    return n


def duty3_orphans(paths: list[Path]) -> int:
    inbound: dict[str, int] = {str(p.relative_to(ROOT)): 0 for p in paths}
    index = ROOT / "docs/README.md"
    sources = [p for p in paths if p != index]
    sources.append(index)
    organizing = ROOT / "ORGANIZING.md"
    if organizing.is_file():
        sources.append(organizing)
    for p in sources:
        text = p.read_text(encoding="utf-8", errors="replace")
        for m in LINK_RE.finditer(text):
            cand = resolve_link(p, m.group(1))
            if cand is None:
                continue
            try:
                rel = str(cand.relative_to(ROOT))
            except ValueError:
                continue
            if rel in inbound:
                inbound[rel] += 1
    n = 0
    for rel, count in sorted(inbound.items()):
        if rel == "docs/README.md":
            continue
        if count == 0:
            print(f"ADVISE duty3 orphan {rel} — no inbound link from roster or docs/README")
            n += 1
    if n == 0:
        print("OK   duty3 orphans — none on roster")
    else:
        print(f"ADVISE duty3 count={n}")
    return n


def duty4_status(paths: list[Path]) -> int:
    n = 0
    for p in paths:
        head = "\n".join(p.read_text(encoding="utf-8", errors="replace").splitlines()[:30])
        status_lines = [ln for ln in head.splitlines() if ln.startswith("**Status:**")]
        if not status_lines:
            print(f"ADVISE duty4 status-missing {p.relative_to(ROOT)}")
            n += 1
            continue
        if not any(ROOM_RE.search(ln) for ln in status_lines):
            print(f"ADVISE duty4 status-room {p.relative_to(ROOT)}: {status_lines[0][:80]}")
            n += 1
    if n == 0:
        print("OK   duty4 Status rooms — roster names Checkable or companion registers")
    else:
        print(f"ADVISE duty4 count={n}")
    return n


def duty5_docs_pins(canon: str) -> int:
    docs_dir = ROOT / "docs"
    if not docs_dir.is_dir():
        print("OK   duty5 docs pins — no docs/ shelf")
        return 0
    n = 0
    for p in sorted(docs_dir.glob("*.md")):
        text = p.read_text(encoding="utf-8", errors="replace")
        pins: list[str] = []
        pins.extend(HEX40_RE.findall(text))
        pins.extend(HEX64_RE.findall(text))
        pins.extend(FPR_COMPACT_RE.findall(text))
        for pin in pins:
            if pin not in canon and pin.lower() not in canon.lower():
                print(f"ADVISE duty5 docs-pin {p.relative_to(ROOT)}: {pin} not in canon")
                n += 1
    if n == 0:
        print("OK   duty5 docs pins — none outside canon (or absent)")
    else:
        print(f"ADVISE duty5 count={n}")
    return n


def main() -> int:
    paths = roster_paths()
    if not paths:
        print("ADVISE living-docs lint — empty roster")
        return 0
    print(f"living-docs lint: roster {len(paths)} paths")
    canon = load_canon_pins()
    duty1_retired(paths)
    duty2_links(paths)
    duty3_orphans(paths)
    duty4_status(paths)
    duty5_docs_pins(canon)
    print(
        "ADVISE: living-docs lint complete — ratchet advisory; "
        "link-breaks may earn a gate once the shelf proves stable"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
