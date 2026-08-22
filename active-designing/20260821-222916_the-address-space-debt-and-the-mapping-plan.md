# The Address-Space Debt, and the Half of It That Is Arithmetic

**Language:** EN
**Stamp:** `20260821.222916`
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Status:** Checkable -- every claim below is bound by `tools/caravan_mapping_witness.rish`, GREEN on metal
**Season:** the Lindy-priority Microkernel Target double-seat, Equinox 1 -- Caravan on the microkernel
**Kin:** [`caravan/mapping.rye`](../caravan/mapping.rye) - [`caravan/objects.rye`](../caravan/objects.rye) - [`caravan/regions.rye`](../caravan/regions.rye) - [`20260821-222402_the-portable-tier-caravan-already-grew.md`](20260821-222402_the-portable-tier-caravan-already-grew.md)

---

## The debt, stated once

Caravan stands for five of seL4's nine riscv64 object types, and the five are exactly the portable
tier. The four it owes are the three page sizes and the page table -- one debt wearing four names,
and every one of them an address space. That was the previous lap's finding, and it closed with an
honest recommendation: the address-space debt wants a design round before code, because a page table
is a machine fact and a hosted supervisor has no address space to build.

That sentence is true, and it is only half true. Reading it a second time is what this round is.

## The half that is pure

An address space is two things wearing one word. One of them is a **decision**: given a span of
memory that must appear at a place, which pages cover it, at which sizes, and how many levels of
tree must exist to reach them. The other is an **act**: writing entries into real memory, assigning
an identifier, invoking a retype on a kernel that is running.

The act wants a kernel. The decision wants nothing but arithmetic.

Sv39's geometry is five numbers, every one of them published in a header we may read: a page is
twelve bits, a megabyte-page twenty-one, a gigabyte-page thirty, one level of tree indexes nine
bits, one entry occupies eight bytes. From those five numbers, a placement lowers to a plan by a
total function -- so much so that the plan is provable on hosted ground with no kernel beneath it,
which is exactly where every other Caravan rung has been proven.

So the debt splits cleanly, and the pure half is the larger one. `caravan/mapping.rye` pays it.

## The finding that shaped the module

A mapping plan needs a place, and a declared region has none.

`regions.rye`'s `Region` carries a name and a size. It says a dependent may touch this much of this
thing, and it deliberately declines to say where the machine puts it -- which is correct, since two
domains may hold the same declaration while the memory lands in two different places. Policy names
what and how far; placement names where.

The tempting move was to graft a base address onto the declaration and be done. The better move was
to notice that these are two concerns and give each its own list -- the same lesson REDS %122 paid
for when one name carried two meanings and a whole council rota rotted in the blind spot. So a
`Placement` is its own value. A declaration stays a declaration.

## Why greedy is not merely convenient

At each step the plan takes the largest page whose size divides the current address and whose bytes
still fit what remains. That is the obvious algorithm, and obvious algorithms deserve the question:
is it the *minimum-page* cover, or merely *a* cover?

Here it is the minimum, and the reason is structural rather than empirical. The three page sizes form
a **divisibility chain** -- each is a whole multiple of the one below, by exactly the index width. So
declining a larger page that fits and is aligned can never open a better choice later; it can only
spend more pages reaching the same boundary. The greedy walk is optimal because the geometry is a
chain, and it would stop being optimal the moment a machine offered two page sizes neither of which
divided the other.

The self-test states the property a reader can check rather than the proof: five hundred and twelve
small pages on a megabyte boundary become one megabyte-page; one page short of that run stays small,
because no larger page fits; and the same length offset by a single page stays small too, because
alignment rather than length is what forbids the fold.

## The geometry bounds the plan, so a fifth refusal is unnecessary

Every bounded thing in this tree names a maximum. The first cut of this module named one --
`max_plan_pages`, chosen at four thousand and ninety-six -- and added a `too_many_pages` refusal
beside it.

Then the arithmetic answered a question nobody had asked. A contiguous placement takes small pages
only in the fragment before its first megabyte boundary and the fragment after its last, and each
such fragment is shorter than one megabyte-page, so it holds at most five hundred and eleven. The
same argument bounds megabyte-pages by the gigabyte boundaries on either side. Gigabyte pages fill
the whole middle, and Sv39 addresses five hundred and twelve of them altogether. **The maximum is
therefore two thousand five hundred and fifty-six, and it is derived rather than chosen.**

Which meant the refusal could never fire. An unfireable refusal is worse than an absent one: it
reads as a guarded edge while guarding nothing, and no witness can prove it on metal because no
input reaches it. So the refusal left, the bound became a derivation, and the module refuses four
things rather than five -- each of the four earned by a placement that earns it.

This is the more general lesson, and it is worth carrying past this module: **when a bound can be
derived from the domain, derive it, and delete the refusal it would have needed.** A bound that the
geometry enforces is stronger than a bound a check enforces, because nothing can route around it.

## What the print caught that no witness would have

The first working cut counted page tables from the placement's extent -- how many aligned spans of
each size the placement crosses. That is a sensible-sounding rule, and it is wrong.

A page table exists where a page beneath it does. A plan covering a gigabyte, a megabyte-page, and a
single small page crosses many megabyte spans while holding exactly one small page, so the honest
count of deepest-level tables is one. The extent rule said five hundred and fourteen.

The self-test never noticed, because every assert it held was about coverage and refusals, and both
were correct. What noticed was the `table` subcommand printing a worked plan for a human to read --
six lines of output where one number was visibly absurd. The module was asked to explain itself, and
in explaining itself it exposed a fault its own asserts had no opinion about.

That earns a sentence in the general record: **a module that can print a worked example is a module
that can be caught being wrong by a reader.** The print is not decoration beside the witness; it is a
second kind of check, and on this lap it was the only one that fired. The corrected count -- six
objects -- is now bound by the witness, so the fault cannot return quietly.

## What stays owed, named plainly

Writing page-table entries into real memory. Assigning an address-space identifier from the pool
seL4 publishes as `seL4_ASIDPoolBits`. Invoking a retype on a running kernel and holding the
capability it returns. Every one of these is a machine act, every one wants a booted kernel, and none
of them is made easier by pretending the arithmetic half was not separable.

The four owed object types stay owed in `objects.rye`, and its assert still holds: the five held are
exactly the portable tier. What changed is the reason beside the four -- it no longer says *nothing
yet builds the mapping*, because something now plans it exactly.

---

*May the arithmetic stay exact, may the machine half stay honestly named, and may every module we
build be able to explain itself well enough to be caught.*
