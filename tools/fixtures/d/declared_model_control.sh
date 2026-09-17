#!/bin/sh
# tools/fixtures/d/declared_model_control.sh -- prove the model reading by doing.
#
# WHY. A guard that cannot red guards nothing (REDS row 59), and a refusal proven only in the
# passing direction cannot be told from a bypass. The scan reads the real tree, whose sites all
# agree, so its RED path cannot be shown there without damaging the tree. This control builds real
# git repositories in a throwaway pen and shows every reading from both sides.
#
# USAGE
#   sh tools/fixtures/d/declared_model_control.sh
#
# Driven by tools/d/declared_model_witness.rish. Run from the repository root.

set -u

scan=tools/fixtures/d/declared_model_scan.sh
read_one=tools/fixtures/d/declared_model.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }
[ -f "$read_one" ] || { echo "control_verdict=reading_missing" >&2; exit 1; }

scan_abs=$(CDPATH= cd -- "$(dirname -- "$scan")" && pwd)/$(basename "$scan")
read_abs=$(CDPATH= cd -- "$(dirname -- "$read_one")" && pwd)/$(basename "$read_one")

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

# Build one pen tree. `want` is the model every declaring site should name.
build() {
  d=$1; want=$2
  # The pen wears the root's two markers and mirrors the folded letter room (letter fold,
  # seated 20260828), so the copied reading's depth-proof walk resolves the pen root.
  rm -rf "$d"; mkdir -p "$d/.claude/rules" "$d/.cursor/rules" "$d/tools/fixtures/d" "$d/rishi/bin" \
    "$d/recursion-prompts/seed" "$d/docs-geode/tutorials"
  cp "$scan_abs" "$d/tools/fixtures/d/declared_model_scan.sh"
  cp "$read_abs" "$d/tools/fixtures/d/declared_model.sh"
  # The pen's own driver reads `max`, deliberately unlike the real tree's `medium`, so every effort
  # leg below proves the gate reads THE FILE rather than a value baked into the scan.
  printf '{ "model": "%s", "effortLevel": "max" }\n' "$want" > "$d/.claude/settings.json"
  printf 'model %s\neffort max\n' "$want" > "$d/GLOW_PROFILE.template.kyri"
  printf 'The loop runs `"model": "%s"` at max effort.\n' "$want" > "$d/recursion-prompts/seed/autonomous-loop.seed.md"
  printf 'Record `model %s` on new logs; settings configures max.\n' "$want" > "$d/.claude/rules/session-logs.md"
  printf 'Record `model` on new logs; settings configures max.\n' > "$d/.cursor/rules/session-logs.mdc"
  printf 'settings.json proves the configured default at max.\n' > "$d/.claude/rules/session-log-provenance.md"
  printf 'settings.json proves the configured default at max.\n' > "$d/.cursor/rules/session-log-provenance.mdc"
  printf 'Where the effort setting lives: settings.json reads max.\n' > "$d/docs-geode/tutorials/running-the-fleet.md"
  ( cd "$d" && git init -q . && git add -A && git -c user.email=pen@pen -c user.name=pen commit -qm pen ) >/dev/null 2>&1
}

# The scan is run from inside the pen, so `git ls-files` reads the pen's index.
runscan() { ( cd "$1" && DECLARED_MODEL_ROOT=. sh tools/fixtures/d/declared_model_scan.sh 2>&1 ); }

add() { printf '%s\n' "$3" > "$1/$2"; ( cd "$1" && git add -A && git -c user.email=pen@pen -c user.name=pen commit -qm add ) >/dev/null 2>&1; }

# Count each leg as it prints. `leg <name> <yes|no>` is the one door every reading goes through, so
# the tally below can never disagree with the lines a reader sees.
legs=0
failed=0
leg() {
  legs=$((legs + 1))
  [ "$2" = "yes" ] || failed=$((failed + 1))
  echo "$1=$2"
}

# 1 -- every site agreeing reads ok.
build "$pen/agree" claude-opus-5
out=$(runscan "$pen/agree")
echo "$out" | grep -q 'verdict=ok' && leg agreement_free yes || leg agreement_free no
echo "$out" | grep -q 'declared_model=claude-opus-5' && leg reading_reported yes || leg reading_reported no

# 2 -- one declaring site naming a different model is bitten.
build "$pen/wrong" claude-opus-5
printf 'The loop runs `"model": "claude-opus-4-6"` at max effort.\n' > "$pen/wrong/recursion-prompts/seed/autonomous-loop.seed.md"
( cd "$pen/wrong" && git add -A && git -c user.email=pen@pen -c user.name=pen commit -qm drift ) >/dev/null 2>&1
out=$(runscan "$pen/wrong")
echo "$out" | grep -q 'verdict=disagreement' && leg stale_site_bitten yes || leg stale_site_bitten no
echo "$out" | grep -q 'declaring_over=1' && leg stale_site_counted yes || leg stale_site_counted no

# 3 -- an absent declaring site is bitten, rather than silently skipped.
build "$pen/absent" claude-opus-5
rm -f "$pen/absent/GLOW_PROFILE.template.kyri"
( cd "$pen/absent" && git add -A && git -c user.email=pen@pen -c user.name=pen commit -qm rm ) >/dev/null 2>&1
out=$(runscan "$pen/absent")
echo "$out" | grep -q 'is named on the declaring roster and absent' && leg absent_site_bitten yes || leg absent_site_bitten no

# 4 -- a site recounting old models BESIDE the current one passes free. Presence, never absence.
build "$pen/history" claude-opus-5
# This page sits on BOTH rosters, so its replacement keeps the effort sentence as well as the
# model one -- the real page states both, and dropping either is a different fault than this leg
# is asking about. Leg 4 read `no` for exactly that reason on the lap the effort roster landed.
printf 'This clone ran claude-opus-4-8, then claude-opus-4-6, runs `model claude-opus-5` today, and configures max.\n' > "$pen/history/.claude/rules/session-logs.md"
( cd "$pen/history" && git add -A && git -c user.email=pen@pen -c user.name=pen commit -qm hist ) >/dev/null 2>&1
out=$(runscan "$pen/history")
echo "$out" | grep -q 'verdict=ok' && leg history_free yes || leg history_free no

# 5 -- dated testimony naming another model passes free, two ways.
build "$pen/dated" claude-opus-5
mkdir -p "$pen/dated/session-logs/date/20260815"
add "$pen/dated" "session-logs/20260815-101010_a-log.kyri" "model claude-opus-4-8"
add "$pen/dated" "session-logs/date/20260815/20260815-101011_b.kyri" "model claude-opus-4-8"
printf 'model claude-opus-4-8\n' > "$pen/dated/session-logs/date/README-index-20260815.md"
( cd "$pen/dated" && git add -A && git -c user.email=pen@pen -c user.name=pen commit -qm dated ) >/dev/null 2>&1
out=$(runscan "$pen/dated")
echo "$out" | grep -q 'drift_candidates=0' && leg dated_free yes || leg dated_free no
echo "$out" | grep -q 'verdict=ok' && leg dated_verdict_ok yes || leg dated_verdict_ok no

# 6 -- a LIVING file naming another model is counted as drift, and the ceiling bites from both sides.
build "$pen/ratchet" claude-opus-5
add "$pen/ratchet" "one.md" "generated by claude-opus-4-6"
out=$(runscan "$pen/ratchet")
echo "$out" | grep -q 'drift_candidates=1' && leg living_drift_counted yes || leg living_drift_counted no
echo "$out" | grep -q 'verdict=ok' && leg at_ceiling_free yes || leg at_ceiling_free no
add "$pen/ratchet" "two.md" "generated by claude-opus-4-6"
out=$(runscan "$pen/ratchet")
echo "$out" | grep -q 'drift_candidates=2' && leg over_ceiling_counted yes || leg over_ceiling_counted no
echo "$out" | grep -q 'verdict=disagreement' && leg over_ceiling_bitten yes || leg over_ceiling_bitten no

# 7 -- claude-code and .claude-state are not model ids, and must not be read as drift.
build "$pen/notmodel" claude-opus-5
add "$pen/notmodel" "prose.md" "Run claude-code from .claude-state via launch-claude-chapter.rish."
out=$(runscan "$pen/notmodel")
echo "$out" | grep -q 'drift_candidates=0' && leg claude_word_free yes || leg claude_word_free no

# 8 -- the reading refuses rather than defaulting when it cannot read.
build "$pen/norefuse" claude-opus-5
rm -f "$pen/norefuse/.claude/settings.json"
if ( cd "$pen/norefuse" && DECLARED_MODEL_ROOT=. sh tools/fixtures/d/declared_model.sh model ) >/dev/null 2>&1
then leg absent_settings_refused no; else leg absent_settings_refused yes; fi

build "$pen/nokey" claude-opus-5
printf '{ "effortLevel": "max" }\n' > "$pen/nokey/.claude/settings.json"
if ( cd "$pen/nokey" && DECLARED_MODEL_ROOT=. sh tools/fixtures/d/declared_model.sh model ) >/dev/null 2>&1
then leg missing_key_refused no; else leg missing_key_refused yes; fi

# 9 -- the reading resolves the settings file from its own location, never the caller's cwd.
build "$pen/cwd" claude-opus-5
got=$( cd / && DECLARED_MODEL_ROOT="$pen/cwd" sh "$pen/cwd/tools/fixtures/d/declared_model.sh" model 2>/dev/null )
[ "$got" = "claude-opus-5" ] && leg reading_root_anchored yes || leg reading_root_anchored "no ($got)"

# 10 -- THE EFFORT ROSTER, seated 20260916. The scan read the effort value from the day it was
# written and gated nothing with it, so three living sites quoted `max` while the driver read
# `medium`. Every leg below shows the second gate from both sides.

# 10a -- the reading is reported, and the whole effort roster agreeing passes free.
build "$pen/effort" claude-opus-5
out=$(runscan "$pen/effort")
echo "$out" | grep -q 'declared_effort=max' && leg effort_reading_reported yes || leg effort_reading_reported no
echo "$out" | grep -q 'declaring_effort_over=0' && leg effort_agreement_free yes || leg effort_agreement_free no
echo "$out" | grep -q 'declaring_effort_documents=6' && leg effort_roster_counted yes || leg effort_roster_counted no

# 10b -- one effort site naming another value is bitten and counted. This is the exact fault that
# stood in `.claude/rules/session-logs.md` for eight days with every guard in the tree green.
build "$pen/effortwrong" claude-opus-5
printf 'Record `model claude-opus-5` on new logs; settings configures low.\n' > "$pen/effortwrong/.claude/rules/session-logs.md"
( cd "$pen/effortwrong" && git add -A && git -c user.email=pen@pen -c user.name=pen commit -qm edrift ) >/dev/null 2>&1
out=$(runscan "$pen/effortwrong")
echo "$out" | grep -q 'verdict=disagreement' && leg effort_stale_bitten yes || leg effort_stale_bitten no
echo "$out" | grep -q 'declaring_effort_over=1' && leg effort_stale_counted yes || leg effort_stale_counted no
echo "$out" | grep -q 'declaring_over=0' && leg effort_gate_independent yes || leg effort_gate_independent no

# 10c -- an absent effort-roster path reds rather than being silently skipped, the same way the
# model roster's does.
build "$pen/effortgone" claude-opus-5
rm -f "$pen/effortgone/docs-geode/tutorials/running-the-fleet.md"
( cd "$pen/effortgone" && git add -A && git -c user.email=pen@pen -c user.name=pen commit -qm ermv ) >/dev/null 2>&1
out=$(runscan "$pen/effortgone")
echo "$out" | grep -q 'is named on the effort roster and absent' && leg effort_absent_bitten yes || leg effort_absent_bitten no

# 10d -- PRESENCE, NEVER ABSENCE, and this leg is why the roster is shaped that way. A page
# teaching the launch-path split names a DIFFERENT effort about a launch path in the sentence
# beside the settings value, and it must pass free -- `fleet_lap.sh` really does exec `--effort
# max` while `fleet-loop.sh` execs `--effort medium`, so both words are true at once.
build "$pen/effortsplit" claude-opus-5
printf 'settings.json reads max; fleet-loop.sh execs --effort medium and fleet_lap.sh --effort low.\n' \
  > "$pen/effortsplit/.claude/rules/session-log-provenance.md"
( cd "$pen/effortsplit" && git add -A && git -c user.email=pen@pen -c user.name=pen commit -qm split ) >/dev/null 2>&1
out=$(runscan "$pen/effortsplit")
echo "$out" | grep -q 'verdict=ok' && leg effort_launch_path_free yes || leg effort_launch_path_free no

# 10e -- the driver moving carries the whole roster with it. Every effort site says `max`; the
# settings file is changed to `high`, and the five sites red together rather than one at a time.
build "$pen/effortmoved" claude-opus-5
printf '{ "model": "claude-opus-5", "effortLevel": "high" }\n' > "$pen/effortmoved/.claude/settings.json"
( cd "$pen/effortmoved" && git add -A && git -c user.email=pen@pen -c user.name=pen commit -qm moved ) >/dev/null 2>&1
out=$(runscan "$pen/effortmoved")
echo "$out" | grep -q 'declared_effort=high' && leg effort_driver_is_source yes || leg effort_driver_is_source no
echo "$out" | grep -q 'declaring_effort_over=6' && leg effort_whole_roster_bitten yes || leg effort_whole_roster_bitten no

# 11 -- THE LOCAL OVERRIDE (`20260917.184231`). `.claude/settings.local.json` outranks the tracked
# file and `.gitignore` denies it, so a clone can RUN a model no tracked byte names. These legs
# prove the two readings apart, and prove the gate deliberately stays on the tracked one.

# 11a -- no local file: the two readings agree and the override says so.
build "$pen/nolocal" claude-opus-5
out=$(runscan "$pen/nolocal")
echo "$out" | grep -q 'resolved_model=claude-opus-5' && leg resolved_matches_tracked yes || leg resolved_matches_tracked no
echo "$out" | grep -q 'local_override=no' && leg override_absent_reported yes || leg override_absent_reported no

# 11b -- a local file naming another model: the readings part, and the OVERRIDE is what parts them.
# This is the leg that fails if the resolved reading ever falls back to the tracked file.
build "$pen/localmodel" claude-opus-5
printf '{ "model": "claude-sonnet-5" }\n' > "$pen/localmodel/.claude/settings.local.json"
out=$(runscan "$pen/localmodel")
echo "$out" | grep -q 'declared_model=claude-opus-5'  && leg tracked_holds_under_override yes || leg tracked_holds_under_override no
echo "$out" | grep -q 'resolved_model=claude-sonnet-5' && leg resolved_follows_override yes || leg resolved_follows_override no
echo "$out" | grep -q 'local_override=yes' && leg override_present_reported yes || leg override_present_reported no
echo "$out" | grep -q 'override_detail: this clone runs claude-sonnet-5' && leg override_detail_named yes || leg override_detail_named no

# 11c -- AND IT NEVER GATES. Seven ships carry this state on Keaton's word; a gate here would red
# every one of them for work no lap may undo. The whole repair rests on this leg staying green.
echo "$out" | grep -q 'verdict=ok' && leg override_never_gates yes || leg override_never_gates no

# 11d -- a local file present and silent on both keys is no override at all. Presence alone would
# over-report, and a reader would chase a difference that is not there.
build "$pen/localsilent" claude-opus-5
printf '{ "hooks": {} }\n' > "$pen/localsilent/.claude/settings.local.json"
out=$(runscan "$pen/localsilent")
echo "$out" | grep -q 'local_override=no' && leg silent_local_is_no_override yes || leg silent_local_is_no_override no
echo "$out" | grep -q 'resolved_model=claude-opus-5' && leg silent_local_falls_back yes || leg silent_local_falls_back no

# 11e -- the fallback is PER KEY rather than per file, exactly as Claude Code resolves it. A local
# file naming only the effort leaves the model reading the tracked file.
build "$pen/localeffort" claude-opus-5
printf '{ "effortLevel": "high" }\n' > "$pen/localeffort/.claude/settings.local.json"
out=$(runscan "$pen/localeffort")
echo "$out" | grep -q 'resolved_effort=high' && leg resolved_effort_follows yes || leg resolved_effort_follows no
echo "$out" | grep -q 'resolved_model=claude-opus-5' && leg per_key_fallback yes || leg per_key_fallback no

# THE CONTROL'S OWN LEG TALLY. Every reading above prints `<name>=yes` or `<name>=no`, and until
# 20260916 a `no` stood beneath a green `control_verdict=ok` unless the witness happened to name
# that key. A leg written tomorrow was therefore unheard until somebody remembered to assert it.
# The tally is counted from the control's own output, so the verdict answers for every leg.
echo "control_legs=$legs"
echo "control_failed=$failed"
[ "$failed" -eq 0 ] && echo "control_verdict=ok" || echo "control_verdict=leg_failed"
