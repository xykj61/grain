# Session Log — Ames, Vere, libuv Study and Carriage Silo

**Stamp:** `20260706.022912 UDT` (Kaeden's clock)
**Editor:** Claude (bench) · **Model:** Claude
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Season:** Linengrow-via-Comlink · Open Asks
**Base tip reported by the bench:** `2252109` (parity 158)

---

## What This Bench Did

This bench answered a research-and-silo question with docs, not code, and left the parity suite untouched at 158. Kaeden asked whether Urbit's Vere runtime still rides libuv today, what the Ames vane actually is, and whether libuv's datagram model is worth emulating for Comlink under TAME — and then asked to silo the lessons into a foundation that strengthens how Comlink's carriage is described.

The current facts were checked against live sources rather than recalled. Vere is still Urbit's standard C runtime and still rides libuv: its host structure carries a libuv loop handle and its boot starts `uv_run`, the library's own event loop. The Rust effort, Sword formerly Ares, is a Nock-execution runtime beside Vere, not a libuv replacement at the socket. Ames was read precisely: an encrypted peer-to-peer overlay over UDP where the address is the identity bound to a public key, with a clean seam between the networking vane and the runtime that carries the bytes, exactly-once transactional messages, end-to-end acknowledgments, whole-and-quiet refusal at the crypto boundary, and a Reno-family congestion control. The axis where Ames and Comlink differ was named plainly: Ames is identity-and-message-centric, while Comlink is content-centric by digest, so the lessons taken live on the carriage-and-reliability axis and content-centrism stays ours.

## The Verdict

Study libuv and Ames; adopt neither. libuv is C, our carriage grows in our own languages on proven ground, and both halves of our own problem are already answered — the hosted side on the toolchain's threaded input-output, the freestanding side directly on virtio with no operating system beneath it. So the study sharpens our own design rather than adding a dependency. libuv earns a gratitude note beside Urbit, studied and not linked, with its license honored and no source vendored.

## What Landed in the Bundle

- `external-research/20260706-022912_ames-vere-libuv-content-carriage.md` — the open study, cited, with the study-not-link verdict.
- `foundations/20260706-022912_the-wire-serves-the-fold.md` — owned carriage first-principles: the record is sovereign and the wire serves it; one logic and many wires; identity is the address; a fact arrives whole or not at all; reliable carriage is transactional and waits its lap; everything is bounded; mechanical sympathy close to the metal.
- `gratitude/libuv.md` — the study-only teacher note.
- Index rows in `external-research/README.md`, `foundations/README.md`, and `session-logs/README.md`.
- The apply prompt in `expanding-prompts/` and this log.

## What Waits on Kaeden's Word

Nothing here changes code, so parity stays 158 and no count is re-pinned. Vendoring libuv's full source into gratitude is a heavier add left for Kaeden's word. A Comlink reliability lap and a flow-control lap are witnessed laps to grow later from the principles named here, not built now. OA-L4 reputation-as-fold and the MALA M0 design lap remain parked, awaiting Kaeden's vocabulary. Existing Comlink files kept their names and stamps; the silo is the carriage-documentation improvement, cross-linking rather than renaming, and no timestamp was computed.

---

*May the study land clean and the lessons take root. May the record stay sovereign and the wire stay humble. And may the carriage we grow be quiet, bounded, and true.*
