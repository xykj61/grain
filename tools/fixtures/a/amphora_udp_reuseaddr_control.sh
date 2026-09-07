#!/usr/bin/env sh
# tools/fixtures/a/amphora_udp_reuseaddr_control.sh -- prove amphora_udp_reuseaddr_scan.sh on planted trees.
#
# Every refusal is shown from the failing side, every welcome is asserted as hard as every refusal,
# and the pen itself is proven innocent -- a scan rewritten to always answer `ok` must fail this
# control, or a green reading here cannot be told from a bypass.
#
# Run from the repository root:
#   sh tools/fixtures/a/amphora_udp_reuseaddr_control.sh
set -u

ROOT=$(pwd)
SCAN="$ROOT/tools/fixtures/a/amphora_udp_reuseaddr_scan.sh"
PEN=$(mktemp -d "${TMPDIR:-/tmp}/amphora_udp_reuseaddr_control.XXXXXX") || exit 2
trap 'rm -rf "$PEN"' EXIT

behaviors=0
failed=0

check() { # check <name> <expected> <actual>
  behaviors=$((behaviors + 1))
  if [ "$2" = "$3" ]; then
    echo "  ok   $1"
  else
    echo "  FAIL $1 -- wanted [$2] got [$3]"
    failed=$((failed + 1))
  fi
}

mkpen() { # mkpen <name> ; echoes its root
  d="$PEN/$1"; mkdir -p "$d/amphora"; printf '%s' "$d"
}

verdict_of() { sh "$SCAN" "$1" 2>/dev/null | sed -n 's/^verdict=//p'; }
field_of()   { sh "$SCAN" "$2" 2>/dev/null | sed -n "s/^$1=//p"; }

# -- 1. a live setsockopt site refuses ----------------------------------------------------------
p=$(mkpen live_site)
cat > "$p/amphora/vessel_fetch_delivery.rye" <<'RYE'
fn open_socket() !c.fd_t {
    const fd = c.socket(AF_INET, SOCK_DGRAM, 0);
    const yes: c_int = 1;
    if (c.setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, @sizeOf(c_int)) < 0) {
        return error.SetSockOptFailed;
    }
    return fd;
}
RYE
check "live setsockopt site refuses"        "reuseaddr_present" "$(verdict_of "$p")"
check "live site is counted once"           "1"                 "$(field_of source_reuseaddr_sites "$p")"

# -- 2. the repaired shape passes ---------------------------------------------------------------
p=$(mkpen repaired)
cat > "$p/amphora/vessel_fetch_delivery.rye" <<'RYE'
fn open_socket() !c.fd_t {
    const fd = c.socket(AF_INET, SOCK_DGRAM, 0);
    // The option that was here was TCP reasoning on a UDP socket: setsockopt(SO_REUSEADDR)
    // stood here until 20260906 and bought a silent duplicate bind.
    var reuse: c_int = 0;
    if (c.getsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &reuse, &reuse_len) < 0) {
        return error.GetSockOptFailed;
    }
    assert(reuse == 0);
    return fd;
}
RYE
check "repaired shape passes"               "ok"                "$(verdict_of "$p")"
check "repaired shape counts no site"       "0"                 "$(field_of source_reuseaddr_sites "$p")"

# -- 3. THE COMMENT IS NOT THE CALL, proven from the failing side --------------------------------
# The first draft of the scan counted the retired call named in prose and reddened on its own
# repair. A pen whose ONLY occurrence is inside a comment must pass.
p=$(mkpen comment_only)
cat > "$p/amphora/note.rye" <<'RYE'
// A history line: c.setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, 4) stood here once.
fn open_socket() !c.fd_t {
    return c.socket(AF_INET, SOCK_DGRAM, 0);
}
RYE
check "comment-only mention passes"         "ok"                "$(verdict_of "$p")"
check "comment-only counts no site"         "0"                 "$(field_of source_reuseaddr_sites "$p")"

# A trailing comment on a line of real code is the same question one column over.
p=$(mkpen trailing_comment)
cat > "$p/amphora/note.rye" <<'RYE'
fn open_socket() !c.fd_t {
    const fd = c.socket(AF_INET, SOCK_DGRAM, 0); // no c.setsockopt(SOL_SOCKET, SO_REUSEADDR) here
    return fd;
}
RYE
check "trailing-comment mention passes"     "ok"                "$(verdict_of "$p")"

# -- 4. two live sites are counted as two -------------------------------------------------------
p=$(mkpen two_sites)
printf 'fn a() { _ = c.setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, 4); }\n' > "$p/amphora/a.rye"
printf 'fn b() { _ = c.setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, 4); }\n' > "$p/amphora/b.rye"
check "two live sites refuse"               "reuseaddr_present" "$(verdict_of "$p")"
check "two live sites count two"            "2"                 "$(field_of source_reuseaddr_sites "$p")"

# -- 5. an empty amphora room is honest ---------------------------------------------------------
p=$(mkpen empty)
check "empty room passes"                   "ok"                "$(verdict_of "$p")"
check "empty room counts no files"          "0"                 "$(field_of corpus_files "$p")"

# -- 6. an absent root refuses rather than reading zero ------------------------------------------
sh "$SCAN" "$PEN/nowhere" >/dev/null 2>&1
check "absent root exits 2"                 "2"                 "$?"

# -- 7. the kernel probe ran, and each of its four answers is the one the repair rests on --------
check "kernel probe ran"                    "ran"               "$(field_of kernel_probe "$ROOT")"
check "rebind after close needs no option"  "ok"                "$(field_of rebind_after_close_no_reuse "$ROOT")"
check "concurrent without option refuses"   "refused_EADDRINUSE" "$(field_of concurrent_neither_reuse "$ROOT")"
check "concurrent with option on both ok"   "ok"                "$(field_of concurrent_both_reuse "$ROOT")"
check "mixed pair refuses the newcomer"     "refused_EADDRINUSE" "$(field_of concurrent_holder_reuse_only "$ROOT")"

# -- 8. the living tree passes ------------------------------------------------------------------
check "living amphora passes"               "ok"                "$(verdict_of "$ROOT")"

# -- 9. THE THIRD READING REPORTS AND NEVER GATES ------------------------------------------------
# The census of other lanes' modules is the one reading here with no authority to refuse. Each leg
# below asserts the count AND the verdict, because a reading that quietly gated would look
# identical in the count alone.
p=$(mkpen peer_dgram); mkdir -p "$p/mantra"
cat > "$p/mantra/recall_sync_delivery.rye" <<'RYE'
fn open_socket() !c.fd_t {
    const fd = c.socket(AF_INET, SOCK_DGRAM, 0);
    const yes: c_int = 1;
    if (c.setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, @sizeOf(c_int)) < 0) {
        return error.SetSockOptFailed;
    }
    return fd;
}
RYE
check "peer datagram site is counted"       "1"    "$(field_of tree_dgram_reuseaddr_files "$p")"
check "peer datagram site counts one call"  "1"    "$(field_of tree_dgram_reuseaddr_sites "$p")"
check "peer datagram site does NOT gate"    "ok"   "$(verdict_of "$p")"

# A module opening SOCK_STREAM may set the option for TCP's own reason, so it is held out -- and
# held out ALOUD, since a reading that drops files in silence overstates how much it looked at.
p=$(mkpen peer_stream); mkdir -p "$p/comlink"
cat > "$p/comlink/tcp_wire.rye" <<'RYE'
fn open_socket() !c.fd_t {
    const fd = c.socket(AF_INET, SOCK_STREAM, 0);
    const yes: c_int = 1;
    _ = c.setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, @sizeOf(c_int));
    return fd;
}
RYE
check "stream peer is held out of the count" "0"   "$(field_of tree_dgram_reuseaddr_files "$p")"
check "stream peer is reported as held out"  "1"   "$(field_of tree_mixed_socket_files "$p")"
check "stream peer does not gate"            "ok"  "$(verdict_of "$p")"

# The comment rule reaches the third reading too, or the census counts prose in nineteen lanes.
p=$(mkpen peer_comment); mkdir -p "$p/granary"
printf '// c.setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, 4) stood here once.\nconst SOCK_DGRAM: c_uint = 2;\n' \
  > "$p/granary/note.rye"
check "peer comment-only counts no file"    "0"    "$(field_of tree_dgram_reuseaddr_files "$p")"

# The gate is unmoved by the census beside it: an amphora site still refuses with peers present.
p=$(mkpen gate_with_peers); mkdir -p "$p/mantra"
printf 'fn a() { _ = c.setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, 4); }\n' > "$p/amphora/a.rye"
printf 'const SOCK_DGRAM: c_uint = 2;\nfn b() { _ = c.setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, 4); }\n' \
  > "$p/mantra/b.rye"
check "amphora gate bites with peers present" "reuseaddr_present" "$(verdict_of "$p")"
check "peer counted while amphora refuses"    "1"                 "$(field_of tree_dgram_reuseaddr_files "$p")"

# AND THE CENSUS REACHES SOMETHING ON THE LIVING TREE. A census answering zero of everything is
# indistinguishable from a healthy tree (REDS %463), so this leg proves the reading arrives. It
# asserts *at least one* rather than today's nineteen on purpose: pinning the count would red this
# guard on the day another lane does the right thing, which is a guard punishing the repair.
live_peers=$(field_of tree_dgram_reuseaddr_files "$ROOT")
behaviors=$((behaviors + 1))
if [ -n "$live_peers" ] && [ "$live_peers" -ge 1 ]; then
  echo "  ok   census reaches the living tree -- $live_peers peer file(s)"
else
  echo "  FAIL census reaches the living tree -- wanted at least 1, got [$live_peers]"
  failed=$((failed + 1))
fi

# -- 10. THE PEN PROVEN INNOCENT ------------------------------------------------------------------
# A scan that always answers ok must fail the refusals above. Without this, a green control cannot
# be told from a scan that stopped reading.
blind="$PEN/blind_scan.sh"
# The blinded copy does ALL of the reading and loses exactly one comparison -- the line that turns
# a counted site into a refusal. Anything less surgical (a stub that only echoes) would prove the
# pen can run a script, which is not the question. Built with python3 so the substitution is exact;
# where python3 is absent the leg says so rather than passing on a sed that failed, which is how
# the first draft of this control read green while proving nothing.
if command -v python3 >/dev/null 2>&1; then
  python3 - "$SCAN" "$blind" <<'PYBLIND'
import sys
src, dst = sys.argv[1], sys.argv[2]
text = open(src).read()
gate = '[ "$sites" -eq 0 ] || verdict=reuseaddr_present'
assert gate in text, "control: the scan no longer carries the site gate this leg blinds"
open(dst, "w").write(text.replace(gate, ': # blinded for the pen-innocence leg'))
PYBLIND
  blind_built=$?
  blind_v=$(sh "$blind" "$PEN/live_site" 2>/dev/null | sed -n 's/^verdict=//p' | tail -1)
  blind_sites=$(sh "$blind" "$PEN/live_site" 2>/dev/null | sed -n 's/^source_reuseaddr_sites=//p')
  check "blind copy was built"                 "0"   "$blind_built"
  check "blind copy still COUNTS the site"     "1"   "$blind_sites"
  check "blind copy answers ok on a live site" "ok"  "$blind_v"
  behaviors=$((behaviors + 1))
  if [ "$blind_v" = "ok" ] && [ "$blind_sites" = "1" ]; then
    echo "  ok   pen innocent -- the refusal above came from the gate, not from the harness"
  else
    echo "  FAIL pen innocent -- blinding the gate did not flip the verdict"
    failed=$((failed + 1))
  fi
else
  behaviors=$((behaviors + 1)); failed=$((failed + 1))
  echo "  FAIL pen innocent -- python3 absent, so this leg proved nothing and says so"
fi

echo "behaviors=$behaviors failed=$failed"
if [ "$failed" -eq 0 ]; then
  echo "control_verdict=ok"
  exit 0
fi
echo "control_verdict=broken"
exit 1
