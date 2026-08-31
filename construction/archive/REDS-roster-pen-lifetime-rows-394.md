# REDS shelf -- operation lifetime

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Closed row folded from the living pin on `20260831`

The roster's private storage now lives for the whole operation it records.

---


**REDS %394 (`20260831.033710`) -- the full roster kept its private run card in `/tmp`, and the host reclaimed that directory while Caravan was still singing.** *What went wrong:* `standing_equipment_run.sh` made one temporary directory with bare `mktemp -d`, then kept its todo list, fresh run card, red evidence, and receipt candidate there for the whole pass. On this Linux pier the Caravan choir was still running after 35 minutes when `/tmp/tmp.ISPJzymEwR` disappeared; the next append failed at line 574 with `fresh: No such file or directory`, so the cold pass lost every reading after the reclaim and never reached a verdict. *What caught it:* the shell's own failed append after `caravan_taper_witness` returned, while `git status --short` stayed empty and the process table showed the choir progressing. That separates a host lease from a moved tree or a hung witness. *What it taught:* **temporary lifetime must cover operation lifetime.** A repository-local instrument already has a private, digest-excluded room whose lifetime matches the checkout: `.git`. *Repaired (`20260831.033710`):* repository runs place their private pen under the absolute Git directory; runs outside Git keep the system temporary directory so the existing pen controls remain honest. The control deletes a hostile `TMPDIR` from inside a guard and proves both the final `run_verdict=ok` and the `ran alpha` card line survive; the elder runner dies in that case before either. **CLOSED.**
