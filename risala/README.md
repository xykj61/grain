# Risala -- A Siloed Study Library for Classical and Quranic Arabic

**Where this sits:** home is [`../README.md`](../README.md) - siloed study libraries sibling
[`../shastra/README.md`](../shastra/README.md), [`../classical-vedic-astrology/README.md`](../classical-vedic-astrology/README.md),
and [`../cubist-bhakti-astrology/`](../cubist-bhakti-astrology/)

**Language:** EN, with Classical Arabic script and scholarly transliteration as the actual subject
of study
**Last updated:** 2026-09-20
**Style:** Gauge Field (see `../context/GAUGE_STYLE.md`), Bhakta register throughout (see
`../context/BHAKTA_STYLE.md`) -- this room assumes no prior Arabic
**Stamp of founding:** `20260920.131450`

---

**Risala** (رسالة, plural *rasa'il*) is the plain Arabic word for a treatise or epistle -- the
direct semantic counterpart to Sanskrit **shastra**, and chosen the same way: under
`.claude/rules/comlink-tendency.md`'s three tests (clear, fun, safe).

## Why "risala" over the other candidates on the table

Three names were on offer, and each was tested and set aside for a plain reason:

- **`ihya/`** names one book -- al-Ghazali's *Ihya' Ulum al-Din* ("The Revival of the Religious
  Sciences") alone. Naming the room after one book would honestly hold that book and only that
  book, the same way `shastra/` chose its own name over `veda/` to keep the room's name matching
  the corpus it actually holds -- and this room is meant to grow toward Ibn 'Arabi's *Fusus
  al-Hikam*, the *Tafsir al-Jalalayn*, and Wright's grammar besides.
- **`shaykh/`** ("sheikh") names the *person* -- the master, teacher, and title Ibn 'Arabi himself
  earned as **al-Shaykh al-Akbar**, "the Greatest Master." That word fits a *role* best.
  `shastra/` keeps the same distinction, naming itself for what it holds rather than for
  `acharya/`, the one who transmits it -- a library is named for its shelf, a teacher for their
  seat.
- **`turath/`** ("heritage, classical patrimony") is the broadest honest word for the whole
  classical Arabic and Islamic corpus, and stays a live option if this room ever widens past
  treatise-and-commentary into poetry, history, and law. It was set aside here only because
  **risala** matches *shastra*'s own sense -- a treatise -- word for word, and a sibling room reads
  clearest when its name answers the same question its neighbor's name does.

**The role-word, kept rather than dropped:** where `shastra/`'s glossary defines *acharya* as the
one who transmits a treatise, this room's glossary (below) opens with **shaykh** -- the Arabic
teacher-title doing the same job, and the honorific Ibn 'Arabi himself carries.

## An ASCII-first exception, named plainly

`.claude/rules/ascii-first.md` asks new documents to stay in plain 7-bit ASCII, and names its own
exception: *a specific, explicitly-named set of work rounds may use non-ASCII when it is the point
of the work -- a Unicode-handling module's own test fixtures, an internationalization surface.*
**This whole room is that exception.** Arabic script is the subject being taught, not decoration,
and the scholarly transliteration marks (macrons for long vowels, dots under emphatic consonants --
*ā ī ū ṣ ḍ ṭ ẓ ḥ ʿ ʾ*) are the IJMES-family convention every source cited below already uses. English
prose elsewhere in this room still holds the ordinary ASCII substitutions -- `--` for a dash, plain
quotes, `...` for an ellipsis.

## Verified -- checked by direct fetch, 20260920

A curriculum draft for this room named four public-domain sources. Per
`.claude/rules/docs-implementation-sync.md` ("assert it, don't assume it"), each was checked
against a live source rather than kept on the strength of the draft alone.

| Source | Status | Where |
|---|---|---|
| **Tafsir al-Jalalayn** (al-Mahalli and as-Suyuti, translated by Feras Hamza) | Confirmed. Commissioned by the Royal Aal al-Bayt Institute for Islamic Thought (Jordan) for its Great Tafsir Project; hosted at [altafsir.com](https://www.altafsir.com/Al-Jalalayn.asp) and as a standalone PDF at [rissc.jo](https://rissc.jo/tafsir-al-jalalayn/). | Classical Arabic text centuries old, public domain; the modern English translation carries its own institutional publication |
| **Edward William Lane's Arabic-English Lexicon** (1863-1893) | Confirmed. Digitized whole by the Perseus Digital Library at Tufts -- [perseus.tufts.edu, the Lane collection](http://www.perseus.tufts.edu/hopper/collection?collection=Perseus%3Acorpus%3Aperseus%2Cwork%2CLane%2C+An+Arabic-English+Lexicon) -- and again at [archive.org](https://archive.org/details/LANESARABICENGLISHLEXICONDIGITIZEDTEXTVERSION) and [lanelexicon.com](https://lanelexicon.com/) | Fully public domain, eight volumes |
| **William Wright's A Grammar of the Arabic Language** (1859/1896, after Caspari) | Confirmed. Multiple public-domain scans on [archive.org](https://archive.org/details/AGrammarOfTheArabicLanguageV1) | Fully public domain, the standard 19th-century comparative Semitic grammar in English |
| **Quranic Arabic Corpus** (Kais Dukes, University of Leeds) | Confirmed. Live at [corpus.quran.com](https://corpus.quran.com/), word-by-word morphological and syntactic annotation of all 77,430 words of the Quran, released under the GNU Public License | Open-access, ongoing project |

All four claims from the curriculum draft held up. **One nuance the draft left unflagged**, worth
recording rather than silently correcting: whether the noun *ism* ("name") derives from the root
س-م-و (*s-m-w*, "height, elevation") or from و-س-م (*w-s-m*, "mark, sign") was a live dispute
between the Basran and Kufan grammatical schools; the *s-m-w* derivation the draft gave is the
majority and pedagogically standard reading, not an uncontested settled fact.

## What lives here

```
risala/
+-- README.md          this bibliography and its verification note
+-- lessons/            one file per lesson, numbered, single-stranded
    +-- 01-brahman-paramatman-bhagavan-and-prema-bhakti-in-three-arabics.md
```

Single-stranded, same as `shastra/`: one file answers one question, and a lesson earns its own
file rather than folding into a growing index. As study continues, later lessons on morphology,
syntax, and the Tafsir al-Jalalayn's own method each get their own numbered file in `lessons/`.

## A caution this room keeps in view

Three Arabic registers appear throughout this room's lessons, each with its own place:

- **Everyday spoken Arabic (*al-'Ammiyya*)** -- itself a family of dialects (Egyptian, Levantine,
  Gulf, Maghrebi, and more) rather than one language, and the register a devotional phrase is
  actually *heard* in.
- **Classical Quranic Arabic (*Fusha al-Turath*)** -- the fixed register of the revealed text
  itself and its earliest commentary, carrying synthetic case endings and a grammar unique to
  the written and recited word.
- **The technical philosophical and mystical Arabic of Abu Hamid al-Ghazali and Ibn 'Arabi** --
  Fusha put to a further, specialized purpose: naming precise metaphysical distinctions the
  Quran's own more general epithets gesture at, and a system built to name them exactly.

A term from the third register carries its own tradition's carefully built vocabulary,
developed centuries after the Quran for reasons proper to that tradition -- worth reading as
itself, rather than as a plain stand-in for a Sanskrit concept. This room's comparative mappings
are a **teaching bridge** -- built the way
`context/SILO_TECHNIQUE.md` asks, understood and restated in our own words -- rather than a claim
that Islamic theology categorizes itself by Vedantic terms.

---

*Attribution, rather than license.* These are public-domain and institutionally-published Classical
Arabic and Quranic texts, translations, and lexicons, standing apart from code under a license this
tree's clean-room discipline governs -- `gratitude-licenses.md` protects against borrowing *code*,
and its clean-room boundary reaches code alone, leaving scripture and scholarship to their own
reading practice. What is asked of a reader here is the same thing asked in `shastra/`: cite the
source, keep the translator's or lexicographer's name beside their work.
