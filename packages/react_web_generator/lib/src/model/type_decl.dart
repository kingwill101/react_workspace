import 'type_ref.dart';
import 'member_decl.dart';

enum Exposure { full, opaque, mapped, excluded }

final class TypeParameterDecl {
  final String name;
  final TypeRef? bound;

  const TypeParameterDecl({required this.name, this.bound});

  Map<String, Object?> toJson() => {
    'name': name,
    if (bound != null) 'bound': bound!.toJson(),
  };
}

final class BrowserBinding {
  final String library;
  final String symbol;

  const BrowserBinding({required this.library, required this.symbol});

  Map<String, Object?> toJson() => {'library': library, 'symbol': symbol};
}

final class InterfaceDecl {
  final String typeId;
  final String name;
  final String? sourceName;
  final List<TypeParameterDecl> typeParameters;
  final List<TypeRef> extends_;
  final List<MemberDecl> members;
  final Exposure exposure;
  final BrowserBinding? browserBinding;

  const InterfaceDecl({
    required this.typeId,
    required this.name,
    this.sourceName,
    this.typeParameters = const [],
    this.extends_ = const [],
    this.members = const [],
    this.exposure = Exposure.full,
    this.browserBinding,
  });

  Map<String, Object?> toJson() => {
    'typeId': typeId,
    'kind': 'interface',
    'name': name,
    if (sourceName != null) 'sourceName': sourceName,
    if (typeParameters.isNotEmpty)
      'typeParameters': typeParameters.map((tp) => tp.toJson()).toList(),
    if (extends_.isNotEmpty)
      'extends': extends_.map((e) => e.toJson()).toList(),
    'members': members.map((m) => m.toJson()).toList(),
    'exposure': exposure.name,
    if (browserBinding != null) 'browserBinding': browserBinding!.toJson(),
  };
}

Exposure exposureFromJson(String s) {
  return switch (s) {
    'full' => Exposure.full,
    'opaque' => Exposure.opaque,
    'mapped' => Exposure.mapped,
    'excluded' => Exposure.excluded,
    _ => Exposure.full,
  };
}

InterfaceDecl interfaceDeclFromJson(Map<String, dynamic> json) {
  return InterfaceDecl(
    typeId: json['typeId'] as String,
    name: json['name'] as String,
    sourceName: json['sourceName'] as String?,
    typeParameters:
        (json['typeParameters'] as List<dynamic>?)
            ?.map(
              (tp) => TypeParameterDecl(
                name: tp['name'] as String,
                bound: tp['bound'] != null
                    ? typeRefFromJson(tp['bound'] as Map<String, dynamic>)
                    : null,
              ),
            )
            .toList() ??
        [],
    extends_:
        (json['extends'] as List<dynamic>?)
            ?.map((e) => typeRefFromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    members:
        (json['members'] as List<dynamic>?)
            ?.map((m) => memberDeclFromJson(m as Map<String, dynamic>))
            .toList() ??
        [],
    exposure: json['exposure'] != null
        ? exposureFromJson(json['exposure'] as String)
        : Exposure.full,
    browserBinding: json['browserBinding'] != null
        ? BrowserBinding(
            library:
                (json['browserBinding'] as Map<String, dynamic>)['library']
                    as String,
            symbol:
                (json['browserBinding'] as Map<String, dynamic>)['symbol']
                    as String,
          )
        : null,
  );
}
