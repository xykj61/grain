// tools/fixtures/monocypher_chacha20_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN ChaCha20
// (IETF, RFC 8439) keystream and ciphertext, so tools/crypto_monocypher_chacha20_parity_witness.rish can diff Monocypher's bytes against our authored
// crypto/chacha20.rye byte-for-byte. The parity TARGET made real for the stream cipher the whole ChaCha/Poly line is built on — the keystream every
// AEAD, Vault seal, and Comlink session enciphers against. Season G (Cryptography · Rye-native, Monocypher-parity, audit-ready).
//
// crypto/chacha20.rye's own selftest names Monocypher-source parity as an honest held horizon; this harness closes it. ChaCha20 was proven inside the
// AEAD flagship, yet never STANDALONE against Monocypher's own crypto_chacha20_ietf. Six lines print, in order: the RFC 8439 §2.3.2 keystream block for
// counter 1 (produced by enciphering 64 zero bytes — the keystream itself), the RFC 8439 §2.4.2 ciphertext of the RFC's 114-byte plaintext at counter 1,
// then keystream-over-deterministic-message lines for sizes {0, 5, 64, 200} at raised counters (empty · sub-block · exact 64-byte boundary · multi-block),
// each message byte i generated as (i*11 + 3) mod 256 and counter si*7 — the same coverage crypto/chacha20.rye's selftest uses. Each line is 2 hex
// characters per byte.
//
// Clean-room: this harness studies Monocypher's PUBLIC crypto_chacha20_ietf API and links the unmodified vendored source; it copies no line into our
// Rye (.claude/rules/gratitude-licenses.md). Purely local — no key of ours, no network, no funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src <this> vendor/monocypher/src/monocypher.c -o crypto/bin/monocypher_chacha20

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "monocypher.h"

// RFC 8439 key 00 01 02 ... 1f.
static const uint8_t rfc_key[32] = {
    0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0a,0x0b,0x0c,0x0d,0x0e,0x0f,
    0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1a,0x1b,0x1c,0x1d,0x1e,0x1f
};

// RFC 8439 §2.3.2 block nonce and §2.4.2 encryption nonce.
static const uint8_t rfc_block_nonce[12] = { 0x00,0x00,0x00,0x09,0x00,0x00,0x00,0x4a,0x00,0x00,0x00,0x00 };
static const uint8_t rfc_enc_nonce[12]   = { 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x4a,0x00,0x00,0x00,0x00 };

// RFC 8439 §2.4.2 canonical plaintext — the standard's own published test string, reproduced byte-for-byte as the neutral reference.
static const char rfc_plaintext[] =
    "Ladies and Gentlemen of the class of '99: If I could offer you only one tip for the future, sunscreen would be it.";

static void print_bytes(const uint8_t *b, uint32_t n) {
    for (uint32_t i = 0; i < n; i++) {
        printf("%02x", b[i]);
    }
    printf("\n");
}

int main(void) {
    uint8_t buf[256];
    uint8_t zeros[64] = {0};

    // 1. RFC 8439 §2.3.2 keystream block for counter 1 — enciphering 64 zero bytes yields the keystream itself.
    crypto_chacha20_ietf(buf, zeros, 64, rfc_key, rfc_block_nonce, 1);
    print_bytes(buf, 64);

    // 2. RFC 8439 §2.4.2 encryption of the RFC's 114-byte plaintext at counter 1.
    uint32_t ptlen = (uint32_t)strlen(rfc_plaintext);
    crypto_chacha20_ietf(buf, (const uint8_t *)rfc_plaintext, ptlen, rfc_key, rfc_enc_nonce, 1);
    print_bytes(buf, ptlen);

    // 3..6. Keystream over deterministic messages at raised counters — byte i = (i*11 + 3) mod 256, counter si*7.
    static const uint32_t sizes[4] = { 0, 5, 64, 200 };
    for (uint32_t si = 0; si < 4; si++) {
        uint32_t sz = sizes[si];
        uint8_t msg[256];
        for (uint32_t i = 0; i < sz; i++) {
            msg[i] = (uint8_t)(i * 11 + 3);
        }
        crypto_chacha20_ietf(buf, msg, sz, rfc_key, rfc_enc_nonce, si * 7);
        print_bytes(buf, sz);
    }

    return 0;
}
