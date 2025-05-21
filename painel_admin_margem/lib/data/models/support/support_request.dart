import '../support/support_model.dart';

class SupportRequest {
  final String name;
  final String email;
  final String partner;
  final double codePartner;

  SupportRequest({
    required this.name,
    required this.email,
    required this.partner,
    required this.codePartner,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'partner': partner,
      'codePartner': codePartner,
    };
  }

  factory SupportRequest.fromModel(SupportModel model) {
    return SupportRequest(
      name: model.name,
      email: model.email,
      partner: model.partner,
      codePartner: model.codePartner,
    );
  }
}
