// tools/fixtures/monocypher_blake2b_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN
// BLAKE2b-512 over four canonical messages, so tools/crypto_monocypher_parity_witness.rish can diff Monocypher's bytes against our authored
// crypto/blake2b.rye byte-for-byte. This is the parity TARGET made real: not a recited constant, but the actual C library the audit names,
// running on metal. Season G (Cryptography · Rye-native, Monocypher-parity, audit-ready).
//
// The four messages are EXACTLY the four crypto/blake2b.rye's own selftest proves our Rye against Zig's std.crypto over: the empty message,
// the ASCII string "abc" (RFC 7693 Appendix A), one full 128-byte block (byte i = i & 0xff), and a 200-byte multi-block input
// (byte i = (i*7 + 1) & 0xff). Each line printed is 128 lowercase hex characters — one BLAKE2b-512 digest.
//
// Clean-room: this harness studies Monocypher's PUBLIC crypto_blake2b API and links the unmodified vendored source; it copies no line into our
// Rye (.claude/rules/gratitude-licenses.md). Purely local — no key, no network, no funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src <this> vendor/monocypher/src/monocypher.c -o crypto/bin/monocypher_blake2b

#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include "monocypher.h"

static void print_digest(const uint8_t *msg, size_t len) {
    uint8_t hash[64];
    crypto_blake2b(hash, 64, msg, len);
    for (size_t i = 0; i < 64; i++) {
        printf("%02x", hash[i]);
    }
    printf("\n");
}

int main(void) {
    // 1. The empty message.
    print_digest((const uint8_t *)"", 0);

    // 2. "abc" — the RFC 7693 Appendix A known-answer.
    print_digest((const uint8_t *)"abc", 3);

    // 3. Exactly one full 128-byte block: byte i = i & 0xff.
    uint8_t one_block[128];
    for (size_t i = 0; i < 128; i++) {
        one_block[i] = (uint8_t)(i & 0xff);
    }
    print_digest(one_block, 128);

    // 4. A 200-byte multi-block input: byte i = (i*7 + 1) & 0xff.
    uint8_t multi[200];
    for (size_t i = 0; i < 200; i++) {
        multi[i] = (uint8_t)((i * 7 + 1) & 0xff);
    }
    print_digest(multi, 200);

    return 0;
}
