import 'package:dartz/dartz.dart';
import '../entities/store.dart';
import '../../core/error/failures.dart';

/// Interface para o repositório de lojas
abstract class IStoreRepository {
  /// Obtém todas as lojas
  Future<Either<Failure, List<Store>>> getStores();

  /// Obtém uma loja pelo ID
  Future<Either<Failure, Store>> getStoreById(String id);

  /// Obtém uma loja pelo CNPJ
  Future<Either<Failure, Store>> getStoreByCnpj(String cnpj);

  /// Cria uma nova loja
  Future<Either<Failure, Store>> createStore(Store store);

  /// Atualiza uma loja existente
  Future<Either<Failure, Store>> updateStore(Store store);

  /// Remove uma loja
  Future<Either<Failure, void>> deleteStore(String id);

  /// Obtém todos os segmentos disponíveis
  Future<Either<Failure, List<String>>> getSegments();

  /// Obtém todos os portes de loja disponíveis
  Future<Either<Failure, List<String>>> getSizes();

  /// Obtém todos os estados disponíveis
  Future<Either<Failure, List<Map<String, dynamic>>>> getStates();

  /// Obtém todos os parceiros disponíveis
  Future<Either<Failure, List<Map<String, dynamic>>>> getPartners();
}
