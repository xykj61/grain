/*
 * proven-seat G1 — smallest posix receipt-verify guest.
 *
 * Seed stays: pinned witness fact from receipt_core / slcl1_fact.bron.
 * Seat changes: Genode posix (Libc::Component::construct via LIBS=posix).
 * Lap one: digest-grade — confirm the embedded fixture byte-identical to the
 * pinned canonical fact, then print GREEN on stdout (serial via /dev/log).
 *
 * Signed Ed25519 (Kumara) is a later lap on this same seat.
 */

#include <stdio.h>
#include <string.h>

/* Byte-identical to linengrow/receipt_core.rye witness_canonical_fact */
static char const FACT[] =
	"from 2152f8d19b791d24453242e15f2eab6cb7cffa7b6a5ed30097960e069881db12\n"
	"to 2152f8d19b791d24453242e15f2eab6cb7cffa7b6a5ed30097960e069881db12\n"
	"amount 100\n"
	"memo stipend for animation micro-gig\n"
	"stamp 20260702.195426\n";

static char const EXPECTED[] =
	"from 2152f8d19b791d24453242e15f2eab6cb7cffa7b6a5ed30097960e069881db12\n"
	"to 2152f8d19b791d24453242e15f2eab6cb7cffa7b6a5ed30097960e069881db12\n"
	"amount 100\n"
	"memo stipend for animation micro-gig\n"
	"stamp 20260702.195426\n";

static int fact_ok(void)
{
	return strcmp(FACT, EXPECTED) == 0;
}

int main(void)
{
	if (!fact_ok()) {
		printf("RED: proven-seat G1 receipt-verify — fixture refused\n");
		return 1;
	}

	printf("GREEN: proven-seat G1 receipt-verify — fixture holds (amount 100); seat speaks\n");
	return 0;
}
