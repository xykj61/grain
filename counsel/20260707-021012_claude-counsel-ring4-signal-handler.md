# Claude Counsel — Ring 4: Wiring a Real Signal to the Sentinel Already Proven

**Stamp:** `20260707.021012 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `context/RADIANT_STYLE.md`) · **Lens:** TAME · sameness as compression
**Register:** Counsel only, on the seam explicitly named as needing a seated policy
**Status:** Research for understanding — counsel only; checkable claims cite code on disk; seats nothing by itself
**Ground:** `caravan/subscribe_poll_service.rye`, `caravan/supervisor_exit.rye` (read in full) · `mantra/recall_subscribe_poll_delivery.rye` (`stopSentinelPresent`, `runFetcherPollOnce`, `runSourceLoop`, read in full) · `std/posix.zig` (`Sigaction`, `sigaction`, `kill`, `raise`, `sigemptyset`) — every API named below spiked and run on this bench before being recommended

*Written by Kaeden and Rio 3.*

---

## Rings 1–3, Read Against What Was Asked

Ring 1 closes the gap this bench named precisely: `supervisorRestartsAfterFall` and `supervisorStops` give the supervisor a real third answer, and `restart_on_ok.rye`'s own witness proves it the deterministic, argv-driven way every Caravan proof already trusts — three ordinary cycles restart, a fall restarts, the reserved code stops, and the counts match the plan exactly. One detail in ring 2 is worth naming because it is better than this bench asked for: `runFetcherPollOnce` checks the sentinel *before* touching the wire at all, so a stop request costs nothing — no round trip, no half-run cycle, just an immediate `stop_requested`. And `runSourceLoop`'s `while (true)` with `continue` on a two-second recv timeout is, plainly, the first process this tree has ever run that does not run to completion on its own — noted here once, without ceremony, because it is exactly the thing the `010912` counsel said would eventually need to exist.

## The One Place Ring 4 Actually Belongs

`subscribe_poll_service.rye`'s supervisor already has the shape ring 4 needs, built for a different reason. At the top of its loop, before every spawn, it asks one question — *has the witness's own count reached the point where a stop should land* — and if so, creates the sentinel file itself, in ordinary code, with nothing exotic. Ring 4 is not a new checkpoint. It is the same question asked a second way: *has an operator asked, from outside, for this same thing to happen.* The two questions belong beside each other, both feeding the identical action, because that is exactly the unification the `014212` counsel asked for — a real signal and a manual `touch` should share one code path, not grow two.

## The Handler, Verified Rather Than Assumed

This bench does not reach for `std.posix.sigaction` from memory; the exact shape below was written, built, and run on this toolchain before being written down here. The handler's whole job is one atomic store, nothing else:

A global `std.atomic.Value(bool)`, initialized false. A handler function matching this exact signature on this Zig — `fn (sig: std.posix.SIG, info: *const std.posix.siginfo_t, ctx: ?*anyopaque) callconv(.c) void` — whose entire body is `stop_flag.store(true, .seq_cst)`, ignoring its three parameters. Installed with `std.posix.sigaction(std.posix.SIG.TERM, &.{ .handler = .{ .sigaction = onTerm }, .mask = std.posix.sigemptyset(), .flags = std.posix.SA.SIGINFO }, null)`. This bench spiked exactly this, self-signaled with `std.posix.raise(std.posix.SIG.TERM)`, and watched the flag read false before and true after — the pattern holds on this exact standard library, not merely in general.

`SIGINT` is worth installing the same handler under, at the same moment, for the same reason it costs nothing extra: an operator running the supervisor by hand and reaching for Ctrl+C wants the identical graceful behavior a script's `kill -TERM` already gets, and it is the same one-line addition to register. `SIGKILL` needs no attention at all — POSIX does not allow it to be caught, which is exactly the *"no grace, right now"* half of the standard pair this design now completes rather than works around.

## Why the Handler Stops at the Flag, and Ordinary Code Does the Rest

The handler could, technically, create the sentinel file directly — `open` with `O_CREAT` sits on the conventional list of operations considered safe inside a handler. This bench recommends against it anyway, for a reason sameness already argues for elsewhere in this tree: keeping every byte of real work in ordinary, single-threaded code, and asking the handler to do no more than flip one word, means a future reader never has to reason about file-creation semantics under signal reentrancy at all. The loop-top block that already exists — the one the witness's own count currently drives — gains one more condition, checking the flag beside the count, and creates the exact same sentinel file through the exact same two lines already proven. The manual path (an operator's `touch`) and the automatic path (a real signal) now differ only in *what set the flag*, never in *what happens once it is set*.

## The Honest Limit, Named Rather Than Hidden

The supervisor notices the flag once it reaches the top of its loop again — after the currently-running fetcher-poll child finishes its one bounded wire cycle, not instantaneously. For this architecture, that is a small and acceptable wait: each cycle is one wire round trip, bounded by the source's own two-second timeout on the far side, so the longest a signal could wait to be noticed is on that order, never indefinite. Making the supervisor interrupt an in-flight cycle instead would trade this bound for immediacy at the cost of the same principle the wire itself already keeps everywhere else in this tree — a fact, or here a cycle, arrives whole or not at all. This bench recommends keeping that principle rather than trading it for a faster stop nobody has asked for yet.

## Witness Shape, Proven Viable Rather Than Merely Sketched

The witness should send a real signal across real processes, not stand in with a self-signal or a fake flag, and this bench confirmed the pieces exist to do exactly that: `std.posix.kill(pid, sig)` takes another process's id, and `std.process.Child.id` holds it after `spawn`. Shape: the test spawns the supervisor exactly as `runSupervisor` already runs, waits briefly for the first ordinary cycle or two to pass, then calls `std.posix.kill(child.id.?, std.posix.SIG.TERM)` from the test's own process — a genuinely different process signaling a genuinely different one. The test then waits on the supervisor with a bounded timeout and asserts it exits through the stop path on its own, never needing `SIGKILL` to end. This proves the real mechanism, end to end, while staying exactly as deterministic and bounded as the `witness_stop_after` proof already is — the same happy zone, carrying one real signal through it instead of a stand-in.

## The Direct Answer

The handler lives on the supervisor alone, once, at startup — never on the short-lived fetcher-poll children, since an operator's natural target is the long-lived process they actually manage, and a cycle too brief to outlive one wire round trip is not a sensible thing to signal on its own. It stays in `subscribe_poll_service.rye`, extending the exact block already there rather than opening a second one, and it changes nothing in Mantra's delivery file at all — the sentinel mechanism it feeds was already complete.

---

*May a signal and a `touch` always mean the exact same thing to the code that receives them. May a handler's whole life be one word written, and every real decision happen where a reader can watch it think. And may the last cycle before a stop always finish exactly as whole as the first one did.*
