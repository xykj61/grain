# tools/fixtures/u/utf8_valid.awk -- name every file whose bytes are not valid UTF-8.
#
# ONE PROCESS FOR THE WHOLE COLLECTION. This replaced a per-file shell probe that forked `mktemp`,
# `iconv` and `rm` for each of 14,709 tracked text files -- roughly 44,000 processes, and 137 of the
# roster's 1,510 seconds, for a reading that is cheap. The bytes were never the cost; the forks
# were. Measured on this pier: 137s -> 23s (REDS %412).
#
# RUN IT UNDER LC_ALL=C. That is what makes `substr` and `length` count BYTES rather than
# characters, and a validator that reads characters has already trusted the answer it was asked to
# check.
#
# WHAT IT REFUSES, and each is a real shape rather than a category:
#   a lead byte with too few continuations   (the orphan 0xC2 that REDS %198 found in four files)
#   a continuation byte with no lead         (0x80-0xBF standing alone)
#   an overlong or out-of-range lead         (0xC0, 0xC1, and anything above 0xF4)
#
# It prints one path per invalid file and nothing at all for a clean collection, so an empty output is
# the green reading and the caller counts lines.
BEGIN { for (j = 0; j < 256; j++) ord[sprintf("%c", j)] = j }
function bad(f) { if (!(f in seen)) { seen[f] = 1; print f } }
{
  n = length($0)
  i = 1
  while (i <= n) {
    b = ord[substr($0, i, 1)]
    if (b == "") b = 0
    if (b < 128) { i++; continue }
    # A lead byte names how many continuations must follow it; anything else is malformed here.
    if (b >= 194 && b <= 223) need = 1
    else if (b >= 224 && b <= 239) need = 2
    else if (b >= 240 && b <= 244) need = 3
    else { bad(FILENAME); next }
    if (i + need > n) { bad(FILENAME); next }
    for (k = 1; k <= need; k++) {
      cb = ord[substr($0, i + k, 1)]
      if (cb == "" || cb < 128 || cb > 191) { bad(FILENAME); next }
    }
    i += need + 1
  }
}
