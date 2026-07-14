# Claude Counsel — Two Real Wins, One Real Wall, and Two Things About Rishi This Bench Had Wrong

**Stamp:** `20260708.042112 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** the same honesty that named camelCase's regex need — a wall found by testing is worth more than a migration forced past it, and a correction found the same way is worth writing down just as plainly
**Register:** An open invitation taken toward the `.sh` witness-support census this bench named as the next real opportunity — two files landed and verified whole, one real limitation documented, and two things this bench believed about Rishi turned out incomplete
**Ground:** all twenty-five remaining `tools/fixtures/*.sh` scripts read before choosing where to spend the round · `tools/fixtures/rs1_args_max.rish` and `tools/fixtures/rw1_exact_probe.rish` built, tested, and — for the first — proven through its full witness chain on the real interpreter · every claim about Rishi's grammar in this document tested directly, including two that corrected this bench's own earlier understanding

*Written by Kaeden and Rio 3.*

---

## Two Landed, Verified Whole

**`rs1_args_max.rish`** replaces the shell script that built sixty-five arguments with a `while` loop Rishi has no equivalent for. Rather than force an accumulation this language cannot do, the sixty-five arguments are written literally — verbose, and entirely inside proven grammar, which this bench prefers over a clever trick that might not hold. Getting it right took two real corrections, both caught by running the file rather than reading it: the runtime's own `"too many arguments"` rejection prints through `std.debug.print`, which is hardcoded to stderr in Zig, while Rishi's `say` writes to `std.Io.File.stdout()` directly — a different stream, unconditionally, regardless of what value is handed to it. The first draft tried to forward the wrong field to `say` and the wrapper checked the wrong field back; both are fixed now, and `tools/rs1_args.rish`'s full four-assertion witness — empty args, three args, out-of-range index, too-many-args — runs GREEN on the real interpreter, not merely inspected.

**`rw1_exact_probe.rish`** replaces `sed -n 2p | cut -f3` — line two, third tab-separated field, checked across every blob for an exact match. This one exists because of a real correction to this bench's own prior counsel: two sittings ago, this bench wrote that Rishi had no list-indexing syntax. That was wrong, or at least incomplete — `expr[n]` and `.len` are real, general operators, confirmed directly in `rishi/src/main.rye` and proven on the interpreter across a two-file fixture built for the purpose, matching and non-matching blobs both. The core logic is verified thoroughly; the one piece this bench could not complete end to end is wiring it through `rw1_history_contract.rish`'s full witness, which first builds `mantra/bin/mantra` from `mantra/src/main.rye` — a file whose own `../parse_int.rye` import hit a pre-existing wrapper-staging limitation on this bench, unrelated to anything touched here, and not one this bench attempted to fix, since it sits outside tonight's scope. The wrapper is updated to call the native file; confirming the full chain is worth a metal run before this is called completely proven.

## The Wall, Found by Testing Rather Than Assumed

`opening_lines_scan.sh` looked like the cleanest remaining candidate — four literal substring checks per file, no character-class regex anywhere, unlike `chrono_version_scan.sh` or `identity_shape.sh`'s PGP-fingerprint check. Building it found a real limit instead of a clean win: **a `where` clause whose input is itself a complex expression, rather than a plain already-bound name, fails with `UndefinedName`, even outside any loop.** `where [has_assert] as n: n == 0` works when `has_assert` is a name a `let` already bound; the identical logic inlined in place of that name does not. Four such checks per file — exactly what `opening_lines_scan.sh` and `tame_check_mantra.sh` both need — cannot be expressed as the single statement a `for-each` or `map` body requires without this composition working. This was tested, not inferred, before it was trusted enough to write down.

## The Census, Recalibrated Honestly

Reading all twenty-five scripts rather than stopping at the first finding sorted the remainder into real categories. **Needs a real regex** — the same honest exception class as camelCase: `chrono_version_scan.sh`, `identity_shape.sh`'s PGP check, `two_rooms_doorway_scan.sh` (which also needs case-insensitive alternation and lexicographic timestamp comparison). **Needs multi-condition-per-item composition** — the wall above: `opening_lines_scan.sh`, `tame_check_mantra.sh`, likely others once read this closely. **Needs something structurally different from backgrounding** — `slc1_accept.sh` pipes a prepared script into an interactive REPL over stdin and inspects real filesystem state after; whether Rishi's `run` can express stdin redirection is a genuinely open question this bench has not yet tested and does not claim an answer to. **Already fine, not yet attempted**: a handful of the smaller remaining scripts carry a single simple check apiece and simply ran out of round before the harder ones were fully read — a real, smaller remainder for a future sitting, not a wall.

## What Would Close the Wall, Offered and Parked

A clean fix exists: a way for a loop body to bind an intermediate name before its final expression — a `let … in <expr>` form, or a block body for `for-each` and `map` specifically. Two concrete, waiting consumers are named above, the same bar `parse_int` and `no_padding` were held to before this bench considered them ready to propose. The exact syntax is a genuine language-design choice and squarely a new-name question; this bench parks the shape rather than guess at Rishi's own taste for how it should read.

## Two Corrections Worth Keeping Where Future Work Will Find Them

Both belong in `TAME_GUIDANCE.md` rather than only in this counsel, so the next script that needs either fact does not have to rediscover it the hard way: **list indexing is real** — `expr[n]` and `.len` work generally, on any list, not only the specially-bound `args`. **`say` and the runtime's own error messages use different streams** — `say` always writes to stdout via `std.Io.File.stdout()`; `print`-based runtime messages (argument-count rejection, file-not-found, and similar) use `std.debug.print`, hardcoded to stderr regardless of context. A script capturing another Rishi process's output needs to know which field to check, and this bench did not, the first two times it tried.

---

*May a correction to one's own earlier counsel be written down as plainly as a fresh finding. May two real wins and one real wall both count as a full night's honest work. And may the next script that needs to know which stream carries which message find the answer already waiting, rather than spend the same hour this one did.*
