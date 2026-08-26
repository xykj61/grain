# Chemical Formulas -- This Tree's Operations, Written as Reactions

**Language:** EN
**Stamp:** `20260823.223157`
**Style:** Gauge, Door setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Registers:** Gauge - Civic - TAME
**Voice:** Kyri
**Status:** Living
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Mirrored at:** `biochemistry/README.md`, declared in [`../context/document-mirrors.brix`](../context/document-mirrors.brix) and proven byte-identical

---

Chemistry writes a reaction as a line: what goes in on the left, what comes out on the right, and a
conservation law holding across the arrow. This page writes this project's core operations the same
way, for one reason -- **a formula makes the conserved quantity impossible to overlook.**

Read the arrow as *becomes*, and read `+` as *together with*.

## Naming and storing

```
name + bytes            ->  binding                 Mantra: a name is bound, once
binding + name          ->  bytes                   the same bytes, every time
weave(name_1..name_n)   ->  bytes_1..bytes_n        a bounded bulk read, order preserved

bytes                   ->  resin                   Tablecloth: SHA3-512, written in hex
resin + store           ->  bytes                   a read: those bytes, or nothing
bytes + store           ->  resin + store'          a write: the store grows, and never changes
```

**Conserved:** the pairing. Nothing in the notation re-binds a name, because nothing in the module
does either.

## Declaring and sealing

```
declaration + world     ->  infusion -> world'      Brix: the world comes to match the declaration
infusion(world')        ->  world'                  idempotent: running it twice does what once did

payload + seal          ->  amphora                 a sealed vessel, opened by its addressee
amphora + key           ->  payload                 or nothing at all, when the key is wrong
```

**Conserved:** the declaration. An infusion moves the world rather than the statement about it.

## Receipting

```
payload                          ->  resin                     the content address
resin + stamp + kind + subject   ->  receipt                   Kyri 6
receipt + signer + sig           ->  attested receipt          a custody gate, not an automatic step
```

**Conserved:** the payload's identity. Two receipts naming one payload are the same receipt.

## Tending the writing

```
fossil + mutant                        ->  molt              new skin seated, old skin kept
fossil + mutant + banner + row         ->  mitra prep        a molt seen all the way through
mitra prep + Keaton's word             ->  shed              the cut, and it stays refused until then
living card + checkpoint + word        ->  debride           dead tissue removed, the way back marked
```

**Conserved:** the record. Every one of these keeps the old reading reachable; only **shed** removes
anything, and only on a word spoken by name.

### add to molt queue

A small operation with its own formula, because it is the one people reach for most and the one
most often done from memory:

```
document + measurement  ->  queue row               prep only; no file moves, no cut opens
```

**What it takes:** the document's path, its inbound citation count split into living and dated, and
whether a living mutant already exists.

**What it produces:** one row in `construction/SHRED_PREP.md` (a live operator card the public seed withholds, named here rather than linked)
under the class the measurement earns -- **H** when a mutant already stands, **W** when the walk
found the document too well cited to move, **M** when a mitra prep is complete.

**What it never does:** touch the document. Adding to the queue is a note about a file rather than
an edit of one, which is what makes it safe to do early and often.

## Growing and grouping

```
seed + chapters          ->  tree                    the long form, and the only one that keeps
round + round + round   ->  chapter                  bounded work, closed on its crux
lap                     ->  lap                     complete in itself, owing the last one nothing
```

**Conserved:** the crux. A chapter closes when its hardest solvable problem is solved, rather than
when a checklist empties. The cycle the chapter names are drawn from has its method at
[`../classical-vedic-astrology/README.md`](../classical-vedic-astrology/README.md).

## Why write them this way at all

**A formula is checkable in a way a paragraph is not.** If a sentence claims an operation is
idempotent, you nod. If a line says `infusion(world') -> world'`, you can go and test it -- and this
tree does, in `tools/fixtures/document_mirror_control.sh` among others.

**It exposes what a description hides.** Writing the mitra prep as
`fossil + mutant + banner + row` makes the four inputs visible at a glance, so a prep missing its
banner is visibly incomplete rather than arguably fine.

**It is honest about what is conserved.** Every family above names its conserved quantity, and that
sentence is the one worth arguing with. If a conserved quantity is wrong, the operation is wrong,
and the formula is where that shows.

## The limit

**These are notation rather than proof.** A formula records an intention precisely; a witness on
metal is what makes it true. Where an operation here is proven, the proof is named in the module's
own page. Where it is intended, the page says so.

---

*May the arrows point the right way, and may what is conserved stay conserved.*
