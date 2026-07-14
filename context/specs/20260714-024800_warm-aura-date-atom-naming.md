# The Warm-Aura Date Atom — One Stamp Format, Everywhere, TAME-Guided

**Language:** EN
**Version:** `20260714.024800` (Pacific)
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Living — names the canonical date-atom format the whole tree already reaches for, ties it to the warm-aura versioning design, and settles how dated folders are named. Extends `20260627-102012_one-clock-naming-law.md`; does not supersede it.

---

## What This Names

The tree already keeps one clock (`20260627-102012_one-clock-naming-law.md`): every dated artifact is `YYYYMMDD-HHMMSS_slug`, every version string is `YYYYMMDD.HHMMSS`, later is always larger. This document does one small, unifying thing: it gives that stamp its **Glow name** — the **warm-aura date atom** — and settles the one place the one-clock law left implicit, **how dated *folders* are named**, so the archiving/reviving sweep has a single rule to align to.

Nothing here changes the stamp anyone already writes. It names what we were already doing, so a reader meets the reason.

## Why "Warm-Aura Date Atom"

The warm-aura versioning design ([`../../external-research/20260714-015200_glow-warm-aura-versioning-and-doc-code-sync.md`](../../external-research/20260714-015200_glow-warm-aura-versioning-and-doc-code-sync.md)) draws Hoon's warm/cold atom distinction through this project's own versioning: a **warm** atom is typed by its aura but free to take any value; a **cold** atom is a frozen constant. A version stamp is the warm case exactly — typed as "a moment in time," free to take any *later* value, always comparable by "later is larger." Kelvin (counting down to a frozen zero) is the cold case, pinned only at the Urbit interop seam.

So the stamp this tree already writes **is** a warm date atom: our own chronological clock, growing by accretion, never freezing a name it already gave. Naming it so ties three things that were separate — the one-clock law, the warm-aura design, and the Pacific-time convention ([`20260713-201910_pacific-time-local-clone-convention.md`](20260713-201910_pacific-time-local-clone-convention.md)) — into one idea with one name.

Hoon's own absolute-date aura is `@da`; Glow's warm date atom is that aura, warm rather than frozen. Whether Glow's stamp parents directly on `@da` or defines its own aura letter stays the open Glow-supplement question the warm-aura doc already named — this spec names the *convention*, not the eventual Glow type.

## The Three Renderings (all one atom)

The same warm-aura date atom renders three ways, by context, and only these three:

| Rendering | Form | Where | Example |
|---|---|---|---|
| **Version string** | `YYYYMMDD.HHMMSS` (dot) | document headers, `.brix` versions, `stamp` fields, commit-body stamps | `20260714.024800` |
| **Filename stamp** | `YYYYMMDD-HHMMSS_slug` (hyphen) | every dated artifact's filename | `20260714-024800_warm-aura-date-atom-naming.md` |
| **Dated folder** | `YYYYMMDD` (day precision) | archive/fold folders that group a closed day | `session-logs/archive/20260714/` |

The dot belongs to the version string (a colon has no place in a filename; the dot stays for the version). The hyphen belongs to the filename. The **folder is the same atom truncated to day precision** — this is the one thing the one-clock law left implicit and this spec makes explicit: **a dated folder is `YYYYMMDD`, nothing else** — no slug, no prefix, no count. `session-logs/archive/20260619/` is the model the whole tree matches.

## TAME-Guided, Because a Stamp Is an Asserted Invariant

The warm-aura date atom is TAME-guided in the same sense every value in this tree is:

- **Bounded and fixed-width.** `YYYYMMDD` is always 8 digits; `HHMMSS` always 6. A stamp that is not exactly `8-6` (filename) or `8.6` (version) or `8` (folder) is malformed, the way an out-of-range index is malformed — checkable at a glance.
- **Monotonic — later is larger.** The one retained semantic. A new stamp sorts after every earlier one, in every folder, on every forge, in the filesystem, identically. This is the invariant the whole naming law rests on.
- **Accrete, never break.** A stamp, once written, is never recomputed or renamed — the append-only log made literal in the filesystem (root rule 4). Dated artifacts are immutable per `dated_guard`; this atom is why.
- **Taken from the contributor verbatim.** The clock is the contributor's own (Pacific, on this clone — `GLOW_PROFILE.bron`'s `timezone`), recorded in prose where a log's meaning depends on it, never rewritten across hosts.

## How the Archiving/Reviving Sweep Aligns to It

The archive process was already settled ([`../../work-in-progress/20260713-215800_markdown-archive-inventory-and-migration-plan.md`](../../work-in-progress/20260713-215800_markdown-archive-inventory-and-migration-plan.md), concluded `20260714.000100`): **no bulk flatten** — each directory archives in its own established way. This spec does not reopen that. It settles only the *naming* the sweep aligns to, so that wherever a directory does fold a closed day, it folds into a `YYYYMMDD` folder — the session-logs pattern — and nowhere invents a different dated-folder shape.

The sweep, then, is a **naming-alignment** pass, not a file-move pass:

1. Any dated folder that already exists uses bare `YYYYMMDD` (session-logs `archive/` is the reference; confirm the rest match or note the exception).
2. Any *new* fold a directory makes on a closed day creates a `YYYYMMDD` folder, never a slugged or counted one.
3. Reviving keeps its own naming discipline unchanged (`active-reviving/`): a revival is born with its Glow name and its own stamp; the elder keeps its name and stamp. Nothing about reviving conflicts with this atom — it *uses* it.

## Sweep Status — Where We Stand (`20260714.044428`)

The date-format sweep is **not an open pile of work; it is a confirmed state with two compliant conventions**, named here so no reader has to wonder again:

- **Dated artifacts** (session logs, dated specs, design briefs, prompts) carry the warm-aura stamp in filename (`YYYYMMDD-HHMMSS_slug`) and header (`stamp`/`Version YYYYMMDD.HHMMSS`). This has been the one-clock law for weeks; compliance is the norm, and `chrono_version_scan` is the existing witness.
- **Living documents** (`README.md`, `ROADMAP.md`, `TASKS.md`, `LEXICON.md`, the discipline files) carry **`Last updated: YYYY-MM-DD` prose**, not a stamp — this is the one-clock law's own deliberate two-tier rule (living docs evolve in place; only dated artifacts take the stamp). An ISO `Last updated` line is therefore **correct, not a miss** — it is not the same field as a dated artifact's stamp.
- **Living-doc `Version` stamps** (the few living guides that carry a `Version`, like `SOURCE.md`) use the dot form `YYYYMMDD.HHMMSS`. `SOURCE.md` was the one such stamp left stale after an on-touch edit; it is now bumped to `20260714.044428`. No other living-doc `Version` drift is known.
- **Dated folders** are bare `YYYYMMDD` (confirmed on metal: `session-logs/archive/` is the reference; `work-in-progress/archive/` holds flat dated files — both valid).

**Conclusion: the format is seated, the two conventions are both honest, and the tree is in compliance** — the "sweep" is a naming-alignment already done, not a backlog. Future drift is caught on-touch (bump a living `Version` when you edit its doc) and by `chrono_version_scan` for dated artifacts. Nothing here asks for a bulk re-stamp.

## What This Does Not Do

- It moves no files and folds no days — it names the format the sweep and every future fold align to.
- It does not define Glow's eventual date *type* (the `@da`-or-own-aura question stays open in the Glow supplement).
- It does not supersede the one-clock law — it extends it with the folder rule and the warm-aura name.

---

*May every stamp we write stay warm — free to grow later, never frozen back — and may one atom name our whole order, in the file, in the folder, and in the version alike.*
