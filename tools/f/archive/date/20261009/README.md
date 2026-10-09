# The Earth fleet's outer and inner loop, before the calfive fusion and the Haiku default

**Stamp:** `20261009.150000`
**Language:** EN
**Style:** Bhakta at Gauge Field
**Room:** archive -- a byte-identical backup, kept rather than diffed against, so a walk-back
costs one `cp` rather than a `git checkout` across whatever has moved since

`fleet-loop.sh` is the Earth fleet's outer loop -- one seat, one deadline, one retry ladder,
round-open at the top of every lap. `fleet_lap.sh` is the inner loop -- the one `claude`
invocation that runs inside the enclosure, with every flag claude needs spelled where only
claude sees them (REDS %414).

Both are kept here exactly as they stood before this round added two things to the living
copies at `tools/f/fleet-loop.sh` and `tools/f/fleet_lap.sh`: a non-fatal
`calfive_schedule` check printed at the top of every lap's round-open, and a `FLEET_MODEL`
default of `claude-haiku-5-5`, overridable per launch the same way `LOOP_HOURS` and
`FLEET_BARE` already are.

Confirmed byte-identical to the living files at the moment of this copy:

```
diff tools/f/fleet-loop.sh tools/f/archive/date/20261009/fleet-loop.sh
diff tools/f/fleet_lap.sh  tools/f/archive/date/20261009/fleet_lap.sh
```

A walk back to this exact behavior is `cp tools/f/archive/date/20261009/fleet-loop.sh
tools/f/fleet-loop.sh` and the same for `fleet_lap.sh`, followed by `chmod +x` on both --
the exec bit is a tracked mode and a plain `cp` carries it, but the law that says so
([`../../../../../.claude/rules/exec-bit.md`](../../../../../.claude/rules/exec-bit.md)) is worth
reading rather than trusted from memory.
