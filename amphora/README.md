# Amphora -- vessel software

**Language:** EN
**Stamp:** `20260710.161358`
**Last updated:** `20260910.064044` (the room's guard count, its guard list, AND its weight all read off `tools/fixtures/am/amphora_roster_scan.sh` -- `readme_unnamed` holds this page's list at zero, so a guard seated without a name here reds on the lap it arrives, and `readme_spelled_lines` holds it at zero line counts spelled in digits, since a figure measured mid-lap is stale by the time the lap commits)
**Status:** Landed -- laps 1-3 + stamp + seal + chunk + purchase delivery; Pond customs gates scrub; forge view folds a live sealed pour - **CLI wave e150** Q6 pour parse - Class W parked - couples held (carry/restore wait)
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Style:** Gauge, Door setting (see `../context/GAUGE_STYLE.md`)

**Amphora** is **vessel software** -- preservation **in motion**. It carries sealed resins across a crossing (wire, dock, or pocket) under the same resins law and Kumara stamp as the cellar.

A **vessel** is one file. You hand Amphora a season -- a directory of work you want to keep -- and it
writes that whole season into a single readable `.bron` file you can put in a pocket, hand across a
wire, or set on a shelf for a decade. Three verbs carry it, and the order inside the first one is
the whole design. **Pour** fills the vessel, encrypts the cargo, and only then signs the canonical
body, so the signature covers the sealed bytes rather than the clear ones, and a change to either
half shows up in the other. **Carry** moves the vessel to a far dock, cutting it into chunks
when it outgrows one datagram and proving the far bytes equal the near ones on arrival. **Restore**
opens it cold at the other end, verifies before it trusts anything, and lands every file back at
the parent it left.

What makes a vessel worth trusting is that every wall names itself. Amphora checks the manifest
line, the season's identity, the seal, the vessel's full length, and each chunk of a large resin,
and it answers by name the moment one of them disagrees -- while the vessel already on disk keeps
every byte it had. Three of the room's guards are negative twins that plant exactly those faults --
a forged manifest line, a tampered seal, a truncated vessel, a torn chunk -- and prove each wall
answers by name.

How many guards stand over this room, how many of them run every lap, whether any module stands
without one, and whether the guard list below is whole are read off an instrument rather than typed
here: `sh tools/fixtures/am/amphora_roster_scan.sh`. A number in this paragraph drifted from twelve
to sixteen inside a day while nothing listened, which is why the sentence names the command instead
-- and the list thirty lines down drifted the same way, to 11 of 16, because the first repair
reached the count and stopped there. `readme_unnamed` reaches the list.

## CLI surface

Canonical roof: [`src/main.rye`](src/main.rye) -- `//!` header + Q3 metal. HTML comment twin retired by accretion (e144). This table is the README surface roof.

| Command | Duty |
|---------|------|
| `amphora version` | free version string on **stdout** - exit 0 |
| `amphora pour <season> <vessel>` | fill vessel - seal then stamp inside pour |
| `amphora carry <vessel> <dock>` | move to far dock - chunk inside carry |
| `amphora restore <vessel>` | cold scrub - verify - restore |

*Q3-Q6: version - bounds - CliError - couples - pour parse (`PourArgs`). Shared bounds agree via `tools/am/amphora_bounds_agree.rish`, which reads four relations -- a **derived** same-name roster, alias value groups, declared `couples:` equalities, and declared `covers:` orders. Run it for the counts; this line names the readings rather than their numbers. Pour/carry/restore wait their quests. Nested wave lean: **the Crossing Chapter** (seat Keaton's).*

| Lap | What |
|-----|------|
| **1 (landed)** | Manifest entry parse (wreck rule) + vessel `.bron` fields (format - stamp - shoulder - parent - cargo) |
| **2 (landed)** | Pour Cellar ring-1 season into vessel; carry to far dock; cold scrub + restore; 3-2-1 fixture scale |
| **3 (landed)** | Comlink hosted fetch-by-digest for vessel cargo (source port **38495**; each asker's port is the kernel's); device-wire virtio lab (**15571**/**15572**) |
| **Stamp (landed)** | Kumara `stamp_sig` on canonical vessel body; verify on pour + scrub |
| **Seal (landed)** | Cellar ChaCha20-Poly1305 on cargo (`seal_nonce` - `seal_tag` - `seal_cargo`); shoulder stays clear; seal then stamp |
| **Chunk (landed)** | Large resin beyond one datagram -- kind **0x33** chunks + `ResinAssembler`; 400 B witness |
| **Purchase delivery (landed)** | Commerce slip binds `vessel_parent` + `payment` under Kumara; Granary is the sharing surface; Mandi is the vessel market floor (seated `165634`) |

**Forge surface:** Realidream `forgeviewtest` pours `amphora_lap3_tree` via `tools/fixtures/f/forge_view_pour.sh`, then folds the sealed bundle onto Skate (`tools/r/realidream_forge_view.rish`).

**Ground:** silo [`foundations/20260703-201612_the-sealed-crossing.md`](../foundations/20260703-201612_the-sealed-crossing.md) - study [`external-research/20260703-201612_the-amphora-and-the-crossing.md`](../external-research/20260703-201612_the-amphora-and-the-crossing.md) - sealed crossing plainly [`external-research/20260710-002952_sealed-crossing-plainly.md`](../external-research/20260710-002952_sealed-crossing-plainly.md) - crossing metal plainly [`external-research/20260710-145313_amphora-crossing-plainly.md`](../external-research/20260710-145313_amphora-crossing-plainly.md)

**Standing witnesses.** How many stand over this room, how many run every lap, and whether the list below is whole are read off `sh tools/fixtures/am/amphora_roster_scan.sh` -- `guards`, `lap_guards`, `cadence_guards`, and `readme_unnamed`, which the scan holds at **zero**, so a guard seated without a name at this door reds on the lap it arrives. That last reading was added `20260908` after the list here named 11 of 16 rostered guards, passing over the two seated most recently: a count read off an instrument beside a list typed by hand is half a repair. On the lap clock: [`amphora_pour`](../tools/am/amphora_pour_witness.rish) - [`amphora_pour_negative`](../tools/am/amphora_pour_negative_witness.rish) - [`amphora_carry`](../tools/am/amphora_carry_witness.rish) - [`amphora_carry_negative`](../tools/am/amphora_carry_negative_witness.rish) - [`amphora_restore`](../tools/am/amphora_restore_witness.rish) - [`amphora_restore_negative`](../tools/am/amphora_restore_negative_witness.rish) - [`amphora_grand_round`](../tools/am/amphora_grand_round_witness.rish) - [`amphora_first_resident`](../tools/am/amphora_first_resident_witness.rish) - [`amphora_roster`](../tools/am/amphora_roster_witness.rish) - [`amphora_bounds_agree`](../tools/am/amphora_bounds_agree.rish) - [`amphora_lap3`](../tools/am/amphora_lap3.rish) - [`amphora_resin_chunk`](../tools/am/amphora_resin_chunk.rish) - [`amphora_purchase_delivery`](../tools/am/amphora_purchase_delivery.rish) - [`amphora_mark_wreck`](../tools/am/amphora_mark_wreck_witness.rish) - [`amphora_manifest_agrees`](../tools/am/amphora_manifest_agrees_witness.rish) - [`amphora_contained_name`](../tools/am/amphora_contained_name_witness.rish) - [`amphora_framed_name`](../tools/am/amphora_framed_name_witness.rish) - [`amphora_prove_before_write`](../tools/am/amphora_prove_before_write_witness.rish) - [`amphora_named_once`](../tools/am/amphora_named_once_witness.rish) - [`amphora_ferried_body_proven`](../tools/am/amphora_ferried_body_proven_witness.rish). On the slower `tier cadence` clock beside them: [`amphora_asker_reply`](../tools/am/amphora_asker_reply.rish) and [`amphora_udp_reuseaddr`](../tools/am/amphora_udp_reuseaddr_witness.rish), the second there because it is **2m8s** measured rather than the 1s its own roster row claimed while it sat parked. Each negative twin plants at the wall it names and asserts the refusal by its own error, so the family is proven able to red rather than only to pass -- and `amphora_mark_wreck` carries that habit to the one field that had no negative anywhere in the room, proving an unknown cargo mark is refused by `parse_manifest_line` itself. They stand on the field's standing-equipment roster, which is a maintainer room the seed withholds -- named here rather than linked, so this page reads whole in both repositories.

**The last three put three more modules on a clock.** The guards that build `src/main.rye`, `vessel_core.rye` and `vessel_seal.rye` reach `manifest_entry.rye` by import, and the scan answers how many stand over each module through `covered`, `singly_covered` and `detail_singly`. This sentence carried that number in letters until `20260908`: written into `05c87d3d0` while twelve guards stood over the room, and read again once `amphora_mark_wreck` made sixteen, one more of which builds all three. A count in letters drifts exactly as a count in digits does, so `readme_spelled_words` reads the letter form beside `readme_spelled_lines` and reports it for a hand to judge -- `three more modules` above names what it counts, and prose that honest stays welcome. `purchase_delivery.rye`, `vessel_fetch_wire.rye` and `vessel_fetch_delivery.rye` carry about a third of what this room owns -- `own_lines` and the `detail_lines` listing on `sh tools/fixtures/am/amphora_roster_scan.sh` weigh each module on every run, and `readme_spelled_lines` holds this page at zero counts spelled in digits, because the figure that stood here was measured against the tree as it was and then written into the same commit that grew one of the three, shipping stale inside the commit that made it stale. `20260906` put all three on a lap clock for the first time. Running the three that do then found the fetch path stalling one time in six to eight: it closed its socket between datagrams and left the receive unbounded, so a datagram that arrived while the socket was shut went past, and the receive after it waited forever. It binds before it sends now and holds one socket per exchange, every receive bounded and named, and the source's port is taken under a host-wide lock (`tools/fixtures/a/amphora_vessel_port_lock.sh`) because eight trees on one pier reach for one machine's ports.

**And one of the two ports belonged to the caller all along.** Until `20260906` the source sent every answer to a second number written in its own file, and every asker bound that same number -- so a source answered exactly one asker, the one compiled to expect it, while `recvfrom` handed it the asker's real address on every request and it left that address unread. The address is a caller-owned slot now, `fetch_one` asks the kernel for a free port and reads it back with `getsockname`, and the request leaves by the very socket the answer will arrive on. Two askers in one demo print two different ports, both of them the kernel's. What separates *answers the asker* from *answers a number* is crossing one repaired end against one elder end, which nothing had done: [`amphora_asker_reply`](../tools/am/amphora_asker_reply.rish) plants both elder faults and runs five legs, both refusals bitten and every welcome asserted as hard. The lock stays, because the source's own port is still one number a machine owns. REDS %485.

**Hand witnesses** (run by name, on no clock): `tools/am/amphora_lap1.rish` - `tools/am/amphora_lap2.rish` - `tools/am/amphora_device_wire.rish` - `tools/am/amphora_vessel_stamp.rish` - `tools/am/amphora_vessel_seal.rish` - `tools/p/pond_customs.rish` - `tools/r/realidream_forge_view.rish` - elder path `tools/cr/crossing_manifest_seed.rish`. Four of them build only modules the standing lap guards already compile, so they add claims rather than reach; `amphora_device_wire` drives a virtio lab this pier has no qemu for, and refuses honestly at exit 1 rather than pretending. **All five hand the target's reason on** (`20260906.124500`): each is an accrete shim onto `tools/gen/amphora/`, Rishi's `run` puts the target's stderr in `r.err`, and saying only `r.out` left the exit code travelling while the sentence stayed behind. `amphora_device_wire` measured it without a plant -- run the target directly and a reader gets `rishi: assertion failed -- Amphora vessel fetch device wire lab failed` with its line number; run the shim and stderr was zero bytes. The habit is held for the whole tree by [`shim_reason`](../tools/s/shim_reason_witness.rish), whose gate refuses a shim on the standing roster that drops its reason.

**Tensegral Arc I r3** (`20260728.000659`): the `amphora_lap1/2/3` witnesses - vessel seal - resin chunk all **GREEN** this sitting -- Arc I (Brix - Cellar - Amphora) exits.

**Resin homes (one job each -- consolidated `20260728.003902`):**

| Home | Job |
|------|-----|
| [`../tools/am/amphora_resin_chunk.rish`](../tools/am/amphora_resin_chunk.rish) | Amphora chunk hand -- rebuild - chunkdemo - fixture scrub |
| [`../tools/r/resin_unit_witness.rish`](../tools/r/resin_unit_witness.rish) | Arc II public resin fold -- batch - granary - chunk fixture - TUBE3 |
| [`../tools/t/tensegral_arc_ii_witness.rish`](../tools/t/tensegral_arc_ii_witness.rish) | Arc II season fold -- resin unit + Glow floors |

*May every vessel stay sealed in motion. May every pour remember its cellar.*
