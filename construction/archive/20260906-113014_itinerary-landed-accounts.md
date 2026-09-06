# ITINERARY landed accounts -- folded `20260906.113014`

**Language:** EN - **Style:** Gauge, Meter - **Voice:** Kyri
**Status:** Shelf -- folded off the live front, every word kept; the living card is [`../ITINERARY.md`](../ITINERARY.md)

*Folded off the live front on `20260906.113014` so the card could hold `%485`'s account under its own 40,960 ceiling without a raise. The words below are this lap's own; the row they summarise keeps its full three fields in [`../REDS.md`](../REDS.md), and the guard's whole reasoning stands in the `amphora_asker_reply` block of `construction/standing-equipment.kyri` -- a maintainer room the seed withholds, so it is named here rather than linked.*

---

## COPAL -- a value that names the machine, checked by a guard that only ever saw the two ends agreeing

**`%485` CLOSED.** `amphora/vessel_fetch_delivery.rye` held `fetcher_port: u16 = 38494` and
`source_port: u16 = 38495`. Every source sent its answer to the first; every asker bound that same
number. The pair therefore agreed with itself, and **nothing it did alone could tell *answers the
asker* from *answers 38494*.**

**The file states the rule twice and breaks it on the next line.** Eight lines above the constants
it reads *THE HOST NUMBERS THESE, NEVER THIS FILE* over `SOL_SOCKET`, and eight above that *THE
KERNEL LAYS THIS OUT, NEVER THIS FILE* over `sockaddr_in` -- both taken back from the source after
REDS `%282`. The port sat between them, unread. Meanwhile `recvfrom` filled `var from: sockaddr_in
= undefined;` with the asker's real address on every single request, and the frame ended without
anyone reading it.

**Two consequences, one measured and one structural.** The measured one is
`tools/fixtures/a/amphora_vessel_port_lock.sh`, a host-path lock around every step that speaks the
pair, because eight trees on this pier reach for one machine's ports. The structural one is that a
source could only ever answer an asker compiled to expect it.

**The first repair refused, and its refusal named the second fault.** Aiming the answer at the
asker made the demo fail at once with `Incomplete`: `send_wire` opened a **fresh socket per send**,
so a request's return address named an ephemeral port the asker was not listening on and closed a
moment later. The source answered honestly and answered nobody. **A datagram carries a return
address whether its sender meant it to or not, so which socket a request leaves by is part of the
message.**

**What is true now.** `recv_on` hands the caller the address it was already given; `send_resin_response`
answers it; `fetch_one` binds `ephemeral_port` -- zero, named as *the ask* rather than as a port --
and the kernel returns a free one atomically, which no probe-then-bind can do; `bound_port` reads it
back with `getsockname` and the asker prints it. `send_from` takes the caller's socket, so one
exchange speaks and listens through one fd. `fetcher_port`, `send_wire`, `send_to` and `recv_wire`
are **gone rather than left uncalled.** Measured: two askers in one demo print two distinct
kernel-chosen ports, neither of them 38494.

**The control, and the test that was tried and discarded.** Two askers at once against one source
was the obvious control and it discriminates nothing -- **both binaries passed it in half a second**,
because two short exchanges stagger by milliseconds and never overlap. **A test both bytes pass
proves only that the test ran.** It stands as a claim on the repaired bytes, where it can still red,
and never as the control. What separates the two behaviors is crossing one repaired end with one
elder end, and nothing in this tree had ever done that. `amphora_asker_reply` plants both elder
faults into a pen copy **by transform rather than by git ref**, so the control survives a history
rewrite: PORT (the written reply number on both ends) and SPLIT (the two-socket asker). Five legs,
each refusal bitten from the failing side and each planted pair answered so the pen is proven
innocent.

**The leg that corrected the round is a welcome.** The first draft expected a repaired source to
refuse a PORT-planted asker and measured the opposite: a fixed-port asker that still speaks and
listens through one socket is answerable, so **the repair is a superset of the elder rather than
merely different from it.**

**`tier cadence`, 68s**, because two crossed legs each spend the module's own three-attempts-of-ten-seconds
bound, and nothing takes exactly as long to prove as a bound says it does. The three lap-tier amphora
rows already build and run this module every lap; this one asks the question they cannot.

**What it does not reach.** The lock stands. `source_port` is still one number the machine owns and
eight trees reach for, so **halving a shared resource is not removing it.** The source's own port
discovery wants a rendezvous the fixtures do not have yet, and is the booked lap after this one.
