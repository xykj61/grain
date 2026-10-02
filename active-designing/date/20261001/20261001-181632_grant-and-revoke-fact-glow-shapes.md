# Grant and Revoke Facts as Glow Shapes -- a sketch

**Stamp:** `20261001.181632` (EDT)
**Language:** EN
**Style:** Bhakta with Gauge's Field discipline
**Voice:** Kyri
**Status:** Proposed, vision room -- written to the same shape [the receipt offer fact's own desk](../20260912/20260912-201126_the-receipt-you-can-read-contract.md)
was before any code existed. Nothing below is checkable yet; it names fields, auras, and one
refusal case each, the way a desk is sized before a shape is lowered.
**Milestone:** The consent you can change -- the sibling task named in
[the product contract](20261001-145643_the-consent-you-can-change-contract.md)'s own closing
paragraph.
**Kin:** [the receipt offer fact's desk](../20260912/20260912-201126_the-receipt-you-can-read-contract.md) --
[`glow/rune_shape.rye`](../../../glow/rune_shape.rye) (the `+$` / `$:` grammar this sketch is
written in) -- [`glow/refusal.rye`](../../../glow/refusal.rye) and
[`tally/receipt_refusal.rye`](../../../tally/receipt_refusal.rye) (the five-part refusal line
both refusal cases below borrow)

## What this sketch is, and is not

The product contract names four public types for this milestone. Two of them --
`ConsentGrantFact` and `ConsentRevokeFact` -- are the shared immutable inputs, the way
`ReceiptOfferFact` was milestone one's. This page sizes those two the way milestone one's own
desk sized `ReceiptOfferFact`. It names field names, the aura each field wants, and one refusal
case each. All of it is written in Glow's own `+$` shape grammar, before any Rye module exists to
hold it.

This stays a sketch, apart from any lowering into Mantra. `ConsentState` and `LinengrowConsent`
stay out of it on purpose -- they are Mantra's replay result and Linengrow's own reading, and
lowering a shape into a working module is Patchouli's and Incense's door, in the order
`construction/ITINERARY.md` already names. What stands here is the desk a future lowering would
read from, sized once so the lowering can reach for it rather than re-derive it.

## The grant

```text
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

Nine faces, all `@t`: every field in a grant is a name, an identifier, or a timestamp written as
text, so these nine stay plain strings throughout -- the receipt desk's `@u64` and `@ux` auras
belong to a counted amount and a digest, fields this fact simply lacks. Nine stands well under
`rune_shape.max_fields`'s fifteen, so this shape is admitted exactly as written -- the receipt
desk was the first to reach past the ladder's elder nine, which is why that ceiling now reads
fifteen at all.

**One refusal case.** The contract's own bounds table gives `scope` an 80-ASCII-byte ceiling,
narrower than every identifier's 96. A scope wider than that field refuses before append.
Picture a recipient naming more than the one bounded use the receipt's own `purpose` already
permits. The refusal renders in the same five-part line both `glow/refusal.rye` and
`tally/receipt_refusal.rye` already use:

```text
field=scope value=84 ceiling=80 unit=ascii-byte reason=too-long
```

The number is illustrative. No fixture scope has been written long enough to reach it. It is
included only to show the *shape* the refusal takes, the same way the receipt contract named its
own borrowed-ceiling refusals before any admission code read them.

## The revoke

```text
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

Seven faces, all `@t` for the same reason the grant's are: a revoke says who, what it points at,
and when, and every one of those is a name, an identifier, or a timestamp rather than a counted
or digested value.

**One refusal case, and this one is the revoke's own rather than a ceiling.** The contract names
two refusals about a relationship rather than a field's length. One is a revoke naming a
`grant_id` that answers no admitted grant. The other is a revoke whose `holder_id` differs from
the grant it names. Both carry only `field` and `reason`. The five-part line's own shape already
allows for this: `tally/receipt_refusal.rye`'s `Reason` enum carries members with an empty
`Measure` (`unknown_schema`, `invalid_signature`) exactly where a refusal names a relationship
rather than a length.

```text
field=grant-id reason=orphaned-revoke
```

`orphaned-revoke` is a word this tree has yet to adopt into any `Reason` enum. It is named here as
the word a future lowering would add, the same way `tally/receipt_refusal.rye`'s own
`no_admitted_fact` was named in the contract before `Log.replay`'s refusal chain existed to throw
it.

## Why both stayed in one page rather than two

The contract sketches both facts together because a revoke is read in light of the grant it
answers. `grant_id` is every revoke's own first fact about itself. Splitting them into separate
pages would have cost a reader the cross-reference this page exists to spare: read once, both
shapes, both refusals, side by side.

## What a lowering would still need to decide

Ruled `20261001.200649`. `orphaned-revoke` earns a `Reason` member in the same change that lowers
these two facts, and not before that change exists. The `.lap` Glow desk stays untracked; this
page is the desk. Patchouli lowers both facts beside `mantra/src/receipt_offer.rye`. Exact-length
derivation for the two ids waits until a witness shows a digest the way `product_digest` did.

May the shape a grant takes and the shape a revoke takes read as plainly to the hand that lowers
them as they read to the hand that sketched them.
