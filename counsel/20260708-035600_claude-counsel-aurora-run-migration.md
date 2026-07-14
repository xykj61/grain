# Claude Counsel — Aurora Run Migration; the Structural POSIX Seam Closes

**Stamp:** `20260708.035600 UDT`
**Voice:** Rio 3
**Parent:** spawn lap 2 arc (`60fe5c5` → `e8a24ad`)
**Register:** verification before closure — `aurora/run.sh` is the last structural seam

*Written by Kaeden and Claude; landed by Rio 3.*

---

## What Was Verified

The eleven comlink wire-lab migrations use `spawn` / `wait-for` honestly — bounded at **8** live handles, `WaitForUnknownHandle` on bad ids, slot released after `wait-for`. Witnesses GREEN on metal.

`aurora/run.sh` is a different shape: **one process, built then woken** — blocking `run` suffices; no background guest, no spawn surface needed.

## Aurora Interface — Live, Not Speculative

`aurora/README.md` documents **six stages** (`seed`, `relay`, `named`, `sealed`, `wire`, `posted`). Two need `RYE_SMP=2`. This is a developer utility with optional `[stage]` argument — not a parity witness (no fixed stdout across stages). It was never in `parity.rish`; it should not be forced into that shape.

## Migration Design

| Concern | Rishi idiom |
|---------|-------------|
| Optional stage arg | `args` pre-bound at script entry; `join args ""` → default `"seed"` when empty (verified empty and populated) |
| `RYE_SMP` | `env "RYE_SMP"` with `if`/`then` default `"1"` |
| `RYE_ZIG` | honor host env; else `vendor/zig-toolchain/zig` |
| Missing stage | `test -f`; `say` path (assert `else` does **not** interpolate `${}`); `exit 2` |
| QEMU exit code | `let wake = run [...]`; `exit wake.code` — propagates 0, 127, 124, etc. |

`tools/aurora_run.rish` holds orchestration; `aurora/run.sh` is `exec rishi/bin/rishi run tools/aurora_run.rish "$@"` — same stable path as all eleven wire labs.

`tools/aurora_run_witness.rish` proves missing-stage exit **2** only — no QEMU claim in parity.

## What Closes

**Structural POSIX seam — closed.** All QEMU background-orchestration and aurora wake scripts delegate to native Rishi.

**Permanent `.sh` — unchanged:**

- `rye/bootstrap.sh` — cold start before `rye` exists
- External interpreters — `cast_a_chart_host.sh`, `cursor-jail.sh`, `fetch_gratitude_web.sh`

Update `TAME_GUIDANCE.md` POSIX note accordingly.

## Kumara Ratchet

Confirmed live at **0** — scan exclusion extended for capitalized `FromEd25519` (`publicKeyFromEd25519`); not stale reporting.

---

*May the last structural seam close with the same thin delegate the wire labs earned — and may the developer utility keep its six stages speaking each in their own voice, without parity claiming a single expected line.*
