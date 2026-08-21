// tools/fixtures/pqclean_slhdsa_harness.c -- the vendored PQClean (vendor/pqclean, CC0-1.0), compiled and asked for its OWN
// SLH-DSA-SHAKE-256s ("SPHINCS+-shake-256s-simple") keypair, signature, and verdict over a fixed seed and two canonical
// messages, so tools/crypto_slhdsa_oracle_witness.rish can hold it as the SECOND independent implementation the doubled-oracle
// discipline requires. Season G (Cryptography -- Rye-native, audit-ready).
//
// WHY THIS FILE EXISTS. active-designing/20260816-161537_post-quantum-mlkem-mldsa-pivot.md pivoted Kumara's post-quantum leg from
// SLH-DSA to ML-KEM + ML-DSA on one honest fact: the vendored Zig toolchain ships independent implementations of the two lattice
// standards and NO SLH-DSA, so a hash-based rung would have had a single external oracle (the NIST KAT alone) and broken the
// doubled-oracle discipline the whole crypto/ shelf rests on. Keaton's word (`20260821`) answers that trade rather than picking a
// side of it: vendor a second SLH-DSA implementation and keep BOTH legs. This harness IS that second implementation, made real.
//
// DETERMINISM, NAMED HONESTLY. The keypair grows from a 96-byte seed via crypto_sign_seed_keypair and is deterministic outright.
// Signing is NOT: FIPS 205 allows a "hedged" variant that mixes a fresh optrand into the message-digest randomization, and PQClean
// takes it -- sign.c calls randombytes(optrand, SPX_N) before gen_message_random. Left alone, the same key would sign the same
// message to a different 29,792 bytes on every run, which is fine cryptography and useless as a diffable oracle.
//
// So this HARNESS supplies the randomness source, which is the harness's own job and leaves the vendored library untouched: the
// PQCLEAN_randombytes below is deterministic, filling each request with a fixed counter pattern. Nothing in vendor/pqclean is
// modified -- the symbol is simply resolved here rather than by common/randombytes.c, exactly as PQClean's own test vectors do it.
// With optrand pinned, two independent implementations handed the same seed, the same message, and the same optrand must agree
// byte for byte, which is what makes this a diffable oracle. A future Rye rung therefore takes optrand as an explicit parameter
// rather than reaching for entropy, and its hedged path can draw a real one at the edge.
//
// Clean-room: this harness studies PQClean's PUBLIC api.h and links the unmodified vendored source; it copies no line into our Rye
// (.claude/rules/gratitude-licenses.md). PQClean is the parity TARGET, exactly as Monocypher is for the classical shelf.
//
// HONEST SCOPE -- purely local. The seed is a published-style test constant (byte i = i), never a real key; no network, no funds,
// no device. Growing a REAL post-quantum identity from the maintainer's own phrase stays the custody gate.
//
// Built and run by the witness with zig cc over the scheme's `clean` sources plus common/fips202.c.

#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include "api.h"

#define SCHEME_PREFIX PQCLEAN_SPHINCSSHAKE256SSIMPLE_CLEAN_
#define PK_BYTES  PQCLEAN_SPHINCSSHAKE256SSIMPLE_CLEAN_CRYPTO_PUBLICKEYBYTES
#define SK_BYTES  PQCLEAN_SPHINCSSHAKE256SSIMPLE_CLEAN_CRYPTO_SECRETKEYBYTES
#define SIG_BYTES PQCLEAN_SPHINCSSHAKE256SSIMPLE_CLEAN_CRYPTO_BYTES
#define SEED_BYTES PQCLEAN_SPHINCSSHAKE256SSIMPLE_CLEAN_CRYPTO_SEEDBYTES

// A signature is 29,792 bytes -- far too long to print whole and still read as a witness line, so each long artifact is
// reported by its SHAKE-256 digest. The digest is taken with PQClean's own fips202, the same sponge the scheme signs with,
// so the harness introduces no primitive of its own.
#include "fips202.h"

// The deterministic randomness source. PQClean's sign.c and keypair both declare this symbol and leave its definition to the
// caller; supplying it here pins optrand so the oracle reproduces. Byte i of every request is (i * 31 + 7) & 0xff -- an arbitrary
// fixed pattern, chosen only to be plainly not-all-zero and easy for a second implementation to reproduce exactly.
void PQCLEAN_randombytes(uint8_t *output, size_t n);
void PQCLEAN_randombytes(uint8_t *output, size_t n) {
    for (size_t i = 0; i < n; i++) {
        output[i] = (uint8_t)((i * 31 + 7) & 0xff);
    }
}

static void print_hex(const uint8_t *bytes, size_t len) {
    for (size_t i = 0; i < len; i++) {
        printf("%02x", bytes[i]);
    }
    printf("\n");
}

static void print_digest_of(const uint8_t *bytes, size_t len) {
    uint8_t digest[32];
    shake256(digest, sizeof digest, bytes, len);
    print_hex(digest, sizeof digest);
}

int main(void) {
    // The fixed 96-byte seed: byte i = i. A test constant, never a real key.
    uint8_t seed[SEED_BYTES];
    for (size_t i = 0; i < SEED_BYTES; i++) {
        seed[i] = (uint8_t)(i & 0xff);
    }

    static uint8_t pk[PK_BYTES];
    static uint8_t sk[SK_BYTES];
    if (PQCLEAN_SPHINCSSHAKE256SSIMPLE_CLEAN_crypto_sign_seed_keypair(pk, sk, seed) != 0) {
        fprintf(stderr, "seed_keypair failed\n");
        return 1;
    }

    // 1. The declared lengths, so a reader can check them against META.yml without trusting this file.
    printf("%zu %zu %zu %zu\n", (size_t)PK_BYTES, (size_t)SK_BYTES, (size_t)SIG_BYTES, (size_t)SEED_BYTES);

    // 2. The public key whole -- 64 bytes, short enough to read.
    print_hex(pk, PK_BYTES);

    // 3. The secret key by digest.
    print_digest_of(sk, SK_BYTES);

    static const char *messages[2] = { "", "abc" };
    static const size_t lengths[2] = { 0, 3 };

    static uint8_t sig[SIG_BYTES];
    for (int m = 0; m < 2; m++) {
        size_t siglen = 0;
        const uint8_t *msg = (const uint8_t *)messages[m];
        if (PQCLEAN_SPHINCSSHAKE256SSIMPLE_CLEAN_crypto_sign_signature(sig, &siglen, msg, lengths[m], sk) != 0) {
            fprintf(stderr, "sign failed\n");
            return 1;
        }
        if (siglen != SIG_BYTES) {
            fprintf(stderr, "signature length %zu is not the declared %zu\n", siglen, (size_t)SIG_BYTES);
            return 1;
        }

        // 4 & 6. Each signature by digest -- deterministic, so a second implementation must match it.
        print_digest_of(sig, siglen);

        // 5 & 7. The genuine signature verifies, and a signature with one flipped bit does not.
        int good = PQCLEAN_SPHINCSSHAKE256SSIMPLE_CLEAN_crypto_sign_verify(sig, siglen, msg, lengths[m], pk);
        sig[0] ^= 0x01;
        int tampered = PQCLEAN_SPHINCSSHAKE256SSIMPLE_CLEAN_crypto_sign_verify(sig, siglen, msg, lengths[m], pk);
        sig[0] ^= 0x01;
        printf("%s %s\n", good == 0 ? "accept" : "refuse", tampered != 0 ? "refuse" : "accept");
    }

    return 0;
}
