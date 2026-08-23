# The Seed That Ships Every Fifth Round

*A public projection earns trust by shipping often. This seats a cadence:
the seed is force-pushed every fifth round, so the face the world sees is never more than five laps
behind the tree that made it.*

**Stamp:** `20260823.111029`
**Language:** EN - **Status:** Living - **Style:** Gauge, Field setting
**Kin:** [`../context/SILO_TECHNIQUE.md`](../context/SILO_TECHNIQUE.md) - [`../context/CIVIC_STYLE.md`](../context/CIVIC_STYLE.md) - [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md) - [`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md)
**Machinery:** `publish-seed.sh` - `tools/fixtures/sow_project.sh` - `tools/s/sow_witness.rish` - `tools/s/seed_link_witness.rish`

---

## The reading that seats this

The public seed is an **allowlist projection**: `template-manifest.bron` names, path by path, what
crosses from the maintainer's field into `grain-os/grain`. Everything else stays home by construction, which is a
stronger promise than care.

The design is sound; the cadence wanted seating. Measured on `20260823`, the seed carried **867 links
in living shipped documents naming rooms it leaves behind** -- 19 of them in the front door
itself -- and all of it read fine from inside the field, because the field holds every room. A projection
published rarely drifts from the thing it projects, and that drift stays hidden in the one place
anyone looks.

Two fixes landed the same day. `tools/s/seed_link_witness.rish` now reads the manifest and gates the
front door at zero, so a link that would land nowhere in the seed reds in the field. This page seats the
other half: **cadence**.

## The cadence

**Every fifth round, the seed is projected and force-pushed.**

A round here is a bounded unit of session with an opening and a close, the sense already seated in
[the words a round uses](20260821-175723_the-words-a-round-uses.md). Five is chosen to match the
council rota, which reads one row of a five-by-five-by-three grid per lap and returns to its start
every fifth. The seed ships on the lap the rota closes its cycle, so one count serves both and
neither needs remembering separately.

**What ships is whatever is green.** The push projects the tree as it stands, rather than staging an
occasion. A seed that waits for a worthy moment keeps waiting.

## The four gates the cadence keeps

The cadence adds frequency and keeps every safeguard already standing.

1. **`IDENT_CLEAN` or nothing.** `publish-seed.sh` runs the leak scan over the staged projection
   and pushes only once it reads clean. That gate holds at every cadence.
2. **The commit stays anonymous and unsigned.** Signing with the maintainer's key would bind the
   depersonalised seed back to the maintainer, which is the one thing the projection exists to
   keep apart. This is the single place in the tree where `commit.gpgsign` is false, and it is a
   safeguard rather than a lapse.
3. **The commit-message wall arms itself on every publish.** `publish-seed.sh` deletes and
   re-creates `seed/.git` each time, so the hooks path is set by the script itself, surviving
   a fresh init.
4. **The front door reads whole in both repositories.** `seed_link` gates the named front-door set
   at zero, so a document naming a withheld room names it in prose, with nothing to click.

## Why five, and what would show five is wrong

Five is a judgement, so it carries its falsifier.

**The case for it:** a projection five laps stale is close enough that a reader arriving at the
public repository sees roughly the tree that exists, and rare enough that the push stays a deliberate act carrying its four
gates.

**What would show it wrong.** A seed reader finding a front-door claim that the field
corrected more than five rounds earlier would show the cadence too slow, and it would want
shortening. A push landing with nothing changed since the last would show it too fast, and the
count would want to follow rounds that touched shipped paths rather than rounds in general.

Either observation is worth more than this paragraph, and either should move the number.

## What the cadence does not license

Reds come first, always: a red books the allocation and a cadence is constructive work, so the
line stays stopped until the red closes. A gate wanting a hand -- a key, a signature, a payment, a
provisioning step -- stays exactly where it is. And `sow_witness` proves `IDENT_CLEAN` and
`NO_PERSONAL` before anything crosses, every time.

The cadence is a floor on frequency rather than a ceiling on care.
