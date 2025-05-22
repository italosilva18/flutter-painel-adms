import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../entities/user.dart';
import '../../repositories/i_auth_repository.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/network_info.dart';

/// Caso de uso para login
class LoginUseCase {
  final IAuthRepository repository;
  final NetworkInfo networkInfo;

  // ALTERAÇÃO: Flag para ativar bypass da verificação de conectividade durante desenvolvimento
  final bool _isDevMode = true;

  LoginUseCase({
    required this.repository,
    required this.networkInfo,
  });

  /// Executa o caso de uso de login
  Future<Either<Failure, User>> call(LoginParams params) async {
    // ALTERAÇÃO: Verifica conexão com a internet apenas se não estiver em modo de desenvolvimento
    if (!_isDevMode && !await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    // Validação básica
    if (params.email.isEmpty) {
      return const Left(ValidationFailure(message: 'E-mail é obrigatório'));
    }

    if (params.password.isEmpty) {
      return const Left(ValidationFailure(message: 'Senha é obrigatória'));
    }

    // Tenta fazer login
    return repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parâmetros para o caso de uso de login
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
