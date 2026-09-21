#!/bin/sh
# tools/fixtures/d/declared_model_scan.sh -- every site that states the model agrees with the driver.
#
# WHY. See tools/fixtures/d/declared_model.sh. Four sites named the model on 20260824 and two of them
# named a different one, including one file that disagreed with its own comment. REDS %201.
#
# WHAT IS GATED, hard. Each site on the DECLARING roster below states the reading's model id
# somewhere in its text. The roster is NAMED rather than discovered, so a new file cannot join the
# enforced tier by accident and red on work it never agreed to cover -- the same discipline
# prose_register_scan.sh keeps for its door roster.
#
# The gate reads PRESENCE of the current id rather than ABSENCE of every other, and the difference
# matters: `.claude/rules/session-logs.md` legitimately recounts the arc of models this clone has
# run -- Fable 5, Opus 4.8, Sonnet 5 -- and erasing that history to satisfy a guard would trade a
# true record for a green line. A site passes by saying what runs today, and keeps every word it
# wrote about yesterday.
#
# WHAT IS REPORTED, as a ratchet under a ceiling that only ever falls. Living tracked files naming
# some `claude-*` id and never naming the current one. Each is a candidate declaration site that
# has drifted, or honest testimony that happens to carry no stamp in its basename. Reported so a
# reader can tell the two apart, rather than gated, since only a reader can.
#
# WHAT PASSES FREE, by two named rules. Dated testimony -- a file whose own basename carries a
# one-clock stamp -- keeps every word it wrote, so a session log recording the model that produced
# it is read past. And anything under a `date/` directory, which is the same rule read from the
# path: a folded room's index shelf is immutable once written by the index-fold law, and its
# basename carries a day rather than a full stamp. Widening the basename pattern instead would put
# this scan at odds with the resolver, the repointer, and the census over what a dated file is,
# which is REDS %175 exactly; reading the directory leaves that seam untouched. Accrete-never-break.
#
# THE EFFORT ROSTER, a second enforced tier seated 20260916. This scan has read the effort value
# since it was written -- `declared_effort=` prints on every run -- and passed it to no comparison,
# so the one field it measured and never gated is the one that drifted. Three living sites quoted
# `.claude/settings.json` as carrying `max` while the file read `medium`: `.claude/rules/session-logs.md`,
# the seed's section 0, and this family's own USAGE comment one file over. Its peer
# `.claude/rules/session-log-provenance.md` read `medium` correctly the whole time, so two law pages
# disagreed about one file and nothing in the tree could hear it. A reading nobody acts on is the
# second half of a guard nobody runs.
#
# WHY THIS ROSTER IS NOT THE MODEL ROSTER. The model is ONE id across the tree. The effort is not,
# and saying so is the whole care of this half: `tools/f/fleet_lap.sh` execs `--effort max` inside
# the enclosure while `tools/f/fleet-loop.sh` execs `--effort medium` bare, which this pier runs.
# So a page describing a LAUNCH PATH writes whatever that path passes and is right to. The roster
# below names only pages that state what `.claude/settings.json` ITSELF carries, and the test is
# presence of the value the file reads today -- the same presence-over-absence discipline the model
# half keeps above, and for the same reason: a page teaching the launch-path split must stay free to
# say `max` about `fleet_lap.sh` in the sentence beside it.
#
# WHAT IS DELIBERATELY OFF IT. `GLOW_PROFILE.template.kyri` reads `effort max` and names no
# `medium`. It records how a clone's work is produced rather than what the settings file carries,
# which is a different door, and `docs-geode/tutorials/running-the-fleet.md` already tabulates both
# readings side by side as the two facts they are. Whether the template should follow the pier it
# ships with is a question for a hand, so it sits on the model roster and off this one.
#
# WHAT IS NOT PROVEN. That the model named is the model the API actually served, and that the effort
# a page names is the effort a lap ran at. This reads what the tree says about itself, and agreement
# is the whole of the claim.
#
# USAGE
#   sh tools/fixtures/d/declared_model_scan.sh
#
# Driven by tools/d/declared_model_witness.rish. Run from the repository root.

set -u

root=${DECLARED_MODEL_ROOT:-.}
read_one="$root/tools/fixtures/d/declared_model.sh"
[ -f "$read_one" ] || { echo "verdict=reading_missing" ; exit 1 ; }

model=$(DECLARED_MODEL_ROOT="$root" sh "$read_one" model) || { echo "verdict=model_unreadable"; exit 1; }
effort=$(DECLARED_MODEL_ROOT="$root" sh "$read_one" effort) || { echo "verdict=effort_unreadable"; exit 1; }

# The RESOLVED pair, reported and never gated (`20260917.184231`). `.claude/settings.local.json`
# outranks the tracked file and `.gitignore` denies it, so a clone can run a model no tracked byte
# names. Gating this would red seven ships for an override Keaton asked for, which is the gate
# `.claude/rules/derived-spine.md` describes as one somebody turns off. So it is printed, loudly,
# and the roster below keeps checking the TRACKED value those pages actually claim.
resolved_model=$(DECLARED_MODEL_ROOT="$root" sh "$read_one" resolved_model) || { echo "verdict=resolved_model_unreadable"; exit 1; }
resolved_effort=$(DECLARED_MODEL_ROOT="$root" sh "$read_one" resolved_effort) || { echo "verdict=resolved_effort_unreadable"; exit 1; }
local_override=$(DECLARED_MODEL_ROOT="$root" sh "$read_one" override) || { echo "verdict=override_unreadable"; exit 1; }

echo "declared_model=$model"
echo "declared_effort=$effort"
echo "resolved_model=$resolved_model"
echo "resolved_effort=$resolved_effort"
echo "local_override=$local_override"
[ "$resolved_model" = "$model" ] || echo "override_detail: this clone runs $resolved_model where the tracked file declares $model"
[ "$resolved_effort" = "$effort" ] || echo "override_detail: this clone runs effort $resolved_effort where the tracked file declares $effort"

# The declaring roster: living pages that state which model THIS clone runs today.
DECLARING="GLOW_PROFILE.template.kyri recursion-prompts/seed/autonomous-loop.seed.md .claude/rules/session-logs.md"

declaring_total=0
declaring_over=0
for f in $DECLARING; do
  declaring_total=$((declaring_total + 1))
  if [ ! -f "$root/$f" ]; then
    declaring_over=$((declaring_over + 1))
    echo "over: $f is named on the declaring roster and absent"
    continue
  fi
  if grep -q -- "$model" "$root/$f"; then
    echo "declares: $f names $model"
  else
    declaring_over=$((declaring_over + 1))
    echo "over: $f states a model and never names $model"
  fi
done

# The effort declaring roster: living pages that state what `.claude/settings.json` itself carries.
# NAMED rather than discovered, exactly as the model roster above is, so a file cannot join the
# enforced tier by accident and red on work it never agreed to cover.
DECLARING_EFFORT=".claude/rules/session-logs.md .claude/rules/session-log-provenance.md recursion-prompts/seed/autonomous-loop.seed.md docs-geode/tutorials/running-the-fleet.md"

effort_total=0
effort_over=0
for f in $DECLARING_EFFORT; do
  effort_total=$((effort_total + 1))
  if [ ! -f "$root/$f" ]; then
    effort_over=$((effort_over + 1))
    echo "over_effort: $f is named on the effort roster and absent"
    continue
  fi
  if grep -q -- "$effort" "$root/$f"; then
    echo "declares_effort: $f names $effort"
  else
    effort_over=$((effort_over + 1))
    echo "over_effort: $f states the settings effort and never names $effort"
  fi
done

# The ratchet: living tracked files naming some claude-* id and never the current one.
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

( cd "$root" && git ls-files 2>/dev/null ) > "$work/tracked.txt" || : > "$work/tracked.txt"

drift=0
: > "$work/drift.txt"

# ONE `git grep` FOR THE CANDIDATES (REDS %413). This walked all 14,709 tracked files and forked a
# `basename` and one or two `grep`s for each -- roughly 35,000 processes to find the 1,127 files
# that name a model id at all. `git grep -l` answers that in one pass over the same tracked set,
# and the loop below then runs only over those, where the second grep is cheap and few.
#
# A MODEL ID, rather than any hyphenated claude-word: the first pattern written here read
# `claude-[a-z0-9-]*` and returned 71 files -- claude-code, .claude-state, launch-claude-chapter.
# A model id is always a family and a number, and that is what the tree means by one.
if ! ( cd "$root" && git grep -lE 'claude-(opus|sonnet|haiku|fable)-[0-9]' ) > "$work/named.txt" 2>"$work/named.err"; then
  # git grep exits 1 when nothing matches, which is a real and clean answer rather than a failure.
  if [ -s "$work/named.err" ]; then
    echo "instrument=failed"
    echo "detail=model_id_pass_refused"
    sed -n '1,5p' "$work/named.err" | sed 's/^/detail_git=/'
    echo "verdict=misread"
    exit 1
  fi
  : > "$work/named.txt"
fi

while IFS= read -r f; do
  [ -n "$f" ] || continue
  case "$(basename "$f")" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][_.]*) continue ;;
  esac
  case "$f" in
    date/*|*/date/*) continue ;;
  esac
  [ -f "$root/$f" ] || continue
  grep -q -- "$model" "$root/$f" 2>/dev/null && continue
  drift=$((drift + 1))
  printf 'drift: %s\n' "$f" >> "$work/drift.txt"
done < "$work/named.txt"

[ -s "$work/drift.txt" ] && cat "$work/drift.txt"

# The ceiling only ever falls. Measured 20260824.161948: one file,
# gratitude/grain-lineage/silken-ground-v3-visionary.md, which records in its own footer the model
# that generated it. Honest testimony wearing no stamp and sitting in no date/ room, so neither
# rule above reaches it, and a reader is what tells it apart from real drift.
ceiling=1

echo "declaring_documents=$declaring_total"
echo "declaring_over=$declaring_over"
echo "declaring_effort_documents=$effort_total"
echo "declaring_effort_over=$effort_over"
echo "drift_candidates=$drift"
echo "drift_ceiling=$ceiling"

if [ "$declaring_over" -eq 0 ] && [ "$effort_over" -eq 0 ] && [ "$drift" -le "$ceiling" ]; then
  echo "verdict=ok"
else
  echo "verdict=disagreement"
  exit 1
fi
