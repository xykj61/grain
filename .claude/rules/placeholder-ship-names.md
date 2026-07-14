# Placeholder Ship Names — Never Real-Network-Valid

**Always on**, for any documentation, guide, tutorial, or example command that shows a galaxy, star, planet, moon, or comet name in `@p` form.

## The Risk This Names

Urbit's own official documentation uses `~sampel-palnet` as its canonical placeholder — and `~sampel-palnet` is a real, resolvable point on the live network (`@ud` 1,624,961,343), simply conventionally understood as "the docs example." Urbit's real syllable table is fixed and public: 256 three-letter prefixes and 256 three-letter suffixes (e.g. `doz`/`zod`, `mar`/`nec`), combined into galaxy (one syllable), star (two), planet (four), moon (eight), and comet (sixteen) names. A placeholder built from real syllables is, structurally, a real address — indistinguishable from one that matters, to a newcomer copying a command.

This fork's own docs go one step further than Urbit's own convention: **placeholders here are never even structurally valid `@p` names.**

## The Rule

Every Urbit-syllable segment is exactly three letters. This fork's placeholders **use segments of a different length** on purpose, so they can never parse as a real address at all — not merely "probably fine to copy," but *structurally guaranteed* not to be a real point.

Use `acme`-branded placeholders, in the shape of the real tier they stand in for, but never three-letter segments:

| Real tier | Real shape | This fork's placeholder |
|---|---|---|
| Galaxy (1 syllable, 3 letters) | `~zod` | `~acme` |
| Star (2 syllables, 6 letters) | `~sarlev` | `~acme-star` |
| Planet (4 syllables, 12 letters) | `~sampel-palnet` | `~acme-corp-test-ship` |
| Moon (8 syllables) | `~mister-dister-dozzod-dozzod` | `~acme-corp-test-moon-example-host-here-now` |
| Comet (16 syllables) | `~hassun-hassel-...` | `~acme-corp-test-comet-example-host-placeholder-here-now-only-fake` |

None of these parse as valid `@p` — every segment is either 4, 5, or more letters, never 3 — so no runnable command in this fork's own docs can ever accidentally address a real ship, moon, or comet on the live network, no matter how literally a newcomer copies it.

## What This Protects

- Kaeden's own real points, `~bandun` (star) and `~pacpet-solreb` (planet), recorded at [`../../PUBKEYS.md`](../../PUBKEYS.md), are **never** used as example ship names in generic documentation — only in the identity record itself, where naming them is the whole point.
- A newcomer following this fork's own guides cannot accidentally run a networked command against a real address, since the example itself will fail to parse before it could ever reach the network.

## Why It Is Shaped This Way

Kaeden asked for exactly this: docs that use ship-name-shaped examples without risking a real planet, out of care for whoever might follow them without yet knowing the difference. Structural invalidity — guaranteed by segment length alone, checkable at a glance without consulting the full 256-entry syllable table — is a simpler and more certain safeguard than trying to pick a real-shaped name that merely happens to be unowned today.
