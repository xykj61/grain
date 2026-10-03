# The label costs more than the four wires it labels

**Status:** checkable -- measured on metal, this host, `20261002.222020`
**Style:** Gauge at Field
**Lane:** Diffuser, moonshots and research

## What this page answers

[The four pairs ride as one string, not four channels](../20261002/20261002-004836_the-four-pairs-ride-as-one-string-not-four-channels.md)
found that Aurora's `roster_pairs` stage sends the four declared channel pairs as one
concatenated string, sealed once, and named the gap this leaves: the implementation that would
carry a per-channel traffic weight still waits to be built, so none exists yet to measure. That
essay declined to build the five-guest fabric a real per-channel measurement would need, calling
it a materially larger build than the lane should attempt speculatively.

This page asks a smaller, buildable question instead: **given the wire format this tree has
already landed, what would it cost in bytes to send those same four pairs as four separately
sealed messages instead of one?** That cost is measurable today with zero new modules, because
`comlink/wire_format.rye`'s `seal_message` already exists, is already GREEN, and already seals
exactly this payload in `comlink/roster_pairs_seal.rye`.

## Method

A throwaway host program called `wf.seal_message` once on the full concatenated string. It then
called the same function four times, once on each pair string alone. It printed the real byte
totals both ways. The program sat beside `wire_format.rye` so its relative import would resolve;
Zig requires an import to stay inside the root file's own directory, a rule learned here when the
first attempt sat one directory lower and the build stopped there. The probe stayed scratch: built,
run, and deleted in the same lap, removed before this essay was written. `git status` shows only
this page.

```
one_seal payload_bytes=89 wire_bytes=277
four_seals payload_bytes=86 wire_bytes=838
ratio_x100=302
GREEN
```

`payload_bytes` for the four-seal case reads 86 rather than 89 because the concatenated string
joins its four pairs with three newline separators (89 = 86 + 3) that four separate messages
skip -- each pair already names its own two domains in plain text, so those three bytes are the
entire cost a joining or labeling scheme would add.

## What the numbers say

`wf.seal_message`'s fixed cost per message is `off_cipher`. Five fields make it up: 32 bytes
sender key, 12 bytes nonce, 64 bytes SHA3-512 content name, 64 bytes Ed25519 signature, and 16
bytes ChaCha20-Poly1305 tag. Together they cost 188 bytes before a single payload byte is counted.
That cost is paid once per `seal_message` call, regardless of payload size.

| Scheme | Calls | Payload bytes | Overhead bytes | Wire bytes | Overhead share |
|---|---|---|---|---|---|
| one seal, four pairs joined | 1 | 89 | 188 | 277 | 67.9% |
| four seals, one pair each | 4 | 86 | 752 | 838 | 89.7% |

A genuine per-channel labeling scheme would send the four pairs separately, so each domain's own
channel could be told apart on the wire. That costs **3.02 times** the bytes of sending them as one
string. The seal owns nearly all of that growth; the label owns only a sliver. The three joining
newlines the one-string scheme pays for are smaller than a single one of the four messages' own
overhead charges. Knowing which bytes belong to which channel costs `off_cipher`'s 188-byte toll
three more times. Naming the channel itself costs only a few bytes beyond that toll.

## Bound and source

- **Bound:** this reads `comlink/wire_format.rye`'s `off_cipher`, `wire_capacity`, and
  `max_message` constants, plus `seal_message`'s real return value, on this host. The build used
  Zig `0.16.0` (`vendor/zig-toolchain/zig`), today. It is scoped to this one wire format and this
  one four-pair payload. A different AEAD, a different signature scheme, or a batched
  multi-message frame would change every number here. `wire_format.rye`'s own header comment
  already names that batched frame as "batched resin-frame hardening," deliberately deferred.
- **Source:** `comlink/wire_format.rye` lines 24-30 name the offset constants.
  `comlink/roster_pairs_seal.rye` is the landed hosted module this probe was modeled on. The
  probe's own printed output above is re-derivable by any later hand from these two files.
- **What holds it still:** free. Nothing pins these four numbers. Re-run the probe described in
  Method against the same two files to confirm them; a future edit to `off_cipher`'s constituent
  lengths would move every row in the table.

## Inference, separated from observation

**Observed:** one sealed message carrying 89 bytes of payload costs 277 wire bytes; four sealed
messages carrying the same 86 bytes of payload (minus three joining newlines) cost 838 wire bytes.

**Inferred:** the single-datagram sealed-message format this tree has built treats per-message
overhead as the dominant cost at small payload sizes. Any scheme that multiplies the message count
to gain per-item identity multiplies that fixed cost along with it. This is a property of
`seal_message`'s own shape -- one nonce, one signature, one content-addressed name, one AEAD tag
per call. It belongs to the wire format itself, rather than to Aurora's roster.

**Projected, and bounded:** [Comlink's own batched resin-frame hardening](../../../comlink/wire_format.rye)
is named but deferred in `wire_format.rye`'s own header. If it lands as one seal wrapping many
labeled sub-messages, the per-channel labeling cost should fall toward the handful of label bytes
this reading shows it ought to cost, rather than the 561-byte difference measured here.
**Falsifier:** build that batched frame. Seal four labeled sub-messages inside one `seal_message`
call. If the resulting wire size tracks near `89 + (label bytes)` rather than near `4 x 188`, this
page's "overhead is the whole cost" reading is confirmed. If it still scales near `4 x 188` --
because the batching wraps four calls rather than replacing them -- this page's inference about
where the fix lives would need revision. **Confidence:** high on the measured numbers (re-run and
check). Moderate on the projection: the batched frame stays unbuilt, so its own real overhead
stays to be measured.

## What this leaves for whoever builds per-channel traffic weight next

The prior essay's open question stands exactly where it stood: a real per-channel traffic weight
needs five guests rather than two. This page leaves that build as large as the prior essay found
it. What this page adds is a second, independent reason the one-string scheme was the right
default to land first. Even setting aside the five-guest build cost, the four-seal alternative
would have cost three times the bytes for the same information. That cost lives entirely in how
many times `seal_message` gets called, apart from Aurora's roster itself. A five-guest build that
wants real per-channel traffic weight should batch its sealing rather than multiply it.

## Related

- [The four pairs ride as one string, not four channels](../20261002/20261002-004836_the-four-pairs-ride-as-one-string-not-four-channels.md) -- the finding this page extends
- `comlink/wire_format.rye`, `comlink/roster_pairs_seal.rye`, `comlink/guest_roster_tx.rye` -- the three files read and the one module this probe borrowed its shape from
