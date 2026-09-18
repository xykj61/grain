# A Request Ends Before Its Budget Is Reused

**Stamp:** 20260909.062114
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Proposed, mixed -- the linked receive experiment is checkable; this contract is design.
**Evidence:** [A reply budget needs a wait budget](../external-research/20260909-062114_a-reply-budget-needs-a-wait-budget.md), measured on 2026-09-09.
**Grant:** [The table-store grant](../active-development/20260907-074815_two-grants-a-molt-lane-and-a-table-store.md).

When may another request use the memory this one holds? Successful search is only one possible
ending. A complete answer, a refusal, and a spent wait budget must each reach an ending the caller
can recognize. That rule lets a service account for work that is still waiting as carefully as
work that is running.

**Observation.** The linked experiment exercises one receive function in a copied hosted caller.
A delivered byte completes it; withheld delivery outlasts the harness's observation limit; a
nonblocking control refuses. The source checks query and encoding errors before sending. The
experiment establishes neither a deployed service deadline nor an energy result.

**Inference.** Search work, reply size, and retained lifetime are separate resources. An index
can improve the first while leaving the others unchanged. The [earlier caller design](20260909-044642_a-query-budget-reaches-its-caller.md)
already separates search from output; this companion gives a waiting request an explicit end.

## One owner for completion

**Proposed.** A request enters only when its owner reserves its full live-state allowance. It
carries an identity, an absolute deadline read from a monotonic clock, and a terminal outcome.
The terminal outcomes distinguish a complete answer, an explicit refusal, and deadline exhaustion.
An empty complete answer means that the query succeeded with no matches.

The owner accepts at most one terminal outcome. A successful answer transfers into bounded
caller-owned storage before the request reservation is released. Borrowed scratch views then
expire. The owner releases the reservation after any dependent work has relinquished it. A late or duplicate
answer belongs to the old identity and cannot complete a newer request using the same slot.
A deadline that merely changes a status field while a worker keeps the memory has not released it.

The wait covers the declared stages together: admission, search, encoding, delivery, and cleanup.
Giving every retry a fresh full allowance would extend the original promise. If retries are
required, they share the original deadline and a separately bounded attempt count. Retry traffic
also needs its own rate policy; this design supplies no automatic retry loop.

## Put the cost where it can be counted

**Proposed.** Let `A` be the maximum admitted requests, in requests, and `B` the reserved private
state per request, in bytes per request. Let `S` be shared live state, in bytes. Under those
assumptions, the reservation ceiling is `A * B + S` bytes. These symbols are a design model dated
2026-09-09, not measured values. The reservation must cover worker stacks, queued replies, and
cancellation state wherever this service owns them; otherwise the formula omits part of the bill.
Checked arithmetic must establish that the combined reservation fits before admission.

Tally is the proposed accounting boundary. Caravan is the proposed admission and cleanup owner.
The query path supplies its existing count and byte refusals. Bakery owns any implementation;
Patchouli reviews the accounting seam. Diffuser carries the experiment and its limits. These are
proposed responsibilities, rather than a claim that this composition already runs.

A blocking receiver is a reasonable simple baseline when its owner can cancel and reclaim it.
A readiness-driven receiver may serve several requests with fewer waiting workers, at the cost
of explicit state and cancellation ordering. Measure both against the same completion contract
before choosing. A receive flag by itself settles neither ownership nor cleanup.

## The trial that decides

**Proposed.** Begin with the existing scan. Declare the accepted concurrency, retained bytes,
whole-request deadline, and cleanup allowance before running it. For each admitted request,
record the terminal event and released reservation. Withhold a response, deliver one after the
deadline, and reuse the slot for a different request. The old reply must leave that new request
unchanged. Include local overflow and a successful empty result, so refusal and absence stay distinct.

**Horizon:** the next bounded caller trial, before selecting a new store.
**Assumptions:** a monotonic clock, unique request identities over the retained replay window,
and a supervisor able to stop or isolate work that outlives its budget.
**Falsifier:** if the existing supervised path already proves these obligations, adopt that path
and add no new mechanism. If a proposed deadline ends the reply wait while retaining its worker
or memory past the cleanup allowance, the proposal fails its own resource contract.
**Confidence:** high that the obligations are distinct; uncertain which implementation meets a
real caller's needs. Lower retained byte-time could reduce pressure on the service, but an energy
claim requires an energy instrument and a separately declared workload.

The storage plan remains conditional. This trial can justify a completion mechanism while leaving
the current store in place, which is a complete and useful outcome for the grant.
