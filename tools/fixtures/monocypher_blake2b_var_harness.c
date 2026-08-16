// tools/fixtures/monocypher_blake2b_var_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN
// VARIABLE-LENGTH BLAKE2b over six (output-length, message) pairs, so tools/crypto_monocypher_blake2b_var_parity_witness.rish can diff
// Monocypher's bytes against our authored crypto/blake2b.rye's hash_var byte-for-byte. The existing BLAKE2b rung proves only the 64-byte full
// digest (crypto_blake2b(hash, 64, ...)); this harness exercises Monocypher's length-parameterized core at 64/16/20/28/32/48 bytes — the
// variable-output mode Argon2's blake2b_long chain and RFC 9106 key derivation lean on. Season G (Cryptography · Rye-native, Monocypher-parity).
//
// The six pairs are printed in order: (64, "abc") — the RFC 7693 Appendix A anchor, since a 64-byte request is BLAKE2b-512 exactly; (16, "");
// (20, "abc"); (28, one full 128-byte block byte i = i & 0xff); (32, a 200-byte multi-block input byte i = (i*7 + 1) & 0xff); and
// (48, the classic fox pangram). Each line printed is 2*out_len lowercase hex characters — one variable-length BLAKE2b digest.
//
// Clean-room: this harness studies Monocypher's PUBLIC crypto_blake2b API (its hash_size parameter) and links the unmodified vendored source; it
// copies no line into our Rye (.claude/rules/gratitude-licenses.md). Purely local — no key, no network, no funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src <this> vendor/monocypher/src/monocypher.c -o crypto/bin/monocypher_blake2b_var

#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include "monocypher.h"

static void print_var_digest(size_t out_len, const uint8_t *msg, size_t len) {
    uint8_t hash[64];
    crypto_blake2b(hash, out_len, msg, len);
    for (size_t i = 0; i < out_len; i++) {
        printf("%02x", hash[i]);
    }
    printf("\n");
}

int main(void) {
    // 1. (64, "abc") — the RFC 7693 Appendix A known-answer (BLAKE2b-512).
    print_var_digest(64, (const uint8_t *)"abc", 3);

    // 2. (16, "") — a 128-bit digest of the empty message.
    print_var_digest(16, (const uint8_t *)"", 0);

    // 3. (20, "abc") — a 160-bit digest.
    print_var_digest(20, (const uint8_t *)"abc", 3);

    // 4. (28, one full 128-byte block: byte i = i & 0xff) — a 224-bit digest.
    uint8_t one_block[128];
    for (size_t i = 0; i < 128; i++) {
        one_block[i] = (uint8_t)(i & 0xff);
    }
    print_var_digest(28, one_block, 128);

    // 5. (32, a 200-byte multi-block input: byte i = (i*7 + 1) & 0xff) — a 256-bit digest.
    uint8_t multi[200];
    for (size_t i = 0; i < 200; i++) {
        multi[i] = (uint8_t)((i * 7 + 1) & 0xff);
    }
    print_var_digest(32, multi, 200);

    // 6. (48, the fox pangram) — a 384-bit digest.
    print_var_digest(48, (const uint8_t *)"The quick brown fox jumps over the lazy dog", 43);

    return 0;
}
