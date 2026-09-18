# Fiber Corridor Shapes -- the fill-in forms for any region, any climate, any town

**Stamp:** `20260825.171908` -- taken from the one clock at seating, never typed by counsel
**Language:** EN
**Style:** Gauge -- Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Mixed -- Design. The corridor stages, the retting discipline, and the receipts shape stand on witnessed ground (`linengrow/retting_timer.rye`, Dimeroll laps 1-4, the five primitives); the money shapes are design that names its own falsifiers; nothing here seats a program anywhere
**Kin:** [`every climate has a fiber`](../foundations/20260824-003828_every-climate-has-a-fiber.md) - [`the water and the work`](../foundations/20260825-171907_the-water-and-the-work.md) - [`Civic Style`](../context/CIVIC_STYLE.md) - [`Dimeroll`](../dimeroll/README.md) - [`Two Rooms`](../context/TWO_ROOMS.md)
**Word:** *shape*, never *mold*, never *template* -- seated `20260804` on the maintainer's word

---

## What a shape is, and why the corridor gets seven of them

A shape is a form with named fields, named bounds, and a named falsifier, that a person fills in for their own place. Fill the same seven shapes for a river valley in the Midwest, a maritime plain, or a monsoon delta, and the *specification travels while the crop stays local* -- the rule the foundations already keep.

The seven shapes are: the ground, the town, the people, the corridor, the retting, the mill, and the money. An eighth, the receipts, runs underneath all of them. Each shape below carries a short explanation, a fill-in block in Kyri notation (key-value, one field per line, `#` for comments), and the question that would show the filled-in shape to be wrong.

## Three old words, said plainly

The shapes lean on three words that classical Greek gave to political philosophy and that Plato's readers still trade in. Here they are in everyday English, because a farmer, a mill hand, and a council member all deserve to read this without a dictionary.

| The old word | What it means here | Why it earns a field |
|---|---|---|
| **polis** -- the town that governs itself | The people who share one budget, one set of rules, and one place, and decide together how to spend on it: a city council, a county, a state, a tribe, a nation. | A corridor lives or dies on procurement, zoning, water permits, and the rules of the road for a crop. The town writes those. |
| **demos** -- the people of the town | The neighbours who live there: the ones who grow, haul, mill, buy, verify, and vote. | Civic Style's verification is done by people with no stake in the result. The people are where the checking lives. |
| **oikos** -- the household | The home and its housekeeping. *Economy* is this word plus *law*: the household's rules for spending. *Ecology* is this word plus *study*: the household's account of itself. | A corridor is a household at the scale of a valley. Its economy and its ecology are one set of books read two ways. |

Every shape below names which of the three it is asking about, so the town's fields stay separate from the people's fields, and the household's books tie the two together.

## Shape 1 -- the ground

The ground is climate, water, and soil, read before any crop is named. The foundation's own table decides the crop from this reading: temperate continental grows hemp; temperate maritime grows flax; monsoon grows jute, kenaf, ramie; arid grows agave kin and stalk residue; tropical grows coir, abaca, bamboo; boreal grows timber and straw; and every climate already has residue lying in the field.

```kyri
format fiber-ground-v1
region                 # plain name of the place
climate_row            # one of: maritime, continental, monsoon, arid, tropical, boreal
rain_mm_year           # long-run normal, with the years the normal covers
season_days            # frost-free days, long-run normal
summer_high_c          # warmest month mean high
soil_note              # bottomland, loess, sand, clay -- one line
basin                  # the river or aquifer the fields sit on
water_stress           # low, moderate, high -- with the source of the reading
residue_already_here   # the food-crop residue the region burns or bales today
candidate_crop_1       # from the climate row
candidate_crop_2       # the companion trial, if any
falsifier              # the observation that would send this crop back to the table
```

**Bound:** one region per block. **Falsifier, standing:** a trial plot that fails the crop's fibre-quality floor two seasons running under the region's own weather moves the crop to a companion trial and promotes the residue row.

## Shape 2 -- the town

The town is the self-governing community and its instruments: who licences the crop, who buys on a specification, who writes the water permit, and who would fund a mill. Every instrument gets a *what it rewards* line, because Civic Style's first question is the whole of good design.

```kyri
format fiber-town-v1
polis                  # city, county, state, tribe, nation -- name each layer
crop_licence           # who issues it, what it costs, how long it takes
water_permit           # who issues it, what the outfall must read
procurement_door       # the public buyer that could specify this fibre by performance
procurement_rewards    # what that buyer's contract actually rewards (name it)
public_money_door      # grants, loans, insurance, preference -- each with a date
public_money_rewards   # what each instrument actually rewards (name it)
zoning_for_mill        # where a mill may stand, with rail and road named
industrial_rent        # asking rent per unit area, with quarter and source
falsifier              # the rule change that would close the door
```

**Bound:** every figure carries its unit, date, and source, or it is written as *unknown* -- a named gap is worth more than a confident adjective. **Falsifier, standing:** a procurement door whose reward, on reading, points at a certificate rather than a measured outcome is a door the corridor should treat as marketing until the specification is rewritten.

## Shape 3 -- the people

The people are the neighbours who do and check the work. The shape names the growers, the custom harvesters, the mill hands, the makers, and -- separately, on purpose -- the verifiers who hold no stake.

```kyri
format fiber-people-v1
growers                # how many, how far from the mill, what they grow today
custom_harvest         # who already cuts and bales bulky straw in the region
mill_hands             # the trades a first mill needs, and where they are trained
makers                 # the sewers, builders, and composite shops that would buy
teachers               # the extension office, the trade association, the university trial
verifiers              # the independent laboratory and soil scientist, funded how
wage_note              # the local wage a mill must clear to be kind
falsifier              # the sign that the people were not asked
```

**Bound:** the verifiers' funding is written as load-bearing or the shape is incomplete. **Falsifier, standing:** a corridor whose verifiers are paid by the mill has a verification budget that thins in a lean year, and the whole preference is worth exactly what that budget is worth.

## Shape 4 -- the corridor

The corridor is the path a stalk walks from the field to the wearer and back to the soil. Twelve stages, and a receipt lives at every seam.

| Stage | What happens | Water and energy spent | Receipt at the seam |
|---|---|---|---|
| ground | field read, crop chosen | none | the ground shape, signed |
| seed | certified fibre cultivar sown | field work | seed lot, cultivar, stamp |
| stand | plant-raised fertility; the crop shades out weeds | none drawn | fertility source, signed |
| cut | at early flowering for fibre | field work | cut date from the one clock |
| windrow | stalks laid in rows to ret on the field | none drawn | retting timer `start` |
| turn | rows turned once or twice for an even ret | field work | turn dates |
| bale | at a moisture floor, tarped field-side | field work | moisture reading, bale count |
| haul | to the mill by road, or rail where it stands | fuel | weight ticket |
| mill | open, decorticate, clean, grade | electricity | lot, streams, yields |
| streams | long bast, short bast, hurd, dust | -- | grade sheet per stream |
| make | building infill, nonwovens, composites, yarn by a partner, garments | partner's | maker's receipt with lot |
| return | the garment or panel composts or is reused | none | end-of-life note |

```kyri
format fiber-corridor-v1
field_to_mill_km       # the haul distance that sets the straw price
haul_mode              # road, rail, both
first_buyers           # the streams with a buyer today, by stream
partner_spinning       # who degums and spins bast to yarn, and where (named gap if none)
brand_home             # where the garment is cut and sewn
return_path            # compost, reuse, take-back
falsifier              # the stage whose receipt cannot be produced
```

**Bound:** a corridor with a named partner for every stage the region lacks is complete at its scope; a corridor with a gap writes *named gap* at that stage and stays honest. **Falsifier, standing:** a seam with no receipt is the seam where a claim becomes marketing.

## Shape 5 -- the retting

The retting shape is the water column applied to one process, and the foundation's three practices are its three rows. Field retting is the default; water retting owes a closed loop; and the timer already in the tree carries the log.

```kyri
format fiber-retting-v1
method                 # field, closed_loop, water_open (write the last only to refuse it)
days_expected          # from the region's own dew and rain, with the source
turn_count             # 1 or 2
moisture_floor_pct     # the reading below which a bale is safe to store
timer_home             # linengrow/retting_timer.rye, or the field's own copy of it
liquor_treatment       # for closed_loop: what treats the water, and what the outfall reads
outfall_bod_mg_l       # for closed_loop: measured, dated; blank for field retting
nutrient_return        # for field retting: yes, by construction
falsifier              # the reading that would move this row
```

**Reference readings, dated.** Untreated water-retting liquor has measured an average biological oxygen demand of roughly 1,460 mg/L with chemical oxygen demand ranging from about 130 to 6,700 mg/L (semi-industrial flax basins, published 2018), against untreated household sewage that commonly reads in the low hundreds; a treated closed loop in the same study brought the discharge down to single digits. Field retting draws no water and puts its breakdown products into the soil that grows next year's crop. The technique is old; the difference is total.

**Bound:** `days_expected` stays inside the timer's own bound of 365, and a batch named longer than a season is a refusal by construction. **Falsifier, standing:** two seasons of over-retting in a wet late summer, logged in the timer, moves the cut date earlier or the crop's harvest window into a drier month.

## Shape 6 -- the mill

The mill shape is three laps, each simple, lovable, and complete at its own scope, grown from the lap before it. A lap is complete in itself and owes the lap before it nothing.

| Lap | Line | Straw per year | Acres to feed it (at 2.9 short tons per acre) | Team | What it proves |
|---|---|---|---|---|---|
| **first** | one line at 1 short ton per hour, one shift | ~2,000 t | ~700 | 8-10 | the region can grow, ret, bale, haul, and sell three streams |
| **second** | 2-3 t/h, two shifts, cleaning and grading added | ~8,000-12,000 t | ~3,000-4,000 | 25-30 | the streams have repeat buyers and the books close |
| **third** | 10 t/h, the scale the largest domestic line runs at today | ~150,000 t | ~50,000 | 60-80 | a state's worth of acres -- a decade horizon anywhere |

```kyri
format fiber-mill-v1
lap                    # first, second, third
line_t_per_h           # nameplate
shifts                 # 1 or 2
straw_t_year           # bounded by line * hours * utilisation
acres_contracted       # the acres under contract before the line is ordered
straw_price_per_t      # delivered, with date and source
bast_share_pct         # planning: 25-30
hurd_share_pct         # planning: 55-65
loss_pct               # planning: 10-15
capex_all_in           # equipment landed and installed, with date and source
building               # lease or buy, area, rent per unit with quarter and source
water_budget_m3_year   # declared before the first bale, even if it reads zero
energy_kwh_t           # per ton of straw, measured after the first month
falsifier              # the acre count below which the line idles
```

**Bound:** the acres under contract are written before the line is ordered, because the earlier study of a decortication plant in another country found that the binding constraint was the straw supply rather than the capital (counsel's report, `20260725`). **Falsifier, standing:** a first lap that runs under 40% of nameplate hours in its second season has a straw problem, and the answer is contracts rather than a bigger line.

## Shape 7 -- the money

The money shape names four sleeves a family fund might hold, what each sleeve rewards, and how each one touches a fiber corridor. It is a shape for *reading* an allocation rather than a recommendation of one; the numbers are a fill-in, and the professionals come ahead of the prose.

| Sleeve | What it holds | What the sleeve's reward measures | How it touches the corridor |
|---|---|---|---|
| public | listed companies | price and dividend, marked daily | firms whose revenue is public spending in the corridor's sectors, screened |
| real estate | rentals and syndications as a limited partner | cash yield, preservation, and the sponsor's promote | the mill's land, building, and barns, leased to the operator on a net lease |
| venture | early companies | a few large exits over many years | the brand, from a lovable capsule up |
| private business | established private firms and funds | earnings and control | the mill operating company, or an existing regional processor |

A **syndication** is a group purchase: a sponsor (the general partner) finds and runs a property, and limited partners put in most of the money and take most of the return after a preferred return and a share to the sponsor. Read it the Civic way: the sponsor's promote rewards deal *volume* and paper *rate of return*; the limited partner's return rewards *cash yield* and *preservation*; the tenant's lease rewards whatever the rent formula rewards. The three point at one outcome only when the sponsor co-invests real money, the fees are named, the preferred return is real, and the tenant's rent is backed by receivables that are themselves backed by something durable.

**The public-receivable screen.** A tenant whose revenue is public spending is durable to the extent the spending is. An elder harvest in this tree's earlier home named five screens for such a business, and they carry over: *share* (how much of revenue is public), *durability* (a specification or a statute rather than a one-year line item), *wages over rents* (the money pays people who work), *circulation over extraction* (the money stays and turns in the region), and *ahimsa* (the work does no harm to any living thing). Read every candidate tenant against all five before the rent is underwritten.

```kyri
format fiber-money-v1
sleeve_public_pct      # fill-in; a reading, never a recommendation
sleeve_real_estate_pct
sleeve_venture_pct
sleeve_private_pct
corridor_touch_public  # the listed firms, by role rather than by name, screened
corridor_touch_re      # the property, the tenant, the lease shape
corridor_touch_venture # the brand, its first capsule, its first maker
corridor_touch_private # the operating company or the existing processor
sponsor_coinvest_pct   # the sponsor's own money in the deal
fee_load_bps           # acquisition, asset management, disposition -- named
preferred_return_pct   # to limited partners before the promote
tenant_public_share    # of tenant revenue, with the durability note
verifier               # appraisal, condition report, audited sponsor record, tenant books
gate                   # securities counsel, fee-only fiduciary, the fund's own policy statement
falsifier              # the reading that would send the deal back
```

**Bound:** every field is filled or written *unknown*. **Gate, standing:** anything touching money, custody, keys, or wire vocabulary is a stop-and-park; counsel proposes, the maintainer's word alone seats, and the securities attorney and the fiduciary sit ahead of both.

## Shape 8 -- the receipts, underneath everything

Every seam above produces a fact somebody signs. The tree already carries the machinery: a keypair, a signed event, an append-only log, a pure fold, a capability. Two homes hold the facts.

**The books of record** -- Dimeroll -- keep one set of books per entity, never braided: the fund's books, the operating company's books, the property's books, each with its own chart, journal, and folds, and a value crossing between them only as an explicit signed inter-entity fact recorded on both sides. Dimeroll records and reports; it holds and moves no money.

**The field and mill receipts** -- the retting timer's log, the moisture at baling, the weight ticket, the grade sheet, the laboratory's outfall reading, the soil reading at the field edge -- live in the same append-only shape and fold to the same kind of state: what this lot is, where it came from, what the water read.

```kyri
format fiber-receipts-v1
entities               # one line per set of books, never braided
inter_entity_facts     # transfers recorded on both sides, signed
field_log              # retting timer home, moisture, soil readings
mill_log               # lots, streams, grade sheets, energy per ton
water_log              # withdrawn, consumed, returned, outfall reading
verifier_keys          # the independent laboratory and soil scientist, by public key
fold_anyone_can_run    # the command that recomputes state from the log
falsifier              # a fact in a report with no signed event behind it
```

## How a region fills these in

Fill the ground first, because it chooses the crop. Fill the town and the people next, because they decide whether a mill can stand and whether anyone would check it. Fill the corridor to find the named gaps. Fill the retting to put water first. Fill the mill at its first lap only, with the acres under contract written before the line. Fill the money last, with the professionals in the room. Keep the receipts shape open the whole time, because every earlier shape ends in a fact somebody signs.

A filled-in set for a specific river valley is an external-research study under its own name -- the place with its real names attached, the shapes as its spine -- and it ships in the public seed with the place names intact and the household names withheld.

## What this refuses

**It seats no program.** Shapes are forms; the town seats programs. **It recommends no allocation.** The money shape reads a portfolio; a fiduciary designs one. **It names no fibre for all climates.** The ground decides, and the boreal row's honest answer is timber and straw.

## Gratitude

The four-sleeve reading of a family portfolio -- public markets, real estate, venture, and private business in roughly equal quarters, weighted toward the first two -- is siloed here from a private investing community and its founder, thanked by name in the maintainer's gratitude room rather than in this design; the reading enters in this tree's own words and stands or falls on its own merit. The plain-English glosses of *polis*, *demos*, and *oikos* follow their ordinary dictionary senses.
