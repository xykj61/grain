# BUHR Journey 10 — Tablecloth artifacts, served as MCP resources (exploration)

**Stamp:** `20260812.151959` · **Waymark:** BUHR (Compass Season · Equinox 3 — Surface & Intelligence) · **Status:** Vision -- exploration, self-approved design round · **Voice:** Kyri

## The blind spot

Journey 9 gave the intelligence its protocol face: a caller who speaks the owned MCP shape
reaches every Quin voice as a named `tools/call`, discovers the five voices through
`tools/list`, and reads each answer in the owned `format mcp-result-v1` envelope. Yet the
Model Context Protocol names **two** first-class surfaces, not one. Beside `tools` — a verb a
caller *invokes* — stands `resources`: a noun a caller *reads*. A resource is named content a
host lists (`resources/list`) and reads by URI (`resources/read`), returning the bytes and
their type. The whole owned MCP arc so far has spoken only the verb half.

And the noun half already has its module, built and witnessed. **Tablecloth** (Journey 7) is
exactly a store of named content: a human name bound to a content address, `fetch_artifact`
returning the true bytes or refusing a tampered store before a single byte is trusted. A
Tablecloth catalog *is* a resource list; an artifact *is* a resource. The pair the equinox
names — the owned MCP shape and the named artifact store — has been built on each side and
never joined. That is the pattern every BUHR journey opened on.

## The crux

**An MCP `resources/read` returns exactly the bytes whose digest the resource URI pins, and a
tampered store refuses.** A read request names a `tablecloth:<name>` URI; the bridge resolves
it through Tablecloth's own `fetch_artifact` — so the read inherits content-address integrity
for free — and renders the verified bytes, their content address, and their length into an
owned `format mcp-resource-v1` result a caller reads back. Every refusal crosses the surface
as a **named** MCP error, never a fabricated body: an unknown name is `resource_not_found`, a
URI that is not a `tablecloth:` resource is `bad_uri`, and — the crux refusal — a tampered
bead is `resource_tampered`, the read answering nothing rather than serving corruption. The
store's own guarantee (a name pins a content address, the bytes prove themselves) becomes the
protocol's guarantee, unchanged.

## Grounded in witnessed ground

- `pond/apps/tablecloth.rye` (J7r1) — `Catalog`, `store_artifact`, `fetch_artifact` (verified,
  `DigestMismatch` on tamper), `address_hex`, `artifact_len`. Reused unchanged, over its
  public API.
- `pond/apps/mcp_bron.rye` (J3r1) — the flat-Bron `key value` idiom and the bounded
  envelope discipline the resource shapes mirror (`format …-v1`, unknown field refused).
- `mantra/beading.rye` — the content-addressed `BeadStore` Tablecloth names over; the tamper
  refusal originates here.

The bridge invents no storage and no transport: it reads a URI, fetches through the store's
verified path, and renders in an owned Bron shape. It reads no network — the real network
fetch and the Comlink-served transport stay the held custody/serve gates.

## The rungs, Lindy-first crux-first

1. **J10r1 — one artifact read as an MCP resource.** A `format mcp-resource-read-v1` request
   naming a `tablecloth:<name>` URI resolves through `fetch_artifact` and answers a
   `format mcp-resource-v1` result carrying uri · digest · length · content; a round-trip
   reader recovers uri and content; a tampered store, an unknown name, and a non-`tablecloth`
   URI each cross back as a named MCP error. This is the crux, taken first.
2. **J10r2 (horizon) — resources/list.** The whole catalog rendered as a bounded
   `format mcp-resource-list-v1` envelope — one `resource <uri> <name> <len>` line per
   artifact — so a caller discovers every readable artifact by URI, mirroring `tools/list`
   for the noun half.
3. **Held gate.** Serving the resource surface over Comlink / a real network transport reaches
   the serve gate that is the maintainer's hand.

A radiant close: with both MCP surfaces owned, Grain's intelligence and Grain's artifacts each
speak a protocol the wider world already knows — the voices as tools to invoke, the artifacts
as resources to read, every answer bounded and every refusal named, in a shape Grain owns end
to end.
