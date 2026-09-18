# The open door was already counted

**Stamp:** `20260918.092431`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Vision -- a checked survey closing a named open question; no code moves
**Room:** Vision -- traces one process's caller to the loop that spawns it, rather than about a
shipped feature
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`20260918-091243_the-wake-cost-paper-does-not-reach-a-one-shot-process.md`](20260918-091243_the-wake-cost-paper-does-not-reach-a-one-shot-process.md)
-- the note whose open door this closes -- and
[`20260918-082216_caravans-fixed-interval-polls-cost-a-wake-every-cycle.md`](20260918-082216_caravans-fixed-interval-polls-cost-a-wake-every-cycle.md)
-- the four-site table this note re-reads

## The open door

The prior note in this pair read `fetcher-poll` and `fetcher-poll-mirror` as one-shot CLI
subcommands: each checks a sentinel once, polls one wire cycle, sleeps once if an interval is set,
and exits. It named one thing it could not see from inside `mantra/`: *"Whatever invokes
`fetcher-poll` on a repeating basis today -- a witness, a shell harness, a test driver -- may pay
the same fixed-interval wake cost one layer up, in a shell script this grep of `mantra/` cannot
see."*

## What invokes it

`grep -rln "fetcher-poll"` outside `recall_subscribe_poll_delivery.rye` finds exactly one caller
that spawns it as a process rather than merely mentioning it: `caravan/subscribe_poll_service.rye`,
whose own header already says what it does -- *"cycle_ok (0) spawns again."*

Reading `run_supervisor` (`caravan/subscribe_poll_service.rye:222-297`) directly: a `while (true)`
loop builds a fresh `fetcher_argv` naming `fetcher-poll` or `fetcher-poll-mirror`
(`build_fetcher_argv`, line 155), spawns it as a child process (line 266), and waits for it to exit
before looping again. On `cycle_ok`, `apply_fetcher_exit` returns `.continue_loop` (line 194-197)
and the `while (true)` immediately spawns the next one. **This is the outside caller the prior note
named as unseen.**

## The wait loop is not a new site -- it is the fourth one, read from its other end

The wait for each spawned fetcher to exit is `wait_fetcher_or_source_lost`
(`caravan/subscribe_poll_service.rye:85-107`): a `while (fetcher_dependent.id != null)` loop that
calls `waitpid(..., WNOHANG)`, and on every "nothing yet" result sleeps `dependent_poll_ns` --
**20 milliseconds, declared at line 77** -- before checking again.

That constant is already row three of the sibling paper's four-site table:
`caravan/subscribe_poll_service.rye:77 dependent_poll_ns, 20 ms`. The falsifier this note carries
is the same one the sibling paper already answered for this exact site: a fixed interval, checked
in a loop, for a duration the loop cannot predict -- here, until the spawned fetcher happens to
finish its own single wire cycle and exit.

**What is new here is the connection, not a new cost.** The prior note treated `fetcher-poll` as
free of the wake-cost claim because it runs once and exits. That reading holds for the fetcher
process's own body. It does not extend to the supervisor watching it: `run_supervisor`'s `while
(true)` re-enters `wait_fetcher_or_source_lost` on every cycle, for as long as the supervisor
itself runs, so the 20ms wake this note traces is paid **for the supervisor's whole life**,
exactly the shape the original claim describes -- and it was already measured, at this file and
this line, before the open door was written.

## Why the earlier note could not see this on its own

`mantra/` is where `fetcher-poll`'s own body lives, and a grep scoped there correctly found no loop
wrapping it -- there is none, inside that file. The loop that repeats it lives one directory over,
in `caravan/`, and was already the subject of the sibling paper's own table before this pair of
notes existed. Two true, narrow readings -- "this process is one-shot" and "the loop that calls it
already has its wake cost counted" -- read as a contradiction only until the caller is named. Once
named, they compose: a one-shot process, called from a loop that already pays for calling it
repeatedly, is exactly Caravan's ordinary shape everywhere else in this same file.

## The falsifier, and how it stood up

**Falsifier for this note:** `run_supervisor`'s `while (true)` calls `build_fetcher_argv` /
`std.process.spawn` somewhere other than inside the loop body, making the respawn conditional or
one-time rather than per-cycle. Read directly at `caravan/subscribe_poll_service.rye:252-284`, the
spawn sits inside the loop body, reached on every iteration that does not `break` or `return`. The
falsifier stayed quiet.

## What stands

Zero new sites. The open door named in the prior note answers to a site this tree had already
measured: `caravan/subscribe_poll_service.rye:77`'s `dependent_poll_ns`, already row three of the
four-site table. The two-note pair together says the same thing about `fetcher-poll` that the
Caravan paper already said about `harvest.rye` and `entrust.rye`: the wake cost lives in the loop
that waits, never in the work being waited for.

## Horizon, assumptions, confidence

**Horizon:** already closed -- a checked reading, no proposal pending beyond what the sibling paper
already proposes for its four sites.

**Assumptions:** the same grep-pattern limits as the prior note -- a differently spelled caller
(one that shells out to the built binary by a name this grep did not match, such as a symlinked or
renamed binary) would slip past.

**Confidence:** high. The caller, the loop, and the constant are each read at their own line
number, and the constant is the same one a sibling paper already priced.

---

*The door was open because the two notes looking at it stood in two different files. The cost was
never missing -- it was already written down, one room over.*
