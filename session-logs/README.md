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

- `20260725.112527` — [Wave 35 close kg turn](20260725-112527_kg-wave35-close.bron) — PR 123
- `20260725.112526` — [REMEMBER Wave 35](20260725-112526_remember-git-nib-wave35.bron) — pin f1eee232e1
- `20260725.112525` — [Send Wave 35](20260725-112525_send-radiant-wave35.bron) — PR 123
- `20260725.112515` — [Radiant Wave 35 — fifty paths](20260725-112515_radiant-wave35.bron) — 41 clean · 9 changed · lint 2
- `20260725.112427` — [Wave 34 close kg turn](20260725-112427_kg-wave34-close.bron) — PR 122
- `20260725.112426` — [REMEMBER Wave 34](20260725-112426_remember-git-nib-wave34.bron) — pin 449b3321a0
- `20260725.112425` — [Send Wave 34](20260725-112425_send-radiant-wave34.bron) — PR 122
- `20260725.112415` — [Radiant Wave 34 — fifty paths](20260725-112415_radiant-wave34.bron) — 50 clean · lint 2
- `20260725.112327` — [Wave 33 close kg turn](20260725-112327_kg-wave33-close.bron) — PR 121
- `20260725.112326` — [REMEMBER Wave 33](20260725-112326_remember-git-nib-wave33.bron) — pin 90087ed126
- `20260725.112325` — [Send Wave 33](20260725-112325_send-radiant-wave33.bron) — PR 121
- `20260725.112315` — [Radiant Wave 33 — fifty paths](20260725-112315_radiant-wave33.bron) — 50 clean · lint 2
- `20260725.112227` — [Wave 32 close kg turn](20260725-112227_kg-wave32-close.bron) — PR 120
- `20260725.112226` — [REMEMBER Wave 32](20260725-112226_remember-git-nib-wave32.bron) — pin 6a0dd97ecd
- `20260725.112225` — [Send Wave 32](20260725-112225_send-radiant-wave32.bron) — PR 120
- `20260725.112215` — [Radiant Wave 32 — fifty paths](20260725-112215_radiant-wave32.bron) — 50 clean · lint 2
- `20260725.112127` — [Wave 31 close kg turn](20260725-112127_kg-wave31-close.bron) — PR 119
- `20260725.112126` — [REMEMBER Wave 31](20260725-112126_remember-git-nib-wave31.bron) — pin 208720f0a6
- `20260725.112125` — [Send Wave 31](20260725-112125_send-radiant-wave31.bron) — PR 119
- `20260725.112115` — [Radiant Wave 31 — fifty paths](20260725-112115_radiant-wave31.bron) — 50 clean · lint 2
- `20260725.112027` — [Wave 30 close kg spot-read](20260725-112027_kg-wave30-close.bron) — PR 118
- `20260725.112026` — [REMEMBER Wave 30](20260725-112026_remember-git-nib-wave30.bron) — pin abe53c5d02
- `20260725.112025` — [Send Wave 30](20260725-112025_send-radiant-wave30.bron) — PR 118
- `20260725.112015` — [Radiant Wave 30 — spot-read](20260725-112015_radiant-wave30.bron) — 50 clean · lint 2
- `20260725.111927` — [Wave 29 close kg turn](20260725-111927_kg-wave29-close.bron) — PR 117
- `20260725.111926` — [REMEMBER Wave 29](20260725-111926_remember-git-nib-wave29.bron) — pin b9fcdaf126
- `20260725.111925` — [Send Wave 29](20260725-111925_send-radiant-wave29.bron) — PR 117
- `20260725.111915` — [Radiant Wave 29 — fifty paths](20260725-111915_radiant-wave29.bron) — 50 clean · lint 2
- `20260725.111827` — [Wave 28 close kg turn](20260725-111827_kg-wave28-close.bron) — PR 116
- `20260725.111826` — [REMEMBER Wave 28](20260725-111826_remember-git-nib-wave28.bron) — pin 0e91145ea7
- `20260725.111825` — [Send Wave 28](20260725-111825_send-radiant-wave28.bron) — PR 116
- `20260725.111815` — [Radiant Wave 28 — fifty paths](20260725-111815_radiant-wave28.bron) — 50 clean · lint 2
- `20260725.111727` — [Wave 27 close kg turn](20260725-111727_kg-wave27-close.bron) — PR 115
- `20260725.111726` — [REMEMBER Wave 27](20260725-111726_remember-git-nib-wave27.bron) — pin 5c0e4807d7
- `20260725.111725` — [Send Wave 27](20260725-111725_send-radiant-wave27.bron) — PR 115
- `20260725.111715` — [Radiant Wave 27 — fifty paths](20260725-111715_radiant-wave27.bron) — 50 clean · lint 2
- `20260725.111627` — [Wave 26 close kg turn](20260725-111627_kg-wave26-close.bron) — PR 114
- `20260725.111626` — [REMEMBER Wave 26](20260725-111626_remember-git-nib-wave26.bron) — pin 24c2f524a0
- `20260725.111625` — [Send Wave 26](20260725-111625_send-radiant-wave26.bron) — PR 114
- `20260725.111615` — [Radiant Wave 26 — fifty paths](20260725-111615_radiant-wave26.bron) — 50 clean · lint 2
- `20260725.111527` — [Wave 25 close kg spot-read](20260725-111527_kg-wave25-close.bron) — PR 113
- `20260725.111526` — [REMEMBER Wave 25](20260725-111526_remember-git-nib-wave25.bron) — pin 1b0a6324f0
- `20260725.111525` — [Send Wave 25](20260725-111525_send-radiant-wave25.bron) — PR 113
- `20260725.111515` — [Radiant Wave 25 — spot-read](20260725-111515_radiant-wave25.bron) — 50 clean · lint 2
- `20260725.111427` — [Wave 24 close kg turn](20260725-111427_kg-wave24-close.bron) — PR 112
- `20260725.111426` — [REMEMBER Wave 24](20260725-111426_remember-git-nib-wave24.bron) — pin 056bf2d5f9
- `20260725.111425` — [Send Wave 24](20260725-111425_send-radiant-wave24.bron) — PR 112
- `20260725.111415` — [Radiant Wave 24 — fifty paths](20260725-111415_radiant-wave24.bron) — 50 clean · lint 2
- `20260725.111247` — [Wave 22-23 close kg turn](20260725-111247_kg-wave22-23-close.bron) — PR 110 · PR 111
- `20260725.111246` — [REMEMBER Wave 23](20260725-111246_remember-git-nib-wave23.bron) — pin 731a802f55
- `20260725.111245` — [Send Wave 23](20260725-111245_send-radiant-wave23.bron) — PR 111
- `20260725.111235` — [Radiant Wave 23 — fifty paths](20260725-111235_radiant-wave23.bron) — 50 clean · lint 2
- `20260725.111132` — [Wave 22 close](20260725-111132_radiant-wave22-close.bron) — PR 110
- `20260725.111131` — [REMEMBER Wave 22](20260725-111131_remember-git-nib-wave22.bron) — pin 65bd39450a
- `20260725.111130` — [Send Wave 22](20260725-111130_send-radiant-wave22.bron) — PR 110
- `20260725.111120` — [Radiant Wave 22 — fifty paths](20260725-111120_radiant-wave22.bron) — 46 clean · 4 changed · lint 2
- `20260725.111100` — [Wave 21 close](20260725-111100_radiant-wave21-close.bron) — PR 109
- `20260725.111051` — [REMEMBER Wave 21](20260725-111051_remember-git-nib-wave21.bron) — pin 336cf06bee
- `20260725.111050` — [Send Wave 21](20260725-111050_send-radiant-wave21.bron) — PR 109
- `20260725.111005` — [Radiant Wave 21 — fifty paths](20260725-111005_radiant-wave21.bron) — 49 clean · 1 changed · lint 2
- `20260725.110930` — [Wave 20 spot-read close](20260725-110930_radiant-wave20-close.bron) — 379/~1185
- `20260725.110925` — [REMEMBER Wave 20](20260725-110925_remember-git-nib-wave20.bron) — pin 4f57421659
- `20260725.110924` — [Send Wave 20 spot-read](20260725-110924_send-radiant-wave20.bron) — PR 109
- `20260725.110847` — [Radiant Wave 20 — spot-read](20260725-110847_radiant-wave20.bron) — 50 clean · lint 2
- `20260725.110820` — [Wave 19 close](20260725-110820_radiant-wave19-close.bron) — PR 108
- `20260725.110813` — [REMEMBER Wave 19](20260725-110813_remember-git-nib-wave19.bron) — pin d36d5b17ae
- `20260725.110812` — [Send Wave 19](20260725-110812_send-radiant-wave19.bron) — PR 108
- `20260725.110740` — [Radiant Wave 19 — fifty paths](20260725-110740_radiant-wave19.bron) — 50 clean · lint 2
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
