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
#                              IS testimony (.claude/rules/stamp-and-name.md) -- UNLESS the page
#                              declares itself Living in its own frontmatter, below.
#   gratitude/ vendor/         third-party text, held unmodified
#   external-research/         the named world; a teacher quoted keeps the teacher's words
#   research-silo/ seed/       a silo and a projection, neither authored here
#   tools/fixtures/            planted corpora. A fixture is an input with an expected output, so
#                              rewording one changes what a witness proves.
#   the vocabulary records     the pages whose SUBJECT is which words this tree retired: the
#                              vocabulary rules, the Lexicon, the two style guides, and the
#                              radiant vocabulary pass that seats footgun, dead-peer and sanity
#                              check. A law needs room to name the word it bans.
#                              tools/v/vocabulary_collection_scan.sh carries the same exemption,
#                              learned the hard way on the day it was written.
#
# A STAMPED PAGE THAT CALLS ITSELF LIVING IS READ (added 20260907.144000). The stamp exclusion
# above is right for testimony and wrong for a page that declares otherwise in its own hand.
# Measured before the change: 555 tracked pages were dropped by the stamp rule alone, and 147 of
# them carry a frontmatter Status or Room line naming Living -- foundations pages on the council
# rota, context/specs, active-designing. Those pages are swept on touch by the vocabulary laws
# and molted in place or by mutant, so an advisory on one is actionable; an advisory on genuine
# testimony would not be. The roster reads 379 -> 525 pages and duty 1 prints 3 rather than 0.
# The page's own Status line is the test, so the meter judges nothing and no list is kept.
#
# WHAT THIS DOES NOT REACH. Whether those three lines get swept: that is on touch under the
# vocabulary rules, and a dated page's prose is Tier 2 (a recorded Radiant pass), never a red.
# Duty 1 refuses nothing, so widening its subject moves no gate and raises no ceiling.
#
# WHAT STAYS IN, though a room rule would have dropped it: the front doors of counsel/, waymarks/,
# and session-logs/. Those rooms hold testimony, and every file inside carries a stamped basename,
# so the mark law already lifts their contents. Their README pins carry no stamp and are ordinary
# living prose. A page dropping off a meter is a page whose pass nobody witnessed (REDS %170).
#
# Read by duty 1 of tools/fixtures/l/living_docs_lint_scan.sh, through
# tools/fixtures/r/retired_word_scan.sh, and proven by retired_word_control.sh.
#
#   sh tools/fixtures/l/living_prose_roster.sh        # one path per line
#
# THE RADIANT-VOCABULARY EXCLUSION NAMES ITS FILE OUTRIGHT (`20260907.192241`). It carried two
# date classes and an underscore before the sprig, which `tools/d/dated_spelling_witness.rish`
# refuses: 237 logs in this tree carry a stamp and no sprig, and a pattern demanding one reads
# straight past them. Here the demand was for a different reason -- the exclusion means ONE page
# and identified it by its sprig -- so the repair is the literal path rather than a looser date
# class. It excludes exactly the page it means, and a mutant seated at a fresh stamp arrives
# reconsidered rather than silently inherited. The roster reads 520 paths before and after.
#
# The elder spelling is described here rather than quoted, and that is the finding rather than a
# nicety: quoting it left the guard reading this comment as a live pattern and refusing the tree
# for prose explaining the repair. A grep for a shape counts the sentence that says the opposite --
# the same reading `tools/fixtures/p/plant_adoption_scan.sh` booked at `20260907.145907` and
# `tools/fixtures/c/crushed_index_scan.sh` met on this same lap. Three houses, one shape.
set -eu

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

git ls-files '*.md' \
  | grep -vE '(^|/)(date|archive|yonder)/' \
  | grep -vE '^(gratitude|vendor|seed|external-research|research-silo|tools/fixtures)/' \
  | grep -vE '^(\.claude/rules/vocabulary-|\.claude/rules/tame-guidance\.md$|context/LEXICON\.md$|context/GAUGE_STYLE\.md$|context/TAME_GUIDANCE\.md$|context/specs/20260707-053212_radiant-vocabulary-pass\.md$)' \
  | while IFS= read -r rel; do
      case "${rel##*/}" in
        [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][_.]*)
          # A stamped basename is testimony by the mark law -- unless the page says otherwise in
          # its own hand. A Status line whose VALUE is Living is the page declaring that it is
          # not testimony, and a page that calls itself living is governed by the living word
          # laws. No list to maintain, and no judgment made by the meter.
          #
          # The value, never the line. A page reading "**Status:** Retired -- a word that is not
          # Living" says the opposite and holds the token; the control plants exactly that and it
          # caught a first draft matching anywhere on the line. Status is unanchored on purpose:
          # this tree writes "**Language:** EN - **Status:** Living, **mixed room**" as often as
          # it writes Status first. Room is not read here -- it answers the register question
          # (checkable, vision, mixed), never the living-or-testimony one.
          grep -qE '\*\*Status:\*\*[[:space:]]*Living\b' "$rel" 2>/dev/null || continue
          ;;
      esac
      printf '%s\n' "$rel"
    done
