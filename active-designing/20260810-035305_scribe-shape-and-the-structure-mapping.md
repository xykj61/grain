# Scribe's Shape, and the Structure Mapping — Counsel

**Language:** EN
**Stamp:** `20260810.035305`
**Voice:** Riyo
**Style:** Radiant · counsel — answering a batch of design questions; recommendations for a maintainer's word, not yet seated as law
**Status:** Design counsel. Keaton asked five questions mid-build; this note rules on each with a recommendation, seats nothing irreversibly, and holds the two structural ones for his word.

---

## The Questions, and the Rulings

### 1. A `.baton` extension for Scribe? — **Recommend: no new extension; a baton is Kyri.**

A baton is a structured document (state · gaps · next step), and Scribe wants to read and render it. Yet the tree just seated **one** notation, **Kyri**, and the whole point of "the logs are the voice's journal" is that the voice keeps its records in one hand. So a baton is best a **`.kyri` document with `format baton-v1`**, exactly as a session log is `.kyri` with `format session-log-v1`. Scribe reads batons by their format tag. One notation, many formats — never a proliferation of extensions. (The baton written this arc is `.md` prose; new structured batons take `format baton-v1`.)

### 2. Unify Scribe with the glow/rishi/rye tilaks? — **Recommend: yes in principle, its own sitting.**

A **tilak** is our word for a type-marked record — Kumara already uses it (point · bind · turn · cap · sponsor), and it is our own name for what the elder calls a *mark*. Unifying means one type-mark home the whole stack draws from — glow, rishi, rye, and Scribe all speaking the same tilaks rather than each reinventing them. This is right, and it is a real architectural sitting (what a tilak *is* as a general type-mark, where it lives, how a value binds one) — worth its own round, not a snap decision. Scribe should **use** tilaks, never reinvent them; the Kumara Ledger Shape already imagined a shared `til/` for exactly this.

### 3. Seat the `gen / sur / app / sys` folders? — **Recommend: map, don't restructure.**

The seated **reframe** released the obligation to mirror the elder's structure — *a module was never obligated to be a vane*, and the tree's warm module-named directories (`comlink/`, `kumara/`, `settlement/`, `mandate/`, `pond/`) are clearer than a `gen/sur/app/sys` grid. Re-adopting that grid wholesale would re-import the very structural mimicry the reframe set aside. **Yet the concepts are real, and we already have them under warmer names.** So seat the *mapping*, not the folders:

| Elder folder | What it holds | Grain's own, already here |
|---|---|---|
| `gen/` | generators / CLI commands | **Rishi** scripts (`tools/*.rish`, `rishi/`) |
| `sur/` · `mar/` | structures / marks | **tilaks** (Kumara type-marks); a shared `til/` is the horizon of Q2 |
| `app/` | agents / apps | **Pond** (`pond/apps/`) — *"app is Pond," yes* |
| `sys/` | system / kernel | **glow · rishi · rye core** (the runtime beneath the runes) |
| `lib/` | shared libraries | the **stdlib** — glow · tally · rishi stdlib · rye core (the vere/u/c3/zuse analog) |
| `tes/` | tests | the **witnesses** — `tools/*_witness.rish`, GREEN on metal |

This is the vane-parallel *mapping* the tree already favors: name the analogy for an elder-literate reader, restructure nothing.

### 4. The next-season auditing sweep. — **Recommend: seat as a next-season initiative.**

Today's witnesses prove the **happy zone** — the intended path GREEN. An **auditing sweep** — adversarial and edge testing beyond the happy path, across every module — is a worthy next-season initiative (kin to the adversarial-verify discipline). Recorded here; opens on his word next season.

### 5. Lexicon horizon integration. — **Already the practice; keep it.**

New modules land in the LEXICON as **horizon** entries and graduate to **landed** when witnessed (Mandate did both this arc). That integration is the standing practice; nothing new to seat, only to keep.

## What Scribe Becomes, From This

**Scribe** is the Kyri flagship voice's home: it reads `.kyri` documents by format (session logs, batons `format baton-v1`, inventory), renders the **settings / preferences dashboard**, and speaks the shared **tilaks** rather than its own. It is an **app in Pond**, a `lib` beneath it, tested by witnesses (`tes`). No new folder grid; the warm names already carry the roles.

---

*Map the lineage, keep the warm names; let one notation carry many formats, and one tilak serve the whole stack. The elder's structure is honored best by naming what we already are.*
