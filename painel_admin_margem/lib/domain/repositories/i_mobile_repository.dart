import 'package:dartz/dartz.dart';
import '../entities/mobile_user.dart';
import '../entities/store.dart';
import '../../core/error/failures.dart';

/// Interface para o repositório de usuários mobile
abstract class IMobileRepository {
  /// Obtém todos os usuários mobile
  Future<Either<Failure, List<MobileUser>>> getMobileUsers();

  /// Obtém um usuário mobile pelo ID
  Future<Either<Failure, MobileUser>> getMobileUserById(String id);

  /// Obtém um usuário mobile pelo e-mail
  Future<Either<Failure, MobileUser>> getMobileUserByEmail(String email);

  /// Cria um novo usuário mobile
  Future<Either<Failure, MobileUser>> createMobileUser(MobileUser user);

  /// Atualiza um usuário mobile existente
  Future<Either<Failure, MobileUser>> updateMobileUser(MobileUser user);

  /// Remove um usuário mobile
  Future<Either<Failure, void>> deleteMobileUser(String id);

  /// Obtém as lojas vinculadas a um usuário mobile
  Future<Either<Failure, List<Store>>> getMobileUserStores(String userId);

  /// Vincula uma loja a um usuário mobile
  Future<Either<Failure, void>> linkStoreToMobileUser(
      String userId, String storeId);

  /// Remove vínculo de uma loja com um usuário mobile
  Future<Either<Failure, void>> unlinkStoreFromMobileUser(
      String userId, String storeId);
}
