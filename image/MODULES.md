# Every module in `image/`

**Language:** EN - **Voice:** Kyri - **Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Checkable -- **227 modules** stand in this directory on `20260824.082436`, and every one of them has a row below.
**Held to the directory by** [`../tools/i/image_module_roster_witness.rish`](../tools/i/image_module_roster_witness.rish) over [`../tools/fixtures/image_module_roster_scan.sh`](../tools/fixtures/image_module_roster_scan.sh), which gates `unrostered`, `phantom`, `duplicate_rows`, and `mismatched_rows` at zero.

This page exists because the front door could not hold it honestly. On `20260824` `README.md` stood at **400,042 bytes** -- the largest page in the tree -- and named **112** of the 227 modules beside it, so a reader used it as the roster and came away with half. A table a reader uses is a roster, and it wants the same bijection the program's own roster already has (REDS %184).

Each row's sentence comes from that module's own `//!` head comment, so the page says what the code says. For the reasoning behind a family, read [`PHOTOS.md`](PHOTOS.md), [`PRIMITIVES.md`](PRIMITIVES.md), or [`MARKETPLACE.md`](MARKETPLACE.md); this page answers *what is here* and stops there.

---

## The codec -- 2

Where a picture becomes a grid, and the rectangle algebra beneath every verb.

| Module | What it does |
|---|---|
| [`qoi.rye`](qoi.rye) | the open image codec (hunk0, the crux) |
| [`shape.rye`](shape.rye) | the open rectangle primitives |

## Photos -- the gestures -- 19

Every verb a keeper applies to a picture, each a pure function returning a fresh image. The prose is in [`PHOTOS.md`](PHOTOS.md).

| Module | What it does |
|---|---|
| [`blur.rye`](blur.rye) | an RGBA image blurred by a separable box mean |
| [`convolve.rye`](convolve.rye) | an RGBA image filtered by a general signed 3x3 convolution kernel |
| [`convolve_n.rye`](convolve_n.rye) | an RGBA image filtered by a general signed NxN convolution kernel |
| [`crop_gesture.rye`](crop_gesture.rye) | drag a rectangle on the picture, lift, and it becomes a crop edit |
| [`edges.rye`](edges.rye) | an RGBA image's edges found by the Sobel operator |
| [`edit_cursor.rye`](edit_cursor.rye) | the edit cursor -- undo and redo over one history, a fresh edit forgets the road not taken |
| [`edit_input.rye`](edit_input.rye) | the edit input seam -- a keeper's raw gesture becomes exactly one history move |
| [`edit_touch_input.rye`](edit_touch_input.rye) | the finger surface proper -- a tap on a strip, a swipe left or right, becomes one edit gesture |
| [`filter_preset.rye`](filter_preset.rye) | named filter presets -- a book of recipes applied by name |
| [`gaussian.rye`](gaussian.rye) | an RGBA image Gaussian-blurred by a stack of box means |
| [`hit_test.rye`](hit_test.rye) | given a pixel, name the object under it |
| [`photo_edits.rye`](photo_edits.rye) | the non-destructive edit-list -- verbs as data, replayed and travelling |
| [`photo_revert.rye`](photo_revert.rye) | the Photos app reverts -- step back through the edit-list, the original one apply away |
| [`photos.rye`](photos.rye) | the first Photos verb, a crop over the decoded grid |
| [`scale.rye`](scale.rye) | an RGBA image resampled to a new size by nearest-neighbor |
| [`scale_area.rye`](scale_area.rye) | an RGBA image resampled to a new size by area averaging |
| [`scale_bilinear.rye`](scale_bilinear.rye) | an RGBA image resampled to a new size by bilinear interpolation |
| [`separable.rye`](separable.rye) | an RGBA image filtered by a separable convolution kernel in two 1D passes |
| [`sharpen.rye`](sharpen.rye) | an RGBA image sharpened by the unsharp mask |

## Paint -- sources and composition -- 14

A pattern a surface can fill a box with, and the compositing that puts one image over another.

| Module | What it does |
|---|---|
| [`checker_paint.rye`](checker_paint.rye) | a checkerboard seen on an image |
| [`compose.rye`](compose.rye) | one image seen over another |
| [`compose_tiled.rye`](compose_tiled.rye) | a source pattern tiled to fill a box |
| [`conic_paint.rye`](conic_paint.rye) | a conic positioned gradient seen on an image |
| [`gradient_paint.rye`](gradient_paint.rye) | a positioned gradient seen on an image |
| [`palette_paint.rye`](palette_paint.rye) | a palette of color swatches seen on an image |
| [`place_paint.rye`](place_paint.rye) | one source placed at a named anchor in a box |
| [`radial_paint.rye`](radial_paint.rye) | a radial positioned gradient seen on an image |
| [`repeat_conic_paint.rye`](repeat_conic_paint.rye) | a repeating conic positioned gradient seen on an image |
| [`repeat_paint.rye`](repeat_paint.rye) | a repeating positioned gradient seen on an image |
| [`repeat_radial_paint.rye`](repeat_radial_paint.rye) | a repeating radial positioned gradient seen on an image |
| [`round_paint.rye`](round_paint.rye) | a source pattern rounded to fill a box, whole copies scaled to fit exactly |
| [`space_paint.rye`](space_paint.rye) | a source pattern spaced to fill a box, whole copies with even ground gaps |
| [`text_paint.rye`](text_paint.rye) | the open text-painting rung |

## Color -- 18

The open sRGB algebra and the design-system layer above it -- palettes, ramps, names, contrast.

| Module | What it does |
|---|---|
| [`color.rye`](color.rye) | the open sRGB color algebra |
| [`color_adjust.rye`](color_adjust.rye) | HSL-space color adjustment verbs |
| [`color_contrast.rye`](color_contrast.rye) | the WCAG contrast reading of an on-color palette |
| [`color_describe.rye`](color_describe.rye) | the plain human description of any color |
| [`color_format.rye`](color_format.rye) | write any color to its CSS functional string |
| [`color_gradient.rye`](color_gradient.rye) | an even gradient ramp between two colors |
| [`color_harmony.rye`](color_harmony.rye) | named color-wheel schemes grown from one seed |
| [`color_name_group.rye`](color_name_group.rye) | the coarse color family of any color, over the open color algebra |
| [`color_names.rye`](color_names.rye) | the named CSS/HTML color table over the open color algebra |
| [`color_names_css.rye`](color_names_css.rye) | the full CSS named-color table over the open color algebra |
| [`color_nearest.rye`](color_nearest.rye) | the nearest named color to any color, over the open color algebra |
| [`color_nearest_css.rye`](color_nearest_css.rye) | the nearest CSS-named color to any color, over the open color algebra |
| [`color_ramp.rye`](color_ramp.rye) | a piecewise-linear ramp across many control colors |
| [`color_ramp_stops.rye`](color_ramp_stops.rye) | a positioned multi-stop gradient |
| [`color_readable.rye`](color_readable.rye) | nudge a color to meet a WCAG contrast floor over the open color algebra |
| [`color_scale.rye`](color_scale.rye) | a tonal palette scale grown from one seed color |
| [`color_swatch.rye`](color_swatch.rye) | a tonal scale where every tone carries its own legible ink |
| [`color_tone.rye`](color_tone.rye) | the coarse tone of any color (dark, mid, light), over the open color algebra |

## Type -- the 5x7 font -- 48

One bitmap font and its coverage, glyph by glyph, plus the accent composition above it. Reached by [`PRIMITIVES.md`](PRIMITIVES.md).

| Module | What it does |
|---|---|
| [`font5x7.rye`](font5x7.rye) | the first permissive font corpus |
| [`font5x7_accented.rye`](font5x7_accented.rye) | the unifying accented-Latin font |
| [`font5x7_acute.rye`](font5x7_acute.rye) | the open acute-accent vowels corpus, grown by composition |
| [`font5x7_alpha.rye`](font5x7_alpha.rye) | the open uppercase alphabet corpus |
| [`font5x7_arrow.rye`](font5x7_arrow.rye) | the open arrow corpus |
| [`font5x7_arrowdiag.rye`](font5x7_arrowdiag.rye) | the open diagonal-arrow corpus |
| [`font5x7_arrows.rye`](font5x7_arrows.rye) | the unifying arrow font |
| [`font5x7_ascii.rye`](font5x7_ascii.rye) | the unifying full-ASCII font |
| [`font5x7_block.rye`](font5x7_block.rye) | the open block-elements corpus |
| [`font5x7_box.rye`](font5x7_box.rye) | the open box-drawing corpus |
| [`font5x7_boxarc.rye`](font5x7_boxarc.rye) | the open rounded-corner box set |
| [`font5x7_boxdiag.rye`](font5x7_boxdiag.rye) | the open box-drawing corpus |
| [`font5x7_boxdouble.rye`](font5x7_boxdouble.rye) | the open box-drawing corpus |
| [`font5x7_boxdrawing.rye`](font5x7_boxdrawing.rye) | the unifying box-drawing font |
| [`font5x7_circumflex.rye`](font5x7_circumflex.rye) | the open circumflex vowels corpus |
| [`font5x7_circumflex_comp.rye`](font5x7_circumflex_comp.rye) | the open circumflex vowels corpus, grown by composition |
| [`font5x7_currency.rye`](font5x7_currency.rye) | the open currency-signs corpus |
| [`font5x7_diaeresis.rye`](font5x7_diaeresis.rye) | the open diaeresis-accent vowels corpus |
| [`font5x7_diaeresis_comp.rye`](font5x7_diaeresis_comp.rye) | the open diaeresis-accent vowels corpus, grown by composition, and the accent economy's proven boundary |
| [`font5x7_fraction.rye`](font5x7_fraction.rye) | the open vulgar-fractions corpus |
| [`font5x7_genpunct.rye`](font5x7_genpunct.rye) | the open general-punctuation corpus |
| [`font5x7_geometric.rye`](font5x7_geometric.rye) | the open geometric-shapes corpus |
| [`font5x7_german.rye`](font5x7_german.rye) | the open German letters corpus |
| [`font5x7_grave.rye`](font5x7_grave.rye) | the open grave-accent vowels corpus |
| [`font5x7_greek.rye`](font5x7_greek.rye) | the open Greek-letters corpus |
| [`font5x7_greek_upper.rye`](font5x7_greek_upper.rye) | the open Greek capitals corpus |
| [`font5x7_icelandic.rye`](font5x7_icelandic.rye) | the open Icelandic letters corpus |
| [`font5x7_latin1.rye`](font5x7_latin1.rye) | the open Latin-1 accented-letters corpus |
| [`font5x7_latin1_block.rye`](font5x7_latin1_block.rye) | the unifying Latin-1 letter font |
| [`font5x7_latin1_text.rye`](font5x7_latin1_text.rye) | the Western European text font |
| [`font5x7_lower.rye`](font5x7_lower.rye) | the open lowercase alphabet corpus |
| [`font5x7_math.rye`](font5x7_math.rye) | the open math/technical-marks corpus |
| [`font5x7_nordic.rye`](font5x7_nordic.rye) | the open Danish-Norwegian letters corpus |
| [`font5x7_punct.rye`](font5x7_punct.rye) | the open punctuation corpus |
| [`font5x7_subscript.rye`](font5x7_subscript.rye) | the open subscript-digits corpus |
| [`font5x7_superscript.rye`](font5x7_superscript.rye) | the open superscript-digits corpus |
| [`font5x7_symbol.rye`](font5x7_symbol.rye) | the open symbol corpus |
| [`font5x7_tilde.rye`](font5x7_tilde.rye) | the open tilde-accent vowels corpus |
| [`font5x7_tilde_comp.rye`](font5x7_tilde_comp.rye) | the open tilde-accent vowels corpus, grown by composition |
| [`font5x7_upper.rye`](font5x7_upper.rye) | the unifying accented-capitals font |
| [`font5x7_upper_accented.rye`](font5x7_upper_accented.rye) | the open uppercase accented-letters corpus |
| [`font5x7_upper_close.rye`](font5x7_upper_close.rye) | the three capitals that close the uppercase Latin-1 letter set |
| [`font5x7_upper_icelandic.rye`](font5x7_upper_icelandic.rye) | the open Icelandic capitals corpus |
| [`font5x7_upper_latin1.rye`](font5x7_upper_latin1.rye) | the rest of the open uppercase Latin-1 accented letters, completing the capitals set |
| [`font5x7_upper_nordic.rye`](font5x7_upper_nordic.rye) | the open Danish-Norwegian capitals corpus |
| [`glyph.rye`](glyph.rye) | the open glyph atlas |
| [`glyph_accent.rye`](glyph_accent.rye) | a whole accented corpus by composition |
| [`glyph_compose.rye`](glyph_compose.rye) | the combining-diacritic overlay |

## Text -- panels and layout -- 7

Type arranged into something a surface draws: a caption, a grid, a marquee, a subtitle.

| Module | What it does |
|---|---|
| [`text_caption.rye`](text_caption.rye) | the framed caption panel meets the moving video frame |
| [`text_grid.rye`](text_grid.rye) | the monospace grid painted into an image |
| [`text_layout.rye`](text_layout.rye) | the open text-layout rung |
| [`text_marquee.rye`](text_marquee.rye) | the open video codecs proven on real panning motion |
| [`text_panel.rye`](text_panel.rye) | the framed text panel |
| [`text_reel.rye`](text_reel.rye) | Season G's capstone |
| [`text_subtitle.rye`](text_subtitle.rye) | the timed subtitle track |

## Video -- frames and the player -- 5

The open intra-frame container and the player furniture around it.

| Module | What it does |
|---|---|
| [`frames.rye`](frames.rye) | the open intra-frame video container (gfv1, Season G, the rung after the glyph atlas) |
| [`frames_delta.rye`](frames_delta.rye) | the open inter-frame video codec (gfd1, Season G, the rung after the gfv1 container) |
| [`player_hud.rye`](player_hud.rye) | the player HUD |
| [`scrubber.rye`](scrubber.rye) | the playback scrubber |
| [`timecode.rye`](timecode.rye) | the burned-in timecode |

## The parts marketplace -- 8

The catalog, its honest facts, and the boolean query algebra over them. The prose is in [`MARKETPLACE.md`](MARKETPLACE.md).

| Module | What it does |
|---|---|
| [`part_and.rye`](part_and.rye) | an AND of clauses -- narrow the marketplace on several facets at once |
| [`part_catalog.rye`](part_catalog.rye) | the parts marketplace carries honest facts beside each window |
| [`part_facets.rye`](part_facets.rye) | the faceted query -- OR within a facet, AND across facets |
| [`part_filter.rye`](part_filter.rye) | narrow the marketplace to the parts that match a query |
| [`part_or.rye`](part_or.rye) | an OR of clauses -- widen the marketplace to the parts matching any facet |
| [`part_query.rye`](part_query.rye) | a typed search box -- parse a keeper's query text into a filter Query |
| [`sprite.rye`](sprite.rye) | the single-sprite marketplace index -- one sheet, each product a window into it |
| [`sprite_catalog.rye`](sprite_catalog.rye) | the marketplace catalog travels as text (the sprite quest closes) |

## Shape analysis -- 48

Season G's morphology and shape family: threshold, label, measure, thin, and describe what a mask holds.

| Module | What it does |
|---|---|
| [`branch.rye`](branch.rye) | mark every skeleton junction of an RGBA mask |
| [`centroid.rye`](centroid.rye) | read every labeled component's centroid (its center of mass) and find the region nearest a point |
| [`chain_code.rye`](chain_code.rye) | encode a traced outer boundary as a Freeman 8-direction chain code, the compact orientation-aware boundary representation |
| [`contour.rye`](contour.rye) | trace a labeled component's outer boundary as an ordered clockwise walk of pixel coordinates |
| [`convex_diameter.rye`](convex_diameter.rye) | the diameter of a shape |
| [`convex_hull.rye`](convex_hull.rye) | the convex hull of a point set by Andrew's monotone chain |
| [`convexity_defects.rye`](convexity_defects.rye) | the depth of each dent below the convex hull, read point-by-point |
| [`disk.rye`](disk.rye) | a true disk structuring element for the general morphology gather |
| [`distance.rye`](distance.rye) | give every foreground pixel of an RGBA mask its distance to the nearest background pixel |
| [`distance_morph.rye`](distance_morph.rye) | true-radius erosion and dilation of an RGBA mask, read in one pass off the chamfer distance field rather than gathered over a structuring element |
| [`edge_draw.rye`](edge_draw.rye) | draw the straight edge between two points as a connected run of pixels, and paint a polygon's whole closed outline from its corner vertices |
| [`endpoints.rye`](endpoints.rye) | mark every skeleton endpoint of an RGBA mask |
| [`euler_number.rye`](euler_number.rye) | the Euler number of a segmented region |
| [`fill_polygon.rye`](fill_polygon.rye) | fill a polygon's whole interior solid from its corner vertices |
| [`hitmiss.rye`](hitmiss.rye) | the hit-OR-miss transform |
| [`hmaxima.rye`](hmaxima.rye) | suppress the shallow peaks of a distance field so a lumpy single object stops over-segmenting |
| [`hu_moments.rye`](hu_moments.rye) | read every labeled component's seven Hu invariant moments |
| [`inscribed_disk.rye`](inscribed_disk.rye) | the largest inscribed disk of a mask |
| [`label.rye`](label.rye) | give every 8-connected component of an RGBA mask its own label |
| [`medial_axis.rye`](medial_axis.rye) | read a shape's metric spine off the distance field |
| [`min_area_rect.rye`](min_area_rect.rye) | the minimum-area oriented bounding box of a point set by rotating calipers over the convex hull's edges |
| [`min_enclosing_circle.rye`](min_enclosing_circle.rye) | the minimum enclosing circle of a shape |
| [`min_width.rye`](min_width.rye) | the minimum-width slot of a point set |
| [`moments.rye`](moments.rye) | read every labeled component's second central moments, then its orientation and eccentricity |
| [`morphology.rye`](morphology.rye) | an RGBA image reshaped by mathematical morphology |
| [`morphology_gradient.rye`](morphology_gradient.rye) | an RGBA image's boundaries lit by the morphological gradient |
| [`morphology_tophat.rye`](morphology_tophat.rye) | an RGBA image's small features recovered by the morphological top-hat residues |
| [`polygon.rye`](polygon.rye) | simplify an ordered contour ring to the few vertices that define its shape, by Douglas-Peucker |
| [`prune.rye`](prune.rye) | an RGBA skeleton pruned of its short spurs |
| [`region_stats.rye`](region_stats.rye) | read a labeling's size structure |
| [`region_summary.rye`](region_summary.rye) | read a query rectangle as a small digest table |
| [`regions.rye`](regions.rye) | read every labeled component's size and bounding box, then despeckle a mask by an area threshold |
| [`roundness.rye`](roundness.rye) | reconcile a shape's inner inscribed bound and outer enclosing bound in one shared convention |
| [`roundness_universal.rye`](roundness_universal.rye) | close the universal inner-<=-outer roundness proof image/roundness.rye named as its honest next horizon |
| [`segment.rye`](segment.rye) | segment a bare mask into its separated objects with no hand-seated markers |
| [`shape_classify.rye`](shape_classify.rye) | name an unknown shape by the closest of a labeled set of template fingerprints |
| [`shape_match.rye`](shape_match.rye) | read the distance between two shapes' Hu fingerprints |
| [`shape_number.rye`](shape_number.rye) | the start-invariant, rotation-invariant canonical form of a boundary |
| [`shape_signature.rye`](shape_signature.rye) | the shape signature of a segmented region |
| [`skeleton.rye`](skeleton.rye) | an RGBA mask skeletonized to its medial lines by the classic thinning template pack |
| [`structure.rye`](structure.rye) | an RGBA image reshaped by a general structuring element |
| [`thin.rye`](thin.rye) | an RGBA mask thinned to its skeleton by iterated hit-OR-miss subtraction |
| [`threshold.rye`](threshold.rye) | turn a real image into the binary mask the segmentation family consumes, by an automatic threshold read from the image's own tones |
| [`tophat_disk.rye`](tophat_disk.rye) | an RGBA image's small features recovered by the isotropic top-hat residues over a true disk element |
| [`turning.rye`](turning.rye) | the differential turning descriptor of a boundary |
| [`watershed.rye`](watershed.rye) | separate touching blobs a connected-component labeler reads as one |
| [`width_profile.rye`](width_profile.rye) | the width profile of a point set |
| [`zhang_suen.rye`](zhang_suen.rye) | an RGBA mask thinned to a one-pixel-wide skeleton by the classic Zhang-Suen parallel algorithm |

## Selection -- clicks, lassos, rectangles -- 21

What a keeper's gesture actually covers, decided in exact integers over the label map.

| Module | What it does |
|---|---|
| [`click_between.rye`](click_between.rye) | the three-click betweenness relation |
| [`click_bounds.rye`](click_bounds.rye) | the click-then-bounds read |
| [`click_collinear.rye`](click_collinear.rye) | the three-click collinearity read |
| [`click_expand.rye`](click_expand.rye) | the click-then-expand gesture |
| [`click_facts.rye`](click_facts.rye) | the click-then-facts read |
| [`click_nearest.rye`](click_nearest.rye) | the three-click nearest relation |
| [`click_order.rye`](click_order.rye) | the two-click reading-order relation |
| [`click_relation.rye`](click_relation.rye) | the two-click relation read |
| [`click_side.rye`](click_side.rye) | the two-anchor which-side read |
| [`lasso_cluster.rye`](lasso_cluster.rye) | which connected clusters a free-form lasso lands on |
| [`lasso_partition.rye`](lasso_partition.rye) | given a query polygon (a free-form lasso), partition the scene's objects into three disjoint classes |
| [`lasso_select.rye`](lasso_select.rye) | given a query polygon (a free-form lasso), name every object it actually covers |
| [`lasso_summary.rye`](lasso_summary.rye) | read a query polygon (a free-form lasso) as a small digest table |
| [`region_cluster.rye`](region_cluster.rye) | which connected clusters a query rectangle lands on |
| [`region_partition.rye`](region_partition.rye) | given a query rectangle, partition the scene's objects into three disjoint classes |
| [`region_select.rye`](region_select.rye) | given a query rectangle, name every object it actually covers |
| [`selection_bounds.rye`](selection_bounds.rye) | the tight bounding box that encloses a whole selection |
| [`selection_cluster_facts.rye`](selection_cluster_facts.rye) | the whole-cluster facts a selection expands to |
| [`selection_neighbors.rye`](selection_neighbors.rye) | the grow-selection gesture |
| [`selection_shrink.rye`](selection_shrink.rye) | the shrink-selection gesture |
| [`selection_summary.rye`](selection_summary.rye) | read a selection as a small table |

## Scene structure -- lines, clusters, order -- 35

How the objects in a scene relate to one another: pairwise, in clusters, along a line, and in reading order.

| Module | What it does |
|---|---|
| [`cluster_adjacency.rye`](cluster_adjacency.rye) | the cluster graph above the object graph |
| [`cluster_connectivity.rye`](cluster_connectivity.rye) | when the whole cluster layout becomes one connected region as reach grows |
| [`cluster_diameter_path.rye`](cluster_diameter_path.rye) | the actual edge list the diameter walks |
| [`cluster_facts.rye`](cluster_facts.rye) | the facts of each connected cluster |
| [`cluster_graph.rye`](cluster_graph.rye) | the whole cluster-neighbor graph above the cluster pair |
| [`cluster_graph_profile.rye`](cluster_graph_profile.rye) | the cluster graph read as a distribution over thresholds |
| [`cluster_minimum_spanning_tree.rye`](cluster_minimum_spanning_tree.rye) | the skeleton that holds a layout together |
| [`cluster_mst_leaves.rye`](cluster_mst_leaves.rye) | the tips and the joints of the skeleton |
| [`cluster_mst_subtrees.rye`](cluster_mst_subtrees.rye) | the branches of the skeleton |
| [`cluster_seams.rye`](cluster_seams.rye) | the whole-tree seam decomposition |
| [`cluster_subtree_frames.rye`](cluster_subtree_frames.rye) | what the branches of the skeleton hold |
| [`cluster_tree_centroid.rye`](cluster_tree_centroid.rye) | the balance point of the skeleton |
| [`cluster_tree_diameter.rye`](cluster_tree_diameter.rye) | the longest reach across the skeleton |
| [`cluster_tree_radius.rye`](cluster_tree_radius.rye) | the center of the skeleton and the reach from it |
| [`euler_scene.rye`](euler_scene.rye) | the Euler number of a whole labeling |
| [`line_band.rye`](line_band.rye) | read a directed line named by two anchor taps (from anchor a toward anchor B) as a corridor marquee |
| [`line_corridor_summary.rye`](line_corridor_summary.rye) | read a directed line named by two anchor taps (from anchor a toward anchor B) as a distribution over half-widths |
| [`line_cross.rye`](line_cross.rye) | read two directed lines, each named by two anchor taps (stroke 1 from anchor a toward B, stroke 2 from C toward D), and answer how the two strokes relate |
| [`line_distance.rye`](line_distance.rye) | read a directed line named by two anchor taps (from anchor a toward anchor B) as a distance from the line |
| [`line_order.rye`](line_order.rye) | read a directed line named by two anchor taps (from anchor a toward anchor B) as a reading order along the line |
| [`line_partition.rye`](line_partition.rye) | given a directed line named by two anchor taps (from anchor a toward anchor B) |
| [`line_pierce.rye`](line_pierce.rye) | read a directed line named by two anchor taps (from anchor a toward anchor B) as a box crossing |
| [`line_project.rye`](line_project.rye) | read a directed line named by two anchor taps (from anchor a toward anchor B) as an exact nearest point |
| [`line_raycast.rye`](line_raycast.rye) | read one directed line, named by two anchor taps (from anchor a toward B), as a ray cast across the scene |
| [`line_segment_distance.rye`](line_segment_distance.rye) | read a directed line named by two anchor taps (from anchor a toward anchor B) as the true nearest gap to the finite stroke a..b |
| [`line_slice.rye`](line_slice.rye) | read one directed line, named by two anchor taps (from anchor a toward B), as a cut across the scene |
| [`line_span.rye`](line_span.rye) | read a directed line named by two anchor taps (from anchor a toward anchor B) as an along-segment position |
| [`line_summary.rye`](line_summary.rye) | read a directed line named by two anchor taps (from anchor a toward anchor B) as a small digest table |
| [`nesting_depth.rye`](nesting_depth.rye) | the nesting depth of every object in a scene's box-containment forest |
| [`object_relation.rye`](object_relation.rye) | the spatial relation between two objects in a scene |
| [`overlap_clusters.rye`](overlap_clusters.rye) | the connected clusters of the scene's box-overlap graph |
| [`overlap_degree.rye`](overlap_degree.rye) | every object's degree in the scene's box-overlap adjacency graph |
| [`reading_order.rye`](reading_order.rye) | the whole scene's total reading order |
| [`scene_graph.rye`](scene_graph.rye) | the whole scene's pairwise structure |
| [`scene_manifest.rye`](scene_manifest.rye) | one row per object for a whole scene |

## Seams into Tally -- 2

Two symlinks into [`../tally/`](../tally/), so a bounded copy and a strict parse are the same code here as everywhere else.

| Module | What it does |
|---|---|
| [`parse_int.rye`](parse_int.rye) | strict-by-default integer parsing |
| [`tally_copy.rye`](tally_copy.rye) | the disjoint copy, with its preconditions written down |

---

*Two hundred and twenty-seven rows, one per module, and a guard that reds the day the two disagree.*
