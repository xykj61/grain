#!/bin/sh
# tools/fixtures/banner_room_scan.sh -- a banner that names a shelf must name the shelf the file is on.
#
# WHY. A living document's header sometimes names the shelf it sits on, in a field of its own:
# `**Register:** active-designing -- siloed; names only our own modules`. That sentence is a claim
# about where the file lives, and a file moves. When `foundations/` graduated six documents on
# `20260821.211423`, three of them kept a Register line still naming `active-designing`, so each one
# told every future reader it lived in a room it had left.
#
# Three consecutive laps found one of these by hand, on touch, while reading the council rota --
# `single-stranded.md`, `growing-a-language.md`, and `the-marked-value.md`. A lantern that fires
# twice becomes a loom, so the third one is a meter rather than a fourth reading.
#
# WHAT IS CHECKED. Only the fields that genuinely name a shelf -- `Register`, `Room`, `Shelf` --
# and only when their first word is a real shelf this tree files on. That first word must then be a
# directory the file actually sits inside.
#
# WHAT IS DELIBERATELY FREE. `**Status:**` says what a piece IS rather than where it lives, so
# `**Status:** Counsel -- recommendations only` on an archived file is honest and passes untouched.
# A Two Rooms register -- `**Register:** Checkable`, `Mixed`, `Vision`, `Radiant` -- names a voice
# rather than a room, so it never matches the roster and never enters the count. Measured across the
# whole tree at seating: 29 shelf-naming banners, 26 agreeing, 3 drifted, and no false positive.
#
# USAGE
#   sh tools/fixtures/banner_room_scan.sh
#
# Driven by tools/banner_room_witness.rish. Run from the repository root.

set -eu

# The shelves this tree files prose on, plus the two sub-shelves a room may carry.
shelves="active-designing active-development active-reviving context counsel crux docs
expanding-prompts external-research foundations gratitude recursion-prompts
research-silo session-logs waymarks yonder archive"

named=0
agreeing=0
drifted=0
bad=$(mktemp)
trap 'rm -f "$bad"' EXIT

for file in $(git ls-files '*.md'); do
  [ -f "$file" ] || continue

  line=$(head -30 "$file" | grep -m1 -E '^\*\*(Register|Room|Shelf):\*\*' || true)
  [ -n "$line" ] || continue

  # The shelf a banner names is its first word, stripped of the punctuation a sentence trails.
  claimed=$(printf '%s' "$line" \
    | sed -E 's/^\*\*(Register|Room|Shelf):\*\* *//' \
    | awk '{print tolower($1)}' \
    | tr -d ',;:.')

  # A first word that is no shelf names a voice or a register, and passes free.
  case " $shelves " in *" $claimed "*) ;; *) continue ;; esac

  named=$((named + 1))

  case "/$file" in
    *"/$claimed/"*) agreeing=$((agreeing + 1)) ;;
    *)
      drifted=$((drifted + 1))
      echo "$file claims $claimed" >> "$bad"
      ;;
  esac
done

echo "banners_naming_a_shelf=$named"
echo "banners_agreeing=$agreeing"
echo "banners_drifted=$drifted"
if [ "$drifted" -gt 0 ]; then sed 's/^/drifted: /' "$bad"; fi

if [ "$drifted" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
echo "verdict=banner_drift"
echo "refused: a banner names a shelf the file has left -- repoint the banner to where the file sits" >&2
exit 1
