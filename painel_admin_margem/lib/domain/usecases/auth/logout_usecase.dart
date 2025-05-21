import 'package:dartz/dartz.dart';
import '../../repositories/i_auth_repository.dart';
import '../../../core/error/failures.dart';

/// Caso de uso para logout
class LogoutUseCase {
  final IAuthRepository repository;

  LogoutUseCase({required this.repository});

  /// Executa o caso de uso de logout
  Future<Either<Failure, void>> call() async {
    return repository.logout();
  }
}
