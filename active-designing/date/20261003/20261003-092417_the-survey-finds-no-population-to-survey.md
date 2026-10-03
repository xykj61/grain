# The survey finds no population to survey

**Style:** Gauge, Field setting -- **Status:** Living, checkable -- **Stamp:** `20261003.092417`
**Kin:** [The witness reads ok at every boundary it names](20261003-082538_the-witness-reads-ok-at-every-boundary-it-names.md) - [The one live site cannot see its own drift](20261003-042550_the-one-live-site-cannot-see-its-own-drift.md)

## The question

The prior essay found a gap specific to `tools/g/glow_compose_tend_unary_witness.rish`: all ten of
its boundary assertions run a `*-lawful-u32` gate and check `gate.ok` alone, leaving the `0`/`1`
digit the gate prints entirely unread. It named the next falsifier rather than running it: "whether
the same shape recurs across the roughly twenty sibling Glow Tend limb witnesses." This essay runs
that falsifier.

## The population, counted rather than guessed

A population matching the file-naming pattern `*_glow_tend_limb*_witness.rish` exists at exactly
**23** files, dated `20261003.092417`, read by:

```sh
ls tools/*/*_glow_tend_limb*_witness.rish | wc -l
```

Four belong to Aurora, four to Caravan, nine to Mantra, six to Tally. "Roughly twenty" was close:
twenty-three.

## What the falsifier asks, and what it finds

The falsifier asks whether any of the 23 composes a `*_lawful` gate call the way
`glow_compose_tend_unary_witness.rish` does -- run the gate, assert `.ok`, leave `.out` unread. Two
greps answer it for every file at once:

```sh
for f in tools/*/*_glow_tend_limb*_witness.rish; do
  echo "$f lawful=$(grep -c '_lawful' "$f") exit0=$(grep -c 'contains \"EXIT:0\"' "$f")"
done
```

Every one of the 23 reads `lawful=0`: each stays clear of calling a `*_lawful` gate. Twenty-two
read `exit0=1` and one (`mantra_glow_tend_limb5_witness.rish`, which tends two shapes in one limb)
reads `exit0=2`, and `grep -rl "_lawful" tools/ --include=*.rish` confirms separately that across
the whole tree only `glow_compose_tend_unary_witness.rish` composes more than one `*_lawful` gate
call -- the eight other hits for the bare string `_lawful` in `.rish` files (`aether_falloff_witness.rish`,
`link_touch_witness.rish`, `mantra_document_roundtrip_witness.rish`, `pin_bound_touch_witness.rish`,
`port_band_witness.rish`, `receipt_chain_witness.rish`, `shelf_link_touch_witness.rish`) use the
word "lawful" in an unrelated sentence rather than naming a Glow gate.

The falsifier is answered, and it closes the question rather than confirming the worry: the shape
stays confined to the one file, because the 23 limb witnesses test a different kind of Glow Tend
pedestal entirely. Each tends a **shape** -- one `src/shape/shape-*.glow` or
`src/gate/shape-*.glow` file declaring a single constant or a struct's field layout -- and its
closing check lowers that shape to Rye, builds it, and runs it, asserting the run's own output
`contains "EXIT:0"`. A build-and-run exit code is a binary pass/fail outcome with every character
of its surface already read by that one assertion; the gates `glow_compose_tend_unary_witness.rish`
runs are a different animal, a Rye boolean (`true`/`false` dressed as a Glow `0`/`1`) printed
specifically so a caller can read *which way* the boundary fell. The shape-pedestal witnesses in
fact read `.out` far more thoroughly than the unary witness does whenever there is real content to
check -- `mantra_glow_tend_limb5_witness.rish` greps a placard's own declared field count out of the
shape file and compares it, string for string, against `rye_struct_fields_scan.sh`'s live read of
the Rye struct, twice, once for `ConsentGrantFact` and once for `ConsentRevokeFact`. The gap the
prior essay found is a trait of the one witness that composes `*_lawful` boundary gates together,
because that is the one place in the tree where a printed digit, rather than an exit code, is the
thing actually under test.

## What this means for the open repair

The prior essay priced a ten-assertion repair inside `glow_compose_tend_unary_witness.rish` alone
and named a survey as the next open question. That survey closes clean: the named population of 23
stands clear of the gap, and the repair stays scoped exactly where the prior essay left it. This
essay's contribution is closing the uncertainty about the repair's true size, leaving it exactly as
priced.

## Falsifier for a later lap

A shape-pedestal witness composing more than one `*_lawful` gate call would reopen this question;
today's 23 all stay clear of it, and a new limb witness built on the same
`glow_compose_tend_unary_witness.rish` template would earn a fresh read of its own rather than
inheriting this count.

**Falsifier:** confirmed closed on metal, via two whole-population greps rather than a sample.
**Confidence:** high; the measurement is exhaustive over a named, counted file set, scoped to this
host's own tracked tree and the single stamp of this reading.

**Built fresh for this essay: zero.** Two shell commands, printed above, read tracked `.rish`
source alone; every file on this host stands exactly as it did before this essay opened.
