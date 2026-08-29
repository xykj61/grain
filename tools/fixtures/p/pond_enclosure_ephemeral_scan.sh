#!/usr/bin/env sh
# pond_enclosure_ephemeral_scan.sh -- what the enclosure FORGETS, and what outlives its close.
#
# WHAT THIS ASKS. Orbit three of the quest that retires ai-jail is named "the memory that forgets":
# an enclosure whose $HOME and /tmp dissolve on exit while the pier persists, done when a planted
# secret written outside the pier is provably absent after the enclosure closes. That is a question
# about TIME rather than about visibility, and no guard here was asking it. Its sibling
# pond_enclosure_built_scan.sh asks whether the record NAMES every mount; this asks which of those
# mounts still holds a byte a minute after the enclosure is gone.
#
# THE RULE, READ OFF THE PLAN RATHER THAN OFF A ROSTER. Each mount row answers for itself:
#
#   tmpfs T / dev T / proc T   dissolves   a filesystem born at open, gone at close
#   ro-bind S T                read-only   nothing can be written, so nothing is kept
#   bind S T / dev-bind S T    survives    a write at T lands at S on the host and outlives us
#
# A survivor is then either UNDER THE PIER, which persists by design and is what the record's
# `persist` line declares, or OUTSIDE it, which is a hole in the forgetting.
#
# THE READINGS
#   unforgotten_claims     the record declares a path ephemeral, the plan keeps it   ZERO, ENFORCED
#   pierced_forgetting     a surviving bind opening a hole inside an ephemeral path  reported
#   survives_outside_pier  a writable path outliving the close, outside the pier     ratchet, only falls
#   survives_in_pier       the lawful survivors -- the pier is meant to persist      reported
#   dissolves              the mounts that forget                                    reported
#   probe_*                the same question asked on metal, under --probe           reported
#
# WHY THE GATE SITS ON ONE READING. `unforgotten_claims` is a record saying a path forgets where the
# plan says it keeps -- a false claim, and the one shape here that is always wrong. The other three
# describe an enclosure this tree did not write and cannot silently change: closing /run/user would
# take the Wayland socket with it, so the count is a ratchet under a ceiling that only falls, and
# closing any one of those holes is a seat rather than a sweep.
#
# WHAT THE PINNED PLAN CANNOT ANSWER. tools/fixtures/p/pond_enclosure_default_plan.kyri drops the two
# rows the invocation creates, one of which is the private home's own tmpfs. So `private-home yes` is
# reported as a claim this reading cannot check and the probe can -- said out loud rather than scored
# as if the plan had answered it.
#
# THE PROBE, and why it is opt-in. --probe starts a real enclosure, plants one marker per candidate
# path, lets it exit, and reads the host. That is orbit three's own "done when", executed rather than
# argued -- and it writes on the host, so it is asked for explicitly and never rides an ordinary run.
# Every marker it plants is removed afterwards whether it survived or not.
#
# THE READING BESIDE IT. active-designing/20260829-054303_the-three-the-enclosure-keeps.md argues
# what these counts mean and what closing each survivor would cost.
#
#   sh tools/fixtures/p/pond_enclosure_ephemeral_scan.sh [--root DIR] [--plan FILE] [--probe]
#
# ACCRETE-ONLY. This reads ai-jail's own printed plan and Pond's record, and rewrites neither. It
# starts no enclosure unless --probe asks for one, and it flips nothing: the ENCLOSURE selector stays
# ai-jail until the switchover round lands behind its audit.
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

PLAN_OVERRIDE=""
WANT_PROBE=no
while [ $# -gt 0 ]; do
  case "$1" in
    --root) ROOT=$2; shift 2 ;;
    --plan) PLAN_OVERRIDE=$2; shift 2 ;;
    --probe) WANT_PROBE=yes; shift ;;
    *) echo "pond_enclosure_ephemeral_scan: unknown argument: $1" >&2; exit 2 ;;
  esac
done

POLICY="$ROOT/pond/enclosure_policy.kyri"
PINNED="${PLAN_OVERRIDE:-$ROOT/tools/fixtures/p/pond_enclosure_default_plan.kyri}"
SIBLING="$ROOT/tools/fixtures/p/pond_enclosure_built_scan.sh"

# invariant: a comparison needs both halves, so an absent one is named rather than guessed at.
if [ ! -f "$POLICY" ]; then echo "scan=absent detail=no_policy"; echo "verdict=unreadable"; exit 1; fi
if [ ! -f "$PINNED" ]; then echo "scan=absent detail=no_pinned_plan"; echo "verdict=unreadable"; exit 1; fi

# max_rows bounds the plan roster, matching the sibling that reads the same file: twenty-one default
# mounts stand on this pier, and sixty-four refuses a generated plan while leaving room for a jail
# that trebles its defaults. max_probe_paths bounds what --probe will start an enclosure to ask
# about; six candidates stand today, and eight is one doubling of the ephemeral claims.
max_rows=64
max_probe_paths=8

# survives_outside_pier_ceiling -- a RATCHET that only falls. Three writable host paths outlive the
# close on this pier (/dev/shm, /tmp/.X11-unix, /run/user/<uid>), each supplied by the jail's own
# defaults rather than by a flag Pond passes. Closing any of them changes what a running agent can
# see -- the runtime directory carries the Wayland socket -- so the number is measured and held down
# rather than gated at zero by a lap that cannot pay for the consequence.
survives_outside_pier_ceiling=3

echo "pond_enclosure_ephemeral_scan v1"
echo "record=pond/enclosure_policy.kyri"
echo "pinned=${PINNED#"$ROOT/"}"

work=$(mktemp -d) || { echo "scan=absent detail=no_workspace"; echo "verdict=unreadable"; exit 1; }
cleanup() { rm -rf "$work"; }
trap cleanup EXIT INT TERM

# CITED, NEVER COPIED. The tokenizer and the four normalization rules are lifted out of
# pond_enclosure_built_scan.sh at run time, the way qa_report_card.sh lifts measure() out of
# prose_register_scan.sh, so one plan row can never read two ways in two guards. Losing the source
# makes this refuse rather than guess.
[ -f "$SIBLING" ] || { echo "detail: the plan reader is missing at ${SIBLING#"$ROOT/"}"; echo "verdict=unreadable"; exit 1; }
sed -n '/^plan_rows() {/,/^}/p' "$SIBLING" > "$work/plan_rows.sh"
sed -n '/^normalize() {/,/^}/p' "$SIBLING" > "$work/normalize.sh"
if [ ! -s "$work/plan_rows.sh" ] || [ ! -s "$work/normalize.sh" ]; then
  echo "detail: pond_enclosure_built_scan.sh no longer publishes plan_rows() and normalize()"
  echo "verdict=unreadable"; exit 1
fi
. "$work/plan_rows.sh"
. "$work/normalize.sh"

# The pinned plan carries header fields naming when and where it was measured; the mount rows are
# every other non-comment line, in bwrap's own words.
grep -v '^#' "$PINNED" | grep -vE '^(format|measured|host|jail|flags)( |$)' | sed '/^[[:space:]]*$/d' > "$work/rows"
plan_row_count=$(wc -l < "$work/rows" | tr -d ' ')
if [ "$plan_row_count" -eq 0 ]; then echo "detail: the pinned plan carries no mount rows"; echo "verdict=unreadable"; exit 1; fi
if [ "$plan_row_count" -gt "$max_rows" ]; then
  echo "detail: the pinned plan carries $plan_row_count rows past max_rows=$max_rows"
  echo "verdict=unbounded"; exit 1
fi

# The record's own halves: where the pier is, and which paths it claims dissolve.
grep -v '^#' "$POLICY" | sed '/^[[:space:]]*$/d' | sed -n 's/^persist \(.*\)$/\1/p'   | sort -u > "$work/persist"
grep -v '^#' "$POLICY" | sed '/^[[:space:]]*$/d' | sed -n 's/^ephemeral \(.*\)$/\1/p' | sort -u > "$work/ephemeral"
private_home=$(grep -v '^#' "$POLICY" | sed -n 's/^private-home \(.*\)$/\1/p' | head -1)
[ -n "${private_home:-}" ] || private_home=unstated

# One plan row becomes one lifetime. The classification is the whole reading, so it is spelled once
# here and every count below is read off its output.
normalize < "$work/rows" | awk '
  {
    if ($1 == "tmpfs" || $1 == "dev" || $1 == "proc") { print "dissolves", $2, "-"; next }
    if ($1 == "ro-bind")                              { print "readonly",  $3, $2; next }
    if ($1 == "bind" || $1 == "dev-bind")             { print "survives",  $3, $2; next }
  }' | sort -u > "$work/lifetime"

dissolves=$(awk '$1 == "dissolves"' "$work/lifetime" | wc -l | tr -d ' ')
readonly_rows=$(awk '$1 == "readonly"' "$work/lifetime" | wc -l | tr -d ' ')

# A survivor is under the pier or outside it. `persist` names the pier; a source equal to that path
# or beneath it goes on with the tree, which is the arrangement the quest wants.
awk '$1 == "survives" { print $2, $3 }' "$work/lifetime" > "$work/survivors"
: > "$work/in_pier"
: > "$work/outside_pier"
while read -r dest src; do
  [ -n "${dest:-}" ] || continue
  inside=no
  while read -r pier_root; do
    [ -n "${pier_root:-}" ] || continue
    case "$src" in "$pier_root"|"$pier_root"/*) inside=yes ;; esac
  done < "$work/persist"
  if [ "$inside" = yes ]; then echo "$dest $src" >> "$work/in_pier"
  else echo "$dest $src" >> "$work/outside_pier"; fi
done < "$work/survivors"
survives_in_pier=$(wc -l < "$work/in_pier" | tr -d ' ')
survives_outside_pier=$(wc -l < "$work/outside_pier" | tr -d ' ')

# READING ONE, the gate: a path the record says dissolves, which the plan keeps.
: > "$work/unforgotten"
while read -r claim; do
  [ -n "${claim:-}" ] || continue
  if ! awk -v p="$claim" '$1 == "dissolves" && $2 == p { found = 1 } END { exit found ? 0 : 1 }' "$work/lifetime"; then
    echo "$claim" >> "$work/unforgotten"
  fi
done < "$work/ephemeral"
unforgotten_claims=$(wc -l < "$work/unforgotten" | tr -d ' ')

# READING TWO, reported: a survivor sitting strictly inside a path the record calls ephemeral. The
# subtree dissolves and the hole in it does not, so a reader of `ephemeral /tmp` alone would be told
# less than the truth.
: > "$work/pierced"
while read -r dest src; do
  [ -n "${dest:-}" ] || continue
  while read -r claim; do
    [ -n "${claim:-}" ] || continue
    case "$dest" in "$claim"/*) echo "$dest $claim $src" >> "$work/pierced" ;; esac
  done < "$work/ephemeral"
done < "$work/survivors"
pierced_forgetting=$(wc -l < "$work/pierced" | tr -d ' ')

if [ "$unforgotten_claims" -gt 0 ]; then
  while read -r one; do
    echo "detail: the record declares \`ephemeral $one\` and the plan builds no dissolving mount there"
  done < "$work/unforgotten"
fi
if [ "$pierced_forgetting" -gt 0 ]; then
  while read -r dest claim src; do
    echo "note: \`$dest\` outlives the close inside \`ephemeral $claim\` -- the host keeps it at \`$src\`"
  done < "$work/pierced"
fi
if [ "$survives_outside_pier" -gt 0 ]; then
  while read -r dest src; do
    echo "note: \`$dest\` is writable and outlives the enclosure at \`$src\`, outside the pier"
  done < "$work/outside_pier"
fi

# THE PROBE. Candidates are derived rather than listed: the paths the record claims dissolve, the
# private home when it is claimed, and every survivor outside the pier -- so a jail that opens a hole
# tomorrow is probed for it without anyone editing a roster.
probe_read=no
probe_planted=0
probe_refused=0
probe_forgotten=0
probe_survived=0
probe_disagreements=0
jail_present=no
# An `if` rather than an `&&`: under `set -e` a bare failing test ends the script, and the honest
# answer to "is the jail here" on a clone without one is `no` rather than a dead scan.
if command -v ai-jail >/dev/null 2>&1; then jail_present=yes; fi
if [ "$WANT_PROBE" = yes ]; then
  if [ "$jail_present" = no ]; then
    echo "note: --probe asked for a live enclosure and ai-jail is absent here"
  else
    # Denormalize back to this host's real paths: the record and the plan speak the placeholder
    # convention, and a marker has to be planted where the kernel can find it.
    uid=$(id -u)
    home_real=${HOME:-/nonexistent}

    # An `if` rather than an `&&` on purpose: under `set -e` a failing test inside this group would
    # end the group and drop the survivors that follow it, which is a candidate list quietly short.
    { cat "$work/ephemeral"
      if [ "$private_home" = yes ]; then echo /home/youruser; fi
      awk '{ print $1 }' "$work/outside_pier"
    } | sort -u \
      | sed -e "s#^/home/youruser#$home_real#" -e "s#/run/user/<uid>#/run/user/$uid#" \
      | sort -u > "$work/probe_paths"
    probe_count=$(wc -l < "$work/probe_paths" | tr -d ' ')
    if [ "$probe_count" -gt "$max_probe_paths" ]; then
      echo "detail: $probe_count probe candidates past max_probe_paths=$max_probe_paths"
      echo "verdict=unbounded"; exit 1
    fi

    # One marker per path, named for this run so two probes never read each other's leavings, and
    # removed from the host afterwards whether it survived or not. A marker name that came out empty
    # would make the removal below reach a directory, so it is checked before anything is planted.
    marker="GRAIN_FORGET_PROBE_$$_$(date +%s)"
    case "$marker" in GRAIN_FORGET_PROBE_?*) : ;; *) echo "detail: the probe marker name is unusable"; echo "verdict=unreadable"; exit 1 ;; esac
    drop_marker() { # a full path only, two segments deep at least, and always ending in the marker
      case "$1" in
        */"$marker") case "$1" in /*/*) rm -f -- "$1" ;; *) echo "note: probe left \`$1\` -- too shallow to remove" ;; esac ;;
        *) echo "note: probe declined to remove \`$1\` -- it does not end in this run's marker" ;;
      esac
    }

    pen="$work/probe-pen"
    mkdir -p "$pen"
    plant=$(awk -v m="$marker" '{ printf "if printf grain-forget-probe > \"%s/%s\" 2>/dev/null; then echo planted %s; else echo refused %s; fi\n", $0, m, $0, $0 }' "$work/probe_paths")
    if ( cd "$pen" && ai-jail --no-save-config --private-home --no-docker --no-gpu -- /bin/sh -c "$plant" ) > "$work/probe.raw" 2>/dev/null; then
      probe_read=yes
      probe_planted=$(grep -c '^planted ' "$work/probe.raw" || true)
      probe_refused=$(grep -c '^refused ' "$work/probe.raw" || true)

      : > "$work/probe.host"
      grep '^planted ' "$work/probe.raw" | sed 's/^planted //' > "$work/probe.planted"
      while read -r one; do
        [ -n "${one:-}" ] || continue
        full="$one/$marker"
        if [ -e "$full" ]; then echo "survived $one" >> "$work/probe.host"
        else echo "forgotten $one" >> "$work/probe.host"; fi
        drop_marker "$full"
      done < "$work/probe.planted"
      probe_forgotten=$(grep -c '^forgotten ' "$work/probe.host" || true)
      probe_survived=$(grep -c '^survived ' "$work/probe.host" || true)

      # A disagreement is a path whose metal answer differs from the lifetime the plan derived. That
      # is the reading worth having: a classification nobody checked against the kernel is a claim.
      : > "$work/probe.disagree"
      while read -r answer one; do
        [ -n "${one:-}" ] || continue
        norm=$(echo "$one" | sed -e "s#^$home_real#/home/youruser#" -e "s#/run/user/$uid#/run/user/<uid>#")
        expect=forgotten
        if awk -v p="$norm" '$1 == "survives" && $2 == p { f = 1 } END { exit f ? 0 : 1 }' "$work/lifetime"; then expect=survived; fi
        # The private home is the one candidate the pinned plan drops, so the probe is its only reader.
        if [ "$norm" = /home/youruser ] && [ "$private_home" = yes ]; then expect=forgotten; fi
        [ "$answer" = "$expect" ] || echo "$one expected=$expect metal=$answer" >> "$work/probe.disagree"
      done < "$work/probe.host"
      probe_disagreements=$(wc -l < "$work/probe.disagree" | tr -d ' ')

      while read -r answer one; do
        if [ "$answer" = survived ]; then echo "probe: \`$one\` still carried the marker after the close"
        else echo "probe: \`$one\` was forgotten at the close"; fi
      done < "$work/probe.host"
      if [ "$probe_refused" -gt 0 ]; then
        grep '^refused ' "$work/probe.raw" | sed 's/^refused //' | while read -r one; do
          echo "note: the enclosure refused a write at \`$one\`, so nothing was there to keep or lose"
        done
      fi
      if [ "$probe_disagreements" -gt 0 ]; then
        while read -r line; do echo "detail: the probe disagrees with the plan at $line"; done < "$work/probe.disagree"
      fi
    else
      echo "note: the probe enclosure did not start; nothing was planted"
    fi
  fi
fi

echo "dissolves=$dissolves readonly_rows=$readonly_rows plan_rows=$plan_row_count max_rows=$max_rows"
echo "survives_in_pier=$survives_in_pier survives_outside_pier=$survives_outside_pier ceiling=$survives_outside_pier_ceiling"
echo "unforgotten_claims=$unforgotten_claims pierced_forgetting=$pierced_forgetting private_home=$private_home"
echo "jail_present=$jail_present probe_read=$probe_read probe_planted=$probe_planted probe_refused=$probe_refused"
echo "probe_forgotten=$probe_forgotten probe_survived=$probe_survived probe_disagreements=$probe_disagreements"

if [ "$unforgotten_claims" -gt 0 ]; then
  echo "verdict=unforgotten"
  exit 1
fi
if [ "$survives_outside_pier" -gt "$survives_outside_pier_ceiling" ]; then
  echo "verdict=over_ceiling"
  exit 1
fi
if [ "$probe_read" = yes ] && [ "$probe_disagreements" -gt 0 ]; then
  echo "verdict=probe_disagrees"
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
