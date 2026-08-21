# Dimeroll lap 1 + books view

**Stamp:** `20260710.130848`
**Editor:** Cursor · **Model:** Grok 4.5 · **Voice:** Rio 3

## Prompt

Focus on Realidream / Tablecloth / Brushstroke for a simple visual of existing SLCs, and create SLC **Dimeroll** — centralized money/tax/accounting like Kick and Digits, designs from public docs only.

## Thinking trace

1. Prior turn left Dimeroll design packet filed (`125953`) and code half-built; `dimeroll.rye` failed on wrong ArgIterator API and parse_int error-set mapping.
2. Fixed `main` to match `mala.rye` (`init.minimal.args.toSlice`); mapped parse overflow/invalid to `BadAmount`.
3. Lap-1 witness greened. Books view failed: `const c` shadowed `std.c`; comment-led journal blocks were skipped whole (first entry never folded); `std.fmt.parseInt` tripped the TAME parseInt ratchet.
4. Renamed debit/credit locals; skip only empty blocks (comment lines still skipped inside); switched to `tally_parse_int` via `rishi/parse_int.rye`.
5. Wired indexes (TASKS **22**/**23**, ROADMAP trio **208**, Visual Track rung 1, LEXICON already had Dimeroll), compass rose packet assert, doorway Status on hammock (`Checkable-room`).
6. Full `parity.rish` greened after doorway fix — Dimeroll lap 1 (**207**) + books view (**208**).

## Observations

- Visual Track lap for Dimeroll rides the same Skate path as Realidream thin view: Brushstroke surface, drawn-terminal headless witness — not full Realidream module, not Tablecloth v1, not Dexter graduation.
- Dimeroll complements MALA (mailable) with centralized books; Kick/Digits stay clean-room public-docs study only.
- Tablecloth remains the horizon store; lap 1 uses fixtures + in-memory fold.

## Files

| File | Why |
|------|-----|
| `linengrow/dimeroll_core.rye` | Chart, journal parse, trial-balance fold |
| `linengrow/dimeroll.rye` | Selftest binary (welcome + unwelcome) |
| `tools/fixtures/dimeroll_journal.bron` | Pinned journal for booksviewtest |
| `pond/apps/drawn_terminal.rye` | `booksviewtest` + fold → six Skate lines |
| `tools/dimeroll_lap1.rish` | Lap-1 witness |
| `tools/dimeroll_books_view.rish` | Books-view witness |
| `tools/parity.rish` | Stanzas for **207**/**208** |
| `tools/compass_rose.rish` | Dimeroll packet assert |
| `active-designing/20260710-125953_dimeroll-hammock.md` | Lap-1 hammock; Status checkable-room green |
| `external-research/20260710-125953_dimeroll-kick-digits-clean-room.md` | Clean-room study |
| `expanding-prompts/yonder/20260710-125953_dimeroll-lap1-books-view.md` | Expanding prompt — landed |
| `context/LEXICON.md` | Dimeroll row |
| `work-in-progress/TASKS.md` · `ROADMAP.md` | Priorities + Visual Track + trio **208** |
| Indexes | ER / AD / EP / linengrow READMEs |

## Next-step recommendation

Recommend: check in with Claude before Dimeroll lap 2 (tax package, bank sync, or MALA→journal bridge) — new domain width and product shape beyond written lap-1 policy; Tablecloth v1 / full Realidream stay horizon until Kaeden names the rung.
