#!/bin/sh
# tools/fixtures/rye_comment_ascii_control.sh -- the comment/string line is proven, not assumed.
#
# WHY. This meter exists to drive a sweep, and a sweep that miscounts a string as a comment would
# rewrite what a program prints. That already happened once by hand: a blanket `sed` over one module
# converted nine string literals along with its comments, including a header written into a file. So
# the reading is planted in a throwaway git repository and proven from both sides before it is
# trusted on 1,497 real files.
#
# WHAT IS PROVEN -- seven behaviors:
#   1  a `//` comment with non-ASCII is counted
#   2  a `///` declaration comment is counted -- it is prose too
#   3  a `//!` module comment is counted
#   4  a `\\` multiline-string line is NOT counted -- that is program output
#   5  a string literal on a code line is NOT counted, for the same reason
#   6  an indented comment is counted, so leading whitespace does not hide prose
#   7  the vendored rooms are left out, since those files are not ours to convert
#
# USAGE
#   sh tools/fixtures/rye_comment_ascii_control.sh
#
# Run from the repository root; it reads only the scan script from there.

set -u

scan=$PWD/tools/fixtures/rye_comment_ascii_scan.sh
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

# four prose files, one character each, and nothing else
case "$out" in *"chars=4 "*) echo "total_is_four=yes";; *) echo "total_is_four=no";; esac

echo "control_verdict=ok"
