// tools/fixtures/monocypher_hchacha20_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN
// HChaCha20 (crypto_chacha20_h) subkey, so tools/crypto_monocypher_hchacha20_parity_witness.rish can diff Monocypher's bytes against our
// authored crypto/xchacha20.rye's hchacha20 byte-for-byte. The parity TARGET made real for the nonce-extension core the whole XChaCha line
// folds through — the 256-bit subkey every random-nonce sealed message (Vault, Comlink, the Lotus signed carry) derives before enciphering.
// Season G (Cryptography · Rye-native, Monocypher-parity, audit-ready).
//
// crypto/xchacha20.rye proved HChaCha20 against the draft §2.2.1 known-answer and inside the AEAD flagship, yet never STANDALONE against
// Monocypher's own crypto_chacha20_h. Six lines print, in order: the draft-irtf-cfrg-xchacha-03 §2.2.1 published HChaCha20 subkey (the
// canonical known-answer), then HChaCha20 subkeys over five deterministic (key, input) pairs — each key byte i generated as (i*7 + 1 + j*13)
// mod 256 and each input byte i as (i*11 + 3 + j*5) mod 256 for line j, the same coverage crypto/xchacha20.rye's parity harness uses. Each
// line is 2 hex characters per byte, a 32-byte subkey → 64 hex characters.
//
// Clean-room: this harness studies Monocypher's PUBLIC crypto_chacha20_h API and links the unmodified vendored source; it copies no line into
// our Rye (.claude/rules/gratitude-licenses.md). Purely local — no key of ours, no network, no funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src <this> vendor/monocypher/src/monocypher.c -o crypto/bin/monocypher_hchacha20

#include <stdio.h>
#include <stdint.h>
#include "monocypher.h"

// draft-irtf-cfrg-xchacha-03 §2.2.1 key 00 01 02 ... 1f.
static const uint8_t draft_key[32] = {
    0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0a,0x0b,0x0c,0x0d,0x0e,0x0f,
    0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1a,0x1b,0x1c,0x1d,0x1e,0x1f
};

// draft §2.2.1 16-byte input.
static const uint8_t draft_input[16] = {
    0x00,0x00,0x00,0x09,0x00,0x00,0x00,0x4a,0x00,0x00,0x00,0x00,0x31,0x41,0x59,0x27
};

static void print_bytes(const uint8_t *b, uint32_t n) {
    for (uint32_t i = 0; i < n; i++) {
        printf("%02x", b[i]);
    }
    printf("\n");
}

int main(void) {
    uint8_t subkey[32];

    // 1. draft §2.2.1 published HChaCha20 known-answer.
    crypto_chacha20_h(subkey, draft_key, draft_input);
    print_bytes(subkey, 32);

    // 2..6. HChaCha20 subkeys over five deterministic (key, input) pairs.
    for (uint32_t j = 0; j < 5; j++) {
        uint8_t key[32];
        uint8_t input[16];
        for (uint32_t i = 0; i < 32; i++) {
            key[i] = (uint8_t)(i * 7 + 1 + j * 13);
        }
        for (uint32_t i = 0; i < 16; i++) {
            input[i] = (uint8_t)(i * 11 + 3 + j * 5);
        }
        crypto_chacha20_h(subkey, key, input);
        print_bytes(subkey, 32);
    }

    return 0;
}
