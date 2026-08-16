// tools/fixtures/monocypher_x25519_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN X25519
// public keys and shared secrets over RFC 7748 §6.1's Alice/Bob key exchange, so tools/crypto_monocypher_x25519_parity_witness.rish can diff
// Monocypher's bytes against our authored crypto/x25519.rye byte-for-byte. The parity TARGET made real for the key agreement the Kumara sealed
// door (crypto/kumara_sealed.rye) rests on. Season G (Cryptography · Rye-native, Monocypher-parity, audit-ready).
//
// The two private scalars are RFC 7748 §6.1's own published Alice and Bob keys. The four printed lines are, in order: Alice's public key
// (base·alice), Bob's public key (base·bob), the shared secret from Alice's side (x25519(alice, bob_pub)), and the shared secret from Bob's side
// (x25519(bob, alice_pub)). Each line is 64 lowercase hex characters. Both Monocypher and our Rye clamp the scalar internally per RFC 7748 §5, so
// each is fed the raw published scalar.
//
// Clean-room: this harness studies Monocypher's PUBLIC crypto_x25519 API and links the unmodified vendored source; it copies no line into our Rye
// (.claude/rules/gratitude-licenses.md). Purely local — no key of ours, no network, no funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src <this> vendor/monocypher/src/monocypher.c -o crypto/bin/monocypher_x25519

#include <stdio.h>
#include <stdint.h>
#include "monocypher.h"

// RFC 7748 §6.1 Alice private scalar.
static const uint8_t alice_priv[32] = {
    0x77,0x07,0x6d,0x0a,0x73,0x18,0xa5,0x7d,0x3c,0x16,0xc1,0x72,0x51,0xb2,0x66,0x45,
    0xdf,0x4c,0x2f,0x87,0xeb,0xc0,0x99,0x2a,0xb1,0x77,0xfb,0xa5,0x1d,0xb9,0x2c,0x2a
};

// RFC 7748 §6.1 Bob private scalar.
static const uint8_t bob_priv[32] = {
    0x5d,0xab,0x08,0x7e,0x62,0x4a,0x8a,0x4b,0x79,0xe1,0x7f,0x8b,0x83,0x80,0x0e,0xe6,
    0x6f,0x3b,0xb1,0x29,0x26,0x18,0xb6,0xfd,0x1c,0x2f,0x8b,0x27,0xff,0x88,0xe0,0xeb
};

static void print_bytes(const uint8_t *b) {
    for (int i = 0; i < 32; i++) {
        printf("%02x", b[i]);
    }
    printf("\n");
}

int main(void) {
    uint8_t alice_pub[32];
    uint8_t bob_pub[32];
    uint8_t shared_ab[32];
    uint8_t shared_ba[32];

    // 1. Alice's public key: base·alice.
    crypto_x25519_public_key(alice_pub, alice_priv);
    print_bytes(alice_pub);

    // 2. Bob's public key: base·bob.
    crypto_x25519_public_key(bob_pub, bob_priv);
    print_bytes(bob_pub);

    // 3. Shared secret from Alice's side: x25519(alice, bob_pub).
    crypto_x25519(shared_ab, alice_priv, bob_pub);
    print_bytes(shared_ab);

    // 4. Shared secret from Bob's side: x25519(bob, alice_pub).
    crypto_x25519(shared_ba, bob_priv, alice_pub);
    print_bytes(shared_ba);

    return 0;
}
