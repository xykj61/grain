# 968 · Prompt Caching, ZON, and What Bron Already Is

*Two ideas from different worlds converge on the same insight. Claude's prompt caching rewards stable, structured context placed early in the request — the longer it stays identical across turns, the more tokens are read from cache at one-tenth the cost. ZON (Zero Overhead Notation) reduces token consumption by half compared to JSON through tabular encoding and minimal delimiters. Our own Bron format — plain key-value, one field per line, no quotes, no braces — is already a token-efficient notation. This research reads both and asks what they teach our system.*

**Language:** EN
**Version:** `20260621.063112` (Rye chronological stamp)
**Last updated:** 2026-06-21
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, joy
**Status:** Research

---

## Prompt Caching — What It Is and What It Rewards

Claude's prompt caching stores the computed representation of prompt prefixes. When a subsequent request shares the same prefix, the cached portion is read at **one-tenth the base cost** — a 90% reduction on the stable part of every request.

**The mechanic:** Place a `cache_control` marker on the last block of content that stays identical across requests. Everything before the marker is cached on first use and read from cache on subsequent turns. Everything after the marker is computed fresh.

**What this rewards:**

1. **Stable system prompts.** A CLAUDE.md that does not change between turns is cached once and read cheaply forever (within the TTL).
2. **Stable tool definitions.** The `.claude/rules/*.md` files, loaded into every conversation, are ideal cache candidates.
3. **Stable context.** Project documentation (TAME_STYLE.md, RADIANT_STYLE.md, PUBKEYS.md) read once per session benefits from caching.
4. **Ordering discipline.** The most stable content goes first; dynamic content (user messages, changing state) goes last. The cache boundary sits between them.

**The cost structure:**

| Token type | Cost relative to base |
|------------|----------------------|
| Base (uncached) | 1.0x |
| Cache write (5-min TTL) | 1.25x |
| Cache write (1-hour TTL) | 2.0x |
| Cache read (hit) | 0.1x |

A 100,000-token system prompt cached and read across 20 turns costs 10% of what it would without caching.

**What this teaches us:** Structure our project context for stability. The CLAUDE.md, the rules, and the design documents should be written to change rarely and be loaded early. The session-specific content (user messages, recent git status) goes after the cache boundary.

---

## ZON — Zero Overhead Notation

ZON is a data format designed for LLM interactions. Its claim: **50% fewer tokens than JSON** for the same data, while remaining human-readable and maintaining a 1:1 mapping to JSON types.

**How it achieves token efficiency:**

1. **Tabular encoding for arrays.** Instead of repeating keys for each object in an array, ZON uses a header row and data rows — the same efficiency a CSV offers over repeated JSON objects.
2. **Minimal delimiters.** No braces, no brackets, no quoted keys. Structure is conveyed through indentation and position.
3. **Human-readable.** Unlike binary formats, ZON is readable in a text editor. The reduction is syntactic, not semantic.

**What ZON teaches us:**

The insight is not "use ZON" — it is that **the format of data sent to an LLM directly affects cost.** Every unnecessary quote, brace, bracket, and comma is a token that carries no information. A format that conveys the same semantics with fewer tokens saves real money at scale.

---

## What Bron Already Is

Our Brix format — the `.brix` descriptor — is already a token-efficient notation:

```
name veganreyklah2
version 20260621.063112
file rye/src/main.rye
file rishi/src/main.rye
file caravan/seed.rye
```

No quotes. No braces. No brackets. No commas. One field per line, space-separated key and value. Comments with `#`. Human-readable by design.

Compare the same data in JSON:

```json
{
  "name": "veganreyklah2",
  "version": "20260621.063112",
  "files": [
    "rye/src/main.rye",
    "rishi/src/main.rye",
    "caravan/seed.rye"
  ]
}
```

The JSON version uses 27 tokens of syntactic overhead (braces, brackets, quotes, commas, colons) that the Brix version does not. At scale — thousands of API calls, each carrying configuration data — this difference compounds.

**Bron is our ZON.** Not by adoption, by convergence: the same design pressure (minimal syntax, human-readable, machine-parseable) produced the same shape. The difference is that Brix is simpler — it has no type system, no nesting, no arrays-of-objects. It is plain key-value, and that plainness is its strength.

---

## What This Means for Our System

### 1. Structure CLAUDE.md and rules for caching

The project's CLAUDE.md, `.claude/rules/*.md`, and `context/*.md` files are loaded into every Claude Code conversation. They should be:

- **Stable.** Change rarely; version with timestamps so the cache is not invalidated by whitespace edits.
- **Ordered by stability.** The most permanent content (identity, style, TAME rules) goes first. Session-specific content (current task, git status) goes last.
- **Concise.** Every unnecessary word is a token; every token costs money or context. The rules should be as short as they can be without losing clarity.

### 2. Use Bron for LLM-facing configuration

When Rishi scripts or Pond policies are sent to an LLM (for code generation, for CI configuration, for forge interactions), Brix is the right format — fewer tokens than JSON, human-readable, machine-parseable with `splitLines` and `indexOf(' ')`.

### 3. Bron grows toward structured data

The seed Brix format is flat key-value. As it grows toward the lawful composition combinator (`active-designing/982`, `997`), it may gain nesting and lists. When it does, the ZON insight applies: use tabular encoding for repeated structures, minimize delimiters, keep the 1:1 mapping to the value model. Bron should never become as heavy as JSON.

### 4. Rye can implement its own prompt-caching client

When Comlink or the Forge speaks to LLM APIs, Rye can implement the `cache_control` protocol directly — placing breakpoints on stable context, tracking cache hits in the usage response, and pre-warming the cache for frequently used prompts. This is a Rye module, not a borrowed library.

---

## Sources

- Claude prompt caching: platform.claude.com/docs/en/build-with-claude/prompt-caching
- ZON: zonformat.org — "50% fewer tokens than JSON, 100% human-readable"
- Brix: our own `.brix` descriptor format (`active-designing/982`, `997`)

---

*May the context we send be structured for the cache — stable content first, changing content last, and every token earning its place. May Brix stay as plain as it began, growing only the complexity it has earned, and may the cost of understanding always be lower than the cost of not.*
