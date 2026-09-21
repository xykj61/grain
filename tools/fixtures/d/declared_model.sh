#!/bin/sh
# tools/fixtures/d/declared_model.sh -- the one reading of which model this clone runs.
#
# WHY THIS FILE EXISTS. The model id was written down four ways and two of them disagreed. On
# 20260824 `.claude/settings.json` and `GLOW_PROFILE.template.kyri` read `claude-opus-5` while
# `recursion-prompts/seed/autonomous-loop.seed.md` read `claude-opus-4-6`, and the personal
# `GLOW_PROFILE.kyri` carried `claude-opus-4-6` in its field beneath a comment of its own saying
# `Model is Opus 5`. A file disagreeing with itself is the clearest form the fault takes.
#
# This is REDS %187, %190, %192, and %199 a fifth time -- a constant spelled in several places is a
# constant that can quietly disagree with itself -- so it becomes a reading rather than a habit,
# the same shape `living_pin_max_bytes.sh` seated for the byte bound.
#
# WHAT IT READS, AND THE TWO ANSWERS THAT CAME APART (`20260917.184231`). `.claude/settings.json`
# is the TRACKED default -- one id across eight clones, and the thing every describing site claims.
# `.claude/settings.local.json` is what Claude Code actually resolves OVER it, and `.gitignore`
# line 146 denies that file, so it reaches no guard reading tracked bytes.
#
# For this family's whole life those were one answer, and the sentence here said so: it read
# `.claude/settings.json` *because that is the file which actually drives the model Claude Code
# loads*. Both halves were true together until `20260917.180039`, when the captain wrote the local
# file carrying `claude-sonnet-5` into the seven peer trees on Keaton's word. Measured that hour:
# seven of eight clones resolve `claude-sonnet-5`, all eight DECLARE `claude-opus-5`, and this
# scan read `verdict=ok` on every one of them -- right about one ship and green about all eight.
#
# So the reading is two readings now, and each is asked by its own name. `model` and `effort`
# answer what the TRACKED file carries, unchanged byte for byte, because that is what the
# declaring pages claim and every one of them stays true. `resolved_model` and `resolved_effort`
# answer what this clone RUNS. `override` says whether the two can differ here at all.
#
# THE GATE STAYS ON THE TRACKED PAIR, deliberately. Seven ships carrying an intended override
# would red a gate no lap may repair, which is the shape `.claude/rules/derived-spine.md` names as
# a gate somebody turns off. The resolved pair is REPORTED, and a reader who needs to know what a
# lap ran asks for it by name.
#
# HOW IT BEHAVES WHEN IT CANNOT READ. It refuses with a named reason and a non-zero status rather
# than defaulting, because a meter whose value silently defaults reports green over an unmeasured
# tree.
#
# USAGE
#   sh tools/fixtures/d/declared_model.sh model            -> claude-opus-5   (tracked default)
#   sh tools/fixtures/d/declared_model.sh effort           -> medium          (tracked default)
#   sh tools/fixtures/d/declared_model.sh resolved_model   -> what THIS clone runs
#   sh tools/fixtures/d/declared_model.sh resolved_effort  -> what THIS clone runs
#   sh tools/fixtures/d/declared_model.sh override         -> yes | no
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
# THE LOCAL FILE OUTRANKS THE TRACKED ONE, and `.gitignore` line 146 denies it, so it reaches
# no guard that reads tracked bytes. Claude Code resolves it OVER `.claude/settings.json` per
# key rather than per file, which is why the reader below falls back key by key.
local_settings="$root/.claude/settings.local.json"

[ -f "$settings" ] || { echo "declared_model: $settings is absent -- the driver of the model cannot be read" >&2; exit 1; }

case "$field" in
  model|resolved_model)   key='model' ;;
  effort|resolved_effort) key='effortLevel' ;;
  override)               key='' ;;
  *) echo "declared_model: unknown field '$field' -- ask for model, effort, resolved_model, resolved_effort, or override" >&2; exit 1 ;;
esac

# One reading of one key out of one file. Spelled once so the tracked and the resolved answers
# can never be read two different ways -- the fault this whole family exists to prevent.
read_key() {
  [ -f "$2" ] || return 1
  sed -n 's/.*"'"$1"'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$2" | head -1
}

# `override` answers whether this clone carries a local file naming EITHER key. A file present
# and silent on both is no override at all, so presence alone would over-report.
if [ "$field" = override ]; then
  if [ -f "$local_settings" ] \
     && { [ -n "$(read_key model "$local_settings")" ] || [ -n "$(read_key effortLevel "$local_settings")" ]; }; then
    echo yes
  else
    echo no
  fi
  exit 0
fi

value=""
case "$field" in
  resolved_model|resolved_effort) value=$(read_key "$key" "$local_settings" 2>/dev/null || true) ;;
esac
[ -n "$value" ] || value=$(read_key "$key" "$settings")

[ -n "$value" ] || { echo "declared_model: $settings names no \"$key\" -- refusing rather than defaulting" >&2; exit 1; }

echo "$value"
