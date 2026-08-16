// tools/fixtures/monocypher_edx_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN
// Edwards↔Montgomery key conversion, so tools/crypto_monocypher_edx_parity_witness.rish can diff Monocypher's bytes against our authored
// crypto/ed25519_to_x25519.rye byte-for-byte. The parity TARGET made real for the identity-unification map that lets one Ed25519 key both
// sign and agree — the conversion crypto/kumara_sealed.rye's one-key story rests on. Season G (Cryptography · Rye-native, Monocypher-parity,
// audit-ready).
//
// Three printed lines, each 64 lowercase hex characters, in order:
//   1. crypto_eddsa_to_x25519(base) — the Edwards base point encoding mapped forward; RFC 7748 §4.1 fixes this to u = 9 exactly.
//   2. crypto_eddsa_to_x25519(rfc8032_pub) — RFC 8032 §7.1 Test 1's Ed25519 public key mapped forward; the real second-implementation oracle.
//   3. crypto_x25519_to_eddsa(u=9) — the X25519 base u mapped back; RFC 7748 §4.1 fixes this to the sign-0 Edwards base encoding 5866…66.
//
// Clean-room: this harness studies Monocypher's PUBLIC crypto_eddsa_to_x25519 / crypto_x25519_to_eddsa API and links the unmodified vendored
// source; it copies no line into our Rye (.claude/rules/gratitude-licenses.md). Purely local — no key of ours, no network, no funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src <this> vendor/monocypher/src/monocypher.c -o crypto/bin/monocypher_edx

#include <stdio.h>
#include <stdint.h>
#include "monocypher.h"

// The Ed25519 base point encoding: y = 4/5, sign of x = 0. RFC 8032 §5.1 canonical little-endian encoding.
static const uint8_t ed_base[32] = {
    0x58,0x66,0x66,0x66,0x66,0x66,0x66,0x66,0x66,0x66,0x66,0x66,0x66,0x66,0x66,0x66,
    0x66,0x66,0x66,0x66,0x66,0x66,0x66,0x66,0x66,0x66,0x66,0x66,0x66,0x66,0x66,0x66
};

// RFC 8032 §7.1 Test 1 Ed25519 public key (a real, published identity key; sign bit 0, so the round trip recovers it).
static const uint8_t rfc8032_pub[32] = {
    0xd7,0x5a,0x98,0x01,0x82,0xb1,0x0a,0xb7,0xd5,0x4b,0xfe,0xd3,0xc9,0x64,0x07,0x3a,
    0x0e,0xe1,0x72,0xf3,0xda,0xa6,0x23,0x25,0xaf,0x02,0x1a,0x68,0xf7,0x07,0x51,0x1a
};

// The X25519 base u-coordinate, u = 9, little-endian.
static const uint8_t x_base_u[32] = {
    0x09,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
};

static void print_bytes(const uint8_t *b) {
    for (int i = 0; i < 32; i++) {
        printf("%02x", b[i]);
    }
    printf("\n");
}

int main(void) {
    uint8_t out[32];

    // 1. Forward map of the Edwards base point: expected u = 9.
    crypto_eddsa_to_x25519(out, ed_base);
    print_bytes(out);

    // 2. Forward map of the RFC 8032 Test 1 public key: the real parity oracle.
    crypto_eddsa_to_x25519(out, rfc8032_pub);
    print_bytes(out);

    // 3. Reverse map of the X25519 base u = 9: expected the sign-0 Edwards base encoding 5866…66.
    crypto_x25519_to_eddsa(out, x_base_u);
    print_bytes(out);

    return 0;
}
