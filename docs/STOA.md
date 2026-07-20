# STOA — Glow SLC · nest · product · ≤80 · STOA0–110 GREEN · 2026-07-20 (G0–G5 · bartis · nest/type) · draw → **STOA**
| Rung | Claim | Witness / gate | State |
|------|-------|----------------|-------|
| **STOA0** | Eight rune heads + desk hop · `(lent)` · `(mix)` | `glow_run_desk_witness` · `glow_expr_witness` | **GREEN** (claimed `20260718.202730`) |
| **STOA1** | `(jam <face> <face>)` thin cell-pack · desks | `glow_expr` · `glow_lower_*` · desk | **GREEN** `20260718.203000` |
| **STOA2** | `:-` pair cell · ninth rune head | `glow_rune_cell` · `glow_lower_cell` · desk | **GREEN** `20260718.204500` |
| **STOA3** | `:+` triple cell · tenth rune head | `glow_rune_triple` · `glow_lower_triple` · desk | **GREEN** `20260718.205200` |
| **STOA4** | `:^` quad cell · eleventh rune head | `glow_rune_quad` · `glow_lower_quad` · desk | **GREEN** `20260718.205400` |
| **STOA5** | `:~` list cell · twelfth rune head | `glow_rune_list` · `glow_lower_list` · desk | **GREEN** `20260718.205715` |
| **STOA6** | `%-` one-arg call · thirteenth rune head | `glow_rune_call` · `glow_lower_call` · desk | **GREEN** `20260718.205959` |
| **STOA7** | `%+` two-arg call · fourteenth rune head | `glow_rune_call2` · `glow_lower_call2` · desk | **GREEN** `20260718.210823` |
| **STOA8** | `%^` three-arg call · fifteenth rune head | `glow_rune_call3` · `glow_lower_call3` · desk | **GREEN** `20260718.211059` |
| **STOA9** | `%*` named-arg call · sixteenth rune head | `glow_rune_calln` · `glow_lower_calln` · desk | **GREEN** `20260718.211343` |
| **STOA10** | Multi-line bare `=/` desk (2–4 lines) | `glow_lower_multi` · desk | **GREEN** `20260718.211817` |
| **STOA11** | Cross-line face→`%-` compose | `glow_lower_compose` · desk | **GREEN** `20260718.212131` |
| **STOA12** | Cross-line face→face→`%+` compose | `glow_lower_compose2` · desk | **GREEN** `20260718.221812` |
| **STOA13** | Typed multi-line `@u32` desks | `glow_lower_multi_typed` · desk | **GREEN** `20260718.223431` |
| **STOA14** | Thin `|%` / `++` / `--` core | `glow_rune_core` · `glow_lower_core` · desk | **GREEN** `20260718.224030` |
| **STOA15** | Two-arm battery (`double` · `inc`) | `glow_rune_core` · `glow_lower_core` · desk | **GREEN** `20260718.225150` |
| **STOA16** | Library emit (no `main`) | `glow_lower_core_lib` · consumer | **GREEN** `20260718.225150` |
| **STOA17** | Core payload `=/` sample | `glow_rune_core` · `glow_lower_core` · desk | **GREEN** `20260718.225931` |
| **STOA18** | Face→`|%` compose | `glow_lower_compose_core` · desk | **GREEN** `20260718.230846` |
| **STOA19** | Face→two-arm `|%` | `glow_lower_compose_core` · desk | **GREEN** `20260718.231511` |
| **STOA20** | Three-arm battery (`dec`) | `glow_rune_core` · `glow_lower_core` · desk | **GREEN** `20260718.231511` |
| **STOA21** | Typed payload `@u32` | `glow_rune_core` · `glow_lower_core` · desk | **GREEN** `20260718.232419` |
| **STOA22** | Face→three-arm `|%` | `glow_lower_compose_core` · desk | **GREEN** `20260718.233120` |
| **STOA23** | Two faces→`|%` `add` | `glow_lower_compose_core_add` · desk | **GREEN** `20260718.234122` |
| **STOA24** | Face→payload `|%` | `glow_lower_compose_core_payload` · desk | **GREEN** `20260718.234430` |
| **STOA25** | Open `++` arm body | `glow_rune_core` · `glow_lower_core` · desk | **GREEN** `20260718.235220` |
| **STOA26** | `/+` library compose | `glow_lower_compose_lib` · desk | **GREEN** `20260718.235530` |
| **STOA27** | Nest `++` arm body | `glow_rune_core` · `glow_lower_core` · desk | **GREEN** `20260718.235804` |
| **STOA28** | Face→open `|%` | `glow_lower_compose_core` · desk | **GREEN** `20260719.000132` |
| **STOA29** | `/+` nest library | `glow_lower_compose_lib` · desk | **GREEN** `20260719.000324` |
| **STOA30** | Payload+open `|%` | `glow_lower_compose_core_payload` · desk | **GREEN** `20260719.000745` |
| **STOA31** | `/+` payload library | `glow_lower_compose_lib` · desk | **GREEN** `20260719.001148` |
| **STOA32** | `(cue <face>)` thin unpack · desks | `glow_expr` · `glow_lower_*` · desk | **GREEN** `20260719.002221` |
| **STOA33** | `(jam (mix …) …)` one-deep nest · face | `glow_expr` · `glow_lower_face` · desk | **GREEN** `20260719.002726` |
| **STOA34** | Nest jam under `?:`/`?-`/`?~` arms | `glow_lower_*` · desks | **GREEN** `20260719.005207` |
| **STOA35** | Nest jam under open `++` | `glow_rune_core` · `glow_lower_core` · desk | **GREEN** `20260719.005650` |
| **STOA36** | `(jam … (mix …))` nest right | `glow_expr` · `glow_lower_*` · desks | **GREEN** `20260719.010409` |
| **STOA37** | `(jam (mix …) (mix …))` nest both | `glow_expr` · `glow_lower_*` · desks | **GREEN** `20260719.143329` |
| **STOA38** | `(cue (jam …))` nest round-trip | `glow_expr` · `glow_lower_*` · desks | **GREEN** `20260719.144929` |
| **STOA39** | Cross-line jam→cue compose | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.145738` |
| **STOA40** | `(cue (jam (mix …) …))` nest-left | `glow_expr` · `glow_lower_*` · desks | **GREEN** `20260719.150634` |
| **STOA41** | `(cue (jam … (mix …)))` nest-right | `glow_expr` · `glow_lower_*` · desks | **GREEN** `20260719.151831` |
| **STOA42** | `(cue (jam (mix …) (mix …)))` nest-both | `glow_expr` · `glow_lower_*` · desks | **GREEN** `20260719.153013` |
| **STOA43** | Bind→jam→cue product multi-line | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.153556` |
| **STOA44** | Bind→nest-jam→cue product multi-line | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.154112` |
| **STOA45** | Bind→nest-right-jam→cue product | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.154325` |
| **STOA46** | Bind→nest-both-jam→cue product | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.154840` |
| **STOA47** | Three-bind nest-left jam→cue | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.155553` |
| **STOA48** | Four-bind nest-both jam→cue | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.161949` |
| **STOA49** | Bind→inline cue-of-jam product | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.162549` |
| **STOA50** | Bind→inline nest-left cue-of-jam | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.163125` |
| **STOA51** | Bind→inline nest-right cue-of-jam | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.163527` |
| **STOA52** | Bind→inline nest-both cue-of-jam | `glow_lower_compose_jam_cue` · desk | **GREEN** `20260719.163945` |
| **STOA53** | Face→`|%` cue-of-jam | `glow_lower_compose_core` · desk | **GREEN** `20260719.164640` |
| **STOA54** | Face→nest-left cue-of-jam | `glow_lower_compose_core` · desk | **GREEN** `20260719.165048` |
| **STOA55** | Face→nest-right cue-of-jam | `glow_lower_compose_core` · desk | **GREEN** `20260719.165404` |
| **STOA56** | Face→nest-both cue-of-jam | `glow_lower_compose_core` · desk | **GREEN** `20260719.165724` |
| **STOA57** | `/+` cue-of-jam library | `glow_lower_compose_lib` · desk | **GREEN** `20260719.170057` |
| **STOA58** | `/+` nest-left cue-of-jam | `glow_lower_compose_lib` · desk | **GREEN** `20260719.170718` |
| **STOA59** | `/+` nest-right cue-of-jam | `glow_lower_compose_lib` · desk | **GREEN** `20260719.171131` |
| **STOA60** | `/+` nest-both cue-of-jam | `glow_lower_compose_lib` · desk | **GREEN** `20260719.171500` |
| **STOA61** | Face→payload cue-of-jam | `glow_lower_compose_core_payload` · desk | **GREEN** `20260719.171844` |
| **STOA62** | Face→payload nest-left cue-of-jam | `glow_lower_compose_core_payload` · desk | **GREEN** `20260719.172234` |
| **STOA63** | Face→payload nest-right cue-of-jam | `glow_lower_compose_core_payload` · desk | **GREEN** `20260719.172625` |
| **STOA64** | Face→payload nest-both cue-of-jam | `glow_lower_compose_core_payload` · desk | **GREEN** `20260719.173215` |
| **STOA65** | `/+` payload cue-of-jam library | `glow_lower_compose_lib` · desk | **GREEN** `20260719.173708` |
| **STOA66** | `/+` payload nest-left cue-of-jam | `glow_lower_compose_lib` · desk | **GREEN** `20260719.174116` |
| **STOA67** | `/+` payload nest-right cue-of-jam | `glow_lower_compose_lib` · desk | **GREEN** `20260719.174531` |
| **STOA68** | `/+` payload nest-both cue-of-jam | `glow_lower_compose_lib` · desk | **GREEN** `20260719.175024` |
| **STOA69** | next-root product desk (`/+` · payload · cue-jam) | `glow_lower_compose_lib` · desk | **GREEN** `20260719.180837` |
| **STOA70** | session-root nest-left product desk | `glow_lower_compose_lib` · desk | **GREEN** `20260719.181259` |
| **STOA71** | NativeActivity-path Glow import seam | `stoa71_glow_import_seam_witness` | **GREEN** `20260719.182120` |
| **STOA72** | NativeActivity APK Glow import wire | `stoa72_glow_apk_import_witness` · pack | **GREEN** `20260719.182648` |
| **STOA73** | product-root write + Pixel install (expect 5) | write · `stoa73_…_install_onpath_host` | **GREEN** write `184836` · eyes `191719` |
| **STOA74–75** | `+$` / `$:` `@u32` mold (1–7 fields · capacity through STOA142) | `glow_rune_mold` · `glow_lower_mold` · desk | **GREEN** `190825` · `192241` |
| **STOA76–83** | `$%` · cast · payload · multi · tag/pay · token stream | mold · named-cast · tokens | **GREEN** `192936`…`200706` |
| **STOA84–105** | Cast · alphabet · G4–G5 · bartis tidy | tokens · G5 · bartis | **GREEN** `201027`…`042300` |
| **STOA106** | Nest/type surface wording (nesting samples) | `glow_nest_type_surface_witness` | **GREEN** `20260720.042931` |
| **STOA107** | Nest/type thin implement (stated aura) | `glow_nest_type_witness` · bartis | **GREEN** `20260720.043251` |
| **STOA108** | Nest/type `$%` tag nest | `glow_nest_type_witness` · mold-kind | **GREEN** `20260720.145814` |
| **STOA109** | Named-mold bartis (`amount-mold`) | `glow_nest_type_witness` · bartis · desk | **GREEN** `20260720.150155` |
| **STOA110** | Nesting-refuse nest path | `glow_nest_type_witness` · barket horizon | **GREEN** `20260720.150635` |
| **STOA111** | Barket tokenize (`\|^` → 27) | `glow_barket_tokenize_witness` · alphabet | **GREEN** `20260720.151119` |
| **STOA112** | Barket header parse (stated demo) | `glow_barket_parse_witness` · tokenize | **GREEN** `20260720.174115` |
| **STOA113** | Barket identity lower (`barket_gate`) | `glow_barket_lower_witness` · `glow_run` | **GREEN** `20260720.175115` |
| **STOA114** | Barket argv sample | `glow_barket_lower_witness` · `--sample-argv` | **GREEN** `20260720.175643` |
| **STOA115** | Barket call-body double | `glow_barket_lower_witness` · `glow_run` | **GREEN** `20260720.180047` |
| **STOA116** | Barket call-body inc/dec | `glow_barket_lower_witness` · `glow_run` | **GREEN** `20260720.180445` |
| **STOA117** | Barket TAME tidy | `glow_barket_lower_witness` · `tame_style_scan_bans` | **GREEN** `20260720.180900` |
| **STOA118** | Named-mold barket | `glow_barket_lower_witness` · `glow_run` | **GREEN** `20260720.181347` |
| **STOA119** | Nesting-nests under stated mold | `glow_nest_type_witness` | **GREEN** `20260720.181950` |
| **STOA120** | Nesting-nests barket/bartis wire | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.182450` |
| **STOA121** | Barket nesting-through-nests | `glow_barket_lower_witness` | **GREEN** `20260720.182915` |
| **STOA122** | Count-mold named allowlist | `glow_nest_type_witness` · barket · bartis | **GREEN** `20260720.183259` |
| **STOA123** | Kind-mold gate sample | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.183837` |
| **STOA124** | Xact-mold gate sample | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.184304` |
| **STOA125** | Xfer-mold gate sample | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.184953` |
| **STOA126** | Pair-mold gate sample | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.185502` |
| **STOA127** | Kind-mold flip call-body | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.190544` |
| **STOA128** | Xact-mold flip call-body | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.191033` |
| **STOA129** | Xfer-mold flip call-body | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.192038` |
| **STOA130** | Stated · nesting · gold vocabulary | `glow_nest_type_witness` · barket · bartis | **GREEN** `20260720.192738` |
| **STOA131** | Pair-mold flip call-body | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.193357` |
| **STOA132** | Amount-mold argv sample | `glow_barket_lower_witness` · bartis · glow_run | **GREEN** `20260720.193805` |
| **STOA133** | Count-mold argv sample | `glow_barket_lower_witness` · bartis · glow_run | **GREEN** `20260720.194143` |
| **STOA134** | Triple-mold gate sample | `glow_nest_type_witness` · barket · bartis | **GREEN** `20260720.194437` |
| **STOA135** | Quad-mold gate sample | `glow_nest_type_witness` · barket · bartis | **GREEN** `20260720.195131` |
| **STOA136** | Triple-mold flip call-body | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.195742` |
| **STOA137** | Quad-mold flip call-body | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.200022` |
| **STOA138** | Penta-mold gate sample | `glow_nest_type_witness` · barket · bartis | **GREEN** `20260720.215530` |
| **STOA139** | Penta-mold flip call-body | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.221625` |
| **STOA140** | Hexa-mold gate sample | `glow_nest_type_witness` · barket · bartis | **GREEN** `20260720.222338` |
| **STOA141** | Hexa-mold flip call-body | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.222724` |
| **STOA142** | Hepta-mold gate sample | `glow_nest_type_witness` · barket · bartis | **GREEN** `20260720.224116` |
| **STOA143** | Hepta-mold flip call-body | `glow_barket_lower_witness` · bartis | **GREEN** `20260720.224734` |
Smoke: `glow_barket_lower_witness` · `glow_barket_parse_witness` · `glow_nest_type_witness` · `glow_lower_bartis_witness` · Sibling: **ZETA** · **LULU** · **SETU** · **TUBE**.
