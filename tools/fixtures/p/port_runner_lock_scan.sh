#!/bin/sh
# tools/fixtures/p/port_runner_lock_scan.sh -- which standing guards actually BIND a constant port,
# and which of those runs holds a lock.
#
# WHY. A port is a name on the MACHINE, and this pier stands eight checkouts deep, each running the
# same roster. tools/fixtures/p/port_band_scan.sh counts the NUMBERS our modules declare and names
# the ones two modules share. That reading answers *can two modules meet*. It cannot answer the
# question a fleet pass actually asks, which is *does the roster run a binder at all, and is that
# run held apart from the seven other ships running the same guard on the same machine at the same
# second*. REDS %700 is what the unanswered half costs: a rostered witness read red on one cold pass
# and green on a re-run over an unchanged tree, and naming the cause took a fortnight.
#
# THE TWO QUESTIONS CROSS, AND THE CROSSING IS THE POINT.
#
#                     | no SO_REUSEADDR          | sets SO_REUSEADDR
#   ------------------+--------------------------+---------------------------------
#   run under a lock  | safe                      | safe
#   run unlocked      | LOUD -- the kernel        | SILENT -- both sockets bind, and
#                     | refuses the second bind,  | the kernel splits the datagrams
#                     | so the pass reds and a    | between them with no refusal at
#                     | re-run passes             | all
#
# A loud collision costs a re-run. A silent one costs a fortnight, because every reading of it is
# plausible. So the two cells carry two instruments: the loud cell is a RATCHET that only falls, and
# the silent cell is a WALL at zero.
#
# WHAT IS COUNTED, and why BUILD and RUN are two facts rather than one word. A rostered guard that
# writes `rye build <module>.rye ... -femit-bin=<target>` has compiled a binder and bound nothing.
# Only a later `run` naming that same target binds. Measured `20260911`: five rostered guards build a
# constant-port binder and FOUR run it -- tools/am/amphora_mark_wreck_witness.rish compiles
# amphora/vessel_fetch_delivery.rye to prove it still compiles and never executes it. A reading that
# counted builders would have charged that guard with an exposure it does not have.
#
# THE READINGS
#   roster_guards        rostered guard paths read
#   port_modules         living modules declaring a constant nonzero port
#   builders             rostered guards compiling one of those modules
#   runners              of those, guards that also EXECUTE what they compiled
#   runs_locked          executing lines holding a *_port_lock.sh
#   runs_unlocked        executing lines holding none              RATCHET, only falls
#   unlocked_reusing     of those, whose module sets SO_REUSEADDR  ZERO, ENFORCED
#
# A LOCK IS READ PER LINE rather than per file, because a guard may hold one run apart and leave
# another open, and a file-wide reading would call the second one safe.
#
# HOW WIDE A LOCK IS. Both locks are taken at ${TMPDIR:-/tmp}. Launched bare -- which is how this
# fleet runs, FLEET_BARE=1 -- every ship shares the host mount namespace, so the lock excludes the
# whole pier. Inside ai-jail each ship gets a private /tmp, so there it excludes two runs within one
# tree alone. Both readings are honest; they describe different launches. The sibling headers at
# tools/fixtures/m/mantra_delivery_port_lock.sh and tools/fixtures/a/amphora_vessel_port_lock.sh
# record the same fact measured on metal.
#
# USAGE
#   sh tools/fixtures/p/port_runner_lock_scan.sh
#   sh tools/fixtures/p/port_runner_lock_scan.sh --list     # every build, run, and verdict
#   PORT_RUNNER_ROOT=<dir> sh tools/fixtures/p/port_runner_lock_scan.sh   # a pen's own tree
#
# Driven by tools/p/port_runner_lock_witness.rish. Run from the repository root.

set -u

root="${PORT_RUNNER_ROOT:-.}"
# The ratchet's ceiling. It only falls: a lane that locks one of the open runs lowers this in the
# same commit, and a new unlocked run refuses on the lap it arrives. Overridable so the pen can
# plant one over and one exactly at it -- a ceiling proven only in the passing direction cannot be
# told from a bypass.
unlocked_ceiling="${PORT_RUNNER_UNLOCKED_CEILING:-4}"
mode="${1:-}"
roster="$root/construction/standing-equipment.kyri"

if [ ! -f "$roster" ]; then
    echo "roster_missing=$roster"
    echo "verdict=no_roster"
    exit 0
fi

work=$(mktemp -d "${TMPDIR:-/tmp}/port_runner_lock.XXXXXX") || exit 1
trap 'rm -rf "$work"' EXIT INT TERM

# --- the port-declaring modules, counted off the sources exactly as the band scan counts them ---
# A `const <name>: u16 = <number>;` where `port` is a whole component of the identifier, and the
# number is nonzero. A port of 0 asks the kernel for a number nobody else holds, which is the cure
# rather than the exposure, so it is read past here as it is there.
( cd "$root" 2>/dev/null && git ls-files '*.rye' 2>/dev/null ) > "$work/rye_sources" || : 
: > "$work/port_modules"
while IFS= read -r src; do
    [ -n "$src" ] || continue
    [ -f "$root/$src" ] || continue
    if grep -qE '^[[:space:]]*(pub )?const [A-Za-z0-9_]*(^|_)?port(_[A-Za-z0-9_]*)?: u16 = [0-9]+;' "$root/$src" 2>/dev/null; then
        if grep -E '^[[:space:]]*(pub )?const [A-Za-z0-9_]+: u16 = [0-9]+;' "$root/$src" 2>/dev/null \
            | grep -E 'const ([A-Za-z0-9_]+_)?port(_[A-Za-z0-9_]+)?: u16 = [1-9]' >/dev/null 2>&1; then
            echo "$src" >> "$work/port_modules"
        fi
    fi
done < "$work/rye_sources"
sort -u "$work/port_modules" -o "$work/port_modules"
port_modules=$(wc -l < "$work/port_modules" | tr -d ' ')

# --- which of those set SO_REUSEADDR for real, on a line that is not a comment ---
: > "$work/reusing"
while IFS= read -r m; do
    [ -n "$m" ] || continue
    if grep -vE '^[[:space:]]*//' "$root/$m" 2>/dev/null | grep -qE 'setsockopt\([^)]*SO_REUSEADDR'; then
        echo "$m" >> "$work/reusing"
    fi
done < "$work/port_modules"

# --- the roster's own guard paths ---
grep '^path ' "$roster" 2>/dev/null | awk '{print $2}' | sort -u > "$work/roster"
roster_guards=$(wc -l < "$work/roster" | tr -d ' ')

# Each reading is derived from the two ledgers below rather than accumulated in a loop, because the
# loops run inside pipeline subshells where a counter increment is lost on the way out.
: > "$work/builds"

while IFS= read -r guard; do
    [ -n "$guard" ] || continue
    case "$guard" in *.rish) ;; *) continue ;; esac
    [ -f "$root/$guard" ] || continue
    grep -q 'rye build ' "$root/$guard" 2>/dev/null || continue

    # Each build line naming a port-declaring module contributes one target.
    grep -n 'rye build ' "$root/$guard" 2>/dev/null | while IFS= read -r line; do
        lineno=${line%%:*}
        mod=$(printf '%s' "$line" | grep -oE 'rye build [A-Za-z0-9_/.-]+\.rye' | head -1 | sed 's/rye build //')
        [ -n "$mod" ] || continue
        grep -qx "$mod" "$work/port_modules" || continue
        target=$(printf '%s' "$line" | grep -oE 'femit-bin=[^ "]*' | head -1 | sed 's/femit-bin=//')
        [ -n "$target" ] || continue
        printf '%s\t%s\t%s\t%s\n' "$guard" "$lineno" "$mod" "$target" >> "$work/builds"
    done
done < "$work/roster"

[ -f "$work/builds" ] || : > "$work/builds"
builders=$(cut -f1 "$work/builds" | sort -u | wc -l | tr -d ' ')

# --- an execution is any OTHER line naming the same target inside a run ---
# RISHI SPELLS ONE REFERENCE TWO WAYS, and a reader that knows one spelling reads half the runs.
# A variable is written `${bin}` inside a string and bare `bin` as an array element, so
# `run ["sh" "-c" "${bin} selftest"]` and `run ["sh" lock "38490" "sh" probe bin "38491"]` name the
# same binary in two forms. The first draft of this scan matched the interpolated form alone and
# reported tools/m/mantra_udp_reuseaddr_witness.rish as a builder that runs nothing, which is the
# %717 lesson one room over: a roster that reads one spelling reports the spelling, never the tree.
# Both the target and the lock are therefore resolved through the file's own `let name = "literal"`
# bindings before anything is compared.
: > "$work/runs"
while IFS="$(printf '\t')" read -r guard lineno mod target; do
    [ -n "$guard" ] || continue

    # the file's own literal bindings, one `let name = "value"` per line
    sed -n 's/^let \([A-Za-z0-9_]*\) = "\([^"]*\)".*/\1\t\2/p' "$root/$guard" > "$work/lets"

    resolved_target="$target"
    case "$target" in
        '${'*'}')
            name=$(printf '%s' "$target" | sed 's/^\${//; s/}$//')
            lit=$(awk -F'\t' -v n="$name" '$1==n {print $2; exit}' "$work/lets")
            [ -n "$lit" ] && resolved_target="$lit"
            ;;
    esac

    grep -n 'run \[' "$root/$guard" 2>/dev/null | while IFS= read -r rl; do
        rno=${rl%%:*}
        [ "$rno" != "$lineno" ] || continue
        body=${rl#*:}
        # expand every binding in both spellings, so one comparison reads both forms
        expanded=$(printf '%s' "$body" | awk -F'\t' '
            NR==FNR { name[NR]=$1; val[NR]=$2; n=NR; next }
            {
                line=$0
                for (i=1; i<=n; i++) {
                    gsub("\\$\\{" name[i] "\\}", val[i], line)
                    gsub("(^|[^A-Za-z0-9_])" name[i] "([^A-Za-z0-9_]|$)", " " val[i] " ", line)
                }
                print line
            }' "$work/lets" -)
        # THE TARGET ENDS AT A BOUNDARY, or a sibling path swallows it. fora_socket_witness writes
        # `let outfile = "constel/bin/socket.out"` beside `let bin = "constel/bin/socket"`, so a
        # bare substring test charged ten `cat ${outfile}` lines as executions of the binary. The
        # binary's own name must be followed by something that cannot continue a path.
        if ! printf '%s' "$expanded" | grep -qE "$(printf '%s' "$resolved_target" | sed 's,[].[^$*\\],\\&,g')([^A-Za-z0-9_.-]|\$)"; then
            continue
        fi
        lock=none
        case "$expanded" in
            *_port_lock.sh*) lock=held ;;
        esac
        reuse=no
        grep -qx "$mod" "$work/reusing" && reuse=yes
        printf '%s\t%s\t%s\t%s\t%s\n' "$guard" "$rno" "$mod" "$lock" "$reuse" >> "$work/runs"
    done
done < "$work/builds"

[ -f "$work/runs" ] || : > "$work/runs"
runners=$(cut -f1 "$work/runs" | sort -u | wc -l | tr -d ' ')
runs_locked=$(awk -F'\t' '$4=="held"' "$work/runs" | wc -l | tr -d ' ')
runs_unlocked=$(awk -F'\t' '$4=="none"' "$work/runs" | wc -l | tr -d ' ')
unlocked_reusing=$(awk -F'\t' '$4=="none" && $5=="yes"' "$work/runs" | wc -l | tr -d ' ')

echo "roster_guards=$roster_guards"
echo "port_modules=$port_modules"
echo "port_modules_reusing=$(wc -l < "$work/reusing" | tr -d ' ')"
echo "builders=$builders"
echo "runners=$runners"
echo "runs_locked=$runs_locked"
echo "runs_unlocked=$runs_unlocked"
echo "unlocked_ceiling=$unlocked_ceiling"
echo "unlocked_reusing=$unlocked_reusing"

if [ "$mode" = "--list" ]; then
    sort -u "$work/builds" | while IFS="$(printf '\t')" read -r g l m t; do
        [ -n "$g" ] || continue
        echo "build: $g:$l	$m	-> $t"
    done
    sort -u "$work/runs" | while IFS="$(printf '\t')" read -r g l m lk ru; do
        [ -n "$g" ] || continue
        echo "run: $g:$l	$m	lock=$lk	reuseaddr=$ru"
    done
    awk -F'\t' '$4=="none"' "$work/runs" | sort -u | while IFS="$(printf '\t')" read -r g l m lk ru; do
        [ -n "$g" ] || continue
        echo "unlocked: $g:$l	$m	reuseaddr=$ru"
    done
fi

verdict=ok
if [ "$unlocked_reusing" -gt 0 ]; then
    echo "over: unlocked_reusing=$unlocked_reusing -- an unlocked run of a binder that sets SO_REUSEADDR; two ships bind one address together and the kernel splits the datagrams in silence"
    verdict=unlocked_reusing
fi
if [ "$runs_unlocked" -gt "$unlocked_ceiling" ]; then
    echo "over: runs_unlocked=$runs_unlocked past its ceiling of $unlocked_ceiling -- one guard, eight ships, one machine"
    verdict=over_ceiling
fi
echo "verdict=$verdict"
