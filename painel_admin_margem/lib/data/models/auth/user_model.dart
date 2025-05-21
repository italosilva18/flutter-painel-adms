import '../../../domain/entities/user.dart';

/// Modelo de dados para o usuário
class UserModel extends User {
  const UserModel({
    required String id,
    required String name,
    required String email,
    String? token,
  }) : super(
          id: id,
          name: name,
          email: email,
          token: token,
        );

  /// Cria a partir de um mapa de dados (JSON)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'],
    );
  }

  /// Converte para um mapa de dados (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
    };
  }

  /// Cria uma cópia do modelo com valores atualizados
  UserModel copyWithModel({
    String? id,
    String? name,
    String? email,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }
}
