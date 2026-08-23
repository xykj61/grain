# Lantern — Local Inference in Pond

**Language:** EN
**Last updated:** 2026-07-11 (RW-5 contract `005028`; tips **420**/**421**)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable-room module — laps 0–33 green; RW-5 mirrored pair landed

---

Lantern serves bounded request/response inference inside Pond. Each lap deepens the contract, one checkable pin at a time: a pinned fixture completion, a `max_tokens` budget, a model-hash allow-list, `temperature` and `seed`, `top_p`, `err_stop`, `stop_sequence` on the response, a request-side `stop_sequence` pin, a request-side `prompt` pin, a request-side `max_tokens` pin, a response `text_pin`, a dedicated `TemperatureMismatch` pin, a seed-only pin fixture, `TopPMismatch` distinct from range `BadTopP`, an `err_stop` request pin, a `length_stop` request pin, empty allow-list refuse, an `allow_count` pin, dual-model allow welcome, a `require_model` pin, `stopped_reason` pins, then a `stream` pin. Weights named by hash and Caravan supervision follow on later laps.

| Lap | Claim | Witness |
|-----|--------|---------|
| **0** | Request validation · model hash match · fixture response | parity **213** |
| **1** | `max_tokens` truncate · length stop · zero budget refused | `tools/lantern_lap1.rish` |
| **2** | Model allow-list gate · unknown hash refused | parity **252** · `tools/lantern_lap2.rish` |
| **3** | `temperature` + `seed` · range and pin checks | parity **258** · `tools/lantern_lap3.rish` |
| **4** | `top_p` · range and pin checks | parity **275** · `tools/lantern_lap4.rish` |
| **5** | `err_stop` · fixture pin | parity **279** · `tools/lantern_lap5.rish` |
| **6** | `stop_sequence` · response fixture pin | parity **283** · `tools/lantern_lap6.rish` |
| **7** | `stop_sequence` · request pin + mismatch refuse | parity **287** · `tools/lantern_lap7.rish` (`191112`) |
| **8** | `prompt` · request pin + mismatch refuse | parity **294** · `tools/lantern_lap8.rish` (`192749`) |
| **9** | `max_tokens` · request pin + mismatch refuse | parity **298** · `tools/lantern_lap9.rish` (`193358`) |
| **10** | `text_pin` · response pin + mismatch refuse | parity **302** · `tools/lantern_lap10.rish` (`200203`) |
| **11** | `temperature` · request pin + `TemperatureMismatch` | parity **306** · `tools/lantern_lap11.rish` (`200819`) |
| **12** | `seed` · request pin fixture + mismatch refuse | parity **310** · `tools/lantern_lap12.rish` (`211930`) |
| **13** | `top_p` · `TopPMismatch` distinct from `BadTopP` | parity **314** · `tools/lantern_lap13.rish` (`211930`) |
| **14** | `err_stop` · request pin + `ErrStopMismatch` | parity **318** · `tools/lantern_lap14.rish` (`212715`) |
| **15** | `length_stop` · request pin + `LengthStopMismatch` | parity **322** · `tools/lantern_lap15.rish` (`212715`) |
| **16** | Empty allow-list · `EmptyAllowList` | parity **326** · `tools/lantern_lap16.rish` (`213317`) |
| **17** | `allow_count` · pin + `AllowCountMismatch` | parity **330** · `tools/lantern_lap17.rish` (`213317`) |
| **18** | Dual-model allow · assist hash welcome | parity **334** · `tools/lantern_lap18.rish` (`213738`) |
| **19** | `require_model` · pin + `RequireModelMissing` | parity **338** · `tools/lantern_lap19.rish` (`213738`) |
| **20** | `stopped_reason` · eos pin | parity **342** · `tools/lantern_lap20.rish` (`214145`) |
| **21** | `stopped_reason` · length pin | parity **346** · `tools/lantern_lap21.rish` (`214145`) |
| **22** | `stream` · pin false | parity **350** · `tools/lantern_lap22.rish` (`215613`) |
| **23** | `stream` · pin true | parity **354** · `tools/lantern_lap23.rish` (`215613`) |
| **24** | `stopped_reason` · err_stop pin | parity **358** · `tools/lantern_lap24.rish` (`223639`) |
| **25** | `stopped_reason` · stop_sequence pin | parity **362** · `tools/lantern_lap25.rish` (`223639`) |
| **26** | `top_k` · request pin | parity **366** · `tools/lantern_lap26.rish` (`224322`) |
| **27** | `frequency_penalty` · request pin | parity **370** · `tools/lantern_lap27.rish` (`224322`) |
| **28** | `presence_penalty` · request pin | parity **374** · `tools/lantern_lap28.rish` (`224805`) |
| **29** | `n` · request pin | parity **378** · `tools/lantern_lap29.rish` (`224805`) |

## Layout

| Path | Role |
|------|------|
| [`lantern_core.rye`](lantern_core.rye) | Request/response types, fixture complete + pins through stream |
| [`lantern.rye`](lantern.rye) | Selftest |
| [`fixtures/completion.bron`](fixtures/completion.bron) | pinned completion |
| [`fixtures/completion_length.bron`](fixtures/completion_length.bron) | long completion |
| [`fixtures/allowed_models.bron`](fixtures/allowed_models.bron) | model-hash allow-list |
| [`fixtures/completion_seed.bron`](fixtures/completion_seed.bron) | seed + temperature pin |
| [`fixtures/completion_top_p.bron`](fixtures/completion_top_p.bron) | top_p pin |
| [`fixtures/completion_err_stop.bron`](fixtures/completion_err_stop.bron) | err_stop pin |
| [`fixtures/completion_stop_sequence.bron`](fixtures/completion_stop_sequence.bron) | stop_sequence pin |
| [`fixtures/completion_prompt.bron`](fixtures/completion_prompt.bron) | prompt pin |
| [`fixtures/completion_max_tokens.bron`](fixtures/completion_max_tokens.bron) | max_tokens pin |
| [`fixtures/completion_text.bron`](fixtures/completion_text.bron) | text pin |
| [`fixtures/completion_temperature.bron`](fixtures/completion_temperature.bron) | temperature pin |
| [`fixtures/completion_seed_pin.bron`](fixtures/completion_seed_pin.bron) | seed pin |
| [`fixtures/completion_err_stop_pin.bron`](fixtures/completion_err_stop_pin.bron) | err_stop pin |
| [`fixtures/completion_length_stop_pin.bron`](fixtures/completion_length_stop_pin.bron) | length_stop pin |
| [`fixtures/allowed_models_empty.bron`](fixtures/allowed_models_empty.bron) | empty allow-list |
| [`fixtures/completion_allow_count.bron`](fixtures/completion_allow_count.bron) | allow_count pin |
| [`fixtures/allowed_models_one.bron`](fixtures/allowed_models_one.bron) | single-model mismatch |
| [`fixtures/completion_assist.bron`](fixtures/completion_assist.bron) | assist-model completion |
| [`fixtures/completion_require_model.bron`](fixtures/completion_require_model.bron) | require_model pin |
| [`fixtures/completion_stopped_reason_pin.bron`](fixtures/completion_stopped_reason_pin.bron) | stopped_reason eos pin |
| [`fixtures/completion_stopped_reason_length_pin.bron`](fixtures/completion_stopped_reason_length_pin.bron) | stopped_reason length pin |
| [`fixtures/completion_stream_pin.bron`](fixtures/completion_stream_pin.bron) | stream pin false |
| [`fixtures/completion_stream_on.bron`](fixtures/completion_stream_on.bron) | stream pin true |
| [`fixtures/completion_stopped_reason_err_stop_pin.bron`](fixtures/completion_stopped_reason_err_stop_pin.bron) | stopped_reason err_stop pin |
| [`fixtures/completion_stopped_reason_stop_sequence_pin.bron`](fixtures/completion_stopped_reason_stop_sequence_pin.bron) | stopped_reason stop_sequence pin |
| [`fixtures/completion_top_k.bron`](fixtures/completion_top_k.bron) | top_k pin |
| [`fixtures/completion_frequency_penalty.bron`](fixtures/completion_frequency_penalty.bron) | frequency_penalty pin |
| [`fixtures/completion_presence_penalty.bron`](fixtures/completion_presence_penalty.bron) | presence_penalty pin |
| [`fixtures/completion_n.bron`](fixtures/completion_n.bron) | n pin |

**RW-5** (`20260711.005028`) — mirrored pair with Drawn Terminal at `complete_fixture`: collaboration tip **420** (`tools/rw5_lantern_collab.rish`), contract tip **421** (`tools/rw5_lantern_contract.rish` · `lantern rw5contracttest`). Contract on paper: [`../construction/archive/20260711-005028_rw5-mirrored-pair-contract.md`](../construction/archive/20260711-005028_rw5-mirrored-pair-contract.md).

*May every completion honor its budget. May length stops stay honest. May only listed models speak. May seed, top_p, err_stop, stop_sequence, prompt, max_tokens, text, temperature, TopPMismatch, err_stop, length_stop, stopped_reason, and stream pins keep the fixture path deterministic.*
