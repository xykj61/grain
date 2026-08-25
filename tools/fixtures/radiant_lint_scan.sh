#!/bin/sh
# radiant_lint_scan.sh -- advisory Radiant surface (body for radiant_lint_scan.rish).
# Missing Rishi verb: accumulate - filter chained - read bounded -- harvest ledger (counsel 20260725.040247)
#
# Duties:
#   1. bare " but " (word-adjacent spaces) outside fences
#   2. emoji (common Unicode emoji blocks)
#   3. multiple H1 -- DEFERRED (TAME check table / tame-check owns one-H1)
#   4. dated artifacts: three-clause May... benediction
#   5. dated memos: co-author line present; living docs must NOT carry one
#   6. living docs: header block (Language or Stamp/Status)
#
# Exempt with reasons: RADIANT_STYLE.md (quotes banned forms), gratitude/,
# old/, vere/, tools/fixtures/.
# Always exits 0 -- ratchet advisory.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

TMP=$(mktemp -d "${TMPDIR:-/tmp}/radiant-lint.XXXXXX")
trap 'rm -rf "$TMP"' EXIT

# Roster: living pins + planted negative + dated counsel/foundations/waymarks sample surface.
# Full tree walk would drown the advisory; grow the roster as waves touch rooms.
ROSTER="$TMP/roster"
: >"$ROSTER"

add() {
  if [ -f "$1" ]; then
    echo "$1" >>"$ROSTER"
  fi
  return 0
}

# Planted negative space -- must be counted.
add "context/fixtures/radiant_lint_planted_but.md"

# Living pins and living docs (Tier 3 prose surfaces)
for f in \
  STEWARDS.md APARIGRAHA.md ORGANIZING.md README.md CONTRIBUTING.md \
  context/THREATS.md context/OPEN_QUESTIONS.md context/REMOTE_ROSTER.md \
  context/LEXICON.md context/TWO_ROOMS.md context/QUIN.md context/CIVIC_STYLE.md \
  context/TAME_GUIDANCE.md context/SILO_TECHNIQUE.md context/SIMPLE_LOVABLE_COMPLETE.md \
  construction/ITINERARY.md construction/TASKS.md construction/ROADMAP.md \
  foundations/README.md counsel/README.md session-logs/README.md waymarks/README.md \
  docs/README.md docs/COMPASS.md
 do
  add "$f"
done

# Dated surfaces on the roster for benediction / co-author duties (not Tier 1)
for f in \
  foundations/20260724-220625_five-pillars-direction.md \
  foundations/20260724-200912_nothing-to-give-custody-first-principle.md \
  counsel/date/20260724/20260724-141612_names-maps-and-open-questions.md \
  counsel/date/20260724/20260724-135312_vanes-shelves-and-the-glow-ladder.md \
  counsel/date/20260724/20260724-132812_the-workshop-and-the-warehouse.md \
  waymarks/date/20260724/20260724-220625_threats-pillars-mand-home.md
 do
  add "$f"
done

exempt_path() {
  case "$1" in
    context/RADIANT_STYLE.md|*/RADIANT_STYLE.md) return 0 ;;
    gratitude/*|old/*|vere/*|tools/fixtures/*) return 0 ;;
    *) return 1 ;;
  esac
}

is_dated() {
  echo "$1" | grep -Eq '(^|/)2026[0-9]{4}-[0-9]{6}[_.][^/]*$'
}

is_living_doc() {
  # plain-named markdown on the living roster, or living ledger header
  if is_dated "$1"; then
    head -20 "$1" | tr '[:upper:]' '[:lower:]' | grep -Fq 'living ledger' && return 0
    return 1
  fi
  case "$1" in
    *.md) return 0 ;;
    *) return 1 ;;
  esac
}

bare_but=0
emoji_n=0
benediction_miss=0
coauthor_dated_miss=0
coauthor_living_hit=0
header_miss=0

: >"$TMP/hits"

while IFS= read -r rel; do
  [ -n "$rel" ] && [ -f "$rel" ] || continue
  exempt_path "$rel" && continue

  # duty 1 -- bare " but " outside fences
  awk '/^```/ { fence = !fence; next } !fence { print NR ":" $0 }' "$rel" \
    | grep -E ' but ' \
    | while IFS= read -r hit; do
        echo "ADVISE bare-but ${rel}:${hit}"
        echo x >>"$TMP/but_count"
      done >>"$TMP/hits" || true

  # duty 2 -- emoji (BMP symbols commonly used as emoji)
  if perl -ne 'BEGIN{$/=undef} print if /[\x{1F300}-\x{1FAFF}\x{2600}-\x{27BF}]/' "$rel" >/dev/null 2>&1; then
    if perl -ne 'BEGIN{$/=undef} exit(/[\x{1F300}-\x{1FAFF}\x{2600}-\x{27BF}]/ ? 0 : 1)' "$rel" 2>/dev/null; then
      echo "ADVISE emoji ${rel}" >>"$TMP/hits"
      echo x >>"$TMP/emoji_count"
    fi
  fi

  if is_dated "$rel"; then
    # duty 4 -- three May clauses in a benediction line/block near the end
    may_n=$(grep -oE '\bMay\b' "$rel" | wc -l | tr -d ' ')
    if [ "$may_n" -lt 3 ]; then
      echo "ADVISE benediction-short ${rel}: May-count=${may_n} (want ≥3 clauses)" >>"$TMP/hits"
      echo x >>"$TMP/ben_count"
    fi
    # duty 5a -- co-author line on dated memos (counsel - foundations)
    case "$rel" in
      counsel/*|foundations/*)
        if ! grep -Eiq 'Written together by|co-author' "$rel"; then
          echo "ADVISE co-author-missing ${rel}" >>"$TMP/hits"
          echo x >>"$TMP/coa_d_count"
        fi
        ;;
    esac
  elif is_living_doc "$rel"; then
    # duty 5b -- living docs must not carry co-author line
    if grep -Eiq 'Written together by|^\*\*Co-author' "$rel"; then
      echo "ADVISE co-author-on-living ${rel}" >>"$TMP/hits"
      echo x >>"$TMP/coa_l_count"
    fi
    # duty 6 -- header block
    if ! head -25 "$rel" | grep -Eqi '^\*\*Language:\*\*|^Language:|^\*\*Stamp:\*\*|^\*\*Status:\*\*|^\*\*Last updated:\*\*'; then
      echo "ADVISE header-missing ${rel}" >>"$TMP/hits"
      echo x >>"$TMP/hdr_count"
    fi
  fi
done <"$ROSTER"

# duty 3 deferred notice
echo "OK   duty3 multiple-H1 — deferred (TAME one-# Title / tame-check owns it)"

[ -f "$TMP/but_count" ] && bare_but=$(wc -l <"$TMP/but_count" | tr -d ' ') || bare_but=0
[ -f "$TMP/emoji_count" ] && emoji_n=$(wc -l <"$TMP/emoji_count" | tr -d ' ') || emoji_n=0
[ -f "$TMP/ben_count" ] && benediction_miss=$(wc -l <"$TMP/ben_count" | tr -d ' ') || benediction_miss=0
[ -f "$TMP/coa_d_count" ] && coauthor_dated_miss=$(wc -l <"$TMP/coa_d_count" | tr -d ' ') || coauthor_dated_miss=0
[ -f "$TMP/coa_l_count" ] && coauthor_living_hit=$(wc -l <"$TMP/coa_l_count" | tr -d ' ') || coauthor_living_hit=0
[ -f "$TMP/hdr_count" ] && header_miss=$(wc -l <"$TMP/hdr_count" | tr -d ' ') || header_miss=0

if [ -s "$TMP/hits" ]; then
  cat "$TMP/hits"
fi

total=$((bare_but + emoji_n + benediction_miss + coauthor_dated_miss + coauthor_living_hit + header_miss))
echo "ADVISE radiant-lint totals: bare_but=${bare_but} emoji=${emoji_n} benediction_short=${benediction_miss} coauthor_dated_miss=${coauthor_dated_miss} coauthor_on_living=${coauthor_living_hit} header_miss=${header_miss} sum=${total}"

# Negative space: planted bare but must be counted
if ! grep -q 'radiant_lint_planted_but.md' "$TMP/hits" 2>/dev/null; then
  echo "ADVISE radiant-lint planted-but NOT counted — roster or duty1 gap"
else
  echo "OK   planted bare-but counted"
fi

exit 0
