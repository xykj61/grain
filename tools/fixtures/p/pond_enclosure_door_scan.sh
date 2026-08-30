#!/usr/bin/env sh
# pond_enclosure_door_scan.sh -- can the program the launcher runs actually START inside the enclosure?
#
# WHAT THIS ASKS. Orbit four of the quest that retires ai-jail is named "the doors": the launchers
# enter through Pond instead of the jail, done when a full working chapter lap runs start to finish
# inside a Pond enclosure. Three guards already read this enclosure and all three read the ROOM --
# pond_policy_launcher_scan.sh compares the record against the flags the launcher spells,
# pond_enclosure_built_scan.sh against the plan the jail builds, pond_enclosure_ephemeral_scan.sh
# against how long a written byte lasts. Room, room, time. None of them reads the DOOR: which program
# walks in, carrying which environment, as which user. That is one line of the launcher, its last:
#
#   exec "$AIJAIL_ABS" ... -- env "GH_CONFIG_DIR=$GH_STATE" "PATH=$JAIL_PATH" "$AGENT_BIN" ...
#
# THE RULE, DERIVED FROM THE RECORD RATHER THAN FROM A ROSTER. A host path is reachable inside when a
# `map`, `persist`, or `rw-map` destination covers it -- equal to it or an ancestor of it -- and no
# `mask` line covers it more closely. `ephemeral` and `fresh` name subtrees born empty, so a path
# strictly beneath one is reachable only where a second line declares it, and `private-home yes`
# makes the home exactly such a subtree.
#
# AND THE SECOND HALF, WHICH ONLY METAL TEACHES: A MAP CARRIES WHAT THE HOST HAS, AND CONJURES
# NOTHING. So a declared path whose host side is absent arrives absent, and the prediction each
# element earns is:
#
#   declared and host-present  ->  present inside
#   declared and host-absent   ->  absent inside   (the map had nothing to carry)
#   undeclared                 ->  absent inside   (the tmpfs withholds it)
#
# Measured on this pier `20260829` under --probe, all four elements of the launcher's own search path
# answered as derived, so the rule above is the kernel's rule rather than this scan's guess.
#
# THE READINGS
#   entry_unreachable    the resolved agent binary under no declared subtree     ZERO, ENFORCED
#   door_disagreements   a derived answer the running enclosure contradicts      ZERO, ENFORCED (--probe)
#   path_undeclared      search-path elements under no declared subtree          ratchet, only falls
#   path_host_absent     search-path elements the host itself lacks              machine fact, reported
#   env_undeclared       an env path value under no declared subtree             reported
#   duties_undeclared    door duties the record's grammar cannot express at all  reported
#   env_disagreements    a declared env assignment the exec line does not make   ZERO, ENFORCED
#   probe_*              the same questions asked inside a running enclosure     reported
#
# WHY THE RATCHET IS THE DERIVED HALF AND THE MACHINE FACT IS NOT. `path_undeclared` reads the record
# against the launcher and answers the same on every pier, so a ceiling over it means something
# everywhere. `path_host_absent` answers differently on a bench that never had a directory, and a
# ceiling over that would red the second pier for owning a different filesystem -- gated where the
# requirement is known rather than where it is discovered.
#
# WHY THE GATE SITS ON THE ENTRY. An enclosure that cannot start the one program it exists to run is
# the shape that is always wrong, whatever else the record gets right. Everything beside it describes
# an enclosure this tree did not write: two of the four search-path elements are dead on this pier,
# one because the host never made it and one because the private home dissolves it, and the launcher
# runs anyway because the first element carries every binary. Repairing that line edits a launcher
# every unattended lap on this pier executes, so the count is measured and held down rather than
# swept by the lap that found it.
#
# THE PROBE, and how it differs from orbit three's. --probe starts one real enclosure and asks it
# what it can see. It writes NOTHING -- on the host or inside -- where the ephemeral scan's probe
# plants markers by necessity, because a question about lifetime needs something to outlive the
# close and a question about reach does not. It is opt-in all the same: starting an enclosure is a
# real act, and an ordinary run of this scan starts none.
#
# THE READING BESIDE IT. active-designing/20260829-064107_the-door-the-record-cannot-name.md argues
# what these counts mean and what each of the three undeclared duties would cost to seat.
#
#   sh tools/fixtures/p/pond_enclosure_door_scan.sh [--root DIR] [--policy FILE] [--launcher FILE]
#                                                   [--entry PATH] [--probe]
#
# ACCRETE-ONLY. This reads Pond's record and the launcher's own exec line, and rewrites neither. It
# flips nothing: the ENCLOSURE selector stays ai-jail until the switchover round lands behind its
# audit, and every markdown that instructs a reader about the jail stands untouched.
set -eu

# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done

# THE DIALECT HELPERS, sourced here on purpose: `--root` below repoints ROOT at a pen, and a pen
# holds a record and a launcher rather than this library. `resolve_path` replaces the GNU-only
# `-f` spelling of readlink, which BSD carried for none of its life and macOS gained only lately,
# so reaching for it bets on the age of the second bench rather than on a spelling both accept.
. "$ROOT/tools/fixtures/s/shell_portable.sh"

POLICY_OVERRIDE=""
LAUNCHER_OVERRIDE=""
ENTRY_OVERRIDE=""
WANT_PROBE=no
while [ $# -gt 0 ]; do
  case "$1" in
    --root) ROOT=$2; shift 2 ;;
    --policy) POLICY_OVERRIDE=$2; shift 2 ;;
    --launcher) LAUNCHER_OVERRIDE=$2; shift 2 ;;
    --entry) ENTRY_OVERRIDE=$2; shift 2 ;;
    --probe) WANT_PROBE=yes; shift ;;
    *) echo "pond_enclosure_door_scan: unknown argument: $1" >&2; exit 2 ;;
  esac
done

POLICY="${POLICY_OVERRIDE:-$ROOT/pond/enclosure_policy.kyri}"
LAUNCHER="${LAUNCHER_OVERRIDE:-$ROOT/tools/ag/agent-jail.sh}"

# invariant: a comparison needs both halves, so an absent one is named rather than guessed at.
if [ ! -f "$POLICY" ]; then echo "scan=absent detail=no_policy"; echo "verdict=unreadable"; exit 1; fi
if [ ! -f "$LAUNCHER" ]; then echo "scan=absent detail=no_launcher"; echo "verdict=unreadable"; exit 1; fi

# max_path_elements bounds the search path this reading will walk: four elements stand today, and
# sixteen refuses a generated PATH while leaving room for a launcher that quadruples its own.
# max_env bounds the env assignments on the exec line: two stand today, same reasoning at the same
# scale. Both are named here because an unbounded roster read out of a file somebody else edits is
# an unbounded allocation wearing a grep's clothes.
max_path_elements=16
max_env=8

# path_undeclared_ceiling -- a RATCHET that only falls. One search-path element sits under no
# declared subtree on every pier: ${HOST_HOME}/.nix-profile/bin, which `private-home yes` dissolves
# into a fresh tmpfs. Removing it edits the launcher every unattended lap on this pier executes, so
# the number is measured and held down rather than gated at zero by a lap that cannot pay for the
# consequence.
path_undeclared_ceiling=1

echo "pond_enclosure_door_scan v1"
echo "record=${POLICY#"$ROOT/"}"
echo "launcher=${LAUNCHER#"$ROOT/"}"

work=$(mktemp -d) || { echo "scan=absent detail=no_workspace"; echo "verdict=unreadable"; exit 1; }
cleanup() { rm -rf "$work"; }
trap cleanup EXIT INT TERM

# ---------------------------------------------------------------------------
# THE DOOR, LIFTED FROM THE LAUNCHER RATHER THAN COPIED HERE.
#
# The search path and the env assignments are read out of tools/ag/agent-jail.sh at run time, the
# way pond_enclosure_ephemeral_scan.sh lifts plan_rows() out of its own sibling, so a launcher that
# adds an element or an environment variable is read on the next run rather than on the next edit
# of this file. Losing either line makes this refuse rather than guess.
# ---------------------------------------------------------------------------
jail_path_line=$(grep -m1 '^JAIL_PATH=' "$LAUNCHER" || true)
exec_line=$(grep -m1 -A1 'exec "\$AIJAIL_ABS"' "$LAUNCHER" | tr '\n' ' ' || true)
if [ -z "$jail_path_line" ] || [ -z "$exec_line" ]; then
  echo "detail: the launcher no longer publishes JAIL_PATH= and its exec line"
  echo "verdict=unreadable"; exit 1
fi

# The record's own halves. `record_home` is the home the record writes its rw-map destinations
# under -- derived from the destination ending in /.claude, which the launcher builds as
# "${HOST_HOME}/.claude", so the two namespaces line up by construction rather than by convention.
grep -v '^#' "$POLICY" | sed '/^[[:space:]]*$/d' > "$work/record"
sed -n 's/^map \(.*\)$/\1/p'     "$work/record" | sort -u >  "$work/reach"
sed -n 's/^persist \(.*\)$/\1/p' "$work/record" | sort -u >> "$work/reach"
sed -n 's/^rw-map [^:]*:\(.*\)$/\1/p' "$work/record" | sort -u >> "$work/reach"
sort -u "$work/reach" -o "$work/reach"
sed -n 's/^mask \(.*\)$/\1/p' "$work/record" | sort -u > "$work/mask"
private_home=$(sed -n 's/^private-home \(.*\)$/\1/p' "$work/record" | head -1)
[ -n "${private_home:-}" ] || private_home=unstated

record_home=$(sed -n 's#^rw-map [^:]*:\(.*\)/\.claude$#\1#p' "$work/record" | head -1)
if [ -z "${record_home:-}" ]; then
  # A PATH IS ONE OPERAND, so it is quoted rather than piped through a word splitter. The elder
  # spelling ended `| xargs -r dirname` and carried two faults. `-r` is a GNU extension BSD never
  # had. And xargs splits on blanks, so a `persist` path holding a space reached dirname as TWO
  # operands and came back as two lines -- measured on this pier `20260830`, where
  # `/home/user/my pier/loops/claude` answered `/home/user` and `pier/loops` in place of one path.
  # This leg is the fallback, latent while the rw-map line above answers on the living record, and
  # `record_home` is the namespace every later path comparison is measured against, so a wrong one
  # would be wrong everywhere at once rather than in one reading.
  _persist_first=$(sed -n 's/^persist \(.*\)$/\1/p' "$work/record" | head -1)
  if [ -n "$_persist_first" ]; then record_home=$(dirname "$_persist_first"); fi
fi
if [ -z "${record_home:-}" ]; then
  echo "detail: the record names no home, so a launcher path under \${HOST_HOME} cannot be placed"
  echo "verdict=unreadable"; exit 1
fi
record_pier=$(sed -n 's/^persist \(.*\)$/\1/p' "$work/record" | head -1)

# declared <path> -- is this path reachable inside, by the record's own lines? A `mask` covering it
# wins over any `map` above it, because a masked path is hidden whatever declared the subtree.
declared() {
  _p=$1
  while read -r _m; do
    [ -n "${_m:-}" ] || continue
    case "$_p" in "$_m"|"$_m"/*) return 1 ;; esac
  done < "$work/mask"
  while read -r _r; do
    [ -n "${_r:-}" ] || continue
    case "$_p" in "$_r"|"$_r"/*) return 0 ;; esac
  done < "$work/reach"
  return 1
}

# The host side of the same two namespaces, so a metal path can be spoken in the record's words.
host_home="${HOME:-/root}"
host_pier="$ROOT"
to_record() {
  echo "$1" | sed -e "s#^$host_pier#$record_pier#" -e "s#^$host_home#$record_home#"
}

# ---------------------------------------------------------------------------
# READING ONE -- the search path the launcher hands the agent.
# ---------------------------------------------------------------------------
jail_path=$(echo "$jail_path_line" | sed -e 's/^JAIL_PATH=//' -e 's/^"//' -e 's/"$//')
echo "$jail_path" | tr ':' '\n' | sed '/^[[:space:]]*$/d' > "$work/path.raw"
path_count=$(wc -l < "$work/path.raw" | tr -d ' ')
if [ "$path_count" -eq 0 ]; then
  echo "detail: the launcher's JAIL_PATH carries no elements"
  echo "verdict=unreadable"; exit 1
fi
if [ "$path_count" -gt "$max_path_elements" ]; then
  echo "detail: the launcher's JAIL_PATH carries $path_count elements past max_path_elements=$max_path_elements"
  echo "verdict=unbounded"; exit 1
fi

: > "$work/path.read"
while read -r elem; do
  [ -n "${elem:-}" ] || continue
  host_elem=$(echo "$elem" | sed -e "s#\${HOST_HOME}#$host_home#g" -e "s#\$HOME#$host_home#g")
  rec_elem=$(to_record "$host_elem")
  if declared "$rec_elem"; then decl=declared; else decl=undeclared; fi
  if [ -d "$host_elem" ]; then present=host_present; else present=host_absent; fi
  # A map carries what the host has and conjures nothing, so an element arrives only when BOTH hold.
  if [ "$decl" = declared ] && [ "$present" = host_present ]; then expect=present; else expect=absent; fi
  echo "$rec_elem $decl $present $expect $host_elem" >> "$work/path.read"
done < "$work/path.raw"

path_undeclared=$(awk '$2 == "undeclared"' "$work/path.read" | wc -l | tr -d ' ')
path_host_absent=$(awk '$3 == "host_absent"' "$work/path.read" | wc -l | tr -d ' ')
path_dead=$(awk '$4 == "absent"' "$work/path.read" | wc -l | tr -d ' ')

while read -r rec decl present expect host; do
  [ -n "${rec:-}" ] || continue
  if [ "$expect" = present ]; then
    echo "path: \`$rec\` arrives -- $decl by the record, $present on this bench"
  elif [ "$decl" = undeclared ]; then
    echo "note: \`$rec\` is on the launcher's search path and under no declared subtree, so the enclosure withholds it"
  else
    echo "note: \`$rec\` is declared and absent on this bench, so the map has nothing to carry"
  fi
done < "$work/path.read"

# ---------------------------------------------------------------------------
# READING TWO -- the entry: the one program the enclosure exists to start.
#
# The launcher resolves it with `command -v` and then `readlink -f`, so the path that actually
# reaches execve is the store path rather than the profile symlink, and the store path is what has
# to be reachable inside.
# ---------------------------------------------------------------------------
entry_host=""
if [ -n "$ENTRY_OVERRIDE" ]; then
  entry_host=$ENTRY_OVERRIDE
elif command -v claude >/dev/null 2>&1; then
  entry_host=$(resolve_path "$(command -v claude)" 2>/dev/null || true)
fi

entry_unreachable=0
if [ -z "${entry_host:-}" ]; then
  entry_state=unresolved
  echo "note: no agent binary resolves on this bench, so the entry reading is a machine fact and stands down"
else
  entry_rec=$(to_record "$entry_host")
  if declared "$entry_rec"; then
    entry_state=declared
    echo "entry: \`$entry_rec\` is reachable -- the record declares the subtree it resolves into"
  else
    entry_state=undeclared
    entry_unreachable=1
    echo "detail: the entry \`$entry_rec\` sits under no declared subtree, so the enclosure could not start it"
  fi
fi

# ---------------------------------------------------------------------------
# READING THREE -- the environment the exec line hands across the threshold.
# ---------------------------------------------------------------------------
echo "$exec_line" | tr ' ' '\n' | sed -e 's/^"//' -e 's/"$//' | grep -E '^[A-Z_][A-Z0-9_]*=' > "$work/env.raw" || true
env_count=$(wc -l < "$work/env.raw" | tr -d ' ')
if [ "$env_count" -gt "$max_env" ]; then
  echo "detail: the exec line carries $env_count env assignments past max_env=$max_env"
  echo "verdict=unbounded"; exit 1
fi

# Values the launcher spells as variables are expanded from the launcher's own assignments, so the
# reading follows the script rather than a second copy of its defaults kept here.
gh_state=$(grep -m1 '^GH_STATE=' "$LAUNCHER" | sed -e 's/^GH_STATE=//' -e 's/.*:-//' -e 's/}.*//' -e 's/"//g' || true)
gh_state=$(echo "${gh_state:-}" | sed -e "s#\$REPO#$host_pier#g")

env_undeclared=0
: > "$work/env.read"
while read -r assign; do
  [ -n "${assign:-}" ] || continue
  key=${assign%%=*}
  val=${assign#*=}
  case "$key" in
    PATH) continue ;;                       # read whole, above, as the search path
    GH_CONFIG_DIR) val=$gh_state ;;
    *) val=$(echo "$val" | sed -e "s#\${HOST_HOME}#$host_home#g" -e "s#\$HOME#$host_home#g") ;;
  esac
  case "$val" in
    /*) ;;
    *) echo "$key - unresolved" >> "$work/env.read"; continue ;;
  esac
  rec_val=$(to_record "$val")
  if declared "$rec_val"; then
    echo "$key $rec_val declared" >> "$work/env.read"
  else
    echo "$key $rec_val undeclared" >> "$work/env.read"
    env_undeclared=$((env_undeclared + 1))
  fi
done < "$work/env.raw"

while read -r key val state; do
  [ -n "${key:-}" ] || continue
  if [ "$state" = declared ]; then
    echo "env: \`$key\` points at \`$val\`, which the record declares"
  elif [ "$state" = undeclared ]; then
    echo "detail: \`$key\` points at \`$val\`, under no declared subtree, so what the agent writes there dissolves"
  else
    echo "note: \`$key\` names no absolute path this reading can place"
  fi
done < "$work/env.read"

# ---------------------------------------------------------------------------
# READING FOUR -- the duties the record's grammar cannot express at all.
#
# The three below are what the exec line decides and the record has no key for. This is orbit four's
# own gap, counted rather than argued: a Pond enclosure that replaces this launcher has to answer
# each of them, and today the record cannot even state the question.
# ---------------------------------------------------------------------------
duties_undeclared=0
: > "$work/duties"
for duty in entry env user; do
  if grep -q "^$duty " "$work/record"; then
    echo "$duty declared" >> "$work/duties"
  else
    echo "$duty absent" >> "$work/duties"
    duties_undeclared=$((duties_undeclared + 1))
  fi
done
while read -r duty state; do
  [ "$state" = absent ] || continue
  case "$duty" in
    entry) echo "gap: the record names no \`entry\` -- which program the enclosure starts lives in the launcher alone" ;;
    env)   echo "gap: the record names no \`env\` -- the environment crossing the threshold lives in the launcher alone" ;;
    user)  echo "gap: the record names no \`user\` -- the uid the agent runs as lives in the launcher alone" ;;
  esac
done < "$work/duties"

# The `user` declaration, lifted here and settled by the probe below. A duty the record can now
# state is a duty something has to check, or the key is a comment with a colon in it -- so the
# declared value is read on the derived leg and compared against a running kernel on the metal one.
# `unstated` is the pre-seating shape and stays free: a record that names no user makes no claim,
# and the gap count above is already the reading for that.
user_declared=$(sed -n 's/^user \(.*\)$/\1/p' "$work/record" | head -1)
[ -n "${user_declared:-}" ] || user_declared=unstated
if [ "$user_declared" = invoking ]; then
  echo "user: the record declares \`user invoking\`, so the enclosure runs the agent as whoever opened the door"
elif [ "$user_declared" != unstated ]; then
  echo "user: the record declares \`user $user_declared\`, a fixed uid the probe leg settles against the kernel"
fi


# ---------------------------------------------------------------------------
# THE `env` DECLARATION, SETTLED AGAINST THE EXEC LINE THAT MAKES IT.
#
# The duty count above says the record CAN state its environment; this reading asks whether what it
# states is true. The instrument is the exec line itself, which is the ground truth for what crosses
# this threshold, so the settling is fully derived and answers the same on every pier -- no probe,
# no jail, no kernel. That is why it gates at zero where `path_host_absent` only reports: one reads
# the record against the launcher, the other reads one bench's own filesystem.
#
# BOTH DIRECTIONS COUNT. A declared assignment the launcher does not spell is the `network off`
# fault wearing a third mark (REDS %329) -- a claim nothing keeps. A spelled assignment the record
# does not declare is the gap this mark was seated to close, still standing. And a key both sides
# name at different values is the drift that would otherwise stay invisible, since each side reads
# fine alone.
#
# THE NAMESPACES LINE UP FIRST. The record writes the placeholder convention its own header explains
# (/home/youruser and its project bind) while the launcher spells host paths, so every spelled value
# goes through `to_record` before any comparison. PATH is rebuilt from the elements reading one
# already normalized, in the launcher's own order, rather than normalized a second time here.
#
# UNSTATED IS FREE. A record naming no `env` at all makes no claim, and `duties_undeclared` above is
# already the reading for that -- the same courtesy `user_declared=unstated` takes, and the reason
# every pen written before this mark existed still passes.
# ---------------------------------------------------------------------------
sed -n 's/^env \(.*\)$/\1/p' "$work/record" > "$work/env.declared"
env_declared_count=$(wc -l < "$work/env.declared" | tr -d ' ')
if [ "$env_declared_count" -gt "$max_env" ]; then
  echo "detail: the record declares $env_declared_count env assignments past max_env=$max_env"
  echo "verdict=unbounded"; exit 1
fi

env_state=unstated
env_disagreements=0
if [ "$env_declared_count" -gt 0 ]; then
  env_state=declared
  path_record=$(awk '{ print $1 }' "$work/path.read" | tr '\n' ':' | sed 's/:$//')
  : > "$work/env.spelled"
  while read -r assign; do
    [ -n "${assign:-}" ] || continue
    ekey=${assign%%=*}
    evalue=${assign#*=}
    case "$ekey" in
      PATH) evalue=$path_record ;;
      GH_CONFIG_DIR) evalue=$(to_record "$gh_state") ;;
      *) evalue=$(to_record "$(echo "$evalue" | sed -e "s#\${HOST_HOME}#$host_home#g" -e "s#\$HOME#$host_home#g")") ;;
    esac
    echo "$ekey=$evalue" >> "$work/env.spelled"
  done < "$work/env.raw"

  while read -r one; do
    [ -n "${one:-}" ] || continue
    ekey=${one%%=*}
    if grep -qxF "$one" "$work/env.declared"; then
      echo "env: the record declares \`$one\`, which is what the exec line spells"
    elif cut -d= -f1 "$work/env.declared" | grep -qxF "$ekey"; then
      env_disagreements=$((env_disagreements + 1))
      echo "detail: the exec line spells \`$one\` and the record declares \`$(awk -F= -v k="$ekey" '$1 == k { print; exit }' "$work/env.declared")\`"
    else
      env_disagreements=$((env_disagreements + 1))
      echo "detail: the exec line spells \`$one\` and the record declares no \`$ekey\` at all"
    fi
  done < "$work/env.spelled"

  while read -r one; do
    [ -n "${one:-}" ] || continue
    ekey=${one%%=*}
    grep -qxF "$one" "$work/env.spelled" && continue
    # A key both sides name was already counted from the spelled side, so counting it again here
    # would read one drift as two.
    cut -d= -f1 "$work/env.spelled" | grep -qxF "$ekey" && continue
    env_disagreements=$((env_disagreements + 1))
    echo "detail: the record declares \`$one\` and the exec line spells no \`$ekey\` at all"
  done < "$work/env.declared"
fi
# ---------------------------------------------------------------------------
# THE PROBE -- the same questions, asked inside a running enclosure.
#
# Read-only on both sides of the threshold: it starts one enclosure, reports what it can see, and
# writes no byte anywhere. A question about reach needs nothing to outlive the close.
# ---------------------------------------------------------------------------
jail_present=no
probe_read=no
probe_asked=0
door_disagreements=0
probe_uid=-
probe_entry=-
command -v ai-jail >/dev/null 2>&1 && jail_present=yes

if [ "$WANT_PROBE" = yes ]; then
  if [ "$jail_present" = no ]; then
    echo "note: ai-jail is absent on this bench, so the derived reading above stands alone"
  else
    flags=$(grep -m1 '^AIJAIL_FLAGS=' "$LAUNCHER" | sed -e 's/.*:-//' -e 's/}.*//' -e 's/"//g' || true)
    [ -n "${flags:-}" ] || flags="--private-home --no-docker --no-gpu"
    awk '{ print $5 }' "$work/path.read" > "$work/probe.ask"
    reporter='for p in $PROBE_PATHS; do if [ -d "$p" ]; then echo "elem present $p"; else echo "elem absent $p"; fi; done; echo "uid $(id -u)"; if [ -n "$PROBE_ENTRY" ] && [ -x "$PROBE_ENTRY" ]; then echo "entry executable"; else echo "entry missing"; fi'
    # shellcheck disable=SC2086
    if PROBE_PATHS="$(tr '\n' ' ' < "$work/probe.ask")" PROBE_ENTRY="${entry_host:-}" \
       timeout 120 ai-jail --no-save-config $flags --map /run/current-system -- \
       env "PROBE_PATHS=$(tr '\n' ' ' < "$work/probe.ask")" "PROBE_ENTRY=${entry_host:-}" \
       "PATH=/run/current-system/sw/bin:/bin" sh -c "$reporter" > "$work/probe.out" 2>/dev/null; then
      probe_read=yes
    elif [ -s "$work/probe.out" ]; then
      probe_read=yes
    fi

    if [ "$probe_read" = yes ]; then
      probe_uid=$(sed -n 's/^uid //p' "$work/probe.out" | head -1)
      probe_entry=$(sed -n 's/^entry //p' "$work/probe.out" | head -1)
      [ -n "${probe_uid:-}" ] || probe_uid=unread
      [ -n "${probe_entry:-}" ] || probe_entry=unread
      : > "$work/probe.disagree"
      while read -r kind answer one; do
        [ "$kind" = elem ] || continue
        probe_asked=$((probe_asked + 1))
        expect=$(awk -v h="$one" '$5 == h { print $4 }' "$work/path.read" | head -1)
        [ -n "${expect:-}" ] || expect=unknown
        if [ "$answer" = present ]; then echo "probe: \`$one\` is reachable inside the enclosure"
        else echo "probe: \`$one\` is absent inside the enclosure"; fi
        [ "$answer" = "$expect" ] || echo "$one derived=$expect metal=$answer" >> "$work/probe.disagree"
      done < "$work/probe.out"
      door_disagreements=$(wc -l < "$work/probe.disagree" | tr -d ' ')

      echo "probe: the agent runs as uid $probe_uid, and claude refuses --dangerously-skip-permissions at uid 0"
      # The declaration settled against the kernel. `invoking` is settled against the uid running
      # this scan, which IS the invoking user; a fixed uid is settled against itself. A record
      # naming a user the enclosure does not run as is the `network off` fault wearing a new mark
      # (REDS %329), so it joins the gate the other probe readings already share rather than being
      # printed beside them.
      if [ "$user_declared" != unstated ]; then
        want_uid=$user_declared
        [ "$user_declared" != invoking ] || want_uid=$(id -u)
        if [ "$probe_uid" = "$want_uid" ]; then
          echo "probe: the record declares \`user $user_declared\` and the enclosure ran as uid $probe_uid, which agrees"
        else
          door_disagreements=$((door_disagreements + 1))
          echo "user $user_declared derived=$want_uid metal=$probe_uid" >> "$work/probe.disagree"
        fi
      fi
      echo "probe: the entry reads $probe_entry from inside"
      if [ "$entry_state" = declared ] && [ "$probe_entry" = missing ]; then
        door_disagreements=$((door_disagreements + 1))
        echo "$entry_host derived=executable metal=missing" >> "$work/probe.disagree"
      fi
      if [ "$door_disagreements" -gt 0 ]; then
        while read -r line; do echo "detail: the enclosure disagrees with the record at $line"; done < "$work/probe.disagree"
      fi
    else
      echo "note: the probe enclosure did not start; nothing was asked"
    fi
  fi
fi

echo "path_elements=$path_count path_undeclared=$path_undeclared ceiling=$path_undeclared_ceiling path_host_absent=$path_host_absent path_dead=$path_dead"
echo "entry_state=$entry_state entry_unreachable=$entry_unreachable env_assignments=$env_count env_undeclared=$env_undeclared"
echo "duties_undeclared=$duties_undeclared private_home=$private_home user_declared=$user_declared"
echo "env_declared=$env_declared_count env_state=$env_state env_disagreements=$env_disagreements"
echo "jail_present=$jail_present probe_read=$probe_read probe_asked=$probe_asked probe_uid=$probe_uid probe_entry=$probe_entry door_disagreements=$door_disagreements"

if [ "$entry_unreachable" -gt 0 ]; then
  echo "verdict=entry_unreachable"
  exit 1
fi
if [ "$path_undeclared" -gt "$path_undeclared_ceiling" ]; then
  echo "verdict=over_ceiling"
  exit 1
fi
if [ "$env_disagreements" -gt 0 ]; then
  echo "verdict=env_disagrees"
  exit 1
fi
if [ "$probe_read" = yes ] && [ "$door_disagreements" -gt 0 ]; then
  echo "verdict=door_disagrees"
  exit 1
fi
# A probe asked for on a host that HAS the jail and did not run is a reading nobody took, and a
# guard whose metal leg can quietly skip is a guard that passes for the wrong reason (REDS %311).
if [ "$WANT_PROBE" = yes ] && [ "$jail_present" = yes ] && [ "$probe_read" = no ]; then
  echo "verdict=probe_absent"
  exit 1
fi
echo "verdict=ok"
exit 0
