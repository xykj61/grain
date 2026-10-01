# Petrichor -- the Wyoming PBC walkthrough reaches the Door ceiling

**Shelved:** `20261001.150500` -- **Status:** Archived, complete
**Living card:** [`../../../ITINERARY.md`](../../../ITINERARY.md)
**Prior account:** [`20261001-123622_itinerary-petrichor-wyoming-pbc-account.md`](20261001-123622_itinerary-petrichor-wyoming-pbc-account.md)
**Room:** checkable -- the report-card reading and its source remain below.

---

**THE YOURS ITEM NAMED A GRADE 3 OVER CEILING; THE REPAIR CLOSED IT.** The prior account left the
[Wyoming PBC walkthrough](../../../../docs-geode/edu/yonder/company/wyoming-pbc-walkthrough.md) at
`composite=85 (B+)`, `reach=70`, Flesch-Kincaid grade 12 against the Door ceiling of 9. The scanner's
own arithmetic (`grade = 0.39*(words/sent) + 11.8*(syllables/words) - 15.59`) names words-per-sentence
as the lever with the larger coefficient, so the repair split nearly every remaining long sentence
in the document -- the status header, the ground-law line, the worked-example paragraph, and all
eight stations -- into shorter ones, changing no statute cite, fee figure, or *verify* marker.

Two quoted legal lines (the public-benefit template, the RESOLVED consent line) carried their own
weight because a sentence boundary inside a closing quote mark does not split under the scanner's
rule (`[.!?]+[ ]`, which needs a space directly after the punctuation). Moving each into its own
block quote removed it from the prose count entirely, the same hold-out the haiku already use.

`qa_report_card.sh --setting door --service 90` now reads `register=96`, `reach=100` (grade 9
exactly, 711 words, 64 sentences), `truth=100`, `composite=97 (A+)`. `prose_register_scan.sh
--explain` still finds 3 honest negatives in 64 sentences, unchanged in substance (`none`, `never`
x2). No statute cite, fee figure, or *verify* marker moved; the two cross-reference links still
resolve.

**YOURS:** none -- the grade ceiling is met and the composite stands at A+.
