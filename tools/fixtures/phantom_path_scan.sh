#!/bin/sh
# tools/fixtures/phantom_path_scan.sh -- a tool reads a path the repository carries, or it reads nothing.
#
# WHY. REDS %153 found an untracked compatibility symlink `work-in-progress -> crux` at this
# pier's root, and repaired the twenty-six document links that resolved through it. The
# machinery was never in that sweep's scope. A census of path literals inside tracked tool
# sources then found 116 more across 58 files -- `tools/fixtures/reds_first_scan.sh` reading
# `ledger="work-in-progress/REDS.md"`, `tools/compass_rose.rish` printing NOW_OK on a
# `test -f work-in-progress/TASKS.md`, the Radiant lint's own roster naming three living cards
# through the old room, and `.brix`, the tree's composition descriptor, listing two bricks there.
#
# Every one of them answered correctly on this machine and would answer wrongly on a fresh
# clone -- a guard reading nothing passes as readily as a guard reading everything. A filesystem
# answers "is this here on this machine." A reader who clones asks "is this in the repository."
# Only the second is a promise, and a guard's whole worth is that its promise travels.
#
# WHAT IS GATED, hard, at zero. Every path literal on a NON-COMMENT line of a tracked
# `tools/**.rish`, `tools/**.sh`, or `.brix` that resolves on this filesystem yet stands
# outside the tracked tree -- a phantom.
#
# WHAT PASSES FREE, by named rule, each for a stated reason.
#   A literal resolving NOWHERE at all. That is a plain dangling reference and belongs to
#     tools/dated_path_witness.rish; one duty, one guard, so two can never disagree.
#   `vendor/`, which `git submodule update` and tools/fetch_toolchain provision.
#   `seed/`, the depersonalized public projection, gitignored by design (`.claude/rules/git-signing.md`).
#   Any path carrying a dot-segment -- `tools/.build`, `glow/.cache`, `crypto/bin/.cc_reg.txt`,
#     `.gnupg-rye` -- because a dot names a generated or machine-local room.
#   `crux/standing-equipment-runs.kyri`, the untracked run card the roster rewrites (%150).
#   A `*_control.sh` fixture, because a control that proves a guard refuses must PLANT the thing
#     it refuses -- this scan's own control writes `work-in-progress/REMEMBER.md` into a throwaway
#     repository on purpose, and counting it makes the meter rise as the proof gets stronger. The
#     refusal stays proven: the pen names its planted tool `stale.sh`, so the exemption reaches the
#     control and never the case it builds.
#   COMMENT lines, which is why the extraction drops them: this scan reads what a tool READS,
#     never what it SAYS. The paragraph above names `work-in-progress/REDS.md` on purpose and
#     must stay free to; a scan that gated its own explanation would delete the record of why
#     it exists.
#
# USAGE
#   sh tools/fixtures/phantom_path_scan.sh
#
# Driven by tools/phantom_path_witness.rish. Run from the repository root.

set -eu

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads the tracked tree, so it wants git" >&2; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=no_repo"; echo "refused: not inside a git repository" >&2; exit 1; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

git ls-files > "$work/files"

# Every ancestor directory of a tracked file is carried by the repository too, so a literal
# naming a directory resolves for a reader who clones.
awk -F/ '{p="";for(i=1;i<NF;i++){p=(i==1)?$i:p "/" $i; print p}}' "$work/files" | sort -u > "$work/dirs"

if [ -f .gitmodules ]; then
  git config -f .gitmodules --get-regexp '^submodule\..*\.path$' 2>/dev/null | awk '{print $2}' > "$work/subs" || : > "$work/subs"
else
  : > "$work/subs"
fi

cat "$work/files" "$work/dirs" "$work/subs" | sort -u > "$work/known"

# A literal may travel through a TRACKED symlink -- `pond/apps/brushstroke` is one, pointing at
# the tracked `brushstroke/` room -- and such a path resolves perfectly well for a reader who
# clones. tools/tracked_link_witness.rish already gates every tracked symlink at landing inside
# the tracked tree, so following one here composes with a promise already proven rather than
# assuming a new one. The map is prefix -> target, longest prefix winning.
git ls-files -s | awk '$1=="120000"{ $1=""; $2=""; $3=""; sub(/^[ \t]+/,""); print }' > "$work/tlinks"
: > "$work/linkmap"
while IFS= read -r link; do
  [ -n "$link" ] || continue
  [ -L "$link" ] || continue
  target=$(readlink "$link")
  case "$target" in /*) continue ;; esac
  resolved=$(printf '%s/%s\n' "$(dirname "$link")" "$target" | awk '{
    n=split($0,part,"/"); top=0
    for (i=1;i<=n;i++) {
      if (part[i]=="" || part[i]==".") continue
      if (part[i]=="..") { if (top>0) top--; continue }
      out[++top]=part[i]
    }
    s=""; for (i=1;i<=top;i++) s=(i==1)?out[i]:s "/" out[i]; print s
  }')
  printf '%s\t%s\n' "$link" "$resolved" >> "$work/linkmap"
done < "$work/tlinks"

# The sources whose reads are a promise: the tools, and the descriptor that lists the bricks.
{ grep -E '^tools/.*\.(rish|sh)$' "$work/files" | grep -v '_control\.sh$' || true; grep -qxF '.brix' "$work/files" && echo .brix || true; } > "$work/sources"
sources=$(wc -l < "$work/sources" | tr -d ' ')

: > "$work/phantom"
while IFS= read -r src; do
  [ -f "$src" ] || continue
  awk -v F="$src" '
    /^[[:space:]]*#/ { next }
    {
      s = $0
      while (match(s, /([A-Za-z0-9_.-]+\/)+[A-Za-z0-9_.-]+/)) {
        tok = substr(s, RSTART, RLENGTH); s = substr(s, RSTART + RLENGTH)
        if (tok ~ /\.(md|rye|rish|sh|bron|kyri|txt|tsv|brix|glow|zig|c|h)$/) print F "\t" tok
      }
    }' "$src"
done < "$work/sources" | sort -u > "$work/lits"

while IFS="$(printf '\t')" read -r src tok; do
  [ -n "$tok" ] || continue
  case "$tok" in
    vendor/*|seed/*) continue ;;
    .*|*/.*) continue ;;
    crux/standing-equipment-runs.kyri) continue ;;
  esac
  grep -qxF -- "$tok" "$work/known" && continue
  # Try again through the tracked symlinks before calling it a phantom.
  through=$(awk -F'\t' -v t="$tok" '
    index(t, $1 "/") == 1 { r = $2 "/" substr(t, length($1) + 2) }
    END { print r }' "$work/linkmap")
  if [ -n "$through" ] && grep -qxF -- "$through" "$work/known"; then continue; fi
  # Resolving nowhere is a plain dangling reference; the dated-path census owns that duty.
  [ -e "$tok" ] || continue
  echo "$src -> $tok" >> "$work/phantom"
done < "$work/lits"

phantom=$(wc -l < "$work/phantom" | tr -d ' ')

echo "sources_read=$sources"
echo "path_literals=$(wc -l < "$work/lits" | tr -d ' ')"
echo "phantom_paths=$phantom"

[ "$phantom" -eq 0 ] || sed 's/^/phantom: /' "$work/phantom"

if [ "$phantom" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=phantom_paths"
exit 2
