#!/bin/sh
# tools/p/pier_jq_install.sh -- infuse jq into the SEA pier's system packages.
#
# Run as root, on the pier:   sudo sh tools/p/pier_jq_install.sh
#
# What it does, and why: the autonomous season loop streams Claude Code with
# `--output-format stream-json --verbose`, which emits one JSON event per line.
# Without `jq` that NDJSON is only raw-readable; with `jq` the operator sees a
# clean live text stream (the filter lives in recursion-prompts/README.md). This
# adds `jq` to environment.systemPackages declaratively and rebuilds, so the tool
# is present on every future boot, not just a throwaway `nix-shell -p jq`.
#
# Safe by construction (same discipline as pier_mosh_udp_open.sh):
#   * ADDITIVE   -- it inserts one package line into environment.systemPackages and
#     touches nothing else, so it cannot lock you out or change a service.
#   * IDEMPOTENT -- if jq is already a listed package it skips the edit and just
#     rebuilds to be sure.
#   * GUARDED    -- it refuses unless this is the SEA pier (hostName pier + the SEA
#     VPS marker), rather than editing an unknown host.
#   * REVERSIBLE -- it backs up configuration.nix first, validates the edited file
#     with `nix-instantiate --parse` BEFORE moving it into place, and relies on the
#     atomic `nixos-rebuild switch` (a build failure leaves the running system as-is).
set -eu

CFG=/etc/nixos/configuration.nix
FLAKE=/etc/nixos
HOST=pier

# --- guards: the pier, SEA -- else stop and report ---
[ -f "$CFG" ] || { echo "REFUSE: $CFG not found — this is not the pier."; exit 2; }
grep -q 'networking.hostName = "pier"' "$CFG" || { echo "REFUSE: hostName is not \"pier\"."; exit 2; }
grep -q 'vultr SEA VPS' "$CFG" || { echo "REFUSE: no SEA VPS marker — SEA only, never EWR."; exit 2; }
grep -q 'environment.systemPackages = with pkgs; \[' "$CFG" || { echo "REFUSE: systemPackages block not in the expected shape — stop and report, do not guess."; exit 2; }

# --- idempotent edit ---
if grep -qE '^[[:space:]]*jq([[:space:]]|$)' "$CFG"; then
  echo "present already: jq in $CFG — skipping edit, rebuilding to be sure."
else
  ts=$(date +%Y%m%d-%H%M%S)
  cp -a "$CFG" "$CFG.bak-$ts"
  echo "backup: $CFG.bak-$ts"
  awk '
    { print }
    /environment\.systemPackages = with pkgs; \[/ && !done {
      print "    jq       # JSON — live stream-json rendering for the season loop (agent visibility)"
      done=1
    }
  ' "$CFG" > "$CFG.new"

  # validate the edited file parses as Nix BEFORE putting it in place
  if nix-instantiate --parse "$CFG.new" >/dev/null 2>&1; then
    mv "$CFG.new" "$CFG"
    echo "edited: added jq to environment.systemPackages in $CFG"
  else
    rm -f "$CFG.new"
    echo "REFUSE: edited config failed nix-instantiate --parse — left $CFG unchanged."
    exit 1
  fi
fi

echo "=== the systemPackages region of $CFG ==="
grep -nE -A14 'environment\.systemPackages' "$CFG" || true

echo "=== rebuild: nixos-rebuild switch --flake $FLAKE#$HOST ==="
if nixos-rebuild switch --flake "$FLAKE#$HOST"; then
  echo "rebuild: OK"
else
  echo "rebuild: FAILED — the running system is unchanged (switch is atomic). Stop here."
  exit 1
fi

echo "=== proof ==="
nixos-version
command -v jq && jq --version || { echo "jq still not on PATH — stop and report."; exit 1; }
echo "DONE — the season loop can now pipe stream-json through jq (see recursion-prompts/README.md)."
