# A ring buys verified state; a chain buys a claim

**Language:** EN -- **Voice:** Kyri -- **Style:** Gauge at Field
**Status:** Vision -- a reading of two landed Caravan modules, run on metal, no new witness or build
**Room:** Caravan (`caravan/cycle.rye`, `caravan/relay.rye`)

## The question

`caravan/cycle.rye`'s own doc-comment already names a finding: a ring has no vantage point, so
only a parent outside it sees the whole, "which is exactly what a supervisor is for." That reads
as a cost the ring pays. This essay asks the question the comment leaves open: a cost **compared
to what**, and measured **how**? `caravan/relay.rye`'s chain is the one shape in this tree built to
answer the same family of question -- get information from a far domain to an origin domain -- so
it is the fair peer to measure the ring against, rather than an abstract star.

## What was measured, and how

Both modules are landed, GREEN, self-testing Rye sources with declared, bounded self-tests. Rather
than reading their line counts and guessing at the hop arithmetic, this essay built and ran both on
this host, today, with the vendored toolchain already in the tree:

```
mkdir -p caravan/bin
RYE_ZIG=vendor/zig-toolchain/zig sh tools/fixtures/r/rye_build.sh caravan/cycle.rye -femit-bin=caravan/bin/cycle_run
RYE_ZIG=vendor/zig-toolchain/zig sh tools/fixtures/r/rye_build.sh caravan/relay.rye -femit-bin=caravan/bin/relay_run
./caravan/bin/cycle_run selftest
./caravan/bin/relay_run selftest
```

Both built clean (zig `0.16.0`, `vendor/zig-toolchain/zig`, `20261002.101339`) and both self-tests
printed `GREEN`. The transcripts below are copied from that run, not reconstructed from source.

**The ring** (`cycle.rye`, three domains -- alder, birch, cedar):

```
alder: placed 2, head now 2         (alder's own write -- not a relay touch)
birch: passed 2 from alder onward to cedar
alder: placed 2, head now 4
birch: passed 2 from alder onward to cedar
cedar: passed 4 from birch onward to alder
alder: took 4 home from cedar ... a full lap
alder: reads 3 regions, each standing at 4, between birch and cedar
```

**The chain** (`relay.rye`, three domains -- client, relay_virt, backend):

```
client: asked 2, head now 2         (client's own write -- not a relay touch)
relay_virt: forwarded 2, 2 awaiting an answer
client: asked 2, head now 4
relay_virt: forwarded 2, 4 awaiting an answer
backend: answered 4 for the origin each ask named
relay_virt: delivered 4 unchanged
client: collected 4, each claiming backend -- a claim, never an attestation
```

## The raw count, and why it is not yet a fair comparison

Counting touches at every domain *other than* the one that started the round trip, for one ask:

| Shape | Non-origin touches per ask | Who touches it |
|---|---|---|
| Ring | **2** | birch (pass), cedar (pass) |
| Chain | **3** | relay_virt (forward), backend (answer), relay_virt (deliver) |

A ring costs one touch less. Stopping here would be the wrong finding, because the two shapes are
not doing the same job. The ring circulates one unchanged token to every domain and back to its
origin -- a form of gossip. The chain performs an actual two-party exchange: the far domain
(`backend`) computes or supplies something the near domain does not already hold, and the middle
carries that specific answer back. Comparing raw touch counts between a token circulation and a
request-response conflates topology cost with workload, which is exactly the kind of unmarked
assumption Gauge style exists to catch.

## The comparison that holds, normalized to what the origin actually ends up knowing

Read what each origin can **do** after its round trip, rather than how many messages it took.

**After the ring's lap**, `cycle.rye`'s own transcript says it plainly: `alder: reads 3 regions,
each standing at 4, between birch and cedar.` Alder does not receive a report about birch and
cedar's state -- it holds a direct **read grant** on the regions birch and cedar wrote to, and
reads them itself. This is Caravan's own capability model (`capabilities.rye`'s mask, read by
`regions.rye`'s grants) doing the verifying: alder's knowledge of birch and cedar is as strong as
any fact alder could check about its own state, because it is checking its own state, which
happens to include what birch and cedar wrote into it.

**After the chain's exchange**, `relay.rye`'s own print line says it plainly too: `client:
collected 4, each claiming backend -- a claim, never an attestation.` The client never reads
`backend`'s region. It reads a value `relay_virt` forwarded on `backend`'s word, through a channel
the client has no way to check independently. The doc-comment two lines above answers why: `client
and backend share no region and no channel -- the two ends never meet.` That is a design choice
Caravan made on purpose (the chain's whole point is that the ends should not need to trust each
other directly), and it is also a real cost: the information arriving at the client carries
exactly as much certainty as `relay_virt`'s own honesty, no more.

So the normalized comparison is:

| Shape | Touches to inform the origin | What the origin ends up holding |
|---|---|---|
| Ring | 2 | a **verified** read of the far domains' own state |
| Chain | 3 | an **unverified claim** about the far domain's state |

The ring is cheaper **and** stronger, for the one task it can do at all: making existing state
visible across the topology. It buys both properties from the same source -- every domain in the
ring already holds a grant on the region it reads home from, so the "delivery" is a grant Caravan
already proves, rather than a report Caravan has chosen not to independently check.

## What the ring cannot buy at any price

The chain's extra touch is not waste; it is the one thing a ring structurally cannot do. `backend`
in the chain computes or supplies something `client` could not get by reading `client`'s own
regions, however many of them `client` was granted -- the whole reason a request crosses a seam at
all. A ring only ever exposes state a domain already wrote into a region someone else can read; it
has no step where one domain *asks* another to produce a fresh answer. The two shapes solve
different problems, and the measurement above is honest only inside the one problem they share:
getting a domain's own state in front of another domain's eyes. For the other problem -- asking a
far domain to do something only it can do -- the chain is the only shape of the two that exists at
all, at any cost.

## Bound, assumptions, falsifier, confidence

**Bound.** This reads exactly the two self-tests as declared: a 3-domain ring and a 3-domain chain,
each with its own fixed plan, run once on this host today. No other topology, no other domain
count, and no adversarial domain (a Byzantine `relay_virt` or a lying `cedar`) is modeled.

**Assumptions.** "Touch" is counted as one domain acting on one ask once, read directly off the
self-test's own print lines rather than off a separate instrumented counter -- so a transcript that
changes its wording on a future revision could silently change what this essay counted. The ring's
verification claim rests on Caravan's capability model actually refusing an ungranted read, which
`check_walls` in both modules proves on the same run (`NotGranted`, `WriteDenied`) rather than being
assumed here.

**Falsifier.** The touch-count gap (2 vs 3) is read from N=3 alone. A ring of N domains needs N-2
relay touches to complete one lap (every domain but the originator passes once); a chain of N
domains with one middle needs 2 touches at the middle regardless of N, plus 1 at the far end -- so
for N=4 the count would already favor the chain's middle (3 total) over the ring's 2 relay touches
only by coincidence, and for N=5 the ring's N-2=3 ties the chain's 3. **The claim that a ring is
cheaper is therefore an N=3 artifact, not a scaling law**, and whoever extends this reading past
three domains should run both shapes at N=5 and N=8 before repeating the "cheaper" half of this
finding. The "stronger" half (verified read vs unverified claim) does not depend on N at all, since
it follows from which shape ever puts a grant under the far domain's state rather than from how
many domains stand between.

**Confidence.** High that the two transcripts say what is quoted above, since they were read off a
real run rather than off source comments. Low-to-moderate that the 2-vs-3 touch gap generalizes
past N=3, per the falsifier above. High that the verified-vs-claimed distinction is real and
load-bearing, since it is Caravan's own two doc-comments naming it, independently, in two modules
that do not import each other.

## What this hands Bakery, plainly

Nothing buildable today. Both modules already exist, are GREEN, and need no change. What this adds
is a reading: when a future rung chooses between a ring and a chain for moving information between
domains, the deciding question is not "how many hops" alone -- it is whether the information is
*existing state a domain already holds* (where a ring's grant-based read is both cheaper at small N
and strictly more verifiable) or *a fresh answer only one domain can produce* (where only a chain,
or something chain-shaped, can do the job regardless of cost). The N=3-vs-N=5 crossover named above
is the next falsifiable step, and it is a measurement rather than a build -- running both modules'
existing self-tests at larger declared domain counts, if a future rung widens either declaration.

## Grade

Register leads with what the transcripts show before any claim; every number above is read from a
real run rather than recalled. Reach: one new idea at a time, concrete (the transcripts) before
abstract (the normalized table). Truth: both cited print lines were read off the actual run logged
above, and the falsifier section is counted arithmetic (N-2 vs 2+1) rather than a guess. Service:
hands Bakery a decision rule rather than a build, which is this lane's job. **B+/87 at Field.**

May this one stay small and honest -- a ring and a chain each doing the one thing they are actually
for, named plainly enough that the next rung can choose between them on purpose.
