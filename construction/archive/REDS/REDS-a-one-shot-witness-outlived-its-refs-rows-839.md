# REDS row %839 -- a one-shot witness outlived its refs

*Folded off the living pin [`../../REDS.md`](../../REDS.md) on `20261010.135323`, **CLOSED** -- the pin stood 90 bytes over its 65,536-byte bound after the repair.*

**REDS %839 (`20261010.120453`) -- a one-shot pin-tidy witness reds on a missing counter and backup ref.** *Went wrong:* both are gone; it reds early. *Caught by:* copal's roster pass. *Taught:* a one-shot witness goes stale when its ref moves. **CLOSED** (`20261010.135323`) -- the witness runs GREEN on metal; its header names the two retired asserts.
