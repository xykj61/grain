#!/usr/bin/env sh
# pond_enclosure_built_scan.sh -- what the enclosure BUILDS, against what the record DECLARES.
#
# WHAT THIS READS. The enclosure assembles a mount plan before it starts, and ai-jail will print
# that plan without running it (`--dry-run`). Those lines are the concrete fact: not what a
# launcher spells, not what a comment remembers -- what bwrap is actually handed. This scan reads
# the plan, drops the two rows that belong to the invocation rather than to the enclosure, turns
# each remaining row into one declaration in the record's own vocabulary, and asks whether
# pond/enclosure_policy.kyri carries it.
#
# WHY IT EXISTS. Its sibling, pond_policy_launcher_scan.sh, reads the record against
# tools/ag/agent-jail.sh, and it is honest about its own reach: it compares what the launcher
# SPELLS. The jail supplies about twenty more mounts from its own defaults, which no flag names
# and which that guard therefore cannot see. Measured 20260828: the record declared 6 mounts where
# the plan builds 27. Orbit two of the quest that retires ai-jail derives every grant from this
# record, so a record naming a fifth of the enclosure would derive a fifth of an enclosure.
#
# THE TWO HALVES, AND WHY THEY DO NOT OVERLAP. A plan row is either DEFAULT -- the jail supplies
# it whatever the launcher says -- or SPELLED, traceable to a flag the launcher passes. This scan
# owns the defaults; the sibling owns the spelled rows. The split is derived rather than listed:
# a dry run in a scratch directory passes no --map or --rw-map at all, so every mount in it is a
# default except the two the invocation itself creates (the working directory's own bind, named
# by --chdir, and the private home's tmpfs).
#
# THE READINGS
#   undeclared_builds  the plan builds a default the record does not declare   ZERO, ENFORCED
#   declared_unbuilt   a record declaration absent from the default plan       reported
#   plan_drift         the pinned plan and a live dry run disagree             reported
#   built_defaults     default mounts the plan carries                         reported
#   declared_lines     declarations the record carries                         reported
#
# WHY THE GATE SITS ON ONE READING. `undeclared_builds` is the escape direction: a mount nobody
# declared is exactly what orbit two must prove cannot happen, so it is enforced. `declared_unbuilt`
# is reported because the record also declares the launcher-spelled rows -- the five state binds,
# the pier, /run/current-system -- which a scratch dry run never builds and which are the sibling's
# business. A number there is expected; the header says which rows it names so a reader can act.
#
# THE PINNED PLAN, AND WHY IT IS TESTIMONY RATHER THAN A SECOND SPELLING. A clone without ai-jail
# installed cannot run a dry run, and a guard that runs nowhere proves nothing. So a measured plan
# is pinned at tools/fixtures/p/pond_enclosure_default_plan.kyri, in bwrap's own words, and the
# same translator reads it. Where the jail IS installed the live plan is read too and any
# disagreement is reported as `plan_drift`. The pinned file records what was measured, on which
# host, at which stamp -- a reading, not a rule.
#
# NORMALIZATION, IN FOUR RULES, SO A PLAN FROM ANY PIER READS THE SAME. The host home becomes
# /home/youruser (the record's own placeholder convention); a runtime directory's numeric owner
# becomes <uid>; a nix store hash becomes <hash>; and bwrap's per-run temporary names lose their
# pid and nanosecond fields. Nothing here spells a host path, so nothing a pier knows about its
# operator reaches the tree.
#
# THE TRANSLATION TABLE, one plan row to one declaration.
#   ro-bind S T, S == T   map S            a host path readable inside
#   ro-bind S T, S != T   graft T          the enclosure's own file placed at T
#   bind S T              rw-map S:T       a host path writable inside
#   dev-bind S T          device T         a device node
#   dev T                 fresh T          a new kernel filesystem, never the host's
#   proc T                fresh T          the same, for the process table
#   tmpfs T, T under a bound path   mask T   an empty filesystem hiding what is under it
#   tmpfs T, standing alone         ephemeral T   scratch that dissolves at exit
#
#   sh tools/fixtures/p/pond_enclosure_built_scan.sh [--root DIR] [--plan FILE] [--no-live]
#
# ACCRETE-ONLY. This reads ai-jail's own printed plan and Pond's record. It rewrites neither, it
# starts no enclosure, and it flips nothing: the ENCLOSURE selector stays ai-jail until the
# switchover round lands behind its audit.
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
ALLOW_LIVE=yes
while [ $# -gt 0 ]; do
  case "$1" in
    --root) ROOT=$2; shift 2 ;;
    --plan) PLAN_OVERRIDE=$2; shift 2 ;;
    --no-live) ALLOW_LIVE=no; shift ;;
    *) echo "pond_enclosure_built_scan: unknown argument: $1" >&2; exit 2 ;;
  esac
done

POLICY="$ROOT/pond/enclosure_policy.kyri"
LAUNCHER="$ROOT/tools/ag/agent-jail.sh"
PINNED="${PLAN_OVERRIDE:-$ROOT/tools/fixtures/p/pond_enclosure_default_plan.kyri}"

# invariant: a comparison needs both halves, so an absent one is named rather than guessed at.
if [ ! -f "$POLICY" ]; then echo "scan=absent detail=no_policy"; echo "verdict=unreadable"; exit 1; fi
if [ ! -f "$PINNED" ]; then echo "scan=absent detail=no_pinned_plan"; echo "verdict=unreadable"; exit 1; fi

# max_rows bounds the plan roster. Twenty-one default mounts stand on this pier; sixty-four
# refuses a generated plan while leaving room for a jail that trebles its defaults.
max_rows=64

echo "pond_enclosure_built_scan v1"
echo "record=pond/enclosure_policy.kyri"
echo "pinned=${PINNED#"$ROOT/"}"

work=$(mktemp -d) || { echo "scan=absent detail=no_workspace"; echo "verdict=unreadable"; exit 1; }
trap 'rm -rf "$work"' EXIT INT TERM

# The four normalization rules, in one place, so a live plan and the pinned plan are read by one
# instrument rather than by two that must agree.
normalize() {
  sed -e 's#/home/[^/ ]*#/home/youruser#g' \
      -e 's#/run/user/[0-9][0-9]*#/run/user/<uid>#g' \
      -e 's#/nix/store/[a-z0-9][a-z0-9]\{31\}-#/nix/store/<hash>-#g' \
      -e 's#/tmp/bwrap-hosts\.[0-9][0-9.]*#/tmp/bwrap-hosts#g' \
      -e 's#/tmp/bwrap-resolv\.[0-9][0-9.]*#/tmp/bwrap-resolv#g'
}

# A plan row carries a mount flag and one or two paths. Every other argument bwrap takes describes
# the process rather than the filesystem, and a scan reading those would answer a different
# question. The line-continuation backslashes go first so no token is one.
plan_rows() {
  sed -e 's/[[:space:]]*\\$//' | awk '
    { for (i = 1; i <= NF; i++) if ($i != "\\") tok[++n] = $i }
    END {
      for (i = 1; i <= n; i++) {
        f = tok[i]
        if (f == "--ro-bind" || f == "--bind" || f == "--dev-bind") {
          sub(/^--/, "", f); print f, tok[i+1], tok[i+2]; i += 2; continue
        }
        if (f == "--tmpfs" || f == "--dev" || f == "--proc") {
          sub(/^--/, "", f); print f, tok[i+1]; i += 1; continue
        }
      }
    }'
}

# One plan row becomes one declaration. A tmpfs laid over a path the plan also binds is a mask --
# it hides what is under it; a tmpfs standing on its own is scratch that dissolves. The rule is
# read off the plan itself rather than off a roster, so a mask the jail adds tomorrow reads as one.
translate() {
  awk '
    { rows[NR] = $0
      if ($1 == "ro-bind" || $1 == "bind" || $1 == "dev-bind") bound[$3] = 1 }
    END {
      for (i = 1; i <= NR; i++) {
        n = split(rows[i], f, " ")
        if (f[1] == "ro-bind")  { if (f[2] == f[3]) print "map " f[2]; else print "graft " f[3]; continue }
        if (f[1] == "bind")     { print "rw-map " f[2] ":" f[3]; continue }
        if (f[1] == "dev-bind") { print "device " f[3]; continue }
        if (f[1] == "dev" || f[1] == "proc") { print "fresh " f[2]; continue }
        if (f[1] == "tmpfs") {
          masked = 0
          for (t in bound) if (t != f[2] && index(f[2], t "/") == 1) masked = 1
          if (masked) print "mask " f[2]; else print "ephemeral " f[2]
        }
      }
    }'
}

# The pinned plan carries header fields naming when and where it was measured; the mount rows are
# every other non-comment line, in bwrap's own words.
grep -v '^#' "$PINNED" | grep -vE '^(format|measured|host|jail|flags)( |$)' | sed '/^[[:space:]]*$/d' > "$work/pinned.rows"
pinned_rows=$(wc -l < "$work/pinned.rows" | tr -d ' ')
if [ "$pinned_rows" -eq 0 ]; then echo "detail: the pinned plan carries no mount rows"; echo "verdict=unreadable"; exit 1; fi
if [ "$pinned_rows" -gt "$max_rows" ]; then
  echo "detail: the pinned plan carries $pinned_rows rows past max_rows=$max_rows"
  echo "verdict=unbounded"; exit 1
fi

# A live dry run is the concrete fact, and it needs the jail installed. Where it answers, the two
# plans are compared and any disagreement is REPORTED: the pinned plan drives the gate so the same
# reading lands on every clone, and drift is the signal to measure and re-pin rather than a red on
# somebody else's machine.
plan_drift=-1
live_read=no
if [ "$ALLOW_LIVE" = yes ] && command -v ai-jail >/dev/null 2>&1 && [ -f "$LAUNCHER" ]; then
  flags=$(sed -n 's/^AIJAIL_FLAGS="\${AIJAIL_FLAGS:-\(.*\)}"$/\1/p' "$LAUNCHER" | head -1)
  if [ -n "${flags:-}" ]; then
    pen="$work/pen"
    mkdir -p "$pen"
    if ( cd "$pen" && ai-jail --no-save-config $flags --dry-run -- true ) > "$work/live.raw" 2>/dev/null; then
      # The two rows the invocation creates rather than the enclosure: the working directory's own
      # bind, and the private home's tmpfs. Both are dropped before normalization, while their real
      # paths still stand, so nothing depends on a normalized name matching.
      plan_rows < "$work/live.raw" \
        | grep -vE "^(bind|ro-bind) $pen $pen$" \
        | grep -vE "^tmpfs ${HOME:-/nonexistent}$" \
        | normalize | sort > "$work/live.rows"
      sort "$work/pinned.rows" > "$work/pinned.sorted"
      plan_drift=$(comm -3 "$work/live.rows" "$work/pinned.sorted" | sed '/^[[:space:]]*$/d' | wc -l | tr -d ' ')
      live_read=yes
    fi
  fi
fi

normalize < "$work/pinned.rows" | translate | sort -u > "$work/declared_by_plan"
built_defaults=$(wc -l < "$work/declared_by_plan" | tr -d ' ')

# The record's own declarations, mount-bearing marks alone. private-home, network, and gpu name a
# facility rather than a path, so they belong to the sibling guard that reads flags.
grep -v '^#' "$POLICY" | sed '/^[[:space:]]*$/d' \
  | grep -E '^(map|rw-map|graft|device|fresh|mask|persist|ephemeral) ' | sort -u > "$work/declared_by_record"
declared_lines=$(wc -l < "$work/declared_by_record" | tr -d ' ')

undeclared_builds=$(comm -23 "$work/declared_by_plan" "$work/declared_by_record" | wc -l | tr -d ' ')
declared_unbuilt=$(comm -13 "$work/declared_by_plan" "$work/declared_by_record" | wc -l | tr -d ' ')

if [ "$undeclared_builds" -gt 0 ]; then
  comm -23 "$work/declared_by_plan" "$work/declared_by_record" | while IFS= read -r one; do
    echo "detail: the plan builds \`$one\` and the record declares no such line"
  done
fi
if [ "$declared_unbuilt" -gt 0 ]; then
  comm -13 "$work/declared_by_plan" "$work/declared_by_record" | while IFS= read -r one; do
    echo "note: the record declares \`$one\`, absent from the default plan (the launcher's own rows live here)"
  done
fi
if [ "$live_read" = yes ] && [ "$plan_drift" -gt 0 ]; then
  comm -3 "$work/live.rows" "$work/pinned.sorted" | sed '/^[[:space:]]*$/d' | while IFS= read -r one; do
    echo "note: live dry run and pinned plan differ at \`$(echo "$one" | sed 's/^[[:space:]]*//')\`"
  done
fi

echo "built_defaults=$built_defaults declared_lines=$declared_lines"
echo "undeclared_builds=$undeclared_builds declared_unbuilt=$declared_unbuilt"
echo "live_read=$live_read plan_drift=$plan_drift pinned_rows=$pinned_rows max_rows=$max_rows"

if [ "$undeclared_builds" -gt 0 ]; then
  echo "verdict=undeclared"
  exit 1
fi
echo "verdict=ok"
exit 0
