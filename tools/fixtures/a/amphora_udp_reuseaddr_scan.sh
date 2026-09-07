#!/usr/bin/env sh
# tools/fixtures/a/amphora_udp_reuseaddr_scan.sh -- Amphora's UDP sockets carry no address reuse, and the
# kernel behaviour that makes that the right choice is proven rather than recited.
#
# WHY. amphora/vessel_fetch_delivery.rye bound UDP 38495 under `setsockopt(SO_REUSEADDR)`, whose
# invariant read *SO_REUSEADDR is what lets a bounded run rebind its own port*. That is TCP
# reasoning: a closed TCP socket sits in TIME_WAIT holding its port, and the option is what lets a
# restart rebind through it. UDP has no TIME_WAIT, so a closed UDP port is free at once and the
# option was buying nothing it was added for. What it bought instead was a DUPLICATE BIND -- two
# sockets that both set it may hold one address and port together while the kernel splits arriving
# datagrams between them, with no error on either side. A per-tree lock was then built to prevent
# the collision that option had made silent. REDS `20260906.154105`.
#
# THREE READINGS, and only one of them is a gate.
#
#   source_reuseaddr_sites  -- setsockopt calls naming SO_REUSEADDR in the amphora Rye sources.
#                              GATED AT ZERO. This is the regression guard: it is what keeps the
#                              option from walking back in under its old, plausible comment.
#   kernel_probe            -- the four binds that decide whether dropping it is right. REPORTED,
#                              and gated only when the probe actually ran, because a guard that
#                              cannot run its instrument must not describe its subject (REDS %460).
#   tree_dgram_reuseaddr    -- the same shape in Rye modules OUTSIDE amphora that open SOCK_DGRAM
#                              and never SOCK_STREAM. REPORTED, never gated: each of those files
#                              belongs to another lane, and a guard that reds a lane over a peer's
#                              module is a guard that lane turns off.
#
# THE PROBE ASKS THE KERNEL FOR ITS PORT rather than naming one. A hardcoded probe port is a second
# machine-wide resource for eight ships to collide on, which is this row's own fault one level up;
# `bind` to port zero and `getsockname` hand back a free one atomically. Amphora's own 38494/38495
# are never touched, so a peer's live exchange is never disturbed.
#
# USAGE, from the repository root:
#   sh tools/fixtures/a/amphora_udp_reuseaddr_scan.sh [ROOT_DIR]
#
# ROOT_DIR names another checkout to read, so a control can build a pen and point this at it. The
# kernel probe is a fact about the machine rather than the tree, so it runs the same either way.
set -u

root_dir=${1:-.}
[ -d "$root_dir" ] || { echo "udp_reuseaddr_scan: no such root -- $root_dir" >&2; exit 2; }

# The GATED corpus is named rather than discovered: this is Amphora's property, and the gate is
# Amphora's to hold. The elder note here declined a wider sweep because it "would hold modules whose
# sockets are not UDP and whose reuse may be correct" -- a hypothesis about the rest of the tree,
# stated rather than measured. The third reading below measures it, and holds that objection by
# construction: it counts only files that open SOCK_DGRAM and never SOCK_STREAM.
corpus=$(find "$root_dir/amphora" -name '*.rye' -type f 2>/dev/null | sort)

# A setsockopt naming SO_REUSEADDR is the site. A `const SO_REUSEADDR = c.SO.REUSEADDR` binding is
# NOT a site, and neither is a getsockopt reading the option back to prove it off -- the repaired
# module does exactly that, so a pattern blind to the difference would red on its own repair.
# AND A COMMENT NAMING THE CALL IS NOT THE CALL. The repaired module explains in prose why the
# option was dropped, and that prose contains the word `setsockopt(SO_REUSEADDR)` -- which the
# first draft of this scan counted as a live site, reddening on the very repair it exists to hold.
# Code lines only: a line whose first non-space is `//` is Rye comment and is read past.
sites=0
site_paths=""
for f in $corpus; do
  n=$(sed 's|//.*||' "$f" | grep -c 'setsockopt(.*SO_REUSEADDR' 2>/dev/null)
  [ -n "$n" ] || n=0
  if [ "$n" -gt 0 ]; then
    sites=$((sites + n))
    site_paths="${site_paths} $f"
  fi
done

echo "root_dir=$root_dir"
echo "corpus_files=$(printf '%s\n' $corpus | grep -c . || printf 0)"
echo "source_reuseaddr_sites=$sites"
for p in $site_paths; do echo "  site $p"; done

# -- the third reading: the same shape, one lane over ------------------------------------------
# THE OPTION WAS NEVER AMPHORA'S ALONE. `open_socket` was copied module to module carrying its
# comment intact, so the TCP sentence that was wrong here is wrong verbatim wherever it landed.
# This reading counts it and never gates on it: those files are other lanes' to repair, and a
# guard that reds a lane over a peer's module is a guard that lane turns off.
#
# THE ELDER OBJECTION IS HELD BY CONSTRUCTION rather than by trust. A module opening SOCK_STREAM
# may set the option for TCP's own good reason, so a file naming SOCK_STREAM at all is held out and
# counted separately as `tree_mixed_socket_files` -- named aloud, because a reading that drops files
# in silence reads as *the class is this size* when it only ever says *the part I looked at is*.
peer_sites=0
peer_files=0
mixed_files=0
peer_paths=""
mixed_paths=""
peer_corpus=$(find "$root_dir" -name '*.rye' -type f 2>/dev/null \
  | grep -v "^$root_dir/amphora/" | grep -v "^$root_dir/seed/" | sort)
for f in $peer_corpus; do
  n=$(sed 's|//.*||' "$f" | grep -c 'setsockopt(.*SO_REUSEADDR' 2>/dev/null)
  [ -n "$n" ] || n=0
  [ "$n" -gt 0 ] || continue
  if grep -q 'SOCK_STREAM' "$f" 2>/dev/null; then
    mixed_files=$((mixed_files + 1))
    mixed_paths="${mixed_paths} $f"
  elif grep -q 'SOCK_DGRAM' "$f" 2>/dev/null; then
    peer_sites=$((peer_sites + n))
    peer_files=$((peer_files + 1))
    peer_paths="${peer_paths} $f"
  fi
done

echo "tree_dgram_reuseaddr_sites=$peer_sites"
echo "tree_dgram_reuseaddr_files=$peer_files"
echo "tree_mixed_socket_files=$mixed_files"
for p in $peer_paths;  do echo "  peer $p"; done
for p in $mixed_paths; do echo "  held_out $p"; done

# -- the kernel probe -------------------------------------------------------------------------
# Four binds of one kernel-chosen UDP port, each answering one question the repair rests on.
if command -v python3 >/dev/null 2>&1; then
  probe=$(python3 - <<'PY' 2>/dev/null
import socket, errno

def mk(reuse):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    if reuse:
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    return s

def bind(s, port):
    try:
        s.bind(("127.0.0.1", port)); return "ok"
    except OSError as e:
        return "refused_" + str(errno.errorcode.get(e.errno, e.errno))

def holder(reuse):
    # 0 IS THE ASK, NOT THE PORT -- the kernel hands back a free one atomically.
    s = mk(reuse); s.bind(("127.0.0.1", 0)); return s, s.getsockname()[1]

try:
    # 1. close, then rebind at once, with no reuse option anywhere.
    s, p = holder(False); s.close()
    b = mk(False); r1 = bind(b, p); b.close()

    # 2. two concurrent binds, neither setting the option.
    s, p = holder(False); b = mk(False); r2 = bind(b, p); b.close(); s.close()

    # 3. two concurrent binds, both setting it -- the shape the module carried.
    s, p = holder(True); b = mk(True); r3 = bind(b, p); b.close(); s.close()

    # 4. a holder that sets it against a newcomer that does not.
    s, p = holder(True); b = mk(False); r4 = bind(b, p); b.close(); s.close()

    print("rebind_after_close_no_reuse=%s" % r1)
    print("concurrent_neither_reuse=%s" % r2)
    print("concurrent_both_reuse=%s" % r3)
    print("concurrent_holder_reuse_only=%s" % r4)
except OSError as e:
    print("probe_error=%s" % errno.errorcode.get(e.errno, e.errno))
PY
)
  # THE INSTRUMENT MUST BE PROVEN TO HAVE RUN. An empty capture is python3 exiting non-zero, and
  # reading four absent answers as four passing ones is REDS %460 exactly.
  if printf '%s' "$probe" | grep -q 'rebind_after_close_no_reuse='; then
    echo "kernel_probe=ran"
    printf '%s\n' "$probe"
  else
    echo "kernel_probe=broken"
    [ -n "$probe" ] && printf '%s\n' "$probe"
  fi
else
  echo "kernel_probe=absent wants=python3"
fi

# -- the verdict ------------------------------------------------------------------------------
# The source reading always gates. The kernel reading gates only when it ran: absent says so and
# leaves the source gate standing, broken refuses, since a probe that started and failed is a fact.
# The third reading NEVER gates -- it is a census of other lanes' modules, and this guard has no
# standing to red a whole tree over a file its own seat may not edit.
verdict=ok
[ "$sites" -eq 0 ] || verdict=reuseaddr_present

probe_state=$(printf '%s\n' "$probe" 2>/dev/null | grep -c 'rebind_after_close_no_reuse=' || printf 0)
if command -v python3 >/dev/null 2>&1; then
  if [ "$probe_state" -eq 0 ]; then
    verdict=probe_broken
  else
    # Each expectation is named beside the reading it holds, so a kernel that disagrees says which
    # of the four it disagreed about rather than failing as one opaque block.
    printf '%s\n' "$probe" | grep -q 'rebind_after_close_no_reuse=ok' \
      || verdict=kernel_needs_reuse_to_rebind
    printf '%s\n' "$probe" | grep -q 'concurrent_neither_reuse=refused_EADDRINUSE' \
      || verdict=kernel_allows_silent_duplicate_bind
    printf '%s\n' "$probe" | grep -q 'concurrent_both_reuse=ok' \
      || verdict=kernel_refuses_reuse_duplicate
    printf '%s\n' "$probe" | grep -q 'concurrent_holder_reuse_only=refused_EADDRINUSE' \
      || verdict=kernel_mixed_pair_unexpected
  fi
fi

echo "verdict=$verdict"
[ "$verdict" = ok ] || exit 1
exit 0
