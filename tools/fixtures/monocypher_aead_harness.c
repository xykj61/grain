// tools/fixtures/monocypher_aead_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN
// ChaCha20-Poly1305 AEAD ciphertext and tag over RFC 8439 §2.8.2's key, nonce, associated data, and plaintext, so
// tools/crypto_monocypher_aead_parity_witness.rish can diff Monocypher's bytes against our authored crypto/aead.rye byte-for-byte. The parity
// TARGET made real for the authenticated-encryption seal Lotus's signed carry, Vault, and Comlink will reach for. Season G (Cryptography ·
// Rye-native, Monocypher-parity, audit-ready) — the FOURTH primitive line the decision wave named, closing ChaCha/Poly against the source.
//
// The AEAD is Monocypher's authenticated stream initialized IETF (crypto_aead_init_ietf, the 12-byte nonce), which is byte-for-byte RFC 8439
// §2.8: a one-time Poly1305 key from ChaCha20 block counter 0, the plaintext enciphered from block counter 1, and the tag over
// ad ‖ pad16(ad) ‖ cipher ‖ pad16(cipher) ‖ le64(ad_size) ‖ le64(text_size). A single crypto_aead_write over the whole message reproduces the
// RFC construction exactly. The two printed lines are, in order: the ciphertext (114 bytes → 228 hex characters) and the 16-byte tag (32 hex).
//
// Clean-room: this harness studies Monocypher's PUBLIC crypto_aead_init_ietf / crypto_aead_write API and links the unmodified vendored source;
// it copies no line into our Rye (.claude/rules/gratitude-licenses.md). Purely local — the key and nonce are the RFC's public vectors, no key of
// ours, no signature, no network, no funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src <this> vendor/monocypher/src/monocypher.c -o crypto/bin/monocypher_aead

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "monocypher.h"

// RFC 8439 §2.8.2 key (0x80..0x9f).
static const uint8_t rfc_key[32] = {
    0x80,0x81,0x82,0x83,0x84,0x85,0x86,0x87,0x88,0x89,0x8a,0x8b,0x8c,0x8d,0x8e,0x8f,
    0x90,0x91,0x92,0x93,0x94,0x95,0x96,0x97,0x98,0x99,0x9a,0x9b,0x9c,0x9d,0x9e,0x9f
};

// RFC 8439 §2.8.2 IETF nonce: the constant 07:00:00:00 then the 64-bit IV 40..47.
static const uint8_t rfc_nonce[12] = {
    0x07,0x00,0x00,0x00,0x40,0x41,0x42,0x43,0x44,0x45,0x46,0x47
};

// RFC 8439 §2.8.2 associated data.
static const uint8_t rfc_aad[12] = {
    0x50,0x51,0x52,0x53,0xc0,0xc1,0xc2,0xc3,0xc4,0xc5,0xc6,0xc7
};

// RFC 8439 §2.8.2 plaintext — the sunscreen line, 114 bytes.
static const char rfc_plaintext[] =
    "Ladies and Gentlemen of the class of '99: If I could offer you only one tip for the future, sunscreen would be it.";

static void print_hex(const uint8_t *b, size_t n) {
    for (size_t i = 0; i < n; i++) {
        printf("%02x", b[i]);
    }
    printf("\n");
}

int main(void) {
    size_t text_size = sizeof(rfc_plaintext) - 1; // drop the trailing NUL — 114 bytes.
    uint8_t cipher[128];
    uint8_t tag[16];

    // The IETF-initialized authenticated stream is RFC 8439 §2.8; one write over the whole message matches the RFC construction exactly.
    crypto_aead_ctx ctx;
    crypto_aead_init_ietf(&ctx, rfc_key, rfc_nonce);
    crypto_aead_write(&ctx, cipher, tag, rfc_aad, sizeof(rfc_aad),
                      (const uint8_t *)rfc_plaintext, text_size);
    crypto_wipe(&ctx, sizeof(ctx));

    // 1. The ciphertext (114 bytes → 228 hex characters).
    print_hex(cipher, text_size);

    // 2. The 16-byte Poly1305 tag (32 hex characters).
    print_hex(tag, 16);

    return 0;
}
