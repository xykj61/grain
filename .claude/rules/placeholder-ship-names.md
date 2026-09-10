# Placeholder Ship Names -- Never Real-Network-Valid

**Always on**, for any documentation, guide, tutorial, or example command that shows a galaxy, star, planet, moon, or comet name in `@p` form.

## The Risk This Names

Urbit's own official documentation uses `~sampel-palnet` as its canonical placeholder. That name is a real, resolvable point on the live network, `@ud` 1,624,961,343. Convention alone is what makes it read as the docs example.

Urbit's real syllable table is fixed and public. It holds 256 three-letter prefixes and 256 three-letter suffixes, such as `doz` and `zod`, or `mar` and `nec`. A galaxy takes one syllable, a star two, a planet four, a moon eight, and a comet sixteen.

So a placeholder built from real syllables is a real address. To a newcomer copying a command, it looks like every other address on the page.

This fork's own docs go one step further than Urbit's own convention: **placeholders here are never even structurally valid `@p` names.**

## The Rule

Every Urbit-syllable segment is exactly three letters. This fork's placeholders **use segments of a different length** on purpose. So they can never parse as a real address at all, and that is *structurally guaranteed* rather than merely likely.

Use `acme`-branded placeholders, in the shape of the real tier they stand in for, but never three-letter segments:

| Real tier | Real shape | This fork's placeholder |
|---|---|---|
| Galaxy (1 syllable, 3 letters) | `~zod` | `~acme` |
| Star (2 syllables, 6 letters) | `~sarlev` | `~acme-star` |
| Planet (4 syllables, 12 letters) | `~sampel-palnet` | `~acme-corp-test-ship` |
| Moon (8 syllables) | `~mister-dister-dozzod-dozzod` | `~acme-corp-test-moon-example-host-here-now` |
| Comet (16 syllables) | `~hassun-hassel-...` | `~acme-corp-test-comet-example-host-placeholder-here-now-only-fake` |

Every segment above runs to 4, 5, or more letters, and never to 3. So each of these refuses to parse as a valid `@p`. A runnable command in this fork's own docs therefore reaches no real ship, moon, or comet on the live network, however literally a newcomer copies it.

## What This Protects

- Kaeden's own real points, `~bandun` (star) and `~pacpet-solreb` (planet), recorded at [`../../PUBKEYS.md`](../../PUBKEYS.md), are **never** used as example ship names in generic documentation -- only in the identity record itself, where naming them is the whole point.
- A newcomer following this fork's own guides cannot accidentally run a networked command against a real address, since the example itself will fail to parse before it could ever reach the network.

## Why It Is Shaped This Way

Kaeden asked for exactly this. Docs here use ship-name-shaped examples while every real planet stays out of reach, out of care for whoever follows them before they know the difference.

Structural invalidity is guaranteed by segment length alone. A reader checks it at a glance, with the 256-entry syllable table left closed. That is a simpler and surer safeguard than picking a real-shaped name that today happens to be unowned.
