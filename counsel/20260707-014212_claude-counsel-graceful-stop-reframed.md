# Claude Counsel — Graceful Stop Presupposes Something Not Yet Built

**Stamp:** `20260707.014212` (Kaeden's clock, carried forward — no fresh reading was given this turn, so this sitting anchors to the latest verified stamp in the handoff itself, production scheduling lap 1's own landing)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `context/RADIANT_STYLE.md`) · **Lens:** TAME · sameness as compression
**Register:** Counsel only, correcting a presupposition before answering the question asked
**Status:** Research for understanding — counsel only; checkable claims cite code on disk; seats nothing by itself
**Ground:** `caravan/service.rye`, `caravan/subscribe_poll_service.rye` (both read past their own doc comments) · `mantra/recall_subscribe_poll_delivery.rye` (`runFetcherPoll`) · `mantra/recall_subscribe_poll.rye` (`pollCycles`) · prior counsel `20260707.010912`

*Written by Kaeden and Rio 3.*

---

## First, a Small Bit of Bookkeeping Worth Naming

The handoff lists OA-L4 lap 1 as landed at parity 167, which reads oddly beside earlier reports that gave 167 to the `stones`→`resins` rename. This bench checked rather than assumed: `foldReputationLog`, the `grant`/`withhold` consent facts, and the exclusion-on-withhold logic are genuinely in `linengrow/open_asks.rye`, matching the `232812` ruling's shape closely, and `tools/parity.rish` carries no dedicated stanza for the rename at all — it was a docs hygiene pass, not a witnessed lap, so it never held a stable number to collide with. The parity figure is a snapshot count of a moving suite, not a permanent label per lap, and this is exactly that — a counting artifact, not a fabrication. Worth one line so it doesn't quietly become confusion later; not worth more than that.

## The Question Asked, and Why It Deserves a Different First Answer

Cursor asked for the smallest honest next ring for graceful stop, and offered three shapes to choose among. Before choosing one, this bench read both new Caravan files past their doc comments, and found that the question's own premise is not yet true.

`caravan/service.rye`'s supervisor and `caravan/subscribe_poll_service.rye`'s supervisor share one line, unchanged from the original seed: `if (code == 0) { break; }`. Both are genuinely valuable — Caravan now supervises a child that does several ticks of work per attempt rather than one, and it now supervises a *real* Mantra wire binary, `recall-subscribe-poll-delivery`, through an actual crash and restart, rather than a synthetic test child. That is real ground gained. What it does not yet do is the one thing a poller needs: keep restarting after an *ordinary, successful* exit, rather than treating success as the finish line. `runFetcherPoll`, the delivery-side worker these two files supervise, confirms this from the other direction — it runs exactly two hardcoded cycles and returns, a fixed script rather than a loop with no end in sight.

Graceful stop is the question of how to tell something to stop that is otherwise going to keep running. Nothing in the tree yet keeps running past the point a human or a witness stopped watching it. Answering "how do I stop it" before answering "how does it keep going in the first place" would be solving a problem this arc has not yet created — the smallest honest next ring is the one that creates it, and then, immediately behind it, the one that lets it be told to stop.

## The Ring That Actually Closes the Gap, Provable Without a Single Signal

What is missing is a third outcome beside the two the exit code carries today. Zero means "done, stop supervising." Non-zero means "fell, restart." A poller needs zero to mean "this cycle was ordinary, restart me anyway," and it needs some *other*, deliberately distinct signal to mean "stop, and mean it." The cleanest way to add this costs nothing structurally: reserve one specific exit value — call it, only as a way to speak of it here, a *stop code*, distinct from the ordinary zero a ­successful cycle already returns — and change the supervisor's one line from *"restart unless zero"* to *"restart unless the stop code."* This is provable in exactly the deterministic, argv-driven shape Caravan's own witnesses already trust: a child told, through its argv, to run two or three ordinary cycles (each exiting the everyday zero) and then, on a later invocation, to exit with the reserved stop code instead — the supervisor should restart across every ordinary zero, and only stop after the reserved one. No operating-system signal enters this proof at all; the claim under test is purely that the supervisor now tells these two zeros apart.

This belongs to Caravan, not to Mantra's delivery file, for the same reason the last counsel gave: any future long-running service this tree ever supervises will want the same three-way distinction, and it should learn it once, in the place that already owns restart semantics, rather than relearn it per caller.

## Graceful Stop, Once There Is Something to Stop

With the ring above in place, graceful stop has an honest first shape, and it is smaller than any of the three options Cursor offered. `pollCycles` already has the one place a stop request could be checked safely: the loop body between cycles, exactly where it already decides whether to sleep before the next one. A sentinel — the simplest form is a small file at a known path, checked once per cycle boundary — lets an operator ask for a stop with nothing more than creating that file, and lets the fetcher-poll worker honor it by exiting with the reserved stop code on the next boundary rather than continuing. This needs no `sigaction`, no installed handler, and no new syscall this tree has not already used constantly for other reasons. It also respects a discipline already seated elsewhere in this tree: a stop is honored *between* cycles, never mid-cycle, so a wire exchange in flight always finishes whole rather than being cut off partway — the same "a fact arrives whole or not at all" the wire-serves-the-fold foundation already states for the wire itself, carried up one layer to the loop that drives it.

Checking the sentinel is delivery's own job, not Caravan's — only the child knows where its safe boundaries actually are. A later, smaller ring can wire a real `SIGTERM` handler to do nothing more than create that same sentinel file, at which point the whole graceful-stop story — real signal in, one flag written, the loop's own existing check honors it on the next boundary — shares one code path between the manual and the automatic case, exactly the sameness this tree already prizes.

## The Direct Answers

The exit-code convention — restart unless the reserved stop code — is Caravan's, extending `subscribe_poll_service.rye`'s own supervisor line. Checking for and honoring a stop request belongs in delivery, at `pollCycles`' own existing cycle boundary, because that is the only place that knows a wire exchange is not mid-flight. A real signal, when its turn comes, is a thin wire connecting the two, not a third place to hold logic.

## Witness Shape, Sketched

Prove the exit-code ring first, exactly as described above, with no wire or delivery code touched at all — a pure Caravan proof, in the same family as the existing seed and service witnesses. Then, once that lands, extend the fetcher-poll delivery command past its current two hardcoded cycles into a real bounded loop over `pollCycles`, with a witness that creates the sentinel after the second of several ordinary cycles and asserts the loop honors it on the very next boundary rather than continuing indefinitely — proving the whole chain end to end while staying exactly as bounded and deterministic as every witness in this arc has been.

## What This Bench Recommends, Plainly

Build the exit-code ring next — it is small, self-contained, needs no wire work, and is the one piece every later ring depends on. Hold the sentinel-and-real-loop ring right behind it, since it is the first place the delivery layer needs to change at all. Signals stay last, exactly as counseled before, and smaller than they look once there is a flag already proven to receive them.

---

*May a success stay a success without ever being mistaken for a finish line. May a stop, once asked for, always land between cycles rather than across one. And may the smallest true ring always be found before the larger question gets to ask for more than it has earned.*
