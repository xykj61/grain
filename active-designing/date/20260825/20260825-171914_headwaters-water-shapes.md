# Headwaters Water Shapes -- the fill-in forms for any basin, any mountain, any town at the top

**Stamp:** `20260825.171914` -- taken from the one clock at seating, never typed by counsel
**Language:** EN
**Style:** Gauge -- Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Mixed -- Design. The receipts shape and the retting row stand on witnessed ground (`linengrow/retting_timer.rye`, `tools/r/retting_timer_witness.rish`, the five primitives); the works laps and the money shape are design that names its own falsifiers; nothing here seats a program anywhere
**Kin:** [`the first user`](../foundations/20260825-171913_the-first-user.md) - [`the water and the work`](../foundations/20260825-171907_the-water-and-the-work.md) - [`fiber corridor shapes`](20260825-171908_fiber-corridor-shapes.md) - [`every climate has a fiber`](../foundations/20260824-003828_every-climate-has-a-fiber.md) - [`Civic Style`](../context/CIVIC_STYLE.md) - [`Dimeroll`](../dimeroll/README.md)
**Word:** *shape*, never *mold*, never *template* -- seated `20260804` on the maintainer's word
**Sibling set:** the fiber corridor shapes fill in a *valley's crop*; these six fill in a *basin's water*. The two sets share the receipts shape and the plain-English civic vocabulary (*polis*, *demos*, *oikos*), which lives in the fiber set and is cited here rather than restated

---

## What these six are for

A basin is a ladder, and the fiber corridor shapes stop at the field edge. These six carry the same discipline up the ladder: read the source, rank the loads, read the town, size the works, plan the second use, and read the money -- each as a form with named fields, named bounds, and a named falsifier, filled in by a person for their own place.

Fill the same six for a Rocky Mountain valley, an Andean altiplano, a Himalayan foothill, or a Scandinavian fell, and the *specification travels while the water stays local*. The elevation changes; the ladder does not.

## Shape 1 -- the source

The source is where the basin's water begins, and the fields ask what is there rather than what could be built there. **A source earns a gauge and a boundary.** Where the reading is long and public, the whole basin below gains a baseline it can argue from.

```kyri
format headwaters-source-v1
basin                  # the river system, by its plain name
source_name            # the spring, snowfield, lake, or glacier
source_elevation_m     # with the survey that fixed it
source_land_status     # refuge, wilderness, park, forest, private, tribal
river_km_to_naming     # distance from source to where the main river takes its name
protection_today       # what already keeps this ground quiet
gauge_today            # the monitoring station and its record length, or a named gap
first_settlement_km    # distance to the first place people live year-round
falsifier              # a reading that would show the source is already carrying a load
```

**Bound:** one source per block; a basin with a disputed source writes both and says who fixed each. **Falsifier, standing:** a nutrient, bacterial, or temperature reading above background at the source moves the source from *leave it be* to *find the load*, and the ladder starts one rung higher than anyone thought.

## Shape 2 -- the load ladder

The ladder is the ordered list of every place used water rejoins the stream, from the sky down. This shape is the heart of the set, because the ranking decides where the works belongs.

One row per load, top to bottom:

```kyri
format headwaters-load-v1
rung                   # 1 is highest; count down the basin
place                  # town, resort, camp, park development, works, feedlot, subdivision
fork                   # which tributary this rung sits on
flow_mgd_avg           # average daily volume of used water, with its date
flow_mgd_peak          # peak day, with its date -- seasonal towns swing hard
receiving_water        # the stream, or groundwater, or land application
share_of_summer_flow   # this load as a share of the receiving stream's low flow, with source
treatment_today        # the process in place, plainly named
nutrient_out_mg_l      # total nitrogen and total phosphorus at the outfall, dated
discharge_permit       # surface discharge, groundwater, or land application only
headroom               # design capacity minus current flow
falsifier              # the measurement that would move this rung up or down the ladder
```

**Bound:** sixteen rungs per basin block; a basin needing more is two basin blocks, split at a confluence. **The ranking rule:** rungs sort by *elevation first, share of low flow second, volume third* -- because a small load in a small cold stream outranks a large load in a large one. **Falsifier, standing:** a rung whose share of summer low flow is unknown is a rung whose position is a guess, and the gauge comes before the ranking.

## Shape 3 -- the town

Who governs the water, who permits the works, who buys, and what each of those rewards. The plain-English glosses of *polis* (the town that governs itself), *demos* (the neighbours who do and check the work), and *oikos* (the household, whose rules are its economy and whose account is its ecology) live in the [fiber corridor shapes](20260825-171908_fiber-corridor-shapes.md) and hold here unchanged.

```kyri
format headwaters-town-v1
polis                  # name each layer: nation, state, county, town, district, tribe
water_rights_office    # who issues an appropriation, and whether the basin is closed
basin_closed           # yes or no, with the statute and its year
exempt_well_count      # small wells outside routine permitting, with the source and date
claims_vs_flow         # historic claims as a multiple of annual flow, with the study
discharge_permit_body  # who writes the outfall permit and sets its limits
impairment_status      # what the river is listed for, under what law, with the date
tmdl_status            # the load study: underway, complete, or still to begin
reuse_rule             # what the law allows a town to do with treated water
public_money_door      # loans, grants, resort tax, bond, revolving fund -- each dated
public_money_rewards   # what each instrument actually rewards (name it plainly)
falsifier              # the rule change that would close a door or open one
```

**Bound:** every figure carries unit, date, and source, or it is written *unknown*. **Falsifier, standing:** a funding door whose reward, on reading, points at capacity built rather than water improved is a door to enter with the outcome written into the contract.

## Shape 4 -- the works, in three laps

Each lap is simple, lovable, and complete at its own scope, and grows from the lap before it. **The gauge is lap one, and it comes before any concrete.**

| Lap | What it is | What it proves | Horizon |
|---|---|---|---|
| **first -- the gauge** | a public monitoring record at the source, at each rung, and above and below each outfall; every reading signed, appended, foldable | the basin knows its own baseline, and every later claim has something to be checked against | one to three seasons |
| **second -- the works at the first load** | treatment sized to the diagnosis lap one produced, at the highest rung that carries a real load | the first user returns water at least as clean as it received, and proves it | three to seven years |
| **third -- the second use** | reuse: recharge basins, purple pipe to irrigation, process water, or a crop; the discharge becomes a supply | the basin gains water without a new appropriation | five to twelve years |

```kyri
format headwaters-works-v1
lap                    # gauge, works, reuse
rung_served            # from the load ladder
design_flow_mgd        # average and peak, stated separately
process                # named plainly: biological nutrient removal, membrane, lagoon, wetland
target_n_mg_l          # total nitrogen at the outfall
target_p_mg_l          # total phosphorus at the outfall
capex                  # all-in, with date and source
funding_mix            # each door named, with what it rewards
energy_kwh_per_mg      # measured after the first year; blank until then
biosolids_path         # what happens to the solids, named honestly
nutrient_recovery      # struvite, biochar, or none -- with the buyer named, or a named gap
verifier               # the independent laboratory, funded how
falsifier              # the reading that would say this works is aimed at the wrong thing
```

**Bound:** the diagnosis is written before the process is chosen. **Falsifier, standing:** three years of post-commissioning readings that hold steady on the impairment the works was built to fix say the diagnosis wants revisiting, and the honest response is to publish that plainly rather than to enlarge the works.

## Shape 5 -- the reuse

In a closed basin this shape carries the whole growth question, because water used twice is the only new water available.

```kyri
format headwaters-reuse-v1
second_use             # recharge, irrigation, process, snowmaking, crop, wetland
volume_mgd             # what the second use can absorb, by season
seasonal_storage       # where the water waits through the months the second use sleeps
storage_integrity      # how a pond or basin proves it holds what it says, and who checks
offset_credit          # whether the second use offsets a consumptive claim, and under what rule
land_needed_ha         # for irrigation or recharge
receiving_aquifer      # for recharge, with its connection to surface water named
quality_required       # what the second use needs at the pipe
public_reading         # where a neighbour reads the volumes and the quality, and how often
falsifier              # the measurement that would show the second use is leaking the first
```

**Bound:** seasonal storage is sized before the second use is promised, because a second use that sleeps in winter needs somewhere for the water to wait. **Falsifier, standing:** a holding pond whose measured seepage exceeds its permitted rate has quietly become a third discharge, and the integrity check is the thing that finds it.

## Shape 6 -- the money

The money shape from the fiber set holds here with one substitution: the tenant is a water business rather than a mill, and the public-receivable screen matters more because water revenue is very largely public revenue.

```kyri
format headwaters-money-v1
sleeve_public_pct      # a reading of an allocation, never a recommendation
sleeve_real_estate_pct
sleeve_venture_pct
sleeve_private_pct
touch_public           # listed firms by role: water engineering, nutrient recovery, remediation
touch_real_estate      # the property under a water-adjacent tenant, net-leased
touch_venture          # the instrument, the sensor, the ledger, the brand
touch_private          # the operating company, the district contract, the laboratory
tenant_public_share    # share of tenant revenue that is public spending, with durability note
durability_basis       # a statute, a permit, a specification, or a single-year line item
verifier               # appraisal, condition report, audited sponsor record, tenant books
gate                   # securities counsel, fee-only fiduciary, the fund's own policy statement
falsifier              # the reading that would send the deal back
```

**The five screens** for a public-receivable business carry over unchanged from the elder harvest: *share* of revenue that is public, *durability* of the spending, *wages over rents*, *circulation over extraction*, and *ahimsa*. A water business scores unusually well on the first two by construction, which is exactly why the last three deserve the closer read.

**Gate, standing:** anything touching money, custody, keys, or wire vocabulary is a stop-and-park; counsel proposes, the maintainer's word alone seats, and the securities attorney and the fiduciary sit ahead of both.

## The receipts, underneath everything

Every seam above ends in a fact somebody signs, and the receipts shape in the [fiber corridor shapes](20260825-171908_fiber-corridor-shapes.md) covers it whole. Two rows earn a headwaters note.

**The water log** takes four fields per event -- withdrawn, consumed, returned, and the laboratory reading of the return -- and folds to *what the basin is still owed*. Any reader with the log runs the fold.

**The verifier keys** matter more here than anywhere else in the tree, because the whole civic case rests on a reading taken by someone with no stake. An independent laboratory and an independent hydrologist each hold a keypair, sign their own results, and publish. The operator's own numbers stand beside theirs rather than in place of them.

## Where the fibre crop enters

One row ties this set to the other. **Field retting draws no water and holds no water right**, which in a closed basin makes it the strongest agricultural argument available. The retting shape in the fiber set governs; the headwaters note is that its `water_budget` field reads zero by construction, and that a mill's process water is small enough to close the loop on.

A basin at the top of a watershed can therefore grow a fibre corridor without asking its water office for a single new drop. That sentence is the reason the two shape sets belong in one bundle.

## How a region fills these in

Fill the source first, because it sets the baseline. Fill the load ladder next, because the ranking chooses the site. Fill the town to learn which doors exist and what each rewards. Fill the works at lap one only -- the gauge -- and let the diagnosis it produces size lap two. Fill the reuse before the works is designed, because reuse changes the process. Fill the money last, with the professionals in the room. Keep the receipts open throughout.

A filled-in set for a specific basin is an external-research study under its own name, with the place, the rivers, the agencies, and the companies named plainly, and household names kept in the maintainer's field.

## What this refuses

**It seats no program.** Shapes are forms; the town seats programs. **It sizes no plant.** An engineer sizes a plant from a diagnosis, and this set says how to get one. **It names no cause for any river's trouble.** The load ladder ranks where to look, and the gauge answers what is happening.

## Gratitude

The ladder reading owes its shape to the ordinary practice of watershed hydrology and to the people who keep long public monitoring records in cold places for decades with little fanfare. The plain-English civic vocabulary follows the ordinary dictionary senses of three Greek words, glossed in the sibling shape set.
