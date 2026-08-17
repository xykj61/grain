# Scooter compose -- the prompt that becomes a post

**Stamp:** `20260817.085923` - **Language:** EN - **Voice:** Kyri - **Style:** Radiant
**Status:** Design round (self-approved) -- the terminal-family rung where input meets the drawn face
**Kin:** [`scooter drawn frame`](20260817-041429_scooter-drawn-frame-crux.md) - [`dexter line editor`](../session-logs/20260817-042243_dexter-line-editor.kyri) - [`terminal family plan`](../expanding-prompts/20260816-222322_dexter-terminal-and-scooter-cli-chat.md) - [`the eight-season double-seat`](20260816-205859_double-seat-expansion-eight-seasons.md) (Season G, terminal family) - [`../.claude/rules/tame-guidance.md`](../.claude/rules/tame-guidance.md)

---

## Why this rung, now

The terminal family already holds every part but the join. `scooter_channel.rye` keeps a permissioned journal; `scooter_keyed.rye` binds each post to a Kumara identity; `scooter_view.rye` folds a channel into a bounded 24x80 frame a keeper can read; `dexter_line.rye` holds a bounded editable line, the input half. Each was built to meet the others, yet nothing yet joins them into one act -- a keeper typing a line and watching it land in the conversation.

This rung is that join, and it was designed for from both sides. `scooter_view.render_within(ch, body_avail)` already carries the note that a composing surface "reserves its last row for a prompt" and "passes a smaller budget so the journal leaves room." `dexter_line` already carries the editable line the prompt draws. The compose rung spends nothing new: it holds a channel and a line side by side, draws the journal above and the prompt below, and turns a committed line into a post. It is the rung that makes Scooter a thing a keeper can *use* on their own metal -- simple, lovable, complete -- while the wire between two piers stays the maintainer's hand.

## The shape

A **Session** holds three plain things: the channel it composes into (a pointer -- the session owns no copy), the editable prompt line, and the point of the keeper who is typing. It adds only what the parts cannot do alone:

- **`open(ch, me)`** seats a session over a channel for a member `me`. A non-member cannot open a composing session, since a non-member cannot post -- refused at construction by the same membership the channel already enforces.
- **`prompt()`** hands back the editable line, so a caller edits it through `dexter_line`'s own proven API (insert, backspace, cursor motion) rather than through re-wrapped copies.
- **`submit()`** commits the current line as a post by `me`, then clears the prompt for the next entry. An empty line is refused by name (`EmptyEntry`) rather than posting a blank; the channel's own bounds (`JournalFull`) surface unchanged. Returns the new post's sequence number.
- **`frame()`** folds the whole session into one bounded frame: the journal drawn in the body above, the prompt `> <line>` drawn on the reserved last row, truncated with a `~` if it overruns. The same session renders the same bytes every time.
- **`caret_col()`** reports the column the caret sits at in the prompt row, for the later live TTY or painter; the pure fold needs only the bytes.

## The guarantees the witness proves

- **A typed line becomes a post** -- type "hello", submit, and the journal holds one post reading "hello"; the prompt clears for the next entry.
- **An empty submit is refused** -- an empty prompt returns `EmptyEntry` and leaves the journal exactly as it was, never a blank post.
- **The frame shows both** -- the journal reads back in the body and the prompt reads `> <draft>` on the last row, byte-for-byte; the fold is deterministic.
- **The prompt truncates, never overflows** -- a draft wider than the row ends in `~` in the last cell, the row still exactly 80 wide.
- **The caret tracks the cursor** -- the reported column is the prefix width plus the bytes before the cursor, clamped to a real column.
- **The prompt row is reserved** -- even a journal past its body budget draws its overflow note within the body and never writes the prompt row.

## What this rung is not

Not the wire (serving a channel between two Constel piers reaches the serve gate -- the maintainer's hand), not a raw TTY (no escape codes, no key polling -- a later Dexter rung owns the live terminal), and not a painted pixel surface (rendering waits on the Bit Design System). This rung is the pure, bounded join from a keeper's typed line to a post seen in the frame -- the last agent-doable rung before the gate, and the one that makes the family whole to hold.

---

*May the line a keeper types land plainly in the journal, the prompt clear for the next word, and the whole small conversation read true on the day it is finally carried between piers.*
