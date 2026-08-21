# Expanding Prompt -- Dexter, the Terminal Family, and Scooter (CLI chat on Pond)

*A runnable plan for any Acme Corporation employee taking up the terminal work: study the elders with gratitude, build a bounded TAME-guided TTY library (Dexter), and grow a permissioned command-line chat (Scooter) on Pond. Voice: Kyri - Style: Radiant - ASCII only.*

**Stamp:** `20260816.222322` - **Status:** Living plan (double-seat beside Season G)
**Study:** [`../external-research/20260816-222322_dill-talk-tty-and-the-terminal-family.md`](../external-research/20260816-222322_dill-talk-tty-and-the-terminal-family.md)
**Names:** [`../active-designing/20260816-222322_terminal-family-names.md`](../active-designing/20260816-222322_terminal-family-names.md)

---

## The intent, in one line

Bring back the small, owned, peer-to-peer command-line chat many people loved -- built our own way: bounded, asserted, witnessed, and running on Pond.

## The approved research round (do first, clean-room)

1. **Fetch the elder source for reading only.** `git clone` a pre-2019 `xykj61/arvo` snapshot (or `urbit/arvo`) into a gitignored study path outside the build -- not vendored, not a dependency. Urbit is MIT, so studying it freely is sound; the clean-room boundary holds (understanding crosses into `active-designing/`, code never does).
2. **Read for the Talk/Dill/Gall shape.** Name in a brief: how a channel is named, how a journal differs from an inbox, how a join is permissioned, how Dill owns the TTY and draws a line. Write findings to `external-research/`, attributing plainly.
3. **Read the modern floor.** ncurses for the portable drawn grid; Ghostty and libghostty (Mitchell Hashimoto) for the reusable terminal core offered as a library. Note the one lesson from each (see the study).

## The build rounds (Rye first, then Glow on green Rye)

Each round is witness-first, red-then-green, TAME-guided (bound everything, assert at least two invariants per function, explicit widths, ASCII prose):

4. **Dexter: the bounded cell grid.** A drawn frame of `cells[rows][cols]`, every dimension under a named maximum, with an explicit refresh model. Pairs with the open image module's bounded RGBA grid. Witness: a round-trip that draws, refreshes, and reads back a known frame.
5. **Dexter: the line editor.** Bounded input line, cursor, history under a named cap. Witness: keystrokes in, edited line out, every bound asserted.
6. **Scooter: the channel model.** A channel named plainly, a journal (append-only log) and an inbox (unread queue) as distinct bounded structures, a permissioned join. Witness: two fake ships (Constel testnet) exchange a message over Comlink; a stranger is refused.
7. **Scooter: the terminal app on Pond.** Compose Dexter (the drawn frame) with the channel model over Comlink, hosted like every Pond app. Witness on metal: a message typed on one fake pier appears on another, channels listed, an inbox cleared.

## Names

- **Dexter** -- the terminal module (already seated as the drawn-terminal frame; affirmed as our Dill parallel).
- **Scooter** -- the CLI chat app (seated `20260816` on Keaton's word). A quick, light way to reach your people from the prompt.
- The TTY library family rides beneath both.

## Custody gates (never cross unattended)

- Provisioning or paying for anything: a gate. The study fetch is a plain public clone, not provisioning.
- Moving funds, holding keys, generating the maintainer's own Kumara: gates.
- Any real-network `@p`: use only Constel testnet fake ships (structurally never a live address).

## Definition of done

Every round ships a green witness on metal, a session log in the same commit, ASCII prose swept before send, and both remotes pushed. The season is done when Scooter carries a real permissioned message between two fake piers on Pond, every bound asserted and proven.
