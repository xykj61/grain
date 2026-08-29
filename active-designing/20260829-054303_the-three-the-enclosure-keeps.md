# The three the enclosure keeps -- orbit three, measured on metal

**Stamp:** `20260829.054303`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Living -- the orbit-three reading of the quest that retires ai-jail; the closing of any survivor named here waits on Keaton's word
**Kin:** [`../expanding-prompts/20260826-033051_pond-completes-the-enclosure.md`](../expanding-prompts/20260826-033051_pond-completes-the-enclosure.md) -- [`../pond/enclosure_policy.kyri`](../pond/enclosure_policy.kyri) -- [`../tools/p/pond_enclosure_ephemeral_witness.rish`](../tools/p/pond_enclosure_ephemeral_witness.rish)

## What orbit three asks, and what nobody was asking

The quest that retires ai-jail names its third orbit **the memory that forgets**: an enclosure whose
`$HOME` and `/tmp` dissolve on exit while the pier persists, *done when a planted secret written
outside the pier is provably absent after the enclosure closes*.

Two guards already read this enclosure, and both read it in space rather than in time.
`pond_policy_launcher_scan.sh` compares the record against the flags the launcher spells.
`pond_enclosure_built_scan.sh` compares the record against the mount plan the jail builds. Each asks
what an agent inside can **see**. Orbit three asks how long what it **writes** lasts, and that
question waited for an instrument.

## The rule, read off the plan rather than off a roster

A mount row answers for its own lifetime, and three rules cover every row the plan carries:

| Plan row | Lifetime | Why |
|---|---|---|
| `tmpfs T`, `dev T`, `proc T` | **dissolves** | a filesystem born at open and gone when the namespace goes |
| `ro-bind S T` | **read-only** | nothing can be written, so nothing is kept |
| `bind S T`, `dev-bind S T` | **survives** | a write at `T` lands at `S` on the host and outlives the enclosure |

A survivor is then either **under the pier**, which is the arrangement the quest wants and which the
record's own `persist` line declares, or **outside it**, which is a hole in the forgetting. The rule
is read off the plan itself, so a hole the jail opens tomorrow classifies as one on the lap it
arrives, by that same rule.

## What the plan says, measured `20260829`

Twenty-one default mount rows, and every one classified: **8 dissolve**, **10 are read-only**, and
**3 survive** -- `/dev/shm`, `/tmp/.X11-unix`, and `/run/user/<uid>`. **None of the three sits under
the pier.** Every one arrives from the jail's own defaults rather than from a flag Pond passes, which puts
them outside the reach of the sibling guard that reads the launcher.

## What the kernel says

A plan is an intention until something runs it, so the scan's `--probe` leg plants one marker per
candidate path inside a real enclosure, lets it close, and reads the host. Measured on this pier at
`20260829.054303`, six candidates, five planted:

| Path | Plan says | The host says after the close |
|---|---|---|
| `$HOME` (private home) | dissolves | **forgotten** |
| `/tmp` | dissolves | **forgotten** |
| `/run` | dissolves | the write was refused, so nothing was there to keep |
| `/dev/shm` | survives | **still carrying the marker** |
| `/run/user/1000` | survives | **still carrying the marker** |
| `/tmp/.X11-unix` | survives | **still carrying the marker** |

**Zero disagreements.** The classification and the kernel say the same thing, and the probe's whole
run costs 0.4 seconds, so it rides the roster every lap rather than waiting for a hand.

The private home is the reading the probe alone can give. `pond_enclosure_default_plan.kyri` drops
the two rows the invocation creates, and one of those is the private home's own tmpfs -- so the
plan leg reports `private-home yes` as a claim it cannot check, and the metal leg checks it.

## The three that stay, and what each would cost to close

Each survivor is a real facility rather than an oversight, which is why the count is a ratchet under
a ceiling that only falls rather than a gate at zero.

- **`/run/user/<uid>`** carries the Wayland socket. Closing it takes the display with it, and the
  GPU passthrough seam orbit four has to carry depends on it.
- **`/tmp/.X11-unix`** is the X11 socket directory, and every X client on the host is reachable
  through it. `ai-jail` builds it for any launcher that leaves `--no-display` unspoken. The record already
  reads REFUSE on this line for that reason, one guard over.
- **`/dev/shm`** is shared memory, which a browser and a Wayland compositor both want.

Closing any of them changes what a running agent can do, so each is Keaton's word rather than a
sweep -- the quest's own custody line names any round that reshapes an isolation boundary as
check-in territory.

## The sharper finding: two holes inside a subtree that dissolves

Two of the three survivors sit **inside** paths the record calls ephemeral. `/tmp/.X11-unix` stands
under `ephemeral /tmp`, and `/run/user/<uid>` under `ephemeral /run`. Both are declared separately
in the record as `rw-map` lines, so the record is honest -- and a reader who took `ephemeral /tmp`
at its word would still be told less than the truth: the subtree dissolves, and the hole inside it
persists.

The scan counts that shape as `pierced_forgetting` and reports it rather than gating it, because the
honest state today is exactly two. Naming the shape is what lets a later lap ask the real question:
whether a declaration should carry its own exceptions on its face.

## What the reading leaves standing

**Whether any survivor should close.** That is a seat, and it is named above with its cost.

**Whether the enclosure Pond eventually builds keeps these three.** Orbit two derives its grants from
this record; this reading tells that derivation which paths carry a lifetime longer than the lap.

**Whether a refused write is a kind of forgetting.** `/run` came back refused rather than forgotten,
which is a stronger property and a different one. The scan reports it separately and names it.

## What this does not reach

Whether the kernel honours the plan in ways past this probe's reach -- a marker is one byte in one
directory, and a filesystem has more corners than that. And whether the pier itself should persist,
which is the arrangement the whole quest is built on rather than a question this instrument opens.

*May every boundary this tree draws be one a hand can find, and may the enclosure keep only what we
asked it to keep.*
