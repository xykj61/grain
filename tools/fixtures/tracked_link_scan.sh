#!/bin/sh
# tools/fixtures/tracked_link_scan.sh -- a link resolves in the tracked tree, or it does not resolve.
#
# WHY. `work-in-progress` was breached to `crux` on 20260815 and 902 references were repointed.
# Twenty-six survived the sweep, and every guard stayed green, because an untracked compatibility
# symlink `work-in-progress -> crux` sat at the repository root of THIS pier. The broken-link duty
# of tools/l/living_docs_lint.rish tests a target with `[ -e ]`, which the symlink satisfied, so a
# link that breaks in every fresh clone read as a link that works. The lint's own roster named
# `work-in-progress/TASKS.md`, so the guard was reaching through the artifact that blinded it.
#
# A filesystem answers "is this here on this machine." A reader who clones answers "is this in the
# repository." Those are different questions, and only the second one is a promise. This scan asks
# the second.
#
# WHAT IS GATED, hard.
#   Every tracked symlink resolves to a path the repository carries -- a tracked file, a tracked
#   directory, or a declared submodule. A fold moved a waymark and left one dangling, tracked,
#   for three days.
#   Every relative Markdown link in a LIVING document outside the two deferred yonder silos
#   resolves in the tracked tree.
#
# WHAT IS REPORTED, as a ratchet under a ceiling that only ever falls. The same reading across
# `external-research/yonder/` and `expanding-prompts/yonder/`, two deferred silos whose documents
# reference a room this tree renamed a season ago. They are repaired on touch rather than swept,
# because a sweep across a deferred shelf costs more than it earns.
#
# WHAT IS OUT OF SCOPE, on purpose.
#   A link resolving NOWHERE is a plain broken link and belongs to tools/l/living_docs_lint.rish.
#   This scan reads only the narrower and more surprising case: resolves here, breaks there.
#   Dated testimony keeps every reference it ever wrote (accrete-never-break), so a document whose
#   own basename carries a one-clock stamp is read past. A stale reference in testimony is
#   resolved rather than rewritten -- `rishi/bin/rishi run tools/d/dated_path_resolve.rish <ref>`.
#   `vendor/` is provisioned rather than tracked: the submodules want `git submodule update`, and
#   `vendor/zig-toolchain` wants tools/fetch_toolchain. A symlink into it is honest.
#
# USAGE
#   sh tools/fixtures/tracked_link_scan.sh
#
# Driven by tools/t/tracked_link_witness.rish. Run from the repository root.

set -eu

ceiling="${TRACKED_LINK_CEILING:-219}"

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads the tracked tree, so it wants git" >&2; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=no_repo"; echo "refused: not inside a git repository" >&2; exit 1; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

git ls-files > "$work/files"

# Every ancestor directory of a tracked file is itself carried by the repository, so a link
# naming a directory resolves for a reader who clones.
awk -F/ '{p="";for(i=1;i<NF;i++){p=(i==1)?$i:p "/" $i; print p}}' "$work/files" | sort -u > "$work/dirs"

# A declared submodule is a path the repository carries and `git submodule update` fills.
if [ -f .gitmodules ]; then
  git config -f .gitmodules --get-regexp '^submodule\..*\.path$' 2>/dev/null | awk '{print $2}' > "$work/subs" || : > "$work/subs"
else
  : > "$work/subs"
fi

cat "$work/files" "$work/dirs" "$work/subs" | sort -u > "$work/known"

# --- duty 1: every tracked symlink lands inside the tracked tree -----------------------
: > "$work/dangling"
git ls-files -s | awk '$1=="120000"{ $1=""; $2=""; $3=""; sub(/^[ \t]+/,""); print }' > "$work/symlinks"
while IFS= read -r link; do
  [ -n "$link" ] || continue
  [ -L "$link" ] || continue
  target=$(readlink "$link")
  case "$target" in /*) echo "$link -> $target (absolute)" >> "$work/dangling"; continue ;; esac
  resolved=$(printf '%s/%s\n' "$(dirname "$link")" "$target" | awk '{
    n=split($0,part,"/"); top=0
    for (i=1;i<=n;i++) {
      if (part[i]=="" || part[i]==".") continue
      if (part[i]=="..") { if (top>0) top--; continue }
      out[++top]=part[i]
    }
    s=""; for (i=1;i<=top;i++) s=(i==1)?out[i]:s "/" out[i]; print s
  }')
  case "$resolved" in vendor/*|vendor) continue ;; esac
  grep -qxF "$resolved" "$work/known" || echo "$link -> $resolved" >> "$work/dangling"
done < "$work/symlinks"
dangling=$(wc -l < "$work/dangling" | tr -d ' ')

# --- duty 2: every relative link in a living document resolves in the tracked tree -----
: > "$work/enforce"
: > "$work/ratchet"
grep '\.md$' "$work/files" | while IFS= read -r src; do
  [ -f "$src" ] || continue
  case "$src" in session-logs/*) continue ;; esac
  base=${src##*/}
  # A basename carrying a one-clock stamp is dated testimony, which keeps every word it wrote.
  case "$base" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][_.]*) continue ;;
  esac
  dir=$(dirname "$src")
  grep -oE '\]\([^)]+\)' "$src" 2>/dev/null | sed 's/^](//; s/)$//; s/#.*$//' | while IFS= read -r target; do
    [ -n "$target" ] || continue
    case "$target" in http*|mailto:*|'<'*|'/'*) continue ;; esac
    resolved=$(printf '%s/%s\n' "$dir" "$target" | awk '{
      n=split($0,part,"/"); top=0
      for (i=1;i<=n;i++) {
        if (part[i]=="" || part[i]==".") continue
        if (part[i]=="..") { if (top>0) top--; continue }
        out[++top]=part[i]
      }
      s=""; for (i=1;i<=top;i++) s=(i==1)?out[i]:s "/" out[i]; print s
    }')
    [ -n "$resolved" ] || continue
    grep -qxF "$resolved" "$work/known" && continue
    # Resolving nowhere at all is a plain broken link; living_docs_lint owns that duty.
    [ -e "$resolved" ] || continue
    case "$src" in
      external-research/yonder/*|expanding-prompts/yonder/*)
        echo "$src -> $target" >> "$work/ratchet" ;;
      *)
        echo "$src -> $target" >> "$work/enforce" ;;
    esac
  done
done
enforce=$(wc -l < "$work/enforce" | tr -d ' ')
ratchet=$(wc -l < "$work/ratchet" | tr -d ' ')

echo "symlinks_tracked=$(wc -l < "$work/symlinks" | tr -d ' ')"
echo "symlinks_outside_tree=$dangling"
echo "living_links_outside_tree=$enforce"
echo "yonder_links_outside_tree=$ratchet"
echo "yonder_ceiling=$ceiling"

[ "$dangling" -eq 0 ] || sed 's/^/dangling: /' "$work/dangling"
[ "$enforce" -eq 0 ] || sed 's/^/enforce: /' "$work/enforce"
[ "$ratchet" -eq 0 ] || { echo "ratchet: $ratchet links in the two deferred yonder silos, repaired on touch"; sed 's/^/ratchet: /' "$work/ratchet" | head -5; }

if [ "$dangling" -eq 0 ] && [ "$enforce" -eq 0 ] && [ "$ratchet" -le "$ceiling" ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=link_outside_tree"
echo "refused: a link above resolves on this machine and breaks in a fresh clone -- read the lines above" >&2
exit 1
