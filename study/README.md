# Study -- held texts, kept with care

**Language:** EN
**Stamp:** `20261018.220000`
**Voice:** Kyri
**Style:** Radiant -- Gauge at Door setting
**Status:** Living
**Room:** research for understanding

---

This room holds outside texts kept for study. A text enters only when its own license says it may
be held without strings. The room sits in the field's reading room, beside `external-research/`
(which holds our notes about the world) and `gratitude/` (which thanks the work we learned from).
`external-research/` holds what we wrote; this room holds what we read.

## The gate

A text enters only when all three hold:

1. **It is public domain, or dedicated to the public.** The license names that in its own words at
   its source -- a Public Domain Mark or CC0, or public domain by age.
2. **It has no share-alike condition.** A CC BY-SA text is refused even when it reads beautifully.
3. **It has no non-commercial condition.** A CC BY-NC text is refused because the project may be
   used commercially.

A text with no clear license is refused. A translation counts as its own work, so a public domain
original with a copyrighted translation is refused unless the translation passes the gate too.

## What each entry records

Each entry in [`MANIFEST.md`](MANIFEST.md) records, before anything is stored:

- the source URL and the page it came from
- the license text as published there, quoted in full
- the date it was retrieved, on the one clock
- the SHA-256 of the file as stored here, once a file is stored
- the reason it passes the gate

Refusals keep their own record in [`refusals/`](refusals/) so a later reader can see why a text
is absent.

## Structure

```
study/
  README.md       -- this gate description
  MANIFEST.md     -- table of accepted texts, one row per text
  texts/          -- one subdirectory per accepted text
    <name>/
      <file>      -- the text itself (untracked by default; large binaries stay off git)
      study-note.md  -- our own notes on the text
      SHA256SUMS  -- checksum of the stored file
  refusals/       -- records of texts the gate declined
```

Large binary files (PDFs, epubs) are untracked by default -- held on disk, verified by checksum,
kept off the seed and off `ww` unless explicitly admitted.

## Status

No texts admitted yet. The room is open for its first entry.

*May the texts we hold teach us well, and may the ones we refuse stand honored in the refusals.*
