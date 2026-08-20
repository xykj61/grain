# Scooter on Dexter -- the drawn frame

**Stamp:** `20260817.041429` - **Language:** EN - **Voice:** Kyri - **Style:** Radiant
**Status:** Mixed -- Design round (self-approved) -- the terminal-family rung the signed-post rung named "later"
**Kin:** [`scooter signed post`](20260817-035757_scooter-signed-post-crux.md) - [`scooter channel model`](20260817-035009_scooter-channel-model-crux.md) - [`terminal family names`](20260816-222322_terminal-family-names.md) - [`the eight-season double-seat`](20260816-205859_double-seat-expansion-eight-seasons.md) (Season G, terminal family) - [`../.claude/rules/tame-guidance.md`](../.claude/rules/tame-guidance.md)

---

## Why this rung, now

Scooter's channel model (rung one) and its Kumara-signed post (rung two) both stand GREEN. Each named the same next step and left it: *the Dexter drawn frame.* A channel that holds a conversation deserves a face a keeper can read, and Dexter -- the bounded terminal, our Dill parallel -- is where a command-line chat draws. This rung gives Scooter that face without reaching the wire: it renders a channel's journal to a terminal frame purely, so a keeper sees the conversation as a grid of characters, deterministic and bounded, no network opened and no key held.

It is the honest next crux of the terminal family: additive (it imports rung one's `Channel` and calls only its public API), Rye-first (the frame is arithmetic over a character grid, no rendering system, so it does not wait on the paused Brushstroke), and finishable green in one lap. The Comlink transport between two Constel piers -- the rung that reaches the serve gate -- stays the maintainer's hand; drawing the frame does not.

## The shape

A **terminal frame** is a fixed grid of character cells -- 24 rows of 80 columns, the classic terminal. `render(channel)` folds a channel into one `Frame`:

- **Row 0 is the header** -- `scooter: <N> posts`, padded to the full width.
- **The body rows carry the journal** in sequence order, one post per row: `[<seq>] p<author>: <text>`. A post wider than the frame is truncated to the width with a `~` in the last cell, never wrapped past the row and never overflowing it.
- **Overflow is honest.** When more posts exist than the body can hold, the last body row reads `(+<K> more)` rather than silently dropping the tail.
- **An empty channel says so** -- `(no posts yet)` -- rather than drawing a blank face.

Every row is exactly the frame width; the whole frame is exactly rows times columns bytes. The fold is referentially transparent -- the same channel renders the same bytes every time -- so a painted view (the day Brushstroke wakes) can never drift from the text the witness pins here.

## The guarantees the witness proves

- **The frame is structurally exact** -- every one of the 24 rows is exactly 80 bytes; the buffer is exactly 24 x 80.
- **The journal reads back in the frame** -- a three-post channel shows each post's sequence, author point, and text, byte-for-byte within its row.
- **Truncation marks, never wraps** -- an over-wide post ends in `~` and never bleeds into the next row.
- **Overflow counts, never drops** -- a channel past the body capacity ends in `(+K more)` with the true count.
- **Determinism** -- rendering the same channel twice yields identical bytes.
- **The empty face is honest** -- a fresh channel renders `(no posts yet)`.

## What this rung is not

Not a live TTY (no cursor, no input, no escape codes -- that is Dexter's own module, `drawn_terminal.rye`, and a later Scooter-on-Dexter input rung), not a painted pixel surface (rendering waits on the Bit Design System), and not the wire (serving a channel between piers reaches the serve gate). This rung is the pure, bounded fold from a channel to a readable frame -- the face every one of those later rungs stands on.

---

*May Scooter's first face read plainly, every row the true width and every post its own bytes, so the day it is painted the picture already matches the words.*
