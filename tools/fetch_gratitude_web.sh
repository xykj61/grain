#!/usr/bin/env bash
# Fetch public web documentation into gratitude/ study copies.
# Usage: tools/fetch_gratitude_web.sh reaper
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCS="$ROOT/gratitude/reaper/docs"
STAMP="$(date +%Y-%m-%d)"

fetch() {
  local url="$1"
  local out="$2"
  local title="$3"
  local body
  body="$(curl -fsSL "$url" | python3 - "$title" "$url" "$STAMP" <<'PY'
import sys, re, html
from html.parser import HTMLParser

class TextExtractor(HTMLParser):
    def __init__(self):
        super().__init__()
        self.parts = []
        self.skip = False
    def handle_starttag(self, tag, attrs):
        if tag in ("script", "style"):
            self.skip = True
        if tag in ("h1", "h2", "h3", "h4", "p", "li", "tr", "br"):
            self.parts.append("\n")
    def handle_endtag(self, tag):
        if tag in ("script", "style"):
            self.skip = False
        if tag in ("h1", "h2", "h3", "h4", "p", "li", "tr"):
            self.parts.append("\n")
    def handle_data(self, data):
        if not self.skip:
            t = data.strip()
            if t:
                self.parts.append(t + " ")

title, url, stamp = sys.argv[1:4]
raw = sys.stdin.read()
p = TextExtractor()
p.feed(raw)
text = re.sub(r"\n{3,}", "\n\n", html.unescape("".join(p.parts)))
text = re.sub(r"[ \t]+\n", "\n", text)
text = re.sub(r" +", " ", text).strip()
print(f"# {title}\n\n**Source:** <{url}>  \n**Fetched:** {stamp}  \n**License:** REAPER is proprietary (Cockos). Public web copy for study only.\n\n---\n\n{text}\n")
PY
)"
  mkdir -p "$(dirname "$out")"
  printf '%s\n' "$body" > "$out"
  echo "wrote $out"
}

case "${1:-}" in
  reaper)
    fetch "https://www.reaper.fm/userguide.php" "$DOCS/user-guide-index.md" "REAPER User Guide — index page"
    fetch "https://www.reaper.fm/about.php" "$DOCS/about-features.md" "REAPER — features and technical summary"
    fetch "https://www.reaper.fm/sdk/reascript/reascript.php" "$DOCS/reascript.md" "ReaScript — scripting and extension API"
    ;;
  karpathy-llm-wiki)
    OUT="$ROOT/gratitude/karpathy/llm-wiki.md"
    mkdir -p "$(dirname "$OUT")"
    body="$(curl -fsSL "https://gist.githubusercontent.com/karpathy/442a6bf555914893e9891c11519de94f/raw")"
    {
      printf '%s\n\n' "# LLM Wiki (study copy)"
      printf '**Source:** <%s>  \n' "https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f"
      printf '**Fetched:** %s  \n' "$STAMP"
      printf '%s\n\n' "**License:** Public gist by Andrej Karpathy; study copy for gratitude only — do not treat as our voice."
      printf '%s\n\n' "---"
      printf '%s\n' "$body"
    } >"$OUT"
    echo "wrote $OUT"
    ;;
  *)
    echo "usage: $0 reaper|karpathy-llm-wiki" >&2
    exit 1
    ;;
esac
