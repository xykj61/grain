#!/bin/sh
# tools/fixtures/a/alias_sameness_scan.sh -- several lawful names keep one identity.
set -eu

LEXICON=${ALIAS_SAMENESS_LEXICON:-context/LEXICON.md}
CLAUDE_RULE=${ALIAS_SAMENESS_CLAUDE_RULE:-.claude/rules/alias-sameness.md}
CURSOR_RULE=${ALIAS_SAMENESS_CURSOR_RULE:-.cursor/rules/alias-sameness.mdc}
SWIFT_CORE=${ALIAS_SAMENESS_SWIFT_CORE:-skate/Sources/SkateCore/FrameGrid.swift}
PACKAGE=${ALIAS_SAMENESS_PACKAGE:-skate/Package.swift}
LIVING_FILES=${ALIAS_SAMENESS_LIVING_FILES:-"context/LEXICON.md tools/l/launch-mind-cardinal-chapter.rish active-designing/20260829-203718_the-six-bodies-and-the-always-fleet.md skate/README.md"}

checks=0
faults=0

require_fixed() {
  checks=$((checks + 1))
  if ! grep -Fq "$1" "$2"; then
    echo "fault: $2 lacks: $1"
    faults=$((faults + 1))
  fi
}

require_count() {
  checks=$((checks + 1))
  got=$(grep -Ec "$1" "$3" || true)
  if [ "$got" -ne "$2" ]; then
    echo "fault: $3 has $got matches for /$1/; want $2"
    faults=$((faults + 1))
  fi
}

require_fixed "Surf / Skate" "$LEXICON"
require_fixed "Peer synonyms for one referent" "$LEXICON"
require_fixed "neither replaces, deprecates, redirects to, or outranks the other" "$LEXICON"
require_fixed "one implementation, state, behavior, serialization identity, and refusal path" "$CLAUDE_RULE"
require_fixed "one implementation, state, behavior, serialization identity, and refusal path" "$CURSOR_RULE"
require_fixed "public typealias SurfFrameGrid = FrameGrid" "$SWIFT_CORE"
require_fixed "public typealias SkateFrameGrid = FrameGrid" "$SWIFT_CORE"
require_fixed 'name: "SkateCore"' "$PACKAGE"

require_count '^public struct FrameGrid' 1 "$SWIFT_CORE"
require_count '^public struct (SurfFrameGrid|SkateFrameGrid)' 0 "$SWIFT_CORE"
require_count '^public enum FrameGridError' 1 "$SWIFT_CORE"
require_count '^public enum (SurfFrameGridError|SkateFrameGridError)' 0 "$SWIFT_CORE"

checks=$((checks + 1))
for living in $LIVING_FILES; do
  if grep -Eiq 'elder code name Skate|Named Skate until|Surf (replaces|replaced) Skate|Skate is deprecated|Skate redirects to Surf|Surf outranks Skate' "$living"; then
    echo "fault: asymmetric living claim in $living"
    faults=$((faults + 1))
  fi
done

echo "alias_checks=$checks"
echo "alias_faults=$faults"
if [ "$faults" -eq 0 ]; then
  echo "alias_verdict=ok"
else
  echo "alias_verdict=refused"
  exit 1
fi
