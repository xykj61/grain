#!/bin/sh
# tools/fixtures/f/fold_shelf_link_repoint.sh -- apply the one correction a depth-lost link has.
#
# WHAT THIS IS FOR. `fold_shelf_link_scan.sh` finds links that kept the depth of the file they were
# folded out of, and names the single correction each one has. This applies them. It is the other
# half of the loom REDS %474 booked: the scan says what is wrong, and this makes it right, so a red
# is never answered by the same hand-editing that caused it. It sits beside the tree's other
# repointers -- `dated_path_repoint.rish` beside `dated_path_resolve.rish`,
# `tool_path_repoint.rish` beside `tool_path_resolve.rish` -- and keeps their shape.
#
# WHY IT CANNOT BE A BLANKET SED, which is the whole reason it is a program rather than one line.
# `reds_fold_reanchor.sh` rewrites `](../` to `](../../` across a row unconditionally, and it is
# right to: it runs at fold time on rows that were ALL correct a moment earlier. This runs after the
# fact, on files where some links are correct, some are depth-lost, and some are stale references
# pointing at pages that genuinely moved. Measured `20260906.120905`, one shelf held 288 depth-lost
# links beside 401 stale ones. A blanket rewrite would move all 689 and turn 401 honest breaks into
# 401 differently-wrong ones -- which is guessing, at scale, in testimony.
#
# So it rewrites ONLY the exact targets the scan approved, each of which resolves under exactly one
# correction. Nothing is inferred here; the scan already decided, and this types.
#
# AND IT MUST NOT TOUCH A CODE SPAN. A row that quotes a broken link as its own subject writes it
# inside backticks, and Markdown renders that literally -- so the same string may stand twice in one
# file, once as a link to repair and once as prose to leave exactly alone. The scan already reads
# past code spans; this uses the same model, splitting each line on backticks and rewriting only the
# segments a reader sees as Markdown. An unterminated span leaves its tail OUTSIDE, which is what
# the scan's own `gsub` does, so the two can never disagree about what is prose.
#
# WHY IT WRITES THROUGH THE ORIGINAL FILE. `cat "$tmp" > "$f"` writes through the inode and the
# repository keeps the mode it tracks; `mv "$tmp" "$f"` would hand the file the temporary's mode
# instead. That is the exec-bit law, and one repoint pass dropped 39 files from 100755 to 100644 by
# reaching for `mv` (REDS, the exec-bit rule). These are Markdown files at 100644 either way -- the
# habit is what the law exists to seat.
#
# USAGE
#   sh tools/fixtures/f/fold_shelf_link_repoint.sh --dry-run   # name every edit, change nothing
#   sh tools/fixtures/f/fold_shelf_link_repoint.sh             # apply them
#
# Proven by doing: the pass that landed this tool repaired 345 links across four shelves, and
# `tools/f/fold_shelf_link_witness.rish` read zero afterward. Run from the repository root.
set -eu

MODE="${1:-apply}"
case "$MODE" in
  --dry-run|-n) MODE=dry ;;
  apply) MODE=apply ;;
  *) echo "refused: unknown argument $MODE -- pass --dry-run or nothing" >&2; exit 2 ;;
esac

scan=$(CDPATH= cd -- "$(dirname "$0")" && pwd)/fold_shelf_link_scan.sh
[ -f "$scan" ] || { echo "verdict=no_scan"; echo "refused: no fold_shelf_link_scan.sh beside this repointer" >&2; exit 2; }

work=$(mktemp -d) || { echo "verdict=no_workspace"; exit 2; }
trap 'rm -rf "$work"' EXIT

# The scan exits 1 when it has work to report, which is the case this tool exists for.
( set +e; sh "$scan" list > "$work/lost" 2>/dev/null; exit 0 )
edits=$(grep -c . "$work/lost" || true)

if [ "$edits" -eq 0 ]; then
  echo "edits=0"
  echo "verdict=nothing_to_do"
  exit 0
fi

cut -f1 "$work/lost" | sort -u > "$work/files"
files=$(grep -c . "$work/files" || true)

if [ "$MODE" = dry ]; then
  awk -F"$(printf '\t')" '{print "would repoint: " $1 " :: " $2 " -> " $3}' "$work/lost"
  echo "files=$files"
  echo "edits=$edits"
  echo "verdict=dry_run"
  exit 0
fi

applied=0
while IFS= read -r f; do
  [ -n "$f" ] || continue
  awk -F"$(printf '\t')" -v want="$f" '$1 == want {print $2 "\t" $3}' "$work/lost" > "$work/map"

  awk -F"$(printf '\t')" -v mapfile="$work/map" '
    FILENAME == mapfile { from[$1] = $2; next }
    {
      n = split($0, seg, "`")
      out = ""
      for (j = 1; j <= n; j++) {
        s = seg[j]
        # A segment a reader sees as Markdown: every odd one, plus a trailing even one whose
        # opening backtick never closed -- the same shape the scan gsubs away, so the two agree.
        outside = (j % 2 == 1) || (j == n)
        if (outside) {
          for (t in from) {
            old = "](" t ")"
            new = "](" from[t] ")"
            p = index(s, old)
            while (p > 0) {
              s = substr(s, 1, p - 1) new substr(s, p + length(old))
              p = index(s, old)
            }
          }
        }
        out = out (j > 1 ? "`" : "") s
      }
      print out
    }
  ' "$work/map" "$f" > "$work/new"

  # Through the inode, so the repository keeps the mode it tracks (the exec-bit law).
  cat "$work/new" > "$f"
  applied=$((applied + 1))
done < "$work/files"

echo "files=$files"
echo "files_written=$applied"
echo "edits=$edits"
echo "verdict=repointed"
