# REDS shelf -- row %696, a ceiling declared four lines above the struct it was drawn for

**Language:** EN
**Status:** Shelf -- immutable once written; the living pin is [`../REDS.md`](../REDS.md)
**Style:** Gauge, Meter
**Voice:** Kyri
**Room:** Checkable -- one BOOKED row, landed straight onto its own shelf because the pin has no
room for it, its relative links re-anchored one directory deeper

Written `20260910`, in the lap that found and repaired the red. `construction/REDS.md` stood at
**40,954 bytes** against the **40,960** its own header declares -- **six** bytes of room, where this
row wants roughly 2,200. The lap tried the other door first and it closed twice: it folded `%687`
for room and a peer had folded the same row in the same hour, then folded `%690` and a peer folded
that one too, onto the very filename this lap had chosen. A BOOKED row may fold by the ledger's own
law, so a BOOKED row may be born here -- the move `%693` made three hours earlier.

---

**REDS %696 (`20260910.054213`) -- a ceiling declared four lines above the struct it was drawn for, and read by nothing.** *What went wrong:* `mantra/recall_subscribe_poll.rye` published `max_mirror_pairs: u32 = 4` directly above the `PeerBoltPair` it bounds, and `poll_one_cycle` walked `pairs.len` with no ceiling; `poll_cycles` then cast that length to `u32` unchecked. `tally/gardens.rye` held the milder form: `add` declared itself `!void` from `20260620` and returned no error at all, so every `try` at a call site was dead syntax and three edges stood on asserts a release build removes -- under an `// invariant:` claiming a *copy into a fixed buffer of max_name_len*, where the field is a slice and no copy was ever made. *What caught it:* an air lap walking the fence line, testing each boundary by pressing on it rather than reading its declaration. Across tracked `.rye` outside `vendor/` and `gratitude/`, **532 distinct `pub const max_*` names in 1,964 sources**, exactly **two** read by nothing anywhere: `max_mirror_pairs` and `lotus/mix.rye`'s `max_mix`, in two different lanes. *What it taught:* **a declaration is half a bound; the other half is a line that READS it where a caller can be turned away.** Fourth firing in four days: `%678`, `%688` and `%689` each stood a declaration further forward than its enforcement; this is the limit case, enforcement nowhere. *Repaired:* both poll functions refuse `error.Overflow` at the edge; `Gardens` publishes four named refusals weighed in one `admits`, called **before `divide` carves the parent** -- a refusal after the carve spends a parent's bytes on a garden nobody holds. *Proven:* [`../../tools/c/ceiling_teeth_witness.rish`](../../tools/c/ceiling_teeth_witness.rish) sorts each declared ceiling into the strongest thing its file does with it -- refused, structural, cut, derived, asserted-only, unread -- gates `unread` at zero and ratchets `asserted_only`; mantra and tally read **31 declaring: 25/3/1/1/1/0**, from 22/4/1/1/2/1. Thirteen behaviors in a git pen, the repair proven to LEAVE the population. **BOOKED** -- two instances gated; the remaining assert-only is `%678`'s own wire, and other lanes adopt by naming themselves in the roster row.

---

*The pin keeps what is open.*
