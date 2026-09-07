# Landed accounts -- `20260907.000030`, Copal

*Folded off [`../ITINERARY.md`](../ITINERARY.md)'s live front, which holds what is OPEN and what
waits on Keaton's word. Both rows CLOSED. Cited by stamp rather than by number: the rows were
unshared when this was written, and rule 4 of the derived spine says the stamp is the identity
until the anointed spine binds a view (`.claude/rules/derived-spine.md`).*

## A flaky guard filed seven lines that could not name a behavior

`tools/fixtures/f/fleet_watch_control.sh:24` prints `FAIL <behavior> -- wanted X, got Y` to
**stderr**, so a passing run stays quiet. `tools/f/fleet_watch_witness.rish:17` interpolated
`${ctl.out}` into its assert message and never `${ctl.err}`. The exit code travelled, the summary
`pass=15 fail=1` travelled, and the clause naming *which* behavior failed did not.

The cold open that found it read `fleet_watch red 25s` with `standing_equipment` red beneath it, and
the evidence file held **seven lines**: three banner says, one progress say, and an assertion whose
whole diagnostic was that summary. The control then passed **16 of 16 on six consecutive re-runs**.

**A flake is exactly when the sentence matters most.** A reproducible red can be re-run until it
explains itself; a red that will not reproduce is diagnosable only from what it wrote down the first
time.

Measured the same hour: **eight** controls print FAIL to stderr, **five** are run by a witness, and
**all five of those witnesses stood on the standing roster** interpolating `.out` alone --
`fleet_watch`, `fleet_lap_verdict`, `publish_template`, `unshared_citation`, `sealed_digest`. All
five carry `${ctl.err}` now, proven on metal by planting one wrong expected value in
`sealed_digest_control.sh`: the evidence went from `pass=8 fail=1` alone to that line plus
`FAIL an unread seal is counted -- wanted PLANTED_WRONG, got yes`.

`tools/fixtures/s/shim_reason_scan.sh` grew a second reading rather than the tree growing a second
instrument -- one law, *hand on your target's reason*, and two shapes. `reason_lost_rostered` is
gated at zero, `reason_lost_unrostered` is a ratchet opening at zero, and `stderr_controls` names
the population so a zero is visible rather than assumed. **The reading caught itself:** the
control's pen helper WRITES a stderr-reporting control, so its own source carries that line inside
single quotes, and the first pattern read **9** where the tree holds **8**. Twenty-one new pen
readings, six new repositories, **61 cases over 14 repositories**.

**Not taken, named:** the three `chatgpt_mind` controls print FAIL to stderr and have no `.rish`
caller at all, so they carry no loss today and would carry one the lap somebody writes them a
witness. The gate is what spares that lane the discovery.

## The cellar's catalog named 3 of its 17 resins, and nothing read it

`bron-resins/manifest.bron` carries one `entry <basename> <note>` line per resin, and its own `note`
line states the habit that keeps it current -- *commit with the resin*. The habit held for the first
three files of the first morning, `20260712`, and lapsed. The catalog also had **no reader**: three
scans name `bron-resins/` only to skip it as testimony, and no witness, runner, or roster row opened
it.

**The council rota found it.** Lap 4114 read row 4, Earth, whose Dual seat is
[`the-marked-value`](../../foundations/20260703-202312_the-marked-value.md) -- the document whose
Amber clause promises *every resin records the marks of what it seals, so a reader in another decade
knows what the cellar held without opening it.* The row that breathes in reads the concrete fact at
the door, and the fact at this door was a catalog four fifths short.

**A lantern rather than a loom, measured before the instrument was built.** Every tracked file in a
living room whose name carries `manifest`, `catalog`, or `roster` was crossed with its readers, and
every other one has one. So the repair is one cellar's scan rather than a general instrument, and
the near-miss is named: `cellar/ring1_manifest_shape.bron` is cited only by `cellar/README.md`, and
it is a *shape* rather than an enumeration, in a lane this seat does not hold.

The catalog names all 17 now, each note written from that resin's own first header line rather than
from a summary, and the one `.md` file in a room whose `law` line says Bron only is **named rather
than swept**, because a catalog states its exception instead of hiding it.
`tools/b/bron_resins_catalog_witness.rish` is rostered `tier lap` at 4s over 34 planted behaviors.

**Left standing, named:** the catalog's header promises SHA3-256 names *when sealed* and the entries
carry plain paths, so the mark and digest of the-marked-value's three-field line are a later lap
rather than a gap this one hid.
