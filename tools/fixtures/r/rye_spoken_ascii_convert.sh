#!/bin/sh
# tools/fixtures/r/rye_spoken_ascii_convert.sh -- convert the six table forms inside Rye SPOKEN
# regions, and nothing else.
#
# WHY A TOOL RATHER THAN A `sed`. A blanket substitution over a `.rye` source reaches three
# populations this tree keeps apart on purpose: a `//` comment, which belongs to
# `tools/fixtures/r/rye_comment_ascii_scan.sh` and its own ceiling; a raw `\\` multiline string,
# which is what the program feeds ONWARD to a parser and whose bytes are behavior; and a spoken
# `print` region, which is what the program says to a person. Only the third is this lap's subject,
# and only a reader of parenthesis depth can tell them apart.
#
# So this converter carries the SAME depth machine as
# `tools/fixtures/r/rye_spoken_ascii_scan.sh` -- the identifier read back whole from the
# parenthesis, the character literal stepped over, the raw line and the comment left alone -- and
# rewrites only inside a region the scan would have counted. A file it changes therefore falls in
# the scan's reading by exactly what it converted, and moves no other meter at all.
#
# WHAT IT CONVERTS, and only these six, each spelled by `.claude/rules/ascii-first.md`:
#   em dash and en dash -> `--` and `-`   middle dot -> `-`   ellipsis -> `...`
#   right, left, and left-right arrow -> `->`, `<-`, `<->`
# Everything else -- a section sign, a `<=`, a superscript, a Greek letter -- is a reader's word to
# choose and is left standing. The scan reports that tail apart for exactly this reason.
#
# THE MODE IS IN THE PATH, WRITTEN THROUGH THE ORIGINAL INODE. `cat "$tmp" > "$f"` preserves the
# mode the repository tracks; `mv` would carry the temporary file's instead
# (`.claude/rules/exec-bit.md`).
#
# USAGE
#   sh tools/fixtures/r/rye_spoken_ascii_convert.sh --check <path>...   # report, change nothing
#   sh tools/fixtures/r/rye_spoken_ascii_convert.sh --apply <path>...   # rewrite in place
#
# Run from the repository root.

set -u

mode="${1:-}"
case "$mode" in
  --check | --apply) shift ;;
  *)
    echo "usage: sh tools/fixtures/r/rye_spoken_ascii_convert.sh --check|--apply <path>..."
    exit 2
    ;;
esac

[ "$#" -gt 0 ] || { echo "verdict=no_paths"; exit 2; }

rewrite() {
  LC_ALL=C awk '
    BEGIN { in_str = 0; depth = 0; changed = 0 }
    {
      s = $0
      len = length(s)
      out = ""
      i = 1
      in_raw = 0
      while (i <= len) {
        c = substr(s, i, 1)
        if (in_str || in_raw) {
          if (in_str && c == "\\") { out = out substr(s, i, 2); i += 2; continue }
          if (in_str && c == "\"") { in_str = 0; out = out c; i++; continue }
          if (depth > 0 && c ~ /[\300-\377]/) {
            seq = c; j = i + 1
            while (j <= len && substr(s, j, 1) ~ /[\200-\277]/) { seq = seq substr(s, j, 1); j++ }
            rep = plain(seq)
            if (rep != seq) changed = 1
            out = out rep
            i = j
            continue
          }
          out = out c; i++; continue
        }
        if (c == "\\" && substr(s, i + 1, 1) == "\\") { in_raw = 1; out = out substr(s, i, 2); i += 2; continue }
        if (c == "/" && substr(s, i + 1, 1) == "/") { out = out substr(s, i); break }
        if (c == "\"") { in_str = 1; out = out c; i++; continue }
        if (c == "'"'"'") {
          out = out c; i++
          while (i <= len) {
            ch = substr(s, i, 1)
            if (ch == "\\") { out = out substr(s, i, 2); i += 2; continue }
            out = out ch; i++
            if (ch == "'"'"'") break
          }
          continue
        }
        if (c == "(") {
          if (depth > 0) depth++
          else {
            j = i - 1
            while (j >= 1 && substr(s, j, 1) ~ /[A-Za-z0-9_]/) j--
            if (substr(s, j + 1, i - j - 1) == "print") depth = 1
          }
          out = out c; i++; continue
        }
        if (c == ")") { if (depth > 0) depth--; out = out c; i++; continue }
        out = out c; i++
      }
      print out
    }
    END { exit (changed ? 0 : 1) }

    # The six forms the rule names and spells, and nothing beside them.
    function plain(seq) {
      if (seq == "\342\200\224") return "--"
      if (seq == "\342\200\223") return "-"
      if (seq == "\302\267")     return "-"
      if (seq == "\342\200\246") return "..."
      if (seq == "\342\206\222") return "->"
      if (seq == "\342\206\220") return "<-"
      if (seq == "\342\206\224") return "<->"
      return seq
    }
  ' "$1"
}

changed=0
read_files=0
for f in "$@"; do
  [ -f "$f" ] || { echo "detail=absent path=$f"; continue; }
  read_files=$((read_files + 1))
  tmp="$f.spoken-ascii.tmp"
  if rewrite "$f" > "$tmp"; then
    changed=$((changed + 1))
    if [ "$mode" = --apply ]; then
      # Written through the original inode, so the tracked mode survives the rewrite.
      cat "$tmp" > "$f"
      echo "converted=$f"
    else
      echo "would_convert=$f"
    fi
  fi
  rm -f "$tmp"
done

echo "RYE_SPOKEN_ASCII_CONVERT mode=${mode#--} read=$read_files changed=$changed"
