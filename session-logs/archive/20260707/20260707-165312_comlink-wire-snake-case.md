# Comlink wire snake_case — on-touch ratchet

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.165312

## Prompt

Kg (keep going).

## Thinking trace

**Hosted + device wire:** migrated camelCase `fn` in `comlink/hosted_wire.rye` (6) and `comlink/device_wire.rye` (6). All references internal.

**Canonical `wire_format.rye`:** renamed public seal/open API (`seal_message`, `seal_datagram`, `open_datagram`) and internal `fresh_nonce` / `seal_key`; repointed **57** caller `.rye` files.

**Comlink guests:** bulk snake_case for shared helpers (`pubkey_hex`, `digest_hex_of`, `append_signed`, `hex_eq`, `send_sealed_payload`, `witness_pattern_fill`, `same_message`) across **25** `guest*.rye` files.

Ratchet **584 → 535** (−49). Witnesses GREEN: `comlink_hosted_wire`, `comlink_device_wire`, `tame_style_check`.

## Files

| File | Why |
|------|-----|
| `comlink/hosted_wire.rye` | hosted UDP wire snake_case |
| `comlink/device_wire.rye` | virtio device wire snake_case |
| `comlink/wire_format.rye` | canonical seal/open API snake_case |
| `comlink/guest_*.rye` (25) | shared helper snake_case |

**Recommend:** say **go** to commit the Comlink wire cluster; optional targeted parity slice before full suite.
