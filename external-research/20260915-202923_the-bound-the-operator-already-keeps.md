# The Bound the Operator Already Keeps

**Stamp:** `20260915.202923`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Room:** Proposed, **research for understanding** -- the census below is checkable by the commands
this page carries, and the design direction stays proposed until a witness binds it
([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Instrument:** the four shell readings printed verbatim in *Re-run the census* at the tail; this lap
built no tool, so every figure is reproducible and nothing here is gated
**Kin:** [`the bound that names a joule`](20260905-232224_the-bound-that-names-a-joule.md) (extent
bounds and cost bounds are different questions) -
[`the toroidal archive read against the tree`](20260826-001743_the-toroidal-archive-read-against-the-tree.md)
(coordinate-as-address) - [`air, the row that feels`](../foundations/20260826-021732_air-the-row-that-feels.md)
(this lap's rota row: press each post and see whether the hand passes through)

---

## What this paper claims, before the argument

**This tree writes two different instruments with one word, and the word is `assert`.** One kind
checks a value that could have been otherwise. The other restates a property the expression on the
line above already guarantees, so it holds for every input the function can receive.

**Measured `20260915.202923` over 1,987 tracked `.rye` paths, resolving to 1,754 unique files: 13
assert statements at 11 modulo sites across 7 files are of the second kind.** Each follows a `%` or an `@mod` and asserts a bound
the operator's own definition supplies. Against 34,852 assert statements in the tree the class is
tiny, and its interest lies in what it is rather than in how much of it there is: three unrelated module rooms reached for the same shape independently.

**The design claim rides on that observation.** Where a wrapped coordinate is the meaning -- a
queue's ring, a residue field, a tiled paint, a hue -- the representation carries the extent bound
and the edge disappears. A program that chooses such a representation deliberately spends its
checking budget where a value could still surprise it.

**The counterweight is stated as plainly as the claim.** A wrap converts an out-of-range index into
a valid index holding the wrong answer, and a wrong answer travels further than a stopped program.
So the technique earns its place where periodicity is the subject, and it earns suspicion elsewhere.

**Scope.** Everything measured here was read from the working tree of `grain-diffuser` at commit
`d447bfa97` on `20260915`, over tracked `.rye` sources alone. The paper leaves guard correctness,
performance, and every question about energy entirely alone. Every assert named below stands as correct code; the paper describes rather than prescribes.

---

## The fact at the door

`caravan/queue.rye` places one sequence number into one slot of a ring, and it writes the invariant
out loud before it writes the arithmetic:

```zig
fn slot_offset(seq: u32) u64 {
    // invariant: wrap-as-periodic -- the queue is a ring, so a linear sequence
    // number landing back on an early slot is the meaning of the modulo rather
    // than an overflow; a slot is reused only after its ask is retired [...]
    const ring: u32 = seq % max_outstanding;
    // invariant: the slot chosen addresses the declared ring
    assert(ring < max_outstanding);
    return @as(u64, index_bytes) + (@as(u64, ring) * @as(u64, slot_stride));
}
```

**That assert holds for every value of `seq`.** For unsigned operands and a positive modulus,
`x % N < N` is the definition of the operator rather than a fact about the program. The check has
no failing input, and it never will while the line above it stands as written.

The comment three lines earlier is the interesting part. It says *wrap-as-periodic*: the author knew
the wrap was the meaning, named it, and then reached for an assert anyway. That reach is the habit
this paper is about.

---

## Observation -- the census

Two spellings of the same operator, read over tracked `.rye` sources:

| Site | Expression | Assert | Kind of wrap |
|---|---|---|---|
| `caravan/queue.rye:226` | `seq % max_outstanding` | `ring < max_outstanding` | queue ring |
| `crypto/mldsa_ring.rye:85` | `(a + b) % q` | `r < q` | residue field |
| `crypto/mldsa_ring.rye:96` | `(a + q - b) % q` | `r < q` | residue field |
| `crypto/mlkem_ring.rye:80` | `(a + b) % q` | `r < q` | residue field |
| `crypto/mlkem_ring.rye:90` | `(a + q - b) % q` | `r < q` | residue field |
| `crypto/mlkem_ring.rye:100` | `(a * b) % q` | `r < q` | residue field |
| `crypto/mlkem_sample.rye:162` | `(x + q - y) % q` | `v < q` | residue field |
| `image/repeat_paint.rye:69` | `c % period` | `cycle < period` | tiled paint |
| `image/repeat_conic_paint.rye:116` | `(t * reps) % den` | `tile < den` | tiled bearing |
| `image/color.rye:298-299` | `@mod(hh, 360)` | `hh >= 0` and `hh < 360` | hue turn |
| `image/color.rye:309-310` | `@mod(t, 360)` | `t >= 0` and `t < 360` | hue turn |

**Eleven sites, thirteen assert statements, seven unique files in three module rooms, four kinds of
wrap.** Caravan's queue ring, two post-quantum residue fields and their sampler, two paint tilers,
and a colour conversion's hue turn. The three rooms share no code, and each reached the shape
alone.

**The `@mod` half was invisible to the first reading, and the miss is worth recording.** The scan
knew one spelling of the modulus and found nine sites; widening it to Zig's `@mod` builtin found
four more assert statements the same afternoon. **A census reports the vocabulary it was handed**,
which is the sentence the water row's seat already carries about naming conventions, met here from a
different door.

**A symlinked source counts twice unless a reading asks the filesystem.** `pond/apps/color.rye` is a
symlink to `image/color.rye`, so a path-based scan reported eight `@mod` asserts where four stand.
That is the shape COPAL booked on the card this same day -- a guard counting one file as two roofs,
repaired by reading inodes. Two ships met one class through two doors inside an hour, and the count
above is the de-duplicated one.

---

## What the two instruments actually are

**A checked bound asks a question the program could answer either way.** `assert(text.len <=
max_message_len)` in the same Caravan file can fail, because a caller may hand it a longer message.
The assert is the wall between a caller's mistake and a corrupted slot.

**A guaranteed bound restates the shape of the value.** `assert(ring < max_outstanding)` asks a
question with one answer. Nothing a caller does reaches it, since the modulo landed the value inside
the range before the assert read it.

**The second kind still earns its line, for a reason that lives at edit time rather than at runtime.** It is an
**anchor on the expression**: the moment a hand rewrites `seq % max_outstanding` as `seq`, the
assert stops being tautological and starts failing. So it guards the code as written rather than the
values flowing through it, and this tree changes code far more often than it receives hostile input.

**Naming the difference is free, and it buys two things.** An assert census reads more honestly
when it can tell a wall from an anchor, and a designer choosing a representation can see which
bounds the representation will keep for them.

---

## Inference -- the wrap as a design technique

**A modular coordinate space has no edge, so it has no edge case.** Every value of the index type
names a real slot. The bound moves out of the control flow and into the type's own arithmetic, where
it holds by construction rather than by a check somebody remembered to write.

This is the toroidal claim in its smallest honest form. The archive papers argue it for a wafer, a
network, and an optimizer on a compact domain; the same property shows up in a 256-byte ring and a
hue wheel, and it is the same property. **Uniform topology means bounded known distances**, and a bounded known distance is a bound the shape itself keeps.

**Three module rooms reached for this before anyone named it**, which is evidence about the
technique's naturalness rather than about anyone's discipline. A shape five unrelated authors find
alone is a shape worth writing down.

---

## The counterweight, stated as hard as the claim

**A wrap converts a range error into a value error, and value errors are the expensive kind.**
An index that runs past the end of a flat array meets an assert and stops the program at the line
that was wrong. The same index on a ring lands on slot three, reads somebody else's message, and
returns it to a caller who has no way to know.

So the technique carries a precondition, and the precondition is about meaning rather than about
types: **wrap where periodicity is the subject.** A queue genuinely is a ring; a residue field
genuinely closes; a hue at 370 degrees genuinely is a hue at 10. An array index that exceeded its
array is none of these, and a `%` written there is a disguise rather than a design.

**Caravan's own comment shows the discipline working.** It states that a slot is reused only after
its ask is retired, and names the in-flight bound that holds it. The wrap is safe there because a
separate bound makes it safe, and the author wrote that dependency down. A wrap whose safety rests on a bound left unwritten is the shape to distrust.

---

## Projection

**Horizon:** the next two chapters of Caravan, Tally, and Aurora work.

**Claim:** a small, named wrapped-index helper in Tally -- one type carrying a modulus, its
constructor asserting the modulus is positive, and an accessor returning a value the type system
knows is in range -- would let the eleven sites above share one anchor instead of thirteen, and would
give a future site the shape without requiring its author to rediscover it.

**Assumptions:** that Zig's comptime can carry the modulus in the type; that the sites stay
few enough for a shared helper to pay for its own indirection; and that the tree's bound-everything
discipline welcomes a bound held by a type rather than by a line.

**Falsifier, in one measurement:** if a reader finds one site in this tree where a `%` or an `@mod`
absorbed a genuine out-of-range value and produced a wrong answer that shipped, the safety half of
this argument is refuted for this tree, and the recommendation narrows to *document the
tautology and stop there*. The census above found none, and the census read eleven sites rather than
the whole tree, so absence here is weak evidence.

**A second falsifier, cheaper:** if a widened scan over the remaining modulo sites in the tree
returns a large population -- say above a hundred -- then this is an ordinary idiom rather than a
rare deliberate one, and the "three rooms found it alone" observation loses its force.

**Confidence:** high that the thirteen asserts are tautological, since each was read by hand against
its own expression. Moderate that a shared helper is worth building, since eleven sites is a small
population and this tree rightly distrusts abstraction bought cheaply. Low on anything past that.

---

## Handed to Bakery, buildable today

**One scan, under law already seated.** A reading that finds an assert restating its own line's modulo, in both
spellings, resolving symlinks by inode before it counts. It reports rather than gates, because every
site it finds is correct code. Its value is the census, and a census of this class has never been
taken here.

**What it cannot do, said at the door.** Type knowledge lives in the compiler, so a scanner cannot
tell `assert(fd >= 0)` on a signed file descriptor -- a real check -- from `assert(hh >= 0)` on a
Euclidean modulus -- a tautology. This paper read 91 candidates of that shape by hand and admitted
only the four it could prove. A scanner asked to guess would report the other 87 as faults.

**What stays out of scope for a scan entirely.** `brushstroke/photos.rye:400` computes
`fy = py - @divFloor(py, unit) * unit` and asserts `fy >= 0`. That expression is `@mod` written
long-hand, so the assert is tautological too -- and seeing it takes the floor-division identity
rather than a pattern. A reader finds it; a scanner passes over it.

---

## What this paper does not reach

**Whether any of the thirteen asserts should change.** Every one is correct, every one documents a
real invariant in the tree's own `// invariant:` grammar, and every one anchors its expression. The
paper names a distinction and stops.

**The cost of an assert.** `std.debug.assert` is a no-op under `ReleaseFast` and `ReleaseSmall` and
live under `Debug` and `ReleaseSafe`, so what these thirteen lines cost at runtime depends on a
build mode this paper never read. The performance argument stays unmade for that reason.

**The wider modulo population.** The census read asserts standing within four lines of their own
modulo. A `%` whose bound is asserted six lines later, or in a caller, or never, sits outside every
reading above.

---

## Re-run the census

Each reading is one command from the repository root. **Run them rather than trusting the figures**,
which are free in Gauge's sense: they move as the tree moves.

```sh
# 1 -- every assert statement in tracked Rye sources (read 34,852 on 20260915)
git ls-files '*.rye' | xargs grep -c 'assert(' | awk -F: '{s+=$2} END {print s}'

# 2 -- the percent spelling: a value assigned `% N`, asserted `< N` within four lines
git ls-files '*.rye' | while read -r f; do awk -v F="$f" '
  { lines[NR]=$0 }
  END { for (i=1;i<=NR;i++) { l=lines[i]
      if (match(l, /[A-Za-z_][A-Za-z0-9_]* *(:[^=]*)?= *[^;]*% *[A-Za-z_][A-Za-z0-9_.]*;/)) {
        v=l; sub(/^[ \t]*(const|var)[ \t]+/,"",v); sub(/[ :=].*/,"",v)
        m=l; sub(/.*% */,"",m); sub(/[; ].*/,"",m)
        for (j=i+1;j<=i+4 && j<=NR;j++)
          if (lines[j] ~ ("assert\\(" v " *< *" m "\\)")) print F ":" j ":" lines[j] } } }' "$f"
done

# 3 -- the builtin spelling, which reading 2 cannot see
git ls-files '*.rye' | while read -r f; do awk -v F="$f" '
  { lines[NR]=$0 }
  END { for (i=1;i<=NR;i++) { l=lines[i]
      if (match(l, /@mod\(/)) {
        v=l; sub(/^[ \t]*(const|var)?[ \t]*/,"",v); sub(/[ :=].*/,"",v)
        m=l; sub(/.*@mod\([^,]*, */,"",m); sub(/\).*/,"",m)
        for (j=i+1;j<=i+4 && j<=NR;j++)
          if (lines[j] ~ ("assert\\(" v " *< *" m "\\)") || lines[j] ~ ("assert\\(" v " *>= *0\\)"))
            print F ":" j ":" lines[j] } } }' "$f"
done

# 4 -- de-duplicate a symlinked source before counting files
git ls-files '*.rye' | xargs -I{} readlink -f {} | sort -u | wc -l
```

Reading 3 returns eight lines for four sites, because `pond/apps/color.rye` is a symlink to
`image/color.rye`. Reading 4 is what tells you so, and it answers 1,754 unique files against the
1,987 paths reading 1 walks -- 233 of this tree's tracked Rye paths are links to a file already
counted.

---

## Addendum -- the census re-run, and the cheaper falsifier answered

**Stamp:** `20260916.000127`. The paper above was written on `20260915`, parked in a stash, and
never landed. This addendum is the lap that recovered it, re-ran every reading it publishes, and
answered the second falsifier it left open. Nothing in the body above is edited; what follows
accretes beside it.

### Reading 3 as published crashes, and it hid nothing

**The `@mod` reading builds a regular expression out of the text it just matched, and it does not
escape the metacharacters in it.** Three tracked sources carry a nested call on a `@mod` line --
`crypto/mldsa_encode.rye:480`, `lotus/crush.rye:240`, and
`rye/tests/mem_align_any_align_test.rye:18` -- so the interpolated variable name arrives holding an
unbalanced `(`, and awk exits with `fatal: invalid regexp` for that whole file. The four real sites
still print, because awk fatals per file rather than per run, so a reader sees the right answer
beside three error lines and has no way to tell which files went unread.

**The repair is one function, and the corrected reading also drops the symlink double-count in the
same pass** by walking inodes rather than paths:

```sh
git ls-files '*.rye' | xargs -I{} readlink -f {} | sort -u | while read -r f; do awk -v F="$f" '
  function q(s) { gsub(/[][(){}.*+?^$|\\]/, "\\\\&", s); return s }
  { lines[NR]=$0 }
  END { for (i=1;i<=NR;i++) { l=lines[i]
      if (match(l, /@mod\(/)) {
        v=l; sub(/^[ \t]*(const|var)?[ \t]*/,"",v); sub(/[ :=].*/,"",v)
        m=l; sub(/.*@mod\([^,]*, */,"",m); sub(/\).*/,"",m)
        v=q(v); m=q(m)
        for (j=i+1;j<=i+4 && j<=NR;j++)
          if (lines[j] ~ ("assert\\(" v " *< *" m "\\)") || lines[j] ~ ("assert\\(" v " *>= *0\\)"))
            print F ":" j } } }' "$f"
done
```

**Run on `20260916.000127` it returns the same four sites and no others**, each once. So the crash
concealed nothing, and the census's thirteen asserts at eleven sites across seven files stand
exactly as the body reports them. **A reading that fails loudly and partially is the dangerous
shape**, since the output looks like an answer; this one was caught only because a later hand ran
the command it published instead of trusting the table.

### The wider population, measured -- the operator is ordinary, the anchor is not

The body names a cheap falsifier: *if a widened scan over the remaining modulo sites returns a large
population -- say above a hundred -- then this is an ordinary idiom rather than a rare deliberate
one.* It stood unanswered. Measured `20260916.000127` over the same 1,754 unique tracked `.rye`
files:

| Reading | Count |
|---|---|
| Modulo sites, both spellings, comments and string lines excluded | **169** across **83** files |
| Of those, sites carrying the assert anchor within four lines | **11** across **7** files |

**169 is above the hundred the falsifier named, so the operator half of the claim is refuted and the
paper's scope narrows.** Reaching for `%` is ordinary in this tree. **What stays is the narrower
and more interesting fact: 11 of 169 sites, 6.5 percent, follow the modulo with an assert restating
its bound**, and those eleven fall in three module rooms that share no code. The observation the
body draws from -- that several unrelated authors reached for one shape alone -- survives; the
implied rarity of the *operator* does not, and was never what the evidence supported.

**Counting the operator took two attempts, and the first was wrong in the paper's own direction.**
Zig spells wrapping addition and multiplication `+%` and `*%`, so a naive modulo grep admits every
wrapping-arithmetic line in the tree and reported 299 where 156 stand. That is *a census reports the
vocabulary it was handed* met a third time, and in the harder direction: the first miss dropped a
spelling the reading did not know, and this one admitted a spelling that merely looked alike.

### Figure refresh

Reading 1 answers **34,884** assert statements on `20260916.000127`, against the 34,852 the body
records for `20260915`. Both are free figures that move with the tree, exactly as the body says, and
the thirty-two between them are one day of ordinary work rather than a finding.

---

*May every fence in this tree be one a hand can find, and may the ones the shape itself keeps be
named as the gift they are.*
