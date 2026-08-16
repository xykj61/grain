// tools/fixtures/monocypher_poly1305_harness.c — the vendored Monocypher (vendor/monocypher, CC0/BSD-dual), compiled and asked for its OWN
// Poly1305 one-time authenticator tags, so tools/crypto_monocypher_poly1305_parity_witness.rish can diff Monocypher's bytes against our authored
// crypto/poly1305.rye byte-for-byte. The parity TARGET made real for the MAC that authenticates every sealed message — the authenticator the AEAD
// flagship (crypto/aead.rye, crypto/xchacha20.rye) and every Vault/Comlink/Lotus sealed carry rest on. Season G (Cryptography · Rye-native,
// Monocypher-parity, audit-ready).
//
// crypto/poly1305.rye's own selftest names Monocypher-source parity as an honest held horizon ("its vendored source is a held fetch, so
// Monocypher-source parity is an honest horizon rung"). This harness closes that horizon: it links the ACTUAL vendored Monocypher and prints eight
// tags. The first seven are over deterministic messages of sizes {0, 1, 15, 16, 17, 34, 256} — the block edges the RFC's polynomial must cross (empty,
// sub-block, exact block, one byte over, the RFC's 34-byte length, and a 256-byte multi-block run) — each byte i generated as (i*7 + 1) mod 256, the
// same generation crypto/poly1305.rye's selftest uses. The eighth is the RFC 8439 §2.5.2 canonical message "Cryptographic Forum Research Group", whose
// published tag anchors the witness to the world. Every tag is under the RFC 8439 §2.5.2 one-time key. Each line is 32 lowercase hex characters.
//
// Clean-room: this harness studies Monocypher's PUBLIC crypto_poly1305 API and links the unmodified vendored source; it copies no line into our Rye
// (.claude/rules/gratitude-licenses.md). Purely local — no key of ours, no network, no funds, no device.
//
// Built and run by the witness with:
//   zig cc -O2 -I vendor/monocypher/src <this> vendor/monocypher/src/monocypher.c -o crypto/bin/monocypher_poly1305

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "monocypher.h"

// RFC 8439 §2.5.2 one-time key — a public test vector, never a real secret. First 16 bytes clamp into r; second 16 are the pad s.
static const uint8_t rfc_key[32] = {
    0x85,0xd6,0xbe,0x78,0x57,0x55,0x6d,0x33,0x7f,0x44,0x52,0xfe,0x42,0xd5,0x06,0xa8,
    0x01,0x03,0x80,0x8a,0xfb,0x0d,0xb2,0xfd,0x4a,0xbf,0xf6,0xaf,0x41,0x49,0xf5,0x1b
};

// RFC 8439 §2.5.2 canonical message — the standard's own published test string, reproduced byte-for-byte as the neutral reference.
static const char rfc_message[] = "Cryptographic Forum Research Group";

static void print_bytes(const uint8_t *b) {
    for (int i = 0; i < 16; i++) {
        printf("%02x", b[i]);
    }
    printf("\n");
}

int main(void) {
    // The block-edge sizes crypto/poly1305.rye's selftest crosses.
    static const uint32_t sizes[7] = { 0, 1, 15, 16, 17, 34, 256 };
    uint8_t msg[256];
    uint8_t mac[16];

    // 1..7. Deterministic messages over the block edges — byte i = (i*7 + 1) mod 256.
    for (int s = 0; s < 7; s++) {
        uint32_t sz = sizes[s];
        for (uint32_t i = 0; i < sz; i++) {
            msg[i] = (uint8_t)(i * 7 + 1);
        }
        crypto_poly1305(mac, msg, sz, rfc_key);
        print_bytes(mac);
    }

    // 8. RFC 8439 §2.5.2 canonical message — anchored to the published tag by the witness.
    crypto_poly1305(mac, (const uint8_t *)rfc_message, strlen(rfc_message), rfc_key);
    print_bytes(mac);

    return 0;
}
