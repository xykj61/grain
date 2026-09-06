#!/bin/sh
# publish_template_control.sh -- the shipped publisher's two gates, proven in a pen.
#
# Every refusal is planted and then LIFTED, because a gate proven only in the passing direction
# cannot be told from a gate that never fires.
#
#   sh tools/fixtures/p/publish_template_control.sh
#
# Prints `pass=N fail=N`. Bounded: 11 cases, one pen.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
cd "$root"

scan=tools/fixtures/p/publish_template_scan.sh
pen=${TMPDIR:-/tmp}/publish-template-pen-$$
trap 'rm -rf "$pen"' EXIT INT TERM
mkdir -p "$pen"

pass=0; fail=0
check() { if [ "$3" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2; fi; }
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

cp publish-seed.template.sh "$pen/tpl.sh"
cp GLOW_PROFILE.template.kyri "$pen/profile.kyri"
ask() { PUBLISH_TEMPLATE="$pen/tpl.sh" PUBLISH_PROFILE="$pen/profile.kyri" sh "$scan" 2>&1; }

# 1-4) the living pair reads clean on both gates
out=$(ask)
check "the living template leaks nothing"   yes "$(has "$out" 'leaked=0')"
check "and orphans no stub"                 yes "$(has "$out" 'orphan=0')"
check "five stubs are found"                yes "$(has "$out" 'stubs=5')"
check "five fields answer them"             yes "$(has "$out" 'fields=5')"

# 5-6) a planted literal is bitten, and lifting it returns the pass
printf "\n# git@github.com:grain-os/grain.git\n" >> "$pen/tpl.sh"
out=$(ask)
check "a planted remote literal is caught"  yes "$(has "$out" 'leaked: grain-os/grain')"
check "and the gate counts it"              yes "$(has "$out" 'leaked=1')"
cp publish-seed.template.sh "$pen/tpl.sh"
check "lifting the literal returns clean"   yes "$(has "$(ask)" 'leaked=0')"

# 7-8) a stub the profile cannot answer is bitten, and lifting it returns the pass
printf "SEED_NEW_THING='FILL_ME:x'\n" >> "$pen/tpl.sh"
out=$(ask)
check "an unanswerable stub is caught"      yes "$(has "$out" 'orphan: SEED_NEW_THING')"
cp publish-seed.template.sh "$pen/tpl.sh"
check "lifting the stub returns clean"      yes "$(has "$(ask)" 'orphan=0')"

# 9) an unfilled copy refuses BEFORE it projects -- the failure this template exists to prevent
out=$(cd "$pen" && sh tpl.sh 2>&1 || true)
check "an unfilled publisher refuses"       yes "$(has "$out" 'a stub is unfilled')"

# 10) a missing profile refuses rather than reading clean (REDS %170)
check "an absent profile refuses"           yes "$(has "$(PUBLISH_TEMPLATE="$pen/tpl.sh" PUBLISH_PROFILE="$pen/nowhere.kyri" sh "$scan" 2>&1 || true)" 'refused: no profile')"

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
