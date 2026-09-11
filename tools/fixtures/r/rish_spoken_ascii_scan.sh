#!/bin/sh
# tools/fixtures/r/rish_spoken_ascii_scan.sh -- non-ASCII in what a Rishi guard SAYS out loud.
#
# WHY. `.claude/rules/ascii-first.md` governs prose, and the two meters holding it read COMMENTS:
# `tools/fixtures/s/shell_comment_ascii_scan.sh` for `#` in Rishi and shell,
# `tools/fixtures/r/rye_comment_ascii_scan.sh` for `//` in Rye. Both refuse to count "program
# content", and `tools/as/ascii_comment_witness.rish` states the reason in its own GREEN line:
# converting a string "changes what a program prints".
#
# THAT ONE EXCLUSION ANSWERS TWO QUESTIONS, and only one of the answers is right. Program content
# is genuinely two populations:
#   * a HEREDOC body, or a string a parser consumes -- what a program feeds ONWARD. Converting it
#     changes behavior, and excluding it is what makes a sweep safe. Kept excluded, here as there.
#   * a `say` line, or an `assert ... else` message -- prose a program SAYS TO A PERSON, on their
#     terminal and into `session-output/`. Converting it changes register rather than behavior,
#     and register is precisely what the ASCII-first rule governs.
# The elder line excluded both, so the law's own instrument is blind at the exact point where the
# law applies most plainly: a guard's spoken sentence.
#
# THE SIZE OF THE BLIND SPOT, measured `20260907.075500` over 2,388 tracked `.rish` sources -- the
# same files the comment meter opens, under the same law, on the same run:
#     505  characters the comment meter counts and holds (its ceiling)
#  11,154  characters this meter counts, in 6,847 spoken lines across 1,516 files
# Twenty-two times the enforced surface, read by nothing. Of those, 10,789 (96.7%) are the SIX
# forms the rule's own substitution table names and spells -- em dash 7,095, middle dot 2,788,
# ellipsis 665, right arrow 181, en dash 57, left-right arrow 5 -- and the remaining 365 is
# notation a reader should choose the ASCII form for rather than a script guessing it. The two are
# printed apart for exactly that reason: one number is a sweep, the other is a judgment.
#
# THE TABLE HAD ONE ROW FEWER THAN THE RULE, for the whole life of this meter, and the same
# disagreement had already been found and closed one instrument over. `.claude/rules/ascii-first.md`
# has spelled the TYPOGRAPHIC MINUS since it was seated -- one ASCII answer, `-`, no reader's
# judgment in it -- and `tools/fixtures/a/ascii_document_scan.sh` carries that row. This meter did
# not, so it filed 103 minus signs standing in arithmetic prose (`2^255 - 19`) under `notation`,
# where `notation` MEANS *a reader must choose*. Read `20260910.180158`: the split moves
# 10,707/365 -> 10,810/262 and the total is unchanged, since a classification fix moves no
# character. The law page states the lesson from its own firing: **a law and its instrument agreeing
# is a thing to measure rather than assume.** Its two spoken siblings,
# `tools/fixtures/r/rye_spoken_ascii_scan.sh` and `tools/fixtures/r/rye_spoken_ascii_convert.sh`,
# carry the same one-row gap and are named here rather than swept.
#
# WHAT LOWERS IT. `tools/fixtures/r/rish_spoken_ascii_convert.sh` converts exactly the forms
# classified above, inside exactly the regions counted below, so a file it rewrites falls in THIS
# reading by what it converted and moves no other meter. It holds back three things the count
# cannot: an assert's CONDITION, a `run [...]` argument, and a COUPLED SAYING -- a spoken line
# another runner matches on. That third exclusion has no sibling, and it is why this surface stood
# unswept while its two siblings were swept to zero: Rye's `print` and Glow's `::` speak to a person
# and to nobody else, while a Rishi `say` is also a wire between guards.
#
# WHAT COUNTS. A SPOKEN line is one whose first non-blank word is `say`, or one that begins
# `assert` and carries an `else "` message. Those are Rishi's two ways of putting a sentence in
# front of a reader, and both are prose by every test the rule applies.
#
# WHAT DOES NOT COUNT, and each line is drawn where counting would be wrong rather than merely hard:
#   * a `#` COMMENT -- the sibling meter's room, and counting it here would double one character
#     against two ceilings.
#   * every other line -- a `run [...]` argument, a `let` binding, an `if` condition. A grep
#     pattern searching for an em dash must CONTAIN an em dash, so counting those would ask the
#     tree's own guards to stop being able to find what they guard. Sixteen such patterns stand.
#   * a spoken sentence built from a variable (`say "text ${x}"` counts the literal text; a `say x`
#     counts nothing). Following the value is interpretation rather than scanning, so this meter
#     **UNDERCOUNTS on purpose**, the same way its comment sibling does at a trailing `#`.
#
# THE UNIT IS A CHARACTER, counted by its UTF-8 lead byte in the C locale, and the byte range is
# spelled in OCTAL -- both conventions inherited from the sibling meters, and both were bought with
# a red there. `\x00-\x7F` is a GNU awk extension the BWK awk parses as literal characters, and
# `LC_ALL=C` pins both awks to bytes so one em dash reads 1 under either.
#
# USAGE
#   sh tools/fixtures/r/rish_spoken_ascii_scan.sh          # count
#   sh tools/fixtures/r/rish_spoken_ascii_scan.sh --list   # name each file and its count, worst first
#
# Run from the repository root.

set -u

mode="${1:-count}"

# The ceiling only falls. Lower it whenever a lap converts spoken lines; never raise it.
# The arc, each figure measured rather than recalled:
#   11154  `20260907.075500`  across 1,516 files, the reading on the lap this meter was seated
#   11153  `20260910.054344`  one em dash in tools/b/bat_fleet_witness.rish's own `say` line
#   11152  `20260910.123000`  one em dash in tools/b/brix_infuse_witness.rish's `say` line, on touch
#                             while its module was swept. The reading stood at 11,073 -- EIGHTY below
#                             the ceiling, slack earned by laps that converted without lowering it --
#                             so this falls by exactly the one character removed and claims none of it.
#   10585  `20260910.180158`  the first sweep this surface has had, and the lap that built the tool
#                             for it. `tools/fixtures/r/rish_spoken_ascii_convert.sh` swept
#                             `tools/p/parity_ch01.rish` and `tools/p/parity_ch02.rish` -- 567
#                             characters, every one a form the rule's table spells -- and both files
#                             were RE-DERIVED from their committed bytes to prove that nothing but a
#                             spoken line moved. The reading fell 11,072 -> 10,505 and this falls
#                             with it, keeping the same 80 of slack it already stood on and taking
#                             none of the 567.
#   10584  `20260910.234500`  one em dash in the GREEN line of
#                             `tools/gen/amphora/amphora_asker_reply.rish`, converted on touch while
#                             its guard was run for the first time on this pier. Falls by exactly the
#                             one character removed and claims none of the 80 of slack.
#   10580  `20260911.003300`  four more in the same lane, on touch: the em dash and three middots in
#                             `tools/am/amphora_carry_negative_witness.rish`'s GREEN line, while its
#                             build reasons moved into their refusal messages. Checked first for a
#                             coupled saying -- no runner greps that line -- and falls by exactly the
#                             four removed.
#   10541  `20260911.003518`  nine mantra and tally gate witnesses swept ON TOUCH, in the lap that
#                             repaired their substring answer reads -- 44 characters, every one a
#                             form the rule's table spells, converted by the tool above with
#                             `held_coupled=0`, and all nine re-run GREEN afterwards so no
#                             cross-guard match was cut. The reading fell 10,505 -> 10,461 and this
#                             falls with it, keeping the same 80 of slack and taking none of the 44.
#   10536  `20260911`          the two sweeps above met in one rebase -- four amphora characters and
#                             forty-four mantra and tally ones -- and the reading fell to 10,456
#                             together. This falls with it, keeping the same 80 of slack.
CEILING=10536

# A symlink is skipped for the sibling's reason: `git ls-files` lists a link AND its target as two
# paths, and following both counts one set of bytes twice (REDS %340).
list=$(git ls-files "*.rish" 2>/dev/null | grep -vE "^(vendor|gratitude|seed)/")

# A GUARD THAT CANNOT RUN ITS INSTRUMENT MUST SAY SO -- REDS %513, learned by both siblings. The
# awk lives in a function so its exit status can be read: an empty answer from a refused read is
# byte-identical to an empty answer from a clean file, and the second is the one everyone hopes for.
count_file() {
  LC_ALL=C awk '
    {
      line = $0
      sub(/^[ \t]+/, "", line)
      if (substr(line, 1, 1) == "#") next
      spoken = 0
      if (line ~ /^say[ \t]/) spoken = 1
      else if (line ~ /^assert[ \t]/ && line ~ /[ \t]else[ \t]+"/) spoken = 1
      if (!spoken) next
      for (i = 1; i <= length($0); i++) {
        c = substr($0, i, 1)
        if (c ~ /[\300-\377]/) {
          n++
          # The forms the rule names and spells are reported apart from the notation tail: one
          # number is a mechanical sweep, the other is a reader choosing a word. The typographic
          # minus joined them `20260910.180158`, and it is the eighth entry rather than a seventh
          # spelling of one of the others.
          seq = c; j = i + 1
          while (j <= length($0) && substr($0, j, 1) ~ /[\200-\277]/) { seq = seq substr($0, j, 1); j++ }
          if (seq == "\342\200\224" || seq == "\342\200\223" || seq == "\302\267" ||
              seq == "\342\200\246" || seq == "\342\206\222" || seq == "\342\206\220" ||
              seq == "\342\206\224" || seq == "\342\210\222") t++
          i = j - 1
        }
      }
    }
    END { print (n + 0) " " (t + 0) }
  ' "$1"
}

total=0
table=0
files=0
absent=0
opened=0
report=""
for f in $list; do
  [ -L "$f" ] && continue
  if [ ! -f "$f" ]; then
    absent=$((absent + 1))
    continue
  fi
  opened=$((opened + 1))
  pair=$(count_file "$f") || {
    echo "instrument=failed"
    echo "detail=awk_refused_a_file"
    echo "detail_path=$f"
    echo "verdict=misread"
    exit 1
  }
  n=${pair% *}
  t=${pair#* }
  case "$n$t" in
    '' | *[!0-9]*)
      echo "instrument=failed"
      echo "detail=awk_answered_no_number"
      echo "detail_path=$f"
      echo "verdict=misread"
      exit 1
      ;;
  esac
  if [ "$n" -gt 0 ]; then
    files=$((files + 1))
    total=$((total + n))
    table=$((table + t))
    report="$report$n $f
"
  fi
done

if [ "$mode" = "--list" ]; then
  printf '%s' "$report" | sort -rn | head -40
fi

if [ "$total" -le "$CEILING" ]; then under=yes; else under=no; fi
echo "instrument=ok"
echo "RISH_SPOKEN_ASCII files=$files chars=$total table_forms=$table notation=$((total - table)) opened=$opened absent=$absent ceiling=$CEILING under_ceiling=$under"
