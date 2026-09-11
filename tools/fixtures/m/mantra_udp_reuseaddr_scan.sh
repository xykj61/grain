#!/usr/bin/env sh
# tools/fixtures/m/mantra_udp_reuseaddr_scan.sh -- Mantra's UDP sockets carry no address reuse, and
# each one proves it rather than merely omitting the call.
#
# WHY. Seven delivery modules under mantra/ opened their UDP socket under
# `setsockopt(SO_REUSEADDR)` carrying the invariant *SO_REUSEADDR is what lets a bounded run rebind
# its own port*. That sentence is TCP's: a closed TCP socket sits in TIME_WAIT holding its port and
# the option is what lets a restart bind through it. UDP has no TIME_WAIT, so a closed UDP port is
# free at once and the option bought nothing it was added for. What it bought instead was a
# DUPLICATE BIND -- two sockets holding one address and port while the kernel splits the arriving
# datagrams between them, with no error on either side. Amphora met the identical shape first and
# measured the four binds that decide it (REDS `20260906.154105`,
# tools/fixtures/a/amphora_udp_reuseaddr_scan.sh); this pier then watched the mantra half of it
# happen, `mantra_snapshot_hosted` red at 2,689ms under load and GREEN alone straight after, its
# evidence naming `BadKind` then `RecvFailed` -- a foreign sender rather than a lost packet.
#
# MEASURED ON METAL `20260911`, one foreign reader holding 127.0.0.1:38491 and the snapshot binary
# run against it: the ELDER module bound beside the holder and printed `GREEN`, and the repaired one
# refuses with `error.BindFailed` naming the bind site on its first stderr line. The collision was
# always there; what changed is that it now says so.
#
# THREE READINGS, two of them gates.
#
#   reuseaddr_sites      -- setsockopt calls naming SO_REUSEADDR on a code line in mantra sources.
#                           GATED AT ZERO. The regression guard: it is what keeps the option from
#                           walking back in under its old, plausible comment.
#   dgram_unproven       -- modules that open SOCK_DGRAM and never read the option back to assert
#                           it zero. GATED AT ZERO, naming each one. Absence of a setsockopt is
#                           silence; the assert is the module saying what it holds, which is the
#                           difference between a property and a coincidence.
#   witness_lock_unwired -- witnesses that run a mantra delivery binary without taking the port pair
#                           through tools/fixtures/m/mantra_delivery_port_lock.sh. REPORTED, never
#                           gated: several belong to the caravan lane, and a guard that reds one
#                           lane over a peer's file is a guard that lane turns off.
#
# THE KERNEL PROBE LIVES ONE LANE OVER and is deliberately not repeated here. Amphora's scan runs
# the four binds that decide whether dropping the option is right, and one expectation written in
# two files is the shape this tree keeps finding drifted.
#
# USAGE, from the repository root:
#   sh tools/fixtures/m/mantra_udp_reuseaddr_scan.sh [ROOT_DIR]
#
# ROOT_DIR names another checkout to read, so a control can build a pen and point this at it.
set -u

root_dir=${1:-.}
[ -d "$root_dir" ] || { echo "mantra_udp_reuseaddr_scan: no such root -- $root_dir" >&2; exit 2; }

# THE WALKER AND THE ORACLE ARE ONE LIST. A `find` walk reads the FILESYSTEM, and a checkout holds
# gitignored rooms -- `.lap/` is one per ship and holds whatever that lap was drafting -- so a
# scratch copy of a delivery module would enter this population on one tree and no other, and eight
# ships would answer one meter differently for a reason none of them can see. Tracked files are the
# subject; a pen with no git is read by `find`, and the source is printed either way.
if git -C "$root_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  corpus_source=git_ls_files
  corpus=$(git -C "$root_dir" ls-files 'mantra/*.rye' | sed "s|^|$root_dir/|" | sort)
else
  corpus_source=find
  corpus=$(find "$root_dir/mantra" -name '*.rye' -type f 2>/dev/null | sort)
fi

code_of() { sed 's|//.*||' "$1"; }

sites=0
site_paths=""
dgram_files=""
dgram_count=0
proven=0
unproven_paths=""
unproven=0

for f in $corpus; do
  code=$(code_of "$f")
  n=$(printf '%s\n' "$code" | grep -c 'setsockopt(.*SO_REUSEADDR' 2>/dev/null)
  [ -n "$n" ] || n=0
  if [ "$n" -gt 0 ]; then
    sites=$((sites + n))
    site_paths="${site_paths} $f"
  fi
  # A module is in the UDP population when it opens SOCK_DGRAM and never SOCK_STREAM. A
  # `const SOCK_DGRAM` binding alone is not an open; the socket call is.
  printf '%s\n' "$code" | grep -q 'socket(.*SOCK_DGRAM' || continue
  printf '%s\n' "$code" | grep -q 'SOCK_STREAM' && continue
  dgram_count=$((dgram_count + 1))
  dgram_files="${dgram_files} $f"
  # The proof is both halves: read the option back, and assert what was read. A getsockopt whose
  # answer nothing checks is a call, never a claim.
  if printf '%s\n' "$code" | grep -q 'getsockopt(.*SO_REUSEADDR' && printf '%s\n' "$code" | grep -q 'assert(reuse == 0)'; then
    proven=$((proven + 1))
  else
    unproven=$((unproven + 1))
    unproven_paths="${unproven_paths} $f"
  fi
done

echo "root_dir=$root_dir"
echo "corpus_source=$corpus_source"
echo "corpus_files=$(printf '%s\n' $corpus | grep -c . || printf 0)"
echo "reuseaddr_sites=$sites"
for p in $site_paths; do echo "  site $p"; done
echo "dgram_modules=$dgram_count"
echo "dgram_proven_off=$proven"
echo "dgram_unproven=$unproven"
for p in $unproven_paths; do echo "  unproven $p"; done

# THE WIRING READING. A witness that drives one of these binaries wants the port pair to itself, and
# the lock is how two lawful runs stay apart. This is reported with each path named, so the number
# is a door rather than a verdict.
lock_fixture="tools/fixtures/m/mantra_delivery_port_lock.sh"
unwired=0
unwired_paths=""
wired=0
if [ -d "$root_dir/tools" ]; then
  for w in $(grep -rl 'mantra/bin/[a-z_-]*delivery' "$root_dir/tools" 2>/dev/null | sort); do
    case "$w" in *"$lock_fixture") continue ;; esac
    if grep -q "$lock_fixture" "$w" 2>/dev/null; then
      wired=$((wired + 1))
    else
      unwired=$((unwired + 1))
      unwired_paths="${unwired_paths} $w"
    fi
  done
fi
echo "witness_lock_wired=$wired"
echo "witness_lock_unwired=$unwired"
for p in $unwired_paths; do echo "  unwired $p"; done

if [ "$sites" -gt 0 ]; then
  echo "verdict=reuseaddr_present"
  exit 1
fi
if [ "$unproven" -gt 0 ]; then
  echo "verdict=unproven_dgram_module"
  exit 1
fi
echo "verdict=ok"
