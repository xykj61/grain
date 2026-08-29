# The door the record cannot name

**Stamp:** `20260829.064107`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Living -- orbit four's first reading, GREEN on metal `20260829`; every count below is measured on this pier
**Kin:** [`../tools/p/pond_enclosure_door_witness.rish`](../tools/p/pond_enclosure_door_witness.rish) -- [`20260829-054303_the-three-the-enclosure-keeps.md`](20260829-054303_the-three-the-enclosure-keeps.md) -- [`../pond/enclosure_policy.kyri`](../pond/enclosure_policy.kyri) -- the quest plan `20260826-033051_pond-completes-the-enclosure.md` in `expanding-prompts/`

## The question

Three guards read this enclosure, and all three read the room. One compares Pond's record against the
flags the launcher spells. One compares it against the plan the jail builds. The newest asks how long
a written byte lasts. Room, room, and time.

The fourth question is the one orbit four is named for: **which program walks through the door,
carrying which environment, as which user?** That question has an answer today, and the answer lives
entirely in the last line of `tools/ag/agent-jail.sh`:

```
exec "$AIJAIL_ABS" --no-save-config $AIJAIL_FLAGS ... -- \
  env "GH_CONFIG_DIR=$GH_STATE" "PATH=$JAIL_PATH" "$AGENT_BIN" "${AGENT_FORWARD[@]}" "$@"
```

Everything the record describes is on the left of the `--`. Everything the door decides is on the
right.

## The door has four parts

**The entry.** `$AGENT_BIN`, which the launcher resolves with `command -v` and then `readlink -f`, so
the path that reaches `execve` is a store path rather than a profile symlink. On this pier that is
`/nix/store/2m6ixmpspk7qm5g3j4vnlyb7bjxqpslw-claude-code-2.1.235/bin/claude`.

**The search path.** `JAIL_PATH`, four elements, handed across as `PATH` so every tool the agent
shells out to resolves inside.

**The environment.** `GH_CONFIG_DIR`, pointing at `.gh` under the pier, so a `gh` login survives a
private home that dissolves.

**The user.** The uid the agent inherits. Claude Code refuses `--dangerously-skip-permissions` at uid
0, so an unattended lap depends on this one being non-root -- a dependency the launcher states in a
comment, and one this reading now counts.

## The rule, derived rather than rostered

A host path is reachable inside the enclosure when the record's own lines say so: a `map`, a
`persist`, or the destination of a `rw-map` covers it, equal to it or an ancestor of it, with any
closer `mask` line winning. `ephemeral` and `fresh` name subtrees that start bare, so a path strictly
beneath one arrives only where a second line declares it -- and `private-home yes` makes the home
exactly such a subtree.

That rule is derivable from the record alone. **Metal taught the second half, and it is the half
worth keeping: a map carries what the host has, and only that.** So each element earns a prediction
from two readings together:

| Declared by the record | Present on the host | Arrives inside |
|---|---|---|
| yes | yes | **present** |
| yes | no | absent -- the map had nothing to carry |
| no | either | absent -- the tmpfs withholds it |

## What the metal answered

Measured `20260829` on this pier, by starting one real enclosure with the launcher's own flags and
asking it what it can see. All four predictions held, so the table above is the kernel's rule rather
than this reading's optimism.

| Search-path element | Record | Host | Inside |
|---|---|---|---|
| `/run/current-system/sw/bin` | declared, `map /run/current-system` | present | **present** |
| `/nix/var/nix/profiles/default/bin` | declared, `map /nix` | absent | absent |
| `${HOST_HOME}/.nix-profile/bin` | undeclared | present | absent |
| `/bin` | declared, `map /bin` | present | **present** |

**The enclosure carries two of the launcher's four search-path elements, and withholds the other two
for two separate reasons.** The host itself lacks one of them, and a map carries only what stands
beneath it. The other stands on the host and vanishes at the threshold, because the private home is a
fresh tmpfs and the record leaves its way back undeclared. A reading of the record alone would call
the first healthy; a reading of the host alone would call the second healthy. Only both together,
checked against a running kernel, tell them apart.

The launcher works anyway, and the reason is worth naming: the first element carries every binary
this pier needs. So the finding is a promise the search path is quietly failing to keep, rather than
a lap that has ever broken.

The entry arrived reachable, the enclosure ran the agent at uid 1000, and the pier came through
whole. The door opens. What it opens by is one element out of four.

## The three duties the record cannot name

Here is orbit four's real distance, counted rather than argued. Pond's policy grammar today carries
thirteen keys -- `format`, `name`, `private-home`, `network`, `gpu`, `map`, `persist`, `ephemeral`,
`fresh`, `graft`, `mask`, `device`, `rw-map`. Every one of them describes the room.

**None of them can state which program starts, what environment it carries, or which user it runs
as.** Three duties, no keys. A Pond enclosure that replaces this launcher has to answer all three, and
today the record cannot pose the question, let alone get it wrong.

What seating each would cost, in the honest order:

- **`user`** is the cheapest and the most valuable. One key, one integer, and the uid an unattended
  lap depends on becomes a thing a program checks rather than a comment somebody hopes is read.
- **`env`** is next. A key per variable, each value a path the existing reachability rule already
  knows how to read, so the guard that reads it exists.
- **`entry`** is the seat that matters and the one to take last. Naming the program inside the record
  is the moment Pond stops describing an enclosure somebody else builds and starts declaring one of
  its own -- which is the switchover, and the switchover is Keaton's word.

That ordering is a proposal, and it is the useful kind: each step is checkable on its own, and the
first two land without touching what runs.

## The trade-off this reading accepted

**It measures the door and repairs nothing.** Removing the two dead search-path elements is a
three-character edit to a script every unattended lap on this pier executes, and the failure mode of
getting it wrong is every loop on this bench answering `command not found` through the night. The
count therefore sits under a ceiling that only falls, and the edit waits for a word -- the same shape
orbit three's three survivors took, for the same reason.

**And it keeps the ratchet on the half that travels.** The undeclared count reads the record against
the launcher, so it answers the same on every pier and a ceiling over it means something everywhere.
The host-absent count answers differently on a bench with a different filesystem, so it is reported as
a machine fact and gated nowhere. A guard that reds on the second pier for owning different
directories is a guard somebody turns off.

## What this does not reach

**Whether the agent, once started, does anything worth doing.** This proves the enclosure can start
the program it exists to run, and stops there.

**The Zed launch path and the GPU seam**, both named in orbit four's own "done when". The GPU
passthrough is carried on this pier by `--no-gpu` and honestly absent, and the editor door is its own
reading.

**Any switchover.** The `ENCLOSURE` selector still reads `ai-jail`, every markdown that instructs a
reader about the jail stands untouched, and this reading accretes beside them.

---

*May every door be measured before it is moved, and may the room and the threshold agree at last.*
