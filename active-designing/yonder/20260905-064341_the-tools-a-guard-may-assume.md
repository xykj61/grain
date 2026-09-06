# The Tools a Guard May Assume

**Stamp:** `20260905.064341`
**Language:** EN
**Style:** New Gauge, Field setting
**Voice:** Kyri
**Status:** Yonder design -- deferred yet alive. The three tiers, the roster, and the meter are **still unbuilt**; a shape for the lap that takes them. **The reflex alone landed `20260905.224445`** -- `have_tool` and `require_tool` in [`../../tools/fixtures/s/shell_portable.sh`](../../tools/fixtures/s/shell_portable.sh), with the three roster-reachable `rg` guards repaired and REDS `%445` closed on [`../../tools/s/shell_dialect_witness.rish`](../../tools/s/shell_dialect_witness.rish). This page's own sentence, *the reflex that should not wait for the design*, is what that lap took.
**Room:** Vision. No claim below is checkable until a witness binds it (`context/TWO_ROOMS.md`).
**Kin:** [`../../external-research/yonder/20260905-064341_what-a-harness-promises-about-its-tools.md`](../../external-research/yonder/20260905-064341_what-a-harness-promises-about-its-tools.md) (the measured world, with attribution) - [`../../tools/fixtures/s/shell_portable.sh`](../../tools/fixtures/s/shell_portable.sh) - [`../../.claude/rules/tame-guidance.md`](../../.claude/rules/tame-guidance.md)

**Silo note.** This page names our own modules and no one else's. Its companion study reads the
outside world with attribution; the boundary between reading and building is the boundary between
`external-research/` and here, and it is never crossed by code.

## The question

**Which tools may a guard assume, and what happens when it is wrong?**

Today the answer is: all of them, and whatever that script happens to do with a failure. Measured
`20260905.064341`: **52 distinct external utilities** across 2,969 tool scripts, **`rg` at 992 sites with
one probe**, **`mktemp` at 353 sites with none** and no place in POSIX since 2008, and the tree's
own portability helper sourced by **38 files, 1.3%**.

## The reflex, first

Before any design: **a guard that cannot run its instrument refuses, and says which instrument.**

That is not a horizon, it is a rule this tree has now paid for twice in one day, and it costs three
lines wherever a scan reaches for something it did not write. It belongs in the next lap that
touches any scan, not in a project. Everything below is the larger shape; this sentence is the part
that should not wait for it.

## Three tiers, and the word for each

The design is one idea: **a tool a guard reaches for has a tier, and the tier says what happens when
it is missing.**

| Tier | Meaning | On absence |
|---|---|---|
| **granted** | the bench guarantees it (POSIX under a shell) | assume it; a missing one is a broken bench, not a guard's problem |
| **carried** | not guaranteed, and we ship or vendor it | assume it, and a witness proves it *is* carried |
| **borrowed** | present on some benches, absent on others | **probe, fall back, and announce which was used** |

**`granted` means the BENCH guarantees it, and that is a smaller claim than it first reads**
(amended `20260905.073903` on Keaton's word, correcting this page's first draft). The draft wrote
*granted = POSIX-mandated*, which quietly made POSIX the floor of the whole project. It is the
floor of the **bench** and not of the **destination**: Caravan is a root task on **seL4's userlevel
side**, where there is a syscall interface and **no shell, no `awk`, no `grep`, no POSIX utility
layer at all**. On the target, `granted` is nearly empty and every tool is something we wrote.

That is not a footnote, it is the design's whole reason. **A tool grant matters most where nothing
is granted.** And it makes the tier roster do double duty: on the bench it says what a guard may
assume, and read from the other end it is **the re-grow list** -- 1,958 `grep` sites, 645 `sed`,
434 `awk` are a work estimate for the Rye that must eventually answer for them. The elder
`external-research/yonder/20260617-201612_useful-utilities.md` ordered its tiers by *how readily
each becomes a TAME Rye module*; this page asks the same question from the near end, and the two
lists are one list.

`rg` is **borrowed** and treated as granted 991 times out of 992. `mktemp` is **borrowed** and
treated as granted 353 times out of 353. `git` is **carried** -- no clone exists without it -- and
probed ten times, which is ten times more caution than it needs.

The tiers are a vocabulary before they are a mechanism. Naming `rg` borrowed already says what a
lap must do the next time it writes one, and that costs nothing to seat.

## Where it would live, in our own modules

**Tally** owns bounds, so it owns this one. A **tool grant** is a bounded named resource exactly
like an arena: declared at construction, checked at the edge, refused with a named error. The
parallel is not decorative -- `garden` is how this tree already spells *you may have this much
memory and no more*, and a grant spells *you may reach for this tool and no other*.

**Caravan** supervises dependents and already weighs one by the line it holds (`unhand.rye`), moves
its reach while it runs (`confer.rye`, `revoke.rye`). A supervised process that may reach `awk` and
not `curl` is the same sentence Caravan already speaks about capabilities. **A tool grant is a
capability**, and Caravan is where capabilities live.

**Mantra** is the descriptor vane: a grant set is a descriptor, and Brix already evaluates to Bron.
The roster below wants to be **read** by three instruments without any of them parsing it twice --
which is REDS `%409`'s lesson, and Mantra is the module whose job that is.

**Aurora** carries the surface to a bench that is not this one, which is where a granted/borrowed
distinction stops being theory: the tier a tool sits in is a fact about the *target*, and Aurora is
the module that knows there is more than one.

**Rye** authors it under TAME: `u32` counts against a named ceiling, `usize` at the seam only, two
asserts a function, a **named error** per refusal -- `ToolError.not_granted`,
`ToolError.absent_and_borrowed`, `ToolError.grant_exceeded`. **Rishi** is where the guards that
consume it already live. **Glow** is the horizon spelling, once the language carries enough to say
it; the growth law is that a rune is earned by a law, and this one has not earned one yet.

## The shape, in three movements

**One: the roster.** `construction/tool-grants.kyri` -- one record per utility, in the standing
roster's own shape: `tool`, `tier`, `fallback`, `witness`, `seated`. One file, read by every
instrument, so none can disagree. This is the fleet roster's argument applied one layer down, and it
is cheap for the same reason: adding a tool is a row.

**Two: the meter.** A scan that reads every tool script's command positions, joins them against the
roster, and reports **borrowed sites with no probe** as a ratchet under a ceiling that only falls.
Not a gate. 992 unprobed `rg` sites cannot become zero in one lap, and a wall that reds on ordinary
work is a wall someone turns off. It falls on touch, like every ratchet this tree keeps.

**Three: the door.** A `granted` helper beside `shell_portable.sh`'s eleven, so a script says
`grant search_text` rather than probing by hand -- one spelling, one announcement, one fallback.
The helper exists; what is missing is a reason for a file to reach for it, and a ratchet counting
the files that have not is exactly that reason.

## Why the meter comes second and not first

The instinct is to write the meter first because it is measurable. The order is wrong: **a meter
that counts against no roster is a meter with an opinion**, and this tree has learned twice this
week what an unrostered reading is worth. The roster is the claim; the meter checks the claim; the
helper is what a repair reaches for. In that order each one has something to stand on.

## The cost, named rather than waved past

**A tier is a promise somebody has to keep.** A roster claiming `awk` is granted is wrong the day a
bench ships a `busybox` awk that lacks a feature, and then the roster is a second thing to fix.
That is the honest objection to the whole design, and the honest answer is that it is a promise
*written down*, which is strictly better than the same promise made 992 times in silence.

**And the ratchet may never reach zero, which is fine.** 992 sites is not a debt anyone should plan
to pay in full. The value is that a *new* borrowed site is visible on the lap it enters -- the same
value `unheard_guard` gives, where 1,116 unheard witnesses will likely never be zero and the ceiling
still does its work every time it falls.

## The re-grow, and whose hand it is

**Nothing is fetched or written by this page.** When the word comes, the order is argued in the
companion study and the shape here is only where each landing belongs:

- **Tally** takes the grant type and its bounds, beside `garden`.
- **Caravan** takes the grant as a **capability** on a supervised dependent -- and Caravan is also
  the module that will one day *be* the thing with no utilities beneath it, which is why it owns
  both ends of this.
- **Mantra** takes the roster as a descriptor, so three instruments read one file.
- **Aurora** is where a tier stops being theoretical, since a tier is a fact about the *target*.
- **Rye** authors the base suite the re-grow produces; **Rishi** consumes it; **Glow** spells it
  when a rune has earned a law.

Every study lands in `gratitude/` with its source and license, and is thanked in writing -- one
page per teacher as that room already does, in a `gratitude/utilities/` subfolder once there is
more than one. We honor a tool by using it now and by re-growing its gift later, which is the
elder study's own promise and not a new one.

## What this does not reach

**Whether a typed tool layer beats a shell one.** The companion study reads two harnesses that
hoisted file reading and searching out of the shell entirely, and notes their cost: the tools must
be reimplemented rather than borrowed. That is a real chapter and this is not it. This design keeps
every guard in the shell and only asks it to say what it is reaching for.

**The Glow spelling.** A rune is earned by a law, and no law here has earned one. When the language
carries enough to say `grant` and mean it, this page will be old enough to be worth rereading.

**Any claim of urgency.** Three ships sail today on one bench where every borrowed tool happens to
be present. This is a shape for the lap that wants it, filed in `yonder/` because that is what
yonder is for: alive, and not now.

May the tools a guard reaches for be named before they are missed.
