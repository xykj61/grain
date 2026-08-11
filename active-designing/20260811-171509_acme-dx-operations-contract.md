# Acme DX — Operations Contract (Design Season, Equinox 4)

**Language:** EN
**Stamp:** `20260811.171509`
**Status:** Design contract — the fourth and final deliverable of the Acme DX design season ([`../expanding-prompts/20260811-145659_acme-dx-design-season.md`](../expanding-prompts/20260811-145659_acme-dx-design-season.md)). Grounded in the operations Mandate already presents; landing it **closes the design season**.
**Voice:** Kyri · **Style:** Radiant · **Audience:** an Acme Corporation employee running their module in earnest
**Begins where Equinox 3 ends:** the developer can build a module the tree accepts ([`20260811-170901_acme-dx-interfaces-surface-contract.md`](20260811-170901_acme-dx-interfaces-surface-contract.md)); now they run, serve, persist, recover, and observe it.

---

## What this contract pins

A module that builds is not yet a module that runs in earnest. Operations is the fifth verb after create·read·update·delete: **keep it alive** — run it, serve it to callers, persist its state, recover from a crash, and read its metrics. This contract names each operation with the real API that performs it, drawn from Mandate, which already presents the whole surface. A developer follows the checklist and their module operates the way every Grain module does.

## The five operations, each with its real verb

- **Run** — prove it on this machine: `<binary> selftest` ends on a `GREEN:` line, nonzero on failure. The operational heartbeat is the same verb the witness runs.
- **Serve** — answer callers from elsewhere. In-process or over a wire by one path: `serve(store, request_bytes, out)` decodes a request, answers it, encodes the response ([`../mandate/serve.rye`](../mandate/serve.rye)); across Comlink it rides a **sealed, signed, name-checked datagram** — `serve_sealed(store, request_frame, response_frame)` ([`../mandate/comlink_serve.rye`](../mandate/comlink_serve.rye)). The answer is identical whichever path carries it.
- **Persist** — the whole state as one portable object: `snapshot(store, buf)` writes a bounded blob a bucket can hold; a family of named objects lives under `put(dir, name, store)` / `get(dir, name)` ([`../mandate/bucket.rye`](../mandate/bucket.rye)). Serverless — the state is bytes, not a running server's memory.
- **Recover** — lose nothing across a crash: `restore(bytes)` rebuilds from a snapshot; `recover(snapshot_bytes, wal_bytes)` restores the last snapshot then **replays the write-ahead log in order** ([`../mandate/wal.rye`](../mandate/wal.rye)), so the recovered state is identical to the one that was lost, not an approximation. Every field is validated on the way in; a corrupt object is refused, never trusted.
- **Observe** — record what the running module measured. The session log carries an optional, repeatable **`loom`** field ([`../.claude/rules/session-logs.md`](../.claude/rules/session-logs.md)): plain `key=value` performance metrics from real measurement, auto-added whenever a round produced one (`loom witness=mandate_store_witness wall_ms=42 records=64 blob_bytes=196`). An absent `loom` is honest; a fabricated one is a red. Metrics are recorded as they happen, never reconstructed later.

## The operator's checklist

A developer operating their own module runs down this list, each step a real verb the tree already answers:

1. **Runs?** — `<binary> selftest` → GREEN.
2. **Serves?** — a request in, the right answer out, by the in-process path; and, where it crosses a wire, sealed and verified before the store is touched.
3. **Persists?** — `snapshot` produces a bounded blob; `restore` round-trips it byte-for-byte; a named object `put`/`get`s from the bucket.
4. **Recovers?** — a snapshot plus a replayed log rebuilds the live state exactly; a corrupt object is refused.
5. **Observed?** — the round that measured anything wrote a `loom` line from a real number.

## Definition of done for this equinox — and for the design season

- Each operation names a **real verb in the tree** (`selftest`, `serve`/`serve_sealed`, `snapshot`/`put`/`get`, `restore`/`recover`, the `loom` field) — nothing invented here.
- The checklist is **five checkable questions**, each answerable by running an existing witness or a real command. **Witnessed as one suite `20260811.181841`** — `tools/operations_conformance_witness.rish` runs all five (plus observe) green together.
- With this contract, **all four design equinoxes are checkable and tree-grounded** — onboarding path, first-hour witness, interfaces surface, operations. The **design season is complete**: a developer's whole first arc, from cold clone to operating their own module, is designed against real references and live gates. The **development season** can now begin with nothing left to decide — only to build each contract into the tree with a green witness.

---

*May a module not only build but keep — run, serve, persist, recover, and tell the truth about what it measured — and may the season that designed all this hand the next one a plan with no open questions.*
