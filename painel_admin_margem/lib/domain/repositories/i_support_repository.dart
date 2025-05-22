import 'package:dartz/dartz.dart';
import '../entities/support_user.dart';
import '../../core/error/failures.dart';

/// Interface para o repositório de usuários de suporte
abstract class ISupportRepository {
  /// Obtém todos os usuários de suporte
  Future<Either<Failure, List<SupportUser>>> getSupportUsers();

  /// Obtém um usuário de suporte pelo ID
  Future<Either<Failure, SupportUser>> getSupportUserById(String id);

  /// Obtém um usuário de suporte pelo e-mail
  Future<Either<Failure, SupportUser>> getSupportUserByEmail(String email);

  /// Cria um novo usuário de suporte
  Future<Either<Failure, SupportUser>> createSupportUser(SupportUser user);

  /// Atualiza um usuário de suporte existente
  Future<Either<Failure, SupportUser>> updateSupportUser(SupportUser user);

  /// Remove um usuário de suporte
  Future<Either<Failure, void>> deleteSupportUser(String id);

  /// Obtém todos os parceiros disponíveis
  Future<Either<Failure, List<Map<String, dynamic>>>> getPartners();
}
