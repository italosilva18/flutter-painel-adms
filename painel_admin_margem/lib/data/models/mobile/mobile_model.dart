import '../../../domain/entities/mobile_user.dart';

class MobileModel extends MobileUser {
  const MobileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.password,
    required super.type,
    required super.partner,
    required super.codePartner,
    required super.active,
    super.storeIds,
  });

  factory MobileModel.fromJson(Map<String, dynamic> json) {
    return MobileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'],
      type: json['type'] ?? 'CLIENTE',
      partner: json['partner'] ?? '',
      codePartner: (json['codePartner'] ?? 0.0).toDouble(),
      active: json['active'] ?? false,
      storeIds:
          json['storeIds'] is List ? List<String>.from(json['storeIds']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      if (password != null) 'password': password,
      'type': type,
      'partner': partner,
      'codePartner': codePartner,
      'active': active,
      'storeIds': storeIds,
    };
  }

  factory MobileModel.fromEntity(MobileUser entity) {
    return MobileModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      password: entity.password,
      type: entity.type,
      partner: entity.partner,
      codePartner: entity.codePartner,
      active: entity.active,
      storeIds: entity.storeIds,
    );
  }

  MobileModel copyWithModel({
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
    return MobileModel(
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
}
