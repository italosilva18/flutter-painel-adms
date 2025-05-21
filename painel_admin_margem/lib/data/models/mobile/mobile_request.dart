import '../mobile/mobile_model.dart';

class MobileRequest {
  final String name;
  final String email;
  final String phone;
  final String? password;
  final String type;
  final String partner;
  final double codePartner;
  final bool active;
  final List<String> storeIds;

  MobileRequest({
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      if (password != null) 'password': password,
      'type': type,
      'partner': partner,
      'codePartner': codePartner,
      'active': active,
    };
  }

  factory MobileRequest.fromModel(MobileModel model) {
    return MobileRequest(
      name: model.name,
      email: model.email,
      phone: model.phone,
      password: model.password,
      type: model.type,
      partner: model.partner,
      codePartner: model.codePartner,
      active: model.active,
      storeIds: model.storeIds,
    );
  }
}
