// tools/fixtures/monocypher_ed25519_harness.c -- the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN Ed25519
// public key and signatures, so tools/crypto_monocypher_ed25519_parity_witness.rish can diff Monocypher's bytes against our authored
// crypto/ed25519_sign.rye byte-for-byte. The parity TARGET made real for the SIGNING primitive the Lotus signed carry (and every Kumara-signed
// record) rests on. Season G (Cryptography, Rye-native, Monocypher-parity, audit-ready).
//
// The seed is RFC 8032 section 7.1 TEST 2's own published secret key. The three printed lines are, in order: the public key derived from the seed,
// the signature over the 1-byte message 0x72 (RFC 8032 section 7.1 TEST 2's published message), and the signature over a longer deterministic
// message ("grain crypto parity"), which exercises the multi-block message path. Each line is lowercase hex -- 64 characters for the public key,
// 128 for a signature.
//
// The RFC 8032 Ed25519 (SHA-512) variant is Monocypher's OPTIONAL crypto_ed25519_* module (src/optional/monocypher-ed25519.c) -- the core
// crypto_eddsa_* uses BLAKE2b as its hash, a different, non-RFC EdDSA. This harness links the optional SHA-512 module so the procedure matches the
// RFC 8032 one our Rye composes exactly.
//
// Clean-room: this harness studies Monocypher's PUBLIC crypto_ed25519 API and links the unmodified vendored source; it copies no line into our Rye
// (.claude/rules/gratitude-licenses.md). Purely local -- it signs only a TEST seed: no key of ours, no network, no funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src -I vendor/monocypher/src/optional <this> \
//     vendor/monocypher/src/monocypher.c vendor/monocypher/src/optional/monocypher-ed25519.c -o crypto/bin/monocypher_ed25519

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "monocypher.h"
#include "monocypher-ed25519.h"

// RFC 8032 section 7.1 TEST 2 secret key (seed). crypto_ed25519_key_pair wipes the buffer it is handed, so it is copied fresh before use.
static const uint8_t seed_vec[32] = {
    0x4c,0xcd,0x08,0x9b,0x28,0xff,0x96,0xda,0x9d,0xb6,0xc3,0x46,0xec,0x11,0x4e,0x0f,
    0x5b,0x8a,0x31,0x9f,0x35,0xab,0xa6,0x24,0xda,0x8c,0xf6,0xed,0x4f,0xb8,0xa6,0xfb
};

// RFC 8032 section 7.1 TEST 2 message: a single byte, 0x72.
static const uint8_t msg_rfc[1] = { 0x72 };

// A longer deterministic message, exercising Ed25519's multi-block SHA-512 message path beyond the 1-byte RFC vector.
static const char msg_long[] = "grain crypto parity";

static void print_bytes(const uint8_t *b, int n) {
    for (int i = 0; i < n; i++) {
        printf("%02x", b[i]);
    }
    printf("\n");
}

int main(void) {
    uint8_t seed[32];
    uint8_t secret_key[64];
    uint8_t public_key[32];
    uint8_t sig_rfc[64];
    uint8_t sig_long[64];

    // Build the key pair from the seed (a fresh copy, since key_pair wipes its seed argument).
    memcpy(seed, seed_vec, 32);
    crypto_ed25519_key_pair(secret_key, public_key, seed);

    // 1. Public key derived from the seed.
    print_bytes(public_key, 32);

    // 2. Signature over the RFC 8032 section 7.1 TEST 2 message (0x72).
    crypto_ed25519_sign(sig_rfc, secret_key, msg_rfc, sizeof msg_rfc);
    print_bytes(sig_rfc, 64);

    // 3. Signature over the longer deterministic message.
    crypto_ed25519_sign(sig_long, secret_key, (const uint8_t *)msg_long, strlen(msg_long));
    print_bytes(sig_long, 64);

    return 0;
}
