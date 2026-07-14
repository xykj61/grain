# Cursor prompt — Place the unifying vision, and deepen Linengrow with it

**Goal:** Place *Anywhere We Go, We're Found* in the foundations as the unifying vision above both tracks, then weave its Linengrow-relevant gifts into `linengrow/` — the creator's fable, the creator-tools surface, and especially the **privacy-and-disclosure model via zero-knowledge proofs**. Pure addition and one woven section. Gated propose-then-confirm. The writing file is provided alongside this prompt; place it and confirm by its first line.

Work in Radiant Style. Commit and push when confirmed, then report a Claude-readable summary of what changed.

---

## Step 0 — Footing

Confirm, then stop:

- Current branch and its cleanliness; whether it is level with its GitHub remote.
- `foundations/` and `foundations/README.md` exist; `linengrow/` and `linengrow/README.md` exist.
- The target file does not yet exist under `foundations/`.

---

## Phase A — Place the unifying vision

Place the writing as a vision document (it carries its own `20260628.124512` stamp):

| File | First line |
|------|-----------|
| `foundations/20260628-124512_anywhere-we-are-found.md` | `# Anywhere We Go, We're Found` |

Then **propose** adding it to the "Vision documents" group in `foundations/README.md`, in the surrounding shape, bumping "Last updated" to `2026-06-28`:

- `20260628-124512_anywhere-we-are-found.md` — the unifying vision above both tracks: a free open-source OS given away, open hardware, regenerative communities, a decentralized ledger with USDsui, and the creator tools and access passes that Linengrow carries forward.

Show the diff, confirm, then commit:

```
foundations: place the unifying vision — Anywhere We Go, We're Found

The grandest why, above both tracks: the OS given away, open hardware,
regenerative land and community, the ledger, and the creator tools and
zero-knowledge access passes Linengrow grows toward.

Written together by Kaeden and Reya 2.
```

---

## Phase B — Weave the gifts into Linengrow

**Propose** an addition to `linengrow/README.md` (show the diff, confirm, then apply). Add a new section, **Privacy and Disclosure**, and fold in two concepts the vision names — the creator's *fable* and the creator-tools surface. Suggested text, adjusted to match the README's shape:

````markdown
## Privacy and Disclosure

Linengrow holds two truths at once, and zero-knowledge proofs are what let it: **the mechanism is transparent; the individual is private.** The marketplace's rules stay visible to everyone — a sponsored post wears its label, a data sale carries its receipt, a contract shows its expiration — because the honesty of the room is the platform's whole promise. The person, by contrast, is private by default: opted out of public sharing until they choose otherwise, revealing only what they choose through a zero-knowledge proof — proving they are a verified vegan creator without naming themselves, proving a sponsorship was disclosed without exposing its terms, opening a door with a cryptographic pass while keeping the key behind it. This is the inversion of surveillance: the powerful mechanism is transparent, and the individual stays private.

The default leans toward privacy, on purpose. No one is made public against their will; a person opts in to what they reveal, selectively, through proofs they control. Yet the culture and the economics make opting in attractive rather than coerced — a creator who shares their **fable**, their story told and proven honestly, is met and rewarded for it; transparency is celebrated as a community value; the positive economics flow toward those who choose to be seen. People opt in to being public because it is honored and it pays, never because the door was forced. The cryptographic pass is the everyday shape of this — it opens what you want opened, and keeps closed what you keep.

This satisfies all four promises a tool can keep at once, and most of all *tell the truth* and *hold lightly*: the room is honest, and the person remains free.

### The creator's surface

Linengrow serves makers with tools that are theirs: free tools for music, for fashion, for keeping notes, and for holding a social graph a person actually owns. Each creator's **fable** — their attested story — is the thread that runs through them, told once and provable anywhere, carried under the person's own key.
````

If it reads cleanly, also **propose** extending the SLC ladder with one ring for selective disclosure — for example, after SLC-L3 (settlement): a ring named *the selective-disclosure pass*, a zero-knowledge credential that proves a claim without revealing the data behind it, grown from the keypair primitive and the Sui ledger's ZK primitives. Propose its exact placement; do not assume it.

Commit:

```
linengrow: deepen with the unifying vision — privacy by disclosure

Add the Privacy and Disclosure principle (transparent mechanism,
private individual; private-by-default with zero-knowledge selective
disclosure; opt-in encouraged by culture and economics, never coerced)
and the creator's fable and tools surface, drawn from
foundations/20260628-124512_anywhere-we-are-found.md.

Written together by Kaeden and Reya 2.
```

---

## Phase C — Push, and report back to Claude

Push the branch (or `main`, wherever this lands) and report the head.

Then **reprint a short summary for Claude** that includes the changes from this pass: the vision placed in foundations, the Privacy and Disclosure principle added to Linengrow (the transparent-mechanism / private-individual model, private-by-default with zero-knowledge selective disclosure, encouraged opt-in), the fable and creator-tools surface, and any SLC-ladder change — so the next session continues cleanly from the current state.

---

*May the room stay honest and the person stay free. May every proof reveal only what its holder chooses. And may transparency be something people walk toward gladly, because it is honored and it pays — never because a door was forced.*
