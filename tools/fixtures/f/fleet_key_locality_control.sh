#!/bin/sh
# Proves fleet_key_locality_scan.sh on real git repositories in a throwaway pen -- every refusal
# shown from BOTH sides, planted and then removed, because a refusal proven only in the passing
# direction cannot be told from a bypass.
set -u
src=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/fleet_key_locality_scan.sh
pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT
pass=0; fail=0
ck() { # ck <name> <expected-substring> <actual>
  if printf '%s' "$3" | grep -q -- "$2"; then pass=$((pass+1)); else
    fail=$((fail+1)); echo "  FAIL $1: wanted '$2'"; printf '%s\n' "$3" | sed 's/^/        /'; fi
}

# A pier with two trees. The scan resolves its own tree from $0 and the pier from its parent.
mkdir -p "$pen/grain-alpha/tools/fixtures/f" "$pen/grain-beta/tools/fixtures/f"
for t in alpha beta; do
  git init -q "$pen/grain-$t" 2>/dev/null
  mkdir -p "$pen/grain-$t/.gnupg-rye" "$pen/grain-$t/.ssh"
  printf '#!/bin/sh\nexec gpg "$@"\n' > "$pen/grain-$t/.gnupg-rye/gpg.sh"
  chmod +x "$pen/grain-$t/.gnupg-rye/gpg.sh"
  : > "$pen/grain-$t/.ssh/id_jail"
  cat > "$pen/grain-$t/.git/ssh_config_jail" <<EOF
Host github.com
  IdentityFile $pen/grain-$t/.ssh/id_jail
  UserKnownHostsFile $pen/grain-$t/.ssh/known_hosts_jail
EOF
  git -C "$pen/grain-$t" config gpg.program "$pen/grain-$t/.gnupg-rye/gpg.sh"
  git -C "$pen/grain-$t" config core.sshCommand "ssh -F $pen/grain-$t/.git/ssh_config_jail"
done
cp "$src" "$pen/grain-alpha/tools/fixtures/f/"
scan="$pen/grain-alpha/tools/fixtures/f/fleet_key_locality_scan.sh"

roster() { cat > "$pen/grain-alpha/tools/fixtures/f/fleet_roster_scan.sh" <<EOF
#!/bin/sh
case "\$1" in
  --live) printf '%s\n' $1 ;;
  --tree) case "\$2" in alpha) echo grain-alpha ;; beta) echo grain-beta ;; gone) echo grain-gone ;; esac ;;
esac
EOF
}

# 1-2. Both trees local: welcome, and the count is real rather than an empty pass.
roster "alpha beta"
out=$(sh "$scan" 2>&1)
ck "clean pier passes"        "verdict=every_path_is_local" "$out"
ck "clean pier counted paths" "paths_checked=8"             "$out"

# 3-5. gpg.program into the sibling: the pheromone fault exactly.
git -C "$pen/grain-alpha" config gpg.program "$pen/grain-beta/.gnupg-rye/gpg.sh"
out=$(sh "$scan" 2>&1)
ck "foreign gpg.program bites" "verdict=foreign_path" "$out"
ck "foreign counted"           "foreign_paths=1"      "$out"
ck "foreign named"             "outside"              "$out"

# 6. Removing the plant returns the reading to green -- the other side of the same refusal.
git -C "$pen/grain-alpha" config gpg.program "$pen/grain-alpha/.gnupg-rye/gpg.sh"
ck "plant removed, green again" "verdict=every_path_is_local" "$(sh "$scan" 2>&1)"

# 7-8. An IdentityFile into the sibling -- the ssh half, which lives in a different file.
cfg="$pen/grain-alpha/.git/ssh_config_jail"
sed "s|IdentityFile .*|IdentityFile $pen/grain-beta/.ssh/id_jail|" "$cfg" > "$cfg.tmp" \
  && cat "$cfg.tmp" > "$cfg" && rm -f "$cfg.tmp"   # temp-then-cat: portable, and the mode survives
out=$(sh "$scan" 2>&1)
ck "foreign IdentityFile bites" "verdict=foreign_path" "$out"
ck "ssh half counted"           "foreign_paths=1"      "$out"
cfg="$pen/grain-alpha/.git/ssh_config_jail"
sed "s|IdentityFile .*|IdentityFile $pen/grain-alpha/.ssh/id_jail|" "$cfg" > "$cfg.tmp" \
  && cat "$cfg.tmp" > "$cfg" && rm -f "$cfg.tmp"   # temp-then-cat: portable, and the mode survives

# 9-10. A SYMLINK IS THE SAME FAULT IN DISGUISE. The config names a local path; the path lands in
# the sibling. A guard comparing the written string calls this local and the ship still refuses.
rm -rf "$pen/grain-alpha/.gnupg-rye"
ln -s "$pen/grain-beta/.gnupg-rye" "$pen/grain-alpha/.gnupg-rye"
out=$(sh "$scan" 2>&1)
ck "symlinked keyring bites"  "verdict=foreign_path" "$out"
ck "resolution is named"      "resolves to"          "$out"
rm -f "$pen/grain-alpha/.gnupg-rye"
mkdir -p "$pen/grain-alpha/.gnupg-rye"
printf '#!/bin/sh\nexec gpg "$@"\n' > "$pen/grain-alpha/.gnupg-rye/gpg.sh"
chmod +x "$pen/grain-alpha/.gnupg-rye/gpg.sh"
ck "symlink removed, green again" "verdict=every_path_is_local" "$(sh "$scan" 2>&1)"

# 11-12. A seat whose tree is absent is reported, never counted -- a fresh clone holds one tree.
roster "alpha beta gone"
out=$(sh "$scan" 2>&1)
ck "absent tree reported"   "absent: gone"                "$out"
ck "absent tree stays green" "verdict=every_path_is_local" "$out"

# 13-14. The instrument must be proven present, not assumed (REDS %413).
mv "$pen/grain-alpha/tools/fixtures/f/fleet_roster_scan.sh" "$pen/roster.away"
out=$(sh "$scan" 2>&1); rc=$?
ck "absent roster refuses loudly" "REFUSED" "$out"
[ "$rc" = 2 ] && pass=$((pass+1)) || { fail=$((fail+1)); echo "  FAIL absent roster exit: got $rc wanted 2"; }
mv "$pen/roster.away" "$pen/grain-alpha/tools/fixtures/f/fleet_roster_scan.sh"

# 15. A roster that lists nothing refuses too -- an empty sweep is not a clean sweep.
roster ""
out=$(sh "$scan" 2>&1)
ck "empty roster refuses" "REFUSED" "$out"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
