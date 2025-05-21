import 'package:equatable/equatable.dart';

/// Entidade de usuário para o domínio
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? token;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
  });

  /// Cria uma cópia do usuário com valores atualizados
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [id, name, email, token];

  @override
  bool get stringify => true;
}
