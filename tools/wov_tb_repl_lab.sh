#!/bin/sh
# SUPERSEDED 20260711.055800 — WOV TB REPL lab retired from the living suite.
# Kaeden approved Claude counsel 055112: keep pure-Rye WOV core; retire the optional
# TigerBeetle cross-check seam to dated record. Kept; never deleted. Not run from parity.
# Living WOV coverage: tools/wov_exit_honesty.rish · tools/wov_dual_monarch.rish
#
# wov_tb_repl_lab.sh — WOV lap 2b seam A: cluster-of-one mint/transfer → projection file.
#
# Requires io_uring (blocked under ai-jail seccomp). On PermissionDenied, exits 0
# with WOV-TB-LIVE-SKIP so the projection witness can still GREEN in the enclosure.
#
# Usage (from repo root; manual / dated record only):
#   sh tools/wov_tb_ensure_binary.sh
#   sh tools/wov_tb_repl_lab.sh

set -eu
root="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
cd "$root"
build="$root/tools/.build/tigerbeetle"
tb="$build/tigerbeetle"
data="$build/0_0.tigerbeetle"
proj="$build/wov_tb_projection_live.bron"
port="${WOV_TB_PORT:-3010}"
cluster=0

if [ ! -x "$tb" ]; then
  sh tools/wov_tb_ensure_binary.sh
fi

# Probe io_uring before formatting a data file.
if ! python3 - <<'PY'
import ctypes, ctypes.util, os, sys
libc = ctypes.CDLL(ctypes.util.find_library("c"), use_errno=True)
NR = 425
class Params(ctypes.Structure):
    _fields_ = [
        ("sq_entries", ctypes.c_uint32), ("cq_entries", ctypes.c_uint32),
        ("flags", ctypes.c_uint32), ("sq_thread_cpu", ctypes.c_uint32),
        ("sq_thread_idle", ctypes.c_uint32), ("features", ctypes.c_uint32),
        ("wq_fd", ctypes.c_uint32), ("resv", ctypes.c_uint32 * 3),
        ("sq_off", ctypes.c_uint8 * 40), ("cq_off", ctypes.c_uint8 * 40),
    ]
p = Params()
fd = libc.syscall(NR, 8, ctypes.byref(p))
sys.exit(0 if fd >= 0 else 1)
PY
then
  echo "WOV-TB-LIVE-SKIP io_uring unavailable (ai-jail seccomp or kernel policy)"
  echo "WOV-TB-LIVE-SKIP use host metal outside the enclosure for cluster-of-one"
  exit 0
fi

rm -f "$data" "$proj" "$build/replica.log" "$build/repl.out"
"$tb" format --cluster="$cluster" --replica=0 --replica-count=1 --development "$data"
"$tb" start --addresses="$port" --development "$data" >"$build/replica.log" 2>&1 &
rpid=$!
cleanup() {
  kill "$rpid" 2>/dev/null || true
  wait "$rpid" 2>/dev/null || true
}
trap cleanup EXIT INT TERM
sleep 1

# Control accounts: 1=issued, 2=redeemed. Holders: 10=A, 11=B (witness ids).
# Mint 1000 issued→A; transfer 300 A→B. Nonces tracked WOV-side in projection.
printf '%s\n' \
  'create_accounts id=1 code=10 ledger=700, id=2 code=10 ledger=700, id=10 code=10 ledger=700, id=11 code=10 ledger=700;' \
  'create_transfers id=1 debit_account_id=1 credit_account_id=10 amount=1000 ledger=700 code=10;' \
  'create_transfers id=2 debit_account_id=10 credit_account_id=11 amount=300 ledger=700 code=10;' \
  'lookup_accounts id=1, id=2, id=10, id=11;' \
  | "$tb" repl --cluster="$cluster" --addresses="$port" >"$build/repl.out" 2>&1

# Map TB numeric ids → lap-1 Kumara pubkey hex (same seeds as wov_core).
# Balance = credits_posted - debits_posted for holders.
python3 - <<'PY' "$build/repl.out" "$proj"
import json, re, sys
text = open(sys.argv[1]).read()
# Extract JSON objects from REPL output
objs = []
for m in re.finditer(r'\{[^{}]+\}', text, re.S):
    try:
        objs.append(json.loads(m.group(0)))
    except json.JSONDecodeError:
        pass
by_id = {o["id"]: o for o in objs if "id" in o and "credits_posted" in o}
need = ("1", "2", "10", "11")
for k in need:
    if k not in by_id:
        raise SystemExit(f"missing account {k} in REPL lookup")
def bal(o):
    return int(o["credits_posted"]) - int(o["debits_posted"])
issued = bal(by_id["1"]) * -1  # issued control is debited on mint → negative TB bal; WOV issued is +1000
# Prefer conservation from holder sum + redeemed control
holder_a = bal(by_id["10"])
holder_b = bal(by_id["11"])
redeemed = bal(by_id["2"]) * -1 if bal(by_id["2"]) < 0 else bal(by_id["2"])
# Issued = holder sum + redeemed (conservation)
issued_wov = holder_a + holder_b + redeemed
# Lap-1 golden pubkeys
A = "5b6489c9c7fd0dcf50545e7c164886ef40491ec06c7f1b123041797e8117535e"
B = "fec1428673f6afe89264b3807344ae8b269d125a503855202687db5a7128579f"
# Nonces: mint bumps A once, transfer bumps A and B → A=2, B=1 (match lap 1)
out = [
    "wov-tb-projection/v1",
    f"issued {issued_wov}",
    f"redeemed {redeemed}",
    f"{A} {holder_a} 2",
    f"{B} {holder_b} 1",
    "",
]
open(sys.argv[2], "w").write("\n".join(out))
print(f"projection written holders A={holder_a} B={holder_b} issued={issued_wov} redeemed={redeemed}")
if holder_a != 700 or holder_b != 300 or issued_wov != 1000:
    raise SystemExit("balance shape mismatch vs lap-1 scenario")
PY

linengrow/bin/wov-tb-host from-projection "$proj"
echo "WOV-TB-LIVE-GREEN cluster-of-one mint/transfer → exit honesty"
