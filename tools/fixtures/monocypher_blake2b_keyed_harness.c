// tools/fixtures/monocypher_blake2b_keyed_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN
// KEYED BLAKE2b (crypto_blake2b_keyed) over six (output-length, key, message) triples, so tools/crypto_monocypher_blake2b_keyed_parity_witness.rish
// can diff Monocypher's bytes against our authored crypto/blake2b.rye's hash_keyed byte-for-byte. The BLAKE2b rungs so far prove only the UNKEYED
// hash (full digest and variable length); this harness exercises Monocypher's keyed MAC mode — the message authenticator no one without the key
// can forge, the mode Grain's per-record authentication and key derivation reach for. Season G (Cryptography · Rye-native, Monocypher-parity).
//
// The six triples are printed in order, each line 2*out_len lowercase hex characters — one keyed BLAKE2b digest:
//   1. (64, key = 00 01 .. 3f, "abc")                     — a full 64-byte key, full 512-bit tag.
//   2. (64, key = "keybytes" (8 bytes), "")               — a short key over the empty message; the key block is the final block.
//   3. (32, key = byte i = (i*3 + 5) & 0xff (32 bytes), a 200-byte multi-block input byte i = (i*7 + 1) & 0xff) — key block, one full message block, a partial final block.
//   4. (16, key = 00 01 .. 3f, "The quick brown fox jumps over the lazy dog") — a 128-bit tag under a full key.
//   5. (48, key = "hemp-linen" (10 bytes), one full 128-byte block byte i = i & 0xff) — a 384-bit tag, message exactly one block.
//   6. (64, key = 00 (1 byte), "abc")                     — a one-byte key, proving the key-length parameter byte at its smallest non-zero value.
//
// Clean-room: this harness studies Monocypher's PUBLIC crypto_blake2b_keyed API and links the unmodified vendored source; it copies no line into
// our Rye (.claude/rules/gratitude-licenses.md). Purely local — no key of ours, no network, no funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src <this> vendor/monocypher/src/monocypher.c -o crypto/bin/monocypher_blake2b_keyed

#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include "monocypher.h"

static void print_keyed_digest(size_t out_len, const uint8_t *key, size_t key_len, const uint8_t *msg, size_t len) {
    uint8_t hash[64];
    crypto_blake2b_keyed(hash, out_len, key, key_len, msg, len);
    for (size_t i = 0; i < out_len; i++) {
        printf("%02x", hash[i]);
    }
    printf("\n");
}

int main(void) {
    uint8_t full_key[64];
    for (size_t i = 0; i < 64; i++) {
        full_key[i] = (uint8_t)(i & 0xff);
    }

    uint8_t mid_key[32];
    for (size_t i = 0; i < 32; i++) {
        mid_key[i] = (uint8_t)((i * 3 + 5) & 0xff);
    }

    uint8_t multi[200];
    for (size_t i = 0; i < 200; i++) {
        multi[i] = (uint8_t)((i * 7 + 1) & 0xff);
    }

    uint8_t one_block[128];
    for (size_t i = 0; i < 128; i++) {
        one_block[i] = (uint8_t)(i & 0xff);
    }

    const uint8_t one_byte_key[1] = { 0x00 };

    // 1. (64, full 64-byte key, "abc") — full key, full tag.
    print_keyed_digest(64, full_key, 64, (const uint8_t *)"abc", 3);

    // 2. (64, "keybytes", "") — short key, empty message; the key block is the final block.
    print_keyed_digest(64, (const uint8_t *)"keybytes", 8, (const uint8_t *)"", 0);

    // 3. (32, 32-byte key, a 200-byte multi-block input) — key block, one full message block, a partial final block.
    print_keyed_digest(32, mid_key, 32, multi, 200);

    // 4. (16, full 64-byte key, the fox pangram) — a 128-bit tag under a full key.
    print_keyed_digest(16, full_key, 64, (const uint8_t *)"The quick brown fox jumps over the lazy dog", 43);

    // 5. (48, "hemp-linen", one full 128-byte block) — a 384-bit tag, message exactly one block.
    print_keyed_digest(48, (const uint8_t *)"hemp-linen", 10, one_block, 128);

    // 6. (64, one-byte key 0x00, "abc") — the key-length parameter byte at its smallest non-zero value.
    print_keyed_digest(64, one_byte_key, 1, (const uint8_t *)"abc", 3);

    return 0;
}
