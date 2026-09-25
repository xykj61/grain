# Receipt motion without changing receipt bytes

**Stamp:** `20260925.090046` (America/New_York)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Proposed -- mixed room: source counts are checked; motion behavior and host cost await witnesses
**Room:** mixed -- a bounded state proposal beside a source reading
**Lane:** Diffuser research; Skate owns any implementation, and DJINN holds signature visual choices
**Kin:** [the receipt contract](../20260912/20260912-201126_the-receipt-you-can-read-contract.md) - [the Still card](../../../skate/Sources/SkateCore/ReceiptCard.swift) - [the event ring](../../../skate/Sources/SkateCore/EventRing.swift) - [the accessibility snapshot](../../../skate/Sources/SkateCore/ReceiptAccessibilitySnapshot.swift)

## The question

How can a receipt settle into view and respond to a local action while its words remain readable in the same order? The first product whole needs a dependable Still frame. Motion may carry attention toward it, but it must never become the only way to obtain it.

## Observation -- the existing bounds

On 2026-09-25, `ReceiptCard.swift` declares a plane of 72 columns by 18 rows, or 1,296 cells. It writes 12 occupied lines. `ReceiptAccessibilitySnapshot.swift` reads 11 deciding fields from those Still lines, with amount and unit sharing one visual line. The source-order scan reported `published_fields=11`, `still_rows=12`, `accessibility_labels=11`, and `verdict=source_order_agrees` on this Linux host. Its control passed 7 legs, including a planted removal of the printable-byte admission check. These are source and control readings; Swift XCTest has not run here.

On the same date, `EventRing.swift` declares 128 optional event seats and refuses a full queue before mutation. It does not declare a receipt-motion event type. `FrameGrid.swift` declares a separate 40 by 8 core frame. The receipt's 72 by 18 plane therefore needs an explicit adapter or its own rendering path; treating the core frame as the receipt frame would silently crop it.

The product card gives Settle at most 1 second and calls Respond a fixed-radius, fixed-life local pulse. It also says renderer loss returns to Still and reduced motion yields Still. It gives no pulse radius, pulse life, or host energy measurement.

## Inference -- one stable meaning, sampled at any time

Keep the admitted `ReceiptCard` and its accessibility snapshot immutable throughout an effect. A motion state carries a start time, a bounded duration, and presentation parameters; it carries no copy of the receipt text. A renderer samples that state against a monotonic clock. For Settle, define progress as `clamp((now - start) / duration, 0, 1)` for a positive duration at or below 1,000 milliseconds. At progress 1, render the exact Still frame. A skipped timer tick then skips an intermediate picture, never the final state.

Reduced motion and renderer loss select progress 1 immediately. Hiding the document can stop scheduling samples; on return, the monotonic clock chooses either the correct later progress or Still. The accessibility snapshot remains the one derived from the admitted Still bytes at every sample. This separates the information a person needs from the presentation that guides the eye toward it.

Respond can use the same clock rule for a local decorative overlay: one fixed radius and one fixed positive life, both chosen and bounded before implementation. Its center must be inside the 72 by 18 receipt plane. Expiry removes the overlay and leaves the receipt bytes and product state unchanged. The event ring can carry a bounded trigger only after Skate declares and proves a fixed receipt event type; the ring's generic payload bound alone does not bound that type.

## Projection -- the next buildable witness

Over one development round, Skate can add a pure motion sampler and test it without a compositor. Assume a monotonic clock, an admitted Still card, and a fixed event type. Sample Settle at start, an interior time, the deadline, and after the deadline; sample reduced motion, renderer loss, and a hidden document returning after the deadline. Compare final bytes to `ReceiptCard.stillFrame()` and compare accessibility entries at every sample. Plant a duration above 1,000 milliseconds and a full 128-seat event ring; each must refuse before visible state changes. **Falsifier:** any terminal sample differs from Still, any accessibility entry changes during motion, or a refusal mutates the card or queue. Confidence is high that this pure test can decide the state rule; runtime rendering and focus order remain unproven until macOS XCTest runs.

A later fixed-host trial could measure frame time, damage area, timer activations, and energy across matched Still and motion runs. It assumes the same host, refresh rate, receipt content, and workload for each pair. **Falsifier:** motion exceeds the accepted frame budget, causes an extra accessibility announcement, or uses at least as much energy after a proposed optimization. Confidence in an energy saving is low: a constant-size motion state does not prove that the compositor avoids redrawing the 1,296-cell plane. No energy figure follows from the source reading.

## Handoff

The pure sampler and its negative tests are buildable now. DJINN's visual seat chooses the radius, life, color, and easing before any signature effect lands. The Linux source control can guard order and admission; a macOS run must close the rendered-frame, focus, and accessibility claims.
