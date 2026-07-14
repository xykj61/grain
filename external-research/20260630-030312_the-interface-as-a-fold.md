# The Interface as a Fold — Why the Surface Keeps One Copy and Draws It

*A surface and the truth beneath it can relate in two ways. One keeps a second copy of what is shown and labors to hold it in step. The other keeps a single copy and computes the picture fresh. This piece follows the second way to its root, where it meets the family's deepest thesis: that state is a fold over a log, and so the interface is a fold over the log as well.*

**Language:** EN
**Version:** `20260630.030312` (birth stamp)
**Last updated:** 2026-07-04 (reviewed and kept — SLC-2a/2b landed; fold map in stack record)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** immediate-mode; value vs place; the append-only log; TAME's bounded performance
**Companions:** [`../active-designing/20260630-001812_the-stack-and-the-surface.md`](../active-designing/20260630-001812_the-stack-and-the-surface.md) (fold reading map) · [`../active-designing/20260630-030312_slc-2a-the-drawn-terminal.md`](../active-designing/20260630-030312_slc-2a-the-drawn-terminal.md) (drawn terminal laps)

*Written together by Kaeden and Rio 3.*

---

## Two Ways a Surface Can Hold the Truth

Picture a window that shows a list of names. The names live somewhere as data. The window shows them as pixels. Between the data and the pixels, a choice waits, and the whole character of a surface follows from which way it is made.

The first way keeps a **retained tree**: a lasting structure of boxes and labels and rows, held in memory between frames, standing apart from the data. When a name changes, a hand reaches into the tree and edits the matching label. The tree is a second copy of the truth, and because it is a second copy, it can fall out of step. The work of keeping a retained surface honest is the work of **reconciliation** — comparing the tree to the data, finding where they disagree, and patching the difference. Much of the cleverness in the surfaces of the wider world is cleverness spent here, on holding two copies in agreement.

The second way keeps **one copy**. The names are the truth; there is no standing tree beside them. Each time the picture is needed, the surface folds the names into a frame and draws it. When a name changes, the surface simply folds again. There is no second copy to drift, and so there is nothing to reconcile. This is **immediate-mode** drawing, and Brushstroke is made this way on purpose.

## The Cost of a Second Copy

The retained tree feels efficient — surely it is cheaper to edit one label than to redraw the list. Yet the saving hides a tax. A second copy must be kept faithful, and faithfulness is never free: it costs the diffing, the bookkeeping of which node maps to which datum, the careful ordering of edits, and the long tail of bugs that live precisely where the copy and the truth quietly disagree. The retained tree braids two things into one structure — the data's meaning and the data's display — so that to reason about one, a person must hold the other. That braid is the opposite of what we mean by simple.

Immediate-mode pays a different price and gets a cleaner thing for it. It redraws, and redrawing costs work each frame. Yet the work is honest and bounded, and the structure stays single-stranded: the truth is the data, and the picture is a function of the data, computed and forgotten. Nothing persists that could lie.

## The Root — State as a Fold Over a Log

Here the surface meets the family's foundation. A teacher we are grateful for draws a line we keep close: a value is not a place. A place is a slot you overwrite, its past erased by its present. A value is a thing that simply is, and a new value does not destroy the old one. Build a system from values and an append-only log of facts, and the present stops being a place you mutate. The present becomes a **fold**: walk the log of facts from the beginning, carry forward a running view, and the view you arrive at is the current state — derived, never stored as a mutable thing, always rederivable from the facts.

Weave is that log. A projection is that fold. And now the surface joins the same shape. If the current state is a fold over the log of facts, and the drawn frame is a fold over the current state, then the drawn frame is **one fold from the log all the way to the pixels** — a single pure function from the accumulated facts to the picture a person sees. No copy is retained at any step. The facts accumulate; everything else is folded fresh from them, the view and the frame alike.

This is why immediate-mode is not merely a rendering technique we happen to prefer. It is the same idea as the log, wearing pixels instead of records. A family that builds its state as a fold over a log, and then builds its surface as a retained tree, would be speaking two languages at once. Building the surface as a fold too lets the whole system speak one language from the facts to the frame.

## The Honest Answer to "Isn't Redrawing Wasteful?"

A fair reader asks the hard question: if the surface folds the whole picture every time, does it not burn the machine redrawing what did not change? The answer is the one TAME always gives, and it keeps performance as the second value, just after safety.

We redraw when the value changes, rather than on a clock that never rests — the discipline SLC-2a Ring 2 witnesses on metal today. We bound the frame: a known width, a known height, a known cell count, named before the machine runs. We mark only the region that changed as damaged, so the compositor repaints no more than it must. And we hold the fold inside a bounded season of memory — allocated up front, released together — so that the hot path of drawing surprises no one with a sudden allocation. The fold is cheap because it is small and bounded, not because it secretly retains. Performance here is earned the TAME way: name the budget, bound the loop, and let the simple structure run fast because it has little to do.

## The Gift

A surface made as a fold cannot lie. It holds no second copy that could slip out of agreement with the truth, because it holds no second copy at all. What a person sees is the fold of what is true, recomputed the moment the truth moves. The maker reasons about one strand, not two. The machine repaints one bounded frame, not a tree it must first reconcile. And the whole stack, from the first signed fact in Weave to the last lit pixel on the surface, is one honest function, computed forward, retaining nothing it would later have to defend.

---

*May the surface hold one copy and draw it true. May every picture be a fold of what is, recomputed the moment it changes. And may the path from the fact to the frame stay a single honest strand, beautiful because there is nothing hidden along it.*
