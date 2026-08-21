# Expanding Prompt — Four Rishi Harvest Laps

**Language:** EN  
**Stamp:** `20260725.040520`  
**Voice:** Quin  
**Status:** Seated plan — each lap retires shell bodies it makes unnecessary  
**Audience:** an Acme Corporation employee reading this as a runnable plan  
**Counsel:** [`../counsel/20260725-040247_what-the-shell-remembers.md`](../counsel/20260725-040247_what-the-shell-remembers.md)  
**Law:** [`../active-designing/20260629-203012_posix-a-seam-not-a-model.md`](../active-designing/yonder/20260629-203012_posix-a-seam-not-a-model.md)

---

## Intent

Grow Rishi demand-driven toward the verbs the shell bodies already asked for. Harvest rather than sweep: each lap lands a word, retires the shell bodies that needed it, and lowers `living_docs_lint` duty 8.

## The four laps

### 1. Accumulate

**Missing verb:** fold over a list — count · sum · join-with.  
**Evidence:** count idiom leaves through `sh -c` arithmetic (`tools/rish_count_selftest.rish`).  
**Done when:** a Rishi fold retires that idiom; duty 8 drops for bodies that only counted.

### 2. Read bounded

**Missing verb:** a line reader that names its bound and refuses past it.  
**Evidence:** map-transform / list ceiling discovered at 257, raised to 512.  
**Done when:** `lines` (or a named reader) refuses past a declared bound with a clear error; scan bodies stop inventing ceilings.

### 3. Filter chained

**Missing verb:** nested `where`, or a compose form.  
**Evidence:** nested-`where` wall; sequential `let passN = where …` workaround.  
**Done when:** one expression filters in chain; sequential-pass workaround retires from new scans.

### 4. Quote safe

**Missing verb:** a `run` form where a dollar sign is a dollar sign.  
**Evidence:** `$` interpolation inside `run` strings forced in-memory compares.  
**Done when:** a witness can pass a literal `$` through `run` without shell expansion; dollar workarounds retire.

## Exemptions (stay `.sh`)

- Cold-start bootstrap (`rye/bootstrap.sh`)
- External interpreters (`cursor-jail.sh`, `fetch_gratitude_web.sh`, astrology host)
- Interactive stdin scripts (`slc1_accept.sh`, `slc1_version_step2.sh`)

## Discipline

Each shell body under a `.rish` wrapper carries a one-line **Missing Rishi verb** note. Duty 8 counts bodies past 40 lines; the number is visible and only ever falls.

## Granularity (open)

Session-log grain — per send vs per sitting — awaits Keaton's word. The fold law works either way.

---

*May every workaround leave a note, and every note become a word.*
