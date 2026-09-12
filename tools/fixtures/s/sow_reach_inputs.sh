#!/bin/sh
# sow_reach_inputs.sh -- name the inputs used to count allowed seed rooms.
# Source this file and call sow_reach_inputs with one manifest path.
# The receipt covers manifest bytes and the coverage STATE of each allowed room.
# It is coverage provenance; privacy and file contents need their own witnesses.
#
# WHY A STATE RATHER THAN AN INVENTORY (REDS %660 refined, 20260909). The elder
# receipt hashed `git ls-files` under the allow entries, so every commit adding a
# tracked file under an allowed room -- a session log, a witness, a shelf -- read
# as stale coverage on the next ship's cold endurance run. Eight ships pay that refusal
# every lap, and each pays it by re-running the projector rather than by learning
# anything: the reader's question is whether an allowed room LEAVES files in the
# projection, and one more file in a room already answered cannot change it.
#
# So the receipt keys on what the reader actually branches on, one line per allow
# row: `subex` (withheld whole by the manifest), `barren` (the field carries no
# tracked file), `unshippable` (every tracked file is sub-excluded), `shippable`
# (the room owes the projection files). A room changing class is a real coverage
# change and still refuses; a file landing beside its siblings is not.
#
# WHAT THE KEY NO LONGER SEES, named rather than hidden: removing the last
# tracked file that the projector logged in an absent room leaves the class at
# `shippable` while flipping that room from `withheld_by_design` to `empty`. The
# scan then reports the room and the witness reds -- a LOUD reading a hand
# resolves by re-projecting, rather than a silent pass. The fail direction is the
# safe one, which is why the per-file inventory is not kept for that one case.

sow_reach_inputs() (
  set -eu
  [ "$#" -eq 1 ] && [ -f "$1" ] || {
    echo "sow-reach: one existing manifest is required" >&2; exit 2;
  }
  manifest=$1
  manifest_hash=$(git hash-object -- "$manifest") || exit 2

  # The manifest's own two lists. `sub_exclude` withholds a path and everything
  # under it, which is exactly how the reader spells it.
  subex=$(awk '$1 == "sub_exclude" { print $2 }' "$manifest") || exit 2
  is_subex() {
    for x in $subex; do
      case "$1" in "$x"|"$x"/*) return 0;; esac
    done
    return 1
  }

  rooms=""
  for path in $(awk '$1 == "allow" { print $2 }' "$manifest"); do
    if is_subex "$path"; then
      rooms="$rooms$path subex
"
      continue
    fi
    # Bounded at 400 tracked files per room, the same bound the reader takes, so
    # the receipt and the reading can never disagree about what they looked at.
    # Read first, truncate second: a pipeline reports the LAST command's status,
    # so `ls-files | head` would read a failed git as an empty room and write a
    # receipt for a reading that never happened.
    listed=$(git -c core.quotePath=true ls-files -- "$path") || exit 2
    if [ -z "$listed" ]; then
      rooms="$rooms$path barren
"
      continue
    fi
    tracked=$(printf '%s\n' "$listed" | head -400)
    state=unshippable
    for f in $tracked; do
      is_subex "$f" || { state=shippable; break; }
    done
    rooms="$rooms$path $state
"
  done

  rooms_hash=$(printf '%s' "$rooms" | git hash-object --stdin) || exit 2
  printf 'reach_manifest %s\nreach_rooms %s\n' "$manifest_hash" "$rooms_hash"
)
