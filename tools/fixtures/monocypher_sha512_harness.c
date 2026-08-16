// tools/fixtures/monocypher_sha512_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN SHA-512
// digests, so tools/crypto_monocypher_sha512_parity_witness.rish can diff Monocypher's bytes against our authored crypto/sha512.rye byte-for-byte.
// The parity TARGET made real for the hash Ed25519 signs with (RFC 8032 / FIPS 180-4) — the hash every Ed25519 signature, the HMAC/HKDF-SHA512 line,
// and the BIP32 seed derivation fold their inputs through. Season G (Cryptography · Rye-native, Monocypher-parity, audit-ready).
//
// crypto/sha512.rye's own selftest names Monocypher-source parity as an honest held horizon ("Monocypher passes the same standard vectors — its
// vendored source is a held fetch, so Monocypher-source parity is an honest horizon rung"); this harness closes it. SHA-512 was proven EMBEDDED inside
// Ed25519 signing, yet never STANDALONE against Monocypher's own crypto_sha512 — the hash-cipher counterpart to the standalone ChaCha20 and Poly1305
// rungs. Five lines print, in order: SHA-512 of the empty message, of "abc", of a 111-byte input (the padding edge where the length still fits the
// block), of a 112-byte input (the edge that forces a second all-padding block), and of a 300-byte multi-block input — the same coverage
// crypto/sha512.rye's selftest uses. Each line is 128 lowercase hex characters (2 per digest byte).
//
// Monocypher's SHA-512 lives in its OPTIONAL module (src/optional/monocypher-ed25519.c) — the RFC 8032 building block for its optional Ed25519 — so
// the harness links that source too. Clean-room: this studies Monocypher's PUBLIC crypto_sha512 API and links the unmodified vendored source; it copies
// no line into our Rye (.claude/rules/gratitude-licenses.md). Purely local — no key of ours, no network, no funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src -I vendor/monocypher/src/optional <this> \
//       vendor/monocypher/src/monocypher.c vendor/monocypher/src/optional/monocypher-ed25519.c -o crypto/bin/monocypher_sha512

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "monocypher.h"
#include "monocypher-ed25519.h"

static void print_digest(const uint8_t *msg, uint32_t n) {
    uint8_t hash[64];
    crypto_sha512(hash, msg, n);
    for (uint32_t i = 0; i < 64; i++) {
        printf("%02x", hash[i]);
    }
    printf("\n");
}

int main(void) {
    // 1. The empty message.
    print_digest((const uint8_t *)"", 0);

    // 2. The FIPS 180-4 canonical "abc".
    print_digest((const uint8_t *)"abc", 3);

    // 3. A 111-byte input — byte i = i mod 256 — the edge where the length still fits the first padded block.
    uint8_t buf111[111];
    for (uint32_t i = 0; i < 111; i++) {
        buf111[i] = (uint8_t)i;
    }
    print_digest(buf111, 111);

    // 4. A 112-byte input — the edge that forces a second all-padding block.
    uint8_t buf112[112];
    for (uint32_t i = 0; i < 112; i++) {
        buf112[i] = (uint8_t)i;
    }
    print_digest(buf112, 112);

    // 5. A 300-byte multi-block input — byte i = (i*7 + 1) mod 256.
    uint8_t multi[300];
    for (uint32_t i = 0; i < 300; i++) {
        multi[i] = (uint8_t)(i * 7 + 1);
    }
    print_digest(multi, 300);

    return 0;
}
