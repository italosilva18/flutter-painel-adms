import 'package:equatable/equatable.dart';

/// Classe base para falhas de domínio
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

/// Falha de servidor
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required String message,
    this.statusCode,
  }) : super(message: message);

  @override
  List<Object> get props => [message, statusCode ?? 0];
}

/// Falha de cache
class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

/// Falha de conexão
class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'Sem conexão com a internet'})
      : super(message: message);
}

/// Falha de autenticação
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({String message = 'Falha na autenticação'})
      : super(message: message);
}

/// Falha de validação
class ValidationFailure extends Failure {
  const ValidationFailure({required String message}) : super(message: message);
}

/// Falha de dados inválidos
class InvalidDataFailure extends Failure {
  const InvalidDataFailure({required String message}) : super(message: message);
}
