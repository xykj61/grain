#!/usr/bin/env sh
# tools/fixtures/l/living_prose_roster.sh -- the living prose a word ban actually governs.
#
# WHY IT STANDS APART FROM THE DOCS ROSTER. living_docs_lint_roster.sh answers a PAGE-level
# question: which pages carry promises about links, rosters, status rooms, and byte bounds. It
# answers with 60 paths, and for those duties that is right. A retired word is a PROSE-level
# question, and it governs every living page in the tree. Duty 1 read the page roster for its
# whole life. So the vocabulary laws reached 767 living markdown pages while the meter enforcing
# them heard 60 of them, a fourteenth of the room. Two questions sharing one roster is the braid
# single-stranded names, and this file is the unbraiding.
#
# THE RULE: a tracked .md file that is neither testimony nor a room keeping words of its own.
#
# WHAT STAYS OUT, each exemption named here so it reads as a decision:
#
#   date/ archive/ yonder/     testimony and deferred work; accrete-never-break keeps every word
#   a stamped basename         the mark law's own test -- a basename carrying a one-clock stamp
#                              IS testimony (.claude/rules/stamp-and-name.md)
#   gratitude/ vendor/         third-party text, held unmodified
#   external-research/         the named world; a teacher quoted keeps the teacher's words
#   research-silo/ seed/       a silo and a projection, neither authored here
#   tools/fixtures/            planted corpora. A fixture is an input with an expected output, so
#                              rewording one changes what a witness proves.
#   the vocabulary records     the five pages whose SUBJECT is which words this tree retired: the
#                              vocabulary rules, the Lexicon, and the two style guides. A law
#                              needs room to name the word it bans.
#                              tools/v/vocabulary_collection_scan.sh carries the same exemption,
#                              learned the hard way on the day it was written.
#
# WHAT STAYS IN, though a room rule would have dropped it: the front doors of counsel/, waymarks/,
# and session-logs/. Those rooms hold testimony, and every file inside carries a stamped basename,
# so the mark law already lifts their contents. Their README pins carry no stamp and are ordinary
# living prose. A page dropping off a meter is a page whose pass nobody witnessed (REDS %170).
#
# Read by duty 1 of tools/fixtures/l/living_docs_lint_scan.sh, through
# tools/fixtures/l/retired_word_scan.sh, and proven by retired_word_control.sh.
#
#   sh tools/fixtures/l/living_prose_roster.sh        # one path per line
set -eu

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

git ls-files '*.md' \
  | grep -vE '(^|/)(date|archive|yonder)/' \
  | grep -vE '^(gratitude|vendor|seed|external-research|research-silo|tools/fixtures)/' \
  | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' \
  | grep -vE '^(\.claude/rules/vocabulary-|\.claude/rules/tame-guidance\.md$|context/LEXICON\.md$|context/GAUGE_STYLE\.md$|context/TAME_GUIDANCE\.md$)'
