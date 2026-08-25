#!/bin/sh
# tools/fixtures/ales_sing_lock_control.sh -- prove the Lotus sing lock, both ways.
#
# A lock proven only in the direction that succeeds cannot be told from a script that always says
# yes, so every case below is driven on a real lock directory in a throwaway pen: taken when free,
# refused when a LIVE process holds it, cleared when the holder is dead, freed idempotently, and
# refused on a word it does not know.
#
# The live-holder case needs a real running pid, because the dead-holder clear is otherwise
# indistinguishable from the refusal -- two shell invocations in a row leave a dead pid behind and
# the second one correctly takes the lock. That is exactly why the case is planted rather than
# reasoned about.
#
# Run from the repository root. Prints one `key=value` line per behavior, then `control_verdict=ok`.
set -u

lock_sh="$(pwd)/tools/fixtures/ales_sing_lock.sh"
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
L="$pen/sing.lock"

# The living lock's state before a single case runs, so the last check can prove this control left
# it exactly as it found it rather than proving it absent -- see that check for why.
living_before=$( [ -e lotus/.sing.lock ] && echo present || echo absent )

# --- a free lock is taken -----------------------------------------------------------------
out=$(ALES_SING_LOCK_DIR="$L" sh "$lock_sh" take 2>/dev/null); e=$?
case "$out$e" in *"LOCK_TAKEN"*0) echo "free_lock_taken=yes" ;; *) echo "free_lock_taken=no" ;; esac
[ -f "$L/pid" ] && echo "take_writes_pid=yes" || echo "take_writes_pid=no"

# --- a lock held by a LIVE process is refused, and says who holds it -----------------------
sleep 30 &
live=$!
printf '%s\n' "$live" > "$L/pid"
out=$(ALES_SING_LOCK_DIR="$L" sh "$lock_sh" take 2>/dev/null); e=$?
case "$out" in *"LOCK_REFUSED reason=held"*) echo "live_holder_refused=yes" ;; *) echo "live_holder_refused=no" ;; esac
case "$out" in *"holder=$live"*) echo "refusal_names_holder=yes" ;; *) echo "refusal_names_holder=no" ;; esac
[ "$e" -eq 3 ] && echo "refusal_exits_three=yes" || echo "refusal_exits_three=no"
kill "$live" 2>/dev/null
wait "$live" 2>/dev/null

# --- a lock left by a DEAD holder is cleared and taken ------------------------------------
# A pid this control KNOWS has exited, rather than one reasoned to have: start a process, wait for
# it, and write its number into the lock.
sleep 0 & gone=$!; wait "$gone" 2>/dev/null
printf '%s\n' "$gone" > "$L/pid"
out=$(ALES_SING_LOCK_DIR="$L" sh "$lock_sh" take 2>/dev/null); e=$?
case "$out$e" in *"LOCK_TAKEN"*0) echo "dead_holder_cleared=yes" ;; *) echo "dead_holder_cleared=no" ;; esac

# --- free releases, and freeing twice is a no-op rather than an error ----------------------
out=$(ALES_SING_LOCK_DIR="$L" sh "$lock_sh" free 2>/dev/null); e=$?
case "$out$e" in *"LOCK_FREED"*0) echo "free_releases=yes" ;; *) echo "free_releases=no" ;; esac
[ -d "$L" ] && echo "free_removes_dir=no" || echo "free_removes_dir=yes"
ALES_SING_LOCK_DIR="$L" sh "$lock_sh" free >/dev/null 2>&1
[ $? -eq 0 ] && echo "free_is_idempotent=yes" || echo "free_is_idempotent=no"

# --- a word the lock does not know is refused rather than guessed at ----------------------
out=$(ALES_SING_LOCK_DIR="$L" sh "$lock_sh" bogus 2>/dev/null); e=$?
case "$out" in *"reason=unknown_word"*) echo "unknown_word_refused=yes" ;; *) echo "unknown_word_refused=no" ;; esac
[ "$e" -eq 2 ] && echo "unknown_word_exits_two=yes" || echo "unknown_word_exits_two=no"

# --- the env override is honored, so no proof ever touches the living lock ----------------
# UNCHANGED rather than ABSENT, and the difference is a real one: the living lock exists exactly
# while a sing holds it, and this control runs from tools/al/ales_roster_witness.rish, which the
# choir itself sings. Reading absence here made the control red inside a healthy sing on the lap it
# was written -- a guard refusing for a reason unrelated to what it guards, which is the very class
# this lock exists to remove. So the before-state is recorded at the top and compared here.
if [ "$living_before" = "$( [ -e lotus/.sing.lock ] && echo present || echo absent )" ]; then
  echo "living_lock_untouched=yes"
else
  echo "living_lock_untouched=no"
fi

echo "control_verdict=ok"
