# STOA216 — Cord Literal Lex (C1)

*An Acme Corporation employee reading this gets the first Glow source-literal token: a single-quoted cord `'…'` with a named interior bound.*

**Language:** EN  
**Version:** `20260721.194941` (UDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — GREEN `20260721.194941`  
**Register:** Checkable (Two Rooms) — lex GREEN; parse/lower/desk pin held  

**Grounds in:** sub-lean **C1** in [`20260721-194941_stoa215-glow-source-literals-inventory.md`](20260721-194941_stoa215-glow-source-literals-inventory.md) · STOA180 `@t` · STOA209 bound 1024

**dated_guard:** Do **not** claim desks parse or lower cord literals yet. No escapes this lap. JABS3 held.

---

## Verdict (one breath)

**CORD_LIT_LEX.** `Kind.cord_lit` · `lex_cord_lit` · `cord_lit_interior` · `max_cord_lit_bytes = 1024`. Witness GREEN including empty and unclosed refuse.

---

## Witness

```bash
export RYE_ZIG=vendor/zig-toolchain/zig
rishi/bin/rishi run tools/glow_tokens_witness.rish
```

---

## Hold

Hex lit (C2) — landed as **STOA217**. Parse face=`lit` (C3). Lower emit (C4). Fixture desk pin (C5). Escapes.
