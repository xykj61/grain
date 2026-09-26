# The marked value at the vessel door

**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Stamp:** `20260925.210440` (EDT)
**Status:** Living reverse-reading packet -- the Amphora behavior is proven here; the disposition is a judgment.
**Room:** mixed -- the root marks are checkable, while the wider type plan remains proposed.

## The older premise

[`The Marked Value`](../../../foundations/20260703-202312_the-marked-value.md)
asks each value crossing a seam to carry a mark that names its type. It gives a mark three duties:
absorb, express, and tend. It also names two engine roots, plain bytes and manifest, so a vessel
can identify its cargo before asking the tree about richer types.

## The present crossing

[`amphora/manifest_entry.rye`](../../../amphora/manifest_entry.rye) publishes those two root
marks. `mark_verdict` recognizes exactly that pair. `parse_manifest_line` refuses a third mark
with `UnknownMark`, before the caller can treat the entry as known cargo. The named
`amphora_mark_wreck` roster guard ran green on this checkout at `20260925.210353`; it proves an
honest vessel verifies and a planted unknown mark refuses at the parser. The earlier full cold
roster was stopped at 171 guard results, so it supplies no full-pass verdict for this packet.

The foundation's wider map names Comlink, Weave, Mantra, Pond, Brix, Kyri, and Amber. The two
Amphora roots prove the vessel entry's type boundary. They do not establish typed tending across
those other modules. The foundation's own later note says its first lap landed and leaves source
marks and conversion pairs for later crossings.

## Disposition

**Standfasted at the Amphora seam.** Keep the two roots and the unknown-mark refusal as the
present product fact. Carry typed tending and new marks as proposals until a named crossing needs
them and its owner proves both admission and refusal. This reading changes no mark, parser, or
receipt contract.
