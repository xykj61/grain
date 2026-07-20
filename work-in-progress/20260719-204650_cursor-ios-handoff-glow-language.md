# Cursor iOS Handoff — Glow Language Season (no adb)

*Keaton is pausing the Framework 16 host for a while. Cursor iOS (or any Cursor cloud sandbox) takes the next language laps with the same model and rhythm. USB/adb is unavailable in that sandbox — prioritize Glow language TAME crafting and solidifying.*

**Language:** EN  
**Stamp:** `20260719.204650` (Eastern)  
**Voice:** Quin  
**Model for this season:** **Cursor Grok 4.5 300k High Fast** (match Framework host; do not silently switch)  
**Status:** Intent — living handoff; refresh REMEMBER when nibs move  
**Style:** Radiant  

---

## Who you are

You are **Quin**. Read `context/QUIN.md` · `context/RADIANT_STYLE.md` · `context/TAME_GUIDANCE.md` · `.cursor/rules/*.mdc` (especially `send-word`, `session-logs`, `vocabulary-nib`, `waymark-ladders`, `collaboration`).

- **nib** = landed edge (product · suite · git) — not *tip* in living prose  
- **kg** = keep going on a mechanical lap — not commit  
- **send** = commit · push · merge (GPG on; session log rides along)  
- **align** / **remember** = their rules when Keaton says those words  

---

## Where the tree is (as of this stamp)

| Nib | Value |
|-----|--------|
| **Language** | **STOA0–89 GREEN** · STOA90 open (check-in offered, not yet approved) |
| **Git** | `50dbdb3af0` on `main` (after STOA89 send log) — refresh with `git rev-parse --short=10 HEAD` after pull |
| **Product / glass** | ZETA6 · LULU0–5 · SETU6.5 · HOLD* GREEN — **do not prioritize device work on iOS** |
| **Seat just landed** | STOA89 — rune pronunciation alphabet · fixture desk vs generator · RISC-V notes |

**Pull first:** `git pull origin main` (also `codeberg` if that remote is wired). Working branch should be `main`.

### Canon just seated (read these)

1. [`../active-designing/20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md`](../active-designing/20260719-204001_glow-rune-pronunciation-alphabet-riscv-and-generators.md) — alphabet YES; fixture desks today; generators horizon; roadmap **G0–G5**  
2. [`../expanding-prompts/20260719-204001_glow-fixture-desks-and-parameterized-generators.md`](../expanding-prompts/20260719-204001_glow-fixture-desks-and-parameterized-generators.md) — Acme wording  
3. [`../active-designing/20260719-204650_hoon-core-polymorphism-tame-and-port-order.md`](../active-designing/20260719-204650_hoon-core-polymorphism-tame-and-port-order.md) — **dry cores YES · wet/gold HOLD · port order L→R→G**  
4. [`../glow/README.md`](../glow/README.md) · [`../docs/STOA.md`](../docs/STOA.md) · [`../work-in-progress/REMEMBER.md`](REMEMBER.md)  
5. [`../context/LEXICON.md`](../context/LEXICON.md) — **Fixture desk** · **Generator** · **Sample** · **Glow gate** · **Rune alphabet** (bare **Gate** = itinerary)

---

## Sandbox constraints (Cursor iOS / cloud)

| Have | Do not expect |
|------|----------------|
| Tree clone · `rishi` after toolchain raise · Glow lowers · witnesses that are device-free | `/dev/bus/usb` · `adb` · Pixel install · HAWM boot |
| `manual/guides/cloud-agent-toolchain-setup.md` if Zig/Rye missing | Framework host GPG key reuse without setup |

**Priority order for this handoff season:**

1. Glow language TAME (STOA) — craft, solidify, complete rungs  
2. Docs synced to behavior (TAME root rule 9)  
3. Device / SETU / Pixel eyes — **defer to Framework outer terminal** when Keaton returns  

---

## STOA90 — check-in already offered (await Keaton approve)

Recommended lean **A** from pin `20260719.204340`:

| Lean | Claim |
|------|--------|
| **A** (recommended) | Closed pronunciation table for every **GREEN** Glow rune head — roadmap **G1** |
| B | Thin parameterized generator — one `@u32` sample from Rishi argv (**G3**) |
| C | Token-driven lower slice |
| D | TAME tidy `lower_mold` |
| E | Sala B0 rewrite |

If Keaton says **approve** / **kg** / **send and approve next rec** without naming a lean, take **A** unless this handoff or a newer pin redirects.

After A: G2 (TAME alphabet pin grow) is natural kg; G3/G4 when he wants code seams.

---

## New design seated this handoff — cores & port order

**Question:** Does Hoon core polymorphism fit Glow TAME? How to port vanes/userspace?

**Answer (seated):**

- **Dry** bartis / `|%` / bounded `|-` / explicit molds — **fit**; keep growing under expansion asserts.  
- **Wet / gold** polymorphic cores — **hold** until nest/type can check at expansion.  
- **Port order:** Phase **L** language (now) → Phase **R** keep vanes in **Rye + TAME** (Pool etc. already green) → Phase **G** Glow-rewrite a module only when fixture desks cover every head.  
- First Glow userspace target later: one thin Pool agent arm with a Rye twin — never dump `old/` Hoon line-by-line.

Full brief: [`../active-designing/20260719-204650_hoon-core-polymorphism-tame-and-port-order.md`](../active-designing/20260719-204650_hoon-core-polymorphism-tame-and-port-order.md).

---

## How to work a language lap (rhythm)

1. Check-in with 3–5 leans (A recommended) when opening a new STOA rung — unless Keaton already approved.  
2. Implement thin; witness GREEN (`rishi/bin/rishi run tools/…`).  
3. Desk suite when desks change: `tools/glow_run_desk_witness.rish`.  
4. Update `docs/STOA.md` (≤80 lines — merge rows), `TASKS.md`, `ROADMAP.md`, `glow/README.md` on touch, `REMEMBER.md` on pin.  
5. Bron session log + README index; **send** on Keaton's word (origin + codeberg).  
6. Style roster hard ceiling **256** files for Rishi `where` lists — do not dump whole `glow/` onto one roster.

### Smoke commands (device-free)

```bash
rishi/bin/rishi run tools/glow_lower_assert_witness.rish
rishi/bin/rishi run tools/glow_tokens_witness.rish
rishi/bin/rishi run tools/glow_run_desk_witness.rish
```

### Pitfalls already earned

- Named-cast / cross-desk peeks must win before mold-only `glow_run` dispatch.  
- Reused lower buffers: write each welcome `.rye` before the next lower.  
- Zig reserved: no field named `test` in rune structs.  
- Commit messages: no bare `@memcpy`-style Zig builtins (linkify risk).  
- `docs/STOA.md` ≤80 lines.  
- Lexicon **Gate** ≠ Hoon gate.

---

## Transcript / prior agent

Framework session transcript (if needed): agent id `caef0084-89b7-4416-b1f2-87a2abb365cf` under Cursor agent-transcripts. Prefer tree docs over rediscovering from chat.

---

## First message template (paste on iOS)

```
Quin — Cursor Grok 4.5 300k High Fast. Pull main. Read work-in-progress/20260719-204650_cursor-ios-handoff-glow-language.md and REMEMBER.md. No adb — Glow language TAME only. STOA90 lean A (pronunciation table G1) unless I redirect. Also honor the cores/polymorphism + port-order brief seated this stamp. Session logs Bron; send when I say send.
```

---

## Open doors (language-first)

| Door | Kind |
|------|------|
| **STOA90** G1 pronunciation table | **check-in** (lean A recommended) |
| G3 argv sample · G4 token-driven lower · tidy mold | later STOA |
| Wet/gold core polymorphism | **held** — design brief |
| Glow-authored Pool agent | Phase G — after language |
| Pixel / SETU adb | Framework host only |

---

*May the phone carry the language season cleanly, and may the Framework host rest until USB is welcome again.*
