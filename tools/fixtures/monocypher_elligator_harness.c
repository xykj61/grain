// tools/fixtures/monocypher_elligator_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN
// Elligator 2 answers via crypto_elligator_map and crypto_elligator_rev, so tools/crypto_monocypher_elligator_parity_witness.rish can diff
// Monocypher's output against our authored crypto/elligator.rye byte-for-byte. The parity TARGET made real for the map that hides an X25519
// public key as a uniformly random string — the obfuscated-handshake primitive. Season G (Cryptography · Rye-native, Monocypher-parity,
// audit-ready).
//
// crypto/elligator.rye authors this primitive from the public Elligator 2 mathematics, never a copied line; this harness links the ACTUAL
// vendored Monocypher and prints thirty-two lines. The DIRECT map prints, for sixteen deterministic representatives hidden[j] = (i*7 + j*3 + 1)
// mod 256, the 64-hex Montgomery u-coordinate crypto_elligator_map produces. The INVERSE map prints, for sixteen deterministic points
// pubkey[j] = (i*11 + j*5 + 2) mod 256 under tweak (i*13 + 7) mod 256, either the word "fail" (crypto_elligator_rev returned -1, the point is
// not representable) or the 64-hex representative it returned. Roughly half the points are representable, so the run mixes both outcomes — a
// strong parity test spanning success and failure.
//
// Clean-room: this harness studies Monocypher's PUBLIC crypto_elligator_map / crypto_elligator_rev API and links the unmodified vendored
// source; it copies no line into our Rye (.claude/rules/gratitude-licenses.md). Purely local — no key, no network, no funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src <this> vendor/monocypher/src/monocypher.c -o crypto/bin/monocypher_elligator

#include <stdio.h>
#include <stdint.h>
#include "monocypher.h"

// ph — print 32 bytes as 64 lowercase hex characters, one line.
static void ph(const uint8_t *b) {
    for (int i = 0; i < 32; i++) printf("%02x", b[i]);
    printf("\n");
}

int main(void) {
    // Direct map: sixteen representatives to their u-coordinates.
    for (uint32_t i = 0; i < 16; i++) {
        uint8_t hidden[32], curve[32];
        for (uint32_t j = 0; j < 32; j++) hidden[j] = (uint8_t)(i * 7 + j * 3 + 1);
        crypto_elligator_map(curve, hidden);
        ph(curve);
    }
    // Inverse map: sixteen points under a per-point tweak, printing the representative or "fail".
    for (uint32_t i = 0; i < 16; i++) {
        uint8_t pubkey[32], hidden[32];
        for (uint32_t j = 0; j < 32; j++) pubkey[j] = (uint8_t)(i * 11 + j * 5 + 2);
        uint8_t tweak = (uint8_t)(i * 13 + 7);
        int status = crypto_elligator_rev(hidden, pubkey, tweak);
        if (status == 0) ph(hidden);
        else printf("fail\n");
    }
    return 0;
}
