# The Tower, Without Recursion -- Bounded Depth in Glow

*The classic three-peg tower is the world's favorite lesson in recursion. Here it becomes our lesson in the opposite discipline: the same tower, solved with an explicit stack whose depth is a named constant -- because in this house, recursion stays out so that everything which should be bounded stays bounded.*

**Language:** EN
**Last updated:** 2026-07-30 (Equinox e15 - frame-bound bite `20260730.120824`)
**Style:** Gauge (see `../../context/GAUGE_STYLE.md`)
**Status:** Living tutorial - **metal GREEN** at `edu/tower/bounded_tower.rye` - frame bite `edu/tower/frame_bound_overpush.rye` - witnesses `tools/e/edu_tower_witness.rish` - `tools/e/edu_tower_frame_bite_witness.rish`
**Home:** `docs-geode/tutorials/` -- the prod crystal for shipping docs
**Naming note:** written for **Glow** and the **rune shell** surface; the rune shell's proper name awaits Keaton's word (`context/specs/reserved-vocabulary.md`)

*Written together by Keaton and Riyo.*

---

## The game, in one breath

Three pegs. A tower of rings on the first, each smaller than the one beneath. Move the whole tower to the third peg, one ring at a time, each ring resting only on a larger one. The classic teaching solves it recursively: *move n-1 aside, move the base, move n-1 back on top* -- three lines of self-call, and the machine's hidden call stack does the bookkeeping.

Our root law reads differently: **control flow stays simple and explicit; recursion stays out.** The recursive telling is lovely, yet a hidden stack carries a depth the code leaves unnamed, and a named depth is what this tree asks for. TAME asks *how large can this grow?* and asks it up front. So our tower keeps the same three-part insight and moves the bookkeeping into the open.

## The bound, named before the machine runs

Every tower of `n` rings takes exactly `2^n - 1` moves -- powers of two, the same arithmetic our seasons breathe. And the explicit stack never holds more than `2n - 1` frames. Both bounds are constants a reader meets at the top of the file:

```zig
const max_rings: u32 = 16;                 // a 16-ring tower is 65,535 moves -- plenty
const max_frames: u32 = 2 * max_rings - 1; // invariant: the frame stack never exceeds this
```

## The frame, and the stack that carries it

A recursive call is a record the machine keeps for you. We keep it ourselves, in a fixed array -- no allocator, no hidden growth:

```zig
// Invariant: a Task is either a move of `count` rings through the pegs,
// or a single literal move to print. Nothing else exists.
const Task = struct { count: u32, from: u8, to: u8, via: u8 };

// Invariant: top <= max_frames; frames[0..top] are live tasks.
const Stack = struct {
    frames: [max_frames]Task = undefined,
    top: u32 = 0,

    fn push(s: *Stack, t: Task) void {
        assert(s.top < max_frames);        // the bound, biting where it must
        s.frames[@intCast(s.top)] = t;
        s.top += 1;
    }
    fn pop(s: *Stack) ?Task {
        if (s.top == 0) return null;       // negative space: empty is a value
        s.top -= 1;
        return s.frames[@intCast(s.top)];
    }
};
```

## The loop that replaces the call

The recursive body said: *solve(n-1, start->via), move one, solve(n-1, via->end).* Our loop pushes those same three tasks -- **in reverse, so they pop in order** -- and walks until the stack has run dry. One `while`, bounded twice: by the frame ceiling and by the move count.

```zig
fn solve(rings: u32) void {
    assert(rings >= 1);
    assert(rings <= max_rings);            // precondition: inside the named tower
    var s = Stack{};
    s.push(.{ .count = rings, .from = 'A', .to = 'C', .via = 'B' });

    var moves: u32 = 0;
    const max_moves: u32 = (@as(u32, 1) << @intCast(rings)) - 1; // 2^n - 1, exact
    while (s.pop()) |t| {
        if (t.count == 1) {
            moves += 1;
            assert(moves <= max_moves);    // the arithmetic keeps the loop honest
            print("move ring from {c} to {c}\n", .{ t.from, t.to });
        } else {
            // pushed in reverse: (n-1 via->to) last out ... first out (n-1 from->via)
            s.push(.{ .count = t.count - 1, .from = t.via, .to = t.to, .via = t.from });
            s.push(.{ .count = 1, .from = t.from, .to = t.to, .via = t.via });
            s.push(.{ .count = t.count - 1, .from = t.from, .to = t.via, .via = t.to });
        }
    }
    assert(moves == max_moves);            // postcondition: exactly 2^n - 1, every time
}
```

The recursive insight survives whole -- three tasks where three calls were -- and everything the machine once hid is now a value a witness can hold: the depth, the count, the frames themselves.

## What the witness asserts (e13 metal)

The welcome side: `solve(3)` prints exactly seven moves and the postcondition holds. The negative space: a seventeenth ring is **refused** as `TooManyRings`, and a capacity-one stack **bites** on the second push -- observed every run from the fixture `edu/tower/frame_bound_overpush.rye` (non-zero exit - assertion failure), never by shrinking the welcome tower by hand. Run:

```
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run edu/tower/bounded_tower.rye
rishi/bin/rishi run tools/e/edu_tower_witness.rish
rishi/bin/rishi run tools/e/edu_tower_frame_bite_witness.rish
```


## What we liked in the standing library -- and what graduated

Writing this against the current tree: **Tally already thinks this way.** `Region.divide` (Equinox e5) carves memory the way this stack carves work -- bounded by the parent, disjoint by construction, refusing rather than truncating.

**`tally/stack.rye` graduated** as the second consumer (TAME worked example - this tutorial). The tower imports it via `edu/tower/tally_stack.rye` -> `../../tally/stack.rye`. The sketch's local `Stack` type is the teaching picture; the metal uses the graduated fold.

---

*May every depth be a number someone wrote down. May the classic lessons enter this house speaking its law. And may the tower teach a second generation -- this time with nothing hidden.*
