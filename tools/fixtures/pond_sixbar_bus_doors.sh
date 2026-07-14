#!/usr/bin/env bash
# pond_sixbar_bus_doors.sh — three-door session-bus measure (Claude 210800).
# Usage:
#   ./tools/fixtures/pond_sixbar_bus_doors.sh
#   ./tools/fixtures/pond_sixbar_bus_doors.sh --write-dir DIR
# Prints one line: bus_env=… bus_socket=… bus_netns=…
# With --write-dir, also writes bus_env / bus_socket / bus_netns one-word files.
set -euo pipefail

write_dir=""
if [ "${1:-}" = "--write-dir" ]; then
  write_dir="${2:?write-dir needs a path}"
  mkdir -p "$write_dir"
fi

if [ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
  bus_env=set
else
  bus_env=empty
fi

rd="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
if [ -S "${rd}/bus" ]; then
  bus_socket=present
else
  bus_socket=absent
fi

n="$(ip -o link show 2>/dev/null | grep -cvE '^[0-9]+: lo[:@]' || true)"
if [ "${n}" -gt 0 ]; then
  bus_netns=shared
else
  bus_netns=unshared
fi

if [ -n "$write_dir" ]; then
  printf '%s\n' "$bus_env" >"${write_dir}/bus_env"
  printf '%s\n' "$bus_socket" >"${write_dir}/bus_socket"
  printf '%s\n' "$bus_netns" >"${write_dir}/bus_netns"
fi

printf 'bus_env=%s bus_socket=%s bus_netns=%s\n' "$bus_env" "$bus_socket" "$bus_netns"
