#!/usr/bin/env sh
# tools/fixtures/m/mantra_udp_reuseaddr_control.sh -- prove mantra_udp_reuseaddr_scan.sh and
# mantra_bind_refusal_probe.sh on planted trees and stub binaries.
#
# Every refusal is shown from the failing side, every welcome is asserted as hard as every refusal,
# and the pen itself is proven innocent -- a scan rewritten to always answer `ok` must fail this
# control, or a green reading here cannot be told from a bypass.
#
# THE PROBE IS PROVEN ON STUBS, and the reason is a measurement rather than a shortcut. Its three
# branches are decided by an exit code and a first error line, so a stub that prints those two
# things exercises the decision exactly as a built delivery binary does -- while a pen build would
# cost twenty seconds a leg and a mutant delivery module written into mantra/ would put a plant
# into the population every find-walking scan on this pier reads (the shape REDS `%519` books).
# The probe was run against the real binaries on metal `20260911`: the repaired snapshot binary
# answers `refused_by_name`, and the elder one, built from the commit before the repair, answers
# `bound_beside_holder`.
#
# Run from the repository root:
#   sh tools/fixtures/m/mantra_udp_reuseaddr_control.sh
set -u

ROOT=$(pwd)
SCAN="$ROOT/tools/fixtures/m/mantra_udp_reuseaddr_scan.sh"
PROBE="$ROOT/tools/fixtures/m/mantra_bind_refusal_probe.sh"
PEN=$(mktemp -d "${TMPDIR:-/tmp}/mantra_udp_reuseaddr_control.XXXXXX") || exit 2
trap 'rm -rf "$PEN"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

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
  d="$PEN/$1"; mkdir -p "$d/mantra"; printf '%s' "$d"
}

verdict_of() { sh "$SCAN" "$1" 2>/dev/null | sed -n 's/^verdict=//p'; }
field_of()   { sh "$SCAN" "$2" 2>/dev/null | sed -n "s/^$1=//p"; }

repaired_body='fn open_socket() !c.fd_t {
    const fd = c.socket(AF_INET, SOCK_DGRAM, 0);
    if (fd < 0) return error.SocketFailed;
    assert(fd >= 0);
    // The option that stood here was TCP reasoning: setsockopt(SO_REUSEADDR) bought a duplicate bind.
    var reuse: c_int = 0;
    var reuse_len: c.socklen_t = @sizeOf(c_int);
    if (c.getsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &reuse, &reuse_len) < 0) {
        _ = c.close(fd);
        return error.GetSockOptFailed;
    }
    assert(reuse == 0);
    return fd;
}'

# -- 1. a live setsockopt site refuses ------------------------------------------------------------
p=$(mkpen live_site)
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
check "live setsockopt site refuses"      "reuseaddr_present" "$(verdict_of "$p")"
check "live site is counted once"         "1"                 "$(field_of reuseaddr_sites "$p")"
check "a pen with no git reads by find"   "find"              "$(field_of corpus_source "$p")"

# -- 2. the repaired shape passes, and is counted proven ------------------------------------------
p=$(mkpen repaired)
printf '%s\n' "$repaired_body" > "$p/mantra/recall_sync_delivery.rye"
check "repaired shape passes"             "ok" "$(verdict_of "$p")"
check "repaired module counted dgram"     "1"  "$(field_of dgram_modules "$p")"
check "repaired module counted proven"    "1"  "$(field_of dgram_proven_off "$p")"
check "repaired module not unproven"      "0"  "$(field_of dgram_unproven "$p")"

# -- 3. silence is not a proof --------------------------------------------------------------------
p=$(mkpen silent)
cat > "$p/mantra/recall_sync_delivery.rye" <<'RYE'
fn open_socket() !c.fd_t {
    const fd = c.socket(AF_INET, SOCK_DGRAM, 0);
    if (fd < 0) return error.SocketFailed;
    return fd;
}
RYE
check "a dgram module proving nothing refuses" "unproven_dgram_module" "$(verdict_of "$p")"
check "and it is named as unproven"            "1"                     "$(field_of dgram_unproven "$p")"

# -- 4. half a proof is not a proof ---------------------------------------------------------------
p=$(mkpen half_proof)
cat > "$p/mantra/recall_sync_delivery.rye" <<'RYE'
fn open_socket() !c.fd_t {
    const fd = c.socket(AF_INET, SOCK_DGRAM, 0);
    var reuse: c_int = 0;
    var reuse_len: c.socklen_t = @sizeOf(c_int);
    if (c.getsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &reuse, &reuse_len) < 0) {
        return error.GetSockOptFailed;
    }
    return fd;
}
RYE
check "a getsockopt nothing asserts refuses" "unproven_dgram_module" "$(verdict_of "$p")"

# -- 5. a comment naming the call is not the call -------------------------------------------------
p=$(mkpen comment_only)
{ printf '%s\n' "$repaired_body"
  echo '// setsockopt(SOL_SOCKET, SO_REUSEADDR) stood here until 20260911 and bought a duplicate bind.'
} > "$p/mantra/recall_sync_delivery.rye"
check "a comment naming setsockopt passes" "ok" "$(verdict_of "$p")"
check "and counts no site"                 "0"  "$(field_of reuseaddr_sites "$p")"

# -- 6. a stream socket is outside the population -------------------------------------------------
p=$(mkpen stream)
cat > "$p/mantra/some_stream.rye" <<'RYE'
fn open_socket() !c.fd_t {
    const fd = c.socket(AF_INET, SOCK_STREAM, 0);
    const fallback = c.socket(AF_INET, SOCK_DGRAM, 0);
    return fd;
}
RYE
check "a module opening SOCK_STREAM is outside" "0"  "$(field_of dgram_modules "$p")"
check "so it cannot be unproven"                "0"  "$(field_of dgram_unproven "$p")"
check "and the scan passes"                     "ok" "$(verdict_of "$p")"

# -- 7. an empty room is honest -------------------------------------------------------------------
p=$(mkpen empty)
check "an empty mantra room passes"   "ok" "$(verdict_of "$p")"
check "with no dgram modules counted" "0"  "$(field_of dgram_modules "$p")"

# -- 8. the wiring reading counts both sides ------------------------------------------------------
p=$(mkpen wiring)
printf '%s\n' "$repaired_body" > "$p/mantra/recall_sync_delivery.rye"
mkdir -p "$p/tools/m"
echo 'let r = run ["sh" "-c" "mantra/bin/recall-sync-delivery selftest"]' > "$p/tools/m/bare_witness.rish"
echo 'let r = run ["sh" "tools/fixtures/m/mantra_delivery_port_lock.sh" "38478" "mantra/bin/recall-sync-delivery" "selftest"]' > "$p/tools/m/locked_witness.rish"
check "an unlocked witness is named"   "1"  "$(field_of witness_lock_unwired "$p")"
check "a locked witness is counted"    "1"  "$(field_of witness_lock_wired "$p")"
check "and the wiring gates nothing"   "ok" "$(verdict_of "$p")"

# -- 9. the pen is innocent -- a scan that always says ok must fail here ---------------------------
cp "$SCAN" "$PEN/bypass_scan.sh"
printf '%s\n' '#!/usr/bin/env sh' 'echo "reuseaddr_sites=0"' 'echo "dgram_unproven=0"' 'echo "verdict=ok"' > "$PEN/bypass_scan.sh"
p=$(mkpen bypass_target)
cat > "$p/mantra/recall_sync_delivery.rye" <<'RYE'
fn open_socket() !c.fd_t {
    const fd = c.socket(AF_INET, SOCK_DGRAM, 0);
    const yes: c_int = 1;
    if (c.setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, @sizeOf(c_int)) < 0) return error.SetSockOptFailed;
    return fd;
}
RYE
bypass_verdict=$(sh "$PEN/bypass_scan.sh" "$p" | sed -n 's/^verdict=//p')
check "a bypass scan would answer ok on a planted site" "ok" "$bypass_verdict"
check "and the real scan refuses the same tree"         "reuseaddr_present" "$(verdict_of "$p")"

# -- 10. the probe's three branches, on stubs -----------------------------------------------------
# The stubs carry the two things the probe reads: an exit code and a first `error: ` line. A port
# the probe can hold is asked of the kernel rather than named, so this leg never touches 38478-38491
# and cannot disturb a peer's exchange.
probe_port=$(python3 -c "
import socket
s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
s.bind(('127.0.0.1',0))
print(s.getsockname()[1])
s.close()" 2>/dev/null || printf '')

if [ -z "$probe_port" ]; then
  echo "  skip probe branches -- python3 absent, which the probe itself reports as absent_instrument"
else
  cat > "$PEN/stub_refuses.sh" <<'STUB'
#!/usr/bin/env sh
echo "error: BindFailed" >&2
echo "    at the bind site" >&2
exit 1
STUB
  cat > "$PEN/stub_binds_beside.sh" <<'STUB'
#!/usr/bin/env sh
echo "GREEN: crossed localhost"
exit 0
STUB
  cat > "$PEN/stub_fails_unnamed.sh" <<'STUB'
#!/usr/bin/env sh
echo "error: RecvFailed" >&2
exit 1
STUB
  chmod +x "$PEN/stub_refuses.sh" "$PEN/stub_binds_beside.sh" "$PEN/stub_fails_unnamed.sh"

  probe_verdict_of() { sh "$PROBE" "$1" "$probe_port" selftest 2>/dev/null | sed -n 's/^probe_verdict=//p'; }
  probe_exit_of() { sh "$PROBE" "$1" "$probe_port" selftest >/dev/null 2>&1; echo $?; }

  check "a binary refusing by name passes"        "refused_by_name"     "$(probe_verdict_of "$PEN/stub_refuses.sh")"
  check "and exits zero"                          "0"                   "$(probe_exit_of "$PEN/stub_refuses.sh")"
  check "a binary succeeding beside a holder bites" "bound_beside_holder" "$(probe_verdict_of "$PEN/stub_binds_beside.sh")"
  check "and exits one"                           "1"                   "$(probe_exit_of "$PEN/stub_binds_beside.sh")"
  check "a failure naming something else bites"   "refused_unnamed"     "$(probe_verdict_of "$PEN/stub_fails_unnamed.sh")"
  check "a binary that is not here says so"       "absent_binary"       "$(probe_verdict_of "$PEN/no_such_binary")"
fi

echo "behaviors=$behaviors"
echo "failed=$failed"
if [ "$failed" -gt 0 ]; then
  echo "control_verdict=failed"
  exit 1
fi
echo "control_verdict=ok"
