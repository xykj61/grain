#!/bin/sh
# tools/fixtures/d/declared_model.sh -- the one reading of which model this clone runs.
#
# WHY THIS FILE EXISTS. The model id was written down four ways and two of them disagreed. On
# 20260824 `.claude/settings.json` and `GLOW_PROFILE.template.kyri` read `claude-opus-5` while
# `recursion-prompts/seed/autonomous-loop.seed.md` read `claude-opus-4-6`, and the personal
# `GLOW_PROFILE.bron` carried `claude-opus-4-6` in its field beneath a comment of its own saying
# `Model is Opus 5`. A file disagreeing with itself is the clearest form the fault takes.
#
# This is REDS %187, %190, %192, and %199 a fifth time -- a constant spelled in several places is a
# constant that can quietly disagree with itself -- so it becomes a reading rather than a habit,
# the same shape `living_pin_max_bytes.sh` seated for the byte bound.
#
# WHAT IT READS. `.claude/settings.json`, because that is the file which actually drives the model
# Claude Code loads. A description agrees with the thing it describes, so the driver is the source
# and every describing site is checked against it.
#
# HOW IT BEHAVES WHEN IT CANNOT READ. It refuses with a named reason and a non-zero status rather
# than defaulting, because a meter whose value silently defaults reports green over an unmeasured
# tree.
#
# USAGE
#   sh tools/fixtures/d/declared_model.sh model     -> claude-opus-5
#   sh tools/fixtures/d/declared_model.sh effort    -> max
#
# Read by tools/fixtures/d/declared_model_scan.sh and its control. Run from anywhere: the settings
# file is resolved from THIS script's own location rather than the caller's working directory, so a
# scan that has cd'd into a throwaway pen still reads the real tree's declaration.

set -u

field=${1:-model}

# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
_fd_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
root=${DECLARED_MODEL_ROOT:-$_fd_root}
settings="$root/.claude/settings.json"

[ -f "$settings" ] || { echo "declared_model: $settings is absent -- the driver of the model cannot be read" >&2; exit 1; }

case "$field" in
  model)  key='model' ;;
  effort) key='effortLevel' ;;
  *) echo "declared_model: unknown field '$field' -- ask for model or effort" >&2; exit 1 ;;
esac

value=$(sed -n 's/.*"'"$key"'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$settings" | head -1)

[ -n "$value" ] || { echo "declared_model: $settings names no \"$key\" -- refusing rather than defaulting" >&2; exit 1; }

echo "$value"
