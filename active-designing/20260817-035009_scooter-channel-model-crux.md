# Scooter, Rung 1 -- the channel model (permissioned journal, derived-unread inbox)

**Stamp:** `20260817.035009` -- **Status:** Mixed -- Living (design read, self-approved) -- **Voice:** Kyri -- **Style:** Radiant
**Season:** the Eight-Season double-seat -- **Season G, Open Media Primitives** -- the terminal family (Dexter + Scooter)
**Kin:** [`the terminal-family plan`](../expanding-prompts/20260816-222322_dexter-terminal-and-scooter-cli-chat.md) (build round 6) -- [`the terminal-family names`](20260816-222322_terminal-family-names.md) -- pattern elders `pond/apps/skate_circle.rye`, `pond/apps/skate_group.rye`

## Why this rung, Lindy-first crux-first

The timed-overlay open-media family is capstoned; the crypto surface stands whole. The next
agent-doable crux with real durability is the **terminal family** the eight-season map names --
Dexter (the drawn TTY, floor already laid in `linengrow/`) and **Scooter**, the permissioned
command-line chat on Pond. Scooter has no file yet. Its heart -- the one thing every later rung
(the drawn frame, the signed post, the Comlink transport) stands on -- is the **channel model**:
a permissioned join, an append-only journal, and a per-member unread inbox. That model is pure
bounded Rye, provable on metal with no network, no key, and no funds. It is the highest-Lindy
still-tractable move, so it lands first.

## The shape -- one keystone

`pond/apps/scooter_channel.rye`, mirroring the proven `skate_circle` / `skate_group` state
machines (bounded arrays, named errors, demo keeper points, `selftest` that speaks GREEN):

- **Permissioned join.** A channel opens with a founding **host**. Only the host **admits** a
  keeper (`NotHost` refuses any other caller); a stranger who was never admitted can neither
  post nor read (`NotMember`). Consent is the host's explicit act, mirroring Skate's rule that
  presence is never default.
- **Append-only journal.** A `post` from a member appends one `Post` -- author, a strictly
  ascending sequence number, and bounded text held byte-for-byte. The journal only grows; a
  post is never mutated or dropped; a seq is monotone by construction.
- **Derived-unread inbox.** Each member carries a read **cursor**. `unread_count` is *derived*
  (`post_count - cursor`), never stored, so it cannot drift from the journal. A keeper admitted
  after N posts starts with a cursor at N -- they see only messages from when they joined, the
  honest chat semantics. `catch_up` advances the cursor to the journal end (clears the inbox);
  the cursor is monotone and never rewinds.
- **Bounded everywhere.** A full roster refuses `ChannelFull`, a full journal `JournalFull`, an
  over-long post `TextTooLong` -- refuse rather than drop a keeper, a post, or a byte.

## The proof -- witness-first, red-then-green

`tools/scooter_channel_witness.rish` builds the module to a binary and asserts its `selftest`
speaks GREEN over these cruxes:

1. **Permissioned** -- a non-host admit refuses `NotHost`; a stranger's post refuses `NotMember`
   and the journal is unchanged (no byte lands).
2. **Append-only** -- three posts carry seqs 0,1,2 strictly ascending; each post's text reads
   back byte-for-byte; `post_count` only grows.
3. **Derived unread** -- a member admitted after two posts starts with 0 unread; each new post
   raises a caught-up member's unread by exactly one; `catch_up` zeroes it; the cursor never
   rewinds.
4. **Bounded** -- `ChannelFull`, `JournalFull`, `TextTooLong` each refuse by name.

## Not this round -- named, not fabricated

- **Signing** each post with the member's settled Kumara identity is the next rung (r2), exactly
  as `skate_circle_signed` follows `skate_circle`. This rung is the pure rule, no signing yet.
- **Dexter composition** (the drawn frame around the channel) and the **Comlink transport**
  between two Constel fake piers are later rungs; a channel served over the wire reaches the
  serve gate -- Keaton's hand.
- **No network, no key, no funds** -- facts only, custody-first.

*May the first channel Scooter opens hold every word it is trusted with, and let no one in who
was not asked.*
