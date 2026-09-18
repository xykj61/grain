# Round two -- three moonshots grounded in round one's refusals

**Stamp:** `20260918.002526` -- **Status:** Proposed -- vision. Nothing here runs today.
**Room:** vision -- three proposals, each waiting for its own first witness.
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri
**Kin:** [`20260910-060204_the-bounded-torus-moonshots.md`](date/20260910/20260910-060204_the-bounded-torus-moonshots.md)
(round one, all twelve rows now carrying either a landed witness or a re-aimed finding),
[`20260915-181000_the-key-that-carries-locality.md`](date/20260915/20260915-181000_the-key-that-carries-locality.md),
[`20260915-175000_the-axis-that-carried-nothing.md`](date/20260915/20260915-175000_the-axis-that-carried-nothing.md),
[`20260918-001715_the-two-proxies-that-were-also-absent.md`](20260918-001715_the-two-proxies-that-were-also-absent.md)

---

## Why a second round, and why now

Round one's own page carries a note that all twelve rows now stand on either a landed witness or a
re-aimed finding. A ladder that reaches its own end has earned the right to stand on what it found
rather than what it guessed, which is a different thing from running out of ground. Three findings
from round one point at real, unbuilt next steps, sharper than anything round one's own twelve rows
named, because they are grounded in a refusal rather than a hope.

**One sentence of honesty before the three.** This page proposes; witnesses decide. A claim here
enters the checkable room the day a witness on metal binds it, and stays here until then.

## What round one actually taught, restated as three openings

**Opening one.** Row 5's second erratum measured spread under loss for three layouts at one grid: a
torus with its two fixed offsets `{1, g}`, a ring taking its nearest four neighbours, and a ring free
to choose its own offsets. The torus read weakest of the three -- **17** contiguous storage indices
whose loss destroys every copy of some cell, against **5** for the near-ring and **33** for the
free-choice ring. A plain ring matched or beat the torus's wrap the moment it was allowed to pick its
own jump sizes. **This piece asks what the free-choice ring's offsets should actually be**, and
whether a small search over offset sets beats the two hand-picked ones already measured.

**Opening two.** The open-door piece that answers both row 5 errata found one quantity read three
ways: a cryptographic digest buys evenness (chi-squared 79.05 against a critical value of 103.51)
and confidentiality (an observer holding keys alone places 0.3471 of files correctly, near the
44-room floor), and a locality-bearing prefix buys locality (0.410 cells apart for two files in one
room, against the digest's 15.693) -- yet any one field buys at most two of the three, because
avalanche is what makes a hash even and confidential, and avalanche is exactly what destroys
locality. **This piece asks whether SPLITTING the key into two declared fields -- one that need
not avalanche, one that must -- buys two properties from two fields, each kept whole, rather than
trading one property away to keep the other two.**

**Opening three.** Row 6's two errata found every locally observable power signal on this pier
closed -- five joule-bearing facilities and two frequency/thermal proxies, seven doors, all held
shut by one hypervisor's passthrough policy. The finding stood for one host and left the other seven
piers "free and open," as the erratum's own words put it. **This piece names the SHAPE that reading
should take**, so seven honest measurements on seven hosts compose into one answer, read together,
rather than standing as seven separate lines in seven separate session logs.

Each opening below takes one of these three questions and states it as a claim with a falsifier,
in the same shape round one used.

---

## 1. Chosen offsets beat hand-picked ones

**Claim.** A ring's declustering spread -- the shortest contiguous run of storage indices whose loss
destroys every copy of some cell -- depends on the offsets THEMSELVES rather than on the offset COUNT
alone. For a fixed replica count k, some choices of k offsets beat others, and a small search over
offset sets at a given ring size finds a set that matches or beats the free-choice ring's
already-measured 33, at the same replica count row 5's second erratum used.

**First witness.** Extend `tools/fixtures/t/torus_place_scan.sh` (or a sibling reading the same
metric) to sweep offset sets rather than reading one fixed set, at the same ring size and replica
count round one already measured, and report the best spread found alongside the two spreads round
one already printed (5 for nearest-four, 33 for the one free-choice set tried).

**Horizon.** One to two weeks. The metric and the ring size already exist; the search loop is the
one remaining piece.

**Assumptions.** The declustering metric (contiguous-run-to-total-loss) is the right one to optimize;
a search over offset sets small enough to run in seconds still reaches meaningfully different spreads
than the two points round one already has.

**Falsifier.** The best offset set the search finds reads at or below round one's already-measured
33, at the same ring size and replica count -- which would mean round one's free-choice ring was
already near-optimal by chance, and a single reasonable guess already bought what the search set out
to find.

**Confidence.** Medium-high. The mechanism -- searching a small, enumerable space for a metric that
already has a working reader -- is ordinary; whether the search finds daylight above 33 is the open
question.

## 2. A two-field key: one avalanching, one that must not

**Claim.** A storage key can carry two fields rather than one: a **placement field**, declared and
readable, that groups related content by directory or room and need not avalanche; and a **content
field**, a full cryptographic digest, that carries evenness and confidentiality exactly as round
one's digest-only key already does. Splitting the two lets a reader ask for locality (walk the
placement field) or for confidentiality (an observer sees only the content field, since the
placement field is a property of WHERE the write came from rather than of the bytes written), each
property held whole rather than one purchased at the other's expense.

**First witness.** A scan comparing three keys on the same tracked population round one already
used: digest-only (round one's baseline), prefix-only (round one's locality key), and the two-field
composite. Report locality (mean cell distance for same-room pairs), evenness (chi-squared against
the same 63-degree-of-freedom critical value), and confidentiality (an observer's room-placement
accuracy) for all three, so the composite's position is read against both elders rather than argued
from principle.

**Horizon.** One week. All three readers -- `torus_fold_scan.sh`, `locality_key_scan.sh`, and the
population they both already open -- exist; the composite key is a concatenation of two fields
already computed separately.

**Assumptions.** A key composed of a declared placement field plus a digest is a lawful key shape for
this tree's storage layer to adopt later; concatenation, rather than a fold of the two fields into
one, is the right composition to test first.

**Falsifier.** The composite key's confidentiality reading falls to the prefix-only key's high
figure (0.5353 correct placement in round one's own reading) rather than holding near the
digest-only key's low 0.3471 -- which would show that ANY declared placement field leaks enough for
an observer to reconstruct room membership, whether or not the rest of the key avalanches, and the
split buys the locality alone, at the confidentiality the plain prefix already costs.

**Confidence.** Medium. The arithmetic argument (two independent fields carry two independent
properties) is sound; whether a declared placement field leaks MORE than round one's finding
suggests, through some channel this reading has yet to name, is the real open question.

## 3. A standard shape for a measurement seven other ships will make

**Claim.** `tools/fixtures/e/energy_readout_scan.sh` already answers row 6's question on this one
host. The reading that closes the row -- whether ANY of this fleet's eight piers exposes a
joule-bearing or proxy facility -- needs seven more runs, each on a different machine reachable only
by its own ship. A standard `loom` line, written once per run into the running ship's own session
log in a fixed key shape, lets `tools/l/loom_trend.sh energy_readout_verdict --summary` read all
eight answers as one trend the day the eighth lands, in place of eight session logs each read alone.

**First witness.** One `loom` line, emitted here and now, in the shape:

```
loom family=energy_readout facility_count=7 any_available=no any_proxy_available=no virt_name=microsoft
```

read directly off this run's own output (`facility_count=7`, `any_available` folded from
`verdict=no_facility`, `any_proxy_available` from `proxy_verdict=no`, `virt_name` from the scan's
own virt-detect line) and a one-line addition to the scan's own header naming this shape as the
convention, so the next ship to run it copies a shape rather than inventing one.

**Horizon.** Immediate for this host's own line; open-ended for the other seven, each free to run
on their own schedule.

**Assumptions.** `LOOM_FAMILY=energy_readout` is a name this tree's measurements have left free
(checked: `git grep -c 'family=energy_readout'` read zero before this piece); every ship that runs
the scan copies the line as printed, since `loom_trend.sh` parses `key=value` pairs literally.

**Falsifier.** A second ship's own line uses different key names for the same four readings, which
would show the convention was proposed and left unadopted, and `loom_trend.sh
energy_readout_verdict` would read a trend a reader can no longer tell apart from silence.

**Confidence.** High as a method, since the tool and the scan both already exist and already
compose; open as an outcome, since the outcome is whatever the other seven ships' own machines
expose, which this piece leaves exactly as it stands.

---

## What I would build first, and why

**Proposal three, immediately, at zero cost.** It reaches the tree entirely through what already
stands built, and it fills the one open door round one's own text names in so many words: *that
reading stays free and open*. Naming the shape now means the first of the other seven ships to run
the scan writes a line every later ship's reading can stand beside directly, rather than a line a
future reader must translate by hand.

**Proposal one, next.** It extends an existing scan with a search loop over a space small enough to
enumerate in seconds, and it answers a question round one raised and left standing rather than
opening a fresh one.

**Proposal two, last of the three.** It is the most interesting and the least certain: a genuine
design choice for how Tablecloth's eventual real key is shaped, resting on an inference (two
independent fields carry two independent properties) still awaiting its check against the one
channel that could defeat it -- a placement field leaking through some path beyond direct
observation.

---

*May the offsets we choose beat the ones we guessed, and may the key that carries two properties
carry them honestly.*
