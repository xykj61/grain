# Amphora -- vessel software

**Language:** EN
**Stamp:** `20260710.161358`
**Last updated:** `20260906.093709` (three more guards on the clock; the fetch path's stall bounded and named)
**Status:** Landed -- laps 1-3 + stamp + seal + chunk + purchase delivery; Pond customs gates scrub; forge view folds a live sealed pour - **CLI wave e150** Q6 pour parse - Class W parked - couples held (carry/restore wait)
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)

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
every byte it had. Eleven standing witnesses run every lap, and four of them plant exactly those
faults and prove each wall answers by name.

## CLI surface

Canonical roof: [`src/main.rye`](src/main.rye) -- `//!` header + Q3 metal. HTML comment twin retired by accretion (e144). This table is the README surface roof.

| Command | Duty |
|---------|------|
| `amphora version` | free version string on **stdout** - exit 0 |
| `amphora pour <season> <vessel>` | fill vessel - seal then stamp inside pour |
| `amphora carry <vessel> <dock>` | move to far dock - chunk inside carry |
| `amphora restore <vessel>` | cold scrub - verify - restore |

*Q3-Q6: version - bounds - CliError - couples - pour parse (`PourArgs`). Shared bounds agree via `tools/am/amphora_bounds_agree.rish` (path C - alias - couples). Pour/carry/restore wait their quests. Nested wave lean: **the Crossing Chapter** (seat Keaton's).*

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

**Standing witnesses** (eleven at `tier lap`; eight seated `20260905.225551` and three more `20260906.093709`, about 16s together -- with [`amphora_asker_reply`](../tools/am/amphora_asker_reply.rish) beside them at `tier cadence`, seated `20260906.113014`): [`amphora_pour`](../tools/am/amphora_pour_witness.rish) - [`amphora_pour_negative`](../tools/am/amphora_pour_negative_witness.rish) - [`amphora_carry`](../tools/am/amphora_carry_witness.rish) - [`amphora_carry_negative`](../tools/am/amphora_carry_negative_witness.rish) - [`amphora_restore`](../tools/am/amphora_restore_witness.rish) - [`amphora_restore_negative`](../tools/am/amphora_restore_negative_witness.rish) - [`amphora_grand_round`](../tools/am/amphora_grand_round_witness.rish) - [`amphora_first_resident`](../tools/am/amphora_first_resident_witness.rish) - [`amphora_lap3`](../tools/am/amphora_lap3.rish) - [`amphora_resin_chunk`](../tools/am/amphora_resin_chunk.rish) - [`amphora_purchase_delivery`](../tools/am/amphora_purchase_delivery.rish). Each negative twin plants at the wall it names and asserts the refusal by its own error, so the family is proven able to red rather than only to pass. They stand on the field's standing-equipment roster, which is a maintainer room the seed withholds -- named here rather than linked, so this page reads whole in both repositories.

**The last three closed a gap the first eight could not see.** Those eight build three modules -- `src/main.rye`, `vessel_core.rye`, `vessel_seal.rye` -- and reach `manifest_entry.rye` by import. `purchase_delivery.rye`, `vessel_fetch_wire.rye` and `vessel_fetch_delivery.rye` are 1,160 lines, a third of what this room owns, and until `20260906` nothing on any clock compiled them. Running the three that do then found the fetch path stalling one time in six to eight: it closed its socket between datagrams and set no receive timeout, so a datagram lost to an unbound port waited forever. It binds before it sends now and holds one socket per exchange, every receive bounded and named, and the source's port is taken under a host-wide lock (`tools/fixtures/a/amphora_vessel_port_lock.sh`) because eight trees on one pier reach for one machine's ports.

**And one of the two ports was never the machine's to lend.** Until `20260906` the source sent every answer to a second number written in its own file, and every asker bound that same number -- so a source could answer only an asker compiled to expect it, while `recvfrom` handed it the asker's real address on every request and it read nothing. The address is a caller-owned slot now, `fetch_one` asks the kernel for a free port and reads it back with `getsockname`, and the request leaves by the very socket the answer will arrive on. Two askers in one demo print two different ports, neither of them the retired one. What separates *answers the asker* from *answers a number* is crossing one repaired end against one elder end, which nothing had done: [`amphora_asker_reply`](../tools/am/amphora_asker_reply.rish) plants both elder faults and runs five legs, both refusals bitten and every welcome asserted as hard. The lock stays, because the source's own port is still one number a machine owns. REDS %485.

**Hand witnesses** (run by name, on no clock): `tools/am/amphora_lap1.rish` - `tools/am/amphora_lap2.rish` - `tools/am/amphora_device_wire.rish` - `tools/am/amphora_vessel_stamp.rish` - `tools/am/amphora_vessel_seal.rish` - `tools/p/pond_customs.rish` - `tools/r/realidream_forge_view.rish` - elder path `tools/cr/crossing_manifest_seed.rish`. Four of them build only modules the standing eleven already compile, so they add claims rather than reach; `amphora_device_wire` drives a virtio lab this pier has no qemu for, and refuses honestly at exit 1 rather than pretending.

**Tensegral Arc I r3** (`20260728.000659`): the `amphora_lap1/2/3` witnesses - vessel seal - resin chunk all **GREEN** this sitting -- Arc I (Brix - Cellar - Amphora) exits.

**Resin homes (one job each -- consolidated `20260728.003902`):**

| Home | Job |
|------|-----|
| [`../tools/am/amphora_resin_chunk.rish`](../tools/am/amphora_resin_chunk.rish) | Amphora chunk hand -- rebuild - chunkdemo - fixture scrub |
| [`../tools/r/resin_unit_witness.rish`](../tools/r/resin_unit_witness.rish) | Arc II public resin fold -- batch - granary - chunk fixture - TUBE3 |
| [`../tools/t/tensegral_arc_ii_witness.rish`](../tools/t/tensegral_arc_ii_witness.rish) | Arc II season fold -- resin unit + Glow floors |

*May every vessel stay sealed in motion. May every pour remember its cellar.*
