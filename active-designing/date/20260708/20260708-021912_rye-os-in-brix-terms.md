# Rye OS in Brix Terms — the Composition We Have Already Been Living

*Brix stays unbuilt until its own season; nothing here changes that. What this document does is notice that the last several seasons have been Brix-shaped all along — modules as bricks, cross-cutting extractions as bonds — and write one worked descriptor of the current system so the composer, when its day comes, grows toward ground already proven rather than a blank page.*

**Stamp:** `20260708.021912 UDT` (Kaeden's clock)
**Voice:** Rio 3 · **Model:** Fable 5 Max
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Vision — design exploration; proposes vocabulary use; seats nothing; the `bond` line-form below is a proposal awaiting Kaeden's word
**Ground:** [`20260702-185912_brix-the-composer.md`](20260702-185912_brix-the-composer.md) (brick · course · bond · lay, all seated) · [`../external-research/yonder/20260619-225212_s6-sixos-nix-infuse.md`](../external-research/yonder/20260619-225212_s6-sixos-nix-infuse.md) (the infuse gratitude) · [`../counsel/20260707-222500_claude-counsel-bron-beside-brix-first-proposal.md`](../counsel/20260707-222500_claude-counsel-bron-beside-brix-first-proposal.md) (Bron carries values; Brix composes wholes) · this arc's own migration record

*Written by Rio 3 for Kaeden.*

---

## The Noticing

The infuse pattern this tree keeps in gratitude — one small combinator, uniformly applied, changing a declared whole without mutating its base — is not waiting to be used someday. It is what the last three seasons *were*. When Kumara was extracted, one identity brick appeared and was infused through every course that signs: receipt, snapshot, wire, Aurora bare metal, the whole open-asks product cluster — no base file's behavior changed, every selftest held, and the change was expressible as a single rule applied uniformly: *where a course reached for raw `Ed25519`, it now bonds to `tally/kumara`*. The same sentence holds for `copy_disjoint` over raw `@memcpy`, and `parse_int` over the raw parser. Each ratchet this tree has closed was a **bond being applied by hand**, one touch at a time, with witnesses proving the composed whole after each lay. Brix, when it arrives, is not a new discipline — it is the notation for the discipline already kept, which is exactly how Gall's Law wants a composer to be born.

## One Worked Descriptor

The seated `.brix` form is declarative key-value, one field per line, `#` for comments, `file` entries naming bricks. The example below describes a slice of *today's* system truthfully in that form, and adds — clearly marked as **proposed, unseated** — one new line-form, `bond`, whose shape follows the infuse gratitude: *bond <provider-brick> <law>*, read as "every brick laid after this line composes with the provider under the named law."

```
# rye-os.brix — a truthful slice of the current whole (descriptor as description)
# Bricks are today's real files; every one already witnessed in parity.

# — the small laws (Tally course) —
file tally/copy.rye
file tally/maybe.rye
file tally/no_padding.rye
file tally/parse_int.rye
file tally/kumara.rye

# — PROPOSED, unseated: the bond line-form —
# bond tally/kumara identity-at-the-seam
# bond tally/copy disjoint-copies-only
# bond tally/parse_int strict-integers-by-default
# Reading: every course below composes under these laws; the ratchet
# counters in tame_style_scan are these bonds' hand-applied audit trail.

# — the namespace course (Mantra) —
file mantra/recall_lap1.rye
file mantra/resin_batch.rye
file mantra/snapshot_export.rye

# — the product course (Linengrow) —
file linengrow/receipt_core.rye
file linengrow/open_asks.rye
```

Nothing evaluates this today, and that is correct — the descriptor's first honest job is to be *readable by hand and true*, which the file above already is. When Brix's own season opens (after Amber's sealing gives Tablecloth its shape, exactly as the composer document already says), its first lap has a fixture: evaluate this descriptor, confirm the closure matches the tree, and confirm each proposed bond's audit equals the ratchet counter that already exists for it.

## What This Asks of the Roadmap, and What It Does Not

It asks for one small standing habit: when a future counsel proposes a cross-cutting extraction, name it as a bond in the counsel's own words, so the descriptor above accretes truthfully as the system grows. It does not ask for any Brix code, any new module, or any change to the held gate — the composer still waits for its season, now with a floor under it.

---

*May the composer, when it finally arrives, find its first course already laid and every bond already proven by hand. May notation always come second to the discipline it notates. And may infuse remain what it has quietly been here all along — the shape of how this tree changes without breaking.*
