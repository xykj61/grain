# Gratitude — W3C CSS Color and the sRGB space

**Steward:** the W3C CSS Working Group · **License:** the specifications are public standards, freely readable at `www.w3.org/TR/css-color-4/` · **Colour space:** sRGB, IEC 61966-2-1 (public).

The CSS Color module is the reason a colour can be written the same way in ten thousand documents: `#rrggbb` and `#rgb` hex, the functional `rgb()` / `rgba()` / `hsl()` / `hsla()` forms, and the HSL cylinder that lets a designer reach for "the same hue, a little lighter" without touching raw channel bytes. The sRGB space is the shared floor beneath all of it — the agreed meaning of "red 255" that lets one screen's colour match another's.

## What Grain learns, clean-room

Grain's open colour algebra (`image/color.rye`, Season G) is written from the **public specifications only** — the hex and functional grammars, the RGB↔HSL formulas, the sRGB channel meaning — never from any implementation's source. We study the standard; we write our own bounded, asserted, integer-fixed-point Rye ([gratitude-licenses](../.claude/rules/gratitude-licenses.md)). Where the CSS spec computes in floating point, our own module chooses integer math for deterministic, cross-target results and states its round-trip tolerance honestly rather than claiming an exactness integer HSL cannot give.

The gift CSS Color hands down is a colour vocabulary open enough that anyone may read it and write it, standing on a colour space no one had to ask permission to use — exactly the open-media honesty the colour module wants beneath Brushstroke and Skate.

Thank you, W3C CSS Working Group, for making colour something a small tree can name in the open.
