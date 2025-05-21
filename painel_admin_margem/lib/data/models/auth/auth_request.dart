/// Classe para representar a requisição de login
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  /// Converte para um mapa de dados (JSON)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

/// Classe para representar a resposta de login
class LoginResponse {
  final String name;
  final String email;
  final String token;

  LoginResponse({
    required this.name,
    required this.email,
    required this.token,
  });

  /// Cria a partir de um mapa de dados (JSON)
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
