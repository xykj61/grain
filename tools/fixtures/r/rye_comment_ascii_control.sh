#!/bin/sh
# tools/fixtures/r/rye_comment_ascii_control.sh -- the comment/string line is proven, not assumed.
#
# WHY. This meter exists to drive a sweep, and a sweep that miscounts a string as a comment would
# rewrite what a program prints. That already happened once by hand: a blanket `sed` over one module
# converted nine string literals along with its comments, including a header written into a file. So
# the reading is planted in a throwaway git repository and proven from both sides before it is
# trusted on 1,497 real files.
#
# WHAT IS PROVEN -- twelve behaviors:
#   1  a `//` comment with non-ASCII is counted
#   2  a `///` declaration comment is counted -- it is prose too
#   3  a `//!` module comment is counted
#   4  a `\\` multiline-string line is NOT counted -- that is program output
#   5  a string literal on a code line is NOT counted, for the same reason
#   6  an indented comment is counted, so leading whitespace does not hide prose
#   7  the vendored rooms are left out, since those files are not ours to convert
#   8  a SYMLINK to a counted module is not counted a second time -- `git ls-files` lists a link
#      and its target as two paths, and following both counts one set of bytes twice (REDS %340)
#   9  and the target it points at is still counted on its own row, so the skip drops a duplicate
#      rather than a file
#  10  a meter whose awk fails says `instrument=failed`
#  11  and it never also reads green
#  12  a file it cannot open is named; a path git lists and the tree lacks is skipped
#
# AND THE CEILING, FROM BOTH SIDES, as its shell sibling has kept all along. The pen is pushed one
# character past the scan's own ceiling and read again, then the plant is removed and the reading
# must return green. There is no override.
#
# USAGE
#   sh tools/fixtures/r/rye_comment_ascii_control.sh
#
# Run from the repository root; it reads only the scan script from there.

set -u

scan=$PWD/tools/fixtures/r/rye_comment_ascii_scan.sh
[ -r "$scan" ] || { echo "control_verdict=no_scan"; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
cd "$pen" || exit 1
git init -q . 2>/dev/null
git config user.email c@example.invalid; git config user.name control

mkdir -p room vendor/theirs

# one non-ASCII character in each position, so the count itself names which readings fired
printf '// a line comment \xe2\x80\x94 one\n'            > room/line_comment.rye
printf '/// a doc comment \xe2\x80\x94 one\n'            > room/doc_comment.rye
printf '//! a module comment \xe2\x80\x94 one\n'         > room/module_comment.rye
printf 'const s =\n    \\\\printed \xe2\x80\x94 output\n' > room/multiline_string.rye
printf 'const s = "printed \xe2\x80\x94 output";\n'      > room/string_literal.rye
printf '        // indented \xe2\x80\x94 one\n'          > room/indented.rye
printf '// theirs \xe2\x80\x94 one\n'                    > vendor/theirs/x.rye

# The eighth and ninth readings: a link beside its target, exactly the shape `tools/rye/sha3.rye`
# took on 20260829. Both paths are tracked, both resolve to the same bytes, and only one may count.
ln -s line_comment.rye room/link_to_line_comment.rye

git add -A >/dev/null 2>&1; git commit -qm plant >/dev/null 2>&1

out=$(sh "$scan" --list 2>/dev/null)
echo "$out" | grep '^RYE_COMMENT_ASCII'

for name in line_comment doc_comment module_comment indented; do
  echo "$out" | grep -q "room/$name.rye" && echo "${name}_counted=yes" || echo "${name}_counted=no"
done
for name in multiline_string string_literal; do
  echo "$out" | grep -q "room/$name.rye" && echo "${name}_counted=yes" || echo "${name}_counted=no"
done
case "$out" in *"vendor/theirs"*) echo "vendor_excluded=no";; *) echo "vendor_excluded=yes";; esac

# The symlink is tracked and resolves to a counted comment, so a meter that follows it reads five.
case "$out" in *"room/link_to_line_comment.rye"*) echo "symlink_skipped=no";; *) echo "symlink_skipped=yes";; esac
# And the skip drops the duplicate rather than the file: the target still counts on its own row.
case "$out" in *"room/line_comment.rye"*) echo "symlink_target_kept=yes";; *) echo "symlink_target_kept=no";; esac

# four prose files, one character each, and nothing else -- five would mean the link was followed
case "$out" in *"chars=4 "*) echo "total_is_four=yes";; *) echo "total_is_four=no";; esac
case "$out" in *"under_ceiling=yes"*) echo "clean_pen_under_ceiling=yes";; *) echo "clean_pen_under_ceiling=no";; esac

# THE CEILING, FROM BOTH SIDES -- the reading this control lacked while its shell sibling kept it.
# A refusal proven only in the passing direction cannot be told from a bypass: a ceiling no pen has
# ever crossed may be a number nothing reads. The scan's own ceiling is read out of its output
# rather than spelled here, so this stays true on the next lap that lowers it.
ceiling=$(printf '%s' "$out" | grep "^RYE_COMMENT_ASCII" | sed -n 's/.* ceiling=\([0-9][0-9]*\) .*/\1/p')
over=$((ceiling + 1))
{ printf '// '; i=0; while [ "$i" -lt "$over" ]; do printf '\xe2\x80\x94'; i=$((i + 1)); done; printf '\n'; } > room/over.rye
git add -A >/dev/null 2>&1
loud=$(sh "$scan" 2>/dev/null)
echo "$loud" | sed 's/^/over_/'
case "$loud" in *"under_ceiling=no"*) echo "over_ceiling_refuses=yes";; *) echo "over_ceiling_refuses=no";; esac

rm -f room/over.rye
git add -A >/dev/null 2>&1
back=$(sh "$scan" 2>/dev/null)
case "$back" in *"under_ceiling=yes"*) echo "removed_returns_green=yes";; *) echo "removed_returns_green=no";; esac


# -- THE INSTRUMENT ITSELF, three readings (REDS %513) --------------------------------------------
#
# A GUARD THAT CANNOT RUN ITS INSTRUMENT MUST SAY SO. Every reading above asks what the meter
# COUNTED; none asked whether it READ anything at all. The elder loop ran its awk under
# `2>/dev/null` and then wrote `[ -z "$n" ] && n=0`, so awk's exit status was never examined and
# its complaint was discarded -- and an empty answer from a refused read is byte-identical to an
# empty answer from a clean file. The second is the one everyone hopes for.

# 16  A BROKEN INSTRUMENT IS NAMED, never counted as a clean zero. The scan is copied into the pen
#     with one unclosed `if (` inserted at the head of its awk program -- a syntax error in every
#     awk dialect, so this leg leans on no one implementation. Measured before the repair: the
#     meter answered `files=0 chars=0 under_ceiling=yes` over every tracked source it never
#     opened, which on a meter sitting AT its ceiling reads as the largest sweep it ever recorded.
awk 'BEGIN{d=0} {print} (d==0 && $0 ~ /^  LC_ALL=C awk/) {print "    if ("; d=1}' "$scan" > broken_scan.sh
broke=$(sh ./broken_scan.sh 2>/dev/null)
case "$broke" in *"instrument=failed"*) echo "broken_instrument_named=yes";; *) echo "broken_instrument_named=no";; esac
case "$broke" in *"under_ceiling=yes"*) echo "broken_instrument_refuses=no";; *) echo "broken_instrument_refuses=yes";; esac
rm -f broken_scan.sh

# 17  AN UNREADABLE FILE IS NAMED, by the same check and a different cause. `chmod 000` is toothless
#     for a privileged reader, so the block is PROBED rather than assumed: where it does not bite,
#     the leg says so by name and passes, because a control that reds on an environment it cannot
#     test is a control somebody turns off. The diagnostic key is printed either way.
printf '// locked $em one\n' > room/locked.rye
git add -A >/dev/null 2>&1
chmod 000 room/locked.rye
if cat room/locked.rye >/dev/null 2>&1; then
  echo "unreadable_probe=readable_anyway"
  echo "unreadable_verdict=ok_skipped_privileged"
else
  echo "unreadable_probe=blocked"
  locked=$(sh "$scan" 2>/dev/null)
  case "$locked" in
    *"instrument=failed"*) echo "unreadable_verdict=ok";;
    *) echo "unreadable_verdict=no -- counted a zero for a file it could not open";;
  esac
fi
chmod 644 room/locked.rye
rm -f room/locked.rye
git add -A >/dev/null 2>&1

# 18  AN ABSENT FILE IS SKIPPED AND COUNTED, never fatal. `git ls-files` reads the INDEX, so a
#     rename staged mid-lap lists a path the working tree no longer holds -- and a rebase is
#     exactly the moment a reading is worth having. Refusing there would trade one blindness for
#     an outage.
printf '// ghost $em one\n' > room/ghost.rye
git add -A >/dev/null 2>&1
rm -f room/ghost.rye
ghost=$(sh "$scan" 2>/dev/null)
case "$ghost" in *"absent=1"*) echo "absent_counted=yes";; *) echo "absent_counted=no";; esac
case "$ghost" in *"instrument=failed"*) echo "absent_is_fatal=yes";; *) echo "absent_is_fatal=no";; esac
git rm -q --cached room/ghost.rye >/dev/null 2>&1


# -- THE TRAILING COMMENT, six readings (seated `20260908.232949`) --------------------------------
#
# A trailing comment is a comment, and until this lap no meter in this tree could see one. The gap
# is an ESCAPE HATCH rather than a blind spot: moving an own-line comment onto the end of the
# preceding code line drops every character it carries out of the numerator, converts nothing, and
# reads as a sweep. Both halves are proven below -- that the reading finds a trailing comment, and
# that the move it was blind to now refuses.

cd "$pen" || exit 1
rm -rf room/trail && mkdir -p room/trail

# 19  A TRAILING COMMENT IS COUNTED, by the new reading.
printf 'const a: u32 = 1; // trailing \xe2\x80\x94 one\n' > room/trail/trailing.rye
# 21  A `//` INSIDE A STRING IS NOT A COMMENT. This exact shape stands in the tree today, at
#     `tools/rye/session_logs_archive.rye:311`, and a scanner without string awareness reads the
#     em dash after it as prose.
printf 'const u = "https://x \xe2\x80\x94 y";\n' > room/trail/in_string.rye
# 22  A CHARACTER LITERAL HOLDING A QUOTE MUST NOT FLIP THE STRING STATE. Without the
#     character-literal step, the `"` here opens a string that never closes, and the comment after
#     it disappears.
printf 'const q: u8 = '"'"'"'"'"'; // quote char \xe2\x80\x94 one\n' > room/trail/char_literal.rye
git add -A >/dev/null 2>&1
tout=$(sh "$scan" --list 2>/dev/null)
trail_block=$(printf '%s' "$tout" | sed -n '/^-- trailing --$/,$p')
own_block=$(printf '%s' "$tout" | sed -n '1,/^-- trailing --$/p')

printf '%s' "$tout" | grep '^RYE_TRAILING_COMMENT_ASCII'
case "$trail_block" in *"room/trail/trailing.rye"*) echo "trailing_counted=yes";; *) echo "trailing_counted=no";; esac
# 20  AND IT IS NOT CHARGED TWICE. One character belongs to one ceiling, or each reading depends on
#     the other and neither can be lowered on its own evidence.
case "$own_block" in *"room/trail/trailing.rye"*) echo "trailing_double_counted=yes";; *) echo "trailing_double_counted=no";; esac
case "$trail_block" in *"room/trail/in_string.rye"*) echo "string_slash_counted=yes";; *) echo "string_slash_counted=no";; esac
case "$trail_block" in *"room/trail/char_literal.rye"*) echo "char_literal_trailing_counted=yes";; *) echo "char_literal_trailing_counted=no";; esac

# 23  THE HATCH, MEASURED. The same three characters are written first as an own-line comment and
#     then trailing a line of code. Before this reading existed the second spelling read as a sweep
#     of three; now one number falls, the other rises, and their SUM does not move.
rm -rf room/trail && mkdir -p room/trail
printf '// moved \xe2\x80\x94\xe2\x80\x94\xe2\x80\x94 three\nconst a: u32 = 1;\n' > room/trail/hatch.rye
git add -A >/dev/null 2>&1
before=$(sh "$scan" 2>/dev/null)
own_before=$(printf '%s' "$before" | grep '^RYE_COMMENT_ASCII' | sed -n 's/.*chars=\([0-9][0-9]*\) .*/\1/p')
trail_before=$(printf '%s' "$before" | grep '^RYE_TRAILING_COMMENT_ASCII' | sed -n 's/.*chars=\([0-9][0-9]*\) .*/\1/p')
printf 'const a: u32 = 1; // moved \xe2\x80\x94\xe2\x80\x94\xe2\x80\x94 three\n' > room/trail/hatch.rye
git add -A >/dev/null 2>&1
after=$(sh "$scan" 2>/dev/null)
own_after=$(printf '%s' "$after" | grep '^RYE_COMMENT_ASCII' | sed -n 's/.*chars=\([0-9][0-9]*\) .*/\1/p')
trail_after=$(printf '%s' "$after" | grep '^RYE_TRAILING_COMMENT_ASCII' | sed -n 's/.*chars=\([0-9][0-9]*\) .*/\1/p')
echo "hatch_own_before=$own_before hatch_own_after=$own_after"
echo "hatch_trail_before=$trail_before hatch_trail_after=$trail_after"
[ "$((own_before - own_after))" -eq 3 ] && echo "hatch_own_falls_by_three=yes" || echo "hatch_own_falls_by_three=no"
[ "$((trail_after - trail_before))" -eq 3 ] && echo "hatch_trail_rises_by_three=yes" || echo "hatch_trail_rises_by_three=no"
[ "$((own_before + trail_before))" -eq "$((own_after + trail_after))" ] && echo "hatch_sum_invariant=yes" || echo "hatch_sum_invariant=no"

# 24  AND THE ELDER READING, RUN OVER THE SAME MOVE, CALLS IT A SWEEP. A repair proven only by the
#     new number cannot be told from a number that was always there, so the pre-repair meter is
#     rebuilt in the pen -- its own-line counter alone -- and shown reading the hatch as a fall.
elder_own=$(LC_ALL=C awk '
  { line = $0; sub(/^[ \t]+/, "", line)
    if (substr(line, 1, 2) != "//") next
    for (i = 1; i <= length($0); i++) if (substr($0, i, 1) ~ /[\300-\377]/) n++ }
  END { print n + 0 }' room/trail/hatch.rye)
[ "$elder_own" -eq 0 ] && echo "elder_reads_hatch_as_swept=yes" || echo "elder_reads_hatch_as_swept=no"

# 25  THE TRAILING CEILING, FROM BOTH SIDES. A refusal proven only in the passing direction cannot
#     be told from a bypass, so the pen is pushed one character past the scan's own trailing ceiling
#     and read again, then the plant is removed and the reading must return green.
trail_ceiling=$(printf '%s' "$after" | grep '^RYE_TRAILING_COMMENT_ASCII' | sed -n 's/.* ceiling=\([0-9][0-9]*\) .*/\1/p')
tover=$((trail_ceiling + 1))
{ printf 'const b: u32 = 2; // '; i=0; while [ "$i" -lt "$tover" ]; do printf '\xe2\x80\x94'; i=$((i + 1)); done; printf '\n'; } > room/trail/over.rye
git add -A >/dev/null 2>&1
tloud=$(sh "$scan" 2>/dev/null)
printf '%s' "$tloud" | grep '^RYE_TRAILING_COMMENT_ASCII' | sed 's/^/tover_/'
case "$tloud" in *"trail_ceiling_ok=no"*) echo "trail_over_ceiling_refuses=yes";; *) echo "trail_over_ceiling_refuses=no";; esac
# And the own-line reading is untouched by a trailing plant, so the two ceilings stand apart.
case "$tloud" in *"under_ceiling=yes"*) echo "own_ceiling_unmoved_by_trailing=yes";; *) echo "own_ceiling_unmoved_by_trailing=no";; esac
rm -f room/trail/over.rye
git add -A >/dev/null 2>&1
tback=$(sh "$scan" 2>/dev/null)
case "$tback" in *"trail_ceiling_ok=yes"*) echo "trail_removed_returns_green=yes";; *) echo "trail_removed_returns_green=no";; esac
rm -rf room/trail
git add -A >/dev/null 2>&1

echo "control_verdict=ok"
