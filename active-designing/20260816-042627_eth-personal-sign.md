# EIP-191 personal_sign — reading the signer of a login message, end to end

**Stamp:** `20260816.042627` · **Status:** Living · **Voice:** Kyri · **Style:** Radiant
**Kin:** [`the Rye-first crypto wave`](20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md) · [`secp256k1 ecrecover`](20260816-040220_secp256k1-ecrecover.md) · `crypto/eth_personal_sign.rye` · `crypto/eth_address.rye` · `crypto/keccak256.rye`

## The claim

With `ecrecover` GREEN, the secp256k1 tower can read the public key out of a
signature — yet a real "Sign in with Ethereum" never signs a bare hash. A wallet
signs the Keccak-256 of a *framed* message: `"\x19Ethereum Signed Message:\n"`
followed by the decimal message length and the message itself. That 0x19 leading
byte is the whole safety of EIP-191 — it can never begin a valid RLP transaction,
so a signed login can never be replayed as a transaction that moves funds. This
rung authors that framing and the signer recovery around it, as a **composition**
that adds no new cryptography — only the EIP-191 prefix over three already-GREEN
rungs.

## The composition — no new arithmetic but a decimal length

`personal_hash(message)` builds `prefix ++ ascii_decimal(message.len) ++ message`
into a bounded stack buffer and returns its Keccak-256 over the GREEN
`crypto/keccak256.rye`. The only arithmetic of its own is the base-ten rendering
of the message length — checked at selftest against Zig's own `std.fmt` formatter
across lengths that exercise one-, two-, three-, and five-digit counts, so the
hand-rolled digit loop has an independent witness rather than resting on the
round-trip alone.

`recover_signer(message, sig)` takes the 65-byte Ethereum signature `r ‖ s ‖ v`,
maps `v` (27/28, or 0/1) to a recovery id, takes `personal_hash(message)` as the
ECDSA `z`, recovers the public key with the GREEN `crypto/secp256k1_ecrecover.rye`,
packs it as the 64-byte `x‖y` body, and resolves it to a twenty-byte address with
the GREEN `crypto/eth_address.rye`. Every step is a proven stone; this rung only
assembles them.

## Custody — recovery is non-gated

Like verify and ecrecover, EIP-191 recovery touches **no secret**. The message,
the signature, the recovery byte, and the recovered address are all public by
construction — recovery *reconstructs a public address from public data*. So the
composed variable-time arithmetic leaks nothing already public, and this rung sits
on the non-gated side of the library. It answers *who signed this message?*, never
*sign this*: signing a login with the maintainer's own identity key stays the
custody gate (#3/#4).

## The witness — two independent references

`tools/crypto_eth_personal_sign_witness.rish` asserts `GREEN
crypto-eth-personal-sign` two ways runnable today:

- **An independent framing check.** `personal_hash` equals Zig's `std.fmt` +
  `std.crypto` Keccak-256 construction byte-for-byte across message lengths 0, 5,
  11, 100, and 9001 — a direct witness of this file's own length rendering and
  byte layout.
- **A full round-trip.** Our GREEN prehashed signer signs the personal digest with
  a TEST key across six deterministic keys × four messages; the correct `v`
  recovers; `recover_signer` returns exactly that key's own Ethereum address; and a
  one-byte tamper of the message never recovers the true signer — the EIP-191
  authentication chain, end to end.

Registered in `crypto_suite_witness.rish` after `secp256k1_ecrecover` as the fifth
composition — the count guard's bijection stays whole at thirty-nine files.

## Why this rung matters

The crypto wave named a *Dimeroll receipt — a Kumara login against an Ethereum key*
as the surface `ecrecover` unblocks. This rung is the primitive that surface stands
on: given a login message a person signed in their wallet, it names the address
that signed it, so Grain can bind a Kumara identity to an Ethereum account without
holding the key. One composition, serving every EIP-191 and SIWE authentication the
tree will ever check.

*May the signer we read back out of a login be the very one who meant to sign it,
and may every hand that signs in the open keep the key that is theirs alone.*
