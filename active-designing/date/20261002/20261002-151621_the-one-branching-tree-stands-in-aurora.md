# The one branching tree in the whole catalog stands in Aurora, not in Caravan

**Status:** Landed -- a reading of tracked source, with a runnable census
**Room:** checkable -- the finding is a graph classification of declared topologies, reproducible by rerunning the printed script against the same files
**Style:** Gauge at Field
**Stamp:** `20261002.151621`
**Scope:** `caravan/systems/*.kyri` (18 declarations) plus the one roster graph `caravan/channels.rye`'s hosted selftest and `aurora/src/roster.rye`'s freestanding mirror share (1 declaration, not a `.kyri` file). No other declared graph in the tree was read; a scan past this scope is named as the open falsifier below rather than assumed.

## What is

`caravan/channels.rye`'s own doc comment calls its declarations a "supervision tree." It gives the
reason: `max_channels` sits below the 28 edges a complete graph over eight domains would need,
"since a supervision tree that wires every component to every other has stopped being a tree"
(`caravan/channels.rye:29-34`). That sentence names an intent alone. A cycle check and a
connectivity check over a loaded roster are two checks `caravan/` and `aurora/` have yet to write.

Caravan's own `systems/` room holds eighteen declared protection-domain graphs. Aurora shares one
more, declared twice. The first copy is a hosted Zig selftest in `caravan/channels.rye:316-331`:
five `declare_domain` calls, four `declare_channel` calls, asserted `domain_count == 5` and
`channel_count == 4`. The second is a freestanding mirror in `aurora/src/roster.rye:18-34`: the
same five names, the same four pairs, running directly on QEMU's virt machine, bare metal
underneath. The file's own header names the reason -- so the hosted witness's three sentences can
be heard again outside a host process: five domains, four channels, each channel naming two
declared domains. Nineteen declared graphs stand between the two rooms.

## Method

A graph counts as a tree exactly when its cycle count reads zero. The standard count for "how many
independent cycles a graph holds" is its **cycle rank**: `edges - vertices + connected_components`.
Zero means a forest, where every component is a tree. A positive number names exactly that many
independent cycles to remove before the rest is a forest. The formula reads directly off what
every `.kyri` system already declares in plain text: a `domain` line per vertex, a `channel` line
per edge.

```python
import glob

def components_and_cyclerank(domains, edges):
    parent = {d: d for d in domains}
    def find(x):
        while parent[x] != x:
            x = parent[x]
        return x
    def union(a, b):
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[ra] = rb
    for a, b in edges:
        union(a, b)
    comps = len(set(find(d) for d in domains))
    V, E = len(domains), len(edges)
    return V, E, comps, E - V + comps

def degree_seq(domains, edges):
    deg = {d: 0 for d in domains}
    for a, b in edges:
        deg[a] += 1
        deg[b] += 1
    return deg
```

Run against every `caravan/systems/*.kyri` file's `domain` and `channel` lines. Add the Aurora demo
by hand, typed from the two source files above; its channel pairs read identically in both, checked
line by line rather than assumed.

## Result

Nineteen declared graphs sort into four shapes, and this script is the first to assert any one of
them:

| Shape | Cycle rank | Count | Members |
|---|---|---|---|
| Cyclic (ring, or ring plus a chord) | 1 or 2 | 8 | `serial_cycle`, `serial_cycle_moved`, `serial_cycle_succession`, `serial_cycle_wide`, `serial_cycle_wide_mute` (rank 1); `serial_cycle_bypass`, `serial_cycle_shadow`, `serial_cycle_wide_wired` (rank 2) |
| Pure star (one hub, every other node a leaf) | 0 | 8 | `serial_duplex`, `serial_relay`, `serial_stack`, `serial_two_clients`, `serial_three_clients`, `serial_three_clients_board`, `serial_three_clients_menu`, `wide_roster` |
| Degenerate (0 or 1 edge, no hub to name) | 0 | 2 | `write_execute` (one domain, no channel), `unheld_region` (two domains, one channel) |
| Branching (two nodes of degree greater than one) | 0 | 1 | the Aurora / `channels.rye` shared demo |

Every cyclic declaration's name already says "cycle." Every star's degree sequence reads
`[k, 1, 1, ..., 1]` for a hub of degree `k`: `wide_roster`'s hub reads degree 4 against four leaves
of degree 1, `serial_three_clients`'s hub reads degree 3 against three leaves, and so on through
every renamed or widened copy in the family. The two degenerate cases carry too little structure to
earn a shape of their own -- one domain standing alone, two domains joined by their only possible
edge.

The Aurora demo's degree sequence reads `[3, 2, 1, 1, 1]`. `serial_virt` is the hub Caravan's own
assert already names (`assert(graph.degree("serial_virt") == 3)`, `channels.rye:370`), connected to
`serial_driver`, `client_a`, and `client_b`. `client_a` is simultaneously a leaf of that hub and a
second, smaller hub of its own, holding `timer_driver` as its one connection. The longest path in
the graph crosses three edges and two internal nodes: `serial_driver -> serial_virt -> client_a ->
timer_driver`. Every star in Caravan's own catalog crosses at most two edges and one internal node.
Aurora's demo is the only declared graph in either room with a leaf hanging off a leaf.

## Why it reads this way

Every `.kyri` star in Caravan's catalog models one shape: a single supervisor and its directly
held dependents. `capabilities.rye`'s own parent/dependent language already names that shape.
`serial_three_clients.kyri`'s own comment prices it as a cost -- "the virtualiser touches every
one of them, so it may run beside none." That shape is flat by construction. A hub's reach is
exactly its declared degree, and every leaf across the eighteen `.kyri` files stays a leaf alone.

Aurora's demo serves a different purpose than topology. Its own header says it exists to let a
*hosted* witness's sentences be heard again on bare metal; topology shape was never the goal it
was built for. It became the one two-level tree in the tree's own source by modeling a real OS
service graph -- a serial driver behind a virtualiser behind two clients, with a timer feeding one
client directly. The shape falls out of the hardware it describes, rather than being chosen on
purpose. That is the more interesting fact. The only non-trivial branching tree in this whole
research arc's declared-graph census arrived as a side effect of describing real hardware. Every
topology Caravan built on purpose -- eight rings, eight stars -- stayed at depth one or depth two
from the center. The question of what a supervisor-of-a-supervisor costs under Caravan's own
capability and grant model waits for its first `.kyri` declaration to ask it.

That is the same uninhabited corner [the composition-gap
essay](20261002-145044_two-sub-rings-refuse-the-single-lap-a-wider-ring-does-not.md) found from a
different angle. Caravan's ring code carries a working single-ring success path beside a
disjoint-rings path still waiting for its own exercise. Here the gap sits one level up the same
family: a flat single-hub success path, exercised eight times over, stands beside a two-level
branching shape that runs. That branching shape still waits for its first turn as a typed `.kyri`
system under `caravan/roster.rye`'s own capability table.

## The falsifier, bound and left for whoever builds it next

**What would overturn this:** a second branching tree anywhere in this tree's declared-graph
surface that this census missed. The scope line at the top names exactly what was read: the
eighteen `caravan/systems/*.kyri` files, and the one Rye-literal demo Aurora shares with Caravan.
It stops there, by name. A `channel`-style declaration living in `comlink/`, `pond/`, or anywhere
else this lane left unopened would falsify the word "only," while leaving the arithmetic above
exactly as it stands.

**What stays for a later lap:** declare a two-level `.kyri` system and run it through
`caravan/roster.rye`'s own `from_system` and capability checks. That reads whether the existing
code accepts the shape Aurora's demo has so far only run as hand-written Zig. That edit belongs to
Caravan, the same way the ring/chain crossover's own next step belonged there. This lane's standing
order this hour keeps `caravan/cycle.rye`, and every build past reading, for someone else's lap.
Named here as the next falsifiable step rather than built: does Caravan's own verify code refuse,
accept, or silently flatten a hub whose leaf is itself a hub?

## Grade

Register reads 10 percent negative sentences against a 30 percent Field ceiling. Graded B+/85 at
Field via `sh tools/fixtures/q/qa_report_card.sh <this file> --setting field --service 50`. No new
witness, no new module; the census script above is printed in full rather than kept as a standing
tool.
