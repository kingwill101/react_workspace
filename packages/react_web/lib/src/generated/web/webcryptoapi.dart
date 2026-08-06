// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: WebCryptoAPI
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webidl.dart';

abstract interface class AesCbcParams {
  BufferSource get iv;
  set iv(BufferSource value);
}

final class AesCbcParamsValue implements AesCbcParams {
  @override
  BufferSource iv;

  AesCbcParamsValue({
    required this.iv,
  });
}

abstract interface class AesCtrParams {
  BufferSource get counter;
  set counter(BufferSource value);
  Object get length;
  set length(Object value);
}

final class AesCtrParamsValue implements AesCtrParams {
  @override
  BufferSource counter;
  @override
  Object length;

  AesCtrParamsValue({
    required this.counter,
    required this.length,
  });
}

abstract interface class AesDerivedKeyParams {
  int get length;
  set length(int value);
}

final class AesDerivedKeyParamsValue implements AesDerivedKeyParams {
  @override
  int length;

  AesDerivedKeyParamsValue({
    required this.length,
  });
}

abstract interface class AesGcmParams {
  BufferSource get iv;
  set iv(BufferSource value);
  BufferSource? get additionalData;
  set additionalData(BufferSource? value);
  Object? get tagLength;
  set tagLength(Object? value);
}

final class AesGcmParamsValue implements AesGcmParams {
  @override
  BufferSource iv;
  @override
  BufferSource? additionalData;
  @override
  Object? tagLength;

  AesGcmParamsValue({
    required this.iv,
    this.additionalData,
    this.tagLength,
  });
}

abstract interface class AesKeyAlgorithm {
  int get length;
  set length(int value);
}

final class AesKeyAlgorithmValue implements AesKeyAlgorithm {
  @override
  int length;

  AesKeyAlgorithmValue({
    required this.length,
  });
}

abstract interface class AesKeyGenParams {
  int get length;
  set length(int value);
}

final class AesKeyGenParamsValue implements AesKeyGenParams {
  @override
  int length;

  AesKeyGenParamsValue({
    required this.length,
  });
}

abstract interface class Algorithm {
  String get name;
  set name(String value);
}

final class AlgorithmValue implements Algorithm {
  @override
  String name;

  AlgorithmValue({
    required this.name,
  });
}

typedef AlgorithmIdentifier = Object;

typedef BigInteger = Object;

abstract interface class Crypto {
  SubtleCrypto get subtle;
  ArrayBufferView getRandomValues(ArrayBufferView array);
  String randomUUID();
}

abstract interface class CryptoKey {
  KeyType get type;
  bool get extractable;
  Object get algorithm;
  Object get usages;
}

abstract interface class CryptoKeyPair {
  CryptoKey? get publicKey;
  set publicKey(CryptoKey? value);
  CryptoKey? get privateKey;
  set privateKey(CryptoKey? value);
}

final class CryptoKeyPairValue implements CryptoKeyPair {
  @override
  CryptoKey? publicKey;
  @override
  CryptoKey? privateKey;

  CryptoKeyPairValue({
    this.publicKey,
    this.privateKey,
  });
}

abstract interface class EcKeyAlgorithm {
  NamedCurve get namedCurve;
  set namedCurve(NamedCurve value);
}

final class EcKeyAlgorithmValue implements EcKeyAlgorithm {
  @override
  NamedCurve namedCurve;

  EcKeyAlgorithmValue({
    required this.namedCurve,
  });
}

abstract interface class EcKeyGenParams {
  NamedCurve get namedCurve;
  set namedCurve(NamedCurve value);
}

final class EcKeyGenParamsValue implements EcKeyGenParams {
  @override
  NamedCurve namedCurve;

  EcKeyGenParamsValue({
    required this.namedCurve,
  });
}

abstract interface class EcKeyImportParams {
  NamedCurve get namedCurve;
  set namedCurve(NamedCurve value);
}

final class EcKeyImportParamsValue implements EcKeyImportParams {
  @override
  NamedCurve namedCurve;

  EcKeyImportParamsValue({
    required this.namedCurve,
  });
}

abstract interface class EcdhKeyDeriveParams {
  CryptoKey get public;
  set public(CryptoKey value);
}

final class EcdhKeyDeriveParamsValue implements EcdhKeyDeriveParams {
  @override
  CryptoKey public;

  EcdhKeyDeriveParamsValue({
    required this.public,
  });
}

abstract interface class EcdsaParams {
  HashAlgorithmIdentifier get hash;
  set hash(HashAlgorithmIdentifier value);
}

final class EcdsaParamsValue implements EcdsaParams {
  @override
  HashAlgorithmIdentifier hash;

  EcdsaParamsValue({
    required this.hash,
  });
}

typedef HashAlgorithmIdentifier = AlgorithmIdentifier;

abstract interface class HkdfParams {
  HashAlgorithmIdentifier get hash;
  set hash(HashAlgorithmIdentifier value);
  BufferSource get salt;
  set salt(BufferSource value);
  BufferSource get info;
  set info(BufferSource value);
}

final class HkdfParamsValue implements HkdfParams {
  @override
  HashAlgorithmIdentifier hash;
  @override
  BufferSource salt;
  @override
  BufferSource info;

  HkdfParamsValue({
    required this.hash,
    required this.salt,
    required this.info,
  });
}

abstract interface class HmacImportParams {
  HashAlgorithmIdentifier get hash;
  set hash(HashAlgorithmIdentifier value);
  int? get length;
  set length(int? value);
}

final class HmacImportParamsValue implements HmacImportParams {
  @override
  HashAlgorithmIdentifier hash;
  @override
  int? length;

  HmacImportParamsValue({
    required this.hash,
    this.length,
  });
}

abstract interface class HmacKeyAlgorithm {
  KeyAlgorithm get hash;
  set hash(KeyAlgorithm value);
  int get length;
  set length(int value);
}

final class HmacKeyAlgorithmValue implements HmacKeyAlgorithm {
  @override
  KeyAlgorithm hash;
  @override
  int length;

  HmacKeyAlgorithmValue({
    required this.hash,
    required this.length,
  });
}

abstract interface class HmacKeyGenParams {
  HashAlgorithmIdentifier get hash;
  set hash(HashAlgorithmIdentifier value);
  int? get length;
  set length(int? value);
}

final class HmacKeyGenParamsValue implements HmacKeyGenParams {
  @override
  HashAlgorithmIdentifier hash;
  @override
  int? length;

  HmacKeyGenParamsValue({
    required this.hash,
    this.length,
  });
}

abstract interface class JsonWebKey {
  String? get kty;
  set kty(String? value);
  String? get use;
  set use(String? value);
  List<String>? get key_ops;
  set key_ops(List<String>? value);
  String? get alg;
  set alg(String? value);
  bool? get ext;
  set ext(bool? value);
  String? get crv;
  set crv(String? value);
  String? get x;
  set x(String? value);
  String? get y;
  set y(String? value);
  String? get d;
  set d(String? value);
  String? get n;
  set n(String? value);
  String? get e;
  set e(String? value);
  String? get p;
  set p(String? value);
  String? get q;
  set q(String? value);
  String? get dp;
  set dp(String? value);
  String? get dq;
  set dq(String? value);
  String? get qi;
  set qi(String? value);
  List<RsaOtherPrimesInfo>? get oth;
  set oth(List<RsaOtherPrimesInfo>? value);
  String? get k;
  set k(String? value);
}

final class JsonWebKeyValue implements JsonWebKey {
  @override
  String? kty;
  @override
  String? use;
  @override
  List<String>? key_ops;
  @override
  String? alg;
  @override
  bool? ext;
  @override
  String? crv;
  @override
  String? x;
  @override
  String? y;
  @override
  String? d;
  @override
  String? n;
  @override
  String? e;
  @override
  String? p;
  @override
  String? q;
  @override
  String? dp;
  @override
  String? dq;
  @override
  String? qi;
  @override
  List<RsaOtherPrimesInfo>? oth;
  @override
  String? k;

  JsonWebKeyValue({
    this.kty,
    this.use,
    this.key_ops,
    this.alg,
    this.ext,
    this.crv,
    this.x,
    this.y,
    this.d,
    this.n,
    this.e,
    this.p,
    this.q,
    this.dp,
    this.dq,
    this.qi,
    this.oth,
    this.k,
  });
}

abstract interface class KeyAlgorithm {
  String get name;
  set name(String value);
}

final class KeyAlgorithmValue implements KeyAlgorithm {
  @override
  String name;

  KeyAlgorithmValue({
    required this.name,
  });
}

typedef KeyFormat = String;

typedef KeyType = String;

typedef KeyUsage = String;

typedef NamedCurve = String;

abstract interface class Pbkdf2Params {
  BufferSource get salt;
  set salt(BufferSource value);
  int get iterations;
  set iterations(int value);
  HashAlgorithmIdentifier get hash;
  set hash(HashAlgorithmIdentifier value);
}

final class Pbkdf2ParamsValue implements Pbkdf2Params {
  @override
  BufferSource salt;
  @override
  int iterations;
  @override
  HashAlgorithmIdentifier hash;

  Pbkdf2ParamsValue({
    required this.salt,
    required this.iterations,
    required this.hash,
  });
}

abstract interface class RsaHashedImportParams {
  HashAlgorithmIdentifier get hash;
  set hash(HashAlgorithmIdentifier value);
}

final class RsaHashedImportParamsValue implements RsaHashedImportParams {
  @override
  HashAlgorithmIdentifier hash;

  RsaHashedImportParamsValue({
    required this.hash,
  });
}

abstract interface class RsaHashedKeyAlgorithm {
  KeyAlgorithm get hash;
  set hash(KeyAlgorithm value);
}

final class RsaHashedKeyAlgorithmValue implements RsaHashedKeyAlgorithm {
  @override
  KeyAlgorithm hash;

  RsaHashedKeyAlgorithmValue({
    required this.hash,
  });
}

abstract interface class RsaHashedKeyGenParams {
  HashAlgorithmIdentifier get hash;
  set hash(HashAlgorithmIdentifier value);
}

final class RsaHashedKeyGenParamsValue implements RsaHashedKeyGenParams {
  @override
  HashAlgorithmIdentifier hash;

  RsaHashedKeyGenParamsValue({
    required this.hash,
  });
}

abstract interface class RsaKeyAlgorithm {
  int get modulusLength;
  set modulusLength(int value);
  BigInteger get publicExponent;
  set publicExponent(BigInteger value);
}

final class RsaKeyAlgorithmValue implements RsaKeyAlgorithm {
  @override
  int modulusLength;
  @override
  BigInteger publicExponent;

  RsaKeyAlgorithmValue({
    required this.modulusLength,
    required this.publicExponent,
  });
}

abstract interface class RsaKeyGenParams {
  int get modulusLength;
  set modulusLength(int value);
  BigInteger get publicExponent;
  set publicExponent(BigInteger value);
}

final class RsaKeyGenParamsValue implements RsaKeyGenParams {
  @override
  int modulusLength;
  @override
  BigInteger publicExponent;

  RsaKeyGenParamsValue({
    required this.modulusLength,
    required this.publicExponent,
  });
}

abstract interface class RsaOaepParams {
  BufferSource? get label;
  set label(BufferSource? value);
}

final class RsaOaepParamsValue implements RsaOaepParams {
  @override
  BufferSource? label;

  RsaOaepParamsValue({
    this.label,
  });
}

abstract interface class RsaOtherPrimesInfo {
  String? get r;
  set r(String? value);
  String? get d;
  set d(String? value);
  String? get t;
  set t(String? value);
}

final class RsaOtherPrimesInfoValue implements RsaOtherPrimesInfo {
  @override
  String? r;
  @override
  String? d;
  @override
  String? t;

  RsaOtherPrimesInfoValue({
    this.r,
    this.d,
    this.t,
  });
}

abstract interface class RsaPssParams {
  int get saltLength;
  set saltLength(int value);
}

final class RsaPssParamsValue implements RsaPssParams {
  @override
  int saltLength;

  RsaPssParamsValue({
    required this.saltLength,
  });
}

abstract interface class SubtleCrypto {
  Future<Object> encrypt(AlgorithmIdentifier algorithm, CryptoKey key, BufferSource data);
  Future<Object> decrypt(AlgorithmIdentifier algorithm, CryptoKey key, BufferSource data);
  Future<Object> sign(AlgorithmIdentifier algorithm, CryptoKey key, BufferSource data);
  Future<Object> verify(AlgorithmIdentifier algorithm, CryptoKey key, BufferSource signature, BufferSource data);
  Future<Object> digest(AlgorithmIdentifier algorithm, BufferSource data);
  Future<Object> generateKey(AlgorithmIdentifier algorithm, bool extractable, List<KeyUsage> keyUsages);
  Future<Object> deriveKey(AlgorithmIdentifier algorithm, CryptoKey baseKey, AlgorithmIdentifier derivedKeyType, bool extractable, List<KeyUsage> keyUsages);
  Future<Object> deriveBits(AlgorithmIdentifier algorithm, CryptoKey baseKey, int length);
  Future<CryptoKey> importKey(KeyFormat format, Object keyData, AlgorithmIdentifier algorithm, bool extractable, List<KeyUsage> keyUsages);
  Future<Object> exportKey(KeyFormat format, CryptoKey key);
  Future<Object> wrapKey(KeyFormat format, CryptoKey key, CryptoKey wrappingKey, AlgorithmIdentifier wrapAlgorithm);
  Future<CryptoKey> unwrapKey(KeyFormat format, BufferSource wrappedKey, CryptoKey unwrappingKey, AlgorithmIdentifier unwrapAlgorithm, AlgorithmIdentifier unwrappedKeyAlgorithm, bool extractable, List<KeyUsage> keyUsages);
}

