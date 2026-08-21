# Amphora large-resin chunking

**Editor:** Cursor · **Model:** Grok 4.5 · **Voice:** Rio 3
**Stamp:** 20260710.154300

## Prompt

keep goin

## Thinking trace

After Amber vessel seal (parity **228**), the named horizon was large-resin chunking beyond one datagram. Followed the NS-L3 batch chunk pattern already on metal: keep single-frame kind **0x32** for small resins; add kind **0x33** chunk frames with digest · index · count · total · body; `ResinAssembler` reassembles before digest verify.

Raised assembled ceiling to **1024** B; single-frame body stays under Comlink `max_message` (**340**). Hosted `chunkdemo` moves a **400** B resin; pour → fetch → scrub witness uses `amphora_chunk_tree`. Device wire stays on small single-frame fixtures this lap.

## Observations

- Chunking is wire carriage only — vessel seal and stamp unchanged.
- Tampered last chunk refuses assembled digest verify.
- Lap 3 small-resin path stays GREEN beside the new witness.

## Files

- `amphora/vessel_fetch_wire.rye` — kind **0x33**, `ResinAssembler`, chunk selftest
- `amphora/vessel_fetch_delivery.rye` — multi-datagram send/recv + `chunkdemo`
- `tools/fixtures/amphora_chunk_tree/` · `amphora_chunk_witness.sh` · `tools/amphora_resin_chunk.rish`
- `tools/parity.rish` — parity **229**
- `amphora/README.md` · TASKS · ROADMAP · crossing plainly notes
- `session-logs/20260710-154300_amphora-resin-chunk.md` · README index

## Next-step recommendation

Recommend: keep going to Pond customs policy at Amphora receipt — first policy lap in Pond's own room, now that seal, stamp, and chunked carriage sit on the vessel.
