# Where the modules stand

**Stamp:** `20261008.184341`
**Language:** EN
**Style:** Bhakta, with Radiant warmth
**Voice:** Kyri
**Room:** checkable -- a status a newcomer can read, and a plan for three seats
**Status:** Living -- Cancer of the orbit that opens at commit 8,071

This is a picture of where the work stands, and of three seats we could take together. Nothing on this page moves a module. The weave ceiling stays `1 << 20`.

## Where we are

Commit 8,073 said the ceiling aloud. This seat is 8,074, Cancer. A weave holds at most 1,048,576 lines. That number lives at `mantra/src/weave.rye` line 142, as `max_weave_lines`.

The fascia face is 60.0000, measured `20261008.184341`. It moved from 59.7000. The shell grade stays 58, and the root README badge stays 58. Sky of this orbit opens at commit 8,083. Siya closes it at 8,085. We are seven commits from that sky.

```
ceiling            1,048,576 lines
    |
    v
current            the lines that are present
    |
    v
your slice         the read copies them into memory you own
```

The same picture stands on `docs-geode/tutorials/README.md`.

## The modules, in plain words

Each line is the module's own door, read `20261008.184341`.

- **Comlink** carries a sealed message. It arrives whole, or it stays with the sender.
- **Mantra** keeps names. A name is peer, bolt, revision, and path. Ask twice, and the same bytes come back.
- **Caravan** starts the other programs, watches them, and brings home any that stumble, inside limits fixed before it begins.
- **Tally** is the garden. Memory has a start, a length, and an end. A request that does not fit fails cleanly.
- **Pond** is the floor a person opens. The applications live there.
- **Tablecloth**, in `pond/apps/tablecloth.rye`, gives an artifact a name. The same bytes can wear more than one name, and they are stored once.
- **Brushstroke** draws plain values into a frame, then releases them.
- **Skate**, and Surf beside it, are one native frame for that drawing. Two names, one surface.
- **Rye** is the language. **Rishi** is the shell that speaks it.
- **Aurora** is the boot: the first light between a cold processor and a living system.
- A **resin** is content at a SHA3-256 digest. Mantra's door says so. **Nib** is our word for a landed edge, not a module with a door of its own.

## What the next three seats could do, together

Leo, this same send, reads the cost of the ceiling and edits no function. Virgo, this same send, leaves one small untidiness where it sits: the line-count parse in `ember/ember_core.rye`.

The three seats after that can be one bundle, still about a bound said once:

- **Libra, commit 8,077.** Done this send. Two checks, one green line.
- **Scorpio, commit 8,078.** Hold this page whole. Read it. Add no module and no second picture.
- **Sagittarius, commit 8,079.** Say the mission in four registers: Bhakta, Gauge, Radiant, and Twilight. One bound, the modules above, four voices.

## Libra, the two checks

Read `20261008.191640`.

`mantra/src/weave.rye` line 142 is still `pub const max_weave_lines: u32 = 1 << 20`. That is 1,048,576 lines.

`caravan/capabilities.rye` line 23 is still `pub const max_caps_per_dependent: u32 = 8`. Twenty-one Caravan files refuse a count past that constant, with `cap_count > capabilities.max_caps_per_dependent`.

The green line is the fascia witness: `GREEN: fascia-metric-v0`. Five roster calls in `pond/apps/mcp_kyri.rye` and `pond/apps/mcp_prompt_voice.rye` now call `tally_parse_int.parse_int`. The face moved from 60.0000 to 60.5000. The shell grade stays 58. `ember/ember_core.rye` still parses its line count with `parseInt`, outside the roster.

Sky of this orbit opens at commit 8,083. After this send the count is 8,078. Five rounds sit between that open and the sky: Scorpio, Sagittarius, Capricorn, Aquarius, Pisces. Siya closes the orbit at 8,085.

That bundle reads. It does not rename, and it does not open a wallet.
