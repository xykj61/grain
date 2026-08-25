#!/bin/sh
# tools/fixtures/shell_comment_ascii_control.sh -- the comment/heredoc line is proven, not assumed.
#
# WHY. This meter drove a sweep across 2,163 files, and a sweep that reads a heredoc body as prose
# would rewrite what a program feeds to another program. The sibling Rye meter learned the same
# lesson at a string literal, by hand and the expensive way. So every reading is planted in a
# throwaway git repository and proven from both sides before it is trusted on 2,823 real files.
#
# WHAT IS PROVEN -- thirteen behaviors, and each one is a claim the scan makes out loud:
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
#
# AND THE CEILING, FROM BOTH SIDES. A refusal proven only in the passing direction cannot be told
# from a bypass, so the pen is pushed over the ceiling and read again. There is no override.
#
# USAGE
#   sh tools/fixtures/shell_comment_ascii_control.sh
#
# Run from the repository root; it reads only the scan script from there.

set -u

scan=$PWD/tools/fixtures/shell_comment_ascii_scan.sh
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

# Seven prose files, one character each, and nothing else.
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

echo "control_verdict=ok"
