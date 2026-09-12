#!/bin/sh
# An announced ladder length is a forecast, and this counts how far each one actually got.
#
# WHY. `.claude/rules/stamp-and-name.md` retires the counted rung for PLANNED work, and gives four
# ladders as its evidence: `f0-f63` reached f3, `u0-u127` paused at u91, `i0-i15` paused at i6, and
# a sixteen-round chapter filled two rooms of twelve. Every one of those was found by a hand, named
# in prose, and typed into the rule. A fifth stood unnoticed in a living pin the whole time --
# `context/LEXICON.md` announcing `BUHR0-BUHR63` for a ladder that reached **BUHR6** across 72
# commits. A lantern that fires five times is a loom.
#
# WHAT IT READS. A living tracked file announcing a range whose two ends share a letter prefix and
# start at zero -- `NAME0-NAME63`. For each, the highest rung of that prefix actually written
# anywhere in the tree. Announced against reached.
#
# AND IT LEAVES ITS OWN OUTPUT ALONE. A page that runs this scan and quotes what it printed is
# documenting an announcement rather than making one, the same way a ledger row is.
#
# WHAT IT LEAVES ALONE. Dated testimony keeps every number it ever wrote (accrete-never-break), so
# anything under `date/`, `archive/`, `session-logs/`, or `seed/` is read past. A ladder whose
# reach meets its announcement is not a forecast that failed; it is reported and never counted.
set -u
here=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd) || exit 1
cd "$here" || exit 1

# THE INSTRUMENT IS PROVEN PRESENT BEFORE IT IS TRUSTED (REDS %413).
command -v git >/dev/null 2>&1 || { echo "announced_length: REFUSED -- git is absent" >&2; exit 2; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "announced_length: REFUSED -- not a git tree" >&2; exit 2; }

living=$(git ls-files '*.md' '*.kyri' '*.bron' 2>/dev/null \
  | grep -vE '(^|/)(date|archive|yonder)/|^session-logs/|^seed/|^gratitude/|^vendor/') || true
[ -n "$living" ] || { echo "announced_length: REFUSED -- no living files listed" >&2; exit 2; }

short=0; over=0; checked=0

# THE SCRATCH IS AN INSTRUMENT, AND AN INSTRUMENT IS PROVEN BEFORE IT IS TRUSTED (REDS %413).
# This script already keeps that discipline twice above -- git is proven present, and the living
# listing is proven non-empty -- and skipped it on the one path that can zero the reading in
# silence. The walk's output is redirected to a scratch file and read back, so a scratch that
# cannot be written yields an empty read, which counts nothing, finds nothing short, and prints
# `verdict=no_living_forecast` at exit 0 -- the same green a clean tree prints. Proven on metal:
# the same pen holding one WIDE0-WIDE63 forecast reads `living_forecast` with a writable scratch
# and `no_living_forecast` with an unwritable one. `mktemp` refuses out loud where a bare
# `/tmp/<name>.$$` redirect could only fail into the void, and it satisfies the pen clause REDS
# %549 seated -- your own root or a mktemp pen.
scratch=$(mktemp) || { echo "announced_length: REFUSED -- no scratch file could be made" >&2; exit 2; }
trap 'rm -f "$scratch"' EXIT INT TERM
{
  for f in $living; do
    # A range announced from zero, both ends sharing a letter prefix of two or more.
    #
    # A LEDGER ROW IS A RECORD, NOT AN ANNOUNCEMENT. A page that tabulates announced-against-reached
    # -- `| BUHR0-BUHR63 | BUHR6 |` -- is documenting a forecast rather than making one, and the
    # foundation written to teach this law was the first page the meter accused. The exclusion is
    # structural rather than a filename: a two-cell table row whose second cell is a rung of the same
    # prefix. To earn it, a page must state the true reach beside the announcement, which is the
    # honest act; a page merely announcing a length cannot qualify.
    #
    # AND THIS METER'S OWN OUTPUT IS A RECORD TOO. `docs-geode/demos/README.md` teaches the law by
    # running this scan and quoting what it printed, so three `met:` lines entered the tree as prose
    # and the next pass read them as three fresh announcements by the demos page -- a meter reading
    # its own output back as input. All three said `met`, so nothing went red; the cost would have
    # arrived later, when a quoting page took the blame for a forecast it merely reprinted. The
    # exclusion is the SAME rule in a third syntax rather than a new one: both output shapes state
    # the true reach beside the announcement, which is exactly what the table row earns its pass for.
    # Syntax-independent on purpose -- a fenced block is where this lands today, and skipping fences
    # would also excuse a bare announcement that happens to sit inside one.
    LC_ALL=C grep -vE '\| *([A-Za-z]{2,})0-\1[0-9]+ *\| *\1[0-9]+ *\|' "$f" 2>/dev/null \
      | LC_ALL=C grep -vE 'announces ([A-Za-z]{2,})0-\1[0-9]+(, | and the ladder )reached \1[0-9]+' \
      | LC_ALL=C grep -oE '\b([A-Za-z]{2,})0-\1[0-9]+\b' | sort -u | while read -r ann; do
      prefix=${ann%%0-*}
      top=${ann##*"$prefix"}
      echo "$f|$prefix|$top"
    done
  done
  # WRITTEN LAST, SO ITS PRESENCE PROVES THE WHOLE WRITE ARRIVED. `mktemp` proves the file could be
  # created; it says nothing about a write that fails partway -- a full filesystem, a killed
  # subshell -- and a listing truncated mid-walk understates the reading exactly as an empty one
  # does. A sentinel at the tail is missing in every one of those cases and present in none of the
  # honest ones, including the honest zero: a tree announcing no ladder at all writes this line and
  # nothing else, counts zero, and passes.
  echo '#listing-complete'
} > "$scratch" 2>/dev/null || true

# The read loop below skips this line by its own shape -- it carries no `|`, so `prefix` reads
# empty and the loop continues past it.
tail -n 1 "$scratch" 2>/dev/null | grep -q '^#listing-complete' || {
  echo "announced_length: REFUSED -- the scratch listing did not survive the write" >&2; exit 2; }

while IFS='|' read -r f prefix top; do
  [ -n "${prefix:-}" ] || continue
  checked=$((checked + 1))
  # The highest rung of this prefix written anywhere the tree can be read.
  #
  # THE ANNOUNCEMENT IS EXCLUDED BY ITS OWN SHAPE, not by its value. An elder draft dropped the
  # number `$top` from the reading, which makes a ladder that genuinely FINISHED read as one rung
  # short -- the meter would have called every completed ladder a failed forecast, which is the
  # false positive that gets a guard turned off. Lines carrying `PREFIX0-PREFIXtop` are dropped
  # instead, so the announcement cannot vote for itself and a real `PREFIXtop` elsewhere counts.
  #
  # AND ANY SPELLING OF A RANGE IS DROPPED, not just the hyphen. `SOON` read as reaching SOON63
  # because a dated page wrote the same announcement with an ellipsis -- `SOON0...SOON63` -- which
  # the hyphen filter walked straight past, so one announcement voted a reach for another. The
  # pattern drops a line carrying two rungs of the same prefix joined by RANGE PUNCTUATION -- a
  # separator carrying at least one non-space punctuation byte. Naming the spellings instead --
  # hyphen, ASCII ellipsis, the word `to` -- missed a UNICODE ellipsis in a dated page, and this
  # script stays ASCII by law, so it cannot simply add the character to a list. Requiring
  # punctuation rather than enumerating it costs nothing and covers a spelling nobody has written
  # yet. An elder draft accepted any short run of
  # non-alphanumerics, which matched a plain SPACE: a page listing `DONE1 DONE2 DONE3` was dropped
  # whole, so the meter understated every reach recorded as a list. Caught by this scan's own
  # control before it read a real tree twice.
  reached=$(git grep -hE "\b${prefix}[0-9]+\b" -- '*.md' '*.kyri' '*.rish' '*.rye' 2>/dev/null \
    | LC_ALL=C grep -vE "${prefix}[0-9]+[^A-Za-z0-9]{0,3}[^A-Za-z0-9 ][^A-Za-z0-9]{0,3}${prefix}[0-9]+" \
    | LC_ALL=C grep -oE "\b${prefix}[0-9]+\b" \
    | sed "s/^${prefix}//" | sort -n | uniq | tail -1)
  [ -n "${reached:-}" ] || reached=0
  if [ "$reached" -lt "$top" ]; then
    short=$((short + 1))
    echo "forecast: $f announces ${prefix}0-${prefix}${top} and the ladder reached ${prefix}${reached}"
  else
    echo "met: $f announces ${prefix}0-${prefix}${top}, reached ${prefix}${reached}"
  fi
done < "$scratch"

echo "announcements_checked=$checked"
echo "forecasts_short=$short"
if [ "$short" -eq 0 ]; then echo "verdict=no_living_forecast"; else echo "verdict=living_forecast"; fi
