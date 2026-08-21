# OA-L4 reputation-as-fold — parity 167

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260706.235512

## Prompt

Kaeden said **yes to all** — apply TASKS phrase deltas from ruling `20260706.232812`, open OA-L4 lap 1, seat ruling docs, cut zip **59**.

## Trace

Applied TASKS lines 52 and 72. Implemented `foldReputationLog` in `linengrow/open_asks.rye`: applicant-signed consent facts (`grant` / `withhold`), consent-before-counting, witness bolt (3 completions, 2 consented, 1 withheld). Added `tools/open_asks_lap4.rish`, parity block → **167**. Fixed doorway scan (ruling Status line, witness-bolt checkable-room). Full parity GREEN (~95s).

## Observations

- OA-L4 reuses OA-L1 completion facts + new consent fact shape; no parallel reputation grammar.
- Unwelcome paths: consent before completion, double consent — refused whole.
- `max_log_len` raised to 16384 for multi-ask witness bolt.
- MALA graduation remains horizon until OA-L4 becomes escrow second consumer.

## Files

- `linengrow/open_asks.rye` — OA-L4 fold + reputation selftest
- `tools/open_asks_lap4.rish` — witness (new)
- `tools/parity.rish` — OA-L4 block
- `work-in-progress/TASKS.md` — ruling deltas + OA-L4 landed + next climb
- `work-in-progress/ready-to-ask-claude.md` — OA-L4 seated
- `active-designing/20260706-013012_open-asks-escrow-hammock.md` — OA-L4 landed
- `active-designing/20260706-185112_the-witness-bolt.md` — doorway fix
- `counsel/20260706-232812_claude-ruling-oal4-mala-edit5-and-horizons.md` — Status line
- `foundations/20260706-022912_the-wire-serves-the-fold.md` — landed (prior pass)
- `session-logs/20260706-235512_oal4-reputation-parity167.md` — this log

**Recommend:** keep going to **`stones/`→`resins/` rename** — mechanical hygiene, witness-gated, first item in ruling Q3 order.
