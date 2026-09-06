#!/bin/sh
# fleet_lap.sh -- one lap's agent invocation, run INSIDE the enclosure.
#
# WHY THIS FILE EXISTS, and it is a flag collision rather than a design choice. Claude Code refuses
# `--output-format stream-json` without `--verbose` ("When using --print, --output-format=stream-json
# requires --verbose"), and **ai-jail owns `-v, --verbose` itself**. Worse, its guard fires on a
# known flag appearing after the command even when `--` was passed -- its own refusal reads *put
# sandbox flags before the command or use --*, and `tools/ag/agent-jail.sh` had already used `--`.
# Eight laps of the pheromone and petrichor loops died on that line in under a minute apiece
# (REDS %414).
#
# So the flags move where the sandbox cannot read them. The jail's argv becomes
# `sh tools/f/fleet_lap.sh <seat>` -- not one flag in it -- and every flag claude needs is spelled
# here, inside, where only claude sees them.
#
# IT ALSO RETIRES THE ARGV PROMPT. The seat text used to ride as one enormous `-p` argument through
# two layers of shell; here it is read from the files directly, so the apostrophe that stranded
# Silence's loop on `20260829` has nowhere left to bite.
#
#   sh tools/f/fleet_lap.sh incense          # inside the jail, or bare on Darwin
set -eu

seat=${1:-}
[ -n "$seat" ] || { echo "fleet-lap: want a seat name" >&2; exit 2; }

root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
cd "$root"

# THE ROOM IS THE SEAT'S OWN FIRST LETTER (`20260906`). `tools/` folds by first sprig letter
# and `tool_path_resolve.rish` computes a room from a basename, so a prompt named
# `bakery_seat_prompt.txt` lives in `tools/b/` -- eleven seats, eleven rooms. A literal
# `tools/l/` was invisible to the reference sweep that moved them, because a path built at
# runtime is not a path any grep can see. Derived here, so a seat added tomorrow arrives
# with its prompt findable by the same one rule.
prompt_room=$(printf '%s' "$seat" | cut -c1)
prompt_file="tools/${prompt_room}/${seat}_seat_prompt.txt"
[ -f "$prompt_file" ] || { echo "fleet-lap: missing seat prompt $prompt_file" >&2; exit 2; }

# The baton is prepended here rather than copied into each stanza (REDS %411): one shared opening,
# read by every ship, and a stanza that carries only its lane.
baton_file=tools/f/fleet_baton.txt
prompt=$(
  if [ -f "$baton_file" ]; then cat "$baton_file"; printf '\n'; fi
  cat "$prompt_file"
)

exec claude --dangerously-skip-permissions --effort max \
  --output-format stream-json --verbose -p "$prompt"
