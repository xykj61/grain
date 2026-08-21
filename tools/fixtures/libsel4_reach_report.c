/* tools/fixtures/libsel4_reach_report.c -- OUR OWN reporter beside the probe.
 * It prints what the probe read out of the vendored headers, so the witness
 * measures the vocabulary rather than reciting it. Held apart from the probe
 * on purpose: the probe compiles freestanding with no libc, and printing
 * needs one.
 */
#include <stdio.h>

unsigned long probe_error_count(void);
unsigned long probe_object_count(void);
unsigned long probe_nonarch_object_count(void);
unsigned long probe_word_bits(void);
unsigned long probe_max_prio(void);

int main(void)
{
    printf("errors=%lu objects=%lu nonarch=%lu wordbits=%lu maxprio=%lu\n",
           probe_error_count(), probe_object_count(),
           probe_nonarch_object_count(), probe_word_bits(),
           probe_max_prio());
    return 0;
}
