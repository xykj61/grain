#!/bin/sh
# tools/fixtures/a/ascii_document_convert.sh -- convert the NAMED non-ASCII forms in a document.
#
# WHY. `.claude/rules/ascii-first.md` carries a substitution table, and every form in it has exactly
# one ASCII spelling the rule itself names. Those conversions are mechanical, so a program should
# make them and a hand should not. What the table does NOT name -- a section sign, a Greek letter, a
# superscript, a check mark -- carries a meaning a reader must choose the ASCII form for, so this
# program leaves every one of them exactly where it stands. The census beside it
# (`ascii_document_scan.sh`) reports the two counts apart for the same reason.
#
# THE MODE IS TRACKED CONTENT. The rewrite goes through the ORIGINAL inode -- `cat "$tmp" > "$f"` --
# rather than `mv`, so the file keeps the mode the repository carries (`.claude/rules/exec-bit.md`).
# A `mv` here would land every converted document at the temporary file's mode.
#
# THE PROOF IS A RE-DERIVATION, not a diff read by eye. `--verify <ref>` takes each path's committed
# bytes, applies this same table in a pure function, and compares the result to the working tree. If
# they match byte for byte, then the only thing that changed is the declared substitution: no line
# reflowed, no word edited, no link retargeted. A sweep across sixty-three law pages needs a
# guarantee stronger than a careful reading.
#
# USAGE
#   sh tools/fixtures/a/ascii_document_convert.sh <path>...            # convert in place
#   sh tools/fixtures/a/ascii_document_convert.sh --verify <ref> <path>...   # prove the transform
#
# Run from the repository root.
set -eu

# The table, one row per form the rule names. Octal escapes throughout: a literal high byte in a
# source file is the very thing this family of guards exists to catch, and `sed` reads `\ooo` the
# same way on both dialects this tree runs on.
table() {
  printf '%s\n' \
    's/\o342\o200\o224/--/g' \
    's/\o342\o200\o223/-/g' \
    's/\o302\o267/-/g' \
    "s/\\o342\\o200\\o230/'/g" \
    "s/\\o342\\o200\\o231/'/g" \
    's/\o342\o200\o234/"/g' \
    's/\o342\o200\o235/"/g' \
    's/\o342\o200\o246/.../g' \
    's/\o342\o206\o222/->/g' \
    's/\o342\o206\o220/<-/g' \
    's/\o342\o206\o224/<->/g' \
    's/\o342\o207\o222/=>/g' \
    's/\o342\o211\o240/!=/g' \
    's/\o342\o211\o244/<=/g' \
    's/\o342\o211\o245/>=/g'
}

TABLEFILE=$(mktemp "${TMPDIR:-/tmp}/ascii-conv.XXXXXX")
WORK=$(mktemp "${TMPDIR:-/tmp}/ascii-work.XXXXXX")
trap 'rm -f "$TABLEFILE" "$WORK"' EXIT INT TERM
table > "$TABLEFILE"

apply() {
  # $1 input path, output on stdout. A pure function: same bytes in, same bytes out, no state.
  LC_ALL=C sed -f "$TABLEFILE" "$1"
}

if [ "${1:-}" = "--verify" ]; then
  shift
  ref=${1:?verify needs a git ref}
  shift
  checked=0
  proven=0
  for f in "$@"; do
    checked=$((checked + 1))
    if ! git show "$ref:$f" > "$WORK" 2>/dev/null; then
      echo "detail=absent_at_ref"
      echo "detail_path=$f"
      continue
    fi
    if [ "$(apply "$WORK" | git hash-object --stdin)" = "$(git hash-object "$f")" ]; then
      proven=$((proven + 1))
    else
      echo "detail=working_tree_is_not_the_transform"
      echo "detail_path=$f"
    fi
  done
  echo "verify_checked=$checked"
  echo "verify_proven=$proven"
  if [ "$checked" -eq "$proven" ] && [ "$checked" -gt 0 ]; then
    echo "verify=honored"
  else
    echo "verify=failed"
    exit 1
  fi
  exit 0
fi

converted=0
unchanged=0
for f in "$@"; do
  [ -f "$f" ] || { echo "detail=absent"; echo "detail_path=$f"; continue; }
  apply "$f" > "$WORK"
  if cmp -s "$WORK" "$f"; then
    unchanged=$((unchanged + 1))
    continue
  fi
  cat "$WORK" > "$f"
  converted=$((converted + 1))
done
echo "converted=$converted"
echo "unchanged=$unchanged"
