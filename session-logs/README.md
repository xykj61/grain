# Session logs

**Language:** EN  
**Status:** Living pin — newest-first index  
**Bound:** under `living_pin_max_bytes`  

Living index for the append-only session stream. This table reads **newest first**.

**Living format:** **Bron** (`.bron`) — immutable key-value at the seam. Historical Markdown logs are folded under `archive/YYYYMMDD/`. Rules: [`.cursor/rules/session-logs.mdc`](../.cursor/rules/session-logs.mdc) · [`.claude/rules/session-logs.md`](../.claude/rules/session-logs.md).

**Day’s truth is this index’s order, not filename sort.** One-clock stamps sort ascending on disk; trust the table for sequence within a day.

Naming follows [`context/specs/20260627-102012_one-clock-naming-law.md`](../context/specs/20260627-102012_one-clock-naming-law.md).

*Erratum `20260724.203617` — UTC window on the cloud bench:* while Keaton's clock supplied `20260724.202412` (EDT), four living logs were stamped from `Etc/UTC` and must be read in index order, not filename sort: `20260724.221013` (digraph research; sits after `181241` in truth-order), `20260725.002400` (sala rename survey), `20260725.002955` (send Seva·Mand), `20260725.003013` (REMEMBER pin). Files keep their names (accrete-never-break). Cause fixed: host zone re-seated to `America/New_York`. From `20260724.205009` the one-clock witness is **blocking** (shape · mono · zone); the human ceiling is retired — see law addendum.

**Living pin bound:** `living_pin_max_bytes = 24576` ([spec](../context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md)). Closed index rows through `20260721`: [`archive/README-index-through-20260721.md`](archive/README-index-through-20260721.md). Early `20260722` overflow: [`archive/README-index-20260722-shelf.md`](archive/README-index-20260722-shelf.md).

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
- `20260724.223409` — [Send Radiant waves close to main](20260724-223409_send-radiant-waves-close.bron) — FF merge · PR 87–90
- `20260724.223410` — [REMEMBER git nib after Radiant waves send](20260724-223410_remember-git-nib-radiant-waves.bron) — pin 41fbabd16e
- `20260724.223233` — [Radiant Wave 3 — Tier 2 passes · five-remotes errata](20260724-223233_radiant-wave3-tier2.bron) — pass · erratum · lint 8→4
- `20260724.223151` — [Radiant Wave 2 — linengrow comments](20260724-223151_radiant-wave2-linengrow.bron) — 5 files · claim_preserve GREEN
- `20260724.223050` — [Radiant Wave 1 — living docs](20260724-223050_radiant-wave1-living.bron) — header · but-word · lint 10→8
- `20260724.222902` — [Accrete three tiers · radiant_lint · claim_preserve](20260724-222902_accrete-tiers-radiant-instruments.bron) — Tier1–3 · instruments · roster
- `20260724.222500` — [Accrete-never-break law survey for 3-tier split](20260724-222500_accrete-never-break-law-survey.bron) — TAME §4 · living-vs-dated · remotes
- `20260724.221120` — [REMEMBER git nib after threats · pillars send](20260724-221120_remember-git-nib-threats-pillars.bron) — pin 7878bd5f28
- `20260724.221119` — [Send threats · pillars · Mand home to main](20260724-221119_send-threats-pillars-mand-home.bron) — FF merge · PR 86
- `20260724.221027` — [Threats · five pillars · Mand home analysis](20260724-221027_threats-pillars-mand-home.bron) — THREATS · siloed pillars · Mand park
- `20260724.212844` — [Explore Mand ring-1 surfaces for ring-2 retention](20260724-212844_explore-mand-ring1-for-ring2.bron) — APIs · custody · ratchet patterns · placement
- `20260724.213221` — [REMEMBER git nib after Mand ring-2 send](20260724-213221_remember-git-nib-mand-ring2.bron) — pin 006b0ffeae
- `20260724.213216` — [Send Mand ring-2 · py gate · stranger parity](20260724-213216_send-mand-ring2-roster.bron) — FF merge · PR 85
- `20260724.213140` — [Mand ring-2 retention · py gate · stranger parity](20260724-213140_mand-ring2-py-gate-stranger.bron) — KEEP·ELIGIBLE·HELD · py blocking · warm REPORT
- `20260724.211904` — [REMEMBER git nib after stranger-lap honesty send](20260724-211904_remember-git-nib-stranger-honesty.bron) — pin 3d9b8f67a3
- `20260724.211852` — [Send stranger lap honesty to main](20260724-211852_send-stranger-lap-honesty.bron) — FF merge · PR 84
- `20260724.211820` — [Stranger lap honesty · warm REPORT · cold open](20260724-211820_stranger-lap-honesty.bron) — scope · bound live · OQ4 warm-only
- `20260724.210931` — [REMEMBER git nib after fixture-scan send](20260724-210931_remember-git-nib-fixture-scans.bron) — pin 6da85ee496
- `20260724.210920` — [Send fixture scans rish · py zero to main](20260724-210920_send-fixture-scans-rish.bron) — FF merge · PR 83
- `20260724.210848` — [Fixture scans to rish · tools py zero](20260724-210848_fixture-scans-rish-zero.bron) — migrate · count zero · law table
- `20260724.210347` — [REMEMBER git nib after aura-floor · stranger send](20260724-210347_remember-git-nib-aura-floor.bron) — pin 489b3abad2
- `20260724.210342` — [Send shape aura floor · stranger lap to main](20260724-210342_send-shape-aura-floor-stranger.bron) — FF merge · PR 82
- `20260724.210249` — [Shape aura floor · stranger lap · .py ratchet](20260724-210249_shape-aura-floor-stranger.bron) — @u64 $: · OQ4 advisory · two-to-zero
- `20260724.205331` — [REMEMBER git nib after one-clock · Crockford send](20260724-205331_remember-git-nib-one-clock-aura.bron) — pin 17c4f694f4
- `20260724.205321` — [Send one-clock · Crockford aura to main](20260724-205321_send-one-clock-crockford.bron) — FF merge · blocking · Decision 6
- `20260724.205258` — [One-clock amended · Crockford aura Decision 6](20260724-205258_one-clock-crockford-aura.bron) — blocking · Decision 6 GREEN
- `20260724.204825` — [Explore one-clock · Crockford aura · encode patterns](20260724-204825_explore-one-clock-crockford-aura.bron) — Decision 6 PARK · aura seat map · witness sketch
- `20260724.203949` — [REMEMBER git nib after Mand ring-1 send](20260724-203949_remember-git-nib-mand-ring1.bron) — pin 9e59d53527
- `20260724.203935` — [Send Mand ring-1 · one-clock to main](20260724-203935_send-mand-ring1-one-clock.bron) — FF merge · HAWM1 · Mand GREEN
- `20260724.203813` — [Mand ring-1 · one-clock seat](20260724-203813_mand-ring1-one-clock.bron) — HAWM1 exempt · one-clock · Mand GREEN
- `20260724.203459` — [Explore Mand · Seva · standing-exempt surfaces](20260724-203459_explore-mand-surfaces.bron) — LEXICON · exclude · ring-1 sketch · EDT stamp
- `20260725.003013` — [REMEMBER git nib after Seva · Mand send](20260725-003013_remember-git-nib-seva-mand.bron) — pin 1ab2009bb0
- `20260725.002955` — [Send Seva complete · Mand seated to main](20260725-002955_send-seva-complete-mand.bron) — FF merge · Sala historical · Mand · GREEN
- `20260725.002400` — [Sala rename digest and fixture risk survey](20260725-002400_sala-rename-digest-fixture-risk.bron) — STOP memos/pins · SAFE names/paths
- `20260724.202412` — [Seva rename complete · Mand seated](20260724-202412_seva-complete-mand-seated.bron) — glow_seva_b0 · Mand · STOP memos · GREEN
- `20260724.201810` — [Send Nothing to Give · Seva · Mona to main](20260724-201810_send-nothing-to-give-seva.bron) — FF merge · custody · Seva · Mona
- `20260724.201727` — [Nothing to Give · Seva · Mona seated](20260724-201727_nothing-to-give-seva-seat.bron) — custody foundations · suite rename GREEN
- `20260724.194344` — [Send Hands We Grow Section One to main](20260724-194344_send-hands-we-grow-relay.bron) — FF merge · JAMCUE · twin 1a · PARK 2–8
- `20260724.194239` — [Hands We Grow relay — jamcue · twin 1a](20260724-194239_hands-we-grow-relay.bron) — JAMCUE reframe · digraph harden · PARK 2–8
- `20260724.181332` — [Send list512 and digraph twin to main](20260724-181332_send-list512-digraph-twin.bron) — FF merge · STOA333 · list512
- `20260724.181241` — [list512 and digraph-table twin STOA333](20260724-181241_list512-digraph-twin.bron) — max_list_items=512 · STOA333 GREEN
- `20260724.221013` — [Rung-1 digraph twin research for Quin](20260724-221013_rung1-digraph-twin-research.bron) — Ojjo twin · Glow @t limits · STOA333 thin plan
- `20260724.151517` — [Send flw Option C fixture pin to main](20260724-151517_send-flw-option-c.bron) — FF merge · witness GREEN · vere STOP ops
- `20260724.151417` — [flw Option C fixture pin and genre law](20260724-151417_flw-option-c-fixture-pin.bron) — twin GREEN · vere STOP ops · genre law
- `20260724.150446` — [Send flw corpus shelf counsel to main](20260724-150446_send-flw-corpus-counsel.bron) — FF merge · Claude A–E ask · vere STOP held
- `20260724.150317` — [flw corpus shelf — STOP obs and Claude ask](20260724-150317_flw-corpus-shelf-counsel.bron) — counsel A–E · Quin leans tools/fixtures · send
- `20260724.145552` — [Send fourth sitting glow and jamcue to main](20260724-145552_send-fourth-sitting-glow.bron) — FF merge · STOA332 · JAMCUE · vere STOP held
- `20260724.145458` — [Fourth sitting — glow SLC, jamcue, vere STOP](20260724-145458_fourth-sitting-glow-jamcue-vere.bron) — STOA332 GREEN · JAMCUE in-tree · vere STOP on flw
- `20260724.184846` — [Glow jam/cue · Rishi glow mode · sixteen heads scout](20260724-184846_glow-jamcue-rishi-mode-scout.bron) — impl map · GREEN wire · thin path
- `20260724.143710` — [Send vanes-shelves-names-maps braid to main](20260724-143710_send-vanes-shelves-names-maps.bron) — FF merge PR 72 · anatomy+strategy on pier
- `20260724.143435` — [Vanes shelves names maps — counsel braid run](20260724-143435_vanes-shelves-names-maps-braid.bron) — P3 under 8KB · waymarks · Aparigraha · coverage GREEN
- `20260724.134541` — [Send workshop-warehouse to main](20260724-134541_send-workshop-warehouse.bron) — FF merge PR 71 · context economy on pier
- `20260724.134322` — [Workshop and Warehouse — counsel, EP, first laps](20260724-134322_workshop-warehouse-counsel-ep-run.bron) — pin-and-ledger · tools/bin off git · living pins rolled
- `20260724.131912` — [Pull Friday · EDT orient after Framework days](20260724-131912_pull-friday-edt-orient.bron) — main f652485607 · STOA331 · EDT law · lean C next
- `20260722.205054` — [REMEMBER git nib after STOA331](20260722-205054_remember-git-nib-stoa331.bron) — pin 4d246d2886
- `20260722.205026` — [STOA330–331 gate-spec shape_name](20260722-205026_stoa330-331-gate-spec-shape-name.bron) — GateSpec rename GREEN; cast/face next
- `20260722.203848` — [REMEMBER git nib after STOA329](20260722-203848_remember-git-nib-stoa329.bron) — pin f18899d8bf
- `20260722.203753` — [STOA328–329 nest_type shape table](20260722-203753_stoa328-329-nest-type-shape-table.bron) — allowlist/N tables; gate-spec mold_name next
- `20260722.202154` — [REMEMBER git nib after STOA327](20260722-202154_remember-git-nib-stoa327.bron) — pin 4b374170d7
- `20260722.202108` — [STOA326–327 welcome sameness collapse](20260722-202108_stoa326-327-welcome-sameness-collapse.bron) — mold→N welcome GREEN; nest_type next
- `20260722.201324` — [Glow sameness collapse survey](20260722-201324_glow-sameness-collapse-survey.bron) — welcome dispatch next; nest/call-gate later
- `20260722.201109` — [REMEMBER git nib after STOA325](20260722-201109_remember-git-nib-stoa325.bron) — pin b93cd09d7b1b
- `20260722.200916` — [STOA324–325 argv sameness collapse](20260722-200916_stoa324-325-argv-sameness-collapse.bron) — one N-path GREEN; name next door
- `20260722.200325` — [REMEMBER git nib after STOA323](20260722-200325_remember-git-nib-stoa323.bron) — pin fb9251f3c7f8
- `20260722.200205` — [STOA323 sameness argv check-in](20260722-200205_stoa323-sameness-argv-checkin.bron) — lean C dollar-colon argv collapse
- `20260722.195352` — [bg penta/hexa witness GREEN](20260722-195352_bg-penta-hexa-witness-green.bron) — late shells exit 0; already seated
- `20260722.195305` — [STOA322 sameness argv critique](20260722-195305_stoa322-sameness-argv-critique.bron) — emit helper ok; rung process drifted
- `20260722.195124` — [REMEMBER git nib after STOA322](20260722-195124_remember-git-nib-stoa322.bron) — pin 8e67f373b428
- `20260722.195019` — [STOA321–322 nona argv](20260722-195019_stoa321-322-nona-argv-round.bron) — $: nine fields GREEN; family closed
- `20260722.194520` — [REMEMBER git nib after STOA320](20260722-194520_remember-git-nib-stoa320.bron) — pin 1f9ff6ee2097
- `20260722.194416` — [STOA319–320 octa argv](20260722-194416_stoa319-320-octa-argv-round.bron) — $: eight fields GREEN; nona next
- `20260722.193831` — [REMEMBER git nib after STOA318](20260722-193831_remember-git-nib-stoa318.bron) — pin bc27f18f2e41
- `20260722.193725` — [STOA317–318 hepta argv](20260722-193725_stoa317-318-hepta-argv-round.bron) — $: seven fields GREEN; octa next
- `20260722.193212` — [REMEMBER git nib after STOA316](20260722-193212_remember-git-nib-stoa316.bron) — pin 4b4e9faf0b1c
- `20260722.192737` — [STOA315–316 hexa argv](20260722-192737_stoa315-316-hexa-argv-round.bron) — $: six fields GREEN; hepta next
- `20260722.192622` — [REMEMBER git nib after STOA314](20260722-192622_remember-git-nib-stoa314.bron) — pin 10790cb5531d
- `20260722.192146` — [STOA313–314 penta argv](20260722-192146_stoa313-314-penta-argv-round.bron) — $: five fields GREEN; hexa next
- `20260722.192029` — [witness bg tasks acked](20260722-192029_witness-bg-tasks-acked.bron) — triple/quad shells already GREEN
- `20260722.191956` — [REMEMBER git nib after STOA312](20260722-191956_remember-git-nib-stoa312.bron) — pin af3c8be8c795
- `20260722.191505` — [STOA311–312 quad argv](20260722-191505_stoa311-312-quad-argv-round.bron) — $: four fields GREEN; penta next
- `20260722.191335` — [REMEMBER git nib after STOA310](20260722-191335_remember-git-nib-stoa310.bron) — pin 86c80ab7a54e
- `20260722.190839` — [STOA309–310 triple argv](20260722-190839_stoa309-310-triple-argv-round.bron) — $: from+amount+fee GREEN; quad next
- `20260722.190730` — [REMEMBER git nib after STOA308](20260722-190730_remember-git-nib-stoa308.bron) — pin 0cd436740c5c
- `20260722.190655` — [STOA307–308 pair argv](20260722-190655_stoa307-308-pair-argv-round.bron) — $: from+amount GREEN; triple next
- `20260722.190216` — [STOA306 check-in restated](20260722-190216_stoa306-checkin-restated.bron) — lean C pair argv
- `20260722.190049` — [REMEMBER git nib after STOA306](20260722-190049_remember-git-nib-stoa306.bron) — pin 5dd12e658863
- `20260722.185953` — [STOA305–306 xfer argv](20260722-185953_stoa305-306-xfer-argv-round.bron) — mint from+amount GREEN; pair next
- `20260722.185256` — [REMEMBER git nib after rest habit](20260722-185256_remember-git-nib-rest-habit.bron) — pin cd72ad613e93
- `20260722.185058` — [stop recommending rest](20260722-185058_stop-recommending-rest.bron) — Keaton owns rest; STOA304 lean C
- `20260722.184920` — [STOA303–304 xact argv](20260722-184920_stoa303-304-xact-argv-round.bron) — payload tag+amount GREEN; rest next
- `20260722.184415` — [REMEMBER git nib after STOA302](20260722-184415_remember-git-nib-stoa302.bron) — pin 802826c4262f
- `20260722.184311` — [align continue Glow STOA302](20260722-184311_align-continue-glow-stoa302.bron) — payload argv survey recommended
- `20260722.184015` — [Glow language completeness survey](20260722-184015_glow-language-completeness-survey.bron) — vs Hoon families; Rye→Zig→RISC-V
- `20260722.183757` — [REMEMBER git nib after cursorignore](20260722-183757_remember-git-nib-cursorignore.bron) — pin c127b3ab73e6
- `20260722.183720` — [cursorignore archive and caches](20260722-183720_cursorignore-archive-caches.bron) — lean A seated; rest or yonder next
- `20260722.183514` — [filetree append-front check-in](20260722-183514_filetree-append-front-checkin.bron) — prefer fold/ignore over content-merge
- `20260722.161915` — [STOA301 send and check-in](20260722-161915_stoa301-send-and-checkin.bron) — pier already clean; rest or payload argv
- `20260722.161826` — [REMEMBER git nib after STOA301](20260722-161826_remember-git-nib-stoa301.bron) — pin 036b9f414008
- `20260722.161751` — [STOA300–301 kind argv](20260722-161751_stoa300-301-kind-argv-round.bron) — unit-tag reader GREEN; rest next
- `20260722.161152` — [REMEMBER git nib after STOA299](20260722-161152_remember-git-nib-stoa299.bron) — pin cda543aac20f
- `20260722.161041` — [STOA299 continue after tagged flip](20260722-161041_stoa299-continue-after-tagged-flip.bron) — rest declined; tagged argv survey next
- `20260722.160958` — [REMEMBER git nib after STOA298](20260722-160958_remember-git-nib-stoa298.bron) — pin 8f7a5290e15a
- `20260722.160929` — [STOA297–298 tagged unit flip](20260722-160929_stoa297-298-tagged-unit-flip-round.bron) — unit helper both gates GREEN; rest next
- `20260722.160543` — [REMEMBER git nib after STOA296](20260722-160543_remember-git-nib-stoa296.bron) — pin 89c6ab60af09
- `20260722.160509` — [STOA295–296 barket tagged flip](20260722-160509_stoa295-296-barket-tagged-flip-round.bron) — barket payload helper GREEN; kind unit next
- `20260722.155928` — [REMEMBER git nib after STOA294](20260722-155928_remember-git-nib-stoa294.bron) — pin 57aa4dbdcc08
- `20260722.155828` — [STOA293–294 tagged flip survey](20260722-155828_stoa293-294-tagged-flip-survey-round.bron) — bartis payload helper GREEN; barket twin next
- `20260722.155603` — [REMEMBER git nib after STOA292](20260722-155603_remember-git-nib-stoa292.bron) — pin d515b7dc0001
- `20260722.155546` — [STOA292 Survey seated](20260722-155546_stoa292-survey-seated.bron) — Lexicon Survey; inventary retired for Now
- `20260722.155357` — [inventary word pick survey](20260722-155357_inventary-word-pick-survey.bron) — Quin picks survey; inventory as plain default
- `20260722.155252` — [inventary word plain function](20260722-155252_inventary-word-plain-function.bron) — coined site-catalog pass; not dictionary English
- `20260722.155221` — [REMEMBER git nib after STOA291](20260722-155221_remember-git-nib-stoa291.bron) — pin a77e356968be
- `20260722.155211` — [STOA291 continue after Pixel eyes](20260722-155211_stoa291-continue-after-pixel-eyes-checkin.bron) — lean A tagged `$%` flip inventary
- `20260722.155031` — [REMEMBER git nib after STOA290](20260722-155031_remember-git-nib-stoa290.bron) — pin 0443b2f6150a
- `20260722.155018` — [STOA289–290 Pixel LIVE eyes](20260722-155018_stoa289-290-pixel-live-eyes-round.bron) — pack+install GREEN; live root distinct
- `20260722.154745` — [REMEMBER git nib after STOA288](20260722-154745_remember-git-nib-stoa288.bron) — pin 611840f5b5f8
- `20260722.154726` — [STOA288 after HAWM rest resume check-in](20260722-154726_stoa288-after-hawm-rest-resume-checkin.bron) — lean A Pixel LIVE eyes
- `20260722.154549` — [REMEMBER git nib after STOA287](20260722-154549_remember-git-nib-stoa287.bron) — pin c6334634ad20
- `20260722.154539` — [STOA287 HAWM season rest](20260722-154539_stoa287-hawm-season-rest.bron) — lean B rest chosen; no next kg
- `20260722.154430` — [REMEMBER git nib after STOA286](20260722-154430_remember-git-nib-stoa286.bron) — pin df35bb113ce8
- `20260722.154415` — [STOA286 hawm0 stopped season fold](20260722-154415_stoa286-hawm0-stopped-season-fold.bron) — AVD down; harvest kept; rest
- `20260722.154221` — [REMEMBER git nib after STOA285](20260722-154221_remember-git-nib-stoa285.bron) — pin e9e5112a4f65
- `20260722.154150` — [STOA284–285 harvest session_root](20260722-154150_stoa284-285-harvest-session-root-round.bron) — HAWM1 root in hawm-harvest-v1
- `20260722.153914` — [REMEMBER git nib after STOA283](20260722-153914_remember-git-nib-stoa283.bron) — pin 3117f6db8ee9
- `20260722.153850` — [STOA283 host GREEN check-in sized](20260722-153850_stoa283-host-green-checkin-sized.bron) — lean A HAWM1→root; AVD still up
- `20260722.153734` — [REMEMBER git nib after STOA282](20260722-153734_remember-git-nib-stoa282.bron) — pin 1a5850d0fa34
- `20260722.153717` — [STOA281–282 host boot harvest GREEN](20260722-153717_stoa281-282-host-boot-harvest-green-round.bron) — host onpath GREEN; serial field; root next
- `20260722.153509` — [REMEMBER git nib after STOA280](20260722-153509_remember-git-nib-stoa280.bron) — pin ed85b9541e21
- `20260722.153448` — [STOA279–280 emulator serial pin](20260722-153448_stoa279-280-emulator-serial-pin-round.bron) — Pixel raced bare adb; pin emulator-*; host retry
- `20260722.153045` — [README stamp fix after STOA278 pin](20260722-153045_readme-stamp-fix-stoa278.bron) — restore index stamp
- `20260722.153025` — [REMEMBER git nib after STOA278](20260722-153025_remember-git-nib-stoa278.bron) — pin 6c939d171374
- `20260722.152849` — [STOA277–278 boot harvest chain](20260722-152849_stoa277-278-boot-harvest-chain-round.bron) — onpath authored; harvest half GREEN; host KVM for full
- `20260722.152716` — [REMEMBER git nib after STOA276](20260722-152716_remember-git-nib-stoa276.bron) — pin ee27364f841e
- `20260722.152631` — [STOA275–276 HAWM log harvest](20260722-152631_stoa275-276-hawm-harvest-round.bron) — hawm-harvest-v1; boot→harvest next
- `20260722.152450` — [REMEMBER git nib after STOA274](20260722-152450_remember-git-nib-stoa274.bron) — pin 450cf2f9afdf
- `20260722.152404` — [STOA274 after Dexter Sala finish check-in](20260722-152404_stoa274-after-dexter-sala-finish-checkin.bron) — season turn; HAWM 1A inventary next
