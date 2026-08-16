// tools/fixtures/monocypher_xaead_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN
// XChaCha20-Poly1305 ciphertext and tag over a published known-answer, so tools/crypto_monocypher_xaead_parity_witness.rish can diff
// Monocypher's bytes against our authored crypto/xchacha20.rye byte-for-byte. The parity TARGET made real for Monocypher's FLAGSHIP AEAD —
// crypto_aead_lock, the 24-byte-nonce authenticated encryption Lotus's signed carry, Vault, and Comlink will actually reach for. Season G
// (Cryptography · Rye-native, Monocypher-parity, audit-ready) — the SIXTH Monocypher-source parity rung, past the four the decision wave named
// and the fifth (Argon2), closing the extended-nonce AEAD that the IETF-nonce AEAD rung did not exercise: the HChaCha20 subkey-derivation path.
//
// crypto_aead_lock IS XChaCha20-Poly1305 (draft-irtf-cfrg-xchacha §2.3): subkey = HChaCha20(key, nonce[0..16]); subnonce = 0x00000000 ‖
// nonce[16..24]; then the RFC 8439 ChaCha20-Poly1305 AEAD runs under (subkey, subnonce). Because the subkey depends on the whole 128-bit nonce
// prefix, the 24-byte nonce may be drawn at random per message without collision — the whole reason for the wider nonce. The two printed lines
// are, in order: the ciphertext (114 bytes → 228 hex characters) and the 16-byte Poly1305 tag (32 hex characters).
//
// Clean-room: this harness studies Monocypher's PUBLIC crypto_aead_lock API and links the unmodified vendored source; it copies no line into our
// Rye (.claude/rules/gratitude-licenses.md). Purely local — the key and nonce are a published test vector, no key of ours, no signature, no
// network, no funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src <this> vendor/monocypher/src/monocypher.c -o crypto/bin/monocypher_xaead

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "monocypher.h"

// The published XChaCha20-Poly1305 known-answer (Zig's own std.crypto neutral test vector, mirrored in crypto/xchacha20.rye's selftest):
// key 0x45 repeated, nonce 0x2a repeated, the RFC's 114-byte plaintext, associated data "Additional data".
static const uint8_t kat_key[32] = {
    0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45,
    0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45,0x45
};

static const uint8_t kat_nonce[24] = {
    0x2a,0x2a,0x2a,0x2a,0x2a,0x2a,0x2a,0x2a,0x2a,0x2a,0x2a,0x2a,
    0x2a,0x2a,0x2a,0x2a,0x2a,0x2a,0x2a,0x2a,0x2a,0x2a,0x2a,0x2a
};

static const char kat_aad[] = "Additional data";

// The RFC's 114-byte plaintext — the sunscreen line (a fixed published test vector string, byte-exact).
static const char kat_plaintext[] =
    "Ladies and Gentlemen of the class of '99: If I could offer you only one tip for the future, sunscreen would be it.";

static void print_hex(const uint8_t *b, size_t n) {
    for (size_t i = 0; i < n; i++) {
        printf("%02x", b[i]);
    }
    printf("\n");
}

int main(void) {
    size_t text_size = sizeof(kat_plaintext) - 1; // drop the trailing NUL — 114 bytes.
    size_t ad_size = sizeof(kat_aad) - 1;          // drop the trailing NUL — 15 bytes.
    uint8_t cipher[128];
    uint8_t tag[16];

    // Monocypher's flagship AEAD: crypto_aead_lock is XChaCha20-Poly1305, the 24-byte extended-nonce authenticated encryption.
    crypto_aead_lock(cipher, tag, kat_key, kat_nonce,
                     (const uint8_t *)kat_aad, ad_size,
                     (const uint8_t *)kat_plaintext, text_size);

    // 1. The ciphertext (114 bytes → 228 hex characters).
    print_hex(cipher, text_size);

    // 2. The 16-byte Poly1305 tag (32 hex characters).
    print_hex(tag, 16);

    return 0;
}
