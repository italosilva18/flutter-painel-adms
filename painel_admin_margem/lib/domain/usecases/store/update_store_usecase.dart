// domain/usecases/store/update_store_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/store.dart';
import '../../repositories/i_store_repository.dart';
import '../../../core/error/failures.dart';

class UpdateStoreUseCase {
  final IStoreRepository repository;

  UpdateStoreUseCase({required this.repository});

  Future<Either<Failure, Store>> call(Store store) async {
    return repository.updateStore(store);
  }
}
