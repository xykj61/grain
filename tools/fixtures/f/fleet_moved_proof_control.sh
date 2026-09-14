#!/bin/sh
# fleet_moved_proof_control.sh -- both decisions and every conservative refusal.
set -eu

root=$(git rev-parse --show-toplevel)
tool="$root/tools/f/fleet_moved_proof.sh"
pen=$(mktemp -d "${TMPDIR:-/tmp}/fleet-moved-proof-control.XXXXXX")
trap 'rm -rf "$pen"' EXIT HUP INT TERM

git -C "$pen" init -q
git -C "$pen" config user.email control@example.invalid
git -C "$pen" config user.name control
mkdir -p "$pen/alpha" "$pen/beta" "$pen/unknown"
printf 'one\n' > "$pen/alpha/a"
printf 'one\n' > "$pen/beta/b"
printf 'one\n' > "$pen/unknown/u"
git -C "$pen" add .
git -C "$pen" commit -qm base
base=$(git -C "$pen" rev-parse HEAD)

{
  echo '#!/bin/sh'
  echo "printf 'alpha_guard alpha/\\nbeta_guard beta/\\n'"
} > "$pen/map"
chmod +x "$pen/map"

printf 'two\n' > "$pen/alpha/a"
git -C "$pen" commit -qam local
local_head=$(git -C "$pen" rev-parse HEAD)
git -C "$pen" checkout -q -b upstream "$base"
printf 'two\n' > "$pen/beta/b"
git -C "$pen" commit -qam upstream
upstream_head=$(git -C "$pen" rev-parse HEAD)
git -C "$pen" checkout -q master

run() {
  FLEET_SCOPE_MAP="$pen/map" sh "$tool" "$@"
}

out=$(cd "$pen" && run "$base" "$base" "$upstream_head")
printf '%s\n' "$out" | grep -q '^proof_scope=scoped$'
printf '%s\n' "$out" | grep -q '^proof_reason=independent$'
printf '%s\n' "$out" | grep -q '^local_guard_names=alpha_guard$'
printf '%s\n' "$out" | grep -q '^upstream_guard_names=beta_guard$'

git -C "$pen" checkout -q upstream
git -C "$pen" checkout -q -b overlap "$base"
printf 'three\n' > "$pen/alpha/a"
git -C "$pen" commit -qam overlap
overlap_head=$(git -C "$pen" rev-parse HEAD)
git -C "$pen" checkout -q master
out=$(cd "$pen" && run "$base" "$base" "$overlap_head")
printf '%s\n' "$out" | grep -q '^proof_scope=full$'
printf '%s\n' "$out" | grep -q '^proof_reason=proof_overlap$'

git -C "$pen" checkout -q -b unknown "$base"
printf 'two\n' > "$pen/unknown/u"
git -C "$pen" commit -qam unknown
unknown_head=$(git -C "$pen" rev-parse HEAD)
git -C "$pen" checkout -q master
out=$(cd "$pen" && run "$base" "$base" "$unknown_head")
printf '%s\n' "$out" | grep -q '^proof_reason=map_unknown$'

out=$(cd "$pen" && FLEET_SCOPE_MAP="$pen/absent" sh "$tool" "$base" "$base" "$base")
printf '%s\n' "$out" | grep -q '^proof_reason=map_absent$'
out=$(cd "$pen" && run missing "$base" "$base")
printf '%s\n' "$out" | grep -q '^proof_reason=ref_unreadable$'

echo 'control_verdict=ok'
echo 'control_legs=5'
