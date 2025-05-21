import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../core/error/failures.dart';

/// Interface para o repositório de autenticação
abstract class IAuthRepository {
  /// Realiza o login do usuário
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Realiza o logout do usuário
  Future<Either<Failure, void>> logout();

  /// Verifica se o usuário está autenticado
  Future<Either<Failure, bool>> isAuthenticated();

  /// Obtém o usuário atual
  Future<Either<Failure, User?>> getCurrentUser();
}
