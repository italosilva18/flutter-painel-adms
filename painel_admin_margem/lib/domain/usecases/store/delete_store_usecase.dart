// domain/usecases/store/delete_store_usecase.dart
import 'package:dartz/dartz.dart';
import '../../repositories/i_store_repository.dart';
import '../../../core/error/failures.dart';

class DeleteStoreUseCase {
  final IStoreRepository repository;

  DeleteStoreUseCase({required this.repository});

  Future<Either<Failure, void>> call(String id) async {
    return repository.deleteStore(id);
  }
}
