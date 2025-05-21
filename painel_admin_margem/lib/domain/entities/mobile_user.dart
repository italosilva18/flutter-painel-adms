import 'package:equatable/equatable.dart';

/// Entidade de usuário mobile para o domínio
class MobileUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? password;
  final String type;
  final String partner;
  final double codePartner;
  final bool active;
  final List<String> storeIds;

  const MobileUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.password,
    required this.type,
    required this.partner,
    required this.codePartner,
    required this.active,
    this.storeIds = const [],
  });

  /// Cria uma cópia do usuário mobile com valores atualizados
  MobileUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? password,
    String? type,
    String? partner,
    double? codePartner,
    bool? active,
    List<String>? storeIds,
  }) {
    return MobileUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      type: type ?? this.type,
      partner: partner ?? this.partner,
      codePartner: codePartner ?? this.codePartner,
      active: active ?? this.active,
      storeIds: storeIds ?? this.storeIds,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        password,
        type,
        partner,
        codePartner,
        active,
        storeIds,
      ];

  @override
  bool get stringify => true;
}

/// Tipos de usuário mobile
enum MobileUserType {
  admin('ADMIN'),
  seller('VENDEDOR'),
  customer('CLIENTE');

  final String value;
  const MobileUserType(this.value);

  static MobileUserType fromString(String value) {
    return MobileUserType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => MobileUserType.customer,
    );
  }

  @override
  String toString() => value;
}
