#!/bin/sh
# tools/fixtures/g/glow_literal_law_scan.sh -- how many answers does Glow give for `007`?
#
# WHY. A decimal literal is part of a language's meaning, so every reader of one inside a
# language implementation must agree about what it accepts. Glow has fourteen of them, and on
# 20260908 they gave two answers: `glow/rune_shop_gate.rye` refuses a leading zero and calls
# that refusal "the house parse law" in its own comment, while the other thirteen accept `007`
# and read it as 7. Proven on metal the same day, through both public entries:
#
#   ?:  (gth a b)  007  1     -> rune_shop_gate.parse_source refuses (MalformedBody)
#   =.  root  007             -> lower_mutate lowers `root = 7`
#
# So the same lap can write a leading zero into one rune and have it refused, write it into
# another and have it accepted, with no seated law saying which is right.
#
# WHAT IS GATED, AND WHY IT IS THIS READING. The gate is `disagreement`, which is
# min(strict, permissive) -- the size of the minority. It is zero when the language agrees and
# it falls under EITHER ruling: making the thirteen strict drives it to zero, and so does
# making the one permissive. A ceiling on `permissive` alone would refuse half the possible
# answers, and a guard that reds on a correct repair is a guard somebody turns off.
#
# The language question itself stays Keaton's -- a rune is earned by a law, and so is a
# literal. This scan decides nothing; it holds the split from widening while the word is out.
#
# WHAT A READER IS. Two shapes, both counted in PROGRAM position by
# tools/fixtures/t/tame_style_app_sites.sh, which is read rather than reimplemented here:
#
#   `* 10 + `      a hand-rolled digit accumulator      11 sites
#   `parseInt(`    the inherited std parser              3 sites
#
# Program position matters twice over in this room. `glow/lower_shop_gate.rye` EMITS the text
# `std.fmt.parseInt(u32, argv[1], 10)` into the Rye it generates -- 79 such lines -- and those
# are what a lowered program will call, never what the compiler calls. Counting them would
# read the compiler's output as the compiler's own code.
#
# WHAT A REFUSAL IS. The one spelling this tree writes, `[0] == '0'`, also in program position.
# A third spelling would read as permissive, so the count can run LOW; the header of any new
# reader is where that gets caught, and `--detail` prints the per-file split for reading.
#
# THE FILE IS THE UNIT, AND THAT IS MEASURED RATHER THAN ASSUMED. A file holding two readers
# where only one refuses would read as strict. `readers_max_per_file` reports the largest
# reader count in any one file; while it reads 1 the file and the reader are the same unit,
# and when it rises the classification wants splitting by function.
#
# USAGE
#   sh tools/fixtures/g/glow_literal_law_scan.sh [--detail]

set -u

detail=no
[ "${1:-}" = "--detail" ] && detail=yes

sites="tools/fixtures/t/tame_style_app_sites.sh"
if [ ! -f "$sites" ]; then
  echo "glow_literal_law: missing $sites -- the program-position reading has no source" >&2
  exit 2
fi

readers=0
strict=0
permissive=0
max_per_file=0
detail_lines=""

for f in $(git ls-files 'glow/*.rye' | grep -v '_witness\.rye$'); do
  acc=$(sh "$sites" '* 10 + ' "$f")
  pi=$(sh "$sites" 'parseInt(' "$f")
  n=$((acc + pi))
  [ "$n" -eq 0 ] && continue
  ref=$(sh "$sites" "[0] == '0'" "$f")
  readers=$((readers + n))
  [ "$n" -gt "$max_per_file" ] && max_per_file=$n
  if [ "$ref" -gt 0 ]; then
    strict=$((strict + 1))
    verdict=strict
  else
    permissive=$((permissive + 1))
    verdict=permissive
  fi
  detail_lines="${detail_lines}reader $f $verdict readers=$n refusals=$ref
"
done

if [ "$strict" -lt "$permissive" ]; then
  disagreement=$strict
else
  disagreement=$permissive
fi

[ "$detail" = yes ] && printf '%s' "$detail_lines"

echo "reader_files=$((strict + permissive))"
echo "readers=$readers"
echo "strict=$strict"
echo "permissive=$permissive"
echo "disagreement=$disagreement"
echo "readers_max_per_file=$max_per_file"
if [ "$disagreement" -eq 0 ]; then
  echo "verdict=agreed"
else
  echo "verdict=split"
fi
