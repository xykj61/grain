/*
 * proven-seat signed-Kumara — posix guest pair (verify + refuse).
 *
 * Includes teacher headers by path and generated fixture_receipt.h.
 * Two checks only:
 *   positive — crypto_ed25519_check(sig_good) == 0
 *   negative — crypto_ed25519_check(sig_tampered) != 0
 * Seed never crosses; host Kumara signed the fixture.
 */

#include <stdio.h>
#include <stdint.h>

#include <monocypher.h>
#include <monocypher-ed25519.h>
#include "fixture_receipt.h"

int main(void)
{
	int good = crypto_ed25519_check(
		fixture_sig_good,
		fixture_pub,
		(const uint8_t *)fixture_message,
		fixture_message_len);

	if (good != 0) {
		printf("RED: signed-Kumara — good signature refused\n");
		return 1;
	}
	printf("GREEN: signed-Kumara — signature holds; seat verifies (amount 100)\n");

	int bad = crypto_ed25519_check(
		fixture_sig_tampered,
		fixture_pub,
		(const uint8_t *)fixture_message,
		fixture_message_len);

	if (bad == 0) {
		printf("RED: signed-Kumara — tampered signature wrongly accepted\n");
		return 1;
	}
	printf("GREEN: signed-Kumara — tampered signature refused; seat stands guard\n");
	return 0;
}
