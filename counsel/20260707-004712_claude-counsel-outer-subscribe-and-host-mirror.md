# Claude Counsel — the Outer Subscribe Loop, and Host Mirror as Its Consequence

**Stamp:** `20260707.004712 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `context/RADIANT_STYLE.md`) · **Lens:** TAME · Gall's Law
**Register:** Counsel only, in answer to the open seams Cursor's bench summary named
**Status:** Research for understanding — outer poll loop buildable with test-only cycle bound; host mirror is loop + named pair list; Caravan restart ≠ poller.
**Ground:** `caravan/seed.rye` · `mantra/recall_catch_up.rye` · `mantra/recall_lap1.rye` (`BoltCatalog`'s public surface, checked for enumeration) · prior counsel [`20260707-000112`](20260707-000112_claude-counsel-two-way-sync-and-subscribe.md) and [`20260707-001612`](20260707-001612_claude-counsel-subscribe-revisited.md)

*Written by Kaeden and Rio 3.*

---

## The Ladder Through 172, Read Once

Two-way sync and the catch-up inner ring landed exactly as counseled, in both directions, over both wire and in-process, editing nothing beneath them. The implementation note about the hosted demo hanging on `recv` and being fixed with a receive timeout is a small, concrete first taste of exactly the question this counsel takes up directly: a process that waits on the wire needs an honest answer for how long it waits and what it does when nothing arrives. That answer mattered even inside a bounded, one-shot demo. It matters a great deal more for a loop that means to keep waiting on purpose.

## What Caravan's Seed Actually Proves, Read Past Its Own Doc Comment

Caravan's seed restarts a child on non-zero exit, counts the restarts against a named bound, and stops the moment the child exits clean — the print line calls that outcome "supervision succeeded." This is a shape built to answer one question: *will this eventually work, and if not, how many times did we try?* A poller asks a different question entirely: *keep checking, forever, whether or not anything was found, and do not stop on success — success is the normal case, not the finish line.* Wrapping the outer subscribe loop in Caravan's seed as it stands today would mean forcing a "successful, nothing changed" cycle to report failure just to earn its own restart, which is not reuse — it is bending a working primitive to say something it was never built to say. This bench also checked for any existing signal-handling pattern to lean on for a graceful stop, and found none: two hits that looked promising on a first grep turned out to be a termination-cause label in one case and an unrelated internal enum in the other. Nothing in this tree yet knows how to be told to stop cleanly from outside itself. Both findings agree with what the last counsel already suspected, now confirmed rather than assumed.

## The Smallest Ring That Is Honestly Buildable Now

None of this blocks a first ring — it only says plainly what that first ring should not try to be. The loop itself — sleep a fixed, named interval, run catch-up-to-latest, repeat — needs neither Caravan nor a signal handler to be correct and provable. What makes it witnessable in the happy zone is the same trick the witness bolt convention already leans on everywhere else in this arc: a test-only bound. Let the loop accept how many cycles to run before returning, a parameter a production caller simply never sets and a witness always does. Three or four cycles are enough to prove real work: the source appends a new revision after the first cycle has already run, so the second cycle has something genuine to catch, and a later cycle with nothing new costs the one empty ask and nothing more, exactly as catch-up-to-latest already proves on its own. Recall stays identical on both catalogs once the loop has run its cycles, the same convergence proof this whole arc keeps returning to.

This ring earns its own small file in the same family — composing `recall_catch_up.rye`, editing nothing beneath it — and it proves the loop is correct on its own terms: it checks, it catches what changed, it costs little when nothing did, and it stops cleanly when its own bounded count says to. What it does not yet claim is production readiness for running unattended for real: no graceful stop from outside, no restart if it crashes mid-cycle, no adaptive interval. Those stay named and open rather than quietly assumed solved, and each is worth its own word once there is a real reason to run one unattended rather than a witness proving the shape is sound.

## Host Mirror, Read Against What Already Exists

Host mirror turns out not to need its own architecture at all. `BoltCatalog` has no way to enumerate which peers or bolts it holds — there is no "list everything you know about" surface anywhere in `recall_lap1.rye` — so a mirror cannot discover what to mirror; it can only be told. Given a short, named list of which peer-and-bolt pairs matter, mirroring is the outer subscribe loop's own cycle body calling catch-up-to-latest once per pair in that list rather than once for a single pair — a detail inside the loop, not a second loop and not a second seam. Everything this counsel already says about the outer loop's scheduling, its bounded test mode, and its still-open production questions carries over to host mirror unchanged, because host mirror is that loop wearing a small configuration rather than a different capability standing beside it. Ruling it separately from the outer loop would be asking the same open question twice under two names.

## What This Bench Recommends, Plainly

Build the bare outer loop now, in the happy zone, with its test-only cycle bound — the same shape that has proven every ring in this arc, applied to the one part of it that is genuinely new: a check repeated on a timer rather than run once. Treat host mirror as answered by the same word, needing only a small named list as its own configuration once the loop exists, rather than a separate ruling. Hold graceful shutdown, crash recovery, and any real supervision apart, honestly unsolved for now, and worth a proper sitting once Caravan grows a scheduling half to match the restart half it already has, or once something real needs to run this unattended rather than by a witness's own bounded hand.

MALA graduation stands exactly as ruled at `20260706.232812` — it fires at OA-L4's second-consumer moment, and nothing in this session touches that.

## Optional — a Small Spec Phrase, Not Applied

If the namespace brief gains a line for host mirror, it might read: *"Host mirror is the outer subscribe loop configured with a named list of peer-and-bolt pairs rather than one — the same loop, the same open questions, one small list beside it. It waits on the same word."* Proposed text only, for Cursor to apply on Kaeden's word.

---

*May a loop that checks forever cost little on the cycles that find nothing, and prove its whole shape honestly on the cycles a witness bounds. May no primitive be bent to say what it was never built to say. And may host mirror, when its day comes, need nothing more than a short list and a word already given.*
