# A Birth-Chart Reading — The Composable Template

*One skeleton for every new reading. Fill the brackets, verify the sky twice, compose each section from the study silos, and close with a blessing. The person's true name lives only in the copy you hand them; the working copies carry a placeholder, so the craft stays portable and the person stays private.*

**Stamp:** `20260701.232912`
**Style:** Radiant (see `RADIANT_STYLE.md`), gentle register throughout
**Companions:** [`../cast_a_chart.rish`](../cast_a_chart.rish) (the computation), the numbered study silos in [`studies/`](../studies/) (`00`–`20` and those yet to come; index at [`studies/README.md`](../studies/README.md)), [`../../context/SILO_TECHNIQUE.md`](../../context/SILO_TECHNIQUE.md)

*Written together by Kaeden and Reya 2; shaped into a template with the outside reading (Fable 5) at Kaeden's direction.*

---

## How a Reading Is Made

**First, receive the birth moment verbatim.** Date, clock time, time zone, and birthplace come from the person and are honored exactly as given — the one-clock rule of the whole project, applied to a life.

**Second, cast the sky twice.** Edit the constants at the head of [`../cast_a_chart.py`](../cast_a_chart.py) and run [`../cast_a_chart.rish`](../cast_a_chart.rish) from the repository root: tropical signs for dignity, sidereal Lahiri longitudes for nakshatra and pada, whole-sign houses rising from the ascendant. Then cast the same moment with one independent tool and compare, placement by placement. Two oracles that agree make a chart worth writing about; the writing begins only when they do.

**Third, compose from the silos.** Each placement points at one or more numbered studies. The silo carries the depth; the reading carries the person. Weave, rather than paste — the studies are understanding to draw on, never text to copy.

**Fourth, keep the name apart.** Working drafts carry a placeholder such as Alice. The true name enters only the final copy given to the person, and gratitude to teachers lives in its own honored space rather than inside the reading.

---

## The Skeleton

# [NAME]'s Sky — A Friendly Reading of Your Birth Chart

**For:** [NAME] — with love
**Born:** [DAY MONTH YEAR] · [TIME] · [PLACE] ([LAT], [LON], [TZ])
**System:** Classical hybrid — tropical zodiac signs · sidereal nakshatras (Lahiri) · whole-sign houses
**Lens:** [the devotional or guiding lens chosen for this reading]
**Stamped:** [YYYYMMDD.HHMMSS] UDT

### Your chart, exactly as the sky drew it

| Light | Tropical sign | Degree | Nakshatra | Pada | House |
|-------|---------------|--------|-----------|------|-------|
| Ascendant | [sign] | [d°mm'] | [star] | [1–4] | 1 |
| Sun | [sign] | [d°mm'] | [star] | [1–4] | [n] |
| Moon | [sign] | [d°mm'] | [star] | [1–4] | [n] |
| Mercury | [sign] | [d°mm'] | [star] | [1–4] | [n] |
| Venus | [sign] | [d°mm'] | [star] | [1–4] | [n] |
| Mars | [sign] | [d°mm'] | [star] | [1–4] | [n] |
| Jupiter | [sign] | [d°mm'] | [star] | [1–4] | [n] |
| Saturn | [sign] | [d°mm'] | [star] | [1–4] | [n] |
| Rahu | [sign] ℞ | [d°mm'] | [star] | [1–4] | [n] |
| Ketu | [sign] ℞ | [d°mm'] | [star] | [1–4] | [n] |

### Before we begin — a little map of the map
*One gentle paragraph naming the three lenses — sign, star, house — so the reader always knows which light is speaking.*

### The first lens — [rising sign], in the star [nakshatra][, with any 1st-house guest]
*Composed from the ascendant silos and the star's own study.*

### The second lens — your Moon, the steady heart
*Composed from the Moon-sign silo, the birth-star silo, and the lunar-day weave.*

### The third lens — four aims, four seasons, and where you stand
*Composed from [`studies/life-frame/four-asramas-and-goals-of-life.md`](../studies/life-frame/four-asramas-and-goals-of-life.md), mapped onto this chart's houses.*

### The rest of your sky — the other lights, one at a time
*One warm paragraph per remaining placement, each drawing its depth from the matching silo. Where a silo has yet to be written, name the placement plainly and add the study to the library before the final copy ships.*

### A few words, gently gathered
*The whole sky in one held breath — what the strongest placements agree on.*

### A blessing to carry
*Three clauses, affirmative, breath-paused, opening outward.*

---

## The Silo Map, Growing

| Placement pattern | Study silo |
|-------------------|-----------|
| Life-stage frame, four aims | `studies/life-frame/four-asramas-and-goals-of-life.md` |
| Nakshatra guardians (Ashvini, Bharani) | `studies/nakshatras/nakshatra-gods-asvins-and-yama.md` |
| Ashvini | `studies/nakshatras/asvini.md` |
| Bharani | `studies/nakshatras/bharani.md` |
| Lunar day and birth star together | `studies/lunar-craft/lunar-day-and-birth-star.md` |
| Moon exalted in Taurus | `studies/planets-in-signs/moon-in-taurus-exalted.md` |
| Venus in Gemini | `studies/planets-in-signs/venus-in-gemini.md` |
| Venus in the 8th | `studies/planet-in-house/venus-in-eighth-house.md` |
| Purva Phalguni | `studies/nakshatras/purva-phalguni.md` |
| Mercury in Virgo in the 11th | `studies/planet-in-house/mercury-in-virgo-in-the-11th.md` |
| Jupiter in Virgo in the 11th | `studies/planet-in-house/jupiter-in-virgo-in-the-11th.md` |
| Mercury with Jupiter | `studies/synthesis/mercury-and-jupiter-together.md` |
| Devotion, patience, partnership themes | `studies/reading-themes/devotion-patience-and-partnership.md` |
| Sun in Leo | `studies/planets-in-signs/sun-in-leo.md` |
| Ashlesha | `studies/nakshatras/ashlesha.md` |
| Sun in the 10th | `studies/planet-in-house/sun-in-the-10th-house.md` |
| Mars in Leo | `studies/planets-in-signs/mars-in-leo.md` |
| Saturn in Cancer | `studies/planets-in-signs/saturn-in-cancer.md` |
| Saturn in the 9th | `studies/planet-in-house/saturn-in-the-9th-house.md` |
| Government as planetary spectrum (teaching) | `studies/teaching/government-as-planetary-spectrum.md` |
| Liberal and conservative planets (teaching) | `studies/teaching/liberal-and-conservative-planets.md` |
| The divine mother as the chart's teacher | `studies/synthesis/20260705-045812_the-divine-mother-as-the-charts-teacher.md` |
| Chitra — the architect's star (transcript-revised) | `studies/nakshatras/20260705-160712_chitra-the-architects-star.md` |
| The maker's gathering | `studies/synthesis/20260705-160712_the-makers-gathering.md` |
| Dharma — the essence of a thing | `studies/life-frame/20260705-171012_dharma-the-essence-of-a-thing.md` |
| The navamsha — chart of the essential self (teaching) | `studies/teaching/20260705-171012_the-navamsha-chart-of-the-essential-self.md` |
| Reading the navamsha upon the birth chart (teaching) | `studies/teaching/20260705-171012_reading-the-navamsha-upon-the-birth-chart.md` |
| The subdivisions — a family of tools (teaching) | `studies/teaching/20260705-171012_the-subdivisions-a-family-of-tools.md` |
| The true sign — a chart's whole voice (teaching) | `studies/teaching/20260705-171012_the-true-sign-a-charts-whole-voice.md` |
| Venus in Aries | `studies/planets-in-signs/20260705-172312_venus-in-aries.md` |
| Venus in Virgo (debilitated) | `studies/planets-in-signs/20260705-172312_venus-in-virgo-debilitated.md` |
| A planet's passage — a transit as maturation | `studies/reading-themes/20260705-172312_a-planets-passage-as-maturation.md` |
| The three-pass opposition | `studies/reading-themes/20260705-172312_the-three-pass-opposition.md` |
| Moon in Capricorn | `studies/planets-in-signs/20260705-173112_moon-in-capricorn.md` |
| Moon in Leo | `studies/planets-in-signs/20260705-173112_moon-in-leo.md` |
| Moon in the 12th house | `studies/planet-in-house/20260705-173112_moon-in-the-12th-house.md` |
| Moon in the 6th house | `studies/planet-in-house/20260705-173112_moon-in-the-6th-house.md` |
| Ardra — the star of Rudra | `studies/nakshatras/20260705-180812_ardra-the-star-of-rudra.md` |
| Rudra and Shiva — one being, two names | `studies/nakshatras/20260705-180812_rudra-and-shiva-one-being-two-names.md` |
| The two ways of reading the Veda | `studies/teaching/20260705-180812_the-two-ways-of-reading-the-veda.md` |
| The four directions and the four aims | `studies/teaching/20260705-180812_the-four-directions-and-the-four-aims.md` |
| Anger and sadness — two responses | `studies/reading-themes/20260705-180812_anger-and-sadness-two-responses.md` |
| Reading a planet in a house | `studies/teaching/20260705-182612_reading-a-planet-in-a-house.md` |
| Sun in the 12th house | `studies/planet-in-house/20260705-182612_sun-in-the-12th-house.md` |
| Sun in the 7th house | `studies/planet-in-house/20260705-182612_sun-in-the-7th-house.md` |
| Rahu and Ketu in Taurus and Scorpio | `studies/planets-in-signs/20260705-182612_rahu-and-ketu-in-taurus-and-scorpio.md` |
| Rahu and Ketu in Cancer and Capricorn | `studies/planets-in-signs/20260705-182612_rahu-and-ketu-in-cancer-and-capricorn.md` |
| The two faces of a sign | `studies/teaching/20260705-182612_the-two-faces-of-a-sign.md` |
| Moon in Aquarius — the woven heart | `studies/planets-in-signs/20260705-190812_moon-in-aquarius.md` |
| Moon in Libra — the attuned heart | `studies/planets-in-signs/20260705-190812_moon-in-libra.md` |
| The four lunar neighbor yogas | `studies/lunar-craft/20260705-190812_the-four-lunar-neighbor-yogas.md` |
| Neighboring yogas of Sun and ascendant | `studies/teaching/20260705-190812_the-neighboring-yogas-of-sun-and-ascendant.md` |
| Occupation as lens on a star's essence | `studies/nakshatras/20260705-190812_occupation-as-a-lens-on-a-stars-essence.md` |
| Capricorn rising | `studies/rising-signs/20260705-190812_capricorn-rising.md` |
| Capricorn — tenacity and realism | `studies/rising-signs/20260705-190812_capricorn-the-sign-nature.md` |
| The hybrid lunar day | `studies/lunar-craft/20260705-195800_the-hybrid-lunar-day.md` |
| The hinge of the lights at birth | `studies/reading-themes/20260705-195800_the-hinge-of-the-lights-at-birth.md` |
| The three paths braid | `studies/reading-themes/20260705-195800_the-three-paths-braid.md` |

### Brooke reading — chapter silos (`readings/brooke/`)

| Chapter | Silo |
|---------|------|
| Shelf index | `readings/brooke/README.md` |
| Season and three paths | `readings/brooke/20260705-020812_the-season-and-the-three-paths.md` |
| Placements table | `readings/brooke/20260705-020812_the-placements-at-a-glance.md` |
| Foundation (dharma, D9) | `readings/brooke/20260705-020812_the-ninth-chart-and-the-shape-of-dharma.md` |
| Ascendant (Makara) | `readings/brooke/20260705-020812_the-makara-at-the-door-the-lion-within.md` |
| Sun | `readings/brooke/20260705-020812_the-priests-light-on-the-marriage-angle.md` |
| Moon | `readings/brooke/20260705-020812_the-spartan-heart-under-vishnus-star.md` |
| Venus | `readings/brooke/20260705-020812_love-as-dharma-twice.md` |
| Mercury | `readings/brooke/20260705-020812_the-articulate-heart.md` |
| Jupiter | `readings/brooke/20260705-020812_deep-faith-among-the-gathered.md` |
| Saturn (steward) | `readings/brooke/20260705-020812_the-makers-discipline.md` |
| Rahu and Ketu | `readings/brooke/20260705-020812_hunger-and-release.md` |
| Yogas | `readings/brooke/20260705-020812_companions-of-the-lights.md` |
| Stars | `readings/brooke/20260705-020812_a-temple-of-star-gods.md` |
| Almanac day | `readings/brooke/20260705-020812_the-day-she-was-born.md` |
| Three paths braid | `readings/brooke/20260705-020812_one-braid.md` |
| Full reading (composed) | `readings/brooke/20260705-020812_dharma-and-the-two-wheels.md` |
| Divine mother as teacher | `studies/synthesis/20260705-045812_the-divine-mother-as-the-charts-teacher.md` |
| Two-wheel HTML template | `templates/20260705-020812_reading-template.html` |
| Diurnal wheel method | `_method/rendering/SILO_DIURNAL_WHEEL.md` |

New placements earn the next number, a topic folder, a hyphenated filename, and a row here — see [`studies/README.md`](../studies/README.md).

---

*May every chart be cast twice and written once. May the silos deepen with each new sky. And may every reading leave its person feeling seen, blessed, and gently sent onward.*
