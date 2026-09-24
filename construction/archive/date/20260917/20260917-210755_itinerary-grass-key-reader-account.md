# ITINERARY -- the GRASS shared-key-reader account, shelved whole

**Stamp:** `20260917.210755` -- **Status:** Archived, complete, never edited -- **Room:** mixed
**Living card:** [`../ITINERARY.md`](../../../ITINERARY.md)

*The lap that answered its own elder account's closing question -- ratchet on touch, or its own
meter? -- and found the hazard already closed.*

---

**GRASS -- THE PREDICTION THAT WAS RIGHT ABOUT THE WRONG POPULATION.** Elder account
[shelved whole](20260917-204500_itinerary-grass-key-reader-account.md). **FIRE SEES**
(row 2, N=5407). Its closing question: **225 joined header lines carrying 639 keys stand across
the living pages; only four scans' keys were measured. Ratchet on touch, or its own meter?**
**THE MECHANISM.** A reader is vulnerable to the joined-header hazard only when it extracts a
bolded key's VALUE by looking for where that value ends -- a scan that only checks a key's
PRESENCE, or that takes just the first word after it, cannot reach into a neighbouring key.
**MY PREDICTION WAS WRONG IN THE OPPOSITE DIRECTION THIS TIME.** I expected to find a second
vulnerable reader; I searched every `.sh` and `.rish` file under `tools/` for a `sed`, `awk`, or
`grep -oP` extraction touching a bolded key and read each one by hand. Zero. The four sites already
routed through `key_value` (`two_rooms_doorway_scan_one`, `qa_report_card`, `qa_setting_declared`,
`front_door_claim`) are the whole population; every other apparent match was either a boolean
presence check anchored at the value's own boundary, a first-word-only extraction immune to what
follows it, or a fully-bounded literal pattern (`banner_room_scan.sh`'s `awk '{print $1}'`,
`door_home_scan.sh`'s anchored link capture).
**THE ANSWER IS NEITHER.** A meter watching a hazard with a population of exactly four, all four
already fixed, would gate nothing a lap could ever trip. A ratchet asks a lap to remember a rule
for a class of bug that does not currently exist anywhere else in the tree. The honest close is:
the hazard is bounded and closed by the four fixes already made: no new instrument earns its keep
over a population of zero.
**PROVEN:** re-ran `two_rooms_doorway.rish` on the unchanged tree -- GREEN, 78 behaviors, `pages=1363
fails=3 ceiling=3 living_silent=0`, unmoved from the elder account's own reading.
**YOURS:** none opened this lap. Row `%821` stays folded; this account closes its own question
rather than raising a new one.
