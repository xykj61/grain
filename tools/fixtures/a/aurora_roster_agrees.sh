#!/bin/sh
# tools/fixtures/a/aurora_roster_agrees.sh -- the hart and the host speak one roster.
#
# Runs caravan/channels.rye selftest and the freestanding roster wake, then
# requires the domain count, the channel count, and the two-domain sentence
# to match. The numbers are read from the two outputs. Nothing here is a
# second copy of the roster.
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$root"

mkdir -p tools/.build
env RYE_ZIG=vendor/zig-toolchain/zig sh tools/fixtures/r/rye_build.sh caravan/channels.rye -femit-bin=tools/.build/aurora_channel_roster >/dev/null
tools/.build/aurora_channel_roster selftest > tools/.build/roster-host.txt 2>&1
rishi/bin/rishi run tools/au/aurora_run.rish roster > tools/.build/roster-hart.txt

awk '
  function num_before(file, word,    line, n, i, a) {
    while ((getline line < file) > 0) {
      n = split(line, a, /[ :]+/)
      for (i = 2; i <= n; i++) if (a[i] == word) { close(file); return a[i-1] }
    }
    close(file)
    return ""
  }
  function has_join(file,    line, found) {
    found = 0
    while ((getline line < file) > 0)
      if (index(line, "each channel names two declared domains") > 0) found = 1
    close(file)
    return found
  }
  BEGIN {
    host = "tools/.build/roster-host.txt"
    hart = "tools/.build/roster-hart.txt"
    hd = num_before(host, "domains")
    hc = num_before(host, "channels")
    ad = num_before(hart, "domains")
    ac = num_before(hart, "channels")
    hj = has_join(host)
    aj = has_join(hart)
    if (hd == "" || ad == "" || hd != ad) {
      printf "roster-agree domains host=%s hart=%s\n", hd, ad
      exit 1
    }
    if (hc == "" || ac == "" || hc != ac) {
      printf "roster-agree channels host=%s hart=%s\n", hc, ac
      exit 1
    }
    if (hj != 1 || aj != 1) {
      printf "roster-agree join host=%d hart=%d\n", hj, aj
      exit 1
    }
    hp = pairs(host)
    ap = pairs(hart)
    if (hp == "" || hp != ap) {
      printf "roster-agree pairs host=%s hart=%s\n", hp, ap
      exit 1
    }
    n = split(hp, parts, "|")
    printf "roster-agree domains=%s channels=%s join=two-declared pairs=%d\n", hd, hc, n
    print "GREEN"
  }
  function pairs(file,    line, acc, p) {
    acc = ""
    while ((getline line < file) > 0) {
      p = index(line, "pair ")
      if (p > 0) {
        if (acc != "") acc = acc "|"
        acc = acc substr(line, p)
      }
    }
    close(file)
    return acc
  }
' 
