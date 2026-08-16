// tools/fixtures/monocypher_elligator_key_pair_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for
// its OWN hidden keypairs via crypto_elligator_key_pair, so tools/crypto_monocypher_elligator_key_pair_parity_witness.rish can diff Monocypher's
// output against our authored crypto/elligator_key_pair.rye byte-for-byte. The parity TARGET made real for the hidden keypair — the composition
// that closes the Elligator key-hiding arc: from a seed, a fresh X25519 secret key and the uniformly random representative of its dirty public
// key (the obfuscated-handshake keypair). Season G (Cryptography · Rye-native, Monocypher-parity, audit-ready).
//
// crypto/elligator_key_pair.rye authors this composition from Monocypher's PUBLIC crypto_elligator_key_pair API, never a copied algorithm; this
// harness links the ACTUAL vendored Monocypher and prints thirty-two lines. For each of sixteen deterministic seeds
// seed[j] = (i*7 + j*3 + 1) mod 256, two lines print: the 64-hex secret_key then the 64-hex hidden (representative). crypto_elligator_key_pair
// WIPES its seed argument, so each call gets its own fresh copy of the seed — the same copy our Rye harness feeds.
//
// Clean-room: this harness studies Monocypher's PUBLIC crypto_elligator_key_pair API and links the unmodified vendored source; it copies no line
// into our Rye (.claude/rules/gratitude-licenses.md). Purely local — no key, no network, no funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src <this> vendor/monocypher/src/monocypher.c -o crypto/bin/monocypher_elligator_key_pair

#include <stdio.h>
#include <stdint.h>
#include "monocypher.h"

// ph — print 32 bytes as 64 lowercase hex characters, one line.
static void ph(const uint8_t *b) {
    for (int i = 0; i < 32; i++) printf("%02x", b[i]);
    printf("\n");
}

int main(void) {
    for (uint32_t i = 0; i < 16; i++) {
        uint8_t seed[32], secret_key[32], hidden[32];
        // A fresh seed copy per call, since crypto_elligator_key_pair wipes its seed argument.
        for (uint32_t j = 0; j < 32; j++) seed[j] = (uint8_t)(i * 7 + j * 3 + 1);
        crypto_elligator_key_pair(hidden, secret_key, seed);
        ph(secret_key);
        ph(hidden);
    }
    return 0;
}
