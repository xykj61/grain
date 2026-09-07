#!/bin/sh
# tools/fixtures/g/glow_comment_ascii_control.sh -- the Glow comment line is proven, not assumed.
#
# WHY. Both sibling controls exist because a comment scan that reads program content as prose will
# drive a sweep that changes what a program does. The Rye one learned it at a `\\` multiline string;
# the shell one learned it at a heredoc body. Glow's own tokenizer settles the same question by
# refusing a newline inside a cord literal (`glow/tokens.rye:239`), so this meter needs no escape
# hatch. That is an argument. An argument is not a measurement, so every reading below is planted in
# a throwaway git repository and proven from both sides before the meter is trusted on 451 real
# sources.
#
# KIN. The meter is `tools/fixtures/g/glow_comment_ascii_scan.sh`. The guard over all three meters is
# `tools/as/ascii_comment_witness.rish`. The law is `.claude/rules/ascii-first.md`. The siblings are
# `tools/fixtures/r/rye_comment_ascii_control.sh` and `tools/fixtures/s/shell_comment_ascii_control.sh`,
# and this file follows their shape on purpose: one family, one set of habits.
#
# WHAT IS PROVEN -- fourteen behaviors, each a claim the scan makes out loud:
#    1  a `::` comment with non-ASCII is counted
#    2  an indented `::` comment is counted, so leading whitespace does not hide prose
#    3  a comment on a desk that also holds real Glow lines is counted
#    4  a CORD LITERAL is NOT counted -- that is program content, and it is the shape both siblings
#       exist to dodge. Here the language forbids a cord crossing a line, and this plant proves the
#       meter agrees with the language rather than merely inheriting its promise.
#    5  a `::` sitting INSIDE a cord literal on a code line is not counted. This is the same reading
#       from the other side: a naive "any `::` on this line" test would read a cord as prose.
#    6  a bare rune line with no comment contributes nothing
#    7  a trailing `::` after code is NOT counted -- the deliberate undercount, named in the scan
#    8  and that undercount is REPORTED rather than silent: `trailing_unread` rises with it
#    9  the vendored rooms are left out, since those files are not ours to convert
#   10  a SYMLINK to a counted source is not counted a second time (REDS %340)
#   11  and the target it points at is still counted on its own row, so the skip drops a duplicate
#       rather than a file
#   12  a BROKEN INSTRUMENT is named rather than counted as a clean zero. With its awk program
#       refused, the meter must say `instrument=failed`, and it must not answer `under_ceiling=yes`.
#   13  a present file the meter cannot OPEN is named by the same check and a different cause
#   14  a path `git ls-files` lists and the working tree no longer holds is skipped and COUNTED,
#       never fatal -- a rename staged mid-rebase is ordinary work
#
# Four of those fourteen are proven by an expected `no`, so this pen prints FEWER `=yes` lines than
# it proves behaviors. The witness counts the lines rather than reciting a total, which is the right
# habit for a number that grows; the list above is the hand count of what is asserted.
#
# AND THE CEILING, FROM BOTH SIDES. A refusal proven only in the passing direction cannot be told
# from a bypass. So the pen is pushed one character over the ceiling and read again, then the plant
# is removed and the reading must return to green. There is no override.
#
# USAGE
#   sh tools/fixtures/g/glow_comment_ascii_control.sh
#
# Run from the repository root; it reads only the scan script from there.

set -u

scan=$PWD/tools/fixtures/g/glow_comment_ascii_scan.sh
[ -r "$scan" ] || { echo "control_verdict=no_scan"; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
cd "$pen" || exit 1
git init -q . 2>/dev/null
git config user.email c@example.invalid; git config user.name control

mkdir -p room vendor/theirs

em='\xe2\x80\x94'

# One non-ASCII character in each position, so the total itself names which readings fired.
printf "::  a Glow comment $em one\n"                        > room/comment.glow
printf "    ::  indented $em one\n"                          > room/indented.glow
printf "::  header $em one\n|=  sample=@u32\n"               > room/with_code.glow
printf "rows='a $em b'\n"                                    > room/cord.glow
printf "rows='a :: $em b'\n"                                 > room/cord_marker.glow
printf "|=  sample=@u32\n%%-  double  sample\n"              > room/bare.glow
printf "|=  sample=@u32  ::  trailing $em one\n"             > room/trailing.glow
printf "::  theirs $em one\n"                                > vendor/theirs/x.glow

# A link beside its target, the shape `tools/rye/sha3.rye` took on `20260829` one language over.
# This tree tracks no symlinked `.glow` today, so the reading is planted rather than waited for.
ln -s comment.glow room/link_to_comment.glow
git add -A >/dev/null 2>&1; git commit -qm plant >/dev/null 2>&1

out=$(sh "$scan" --list 2>/dev/null)
echo "$out" | grep '^GLOW_COMMENT_ASCII'

for name in comment.glow indented.glow with_code.glow; do
  key=$(printf '%s' "$name" | sed 's/\..*$//')
  echo "$out" | grep -q "room/$name" && echo "${key}_counted=yes" || echo "${key}_counted=no"
done
for name in cord.glow cord_marker.glow bare.glow trailing.glow; do
  key=$(printf '%s' "$name" | sed 's/\..*$//')
  echo "$out" | grep -q "room/$name" && echo "${key}_counted=yes" || echo "${key}_counted=no"
done
case "$out" in *"vendor/theirs"*) echo "vendor_excluded=no";; *) echo "vendor_excluded=yes";; esac

# The symlink is tracked and resolves to a counted comment, so a meter that follows it reads four.
case "$out" in *"room/link_to_comment.glow"*) echo "symlink_skipped=no";; *) echo "symlink_skipped=yes";; esac
case "$out" in *"room/comment.glow"*) echo "symlink_target_kept=yes";; *) echo "symlink_target_kept=no";; esac

# Three prose files, one character each, and nothing else -- four would mean the link was followed,
# and five or more would mean a cord was read as prose.
case "$out" in *"chars=3 "*) echo "total_is_three=yes";; *) echo "total_is_three=no";; esac

# The undercount is REPORTED rather than silent. Two files carry a `::` away from the line start --
# the trailing comment and the cord holding the mark -- so the meter must say it saw two it did not
# read. A blind spot nobody can measure is the same blind spot with better manners.
case "$out" in *"trailing_unread=2"*) echo "trailing_reported=yes";; *) echo "trailing_reported=no";; esac

case "$out" in *"under_ceiling=yes"*) echo "clean_pen_under_ceiling=yes";; *) echo "clean_pen_under_ceiling=no";; esac

# The ceiling, from the refusing side. The scan's own ceiling is read rather than spelled here, so
# this stays true when a lap lowers it.
ceiling=$(printf '%s' "$out" | sed -n 's/.* ceiling=\([0-9][0-9]*\) .*/\1/p')
over=$((ceiling + 1))
{ printf ':: '; i=0; while [ "$i" -lt "$over" ]; do printf "$em"; i=$((i + 1)); done; printf '\n'; } > room/over.glow
git add -A >/dev/null 2>&1
loud=$(sh "$scan" 2>/dev/null)
echo "$loud" | sed 's/^/over_/'
case "$loud" in *"under_ceiling=no"*) echo "over_ceiling_refuses=yes";; *) echo "over_ceiling_refuses=no";; esac

rm -f room/over.glow
git add -A >/dev/null 2>&1
back=$(sh "$scan" 2>/dev/null)
case "$back" in *"under_ceiling=yes"*) echo "removed_returns_green=yes";; *) echo "removed_returns_green=no";; esac


# -- THE INSTRUMENT ITSELF, three readings (REDS %513) --------------------------------------------
#
# Every reading above asks what the meter COUNTED; none asked whether it READ anything at all. An
# empty answer from a refused read is byte-identical to an empty answer from a clean file.

# 12  A BROKEN INSTRUMENT IS NAMED, never counted as a clean zero. The scan is copied into the pen
#     with one unclosed `if (` inserted at the head of its awk program -- a syntax error in every
#     awk dialect, so this leg leans on no one implementation.
awk 'BEGIN{d=0} {print} (d==0 && $0 ~ /^  LC_ALL=C awk/) {print "    if ("; d=1}' "$scan" > broken_scan.sh
broke=$(sh ./broken_scan.sh 2>/dev/null)
case "$broke" in *"instrument=failed"*) echo "broken_instrument_named=yes";; *) echo "broken_instrument_named=no";; esac
case "$broke" in *"under_ceiling=yes"*) echo "broken_instrument_refuses=no";; *) echo "broken_instrument_refuses=yes";; esac
rm -f broken_scan.sh

# 13  AN UNREADABLE FILE IS NAMED, by the same check and a different cause. `chmod 000` is toothless
#     for a privileged reader, so the block is PROBED rather than assumed: where it does not bite,
#     the leg says so by name and passes, because a control that reds on an environment it cannot
#     test is a control somebody turns off.
printf ":: locked $em one\n" > room/locked.glow
git add -A >/dev/null 2>&1
chmod 000 room/locked.glow
if cat room/locked.glow >/dev/null 2>&1; then
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
chmod 644 room/locked.glow
rm -f room/locked.glow
git add -A >/dev/null 2>&1

# 14  AN ABSENT FILE IS SKIPPED AND COUNTED, never fatal. `git ls-files` reads the INDEX, so a
#     rename staged mid-lap lists a path the working tree no longer holds -- and a rebase is
#     exactly the moment a reading is worth having.
printf ":: ghost $em one\n" > room/ghost.glow
git add -A >/dev/null 2>&1
rm -f room/ghost.glow
ghost=$(sh "$scan" 2>/dev/null)
case "$ghost" in *"absent=1"*) echo "absent_counted=yes";; *) echo "absent_counted=no";; esac
case "$ghost" in *"instrument=failed"*) echo "absent_is_fatal=yes";; *) echo "absent_is_fatal=no";; esac
git rm -q --cached room/ghost.glow >/dev/null 2>&1

echo "control_verdict=ok"
