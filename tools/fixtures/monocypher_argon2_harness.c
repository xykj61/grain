// tools/fixtures/monocypher_argon2_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN
// Argon2 derived key over RFC 9106's own password, salt, secret, and additional data, for all three modes (Argon2d, Argon2i, Argon2id), so
// tools/crypto_monocypher_argon2_parity_witness.rish can diff Monocypher's bytes against our authored crypto/argon2.rye byte-for-byte. The
// parity TARGET made real for the memory-hard password KDF Vault's seal rests on. Season G (Cryptography · Rye-native, Monocypher-parity,
// audit-ready) — the fifth Monocypher-SOURCE parity rung, extending the four the decision wave named (BLAKE2b, X25519, Ed25519, ChaCha/Poly)
// to Argon2, the primitive Monocypher itself implements and any auditor of a password vault will name first.
//
// The three printed lines are, in order: the Argon2d, Argon2i, and Argon2id derived keys (32 bytes → 64 hex characters each) over RFC 9106's
// primary p=4 vector: password 0x01*32, salt 0x02*16, secret (key) 0x03*8, additional data 0x04*12, t=3 passes, m=32 blocks, p=4 lanes.
//
// Clean-room: this harness studies Monocypher's PUBLIC crypto_argon2 API and links the unmodified vendored source; it copies no line into our
// Rye (.claude/rules/gratitude-licenses.md). Purely local — the inputs are RFC 9106's public TEST vectors, no real password, no identity key,
// no network, no funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src <this> vendor/monocypher/src/monocypher.c -o crypto/bin/monocypher_argon2

#include <stdio.h>
#include <stdint.h>
#include "monocypher.h"

// RFC 9106 §5.1–5.3 primary vector inputs, shared by all three modes.
static const uint8_t rfc_password[32] = {
    0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,
    0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01
};
static const uint8_t rfc_salt[16] = {
    0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02
};
static const uint8_t rfc_secret[8] = { 0x03,0x03,0x03,0x03,0x03,0x03,0x03,0x03 };
static const uint8_t rfc_ad[12] = { 0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04 };

// RFC 9106's primary cost: 32 blocks of 1024 bytes each. Monocypher fills this work area; a static, 64-byte-aligned buffer serves it.
#define NB_BLOCKS 32
_Alignas(64) static uint8_t work_area[NB_BLOCKS * 1024];

static void print_hex(const uint8_t *b, size_t n) {
    for (size_t i = 0; i < n; i++) {
        printf("%02x", b[i]);
    }
    printf("\n");
}

// derive_one — one Argon2 derived key over the RFC 9106 primary vector, for the given algorithm, printed as a hex line.
static void derive_one(uint32_t algorithm) {
    uint8_t hash[32];

    crypto_argon2_config config = {
        .algorithm = algorithm,
        .nb_blocks = NB_BLOCKS,
        .nb_passes = 3,   // t
        .nb_lanes  = 4,   // p
    };
    crypto_argon2_inputs inputs = {
        .pass      = rfc_password,
        .salt      = rfc_salt,
        .pass_size = sizeof(rfc_password),
        .salt_size = sizeof(rfc_salt),
    };
    crypto_argon2_extras extras = {
        .key      = rfc_secret,
        .ad       = rfc_ad,
        .key_size = sizeof(rfc_secret),
        .ad_size  = sizeof(rfc_ad),
    };

    crypto_argon2(hash, sizeof(hash), work_area, config, inputs, extras);
    print_hex(hash, sizeof(hash));
}

int main(void) {
    // Three lines: Argon2d, Argon2i, Argon2id — the same three primary known-answers crypto/argon2.rye proves itself against.
    derive_one(CRYPTO_ARGON2_D);
    derive_one(CRYPTO_ARGON2_I);
    derive_one(CRYPTO_ARGON2_ID);
    return 0;
}
