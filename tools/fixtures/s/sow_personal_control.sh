#!/bin/sh
# tools/fixtures/s/sow_personal_control.sh -- prove the seed's key-material wall can red.
#
#   sh tools/fixtures/s/sow_personal_control.sh
#
# WHY. tools/fixtures/s/sow_personal_scan.sh is the wall between a real credential and a
# repository meant to carry none. tools/s/sow_witness.rish's duty 4 trusts its NO_PERSONAL
# answer. Until 20260920 nothing had ever planted a key in front of it and watched it answer --
# the same gap sow_leak_control.sh closed for the identity wall at REDS row 59: a guard that
# cannot red guards nothing.
#
# WHY IT EARNED A CONTROL THIS PARTICULAR DAY. A real OpenRouter API key was pasted into a chat
# session and, in the same breath, the operator asked whether the publish pipeline would catch
# one like it. The honest answer was no -- sow_personal_scan.sh's embedded-key guard matched
# only SSH and PGP key SHAPES, and a bearer token is a different shape entirely. The scan's own
# regex was widened the same round; this control is what proves the widening actually bites.
#
# EVERY CASE RUNS IN A PEN. The scan reads a relative `seed` from its own working directory, so
# each case runs with its cwd inside a throwaway copy holding a seed/ of its own. The real
# seed/ stays untouched, no projection runs, and custody gate %1 sits far from this file.
# template-manifest.bron is read too (for the `personal`/`sub_exclude` halves of the scan), so
# each pen also carries an empty one -- absent, the scan's own `grep` warns to stderr and reads
# no rows, which is the same "nothing personal, nothing sub_excluded" answer an empty file gives.
#
# WHAT IS PROVEN, both directions, on real directories:
#
#   1 bitten  -- a planted OpenRouter key (sk-or-v1-...) reads PERSONAL_BAD
#   2 bitten  -- an Anthropic-shaped key (sk-ant-...) reads PERSONAL_BAD
#   3 bitten  -- a GitHub personal access token (ghp_...) reads PERSONAL_BAD
#   4 bitten  -- an AWS access key ID (AKIA...) reads PERSONAL_BAD
#   5 bitten  -- the reader is told which file carries the leak
#   6 free    -- the OpenRouter placeholder this tree's own docs write (sk-or-v1-...,
#                three literal dots) reads NO_PERSONAL -- a template stays a template
#   7 free    -- an ordinary page of prose reads NO_PERSONAL
#   8 bitten  -- the elder guard's own subject, an embedded SSH public key, still reads
#                PERSONAL_BAD after the widening (the new pattern must not crowd out the old)
#   9 bitten  -- a Together AI-shaped key (tgp_v1_...) reads PERSONAL_BAD -- added the same
#                day a real Together key was confirmed live, widening the guard on sight
#
# Run from the repository root.
set -eu

ROOT=$(pwd -P)
SCAN="${SOW_PERSONAL_SCAN:-$ROOT/tools/fixtures/s/sow_personal_scan.sh}"
[ -f "$SCAN" ] || { echo "control_verdict=absent_scan" >&2; exit 2; }

PASS=0
FAIL=0
PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

check() {
  # check <label> <expected> <actual>
  if [ "$2" = "$3" ]; then
    PASS=$((PASS + 1)); echo "$1 -- ok"
  else
    FAIL=$((FAIL + 1)); echo "$1 -- FAIL (wanted $2, got $3)"
  fi
}

verdict=""
detail=""
run_case() {
  # run_case <case> <relative-path-under-seed> <content>
  d="$PEN/$1"
  rm -rf "$d"
  mkdir -p "$d/seed/$(dirname "$2")"
  : > "$d/template-manifest.bron"
  printf '%s\n' "$3" > "$d/seed/$2"
  out=$(cd "$d" && sh "$SCAN")
  verdict=$(printf '%s\n' "$out" | head -1)
  detail=$(printf '%s\n' "$out" | sed -n '2p')
}

# The credential fragments below are assembled at runtime, for the same reason
# sow_leak_control.sh assembles its own name fragments: this control is a tracked
# file, and a wall that hunts a literal must never be fed that literal by the
# thing testing it. None of these are real -- they are shaped like the real
# thing, which is exactly what the widened regex reads for.
OR_KEY="sk-or-v1-""$(printf '%040d' 1)"
ANT_KEY="sk-ant-""api03-fakefakefakefakefakefakefakefakefakefakefakefakefake"
GH_KEY="ghp_""fakeFakeFakeFakeFakeFakeFakeFakeFake"
AWS_KEY="AKIA""FAKE0FAKE0FAKE0FAKE"
TOGETHER_KEY="tgp_v1_""$(printf '%040d' 2)"

# ---- 1: an OpenRouter-shaped key reds -------------------------------------------------
run_case openrouter "notes/a.md" "export OPENROUTER_API_KEY=\"$OR_KEY\""
check "1 bitten: an OpenRouter-shaped key plant reads PERSONAL_BAD" PERSONAL_BAD "$verdict"

# ---- 2: an Anthropic-shaped key reds --------------------------------------------------
run_case anthropic "a.md" "export ANTHROPIC_API_KEY=\"$ANT_KEY\""
check "2 bitten: an Anthropic-shaped key plant reads PERSONAL_BAD" PERSONAL_BAD "$verdict"

# ---- 3: a GitHub PAT reds --------------------------------------------------------------
run_case github "a.md" "curl -H \"Authorization: token $GH_KEY\" https://api.github.com"
check "3 bitten: a GitHub PAT plant reads PERSONAL_BAD" PERSONAL_BAD "$verdict"

# ---- 4: an AWS access key ID reds -------------------------------------------------------
run_case aws "a.md" "AWS_ACCESS_KEY_ID=$AWS_KEY"
check "4 bitten: an AWS access key ID plant reads PERSONAL_BAD" PERSONAL_BAD "$verdict"

# ---- 5: the reader is told which file carries it ---------------------------------------
run_case named "notes/deep/b.md" "export OPENROUTER_API_KEY=\"$OR_KEY\""
case "$detail" in
  "key files:"*|"embedded key material:"*seed/notes/deep/b.md*) got=named;;
  *) got="$detail";;
esac
check "5 bitten: the leak names the file that carries it" named "$got"

# ---- 6: this tree's own placeholder shape stays clean -----------------------------------
run_case placeholder "a.md" "export OPENROUTER_API_KEY=\"sk-or-v1-...\""
check "6 free: the tree's own sk-or-v1-... placeholder reads NO_PERSONAL" NO_PERSONAL "$verdict"

# ---- 7: an ordinary page walks free ------------------------------------------------------
run_case clean "a.md" "an ordinary page of prose about bounded loops"
check "7 free: an ordinary page of prose reads NO_PERSONAL" NO_PERSONAL "$verdict"

# ---- 8: the elder guard's own subject still reds after the widening --------------------
run_case sshkey "a.md" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFakeFakeFakeFakeFakeFakeFake user@host"
check "8 bitten: an embedded SSH public key still reads PERSONAL_BAD" PERSONAL_BAD "$verdict"

# ---- 9: a Together AI-shaped key reds ----------------------------------------------------
run_case together "a.md" "export TOGETHER_API_KEY=\"$TOGETHER_KEY\""
check "9 bitten: a Together AI-shaped key plant reads PERSONAL_BAD" PERSONAL_BAD "$verdict"

echo "control_cases=$((PASS + FAIL))"
echo "control_fail=$FAIL"
if [ "$FAIL" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=drift"
  exit 1
fi
