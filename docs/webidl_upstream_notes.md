# Upstream `dart-lang/web` generator study notes

Findings from cloning `https://github.com/dart-lang/web` and studying `web_generator`
and `js_interop_gen`, applied to `react_web_generator`.

## Where `web_apis.json` comes from

- `web_generator/bin/preparse_idls.mjs` produces `web_apis.json` from **webref**:
  `@webref/idl.parseAll()`, `@webref/css.listAll()`, `@webref/elements.listAll()`.
- Therefore the snapshot contains the **full webref IDL corpus** (all specs), not a
  curated subset. Generating every definition and module from it — exactly what the
  complete pipeline in `react_web_generator/lib/src/complete/` does — is correct.
- The three top-level keys are `idl`, `css`, `elements`.
- A `dartWebRevision` in our `tool/web_idl/snapshots/provenance.json` records the
  revision; it is not part of upstream's own output.

## Name handling (`interop_gen/banned_names.dart`, `namer.dart`)

Upstream `dartRename`/`makeNonConflicting`:
- `-` → `_`
- leading `_` → prefix `$`
- Dart keyword → suffix `$`
- collisions within a scope → `$i`
- core keyword set includes `toString` and `Function`.

`override` and the IDL `Function` typedef are NOT special-cased upstream because
those specific webref APIs are absent from package:web's rendered set. Our corpus
includes them, so `react_web_generator` handles them explicitly (escape `override`
→ `override_`; skip the un-declarable `typedef Function` and lower references to
`Function`).

## Union lowering (`js_interop_gen/lib/src/type_union.dart`)

Upstream computes the JS **least upper bound** of union members. `react_web`
lowers unions to an opaque `Object` in the neutral surface (the "opaque but
present, never missing" representation); this is a documented divergence since
the neutral facade has no JS type hierarchy.

## Implication for the browser adapter

The installed `package:web 1.1.1` maps only ~1458 types while the snapshot needs
~2626 definitions (+ referenced types). To generate the full browser
(`Browser<Name> implements <Name>`) adapter, `package:web` must be pinned to the
revision whose `web_apis.json` matches `tool/web_idl/snapshots/web_apis.json`
(provenance `dartWebRevision`). Until then, `dart run tool/web_idl/verify.dart
--strict` reports the mapping gap.
