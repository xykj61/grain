# Headwater Works Shapes -- four forms for a basin whose river begins at a plant

**Stamp:** `20260825.171920` -- taken from the one clock at seating, never typed by counsel
**Language:** EN
**Style:** Gauge -- Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Mixed -- Design. The receipts shape underneath stands on witnessed ground (the five primitives, Dimeroll laps 1-4); the four water shapes are design that names its own falsifiers; nothing here seats a program anywhere
**Grows beside:** [`fiber corridor shapes`](20260825-171908_fiber-corridor-shapes.md) -- the seven stay as written; these four accrete beside them and share its receipts shape
**Kin:** [`where the water enters`](../foundations/20260825-171919_where-the-water-enters.md) - [`the water and the work`](../foundations/20260825-171907_the-water-and-the-work.md) - [`Civic Style`](../context/CIVIC_STYLE.md) - [`Two Rooms`](../context/TWO_ROOMS.md)
**Word:** *shape*, never *mold*, never *template* -- seated `20260804` on the maintainer's word

---

## Why four more shapes

The seven corridor shapes read a river valley for a fibre crop: the ground, the town, the people, the corridor, the retting, the mill, and the money, with the receipts underneath. They assume the river is there. On a high plain the river is a draw that runs a few days a year, the real headwater is an aquifer, and the first perennial flow is a city's return -- so a study of such a place needs four forms the seven leave out: **the basin** (where each load enters), **the aquifer** (the well that is the true headwater), **the works** (the plant that treats water at the top), and **the residual** (the ash the works leaves behind). Fill these four before the corridor shapes, because on this ground they choose the water the crop will drink.

Each shape carries a short explanation, a fill-in block in Kyri notation (key-value, one field per line, `#` for comments), and the question that would show the filled-in shape to be wrong.

## Five plain words

The corridor shapes gave three old Greek words their everyday English -- *polis* the town that governs itself, *demos* the neighbours who do and check the work, *oikos* the household whose economy and ecology are one set of books. The water shapes lean on five working words, said plainly here so a farmer, a plant operator, and a council member all read them the same way.

| Word | What it means here |
|---|---|
| **reach** | one stretch of river between two points where somebody measures it |
| **door** | the place where a load enters the basin: a spring, a plume front, an outfall, a barn |
| **works** | any plant that treats water: a reclamation plant, a desalting plant, a well field with a filter |
| **residual** | what the works takes out and must put somewhere: brine, sludge, spent filter media |
| **recharge** | water put back into an aquifer on purpose, by a well or a basin, with a receipt |

## Shape 9 -- the basin

The basin is a ledger of entrances. Fill one row per door, because Civic Style's first question -- what does this reward -- has a different answer at each one.

```kyri
format water-basin-v1
river                  # the river and the fork, as the survey names it
mapped_source          # where the map says the river begins, with the county
perennial_source       # where the first year-round flow actually begins (often an outfall)
reaches                # the reaches somebody measures, named in order
door_1                 # a door: kind (salt, chemical, nutrient, sediment), place, load with unit and date
door_2
door_3
largest_load           # the door carrying the most of the basin's worst load, with the share
cheapest_door          # the door where a small works removes the largest share
downstream_cost        # what the load costs at the intake or the mouth, dated, with source
falsifier              # the reading that would move the largest-load door
```

**Bound:** at most 16 doors per basin block; a basin needing more is two basins. **Falsifier, standing:** a door named as largest on memory rather than on a survey's load reading is a claim wearing a fact's clothes, and the shape stays open until the survey is cited.

## Shape 10 -- the aquifer

The aquifer is the plain's real headwater, and it keeps its own books: how much is there, how fast it refills, how far it has fallen, and what every foot of fall costs in lift.

```kyri
format water-aquifer-v1
aquifer                # name as the survey names it
saturated_thickness_m  # at the site, dated, with source
decline_m_per_year     # long-run, dated, with the district that measures it
recharge_mm_per_year   # natural, with source; write the honest small number
lift_m                 # depth to water at the site, dated
lift_kwh_per_m3        # energy to raise one cubic metre from that depth, measured or estimated (say which)
recharge_projects      # any managed recharge, with acre-feet per year and its receipt
brackish_below         # a deeper saline aquifer, if one exists, with its salinity and depth
district_rule          # the pumping rule the local district enforces, dated
falsifier              # the decline reading that would send the crop back to the residue row
```

**Bound:** every figure carries unit, date, and source, or is written *unknown*. **Falsifier, standing:** a crop plan that draws on the aquifer where the district's own reading shows withdrawal above recharge is a plan the water column has already refused; the crop moves to reclaimed water or to the residue row.

## Shape 11 -- the works

The works is the plant at the top. The shape names its feeds, its products, its doors, its residual, what its funding rewards, and who verifies its reading -- and it holds the pumped loop's clause: the residual is named before the plant.

```kyri
format water-works-v1
works                  # plain name
site                   # where it stands, and which door it stands at
owner_operator         # public authority, city, private utility, contractor -- name each layer
feed_1                 # a feed: kind (surface, reclaimed, brackish, plume, dairy), volume with unit and date
feed_2
feed_3
product_1              # a product: kind (potable, reuse-grade, recharge, mineral, salt, biogas), volume, buyer
product_2
product_3
residual               # what leaves as ash: kind, volume, home (deep well, salt yard, reinjection, landfill)
residual_named_before  # yes or open -- the pumped-loop clause
outfall_reading        # what the outfall must read, by parameter, with the permit that sets it
energy_kwh_per_m3      # measured after the first year; blank until then
capex_all_in           # dated, with source; write the federal and local shares
funding_rewards        # what each funding door rewards (miles laid, gallons treated, readings at the door)
verifier               # the independent laboratory and its funding, written as load-bearing
receipt_home           # where the daily outfall reading is signed and appended
falsifier              # the residual home that would move the whole plant
```

**Bound:** three feeds and three products per block; a campus with more is several works sharing one site, each with its own block. **Falsifier, standing:** a works whose residual home reads *open* after the pipelines are funded has been built from the wrong end, and the shape says so in its own field.

## Shape 12 -- the residual

The residual earns its own shape because it is where a works most often moves a harm rather than ending it. Brine, sludge ash, spent media, and captured chemistry each need a named home, a named volume, and a named receipt.

```kyri
format water-residual-v1
kind                   # brine, sludge, ash, spent media, captured chemistry
volume                 # per year, with unit and date
concentration          # the salinity or the mass of the load it carries
home                   # deep well, salt yard, reinjection, landfill, destruction -- one line each if several
home_basin             # which basin or formation receives it -- the custody-first question
product_recovered      # any salt, mineral, or nutrient sold from it, with buyer and price if known
energy_kwh_per_m3      # the cost of the home, measured or estimated (say which)
permit                 # the permit and the agency, dated
verifier               # who checks the home holds, funded how
falsifier              # the reading that would close this home
```

**Bound:** one residual per block. **Falsifier, standing:** a residual whose `home_basin` is the next basin down, or a formation shared with a drinking aquifer, fails the custody-first reading regardless of the permit, and the works goes back to shape 11 to name a different home.

## How the four sit with the seven

Fill the basin first, because it names the doors. Fill the aquifer second, because it decides whether any crop may drink from it. Fill the works third, with the residual shape open beside it, because on this ground the works chooses the crop's water. Then fill the seven corridor shapes as before -- the ground now reading *reclaimed* or *residue* in its water field, the retting reading *dry decortication* where dew is scarce, and the mill's first lap reading *contract acres for a line that already runs* where one runs within a day's haul. The receipts shape underneath stays exactly as the corridor shapes wrote it, with two rows added:

```kyri
format fiber-receipts-v1
door_log               # each door's reading, signed at the door, appended daily
residual_log           # each residual's volume and home, signed at the works
```

A filled-in set for a specific basin is an external-research study under its own name, with its real places attached and the household names withheld, and it ships in the public seed on those terms.

## What this refuses

**It seats no program.** Shapes are forms; the town seats programs. **It picks no technology.** Membranes, wells, and wetlands earn their place on the basin's own readings. **It names no crop for the plain.** The aquifer shape decides, and its honest answer on a declining aquifer is reclaimed water or the residue row.

## Gratitude

The five plain words follow their ordinary engineering senses. The at-source salt interception that shape 9 leans on was taught by a river authority's own salinity-control project, thanked by role here and by name in the study that carries its numbers. The pumped-loop clause grows from the custody-first principle already seated in this tree's foundations.
