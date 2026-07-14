# Hyperfiddle — UIs as streaming DAGs

**Honors:** Dustin Getz (Hyperfiddle, Electric Clojure)

**Sources:**

- Talk: [UIs are streaming DAGs](https://www.hytradboi.com/2022/uis-are-streaming-dags) (Hytradboi 2022)
- Project: <https://github.com/hyperfiddle/electric>
- Site: <https://www.hyperfiddle.net/>

**Role for us:** Getz names what the Realidream lane already reaches toward — a UI as a **streaming directed acyclic graph**, where changes propagate along dependency edges and network crossings are visible in the graph itself rather than hidden behind request waterfalls. The grain-sketchbook's unified DAG backend (Aurora + Skate + Realidream) credited this vision directly; Rye OS carries the discipline forward under truer names: **Weave** as the log, **fold** as the frame, **Tilak** as per-consumer meaning.

**Clean room:** We study the talk and the architectural lesson; we never copy Electric source into our modules. The lane's gratitude shelf seats this name formally per Kaeden's word (`20260708.174500`).

**Cross-ref:** [`../work-in-progress/ROADMAP.md`](../work-in-progress/ROADMAP.md) — Visual Track · [`../external-research/20260708-021912_grain-sketchbook-realidream-mining.md`](../external-research/20260708-021912_grain-sketchbook-realidream-mining.md)
