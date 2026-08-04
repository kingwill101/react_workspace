// GENERATED CODE — DO NOT EDIT
// Neutral Web surface for spec: WebCryptoAPI
// ignore_for_file: constant_identifier_names, unnecessary_late, non_constant_identifier_names, unused_local_variable, camel_case_types, unused_import

import 'webidl.dart';

abstract interface class AesCbcParams {
  BufferSource get iv;
  set iv(BufferSource value);
}

abstract interface class AesCtrParams {
  BufferSource get counter;
  set counter(BufferSource value);
  Object get length;
  set length(Object value);
}

abstract interface class AesDerivedKeyParams {
  int get length;
  set length(int value);
}

abstract interface class AesGcmParams {
  BufferSource get iv;
  set iv(BufferSource value);
  BufferSource get additionalData;
  set additionalData(BufferSource value);
  Object get tagLength;
  set tagLength(Object value);
}

abstract interface class AesKeyAlgorithm {
  int get length;
  set length(int value);
}

abstract interface class AesKeyGenParams {
  int get length;
  set length(int value);
}

abstract interface class Algorithm {
  String get name;
  set name(String value);
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
  CryptoKey get publicKey;
  set publicKey(CryptoKey value);
  CryptoKey get privateKey;
  set privateKey(CryptoKey value);
}

abstract interface class EcKeyAlgorithm {
  NamedCurve get namedCurve;
  set namedCurve(NamedCurve value);
}

abstract interface class EcKeyGenParams {
  NamedCurve get namedCurve;
  set namedCurve(NamedCurve value);
}

abstract interface class EcKeyImportParams {
  NamedCurve get namedCurve;
  set namedCurve(NamedCurve value);
}

abstract interface class EcdhKeyDeriveParams {
  CryptoKey get public;
  set public(CryptoKey value);
}

abstract interface class EcdsaParams {
  HashAlgorithmIdentifier get hash;
  set hash(HashAlgorithmIdentifier value);
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

abstract interface class HmacImportParams {
  HashAlgorithmIdentifier get hash;
  set hash(HashAlgorithmIdentifier value);
  int get length;
  set length(int value);
}

abstract interface class HmacKeyAlgorithm {
  KeyAlgorithm get hash;
  set hash(KeyAlgorithm value);
  int get length;
  set length(int value);
}

abstract interface class HmacKeyGenParams {
  HashAlgorithmIdentifier get hash;
  set hash(HashAlgorithmIdentifier value);
  int get length;
  set length(int value);
}

abstract interface class JsonWebKey {
  String get kty;
  set kty(String value);
  String get use;
  set use(String value);
  List<String> get key_ops;
  set key_ops(List<String> value);
  String get alg;
  set alg(String value);
  bool get ext;
  set ext(bool value);
  String get crv;
  set crv(String value);
  String get x;
  set x(String value);
  String get y;
  set y(String value);
  String get d;
  set d(String value);
  String get n;
  set n(String value);
  String get e;
  set e(String value);
  String get p;
  set p(String value);
  String get q;
  set q(String value);
  String get dp;
  set dp(String value);
  String get dq;
  set dq(String value);
  String get qi;
  set qi(String value);
  List<RsaOtherPrimesInfo> get oth;
  set oth(List<RsaOtherPrimesInfo> value);
  String get k;
  set k(String value);
}

abstract interface class KeyAlgorithm {
  String get name;
  set name(String value);
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

abstract interface class RsaHashedImportParams {
  HashAlgorithmIdentifier get hash;
  set hash(HashAlgorithmIdentifier value);
}

abstract interface class RsaHashedKeyAlgorithm {
  KeyAlgorithm get hash;
  set hash(KeyAlgorithm value);
}

abstract interface class RsaHashedKeyGenParams {
  HashAlgorithmIdentifier get hash;
  set hash(HashAlgorithmIdentifier value);
}

abstract interface class RsaKeyAlgorithm {
  int get modulusLength;
  set modulusLength(int value);
  BigInteger get publicExponent;
  set publicExponent(BigInteger value);
}

abstract interface class RsaKeyGenParams {
  int get modulusLength;
  set modulusLength(int value);
  BigInteger get publicExponent;
  set publicExponent(BigInteger value);
}

abstract interface class RsaOaepParams {
  BufferSource get label;
  set label(BufferSource value);
}

abstract interface class RsaOtherPrimesInfo {
  String get r;
  set r(String value);
  String get d;
  set d(String value);
  String get t;
  set t(String value);
}

abstract interface class RsaPssParams {
  int get saltLength;
  set saltLength(int value);
}

abstract interface class SubtleCrypto {
  Future<Object> encrypt(AlgorithmIdentifier algorithm, CryptoKey key, BufferSource data);
  Future<Object> decrypt(AlgorithmIdentifier algorithm, CryptoKey key, BufferSource data);
  Future<Object> sign(AlgorithmIdentifier algorithm, CryptoKey key, BufferSource data);
  Future<bool> verify(AlgorithmIdentifier algorithm, CryptoKey key, BufferSource signature, BufferSource data);
  Future<Object> digest(AlgorithmIdentifier algorithm, BufferSource data);
  Future<Object> generateKey(AlgorithmIdentifier algorithm, bool extractable, List<KeyUsage> keyUsages);
  Future<CryptoKey> deriveKey(AlgorithmIdentifier algorithm, CryptoKey baseKey, AlgorithmIdentifier derivedKeyType, bool extractable, List<KeyUsage> keyUsages);
  Future<Object> deriveBits(AlgorithmIdentifier algorithm, CryptoKey baseKey, [int? length]);
  Future<CryptoKey> importKey(KeyFormat format, Object keyData, AlgorithmIdentifier algorithm, bool extractable, List<KeyUsage> keyUsages);
  Future<Object> exportKey(KeyFormat format, CryptoKey key);
  Future<Object> wrapKey(KeyFormat format, CryptoKey key, CryptoKey wrappingKey, AlgorithmIdentifier wrapAlgorithm);
  Future<CryptoKey> unwrapKey(KeyFormat format, BufferSource wrappedKey, CryptoKey unwrappingKey, AlgorithmIdentifier unwrapAlgorithm, AlgorithmIdentifier unwrappedKeyAlgorithm, bool extractable, List<KeyUsage> keyUsages);
}

