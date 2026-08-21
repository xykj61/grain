# Surface Season p24 — `.brush` Parser TAME Tidy

**Stamp:** `20260728.212328` · **Voice:** Quin · **Season:** Surface · **Scope:** sept · **Round:** p24  
**Prior:** [p23 parser begun](20260728-211918_surface-season-p23-brush-parser-begun.md)  
**Ask:** waymark p23 complete / p24 next · *I'm not seeing TAME guidance in the code you're writing*

## Verdict

**p24 LANDED.** Honest catch — p23 opened the parser without the hosted-Rye TAME density this tree expects. `brushstroke/brush_parse.rye` is retidied: opening triad named · every assert wears `// invariant:` · functions split under the long-fn ratchet · `u32` counts via `slice_len_u32` at the usize seam · refuse paths use `|err|` capture (no call-seam `) == error.`) · named bounds (`max_frame_lines` · `max_brush_bytes` · `max_pin_bytes`). Witness pins ≥20 invariant markers + triad + ban-clean + width helpers.

## Choir

`brush_parse_witness` — build · selftest · seed-frame · **TAME density**.

## What changed

| Before (p23) | After (p24) |
| --- | --- |
| One long `parse_brush` | `scan_brush_pins` · `finish_brush_surface` · `take_pin` · `count_frame_line` |
| Sparse postcondition asserts | Contract asserts with `// invariant:` throughout |
| `assert(refused == error.…)` | `if (parse…) |_| unreachable else \|err\| assert(err == …)` |
| Raw `.len` in authored arithmetic | `slice_len_u32` seam helper |

## What this round does *not* do

No paint · no Wayland · no Skate lower · no second fixture language · no live-five · no O3 · no shred.

## Next

**p25** — grow refuse suite · thin lower toward Frame · more pedestals · or live-five on his word.

---

*p24 · stamp `20260728.212328` · Quin · TAME visible in the parser body*
