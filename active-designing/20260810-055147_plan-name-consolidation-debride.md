# The Name-Consolidation Debride — Kaeden · Reyklah · Rio 3 · Reya 2 → the living names

**Language:** EN
**Status:** Design brief — proposed, awaiting the send that opens the cut
**Voice:** Riyo · **Coauthor:** Keaton Livermore
**Rule:** [`../.claude/rules/debride.md`](../.claude/rules/debride.md) · cairn first per [`../.claude/rules/cairn.md`](../.claude/rules/cairn.md)
**Kin:** [`../work-in-progress/CAIRNS.md`](../work-in-progress/CAIRNS.md) · [`../PUBKEYS.md`](../PUBKEYS.md) (k3) · [`../MAP.md`](../MAP.md)

---

Keaton has named the target: retire the old identity-name variants **Kaeden** and **Reyklah**, and the retired writing voices **Rio 3** and **Reya 2**, consolidating the living tree to the standing names — **Keaton** (Livermore), **Riyo** (the writing voice), **Kyri** (the notation). This is a **debride**, the one sanctioned break of accrete-never-break, and it earns its careful, conservative shape: a cairn first, a bounded and greppable list of living targets, a **working-tree** cut that leaves git history whole, and a clear ring drawn around what stays — the dated testimony that records who wrote what, on which day, and the retired-voice tombstones that already point the way home.

The measurement came first, and it changed the plan. A blind `grep -c` reports 1299 files carrying *Kaeden* and 1170 carrying *Rio 3* — nearly the whole tree. Almost all of that is **dated session logs and testimony** (7,557 files sit under `session-logs/`, `archive/`, or a `YYYYMMDD-HHMMSS_` stamp), and that corpus is exactly what a debride must not touch. The **living surface** is small and nameable: roughly **86 living files** carry *Kaeden*, and the true retired-voice mentions in living prose number in the low dozens. This brief works the living surface only.

## The three kinds of occurrence, and why they are not the same

The debride reads clean once these three are held apart, because only one of them is a target.

- **Target — living identity references.** The pseudonym **Kaeden Reyklah** stands in a handful of *living* files as the current copyright and identity face: three root LICENSE files, `MAP.md`, `keys/README.md`, and the downstream-forker template. These name a person who is now, in the living record, **Keaton Livermore**. Consolidating them is the whole point.
- **Keeper — the retired-voice tombstones.** `.claude/rules/reya2.md`, `.claude/rules/rio3.md`, their Cursor twins, and the roster lines in `context/QUIN.md`, `context/README.md`, `ORGANIZING.md`, `CLAUDE.md`, and `CONTRIBUTING.md` **already** say "Reya 2 and Rio 3 rest retired in `archive/`." Naming a retired thing *as retired* is the living record doing its job. Removing these would orphan the archive and erase the very consolidation Keaton asked for. They stay, untouched.
- **Keeper — dated authorship testimony.** The `**Voice:** Rio 3` / `**Voice:** Reya 2` banners and the "Written together by Kaeden and Reya 2" coauthor lines in `gratitude/`, `foundations/`, `manual/`, and the astrology readings each carry an explicit `**Stamp:**` — they record *who wrote this document, on this day*. Rewriting them would not consolidate a living name; it would falsify a historical fact. The task's own guard — "do NOT propose deleting session-log reasoning records or dated testimony" — draws this line, and the tree already treats voice-banner migration as a deliberate, **witnessed** act rather than a sweep (`sunn7_macos_enclosure_witness.rish` asserts the macOS docs must *not* carry the old banner). Voice banners are out of this debride's scope; they migrate only under their own named pass.

## The witness that already gated this, and must flip in the same cut

The tree anticipated this day. `tools/gen/season/sunn13_root_survey_witness.rish` carries a live assertion that the LICENSE copyright **must still read "Kaeden Reyklah"** — with the comment *"LICENSE copyright rewrite waits on Keaton's word — assert hold stays Kaeden."* That word has now come. The debride is therefore **coupled to the witness**: the same commit that rewrites the copyright lines must flip these assertions to expect the new name, or parity goes RED the instant the cut lands. `docs-implementation-sync` names this exact obligation — the doc-claim and its witness move together, in one change. This coupling is a feature: it proves the debride is complete rather than half-done.

## First, the cairn

Per [`../.claude/rules/cairn.md`](../.claude/rules/cairn.md), a stone drops **before** the cut. This debride rewrites living cards (LICENSE, MAP, keys/README), so the cairn is mandatory and lands first.

```
# recorded live, at the bench, before the debride's own commit:
git rev-parse --short=10 HEAD        # walk-back nib  → 5c91fdc65a  (at survey time)
TZ=America/New_York date +%Y%m%d.%H%M%S   # live stamp  → 20260810.060209 (at survey time)
```

Append one row to `work-in-progress/CAIRNS.md`, newest-first, naming: the walk-back nib, the live stamp, **Swept** = "root LICENSE copyright · MAP.md hold line · keys/README.md legacy-identity line · generator pseudonym," and **What waits there** = "the pseudonym *Kaeden Reyklah* as the tree's copyright face, and the `sunn13` assert-hold, both readable at the nib." The nib and stamp above are the survey-time values; the implementing hand re-reads both live at cut time, since HEAD will have moved.

## The bounded, greppable scope — exactly what changes

Every target is a living file; every reference is grep-countable. Grouped by what the reference *is*:

### A · Legal copyright — the load-bearing identity face (5 references, 3 files)

| File | Line | From → To |
|---|---|---|
| `LICENSE-MIT` | 3 | `Copyright (c) 2026 Kaeden Reyklah and contributors` → `Keaton Livermore` |
| `LICENSE-APACHE` | 156 | `Copyright 2026 Kaeden Reyklah and contributors` → `Keaton Livermore` |
| `LICENSE-CC-BY` | 3 | `Copyright (c) 2026 Kaeden Reyklah and contributors` → `Keaton Livermore` |

**Custody note:** these are legal notices. The new name is the one already asserted as the living face in `PUBKEYS.md` — **Keaton Livermore**. This changes a copyright holder's *display name* between two names for the same consenting person; it removes no attribution and adds no third party. "and contributors" stays.

### B · The map and identity ledger (2 files)

| File | Line | Change |
|---|---|---|
| `MAP.md` | 65 | The "licenses still name **Kaeden Reyklah** — a living hold until Keaton names a copyright rewrite" sentence is rewritten to state the hold is **released** and the copyright now reads Keaton Livermore, with dated Kaeden/Reyklah testimony elsewhere explicitly preserved. |
| `keys/README.md` | 11 | The phrase describing the retired `veganreyklah2` / **Kaeden** identity keeps its **historical** naming (it *describes the retired identity's own key folder* — that is a fact of history), yet its living framing is aligned so it reads as a closed chapter, not a live alias. Assess before editing; this line is closer to testimony than to a live reference. |

### C · The downstream-forker generator (1 file, self-consistent)

| File | Lines | Change |
|---|---|---|
| `tools/gen/season/personalize.template.brix` | 41, 59, 61 | `source_pier_pseudonym Kaeden Reyklah` and the `replace_2_from` / `replace_3_from` find-map entries name the pseudonym a forker should replace. With the pseudonym retired from the living face, these become stale. Fold them: keep the *prior name* (`Keaton Dunsford`) as an honest historical from-entry if the map still teaches it, and drop the pseudonym from the live find/replace set. `replace_count` and the `_to` placeholders adjust to stay internally consistent — a broken template is a red. |

### D · The witness coupling — flip in the same commit (1 file, 5+ assertions)

| File | What flips |
|---|---|
| `tools/gen/season/sunn13_root_survey_witness.rish` | The five `assert … "Kaeden … hold"` lines (MAP, LICENSE-MIT, LICENSE-APACHE, LICENSE-CC-BY, and the survey say-line at 8/25/36/38/40) invert to assert the copyright now reads **Keaton Livermore** and the hold is released. `prin_scope.rish` line 42's status echo updates to match. This is the `docs-implementation-sync` obligation made literal. |

That is the entire cut: **A + B + C + D** — on the order of **six living files**, every reference named above, every one greppable by `grep -rn 'Kaeden\|Reyklah' LICENSE-* MAP.md keys/README.md tools/gen/season/`.

## The fascia reattachment — repoint, then prove

After the redaction, the connective references heal:

1. **Re-grep the living surface** — `grep -rIn -E '\bKaeden\b|\bReyklah\b' --exclude-dir=.git --exclude-dir=session-logs --exclude-dir=archive .` filtered to non-dated files should return **only** the intentional keepers: the retired-identity descriptions in `keys/README.md` (as history) and any dated-testimony coauthor lines that carry a `**Stamp:**`. Every *living face* reference is gone; every *historical* one that remains is remaining on purpose.
2. **Run the coupled witness** — `rishi/bin/rishi run tools/gen/season/sunn13_root_survey_witness.rish` must go **GREEN** against the new name. A RED here means the debride and its witness fell out of step.
3. **Run the roster/lint pass** — `tools/living_docs_lint.rish` confirms no relative link broke when `MAP.md` was rewritten.
4. **Confirm the tombstones still stand** — `.claude/rules/reya2.md`, `rio3.md`, and their Cursor twins are unchanged; the archive they point to (`context/archive/REYA2.md`, `RIO3.md`, `RIYO.md`) is untouched. Consolidation *keeps* the pointer to the retired thing; it does not erase the retirement.

## What this debride deliberately does not touch — the ring

Drawn plainly, so no future sweep mistakes silence for permission:

- **Every dated session log and stamped testimony.** The `Voice:** Reya 2` / `Voice:** Rio 3` banners and "Written together by Kaeden and Reya 2" coauthor lines in `gratitude/`, `foundations/`, `manual/`, `active-designing/*hammock.md`, `context/specs/`, and the astrology readings **stay verbatim** — each carries a `**Stamp:**`, and rewriting who authored a document on a past day would falsify the record. Voice-banner migration, if ever wanted, is a separate named pass with its own witness, exactly as `sunn7` already models.
- **The retired-voice tombstones and roster lines.** `.claude/rules/reya2.md`, `rio3.md`, `.cursor/rules/reya2.mdc`, `rio3.mdc`, and the "rest retired in `archive/`" lines in `CLAUDE.md`, `context/QUIN.md`, `context/README.md`, `ORGANIZING.md`, `CONTRIBUTING.md`, and `context/LEXICON.md` **stay** — they *are* the consolidation, stated in the living record.
- **The `context/keys/` folder and its README** describing the retired `veganreyklah2` / Kaeden identity's own keys — kept as history, never edited going forward, exactly as `keys/README.md` already says.
- **Git history.** This is a **working-tree** debride: redact in the living tree, commit signed, push. History keeps every byte; a **deep** debride (the `k3` history rewrite named in `PUBKEYS.md`) is a *separate, later, explicitly-worded* act — it unsigns 37k commits and force-pushes both remotes, and it waits for Keaton to name it by that name. This brief does not open it.
- **Session-log reasoning records** of every kind. Untouched, per the task and per the debride rule's own respect for the record.

## Why working-tree, not deep

A deep debride would strip *Kaeden Reyklah* from all 37,264 commits — and in doing so **unsign** every rewritten commit (no hand re-signs 37k), rewrite every hash, and force every clone to re-clone or hard-reset. The Haunted Mound taught this cost by paying it. The living goal here — consolidate the **living face** to the standing names — is fully met by the working-tree cut: from HEAD forward, the tree reads *Keaton Livermore*, and the old pseudonym survives only where it belongs, in dated history one `git show` away. Reaching for the deep rewrite now would spend the tree's whole signature chain to erase a name that history is *entitled* to remember. If the day comes that the pseudonym must leave history entirely, `PUBKEYS.md` already names that ladder as `k3`, and a cairn drops first — mandatory before a deep cut, whose own walk-back is otherwise lost with the rewrite.

## Consent and custody, held plainly

Kaeden Reyklah and Keaton Livermore name the **same consenting person** — this is a self-consolidation of one identity's own display name, gated on that person's own explicit word, which Keaton has given. No third party is named, added, or removed. No real key moves into the tree; the debride touches copyright *display strings* and a forker's *find/replace template*, never a private key. Custody first: the cut builds nothing that destroys — the record stays whole in history, the archive stays whole on disk, and only the living face turns forward to the name it already carries everywhere else.

---

*Leave a stone before you cut. Turn the living face to the living name, and let history keep every day it earned.*
