# BUHR Journey 11 — the MCP `prompts` surface, named templates a server offers (exploration)

**Stamp:** `20260812.153255` · **Waymark:** BUHR (Compass Season · Equinox 3 — Surface & Intelligence) · **Status:** Vision -- exploration, self-approved design round · **Voice:** Kyri

## The blind spot

The Model Context Protocol names **three** first-class surfaces, not two. Journey 9 served the
first — `tools`, a verb a caller *invokes*, every Quin voice reachable as a named `tools/call`
and discoverable through `tools/list`. Journey 10 served the second — `resources`, a noun a
caller *reads*, every Tablecloth artifact addressable by URI through `resources/read` and
discoverable through `resources/list`. The third stands unbuilt: **`prompts`** — named,
reusable prompt templates a server *offers*, listed through `prompts/list` and retrieved,
filled with a caller's arguments, through `prompts/get`.

The owned MCP arc has spoken the verb and the noun; it has not yet spoken the **template**. A
prompt template is neither a tool to invoke nor a stored artifact to read — it is a small,
parameterized piece of text a server publishes so a caller need not compose the wording
itself: name the prompt, supply its arguments, receive the finished text. That is the third
primitive every real MCP host offers, and the one surface BUHR's protocol face has never worn.

## The crux

**A `prompts/get` returns exactly the template's text with every declared argument filled and
every placeholder resolved — nothing left half-substituted.** A `format mcp-prompt-v1`
descriptor declares a prompt: a name, a one-line summary, one `arg <name>` line per argument it
takes, and a `template` body carrying `{name}` placeholders. A `format mcp-prompt-get-v1`
request names the prompt and binds each argument (`arg <name> <value>`); the fill substitutes
every `{name}` with its bound value and answers a `format mcp-prompt-result-v1` envelope whose
body is the finished text. The crux is **completeness**: the result body holds no `{…}` at all,
exactly the declared arguments were supplied, and the envelope round-trips byte-for-byte.

Every refusal crosses the surface as a **named** MCP error, never a half-filled body:
- an unknown prompt name → `prompt_not_found`;
- an argument the descriptor never declared → `unknown_argument` (never silently dropped);
- a declared argument the request left unbound → `missing_argument`;
- a `{name}` in the template naming no declared argument → `unbound_placeholder` (the fill
  refuses rather than leaving a live brace in the body).

So the server can never hand a caller a prompt with an unresolved hole in it, and can never
quietly ignore an argument the caller meant to matter.

## Grounded in witnessed ground

- `pond/apps/mcp_bron.rye` (J3r1) — the flat-Bron `key value` idiom, the bounded `format …-v1`
  envelope discipline, unknown-field-refused, and the round-trip property this rung mirrors.
- `pond/apps/mcp_resource.rye` (J10r1) — the length-delimited body idiom (a `template`/`content`
  body may hold interior newlines, read exactly after its marker and checked against a
  published length), reused so a multi-line template survives the crossing.
- `brix/infuse.rye` — per-key override over flat Bron: the argument bindings *are* a flat-Bron
  key/value set, exactly the shape infuse already reasons over; the fill's binding lookup is
  kin to it.
- The Lantern request shape (Quin's voices, J1) — a filled prompt is precisely a prompt a voice
  can answer, which is what the horizon rung joins.

The bridge invents no storage and no transport: it reads a descriptor and a request in owned
Bron shapes, fills bounded text, and renders an owned result. It reads no network — the real
network fetch and the Comlink-served transport stay the held custody/serve gates.

## The rungs, Lindy-first crux-first

1. **J11r1 — one named prompt filled.** A `format mcp-prompt-v1` descriptor and a
   `format mcp-prompt-get-v1` request fill into a `format mcp-prompt-result-v1` result whose
   body carries the template with every placeholder resolved; a round-trip reader recovers the
   body, and the four refusals (`prompt_not_found` · `unknown_argument` · `missing_argument` ·
   `unbound_placeholder`) each hold. This is the crux, taken first.
2. **J11r2 (horizon) — prompts/list.** The whole prompt catalog rendered as a bounded
   `format mcp-prompt-list-v1` envelope — one `prompt <name> <argc>` line per template — so a
   caller discovers every offered prompt and its arity, the template half's mirror of
   `tools/list` (J9) and `resources/list` (J10r2).
3. **J11r3 (horizon) — a filled prompt routes to a voice.** `prompts/get` fills a template into
   exactly a Lantern prompt, dispatched through the Quin host (J9r2), so the equinox's two
   halves — the intelligence and the protocol — meet once more: a server's own prompt template,
   filled by a caller, answered by a Grain voice.
4. **Held gate.** Serving the prompt surface over Comlink / a real network transport reaches the
   serve gate that is the maintainer's hand.

A radiant close: with the template surface owned beside the verb and the noun, Grain speaks all
three of MCP's first-class shapes in a notation it owns end to end — the voices as tools to
invoke, the artifacts as resources to read, and now the prompts as templates to fill, every
answer bounded and every refusal named. May the finished text always arrive whole.
