/// Exceção para servidor
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({this.message = 'Erro no servidor', this.statusCode});

  @override
  String toString() => message;
}

/// Exceção para falha de cache
class CacheException implements Exception {
  final String message;

  CacheException({this.message = 'Erro ao acessar cache'});

  @override
  String toString() => message;
}

/// Exceção para falha de conexão
class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'Sem conexão com a internet'});

  @override
  String toString() => message;
}

/// Exceção para falha de autenticação
class AuthenticationException implements Exception {
  final String message;

  AuthenticationException({this.message = 'Falha na autenticação'});

  @override
  String toString() => message;
}

/// Exceção para dados inválidos
class InvalidDataException implements Exception {
  final String message;

  InvalidDataException({this.message = 'Dados inválidos'});

  @override
  String toString() => message;
}
