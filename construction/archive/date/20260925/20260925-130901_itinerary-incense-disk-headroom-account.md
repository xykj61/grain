# ITINERARY -- the disk headroom account

**Shelved:** `20260925.130901` -- **Status:** Archived, complete
**Living card:** [`../../../ITINERARY.md`](../../../ITINERARY.md) -- **Ledger:** the row stamped `20260925.130901`
**Room:** checkable -- every reading below was taken on metal and names the instrument that took it.

*A completed account belongs on a shelf; the card keeps one pointer line and the open question.*

---

## THE PIER'S OWN DISK, AND WHICH ROOMS WERE SAFE TO CLEAR

The card's own open item (`20260918.091343`) named a cold pass dying with no `run_verdict=`, the
root filesystem at 97% full, 5.5G free. Re-read this lap: **96% full, 7.6G free**, still the
sharpest fault on the pier.

`git status --porcelain --ignored=matching .` summed each ship's own gitignored bytes with `du -s`,
one `git check-ignore -q` gate ahead of every reading:

| Ship | Gitignored bytes |
|---|---|
| bakery | 10.3G |
| copal | 11.6G |
| diffuser | 7.7G |
| grass | 12.4G |
| incense | 12.5G |
| patchouli | 9.5G |
| petrichor | 3.7G |
| pheromone | 14.8G |

**~82G across eight checkouts, almost entirely compiled `*/bin/` witness and CLI binaries** --
`.gitignore` lines `/glow/bin/`, `/caravan/bin/`, `/mycelium/bin/` and twenty-odd siblings, every
one rebuildable output that is never tracked.

**Cleared, incense's own tree only:** `glow/bin`, `caravan/bin`, `mycelium/bin`, `image/bin`,
`crypto/bin`, `pond/bin`, `brushstroke/bin`, `lotus/bin`, `constel/bin`, `mantra/bin`,
`linengrow/bin`, `pond/apps/bin`, `mikrophone/bin`, `tools/.build`, `tally/bin`, `amphora/bin`,
`comlink/bin`, `mandate/bin`, `scribe/bin`, `encoding/bin`, `lattice/bin`, `lantern/bin`,
`glow/nock/bin`, `kyri/bin` -- each removed only after `git check-ignore -q` confirmed it. `rye/bin`
and `rishi/bin`, the load-bearing toolchain binaries themselves (4.1M and 22M), were named and left
untouched. `git status --porcelain` read clean afterward; `tools/ca/caravan_reclaim_witness.rish`
rebuilt from the cleared cache and read GREEN, proving the clear costs rebuild time and nothing
else. `df -h /` moved **96% (7.6G free) to 89% (20G free)** on this one tree's own clear -- a shared
mount, so every ship on the pier gained that headroom at once, the same as `%745`'s `/tmp` reclaim.

**Yours:** the other seven ships' own `*/bin/` rooms (roughly 68G of the ~82G fleet-wide reading)
stay theirs to clear on their own touch, per `.claude/rules/the-baton.md`'s one-writer-per-checkout
law -- a peer's clone is read and a shared fault is repaired, never a peer's own tree edited in
place. Whether a rostered tool belongs in `tools/` so each ship runs one command rather than a typed
loop is named here rather than built this lap.
