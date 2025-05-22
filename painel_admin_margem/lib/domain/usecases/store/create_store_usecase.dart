// domain/usecases/store/create_store_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/store.dart';
import '../../repositories/i_store_repository.dart';
import '../../../core/error/failures.dart';

class CreateStoreUseCase {
  final IStoreRepository repository;

  CreateStoreUseCase({required this.repository});

  Future<Either<Failure, Store>> call(Store store) async {
    return repository.createStore(store);
  }
}
