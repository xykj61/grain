# JABS — Sala broadcast live-session fold ladder

*Waymark for Sala as a broadcast surface: session-as-log → live carriage → audience + back-channel. Compresses the silo; never replaces it.*

**Status:** Checkable — operator compressor
**Depth:** guide
**Ceiling:** ≤80 lines
**Last updated:** 2026-07-17
**Compresses:** [`20260715-181500_sala-broadcast-live-session-fold.md`](../external-research/20260715-181500_sala-broadcast-live-session-fold.md)

---

## Thesis — the stream is the log

A broadcast is a fold over a signed, append-only, ordered log. Live carriage and audience chat are more signed facts in the same stream; the VOD is the log at rest.

**Waymark draw:** input `sala-broadcast-live-session-fold` · SHA3-512 · flw.txt → **JABS** (`tools/waymark_derive.rish`, `20260717.191030`). Bare `B0`–`B3` was the draft letter; **JABS** is the seated mark (same collision class as Genode’s B-ladder / bare letters).

## Rung table

| Rung | Claim | Witness / gate | State |
|------|-------|----------------|-------|
| **JABS0** | Session-as-log (signed ordered fold) | `sala_session_core` / B0 fold witnesses | **GREEN** (historical B0) |
| **JABS1** | Live carriage → one subscriber | `sala_b1_*` glass + delivery | **GREEN** · glass Pixel look |
| **JABS2** | Audience + back-channel (multi-signer chat) | `sala_backchannel_witness` · glass strip | **GREEN** device-free · glass Pixel `20260717.190807` · live chat · finish-zone row 13 only `20260717.213015` |
| **JABS3** | Inference and economics | B2 · Quin · MALA | open — check-in |

## Hands-on

```bash
# input_name = sala-broadcast-live-session-fold  (already seated → JABS)
rishi/bin/rishi run tools/waymark_derive.rish
rishi/bin/rishi run tools/sala_backchannel_witness.rish
rishi/bin/rishi run tools/sala_jabs2_glass_audience_witness.rish
```

---

*May every stream keep one log, and every ladder keep its own word.*
