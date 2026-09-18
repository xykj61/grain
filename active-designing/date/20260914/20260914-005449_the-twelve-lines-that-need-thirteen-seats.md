# The Twelve Lines That Need Thirteen Seats

**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Design handoff -- **mixed room**: the present capacity mismatch is checkable; the separate receipt snapshot is proposed
**Stamp:** `20260914.005449` (EDT)
**For:** Diffuser's Brushstroke and Skate surface; Bakery's proof closure

## The reading

**Observation.** At git parent `d67d42078c`, `ReceiptCard` renders **12 ASCII lines** on a fixed
**72-cell by 18-row** plane. Its `accessibilityLine(row:)` reader returns bytes from that plane in
row order. Source: `skate/Sources/SkateCore/ReceiptCard.swift`, read `20260914`.

**Observation.** At the same parent, `AccessibilitySnapshot` owns **9 node seats**: one frame root
and eight text lines. Each text label admits at most **40 bytes**, and each rectangle is bounded by
the elder **40-cell by 8-row** media grid. Source:
`skate/Sources/SkateCore/AccessibilitySnapshot.swift`, read `20260914`.

**Observation.** The accepted receipt contract requires Skate's Still frame and accessibility
snapshot to carry every deciding Linengrow field in the same reading order, within **72 cells by
18 rows**. Source: `active-designing/20260912-201126_the-receipt-you-can-read-contract.md`, accepted
for bounded synthetic implementation on `20260913`.

**Inference.** The Receipt Card's rendered bytes are a sound single source for semantic text, yet
the existing snapshot type cannot hold them. A complete card needs **13 node seats**: one root plus
12 lines. Its value row is 33 bytes in the accepted fixture, while the 72-cell receipt ceiling
allows a later admitted line to exceed the elder snapshot's 40-byte label ceiling.

**Inference.** Widening `AccessibilitySnapshot` would mix two proven surfaces. Its 9-seat and
40-by-8 bounds belong to the media frame; the receipt contract already chose a distinct plane.
The smallest seam is therefore a receipt-specific snapshot that reads `ReceiptCard` directly.

## The buildable handoff

Add a `ReceiptAccessibilitySnapshot` beside `ReceiptCard`, with these bounds stated before its
storage:

- **13 inline node seats**: one root and at most 12 text rows for this card version.
- **128 ASCII bytes** for the root identity, matching the elder root ceiling.
- **72 ASCII bytes** per text label, matching the receipt plane width.
- Row-local rectangles bounded by **72 columns and 18 rows**.
- Whole-value publication only after every node and rectangle passes.

The root names the receipt identity. Nodes 1 through 12 copy the bytes returned by
`accessibilityLine(row:)` in ascending row order. Repeating regeneration from the same card must
produce a byte-identical value. A refusal must leave the previous count and all 13 physical seats
unchanged.

Bakery can place this witness in the product proof closure without teaching Rishi any surface
meaning: build Skate, run the receipt snapshot tests, and record the compiler identity beside the
result. The public `LinengrowReceipt` adapter remains Diffuser's later seam when that type lands.

## Projection

**Projection, next Diffuser implementation lap.** A separate snapshot should close the Skate half
of acceptance case 4 in one module-and-test change, assuming the Receipt Card keeps its present 12
rendered lines and Swift 6.3.3 keeps `InlineArray` available on the declared macOS 26 floor.

**FALSIFIER.** Reject this shape if a test proves that the accepted card requires more than 12
semantic text rows, if a deciding field cannot appear in the same order as the rendered rows, or
if the product contract seats a shared cross-surface accessibility type instead of separate media
and receipt bounds.

**Confidence:** high that the current types do not compose; medium that 13 seats remain the right
long-lived ceiling, because the public Linengrow projection has not landed yet.

## What stays open

This study does not claim acceptance case 4 GREEN. It binds the mismatch and names a buildable
repair. Still-frame equality, reduced motion, renderer loss, hidden-document behavior, focus order,
and the direct `LinengrowReceipt` adapter remain open. Palette and signature composition remain at
DJINN's design gate; real identities, values, keys, and deployment remain at their custody gates.
