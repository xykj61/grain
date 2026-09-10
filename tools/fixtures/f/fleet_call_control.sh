#!/bin/sh
# fleet_call_control.sh -- the tree-bounded call helper, proven on real processes in a throwaway pen.
#
# Every refusal is planted and then LIFTED, so a refusal proven only in the passing direction cannot
# be told from a helper that refuses everything. The pen starts its own sleepers in its own
# directories and signals only PIDs it recorded -- this control never matches a program by name,
# because matching a program by name is the fault under test.
#
#   sh tools/fixtures/f/fleet_call_control.sh
#
# Prints `pass=N fail=N` and exits non-zero on any failure. Bounded: 40 cases, one pen, 9 sleepers.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd -P)
cd "$root"

call=tools/f/fleet_call.sh
pen=${TMPDIR:-/tmp}/fleet-call-pen-$$
mine="$pen/mine"
theirs="$pen/theirs"
tag="fleetcallpen$$"

pass=0
fail=0
born=""

check() {
  if [ "$3" = "$2" ]; then pass=$((pass + 1)); else
    fail=$((fail + 1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2
  fi
}
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

cleanup() {
  for p in $born; do kill -KILL "$p" 2>/dev/null || true; done
  rm -rf "$pen"
}
trap cleanup EXIT INT TERM

mkdir -p "$mine" "$theirs"
printf 'sleep 120\n' > "$pen/$tag.sh"

# A sleeper whose command line carries the pen's unique tag, started from a named directory.
# invariant: the tag rides in the script's PATH, never in a shell comment -- `sh -c "# tag; sleep"`
# execs the sleep and drops the tag with the shell that held it, so nothing would match.
# invariant: the background job's own stdout is closed. A background process inheriting the command
# substitution's pipe holds it open for its whole life, so the substitution would never return.
sleeper() {
  ( cd "$1" && exec sh "$pen/$tag.sh" ) >/dev/null 2>&1 &
  p=$!
  born="$born $p"
  printf '%s\n' "$p"
}
alive() { kill -0 "$1" 2>/dev/null && echo yes || echo no; }

# -- 1-2: a process in this root is signaled; one outside it is refused ---------------------------
a=$(sleeper "$mine")
b=$(sleeper "$theirs")
sleep 1
out=$(sh "$call" --pattern "$tag" --root "$mine" --signal KILL 2>&1)
sleep 1
check "own process signaled"        yes "$(has "$out" "pid=$a")"
check "own process died"            no  "$(alive "$a")"
check "foreign refused out loud"    yes "$(has "$out" "pid=$b cwd=$theirs verdict=refused_foreign")"
check "foreign process survived"    yes "$(alive "$b")"

# -- 3: the refusal LIFTS when the root moves -- the boundary is the reason, not a blanket no -----
out=$(sh "$call" --pattern "$tag" --root "$theirs" --signal KILL 2>&1)
sleep 1
check "refusal lifts with the root" no "$(alive "$b")"

# -- 4-5: the caller's own ancestors are refused, which is the exit-144 fault ---------------------
# The `sh -c` wrapper below carries the tag in its own command line, exactly as the shell running a
# `pkill -f <pattern>` does. It must be refused, and it must still be alive afterwards.
printf "sh '%s' --pattern '%s' --root '%s' --signal KILL 2>&1\n" "$call" "$tag" "$mine" > "$pen/wrap-$tag.sh"
res=$(sh "$pen/wrap-$tag.sh" || true)
check "caller ancestry refused"     yes "$(has "$res" "verdict=refused_self")"
check "no ancestor was signaled"    yes "$(has "$res" "sent=0")"

# -- 6-7: a dry run classifies identically and signals nothing ------------------------------------
c=$(sleeper "$mine")
sleep 1
out=$(sh "$call" --pattern "$tag" --root "$mine" --signal KILL --dry-run 2>&1)
sleep 1
check "dry run classifies"          yes "$(has "$out" "pid=$c cwd=$mine verdict=dry")"
check "dry run signals nothing"     yes "$(alive "$c")"
# invariant: the summary VERB changes with the mode. A dry run reporting `sent=` is a line claiming
# a signal went where none did -- the helper's own silence, one field over.
check "dry run says would_send"     yes "$(has "$out" "would_send=1")"
check "dry run never says sent"     no  "$(has "$out" " sent=")"
live=$(sh "$call" --pattern "$tag" --root "$mine" --signal CONT 2>&1)
check "a real call says sent"       yes "$(has "$live" " sent=1")"

# -- 8: a symlinked root resolves physically before it is compared --------------------------------
ln -s "$mine" "$pen/link"
out=$(sh "$call" --pid "$c" --root "$pen/link" --signal KILL 2>&1)
sleep 1
check "symlinked root resolves"     no "$(alive "$c")"

# -- 9-10: an explicit PID is bounded by the same wall --------------------------------------------
d=$(sleeper "$theirs")
sleep 1
out=$(sh "$call" --pid "$d" --root "$mine" --signal KILL 2>&1)
sleep 1
check "explicit foreign pid refused" yes "$(has "$out" "verdict=refused_foreign")"
check "explicit foreign pid alive"   yes "$(alive "$d")"

# -- 11: a working directory that cannot be read refuses rather than guessing ---------------------
gone=$(sleeper "$mine")
kill -KILL "$gone" 2>/dev/null || true
wait "$gone" 2>/dev/null || true
out=$(sh "$call" --pid "$gone" --root "$mine" --signal KILL 2>&1)
check "unreadable cwd refuses"      yes "$(has "$out" "verdict=refused_unknown")"

# -- 12: nothing matching is an honest zero, never an error ---------------------------------------
# invariant: a pattern always matches at least the helper's own command line, which is why the
# reading here is a zero SEND rather than a zero candidate count -- the self-refusal is the wall
# working, and a control expecting zero candidates would be asserting the fault back into place.
out=$(sh "$call" --pattern "no-process-carries-this-$$" --root "$mine" --dry-run 2>&1)
check "no match sends nothing"      yes "$(has "$out" "would_send=0 refused_foreign=0")"
check "no match still refuses self" yes "$(has "$out" "refused_self=1")"

# -- 13-14: usage errors refuse with exit 2 rather than signaling a default -----------------------
if sh "$call" --root "$mine" >/dev/null 2>&1; then rc=0; else rc=$?; fi
check "no target refuses"           2 "$rc"
if sh "$call" --pattern "$tag" --root "$pen/absent" >/dev/null 2>&1; then rc=0; else rc=$?; fi
check "unresolvable root refuses"   2 "$rc"

# -- 15-16: the helper spawns no matcher of its own, and never reaches for pkill ------------------
# invariant: a `grep <pattern>` child would carry the pattern in its own command line and become a
# candidate -- the self-match fault one process further out.
greps=$(grep -v '^ *#' "$call" | grep -c 'grep .*\$pattern\|pkill ' || true)
check "no matcher child, no pkill"  0 "$greps"
e=$(sleeper "$mine")
sleep 1
out=$(sh "$call" --pattern "$tag" --root "$mine" --dry-run 2>&1)
check "a live pen process is seen"  yes "$(has "$out" "pid=$e cwd=$mine verdict=dry")"

# -- 17-20: NAMING A SIGNAL IS THE VERB, and the reading is what a bare call gives ----------------
# invariant: this is the fault of `20260908` proven from the failing side. A bare --pattern over a
# process in this very root must report and leave it ALIVE; the same call with --signal must reach
# it. Proved on a live process rather than on the summary line alone, since a summary saying
# would_send while a process dies is the silence this helper exists to end.
f=$(sleeper "$mine")
sleep 1
out=$(sh "$call" --pattern "$tag" --root "$mine" 2>&1)
sleep 1
check "a bare call only reads"      yes "$(has "$out" "pid=$f cwd=$mine verdict=dry")"
check "a bare call signals nothing" yes "$(alive "$f")"
# invariant: --dry-run wins in EITHER order, so a preview asked for after a signal is a preview.
out=$(sh "$call" --pattern "$tag" --root "$mine" --dry-run --signal KILL 2>&1)
sleep 1
check "dry-run wins before signal"  yes "$(alive "$f")"
out=$(sh "$call" --pattern "$tag" --root "$mine" --signal KILL 2>&1)
sleep 1
check "naming a signal acts"        no  "$(alive "$f")"

# -- 21-27: A MATCH INSIDE PROSE IS NOT A MATCH ON A COMMAND WORD ---------------------------------
# invariant: this is the `20260909.223500` fault proven from the failing side. This tree's baton
# reaches every agent as one 11,558-byte argument that NAMES the tools a hand searches for, so a
# substring test on the flattened command line read eight peer agents as candidates while one
# process was the tool. The plant is a process carrying the tag ONLY inside a prose argument, in
# THIS root, so nothing but the prose test can save it -- cwd and ancestry both admit it.
printf 'sleep 120\n' > "$pen/prose.sh"
prose_sleeper() {
  ( cd "$1" && exec sh "$pen/prose.sh" "a prompt that names $tag inside a sentence" ) >/dev/null 2>&1 &
  p=$!
  born="$born $p"
  printf '%s\n' "$p"
}
g=$(prose_sleeper "$mine")
sleep 1
# The plant is only a plant if the pattern really is on that command line -- a leg proving a refusal
# over a process the matcher never saw would pass for the wrong reason.
check "prose plant carries the tag" yes "$(has "$(ps -o args= -p "$g" 2>/dev/null || printf '')" "$tag")"
out=$(sh "$call" --pattern "$tag" --root "$mine" --signal KILL 2>&1)
sleep 1
check "prose-only match refused"    yes "$(has "$out" "pid=$g verdict=refused_prose")"
check "prose match survives KILL"   yes "$(alive "$g")"
check "prose refusal is counted"    yes "$(has "$out" "refused_prose=1")"
check "the reading names itself"    yes "$(has "$out" "reading=exact")"
# invariant: the refusal LIFTS through the door the refusal line names. A wall with no door is a
# process a hand can never reach, which is the fault this file's cwd wall already avoids.
h=$(sleeper "$mine")
sleep 1
out=$(sh "$call" --pattern "$tag" --root "$mine" 2>&1)
check "a command word still reads"  yes "$(has "$out" "pid=$h cwd=$mine verdict=dry")"
out=$(sh "$call" --pid "$g" --root "$mine" --signal KILL 2>&1)
sleep 1
check "--pid reaches past prose"    no  "$(alive "$g")"

# -- 28-33: the pattern is one command word, and the degradation is named rather than silent -------
# invariant: a pattern carrying whitespace can match no command word by construction, so a zero
# would mean "impossible" while reading exactly like "nobody is running it". It refuses with the
# usage exit instead. Caught first-resident within the hour the shape rule landed.
rc=0
sh "$call" --pattern "$tag --hot" --root "$mine" >/dev/null 2>&1 || rc=$?
check "multi-word pattern refuses"  2 "$rc"
out=$(sh "$call" --pattern "$tag --hot" --root "$mine" 2>&1 || true)
check "and says which door to use"  yes "$(has "$out" "use --pid")"
# invariant: the reading is decided by the HOST once, never by one candidate. A process that exits
# between the listing and the cmdline read must not report the whole reading as degraded -- that
# fired on a live Linux pier before this was pulled out of the loop.
i=$(prose_sleeper "$mine")
sleep 1
out=$(sh "$call" --pattern "$tag" --root "$mine" 2>&1)
check "a /proc host reads exact"    yes "$(has "$out" "reading=exact")"
check "and one prose match is seen" yes "$(has "$out" "refused_prose=1")"
# invariant: with no /proc there are no argument boundaries, so the elder substring test stands AND
# SAYS SO. A host that cannot tell prose from a command word ADMITS the prose match, which is the
# honest cost, named in the summary rather than hidden. The leg reads the admission rather than a
# send, because `cwd_of` resolves through the same `$proc_root`: overriding it removes the working
# directory too, so this candidate lands on `refused_unknown` here where a real Mac would reach lsof.
# That coupling is the reason the check is written this way, rather than a weaker assertion.
out=$(FLEET_CALL_PROC="$pen/no-proc-here" sh "$call" --pattern "$tag" --root "$mine" 2>&1)
check "no /proc reads flattened"    yes "$(has "$out" "reading=flattened")"
check "and admits what exact refused" yes "$(has "$out" "pid=$i")"

printf 'pass=%s fail=%s\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
