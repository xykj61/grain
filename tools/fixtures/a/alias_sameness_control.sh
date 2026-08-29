#!/bin/sh
# tools/fixtures/a/alias_sameness_control.sh -- prove the alias-sameness scan both ways.
set -eu

PASS=0
FAIL=0
PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

check() {
  if [ "$2" = "$3" ]; then
    PASS=$((PASS + 1)); echo "$1 -- ok"
  else
    FAIL=$((FAIL + 1)); echo "$1 -- FAIL (wanted $2, got $3)"
  fi
}

write_healthy() {
  printf '%s\n' '| **Surf / Skate** | **Peer synonyms for one referent**; neither replaces, deprecates, redirects to, or outranks the other. |' > "$PEN/lexicon.md"
  printf '%s\n' 'Keep one implementation, state, behavior, serialization identity, and refusal path.' > "$PEN/claude.md"
  printf '%s\n' 'Keep one implementation, state, behavior, serialization identity, and refusal path.' > "$PEN/cursor.mdc"
  printf '%s\n' 'public struct FrameGrid {' '}' 'public enum FrameGridError: Error {' '}' 'public typealias SurfFrameGrid = FrameGrid' 'public typealias SkateFrameGrid = FrameGrid' > "$PEN/core.swift"
  printf '%s\n' 'let package = Package(name: "SkateCore")' > "$PEN/Package.swift"
  printf '%s\n' 'Surf and Skate are peer synonyms for one surface.' > "$PEN/living.md"
}

run_scan() {
  ALIAS_SAMENESS_LEXICON="$PEN/lexicon.md" \
  ALIAS_SAMENESS_CLAUDE_RULE="$PEN/claude.md" \
  ALIAS_SAMENESS_CURSOR_RULE="$PEN/cursor.mdc" \
  ALIAS_SAMENESS_SWIFT_CORE="$PEN/core.swift" \
  ALIAS_SAMENESS_PACKAGE="$PEN/Package.swift" \
  ALIAS_SAMENESS_LIVING_FILES="$PEN/living.md" \
  sh tools/fixtures/a/alias_sameness_scan.sh 2>&1 || true
}

verdict() {
  case "$1" in *alias_verdict=ok*) echo free;; *) echo refused;; esac
}

write_healthy
out=$(run_scan)
check "1 free: both peer names share one direct type and refusal identity" free "$(verdict "$out")"

sed 's/public typealias SkateFrameGrid = FrameGrid/public struct SkateFrameGrid {}/' "$PEN/core.swift" > "$PEN/core.new"
mv "$PEN/core.new" "$PEN/core.swift"
out=$(run_scan)
check "2 bitten: a Skate wrapper cannot become a second implementation" refused "$(verdict "$out")"

write_healthy
sed 's/public typealias SkateFrameGrid = FrameGrid/public typealias SkateFrameGrid = OtherGrid/' "$PEN/core.swift" > "$PEN/core.new"
mv "$PEN/core.new" "$PEN/core.swift"
out=$(run_scan)
check "3 bitten: the peer names cannot point at divergent types" refused "$(verdict "$out")"

write_healthy
printf '%s\n' 'Surf replaces Skate.' > "$PEN/living.md"
out=$(run_scan)
check "4 bitten: replacement wording refuses" refused "$(verdict "$out")"

write_healthy
printf '%s\n' 'Skate is deprecated.' > "$PEN/living.md"
out=$(run_scan)
check "5 bitten: deprecation wording refuses" refused "$(verdict "$out")"

write_healthy
printf '%s\n' 'Skate redirects to Surf.' > "$PEN/living.md"
out=$(run_scan)
check "6 bitten: redirect wording refuses" refused "$(verdict "$out")"

write_healthy
printf '%s\n' 'Surf outranks Skate.' > "$PEN/living.md"
out=$(run_scan)
check "7 bitten: rank wording refuses" refused "$(verdict "$out")"

write_healthy
printf '%s\n' 'public struct FrameGrid {' '}' 'public struct FrameGrid {' '}' 'public enum FrameGridError: Error {' '}' 'public typealias SurfFrameGrid = FrameGrid' 'public typealias SkateFrameGrid = FrameGrid' > "$PEN/core.swift"
out=$(run_scan)
check "8 bitten: duplicate neutral implementations refuse" refused "$(verdict "$out")"

echo "control_cases=$((PASS + FAIL))"
echo "control_fail=$FAIL"
if [ "$FAIL" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=refused"
  exit 1
fi
