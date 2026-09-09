# A Reply Budget Needs a Wait Budget

**Stamp:** 20260909.062114
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Living, mixed -- a local receive experiment; the service contract stays proposed.
**Scope:** The hosted Tablecloth query receiver at Git nib `f853fed32b`, read and run on 2026-09-09.
**Kin:** [The query and reply budget](20260909-044642_the-query-and-the-reply-budget.md).

When does a request let go of the room it holds? A result can fit its byte buffer while its
caller keeps waiting for delivery. This study separates the receive wait from the search and
reply limits already measured. Its subject is a hosted demonstration.

## Follow the call

**Observation.** The [hosted delivery source](../mantra/recall_tablecloth_query_delivery.rye)
checks `build_response` and `encode_response` with `try` before sending. A local overflow
therefore exits that path before a success reply is sent. Its `recv_wire` function opens a
blocking socket and calls `recvfrom` with flags zero. The socket configuration supplies reuse and leaves the receive wait at its blocking default.
These are source readings at the nib above. An outer supervisor's deadline lies outside this reading.

**Observation.** RFC 8085, published in March 2017, leaves lost-packet retransmission
and delivery ordering to applications. Applications needing those properties must provide them or
use a transport that does. Read on 2026-09-09: [RFC 8085, section 3.3](https://www.rfc-editor.org/rfc/rfc8085.html#section-3.3).

**Inference.** A successful local search and a bounded reply still leave the caller's completion
contract to settle. A host's safe refusal needs a caller policy for a withheld answer.
The source's local error return is distinct from an error delivered to the waiting client.

## The small experiment

**Observation.** The Linux experiment below copies the hosted source into an ignored pen. It
retains `open_socket` and the receive call, adds a bound-port announcement, and replaces the
entry point with one receive into an **8-byte buffer**. Port zero asks the kernel to choose a
local port. Kernel-assigned ports keep the probe separate from the demonstration's ports; traffic stays on loopback.

The parent starts its observation after the child's ready announcement. That announcement follows
binding and precedes the receive call. The exact instant of syscall entry lies outside this observation.
The withheld case proves the child had not completed at the harness limit. The source reading
identifies an implicit local wait policy.

| Case on 2026-09-09 | Reading from the reproduced probe |
|---|---|
| Parent sends one byte after readiness | Receiver reports 1 byte and exits 0 |
| Parent withholds delivery | Parent reaches its 250 ms observation limit; child still runs |
| Same source, receive flag changed to nonblocking | Receiver reports `RecvFailed` and exits 1 |

The recorded withheld observation lasted **250.451 ms**, measured with the parent's monotonic
clock. This duration belongs to the harness and host scheduling. Product deadlines
and network latency require their own measurements. The harness then verifies the child's working directory and sends
TERM to that exact child; the recorded exit is **-15** in Python's signal convention.

**Inference.** The experiment distinguishes successful receipt, continued waiting, and immediate
refusal. The observed interval is finite. The nonblocking flag serves as a diagnostic control:
by itself it turns temporary absence into a generic receive error.

## Reproduce on this Linux checkout

Save the following block as `session-output/query-wait-probe/reproduce.py` and run it with
`python3` from the repository root. Create that ignored directory first. The script checks each
source substitution, builds both copies, runs all three cases, and writes `result.json` in its pen.
A changed source or compiler earns a new reading. The script uses unbuffered child pipes to carry both
the ready line and subsequent diagnostics through `communicate`.

```python
from pathlib import Path
import json
import select
import socket
import subprocess
import time

root = Path.cwd()
pen = root / 'session-output/query-wait-probe'
pen.mkdir(parents=True, exist_ok=True)
for entry in (root / 'mantra').iterdir():
    target = pen / entry.name
    if not target.exists() and not target.is_symlink():
        target.symlink_to(entry)
source = (root / 'mantra/recall_tablecloth_query_delivery.rye').read_text()
anchor = '    if (c.bind(fd, @ptrCast(&bind_addr), @sizeOf(sockaddr_in)) < 0) return error.BindFailed;'
assert source.count(anchor) == 1
observed = source.replace(anchor, anchor + '''
    var local: sockaddr_in = undefined;
    var local_len: c.socklen_t = @sizeOf(sockaddr_in);
    if (c.getsockname(fd, @ptrCast(&local), &local_len) < 0) return error.NameFailed;
    print("ready_port={d}\\n", .{std.mem.bigToNative(u16, local.port)});''')
observed = observed[:observed.index('pub fn main(')] + '''pub fn main() !void {
    var bytes: [8]u8 = undefined;
    const n = recv_wire(0, &bytes) catch |err| {
        print("receive_error={s}\\n", .{@errorName(err)});
        return err;
    };
    print("received_bytes={d}\\n", .{n});
}
'''
needle = 'wire.len), 0, @ptrCast(&from)'
assert observed.count(needle) == 1
changed = observed.replace(needle, 'wire.len), c.MSG.DONTWAIT, @ptrCast(&from)')
assert changed != observed
for name, body in (('wait', observed), ('nonblocking', changed)):
    path = pen / (name + '_probe.rye')
    path.write_text(body)
    subprocess.run(['env', 'RYE_ZIG=vendor/zig-toolchain/zig', 'rye/bin/rye',
                    'build', str(path.relative_to(root)), '-lc',
                    '-femit-bin=' + str(pen / (name + '-probe'))],
                   check=True, timeout=120)
rows = []
for case in ('delivered', 'withheld', 'nonblocking'):
    name = 'nonblocking' if case == 'nonblocking' else 'wait'
    child = subprocess.Popen([str(pen / (name + '-probe'))], cwd=root,
                             stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                             bufsize=0)
    try:
        assert select.select([child.stderr], [], [], 10)[0], 'ready absent'
        ready = child.stderr.readline().strip()
        assert ready.startswith(b'ready_port='), ready
        port = int(ready.split(b'=')[1])
        started = time.monotonic()
        if case == 'delivered':
            with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sender:
                sender.sendto(b'x', ('127.0.0.1', port))
        try:
            _, err = child.communicate(timeout=0.25 if case == 'withheld' else 5)
            assert case != 'withheld', 'withheld receive returned'
            if case == 'delivered':
                assert child.returncode == 0 and b'received_bytes=1' in err, err
            else:
                assert child.returncode != 0 and b'receive_error=RecvFailed' in err, err
            rows.append(dict(case=case, exit=child.returncode,
                             result='one_byte' if case == 'delivered' else 'RecvFailed'))
        except subprocess.TimeoutExpired:
            assert case == 'withheld'
            elapsed = time.monotonic() - started
            assert Path('/proc', str(child.pid), 'cwd').resolve() == root
            child.terminate()
            child.communicate(timeout=5)
            rows.append(dict(case=case, result='harness_timeout',
                             requested_wait_ms=250,
                             observed_wait_ms=round(elapsed * 1000, 3),
                             signal='TERM', exit=child.returncode))
    finally:
        if child.poll() is None:
            assert Path('/proc', str(child.pid), 'cwd').resolve() == root
            child.terminate()
            child.communicate(timeout=5)
print(json.dumps(rows, indent=2))
(pen / 'result.json').write_text(json.dumps(rows, indent=2) + '\n')
```

## What this hands to Bakery

**Proposal.** Before comparing storage candidates, give the caller a maximum accepted wait,
a terminal outcome for exhaustion, and a limit on simultaneously retained requests. Keep those
obligations beside the count and byte limits. A deadline should release the request's resources
whether the cause was a lost packet, a host refusal, or a slow peer.

**Proposal.** Test success, empty success, local refusal, withheld response, and a late response
against that contract. Record which event ends each request and when its memory becomes reusable.
The [companion design](../active-designing/20260909-062114_a-request-ends-before-its-budget-is-reused.md) describes the ownership and trade-off.

**Horizon:** the next caller-contract trial, before the conditional storage build plan.
**Assumptions:** one receiver per request in this experiment, fresh sockets, loopback traffic,
and a parent allowed to stop only its own child. A service trial must declare its own concurrency.
**Falsifier:** a local timeout path in the named source, or an outer caller deadline already proven
to release this request, narrows the contract finding. A failed probe assertion overturns
its recorded case. If the existing service already bounds completion and retention, reuse is enough.
**Confidence:** high in the three observed outcomes; uncertain about a deployed caller.
Energy use, storage performance, cryptographic exchange, and durable recovery remain
outside this experiment's scope.
