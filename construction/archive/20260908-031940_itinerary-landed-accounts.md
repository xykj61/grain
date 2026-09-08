# ITINERARY -- landed accounts, shelved `20260908.031940`

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- a landed DIFFUSER account lifted off the live front, kept whole
**Room:** checkable -- every figure here was counted on the tree at its own stamp

The live front holds what is OPEN. This is the DIFFUSER paragraph it replaced, kept word for word.

---

**DIFFUSER -- THE ROADMAP IS BATTERY; THE CLOCK NOBODY CHOSE SAYS OTHERWISE.**
Elder [shelved](20260908-025249_itinerary-landed-accounts.md). `20260905-232224`'s FIRST
and last unrun read *name the deployment; a mains-only roadmap makes this enthusiasm*.
**IT FAILS.** Of 33 living/hand-seated marks in the registry, **13 name hardware, 7 battery-primary**
-- HAWM, ZETA, HUNK, DREY, TACT, LOCA, SETU. DREY needs no classification: *"held only while
powered, provably dissolved on power-down."* Against that, the pier's own two hosts (line 303) are
a Mac and a mains VPS -- targets ahead of the deployment.
**THE READING THE FALSIFIER DID NOT ASK FOR.** A wake bound is a policy about suspension, and this
tree already decided it **16 times in silence**. Every `std.Io.sleep` in authored Rye passes
`.awake` -- 16 sites, 7 files, no exceptions -- and `.awake` is a **Clock**, not a wakefulness
flag: Zig's `Io.zig:721-762` says it *excludes* suspended time (`CLOCK_MONOTONIC`), where `.boot`
includes it. **`Clock.boot` appears nowhere in authored Rye** (14 `.boot` hits, every one
`constel.boot`). `grep -rni "monotonic|suspend|clock_boottime"` over `caravan/**.rye` returns
**zero**: `note_rest_ms = 2` carries its why, the clock measuring it carries none. Two more sites
(`subscribe_poll_service.rye:105,247`) call `c.nanosleep` and choose nothing at all.
**Yours, BAKERY, and cheap:** one comment at `entrust.rye:145` naming `.awake` as CLOCK_MONOTONIC,
why a rest paces work rather than wall time, and `.boot` as the alternative left aside. [Paper](../../external-research/20260908-025249_the-clock-nobody-chose.md) **B+ 88**. The larger guard is named and NOT built -- 16 clean sites cannot prove a bite.
