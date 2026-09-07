# The eight cores and the serial pass

**Language:** EN - **Style:** Gauge, Field - **Voice:** Kyri
**Stamp:** `20260907.022500` - **Status:** Measured. Two questions Keaton asked in one sitting.
**Asked by:** Keaton, `20260907` -- *let's see if we are maximizing our eight core pier server cpu
value*, and *I still see our `.cursor` and `.vscode` not retired, archived, molt-breached, mitra
shed-prepped*.

Both answers are numbers rather than opinions, and one of them says **the fleet is already doing
well** at the thing it was asked about, while the cost sits somewhere else entirely.

## The pier is fully subscribed, and that is the easy half

Measured over thirty seconds on `20260907.022000`, on the 8-vCPU pier:

| Reading | Value |
|---|---|
| Cores | 8 |
| Load average, three samples | 9.13, 8.57, 8.10 |
| Runnable processes (`vmstat`) | 7 |
| CPU split | 39.5% user, 39.4% system, 17.4% idle |

**Load at 8-10 against 8 cores is full subscription**, and the top consumers are real work: two Zig
`build-exe` runs from `grain-bakery` and `grain-diffuser`, one of them at 293% because Zig
parallelises internally, and one `./topology selftest` at a full core, which is `grain-copal`'s own
comlink witness doing its job. Nothing idles and nothing spins.

**So the eight cores are being used.** What follows is the sharper reading underneath that.

## Every lap spends a quarter of itself in a strictly serial pass

The standing roster is how a lap proves itself, and it runs **161 guards one after another**:

| Reading | Value |
|---|---|
| Guards per pass | 161 |
| Wall time, last measured pass | 945s -- **15.75 minutes** |
| Mean per guard | 5.9s |
| Guard invocations backgrounded | **zero** |
| Fleet cost per full round | 8 x 945s = **2.1 core-hours** |

Fifteen minutes of serial work on one core, per ship, per lap. At fleet scale the eight passes
overlap and fill the machine, which is exactly why load reads 8-10 -- **the utilisation is good
precisely because the latency is bad.** Eight ships each waiting on a single-threaded pass is a way
of using eight cores, and it is not the best one.

## Why the pass is serial, and it is a reason rather than an oversight

The guards were written to run alone. Parallelising them collides on shared resources the tree has
already booked reds for:

- **A pen one path wide for eight ships** -- two concurrent copies of one control's throwaway
  directory, each deleting the other's, booked and folded this week.
- **A fixed UDP port** in an Amphora guard, which two simultaneous runs cannot both bind; copal
  booked the address-reuse repair the same day.
- **The `run_lock`**, which the runner holds at zero wait and refuses rather than queueing --
  correct for two passes, and it says nothing about two *guards* inside one pass.

So the serial pass is load-bearing until each guard owns its own pen and its own port. **That is a
per-guard property, so it can be earned incrementally**: a guard whose pen is uniquely named and
whose ports are ephemeral is safe to run beside its neighbours, and the runner could take those in
a pool while the rest stay serial.

**The falsifier, named plainly:** if a pool of even four parallel slots does not cut the 945s
materially, the pass is dominated by a few slow guards rather than by their number, and the right
move is to find those instead. `sow` at 230s is already the slowest single guard on record, which
makes that outcome genuinely possible.

## The two editor rooms, and what actually holds them

`.vscode` is **one file**, `settings.json`. `.cursor` is **53 files**, of which 53 are rule twins.

**`.vscode` is free to retire today.** Nothing reads it, no guard names it, and the seed already
ships it as `template` -- so retiring it is a manifest edit and a `git rm`.

**`.cursor` is not, and the reason is a gate rather than a preference.** Three things bind it:

1. **`rule_twin` sits at custody gate `%7`** in the standing roster, comparing 53 `.mdc` twins
   against 51 `.claude/rules/*.md`. Retiring the room retires the guard.
2. **25 rules end with a `Canonical Cursor twin` line**, each naming its partner. Those footers
   become false the moment the partner goes.
3. **`template-manifest.bron` reads `scrub .cursor`**, so the public seed already carries the room
   depersonalised -- retiring it changes what a stranger inherits.

None of that forbids the retirement. It means the retirement is **one round with three named
parts**, not a `git rm`, and it wants Keaton's word because gate `%7` is his.

## What this page asks for

**For the cores:** a per-guard audit of pen and port isolation, taken in the order the slow guards
already name, so a parallel pool can be earned rather than declared.

**For the rooms:** `.vscode` retired now; `.cursor` prepared as a **Class M mitra shed** row naming
its three bindings, with the cut RED until circled -- which is exactly the shape the vendor-name
survey used for the Codex family, and it worked there.
