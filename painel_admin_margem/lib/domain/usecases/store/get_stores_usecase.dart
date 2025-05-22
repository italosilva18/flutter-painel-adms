// domain/usecases/store/get_stores_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/store.dart';
import '../../repositories/i_store_repository.dart';
import '../../../core/error/failures.dart';

class GetStoresUseCase {
  final IStoreRepository repository;

  GetStoresUseCase({required this.repository});

  Future<Either<Failure, List<Store>>> call() async {
    return repository.getStores();
  }
}
