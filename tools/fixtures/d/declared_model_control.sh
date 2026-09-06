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
# Driven by tools/m/declared_model_witness.rish. Run from the repository root.

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
  rm -rf "$d"; mkdir -p "$d/.claude/rules" "$d/tools/fixtures/d" "$d/rishi/bin" "$d/recursion-prompts/seed"
  cp "$scan_abs" "$d/tools/fixtures/d/declared_model_scan.sh"
  cp "$read_abs" "$d/tools/fixtures/d/declared_model.sh"
  printf '{ "model": "%s", "effortLevel": "max" }\n' "$want" > "$d/.claude/settings.json"
  printf 'model %s\neffort max\n' "$want" > "$d/GLOW_PROFILE.template.kyri"
  printf 'The loop runs `"model": "%s"` at max effort.\n' "$want" > "$d/recursion-prompts/seed/autonomous-loop.seed.md"
  printf 'Record `model %s` on new logs.\n' "$want" > "$d/.claude/rules/session-logs.md"
  ( cd "$d" && git init -q . && git add -A && git -c user.email=pen@pen -c user.name=pen commit -qm pen ) >/dev/null 2>&1
}

# The scan is run from inside the pen, so `git ls-files` reads the pen's index.
runscan() { ( cd "$1" && DECLARED_MODEL_ROOT=. sh tools/fixtures/d/declared_model_scan.sh 2>&1 ); }

add() { printf '%s\n' "$3" > "$1/$2"; ( cd "$1" && git add -A && git -c user.email=pen@pen -c user.name=pen commit -qm add ) >/dev/null 2>&1; }

# 1 -- every site agreeing reads ok.
build "$pen/agree" claude-opus-5
out=$(runscan "$pen/agree")
echo "$out" | grep -q 'verdict=ok' && echo "agreement_free=yes" || echo "agreement_free=no"
echo "$out" | grep -q 'declared_model=claude-opus-5' && echo "reading_reported=yes" || echo "reading_reported=no"

# 2 -- one declaring site naming a different model is bitten.
build "$pen/wrong" claude-opus-5
printf 'The loop runs `"model": "claude-opus-4-6"` at max effort.\n' > "$pen/wrong/recursion-prompts/seed/autonomous-loop.seed.md"
( cd "$pen/wrong" && git add -A && git -c user.email=pen@pen -c user.name=pen commit -qm drift ) >/dev/null 2>&1
out=$(runscan "$pen/wrong")
echo "$out" | grep -q 'verdict=disagreement' && echo "stale_site_bitten=yes" || echo "stale_site_bitten=no"
echo "$out" | grep -q 'declaring_over=1' && echo "stale_site_counted=yes" || echo "stale_site_counted=no"

# 3 -- an absent declaring site is bitten, rather than silently skipped.
build "$pen/absent" claude-opus-5
rm -f "$pen/absent/GLOW_PROFILE.template.kyri"
( cd "$pen/absent" && git add -A && git -c user.email=pen@pen -c user.name=pen commit -qm rm ) >/dev/null 2>&1
out=$(runscan "$pen/absent")
echo "$out" | grep -q 'is named on the declaring roster and absent' && echo "absent_site_bitten=yes" || echo "absent_site_bitten=no"

# 4 -- a site recounting old models BESIDE the current one passes free. Presence, never absence.
build "$pen/history" claude-opus-5
printf 'This clone ran claude-opus-4-8, then claude-opus-4-6, and runs `model claude-opus-5` today.\n' > "$pen/history/.claude/rules/session-logs.md"
( cd "$pen/history" && git add -A && git -c user.email=pen@pen -c user.name=pen commit -qm hist ) >/dev/null 2>&1
out=$(runscan "$pen/history")
echo "$out" | grep -q 'verdict=ok' && echo "history_free=yes" || echo "history_free=no"

# 5 -- dated testimony naming another model passes free, two ways.
build "$pen/dated" claude-opus-5
mkdir -p "$pen/dated/session-logs/date/20260815"
add "$pen/dated" "session-logs/20260815-101010_a-log.kyri" "model claude-opus-4-8"
add "$pen/dated" "session-logs/date/20260815/20260815-101011_b.kyri" "model claude-opus-4-8"
printf 'model claude-opus-4-8\n' > "$pen/dated/session-logs/date/README-index-20260815.md"
( cd "$pen/dated" && git add -A && git -c user.email=pen@pen -c user.name=pen commit -qm dated ) >/dev/null 2>&1
out=$(runscan "$pen/dated")
echo "$out" | grep -q 'drift_candidates=0' && echo "dated_free=yes" || echo "dated_free=no"
echo "$out" | grep -q 'verdict=ok' && echo "dated_verdict_ok=yes" || echo "dated_verdict_ok=no"

# 6 -- a LIVING file naming another model is counted as drift, and the ceiling bites from both sides.
build "$pen/ratchet" claude-opus-5
add "$pen/ratchet" "one.md" "generated by claude-opus-4-6"
out=$(runscan "$pen/ratchet")
echo "$out" | grep -q 'drift_candidates=1' && echo "living_drift_counted=yes" || echo "living_drift_counted=no"
echo "$out" | grep -q 'verdict=ok' && echo "at_ceiling_free=yes" || echo "at_ceiling_free=no"
add "$pen/ratchet" "two.md" "generated by claude-opus-4-6"
out=$(runscan "$pen/ratchet")
echo "$out" | grep -q 'drift_candidates=2' && echo "over_ceiling_counted=yes" || echo "over_ceiling_counted=no"
echo "$out" | grep -q 'verdict=disagreement' && echo "over_ceiling_bitten=yes" || echo "over_ceiling_bitten=no"

# 7 -- claude-code and .claude-state are not model ids, and must not be read as drift.
build "$pen/notmodel" claude-opus-5
add "$pen/notmodel" "prose.md" "Run claude-code from .claude-state via launch-claude-chapter.rish."
out=$(runscan "$pen/notmodel")
echo "$out" | grep -q 'drift_candidates=0' && echo "claude_word_free=yes" || echo "claude_word_free=no"

# 8 -- the reading refuses rather than defaulting when it cannot read.
build "$pen/norefuse" claude-opus-5
rm -f "$pen/norefuse/.claude/settings.json"
if ( cd "$pen/norefuse" && DECLARED_MODEL_ROOT=. sh tools/fixtures/d/declared_model.sh model ) >/dev/null 2>&1
then echo "absent_settings_refused=no"; else echo "absent_settings_refused=yes"; fi

build "$pen/nokey" claude-opus-5
printf '{ "effortLevel": "max" }\n' > "$pen/nokey/.claude/settings.json"
if ( cd "$pen/nokey" && DECLARED_MODEL_ROOT=. sh tools/fixtures/d/declared_model.sh model ) >/dev/null 2>&1
then echo "missing_key_refused=no"; else echo "missing_key_refused=yes"; fi

# 9 -- the reading resolves the settings file from its own location, never the caller's cwd.
build "$pen/cwd" claude-opus-5
got=$( cd / && DECLARED_MODEL_ROOT="$pen/cwd" sh "$pen/cwd/tools/fixtures/d/declared_model.sh" model 2>/dev/null )
[ "$got" = "claude-opus-5" ] && echo "reading_root_anchored=yes" || echo "reading_root_anchored=no ($got)"

echo "control_verdict=ok"
