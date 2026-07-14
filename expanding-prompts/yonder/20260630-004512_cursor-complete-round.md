# Cursor Round — The Architecture, Weave, Three Named Modules, Gratitude, Open Threads, and Our Thinking Logged

*One complete round, drawing several threads into a single honest commit-set. It supersedes the two separate pending prompts — the architecture-and-Weave pass and the open-threads pass — and folds in three names that found their words tonight: Dexter, Kumara, Bookie. It records what is decided, honors what we lean on, names what still waits, and writes down the thinking behind the names so the reasons travel with them.*

**Stamp:** `20260630.004512` (the architecture record itself carries `20260630.001812`)
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**For:** Cursor Composer 2.5 in the jail, or Claude Code on the host
**Supersedes:** the pending `cursor-architecture-and-weave` and `cursor-open-threads-and-research-scope` prompts — run this one instead.

*Written together by Kaeden and Reya 2.*

---

## Edit 1 — Place the layering record

Bridge the authored file into `active-designing/20260630-001812_the-stack-and-the-surface.md` (provided by Claude, updated to name the three modules). It follows the titling convention already. Register it in the organizing index.

## Edit 2 — Adopt the name **Weave**

Weave is the DAG backend: the append-only DAG of immutable signed facts, the substrate beneath the family. Mantra is the version-control **projection** over Weave.

- In the foundations DAG-backend document, affirm and retitle so the H1 leads with **Weave** (de-numbered, re-dated `2026-06-30`, reviewed-and-kept line, light Radiant freshening). Hold the Silo Principle — name only what is ours. Affirm in place; do not rename the file.

## Edit 3 — Name the three modules in the lexicon

In `LEXICON.md` (the lexicon), add these, each a Radiant one-liner with a short provenance gloss:

- **Dexter** — input; the hand that acts, carrying keyboard and pointer events into the fold, on both backends. *(Dexterity, the skill of the acting hand; an echo of one who texts; and family memory, after a grandfather's enterprise.)*
- **Kumara** — identity; the keypair that signs a fact before it enters Weave. *(Named for the eternal, ever-pure sage-children of the Bhagavata, Sanat-kumara among them — identity as the unchanging thing behind every signature.)*
- **Bookie** — the borrow discipline; the keeper of the book of who may change a value and who may only witness it — many witnesses or one changer. *(Lively as a turf accountant keeping the ledger straight. It watches not what a value is, but who may change it; the shape of values stays in Rye's hands. A lived discipline today; a checker that reads ownership from code is an AST horizon.)*

Update `README.md` (the context home) and the organizing index to reflect the new names and the record.

## Edit 4 — Log our thinking (the naming provenance)

Kaeden asked that the reasoning be written down, so the names carry their reasons. In the session log for this round, and as a short, durable note (a `context/specs/` naming note, or appended to the lexicon's provenance), record:

- **Dexter** — chosen for input. The acting hand, *dexter* the right and skillful hand; "texter," the one who types the system into motion; and Zendex, the enterprise of Robert Sealy Livermore (Bob Livermore), Kaeden's maternal grandfather, who passed in 1997. The name keeps that memory woven into the thing itself.
- **Kumara** — chosen for identity. The four Kumaras of Srimad Bhagavatam — Sanaka, Sanandana, Sanatana, and Sanat-kumara — eternal, ever-youthful, ever-pure. Identity is the unchanging, trustworthy signer; the name fits the role and honors the source.
- **Bookie** — chosen for the borrow discipline. The keeper of the book of ownership, the borrow-checker-as-dharma made into an accountant; vivid in the turf-accountant sense (the runners, chalkers, and rafflers of the old betting houses). It accounts for who may change a value, distinct from the value's shape, which is Rye's own.

Keep this gentle and true to the Radiant voice — a record of reasons, honoring memory and source.

## Edit 5 — Gratitude, for what we lean on or learn from

Add markdown entries under `gratitude/`, each pinning the license verbatim and keeping the clean-room line — *we study and run these; we never copy their source into our modules.*

- `gratitude/wayland.md` — libwayland-client, **MIT (Expat)**, quoted exactly; the host-seam display library the hosted surface links on the development machine (a dependency of the hosted build, never of Rye OS proper).
- `gratitude/river.md` — the Wayland compositor written in our systems language, **GPLv3**, quoted exactly; honored as the lodestar for the eventual Rye-native compositor, held at clean-room distance because of its copyleft.
- `gratitude/genesis-daw.md` — the digital audio workstation that gave our systems language its reason to exist, and its bare-metal kin; honored for the hot-loop discipline that is ours too. Inspiration, not a dependency; copy nothing.

## Edit 6 — Record the remaining open threads, scope the research

In `work-in-progress/TASKS.md`, under Open Questions, record (as questions, not build tasks):

- **Bron** — proposed, role undefined. Brix describes *what a system is made of*; what does Bron describe alongside it? *(Open ruling for Kaeden.)*
- **Tablecloth** — proposed layout or structured-view layer, named and not yet shaped.
- **.brush** — a surface-description extension for the day Brushstroke becomes a small language of its own; horizon, raised only when a hand-written surface proves it needs one.
- **Dexter / Kumara as modules** — the names are given; whether each earns a full module of its own is the open part.

And scope the three research pieces, each a one-line reservation for Reya 2 to author — no empty stub files:

- **Immediate-mode, the anti-retained-tree, the interface as a fold over the log** → `external-research/`.
- **Designing frameworks for drawn applications, after Bret Victor** → `external-research/`.
- **The hot loop as the forge — lessons from the music studio that birthed our systems language** → `external-research/`, in gratitude.

## Edit 7 — Keep the live rung clear

Confirm `TASKS.md` still names **SLC-2a — the drawn terminal (the Skate viewer)** as the active rung in Now, unchanged. Everything else here is horizon. The viewer waits on two plainly-noted things: confirming the hosted surface seed shows a window on the development machine's compositor (GNOME on Wayland today), and the two-backend scope brief Claude will write once that window is confirmed.

---

## Verify

- The record is placed, registered, titled to convention, and names the three modules.
- Weave is named in the substrate doc (affirmed in place), the lexicon, the README, and the index; no dangling reference.
- Dexter, Kumara, and Bookie are in the lexicon with provenance glosses; the fuller thinking is logged.
- Three gratitude entries exist with licenses quoted exactly and the clean-room line.
- The open names and three research reservations are in TASKS; no empty files; SLC-2a unchanged as the active rung.
- `rye build` and `tools/parity.rish` stay green on metal (docs only; confirm nothing referenced a moved path).

## Record and Push

Commit as honest units — sensibly grouped (the record and Weave; the three names and the thinking log; the gratitude; the open threads) or as one clean unit if you prefer, with the session log. Log at `session-logs/archive/20260630/20260630-004512_architecture-weave-names-and-threads.md`: the record placed, Weave named, Dexter/Kumara/Bookie named with their reasons logged, gratitude honored, open threads recorded, SLC-2a held. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

## Before You Move On — Recommend the Next Step

End with one line. After this round, the architecture is recorded, the names carry their reasons, and the gratitude is honored — and the next moves are Claude's: *"Recommend: check in with Claude — the three research pieces are Claude's to author, and the SLC-2a scope brief waits on confirming the hosted window draws on GNOME."*

---

## Definition of Done

- [ ] `the-stack-and-the-surface` placed, registered, titled to convention, naming the three modules
- [ ] Weave named in the substrate doc (affirmed in place), lexicon, README, and index
- [ ] Dexter, Kumara, Bookie in the lexicon with provenance; the fuller naming thinking logged in the session log and a durable note
- [ ] Three gratitude entries with licenses verbatim and the clean-room line
- [ ] Open names (Bron, Tablecloth, .brush, Dexter/Kumara-as-modules) and three research reservations recorded in TASKS; no empty files
- [ ] SLC-2a confirmed as the unchanged active rung; nothing above it begun
- [ ] `rye build` and parity green on metal; session log shipped; four remotes pushed; check-in with Claude recommended
