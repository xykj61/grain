# NS-L3 wire carriage counsel — anchor 041012 seated

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260706.041012

**Prompt:** Kaeden forwarded Claude's check-in on NS-L3 wire carriage (anchor `041012`) at parity 161 — counsel only, awaits Kaeden **proceed** before lap 1 build.

## Thinking trace

Claude's counsel crossed the Comlink module seam Cursor had flagged before wire carriage. The numbers were the first thing to verify: `wire_capacity` 528, `off_cipher` 188, so `max_message` is 340 bytes per sealed datagram; catalog resins may be up to 512 bytes. The witness bolt's `alpha` and `beta` leaves (five bytes each) fit one frame each — lap 1 can prove crossing without beading.

The ruling is clear: hosted-first request/response over existing sealed datagram shape (OA-L2 pattern); device wire lap 2; resin-batch frame + beading as lap 3w-3 follow-on rather than inflating `wire_capacity`. Vocabulary is fully seated — mechanical lap once Kaeden speaks.

Seated the counsel in the referential namespace brief (wire lap table, capacity constraint, invariants, proposed ports) and TASKS (parked item with proceed gate). No code — implementation waits for Kaeden confirm + **proceed**.

## Observations

- Sync semantics are proven in-process at parity 161; wire carriage reuses `open_asks_delivery`-style hosted UDP and virtio guests from OA-L2/OA-L3.
- Proposed ports: hosted 38478/38479, device 15561/15562 — sequential after OA-L2 (38474/38475) and OA-L3 escrow (38476/38477).
- Parked regardless: `stones/` → `resins/` path rename, OA-L4, MALA, settlement rail.

## Files

- `active-designing/20260706-023912_the-referential-namespace.md` — wire carriage counsel section, lap ladder split (logic 161 vs wire 3w-*)
- `work-in-progress/TASKS.md` — NS-L3 wire carriage parked task with proceed gate
- `session-logs/20260706-041012_ns-l3-wire-carriage-counsel.md` — this log
- `session-logs/README.md` — index row

**Recommend:** Kaeden confirms hosted-first, request/response lap 1 shape, and ports (or overrides), then says **proceed** — lap 1 is mechanical single-module work following seated counsel and OA-L2 patterns; beading/batch frame stays lap 3w-3 per ruling.
