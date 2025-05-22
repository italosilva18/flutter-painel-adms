import '../../../domain/entities/support_user.dart';

class SupportModel extends SupportUser {
  const SupportModel({
    required String id,
    required String name,
    required String email,
    required String partner,
    required double codePartner,
  }) : super(
          id: id,
          name: name,
          email: email,
          partner: partner,
          codePartner: codePartner,
        );

  factory SupportModel.fromJson(Map<String, dynamic> json) {
    return SupportModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      partner: json['partner'] ?? '',
      codePartner: (json['codePartner'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'partner': partner,
      'codePartner': codePartner,
    };
  }

  factory SupportModel.fromEntity(SupportUser entity) {
    return SupportModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      partner: entity.partner,
      codePartner: entity.codePartner,
    );
  }

  SupportModel copyWithModel({
    String? id,
    String? name,
    String? email,
    String? partner,
    double? codePartner,
  }) {
    return SupportModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      partner: partner ?? this.partner,
      codePartner: codePartner ?? this.codePartner,
    );
  }
}
