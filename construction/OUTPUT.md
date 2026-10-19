# OUTPUT -- what landed and stayed

Append-only. One row per landed output. Newest first.
Four fields: **kind** - **path** - **git nib** - **note**.

Kinds: `witness` `module` `predicate` `docs-page` `tool` `room` `context` `ww-push`

Design: `active-designing/date/20261018/20261018-224923_output-vs-activity-open-question.md`
Opened: `20261018.225249`

---

## 20261019

**docs-page** `composition/20261019-002845_calfive-plans-seven-kinds.md` `d10402eef4` -- seven kinds of Calfive work named: language, product, identity/network, surface, hardware, creative suite, long return

## 20261018

**context** `context/styles/lib/` `66dde40549` -- rota revitalization: `composition.md`, `page-header.md`, `section-names.md`, and `order.md` seat the shared library shape for context/ voices and styles

**tool** `construction/OUTPUT.md` `6db8253a30` -- output ledger opened; append-only, four fields, eight kinds, seeded with twelve rows; the ratio is now measurable

**predicate** `scribe/reader.rye` `34d0155c24` -- `has_rota` and `has_loom` close the single-strand gap; shape validated in Rye, cited in scan scripts

**context** `context/KYLI_7.md` + `context/KYRI.md` `ee895f7d39` -- Kyli 7 shared style library seated; composed voices (Kyli, Gauge, Bhakta, Teacher) in one file

**room** `study/` `51a4a1dd4c` -- study room opened with gate (three conditions), manifest, and texts/ directory module

**docs-page** `docs-geode/study/` `4bdf9e5f50` -- study room gate taught with template; graded at Door setting

**room** `composition/` `cbcada32c3` -- Kyli's journal room opened; first entry written; second entry added at `3e6e873b`

## 20261018 (earlier)

**tool** `tools/t/tame_style_check.rish` + friends `295eae5e3b` -- Zig 0.17.0 pinned in fetch scan constant and its callers; toolchain stays current

**docs-page** `docs-geode/lessons/` `450cffc693` -- eight lessons, twelve moonshots, one spell; Door graded

**witness** `glow/chain_witness.sh` `c8a9d53698` -- glow lower-refuse-compile-run chain witnessed GREEN

## Recent weeks

**module** `scribe/dashboard.rye` `748a84bbcd` -- Scribe dashboard reading room; dispatches Kyri docs by format through reader.rye; zero new type knowledge, clean composition

**module** `scribe/reader.rye` `75da0b2f91` -- canonical Kyri reader seated; zero-copy parser, format dispatcher, six archetype validators, `is_session_log`, `is_baton`, `is_inventory`

**witness** `tools/s/scribe_reader_witness.rish` `75a9b04e43` -- scribe reader witness; proves planted baton crosses disk seam; wrong-format and oversize refuse by name

**module** `tally/kumara.rye` `fda5a4b03e` -- `sign_checked` added; a mismatched Kumara pair refuses on `KeyMismatch` before it reaches the caller

**docs-page** `docs-geode/` (permissioning) `aec7b8341d` -- depersonalized tutorial on permissioning and Constels; Door graded

**module** `glow/` (Zig-identifier rule) `482b34df97` -- Zig-identifier rule written once, not twenty-nine times; cited by each glow module that needed it

---

## How to append

Add a row above the `---` at the bottom, or under the day heading if today has one already:

```
**<kind>** `<path>` `<10-char git nib>` -- one line saying what it proves or teaches
```

Run `git rev-parse --short=10 HEAD` for the nib after the commit lands.
No gate. No witness required to append. The ledger earns its reader when it has rows.
