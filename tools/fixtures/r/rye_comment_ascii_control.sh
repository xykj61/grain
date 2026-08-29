#!/bin/sh
# tools/fixtures/r/rye_comment_ascii_control.sh -- the comment/string line is proven, not assumed.
#
# WHY. This meter exists to drive a sweep, and a sweep that miscounts a string as a comment would
# rewrite what a program prints. That already happened once by hand: a blanket `sed` over one module
# converted nine string literals along with its comments, including a header written into a file. So
# the reading is planted in a throwaway git repository and proven from both sides before it is
# trusted on 1,497 real files.
#
# WHAT IS PROVEN -- nine behaviors:
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
ceiling=$(printf '%s' "$out" | sed -n 's/.* ceiling=\([0-9][0-9]*\) .*/\1/p')
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

echo "control_verdict=ok"
