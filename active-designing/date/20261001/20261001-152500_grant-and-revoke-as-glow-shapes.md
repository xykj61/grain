# Grant and revoke, in the smallest Glow form already owned

**Stamp:** `20261001.152500` (EDT)
**Language:** EN
**Style:** Gauge at Field
**Voice:** Kyri
**Status:** Vision -- sketch only, per `context/TWO_ROOMS.md`. Neither `+$` shape below lives in a
tracked `.glow` source yet, and lowering either into Mantra waits for Patchouli and Incense, per
the inner prompt that named this sketch as its own task.
**Sibling:** [The consent you can change](../../date/20261001/20261001-145643_the-consent-you-can-change-contract.md)
names `ConsentGrantFact` and `ConsentRevokeFact` in prose, with their field lists and byte
ceilings. This page draws the same two facts the other way -- as Glow shapes -- the way
`glow/rune_shape.rye`'s own fifteen-field ceiling was read off `ReceiptOfferFact`
([that contract](../../date/20260912/20260912-201126_the-receipt-you-can-read-contract.md)) rather
than picked ahead of a real desk.
**Falsifier:** If either shape below asks for a ninth field, a numeric aura, or a payload wider
than Glow's own `+$`/`$:` already admits, this sketch undercounted and the ruling that closed
`glow/rune_shape.rye`'s ceiling at fifteen gets read wrong here too.

## Why a sketch, and why now

`glow/rune_shape.rye` raised its field ceiling from nine to fifteen on `20260923`, on metal, because
`ReceiptOfferFact` genuinely needed fifteen. That ruling carries a reusable lesson: **a shape's
ceiling comes from a real desk, measured rather than guessed ahead of one.** Milestone two's two
new facts are the next desk a shape rune will meet, so this page measures them before any code
exists -- the same order the receipt contract's own `.lap/shape-receipt-offer.glow` scratch sketch
kept, with one difference: this sketch is written to stand, so the next hand who lowers it reads a
tracked page rather than reconstructing a scratch file.

## The two shapes

Both shapes fit inside the nine-field ladder `glow/rune_shape.rye` carried before the receipt
raised it -- the fifteen-field ceiling the receipt earned stays exactly where it is, and so does
every wider one. Field names and order follow the consent contract's own `ConsentGrantFact` and
`ConsentRevokeFact`. Every face is `@t`, Glow's cord aura: each value here reads as a name, a
scope word, or a timestamp string, so the four-aura table in `glow/rune_shape.rye` keeps its
current four.

```text
::  The consent grant fact as one Glow shape -- milestone two's first public
::  type, ConsentGrantFact, written in the smallest form Glow owns.
::  Contract: active-designing/date/20261001/20261001-145643_the-consent-you-can-change-contract.md
::  Nine fields, inside the nine-field ladder rune_shape.rye held before the
::  receipt's own fifteen-field desk raised it -- no ceiling move needed here.
::  Every face is @t; a grant carries no amount, digest, or other numeric aura.
+$  consent-grant-shape
  $:  schema=@t
      grant-id=@t
      receipt-id=@t
      holder-id=@t
      recipient-id=@t
      scope=@t
      granted-at=@t
      signer-id=@t
      signature=@t
  ==
```

```text
::  The consent revoke fact as one Glow shape -- milestone two's second public
::  type, ConsentRevokeFact, written in the smallest form Glow owns.
::  Contract: active-designing/date/20261001/20261001-145643_the-consent-you-can-change-contract.md
::  Seven fields -- the smallest of the three facts this tree has shaped so
::  far (receipt 15, grant 9, revoke 7), because a revoke names only what it
::  revokes and who revoked it, leaving the grant's own scope unrepeated.
+$  consent-revoke-shape
  $:  schema=@t
      revoke-id=@t
      grant-id=@t
      holder-id=@t
      revoked-at=@t
      signer-id=@t
      signature=@t
  ==
```

Field order follows the contract's own reading order here, apart from the receipt's: `consent-revoke-shape`
names what it revokes (`grant-id`) before who revoked it (`holder-id`, `signer-id`), the same way
the contract's own acceptance case 7 reads the two identifiers side by side to catch a mismatch.

## Ceilings, carried forward

Every number below carries forward from the consent contract's own bounds table -- a shape names
faces, and a separate desk owns what those faces may hold, exactly as the receipt's own
`.lap/shape-receipt-offer.glow` scratch already said: "a shape names faces rather than ceilings." A
future `tally/consent_bounds.rye` would hold these constants the way `tally/receipt_offer_bounds.rye`
holds the receipt's own.

| Field or population | Ceiling | Unit |
|---|---:|---|
| encoded `consent-grant-shape` | 1024 | bytes |
| encoded `consent-revoke-shape` | 512 | bytes |
| `grant-id`, `receipt-id`, `holder-id`, `recipient-id`, `revoke-id`, `signer-id` | 96 | ASCII bytes |
| `scope` | 80 | ASCII bytes |
| `signature` | 192 | ASCII bytes |
| consent facts admitted in one replay | 2 | facts |

## One catch case each

Both cases travel through the five-field shape the receipt contract already owns --
`receipt-refusal-shape` (`field`, `value`, `ceiling`, `unit`, `reason`) -- since a consent catch
asks for exactly the readings a receipt catch asks for, and reusing a proven shape beats inventing
a new one to say the same five things.

**Grant: an oversized `scope`.** The contract's own fixture carries `scope
habitat-planning-read-only` (25 ASCII bytes), well under the 80-byte ceiling. Stretch it one byte
past that ceiling and the fixture meets the shape before append:

```text
field=scope value=81 ceiling=80 unit=ascii-bytes reason=too-long
```

**Revoke: a `grant-id` with no match.** The contract's own acceptance case 6 already covers this
reading in prose; here the same reading travels through the shared shape, naming a `grant-id` that
admits to no standing `consent-grant-shape`. A lookup decides this case rather than a byte ceiling --
the unbounded kind `tally/receipt_offer_bounds.rye`'s own `Refusal.bounded` flag already names. So
`value` and `ceiling` read `0`, and `reason` alone carries the weight, exactly as that Rye source's
own doc comment allows:

```text
field=grant-id value=0 ceiling=0 unit=facts reason=no-admitted-grant
```

## What this sketch leaves for the next hand

`glow/rune_shape.rye`'s `max_fields` stays exactly at fifteen: both shapes above fit inside the
ladder that stood before the receipt raised it, so this sketch leaves that ceiling untouched.
`tally/consent_bounds.rye`, `mantra/src/consent_grant.rye`, and any lowering path stay Dream's and
Incense's door to open, per the inner prompt that named this sketch as a sibling task rather than
a continuation of the closed receipt fruit. And running either `+$` block above through
`glow_run.rye`'s own parser is the first proof a future lap owes, before this sketch earns more
trust than the reading a person gives it today.

May the shape a grant takes stay exactly as small as the thing it grants, and may the shape a
revoke takes stay smaller still, since a revoke has only ever had to name what came before it.
