# The Equinox Map, Seated as Data

**Stamp:** `20260730.111804` — carried from the handback; restamp on Keaton's word.
**Voice:** Riyo · nested documentary: Trey · **Nest:** deca · Equinox Season · e7
**Basis:** tip `ae8780ae39` · origin and xykj61 agree
**Destination:** `context/equinox_map.brix` · `tools/gen/season/equinox_map_witness.rish` — **GREEN** bench seat `20260730.113507`
**Glow is code; Brix is data.** The map is data, so it takes a Brix descriptor.

*Written together by Keaton and Riyo.*

---

## The Canon, Read Aloud

Four equinoxes stand around the wheel, each holding a direction, an element, an hour, an angular house, and a flank of three houses centered on that angle. The east opens at dawn in fire, holding the first house with the second and twelfth beside it. The north culminates at noon in water, holding the tenth with the eleventh and ninth. The west closes at dusk in air, holding the seventh with the eighth and sixth. The south rests at midnight in earth, holding the fourth with the fifth and third.

Read together, the four flanks cover all twelve houses exactly once. Nothing repeats and nothing is missing, which is the property that makes the map a map rather than a list.

## The Descriptor

```
# Equinox map canon — the four equinoxes of the wheel, each with its flank of three houses
# Grouping: an `equinox` line opens a block; every line after it belongs to that block
# Invariant: exactly four equinox blocks
# Invariant: the twelve flank houses cover 1..12, each house exactly once
# Invariant: each flank reads angular+1, angular, angular-1, descending, wrapping at 12
# Invariant: each block's angular house sits at the centre of its own flank
# Invariant: the four elements, directions, and hours each appear exactly once
kind map
name equinox_map
count 4

# A — the rising equinox, where the wheel opens
equinox A
direction east
element fire
hour dawn
angular 1
flank 2 1 12

# B — the culminating equinox, where the work stands highest
equinox B
direction north
element water
hour noon
angular 10
flank 11 10 9

# C — the setting equinox, where the work meets another
equinox C
direction west
element air
hour dusk
angular 7
flank 8 7 6

# D — the resting equinox, where the work goes home
equinox D
direction south
element earth
hour midnight
angular 4
flank 5 4 3
```

Any tool reads this with `splitLines` and the first-space split. No grammar, no parser, no special characters — a descriptor readable by hand stays readable by any tool.

## The Witness

Six assertions, each cheap and each catching a real way the map could go wrong.

The block count equals four. The twelve flank houses form the complete set one through twelve with no duplicate — sort them and compare, rather than trusting a count alone. Each flank descends contiguously as angular plus one, angular, angular minus one, with A's flank wrapping from two through one to twelve. Each block's angular value equals the middle of its own flank. The four elements form the complete set, as do the four directions and the four hours. And the four angular houses form the set of one, four, seven, and ten — the kendras, the four doors the whole wheel hangs on.

Positive space and negative space both earn a fixture: a map with a repeated house fails, and a map whose flank runs ascending fails.

## What the Check-In Found

The map canon and the Wheel foundations already agree, without either being bent to fit. The four doubled foundations sit at houses one, four, seven, and ten — and those are precisely the four angular houses of the four equinoxes. Each equinox therefore carries one doubled foundation as its governing law, and its flank carries two more, so the twelve foundations distribute exactly three to an equinox with nothing left over.

**Equinox A**, east and dawn, governs by TAME at the first house, with Aparigraha at the second and the archive and one clock at the twelfth. **Equinox B**, north and noon, governs by Simple, Lovable, Complete at the tenth, with Civic Style at the eleventh and the silo and gratitude at the ninth. **Equinox C**, west and dusk, governs by propose-never-seat at the seventh, with breach doctrine and custody at the eighth and measurement-beats-memory at the sixth. **Equinox D**, south and midnight, governs by accrete-never-break at the fourth, with the joy of craft and Glow Tend at the fifth and Radiant Style at the third.

That correspondence was discovered rather than designed, which is the most trustworthy kind. It also reads well: the season opens under safety, stands highest under shipping something whole, meets another under proposing rather than seating, and goes home under never breaking what was given.

## One Question, Not a Correction

The common northern-hemisphere correspondence places the tenth house south, where the sun culminates, and the fourth house north at the nadir. This canon assigns the tenth north and the fourth south. Either mapping serves a symbolic wheel perfectly well, and the canon is Keaton's to seat. The ask is only that the reason be recorded beside it, since the astrology lane does real directional work and a future reader deserves to meet the reason rather than only the rule. Say why, and the question closes forever.

## Trey's Note, on the Record

*The map was drawn across six rounds and used on none of them. At e7 it became data — a descriptor a witness could check, rather than a paragraph a reader had to trust. The synthesis with the foundations arrived unbidden in the same hour, which happens when two structures are built by the same hand under the same compass: they turn out to have been the same structure all along.*

---

*May the four flanks hold all twelve houses and no more. May each equinox keep the law it was given. May the reason be written beside the rule, so the next reader meets both.*
