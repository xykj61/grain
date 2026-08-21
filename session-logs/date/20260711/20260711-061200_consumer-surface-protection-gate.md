# Apply consumer-surface protection audit — published-set gate

**Editor:** Cursor · **Model:** Cursor Grok 4.5 · **Voice:** Rio 3
**Stamp:** `20260711.061200`

## Thinking trace

Kaeden handed Claude 5 Fable's consumer-surface audit (zip 48, parent `92e2d4c`). Consent architecture verified excellent. Real gap: Granary fetch-by-digest served any digest without consulting the published name registry — digest-as-capability. Fix already built in the bundle: `digest_is_published` + `serve_resin_published` + unwelcome path + witness assert.

Applied payload; `tools/granary_resin_wire.rish` GREEN including `unpublished digest refused`. Steep hammock sentence left parked in TASKS for Kaeden's word.

## Observations

- Principle seated in code: a digest is an address for verifying content, never a capability for reaching it.
- Live UDP demo host now uses the same published-set gate (no one-off equality check).
- Open Asks consent path left untouched — already correct.

## Files

| File | Why |
|------|-----|
| `granary/granary_core.rye` | `serve_resin_published` + `NotPublished` |
| `granary/resin_serve_delivery.rye` | Wire paths gated; unwelcome unpublished |
| `tools/granary_resin_wire.rish` | Assert unpublished refuse |
| `counsel/20260711-060112_…` | Full audit counsel |
| `work-in-progress/TASKS.md` | Audit row + Steep note parked |

**Recommend:** check in with Kaeden before adding the Steep hammock sentence (parks for word in TASKS); otherwise hold at tip **430**.
