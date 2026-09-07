#!/usr/bin/env sh
# tools/fixtures/l/retired_word_scan.sh -- read a roster on stdin, name every retired word in it.
#
# This is duty 1 of the living-docs lint. It stands on its own file so a control can feed it a
# planted tree and watch it work. The grain asks that every guard be proven able to red. An
# advisory nobody has seen name a violation still owes that proof.
#
# THE WORDS, each beside the law that seats it:
#
#   footgun, dead-peer, sanity check       context/specs/20260707-053212_radiant-vocabulary-pass.md
#   empty plate, ungated diet, thin ring   context/specs/20260704-030300_itinerary-retires-diet.md
#   product/suite/git tip, six spellings   .claude/rules/vocabulary-nib.md (20260713)
#   dogfood, three forms                   .claude/rules/vocabulary-first-resident.md (20260828)
#
# CORPUS LEFT THIS LIST. Its departure is the sharper half of the reading. A dedicated guard holds
# that word at zero across 391 reader-facing pages, ENFORCED. Its pattern tells a prose use from an
# identifier, a path segment, and a backticked token. See tools/v/vocabulary_collection_witness.rish.
# A word-boundary match makes none of those distinctions. Wired here it named 135 lines, and the
# stronger guard had already ruled every one of them lawful. Two ears on one sound, with the cruder
# ear the loud one.
#
# THREE MORE BANS STAY OUT BY DESIGN. Each carries an exemption a word boundary cannot judge:
#   bug   -- vocabulary-red-over-bug: debug, debugging and debugger are their own words
#   smell -- vocabulary-aroma: ordinary English about a nose keeps its place
#   child -- vocabulary-dependent: std.process.Child keeps Zig's name. A human child in civic
#            prose keeps its own.
#
# THREE EXEMPTIONS, applied in order:
#   1. a fenced code block   -- what a page SHOWS, rather than what it says
#   2. a backticked mention  -- `dogfood` names the token; dogfooding uses it. A law needs room to
#                               name the word it retires. This tree has learned that twice.
#   3. living_docs_lint_keeps.txt -- path plus regex, one lawful line at a time
#
# Which pages hold the vocabulary itself is the caller's question. The roster answers it.
#
#   sh tools/fixtures/l/living_prose_roster.sh | sh tools/fixtures/l/retired_word_scan.sh
set -eu

ROOT=${ROOT:-$(pwd)}
KEEPS=${KEEPS:-"$ROOT/tools/fixtures/l/living_docs_lint_keeps.txt"}

RETIRED='footgun|dead-peer|sanity check|empty plate|ungated diet|thin ring|product tip|suite tip|git tip|product_tip|suite_tip|git_tip|dogfood|dogfooded|dogfooding'

kept_line() {
  rel=$1
  body=$2
  [ -f "$KEEPS" ] || return 1
  while IFS= read -r kline; do
    case "$kline" in ''|\#*) continue ;; esac
    case "$kline" in *"	"*) ;; *) continue ;; esac
    kpath=${kline%%	*}
    kpat=${kline#*	}
    [ "$kpath" = "$rel" ] || continue
    if printf '%s\n' "$body" | grep -Eq "$kpat"; then
      return 0
    fi
  done <"$KEEPS"
  return 1
}

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

hits=0
files=0
while IFS= read -r rel; do
  [ -n "$rel" ] && [ -f "$rel" ] || continue
  files=$((files + 1))
  # Fence state toggles on a ``` line, which is itself skipped -- what a page shows is not
  # what a page says.
  awk '/^[[:space:]]*```/ { fence = !fence; next } !fence { print NR ":" $0 }' "$rel" \
    | grep -Ei "\\b(${RETIRED})\\b" \
    | grep -viE '`[^`]*('"${RETIRED}"')[^`]*`' \
    > "$TMP/hits" 2>/dev/null || :
  while IFS= read -r hit; do
    [ -n "$hit" ] || continue
    line_no=${hit%%:*}
    body=${hit#*:}
    kept_line "$rel" "$body" && continue
    printf 'RETIRED %s:%s: %s\n' "$rel" "$line_no" "$(printf '%s' "$body" | cut -c1-100)"
    hits=$((hits + 1))
  done <"$TMP/hits"
done

echo "retired_word_files=$files"
echo "retired_word_hits=$hits"
