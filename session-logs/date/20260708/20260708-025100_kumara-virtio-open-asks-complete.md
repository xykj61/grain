**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

# Kumara virtio open_asks guests — cluster complete

**Stamp:** 20260708.025100

## Thinking trace

Kaeden sent **`kg`** for the next mechanical cluster: fourteen remaining `guest_open_asks_*` virtio files still reaching for `Ed25519` directly after wire tier 1 (`024900`).

I applied the same Kumara idiom used in `linengrow/open_asks*` (`015312`): import `kumara`, replace type aliases (`KeyPair`, `PublicKey`, `Signature`), `keypair_from_seed` for deterministic seeds (`poster_seed`, `applicant_seed`, `escrow_seed`), `kumara.sign` for signing, `kumara.signature_length` for buffer sizes.

Bulk sed across all fourteen files, then verified no `Ed25519` remained in any `comlink/guest_*.rye`.

## Verification

| Witness | Result |
|---------|--------|
| `tools/open_asks_lap1.rish` | GREEN |
| `tools/open_asks_lap2.rish` | GREEN (hosted + device) |
| `tools/open_asks_lap3.rish` | GREEN (hosted + device escrow) |
| `tools/open_asks_lap5.rish` | GREEN (hosted + device consent) |
| `tools/tame_style_scan_advise_selftest.rish` | GREEN at **4** |
| `tools/tame_style_check.rish` | GREEN |

Ed25519 ratchet: **73 → 4**. The four remaining sites live in `rye/tests` (`ed25519_sign_test.rye`, `sealed_message_test.rye`) — upstream primitive witnesses, not Kumara migration targets. All `fromEd25519` lines in `wire_format.rye` remain correctly excluded.

**Kumara virtio guest cluster is complete.** The extraction arc opened at 326 sites; application identity now routes through `tally/kumara.rye` everywhere except intentional test primitives.

## Files

- `comlink/guest_open_asks_*.rye` (14 files) — Kumara repoint
- `tools/tame_style_scan_advise_selftest.rish` — ratchet pinned **4**
- `context/TAME_GUIDANCE.md`, `work-in-progress/TASKS.md` — virtio cluster done, ratchet history closed

**Recommend:** check in with Kaeden before **SLC-L3** settlement — the next item crosses real money; Kumara mechanical season is complete. Say **`go`** to commit virtio tiers 1–2 plus prior uncommitted `024800`/`024900` logs.
