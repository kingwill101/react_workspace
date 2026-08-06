// GENERATED CODE — DO NOT EDIT
// ignore_for_file: type=lint
// Neutral Web surface for spec: webcrypto-secure-curves
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webidl.dart';
import 'webcryptoapi.dart';

abstract interface class Ed448Params {
  BufferSource? get context;
  set context(BufferSource? value);
}

final class Ed448ParamsValue implements Ed448Params {
  @override
  BufferSource? context;

  Ed448ParamsValue({
    this.context,
  });
}

