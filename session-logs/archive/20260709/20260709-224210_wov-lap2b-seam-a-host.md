# WOV lap 2b seam A — host projection landed

**Stamp:** `20260709.224210`
**Editor:** Cursor · **Model:** Grok 4.5 · **Voice:** Rio 3

## Prompt

Keep going; continue in the best path; open anything needed.

## Thinking trace

1. Treated keep-going after design `204026` as affirm of **seam A** (POSIX host to pinned binary).
2. Built pin binary with TB's Zig 0.14.1 (`gratitude/tigerbeetle/zig/zig build -Drelease`) — binary at pin root and `zig-out/bin/`.
3. Live `format`/`start` failed inside ai-jail: `io_uring_setup` → EPERM (seccomp). Kernel `io_uring_disabled=0`; capability/seccomp still blocks the syscall.
4. Landed seam A as: ensure-binary script + projection grammar + `wov_tb_host.rye` (rebuilds lap-1 exit bundle from TB-shaped balances) + REPL lab that **SKIP**s when io_uring is unavailable and **GREEN**s on metal.
5. Wired `tools/wov_tb_host.rish` into `parity.rish` → **204**. Full suite GREEN (~173s). Pin-presence still GREEN (no `@import` of the pin).

## Observations

- Exit honesty stays byte-compatible with lap 1 golden `wov_exit_bundle_v1.bron`.
- Live cluster-of-one is ready outside the enclosure; enclosure witnesses stay honest via SKIP.
- Seam B (Zig client protocol) stays later.

## Files

| File | Why |
|------|-----|
| `linengrow/wov_tb_host.rye` | Projection → Book → root/prove/exit |
| `tools/fixtures/wov_tb_projection_v1.bron` | Golden TB-shaped balance table |
| `tools/wov_tb_ensure_binary.sh` | Stage pin binary under `tools/.build/` |
| `tools/wov_tb_repl_lab.sh` | Live REPL lab; SKIP without io_uring |
| `tools/wov_tb_host.rish` | Witness |
| `tools/parity.rish` | Slot **204** |
| `expanding-prompts/20260709-204026_…` | Status landed |
| `context/specs/20260709-204026_…` + exit-honesty | Gate checklist |
| `work-in-progress/TASKS.md` + `ROADMAP.md` | Parity **204** |
| `context/LEXICON.md` + `README.md` | WOV entry |
| `external-research/20260709-203139_…` | Q1 answered |
| `session-logs/20260709-224210_…` | This log |

## Next-step recommendation

Recommend: keep going to `go` (commit + push four remotes, exclude `tools/bin/` and `tools/.build/`) — seam A verified at parity **204**. Check in with Claude before dual monarch or seam B.
