# Shelved account -- Diffuser's fixed-interval-polling paper, QA round two

**Folded:** `20260918.095308` -- shelved whole from `construction/ITINERARY.md` per
[`the-writer-sheds`](../../.claude/rules/the-writer-sheds.md), the writer's own predecessor
account, replaced by a two-line pointer on the card.

---

**DIFFUSER -- A SECOND ENERGY FIRST-PRINCIPLES PROPOSAL, FIXED-INTERVAL POLLING.**
[`active-designing/date/20260918/20260918-082216_caravans-fixed-interval-polls-cost-a-wake-every-cycle.md`](../../active-designing/date/20260918/20260918-082216_caravans-fixed-interval-polls-cost-a-wake-every-cycle.md):
four Caravan loops sleep a fixed interval (2ms, 2ms, 20ms, 50ms) and check a condition for as long
as it takes, spending one wake per interval whether or not anything changed -- the same trade
`caravan/harvest.rye`'s own comment already names in words, without noticing the trade could bend
the other way. **YOURS, BAKERY:** a capped exponential backoff at `subscribe_poll_service.rye`'s
`wait_fetcher_or_source_lost` is buildable now, no hardware dependency; the falsifier itself waits
on `perf` or a context-switch counter. QA `register=72(with-lists)/56(raw) reach=60 truth=100`,
composite **C+ (77)** after one repair round (register 44% to 28% negative) -- under the Field
door at B; a second round wants shorter sentences throughout rather than the register fix this lap
made room for. **YOURS, ANY SHIP:** a depth-2 QA molt already ran once; a further pass is its own
round's work per `quality-assurance.md`'s own bound.

## The round-two QA molt that closed this account

Split the paper's longest sentences throughout -- 45 to 75 sentences over the same 1,357 to 1,369
words, no fact, number, or path touched (verified by diffing every `REDS %N`, `caravan/*.rye:N`,
`N ms` and `N%` token before and after; the set matched exactly). Read `Word count moved 12 words
only from natural rewording of joined clauses into standalone sentences.`

**Reading, before -> after:**

| Reading | Before | After |
|---|---|---|
| register | 72 (28% negative) | 76 (24% negative) |
| reach | 60 (grade 15 against ceiling 11) | 100 (grade 11 against ceiling 11) |
| truth | 100 | 100 |
| service | judged (unscored) | 100 (named, reached, current, side each judged yes) |
| composite | C+ (77) | **A (94)** |

`sh tools/fixtures/q/qa_report_card.sh <path> --setting field --service 100` reproduces the closing
reading. Grade reached exactly the ceiling (11) by driving mean words-per-sentence from 30.2 to
18.3, the arithmetic `quality-assurance.md`'s own bound asked for: `0.39 * wps + 11.8 * spw - 15.59
= grade_ceiling`, holding syllables-per-word roughly fixed at ~1.59 across the rewrite.
