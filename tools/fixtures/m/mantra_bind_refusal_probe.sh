#!/usr/bin/env sh
# tools/fixtures/m/mantra_bind_refusal_probe.sh -- a second reacher for a held mantra port is
# refused BY NAME, proven against the built binary rather than argued from the source.
#
# WHAT IT DOES. It holds 127.0.0.1:<port> in a process of its own, runs the delivery binary handed
# to it, and reads what the binary says. A repaired module refuses at `bind` and names the failure
# `BindFailed` on its first error line; the elder module, which set SO_REUSEADDR, bound beside the
# holder and printed `GREEN` while the kernel split the datagrams between the two readers. Measured
# both ways on this pier `20260911`.
#
# WHY THE HOLDER SETS SO_REUSEADDR ITSELF. The holder stands for a peer ship still running the
# elder shape, which is the population this repair actually meets -- and under the kernel's own
# rule a holder WITHOUT the option already refuses every newcomer, which would prove the newcomer
# nothing about itself. With the option set on the holder alone, the kernel refuses a newcomer that
# lacks it and admits one that sets it, so the reading is about the binary under test.
#
# THE CALLER TAKES THE PORT LOCK. This probe binds a real machine-wide port, so running it bare
# would red a peer's lap -- the exact fault it exists to name. Its witness calls it through
# tools/fixtures/m/mantra_delivery_port_lock.sh.
#
# USAGE, from the repository root:
#   sh tools/fixtures/m/mantra_bind_refusal_probe.sh <binary> <port> [<argv1>]
set -u

[ "$#" -ge 2 ] || { echo "$0: name a binary and a port" >&2; exit 2; }
bin=$1
port=$2
arg=${3:-selftest}

[ -x "$bin" ] || { echo "probe_verdict=absent_binary"; echo "detail: $bin is not executable here"; exit 0; }
if ! command -v python3 >/dev/null 2>&1; then
  echo "probe_verdict=absent_instrument"
  echo "detail: python3 is what holds the port; a guard that cannot run its instrument must not describe its subject"
  exit 0
fi

python3 - "$bin" "$port" "$arg" <<'PY'
import socket, subprocess, sys

binary, port, arg = sys.argv[1], int(sys.argv[2]), sys.argv[3]
holder = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
# The holder stands for a peer running the elder shape -- see the header above for why it is the
# holder rather than the binary under test that carries the option.
holder.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
try:
    holder.bind(("127.0.0.1", port))
except OSError as e:
    print("probe_verdict=port_busy")
    print("detail: %s already held by something outside this probe -- %s" % (port, e))
    sys.exit(0)

# Bounded: one exchange takes about two seconds and a refusal returns at once, so a run past sixty
# is a hang rather than a slow pier, and saying so beats waiting.
try:
    r = subprocess.run([binary, arg], capture_output=True, text=True, timeout=60)
except subprocess.TimeoutExpired:
    print("probe_verdict=timeout")
    sys.exit(1)
finally:
    holder.close()

err = r.stderr or ""
out = r.stdout or ""
first_error = ""
for line in err.splitlines():
    if line.startswith("error: "):
        first_error = line[len("error: "):].strip()
        break

print("held_port=%d" % port)
print("binary_exit=%d" % r.returncode)
print("first_error=%s" % (first_error or "none"))
print("said_green=%s" % ("yes" if "GREEN" in out or "GREEN" in err else "no"))

if first_error == "BindFailed" and r.returncode != 0:
    print("probe_verdict=refused_by_name")
    sys.exit(0)
if r.returncode == 0:
    print("probe_verdict=bound_beside_holder")
    print("detail: the binary shared a held port and reported success -- this is the silent duplicate bind")
    sys.exit(1)
print("probe_verdict=refused_unnamed")
print("detail: the run failed without naming BindFailed first, so the cause a reader gets is inference")
sys.exit(1)
PY
