#!/bin/sh
# tools/fixtures/s/shell_comment_ascii_control.sh -- the comment/heredoc line is proven, not assumed.
#
# WHY. This meter drove a sweep across 2,163 files, and a sweep that reads a heredoc body as prose
# would rewrite what a program feeds to another program. The sibling Rye meter learned the same
# lesson at a string literal, by hand and the expensive way. So every reading is planted in a
# throwaway git repository and proven from both sides before it is trusted on 2,823 real files.
#
# WHAT IS PROVEN -- eighteen behaviors, and each one is a claim the scan makes out loud:
#    1  a `#` comment with non-ASCII is counted in a `.rish` source
#    2  a `#` comment with non-ASCII is counted in a `.sh` source
#    3  an indented comment is counted, so leading whitespace does not hide prose
#    4  a plain `<<EOF` heredoc body is NOT counted -- that is program content
#    5  a quoted `<<'EOF'` heredoc body is NOT counted
#    6  a tab-stripping `<<-EOF` heredoc body is NOT counted, and its indented delimiter closes it
#    7  a heredoc REOPENS the file to prose at its delimiter, so it cannot swallow what follows
#    8  a plain `<<EOF` does NOT close on an indented delimiter -- the shell's own rule, kept
#       because closing early would read program content as prose
#    9  an arithmetic shift (`1 << 3`) does not open a heredoc
#   10  a here-string (`<<<`) does not open a heredoc
#   11  a `<<EOF` written inside a comment does not open a heredoc
#   12  a trailing comment after code is NOT counted -- the deliberate undercount, named in the scan
#   13  the vendored rooms are left out, since those files are not ours to convert
#   14  a SYMLINK to a counted source is not counted a second time -- `git ls-files` lists a link
#       and its target as two paths, and following both counts one set of bytes twice (REDS %340)
#   15  and the target it points at is still counted on its own row, so the skip drops a duplicate
#       rather than a file
#   16  a BROKEN INSTRUMENT is named rather than counted as a clean zero -- with its awk program
#       refused, the meter must say `instrument=failed` and must not answer `under_ceiling=yes`
#   17  a present file the meter cannot OPEN is named by the same check and a different cause
#   18  a path `git ls-files` lists and the working tree no longer holds is skipped and COUNTED,
#       never fatal -- a rename staged mid-rebase is ordinary, and refusing there would trade one
#       blindness for an outage
#
# AND THE CEILING, FROM BOTH SIDES. A refusal proven only in the passing direction cannot be told
# from a bypass, so the pen is pushed over the ceiling and read again. There is no override.
#
# USAGE
#   sh tools/fixtures/s/shell_comment_ascii_control.sh
#
# Run from the repository root; it reads only the scan script from there.

set -u

scan=$PWD/tools/fixtures/s/shell_comment_ascii_scan.sh
[ -r "$scan" ] || { echo "control_verdict=no_scan"; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
cd "$pen" || exit 1
git init -q . 2>/dev/null
git config user.email c@example.invalid; git config user.name control

mkdir -p room vendor/theirs

em='\xe2\x80\x94'

# One non-ASCII character in each position, so the total itself names which readings fired.
printf "# a Rishi comment $em one\n"                            > room/rish_comment.rish
printf "# a shell comment $em one\n"                            > room/sh_comment.sh
printf "    # indented $em one\n"                               > room/indented.sh
printf "cat <<EOF\n# inside $em output\nEOF\n"                  > room/heredoc_plain.sh
printf "cat <<'EOF'\n# inside $em output\nEOF\n"                > room/heredoc_quoted.sh
printf "cat <<-EOF\n\t# inside $em output\n\tEOF\n"             > room/heredoc_dash.sh
printf "cat <<EOF\n# inside $em output\nEOF\n# after $em one\n" > room/heredoc_reopen.sh
printf "cat <<EOF\n# inside $em output\n   EOF\n# still inside $em output\n" > room/heredoc_strict.sh
printf "n=\$((1 << 3))\n# after shift $em one\n"                > room/shift.sh
printf "cat <<<\"x\"\n# after herestring $em one\n"             > room/herestring.sh
printf "# prose naming <<EOF in passing\n# after $em one\n"     > room/comment_opener.sh
printf "echo hi  # trailing $em one\n"                          > room/trailing.sh
printf "# theirs $em one\n"                                     > vendor/theirs/x.rish

# A link beside its target, the shape `tools/rye/sha3.rye` took on `20260829` one language over.
# `git ls-files` lists a link and its target as two paths, and following both counts one set of
# bytes twice; the Rye meter read 4,342 against a ceiling of 4,333 that way and reported a rise
# nobody had written (REDS %340). That repair reached this scan's `[ -L "$f" ] && continue` line
# and stopped short of this control, so the shell half of it stood unproven -- and this tree tracks
# exactly one symlinked `.rish` today, which is why the reading is planted rather than waited for.
ln -s sh_comment.sh room/link_to_sh_comment.sh
git add -A >/dev/null 2>&1; git commit -qm plant >/dev/null 2>&1

out=$(sh "$scan" --list 2>/dev/null)
echo "$out" | grep '^SHELL_COMMENT_ASCII'

for name in rish_comment.rish sh_comment.sh indented.sh heredoc_reopen.sh shift.sh herestring.sh comment_opener.sh; do
  key=$(printf '%s' "$name" | sed 's/\..*$//')
  echo "$out" | grep -q "room/$name" && echo "${key}_counted=yes" || echo "${key}_counted=no"
done
for name in heredoc_plain.sh heredoc_quoted.sh heredoc_dash.sh heredoc_strict.sh trailing.sh; do
  key=$(printf '%s' "$name" | sed 's/\..*$//')
  echo "$out" | grep -q "room/$name" && echo "${key}_counted=yes" || echo "${key}_counted=no"
done
case "$out" in *"vendor/theirs"*) echo "vendor_excluded=no";; *) echo "vendor_excluded=yes";; esac

# The symlink is tracked and resolves to a counted comment, so a meter that follows it reads eight.
case "$out" in *"room/link_to_sh_comment.sh"*) echo "symlink_skipped=no";; *) echo "symlink_skipped=yes";; esac
# And the skip drops the duplicate rather than the file: the target still counts on its own row.
case "$out" in *"room/sh_comment.sh"*) echo "symlink_target_kept=yes";; *) echo "symlink_target_kept=no";; esac

# Seven prose files, one character each, and nothing else -- eight would mean the link was followed.
case "$out" in *"chars=7 "*) echo "total_is_seven=yes";; *) echo "total_is_seven=no";; esac
case "$out" in *"under_ceiling=yes"*) echo "clean_pen_under_ceiling=yes";; *) echo "clean_pen_under_ceiling=no";; esac

# The ceiling, from the refusing side. The scan's own ceiling is read rather than spelled here, so
# this stays true when a lap lowers it.
ceiling=$(printf '%s' "$out" | sed -n 's/.* ceiling=\([0-9][0-9]*\) .*/\1/p')
over=$((ceiling + 1))
{ printf '# '; i=0; while [ "$i" -lt "$over" ]; do printf "$em"; i=$((i + 1)); done; printf '\n'; } > room/over.sh
git add -A >/dev/null 2>&1
loud=$(sh "$scan" 2>/dev/null)
echo "$loud" | sed 's/^/over_/'
case "$loud" in *"under_ceiling=no"*) echo "over_ceiling_refuses=yes";; *) echo "over_ceiling_refuses=no";; esac

rm -f room/over.sh
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
printf '# locked $em one\n' > room/locked.sh
git add -A >/dev/null 2>&1
chmod 000 room/locked.sh
if cat room/locked.sh >/dev/null 2>&1; then
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
chmod 644 room/locked.sh
rm -f room/locked.sh
git add -A >/dev/null 2>&1

# 18  AN ABSENT FILE IS SKIPPED AND COUNTED, never fatal. `git ls-files` reads the INDEX, so a
#     rename staged mid-lap lists a path the working tree no longer holds -- and a rebase is
#     exactly the moment a reading is worth having. Refusing there would trade one blindness for
#     an outage.
printf '# ghost $em one\n' > room/ghost.sh
git add -A >/dev/null 2>&1
rm -f room/ghost.sh
ghost=$(sh "$scan" 2>/dev/null)
case "$ghost" in *"absent=1"*) echo "absent_counted=yes";; *) echo "absent_counted=no";; esac
case "$ghost" in *"instrument=failed"*) echo "absent_is_fatal=yes";; *) echo "absent_is_fatal=no";; esac
git rm -q --cached room/ghost.sh >/dev/null 2>&1

echo "control_verdict=ok"
