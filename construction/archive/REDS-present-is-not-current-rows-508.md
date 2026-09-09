# Present is not current -- parked draft

**Language:** EN
**Status:** Recovered historical record -- checkable
**Style:** Gauge, Meter
**Voice:** Kyri
**Recovered:** `20260909.120503`
**Source stash:** `ce363e5093bad6d9024d25ffd859a69faab68c8a`
**Source blob:** `254973bf2112fb70ddf256c4ade30fe247506816`

This draft records an earlier projection receipt keyed to a commit. The current
[input-bound receipt](REDS-the-projection-must-name-its-inputs-rows-660.md)
compares the manifest and admitted paths. Its checks supersede this proposed mechanism.

## Saved draft -- historical claims

The quotation preserves the parked page. Its row numbers were draft allocations,
and its claims of completion describe that parked lap, not the current tree.

> # REDS shelf -- present is not current
>
> **Language:** EN
> **Style:** Gauge, Meter setting (see [`../../context/GAUGE_STYLE.md`](../../context/GAUGE_STYLE.md))
> **Voice:** Kyri
> **Status:** Shelf -- immutable once written; the living pin is [`../REDS.md`](../REDS.md)
>
> One row, and it is the second half of a defect a peer closed the same afternoon. `%493` gave the
> `sow_allow_reach` guard a `capability seed_projection` probe so the six fleet trees carrying no
> `seed/` at all would be named rather than counted red. This row is what that probe could not see:
> on the two trees that HAD projected, `test -d` answered *present*, the guard ran, and it accused
> three files of never arriving that had simply landed after the projection was taken.
>
> The lesson keeps past both: **an artifact carrying no provenance cannot be told from a fresh one**,
> so every reader of it either trusts it or refuses it -- and a reader that trusts it will one day
> publish a confident false accusation in the exact words of the fault it was built to catch.
>
> ---
>
>
> **REDS %508 (`20260906.162327`) -- a capability probe asked where the projection was and the guard asked what it said about this tree, so the two trees that HAD projected went on accusing three innocent files.** *What went wrong:* `sow_allow_reach_scan.sh` reads three inputs and only two of them come from the same tree -- the manifest's `allow` lines and `git ls-files` are read at **HEAD**, while `seed/` is a gitignored build artifact standing at whatever commit `tools/s/sow.rish` last ran on. Nothing recorded which commit that was, so no reader could tell *the projector dropped this room* from *this room landed after the projection was taken*. Measured on this field at the cold open: `GLOW_HOST.template.kyri`, `GLOW_PROFILE.template.kyri` and `publish-seed.template.sh` read `empty: allowed, shippable, and absent with nothing logged` -- and their `allow` lines were added at **14:33**, in the same commit that created them, against a projection built at **13:37**. The projector was never asked to ship them. **The false reading and the true one are spelled identically**, in the scan's own words for the fault it exists to catch (`%489`). *And the gap is the ordinary case rather than the edge:* this guard is `tier lap` where `sow`, which rebuilds its instrument, is `tier cadence`, so it reads a projection older than the tree **four laps in five** even where one exists at all. *What caught it:* reading a red rather than routing around it. The card twice names this guard as another seat's, and `%493` closed the half where `seed/` is **absent** -- 6 of 8 fleet trees -- with a `capability seed_projection` probe spelling `test -d "${SOW_SEED:-seed}"`. That probe's own comment sets the standard this row turns on: *"Answering a different question than the guard would is how a capability becomes an exemption."* `test -d` answers **where the projection is**; the guard asks **what it says about the tree standing now**, and on the two trees that have projected those are two questions. *What it taught:* **present is not current, and an artifact carrying no provenance cannot be told from a fresh one -- so every reader either trusts it or refuses it, and this one trusted it.** `%457`'s class -- absence read from a stale corpus -- with the corpus a build artifact rather than a checkout, which is why no fetch could have helped. *Repaired (`20260906.162327`), in three parts, none of which is a new judgment call:* `sow_project.sh` reads HEAD **before** the first file is copied and writes `seed/.sow-projection.log` **after** the copy completes, so a receipt means a finished projection rather than a partial one, and it is written after `COPIED` is counted so the number the script prints is unchanged; it never ships, since the seed's `.gitignore` denies the root and allows back no `.sow-*` name, exactly as the three logs beside it are already handled. `sow_allow_reach_scan.sh` refuses `projection is stale -- taken at X, tree now at Y` by name, naming both so a hand acts without a second run. The `seed_projection` probe keeps the peer's `test -d` as its first reading and adds the currency reading beneath it -- and **the unknown returns**, which the elder arm could rightly do without: once a receipt is read and `git rev-parse` is called there are tools to go missing again, and anything the probe cannot measure RUNS the guard. *Proven:* all five probe answers on the runner's own bytes -- no directory `absent`, stale `absent`, receipt naming no commit `unknown`, no receipt `absent`, receipt naming HEAD `present`. `sow_allow_reach_control.sh` proves **26 behaviors** across six real git repositories in a throwaway pen, the scan copied in at its own depth because it `cd`s to its own root, every refusal planted and then lifted, **the welcome asserted as hard as the refusals**, and the pen proven innocent against a scan patched to answer `empty=0`. The sharpest leg is the elder's: fed a projection **one commit** old it prints `empty: late -- allowed, shippable, and absent with nothing logged` and exits **zero**, measured. *And the accusation disproved on metal:* re-projected at HEAD, all three accused files ship and the witness reads GREEN. *What it cost while it stood:* this one red also reddened `standing_equipment` beneath it -- `verdict=roster_broken` -- withheld the run receipt, and so refused `--scoped` on the next lap: **867 seconds across 151 guards**, on every ship, every lap. **CLOSED** on `tools/s/sow_allow_reach_witness.rish` GREEN, its stale and unprovenanced refusals planted from the failing side.
