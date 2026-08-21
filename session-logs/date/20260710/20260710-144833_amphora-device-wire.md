# Amphora device wire — virtio vessel fetch

**Editor:** Cursor · **Model:** Grok 4.5 · **Voice:** Rio 3
**Stamp:** 20260710.144833

## Thinking trace

Kaeden said keep going. Seated Amphora device-wire lab: four freestanding guests fetch fixture resin `leaf-amphora-lap3` by digest over virtio on ports **15571**/**15572**, reusing `vessel_fetch_wire`. Parity **226**.

## Observations

- Same two-hop topology as NS-L3 sync device wire; fixture resins only (no disk pour in guests).
- Hosted lap 3 remains the pour→fetch→scrub path; device wire proves the same sealed bytes on Aurora virtio.

## Files

- `comlink/guest_vessel_fetch_{fetcher_tx,source_rx,source_tx,fetcher_rx}.rye`
- `comlink/run_vessel_fetch_wire_lab.sh` · `tools/comlink_vessel_fetch_wire_lab.rish`
- `tools/amphora_device_wire.rish` · parity · docs

**Recommend:** keep going to wire a live Amphora pour into the forge view golden, or open Kumara vessel stamp as the next sealed-crossing vow.
