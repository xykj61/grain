# Scribe's Dashboard, and the Bat Fleet — original baton archetypes

**Language:** EN
**Status:** Mixed -- Design brief — no code, no witness yet
**Stamp:** `20260810.055716`
**Voice:** Riyo
**Equinox:** BUHR (Surface & Intelligence) · Scribe, the Kyri voice's home
**Reads-from:** `scribe/reader.rye` (GREEN `20260810.041230`) · counsel `active-designing/20260810-035305_scribe-shape-and-the-structure-mapping.md`
**Names the folder the vision baton named:** `expanding-prompts/20260810-044453_the-3x39-baton-passports-dividers-and-starseeding.md` → *"a `bat/` folder — baton archetypes, uniquely named in the style of Battlestar Galactica or One Piece ship names, or Acme/MEGACORP corporate names — original coinages only."*

Scribe already reads its own records. `scribe/reader.rye` parses a `.kyri` document zero-copy and dispatches by its `format` line — it tells a `session-log-v1` from a `baton-v1` with one honest reader, the seated *one notation, many formats* made real. This brief carries that reader two steps forward: **a dashboard that reads a whole drawer of `.kyri` documents by format and lays them out**, and **a `bat/` fleet of baton archetypes** — original coined shapes, each a `format baton-v1` document, each proven by the reader the way a session log already is.

Two builds, one spine. The dashboard is the reading room; the fleet is what fills its shelves. Both stand on the reader already GREEN, and neither writes a byte the reader cannot already parse.

---

## Part One — Scribe's Dashboard (the reading room)

### What it is

A **dashboard** is Scribe's settings-and-preferences reading room: point it at a drawer of `.kyri` documents, and it reads each one, **dispatches by format**, and lays them out by kind — session logs in one shelf, batons in another, inventory in a third. Where `reader.rye` reads *one* document, the dashboard reads *many* and renders a legible index of what a drawer holds. It is the plain warm word — clear over coined, per the comlink-tendency — because a newcomer meets a dashboard and knows it at once.

The counsel already placed this: Scribe *"reads `.kyri` documents by format (session logs, batons, inventory), renders the settings / preferences dashboard, and speaks the shared tilaks."* This brief is that dashboard's first lap.

### What it reads, and how it dispatches

The dashboard walks a drawer, parses each document with `reader.parse`, and asks each one what it is. Three formats are known today; a fourth (`inventory-v1`) is named here so the dashboard has a third shelf from the first lap:

| Format tag | Shelf | Dispatch predicate | Load-bearing fields the dashboard shows |
|---|---|---|---|
| `session-log-v1` | **Logs** | `reader.is_session_log` | `stamp` · `title` · `recommend` (and the `think`/`file` counts) |
| `baton-v1` | **Batons** | `reader.is_baton` | `stamp` · `state` · `next` (and the archetype's own head; see Part Two) |
| `inventory-v1` | **Inventory** | `is_inventory` *(new, this lap)* | `stamp` · `title` · the counted line-items |
| *(any other / none)* | **Unread** | falls through | shown by filename only, honestly marked "format unread" |

`is_inventory` is the small new dispatch predicate this lap adds to `reader.rye`, in the exact shape of `is_session_log` and `is_baton`: format says `inventory-v1`, and a load-bearing field (`stamp`) is present. Three predicates, one honest reader — the sprawl the counsel warned against never opens.

### The shape of a rendering

The dashboard's first lap renders to **text** — one honest index a terminal prints, or Skate later paints. Skate rendering is a horizon above this lap; the dashboard's job now is to *read and lay out*, not to draw pixels. A rendering is a bounded list of rows, each row a `{ shelf, stamp, title, one_line }` drawn entirely from fields the reader already returns. Nothing is computed the document does not say; the dashboard is a lens, never an author.

### The bounded shape (TAME)

Every count is named and asserted at the edge, in the reader's own idiom:

- `max_drawer_docs: u32` — the most documents one dashboard reads in a pass (a voice's drawer is not infinite; name it, assert it).
- Each document stays within the reader's own `max_source_len` / `max_fields` — the dashboard adds no new source bound, it borrows the reader's.
- The dashboard holds an array of `max_drawer_docs` rows; the count never runs past it, asserted with a `// invariant:` at fill and at render.
- **Zero-copy holds across the dashboard.** A row's `stamp`/`title` are the reader's own slices into each document's source — the dashboard copies no field. The caller keeps every document's bytes alive while the dashboard reads; the rows borrow, exactly as `Field` borrows. The one bound to state plainly: a row is valid only while its source document lives, and the dashboard asserts it never outlives its drawer.

### The smallest witnessed first lap (dashboard)

One lap, small enough to hold in mind: **the dashboard reads a three-document drawer — a log, a baton, an inventory — and lays them out on the right three shelves, with the Unread shelf empty.**

`scribe/dashboard.rye` seats an `Index` over the reader:

1. Parses three sample documents held in-source (a `session-log-v1`, a `baton-v1`, an `inventory-v1`), exactly as `reader.rye`'s selftest holds `sample_log` and `sample_baton`.
2. Dispatches each to its shelf via `is_session_log` / `is_baton` / the new `is_inventory`, and asserts each landed on the shelf it should — the log on Logs, the baton on Batons, the inventory on Inventory.
3. Asserts the **Unread** shelf is empty (every known format was recognized) and that a fourth document with a nonsense format *does* land in Unread (the fall-through is honest, not silent).
4. Renders the index to text and asserts each shelf's row shows the document's own `stamp` and `title`/`state` — proving the lens shows only what the document said.
5. Proves **zero-copy across the dashboard**: a rendered row's `title` slice lies within its source document's bytes, the same `@intFromPtr` bounds check `prove_zero_copy` already uses.

The witness `tools/scribe_dashboard_witness.rish` builds the binary, runs the selftest, and checks the GREEN line, the three-shelf placement, and the empty-Unread claim — the witness shape `scribe_reader_witness.rish` already established. GREEN means Scribe reads a whole drawer by format, not just one document.

---

## Part Two — The `bat/` Fleet (original baton archetypes)

### What a baton is, and why archetypes

A **baton** is a carry between hands — the word the tree already loves (`comlink-tendency` favorites; Lexicon-seated). It is a `.kyri` document with `format baton-v1`, capturing **state · gaps · next** so a context reset, a BRB, or a fresh agent turn loses nothing. The reader already recognizes it (`is_baton`). What is missing is *shape*: today every baton is free-form under one format. An **archetype** is a named baton shape — a small set of expected fields for a *kind* of carry — so the reader can not only say "this is a baton" but "this is a **Galleon** baton, and its `manifest`/`aspiration`/`gap` fields are present."

The fleet lives in `bat/` (the folder the vision baton named). Each archetype is a documented shape plus a `bat/<name>.kyri` **exemplar** — a real, fake-data instance the witness parses. No archetype invents a new format tag; all are `format baton-v1` with a second field, `archetype <name>`, that the dashboard and a new predicate read.

### The register, and the copyright discipline

The vision asked for names *in the style of* Battlestar Galactica, One Piece ship names, or Acme/MEGACORP corporate names — **original coinages only**, honoring copyright and never infringing a trademark, safe even in history and Weave. The register these three share is **the vessel that carries a crew across a gulf** and **the firm that carries a ledger across a fiscal year** — a baton carries state across a gulf in attention. So the fleet is named for **ships and trading-houses of an invented line**, drawn from the plain nautical and mercantile commons (a *galleon*, a *barque*, a *corsair* are common nouns no one owns), never from any named ship or company in any of those works.

**Every name below greps to zero across the whole tree** (`.rye`, `.rish`, `.brix`, `.bron`, `.kyri`, `.md`) as of this brief — clear, warm, safe, and collision-free per the comlink-tendency's three tests. None is a real `@p`-shaped token; none is a real company. The copyright discipline is structural: each archetype's exemplar carries a `note original coinage; no named ship or company` line, and the style check turns away any exemplar that names a real vessel or firm.

### The six archetypes

Each names a *shape of carry*. The head field `archetype <name>` selects it; the listed fields are what that shape expects a reader to find.

| Archetype | Register | The carry it names | Expected fields (beyond `format` · `stamp`) |
|---|---|---|---|
| **Galleon** | grand ship of the line | the **full vision handoff** — everything to disk, so history may clear and lose nothing (the 3x39 baton is a Galleon) | `manifest` (the whole cargo, one line) · `seated` (what landed) · `aspiration` (north stars, consent-gated) · `gap` (repeatable) · `next` |
| **Cutter** | swift single-masted boat | the **one-keystone lap** — minimal, `kg` — a single mechanical step carried forward | `state` · `next` (and nothing more; a Cutter is small on purpose) |
| **Barque** | mid-sized working vessel | the **round in progress** — several doors open, none yet closed | `state` · `gap` (repeatable) · `next` · `witness` (the GREEN line or "eyes pending") |
| **Holdfast** | an anchor's grip | the **checkpoint** — *stop before you cross this gate* — a named stop-before-cross | `state` · `gate` (what must be confirmed before crossing) · `hand` (Cursor / Claude / either) · `next` |
| **Corsair** | a raider that probes defenses | the **audit sweep** — what was adversarially probed and what held (the next-season auditing initiative's record) | `state` · `probe` (repeatable — each edge tested) · `held` (repeatable — each that survived) · `red` (repeatable — each that fell) · `next` |
| **Ledgerworks** | an invented trading-house | the **portfolio roll-up** — many modules' state gathered under one head (the Scribe × Tally monitor's carry) | `member` (repeatable — one per module) · `roll` (the aggregate state) · `stamp` · `next` |

Six shapes cover the carries the tree already makes: the grand handoff, the tiny lap, the working round, the checkpoint, the audit, and the roll-up. Each is a `format baton-v1` document — the reader already parses every one; the archetype adds only *which fields to expect*.

### The dispatch this adds

`reader.rye` gains one small predicate this lap, in the family of `is_baton`:

```
archetype_of(doc) -> ?[]const u8   // the value of the `archetype` field, or null
```

And a bounded validator per archetype — `validates_galleon(doc) bool`, etc. — that asks: is this a baton (`is_baton`), does its `archetype` say the right name, and are the shape's **required** fields present? This is exactly `is_session_log`'s pattern (`format` says so *and* the load-bearing fields are present), one predicate per archetype, each small and each asserted. The dashboard's Batons shelf reads `archetype_of` to label each baton by its kind.

### The `bat/` folder shape

```
bat/
  README.md            — the fleet, the register, the copyright discipline
  galleon.kyri         — a fake-data Galleon exemplar (a small vision handoff)
  cutter.kyri          — a one-keystone Cutter exemplar
  barque.kyri          — a round-in-progress Barque exemplar
  holdfast.kyri        — a checkpoint Holdfast exemplar
  corsair.kyri         — an audit-sweep Corsair exemplar
  ledgerworks.kyri     — a portfolio Ledgerworks exemplar
```

Every exemplar holds **fake, illustrative data only** — no real key, no real person's decision, no real company's state. An exemplar is a shape a reader parses, exactly as `reader.rye`'s `sample_baton` is fake. Custody first: the fleet builds nothing that destroys, and places no real secret to lose.

### The smallest witnessed first lap (fleet)

One lap, the load-bearing claim the whole fleet hangs from: **the reader recognizes `format baton-v1`, reads its archetype, and validates that a Galleon exemplar carries every field a Galleon requires.**

`bat/galleon.kyri` is the first exemplar — a `format baton-v1` document with `archetype galleon` and the Galleon fields filled with fake handoff data. The lap seats `archetype_of` and `validates_galleon` in `reader.rye`, and proves in the reader's own selftest (or a `bat/`-scoped witness):

1. **Recognizes the form** — `is_baton(galleon)` is true and `is_session_log(galleon)` is false (the seated dispatch still holds).
2. **Reads the archetype** — `archetype_of(galleon)` returns `"galleon"`, not null.
3. **Validates the shape** — `validates_galleon(galleon)` is true: `manifest`, `seated`, `aspiration`, and `next` are all present, and at least one `gap`.
4. **Refuses a short shape** — a Galleon exemplar with `manifest` removed fails `validates_galleon` (the required field is *required*, proven by its absence turning the predicate false), exactly as a session log missing `stamp` fails `is_session_log`.
5. **Repeatable fields survive** — a Galleon with three `gap` lines reports `count_key("gap") == 3`, the reader's repeatable-key promise carried into the fleet.
6. **Zero-copy holds** — the `manifest` value slices into the exemplar's source, the same bounds check the reader already proves.

The witness `tools/bat_galleon_witness.rish` builds the reader, parses `bat/galleon.kyri`, and checks the GREEN line, the archetype label, the validate-true, and the validate-false-on-short line. GREEN means the fleet is real: a named baton shape, parsed and validated by the one reader, with a refusal on a missing required field.

The other five archetypes follow as their own small laps — `validates_cutter`, `validates_barque`, and so on — each accreting beside the one before, each with its own exemplar and its own witness line, exactly the *one small witnessed step at a time* rhythm the reader itself was built on.

---

## Consent and custody — the invitations named plainly

The vision baton this brief serves names real people and companies as **north stars, consent-gated** — b122m, Siya Fund LLC, Linengrow PBC, Bitscape (DJINN's company), the Atthowe-ecological healthcare direction, and a long compatibility horizon. **This brief inherits every one of those as an invitation, never a claim.** No archetype exemplar names a real party's real decision as settled; a `Ledgerworks` roll-up over real companies, or a `Galleon` handoff naming a real partnership, is written only with that party's own yes, by their own hand. The fleet ships with fake exemplars and no real state. The 3x39 concept and the council names are Keaton's own; their entry into any exemplar is his call. Custody first is the whole posture: read records, carry state, and place no real secret and no unconsented name in the tree.

## Risks, named plainly

- **Format sprawl is the temptation the counsel already refused.** The mitigation is structural: every archetype is `format baton-v1` with an `archetype` field — **zero new format tags, one reader, one notation**. The dashboard's fourth known format (`inventory-v1`) is the only new tag, and it earns its shelf. If a seventh archetype ever wants a new *format*, that is a counsel question, not a quiet addition.
- **Copyright and trademark, in a register borrowed from named works.** The mitigation is the common-noun rule and the grep: every archetype is a plain nautical or mercantile word no one owns (*galleon*, *barque*, *corsair*, *cutter*, *holdfast*, and the coined firm *Ledgerworks*), never a named ship or company from Battlestar Galactica, One Piece, or any real corporation. Each grep to **zero** across the tree today; each exemplar carries `note original coinage`; the style check turns away any exemplar that names a real vessel or firm. The register is the *flavor*, never the source.
- **Zero-copy is easy to lose when a dashboard holds many documents.** The mitigation is the borrow discipline the reader already lives by: the dashboard's rows are slices into each document's source, the caller keeps every source alive, and the witness proves a rendered field still lies within its document's bytes. A row that outlived its drawer would be the red; the invariant asserts it never does.
- **An archetype's "required fields" can drift from the shape a real baton wants.** The mitigation is `docs-implementation-sync`: the required-field table in this brief and the `validates_<name>` predicate are one claim, checked by the witness — a Galleon that dropped `manifest` fails GREEN, so the doc's claim and the code's check move together or the witness catches it.
- **Naming, one last grep.** `Galleon`, `Cutter`, `Barque`, `Holdfast`, `Corsair`, and `Ledgerworks` grep clean against every seated module and waymark today, and `dashboard`/`inventory` collide only as incidental prose (no seated home). Before the first `bat/` file or `scribe/dashboard.rye` lands, re-grep the tree and seat the six archetype names and the dashboard in the Lexicon, per the comlink-tendency — clear, warm, safe words a newcomer grasps at once.

---

*Scribe reads its own records; now it lays out a whole drawer, and the fleet gives each carry a name. A Galleon for the grand handoff, a Cutter for the one small lap, a Holdfast for the gate you must not cross unconfirmed — original vessels of an invented line, every one a `format baton-v1` document the one reader already knows how to read. One notation, many formats, many shapes; every field borrowed, none copied, and no real secret carried anywhere near the water.*
