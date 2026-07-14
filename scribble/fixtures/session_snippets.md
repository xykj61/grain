# Session log training snippets (fixture — our tree only)

Notes from a forge lap; rye fences are corpus candidates.

```rye
const garden = init.arena.allocator();
const args = try init.minimal.args.toSlice(garden);
```

```rish
say "witness passed."
```

```rye
try lc.matmul(&a, &b, &c);
assert(c.at(0, 0) == 19);
```
