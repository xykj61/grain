// tools/fixtures/monocypher_verify_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN
// constant-time equality verdict via crypto_verify16/32/64, so tools/crypto_monocypher_verify_parity_witness.rish can diff Monocypher's returns
// against our authored crypto/verify.rye byte-for-byte. The parity TARGET made real for the constant-time compare every MAC, tag, and
// signature-equality check rests on — the piece the two HMAC modules named as an open horizon. Season G (Cryptography · Rye-native,
// Monocypher-parity, audit-ready).
//
// crypto/verify.rye authors this primitive from the idea (the OR of byte-wise XORs, folded with no early exit), never a copied line; this harness
// links the ACTUAL vendored Monocypher and prints fifteen lines. crypto_verify16/32/64 return 0 for equal and -1 for differing. For each of
// Monocypher's three widths {16, 32, 64}, five cases print in order: equal (b = a) -> 0, one-bit difference at byte 0 -> -1, one-bit difference at
// the last byte -> -1, all-bytes-differ (b = a ^ 0xff) -> -1, and equal again over a second deterministic pattern -> 0. The base pattern is
// a[i] = (i*7 + 1) mod 256; the second-equal pattern is (i*13 + 5) mod 256 — the same generation crypto/verify.rye's parity harness uses.
//
// Clean-room: this harness studies Monocypher's PUBLIC crypto_verify16/32/64 API and links the unmodified vendored source; it copies no line into
// our Rye (.claude/rules/gratitude-licenses.md). Purely local — no key, no network, no funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src <this> vendor/monocypher/src/monocypher.c -o crypto/bin/monocypher_verify

#include <stdio.h>
#include <stdint.h>
#include "monocypher.h"

// emit16/32/64 print the five parity cases at each Monocypher width, one int per line.
static void emit16(void) {
    uint8_t a[16], b[16], c[16], d[16];
    for (uint32_t i = 0; i < 16; i++) a[i] = (uint8_t)(i * 7 + 1);

    for (uint32_t i = 0; i < 16; i++) b[i] = a[i];
    printf("%d\n", crypto_verify16(a, b));                 // equal
    for (uint32_t i = 0; i < 16; i++) b[i] = a[i];
    b[0] ^= 0x01;
    printf("%d\n", crypto_verify16(a, b));                 // one-bit diff, byte 0
    for (uint32_t i = 0; i < 16; i++) b[i] = a[i];
    b[15] ^= 0x80;
    printf("%d\n", crypto_verify16(a, b));                 // one-bit diff, last byte
    for (uint32_t i = 0; i < 16; i++) b[i] = a[i] ^ 0xff;
    printf("%d\n", crypto_verify16(a, b));                 // all bytes differ
    for (uint32_t i = 0; i < 16; i++) { c[i] = (uint8_t)(i * 13 + 5); d[i] = c[i]; }
    printf("%d\n", crypto_verify16(c, d));                 // equal, second pattern
}

static void emit32(void) {
    uint8_t a[32], b[32], c[32], d[32];
    for (uint32_t i = 0; i < 32; i++) a[i] = (uint8_t)(i * 7 + 1);

    for (uint32_t i = 0; i < 32; i++) b[i] = a[i];
    printf("%d\n", crypto_verify32(a, b));
    for (uint32_t i = 0; i < 32; i++) b[i] = a[i];
    b[0] ^= 0x01;
    printf("%d\n", crypto_verify32(a, b));
    for (uint32_t i = 0; i < 32; i++) b[i] = a[i];
    b[31] ^= 0x80;
    printf("%d\n", crypto_verify32(a, b));
    for (uint32_t i = 0; i < 32; i++) b[i] = a[i] ^ 0xff;
    printf("%d\n", crypto_verify32(a, b));
    for (uint32_t i = 0; i < 32; i++) { c[i] = (uint8_t)(i * 13 + 5); d[i] = c[i]; }
    printf("%d\n", crypto_verify32(c, d));
}

static void emit64(void) {
    uint8_t a[64], b[64], c[64], d[64];
    for (uint32_t i = 0; i < 64; i++) a[i] = (uint8_t)(i * 7 + 1);

    for (uint32_t i = 0; i < 64; i++) b[i] = a[i];
    printf("%d\n", crypto_verify64(a, b));
    for (uint32_t i = 0; i < 64; i++) b[i] = a[i];
    b[0] ^= 0x01;
    printf("%d\n", crypto_verify64(a, b));
    for (uint32_t i = 0; i < 64; i++) b[i] = a[i];
    b[63] ^= 0x80;
    printf("%d\n", crypto_verify64(a, b));
    for (uint32_t i = 0; i < 64; i++) b[i] = a[i] ^ 0xff;
    printf("%d\n", crypto_verify64(a, b));
    for (uint32_t i = 0; i < 64; i++) { c[i] = (uint8_t)(i * 13 + 5); d[i] = c[i]; }
    printf("%d\n", crypto_verify64(c, d));
}

int main(void) {
    emit16();
    emit32();
    emit64();
    return 0;
}
