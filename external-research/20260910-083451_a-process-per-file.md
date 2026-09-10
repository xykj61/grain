# A process per file -- the falsifier, run

**Stamp:** `20260910.083451`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Living -- **mixed room**: the two measurements and the agreement are checkable, bound by
[`../tools/a/ascii_resident_agree_witness.rish`](../tools/a/ascii_resident_agree_witness.rish); the
fleet-scale projection at the end is vision and says so.
**Kin:** [`20260910-072912_the-seconds-this-pier-actually-spends.md`](20260910-072912_the-seconds-this-pier-actually-spends.md)
(the paper this one falsifies) -- [`20260905-232224_the-bound-that-names-a-joule.md`](20260905-232224_the-bound-that-names-a-joule.md)
**Instruments:** [`../tools/fixtures/a/ascii_document_resident_probe.sh`](../tools/fixtures/a/ascii_document_resident_probe.sh) -
[`../tools/fixtures/a/ascii_resident_agree_control.sh`](../tools/fixtures/a/ascii_resident_agree_control.sh)

Yesterday's reading of this pier ended in a projection and named the measurement that would kill
it: *implement one representative guard as a single long-lived process and measure its CPU seconds
against the shell form on the same tree; a saving under a factor of two says the bill is not the
shape claimed here.* This paper is that measurement. The claim survives, at **17 times** rather
than two -- and the reason given for it wants correcting, which is the more useful half.

---

## What was measured, and on what

**The guard.** `tools/fixtures/a/ascii_document_scan.sh`, which counts non-ASCII characters in
living documents. It was chosen for one reason: of the three scans sampled on
`20260910.065600` it was by far the most expensive, at **26.1 CPU seconds** against 1.12 and 1.84.
Whether any guard on the roster costs more stands unmeasured, and the falsifier below is what would
settle it. Its shape is the family's
shape -- a shell loop over a tracked listing that spawns a process per item.

**The population**, read `20260910.083451` on this tree: **6,221** tracked `.md` and `.mdc` paths,
of which **447** are counted (161 walled, 286 ratcheted) and the rest are read past as testimony,
closed stacks, vendored sources, or planted fixtures.

**The bench.** The Dallas pier, 8 vCPU, GNU Awk 5.4.1, and `grep` provided by **ugrep 7.8.4**
rather than GNU grep -- a detail that matters, since startup cost is the subject and two greps do
not start alike. The machine was **busy throughout**, sharing the pier with seven other ships and
with this lap's own roster pass, so both figures below are inflated by an unknown amount. They are
inflated **together**, so the ratio is the reading here and the absolute seconds travel less well.

**The probe.** `tools/fixtures/a/ascii_document_resident_probe.sh` is the same scan with every
per-file process removed: one `awk` reads the tracked listing, builds both rosters, opens each
counted file with `getline`, and prints the same census. The population rule, the skip rules, the
two rosters, the octal high-byte class, and the named-form table are transcribed without change.
A probe earns its comparison by answering the same question, so the agreement is proven before
the seconds are quoted.

---

## Observation one -- the two readers answer alike

On this tree, at `20260910.082000`, both print the same fifteen lines character for character,
`ratchet_files=286 chars=763` among them.

That agreement is held by
[`../tools/fixtures/a/ascii_resident_agree_control.sh`](../tools/fixtures/a/ascii_resident_agree_control.sh),
which builds real git repositories in a throwaway pen and compares both readers' standard output
**and exit status** over ten planted cases: a clean tree, a dirty ratchet page, a ratchet over its
ceiling, a walled page carrying a character, two walled pages ordered worst first, a page walled by
the law's own citation, dated testimony and a closed shelf read past, a tracked path holding a
space, a path in the index and absent from the working tree, and one **mutation** -- a probe with
the middle-dot row struck out, which must part from the scan or the other nine legs compare nothing.
**Ten legs pass, the mutation parts.**

**The pen earned its keep on the first run.** The two agreed to the character on the living tree and
**parted the moment a planted page broke the wall**: the probe answered `enforce=broken` where the
scan answers `enforce=failed`, printed none of the `detail=` lines a repairing reader needs, and
exited 0 where the scan exits 1. A refusal is proven where a refusal is planted, and
nowhere else. The refusal path is transcribed now, ordering included.

---

## Observation two -- the seconds

Three runs of each, CPU time taken by `times` in a subshell, `20260910.082000`.

| Reader | User CPU s | System CPU s | Total CPU s |
|---|---|---|---|
| Shell scan | 12.94 | 13.06 | **25.99** |
| Resident probe | 1.47 | 0.03 | **1.49** |

**The whole bill falls by a factor of 17.4.** The kernel half falls by a factor of **466**, from
13.06 seconds to 0.03. The user half falls by a factor of **8.8**.

## Observation three -- the mechanism, counted rather than inferred

`strace -f -c -e trace=execve,clone`, same tree, same stamp:

| Reader | `execve` | `clone` |
|---|---|---|
| Shell scan | **7,741** | 7,744 |
| Resident probe | **6** | 6 |

Divide the shell form's 25.99 CPU seconds by its 7,741 processes and each one costs **3.36
milliseconds** -- consistent with the 2.72 ms a `fork` plus `exec` of `/run/current-system/sw/bin/true`
measured on this bench yesterday under the same load, and higher for the honest reason that a
`grep` or an `awk` is heavier to start than `true`.

The 7,741 divide plainly: roughly **6,200** are a `grep -qxF` membership question asked once per
tracked path, and **447** are the `awk` that counts one file. The counting processes are 6 percent
of the process bill and carry all of the work.

---

## The inference, kept separate from the readings

**The projection survives its own falsifier by a wide margin, and its stated reason wants correcting.**
Yesterday's claim was that a resident reader *"would remove the kernel half of this bill rather
than the whole bill, since the user half is real reading."* The kernel half did go, as predicted.
The user half went too, nearly nine tenths of it, because most of what looked like reading was
interpreter startup rather than bytes moving. **The real reading is about 1.5 CPU seconds of the
26**, under 6 percent.

**So the truer sentence is *the process is overhead, kernel side and user side both*.** An `awk`
that starts once and reads 447 files pays its startup once; an `awk` that starts 447 times pays it
447 times, in both columns.

---

## The bounds of this result, said plainly

**One guard is not a roster.** Two other scans measured the same way on the same bench,
`20260910.083000`:

| Scan | `execve` | Total CPU s |
|---|---|---|
| `prose_register_scan.sh` | 217 | 1.16 |
| `exec_bit_scan.sh` | 267 | 1.83 |

Roughly a thirtieth as many processes as the document scan, and correspondingly small bills.
**The roster wears this shape unevenly**, so the pier-scale saving wants its own measurement. What
the family shares is the *pattern* -- a shell loop that spawns a process per item -- and what
varies is how many items each loop reaches.

**The ratio is what travels; the absolute seconds belong to this bench.** The pier was busy, and a
quiet machine reads lower for both.

**The guard on the roster stands as it is.** The probe reports, gates nothing, and exists to be
measured against rather than adopted. Adoption would trade a shell program many hands read easily
for a 200-line `awk` program fewer do, and pricing that trade belongs to whoever proposes it.

---

## The projection, with its terms

**Horizon:** the coming season, while the fleet holds at eight ships and the roster keeps growing.

**Assumptions:** guards stay shell-shaped; the population each guard walks keeps growing with the
tree; the pier keeps 8 vCPU.

**The claim:** the pier's assurance bill is concentrated in the few guards whose loops reach the
whole tracked listing, and those few can be made an order of magnitude cheaper while
answering identically.

**Falsifier:** rank the roster by measured seconds and count the processes of the top ten. A bill spread evenly across two hundred cheap guards, rather than concentrated in a handful of
expensive ones, leaves a resident reader saving a few percent of the pass, and this direction can
rest there.

**Confidence: high** for the one guard, which is measured from both ends and proven to answer the
same question. **Low** for the pier-scale saving, which rests on one guard of roughly two hundred
and thirty and is exactly what the falsifier above would settle.

---

## What this hands the modules

**Caravan** supervises processes, and this is the first reading in the tree that prices one. A
supervisor that knows a dependent costs about 3.4 milliseconds of CPU to start on this class of
machine can budget a fan-out rather than guess at it.

**Tally** bounds allocation, and the probe is a small argument for the resident shape it already
prefers: open the collection once, hold the bound, answer many questions.

**Mantra** stores documents by content. A reader that opens 6,221 paths to answer a question about
447 of them is asking the filesystem what a content-addressed store could answer from an index.

---

## A small lesson the writing itself taught

An apostrophe inside a single-quoted `awk` program closes the quote. A comment added to the probe
for clarity -- three words with a possessive in them -- ended the program early and handed the
shell a syntax error at the next line. That is the same class as the fault the scan's own header
records, where an `awk` comment in the wrong place made the whole program refuse and every file
read a clean zero. **A comment is code until the parser says otherwise**, and running the thing is what caught both.
