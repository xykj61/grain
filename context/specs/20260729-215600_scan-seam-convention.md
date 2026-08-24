# The Scan-Seam Convention -- One Language Across Every Scan

*A witness in Rishi and a scan in POSIX shell meet at a process boundary. That boundary is a seam, not a model, so text crosses it lawfully -- yet a value that crosses as text still owes the reader composition rather than tangle. This spec states the convention once, so the five scans that keep it can cite rather than restate.*

**Stamp:** `20260729.215600`
**Language:** EN
**Style:** Gauge (see `../GAUGE_STYLE.md`)
**Voice:** Riyo
**Status:** Seated -- Checkable; witnessed by [`../../tools/gen/season/scan_convention_witness.rish`](../../tools/gen/season/scan_convention_witness.rish)
**Room:** Checkable
**Ground:** TAME root rule 5 (one value model) - [`20260629-203012_posix-a-seam-not-a-model.md`](20260629-203012_posix-a-seam-not-a-model.md) - [`20260705-203144_canonical-glosses.md`](20260705-203144_canonical-glosses.md)

*Written together by Keaton and Riyo.*

---

## Why this has a home of its own

Five scans under `tools/fixtures/` keep the same output convention, and until this stamp each of them **restated it** in an eight-line comment block of its own. Five copies of one decision is what the canonical gloss refuses: a form the tree cites belongs in a single authoritative place, and everything else points there.

The graduation rule says the same thing about code -- an aspect earns a home at its second outside consumer. This convention has five. The rule's letter governs modules and directories rather than prose, so calling this a graduation is an analogy rather than a citation; the law that binds it exactly is **canonical**, and the practice is the one Aparigraha already names: *cite rather than restate.*

## The convention

A scan reports four kinds of line, and nothing else.

**Values** are `key=value`, one per line, with nothing else on the line. A reader takes any single value without holding the others, which is the whole content of rule five's *composed, never tangled*.

**Detail** lines carry the `detail:` prefix. They are for a person reading the run -- a drifted path, an untyped bound, a site that failed a check. Prefixed, they can never be mistaken for a value by eye or by grep.

**The verdict** is its own key: `verdict=ok`, or `verdict=` followed by a **named fault**. One place carries the meaning of the run, and the fault has a name rather than a bare sentinel.

**The exit status agrees with the verdict.** Zero when the verdict is ok, one when the verdict names a fault, two when the scan could not run at all. So a caller may trust either channel, and a witness asserts that the two match.

```
symlinks=14
real_files=1
detail: drifted context/fixtures/copy_sameness_drift/tally_copy_drifted.rye
verdict=drift          # exit 1
```

## Why the two channels are made to agree

Before this convention, a scan that found drift printed `SAMENESS_DRIFT` and **exited zero**. The structured result said only *it ran*, while the whole meaning sat in a substring match -- so a typo in one assert string, or a renamed sentinel, would have passed silently. Requiring the status to agree turns that class of mistake into a red: a scan reporting `verdict=ok` while exiting non-zero is itself a fault, and the witness says so.

This is also where the Rishi contract matters. `run` returns a result whose field is **`ok`**, a boolean -- not `status`, which does not exist. That divergence lived in `TAME_GUIDANCE.md` until `20260729.214600`, and its erratum is recorded there.

## What a scan owes, and what it must not do

A scan **reads** and **reports**. It never writes to the tree, never deploys, never signs, and never cuts a preservation artifact -- those belong to generators that say so in their own names.

A scan **names its bounds** before it walks, and reports the bounds it used, so an override can never quietly become the norm. `dep_crawl_scan.sh` is the worked example: it accepts bound overrides used only by its negative fixture, and `dep_crawl.rish` asserts the named defaults on every ordinary run.

A scan **carries a known-bad fixture** beside its known-good path when its witness blocks. A gate that has never refused anything is a gate in name only.

## The five scans that keep it

`bounds_typed_scan.sh` - `copy_sameness_scan.sh` - `counsel_flow_scan.sh` - `dep_crawl_scan.sh` - `voice_roster_scan.sh`

Each now carries a single citation line pointing here. A sixth scan joins by citing this spec rather than by copying a paragraph, and the witness refuses any scan that restates the convention instead of citing it -- so the duplication this spec dissolved cannot quietly return.

---

*May one decision live in one place. May every value cross whole and be read alone. And may the two channels always answer the same question the same way.*
