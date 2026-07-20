#!/bin/sh
# Find a CDC-NCM / USB gadget netdev for SETU6 host probe.
# Prefer classic usb0 / ncm*; else systemd enx* with cdc_ncm (Pixel Graphene tether).
set -eu
name=$(ip -o link show 2>/dev/null | grep -oE '(usb0|ncm[0-9]+)' | head -1 || true)
if [ -n "${name}" ]; then
  printf '%s\n' "${name}"
  exit 0
fi
for leaf in /sys/class/net/enx*/cdc_ncm; do
  if [ -d "${leaf}" ]; then
    basename "$(dirname "${leaf}")"
    exit 0
  fi
done
ip -o link show up 2>/dev/null | grep -oE 'enx[0-9a-f]+' | head -1 || true
