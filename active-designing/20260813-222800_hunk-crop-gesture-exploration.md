# HUNK60 — the interactive crop gesture

**Stamp:** `20260813.222800` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season A (Hardware & Right-to-Repair) · waymark HUNK · Photos-app journey · rung HUNK60**
**Kin:** [`photos.rye`](../image/photos.rye) (HUNK3 `crop`) · [`photo_edits.rye`](../image/photo_edits.rye) (HUNK11 vocabulary) · [`edit_touch_input.rye`](../image/edit_touch_input.rye) (HUNK50 down/move/up law)

## The gap this rung closes

HUNK3 gave the Photos app a pure `crop` verb, and the double-seat itinerary names cropping the **crux gesture** of the app — *"cropping plus the common iCloud Photos / Google Photos gestures."* Yet every crop so far took four numbers a caller had to know in advance. A keeper cannot yet do the one thing a photo app is for: **drag a rectangle on the picture and keep what is inside it.**

The filmstrip arc (HUNK54–59) built the app's *history* surface — reading, tapping, scrubbing, windowing the road a picture took. This rung turns to the app's *editing* surface and lands the gesture the itinerary called the crux.

## The move

`CropGesture` owns the image's `width`×`height` and a drag, in **image pixels**, under HUNK50's arming law: press sets an anchor corner, each sweep moves the opposite corner, lift settles both. One pure `rect` reads the two corners as a normalized top-left rectangle — `min`/`max` of the corners — so a drag in **any direction** names the same rectangle, and both corners clamp inside the image so no rectangle ever exceeds the picture.

The gesture invents no pixels and no edit: `as_edit` turns the rectangle into a `.crop` edit a keeper's cursor can `push`, so a dragged crop joins the **same non-destructive history** as every other verb (HUNK11), and `preview` applies the rectangle to the source through HUNK3's `crop` for a live look at what commit will produce. A degenerate drag — a tap, or a zero-width sweep — commits nothing, refusing `NoRect` by name rather than an empty crop.

## Why this shape

- **Lindy-first.** The crop gesture is the app's central editing act, read thousands of times over the app's life; it outweighs another filmstrip refinement (auto-pan, HUNK60-as-was) which polishes an already-strong sub-feature.
- **Crux-first.** The hardest still-tractable move is normalizing an arbitrary drag into an in-bounds, first-class edit that round-trips the vocabulary — proven, not assumed.
- **Pure composition.** No new pixel op, no new failure mode of its own: the rectangle is in-bounds by the corner clamps, so its later `apply` cannot raise `OutOfBounds`; only `NoRect` (a drag that named no area) is the gesture's own honest refusal.

## The proof (selftest)

An 8×8 two-tone source with a per-column green gradient (so a mis-placed crop would show):

1. A drag `(2,2)→(6,6)` commits `crop{2,2,4,4}`; its live `preview` equals a direct `crop` cell-for-cell; its edit round-trips `render_edits`/`parse_edits`/`apply` to the same cropped image — a dragged crop is a first-class, non-destructive edit.
2. A **reverse** drag normalizes to the same rectangle — direction never matters.
3. Corners **past the edges** clamp to the whole image; cropping to the whole image recovers the source.
4. A **tap** and a **zero-width sweep** each refuse `NoRect` rather than commit an empty crop.
5. A **move with no press** moves nothing (the arming law).
6. A **zero-dimension image** refuses `BadImage` at open.

## The road on from here

- A Skate/Brushstroke **overlay** that paints the crop rectangle's outline on the glass as it is dragged (a later rung, paralleling the filmstrip's paint surfaces).
- Filmstrip **continuous auto-pan** (the deferred HUNK60-as-was) remains a named, smaller refinement for when the history-surface arc resumes.
