// tools/fixtures/pqclean_slhdsa_thash_harness.c -- the vendored PQClean (vendor/pqclean, CC0-1.0) asked for its OWN prf_addr and thash over
// exactly the inputs crypto/slhdsa_thash.rye's selftest prints, so tools/crypto_slhdsa_thash_witness.rish can diff the two implementations
// function-for-function rather than only at the top of the scheme. Rung DISC0 of the SLH-DSA ladder (Season G -- Cryptography).
//
// WHY FUNCTION-LEVEL PARITY MATTERS HERE. A hash-based signature is correct or incorrect entirely in its ADDRESSING: a field written one byte
// off silently merges two hash domains that FIPS 205 keeps apart. A top-level sign/verify vector would eventually catch a broken address, yet
// it would not say WHICH field moved. Diffing prf_addr and thash directly names the fault at the rung that owns it.
//
// The five lines printed here correspond one-for-one, in order, to the five the Rye selftest prints:
//   1. PRF at a fully-populated address
//   2. T_1 -- the standard's F, one block
//   3. T_2 -- the standard's H, two blocks
//   4. T_22 -- the width FORS compresses its tree roots at
//   5. T_67 -- the width a WOTS+ public key compresses at
//
// Every input is a test constant matching the Rye side byte for byte: public seed byte i = i, secret seed byte i = i + 128, the one-block
// message byte i = 3i + 1, the two-block message byte i = 5i + 2, and the wide message byte i = 7i + 3.
//
// Clean-room: this harness calls PQClean's PUBLIC (namespaced, non-static) internal API and links the unmodified vendored source; it copies no
// line into our Rye (.claude/rules/gratitude-licenses.md). Purely local -- no real key, no network, no funds, no device.

#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>

#include "params.h"
#include "context.h"
#include "address.h"
#include "hash.h"
#include "thash.h"

#define ADDR_LAYER     3
#define ADDR_TREE      8
#define ADDR_TYPE      19
#define ADDR_KEYPAIR   22
#define ADDR_CHAIN     27
#define ADDR_HASH      31

static void print_hex(const uint8_t *bytes, size_t len) {
    for (size_t i = 0; i < len; i++) {
        printf("%02x", bytes[i]);
    }
    printf("\n");
}

int main(void) {
    spx_ctx ctx;
    for (size_t i = 0; i < SPX_N; i++) {
        ctx.pub_seed[i] = (uint8_t)i;
        ctx.sk_seed[i] = (uint8_t)(i + 128);
    }
    initialize_hash_function(&ctx);

    // The same fully-populated address the Rye selftest builds: layer 5, tree 0x0011223344556677, type WOTS_HASH, key pair 0x0abc,
    // chain 17, hash step 9. Built through PQClean's OWN setters, so the two implementations are compared on the addressing too.
    uint32_t addr[8];
    memset(addr, 0, sizeof addr);
    set_layer_addr(addr, 5);
    set_tree_addr(addr, 0x0011223344556677ULL);
    set_type(addr, SPX_ADDR_TYPE_WOTS);
    set_keypair_addr(addr, 0x0abc);
    set_chain_addr(addr, 17);
    set_hash_addr(addr, 9);

    uint8_t out[SPX_N];

    // 1. PRF at that address.
    prf_addr(out, &ctx, addr);
    print_hex(out, SPX_N);

    // 2. T_1 -- one block, byte i = 3i + 1.
    uint8_t one[SPX_N];
    for (size_t i = 0; i < SPX_N; i++) {
        one[i] = (uint8_t)(i * 3 + 1);
    }
    thash(out, one, 1, &ctx, addr);
    print_hex(out, SPX_N);

    // 3. T_2 -- two blocks, byte i = 5i + 2.
    uint8_t two[2 * SPX_N];
    for (size_t i = 0; i < 2 * SPX_N; i++) {
        two[i] = (uint8_t)(i * 5 + 2);
    }
    thash(out, two, 2, &ctx, addr);
    print_hex(out, SPX_N);

    // 4 & 5. The wide message, byte i = 7i + 3, compressed at the FORS width and then at the WOTS+ width.
    uint8_t many[SPX_WOTS_LEN * SPX_N];
    for (size_t i = 0; i < sizeof many; i++) {
        many[i] = (uint8_t)(i * 7 + 3);
    }
    thash(out, many, SPX_FORS_TREES, &ctx, addr);
    print_hex(out, SPX_N);

    thash(out, many, SPX_WOTS_LEN, &ctx, addr);
    print_hex(out, SPX_N);

    return 0;
}
