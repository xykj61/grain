#!/bin/sh
# qa_setting_declared_scan.sh -- a page that names no setting is graded by whoever runs the tool.
#
# WHY. Gauge is one style on one dial, and the dial is the SETTING: Door holds a page at one
# cross-reference per hundred words and 20 percent negative sentences, Field at three and 30, Meter
# at neither. `sh tools/fixtures/q/qa_report_card.sh` reads that dial from a `--setting` flag the
# CALLER hands it, and reports the page's own declaration separately as `qa_declared_setting`. When
# the page declares nothing, those two facts stop agreeing and nothing in the tree counts how often.
#
# THE LAW SAYS MOST PAGES KNOW THEIR OWN. `context/GAUGE_STYLE.md` writes it plainly -- *a document
# names its setting when the choice would surprise a reader; most know their own.* That sentence was
# written for a HUMAN reader, who can open a page and tell. The card is a MACHINE reader and cannot,
# so an undeclared page hands its grade to whoever typed the command.
#
# MEASURED `20260910.163831` BY THIS SCAN, and every figure below is FREE -- nothing holds it
# still -- so RUN the scan rather than reading them. Of **330** living pages, **164 declare a
# style** and **50 of those name a setting**; **114 leave it unnamed**, and 166 carry no `**Style:**`
# line at all. The elder reading of `20260910.104833` answered 158 / 48 / 110 / 172, and the
# difference is the repair recorded below the population rule: six pages were being read as silent
# while they spoke. Priced over 27 of the 110 at stride 4: **20 scored differently** at Door than at
# Field, mean spread **3.29 points**, and **4 crossed the B door at 80** at the judged stand-in
# `--service 90`. Two of those four are
# pages the whole fleet reads -- `MAP.md` at **79 Door, 84 Field**, which the baton instructs every
# ship to read instead of walking the root, and `construction/REDS.md` at **77 and 82**, the ledger.
#
# THE FIRST DRAFT OF THIS HEADER CARRIED A HAND COUNT, and it was wrong in both directions: 235
# pages where the tree's own rule reads 330, and 172 unnamed where it reads 110. The hand filter
# excluded a dated stamp anywhere in a PATH where the rule excludes it only in a BASENAME, and it
# never read `.mdc` at all. That is why the population rule below is transcribed rather than
# rewritten, and why the numbers in this paragraph come from the scan that prints them.
#
# THE LANTERN FIRED TWICE, which is what earns an instrument rather than a repair. On
# `20260910.082330` the same question was priced at **eight points** on `glow/nock/README.md` and
# carried to the card as one page's ask; this scan makes it one ruling with a population attached.
#
# COUNTED, NEVER GATED, for the reason its rota sibling gives: a page may honestly need no setting
# -- Gauge's own law says most know their own -- so a gate here would red on ordinary work, and a
# gate that reds on ordinary work is a gate somebody turns off. What the tree lacked was the number.
#
# THE COUNT IS CHEAP AND THE PRICE IS NOT. Pricing one page costs two card runs at about half a
# second each, so the whole class costs minutes. `count` reads headers alone and is the lap-tier
# reading; `price` is a hand's subcommand and prints its own sample size.
#
#   sh tools/fixtures/q/qa_setting_declared_scan.sh          # the counts
#   sh tools/fixtures/q/qa_setting_declared_scan.sh list     # one line per undeclared page
#   sh tools/fixtures/q/qa_setting_declared_scan.sh price    # Door vs Field, bounded sample
#   QA_SETTING_STRIDE=1 sh ... price                         # every page, minutes
#   QA_SETTING_SERVICE=100 sh ... price                      # a different judged stand-in
#
# THE POPULATION RULE IS TRANSCRIBED FROM `tools/fixtures/a/ascii_document_scan.sh` UNCHANGED, so
# two readings of "a living page" cannot drift apart, and so this scan inherits three lessons that
# room already paid for: a git-quoted path is skipped and named rather than read as bytes; the
# listing is read a LINE at a time, because `for f in $list` splits a tracked path holding a space
# into two words; and a dated basename or a `date/`, `archive/`, `yonder/` shelf is read past,
# because accrete-never-break outranks any reading -- testimony keeps the words it wrote.
#
# BOUNDS: at most 4000 tracked documents read, at most 200 lines reported, at most 250 pages priced.
set -eu

root=${QA_SETTING_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)}
cd "$root"

MODE=${1:-count}
MAX_DOCS=4000
MAX_REPORT=200
MAX_PRICE=250
STRIDE=${QA_SETTING_STRIDE:-4}
# THE SERVICE READING IS JUDGED, AND PRICING NEEDS A NUMBER, so one stand-in is handed to both runs.
# It cancels out of the SPREAD entirely -- Service is added to both settings alike, so `spread` and
# `spread_differs` are true whatever this is. It does NOT cancel out of `crosses_b`, which asks
# where a composite lands against 80: at `--service 100` MAP.md reads 81 and 86 and crosses nothing,
# at 90 it reads 79 and 84 and crosses. So the crossing count is reported WITH the stand-in that
# produced it, and a reader who disagrees with the stand-in re-runs rather than re-reads.
SERVICE=${QA_SETTING_SERVICE:-90}

work=$(mktemp -d "${TMPDIR:-/tmp}/qa-setting.XXXXXX") || {
  echo "instrument=failed"
  echo "detail=mktemp_refused"
  echo "verdict=misread"
  exit 1
}
trap 'rm -rf "$work"' EXIT INT TERM

# invariant: a guard that cannot run its instrument says so rather than reporting an empty tree as
# a clean one -- an absent answer and a good answer must never look alike.
if ! git ls-files -- '*.md' '*.mdc' > "$work/all.txt" 2>/dev/null; then
  echo "instrument=failed"
  echo "detail=git_ls_files_refused"
  echo "verdict=misread"
  exit 1
fi
if [ ! -s "$work/all.txt" ]; then
  echo "instrument=failed"
  echo "detail=no_tracked_documents"
  echo "verdict=misread"
  exit 1
fi

quoted=0
absent=0
: > "$work/living.txt"
lines=0
while IFS= read -r f; do
  [ -n "$f" ] || continue
  lines=$((lines + 1))
  [ "$lines" -le "$MAX_DOCS" ] || break
  case "$f" in '"'*) quoted=$((quoted + 1)); continue ;; esac
  case "$f" in
    gratitude/*|vendor/*|seed/*) continue ;;
    */fixtures/*|fixtures/*|*/fixture/*) continue ;;
    date/*|*/date/*|archive/*|*/archive/*|yonder/*|*/yonder/*) continue ;;
  esac
  b=${f##*/}
  case "$b" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][_.]*) continue ;;
  esac
  # invariant: an absent path is SKIPPED AND COUNTED, never silently dropped -- `git ls-files` reads
  # the INDEX, so a staged rename lists a path the working tree no longer holds, and a reader must
  # be able to tell a small population from a population the scan could not open.
  if [ ! -f "$f" ]; then absent=$((absent + 1)); continue; fi
  printf '%s\n' "$f" >> "$work/living.txt"
done < "$work/all.txt"

# invariant: a declaration is a `**Style:**` key standing anywhere in the page's HEAD, and the
# reader that decides it is CITED out of tools/fixtures/q/qa_report_card.sh rather than written
# again here -- the same way this scan's population rule is transcribed from the ascii room, and
# the same way the card itself lifts `measure()` from the register scan (REDS %201). A second copy
# of a one-line rule is how two readers come to disagree, which is exactly what happened.
#
# WHAT WENT WRONG, and it took both instruments to see it. This scan read the block above a page's
# first `---` rule and its own comment claimed that was "the same way the card reads it." The card
# matched `^[ \t]*\*\*Style:\*\*` over the whole file. Neither claim held: measured
# `20260910.163831` over this scan's own 330-page population, the elder block rule missed **five**
# pages declaring their style BELOW their first horizontal rule -- README.md, the tree's own front
# door, whose head opens with a centred logo block, a title, a tagline and four licence badges and
# carries `**Style:** Bhakta with Gauge and Twilight` at line 23; SKILL.md and
# classical-vedic-astrology/studies/README.md, both of which NAME a setting; plus cellar/README.md
# and context/TAME_GUIDANCE.md. The card's anchor missed **65** pages writing the key INLINE after
# another -- `**Language:** EN - **Voice:** Kyri - **Style:** Gauge, Door setting`, which is how
# docs/README.md declares Door and how the card read it as absent.
#
# THE REPAIR MOVED THIS SCAN'S FOUR COUNTS, and every one of them rose because a page was being
# read as silent while it spoke: style_declared **158 -> 164**, setting_named **48 -> 50**,
# setting_unnamed **110 -> 114**, no_style_line **172 -> 166**. Both understatements were of the
# same kind, which is why neither showed up as a contradiction anywhere: a missed declaration
# looks exactly like a page that never wrote one.
#
# WHAT THE SETTING MATCH CANNOT TELL APART, named rather than left for a reader to trip on. The
# reading asks whether the declaration LINE carries the word door, field or meter, so a line whose
# trailing prose happens to use one of those words as ordinary English reads as naming a setting.
# Measured `20260910.175434`: **two** pages do -- `docs-geode/tutorials/the-first-hour.md` and its
# sibling, whose Style line ends *"named rather than linked -- it stays in the field"*, meaning the
# maintainer's working tree rather than Gauge's Field. Two of fifty is the size of the error, and
# the cure is worse than the fault: the fifty declaring pages spell their setting **14** different
# ways -- `Gauge Field`, `Gauge, Door setting`, `Gauge at the Door, in the Twilight register` --
# so a stricter pattern would drop real declarations to catch two false ones. One spelling, agreed
# on, would let this reading tighten; that is the standing ask rather than a lap's decision.
#
# LOSING THE CITED FUNCTION MAKES THIS SCAN REFUSE rather than fall back on a copy, since a
# fallback is a second rule wearing a safety net.
# THE CARD IS RESOLVED BESIDE THIS SCRIPT rather than under the tree being read. `QA_SETTING_ROOT`
# points this scan at another tree -- which is how the pen reads planted pages -- and the reader it
# cites is part of the INSTRUMENT rather than part of the population. Resolving it under the root
# made the pen answer `card_absent` for every leg, which is the fault a control exists to catch.
card_reader="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/qa_report_card.sh"
if [ ! -f "$card_reader" ]; then
  echo "instrument=failed"
  echo "detail=card_absent"
  echo "verdict=misread"
  exit 1
fi
sed -n '/^QA_HEAD_LINES=/p;/^declared_style_line_of() {/,/^}/p' "$card_reader" > "$work/declared.sh"
if [ ! -s "$work/declared.sh" ] || ! grep -q '^declared_style_line_of() {' "$work/declared.sh"; then
  echo "instrument=failed"
  echo "detail=card_no_longer_publishes_declared_style_line_of"
  echo "verdict=misread"
  exit 1
fi
. "$work/declared.sh"

pages=0
style_declared=0
setting_named=0
setting_unnamed=0
no_style_line=0
: > "$work/unnamed.txt"
while IFS= read -r f; do
  [ -n "$f" ] || continue
  pages=$((pages + 1))
  h=$(declared_style_line_of "$f")
  case "$h" in
    *'**Style:**'*) style_declared=$((style_declared + 1)) ;;
    *) no_style_line=$((no_style_line + 1)); continue ;;
  esac
  if printf '%s\n' "$h" | grep -qiE '\*\*Style:\*\*[^|]*(door|field|meter)'; then
    setting_named=$((setting_named + 1))
  else
    setting_unnamed=$((setting_unnamed + 1))
    printf '%s\n' "$f" >> "$work/unnamed.txt"
  fi
done < "$work/living.txt"

if [ "$MODE" = list ]; then
  head -"$MAX_REPORT" "$work/unnamed.txt" | while IFS= read -r f; do
    echo "unnamed_setting $f"
  done
fi

priced=0
spread_differs=0
crosses_b=0
spread_sum=0
if [ "$MODE" = price ]; then
  card="tools/fixtures/q/qa_report_card.sh"
  if [ ! -f "$card" ]; then
    echo "instrument=failed"
    echo "detail=card_absent"
    echo "verdict=misread"
    exit 1
  fi
  i=0
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    i=$((i + 1))
    [ $((i % STRIDE)) -eq 0 ] || continue
    [ "$priced" -lt "$MAX_PRICE" ] || break
    d=$(sh "$card" "$f" --setting door  --service "$SERVICE" 2>/dev/null | sed -nE 's/^composite=([0-9]+).*/\1/p')
    v=$(sh "$card" "$f" --setting field --service "$SERVICE" 2>/dev/null | sed -nE 's/^composite=([0-9]+).*/\1/p')
    case "$d$v" in ''|*[!0-9]*) continue ;; esac
    priced=$((priced + 1))
    spread_sum=$((spread_sum + v - d))
    [ "$v" -ne "$d" ] && spread_differs=$((spread_differs + 1))
    if [ "$d" -lt 80 ] && [ "$v" -ge 80 ]; then
      crosses_b=$((crosses_b + 1))
      echo "crosses_b door=$d field=$v $f"
    fi
  done < "$work/unnamed.txt"
fi

echo "pages=$pages style_declared=$style_declared setting_named=$setting_named setting_unnamed=$setting_unnamed no_style_line=$no_style_line"
echo "quoted_paths_skipped=$quoted absent_in_worktree=$absent (a git-quoted path is named rather than read as bytes; an indexed path the tree lacks is counted rather than dropped)"
if [ "$MODE" = price ]; then
  mean="n/a"
  [ "$priced" -gt 0 ] && mean=$(( spread_sum * 100 / priced ))
  echo "priced=$priced of $setting_unnamed stride=$STRIDE spread_differs=$spread_differs mean_spread_x100=$mean"
  echo "crosses_b=$crosses_b at service=$SERVICE (the spread is service-free; a crossing is not -- see the header)"
fi
echo "reading=counted (a page may honestly need no setting; a gate here would red on ordinary work)"
echo "verdict=ok"
