#!/bin/sh
# tools/fixtures/p/port_runner_lock_control.sh -- prove the runner-lock reading on planted trees.
#
# WHY A PEN. The living tree holds four unlocked runs and zero unlocked reusing ones, so the living
# reading can show the ratchet standing and can never show the wall biting. Every refusal here is
# planted and then lifted, and every welcome is asserted as hard as every refusal -- a refusal
# proven only in the passing direction cannot be told from a bypass.
#
# WHAT EACH PEN CARRIES. A pen is a git repository, because the scan reads its sources through
# `git ls-files` exactly as the living one does. Each holds a roster naming its guards, one or two
# `.rye` modules declaring a port, and the guards themselves.
#
# USAGE
#   sh tools/fixtures/p/port_runner_lock_control.sh
#
# Driven by tools/p/port_runner_lock_witness.rish. Run from the repository root.

set -u

scan="$(pwd)/tools/fixtures/p/port_runner_lock_scan.sh"
pen=$(mktemp -d "${TMPDIR:-/tmp}/port_runner_lock_pen.XXXXXX") || exit 1
trap 'rm -rf "$pen"' EXIT INT TERM

legs=0
failed=0

check() {
    # check <name> <expected> <actual>
    legs=$((legs + 1))
    if [ "$2" = "$3" ]; then
        echo "leg: $1 ok"
    else
        echo "leg: $1 FAILED want=$2 got=$3"
        failed=$((failed + 1))
    fi
}

read_key() {
    # read_key <tree> <key> [--list]
    PORT_RUNNER_ROOT="$1" sh "$scan" ${3:-} 2>/dev/null | awk -F= -v k="$2" '$1==k {print $2; exit}'
}

read_key_ceiling() {
    # read_key_ceiling <tree> <key> <ceiling>
    PORT_RUNNER_ROOT="$1" PORT_RUNNER_UNLOCKED_CEILING="$3" sh "$scan" 2>/dev/null \
        | awk -F= -v k="$2" '$1==k {print $2; exit}'
}

make_tree() {
    # make_tree <name> -> prints the path
    t="$pen/$1"
    mkdir -p "$t/construction" "$t/tools/x" "$t/room"
    ( cd "$t" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )
    printf '# pen roster\n' > "$t/construction/standing-equipment.kyri"
    echo "$t"
}

plain_module() {
    # plain_module <tree> <path> <port>  -- binds a constant port, sets no SO_REUSEADDR
    cat > "$1/$2" <<EOF
const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;

const wire_port: u16 = $3;

pub fn main() !void {
    // invariant: the port is the one this module declares, so a reader of the
    // roster and a reader of the socket agree.
    assert(wire_port == $3);
    print("bound {d}\\n", .{wire_port});
}
EOF
}

reusing_module() {
    # reusing_module <tree> <path> <port> -- the same, and it sets SO_REUSEADDR for real
    cat > "$1/$2" <<EOF
const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;

const wire_port: u16 = $3;

pub fn main() !void {
    // invariant: the port is the one this module declares.
    assert(wire_port == $3);
    if (c.setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &yes, 4) < 0) return error.OptionFailed;
    print("bound {d}\\n", .{wire_port});
}
EOF
}

seat() {
    # seat <tree> <guard path>
    printf 'guard pen\npath %s\n' "$2" >> "$1/construction/standing-equipment.kyri"
}

commit_tree() {
    ( cd "$1" && git add -A && git commit -qm pen )
}

# --- pen 1: a clean tree -- a guard that neither builds nor runs a binder --------------------
t=$(make_tree clean)
plain_module "$t" room/wire.rye 38500
cat > "$t/tools/x/quiet_witness.rish" <<'EOF'
let out = run ["sh" "-c" "echo hello"]
assert out.ok else "quiet: echo must pass"
EOF
seat "$t" tools/x/quiet_witness.rish
commit_tree "$t"
check clean_port_modules 1 "$(read_key "$t" port_modules)"
check clean_builders 0 "$(read_key "$t" builders)"
check clean_runners 0 "$(read_key "$t" runners)"
check clean_unlocked 0 "$(read_key "$t" runs_unlocked)"
check clean_reusing 0 "$(read_key "$t" unlocked_reusing)"
check clean_verdict ok "$(read_key "$t" verdict)"

# --- pen 2: BUILD IS FREE -- compiling a binder binds nothing --------------------------------
t=$(make_tree builds_only)
plain_module "$t" room/wire.rye 38500
cat > "$t/tools/x/build_witness.rish" <<'EOF'
let build = run ["sh" "-c" "rye/bin/rye build room/wire.rye -femit-bin=room/bin/wire"]
assert build.ok else "build: must compile"
EOF
seat "$t" tools/x/build_witness.rish
commit_tree "$t"
check build_only_builders 1 "$(read_key "$t" builders)"
check build_only_runners 0 "$(read_key "$t" runners)"
check build_only_unlocked 0 "$(read_key "$t" runs_unlocked)"

# --- pen 3: the ratchet bites -- an unlocked run of a non-reusing binder ----------------------
t=$(make_tree unlocked_loud)
plain_module "$t" room/wire.rye 38500
cat > "$t/tools/x/loud_witness.rish" <<'EOF'
let bin = "room/bin/wire"
let build = run ["sh" "-c" "rye/bin/rye build room/wire.rye -femit-bin=${bin}"]
assert build.ok else "loud: must compile"
let live = run ["sh" "-c" "${bin} selftest"]
assert live.ok else "loud: must run"
EOF
seat "$t" tools/x/loud_witness.rish
commit_tree "$t"
check loud_runners 1 "$(read_key "$t" runners)"
check loud_unlocked 1 "$(read_key "$t" runs_unlocked)"
check loud_reusing 0 "$(read_key "$t" unlocked_reusing)"
# THE CEILING IS PROVEN FROM BOTH SIDES. One unlocked run against a ceiling of one walks free; the
# same tree against a ceiling of zero refuses and names its verdict. A ceiling shown only in the
# passing direction cannot be told from a bypass.
check loud_at_ceiling_free ok "$(read_key_ceiling "$t" verdict 1)"
check loud_over_ceiling_refused over_ceiling "$(read_key_ceiling "$t" verdict 0)"
check loud_over_ceiling_counted 1 "$(read_key_ceiling "$t" runs_unlocked 0)"

# --- pen 4: the WALL bites -- the same run, of a binder that sets SO_REUSEADDR ----------------
t=$(make_tree unlocked_silent)
reusing_module "$t" room/wire.rye 38500
cat > "$t/tools/x/silent_witness.rish" <<'EOF'
let bin = "room/bin/wire"
let build = run ["sh" "-c" "rye/bin/rye build room/wire.rye -femit-bin=${bin}"]
assert build.ok else "silent: must compile"
let live = run ["sh" "-c" "${bin} selftest"]
assert live.ok else "silent: must run"
EOF
seat "$t" tools/x/silent_witness.rish
commit_tree "$t"
check silent_modules_reusing 1 "$(read_key "$t" port_modules_reusing)"
check silent_unlocked 1 "$(read_key "$t" runs_unlocked)"
check silent_wall 1 "$(read_key "$t" unlocked_reusing)"
# and the wall names itself rather than merely counting, even with the ratchet's ceiling clear
check silent_verdict unlocked_reusing "$(read_key_ceiling "$t" verdict 9)"
# and lifted: comment the setsockopt out and the wall stands down
# The edit is written through the original file rather than moved over it, so the mode the
# repository tracks survives (`.claude/rules/exec-bit.md`), and `-i` stays out of the tree because
# its spelling differs between GNU and BSD sed (`tools/s/shell_dialect_witness.rish`).
sed 's|^    if (c.setsockopt|    // if (c.setsockopt|' "$t/room/wire.rye" > "$t/room/wire.rye.tmp"
cat "$t/room/wire.rye.tmp" > "$t/room/wire.rye"
rm -f "$t/room/wire.rye.tmp"
commit_tree "$t"
check silent_lifted 0 "$(read_key "$t" unlocked_reusing)"
check silent_lifted_still_unlocked 1 "$(read_key "$t" runs_unlocked)"
check silent_lifted_verdict ok "$(read_key_ceiling "$t" verdict 9)"

# --- pen 5: a lock spelled inline is held -----------------------------------------------------
t=$(make_tree locked_inline)
plain_module "$t" room/wire.rye 38500
cat > "$t/tools/x/locked_witness.rish" <<'EOF'
let bin = "room/bin/wire"
let build = run ["sh" "-c" "rye/bin/rye build room/wire.rye -femit-bin=${bin}"]
assert build.ok else "locked: must compile"
let live = run ["sh" "-c" "sh tools/fixtures/m/mantra_delivery_port_lock.sh 38500 ${bin} selftest"]
assert live.ok else "locked: must run"
EOF
seat "$t" tools/x/locked_witness.rish
commit_tree "$t"
check locked_runners 1 "$(read_key "$t" runners)"
check locked_held 1 "$(read_key "$t" runs_locked)"
check locked_unlocked 0 "$(read_key "$t" runs_unlocked)"

# --- pen 6: BOTH RISHI SPELLINGS -- a bare variable in a run array reads the same -------------
# This is the pen that names the first draft's own fault. The binary and the lock both arrive as
# bare array elements rather than interpolations, and a reader knowing one spelling sees neither.
t=$(make_tree bare_spelling)
plain_module "$t" room/wire.rye 38500
cat > "$t/tools/x/bare_witness.rish" <<'EOF'
let bin = "room/bin/wire"
let lock = "tools/fixtures/m/mantra_delivery_port_lock.sh"
let build = run ["sh" "-c" "rye/bin/rye build room/wire.rye -femit-bin=${bin}"]
assert build.ok else "bare: must compile"
let live = run ["sh" lock "38500" bin "selftest"]
assert live.ok else "bare: must run"
EOF
seat "$t" tools/x/bare_witness.rish
commit_tree "$t"
check bare_runners 1 "$(read_key "$t" runners)"
check bare_held 1 "$(read_key "$t" runs_locked)"
check bare_unlocked 0 "$(read_key "$t" runs_unlocked)"

# --- pen 7: a sibling path is NOT the binary -- the boundary ----------------------------------
t=$(make_tree sibling_path)
plain_module "$t" room/wire.rye 38500
cat > "$t/tools/x/sibling_witness.rish" <<'EOF'
let bin = "room/bin/wire"
let outfile = "room/bin/wire.out"
let build = run ["sh" "-c" "rye/bin/rye build room/wire.rye -femit-bin=${bin}"]
assert build.ok else "sibling: must compile"
let shown = run ["sh" "-c" "cat ${outfile}"]
assert shown.ok else "sibling: must read"
EOF
seat "$t" tools/x/sibling_witness.rish
commit_tree "$t"
check sibling_builders 1 "$(read_key "$t" builders)"
check sibling_runners 0 "$(read_key "$t" runners)"
check sibling_unlocked 0 "$(read_key "$t" runs_unlocked)"

# --- pen 8: an off-roster guard is not the roster's exposure ----------------------------------
t=$(make_tree off_roster)
plain_module "$t" room/wire.rye 38500
cat > "$t/tools/x/stray_witness.rish" <<'EOF'
let bin = "room/bin/wire"
let build = run ["sh" "-c" "rye/bin/rye build room/wire.rye -femit-bin=${bin}"]
assert build.ok else "stray: must compile"
let live = run ["sh" "-c" "${bin} selftest"]
assert live.ok else "stray: must run"
EOF
commit_tree "$t"
check off_roster_builders 0 "$(read_key "$t" builders)"
check off_roster_unlocked 0 "$(read_key "$t" runs_unlocked)"
# and seated, the very same guard is counted -- so the filter is the roster rather than the file
seat "$t" tools/x/stray_witness.rish
commit_tree "$t"
check off_roster_seated_unlocked 1 "$(read_key "$t" runs_unlocked)"

# --- pen 9: a port of zero is the cure, never the exposure ------------------------------------
t=$(make_tree kernel_chosen)
plain_module "$t" room/wire.rye 0
cat > "$t/tools/x/zero_witness.rish" <<'EOF'
let bin = "room/bin/wire"
let build = run ["sh" "-c" "rye/bin/rye build room/wire.rye -femit-bin=${bin}"]
assert build.ok else "zero: must compile"
let live = run ["sh" "-c" "${bin} selftest"]
assert live.ok else "zero: must run"
EOF
seat "$t" tools/x/zero_witness.rish
commit_tree "$t"
check zero_port_modules 0 "$(read_key "$t" port_modules)"
check zero_builders 0 "$(read_key "$t" builders)"
check zero_unlocked 0 "$(read_key "$t" runs_unlocked)"

# --- pen 10: no roster at all refuses by name rather than reading zero ------------------------
t="$pen/no_roster"
mkdir -p "$t"
check no_roster_verdict no_roster "$(read_key "$t" verdict)"

echo "legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then
    echo "control_verdict=ok"
else
    echo "control_verdict=failed"
fi
