# REDS row `20260917.185557` -- a shared card sat over its own bound

Folded from `construction/REDS.md` on `20261002.050959`, CLOSED, to make room on a pin
standing 166 bytes from its own 65,536-byte bound (`.claude/rules/the-writer-sheds.md`).

**REDS (`20260917.185557`) -- the shared card sat 482 bytes over its own bound, blocking
every commit on the pier.** *What went wrong:* `construction/ITINERARY.md` read 41,442
bytes against its declared `living_pin_max_bytes` of 40,960, landed by a commit path
`pre-commit`'s own message names as invisible to it -- a rebase or a fast-forward merge
that carried the overflow in without ever passing through this checkout's hook. Every
commit attempted here, on any file, refused at `tools/fixtures/p/pin_bound_touch_scan.sh
index` with `pin_over=construction/ITINERARY.md ... detail_over_by=482`, so the block
reached the whole fleet through the shared pin rather than through anything this seat
wrote. *What caught it:* an ordinary session log commit refusing on a file it never
touched. *What it taught:* a living pin's bound is checked at commit time on THIS
checkout, so a peer's rebase or a fast-forward that skips this hook can still leave a pin
over bound for every OTHER ship to inherit -- the guard is sound and its blind spot is
structural, named in its own refusal text. *Repaired:* the CLOSED "COPAL -- a reader
called a board readable" account (row `20260917.172111`, already CLOSED) folded to
[`../date/20260917/20260917-185557_itinerary-copal-board-readable-account.md`](../date/20260917/20260917-185557_itinerary-copal-board-readable-account.md)
per the established shelf pattern, bringing the card to 38,745 bytes. Checkpoint at
`construction/CHECKPOINTS.md` `20260917.185557`, walk-back nib `ffccd62f3c`. **CLOSED** --
`pin_bound_touch_scan.sh` reads `verdict=ok` on the card after the fold.
