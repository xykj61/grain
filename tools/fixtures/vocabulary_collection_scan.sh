#!/bin/sh
# Collection vocabulary guard -- reader-facing prose says what it means (seated 20260821.213540).
#
# `corpus` was doing FOUR jobs at once, and the overloading cost more than the Latin did:
#   the flw draw's 5,526-word source   -> a WORD LIST
#   the hosted .rye files              -> the HOSTED SOURCES
#   a test or control set              -> a CONTROL SET
#   Grain's body of living documents   -> a COLLECTION
#
# So the sweep was per-sense rather than one abstract word swapped for another. 56 replacements
# across 28 reader-facing files; the seed's Markdown had carried 652 occurrences of the old word
# to an audience meeting this tree for the first time.
#
# WHAT KEEPS `corpus`, deliberately and by rule:
#   CODE IDENTIFIERS -- 1,344 bare `corpus` plus `query_corpus`, `corpus_path`, `corpus_digest`
#     and friends. Renaming them is the churn `.claude/rules/comlink-tendency.md` forbids, and no
#     reader of the front door ever meets one.
#   FILE PATHS -- 169 tracked paths, including a `pond/apps/corpora/` room and dated filenames the
#     one-clock law protects. Paths are out of scope for a prose rule.
#   THE RECORD -- dated testimony, `crux/REDS.md` and `crux/CAIRNS.md` (append-only by their own
#     laws), `*/archive/` and `*/yonder/`, and `context/LEXICON.md`, which SEATS the word and must
#     be able to name it. A guard that makes the record of a decision unwritable was already hit
#     twice this day; it is written into the roster here rather than rediscovered a third time.
#
#   sh tools/fixtures/vocabulary_collection_scan.sh
#   sh tools/fixtures/vocabulary_collection_scan.sh prove-red
#
# Read-only: no network, no key, no funds, and no prose is rewritten here.
set -eu

MODE=${1:-}
CONTROL=tools/fixtures/vocabulary_collection_control/corpus_control.md

# A PROSE word, rather than a path segment or an identifier: `corpus` with no letter, underscore,
# slash, hyphen or backtick touching it on either side. `flw-corpus-shelf` and `corpus_path` and
# `pond/apps/corpora` all fail that test, which is the point.
PROSE='(^|[^A-Za-z_/`-])[Cc]orp(us|ora|uses)([^A-Za-z_/`-]|$)'

enforce_roster() {
  ls manual/*.md manual/*/*.md 2>/dev/null || true
  ls context/*.md context/specs/*.md 2>/dev/null | grep -v '^context/LEXICON.md$' || true
  ls foundations/*.md docs/*.md 2>/dev/null || true
  ls docs-geode/*.md docs-geode/*/*.md 2>/dev/null || true
  ls .claude/rules/*.md .cursor/rules/*.mdc 2>/dev/null || true
  ls edu/*.md edu/*/*.md edu/*/*/*.md 2>/dev/null || true
  ls ./*.md 2>/dev/null | sed 's|^\./||' || true
  ls crux/*.md 2>/dev/null | grep -vE '^crux/(REDS|CAIRNS)\.md$' || true
}

count_prose() { grep -cE "$PROSE" "$1" 2>/dev/null || true; }

if test "$MODE" = "prove-red"; then
  test -f "$CONTROL" || { echo "control_verdict=missing"; exit 1; }
  n=$(count_prose "$CONTROL")
  echo "control_prose_hits=$n"
  if test "${n:-0}" -ge 1; then
    echo "RED_corpus_in_reader_prose_caught=$n"
    exit 1
  fi
  echo "control_verdict=MISSED"
  exit 1
fi

files=0; hits=0
for f in $(enforce_roster | sort -u); do
  [ -f "$f" ] || continue
  files=$((files + 1))
  n=$(count_prose "$f")
  if test "${n:-0}" -ge 1; then
    echo "CORPUS $f lines=$n"
    hits=$((hits + n))
  fi
done
echo "enforce_files=$files"
echo "enforce_hits=$hits"

# The record, reported so the scale stays visible and failed never -- these rooms keep their words.
adv=$(grep -rlE "$PROSE" --include=*.md --include=*.kyri --include=*.bron \
        session-logs active-designing external-research counsel waymarks crux/archive crux/yonder \
        2>/dev/null | wc -l | tr -d ' ')
echo "record_files_keeping_the_word=$adv"
echo "record=kept_by_law"

if test "$hits" -eq 0; then
  echo "verdict=ok"
else
  echo "verdict=CORPUS_IN_READER_PROSE"
  exit 1
fi
