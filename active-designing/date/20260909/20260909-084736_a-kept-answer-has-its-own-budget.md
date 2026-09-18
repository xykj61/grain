# A Kept Answer Has a Budget After the Request Ends

**Stamp:** 20260909.084736
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Proposed, mixed -- the finite model is checkable; the service contract is design.
**Scope:** Reservation accounting for retained query answers, modeled on 2026-09-09.

Where do the bytes go when a request finishes? A caller may keep its answer while the service
starts another request. Each request can fit its own limit while the kept answers fill memory.
The admission rule therefore needs to count both lifetimes.

**Observation.** The [retention experiment](../external-research/20260909-072836_a-retained-reply-needs-its-own-bytes.md)
shows an encoded copy keeping an answer through scratch reuse. That experiment reserves a
340-byte answer array and copies a 14-byte initialized prefix, measured on 2026-09-09 at its
named source revision. It measures one local answer, with all storage alive.

**Inference.** Useful payload length and reserved capacity answer different questions. The
small prefix leaves the full array reserved. Releasing the completed request also leaves the
caller's retained array alive. The [completion contract](20260909-062114_a-request-ends-before-its-budget-is-reused.md)
already requires owned storage; this design makes its aggregate reservation explicit.

## Reserve the destination before work starts

**Proposed.** For the first trial, declare a maximum of `A` active requests and `H` answer slots.
Each active request reserves one answer slot before it starts. A success transfers that slot
to the caller. A refusal releases it after cleanup. The caller releases a successful answer's
slot only after all its readers finish. Admission requires both a free request slot and a free
answer slot.

This policy chooses predictable completion over maximum utilization. A request that will fail
still occupies answer capacity while running. It buys a simple promise: a successful request
already has a place to put its answer. A full answer pool causes a named admission refusal.
Any waiting queue would need its own bounds and is outside this first trial.

Let `a` count active requests and `r` count retained answers. With one exclusive slot owner,
serial transitions, and cleanup complete before a transition releases storage, keep:

```text
0 <= a <= A
0 <= r
a + r <= H
```

| Event | Required before it acts | Count after it acts |
|---|---|---|
| Admit | a < A and a + r < H | a + 1, r |
| Complete successfully | a > 0; answer copy complete | a - 1, r + 1 |
| Finish refusal | a > 0; workers relinquished storage | a - 1, r |
| Caller releases answer | r > 0; all readers finished | a, r - 1 |

The real owner must identify the exact request or answer. Counts alone cannot detect a duplicate
release against the wrong slot. Keep slot identity and generation until every borrower has
finished; the count model below deliberately leaves that implementation obligation open.

## State the byte ceiling separately

**Proposed model, dated 2026-09-09.** Let `B` be private scratch bytes per active request,
excluding answer storage. Let `C` be reserved bytes per answer slot, including its metadata.
Let `S` be shared bytes, including pool bookkeeping. A fixed backing allocation reserves
`A * B + H * C + S` bytes even when the pools are empty. An occupied-reservation reading is
`a * B + (a + r) * C + S` bytes under this partition. Neither expression measures resident
physical memory or energy.

The copy happens while source scratch and destination answer storage coexist. Both charges
must hold during that overlap. Worker stacks and cleanup state belong in `B` or `S` exactly
once; storage owned by a caller outside this pool needs a separately bounded owner. Checked
arithmetic must prove the full reservation fits before the service starts.

A source-defined frame capacity alone supplies neither `C` nor a service memory budget. The
trial still needs the response metadata size, request state size, pool sizes, and caller demand.
Keep those values explicit before comparing a scan with an index.

## A finite model, with its failing alternative

**Observation.** On 2026-09-09, the Python model below explored all reachable count states for
an illustrative limit of **2 active requests** and **3 answer slots**. These are chosen test
inputs, not proposed production settings. It visited **9 states**, accepted **21 event edges**,
and refused **15 event edges**. An edge is one event tried from one reachable state.

The control admits on the active-request count alone. After **4 sequential completions** and
zero caller releases, it holds **4 answers** against the illustrative **3-slot limit**. At
most one request was active at any time. The control demonstrates the omitted reservation
within this model, rather than a defect observed in a deployed service.

Save the following block as `session-output/retained-budget-model.py` and run
`python3 session-output/retained-budget-model.py` from the repository root. The state space is
finite under the declared limits; every accepted transition checks both bounds.

```python
from collections import deque

ACTIVE_MAX = 2
ANSWER_MAX = 3
start = (0, 0)
seen = {start}
queue = deque([start])
edges = refused = 0
while queue:
    active, retained = queue.popleft()
    choices = {
        'admit': (active + 1, retained),
        'complete': (active - 1, retained + 1),
        'fail': (active - 1, retained),
        'release': (active, retained - 1),
    }
    for event, target in choices.items():
        allowed = {
            'admit': active < ACTIVE_MAX and active + retained < ANSWER_MAX,
            'complete': active > 0,
            'fail': active > 0,
            'release': retained > 0,
        }[event]
        if not allowed:
            refused += 1
            continue
        a, r = target
        assert 0 <= a <= ACTIVE_MAX
        assert 0 <= r and a + r <= ANSWER_MAX
        edges += 1
        if target not in seen:
            seen.add(target)
            queue.append(target)
assert (0, ANSWER_MAX) in seen
assert (ACTIVE_MAX, ANSWER_MAX - ACTIVE_MAX) in seen
assert len(seen) == 9
assert edges == 21
assert refused == 15
# Control: admission checks only active slots after each prior completion.
active = retained = 0
for _ in range(ANSWER_MAX + 1):
    assert active < ACTIVE_MAX
    active += 1
    active -= 1
    retained += 1
assert retained > ANSWER_MAX
print(f'states={len(seen)} accepted_edges={edges} refused_edges={refused}')
print(f'active_only_control_retained={retained} answer_limit={ANSWER_MAX}')
```

**Inference.** An active-request ceiling can bound concurrent work while retained output keeps
growing across completions. Reserving the answer slot at admission closes that count-level gap.
The model proves count conservation under its stated transitions. Byte ownership, concurrent publication, cancellation, and a real allocator's
accounting each need a separate implementation witness.

## The next trial for Bakery and Patchouli

**Proposed.** Bakery owns the caller trial; Patchouli reviews the Tally accounting seam. Keep
the existing Tablecloth scan. Fill the answer pool with successful retained replies, finishing
each request before starting the next. Admission must then refuse despite idle request slots.
Release one answer and admit one request. Preserve the other answers while its scratch is reused.

Read each ownership transfer, occupied capacity, and fixed backing capacity separately. Check
copy failure, cancellation during copy, duplicate release, stale generation, and cleanup that
outlives a deadline. A refused transfer must preserve a complete prior answer or expose no new
answer, with every slot still charged to its owner. Caravan's proposed admission owner and
Tally's proposed accounting boundary must agree on that point.

**Horizon:** the next caller workload trial, before a storage build is scheduled.
**Assumptions:** bounded exclusive slots, declared byte partitions, serialized transitions,
explicit borrower release, and a cleanup owner able to establish that storage is free.
**Falsifier:** reject this policy if any admitted success needs an unreserved destination, if
reuse changes a retained answer, or if a release returns capacity while a reader still holds it.
If an existing caller already proves the whole contract, reuse it. If pre-reservation prevents
the agreed workload from fitting, compare a separately bounded completion queue under the same
byte and deadline limits.
**Confidence:** high in the finite count result; the service fit remains unknown until that trial.
Elapsed time, throughput, and energy savings remain unmeasured. The existing store stays the
baseline while its caller's ownership and workload contracts are settled.
