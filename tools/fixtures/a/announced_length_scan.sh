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
for f in $living; do
  # A range announced from zero, both ends sharing a letter prefix of two or more.
  LC_ALL=C grep -oE '\b([A-Za-z]{2,})0-\1[0-9]+\b' "$f" 2>/dev/null | sort -u | while read -r ann; do
    prefix=${ann%%0-*}
    top=${ann##*"$prefix"}
    echo "$f|$prefix|$top"
  done
done > /tmp/al_found.$$ 2>/dev/null || true

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
done < /tmp/al_found.$$
rm -f /tmp/al_found.$$

echo "announcements_checked=$checked"
echo "forecasts_short=$short"
if [ "$short" -eq 0 ]; then echo "verdict=no_living_forecast"; else echo "verdict=living_forecast"; fi
