# The wake-cost paper reaches four sites, and stops there

**Stamp:** `20260918.091243`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Vision -- a checked survey extending a proposal that already stands; no code moves
**Room:** Vision -- reasons about which processes a scheduling argument reaches, rather than about
a shipped feature
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`20260918-082216_caravans-fixed-interval-polls-cost-a-wake-every-cycle.md`](20260918-082216_caravans-fixed-interval-polls-cost-a-wake-every-cycle.md)
-- the paper this note tests against a wider population

## What this note checks

The prior paper in this pair argues two general facts about idle CPUs and periodic wakes, then
finds four Caravan sites paying the cost those facts describe: a loop that sleeps a fixed interval
and checks a condition, spending one wake per interval for as long as the condition stays unmet.

Grepping this tree for the same shape outside Caravan -- `nanosleep`, `poll_ms`, `poll_ns`,
`_rest_ms` -- surfaces twelve more call sites in `mantra/` and `amphora/`. This note reads each one
directly, since the earlier paper's own falsifier is exactly this question: does the wake-cost
argument reach every site sharing the same function call, or only some of them.

## Ten of the twelve pay a one-time cost, which the argument never charged

Ten sites -- `recall_batch_delivery.rye:461,536,612`, `recall_two_way_sync_delivery.rye:326,348`,
`recall_catch_up_delivery.rye:390`, `recall_sync_delivery.rye:294`,
`snapshot_export_delivery.rye:293`, `vessel_fetch_delivery.rye:515,601` -- share one shape at each
line: a fixed `50_000_000` nanosecond pause inside a `run_demo` or `run_selftest` function,
placed right after spawning a source-side child process and right before spawning a fetcher-side
one. The surrounding `child.spawn` calls give the reason plainly: let the source bind its
listening port before the fetcher tries to reach it.

**Each of these ten runs once.** A demo or selftest process spawns its two children, sleeps once,
does its work, and exits. The earlier paper's claim covers a loop that pays a wake's cost **every
interval, for the loop's whole life**; a function that sleeps once pays the wake's cost once, and
that single wake buys correctness (the source's port is bound in time) rather than an avoidable
polling architecture. The falsifier holds here on its own terms: this population sits outside the
paper's claim by scope, honestly rather than by oversight.

## Two more read the same way, for an architectural reason

The remaining two sites both call `mantra/recall_subscribe_poll.rye:58`'s `sleep_interval_ns`, from
two places in `recall_subscribe_poll_delivery.rye` (lines 447 and 467), inside
`run_fetcher_poll_once` and `run_fetcher_poll_mirror_once`. Read by name alone, both could pass for
the Caravan shape -- sleep an interval, check a condition, repeat.

**Reading `main` (lines 527-550) answers the question instead.** `fetcher-poll` and
`fetcher-poll-mirror` are CLI subcommands, each dispatching to one call of `run_fetcher_poll_once`
or `run_fetcher_poll_mirror_once`. Each function checks a stop sentinel once, polls one wire cycle
once, sleeps once when `interval_ns` is set, prints one line, and returns -- the process exits
right there, after that single cycle. Every `while (true)` this file holds (lines 220, 291, 394)
belongs to `run_source_loop`, `run_source_loop_mirror`, and a legacy fetcher path; `sleep_interval_ns`
answers to none of them.

Repeated polling here needs an outside caller -- a shell loop, a test harness, a supervisor, a
scheduler -- and that outside caller is where the wake decision actually sits. The `interval_ns`
sleep delays this one-shot process's own exit by one interval, which is a smaller and different
thing than Caravan's resident, self-repeating `while` loop. The earlier paper describes a process
that stays up and keeps checking; these two describe a process that runs once and hands the
re-checking to whoever called it.

## The falsifier, and how it stood up

**Falsifier for this note:** any of the twelve sites sits inside a `while` loop this grep missed,
which would return it to the earlier paper's own population. Read directly, file by file
(`grep -n "while (true)"` beside each call site's line, and both callers of `sleep_interval_ns`
traced to their one call in `main`), every one of the twelve stands outside a loop. The falsifier
stayed quiet.

## What stands, and the one door left open

This closes the twelve-site question with two clean answers for two populations: ten sites outside
the claim by scope (a one-time pause), two outside it by architecture (a one-shot process whose
caller owns the repeat). Both readings leave the Caravan paper's own four sites exactly as
measured, unweakened.

**One real question stays open, and it is smaller than the twelve.** Whatever invokes
`fetcher-poll` on a repeating basis today -- a witness, a shell harness, a test driver -- may pay
the same fixed-interval wake cost one layer up, in a shell script this grep of `mantra/` cannot
see. Naming it here hands it to whoever next reads that harness.

## Horizon, assumptions, confidence

**Horizon:** already closed -- a checked reading rather than a proposal awaiting a build.

**Assumptions:** the grep pattern (`poll_ms|poll_ns|_rest_ms|nanosleep`) covers every fixed-sleep
call site in `mantra/`, `tablecloth/`, `amphora/`, `skate/`, and `brushstroke/`. A differently
spelled sleep -- a raw `std.time.sleep` under another name, or a busy-wait carrying no sleep at all
-- would slip past this pattern and stays for a future reading.

**Confidence:** high. Every one of the twelve sites was read at its own line, in its own function,
against its own caller, rather than sorted by name alone.

---

*A grep found twelve, and reading each one clears all twelve -- the same lesson this lane keeps
meeting today: a call's shape and a call's cost are two different questions, and only the loop
around it answers the second.*
