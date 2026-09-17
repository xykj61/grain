#!/bin/sh
# tools/fixtures/l/listing_census_scan.sh -- a listing that drops rows and does not say so.
#
# WHAT A CAPPED LISTING IS. A scan answers `--list` by sorting its per-site report worst-first and
# piping it through `head`. That bound is right: a lane wants the loudest sites, and an unbounded
# listing buries them. What is wrong is printing the bound in silence, because then an absent row
# and a dropped row look identical, and the reader most likely to be misled is the one asking the
# narrowest question -- *what is MY lane's share?*
#
# HOW LARGE THE SILENCE WAS, measured `20260916.214947` over the nine ASCII-family scans, the only
# members carrying this shape at the time:
#     3,321  rows those eleven listings could have printed
#       349  rows they did print
#     2,972  rows dropped, 89 percent, with nothing saying a row had been dropped
# `tools/fixtures/r/rish_spoken_ascii_scan.sh` alone held 1,480 files carrying non-ASCII spoken
# characters and named 40. Eighteen of the hidden characters stood in five `tools/am/amphora_*`
# witnesses, whose own lane read the listing, saw no amphora row, and had no way to tell that from
# a clean room. That is the founding case and it is this file's reason.
#
# AND THE USAGE LINE PROMISED WHAT THE CODE REFUSED. Seven of the nine headers read
# `--list   # name each file and its count, worst first`. Each file, and forty printed -- so the
# silence was not an omission a reader could have caught by reading the header more carefully.
#
# THE CLASS FIRED TWICE IN ONE DAY, which is what earns a meter rather than a repair. Petrichor's
# `tools/fixtures/s/seed_link_scan.sh` printed a ratchet site only while its counter stood at or
# under five, so 847 sites showed five (`20260916.210332`); this family printed forty of 3,321. One
# lantern is a repair; two is a loom (`.claude/rules/reds-first.md`).
#
# WHAT COUNTS AS A CAP. A line outside a `#` comment carrying `sort`, then a pipe, then `head`,
# where the head count is NOT one. `head -1` and `head -n 1` are excluded on purpose: taking the
# single worst row is a scalar read rather than a listing, and it drops nothing a reader would have
# expected to see. Nine such single reads stand in this tree and none is a fault.
#
# WHAT COUNTS AS A CENSUS. A line emitting a key whose name ends in `hidden=` -- `list_hidden`,
# `trail_list_hidden`, `enforce_list_hidden`. The key rather than the prose, because a comment
# promising honesty is exactly what this family already had.
#
# THE READING IS PER FILE RATHER THAN PER SITE, and the reason is a bound on what a scanner can
# know: pairing a particular `head` with a particular `echo` needs the control flow between them,
# which is parsing. So a file owes one census per cap, and `uncensused` is the shortfall. A file
# printing more censuses than caps reads zero rather than negative, and says so by the same
# arithmetic. This UNDERCOUNTS a file whose two caps share one census line, the same way its
# siblings in the ASCII family undercount on purpose and say so.
#
# THE FAMILY IS A WALL; EVERYTHING ELSE IS A RATCHET. The nine ASCII scans were repaired on
# the lap that seated this meter, so `family_uncensused` is held at zero and the next silent
# cap added to one of them reds where it lands. `caravan_ladder_carry` and `width_check` were
# repaired on later laps and dropped off this list. Eleven caps across seven files stand
# outside the family -- `prose_register` 4, `sealed_digest` 2, and one each in
# `tame_style_long_fn`, `standing_equipment`, `socket_dialect`, `ladder_reach_visibility` and
# `control_perturbation` -- each its own lane's to repair. A lane repairs its own and lowers
# the ceiling; a sweep from here would be this lane spending other lanes' judgment.
#
# USAGE
#   sh tools/fixtures/l/listing_census_scan.sh             # census -- key=value lines
#   sh tools/fixtures/l/listing_census_scan.sh --list      # every uncensused file, worst first
#
# Run from the repository root, or from any git work tree (the control runs it inside a pen).

set -u

mode="${1:-count}"

# The ceiling only falls. Measured `20260916.214947`: THIRTEEN uncensused caps across nine
# files outside the family. The claim that opened this lap said FOUR, counted by a grep
# wanting `sort ... | head -<digits>` on one line; the meter reads `head -n "$var"` too, and
# the correction rides with the reading rather than waiting for a later lap.
# Fell to TWELVE `20260917`: `caravan_ladder_carry_scan.sh`'s CARRY_TOP queue now names
# top_shown and top_hidden beside the twelve families it prints, so a reader can tell "the
# queue held exactly twelve" from "the queue held 576 and the rest were cut."
CEILING=11

# The wall. Named rather than discovered, because membership in the ASCII-first meter family is a
# fact about the law those nine serve rather than about their spelling -- and a discovered roster
# would quietly drop a member that was renamed.
FAMILY="tools/fixtures/r/rish_spoken_ascii_scan.sh
tools/fixtures/r/rye_spoken_ascii_scan.sh
tools/fixtures/s/shell_comment_ascii_scan.sh
tools/fixtures/r/rye_comment_ascii_scan.sh
tools/fixtures/g/glow_comment_ascii_scan.sh
tools/fixtures/a/ascii_document_scan.sh
tools/fixtures/r/rye_written_ascii_scan.sh
tools/fixtures/s/shell_written_ascii_scan.sh
tools/fixtures/s/shell_emit_ascii_scan.sh"

list=$(git ls-files 'tools/*_scan.sh' 2>/dev/null | grep -vE '^(vendor|gratitude|seed)/')

if [ -z "$list" ]; then
  # A GUARD THAT CANNOT RUN ITS INSTRUMENT MUST SAY SO (REDS %513). An empty population and a
  # refused listing print the same zero, and only one of them means the tree is clean.
  echo "instrument=failed"
  echo "detail=no_scan_sources_listed"
  echo "verdict=misread"
  exit 1
fi

# Reads one file and prints "<caps> <censuses>".
read_file() {
  LC_ALL=C awk '
    {
      line = $0
      sub(/^[ \t]+/, "", line)
      # A comment naming the shape is not the shape. the header of this file describes a capped
      # listing in prose, so a reader that counted comments would refuse itself.
      if (substr(line, 1, 1) == "#") next
      # `head -1` and `head -n 1` are a scalar read rather than a listing: taking the single worst
      # row drops nothing a reader expected to see. The trailing class is `[^0-9]` rather than
      # whitespace, because this tree writes `| head -1)` inside a command substitution, and a
      # whitespace-anchored exclusion read nine such scalar reads as silent caps.
      # A cap whose output is REDIRECTED into a file bounds an input set rather than a
      # listing -- `sort -u | head -n "$max" > "$work/cited.txt"` is TAME asking every
      # collection to name a maximum, and it drops rows nobody was reading. Four such
      # bounds stand in `aurora_placement` and `law_guard_heard`. The subject here is a cap
      # on what reaches a PERSON, so a redirected line is read past.
      if (line ~ />[ \t]*["$a-zA-Z]/) next
      if (line ~ /sort[^|]*\|[ \t]*head/ && line !~ /head[ \t]+-(n[ \t]+)?1([^0-9]|$)/) caps++
      # A CENSUS is a key naming what the run printed or dropped -- `list_hidden`,
      # `trail_list_hidden`, `enforce_list_hidden`, and equally `runs_slowest_shown`,
      # which `standing_equipment_scan.sh` prints beside a total a reader can subtract
      # from. The narrow reading counted only `hidden=` and called that file four short
      # when it names three of its four caps honestly in the other spelling. The key
      # rather than the prose, because a comment promising honesty is exactly what the
      # ASCII family already had.
      # An EMIT rather than an assignment. `list_shown=$list_total` is a variable being set and
      # says nothing to a reader; only the `echo` that prints it is the census. Counting the
      # assignments read one honest block as three, so a file could earn slack by being verbose.
      if (line ~ /^(echo|printf)/ && line ~ /[a-z_](hidden|shown)=/) cens++
    }
    END { print (caps + 0) " " (cens + 0) }
  ' "$1"
}

files=0
opened=0
absent=0
caps_total=0
family_caps=0
family_uncensused=0
other_uncensused=0
report=""

for f in $list; do
  [ -L "$f" ] && continue
  if [ ! -f "$f" ]; then
    absent=$((absent + 1))
    continue
  fi
  opened=$((opened + 1))
  pair=$(read_file "$f") || {
    echo "instrument=failed"
    echo "detail=awk_refused_a_file"
    echo "detail_path=$f"
    echo "verdict=misread"
    exit 1
  }
  caps=${pair% *}
  cens=${pair#* }
  case "$caps$cens" in
    '' | *[!0-9]*)
      echo "instrument=failed"
      echo "detail=awk_answered_no_number"
      echo "detail_path=$f"
      echo "verdict=misread"
      exit 1
      ;;
  esac
  [ "$caps" -eq 0 ] && continue
  files=$((files + 1))
  caps_total=$((caps_total + caps))
  short=$((caps - cens))
  [ "$short" -lt 0 ] && short=0
  in_family=no
  for m in $FAMILY; do
    [ "$m" = "$f" ] && in_family=yes && break
  done
  if [ "$in_family" = yes ]; then
    family_caps=$((family_caps + caps))
    family_uncensused=$((family_uncensused + short))
  else
    other_uncensused=$((other_uncensused + short))
  fi
  [ "$short" -gt 0 ] && report="$report$short $f
"
done

if [ "$mode" = "--list" ]; then
  # This listing is uncapped by construction: a meter about dropped rows that dropped rows would be
  # the fault wearing its own instrument.
  list_total=$(printf '%s' "$report" | grep -c .)
  [ "$list_total" -gt 0 ] && printf '%s' "$report" | sort -rn
  echo "list_shown=$list_total list_hidden=0 list_total=$list_total"
fi

if [ "$other_uncensused" -le "$CEILING" ]; then under=yes; else under=no; fi
if [ "$family_uncensused" -eq 0 ]; then family_ok=yes; else family_ok=no; fi

echo "instrument=ok"
echo "scans_read=$opened"
echo "scans_absent=$absent"
echo "files_with_cap=$files"
echo "caps=$caps_total"
echo "family_caps=$family_caps"
echo "family_uncensused=$family_uncensused"
echo "family_walled=$family_ok"
echo "other_uncensused=$other_uncensused"
echo "ceiling=$CEILING"
echo "under_ceiling=$under"
if [ "$family_ok" = yes ] && [ "$under" = yes ]; then
  echo "verdict=ok"
else
  echo "verdict=silent_cap"
fi
