#!/bin/sh
# tools/fixtures/p/phantom_path_scan.sh -- a tool reads a path the repository carries, or it reads nothing.
#
# WHY. REDS %153 found an untracked compatibility symlink `work-in-progress -> crux` at this
# pier's root, and repaired the twenty-six document links that resolved through it. The
# machinery was never in that sweep's scope. A census of path literals inside tracked tool
# sources then found 116 more across 58 files -- `tools/fixtures/r/reds_first_scan.sh` reading
# `ledger="work-in-progress/REDS.md"`, `tools/co/compass_rose.rish` printing NOW_OK on a
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
#     tools/d/dated_path_witness.rish; one duty, one guard, so two can never disagree.
#   `vendor/`, which `git submodule update` and tools/fetch_toolchain provision.
#   `seed/`, the depersonalized public projection, gitignored by design (`.claude/rules/git-signing.md`).
#   Any path carrying a dot-segment -- `tools/.build`, `glow/.cache`, `crypto/bin/.cc_reg.txt`,
#     `.gnupg-rye` -- because a dot names a generated or machine-local room.
#   `construction/standing-equipment-runs.kyri`, the untracked run card the roster rewrites (%150).
#   Any path GIT ITSELF ignores, asked with `git check-ignore` rather than guessed. A gitignored
#     path is a declared build artifact: the repository states its absence, so a reader who clones
#     is promised exactly what they get. This rule was earned (%169) -- two witnesses create the
#     symlink `linengrow/lib_session_root_nest_cue_jam.rye` into `glow/.cache/` while they run, and
#     `.gitignore` line 196 names it, so RUNNING the roster made this guard red on the next lap
#     while the tree itself was sound. It subsumes the `seed/` and dot-segment rules above, which
#     stay written for the reader and for the pass that never has to shell out.
#   A `*_control.sh` fixture, because a control that proves a guard refuses must PLANT the thing
#     it refuses -- this scan's own control writes `construction/ITINERARY.md` into a throwaway
#     repository on purpose, and counting it makes the meter rise as the proof gets stronger. The
#     refusal stays proven: the pen names its planted tool `stale.sh`, so the exemption reaches the
#     control and never the case it builds.
#   COMMENT lines, which is why the extraction drops them: this scan reads what a tool READS,
#     never what it SAYS. The paragraph above names `work-in-progress/REDS.md` on purpose and
#     must stay free to; a scan that gated its own explanation would delete the record of why
#     it exists.
#
# USAGE
#   sh tools/fixtures/p/phantom_path_scan.sh
#
# Driven by tools/p/phantom_path_witness.rish. Run from the repository root.

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
# clones. tools/t/tracked_link_witness.rish already gates every tracked symlink at landing inside
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
# ONE AWK OVER EVERY SOURCE (REDS %413). This forked an awk per file across 2,859 tool scripts,
# for a pass that reads each of them once either way. `FILENAME` carries what `-v F=` used to, and
# a NUL-delimited list keeps a path with a space in it whole -- the fault this rewrite hit twice
# in its sibling scans before it was written down.
# PIPED RATHER THAN `xargs -a`: the argument-file flag is a GNU extension and this fleet spans a
# Mac, so the dialect guard refuses it -- and it caught this one on the lap it entered.
if ! tr '\n' '\0' < "$work/sources" | LC_ALL=C xargs -0 awk '
    FNR == 1 { F = FILENAME }
    /^[[:space:]]*#/ { next }
    {
      s = $0
      while (match(s, /([A-Za-z0-9_.-]+\/)+[A-Za-z0-9_.-]+/)) {
        tok = substr(s, RSTART, RLENGTH); s = substr(s, RSTART + RLENGTH)
        if (tok ~ /\.(md|rye|rish|sh|bron|kyri|txt|tsv|brix|glow|zig|c|h)$/) print F "\t" tok
      }
    }' > "$work/lits.raw" 2>"$work/lits.err"; then
  echo "instrument=failed"
  echo "detail=literal_pass_refused"
  sed -n '1,5p' "$work/lits.err" | sed 's/^/detail_awk=/'
  echo "verdict=misread"
  exit 1
fi
sort -u "$work/lits.raw" > "$work/lits"

# ONE PASS OVER 8,793 LITERALS (REDS %413). This loop forked a `grep -qxF` for every literal, an
# `awk` for every one that missed, and a `git check-ignore` beyond that -- for a membership test
# that is a hash lookup. The awk below loads the known set and the symlink map once, applies the
# same exclusions in the same order, and emits only what still misses; the shell then tests `-e`
# and asks git about ignore rules over that residue alone, which is small because almost every
# literal a tool writes names something the tree carries.
if ! awk -F'\t' -v KF="$work/known" -v LF="$work/linkmap" '
    BEGIN {
      while ((getline k < KF) > 0) known[k] = 1
      close(KF)
      nl = 0
      while ((getline l < LF) > 0) {
        split(l, m, "\t")
        nl++; from[nl] = m[1]; to[nl] = m[2]
      }
      close(LF)
    }
    {
      src = $1; tok = $2
      if (tok == "") next
      # The same three exclusions the shell case carried, in the same order.
      if (tok ~ /^(vendor|seed)\//) next
      if (tok ~ /^\./ || tok ~ /\/\./) next
      if (tok == "construction/standing-equipment-runs.kyri") next
      if (tok in known) next
      # Try again through the tracked symlinks before calling it a phantom.
      for (i = 1; i <= nl; i++) {
        if (index(tok, from[i] "/") == 1) {
          through = to[i] "/" substr(tok, length(from[i]) + 2)
          if (through in known) next
        }
      }
      print src "\t" tok
    }' "$work/lits" > "$work/residue" 2>"$work/lits.err2"; then
  echo "instrument=failed"
  echo "detail=membership_pass_refused"
  sed -n '1,5p' "$work/lits.err2" | sed 's/^/detail_awk=/'
  echo "verdict=misread"
  exit 1
fi
while IFS="$(printf '\t')" read -r src tok; do
  [ -n "$tok" ] || continue
  # Resolving nowhere is a plain dangling reference; the dated-path census owns that duty.
  [ -e "$tok" ] || continue
  # A path git is TOLD to ignore is a declared build artifact, so a reader who clones is
  # promised its absence rather than its presence. This asks git rather than guessing:
  # `git check-ignore` consults .gitignore, the excludes file, and every nested rule at once.
  git check-ignore -q -- "$tok" 2>/dev/null && continue
  echo "$src -> $tok" >> "$work/phantom"
done < "$work/residue"

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
