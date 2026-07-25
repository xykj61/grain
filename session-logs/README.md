# Session logs

**Language:** EN  
**Status:** Living pin — newest-first index (current day)  
**Bound:** under `living_pin_max_bytes`  
**Seasons roster:** [`SEASONS.md`](SEASONS.md)

Living index for the append-only session stream. This table reads **newest first** and holds the **current season day only**. Closed seasons fold into dated indexes under `archive/`; the roster names each season in one line.

**Living format:** **Bron** (`.bron`) — immutable key-value at the seam. Historical Markdown logs are folded under `archive/YYYYMMDD/`. Rules: [`.cursor/rules/session-logs.mdc`](../.cursor/rules/session-logs.mdc) · [`.claude/rules/session-logs.md`](../.claude/rules/session-logs.md).

**Day’s truth is this index’s order, not filename sort.** One-clock stamps sort ascending on disk; trust the table for sequence within a day. Naming: [`context/specs/20260627-102012_one-clock-naming-law.md`](../context/specs/20260627-102012_one-clock-naming-law.md).

**Living pin bound:** `living_pin_max_bytes = 24576` ([spec](../context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md)) · growth law: [`../context/specs/append-only-growth-law.md`](../context/specs/append-only-growth-law.md).

*Erratum `20260724.203617` — UTC window:* four living logs were stamped from `Etc/UTC` and must be read in index order (now on the 20260724/25 season surfaces). Cause fixed: host zone `America/New_York`. From `20260724.205009` the one-clock witness is **blocking**.

- `20260725.110710` — [Wave 18 close](20260725-110710_radiant-wave18-close.bron) — PR 107 · 279/~1185
- `20260725.110704` — [REMEMBER Wave 18](20260725-110704_remember-git-nib-wave18.bron) — pin 07284bb16c
- `20260725.110703` — [Send Wave 18](20260725-110703_send-radiant-wave18.bron) — PR 107
- `20260725.110622` — [Radiant Wave 18 — fifty paths](20260725-110622_radiant-wave18.bron) — 50 clean · lint 2
- `20260725.110550` — [Quin relay runway · Wave 17](20260725-110550_quin-relay-runway-wave17.bron) — A–D seated · PR 106
- `20260725.110544` — [REMEMBER git nib Wave 17](20260725-110544_remember-git-nib-wave17.bron) — pin ef96db6513
- `20260725.110543` — [Send Radiant Wave 17 · runway](20260725-110543_send-radiant-wave17.bron) — FF · PR 106
- `20260725.110418` — [Radiant Wave 17 — fifty batch](20260725-110418_radiant-wave17.bron) — 50 clean · lint 2
- `20260725.105716` — [wave runway estimate · Wave 16 send](20260725-105716_wave-runway-estimate.bron) — 16/~17 counsel runway
- `20260725.105706` — [REMEMBER git nib after Wave 16 send](20260725-105706_remember-git-nib-wave16.bron) — pin 8d416b71d3
- `20260725.105705` — [Send Radiant Wave 16 to main](20260725-105705_send-radiant-wave16.bron) — FF merge · PR 105
- `20260725.105645` — [Radiant Wave 16 — twelve counsel replies](20260725-105645_radiant-wave16.bron) — 12 files · lint 2
- `20260725.105547` — [Radiant Wave 15 close on main](20260725-105547_radiant-wave15-close.bron) — PR 104 · model Composer 2.5
- `20260725.105537` — [REMEMBER git nib after Wave 15 send](20260725-105537_remember-git-nib-wave15.bron) — pin b4c3c21ca0
- `20260725.105536` — [Send Radiant Wave 15 to main](20260725-105536_send-radiant-wave15.bron) — FF merge · PR 104
- `20260725.105504` — [Radiant Wave 15 — twelve counsel · replies](20260725-105504_radiant-wave15.bron) — 12 files · lint 2
- `20260725.104544` — [REMEMBER git nib after Wave 14 send](20260725-104544_remember-git-nib-wave14.bron) — pin caab8ca98c
- `20260725.104543` — [Send Radiant Wave 14 to main](20260725-104543_send-radiant-wave14.bron) — FF merge · PR 103
- `20260725.104506` — [Radiant Wave 14 — twelve counsel](20260725-104506_radiant-wave14.bron) — 12 files · lint 2
- `20260725.104418` — [waymarks root claims newest-first sort](20260725-104418_waymarks-root-order.bron) — index hygiene
- `20260725.104333` — [REMEMBER git nib after Wave 13 send](20260725-104333_remember-git-nib-wave13.bron) — pin 6f19991264
- `20260725.104332` — [Send Radiant Wave 13 to main](20260725-104332_send-radiant-wave13.bron) — FF merge · PR 101
- `20260725.104245` — [Radiant Wave 13 — twelve counsel](20260725-104245_radiant-wave13.bron) — 12 files · lint 2
- `20260725.104017` — [REMEMBER git nib after Wave 12 send](20260725-104017_remember-git-nib-wave12.bron) — pin 58a459f3ad
- `20260725.104016` — [Send Radiant Wave 12 to main](20260725-104016_send-radiant-wave12.bron) — FF merge · PR 100
- `20260725.103949` — [Radiant Wave 12 — twelve counsel](20260725-103949_radiant-wave12.bron) — 12 files · lint 2
- `20260725.041102` — [REMEMBER git nib after Wave 11 send](20260725-041102_remember-git-nib-wave11.bron) — pin 54d880fdf8
- `20260725.041101` — [Send Radiant Wave 11 to main](20260725-041101_send-radiant-wave11.bron) — FF merge · PR 99
- `20260725.041039` — [Radiant Wave 11 — twelve counsel · specs](20260725-041039_radiant-wave11.bron) — 12 files · lint 2
- `20260725.040845` — [REMEMBER git nib after shell·fold send](20260725-040845_remember-git-nib-shell-fold.bron) — pin f521048887
- `20260725.040844` — [Send shell·fold · Wave 10 to main](20260725-040844_send-shell-fold-wave10.bron) — FF merge · PR 98
- `20260725.040728` — [Shell fold seat · Radiant Wave 10](20260725-040728_shell-fold-wave10.bron) — growth law · fold · duty8=27 · wave10 lint 2
- `20260725.040021` — [REMEMBER git nib after Wave 9 send](20260725-040021_remember-git-nib-wave9.bron) — pin 820c3d95c5
- `20260725.040020` — [Send Radiant Wave 9 to main](20260725-040020_send-radiant-wave9.bron) — FF merge · PR 97
- `20260725.035955` — [Radiant Wave 9 — twelve context specs](20260725-035955_radiant-wave9-specs.bron) — 12 files · lint 2
- `20260725.035918` — [REMEMBER git nib after Wave 8 send](20260725-035918_remember-git-nib-wave8.bron) — pin 5492d7c3ec
- `20260725.035917` — [Send Radiant Wave 8 to main](20260725-035917_send-radiant-wave8.bron) — FF merge · PR 96
- `20260725.035852` — [Radiant Wave 8 — twelve context specs](20260725-035852_radiant-wave8-specs.bron) — 12 files · lint 2
- `20260725.035801` — [REMEMBER git nib after Wave 7 send](20260725-035801_remember-git-nib-wave7.bron) — pin 2ee01dd29f
- `20260725.035800` — [Send Radiant Wave 7 to main](20260725-035800_send-radiant-wave7.bron) — FF merge · PR 95
- `20260725.035645` — [Radiant Wave 7 — twelve context specs](20260725-035645_radiant-wave7-specs.bron) — 12 files · lint 2
- `20260725.035548` — [REMEMBER git nib after Wave 6 send](20260725-035548_remember-git-nib-wave6.bron) — pin a02ec36f16
- `20260725.035547` — [Send Radiant Wave 6 to main](20260725-035547_send-radiant-wave6.bron) — FF merge · PR 94
- `20260725.035453` — [Radiant Wave 6 — next twelve foundations](20260725-035453_radiant-wave6-foundations.bron) — 12 files · lint 2
- `20260725.035342` — [REMEMBER git nib after Wave 5 send](20260725-035342_remember-git-nib-wave5.bron) — pin c4f0d02140
- `20260725.035341` — [Send Radiant Wave 5 to main](20260725-035341_send-radiant-wave5.bron) — FF merge · PR 93
- `20260725.035134` — [Radiant Wave 5 — oldest foundations](20260725-035134_radiant-wave5-foundations.bron) — 12 files · lint 2
- `20260725.035026` — [REMEMBER git nib after always-in-it send](20260725-035026_remember-git-nib-always-in-it.bron) — pin 4605eb6318
- `20260725.035025` — [Send always-in-it · Wave 4 to main](20260725-035025_send-always-in-it.bron) — FF merge · PR 92
- `20260725.034920` — [Always in it · pass playbook · Wave 4](20260725-034920_always-in-it-ethos-wave4.bron) — OQ5 · ledger · lint 4→2
- `20260725.001742` — [REMEMBER git nib after redaction send](20260725-001742_remember-git-nib-redaction.bron) — pin 8dc6238c7a
- `20260725.001741` — [Send redaction stance to main](20260725-001741_send-redaction-stance.bron) — FF merge · PR 91
- `20260725.001710` — [Redaction stance living pin · OQ #1](20260725-001710_redaction-stance-seat.bron) — forget by key · Mand ring-3 PARK
- `20260725.003013` — [REMEMBER git nib after Seva · Mand send](20260725-003013_remember-git-nib-seva-mand.bron) — pin 1ab2009bb0
- `20260725.002955` — [Send Seva complete · Mand seated to main](20260725-002955_send-seva-complete-mand.bron) — FF merge · Sala historical · Mand · GREEN
- `20260725.002400` — [Sala rename digest and fixture risk survey](20260725-002400_sala-rename-digest-fixture-risk.bron) — STOP memos/pins · SAFE names/paths
