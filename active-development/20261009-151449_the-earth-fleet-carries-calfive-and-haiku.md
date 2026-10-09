# The Earth fleet carries Calfive, and defaults to Haiku 5.5

**Stamp:** `20261009.151449`
**Language:** EN
**Style:** Bhakta at Gauge Field, with Radiant warmth
**Voice:** Kyri
**Room:** development -- a backup, an adaptation, and two version bumps, each proven before
it shipped
**Kin:** [`../tools/f/archive/date/20261009/README.md`](../tools/f/archive/date/20261009/README.md) - [`../context/SPELLBOOK.md`](../context/SPELLBOOK.md) - [`../nixos/configuration.nix`](../nixos/configuration.nix)

## What was asked, and what this does

Keaton asked to back up the Earth fleet's outer and inner loop scripts, build adapted ones
that fuse the new calfive schedule guard and default to Haiku 5.5, and bring the nixos
config's agent CLIs to their latest upstream versions, so `dallas-keeper` can pull the result.

## The backup, and why it stays plain

`tools/f/fleet-loop.sh` (the outer loop -- one seat, one deadline, round-open every lap) and
`tools/f/fleet_lap.sh` (the inner loop -- the one `claude` invocation, run inside the
enclosure) are copied byte-identical to `tools/f/archive/date/20261009/`, confirmed with
`diff` before either living file moved. A walk-back costs one `cp` and a `chmod +x`, named in
that folder's own `README.md`.

## The adaptation, proven rather than assumed

**Calfive, fused at round-open.** `fleet-loop.sh` now runs
`tools/fixtures/c/calfive_schedule_scan.sh` right after `fleet_round_open.sh` succeeds and
prefixes its lines `calfive: ` into the lap's own transcript. It is piped through `|| true` on
purpose -- a scheduling conflict is named, never a reason to stop a lap, the same
report-rather-than-gate choice the guard already makes for anything a lap cannot fix by
running again. Proven on metal: a clean run prints `calfive: verdict=ok`; a planted conflict
(count 8,101 paired with a false round 5, in a throwaway directory) prints the conflict by
path and the whole statement still exits 0.

**`FLEET_MODEL`, defaulting to `claude-haiku-5-5`.** Both `fleet_lap.sh` (the jailed path
every Linux Earth ship actually runs) and `fleet-loop.sh`'s own Darwin/bare path read
`${FLEET_MODEL:-claude-haiku-5-5}` and pass it as `--model`, the same env-var-override shape
`LOOP_HOURS` and `FLEET_BARE` already carry. A round that wants the fuller model still gets
it, by naming `FLEET_MODEL=claude-sonnet-5-5` or whichever string a hand types.

Proven with `FLEET_DRY=1` against this tree's own live seat, `incense`, both with the default
and with an override:

```
$ FLEET_DRY=1 sh tools/f/fleet-loop.sh incense
claude --dangerously-skip-permissions --effort medium --model claude-haiku-5-5 --output-format stream-json --verbose -p <tools/i/incense_seat_prompt.txt>

$ FLEET_DRY=1 FLEET_MODEL=claude-sonnet-5-5 sh tools/f/fleet-loop.sh incense
claude --dangerously-skip-permissions --effort medium --model claude-sonnet-5-5 --output-format stream-json --verbose -p <tools/i/incense_seat_prompt.txt>
```

`pheromone` and `petrichor` refuse on this machine with "seat X belongs in grain-X; this tree
is grain-incense" -- the tree's own one-seat-one-tree guard (REDS %291) working exactly as
designed, since those two ships' trees are not checked out here. The logic is seat-agnostic;
the same tracked file will carry the identical behavior once each ship's own tree pulls this
commit.

## What this leaves for a hand to watch

The jailed path (every Linux Earth ship, which is all three today) has not been run end to
end with this change -- only syntax-checked and dry-run-printed. The first real lap on
`pheromone` or `petrichor` after this lands is the honest proof that `--model claude-haiku-5-5`
is a flag their installed `claude` binary accepts and that Haiku answers the baton's own
instructions at the quality a lap needs. If it does not, `FLEET_MODEL=claude-sonnet-5-5` on
that one launch is the whole repair.

## The nixos bump, sourced rather than guessed

`nixos/configuration.nix` pins three agent CLIs by overlay. This round checked two against
their own upstream, both by fetch rather than by memory:

| Package | Was | Now | Source |
|---|---|---|---|
| claude-code | 2.1.286 | **2.1.295** | github.com/anthropics/claude-code/releases/latest (fetched); checksum from downloads.claude.ai/claude-code-releases/2.1.295/manifest.json's own linux-x64 field |
| codex | 0.155.1 | **0.162.0** | github.com/openai/codex/releases/latest (fetched); checksums from api.github.com's own release-asset digest field for both the main binary and codex-code-mode-host |

Neither checksum was produced by downloading the binary and running `sha256sum` on this
machine -- both are the publisher's own checked, published checksum, read and quoted rather
than computed locally, and the comment beside each says so plainly rather than claiming a
verification this round did not run. `cursor-cli` was left at its current pin; a version
check for it is a short, separate round rather than a third thing folded into this one.

## What this does not do

It does not run `nixos-rebuild switch` anywhere, and it does not touch
`construction/declared-host-config.md`'s own order (tree first, machine second). The tree now
names the newer versions; a pier applies them on its own next pull and rebuild, exactly as
that rule already asks.

May the fleet's cheaper model answer every ordinary lap as well as the dearer one did, and may
the day it cannot be the day `FLEET_MODEL` is already sitting there, one word away.
