// tools/fixtures/monocypher_hmac_sha512_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN
// HMAC-SHA-512 tags, so tools/crypto_monocypher_hmac_sha512_parity_witness.rish can diff Monocypher's bytes against our authored crypto/hmac_sha512.rye
// byte-for-byte. The parity TARGET made real for the keyed MAC HKDF-SHA512 and BIP32 key derivation are built on (RFC 2104 / RFC 4231). Season G
// (Cryptography · Rye-native, Monocypher-parity, audit-ready).
//
// crypto/hmac_sha512.rye's own selftest names Monocypher-source parity as an honest held horizon; this harness closes it. Five lines print, in order:
// RFC 4231 Test Case 1 (key 0x0b*20, "Hi There"), Test Case 2 (key "Jefe", "what do ya want for nothing?"), then an exact-block-length key (128 bytes)
// over "abc" (the K0-fits-block path), a longer-than-block key (200 bytes) over a 300-byte multi-block message (the hash-the-key path), and the empty
// message under a short key — the same coverage crypto/hmac_sha512.rye's selftest uses. Each line is 128 lowercase hex characters (2 per tag byte).
//
// Monocypher's HMAC-SHA-512 lives in its OPTIONAL module (src/optional/monocypher-ed25519.c, crypto_sha512_hmac) — the RFC 2104 building block for its
// optional Ed25519 line — so the harness links that source too. Clean-room: this studies Monocypher's PUBLIC crypto_sha512_hmac API and links the
// unmodified vendored source; it copies no line into our Rye (.claude/rules/gratitude-licenses.md). Purely local — no key of ours, no network, no funds,
// no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src -I vendor/monocypher/src/optional <this> \
//       vendor/monocypher/src/monocypher.c vendor/monocypher/src/optional/monocypher-ed25519.c -o crypto/bin/monocypher_hmac_sha512

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "monocypher.h"
#include "monocypher-ed25519.h"

static void print_tag(const uint8_t *key, uint32_t key_size, const uint8_t *msg, uint32_t msg_size) {
    uint8_t tag[64];
    crypto_sha512_hmac(tag, key, key_size, msg, msg_size);
    for (uint32_t i = 0; i < 64; i++) {
        printf("%02x", tag[i]);
    }
    printf("\n");
}

int main(void) {
    // 1. RFC 4231 Test Case 1 — key 0x0b repeated 20 times, message "Hi There".
    uint8_t key1[20];
    for (uint32_t i = 0; i < 20; i++) key1[i] = 0x0b;
    print_tag(key1, 20, (const uint8_t *)"Hi There", 8);

    // 2. RFC 4231 Test Case 2 — key "Jefe", message "what do ya want for nothing?".
    print_tag((const uint8_t *)"Jefe", 4, (const uint8_t *)"what do ya want for nothing?", 28);

    // 3. An exact-block-length key (128 bytes, byte i = i) over "abc" — the K0-fits-block path.
    uint8_t keyb[128];
    for (uint32_t i = 0; i < 128; i++) keyb[i] = (uint8_t)i;
    print_tag(keyb, 128, (const uint8_t *)"abc", 3);

    // 4. A longer-than-block key (200 bytes, byte i = (i*3 + 1) mod 256) over a 300-byte multi-block message — the hash-the-key path.
    uint8_t keyl[200];
    for (uint32_t i = 0; i < 200; i++) keyl[i] = (uint8_t)(i * 3 + 1);
    uint8_t multi[300];
    for (uint32_t i = 0; i < 300; i++) multi[i] = (uint8_t)(i * 7 + 1);
    print_tag(keyl, 200, multi, 300);

    // 5. The empty message under the short RFC key 0x0b*20.
    print_tag(key1, 20, (const uint8_t *)"", 0);

    return 0;
}
