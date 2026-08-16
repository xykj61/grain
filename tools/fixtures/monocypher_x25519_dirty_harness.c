// tools/fixtures/monocypher_x25519_dirty_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN
// dirty X25519 public keys via crypto_x25519_dirty_small AND crypto_x25519_dirty_fast, so
// tools/crypto_monocypher_x25519_dirty_parity_witness.rish can diff Monocypher's output against our authored crypto/x25519_dirty.rye
// byte-for-byte. The parity TARGET made real for the "dirty" public key — the X25519 key with its cofactor left in, so its Elligator
// representative is uniformly random (the obfuscated-handshake key-hiding primitive). Season G (Cryptography · Rye-native, Monocypher-parity,
// audit-ready).
//
// crypto/x25519_dirty.rye authors this primitive from the public Curve25519 mathematics, never a copied algorithm; this harness links the
// ACTUAL vendored Monocypher and prints thirty-two lines. First SIXTEEN lines: for sixteen deterministic secret keys
// sk[j] = (i*7 + j*3 + 1) mod 256, the 64-hex dirty public key crypto_x25519_dirty_small produces. Next SIXTEEN lines: the SAME sixteen keys
// through crypto_x25519_dirty_fast. Monocypher chose its two dirty paths to agree, so the first sixteen must equal the last sixteen — the
// witness checks both that our Rye equals the first sixteen and that Monocypher's two paths agree, a double anchor.
//
// Clean-room: this harness studies Monocypher's PUBLIC crypto_x25519_dirty_small / crypto_x25519_dirty_fast API and links the unmodified
// vendored source; it copies no line into our Rye (.claude/rules/gratitude-licenses.md). Purely local — no key, no network, no funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src <this> vendor/monocypher/src/monocypher.c -o crypto/bin/monocypher_x25519_dirty

#include <stdio.h>
#include <stdint.h>
#include "monocypher.h"

// ph — print 32 bytes as 64 lowercase hex characters, one line.
static void ph(const uint8_t *b) {
    for (int i = 0; i < 32; i++) printf("%02x", b[i]);
    printf("\n");
}

int main(void) {
    // dirty_small over sixteen deterministic secret keys.
    for (uint32_t i = 0; i < 16; i++) {
        uint8_t sk[32], pk[32];
        for (uint32_t j = 0; j < 32; j++) sk[j] = (uint8_t)(i * 7 + j * 3 + 1);
        crypto_x25519_dirty_small(pk, sk);
        ph(pk);
    }
    // dirty_fast over the SAME sixteen keys — must agree with dirty_small above.
    for (uint32_t i = 0; i < 16; i++) {
        uint8_t sk[32], pk[32];
        for (uint32_t j = 0; j < 32; j++) sk[j] = (uint8_t)(i * 7 + j * 3 + 1);
        crypto_x25519_dirty_fast(pk, sk);
        ph(pk);
    }
    return 0;
}
