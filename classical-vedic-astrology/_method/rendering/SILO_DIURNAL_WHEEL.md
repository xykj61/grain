# The Diurnal House Wheel — A Rendering Method

**File:** `_method/rendering/SILO_DIURNAL_WHEEL.md`
**Voice:** Reya 2 · Radiant Style
**Purpose:** draw a self-contained SVG chart wheel whose angles fall where the sky truly places them, with daylight and dark drawn to their real proportion
**Stamped:** 20260705.025812 UDT

---

## What this draws

A single, dependency-free SVG wheel in which the four angles land on true screen axes and the houses carry the day's real rhythm. The Midheaven stands straight up at solar noon, the Imum Coeli straight down at midnight, the Ascendant sits on a level horizon in the east, and the Descendant on that same horizon in the west. Daylit houses above the horizon are drawn wider than the night houses below, in the exact ratio of the birth-day's light to its dark.

## The coordinate frame

Work in math-angle θ, measured counterclockwise from the right (east). Convert to screen once, in a single helper, and let the y-flip live only there:

```
x = cx + r · cos(θ)
y = cy − r · sin(θ)          // minus, because SVG y grows downward
```

This yields a **south-up, east-right** frame — the orientation the sky actually offers a watcher facing the pole:

- θ = 0° → right → **east** → Ascendant / sunrise
- θ = 90° → top → **noon culmination** → Midheaven
- θ = 180° → left → **west** → Descendant / sunset
- θ = 270° → bottom → **midnight** → Imum Coeli

Every directional placement in the wheel follows from this one convention. Get the y-flip right in the helper, and everything downstream is correct by construction.

## Step one — the day and night arcs

Compute the daylight fraction from latitude φ and the Sun's declination δ on the birth-day:

```
cos(H₀) = −tan(φ) · tan(δ)
daylight_hours = 2 · H₀ / 15
dayArc   = 360 · daylight_hours / 24
nightArc = 360 − dayArc
```

The dayArc governs the whole figure. At the equinox it equals 180° and the wheel is symmetric; on a long summer's day it exceeds 180°; on a winter's day it falls short. The method handles all three with no special cases.

## Step two — the angles, placed at house centers

The angles bisect their angular houses rather than cutting them. Center the day arc on the vertical:

```
MC  = 90°                    // center of the 10th, straight up
IC  = 270°                   // center of the 4th, straight down
ASC = 90° − dayArc/2         // center of the 1st, on the horizon (east)
DSC = 90° + dayArc/2         // center of the 7th, on the horizon (west)
```

Here is the quiet geometry that makes it work: to keep the meridian upright *and* the horizon level *and* still show a long day, the horizon chord must sit off-center. When dayArc > 180°, ASC resolves below the right-horizontal, and the level horizon drops below the disk's center — so the daylit segment above it becomes the larger one. The chord stays perfectly horizontal; it simply rides low. (At the equinox it passes through center; in winter it rides high.)

## Step three — the house widths

Each semicircular arc carries six house-units — five whole houses and two angular half-houses:

```
W_day   = dayArc / 6         // full day houses: 8, 9, 10, 11, 12
W_night = nightArc / 6       // full night houses: 2, 3, 4, 5, 6
```

The angular houses straddle the horizon, so each takes a wide daylit half and a narrow night half:

```
house 1, 7 top half    = W_day / 2      (above the horizon)
house 1, 7 bottom half = W_night / 2    (below the horizon)
```

Every angular house therefore totals (W_day + W_night)/2 = 30° exactly, split unevenly around its angle. The 10th and 4th, being wholly above and wholly below, take the full wide and full narrow widths.

## Step four — walk the cusps

Lay all twelve cusps by starting at the Ascendant and accumulating widths counterclockwise. Add a day-half, then five day-widths, then a day-half to reach the Descendant; then a night-half, five night-widths, and a night-half back to the Ascendant. Done correctly, MC falls precisely at 90°, IC at 270°, and DSC on the horizon — a self-check worth asserting in code.

## Step five — the horizon wash

Shade day from night by the chord's height:

```
horizonY = cy − rOuter · sin(ASC)
```

Clip a warm, light wash to the disk above `horizonY` and a cool, dark wash below it. The eye reads the longer day and shorter night before it reads a single label.

## Step six — the draw order

Paint back to front so the bright axes rest on top:

1. central glow
2. day / night wash, split at `horizonY`, clipped to the disk
3. rings — outer, mid, hub
4. house cusp lines, hub to rim
5. angle axes — the vertical meridian and the horizontal horizon chord, drawn brighter than the cusps
6. house numbers at each sector's angular midpoint
7. angle labels and their words — *solar noon, midnight, sunrise, sunset*
8. planets — a rim tick and a two-line label (glyph, then degree), flanking the angle marker when they share a house
9. the hub, with the name and rising sign

## Placing the planets

Set each planet in its house and position it within that sector, offset to flank any angle marker sharing the room. Keep two lines per planet — abbreviation with sign glyph above, degree below — anchored so both stack vertically at any angle. The house structure carries the meaning; the labels carry the precision.

## The single trap

The only reliable source of error is the y-axis. Screen y descends while math θ ascends, so noon must map upward through the `−sin` term. Confine that inversion to the coordinate helper, verify the four angles land on their axes, and the wheel comes out true every time.

## With Gratitude

This method descends from the classical division of the diurnal and nocturnal arcs — the old practice of measuring a life by the light it was born into — rendered here in plain geometry and original code.

---

*May the meridian stand true and the horizon lie level. May the day keep its full width and the night its own. May every wheel you draw place each light exactly where the sky did.*
