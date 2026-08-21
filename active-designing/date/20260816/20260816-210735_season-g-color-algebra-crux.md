# Season G — the open color algebra in Rye (the smallest tractable crux)

**Stamp:** `20260816.210735` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round — building now, Rye-first, floor code
**Kin:** [`the eight-season double-seat`](20260816-205859_double-seat-expansion-eight-seasons.md) (Season G — Open Media Primitives) · [`image/qoi.rye`](../image/qoi.rye) (the sibling open primitive) · [`rye-first crypto parity`](20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md) (the Rye-first spine)

---

## Why this round, why now

The eight-season double-seat names the open **sRGB / hex / HSL color primitive** as "the crux and the smallest tractable move in the whole pile" — **floor code that does not wait on DJINN's Bit Design System**, since only Brushstroke *rendering* is paused, never color math. It prepares Brushstroke and Skate with a proven color model the day the design system lands, and it sits beside `image/qoi.rye` as the second member of the open-media family. Lindy-first: a color model is read by every surface for years. Crux-first: it is the one move that unblocks the rest of the family without depending on any paused or gated thread. No network, no key, no funds — the same honest floor QOI stands on.

## What a color *is*, in this module

A color is four bytes — **sRGB red · green · blue, and alpha** — held exactly, so a color that goes in comes back out byte-for-byte. Everything else is a *reading* of those four bytes: a hex text, a functional `rgb()` / `hsl()` text, an HSL triple, a blend of two, a quantization to fewer levels. The bytes are the truth; the readings are derived and bounded.

## The four rounds this quest fills

1. **Parse & format (this round's crux).** Parse `#rgb`, `#rrggbb`, `#rrggbbaa` hex and `rgb()/rgba()/hsl()/hsla()` functional forms into the four-byte color; format back to canonical `#rrggbbaa`. The provable property: `format(parse(hex))` is the canonical hex, and re-parsing it recovers the same bytes — an exact round-trip, QOI's discipline carried to text.
2. **HSL conversion.** RGB→HSL and HSL→RGB by integer fixed-point math (no float, so it is deterministic across targets). Proven against known vectors — pure red is `hsl(0,100,50)`, the greys are `hsl(0,0,l)` — and a full-sweep round-trip that recovers each channel within a small **named tolerance**, stated honestly rather than claimed exact (integer HSL cannot round-trip byte-exact, and the module says so).
3. **Blend.** Linear interpolation between two colors by a `t` in `0..255`, and the alpha-**over** compositing operator — both exact integer math, endpoints recovered precisely (`t=0`→a, `t=255`→b).
4. **Quantize.** Reduce each channel to `levels` steps (`2..=256`), bounded and deterministic, so a palette or an e-ink panel's limited depth has one honest reduction.

This round lands rounds 1, 3, and 4 whole and round 2's conversion with its named tolerance — the full crux in one file, witnessed end to end, because the pieces are small enough to hold together and the round-trip property wants them all present to prove.

## TAME shape

`u8` color channels · `u16` hue (`0..=360`) · `u8` saturation/lightness percent (`0..=100`) · `u32` in-memory counts and cursors. Every parse names its maximum length and refuses over-long or malformed input **by name** (`BadHexLength` · `BadHexDigit` · `BadFunctionForm` · `ChannelOutOfRange` · `BadLevels`), exactly as QOI refuses a malformed stream rather than painting garbage. Two-plus invariants per function, stated positively. `copy_disjoint` over bare copies. The witness prints one GREEN line and the round-trip, known-vector, blend-endpoint, and quantize claims each stand on an assert.

## Teacher, thanked clean-room

The **W3C CSS Color** module (public specification only) and the **sRGB** color space (IEC 61966-2-1, public) are the teachers of the hex and functional syntaxes and the HSL formulas — studied as public standards, never a copied line; our own Rye. Silo: [`gratitude/w3c-css-color.md`](../gratitude/w3c-css-color.md).
