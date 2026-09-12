# The exit code that named two things

**Stamp:** `20260911.232010`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every reading below is published by a scan and gated by a
witness, and each figure names the instrument that answers it
**Kin:** [`../foundations/20260703-202312_the-marked-value.md`](../foundations/20260703-202312_the-marked-value.md) -
[`../foundations/20260826-021735_earth-the-row-that-breathes-in.md`](../foundations/20260826-021735_earth-the-row-that-breathes-in.md) -
[`../foundations/20260823-204456_single-stranded.md`](../foundations/20260823-204456_single-stranded.md) -
REDS `%532` - REDS `%460`

## What changed

`glow/glow_run.rye` is the language hop: hand it a `.glow` desk and it writes the `.rye` a build can
eat, printing that path on stdout. Beside the path it hands its caller an **exit code**, and three
instruments in this tree read that code by number --
[`../tools/fixtures/g/glow_desk_run_scan.sh`](../tools/fixtures/g/glow_desk_run_scan.sh) maps it onto
its own stage codes, and two more doors recite it in prose.

Each reader held its own account of what the numbers meant, since the module returning them stated
none. Two codes each carried **two meanings**, measured on metal `20260911.230925`:

| Code | One meaning | And the other |
|---|---|---|
| `1` | a lowering ran and failed | the source was never read at all |
| `2` | glow_run knows no head for this file | glow_run was called with no file |

Three edits close it. `main` catches `readFileAlloc` rather than reaching it with `try`, names the
error on stderr, and returns a new **`3 unreadable`**; both usage refusals return a new **`4 usage`**;
and the module's `//!` head carries the whole table, five rows, where the number is returned. The
downstream scan gains a sixth stage, `unreadable`, so a desk whose bytes went unseen keeps a name of
its own.

## Why the first collision is the one that costs

`readFileAlloc` was reached with `try`, so every read error returned through Zig's own `!u8` main,
which exits **1**. Probed on metal, three shapes land there and each rides in on a caller's own path
argument:

```
glow/gen/x/no-such-desk.glow   error: FileNotFound     exit 1
glow/gen                       error: IsDir           exit 1
a source past 64 KiB           error: StreamTooLong   exit 1
```

Downstream, `1` reads *glow_run's lowering failed* -- a claim about a **desk's content**, made for a
file whose bytes went unseen. So a desk deleted under a running pass, a path typed one letter aside,
and a generated desk grown past the module's own 64 KiB read ceiling each send the next reader into
the lowering chain, hunting a fault that lives elsewhere. All three answer `3` now, each naming its
own error on stderr:

```
glow_run: unreadable source glow/gen/x/no-such-desk.glow (FileNotFound)
```

## Why careful reading could never have fixed it

The scan that consumes these codes says, in its own door, that *glow_run draws the line itself, in
its own contract rather than in its prose*. That sentence was true, and it pointed one file aside:
the prose lived in the **reader**, where the writer of the number kept its own. So the reading was
taken by hand off metal and rewritten twice. REDS `%532` recorded the three unmarked data fixtures as
refusing one way. A correction on `20260908.234354` recorded them as refusing two ways. Metal answers
**three**, across both exit codes, and that second correction was itself made by matching an error
name -- the one reading the scan's own door warns against.

Two corrections, each honest, each made by a hand reading code that returned a number and kept quiet
about it. This is the [single-stranded](../foundations/20260823-204456_single-stranded.md) shape: one
number was asked to answer two questions, and a reader downstream held one answer for both.

## What holds it now

[`../tools/g/glow_run_contract_witness.rish`](../tools/g/glow_run_contract_witness.rish) over
[`../tools/fixtures/g/glow_run_contract_scan.sh`](../tools/fixtures/g/glow_run_contract_scan.sh) reads
three things and gates each at zero:

- **declared** -- the codes the module's `//!` head table names
- **returned** -- the codes `pub fn main` actually returns
- **probed** -- what the built binary answers when each shape is handed to it

`undeclared_returns` and `unreturned_declared` catch a table and an implementation drifting apart.
`probe_mismatch` catches the half they leave open between them: a table and a source that agree while
the binary answers otherwise. Six probes run per pass -- both usage shapes, all three unreadable shapes,
and one desk that lowers.

**Gates, rather than a ratchet.** A contract differs from a backlog: a code with two meanings is a
fault on the lap it arrives, so the population to work down is empty and a ceiling would hold air.

**The derivation states its own precondition and checks it.** `returned` is read
as `return <digit>;` at or after the `pub fn main` line, which is sound because the three helpers above
it return an optional slice, a `usize`, and a slice. Plant a helper above `main` that returns a bare
integer and the scan answers `verdict=derivation_unsound` rather than reading that helper's number as
an exit code.

**34 legs** stand proven in a throwaway pen under
[`../tools/fixtures/g/glow_run_contract_control.sh`](../tools/fixtures/g/glow_run_contract_control.sh),
every refusal planted and then lifted, and two mutations of the scan bitten -- disarming the
precondition refusal fails two legs, and disarming the probe comparison fails four. The pen's stub
binary spells the same contract in shell, so a mutation of the stub is a mutation of the **metal**
answer, which is what makes the `metal_disagrees` legs mean something: they restore the exact elder
collision, usage at `2` and an unreadable source at `1`, and watch the guard refuse both.

**An unbuilt binary is named rather than counted as proof.** A tree missing `glow/bin/glow_run` reads
`verdict=unprobed` with `probes=0`, keeping the two source-side readings and saying plainly that the
metal half went unread -- `%460`'s ruling one lane over, that a guard which can run its instrument is
the only one entitled to describe its subject.

## What this does not reach

**Exit 1 still carries two things**, and the head table says so: a lowering that broke, and the write
that follows a successful one. Both happen after the source is read and both are faults inside
glow_run's own work, so they share a code honestly rather than by accident. Splitting them would want
a new reading with a new witness, and every reader downstream treats them alike today.

**Whether `glow_run`'s 64 KiB read ceiling is the right number.** It is stated in the code, now named
in the contract as a reason a source reads unreadable, and left where it stood.

**The three unmarked data fixtures** of `%532` keep their ceiling of three and their open custody
question. What changed for them is that the stage each lands on is derived from a contract rather
than from a sentence somebody read.

## The row this lap read

Earth breathes in, and the row's question is the concrete one: what already stands true, before anyone
argues with it? An exit code is exactly that -- a small hard fact handed across a seam, read at the
door before any reasoning begins. [The marked value](../foundations/20260703-202312_the-marked-value.md)
asks that every value crossing a seam wear a mark naming its kind, and that an unknown mark meet the
wreck rule whole. A number that names two kinds sits past that foundation's reach, since it is a
**known** mark, read confidently, and true half the time.
