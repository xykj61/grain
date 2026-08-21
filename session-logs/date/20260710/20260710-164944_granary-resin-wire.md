# Granary lap 4 — Comlink resin serve

**Editor:** Cursor · **Model:** Cursor Grok 4.5 · **Voice:** Rio 3
**Stamp:** 20260710.164944

**Prompt:** keep going

## Thinking

After in-process Sharing, the next keep-going item was Comlink federation for resins — Amphora fetch-by-digest transport reused (kinds 0x31/0x32), Granary apply on the guest. Ports **38496**/**38497**. Name-facts stay local; only resin bytes cross. Device wire and Exchange deferred.

Built `granary/resin_serve_delivery.rye` with selftest (seal round-trip + guest equals host + seal/digest refuse) and demo (host serves front_page, guest mirrors and renders Scribble).

## Observations

- Laps 1–3 and weave view still GREEN after version `164944`.
- Parity **236**. Exchange and Mandi still held.

## Files

- `granary/resin_serve_delivery.rye` · symlinks `vessel_fetch_wire` · `wire_format`
- `tools/granary_resin_wire.rish` · parity · comlink port map · docs

## Next

Recommend: keep going to rest — Sharing is hosted on the wire; Exchange (MALA/WOV listings) is the remaining Granary door and deserves its own gate; device wire can follow Amphora's virtio pattern when wanted. Mandi stays parked.
