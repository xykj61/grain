#!/usr/bin/env python3
"""Shared dated/live classifier — one definition for every roof.

Canon: context/specs/living-vs-dated.md

A tracked path is Tier-2 dated testimony when:
  1. its path carries a dated leaf stamp YYYYMMDD-HHMMSS_ (anchored segment), and
  2. it does NOT declare a living-ledger header.

Living-ledger header (either form):
  - **Stamp:** living ledger …
  - living ledger (born …

Everything else is live surface.

Law: when two roofs carry one name, either they agree or the name is doing two jobs.
"""

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path

DATED_NAME_RE = re.compile(r"(^|/)\d{8}-\d{6}_")
LIVING_HEADER_RE = re.compile(
    r"(?i)(\*\*Stamp:\*\*\s*living ledger|living ledger\s*\(born)"
)

SKIP_EXT = {
    ".png",
    ".jpg",
    ".jpeg",
    ".gif",
    ".webp",
    ".ico",
    ".pdf",
    ".woff",
    ".woff2",
    ".ttf",
    ".otf",
    ".zip",
    ".gz",
    ".xz",
    ".wasm",
    ".so",
    ".o",
    ".a",
    ".bin",
    ".mp4",
    ".webm",
}


def is_dated_name(path: str) -> bool:
    return bool(DATED_NAME_RE.search(path))


def has_living_header(path: str, text: str | None = None) -> bool:
    if text is None:
        try:
            text = Path(path).read_text(encoding="utf-8", errors="ignore")[:8000]
        except Exception:
            return False
    return bool(LIVING_HEADER_RE.search(text))


def classify(path: str, text: str | None = None) -> str:
    """Return 'dated' or 'live' for a tracked path."""
    if not is_dated_name(path):
        return "live"
    if text is None and Path(path).suffix.lower() in SKIP_EXT:
        return "dated"
    if has_living_header(path, text):
        return "live"
    return "dated"


def tracked_files() -> list[str]:
    return [
        f
        for f in subprocess.check_output(["git", "ls-files", "-z"], text=True).split(
            "\0"
        )
        if f
    ]


def census(files: list[str] | None = None) -> dict[str, int]:
    files = files if files is not None else tracked_files()
    dated = 0
    live = 0
    for f in files:
        if classify(f) == "dated":
            dated += 1
        else:
            live += 1
    total = len(files)
    health = int(round(100.0 * live / total)) if total else 0
    return {
        "tracked_total": total,
        "dated_testimony": dated,
        "live_surface": live,
        "fascia_health": health,
    }


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print("usage: dated_classify.py classify <path> | census", file=sys.stderr)
        return 2
    cmd = argv[1]
    if cmd == "classify":
        if len(argv) < 3:
            print("usage: dated_classify.py classify <path>", file=sys.stderr)
            return 2
        print(classify(argv[2]))
        return 0
    if cmd == "census":
        c = census()
        for k, v in c.items():
            print(f"{k}={v}")
        print("definition=living-vs-dated")
        print("dated_name=(^|/)YYYYMMDD-HHMMSS_")
        print("living_header=Stamp living ledger | living ledger (born")
        print("verdict=ok")
        return 0
    print(f"unknown command: {cmd}", file=sys.stderr)
    return 2


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
