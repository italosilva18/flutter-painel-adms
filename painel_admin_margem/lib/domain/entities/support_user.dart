import 'package:equatable/equatable.dart';

/// Entidade de usuário de suporte para o domínio
class SupportUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final String partner;
  final double codePartner;

  const SupportUser({
    required this.id,
    required this.name,
    required this.email,
    required this.partner,
    required this.codePartner,
  });

  /// Cria uma cópia do usuário de suporte com valores atualizados
  SupportUser copyWith({
    String? id,
    String? name,
    String? email,
    String? partner,
    double? codePartner,
  }) {
    return SupportUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      partner: partner ?? this.partner,
      codePartner: codePartner ?? this.codePartner,
    );
  }

  @override
  List<Object?> get props => [id, name, email, partner, codePartner];

  @override
  bool get stringify => true;
}
