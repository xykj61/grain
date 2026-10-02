# REDS -- the shared card overran its own bound

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- one folded row, immutable once written
**Room:** checkable -- a landed commit path left the card over its own declared byte bound
**Folded:** `20261002.005300` from [`../REDS.md`](../../REDS.md)

One row, folded to hold the pin under its bound. It is the oldest CLOSED row still standing on
the pin at fold time, carried off whole so a fresh row could land.

**REDS (`20260917.185557`) -- the shared card sat 482 bytes over its own bound, blocking every commit on the pier.** *What went wrong:* `construction/ITINERARY.md` read 41,442 bytes against its declared `living_pin_max_bytes` of 40,960, landed by a commit path `pre-commit`'s own message names as invisible to it -- a rebase or a fast-forward merge that carried the overflow in without ever passing the hook that gates a plain commit. *What caught it:* the next ordinary commit on the card, refused outright by the pin-bound hook reading the file as it stood. *What it taught:* a bound enforced only at the moment of a direct edit has a blind side at every merge and rebase, which is exactly the path eight ships pushing to one remote take most often. *Repaired:* the card's own account was folded and condensed in the same lap that found the overflow, bringing the page back under its declared ceiling; the hook read clean on the next commit. **CLOSED**.
