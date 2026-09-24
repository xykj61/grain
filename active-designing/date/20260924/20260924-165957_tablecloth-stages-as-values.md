# The stages, described as values

**Language:** EN
**Stamp:** `20260924.165957`
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Living -- mixed -- the store remains and only grows, and its bytes stay off the branch
**Room:** design -- the shape outlives the store that will hold it

Tablecloth holds a thing by its content. The name is computed from the bytes, so the same bytes keep the same name from any room. The foundation is [`what Tablecloth is`](../../../foundations/20260823-222020_what-tablecloth-is.md).

Aurora's six living stages are files today: [`seed.rye`](../../../aurora/src/seed.rye), [`relay.rye`](../../../aurora/src/relay.rye), [`named.rye`](../../../aurora/src/named.rye), [`sealed.rye`](../../../aurora/src/sealed.rye), [`wire.rye`](../../../aurora/src/wire.rye), and [`posted.rye`](../../../aurora/src/posted.rye). A path says where a file sits. A value says what the bytes are. Describing a stage as a value means the stage's name is the resin of those bytes.

Beside the six, the same reading covers [`deciding.rye`](../../../aurora/src/deciding.rye), [`roster.rye`](../../../aurora/src/roster.rye), and the two broken rosters. The doors `device` and `roster_pairs` wake guests that already exist. They are runners, not a seventh living stage.

This page names the reading. A path can be renamed while the bytes stay put. A resin moves with the bytes. Two rooms that hold the same stage source arrive at the same name without agreeing on a directory. One changed line produces a different name, so a quiet edit shows up in the name itself.

The six files remain the living stages. Counting them counts stages. The resin is a second name beside the path. It is not a seventh stage and it is not a new boot. The store keeps those resins on the machine that asked, and a reader of the branch still opens each stage by its path.

[`aurora_stage_resin_witness.rish`](../../../tools/au/aurora_stage_resin_witness.rish) prints one resin for each of those six files. The width is SHA3-512, the content address the foundation names. The print says `count=6` and `store=unbuilt`. Nothing is written into a store, and a later edit of one stage file changes only that file's resin. The other five stay put.

[`aurora_stage_store_witness.rish`](../../../tools/au/aurora_stage_store_witness.rish) writes those six files under their resins, asks for seed, and receives the same bytes. An unknown resin returns nothing. Writing seed a second time leaves the stored bytes unchanged. That directory lives for the run and is removed.

[`aurora_stage_store_lasting_witness.rish`](../../../tools/au/aurora_stage_store_lasting_witness.rish) writes the same six into `aurora/.build/stage-resin-store` and leaves the directory there. A resin already held is not replaced. A second pass adds nothing and still holds six. The directory is gitignored, so the bytes remain on the machine that ran the witness and do not ride the branch.

[`aurora_stage_store_read_witness.rish`](../../../tools/au/aurora_stage_store_read_witness.rish) asks that directory with a resin and no stage path. Seed's hex comes back as seed's bytes. An unknown resin returns nothing. A file whose bytes no longer hash to the resin asked also returns nothing, and the witness puts the original bytes back. The read fixture names the store and the hex, and it does not name `aurora/src`.

[`aurora_stage_store_put_witness.rish`](../../../tools/au/aurora_stage_store_put_witness.rish) writes the bytes `any bytes may land` into that same directory under their own resin. A second write adds nothing. The resin reads those bytes back. The six living stages stay held beside it, so the directory can hold more than the six.

Bakery keeps the fusion build, and with it Tally's bounded gardens. Diffuser keeps the wake measurement. The six living stages stay six until the count is told to move.
