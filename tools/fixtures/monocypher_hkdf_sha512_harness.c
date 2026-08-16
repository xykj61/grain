// tools/fixtures/monocypher_hkdf_sha512_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN
// HKDF-SHA-512 output, so tools/crypto_monocypher_hkdf_sha512_parity_witness.rish can diff Monocypher's bytes against our authored
// crypto/hkdf_sha512.rye byte-for-byte. The parity TARGET made real for the extract-then-expand key-derivation function every handshake, sealed
// box, and vault key schedule stands on (RFC 5869). Season G (Cryptography · Rye-native, Monocypher-parity, audit-ready).
//
// crypto/hkdf_sha512.rye proves itself against Zig's std.crypto HKDF-SHA-512 and transitively against the RFC-4231-anchored HMAC beneath it; this
// harness adds the audit's own parity target. RFC 5869 publishes its known-answers over SHA-256 and SHA-1 rather than SHA-512, so the anchor for a
// SHA-512 instantiation is a second real implementation agreeing byte-for-byte — Monocypher's crypto_sha512_hkdf, its own composition over the same
// RFC's two steps. Four lines print, in order, the same shapes crypto/hkdf_sha512.rye's selftest uses: a short-salt-and-info request (RFC 5869 Test
// Case 1 structure, 42 bytes), a longer-inputs request spanning several blocks (Test Case 2 structure, 82 bytes), a zero-length-salt-and-info request
// (Test Case 3 structure, 42 bytes), and a two-block request that crosses the block boundary once (100 bytes). Each line is 2 lowercase hex characters
// per output byte.
//
// Monocypher's HKDF-SHA-512 lives in its OPTIONAL module (src/optional/monocypher-ed25519.c, crypto_sha512_hkdf) — the RFC 5869 expander over its
// optional SHA-512 line — so the harness links that source too. Clean-room: this studies Monocypher's PUBLIC crypto_sha512_hkdf API and links the
// unmodified vendored source; it copies no line into our Rye (.claude/rules/gratitude-licenses.md). Purely local — no key of ours, no network, no
// funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src -I vendor/monocypher/src/optional <this> \
//       vendor/monocypher/src/monocypher.c vendor/monocypher/src/optional/monocypher-ed25519.c -o crypto/bin/monocypher_hkdf_sha512

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "monocypher.h"
#include "monocypher-ed25519.h"

// print_okm — derive okm_size bytes of key material through Monocypher's own crypto_sha512_hkdf and print them on one hex line.
static void print_okm(uint8_t *okm, uint32_t okm_size,
                      const uint8_t *ikm, uint32_t ikm_size,
                      const uint8_t *salt, uint32_t salt_size,
                      const uint8_t *info, uint32_t info_size) {
    crypto_sha512_hkdf(okm, okm_size, ikm, ikm_size, salt, salt_size, info, info_size);
    for (uint32_t i = 0; i < okm_size; i++) {
        printf("%02x", okm[i]);
    }
    printf("\n");
}

int main(void) {
    // 1. RFC 5869 Test Case 1 structure — 13-byte salt 0x00..0x0c, 22-byte ikm 0x0b*22, 10-byte info 0xf0..0xf9, 42 output bytes.
    uint8_t salt1[13];
    for (uint32_t i = 0; i < 13; i++) salt1[i] = (uint8_t)i;
    uint8_t ikm1[22];
    for (uint32_t i = 0; i < 22; i++) ikm1[i] = 0x0b;
    uint8_t info1[10];
    for (uint32_t i = 0; i < 10; i++) info1[i] = (uint8_t)(0xf0 + i);
    uint8_t out1[42];
    print_okm(out1, 42, ikm1, 22, salt1, 13, info1, 10);

    // 2. RFC 5869 Test Case 2 structure — 80-byte salt, ikm, and info, 82 output bytes spanning several blocks.
    uint8_t ikm2[80];
    uint8_t salt2[80];
    uint8_t info2[80];
    for (uint32_t i = 0; i < 80; i++) {
        ikm2[i]  = (uint8_t)i;
        salt2[i] = (uint8_t)(0x60 + i);
        info2[i] = (uint8_t)(0xb0 + i);
    }
    uint8_t out2[82];
    print_okm(out2, 82, ikm2, 80, salt2, 80, info2, 80);

    // 3. RFC 5869 Test Case 3 structure — zero-length salt and info (the salt becomes HashLen zeros), 42 output bytes.
    print_okm(out1, 42, ikm1, 22, NULL, 0, NULL, 0);

    // 4. A two-block-crossing request — short salt, ikm, info, 100 output bytes (one whole 64-byte block plus a 36-byte tail).
    uint8_t out4[100];
    print_okm(out4, 100,
              (const uint8_t *)"ceiling ikm", 11,
              (const uint8_t *)"ceiling salt", 12,
              (const uint8_t *)"ceiling info", 12);

    return 0;
}
