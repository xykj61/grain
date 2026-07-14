# Tasks — The Granular Plan

**Language:** EN
**Last updated:** 2026-07-13 (compass align landed · git nib **5c06253**; local macOS fork Pass 1 `20260713.201910`)

## Local macOS fork — Pass 1 landed `20260713.201910`, Pass 2 open

*A parallel thread, distinct from the product laps below: Kaeden's Mac-hosted `~/urbit` clone, layered over `urbit/urbit` and `urbit/vere` histories under the `xykj61` identity, diverging from the Urbit Foundation on purpose.*

- [x] Mirror-backup `urbit/urbit` and `urbit/vere` to `~/backups/` before any destructive move
- [x] Rebuild `~/urbit` — fresh `urbit/urbit` history at top level, `veganreyklah2` content moved into its place, `old/` holding the original urbit/urbit tree plus a legacy Oct-2025 personal collection (`nockchain`, `urbit.org`) Kaeden asked to nest rather than discard
- [x] Rebuild `~/urbit/vere` — `.git` relocated to `~/.git-vere-backup/` (outside the project), original content under `vere/old/`
- [x] Generate a clean `keatondun@gmail.com` ed25519 identity (2 SSH keys + 1 GPG signing key) and wire it into `~/urbit`'s **local** git config (not global — the global `~/.ssh/config` host aliases already belong to a different identity)
- [x] Add macOS Finder/Spotlight/AppleDouble ignore family to `.gitignore` beside the existing Linux-host `.DS_Store` line; allow-list `old/` and `vere/`
- [x] Seat a Pacific Time (Reno, NV) stamp convention for this local clone — [`context/specs/20260713-201910_pacific-time-local-clone-convention.md`](../context/specs/20260713-201910_pacific-time-local-clone-convention.md)
- [ ] **gh CLI auth for `xykj61`** — device-flow login started; Kaeden completing the browser step
- [x] Add new SSH/GPG public keys to the `xykj61` GitHub account (via `gh`) and Codeberg account (Kaeden, by hand) — both verified `20260713`–`20260714`
- [x] Create `xykj61/urbit` on GitHub and Codeberg, point `~/urbit` remotes at them — pushed and signature-verified on both forges at commit `def0d3c7`
- [x] **Pass 2, study 1** — macOS enclosure (Seatbelt/`sandbox-exec`) and QEMU-vs-`Virtualization.framework` — [`external-research/20260713-202929_macos-enclosure-and-qemu-vs-vz-study.md`](../external-research/20260713-202929_macos-enclosure-and-qemu-vs-vz-study.md); finding: keep QEMU + `-accel hvf` for the existing wire labs (lowest disruption, ARM64-native already), Pond's macOS enclosure wants its own Rye/Rishi SBPL-profile seam (real work, not a horizon) — study only, no lap opened
- [ ] **Pass 2, remaining:** Azimuth contract address confirmation (web search, current date) and a Comlink↔Ethereum design sketch; `urbit/vere` issue triage via `gh` for recreation in the new fork

### SOURCE.md ai-jail → macOS: granular adaptation (opened `20260713.211800`)

*Cursor ships as a native `.app` on macOS with a `cursor` CLI wrapper (Homebrew-installed, confirmed on this Mac) — no AppImage, no `squashfs-root/AppRun`. The `--user-data-dir` / `--extensions-dir` flags `tools/cursor-jail.sh` already relies on exist unchanged in the macOS build, so the project-local state-directory model ports directly; only the sandbox layer itself (`bwrap` → Seatbelt) and the launch target (`AppRun` → `cursor`/`Cursor.app`) need new code.*

- [ ] Author `tools/macos_sandbox_profile.rish` — a Rye/Rishi seed that renders an SBPL `(deny default)` profile from named allow-paths (project dir read+write, `/System` and toolchain paths read-only, one coarse network allow/deny switch), mirroring the `agent-jail`/`mkke/seatbelt` shape named in the study
- [ ] Author `tools/cursor-jail-macos.sh` — execs `sandbox-exec -f <generated .sb> -- cursor --user-data-dir="$CURSOR_STATE/user-data" --extensions-dir="$CURSOR_STATE/extensions" "$REPO"`, same `enclosure.conf` variables as the Linux launcher where they still make sense
- [ ] Witness: confirm a write attempt outside the project directory is denied under the profile, a write inside succeeds, and the network switch actually blocks/allows a real connection — same spirit as `tools/lane_kvm_refuse.rish`'s refuse-witness pattern
- [ ] Decide and document the private-`$HOME` equivalent — macOS has no `--private-home` primitive; likely answer is a prepared substitute `HOME` directory pointed at via `HOME=` before the `sandbox-exec` call, scoped only to the launched process's environment
- [ ] Extend `context/specs/enclosure-editors.md` with a macOS section alongside the existing Ubuntu/NixOS ones
- [ ] Extend `SOURCE.md` Step 6 and Step 9 with a macOS variant path once the above is witnessed — not before, so the guide never describes an untested command
- Session log: [`session-logs/20260713-201910_local-fork-pass1-restructure.bron`](../session-logs/20260713-201910_local-fork-pass1-restructure.bron)

## Now — product nib **430** · suite nib **433** · proven-seat · enclosure A→B · `lane_kvm`

**Standing green:** product nib **430** — Open Asks civic sight. Suite nib **433** — receipt-verify Wasmtime + signed-Kumara parity append ch.2. Proven-seat **G0-complete** (`004012`) · **G1 closed digest-grade** `204549` · **`lane_kvm` on-path G0-complete GREEN** `20260712.140403` (phase A GRUB · phase B QMP glass 2359312 B · refuse restored). Enclosure pair **complete on metal** — refuse GREEN (jail) · permit GREEN (Framework) · refuse-probe restored. Disposition **A-narrow → B** [`090512`](../counsel/20260712-090512_claude-ruling-enclosure-ai-jail-then-pond.md). Bron session-log law seated. **Nib** seated. Git nib **`b31756c`**. Teacher ai-jail **v1.12.0**. argv-direct witness build law Claude-affirmed `144519`. Encrypt-to-future-identity horizon park. IronBeetle 34 · five gaps. Metal parity chaptered **GREEN** — host re-pin **`20260712.193958`** (both chapters · full suite under Env ceiling). **Docs keeper** GREEN `223300` · [`docs/`](../docs/README.md) shelf complete. **Parity word** landed `20260713` — living_docs_lint advisory ch.1 · signed-Kumara append ch.2.

**Landed (`140403` host):** `rishi run tools/lane_kvm_onpath_host.rish` — permit green + refuse restored on Framework metal. Artifacts under gitignored `tools/.cache/proven-seat/`.

**Landed (`193958` host):** `rishi run tools/parity.rish` tee — chapter 1 GREEN · chapter 2 GREEN · full witness suite GREEN. Log `tools/.cache/parity-host.log`. Fresh-sitting first act closed.

**Ordered next (fresh sitting `20260713` · season held · follow compass):**
1. ~~Fresh Framework sitting — first act: metal parity re-pin~~ **done `193958`**
2. ~~**G1**~~ — **closed digest-grade** `204549`
3. ~~**Pond** enclosure · exit freeze · master-seal~~ — **latch rests** `214200`
4. ~~**Signed-Kumara**~~ — **resting GREEN** `220400` · seam-C law named · Rye-body shim parked
5. ~~**Docs compression layer**~~ — **complete** · `living_docs_lint.rish` seated `222800` · keeper folds **GREEN** `223300`
6. ~~**Parity word**~~ — **landed** `20260713` · living_docs_lint advisory ch.1 · signed-Kumara append ch.2 · suite nib **433**
7. **Forge courtesy** — ~two minutes
8. **G2 naming** — seL4-kernel-swap · hw-kernel · Sculpt-integration (proven-seat ladder warm; word today never named)
9. **Named supersede build word** — only then · frozen criteria [`210800`](../active-designing/20260712-210800_pond-supersede-exit-criteria.md)
10. Route two / libsodium — parked · Rye-body C-shim on trigger (guest logic outgrows seam-C · or second Genode guest)

**Parked — lane inward Route two:** nest bwrap + `--dev-bind /dev/kvm` for proven-seat only. **Graduation trigger (Claude `144519`):** open when G1’s QEMU cadence makes the hand one-shot the bottleneck (lane’s second consumer), or at the autonomous-pipeline word — whichever first. Do not patch teacher ai-jail.

**Metal parity pin (chaptered):** suite **GREEN** — 2 chapters under Env[256]; composition **324** GREEN say-lines (chaptered claim); suite nib **432**; **host re-pin GREEN** `20260712.193958` at git nib `826bcea`. wasmtime via PATH or `tools/.cache/wasmtime/wasmtime` (31.0.0).

| Priority | Item | Status | Notes |
|----------|------|--------|-------|
| **1** | **OCapN idiom beside Comlink** | **Landed** `053324` | ER [`053324`](../external-research/20260712-053324_ocapn-beside-comlink.md); Door 3 design conclusion + test plan · product **430** · suite later **431**/**432** |
| **2** | **Component-model target — one seed** | **Landed** `054135` | ER [`054135`](../external-research/20260712-054135_component-model-one-seed.md); pick = `receipt_core` verify-witness |
| **3** | **Genode / seL4 guest for Rye userland** | **Landed** `054342` | ER [`054342`](../external-research/20260712-054342_proven-seat-guest-genode-sel4.md); guest never merger; G0–G3 sketch |
| **4** | **GNU Taler for Linengrow giving lane** | **Landed** `054521` | ER [`054521`](../external-research/20260712-054521_taler-giving-lane-asymmetry.md); private payer · transparent payee |
| — | **CapTP as fold carriage** | **Declined** `054650` | Spec [`054650`](../context/specs/20260712-054650_captp-as-fold-carriage-declined.md) — sealed datagram stays carriage |
| — | **Giving-lane T0** | **Seated** `054650` | Invariant in [`money-close-to-home`](../foundations/20260629-014512_money-that-stays-close-to-home.md) |
| — | **Giving-lane T1** | **Landed** `054942` | OA stipend field map [`054942`](../active-designing/20260712-054942_giving-lane-t1-open-asks-field-map.md) — amount/`from` public = top gaps |
| — | **Spritely institutional ally** | **Parked** | Teacher now (gratitude/silo); ally after two-sided green |
| — | **Encrypt-to-future-identity** | **Horizon park** `114600` | Keep capability · decline VetKeys quorum; beside T3 / OCapN — RTAC |
| — | **Consumer-edge pass / Door 3** | **Landed** tip **431** · product **430** · suite **431** `063213` | `granary/consumer_edge_pass.rye` · witness GREEN — hammock [`063213`](../active-designing/20260712-063213_door3-consumer-edge-pass-hammock.md) |
| — | **Component compile lap** | **Landed** tip **432** · product **430** · suite **432** `063558` | WIT + wasm guest under Wasmtime — hammock [`063558`](../active-designing/20260712-063558_receipt-verify-wasm-hammock.md) |
| — | **Proven-seat G0–G3 metal** | **G0-complete GREEN** `004012` · **`lane_kvm` on-path GREEN** `140403` · refuse GREEN · **G1 closed digest-grade** `204549` · home `vendor/genode` | Hammock [`proven-seat-guest-hammock.md`](../active-designing/proven-seat-guest-hammock.md); Pond next · signed lap pre-shaped |
| — | **Giving-lane T2** | **Wire opened** `071405` | Choice [`062656`](../active-designing/20260712-062656_giving-lane-t2-choice-brief.md) · wire note [`giving-lane-t2-courtesy-wire.md`](../active-designing/giving-lane-t2-courtesy-wire.md); composition witness ahead |
| — | **Steep published-set sentence** | **Seated** `071405` | Living [`steep.md`](../active-designing/steep.md) — peer-offer gate; Granary precedent |
| — | **Bud / mudra names** | **Seated** `062656` | Spec [`061012`](../context/specs/20260712-061012_bud-and-mudra-names-seated.md); `tally/bud.rye` · `slcl4_mudra.rish` |
| — | **Cloud signing key** | **Seated** `062656` | PUBKEYS Cursor cloud lane-key `SHA256:/ZGdxqU+…` |
| — | **Post–Season-B hygiene** | **This lap** | Collision-guard · living-vs-dated · dated_guard · toolchain pin · product **430** · suite **432** |
| — | **Rest bench (commerce)** | **Parked** | Live TB · W1/seam B Rest-until unchanged |

- [x] **Seam study 1 — OCapN idiom beside Comlink** — [`053324`](../external-research/20260712-053324_ocapn-beside-comlink.md)
- [x] **Seam study 2 — component-model target for one existing seed** — [`054135`](../external-research/20260712-054135_component-model-one-seed.md); **pick: `receipt_core`**
- [x] **Seam study 3 — Genode / seL4 guest witness for Rye userland** — [`054342`](../external-research/20260712-054342_proven-seat-guest-genode-sel4.md); **guest, never merger**
- [x] **Seam study 4 — GNU Taler for the giving lane** — [`054521`](../external-research/20260712-054521_taler-giving-lane-asymmetry.md)
- [x] **CapTP-as-fold formal decline** — [`054650`](../context/specs/20260712-054650_captp-as-fold-carriage-declined.md)
- [x] **Giving-lane T0** — private payer · transparent payee in [`money-close-to-home`](../foundations/20260629-014512_money-that-stays-close-to-home.md)
- [x] **Giving-lane T1** — OA stipend field map [`054942`](../active-designing/20260712-054942_giving-lane-t1-open-asks-field-map.md); top gaps: public `amount` and `from` on completion
- [ ] **Parked — Spritely ally name** — teacher in gratitude now; ally only after two-sided witness
- [ ] **Parked — encrypt-to-future-identity** — horizon beside T3 / OCapN (`114600`); keep capability; decline threshold-derivation quorum (VetKeys packaging)
- [x] **Door 3 first green** — in-process pass admits published read + signed submit; refuses unpublished / lying / lying pass — tip **431** `063213`
- [x] **Component compile lap** — `receipt_core` → WIT `receipt-verify` → Wasmtime green + tamper refuse — tip **432** `063558`
- [x] **Proven-seat G0 (Kaeden word)** — Sculpt 26.04 pinned + QEMU reaches GRUB loading (TCG) — [`proven-seat-guest-hammock.md`](../active-designing/proven-seat-guest-hammock.md) · `tools/proven_seat_g0.rish` (`071405`)
- [x] **Proven-seat G0-complete (Framework host KVM)** — Leitzentrale Components graph + glass witness — `tools/proven_seat_g0_complete.rish` (`004012`)
- [x] **Claude ruling — ai-jail widen vs Pond supersede** — **Answered** A-narrow → B [`090512`](../counsel/20260712-090512_claude-ruling-enclosure-ai-jail-then-pond.md)
- [x] **Metal parity pin (chaptered)** — suite **GREEN** · **324** GREEN say-lines · 2 chapters · tip **432** · Env[256] cleared (`parity_ch01`/`parity_ch02` + thin orchestrator)
- [x] **RTAC — parity TooManyBindings** — **Resolved** by chaptering (fresh Env per chapter); not by raising the binding ceiling
- [x] **`lane_kvm` + paired refuse** — off by default; `tools/lane_kvm.sh`; refuse GREEN `113900`; D-Bus escape retired [`113900`](../active-designing/20260712-113900_lane-kvm-retire-dbus-escape.md); on-path scripts ready (`proven_seat_g0_complete_jailed.rish`) — host one-shot when `/dev/kvm` granted
- [x] **Proven-seat G1** — **closed digest-grade** `204549` · serial GREEN · `vendor/genode` submodule @ `492a510…` · probe + guest + jailed TCG witnesses · signed Ed25519 next named lap
- [x] **Pond enclosure witness baseline** — **GREEN** `205600` · sharpened `210800` · two-column scorecard · three-door bus · bar5 exactly-one secret
- [x] **Pond supersede exit criteria** — **freeze affirmed** [`210800`](../active-designing/20260712-210800_pond-supersede-exit-criteria.md) · master-seal `213600` · **N = six-over-seven** · season closed until master-signed exit bron
- [x] **Pond column-two probes** — **landed** refuse-until-candidate `tools/pond_enclosure_col2_probes.rish` · claim nothing · build word still required
- [x] **Pond master-seal** — **landed** `tools/pond_exit_bron_master_seal.sh` · VALIDSIG `0646 2132…` alone
- [x] **Monocypher vendor pin** — **landed** `vendor/monocypher` @ 4.0.3 / `ab2b16d…` · fetch witness GREEN
- [x] **Signed-Kumara** — **GREEN** `215400` · pair verify+refuse · jailed TCG · grade signed-Kumara · G1 digest stays
- [x] **`lane_kvm` on-path G0-complete green** — **GREEN** `140403` host — `lane_kvm_onpath_host.rish` · phase A GRUB · phase B glass 2359312 B · refuse restored; host metal parity re-pin **GREEN** `193958`
- [x] **Brushstroke × Linengrow weave silo** — [`091012`](../active-designing/20260712-091012_brushstroke-linengrow-weave-silo.md); Flax·Bark·Oat·Walnut proposed
- [ ] **Brushstroke tokens + witness** — `tokens.rye` · `brushstroke_tokens.rish` (on word)
- [x] **Giving-lane T2 wire opened (Kaeden word)** — courtesy composition note [`giving-lane-t2-courtesy-wire.md`](../active-designing/giving-lane-t2-courtesy-wire.md); glass witness still ahead
- [x] **Steep published-set sentence** — living [`steep.md`](../active-designing/steep.md) (`071405`)
- [x] **Bud / mudra names seated** — `tally/bud.rye` · `tools/slcl4_mudra.rish` · Mudra released from Pottery alternates (`062656`)
- [x] **Cloud Cursor lane-key in PUBKEYS** — `SHA256:/ZGdxqU+…` (`062656`)
- [x] **RTAC ledger plain name** — `work-in-progress/ready-to-ask-claude.md` (`062656`)
- [x] **Giving-lane T2 choice brief** — courtesy now · proof as T3 (`062656`)
- [x] **Post–Season-B hygiene** — collision-guard · living-vs-dated · dated_guard · toolchain pin in parity/receipt_verify_wasm · hammock living twin · product tip **430** · suite tip **432** (`065146` bench-clock)

- [x] **Consumer-surface protection audit (`060112`)** — the innocent surfaces walked for user protection. **What held:** Open Asks consent is opt-in, self-sovereign, non-overwritable (applicant's own key only, post-completion only, set-once, explicit-grant-only counting, `.none`==`.withhold`==excluded — silence means privacy); civic sight displays aggregates only with `withheld=excluded` visible; Granary sharing is explicit-signed-act only; input glass bounded (400B, silent-refuse correct for typed input); Steep design already privacy-leaning (named peers, no open swarm). **Gap found + closed:** the fetch-by-digest wire (`resin_serve_delivery.rye`) served ANY digest without consulting the registry — digest-as-capability; exposed nothing today (store held only published resins) yet sat one step from a real leak since digests travel into public logs. Fix built + witnessed: `granary_core.rye` gains `digest_is_published` + `serve_resin_published` (+ `error.NotPublished`); both wire paths (selftest round-trip AND live UDP demo host) now gate on the published set; new unwelcome path proves an unpublished resin in the same store is refused over the wire; witness asserts `unpublished digest refused` so parity (line 714) guards it permanently. All GREEN on bench. **Principle seated in code comment:** a digest is an address for verifying content, never a capability for reaching it. Counsel `060112`.
- [x] **Steep design-stage note (`060112`)** — seated in living [`steep.md`](../active-designing/steep.md) (`071405`): serving side gates on *pieces explicitly offered to that named peer*, never *any digest the local store holds*; Granary `serve_resin_published` is the precedent.

- [x] **Cursor-bot arc audit (`053412`)** — audited tips 379→430 (PRs #85–#112). **Money code sound:** `linengrow/mala_core.rye` conservation traced by hand — mint is issuer-only (double-guarded: `from`==issuer AND sig verifies against issuer key, holder cannot mint), send strictly conserves (debit-then-credit, underflow-refused); MALA M1 witness GREEN on bench. Naming discipline held (every new module — Granary/Mandi/Dimeroll/Anvil/Steep — has a dated seating spec); symlink hygiene held (5 `mala_core.rye` copies all symlink to one canonical, byte-identical); WOV well-witnessed (exit-honesty, TB-pin, host-seam, dual-monarch all in parity). **Fix done + verified, not just recommended:** split three over-length WOV money functions — `publish_root` (72→32), `publish_root_dual` (73→36), `accept_exit_dual` (74→68) — via three shared leaf helpers (`build_attested_bundle`, `write_root_memo`, `append_signed_line`); both WOV witnesses GREEN against refactored code, confirming behavior-preserving. **Left for next hand (named honestly):** `wov_core.rye:run_selftest` (77, test scaffold) and `open_asks_lap5_delivery.rye:run_poster` (73, older orchestration) — stopped at core money-path functions rather than refactor code unverifiable in one pass. Counsel `053412`.
- [x] **WOV TB cross-check seam retired `055800` (Kaeden approved `055112`)** — pure-Rye WOV core kept (`wov_exit_honesty`, `wov_dual_monarch` only in living parity). Optional TigerBeetle pin/host seam marked superseded dated record (`tools/wov_tb_pin.rish`, `tools/wov_tb_host.rish`, `tools/wov_tb_ensure_binary.sh`, `tools/wov_tb_repl_lab.sh`, `linengrow/wov_tb_host.rye`); two `wov_tb` stanzas removed from `parity.rish`. `gratitude/tigerbeetle` stays whole on the shelf. Seam revivable later if MALA log-and-fold ever needs TB throughput. Counsel [`055112`](../counsel/20260711-055112_claude-counsel-wov-tigerbeetle-recommendation.md).

- [x] **Realidream thin-view exception (`021112` → re-scoped `202427`)** — chain-read removed `152612`; renders **local** MALA mint + WOV exit-bundle fixtures through SLC-2a drawn terminal (`thinviewtest`); no new input, no Pond policy, no Dexter graduation; `tools/realidream_thin_view.rish`; parity **202**; prompt [`202427`](../expanding-prompts/20260709-202427_realidream-thin-view-local-facts.md)

- [x] **Commit-message mention hygiene** — GitHub linkifies `@memcpy` in commit subjects (a real, unrelated account), checked against GitHub's own Nov 2025 changelog: notification side-effect removed, cosmetic linkification remains. `.claude/rules/git-signing.md` + newly-written `.cursor/rules/git-signing.mdc` (the latter didn't exist before, unlike every other rule's matching pair) now say: no bare `@builtin` in commit subject/body text; file content and documentation keep `` `@memcpy` `` exactly as styled. History not rewritten — commit messages are dated artifacts under the same one-clock law protecting session logs. Counsel `011912`.
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Lens:** TAME — safety, performance, joy; SLC; Gall's Law

*This is the living, granular plan — the bench where the current laps are shaped. `ROADMAP.md` holds the why and the order; this file holds the what-now. It is **edited in place**: a task is checked when it lands, and the record of how it landed accretes in `../session-logs/`. Checked items are swept to a session log and pruned here when a section grows heavy. What is next lives here; what happened lives there.*

**Legend:** `[ ]` to do · `[~]` in flight · `[x]` done, pending sweep to a session log.

**Tracks:** **Rye OS** grows the system. **Linengrow** grows the first whole built on it. **Ground** is the shared discipline beneath both.

**Landed through 2026-06-30** (detail in `../session-logs/`): SLC-2a Laps 1–2 (`5b3a5a4`); yonder pass nine; Caravan path + Comlink hosted wire (`dc26396`→`8d720c6`); Tally/Brushstroke foundation seeds in parity (**138**); prior: SLC-1; TAME hardening.

---

## Now — Season Linengrow-via-Comlink

**Ground lap landed `20260705.203144` — parity **153**:**

- [x] **TWO_ROOMS seated** — [`context/TWO_ROOMS.md`](../context/TWO_ROOMS.md) reviewed and kept; doorway from this stamp forward
- [x] **Canonical gloss spec** — [`context/specs/20260705-203144_canonical-glosses.md`](../context/specs/20260705-203144_canonical-glosses.md)
- [x] **Doorway witness** — `tools/two_rooms_doorway.rish` + `tools/fixtures/two_rooms_doorway_scan.sh`; wired parity **153**
- [x] **LEXICON rows** — Two rooms · Canonical
- [x] **ROADMAP/TASKS hygiene (A8)** — zip **47** · astrology silo bench closed (`e8d1919`) · season line recorded

**Device wire landed `20260705.235412` — parity **154**:**

- [x] **Comlink device wire** — sub-laps 1–3 GREEN; `tools/comlink_device_wire.rish` wired parity **154**
- [x] **Dependency survey** — [`external-research/20260705-235412_device-wire-dependencies-down-to-caravan-tally.md`](../external-research/20260705-235412_device-wire-dependencies-down-to-caravan-tally.md)

**SLC-L2 landed `20260706.000812` — parity **155**:**

- [x] **SLC-L2 sealed delivery** — `linengrow/delivery.rye` + `tools/slcl2_receipt.rish`; hosted UDP + **device wire** virtio guests GREEN; parity **155**

**OA-L1 landed `20260706.010912` — parity **156**:**

- [x] **OA-L1 closed ask loop** — `linengrow/open_asks.rye` + `tools/open_asks_lap1.rish`; post → apply → accept → complete → verify GREEN

**OA-L2 landed `20260706.011512` — parity **157**:**

- [x] **OA-L2 cross-party delivery** — hosted UDP + device wire **request + application** hops GREEN

- [x] **OA-L5 accept, complete, consent wire** — finishes the open-asks Comlink path; hosted **38488**/**38489**; device **15561–15563**; parity **184**

**OA-L3 escrow landed `20260706.014512` — parity 158:**

- [x] **OA-L3 escrow lap 1** — hold at acceptance, release at completion; **Nyasa** escrow account; conservation, no negatives, no double-hold or double-release, poster-signed, internal test units; welcome and five unwelcome paths in the selftest; brief [`20260706-013012_open-asks-escrow-hammock.md`](../active-designing/20260706-013012_open-asks-escrow-hammock.md)
- [x] **OA-L3 escrow lap 2** — `linengrow/open_asks_escrow_delivery.rye` + four virtio guests + `comlink/run_open_asks_escrow_wire_lab.sh`; hosted UDP (ports **38476**/**38477**) and device wire (ports **15559**/**15560**) hold + release hops GREEN; `tools/open_asks_lap3.rish` extended (parity **158** unchanged); `wire_capacity` **528** / `max_frame` **554** for escrow payload headroom
- [x] **Claude bench prepared and run** — [`expanding-prompts/20260706-013512_claude-oal3-escrow-first-lap.md`](../expanding-prompts/20260706-013512_claude-oal3-escrow-first-lap.md); lap 1 implemented and verified on the bench, parity pinned on metal

- [x] **OA-L4 reputation-as-fold lap 1** — `foldReputationLog` + applicant-signed consent facts (`grant` / `withhold`); witness bolt (3 completions, 2 consented, 1 withheld); `tools/open_asks_lap4.rish`; parity **167** (ruling `20260706.232812` — MALA graduation fires at escrow's second consumer, not a rival lap)

**Next climb (counsel `044112` complete):** MALA graduation **on hold** (trigger decides). Brix · Pond · continuity · sourcing note each wait their own word. Extended-run stability deferred until something runs unattended for real.

- [x] **TigerBeetle alignment arc** — **closed** (`20260707.213212`); all TAME ratchets **0** on `tame_style_check`; capstone counsel [`213212`](../counsel/20260707-213212_claude-counsel-tigerbeetle-arc-closed.md); AST-grade machine canon waits on Zig parser per original study

## Next bench (counsel [`222812`](../counsel/20260707-222812_claude-counsel-open-questions-final-pass.md) → [`015312`](../counsel/20260708-015312_claude-counsel-kumara-open-asks-cluster.md) · Realidream [`021912`](../counsel/20260708-021912_claude-counsel-realidream-zig016-brix.md))

**Direction:** Open Questions closed on paper. **Kumara arc complete** — ratchet **0**. **MALA/WOV path realigned** `152612`. **MALA M1–M2b landed**; **SLC-L4 Sigma + W0 landed**; **WOV lap 1 + pin + seam A + dual D1 landed**; **Realidream thin view landed**; **Dimeroll laps 1–3 + Linengrow sight view landed**; **Inference stack laps 0–1 + Scribble lap 1 landed**; **Tablecloth query wire landed** `140500`; **Realidream query view landed** `141200`; **Realidream forge view landed** `143000`; **Amphora lap 1 + forge query landed** `143500`; **Amphora lap 2 pour/scrub landed** `143726`; **Amphora lap 3 Comlink fetch landed** `144309`; **Amphora device wire landed** `144833`; **Amphora Kumara vessel stamp landed** `145843`; **Amphora Amber vessel seal landed** `153745`; **Amphora resin chunk landed** `154300`; **Pond customs landed** `161125`; **Amphora purchase delivery landed** `161358`; **Granary name seated** `163043`; **Granary four doors through Exchange listing** through `165348`; **Mandi name + lap 1** `165634`; **Granary device-wire resin serve** `170132`; **Mandi floor view** `170700`; **Granary Exchange view** `170838`; **Mandi listing settle** `171202`; **commerce compass hygiene** `171707`; **Granary weave settle** `172625`; **Mandi settle view** `172955`; **Granary settle view** `173353`; **Kitchen twin LEXICON** `173752`; **Tablecloth query device wire** `174217`; **Realidream query device view** `174752`; **Realidream query unified view** `175447`; **compass climb** (forge device/unified · Lantern lap 1 · assist lap 2) `180111`; **compass climb** (Lantern allow-list · Scribble rish · assist sight · forge query unified) `180747`; **compass climb** (forge query device · Lattice reshape · Lantern temp/seed · corpus view) `181653`; **compass climb** (Lattice reduce · Scribble headings · scribble view · assist rye/rish) `182118`; **compass climb** (Lattice scale · corpus prefix · assist sight kinds · exception view) `182502`; **kitchen-twin shelf** (shipping + custody + thin-edge spine + two-roofs commerce); **universal foundations affirmed**. Parity **267**. Commerce rest bench: live TB parked until brief.

| Priority | Item | Status | Notes |
|----------|------|--------|-------|
| **1** | **Kumara extraction** | **Closed** | ratchet **0**; virtio + product surface GREEN; scan precision fix `030200` |
| **2** | **MALA M1–M2** | **Landed** | M1 **198**; M2 hosted **199**; M2b device wire `201734`; counsel [`191634`](../counsel/20260709-191634_grok-counsel-mala-m2-open.md) |
| **3** | **SLC-L4 Sigma** | **Landed** | fixed-tier prove/verify; parity **200**; prompt [`031612`](../expanding-prompts/20260709-031612_slcl4-lap1-fixed-tier-sigma-protocol.md) |
| **4** | **WOV exit honesty** | **Landed** | in-memory lap 1; parity **201**; spec [`200443`](../context/specs/20260709-200443_wov-exit-honesty.md) |
| **5** | **Realidream thin view** | **Landed** | local fixtures → Skate; parity **202**; prompt [`202427`](../expanding-prompts/20260709-202427_realidream-thin-view-local-facts.md) |
| **6** | **WOV TB pin presence** | **Landed** | rev `59f2b99` witnessed; no client link; parity **203**; prompt [`203527`](../expanding-prompts/20260709-203527_wov-lap2-tigerbeetle-pin-presence.md) |
| **7** | **WOV TB host seam A** | **Landed** | projection → exit honesty; binary ensure; live REPL skip-or-green; parity **204**; prompt [`204026`](../expanding-prompts/20260709-204026_wov-lap2b-tb-client-wrapper.md) |
| **8** | **SLC-L4 lap 2 width** | **W0 cleared** | review [`224426`](../counsel/20260709-224426_grok-counsel-slcl4-w0-lap1-review.md); W1/W2 still gated [`224325`](../context/specs/20260709-224325_slcl4-lap2-width.md) |
| **9** | **WOV dual monarch D1** | **Landed** | twin log lines; solo refused; parity **205**; [`224531`](../context/specs/20260709-224531_wov-dual-monarch.md) |
| **10** | **MALA `kind` field** | **K0 cleared** | memos through M3; K1 gated [`225159`](../context/specs/20260709-225159_mala-kind-field.md) |
| **11** | **Thin view / Dexter** | **Exception affirmed** | not a second consumer; [`225343`](../context/specs/20260709-225343_thin-view-dexter-exception.md) |
| **12** | **Evening leftovers** | **Cleared** | removal headers on-touch; M0 spec not required; keep-going default; [`225508`](../counsel/20260709-225508_grok-counsel-evening-close-leftovers.md) |
| **13** | **W1 + seam B** | **Rest-until** | reopen triggers named; [`225614`](../counsel/20260709-225614_grok-counsel-w1-and-seam-b-soak.md) |
| **14** | **Compass rose + twin-keys story** | **Landed** | jail-safe clarity; parity **206**; [`230414`](../external-research/20260709-230414_twin-keys-and-the-exit-bundle.md) |
| **15** | **Graduation plainly + pointer hygiene** | **Landed** | Jul 2 kitchen twin [`231011`](../external-research/20260709-231011_graduation-rule-plainly.md); thin-edge + Amber + OWOG index; compass rose extended |
| **16** | **One-clock + resins plainly** | **Landed** | Jun 27 naming spine [`235921`](../external-research/20260709-235921_one-clock-plainly.md); cellar/vessel [`235931`](../external-research/20260709-235931_resins-cellar-vessel-plainly.md); compass rose pairs |
| **17** | **Learning plainly + universal affirm** | **Landed** | Civic candidate kitchen twin [`000725`](../external-research/20260710-000725_learning-chapter-plainly.md); aspiring/regenerative **Reviewed and kept**; zip 58 / expanding-prompts hygiene |
| **18** | **Settlement seat plainly** | **Landed** | Jul 6–7 dossier kitchen twin + supersession notes [`001249`](../external-research/20260710-001249_settlement-seat-plainly.md); external rail retired `152612` |
| **19** | **Metalsmoke plainly + affirm** | **Landed** | Kitchen twin [`002017`](../external-research/20260710-002017_metalsmoke-plainly.md); silo **Reviewed and kept**; audit-rule stale line cleared; LEXICON row |
| **20** | **Amber seasons + first-lap plainly** | **Landed** | Custody twin [`002422`](../external-research/20260710-002422_amber-seasons-plainly.md); shipping phrase [`002544`](../external-research/20260710-002544_first-lap-goes-green-plainly.md); Season LEXICON ask cleared |
| **21** | **Sealed crossing plainly** | **Landed** | Kitchen twin [`002952`](../external-research/20260710-002952_sealed-crossing-plainly.md) affirmed Landed; crossing metal plainly [`145313`](../external-research/20260710-145313_amphora-crossing-plainly.md); Amphora laps 1–3 |
| **22** | **Dimeroll lap 1** | **Landed** | Chart · journal · fold · unwelcome; `dimeroll/`; parity **207**; hammock [`125953`](../active-designing/20260710-125953_dimeroll-hammock.md) |
| **23** | **Dimeroll books view** | **Landed** | Trial balance → Skate via `booksviewtest`; parity **208**; prompt [`125953`](../expanding-prompts/20260710-125953_dimeroll-lap1-books-view.md) |
| **24** | **Dimeroll root + lap 2** | **Landed** | Own folder; P&L · BS · exception queue; parity **209**; [`131212`](../active-designing/20260710-131212_dimeroll-lap2-reports.md) |
| **25** | **Linengrow sight view** | **Landed** | Carriage + books on one Skate frame; `sightviewtest`; parity **210**; [`132548`](../active-designing/20260710-132548_dimeroll-lap3-sight-view.md) |
| **26** | **Inference stack lap 0** | **Landed** | Lattice · Scribble · Lantern · Anvil corpus · `assistviewtest`; parity **211**–**215**; [`133500`](../active-designing/20260710-133500_inference-stack-lap0-hammock.md) |
| **27** | **Inference stack lap 1** | **Landed** | Anvil corpus query · Lattice add; parity **216**–**217**; stamp `134200` |
| **28** | **Scribble lap 1** | **Landed** | `extract_rye_snippets` from session fixture; parity **218**; stamp `134800` |
| **29** | **Tablecloth query wire** | **Landed** | Comlink hosted filter (not GraphQL); parity **219**; hammock [`140500`](../active-designing/20260710-140500_comlink-view-filter-not-graphql.md) |
| **30** | **Realidream query view** | **Landed** | query-wire hits → Skate `queryviewtest`; parity **220**; thin-view exception family |
| **31** | **Realidream forge view** | **Landed** | Live Amphora pour → Skate `forgeviewtest` (`145313`); parity **221** path |
| **32** | **Amphora lap 1** | **Landed** | Module home `amphora/`; manifest entry + vessel; parity **222**; gate opened `143500` |
| **33** | **Forge query view** | **Landed** | Tablecloth-shaped forge hits → Skate; parity **223** |
| **34** | **Amphora lap 2** | **Landed** | Pour Amber season → carry far → cold scrub; 3-2-1 fixture; parity **224** |
| **35** | **Amphora lap 3** | **Landed** | Comlink hosted fetch-by-digest (38494/38495); parity **225** |
| **36** | **Amphora device wire** | **Landed** | Virtio vessel fetch (15571/15572); parity **226** |
| **37** | **Amphora vessel stamp** | **Landed** | Kumara `stamp_sig` on canonical vessel; parity **227** |
| **38** | **Amphora vessel seal** | **Landed** | Amber ChaCha20-Poly1305 on cargo; parity **228** |
| **39** | **Amphora resin chunk** | **Landed** | Large resin beyond one datagram (kind **0x33**); parity **229** |
| **40** | **Pond customs** | **Landed** | First policy lap — place / hold / refuse per Tilak; Amphora receipt gated; parity **230** |
| **41** | **Amphora purchase delivery** | **Landed** | Commerce delivery slip binds vessel parent + payment; parity **231** |
| **42** | **Granary name** | **Seated** | Weave-sharing surface (four doors); Mandi is the vessel floor — [`163043`](../context/specs/20260710-163043_granary-name-seated.md) |
| **43** | **Granary lap 1** | **Landed** | Registry · resolve `person/weave` · fold-clone · Scribble frame · lying sig refuse; `granary/`; parity **232**; stamp `163304` |
| **44** | **Granary weave view** | **Landed** | Resolve + Scribble → Skate `granaryviewtest`; parity **233**; stamp `163557` |
| **45** | **Granary lap 2 write gate** | **Landed** | Durable `publish` + reload; prior immutable; duplicate/lying refused; parity **234**; stamp `164237` |
| **46** | **Granary lap 3 Sharing** | **Landed** | Host serve + mirror clone; equal folds; missing/tamper refused; parity **235**; stamp `164514` |
| **47** | **Granary lap 4 resin wire** | **Landed** | Comlink serve (Amphora fetch wire reused); ports **38496**/**38497**; parity **236**; stamp `164944` |
| **48** | **Granary lap 5 Exchange** | **Landed** | Weave listing in MALA; receipt without identities; WOV settlement waits; parity **237**; stamp `165348` |
| **49** | **Mandi name + lap 1** | **Landed** | Vessel market floor seated; `vessel-listing-v1` + receipt; parity **238**; stamp `165634` — [`165634`](../context/specs/20260710-165634_mandi-name-seated.md) |
| **50** | **Granary lap 4b device wire** | **Landed** | Resin serve over virtio (15573/15574); same sealed bytes as hosted; parity **239**; stamp `170132` |
| **51** | **Mandi floor view** | **Landed** | Vessel listing → Skate `mandiviewtest`; five-line frame; parity **240**; stamp `170700` |
| **52** | **Granary Exchange view** | **Landed** | Weave listing → Skate `exchangeviewtest`; six-line frame; parity **241**; stamp `170838` |
| **53** | **Mandi listing settle** | **Landed** | `vessel-settle-v1` binds listing receipt + MALA/WOV payment; parity **242**; stamp `171202` — [`171202`](../context/specs/20260710-171202_mandi-listing-settle-seated.md) |
| **54** | **Commerce compass hygiene** | **Landed** | Kitchen twin + compass_rose packet; rest bench; stamp `171707` — [`171707`](../external-research/20260710-171707_granary-mandi-commerce-plainly.md) |
| **55** | **Granary weave settle** | **Landed** | `weave-settle-v1` binds Exchange receipt + MALA/WOV payment; parity **243**; stamp `172625` — [`172625`](../context/specs/20260710-172625_granary-weave-settle-seated.md) |
| **56** | **Mandi settle view** | **Landed** | Vessel settle → Skate `mandisettletest`; six-line frame; parity **244**; stamp `172955` |
| **57** | **Granary settle view** | **Landed** | Weave settle → Skate `settlevie`; six-line frame; parity **245**; stamp `173353` |
| **58** | **Kitchen twin LEXICON** | **Landed** | Plain-companion gloss seated; compass rose asserts; stamp `173752` |
| **59** | **Tablecloth query device wire** | **Landed** | Virtio filter request + response; ports **15575**/**15576**; parity **246**; stamp `174217` |
| **60** | **Realidream query device view** | **Landed** | Device-wire hits → Skate `querydeviceviewtest`; parity **247**; stamp `174752` |
| **61** | **Realidream query unified view** | **Landed** | Hosted + device hits → Skate `queryunifiedviewtest`; parity **248**; stamp `175447` |
| **62** | **Forge device view** | **Landed** | Amphora virtio fetch → Skate; parity **249**; stamp `180111` |
| **63** | **Forge unified view** | **Landed** | Hosted pour + device fetch → Skate; parity **250**; stamp `180111` |
| **64** | **Lantern lap 1 max_tokens** | **Landed** | Truncate + `stopped_reason length`; upgrades lap-0 witness; stamp `180111` |
| **65** | **Assist view lap 2 snippets** | **Landed** | Scribble fence count on Skate; parity **251**; stamp `180111` |
| **66** | **Lantern lap 2 allow-list** | **Landed** | `complete_allowed` model-hash gate; parity **252**; stamp `180747` |
| **67** | **Scribble lap 2 rish extract** | **Landed** | `extract_rish_snippets` from session fixture; parity **253**; stamp `180747` |
| **68** | **Assist sight view** | **Landed** | Carriage + assist fold → Skate `assistviewsighttest`; parity **254**; stamp `180747` |
| **69** | **Forge query unified view** | **Landed** | Hosted + device forge hits → Skate; parity **255**; stamp `180747` |
| **70** | **Forge query device view** | **Landed** | Device forge hits → Skate `forgequerydeviceviewtest`; parity **256**; stamp `181653` |
| **71** | **Lattice lap 2 reshape** | **Landed** | Row-major reshape + count assert; parity **257**; stamp `181653` |
| **72** | **Lantern lap 3 temperature+seed** | **Landed** | Request budget fields + fixture pin; parity **258**; stamp `181653` |
| **73** | **Anvil corpus view** | **Landed** | Rye query hits → Skate `corpusviewtest`; parity **259**; stamp `181653` |
| **74** | **Lattice lap 3 reduce_sum** | **Landed** | Full-matrix sum into 1×1; parity **260**; stamp `182118` |
| **75** | **Scribble lap 3 headings** | **Landed** | `extract_headings` from outline fixture; parity **261**; stamp `182118` |
| **76** | **Scribble outline view** | **Landed** | Headings → Skate `scribbleviewtest`; parity **262**; stamp `182118` |
| **77** | **Assist view lap 4 kinds** | **Landed** | Rye + rish snippet counts on Skate; parity **263**; stamp `182118` |
| **78** | **Lattice lap 4 scale** | **Landed** | Elementwise scale · shape assert; parity **264**; stamp `182502` |
| **79** | **Anvil corpus prefix view** | **Landed** | path_prefix pond/ → Skate; parity **265**; stamp `182502` |
| **80** | **Assist sight lap 2 kinds** | **Landed** | Rye + rish on carriage fold; parity **266**; stamp `182502` |
| **81** | **Dimeroll exception view** | **Landed** | Refused drafts → Skate `exceptionviewtest`; parity **267**; stamp `182502` |
| **82** | **Lattice lap 5 transpose** | **Landed** | Shape-asserted transpose; parity **268**; stamp `185542` |
| **83** | **Anvil corpus rish view** | **Landed** | kind rish → Skate `corpusrishviewtest`; parity **269**; stamp `185542` |
| **84** | **Scribble lap 4 paragraphs** | **Landed** | `extract_paragraphs` from outline; parity **270**; stamp `185542` |
| **85** | **Dimeroll P&L view** | **Landed** | Income statement → Skate `pnlviewtest`; parity **271**; stamp `185542` |
| **86** | **Lattice lap 6 mul** | **Landed** | Elementwise Hadamard mul; parity **272**; stamp `185947` |
| **87** | **Scribble paragraphs view** | **Landed** | Prose bodies → Skate `scribbleparaviewtest`; parity **273**; stamp `185947` |
| **88** | **Dimeroll BS view** | **Landed** | Balance sheet → Skate `bsviewtest`; parity **274**; stamp `185947` |
| **89** | **Lantern lap 4 top_p** | **Landed** | top_p range + fixture pin; parity **275**; stamp `185947` |
| **90** | **Lattice lap 7 fill** | **Landed** | Fill tensor with constant; parity **276**; stamp `190319` |
| **91** | **Dimeroll TB view** | **Landed** | Trial balance → Skate `tbviewtest`; parity **277**; stamp `190319` |
| **92** | **Scribble fence kinds view** | **Landed** | rye/rish/plain counts → Skate `scribblefenceviewtest`; parity **278**; stamp `190319` |
| **93** | **Lantern lap 5 err_stop** | **Landed** | err_stop fixture pin; parity **279**; stamp `190319` |
| **94** | **Lattice lap 8 copy** | **Landed** | Shape-asserted tensor copy; parity **280**; stamp `190800` |
| **95** | **Anvil corpus rye prefix view** | **Landed** | rye + pond/ → Skate `corpusryeprefixviewtest`; parity **281**; stamp `190800` |
| **96** | **Scribble lap 6 plain snippets** | **Landed** | `extract_plain_snippets` from fence_kinds; parity **282**; stamp `190800` |
| **97** | **Lantern lap 6 stop_sequence** | **Landed** | stop_sequence fixture pin; parity **283**; stamp `190800` |
| **98** | **Lattice lap 9 sub** | **Landed** | Elementwise subtract; parity **284**; stamp `191112` |
| **99** | **Dimeroll journal view** | **Landed** | Journal entries → Skate `journalviewtest`; parity **285**; stamp `191112` |
| **100** | **Scribble plain snippets view** | **Landed** | Unmarked fences → Skate `scribbleplainviewtest`; parity **286**; stamp `191112` |
| **101** | **Lantern lap 7 stop_sequence pin** | **Landed** | Request-side stop_sequence pin; parity **287**; stamp `191112` |
| **102** | **Assist view lap 5 plain+journal** | **Landed** | Plain fences + journal memos on assist fold; parity **288**; stamp `192018` |
| **103** | **Assist sight lap 3 plain+journal** | **Landed** | Plain + journal on carriage assist fold; parity **289**; stamp `192018` |
| **104** | **Linengrow sight lap 2 journal** | **Landed** | Journal memos on steward glass; parity **290**; stamp `192018` |
| **105** | **Lattice lap 10 neg** | **Landed** | Elementwise negate; parity **291**; stamp `192749` |
| **106** | **Dimeroll chart view** | **Landed** | Chart of accounts → Skate `chartviewtest`; parity **292**; stamp `192749` |
| **107** | **Anvil corpus tools prefix view** | **Landed** | tools/ → Skate `corpustoolsprefixviewtest`; parity **293**; stamp `192749` |
| **108** | **Lantern lap 8 prompt pin** | **Landed** | Request-side prompt pin; parity **294**; stamp `192749` |
| **109** | **Lattice lap 11 div** | **Landed** | Elementwise divide + zero refuse; parity **295**; stamp `193358` |
| **110** | **Scribble rye snippets view** | **Landed** | Rye fences → Skate `scribbleryeviewtest`; parity **296**; stamp `193358` |
| **111** | **Anvil corpus dimeroll prefix view** | **Landed** | dimeroll/ → Skate `corpuscandyprefixviewtest`; parity **297**; stamp `193358` |
| **112** | **Lantern lap 9 max_tokens pin** | **Landed** | Request-side max_tokens pin; parity **298**; stamp `193358` |
| **113** | **Lattice lap 12 reduce_mean** | **Landed** | Full-matrix mean into 1×1; parity **299**; stamp `200203` |
| **114** | **Scribble rish snippets view** | **Landed** | Rish fences → Skate `scribblerishviewtest`; parity **300**; stamp `200203` |
| **115** | **Linengrow sight lap 3 chart** | **Landed** | Chart on steward glass; parity **301**; stamp `200203` |
| **116** | **Lantern lap 10 text pin** | **Landed** | Response text_pin; parity **302**; stamp `200203` |
| **117** | **Lattice lap 13 abs** | **Landed** | Elementwise abs; parity **303**; stamp `200819` |
| **118** | **Anvil corpus apps prefix view** | **Landed** | pond/apps/ → Skate; parity **304**; stamp `200819` |
| **119** | **Assist sight lap 4 chart** | **Landed** | Chart on carriage assist fold; parity **305**; stamp `200819` |
| **120** | **Lantern lap 11 temperature pin** | **Landed** | TemperatureMismatch pin; parity **306**; stamp `200819` |
| **121** | **Lattice lap 14 clamp** | **Landed** | Elementwise clamp; parity **307**; stamp `211930` |
| **122** | **Scribble lap 7 heading depth + h1 view** | **Landed** | Depth filter + h1 Skate view; parity **308**; stamp `211930` |
| **123** | **Assist view lap 6 chart** | **Landed** | Chart joins journal on assist fold; parity **309**; stamp `211930` |
| **124** | **Lantern lap 12 seed pin** | **Landed** | Seed-only request pin fixture; parity **310**; stamp `211930` |
| **125** | **Lattice lap 15 reduce_max** | **Landed** | Full-matrix reduce_max; parity **311**; stamp `211930` |
| **126** | **Scribble h2 view** | **Landed** | Depth-2 headings → Skate; parity **312**; stamp `211930` |
| **127** | **Linengrow sight lap 4 P&L** | **Landed** | P&L net on steward glass; parity **313**; stamp `211930` |
| **128** | **Lantern lap 13 TopPMismatch** | **Landed** | TopPMismatch distinct from BadTopP; parity **314**; stamp `211930` |
| **129** | **Lattice lap 16 reduce_min** | **Landed** | Full-matrix reduce_min; parity **315**; stamp `212715` |
| **130** | **Scribble h3 view** | **Landed** | Depth-3 headings → Skate; parity **316**; stamp `212715` |
| **131** | **Anvil rye+dimeroll prefix** | **Landed** | rye under dimeroll/ combo; parity **317**; stamp `212715` |
| **132** | **Lantern lap 14 err_stop pin** | **Landed** | err_stop request pin; parity **318**; stamp `212715` |
| **133** | **Lattice lap 17 sqrt** | **Landed** | Elementwise sqrt + negative refuse; parity **319**; stamp `212715` |
| **134** | **Anvil rish+tools prefix** | **Landed** | rish under tools/ combo; parity **320**; stamp `212715` |
| **135** | **Assist sight lap 5 P&L** | **Landed** | P&L net on carriage assist fold; parity **321**; stamp `212715` |
| **136** | **Lantern lap 15 length_stop pin** | **Landed** | length_stop request pin; parity **322**; stamp `212715` |
| **137** | **Lattice lap 18 exp** | **Landed** | Elementwise exp; parity **323**; stamp `213317` |
| **138** | **Scribble depth tally view** | **Landed** | h1/h2/h3 counts on Skate; parity **324**; stamp `213317` |
| **139** | **Linengrow sight lap 5 BS equity** | **Landed** | BS equity on steward glass; parity **325**; stamp `213317` |
| **140** | **Lantern lap 16 empty allow-list** | **Landed** | EmptyAllowList refuse; parity **326**; stamp `213317` |
| **141** | **Lattice lap 19 log** | **Landed** | Elementwise log + non-positive refuse; parity **327**; stamp `213317` |
| **142** | **Anvil rye+apps prefix** | **Landed** | rye under pond/apps/ combo; parity **328**; stamp `213317` |
| **143** | **Assist view lap 7 P&L** | **Landed** | P&L on assist fold; parity **329**; stamp `213317` |
| **144** | **Lantern lap 17 allow_count pin** | **Landed** | allow_count pin on complete_allowed; parity **330**; stamp `213317` |
| **145** | **Lattice lap 20 pow** | **Landed** | Elementwise pow + negative refuse; parity **331**; stamp `213738` |
| **146** | **Scribble tally view** | **Landed** | Headings+paragraphs tally → Skate; parity **332**; stamp `213738` |
| **147** | **Linengrow sight lap 6 TB** | **Landed** | Trial-balance sum on glass; parity **333**; stamp `213738` |
| **148** | **Lantern lap 18 dual-model allow** | **Landed** | Assist hash on allow-list; parity **334**; stamp `213738` |
| **149** | **Lattice lap 21 relu** | **Landed** | Elementwise ReLU; parity **335**; stamp `213738` |
| **150** | **Assist sight lap 6 BS equity** | **Landed** | BS equity on carriage; parity **336**; stamp `213738` |
| **151** | **Assist view lap 8 BS equity** | **Landed** | BS equity on assist fold; parity **337**; stamp `213738` |
| **152** | **Lantern lap 19 require_model** | **Landed** | require_model pin; parity **338**; stamp `213738` |
| **153** | **Lattice lap 22 sigmoid** | **Landed** | Elementwise sigmoid; parity **339**; stamp `214145` |
| **154** | **Scribble blocks view** | **Landed** | Six outline blocks → Skate; parity **340**; stamp `214145` |
| **155** | **Linengrow sight lap 7 exceptions** | **Landed** | Exception queue on glass; parity **341**; stamp `214145` |
| **156** | **Lantern lap 20 stopped_reason eos pin** | **Landed** | pin_stopped_reason eos; parity **342**; stamp `214145` |
| **157** | **Lattice lap 23 softmax** | **Landed** | Row-wise softmax; parity **343**; stamp `214145` |
| **158** | **Assist sight lap 7 exceptions** | **Landed** | Exceptions on carriage; parity **344**; stamp `214145` |
| **159** | **Assist view lap 9 exceptions** | **Landed** | Exceptions on assist fold; parity **345**; stamp `214145` |
| **160** | **Lantern lap 21 stopped_reason length pin** | **Landed** | pin_stopped_reason length; parity **346**; stamp `214145` |
| **161** | **Lattice lap 24 tanh** | **Landed** | Elementwise tanh; parity **347**; stamp `215613` |
| **162** | **Scribble fence+heading view** | **Landed** | Fence kinds + heading on one Skate frame; parity **348**; stamp `215613` |
| **163** | **Linengrow sight lap 8 exception reason** | **Landed** | First exception reason on glass; parity **349**; stamp `215613` |
| **164** | **Lantern lap 22 stream pin false** | **Landed** | stream pin false; parity **350**; stamp `215613` |
| **165** | **Lattice lap 25 gelu** | **Landed** | Elementwise GELU (tanh approx); parity **351**; stamp `215613` |
| **166** | **Assist sight lap 8 exception reason** | **Landed** | First exception reason on carriage; parity **352**; stamp `215613` |
| **167** | **Assist view lap 10 exception reason** | **Landed** | First exception reason on assist fold; parity **353**; stamp `215613` |
| **168** | **Lantern lap 23 stream pin true** | **Landed** | stream pin true; parity **354**; stamp `215613` |
| **169** | **Lattice lap 26 silu** | **Landed** | Elementwise SiLU; parity **355**; stamp `223639` |
| **170** | **Scribble tally+blocks view** | **Landed** | Tally + blocks on one Skate frame; parity **356**; stamp `223639` |
| **171** | **Linengrow sight lap 9 second exception reason** | **Landed** | Second exception reason on glass; parity **357**; stamp `223639` |
| **172** | **Lantern lap 24 stopped_reason err_stop pin** | **Landed** | pin_stopped_reason err_stop; parity **358**; stamp `223639` |
| **173** | **Lattice lap 27 leaky_relu** | **Landed** | Elementwise leaky ReLU; parity **359**; stamp `223639` |
| **174** | **Assist sight lap 9 second exception reason** | **Landed** | Second exception reason on carriage; parity **360**; stamp `223639` |
| **175** | **Assist view lap 11 second exception reason** | **Landed** | Second exception reason on assist fold; parity **361**; stamp `223639` |
| **176** | **Lantern lap 25 stopped_reason stop_sequence pin** | **Landed** | pin_stopped_reason stop_sequence; parity **362**; stamp `223639` |
| **177** | **Lattice lap 28 softplus** | **Landed** | Elementwise softplus; parity **363**; stamp `224322` |
| **178** | **Scribble paragraphs+blocks view** | **Landed** | Paragraphs + blocks on one Skate frame; parity **364**; stamp `224322` |
| **179** | **Linengrow sight lap 10 exception tallies** | **Landed** | Exception reason tallies on glass; parity **365**; stamp `224322` |
| **180** | **Lantern lap 26 top_k pin** | **Landed** | top_k pin; parity **366**; stamp `224322` |
| **181** | **Lattice lap 29 maximum** | **Landed** | Elementwise maximum; parity **367**; stamp `224322` |
| **182** | **Assist sight lap 10 exception tallies** | **Landed** | Exception tallies on carriage; parity **368**; stamp `224322` |
| **183** | **Assist view lap 12 exception tallies** | **Landed** | Exception tallies on assist fold; parity **369**; stamp `224322` |
| **184** | **Lantern lap 27 frequency_penalty pin** | **Landed** | frequency_penalty pin; parity **370**; stamp `224322` |
| **185** | **Lattice lap 30 minimum** | **Landed** | Elementwise minimum; parity **371**; stamp `224805` |
| **186** | **Scribble h1+blocks view** | **Landed** | h1 + blocks on one Skate frame; parity **372**; stamp `224805` |
| **187** | **Linengrow sight lap 11 exception kinds** | **Landed** | Exception kinds tally on glass; parity **373**; stamp `224805` |
| **188** | **Lantern lap 28 presence_penalty pin** | **Landed** | presence_penalty pin; parity **374**; stamp `224805` |
| **189** | **Lattice lap 31 elu** | **Landed** | Elementwise ELU; parity **375**; stamp `224805` |
| **190** | **Assist sight lap 11 exception kinds** | **Landed** | Exception kinds on carriage; parity **376**; stamp `224805` |
| **191** | **Assist view lap 13 exception kinds** | **Landed** | Exception kinds on assist fold; parity **377**; stamp `224805` |
| **192** | **Lantern lap 29 n pin** | **Landed** | n pin; parity **378**; stamp `224805` |
| **193** | **Inference Track lap 1 close** | **Landed** | Fixture-contract family closed at tip **378**; next ROCm/Pond/LoRA horizon | stamp `224805` |
| **194** | **Anvil corpus lap 2 min_lines** | **Landed** | min_lines filter; parity **379**; stamp `225320` |
| **195** | **Anvil corpus lap 2 max_lines** | **Landed** | max_lines filter; parity **380**; stamp `225320` |
| **196** | **Anvil corpus lap 2 path_suffix** | **Landed** | path_suffix filter; parity **381**; stamp `225320` |
| **197** | **Anvil corpus lap 2 sum_lines** | **Landed** | sum_lines fold; parity **382**; stamp `225320` |
| **198** | **Anvil min_lines view** | **Landed** | min_lines → Skate; parity **383**; stamp `225320` |
| **199** | **Anvil max_lines view** | **Landed** | max_lines → Skate; parity **384**; stamp `225320` |
| **200** | **Anvil path_suffix view** | **Landed** | path_suffix → Skate; parity **385**; stamp `225320` |
| **201** | **Anvil sum_lines view — lap 2 close** | **Landed** | sum_lines → Skate; tip **386**; Anvil corpus lap 2 closed; stamp `225320` |
| **202** | **Dimeroll lap 4 account filter** | **Landed** | filter_by_account; parity **387**; stamp `230433` |
| **203** | **Dimeroll lap 4 memo prefix** | **Landed** | filter_by_memo_prefix; parity **388**; stamp `230433` |
| **204** | **Dimeroll lap 4 cash flow** | **Landed** | fold_cash_flow; parity **389**; stamp `230433` |
| **205** | **Dimeroll lap 4 sum amounts** | **Landed** | sum_amounts; parity **390**; stamp `230433` |
| **206** | **Dimeroll cash account view** | **Landed** | cash filter → Skate; parity **391**; stamp `230433` |
| **207** | **Dimeroll memo prefix view** | **Landed** | memo prefix → Skate; parity **392**; stamp `230433` |
| **208** | **Dimeroll cash flow view** | **Landed** | cash flow → Skate; parity **393**; stamp `230433` |
| **209** | **Dimeroll sum amounts view — lap 4 close** | **Landed** | sum amounts → Skate; tip **394**; Dimeroll lap 4 closed; stamp `230433` |
| **210** | **Lattice lap 32 softsign** | **Landed** | Elementwise softsign; parity **395**; stamp `231151` |
| **211** | **Scribble h2+blocks view** | **Landed** | h2 + blocks on one Skate frame; parity **396**; stamp `231151` |
| **212** | **Lattice lap 33 square** | **Landed** | Elementwise square; parity **397**; stamp `231151` |
| **213** | **Lantern lap 30 tokens_out pin** | **Landed** | tokens_out pin; parity **398**; stamp `231151` |
| **214** | **Lattice lap 34 sign** | **Landed** | Elementwise sign; parity **399**; stamp `231151` |
| **215** | **Scribble h3+blocks view** | **Landed** | h3 + blocks on one Skate frame; parity **400**; stamp `231151` |
| **216** | **Lattice lap 35 reciprocal** | **Landed** | Elementwise reciprocal + zero refuse; parity **401**; stamp `231151` |
| **217** | **Lantern lap 31 tokens_in pin — fixture deepen close** | **Landed** | tokens_in pin; tip **402**; stamp `231151` |
| **218** | **Lattice lap 36 hard_sigmoid** | **Landed** | Elementwise hard sigmoid; parity **403**; stamp `232158` |
| **219** | **Scribble rye+blocks view** | **Landed** | rye + blocks on one Skate frame; parity **404**; stamp `232158` |
| **220** | **Lattice lap 37 rsqrt** | **Landed** | Elementwise rsqrt; parity **405**; stamp `232158` |
| **221** | **Lantern lap 32 echo pin** | **Landed** | echo pin; parity **406**; stamp `232158` |
| **222** | **Lattice lap 38 hardtanh** | **Landed** | Elementwise hardtanh; parity **407**; stamp `232158` |
| **223** | **Scribble rish+blocks view** | **Landed** | rish + blocks on one Skate frame; parity **408**; stamp `232158` |
| **224** | **Lattice lap 39 cube** | **Landed** | Elementwise cube; parity **409**; stamp `232158` |
| **225** | **Lantern lap 33 user pin — fixture deepen lap close** | **Landed** | user pin; tip **410**; stamp `232158` |
| **226** | **Assist view lap 14 — blocks on glass** | **Landed** | blocks=4 on snippets band; parity **411**; stamp `234004` |
| **227** | **Assist sight lap 12 — blocks on carriage** | **Landed** | blocks=4 on assist sight; parity **412**; stamp `234004` |
| **228** | **Assist view lap 15 — fence-rye + blocks** | **Landed** | fence_rye=1 + blocks; parity **413**; stamp `234004` |
| **229** | **Assist sight lap 13 — fence-rye + blocks** | **Landed** | fence_rye + blocks on carriage; parity **414**; stamp `234004` |
| **230** | **Assist view lap 16 — echo on glass** | **Landed** | echo pin on lantern band; parity **415**; stamp `234004` |
| **231** | **Assist sight lap 14 — echo on carriage** | **Landed** | echo on assist sight; parity **416**; stamp `234004` |
| **232** | **Assist view lap 17 — user on glass** | **Landed** | user pin on lantern band; parity **417**; stamp `234004` |
| **233** | **Assist sight lap 15 — user — glass composition close** | **Landed** | user on carriage; tip **418**; stamp `234004` |
| **234** | **Commerce steward demo — list → settle → Dimeroll receipt** | **Landed** | In-process livelihood loop; tip **419**; stamp `004652`; live TB stays Rest-until |
| **235** | **RW-5 collaboration — Drawn Terminal asks Lantern** | **Landed** | `complete_fixture` welcome/unwelcome; tip **420**; stamp `005028` |
| **236** | **RW-5 contract — Lantern six-probe** | **Landed** | welcome complete/echo/user + three refuses; tip **421**; stamp `005028` |
| **237** | **Steward composition — livelihood on one Skate frame** | **Landed** | list → settle → Dimeroll receipt on glass; tip **422**; stamp `010030` |
| **238** | **Steward sight — livelihood + books on one frame** | **Landed** | same journal fold · pnl 825 · journal 3; tip **423**; stamp `011254` |
| **239** | **Granary weave steward — list → settle → Dimeroll** | **Landed** | second roof on Skate; cash **900**; tip **424**; stamp `012451` |
| **240** | **Granary steward sight — weave + books on one frame** | **Landed** | pnl **900** · journal 3; tip **425**; stamp `014304` |
| **241** | **Open Asks view — closed ask loop on Skate** | **Landed** | OA-L1 fold on glass; stipend **100**; tip **426**; stamp `014454` |
| **242** | **Open Asks escrow view — Nyasa hold/release on Skate** | **Landed** | OA-L3 fold on glass; escrow **0**; tip **427**; stamp `015106` |
| **243** | **RW-5 assist integration — glass asks complete_fixture** | **Landed** | assist + sight lantern band via tip-420 ask path; tip **428**; stamp `025301` |
| **244** | **Open Asks reputation view — consent-before-counting on Skate** | **Landed** | OA-L4 fold on glass; consented **3** · stipend **300**; tip **429**; stamp `030123` |
| **245** | **Open Asks civic sight — lifecycle · escrow · consent on Skate** | **Landed** | three seated folds on one frame; tip **430**; stamp `032657` |
| — | **Hold at tip 430** | **Door named** | Horizon brief → **Seam season** `052806`; reopen menu `counsel/20260711-033228_hold-at-tip-430.md` (`033228`) · product **430** · suite later **432** |
| — | **Seam season** | **Landed through suite 432** | Four RTAC studies · CapTP decline · Door 3 · compile — living hammock [`seam-season-hammock.md`](../active-designing/seam-season-hammock.md) · product nib **430** · suite nib **432** |
| — | **Rest bench (commerce)** | **Parked** | Live TB — wait for brief; Rest-until (W1/seam B) unchanged |
| — | **Realidream lane** | Horizon opened | Visual Track in ROADMAP; full viewer still held; thin view + books view are Skate folds |
| — | Two-backend seam | **Affirmed: wait** | Kaeden `174500`; sovereign framebuffer when Aurora needs a screen |
| — | Agent-writing paste | Awaiting paste | — |
| — | Snapshot lap 4 | Kaeden's hands | — |
| — | Astrology lane | Declined this season | — |

**Kumara ratchet history:** 326 (opened) → 276 (hosted + Aurora, `a086f08`) → **91** (`open_asks` product, `015312`) → **73** (virtio wire guests, `024900`) → **0** (virtio complete + scan excludes X25519 conversion seams, `030200`).

## The Realidream Lane (horizon — opened `20260708.021912`)

*The visual home of SLC design; ladder and gratitude in [ROADMAP — the Visual Track](ROADMAP.md); mining study and counsel filed same stamp. Nothing here enters Now — SLC-2a keeps the active rung, now visible as this lane's rung 1.*

- [x] **Sketchbook gratitude (Kaeden affirms `174500`; shelf-only `222852`)** — [`gratitude/grain-sketchbook.md`](../gratitude/grain-sketchbook.md) alone; archive stays outside the tree
- [x] **Gratitude lines (Kaeden affirms `174500`)** — [`hyperfiddle.md`](../gratitude/hyperfiddle.md), [`matklad.md`](../gratitude/matklad.md), Nostr via [`nips/`](../gratitude/nips/) (already kept), [`noah-b-realidream.md`](../gratitude/noah-b-realidream.md)
- [x] **Rishi `spawn` / `wait-for` verb pair — lap 1** — `spawn` returns bounded handle `{id, pid}` (max **8** live); `wait-for` returns `{out, err, code, ok}`; witnesses [`rish_spawn_witness.rish`](../tools/rish_spawn_witness.rish) + [`rish_wait_for_witness.rish`](../tools/rish_wait_for_witness.rish) GREEN; `pond/apps/rishi/main.rye` twinned via hardlink (`60fe5c5`)
- [x] **Spawn lap 2 — wire-lab `.sh` migration** — all eleven `comlink/run_*_wire_lab.sh` + `aurora/run.sh` delegate to [`tools/comlink_*_wire_lab.rish`](../tools/) and [`tools/aurora_run.rish`](../tools/aurora_run.rish) (`033600`); structural POSIX seam closed; permanent `.sh`: bootstrap + external interpreters only
- [x] **`.sh` witness-support census (`042112`–`161200`)** — native: [`tame_style_scan`](../tools/tame_style_scan.rish) router + halves, [`rs1_args_max`](../tools/fixtures/rs1_args_max.rish), [`rw1_exact_probe`](../tools/fixtures/rw1_exact_probe.rish), [`opening_lines_scan`](../tools/fixtures/opening_lines_scan.rish), [`tame_check_mantra`](../tools/fixtures/tame_check_mantra.rish), [`tame_check_scan`](../tools/fixtures/tame_check_scan.rish), [`chrono_version_scan`](../tools/fixtures/chrono_version_scan.rish), [`identity_shape`](../tools/fixtures/identity_shape.rish), [`designed_not_built_scan`](../tools/fixtures/designed_not_built_scan.rish), [`two_rooms_doorway_scan`](../tools/fixtures/two_rooms_doorway_scan.rish), [`tame_style_long_fn`](../tools/fixtures/tame_style_long_fn.rish); thin-delegate elders; `slc1_*` stay `.sh`; counsel [`042112`](../counsel/20260708-042112_claude-counsel-sh-migration-wall-found.md)
- [x] **Identity witness (`180000`)** — `PUBKEYS.template.md` at root; `identity_shape.rish` reads `context/PUBKEYS.md` when no root override; wired parity **197**
- [x] **SLC-L3 settlement + chain-read seams — removed `152612`** — was `linengrow/settlement.rye`, `settlement_core.rye`, `slcl3_settlement_witness.rish`, `comlink/chain_read_*.sh`, `chain_read_*` hosts/witnesses, `ensure_grpcurl.sh`; landed `182500` then removed per MALA realignment; counsel [`152612`](../counsel/20260709-152612_claude-counsel-mala-wov-already-designed.md); hammock [`182500`](../active-designing/20260708-182500_slcl3-settlement-rail.md) kept as record
- [x] **MALA M0 gate — verified `182354`** — Edit 5 (`143`) + Amber first lap (`144`) GREEN on metal; `designed_not_built` count **0**
- [x] **MALA M0 token-fact shapes (on paper)** — `mala:mint` and `mala:send` memo prefixes; field table in [`182354`](../expanding-prompts/20260709-182354_mala-m1-one-issuer-one-holder.md)
- [x] **MALA M1 implementation** — one issuer, one holder, mint/send/receipt/balance-as-fold; `linengrow/mala.rye` + `tools/mala_m1_witness.rish`; parity **198** (`20260709.184051`); prompt [`182354`](../expanding-prompts/20260709-182354_mala-m1-one-issuer-one-holder.md); counsel [`184051`](../counsel/20260709-184051_grok-counsel-mala-m1-names-and-tasks.md)
- [x] **MALA M2 — mailable (hosted)** — mint crosses Comlink UDP; receipt crosses back; `mala_core.rye` + `mala_delivery.rye` + `tools/mala_m2_witness.rish`; parity **199** (`20260709.191634`); prompt [`191634`](../expanding-prompts/20260709-191634_mala-m2-mailable-comlink.md)
- [x] **OA-L3/L5 UDP bind-before-send** — listen sockets bound before peer sends; clears parity hang under Rishi `sh -c` (`20260709.192631`)
- [x] **SLC-L4 fixed-tier mudra** (inherited: Sigma) — bud + proof of opening to declared tier; `disclosure_core.rye` + `tally/bud.rye` + `tools/slcl4_mudra.rish`; first landed parity **200** (`20260709.194437`); warm names seated `062656`; prompt [`031612`](../expanding-prompts/20260709-031612_slcl4-lap1-fixed-tier-sigma-protocol.md)
- [x] **MALA M2b — device wire** — virtio twin of hosted M2; ports **15569**/**15570**; four guests + `comlink/run_mala_wire_lab.sh`; extends `mala_m2_witness` (`20260709.201734`)
- [x] **WOV exit-honesty spec** — root facts + exit bundles + holder `wov:exit`; [`context/specs/20260709-200443_wov-exit-honesty.md`](../context/specs/20260709-200443_wov-exit-honesty.md)
- [x] **WOV lap 1 (in-memory)** — mint/transfer, publish root + golden bundle, prove balance, accept exit, refuse double/tamper; `linengrow/wov_core.rye` + `tools/wov_exit_honesty.rish`; parity **201** (`20260709.200729`); prompt [`200443`](../expanding-prompts/20260709-200443_wov-lap1-exit-honesty-witness.md)
- [x] **WOV lap 2a — TigerBeetle pin presence** — gitlink `59f2b99` + Apache + TIGER_STYLE + `src/tigerbeetle.zig`; no Rye `@import` of the pin; `tools/wov_tb_pin.rish`; parity **203** (`20260709.203527`); prompt [`203527`](../expanding-prompts/20260709-203527_wov-lap2-tigerbeetle-pin-presence.md); **retired from living parity** `055800` (dated record)
- [x] **WOV lap 2b client-seam design** — seam A (POSIX host) vs B (Zig protocol); account mapping; exit honesty unchanged; [`context/specs/20260709-204026_wov-tb-client-seam.md`](../context/specs/20260709-204026_wov-tb-client-seam.md); lap-open [`204026`](../expanding-prompts/20260709-204026_wov-lap2b-tb-client-wrapper.md); seam A **retired** `055800`
- [x] **WOV lap 2b — TB host seam A (code)** — `wov_tb_host.rye` + ensure/REPL scripts; projection golden; parity **204** (`20260709.223700`); live REPL needs io_uring (SKIP in ai-jail); seam B later; **retired from living parity** `055800` (dated record)
- [x] **MALA / WOV — path realigned `152612`** — own L1 via July 2 design; Sui/Monad settlement removed; **M1–M2b + WOV lap 1 + pin + seam A** on metal; counsel [`152612`](../counsel/20260709-152612_claude-counsel-mala-wov-already-designed.md)
- [x] **SLC-L4 lap 2 width design** — W0/W1/W2 named; [`224325`](../context/specs/20260709-224325_slcl4-lap2-width.md); lap-open [`224325`](../expanding-prompts/20260709-224325_slcl4-lap2-width-gated.md)
- [x] **SLC-L4 W0 — lap 1 design review** — selftest-scope review; Rest-until affirmed; counsel [`224426`](../counsel/20260709-224426_grok-counsel-slcl4-w0-lap1-review.md); no parity bump
- [x] **WOV dual-monarch design** — D1 twin log lines vs D2 two-sig envelope; [`224531`](../context/specs/20260709-224531_wov-dual-monarch.md)
- [x] **WOV dual-monarch D1 (code)** — `publish_root_dual` / `verify_latest_root_dual` / `accept_exit_dual`; `selftest-dual`; `tools/wov_dual_monarch.rish`; parity **205** (`20260709.224634`)
- [ ] **WOV TB seam B** — **Rest-until** [`225614`](../counsel/20260709-225614_grok-counsel-w1-and-seam-b-soak.md); reopen on measured red or affirm
- [ ] **WOV dual D2 envelope** — later if twin-line pairing proves awkward
- [ ] **SLC-L4 W1/W2 code** — **Rest-until** [`225614`](../counsel/20260709-225614_grok-counsel-w1-and-seam-b-soak.md); reopen on product need or affirm
- [x] **W1 + seam B Rest-until ruling** — counsel [`225614`] (living name Rest-until; counsel title keeps soak)(../counsel/20260709-225614_grok-counsel-w1-and-seam-b-soak.md); keep-going does not open them
- [x] **Twin-keys plain story + compass rose** — kitchen-language dual D1 [`230414`](../external-research/20260709-230414_twin-keys-and-the-exit-bundle.md); `tools/compass_rose.rish` walks the navigation habit; parity **206** (`20260709.230414`)
- [x] **Graduation plainly + pointer hygiene** — Jul 2 kitchen twin [`231011`](../external-research/20260709-231011_graduation-rule-plainly.md); thin-ring→thin-edge in gratitude; Amber §10 + context README; OWOG index → specs; compass rose asserts the hygiene; parity **206** unchanged (`20260709.231011`)
- [x] **One-clock + resins plainly** — Jun 27 naming spine [`235921`](../external-research/20260709-235921_one-clock-plainly.md); Amber/Amphora/resin/two-tier SHA3 [`235931`](../external-research/20260709-235931_resins-cellar-vessel-plainly.md); compass rose asserts both pairs; parity **206** unchanged (`20260709.235931`)
- [x] **Learning plainly + universal affirm** — Civic candidate kitchen twin [`000725`](../external-research/20260710-000725_learning-chapter-plainly.md) (CIVIC_STYLE untouched); aspiring/regenerative **Reviewed and kept**; resins H1 drift; zip 58 proposed→landed; Jul 9 prompts in expanding-prompts index; parity **206** (`20260710.000725`)
- [x] **Settlement seat plainly** — kitchen twin [`001249`](../external-research/20260710-001249_settlement-seat-plainly.md); dated supersession on `002612`/`005512`/`222500`; Prior-bench SLC-L3 row marked superseded; compass rose asserts; parity **206** (`20260710.001249`)
- [x] **Metalsmoke plainly + affirm** — kitchen twin [`002017`](../external-research/20260710-002017_metalsmoke-plainly.md); silo + happy-zone foundations affirmed; "awaiting ratification" cleared (audit rule `191312`); LEXICON **Metalsmoke**; parity **206** (`20260710.002017`)
- [x] **Amber seasons + first-lap plainly** — kitchen twins [`002422`](../external-research/20260710-002422_amber-seasons-plainly.md) · [`002544`](../external-research/20260710-002544_first-lap-goes-green-plainly.md); seasons silo **Reviewed and kept** (LEXICON Season ask closed); first-lap essay affirmed; Lap/Green/Season plainly links; parity **206** (`20260710.002544`)
- [x] **Sealed crossing plainly** — kitchen twin [`002952`](../external-research/20260710-002952_sealed-crossing-plainly.md) affirmed **Landed** `145313`; crossing metal plainly [`145313`](../external-research/20260710-145313_amphora-crossing-plainly.md); Amphora module seated; parity path through **226**
- [x] **Dimeroll lap 1** — chart (cash/revenue/expense/equity), journal parse, trial-balance fold, unwelcome paths; now at `dimeroll/`; `tools/dimeroll_lap1.rish`; parity **207** (`20260710.125953`)
- [x] **Dimeroll books view** — journal fixture → six Skate lines via `drawn-terminal booksviewtest`; `tools/dimeroll_books_view.rish`; parity **208** (`20260710.125953`)
- [x] **Dimeroll root + lap 2** — own `dimeroll/` home; P&L · balance sheet · exception queue; `tools/dimeroll_lap2.rish`; parity **209** (`20260710.131212`)
- [x] **Linengrow sight view** — horizon sight altitude: `booksviewtest` eight lines (TB + P&L net + BS); `sightviewtest` carriage+books; `tools/dimeroll_sight_view.rish`; parity **210** (`20260710.132548`)
- [x] **MALA `kind` field design** — K0/K1 named; [`225159`](../context/specs/20260709-225159_mala-kind-field.md)
- [x] **MALA `kind` K0** — keep memo prefixes through M3; affirmed `225343`; K1 still gated
- [ ] **MALA `kind` K1 code** — waits affirm
- [x] **Late-night Claude brief** — parity **205** landscape; [`225159`](../external-research/20260709-225159_claude-review-brief-jul9-late-night.md) supersedes `203139` for open Qs
- [x] **Thin view / Dexter exception** — thin view is not Dexter's second consumer; Dexter stays aspect; [`225343`](../context/specs/20260709-225343_thin-view-dexter-exception.md)
- [x] **Evening-close leftovers** — removal-vs-supersede on-touch; M0 functional-spec slot closed; keep-going default named; counsel [`225508`](../counsel/20260709-225508_grok-counsel-evening-close-leftovers.md)

## Six Open Points, Counseled (`221612`)

1. **Settlement-seat crown** — **moot** — Sui/Monad path removed `152612`; MALA is own-issuer money.
2. **Mainnet treasury custody event** — separate custody event when real value moves; legal/tax counsel required; MALA path replaces external-chain settlement.
3. **SLC-L4 first pass** — **landed** `194437` — fixed-tier Sigma (declared tier; blinding private); parity **200**; **W0 review** `224426`. W1 OR-tiers / W2 range remain later.
4. **Realidream viewer UI** — still held; thin view exception affirmed `225343` (not Dexter graduation); full viewer still horizon.
5. **Parity for network seams** — **resolved** — chain-read witnesses removed with settlement path `152612`.
6. **Grain-sketchbook** — **closed shelf-only** (Kaeden `222852`): [`gratitude/grain-sketchbook.md`](../gratitude/grain-sketchbook.md) is enough; no copy of the archive into this tree. Counsel `221612` had left a local `cp -r` open; Kaeden declined the hold directory.

- [ ] **Labeled `continue :state` switch (on-touch)** — for Rishi's dispatcher and any future Bron/Tilak parser next time those files open; proven in the vendored stdlib's own tokenizer; never a sweep
- [ ] **Bond-naming habit (standing)** — future cross-cutting extraction counsels name their bond in so many words, so [`rye-os-in-brix-terms`](../active-designing/20260708-021912_rye-os-in-brix-terms.md)'s descriptor accretes truthfully; Brix's gate unmoved

- [x] **Kumara extraction — first lap** — `tally/kumara.rye` + symlinks; receipt cluster; `tools/kumara_seed.rish`; counsel `222812` (`dc9ebd8`)
- [x] **Kumara extraction — expansion arc** — snapshot_export, resin_batch, recall_batch_delivery, wire_format, batch_wire, snapshot_delivery, SLC-L2 delivery, Aurora posted + sealed (`a086f08`)
- [x] **Kumara extraction — open_asks cluster** — `open_asks.rye` + OA-L2/L3/L5 delivery; ratchet **91**; counsel `015312`
- [x] **Kumara extraction — virtio wire guests (tier 1)** — `guest_receipt_*`, `guest_batch_*`, `guest_snapshot_*`; slcl2 + batch + snapshot device labs GREEN; ratchet **73**
- [x] **Kumara extraction — virtio open_asks guests (tier 2)** — fourteen `guest_open_asks_*`; OA-L1–L5 device labs GREEN; virtio cluster complete; ratchet **0**

*(Prior: Open Questions batch two `223100`, settlement refresh `222500`, roadmap synthesis `220912`.)*

## Prior bench (counsel [`220912`](../counsel/20260707-220912_claude-counsel-roadmap-synthesis.md))

**Direction (historical `220912`):** Open Questions cleared; SLC-L3 external-rail prep was front of queue — **superseded** `152612` by MALA/WOV. Kitchen twin: [`001249`](../external-research/20260710-001249_settlement-seat-plainly.md).

| Priority | Item | Status | Notes |
|----------|------|--------|-------|
| **1** | Open Questions backlog | **Cleared** | Six small proposals affirmed `174500` |
| **2** | **SLC-L3 settlement prep** | **Superseded** `152612` | External rail removed; MALA/WOV path; plainly [`001249`](../external-research/20260710-001249_settlement-seat-plainly.md) |
| — | Snapshot lap 4 | Kaeden's hands | Unchanged per `214012` |
| — | Astrology lane | Source material | Unchanged per `214012` |

- [x] **Settlement-seat refresh** — refresh + two-lane witness then **superseded** `152612`; dossiers dated; kitchen twin [`001249`](../external-research/20260710-001249_settlement-seat-plainly.md); July horizon [`041000`](../external-research/20260708-041000_settlement-horizon-refresh-july-2026.md)
- [x] **Bron beside Brix — first proposal** — counsel [`222500`](../counsel/20260707-222500_claude-counsel-bron-beside-brix-first-proposal.md): Bron = values at seams; Brix = composable wholes; graduation deferred
- [x] **Open Questions batch two** — Brix/Silo, Linengrow home, TASKS naming — counsel [`223100`](../counsel/20260707-223100_claude-counsel-open-questions-batch-two.md)
- [x] **ROADMAP Linengrow table hygiene** — OA-L4 and OA-L5 landed rows added; parity **196** (`220912`)

*(Prior next-bench counsel [`214012`](../counsel/20260707-214012_claude-counsel-next-bench-choice.md): `.sh` migration complete; OA wire verified not an open gap.)*

## Prior bench (counsel [`214012`](../counsel/20260707-214012_claude-counsel-next-bench-choice.md))

**Checked:** Open Asks Comlink wire ladder **complete** — `open_asks_lap5_delivery.rye` folds reputation after accept/complete/consent facts cross hosted + device wire (parity **184**). "More Linengrow wire" is **not** an open gap.

| Choice | Status | Notes |
|--------|--------|-------|
| **`.sh` → `.rish` migration** | `tame_style_scan` native (bans + advise); structural QEMU/cold-start `.sh` stay | Witness-support scans done |
| **Snapshot lap 4** (Puddle microVM boot replay) | Kaeden's hands | Headless bench cannot claim this lap — different session kind |
| **New domain** (astrology lane, etc.) | Awaiting source material | Valid pivot; needs Kaeden's transcripts/readings, not bench alone |

**Still open under Linengrow (not wire):** agent-writing intake (paste pending); moderation + resin-refusal fact shapes (design only). External settlement seat **retired** `152612` — see [`001249`](../external-research/20260710-001249_settlement-seat-plainly.md).

- [x] **`.sh` migration — `tame_style_scan` bans half** — `tools/tame_style_scan_bans.rish` + selftest; `tame_style_check.rish` wired; `tame_style_scan.sh bans` delegates; counsel [`214012`](../counsel/20260707-214012_claude-counsel-next-bench-choice.md)
- [x] **`.sh` migration — `tame_style_scan` advise half** — `tools/tame_style_scan_advise.rish` + selftest; map+join+sh sum idiom (`rish_count_selftest.rish`); `>70` ledger shell seam in `tame_style_long_fn.sh`; counsel `195912` / `214012`
- [x] **TigerBeetle alignment leap (`053212`)** — `tally/copy.rye` disjoint-copy law; `tools/tame_style_check.rish` bans + ratchets; 8-site `@memcpy` migration; 33 qualified asserts retired; 7 compound asserts split; Radiant vocabulary pass; study [`external-research/20260707-053212_tigerbeetle-alignment-study.md`](../external-research/20260707-053212_tigerbeetle-alignment-study.md); parity **190**
- [x] **`copy_disjoint` ratchet arc** — six on-touch turns across Mantra delivery/export, comlink virtio guests, canonical wire modules, beading cluster, linengrow OA/receipt stack, and `rishi/src/main.rye`; application `@memcpy` **121→1** (sole site intentional in `tally/copy.rye`); `linengrow/tally_copy.rye` symlink; commits `adb46e9`/`f2e69de`; full parity **191** GREEN (~146s); detail in [`session-logs/archive/20260707/20260707-154812_copy-ratchet-commit-push.md`](../session-logs/archive/20260707/20260707-154812_copy-ratchet-commit-push.md)
- [x] **General expansion round (`185612`)** — `tally/maybe.rye` + `tally/no_padding.rye` seated; `device_wire.rye` stale `negotiateFeatures` found and fixed; hosted selftest in `comlink_device_wire.rish`; tools/enrich safety net 2-of-3 (`align_session_logs`, `tame_usize_audit`); three module READMEs; counsel [`counsel/20260707-185612_claude-counsel-general-expansion-round.md`](../counsel/20260707-185612_claude-counsel-general-expansion-round.md); full parity **195** GREEN (~147s); apply [`expanding-prompts/20260707-185612_apply-general-expansion.md`](../expanding-prompts/20260707-185612_apply-general-expansion.md)
- [x] **enrich_strengthening_docs witness (`193712`)** — third tools/enrich safety-net piece; fixture at `tools/fixtures/enrich_strengthening_docs_fixture/`; two-run idempotency + real-tree checksums; counsel [`counsel/20260707-193712_claude-counsel-enrich-strengthening-docs-witness.md`](../counsel/20260707-193712_claude-counsel-enrich-strengthening-docs-witness.md); parity **196** GREEN (~147s); apply [`expanding-prompts/20260707-193712_apply-enrich-witness.md`](../expanding-prompts/20260707-193712_apply-enrich-witness.md)

**Held per counsel `025212` (not rejected — no code until each module has ground):**

- [x] **Weave slice in snapshot** — **closed** Kaeden `20260707.030412`: sovereign slice = I2 `catalog/` export (`BoltCatalog` accretion at HEAD); no `weave/` bundle; spec [`context/specs/20260707-030412_weave-slice-ruling.md`](../context/specs/20260707-030412_weave-slice-ruling.md)
- [ ] **Brix closure in snapshot** — no Brix code in tree; first lap is Brix's own, not an exporter side-effect
- [x] **Pond customs on import** — first policy lap in `pond/customs.rye`; place / hold / refuse per Tilak; Amphora scrub gated; parity **230** (`20260710.161125`)

- [x] **Snapshot horizon bundles lap 2** — `catalog/` + `trust/` prefixes; SHA3-512 head record; continuity fact sketch; `tools/mantra_snapshot_horizon.rish`; spec [`context/specs/20260707-024712_snapshot-export-lap2.md`](../context/specs/20260707-024712_snapshot-export-lap2.md); parity **182**

- [x] **Real clock in poll loop** — `sleepIntervalNs` + `default_poll_interval_ns`; in-process `interval-selftest`; wire `fetcher-poll <sentinel> [interval-ns]`; supervisor optional `[interval-ns]`; `tools/mantra_recall_subscribe_poll_interval.rish`; parity **181**

- [x] **OA-L4 escrow-release compatibility** — `foldReputationLog` recognizes `escrow-release` memos, skips holds; witness bolt extended; counsel `20260707.023512`; parity **167** witness extended

- [x] **I2 snapshot export lap 3 (hosted Comlink crossing)** — `mantra/snapshot_export_delivery.rye`; batch wire per revision group; ports **38490**/**38491**; `importCatalogHorizon` unchanged; spec [`context/specs/20260707-042512_snapshot-export-lap3.md`](../context/specs/20260707-042512_snapshot-export-lap3.md); parity **185**

- [x] **I6 Amber manifest Tilak hygiene** — export writes `format amber-ring1-v2-tilak` + `entry plain-bytes <digest> <name>`; verify/restore accept legacy two-field and Tilak three-field; elder golden preserved; tamper + unknown mark refuse; `tools/amber_manifest_tilak.rish`; parity **183**

- [x] **OA-L5 accept, complete, consent wire** — `linengrow/open_asks_lap5_delivery.rye`; hosted UDP ports **38488**/**38489**; device virtio ports **15561**/**15562**/**15563**; `tools/open_asks_lap5.rish` + `comlink/run_open_asks_lap5_wire_lab.sh`; parity **184**

- [x] **I2 snapshot export lap 1** — `mantra/snapshot_export.rye`; resin-batch frames per revision; `tools/mantra_snapshot_replay.rish`; spec [`context/specs/20260707-021512_snapshot-export-lap1.md`](../context/specs/20260707-021512_snapshot-export-lap1.md); parity **180**

- [x] **Exit-code ring (Caravan)** — `caravan/supervisor_exit.rye` + `caravan/restart_on_ok.rye`; `cycle_ok` restarts, `stop_requested` (8) halts; counsel `20260707.014212`; `tools/caravan_restart_on_ok.rish`; parity **177**
- [x] **Stop sentinel at poll boundary (Mantra)** — `fetcher-poll <sentinel>` one cycle + exit 8 when present; `fetcher-poll-legacy` for demo/selftest; `tools/mantra_recall_subscribe_poll_stop.rish`; parity **178**
- [x] **Production scheduling lap 2** — `subscribe_poll_service` imports `supervisor_exit`; restart on `cycle_ok`, halt on `stop_requested`; witness writes sentinel after N cycles; parity **178**
- [x] **SIGTERM ring (Caravan)** — `caravan/supervisor_signal.rye`; atomic flag in handler; loop top unifies signal + witness + `touch`; `tools/caravan_subscribe_poll_signal.rish`; counsel `20260707.021012`; parity **179**

**Caravan production hardening (counsel `044112` — landed parity **186**→**188**)** — detail: [`session-logs/archive/20260707/20260707-052212_caravan-host-mirror-supervision.md`](../session-logs/archive/20260707/20260707-052212_caravan-host-mirror-supervision.md) · counsel [`044112`](../counsel/20260707-044112_claude-recommendation-path.md):

- [x] **Misuse-guard → source-fall → snapshot device wire → host mirror → TASKS sweep** — all five rings GREEN; mirror via `CARAVAN_WITNESS_MIRROR=1` + `source-loop-mirror` / `fetcher-poll-mirror`; `tools/caravan_subscribe_poll_mirror_service.rish`
- [ ] **Extended-run stability** — deferred until something runs unattended for real (counsel `044112`)

**NS Q3 horizon — landed through parity 175** (detail: [`session-logs/archive/20260707/20260707-010212_tablecloth-query-parity175.md`](../session-logs/archive/20260707/20260707-010212_tablecloth-query-parity175.md) · synthesis: [`session-logs/archive/20260707/20260707-011412_claude-state-analysis-and-reference-pass.md`](../session-logs/archive/20260707/20260707-011412_claude-state-analysis-and-reference-pass.md)):

- [x] **Synthesis `20260707.011412`** — batch delivery rebind-race repair; namespace reference spec + module surfaces index + `mantra/README.md` canon `20260707.011812`
- [x] **Caravan service ring** — `caravan/service.rye`; bounded multi-tick supervised child (ring B); `tools/caravan_seeds.rish` extended
- [x] **Production scheduling lap 1** — `caravan/subscribe_poll_service.rye` supervises `recall_subscribe_poll_delivery` source + fetcher-poll; one planned restart; `tools/caravan_subscribe_poll_service.rish`; parity **176**

- [x] **Marks-on-read** — `mantra/recall_by_mark.rye`; parity **168**

- [x] **Two-way sync (in-process)** — `mantra/recall_two_way_sync.rye`; symmetric `syncRevision`; counsel `20260707.000112`; `tools/mantra_recall_two_way_sync.rish`; parity **169**

- [x] **Two-way sync (wire)** — `mantra/recall_two_way_sync_delivery.rye`; exchange twice with roles reversed; hosted **38482/38483** + device `comlink/run_recall_two_way_sync_wire_lab.sh`; `tools/mantra_recall_two_way_sync_wire.rish`; parity **170**

- [x] **Catch-up-to-latest (in-process)** — `mantra/recall_catch_up.rye`; bounded inner loop over `syncRevision`; counsel `20260707.001612`; `tools/mantra_recall_catch_up.rish`; parity **171**

- [x] **Catch-up-to-latest (wire)** — `mantra/recall_catch_up_delivery.rye`; wire loop until empty response; hosted **38484/38485** + device `comlink/run_recall_catch_up_wire_lab.sh`; `tools/mantra_recall_catch_up_wire.rish`; parity **172**

- [x] **Outer subscribe poll (in-process)** — `mantra/recall_subscribe_poll.rye`; bounded cycles over catch-up; host mirror = named pair list; counsel `20260707.004712`; `tools/mantra_recall_subscribe_poll.rish`; parity **173**

- [x] **Outer subscribe poll (wire)** — `mantra/recall_subscribe_poll_delivery.rye`; bounded poll cycles over catch-up wire; hosted **38486/38487** + device `comlink/run_recall_subscribe_poll_wire_lab.sh`; `tools/mantra_recall_subscribe_poll_wire.rish`; parity **174**

- [x] **Tablecloth query (in-process)** — `mantra/recall_tablecloth_query.rye`; optional peer/bolt/revision filter; every match in catalog order; counsel `20260707.005612`; `tools/mantra_recall_tablecloth_query.rish`; parity **175**

**NS-L1 landed `20260706.032700` — parity 159:**

- [x] **NS-L1 local recall** — `mantra/recall_lap1.rye` + `tools/mantra_recall_lap1.rish`; referential transparency + digest mismatch refused; parity **159**

- [x] **NS-L2 write revision** — `BoltCatalog.appendLeaf` + immutable prior revision recall; `tools/mantra_recall_lap2.rish`; parity **160**
- [x] **NS-L3 bolt sync (logic)** — `syncRevision` between two catalogs: have-already resins cross as refs, need-resin as bytes once; every resin digest-verified before append (tampered resin refused whole); recall identical on both peers; duplicate revision refused; `tools/mantra_recall_lap3.rish`; parity **161**
- [x] **NS-L3 wire carriage lap 2 (device)** — virtio guests `guest_sync_*`; ports **15561/15562**; `comlink/run_recall_sync_wire_lab.sh`; witness extended in `tools/mantra_recall_lap3_wire.rish`
- [x] **NS-L3 lap 3w-3a (resin-batch frame)** — `mantra/resin_batch.rye`: signed header + manifest (control plane), payloads prove by digest (data plane); many resins under one signature; have-already entries reconstructed locally; second sync moves zero payload bytes; bad signature, tampered payload, unknown Tilak refused whole; `tools/mantra_resin_batch.rish`; width-checked; parity **163**
- [x] **NS-L3 recall_beaded** — `mantra/recall_beaded.rye`; derived paths `{path}.b{N}`; `tools/mantra_recall_beaded.rish`; parity **165**
- [x] **NS-L3 multi-frame batch chunking** — kind **0x04** chunk wire + `BatchAssembler`; hosted `chunkdemo` + device lab (400 B beta, 2 frames); `virtio_net` multi-packet TX/RX; parity **166** extended
- [x] **NS-L3 beaded bolt full crossing** — bead-index + `.bN` leaves over batch wire; `hydrateBeadStoreFromCatalog` + `beadeddemo`; witness per [`20260706-185112_the-witness-bolt.md`](../active-designing/20260706-185112_the-witness-bolt.md); parity **166** extended

- [x] **Stone → resin hygiene pass (forward docs)** — active-designing, external-research, foundations carriage silo, context specs, work-in-progress, expanding-prompts (20260703+), recent session logs; **foundation stone** metaphor in READMEs kept
- [x] **`stones/` → `resins/` path rename** — Amber ring-1 export/verify/restore/witness; `amber/ring1_manifest_shape.bron`; resins law spec; golden manifest digest unchanged; parity **167** unchanged (`20260706.235812`)

**Alongside:** Sourcing-discipline note (verify vendor claims, name authors in ledger) — recommended; awaits Kaeden word for `context/` home.

**Edit-5 slot released:** I1 landed on the referential namespace foundation through parity 166. **I2 snapshot export lap 1** landed parity **180** — reuses `resin_batch.rye` manifest shape per ruling `20260706.232812`; spec [`context/specs/20260707-021512_snapshot-export-lap1.md`](../context/specs/20260707-021512_snapshot-export-lap1.md).

---

## Closed — The Three Doors and the Ladder

### The three doors (Kaeden, in order)
- [x] **Door 1 — Pond clause**: affirmed verbatim in [`pond/README.md`](../pond/README.md) (`20260703.012031`, commit `3320bed`).
- [x] **Door 2 — Lap 3 metal close** (Kaeden, on GNOME Wayland):
  - [x] `rishi/bin/rishi run tools/fixtures/pond_metal_close_preflight.rish` — build + headless witness GREEN (`20260702.195626`; fresh `20260703.012336`; jail `20260703.031212`)
  - [x] `rishi/bin/rishi run tools/slc2a_ring3_metal.rish` — the thin edge answers (`20260702.195626`; fresh `20260703.012336`; jail `20260703.031312`)
  - [x] Live `pond/bin/drawn-terminal`, five confirmations — host GNOME (`20260703.032412`)
  - [x] Lap 3 metal-closed on GNOME, `20260703.032412 UDT` — Kaeden's stamp verbatim
- [x] **Door 3 — Edit 5 ruling**: ***for*** — at most one functional spec in flight until first lap green; witness wired parity **143** (`20260703.032812`).

### The ladder (after the doors, in order — owner tagged)
1. [x] **(Cursor) Fixture twins verified** — both `.rish` fixtures green on host; `.sh` elders retired to [`tools/fixtures/yonder/`](../tools/fixtures/yonder/); [`pond/README.md`](../pond/README.md) points at twins (`20260702.180812`).
2. [x] **(Cursor) Wire Edit 5 → parity 143.** One commit, message `Wire Edit 5 designed-not-built witness — parity 143` (`20260703.032812`):
   - [x] Append the standard quartet at the tail of [`tools/parity.rish`](../tools/parity.rish), after the width-check block: `say` banner → `run ["rishi/bin/rishi" "run" "tools/designed_not_built_witness.rish"]` → `assert .ok else` → `say "GREEN: …"`
   - [x] Full suite green on metal; ROADMAP gate-trio line and this ladder's parity numbers refreshed in the same commit.
3. [x] **(Claude + Kaeden) Amber first lap — the season sitting** — brief: [`20260702-190000_amber-first-lap-claude-brief.md`](20260702-190000_amber-first-lap-claude-brief.md); spec: [`context/specs/20260701-221512_amber-functional-spec.md`](../context/specs/20260701-221512_amber-functional-spec.md). **Landed `20260703.051812` — five rungs, parity **144**:**
   - [x] **(1) Module home:** `amber/` at top level
   - [x] **(2) Fixture tree:** `tools/fixtures/amber_ring1_tree/`
   - [x] **(3) Oracle:** `openssl dgst -sha3-256`; golden `97e0d0cd…d96f` in [`tools/fixtures/amber_ring1_golden.txt`](../tools/fixtures/amber_ring1_golden.txt)
   - [x] **(4) Witness:** [`tools/amber_first_ring.rish`](../tools/amber_first_ring.rish) — welcome + tampered resin fails
   - [x] **(5) Parity 144** wired in same season
4. [x] **(Kaeden) SLC-2b nod → (Cursor) Dexter bench** — prompt: [`20260702-030112_cursor-slc-2b-keyboard-from-window.md`](../expanding-prompts/20260702-030112_cursor-slc-2b-keyboard-from-window.md). **Landed `20260703.132112` — parity **145**:**
   - [x] **Nod (Kaeden):** **`pond/apps/` extension** — counsel's recommended placement (`20260703.131812`); keyboard input grows from Lap 3's poll loop in [`pond/apps/drawn_terminal.rye`](../pond/apps/drawn_terminal.rye); Skate stays in `brushstroke/`.
   - [x] **Dexter graduation trigger (recorded):** the **Dexter** name applies to keyboard-from-window as an aspect inside the drawn terminal until a **second external consumer** arrives — a Pond app beyond the terminal, a TAME editor surface, or the sovereign framebuffer backend's input path; then `dexter/` earns its own module home per [`context/specs/20260702-035018_graduation-rule.md`](../context/specs/20260702-035018_graduation-rule.md).
   - [x] **(Cursor) DoD:** Wayland seat + xkbcommon in [`brushstroke/wayland_seed.rye`](../brushstroke/wayland_seed.rye); line editor in [`pond/apps/window_input.rye`](../pond/apps/window_input.rye); live loop + `keyboardtest` witness; [`tools/slc2b_keyboard.rish`](../tools/slc2b_keyboard.rish) in parity **145**
5. [x] **(Cursor) RW-1 mirrored pair** — the Rishi↔Mantra history seam, per the audit ([`20260702-180812_testing-audit-first-pass.md`](20260702-180812_testing-audit-first-pass.md)); contract on paper at [`20260702-200109_rw1-mirrored-pair-contract.md`](20260702-200109_rw1-mirrored-pair-contract.md) (`20260702.200109`); lands while the seam is warm from SLC-2b. Two witnesses, two commits, parity **+2**:
   - [x] `tools/rw1_shell_collab.rish` — the asker's side: the shell against a stub history store; right questions at `:version`/`:history`/`:recall`; every allowed answer handled, one unwelcome answer survived
   - [x] `tools/rw1_history_contract.rish` — the answerer's side: the `.mantra` store honors exactly those questions; every prepared answer demonstrated, welcome and unwelcome mirrored line for line
   - [x] **Landed `20260703.182612 UDT` — parity **147** (`20260703.182612`)
6. [x] **(Cursor) RW-2 mirrored pair** — app↔Brushstroke `setFrame` seam per [`20260702-205630_rw2-mirrored-pair-contract.md`](20260702-205630_rw2-mirrored-pair-contract.md); **landed `20260703.235512 UDT` — parity 150**:**
   - [x] `tools/rw2_app_collab.rish` — drawn-terminal `rw2collabtest`: sessionLines → contentSignature
   - [x] `tools/rw2_surface_contract.rish` — `redrawtest` + `boundstest` on wayland_seed

### Linengrow
- [x] **SLC-L1 scope note** — the hammock spec, one page, these boxes its skeleton ([`../active-designing/20260702-195426_slcl1-verifiable-receipt.md`](../active-designing/20260702-195426_slcl1-verifiable-receipt.md), `20260702.195426`):
  - [x] The **transaction fact**'s fields, exactly (parties by Kumara key, amount, memo, stamp) — a `.bron` value
  - [x] **Sign** with the ed25519 path parity already witnesses; **append** to a plain log file; **receipt = a pure fold** over that log; **verify** = recompute + signature check
  - [x] The **edge of complete**, named: in — one signer, one log, one verifiable receipt; out — settlement, the market, currency, multi-party
  - [x] Witness sketch named (`tools/slcl1_receipt.rish`) so the lap lands proven; Open Asks room stays gated behind this note
- [x] **SLC-L1 build + witness** — `linengrow/receipt.rye` + `tools/slcl1_receipt.rish`; parity **152** (`20260704.021800`):
  - [x] Sign → append (hex log line) → fold balance → verify on metal
  - [x] Unwelcome path: tampered log byte rejected at verify
  - [x] Fixture fact pinned at `tools/fixtures/slcl1_fact.bron`; deterministic Ed25519 seed `0x42`

### Ground
- [ ] **Kernel-direction memo** — graduate the microkernel leaning in `expanding-prompts/20260628-120912_*` into its own direction memo beside `20260628-043542`, when it feels fully settled. Same pattern as thin-frontend: deliberate, then record.
- [ ] **Egress budget (recorded, design)** — the front-door VPS transfer cap named as a constant, metered at the tunnel's mouth, witness at the edge; **household headroom** as a standing courtesy fraction the tunnel never crosses. Ground: [`external-research/20260703-015512_bandwidth-and-moderation.md`](../external-research/20260703-015512_bandwidth-and-moderation.md) (`20260703.015512`).
- [ ] **Deep-archive hardware (horizon)** — rack, powered dock, bare enterprise drives, front-door tunnel; researched in [`external-research/20260701-213412_deep-archive-and-sovereign-host-blueprint.md`](../external-research/20260701-213412_deep-archive-and-sovereign-host-blueprint.md); procurement waits on the dedicated machine; complete priced guide (new + used, three tiers, tinybox and apex-tower appendices): [`external-research/20260703-013412_home-server-purchase-guide.md`](../external-research/20260703-013412_home-server-purchase-guide.md).
- [x] **Designed-not-built spec bound (Edit 5)** — at most one functional spec in flight until its first lap runs green; witness [`tools/designed_not_built_witness.rish`](../tools/designed_not_built_witness.rish) wired in parity **143** (`20260703.032812`).

**Recorded rulings (`20260701-221512` docs round):** **Amber invocation** — explicit shell command with manual sandbox-key unlock; the docked bare drive is precondition, never trigger; the shell may notice and offer, never act; scrub runs cold, key warm only for the seconds of seal. **Amber key custody** — master `0646 2132 D3E6 3B83 4F97 6E03 A81D 720B 9235 FA7A` cold and certifying; sandbox `DBF8 5343 7A93 7B4E 36B9 3611 D949 807A C26B 2B99` signing and revocable; drive passphrase on paper in the firebox and offsite; any other fingerprint is an error on sight.

**Recorded rulings (`20260703.203712 UDT`) — crossing names, all *for*:** **Tilak** — the type-mark word; every value at a seam wears a mark in Weave. **Triad** — **absorb / express / tend** affirmed as the three duties of every Tilak. **Pottery** — value-object tier name; `.pott` working extension; greenware · kiln · glaze aspect family. **Amphora** — crossing-vessel vocabulary for agent handoffs. Law: [`active-designing/20260703-202312_the-marked-value.md`](../active-designing/20260703-202312_the-marked-value.md) · [`external-research/20260703-201612_the-amphora-and-the-crossing.md`](../external-research/20260703-201612_the-amphora-and-the-crossing.md).

**Recorded rulings (`20260703.191312 UDT`) — five ratifications, all *for*:** **Archive verdict** — Amber seals content-addressed **resins** (SHA3-256 working tier; SHA3-512 canonical forever-names); law at [`context/specs/20260703-191112_resins-and-hash-tiers.md`](../context/specs/20260703-191112_resins-and-hash-tiers.md). **Versioning rule** — authored surfaces chronological stamps only; semver a named backend seam; chrono sweep may wire. **Standing audit rule** — mirrored collaboration/contract pair per seam; integrated checks on thin edge only; one pair per season; RW-1 landed (**147**), RW-2 landed (**150**). **Maitreya owns time** — one clock for audio and video; Brushstroke owns space. **Demand map** — eight-category → module-ensemble table held as requirements; interop-first, consent-before-counting, reward-points-at-the-good; **proxy column** on the movement memo table per circulation survey Q1.

---

---

### WOV, the builds, and the harvest (`20260702.211312`)

Ground: [`external-research/20260702-211312_names-builds-and-the-ledger-map.md`](../external-research/20260702-211312_names-builds-and-the-ledger-map.md).

- [x] **WOV gate + lap 1 + pin + seam A + dual D1** — exit-honesty [`200443`](../context/specs/20260709-200443_wov-exit-honesty.md); lap 1 **201**; pin **203**; seam A **204**; dual D1 **205** (`224634`); seam B / D2 later; one or two monarchs, never three (three is Mycelium's door at M4).
- [x] **Hardware fit (recorded)** — the sovereign-host blueprint covers MALA M0–M2 and WOV's first lap through the two-monarch season with headroom; two deltas named: a dedicated power-loss-protected M.2 NVMe for the WOV data file beside the settlement U.2, and ECC as the value-bearing-monarch threshold with the blueprint's apex tower as its pre-written answer; the x1 gentle-slot rule extends to every ledger tenant. Ground: [`external-research/20260702-215212_wov-mala-hardware-fit.md`](../external-research/20260702-215212_wov-mala-hardware-fit.md) (`20260702.215212`).
- [x] **Build verdict (recorded)** — no new module: the build system grows as `rye`'s verbs (`rye test` runner is the first witness-gated horizon, a watcher later), declared by Brix, typed by Bron's mark triad, versioned where Mantra already stands; watcher name-candidates parked in RTAC for Kaeden (`20260702.211312`).
- [ ] **Living build counsel (recorded, design-only)** — builder as projection over Weave/Mantra, never a second state holder; Brix declared graph + resins-law SHA3-256 content keys; three SLC laps (watch loop · Brix-keyed cache with no-work witness · Salsa-shaped sub-file queries on proven need); lap two waits for measured red. Ground: [`external-research/20260703-193012_the-bench-as-a-block-and-the-living-build.md`](../external-research/20260703-193012_the-bench-as-a-block-and-the-living-build.md) (`20260703.193012`).
- [ ] **Bench-as-block extractions (Kaeden word)** — three siloed active-designing cuts named in counsel: *the bench is a block* · *the build as a projection* · *the message seam*; each stripped of outside names on a fresh anchor.

### Crossing suite — Pottery, Amphora, type-marks (`20260703.200712`–`202312`)

Ground: [`external-research/20260703-201612_the-amphora-and-the-crossing.md`](../external-research/20260703-201612_the-amphora-and-the-crossing.md) · [`active-designing/20260703-202312_the-marked-value.md`](../active-designing/20260703-202312_the-marked-value.md) · [`session-logs/archive/20260703/20260703-202312_the-marked-value-round.md`](../session-logs/archive/20260703/20260703-202312_the-marked-value-round.md).

- [x] **Pottery seat (Kaeden)** — value-object tier; `.pott` working extension; greenware · kiln · glaze aspect family (`20260703.203712 UDT`, *for*).
- [x] **Amphora seat (Kaeden)** — crossing-vessel vocabulary; companion silo [`active-designing/20260703-201612_the-sealed-crossing.md`](../active-designing/20260703-201612_the-sealed-crossing.md) (`20260703.203712 UDT`, *for*).
- [x] **Type-mark word (Kaeden)** — **Tilak** seated; **absorb / express / tend** triad affirmed (`20260703.203712 UDT`, *for*).
- [x] **Crossing manifest seed (witness)** — graduated to [`amphora/manifest_entry.rye`](../amphora/manifest_entry.rye); elder `tools/crossing_manifest_seed.rish` delegates; Amphora lap 1 + vessel at parity **222** (`20260710.143500`).
- [x] **Bron mark triad (concept adopted)** — every notation type carries its conversions in, out, and its operations; arm names **absorb / express / tend** seated as Tilak duties (`20260702.211312`; affirmed `20260703.203712 UDT`).
- [x] **Comlink address triple (concept adopted)** — named data resolves by *Kumara identity / lane / stamp*; design note when the naming lap opens (`20260702.211312`).

**Stops, pre-staged for the doors** (answers the loop's question six): when **Door 3 = *for*** → Edit 5 wire (**143**), then Amber rungs (a)–(e) per the confirmed counsel, and the chronological sweep wires in the same arithmetic; when the **SLC-2b nod** lands after Door 2 → the four DoD greens, then RW-1's pair (**+2**); after the **Amber season** → the toolset lap one and `rye test` enter the itinerary; the Aurora manual page enters on that surface's next touch, as-you-touch.

## Next — Horizons and Optional

### The lane and the hearth (`20260702.202612`)

- [x] **Studies 19–20** — [`government-as-planetary-spectrum.md`](../classical-vedic-astrology/studies/teaching/government-as-planetary-spectrum.md) and [`liberal-and-conservative-planets.md`](../classical-vedic-astrology/studies/teaching/liberal-and-conservative-planets.md); distilled from Vic DiCara with gratitude; raw transcripts not committed (`20260702.202612`).
- [x] **The Serena episode** — [`foundations/20260702-202612_a-conversation-with-serena.md`](../foundations/20260702-202612_a-conversation-with-serena.md): the hearth-talk imagined fuller, in the register of the earliest foundations writings (`20260702.202612`).

### The movement's open asks (`20260702.192712`)

Ground: [`external-research/20260702-192712_the-movements-open-asks.md`](../external-research/20260702-192712_the-movements-open-asks.md).

- [x] **Demand map (Kaeden affirms)** — the eight-category → module-ensemble table; interop-first, consent-before-counting, and reward-points-at-the-good held as requirements; **proxy column** (public-market proxy present or absent) on the movement memo table per circulation survey Q1 (`20260703.191312 UDT`, *for*).
- [x] **Open Asks room (OA-L1)** — `linengrow/open_asks.rye` + `tools/open_asks_lap1.rish`; parity **156**
- [x] **Open Asks cross-party (OA-L2)** — `linengrow/open_asks_delivery.rye` + `tools/open_asks_lap2.rish`; parity **157**; OA-L5 completes the wire through consent (parity **184**)
- [ ] **Sanctuary care log (flagship candidate)** — signed care facts per resident, schedules as projections, CIVIC dignity-floor accountability; design-only until its season.
- [ ] **Moderation-fact shape (recorded, design-only)** — label · limit · mute as small signed facts referencing a stated community rule; moderation as fold-choice with receipts; chosen, composable label sources; reputation stays a fold over signed receipts under consent-before-counting. Enters the ladder beside the Open Asks room, after SLC-L1 draws its edge. Ground: [`external-research/20260703-015512_bandwidth-and-moderation.md`](../external-research/20260703-015512_bandwidth-and-moderation.md) (`20260703.015512`).
- [ ] **Resin-refusal fact (recorded)** — media never lives in the log, only digests; each store is sovereign to purge and decline a resin, and a signed refusal fact gives the no its receipt without describing the refused (`20260703.015512`; unit word ratified `20260703.191312`).
- [ ] **Linengrow agent writing (intake awaiting paste)** — the shared links resist the bench's fetch (client-rendered artifact; robots-walled share); on arrival it lands whole in external-research and siloed in foundations, exactly as asked.
- [x] **Issuer's ledger silo + circulation portfolio survey (`20260703.043912`)** — [`external-research/20260703-043912_the-issuers-ledger.md`](../external-research/20260703-043912_the-issuers-ledger.md) (MMT lecture on our spine; MALA deferred) · [`external-research/20260703-043912_circulation-portfolio-survey.md`](../external-research/20260703-043912_circulation-portfolio-survey.md) (July 2026 ground re-verified on Cursor metal; thin-chapter → Linengrow rails); research for understanding only; treasury untouched.

### The audit, the manual, and the userland (`20260702.180812`)

Ground: [`20260702-180812_testing-audit-first-pass.md`](20260702-180812_testing-audit-first-pass.md) · [`20260702-184312_versioning-audit.md`](20260702-184312_versioning-audit.md) · [`active-designing/20260702-184312_the-grain-and-the-crossing.md`](../active-designing/20260702-184312_the-grain-and-the-crossing.md) · [`manual/reference/rishi-language.md`](../manual/reference/rishi-language.md) · [`external-research/20260702-180812_userland-lineages.md`](../external-research/20260702-180812_userland-lineages.md) · [`active-designing/20260702-180812_the-small-sharp-toolset.md`](../active-designing/20260702-180812_the-small-sharp-toolset.md).

- [x] **RW-3 run-record witness** — `tools/run_record_witness.rish` pins `.ok`, `.code`, `.out`, `.err` for success and failure; wired in parity **141** (`20260702.190000`).
- [x] **RW-4 SLC failure-path witness** — `tools/rw4_slc_failure_paths.rish` pins unknown meta-command, bad `:recall`, doomed `run`, and unknown CLI; wired in parity **142** (`20260702.183500`).
- [x] **Standing audit rule (Kaeden ratifies)** — every new seam ships its mirrored collaboration/contract pair; integrated checks live only on the thin edge; one pair per season, RW-1 (**147**), RW-2 (**150**) landed (`20260703.191312 UDT`, *for*).
- [x] **Happy-zone second pass (Inference)** — census tip **211**–**418**; suite still happy-zone shaped; mirror gap named; next season **RW-5** Drawn Terminal ↔ Lantern; audit [`20260711-001225_testing-audit-second-pass-inference.md`](20260711-001225_testing-audit-second-pass-inference.md) (`20260711.001225`).
- [x] **RW-5 contract on paper** — Drawn Terminal ↔ Lantern fixture collaboration/contract mirror; tips **420**/**421**; contract [`20260711-005028_rw5-mirrored-pair-contract.md`](20260711-005028_rw5-mirrored-pair-contract.md) (`20260711.005028`).
- [x] **RW-5 assist integration** — assist + sight lantern band via `ask_lantern_assist_band` → `complete_fixture`; tip **428**; witness `tools/rw5_assist_integration.rish` (`20260711.025301`).
- [x] **Open Asks reputation view** — OA-L4 consent-before-counting on Skate; tip **429**; hammock [`20260711-030123_open-asks-reputation-view-hammock.md`](../active-designing/20260711-030123_open-asks-reputation-view-hammock.md) (`20260711.030123`).
- [x] **Open Asks civic sight** — L1 · L3 · L4 on one Skate frame; tip **430**; hammock [`20260711-032657_open-asks-civic-sight-hammock.md`](../active-designing/20260711-032657_open-asks-civic-sight-hammock.md) (`20260711.032657`).
- [x] **Versioning rule (Kaeden ratifies)** — authored surfaces carry chronological stamps only; the backend's semver and the inherited parser stay named seams ([`20260702-184312_versioning-audit.md`](20260702-184312_versioning-audit.md)); **chrono sweep** wired in parity **148** (`20260703.203212 UDT`, Cursor metal) (`20260703.191312 UDT`, *for*).
- [x] **Rishi framework growth (witness-first, in need order)** — **conditional** `tools/rish_conditional_witness.rish` (`20260702.205630`); **env** `tools/rish_env_witness.rish` (`20260702.210201`); **file I/O** `tools/rish_file_io_witness.rish` (`20260702.210435`); **exit vocabulary** `tools/rish_exit_codes_witness.rish` (`20260702.210650`); all unwired from parity — Edit 5 landed at **143** (`20260703.032812`).
- [x] **Manual next rooms — Rishi tutorial one** — [`manual/tutorials/first-witness.md`](../manual/tutorials/first-witness.md); reference at chronological stamp `20260702.184312`, parity **142** (`20260702.184312` grain round).
- [x] **Manual tutorial two — run record and failures** — [`manual/tutorials/run-record-and-failures.md`](../manual/tutorials/run-record-and-failures.md); RW-3 and RW-4 deep dive at parity **142** (`20260702.205630`).
- [x] **RW-2 contract on paper** — [`20260702-205630_rw2-mirrored-pair-contract.md`](20260702-205630_rw2-mirrored-pair-contract.md); app↔Brushstroke mirrored pair spec; **landed parity 150** (`20260703.235512 UDT`, Cursor metal).
- [ ] **Manual horizons** — Aurora / Tally / Caravan interface reference pages as each surface stabilizes. **Partial (`20260702.205630`):** [`manual/reference/caravan-capabilities.md`](../manual/reference/caravan-capabilities.md) · [`manual/reference/tally-gardens.md`](../manual/reference/tally-gardens.md) — witnessed behavior only; Aurora waits.
- [ ] **Man-as-value first lap** — one utility carries a `.bron` man record; `:man <name>` renders it; the manual renders the same record. After the toolset's first lap.
- [ ] **Small-sharp-toolset ladder (gated after Amber season)** — lap one: an `echo`-sized utility with opening lines, `.bron` man record, `.brix` declaration, witness green; lap two: readiness-as-fact for one Caravan child; the override combinator earns its lap when two real configurations exist to differ.

### Rio's first round — searched ground and the happy zone (`20260702.165412`)

Ground: [`external-research/20260702-035018_puddle-sandboxed-rye-containers.md`](../external-research/20260702-035018_puddle-sandboxed-rye-containers.md) (second pass) · [`foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md`](../foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md).

- [x] **Archive verdict (Kaeden affirms)** — Amber's seal = Kumara-signed `.bron` manifest naming SHA3-256 **resins** cut at content-defined boundaries; each resin is the stored bytes, the manifest catalogs; SHA3-512 for canonical forever-names per [`context/specs/20260703-191112_resins-and-hash-tiers.md`](../context/specs/20260703-191112_resins-and-hash-tiers.md); bead-store host seam today; mountable index = bootable-clone shape; tar transport wrapper only (`20260703.191312 UDT`, *for*).
- [ ] **Puddle continuity invariant (recorded)** — one live instance per Kumara identity, enforced by a signed continuity fact; the double-boot hazard ruled out by construction.
- [x] **Maitreya owns time (Kaeden affirms)** — one clock for audio and video: decode, sync, bounded buffers; Brushstroke owns space; codecs stay royalty-free host seams (the lossless, low-delay, general, and hybrid families, with their video kin); Lotus authors above; Realidream plays through the same seam (`20260703.191312 UDT`, *for*).
- [ ] **Happy-zone pairing (TAME horizon)** — as module seams stabilize, each earns mirrored collaboration and contract witnesses; metalsmoke stays the thin edge's few honest integrated checks; enters TAME guidance on Kaeden's ruling.

### Modules, money, and the manual — horizons (`2026-07-02`)

Ground: [`active-designing/20260702-031312_modules-aspects-and-mailable-money.md`](../active-designing/20260702-031312_modules-aspects-and-mailable-money.md) · named companion: [`external-research/20260702-031312_settlement-consensus-and-many-roads.md`](../external-research/20260702-031312_settlement-consensus-and-many-roads.md).

- [x] **Module/aspect vocabulary** — definitions and graduation rule in [`context/specs/20260702-035018_graduation-rule.md`](../context/specs/20260702-035018_graduation-rule.md).
- [ ] **Weave graduation trigger (recorded)** — the day Comlink serves named data straight from Weave, `mantra/src/weave.rye` graduates to `weave/` and Mantra imports it like everyone else.
- [x] **MALA M0 (design lap)** — token-fact shapes on paper in expanding-prompt [`182354`](../expanding-prompts/20260709-182354_mala-m1-one-issuer-one-holder.md); gate cleared `182354`
- [x] **MALA M1 (code lap)** — landed `184051`; parity **198**; brief [`182354`](../expanding-prompts/20260709-182354_mala-m1-one-issuer-one-holder.md)
- [x] **MALA M2 (mailable, hosted)** — landed `191634`; parity **199**; brief [`191634`](../expanding-prompts/20260709-191634_mala-m2-mailable-comlink.md)
- [x] **MALA M2b (device wire)** — virtio carriage landed `201734`; ports **15569**/**15570**
- [ ] **Digital land = M3 (design only)** — plots as name-claim facts with extent in Realidream's graph, deeds bound to Kumara holders, traded in MALA; ordinary internet and dock-wire alike.
- [ ] **Mycelium gate (recorded)** — the ordering aspect opens at M4's many-issuer season, never before.
- [ ] **Road-keeper (exploration → first lap)** — Comlink's multipath aspect: per-road bounded queues and scorecards; first lap = one session surviving across two UDP paths under QEMU.
- [ ] **Amber-compatibility contract (design)** — export / verify / restore for every log-bearing module (Mantra, Tablecloth, Linengrow, Realidream, MALA); first lap = a Mantra log slice sealed and restored, riding Amber's first lap.
- [ ] **Brix packaging (first lap visible)** — one content-addressed, Kumara-signed package: descriptor read, resins fetched by digest over Comlink, verified on two paths, placed, run in Pond; `.bron` as the resolved-record carrier awaits Kaeden's affirmation.
- [x] **Opening lines (canonized)** — three-line head in TAME guidance; **`tools/opening_lines_witness.rish`** in parity **140** (sixteen hosted files, including `pond/apps/drawn_terminal.rye`).
- [ ] **Manual program (horizon)** — four rooms founded at [`manual/README.md`](../manual/README.md); first reference [`manual/reference/rishi-language.md`](../manual/reference/rishi-language.md) open; tutorials and module reference pages in season.
- [x] **Pond clause (Kaeden completes)** — affirmed in [`pond/README.md`](../pond/README.md) (`20260703.012031`, `3320bed`).
- [ ] **Puddle exploration (horizon)** — sandboxed Rye containers; [`external-research/20260702-035018_puddle-sandboxed-rye-containers.md`](../external-research/20260702-035018_puddle-sandboxed-rye-containers.md); first lap = one guest snapshot export/verify/restore.
- [ ] **Maitreya / Uddhava naming (recorded)** — Maitreya owns time (audio + video); Uddhava spatial/CAD horizon; counsel affirmed `20260702.165412`; archive verdict and Maitreya owns-time **ratified** `20260703.191312 UDT`.

### Comlink and the long run — horizons (`2026-07-02`)

Ground: [`external-research/20260702-014112_comlink-beyond-dns-and-sockets.md`](../external-research/20260702-014112_comlink-beyond-dns-and-sockets.md) · counsel: [`20260702-014112_horizons-and-blind-spots.md`](20260702-014112_horizons-and-blind-spots.md).

- [x] **Wire hardening (precedes any real peer)** — hosted wire: witness fixture key seeds (replacing `0xA1`/`0xB0`), unique nonce per seal via monotonic counter + SHA3 mix; parity **138** green. Production CSPRNG nonces remain horizon.
- [ ] **Algorithm tags (accretion)** — every signed record carries its algorithm field, so eras verify side by side on one log forever.
- [ ] **Hybrid key agreement (horizon)** — X25519 joined with ML-KEM-768 on the wire; harvest-now-decrypt-later answered.
- [ ] **Dual signatures for the long dark (horizon)** — Amber adds SLH-DSA beside Ed25519 through the OpenPGP seam as its tooling settles.
- [ ] **The stream lane (exploration → first lap)** — bounded, drop-late encrypted datagrams beside the fact lane; WebTransport at the browser seam; relay shape at the front door; codecs stay host seams.
- [ ] **Names without DNS (design only)** — name-claim fact shape, petnames above, Linengrow settlement as the market; no code before Kumara signs.
- [ ] **Setu ruling (Kaeden)** — the USB-C dock-wire lane's name; candidate proposed for the lexicon's open table; first lap = one Comlink datagram over CDC-NCM, host to QEMU guest.
- [ ] **Mantrapod module map (Kaeden affirms)** — the pod's module-by-module plan as tabled in the counsel memo.
- [x] **Two-oracle sky gate (first lap)** — `classical-vedic-astrology/cast_a_chart.rish` hosts `cast_a_chart_host.sh` → pyswisseph; golden-chart pin still optional.
- [ ] **Intakes awaiting Kaeden's hand** — the mathematics writings (silo together, then weigh against TAME's goals); the Cerebras and wafer-memory silos (held for the inference season).
- [ ] **Recovery rehearsal (after Amber's first lap)** — restore a directory from a cold drive and recover from a revoked sandbox key, so recovery is a witnessed fact.

### TAME hardening — complete (`2026-06-29`)


- [ ] **Width migration Phase 1b (as-you-touch)** — `mantra/*` next per the living baseline [`20260620-212126_usize-width-baseline.md`](20260620-212126_usize-width-baseline.md); decoupled from any compiler fork; re-anchored here so the oldest live thread stays on the granular plan (`20260703.013412`).

Record: `session-logs/archive/20260629/20260629-204910_th7-width-gate-yonder-convention.md` and prior TH/RS logs. Hosted `width-check` blocks in parity (**138** witnesses).

**Horizon and optional (still open):**

- [ ] **Aurora invariant notes (optional)** — say-why rationales beside `catch unreachable` in `aurora/src/seed.rye`; freestanding only; no width or assert lint.

- [ ] **Mantra CRDT weave (horizon)** — merge-always-succeeds-and-converges semantics from `external-research/yonder/20260617-195312_mantra.md`; SLC-1 seed uses LCS line weave only today.

- [x] **camelCase ratchet** — scan dirs **0** through `rye/src` (`20260707.175312`); counsel folder split (`20260707.180712`)
- [x] **Assert-density ratchet** — zero-assert non-exempt **0**; sync wire + snapshot delivery contract asserts (`20260707.183412`); counsel [`counsel/20260707-183412_claude-counsel-tb-std-prefix-assert-density.md`](../counsel/20260707-183412_claude-counsel-tb-std-prefix-assert-density.md)
- [x] **`maybe` seated** — TigerBeetle dual of assert; `tally/maybe.rye`; witness `tools/tally_maybe.rish`; counsel [`counsel/20260707-185612_claude-counsel-general-expansion-round.md`](../counsel/20260707-185612_claude-counsel-general-expansion-round.md)
- [x] **`no_padding` seated** — TigerBeetle `stdx.no_padding`, ported and honestly simplified (no `u128` branch — unneeded); `tally/no_padding.rye`; real application at `comlink/device_wire.rye`'s hosted selftest, asserted against all five `virtio_net.rye` wire structures
- [x] **Stale virtio rename found and fixed** — `device_wire.rye` called `vn.negotiateFeatures`; `virtio_net.rye` had migrated to `negotiate_features` a season ago; the parity suite never built `device_wire.rye`'s own hosted binary, only the freestanding lab downstream of it, so the break sat unnoticed. `tools/comlink_device_wire.rish` now builds and runs the hosted selftest first.
- [x] **Tools/enrich safety net — complete (3/3)** — `align_session_logs`, `tame_usize_audit`, `enrich_strengthening_docs` witnesses GREEN; counsel [`193712`](../counsel/20260707-193712_claude-counsel-enrich-strengthening-docs-witness.md)
- [x] **Tools `snake_case` season** — **0** camelCase `fn` in `tools/` (**114** cleared); counsel [`201912`](../counsel/20260707-201912_claude-counsel-enrich-migration-order.md)
- [x] **`parseInt(` ratchet** — **0** application sites (**12** migrated after counsel `203612` seated the module); counsel [`203612`](../counsel/20260707-203612_claude-counsel-parse-int-and-season-close.md); `tame_style_check` ratchet **0**
- [x] **Three module READMEs** — `comlink/README.md`, `caravan/README.md`, `tally/README.md`, matching `amber/README.md`'s shape; named as a gap since the synthesis sitting, closed this round.
- [ ] **TAME hygiene (as-you-touch)** — bare `print(...)` via `const print = std.debug.print` in older hosted `.rye`; address when each file is touched, not as a sweep.

- [ ] **Content-centric Rishi messenger (horizon)** — smallest IRC-meets-Dojo CLI over sealed, content-named datagrams; from `expanding-prompts/yonder/20260618-212012_content-centric-messaging.md`; Aurora/Comlink carry the networking seeds today.

- [ ] **Shape-casting for RISC-V bytecode (horizon)** — prove raw bytes match a declared type before trust; draw the shape-vs-execution seam plainly; from the same consumed prompt.

- [ ] **Ownerboot sovereignty (horizon)** — owner-key-sealed boot chain inverting trust at the reset vector; from `external-research/yonder/20260617-195612_ownerboot-riscv-caravan.md`; Caravan is live, the firmware path is horizon.

- [ ] **Unified identity and fractal address space (horizon)** — one seed deriving SSH, GPG, Sui, and Nostr keys; fractal address space shaped by Vedic whole-sign astrology (galaxy / star / planet); ties to Linengrow portable identity; from `expanding-prompts/yonder/20260618-215512_unified-keys-and-address-space.md`; Comlink carries the networking half today.

---

## Soon — Medium Term

### Rye OS
- [ ] **SLC-2 — Pond GUI** — the Rishi+Mantra loop in a Brushstroke/Skate window on x86_64. Simple, lovable, complete at a small scope.
- [x] **Comlink device wire** — sub-laps 1–3 GREEN; witness wired parity **154**. Unlocks **SLC-L2** carriage.
- [ ] **Comlink v1** — typed, content-named, sealed delivery between identities.
- [ ] **Brix v1** — a `.brix` course evaluating into a closure of content-addressed bricks in Tablecloth, per [`active-designing/20260702-185912_brix-the-composer.md`](../active-designing/20260702-185912_brix-the-composer.md).
- [ ] **Unified keys** — one owner seed deriving all keys.
- [ ] **Revitalization pass** — refresh the oldest active-designing briefs to the current direction; affirmed canonical files get the four-in-one touch (de-number, re-date, affirm, light freshen) rather than rename; see `ORGANIZING.md`.

### Linengrow
- [x] **SLC-L1 build** — verifiable receipts from keypair + Mantra log + projection; landed `20260704.021800` — see ladder above · parity **152**
- [x] **SLC-L2** — signed receipt delivered identity to identity over Comlink hosted wire; parity **155**

### Ground
- [ ] **Tablecloth v1** — the content-addressed store the package picture rests on.
- [ ] **TAME lints, AST tier** — textual tier expanded at `053212` (`tame_style_check`); AST-grade rules (70-line hard gate, precedence parens, defer blank line, dead declarations) wait for a Zig parser — see study [`20260707-053212`](../external-research/20260707-053212_tigerbeetle-alignment-study.md)

---

## Later — Horizons (decided in direction, grown by degrees)

### Rye OS
- [ ] **Caravan v1** — a supervision tree with a capability table; the microkernel taking shape from the hosted seed.
- [ ] **Pond v1** — Caravan isolation composed with Tally bounds, policy as a value.
- [ ] **The Forge** — Mantra served, Brushstroke drawn, Comlink replicated.
- [ ] **The TAME Editor**, **Comlink remoting** — select-then-act in Skate; value-based state sync over UDP.
- [ ] **Aurora toward verified boot** — the freestanding RISC-V seed grown toward a verified boot.
- [ ] **The kernel, built** — Caravan grown into a real microkernel on RISC-V (architecture decided; build last).
- [ ] **Language fork** — self-hosted compiler, Rye-native `std`, revisited from a mature whole if RISC-V-first genuinely demands it.
- [ ] **Inference stack** — Lantern, Lattice, Anvil, held furthest, after the living desktop composes.

### Linengrow
- [x] **SLC-L3 — settlement** — **landed** `20260708.182500`, **removed from tree** `152612` — witness dropped from parity (**197**); implementation deleted; hammock + counsel kept as record. Superseded by MALA per counsel [`152612`](../counsel/20260709-152612_claude-counsel-mala-wov-already-designed.md).
- [x] **SLC-L4 lap 1 — fixed-tier Sigma** — **landed** `20260709.194437` — parity **200**; prompt [`031612`](../expanding-prompts/20260709-031612_slcl4-lap1-fixed-tier-sigma-protocol.md). **W0 design review** cleared `224426` ([`counsel/224426`](../counsel/20260709-224426_grok-counsel-slcl4-w0-lap1-review.md)). Later: W1 OR-tiers, W2 range, sanctuary eligibility; live chain verify on-demand.
- [ ] **The platform horizons** — the computational data market, premium tiers, state-currency circulation, infrastructure licensing — grown from the business model in `../linengrow/`.
- [ ] **The civic horizons** — PBC formation, investor outreach, the first transparency campaign as proof of concept.

---

## Open Questions

- **sixos/s6 infrastructure horizon** — study in `external-research/yonder/20260619-225212_s6-sixos-nix-infuse.md`; Caravan inherits supervision discipline when we reach for it.
- **Bron** — **affirmed** [`counsel/20260707-222500`](../counsel/20260707-222500_claude-counsel-bron-beside-brix-first-proposal.md): Bron carries **immutable values at seams**; Brix carries **composable system descriptions**. Brix uses Bron as surface syntax; Bron stands alone at every seam. `bron/` module waits on parser + second consumer. *(Kaeden affirms `174500`.)*
- **Tablecloth** — **Tablecloth** names the Brix-facing application store (horizon); **Tablecloth query** names the namespace optional-field filter (parity **175**); reconciled `20260707.011812` per counsel `005612`.
- **`.brush`** — surface-description extension for the day Brushstroke becomes a small language; horizon only.
- **Dexter / Kumara** — **Dexter (re-affirmed `225343`):** still one external consumer (`pond/apps/drawn_terminal.rye` → `window_input.rye`); thin view is **not** a second consumer; stays aspect; full Realidream viewer remains the natural second-consumer candidate. **Kumara arc closed (`030200`):** Ed25519 ratchet **0**.
- **Two-backend seam** — **affirmed `174500`:** lean **wait** — hosted Wayland path witnessed (parity **145**+); sovereign framebuffer-to-QEMU sibling builds when Aurora's path needs a screen without a compositor, not before.
- **`.sh` POSIX-seam pattern** — **answered** in [`context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md) and [`ORGANIZING.md`](../ORGANIZING.md) (counsel `195912`).
- **Weave graduation (checked `220912`)** — sovereign slice = I2 `catalog/` export; stays Mantra aspect.
- **Settlement-seat refresh** — **done** `222500`; SLC-L3 witness proposal seated.
- **Weave** — aspect of Mantra today (`mantra/src/weave.rye`); graduation trigger recorded in [`20260702-031312`](../active-designing/20260702-031312_modules-aspects-and-mailable-money.md).
- **Research essays (authored, living)** — [`external-research/20260630-030312_the-interface-as-a-fold.md`](../external-research/20260630-030312_the-interface-as-a-fold.md); [`external-research/20260630-030312_after-victor-immediate-contact.md`](../external-research/20260630-030312_after-victor-immediate-contact.md); [`external-research/20260630-030312_the-hot-loop-as-the-forge.md`](../external-research/20260630-030312_the-hot-loop-as-the-forge.md).
- **Lotus** — DAW direction adopted in `active-designing/20260630-014012_lotus-the-daw.md`; REAPER docs and AP Mastering design in `gratitude/`; bench waits for SLC-2a.
- **Kernel-direction brief held** — `expanding-prompts/20260628-120912_kernel-direction-brix-and-foundations.md` stays one level deep pending the kernel-direction memo (live Now task).
- **Brix and Silo** — **affirmed** `223100`: **Silo module retired** (`20260620`); config = **Brix bonds** (infuse pattern); store = **Tablecloth**; lowercase **silo** = reading technique / astrology lane only. *(Kaeden affirms `174500`.)*
- **Linengrow's home** — **affirmed** `223100`: stay in this repo until **SLC-L3 witnessed** + deployable civic whole + Kaeden's word on `xwb122m/linengrow-*`. *(Kaeden affirms `174500`.)*
- **TASKS naming** — **affirmed** `223100`: **keep `TASKS.md`**; **workbench** as conversational alias in [`work-in-progress/README.md`](README.md) only — no rename. *(Kaeden affirms `174500`.)*
- **SLC-L1 and Sui** — **affirmed in scope note** [`20260702-195426_slcl1-verifiable-receipt.md`](../active-designing/20260702-195426_slcl1-verifiable-receipt.md): first lap uses pure foundations (keypair + log + projection); no Sui; settlement deferred to SLC-L3.
- **OCuLink companion memo** — blueprint [`20260701-213412`](../external-research/20260701-213412_deep-archive-and-sovereign-host-blueprint.md) awaits the server-workstation research memo; bridge into `external-research/` when Kaeden supplies it.
- **Birth-chart craft** — siloed library complete through studies **#57**, Brooke shelf dissociated, zip **47** at `e8d1919` (`20260705`); fidelity soften on title-drawn studies **#24–#36**; forward path: transcript-true revisions as transcripts arrive

---

*May the next lap stay clear at the top of this list. May each task be small enough to finish and worth the finishing. May what we complete accrete as honest history, and what remains stay light in the hand.*
