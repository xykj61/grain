#!/bin/sh
# tools/fixtures/s/socket_dialect_control.sh -- proves the socket-dialect meter on planted repositories.
#
# WHY A CONTROL. The fault this meter counts is silent on the pier that carries it: a Linux number
# is the right number on Linux, so a scan written here and never proven can read zero forever and
# look exactly like a clean tree. That is REDS %240's confident wrong zero, and it is why every
# reading below is shown from BOTH sides -- the shape that must be counted is planted and watched
# to refuse, and the shape that must pass free is planted beside it and watched to pass. A wall
# proven only in the passing direction cannot be told from a bypass.
#
# Each pen is a real git repository in a throwaway directory, because the scan draws its corpus
# with `git ls-files`.
#
# USAGE
#   sh tools/fixtures/s/socket_dialect_control.sh
#
# Driven by tools/s/socket_dialect_witness.rish. Run from the repository root.

set -u

SCAN=$(CDPATH= cd "$(dirname "$0")" && pwd)/socket_dialect_scan.sh
[ -f "$SCAN" ] || { echo "control_verdict=scan_absent" >&2; exit 1; }

pen_root=$(mktemp -d)
trap 'rm -rf "$pen_root"' EXIT INT TERM

fails=0
note() { echo "$1"; }
want() { # want <name> <expected ok|refuse> <actual exit>
  if [ "$2" = "ok" ] && [ "$3" -eq 0 ]; then note "$1=yes"; return; fi
  if [ "$2" = "refuse" ] && [ "$3" -ne 0 ]; then note "$1=yes"; return; fi
  note "$1=no"; fails=$((fails + 1))
}
reads() { # reads <name> <key> <want> <pen>
  v=$(sed -n "s/^$2=//p" "$4/.out")
  [ "$v" = "$3" ] && note "$1=yes" || { note "$1=no ($2 read $v, wanted $3)"; fails=$((fails + 1)); }
}

new_pen() { # new_pen <name> -- prints the pen path
  p=$pen_root/$1
  mkdir -p "$p"
  ( cd "$p" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )
  echo "$p"
}
stage() { ( cd "$1" && git add -A . >/dev/null 2>&1 ); }
run_scan() { sh "$SCAN" --root "$1" >"$1/.out" 2>"$1/.err"; echo $?; }

# ---- Reading one: a dispatched module passes free and is reported as dispatched.
pen=$(new_pen dispatched)
printf 'const c = std.c;\nconst sockaddr_in = c.sockaddr.in;\nconst SOL_SOCKET: c_int = c.SOL.SOCKET;\n' > "$pen/a.rye"
stage "$pen"; want dispatched_passes ok "$(run_scan "$pen")"
reads dispatched_option_not_counted option_files 0 "$pen"
reads dispatched_layout_not_counted linux_layout_files 0 "$pen"
reads dispatched_reported dispatched_files 1 "$pen"

# ---- Reading two: the portable-identical constants are deliberately NOT counted.
pen=$(new_pen portable)
printf 'const AF_INET: c_uint = 2;\nconst SOCK_DGRAM: c_uint = 2;\n' > "$pen/a.rye"
stage "$pen"; want portable_constants_pass ok "$(run_scan "$pen")"
reads portable_constants_not_counted option_files 0 "$pen"

# ---- Reading three: the option ceilings, from both sides.
ceil_opt_files=$(sed -n 's/^option_files_ceiling=//p' "$pen/.out")
ceil_opt_lines=$(sed -n 's/^option_lines_ceiling=//p' "$pen/.out")
pen=$(new_pen optceiling)
i=1
while [ "$i" -le "$ceil_opt_files" ]; do printf 'const SOL_SOCKET: c_int = 1;\n' > "$pen/f$i.rye"; i=$((i + 1)); done
stage "$pen"; want option_at_files_ceiling_passes ok "$(run_scan "$pen")"
reads option_files_at_ceiling option_files "$ceil_opt_files" "$pen"

printf 'const SOL_SOCKET: c_int = 1;\n' > "$pen/f$((ceil_opt_files + 1)).rye"
stage "$pen"; want option_over_files_ceiling_refused refuse "$(run_scan "$pen")"
grep -q 'option_top: ' "$pen/.out" && note "option_flag_named=yes" || { note "option_flag_named=no"; fails=$((fails + 1)); }

rm -f "$pen/f$((ceil_opt_files + 1)).rye"
# Each of the ceil_opt_files pens carries one line, so one past the LINE ceiling needs the
# difference plus one, all inside a single already-counted file.
over=$((ceil_opt_lines - ceil_opt_files + 2))
i=1; : > "$pen/f1.rye"
while [ "$i" -le "$over" ]; do printf 'const SO_REUSEADDR: c_int = 2;\n' >> "$pen/f1.rye"; i=$((i + 1)); done
stage "$pen"; want option_over_lines_ceiling_refused refuse "$(run_scan "$pen")"

# ---- Reading four: the Linux-layout ceiling, from both sides.
ceil_layout=$(sed -n 's/^linux_layout_files_ceiling=//p' "$pen/.out")
pen=$(new_pen layout)
i=1
while [ "$i" -le "$ceil_layout" ]; do printf 'const S = extern struct {\n    sin_family: c_ushort = 2,\n};\n' > "$pen/g$i.rye"; i=$((i + 1)); done
stage "$pen"; want layout_at_ceiling_passes ok "$(run_scan "$pen")"
reads layout_files_at_ceiling linux_layout_files "$ceil_layout" "$pen"

printf 'const S = extern struct {\n    sin_family: c_ushort = 2,\n};\n' > "$pen/g$((ceil_layout + 1)).rye"
stage "$pen"; want layout_over_ceiling_refused refuse "$(run_scan "$pen")"
grep -q 'layout_file: ' "$pen/.out" && note "layout_flag_named=yes" || { note "layout_flag_named=no"; fails=$((fails + 1)); }

# ---- Reading five: aurora, vendor, gratitude and dated testimony stand outside the corpus.
pen=$(new_pen excluded)
mkdir -p "$pen/aurora" "$pen/vendor/x" "$pen/gratitude"
printf 'const SOL_SOCKET: c_int = 1;\n' > "$pen/aurora/boot.rye"
printf 'const SOL_SOCKET: c_int = 1;\n' > "$pen/vendor/x/lib.rye"
printf 'const SOL_SOCKET: c_int = 1;\n' > "$pen/gratitude/read.rye"
printf 'const SOL_SOCKET: c_int = 1;\n' > "$pen/20260101-010101_dated.rye"
stage "$pen"; want excluded_rooms_pass ok "$(run_scan "$pen")"
reads excluded_not_counted option_files 0 "$pen"

# ---- Reading six: a file no roster names IS counted, so discovery genuinely reaches.
printf 'const SO_REUSEADDR: c_int = 2;\n' > "$pen/stranger.rye"
stage "$pen"; run_scan "$pen" >/dev/null
reads discovers_stranger option_files 1 "$pen"

echo "control_checks=18"
echo "control_failures=$fails"
if [ "$fails" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=behavior_missing" >&2
exit 1
