#!/bin/sh
# tools/fixtures/r/rye_comment_ascii_scan.sh -- non-ASCII bytes in authored Rye COMMENTS.
#
# WHY. `.claude/rules/ascii-first.md` asks that prose be plain 7-bit ASCII, because a character no
# reader needs is a corruption waiting to compound -- the operator card once triple-encoded itself
# into 2,797 runs of mojibake (REDS %83). The rule governs documents, code comments, and commit
# messages, and it says to migrate on touch. Two files were migrated by hand on `20260825` and both
# times the violation had been written that same day, copied from the surrounding style rather than
# read. A lantern that fires twice becomes a loom, so here is the loom.
#
# WHAT COUNTS, and the line is drawn carefully because getting it wrong changes behavior.
# A COMMENT line is one whose first non-blank characters are `//` -- which covers `//`, `///`, and
# `//!`. Those are prose and the rule reaches them.
#
# WHAT DOES NOT COUNT:
#   * a `\\` line, which is Zig multiline STRING content and is program output, not prose;
#   * a string literal on a code line, for the same reason;
#   * a trailing comment after code on the same line -- IN THIS READING. It is prose, and it is
#     counted by the SECOND reading this scan prints, `RYE_TRAILING_COMMENT_ASCII`, seated
#     `20260908.232949` and argued in full beside `TRAIL_CEILING` below. One character belongs to
#     one ceiling; what changed is that it now belongs to one rather than to none.
# The first two are excluded because converting them would change what a program prints -- measured
# `20260825.011000`: 5,455 non-ASCII characters live in strings across 1,041 authored files, and one
# blanket `sed` over a single module rewrote nine of them, including a header written into a file.
# The third WAS excluded because finding it needs to know whether a `//` sits inside a string, which
# is parsing rather than scanning -- a reason about capability rather than about subject, and the
# capability arrived one lap earlier in the spoken meter beside this one. **This reading still
# UNDERCOUNTS on purpose**: it reads 33,541 total non-ASCII in comment context by a parsing measure,
# and rather less by this one. An honest smaller
# number under a falling ceiling beats a larger one that might be wrong about a string.
#
# USAGE
#   sh tools/fixtures/r/rye_comment_ascii_scan.sh          # count
#   sh tools/fixtures/r/rye_comment_ascii_scan.sh --list   # name each file and its count, worst first
#
# Run from the repository root.

set -u

mode="${1:-count}"

# The ceiling only falls. Lower it whenever a lap converts comments; never raise it.
# The arc, each figure measured rather than recalled:
#   32064  `20260825.011000`  across 1,497 files, the reading on the lap this meter was seated
#    4338  `20260825.011500`  after the named punctuation was converted in 1,303 files
#    4333  `20260828.134500`  after constel's eight -- three em-dashes this lap had itself
#                             promoted from trailing comments (uncounted) to their own lines
#                             (counted), plus five typographic minus signs in arithmetic prose
#    2608  `20260908.224742`  after the typographic minus was converted in 129 files -- the one
#                             residue class with a single lawful ASCII answer, so a script may
#                             make it where for the rest a reader must choose. The rule's table
#                             names it from this stamp: U+2212 MINUS SIGN -> `-`. Every one of the
#                             1,164 sat in arithmetic prose (`2^255 - 19`, `n - (n-1)/3`), and
#                             every rewritten file was re-derived from its committed bytes to
#                             prove the sweep moved nothing else.
# What remains is notation whose ASCII form a reader must choose -- 542 double vertical, 350
# section, 341 multiplication, 289 less-or-equal, 291 superscripts, 195 Greek -- each carrying a
# meaning a script would have to guess at.
#
# THE UNIT IS A CHARACTER, COUNTED BY ITS UTF-8 LEAD BYTE IN THE C LOCALE. Every non-ASCII
# character carries exactly one lead byte in `\300-\377`, so counting lead bytes counts
# characters -- one em dash is one, under every awk. The two dialect traps this survives, both
# paid for on this bench: `\x00-\x7F` is a GNU extension the BWK awk reads as literal characters
# (`20260826.211500`: 16,131,707 against a ceiling of 4,338), and a negated class like
# `[^\001-\177]` counts BYTES under BWK awk while GNU awk in a UTF-8 locale counts CHARACTERS --
# an em dash read 3 here and 1 on the Linux benches, so one tree carried two readings
# (`20260828.160500`: 11,405 against 4,333 on this bench, the ceiling itself char-measured).
# `LC_ALL=C` pins both awks to bytes, the lead-byte class turns bytes back into characters, and
# octal spelling reads identically in both dialects -- the same C-locale move
# `tools/fixtures/l/living_card_ascii_scan.sh` made when it dropped `grep -P` (REDS %278).
CEILING=2625

# A SYMLINK IS SKIPPED, and this is a census rather than a roster, so the reading is unambiguous:
# `git ls-files` lists a link AND its target as two paths, and following both counts the same bytes
# twice. On 20260829 two symlinks landed under `tools/rye/` pointing at `crypto/sha3.rye` and
# `crypto/keccak256.rye`, which have carried their 32 non-ASCII characters since 20260826 -- so this
# meter read 4,342 against a 4,333 ceiling and reported a rise that never happened. 4,342 minus the
# doubled 32 is 4,310, twenty-three UNDER. The idiom and its reason are the tree's own, from
# `tools/fixtures/c/caravan_wrap_class_scan.sh`: a symlink's laws belong to the room its target
# lives in. `tools/fixtures/c/caravan_ladder_roster_scan.sh` deliberately reads the other way, and
# both are right -- that meter asks which modules a room HAS, where a shared body reached by symlink
# is genuinely one of them; this one asks how many characters EXIST, and a byte counted twice is a
# byte miscounted.
#
# THE CEILING FELL WITH THE FIX, from 4,333 to 3,794, and the gap is the whole point: the two new
# links carried 32 characters, yet skipping symlinks removed 548 across 56 of them. This meter has
# double-counted every linked `.rye` since it was written, so the ceiling it carried was set on a
# doubled reading and held 539 characters of phantom headroom. A ceiling only falls, and this is
# the fall the correction owes.
list=$(git ls-files "*.rye" 2>/dev/null | grep -vE "^(vendor|gratitude|seed)/")

# A GUARD THAT CANNOT RUN ITS INSTRUMENT MUST SAY SO -- REDS %513. The elder loop read
# `n=$(LC_ALL=C awk ... 2>/dev/null)` and then `[ -z "$n" ] && n=0`, so awk's exit status was never
# read and its complaint was discarded. An empty answer from a refused read is byte-identical to an
# empty answer from a clean file, and the second is the one everyone hopes for. Proven on metal in a
# throwaway pen: with one comment planted between a trailing `||` and the newline continuing the
# statement -- the exact fault `tools/fixtures/a/ascii_document_scan.sh` carried in its own first
# draft -- awk refused the whole program and this meter answered `files=0 chars=0 under_ceiling=yes`
# over every tracked source it never opened. Both meters sat AT their ceilings when this was found,
# so a silent zero would have read as the largest sweep either had ever recorded.
#
# The awk moves into a function so its status can be read. Three answers, told apart:
#   * ABSENT is skipped and COUNTED, never fatal -- `git ls-files` reads the INDEX, so a rename
#     staged mid-lap lists a path the working tree no longer holds, and a rebase is exactly when a
#     reading is worth having.
#   * REFUSED is fatal and NAMED -- the file is present and awk could not read it.
#   * A non-numeric answer is refused too, since `END { print n + 0 }` prints a number whenever the
#     program runs at all; anything else means it did not.
count_file() {
  LC_ALL=C awk '
    { line = $0
      sub(/^[ \t]+/, "", line)
      if (substr(line, 1, 2) != "//") next
      s = $0
      for (i = 1; i <= length(s); i++) if (substr(s, i, 1) ~ /[\300-\377]/) n++
    }
    END { print n + 0 }
  ' "$1"
}


# A TRAILING COMMENT IS A COMMENT, and until `20260908.232949` no meter in this tree could see one.
# The header above excludes it with a reason about capability rather than about subject -- "finding
# it needs to know whether a `//` sits inside a string, which is parsing rather than scanning" --
# and that capability now exists here, in the walk below. It was written for
# `tools/fixtures/r/rye_spoken_ascii_scan.sh` on `20260908.214712`, which tracks parenthesis depth
# outside string literals over the same 1,730 sources, and which already finds this exact `//` and
# steps past it because a comment is this meter's room rather than its own.
#
# THE GAP IS AN ESCAPE HATCH RATHER THAN A BLIND SPOT, and that is what earns the second reading.
# Moving an own-line `//` comment onto the end of the preceding code line removes every character
# it carries from the numerator above, converts nothing, and reads as a sweep. The arc in the
# ceiling comment records the reverse move happening by accident: `20260828.134500` promoted three
# em dashes from trailing comments to their own lines and the count ROSE. The same door swings both
# ways, and one direction lowers a ratchet for free.
#
# MEASURED `20260908.232949` over the same 1,730 tracked sources, after this lap swept its own lane
# (mantra and tally, 8 characters in 5 files) to zero: 1,311 characters across 366 files. Against
# the 3,772 the reading above counts, roughly one comment character in four stood outside every
# meter.
#
# TWO READINGS RATHER THAN ONE MERGED NUMBER, for two reasons. A single number would need a ceiling
# of 5,083, which reads as a raise however it is explained, and the ceiling above must stay exactly
# 3,794 with its arc intact. And two gated numbers close the hatch by themselves: a comment moved
# from one position to the other lowers one reading and RAISES the other, so the receiving ceiling
# refuses. Neither number can be improved by moving a character.
#
# WHAT COUNTS: a `//` that opens a comment on a line whose first non-blank is NOT `//`, found with
# the same string, raw-string, and character-literal awareness the spoken meter uses -- so the `//`
# inside `"https://"` is passed over rather than counted. That case stands in the tree today, at
# `tools/rye/session_logs_archive.rye:311`, and the control plants it.
#
# The ceiling only falls. Lower it whenever a lap converts trailing comments; never raise it.
#   1319  `20260908.232949`  the reading before this lap swept its own lane
#   1311  `20260908.232949`  after mantra and tally were converted to zero, first resident
#   1307  `20260910.114040`  amphora's four trailing em dashes converted while `src/main.rye` was
#                            open for the ferry repair -- the module's own-line comments fell zero,
#                            so only this reading moved
TRAIL_CEILING=1307

count_trailing() {
  LC_ALL=C awk '
    { s = $0
      len = length(s)
      i = 1
      in_str = 0
      in_raw = 0
      # An own-line comment belongs to the reading above; counting it here would charge one
      # character to two ceilings and make each number depend on the other.
      lead = s
      sub(/^[ \t]+/, "", lead)
      if (substr(lead, 1, 2) == "//") next
      while (i <= len) {
        c = substr(s, i, 1)
        if (in_str) {
          if (c == "\\") { i += 2; continue }
          if (c == "\"") { in_str = 0; i++; continue }
          i++
          continue
        }
        # A raw multiline string runs to the end of the line and holds no closing quote.
        if (in_raw) { i++; continue }
        if (c == "\\" && substr(s, i + 1, 1) == "\\") { in_raw = 1; i += 2; continue }
        if (c == "/" && substr(s, i + 1, 1) == "/") {
          for (k = i; k <= len; k++) if (substr(s, k, 1) ~ /[\300-\377]/) n++
          break
        }
        if (c == "\"") { in_str = 1; i++; continue }
        # A character literal may hold a quote or a slash, so it is stepped over whole.
        if (c == "\047") {
          i++
          while (i <= len) {
            ch = substr(s, i, 1)
            if (ch == "\\") { i += 2; continue }
            if (ch == "\047") { i++; break }
            i++
          }
          continue
        }
        i++
      }
    }
    END { print n + 0 }
  ' "$1"
}

# A number that is not a number means the awk never ran -- REDS %513, learned by every sibling here.
check_number() {
  case "$1" in
    '' | *[!0-9]*)
      echo "instrument=failed"
      echo "detail=awk_answered_no_number"
      echo "detail_path=$2"
      echo "verdict=misread"
      exit 1
      ;;
  esac
}

total=0
trail_total=0
files=0
trail_files=0
absent=0
opened=0
report=""
trail_report=""
for f in $list; do
  # A link and its target are two paths and one set of bytes; the target is read on its own row.
  [ -L "$f" ] && continue
  if [ ! -f "$f" ]; then
    absent=$((absent + 1))
    continue
  fi
  opened=$((opened + 1))
  n=$(count_file "$f") || {
    echo "instrument=failed"
    echo "detail=awk_refused_a_file"
    echo "detail_path=$f"
    echo "verdict=misread"
    exit 1
  }
  check_number "$n" "$f"
  t=$(count_trailing "$f") || {
    echo "instrument=failed"
    echo "detail=awk_refused_a_file"
    echo "detail_path=$f"
    echo "verdict=misread"
    exit 1
  }
  check_number "$t" "$f"
  if [ "$n" -gt 0 ]; then
    files=$((files + 1))
    total=$((total + n))
    report="$report$n $f
"
  fi
  if [ "$t" -gt 0 ]; then
    trail_files=$((trail_files + 1))
    trail_total=$((trail_total + t))
    trail_report="$trail_report$t $f
"
  fi
done

if [ "$mode" = "--list" ]; then
  printf '%s' "$report" | sort -rn | head -40
  echo "-- trailing --"
  printf '%s' "$trail_report" | sort -rn | head -40
fi

if [ "$total" -le "$CEILING" ]; then under=yes; else under=no; fi
# The key is spelled `trail_ceiling_ok` rather than a second `under_ceiling`, because a reader --
# and every `case` pattern in the control -- must be able to match one reading without catching the
# other as a substring.
if [ "$trail_total" -le "$TRAIL_CEILING" ]; then trail_ok=yes; else trail_ok=no; fi
echo "instrument=ok"
echo "RYE_COMMENT_ASCII files=$files chars=$total opened=$opened absent=$absent ceiling=$CEILING under_ceiling=$under"
echo "RYE_TRAILING_COMMENT_ASCII files=$trail_files chars=$trail_total ceiling=$TRAIL_CEILING trail_ceiling_ok=$trail_ok"
