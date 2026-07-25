# Expanding Prompt — WOV Lap 2b: TigerBeetle Client Wrapper

**Stamp:** `20260709.204026`
**Voice:** Rio 3
**Status:** **Landed** `20260709.223700` — seam **A** (POSIX host); parity **204**
**Ground:** client-seam design [`../context/specs/20260709-204026_wov-tb-client-seam.md`](../context/specs/20260709-204026_wov-tb-client-seam.md) · pin presence [`203527`](20260709-203527_wov-lap2-tigerbeetle-pin-presence.md) · exit honesty [`200443`](../context/specs/20260709-200443_wov-exit-honesty.md)

---

## Affirm

Kaeden keep-going after design `204026` affirmed **seam A**. Seam B stays later.

## DoD

1. Pinned binary staged under `tools/.build/tigerbeetle/` via `tools/wov_tb_ensure_binary.sh` — GREEN.
2. Projection grammar `wov-tb-projection/v1` → `linengrow/wov_tb_host.rye` rebuilds lap-1 exit bundle — GREEN (`tools/wov_tb_host.rish`).
3. Live cluster-of-one REPL lab (`tools/wov_tb_repl_lab.sh`) — **GREEN** on metal with io_uring; **SKIP** under ai-jail seccomp (documented).
4. Pin-presence witness still GREEN (no `@import` of the pin into `.rye`).
5. Parity stanza GREEN → **204**.

## Out of scope

Dual monarch; forking TB; Zig client protocol (seam B); SLC-L4 privacy over the account table.

---

*Seam A earns the first green wrapper without forking the pin.*
