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
    required super.message,
    this.statusCode,
  });

  @override
  List<Object> get props => [message, statusCode ?? 0];
}

/// Falha de cache
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Falha de conexão
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Sem conexão com a internet'});
}

/// Falha de autenticação
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({super.message = 'Falha na autenticação'});
}

/// Falha de validação
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// Falha de dados inválidos
class InvalidDataFailure extends Failure {
  const InvalidDataFailure({required super.message});
}
