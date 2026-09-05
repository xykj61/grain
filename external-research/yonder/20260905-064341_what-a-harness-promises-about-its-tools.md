# What a Harness Promises About Its Tools

**Stamp:** `20260905.064341`
**Language:** EN
**Style:** New Gauge, Field setting -- every figure carries its unit, date and source; every projection its falsifier
**Voice:** Kyri
**Status:** Yonder study -- deferred yet alive; external world with attribution, per the clean-room discipline
**Room:** Vision, not checkable. Nothing here binds until a witness does (`context/TWO_ROOMS.md`).
**Kin:** [`../../.claude/rules/gratitude-licenses.md`](../../.claude/rules/gratitude-licenses.md) - [`../../tools/fixtures/s/shell_portable.sh`](../../tools/fixtures/s/shell_portable.sh) - [`../../tools/fixtures/s/shell_dialect_scan.sh`](../../tools/fixtures/s/shell_dialect_scan.sh)

An agent harness and a witness suite are the same kind of thing wearing different clothes: both are
programs that must reach a machine's tools and must survive not finding them. This study measures
what this tree actually depends on, reads what two harnesses do about the same problem, and names
the gap. It builds nothing. The siloed answer is its companion in `active-designing/yonder/`.

## Assumptions, before the numbers

Counted `20260905.064341` on the Dallas pier (NixOS, x86_64) over **2,969 tracked tool scripts** --
`tools/**/*.sh` and `tools/**/*.rish`. A site is a utility name in **command position**: at the
start of a statement, or after a pipe, semicolon, `&&`, `||`, `$(`, backtick, `then`, `do`, `else`,
or `{`. Full-line comments are excluded. The count over-reads where a comment sits inline after
code and under-reads where a name is built at runtime, so treat every figure as a **floor with a
narrow band**, not a census. Probe counts are literal `command -v <name>` occurrences.

## What this tree depends on

**52 distinct external utilities** stand in command position. The ten heaviest:

| Utility | Sites | `command -v` probes | In POSIX? |
|---|---|---|---|
| `grep` | 1,958 | -- | yes |
| `printf` | 1,523 | -- | yes |
| **`rg`** (ripgrep) | **992** | **1** | **no** |
| `git` | 964 | 10 | no |
| `test` | 737 | -- | yes |
| `tr` | 647 | -- | yes |
| `sed` | 645 | -- | yes |
| `wc` | 452 | -- | yes |
| `awk` | 434 | -- | yes |
| **`mktemp`** | **353** | **0** | **no** |

Two readings carry the study.

**`rg` is invoked 992 times and probed once.** ripgrep is not a POSIX utility and ships on no system
by default. It is present on this pier (`ripgrep-15.1.0`), which is exactly why 992 sites are green
here and say nothing about anywhere else. One guard, `tools/co/collision_guard.rish`, does the
honest thing -- `command -v rg >/dev/null 2>&1 && echo HAVE_RG || echo NO_RG`, then falls back to
`grep` and *announces which searcher it used*. It is one guard in 2,969.

**`mktemp` is invoked 353 times and probed zero times, and it is not in POSIX.** Its specification
was **removed at POSIX.1-2008** and it is absent from the IEEE Std 1003.1-2024 command list. Every
throwaway pen in this tree's controls opens with it.

A correction worth recording, because the first draft of this study had it wrong: **`readlink` IS
POSIX**, as are `realpath`, `timeout`, `xargs`, and `iconv`. The non-portable part of `readlink -f`
is the **flag**, not the utility -- which is precisely what
`tools/fixtures/s/shell_dialect_scan.sh` already gates. Assuming a whole utility is unavailable
because one of its flags is GNU-only would have retired four portable tools for no reason.

## What this tree already built, and how little of it is used

The tree diagnosed this and wrote the cure. `tools/fixtures/s/shell_portable.sh` publishes eleven
helpers over exactly the seams that differ between GNU and BSD -- `xargs_lines`,
`xargs_lines_batched`, `stamp_epoch`, `epoch_stamp`, `stamp_ahead`, `file_mtime`, `resolve_path`,
`sed_inplace`, `lock_acquire`, `lock_release`, `search_text`. Beside it,
`tools/fixtures/s/shell_dialect_scan.sh` gates six named dialect families at a ceiling that only
falls: `date_parse_or_relative`, `xargs_arg_file_or_delimiter`, `grep_pcre`,
`readlink_resolve_flag`, `sed_in_place_flag`, `stat_field_format`.

**38 of 2,969 tool scripts source that helper -- 1.3%.** The gate catches the *spellings* it knows
about, in files nobody has converted, and the helper waits.

That is not an argument that the helper is wrong. It is the ordinary fate of a library published
into a body of code already written: adoption is a per-file act and there are 2,931 files.

## What the world does about the same problem

### DeepSeek Harness -- capability as declaration

Open-sourced August 2026, built on Cordis as a micro-kernel where "functional units including model
adapters, tool registries, sandboxing environments, session state handlers, event dispatchers, and
user interfaces are loaded as independent extensions." The part this study came for is the
**manifest**: configuration schemas support "specifying environment constraints, plugin
dependencies, and runtime parameters via YAML or JSON definitions" without touching core logic.

A dependency is a **declared, machine-readable fact** rather than a call site discovered at
runtime. Four baseline modes make the declaration operational, and the third is the one worth
staring at: **Standard** grants shell execution and web retrieval; **Code** exposes an SDK for
multi-step tool calls in batches; **Minimal** "restricts execution to a persistent shell session and
text-editing utilities"; **Creator** is a diagnostic environment for testing plugin
configurations.

**Minimal mode is the question this study is asking, answered by someone else.** What is the
smallest utility set an agent can work in? DeepSeek answers it by *configuration*, and can therefore
test the answer.

Its `AGENTS.md` also shows the honest limit of the idea: the repository still assumes `gh` and
`pnpm` in prose, and its own guidance is to "retry unchanged with the narrowest host escalation"
when a sandbox blocks something. A manifest covers plugins; the tools a build reaches for stay
where they always were.

### Claude Code -- capability as a typed tool

Observed directly on this pier `20260905`, from a jailed lap's own `init` event: the harness exposes
**26 tools**, and the ones that matter here are `Read`, `Edit`, `Write`, `Grep`, and `Bash`. Reading
a file, editing it, and searching a tree are **first-class typed tools**, not shell invocations.
`Bash` exists beside them rather than beneath them.

The consequence is exact: an agent that reads with `Read` depends on no `cat`, and one that searches
with `Grep` depends on no `grep` dialect. **The dependency has been hoisted out of the shell and
into the harness**, where one implementation answers for every platform.

### The two shapes, side by side

| | DeepSeek Harness | Claude Code |
|---|---|---|
| Where a dependency lives | a declared manifest entry | a typed tool in the harness |
| How absence is discovered | at load, from configuration | it cannot be -- the tool is the harness |
| What varies per platform | the plugin chosen | nothing the agent sees |
| Cost | a schema to keep true | tools must be reimplemented, not borrowed |

Neither is what this tree does. **This tree discovers a dependency when a script runs and the
utility is missing** -- and the fault surfaces as whatever that script does with a failure, which
is the whole of the problem.

## The gap, stated plainly

Three faults from one working day, all the same shape, all measured rather than recalled:

- A helper resolved from `$(pwd)` and a discarded error made a guard report **zero unresolved links
  and pass** when its instrument was simply absent (REDS `%413`).
- A validator forked `mktemp`, `iconv` and `rm` **per file** across 14,709 files -- about 44,000
  processes -- because a per-item shell loop is invisible inside a script that reads correctly
  (REDS `%412`).
- `xargs -a` is GNU-only. The tree had **already written that down twice**, in
  `shell_portable.sh`'s own header and in a comment recording that it was "paid for twice", and a
  third payment was avoided only because a rostered guard was listening (REDS `%413`).

The common root is not carelessness. It is that **a shell utility has no contract**: it may be
absent, it may be a different implementation with the same name, and its failure is a number that
looks like every other number. A manifest fixes the first. A typed tool fixes all three.

## What would falsify this study

- **If `shell_portable.sh` adoption is rising on its own**, the gap closes without new machinery and
  the right move is patience. Measure the same 1.3% in a month; a rise past ~5% falsifies the claim
  that adoption needs a mechanism.
- **If the utility set is genuinely stable**, portability is a theoretical worry. The test is a
  second bench: run the full roster on the macOS clone and count refusals that are dialect faults
  rather than real ones. Zero would falsify this study's premise.
- **If the cost of a typed layer exceeds the cost of the faults**, the answer is the dialect gate
  and nothing more. The comparison is honest only with both numbers, and only one exists today.

## Horizon, assumptions, confidence

**Horizon:** the next two chapters. **Assumptions:** the fleet keeps growing (three live ships,
three berthed), it keeps spanning at least two operating systems, and guard count keeps rising
(110 rostered of 1,809 witnesses). **Confidence:** high that the dependency surface is real and
measured; **moderate** that a typed layer is the right answer, since its cost has not been measured
and its benefit is inferred from three faults in one day rather than a trend.

## Attribution

**DeepSeek Harness** -- concepts read from its public documentation and repository, and from InfoQ's
August 2026 report. Studied here as a design, never copied: this room reads the world with
attribution and `active-designing/` names only our own modules
([`../../.claude/rules/gratitude-licenses.md`](../../.claude/rules/gratitude-licenses.md)).
**Claude Code** -- the tool list is not quoted from documentation; it was **observed** in a jailed
lap's own `init` event on this pier, which is the strongest source available for it.
**The Open Group / IEEE Std 1003.1** -- for what is and is not a POSIX utility, checked rather than
recalled, and it corrected this study's own first draft.

## Sources

- [DeepSeek Harness developer preview](https://deepseek.com/harness/en/)
- [deepseek-harness/AGENTS.md](https://github.com/deepseek-ai/deepseek-harness/blob/master/AGENTS.md)
- [InfoQ: The Open-Sourcing of DeepSeek Harness](https://www.infoq.com/news/2026/08/deep-seek-harness/)
- [List of POSIX commands](https://en.wikipedia.org/wiki/List_of_POSIX_commands)
- [The Open Group Base Specifications, Utilities](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap01.html)
