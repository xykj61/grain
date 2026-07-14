# Outer subscribe poll wire — parity 174

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.005012

## Thinking trace

Kaeden said keep going after parity 173 in-process. Built `mantra/recall_subscribe_poll_delivery.rye` — bounded poll cycles over catch-up wire (`pollOneCycleWireInProcess` / sockets), ports **38486/38487**. Selftest proves delayed-revision counsel shape under Comlink seal; demo runs source-loop + fetcher-poll; device lab reuses catch-up rev-2 hop as one poll-cycle body. Parity **174** GREEN.

## Observations

Q3 subscribe arc complete through wire (169–174). Host mirror answered as named pair list. Production scheduling, graceful stop, crash recovery remain open. Tablecloth query is last horizon item per ruling `232812`.

## Files

- `mantra/recall_subscribe_poll_delivery.rye` — poll wire (new)
- `tools/mantra_recall_subscribe_poll_wire.rish` — witness (new)
- `comlink/run_recall_subscribe_poll_wire_lab.sh` — device lab (new)
- Plus uncommitted 173 artifacts from prior turn (counsel `004712`, `recall_subscribe_poll.rye`)
- Docs, parity, width-check updated

**Recommend:** check in with Claude before **Tablecloth query** — last Q3 horizon item; may need counsel on query shape vs namespace.
