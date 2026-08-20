# BUHR Journey 9 — the intelligence, served as MCP tools (exploration)

**Stamp:** `20260812.150600` · **Waymark:** BUHR (Compass Season · Equinox 3 — Surface & Intelligence) · **Status:** Vision -- exploration, self-approved design round · **Voice:** Kyri

## The blind spot

BUHR's eight journeys built every module the equinox names and let the intelligence read
every surface: Journey 3 spoke MCP in Bron (the owned `format mcp-call-v1` / `mcp-result-v1`
shape, a JSON host bridge, the whole `tools/list` envelope), and Journey 8 gathered the five
voices — Lattice, Scribble, Ember, the living graph, and a named Tablecloth artifact — under
one bounded Q-vane host (`quin_host_artifact.dispatch`). Yet those two halves have never met.
The MCP host's `tools/call` still dispatches only to the toy `add` and `join` of Journey 3's
first rung; `tools/list` advertises only those two. A caller who speaks the owned MCP shape
cannot reach the actual intelligence at all.

That is the pattern every BUHR journey opened on: a pair the equinox names, built on each
side, never joined. Here the pair is **the MCP shape and the gathered voice host.**

## The crux

**An MCP `tools/call` routes to a real Quin voice, and the answer returns in the owned MCP
result shape.** A `format mcp-call-v1` envelope naming the intelligence tool, carrying a
model and a prompt, crosses into a Lantern request, dispatches through
`quin_host_artifact.dispatch` (which routes by prompt to whichever voice recognizes it), and
the Lantern response crosses back into a `format mcp-result-v1` envelope a caller reads with
Journey 3's own `parse_result`. Every refusal the host already owns — a disallowed model, a
prompt no voice knows, an artifact name the store lacks — crosses back as a **named MCP
error**, never a fabricated result. The intelligence's own integrity guarantee travels with
it: an artifact answer still rests on bytes that proved themselves against their content
address.

## Grounded in witnessed ground

- `pond/apps/mcp_bron.rye` (J3r1) — `parse_call`, `Call.arg_val`, `Result`, `parse_result`,
  the bounded `format mcp-call-v1` / `mcp-result-v1` shapes. Reused unchanged.
- `pond/apps/quin_host_artifact.rye` (J8r3) — `dispatch` over five voices, each Lantern-metered.
- `lantern/lantern_core.rye` — the Request/Response contract the voices obey.

The bridge invents no transport and no parser: it reads a call with J3's reader, renders a
result in J3's shape, and composes over both public APIs. It reads no network — the real
network fetch and the Comlink-served transport stay the held custody/serve gates.

## The rungs, Lindy-first crux-first

1. **J9r1 — one intelligence tool over the gathered host.** An MCP tool `ask` (args: `model`,
   `prompt`, optional `max_tokens`) dispatches through the five-voice host and answers in the
   MCP result shape; a round-trip through `parse_result` recovers the answer; refusals cross
   back as named errors. This is the crux, taken first.
2. **J9r2 (horizon) — the voices as distinct tools.** `tools/list` advertises each voice as
   its own MCP tool, so a caller discovers the intelligence surface by name.
3. **Held gate.** Serving the tool set over Comlink / a real network transport reaches the
   serve gate that is the maintainer's hand.

A radiant close: the intelligence Grain grew now speaks a protocol the wider world already
knows, in a shape Grain owns end to end — reachable, bounded, and honest about every refusal.
